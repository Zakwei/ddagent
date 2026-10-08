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
class TranslationsRu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$ru auth = Translations$auth$ru._(_root);
	@override late final Translations$chat$ru chat = Translations$chat$ru._(_root);
	@override late final Translations$codeEditor$ru codeEditor = Translations$codeEditor$ru._(_root);
	@override late final Translations$common$ru common = Translations$common$ru._(_root);
	@override late final Translations$settings$ru settings = Translations$settings$ru._(_root);
	@override late final Translations$sidebar$ru sidebar = Translations$sidebar$ru._(_root);
	@override late final Translations$tasks$ru tasks = Translations$tasks$ru._(_root);
	@override late final Translations$knowledge$ru knowledge = Translations$knowledge$ru._(_root);
	@override late final Translations$browser$ru browser = Translations$browser$ru._(_root);
	@override late final Translations$collab$ru collab = Translations$collab$ru._(_root);
	@override late final Translations$fileTree$ru fileTree = Translations$fileTree$ru._(_root);
	@override late final Translations$git$ru git = Translations$git$ru._(_root);
	@override late final Translations$kanban$ru kanban = Translations$kanban$ru._(_root);
	@override late final Translations$mcp$ru mcp = Translations$mcp$ru._(_root);
	@override late final Translations$notifications$ru notifications = Translations$notifications$ru._(_root);
	@override late final Translations$onboarding$ru onboarding = Translations$onboarding$ru._(_root);
	@override late final Translations$projects$ru projects = Translations$projects$ru._(_root);
	@override late final Translations$quota$ru quota = Translations$quota$ru._(_root);
	@override late final Translations$scheduler$ru scheduler = Translations$scheduler$ru._(_root);
	@override late final Translations$serverConnect$ru serverConnect = Translations$serverConnect$ru._(_root);
	@override late final Translations$sessions$ru sessions = Translations$sessions$ru._(_root);
	@override late final Translations$sharedContext$ru sharedContext = Translations$sharedContext$ru._(_root);
	@override late final Translations$skills$ru skills = Translations$skills$ru._(_root);
	@override late final Translations$terminal$ru terminal = Translations$terminal$ru._(_root);
	@override late final Translations$voice$ru voice = Translations$voice$ru._(_root);
	@override late final Translations$workspace$ru workspace = Translations$workspace$ru._(_root);
	@override late final Translations$worktrees$ru worktrees = Translations$worktrees$ru._(_root);
	@override late final Translations$browserUse$ru browserUse = Translations$browserUse$ru._(_root);
	@override late final Translations$orchestrator$ru orchestrator = Translations$orchestrator$ru._(_root);
	@override late final Translations$miniOrchestrator$ru miniOrchestrator = Translations$miniOrchestrator$ru._(_root);
}

// Path: auth
class Translations$auth$ru extends Translations$auth$en {
	Translations$auth$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'Срок действия сеанса истёк. Войдите снова.';
	@override late final Translations$auth$login$ru login = Translations$auth$login$ru._(_root);
	@override late final Translations$auth$register$ru register = Translations$auth$register$ru._(_root);
	@override late final Translations$auth$logout$ru logout = Translations$auth$logout$ru._(_root);
}

// Path: chat
class Translations$chat$ru extends Translations$chat$en {
	Translations$chat$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$ru codeBlock = Translations$chat$codeBlock$ru._(_root);
	@override late final Translations$chat$copyMessage$ru copyMessage = Translations$chat$copyMessage$ru._(_root);
	@override late final Translations$chat$messageTypes$ru messageTypes = Translations$chat$messageTypes$ru._(_root);
	@override late final Translations$chat$orchestrator$ru orchestrator = Translations$chat$orchestrator$ru._(_root);
	@override late final Translations$chat$tools$ru tools = Translations$chat$tools$ru._(_root);
	@override late final Translations$chat$search$ru search = Translations$chat$search$ru._(_root);
	@override late final Translations$chat$fileOperations$ru fileOperations = Translations$chat$fileOperations$ru._(_root);
	@override late final Translations$chat$interactive$ru interactive = Translations$chat$interactive$ru._(_root);
	@override late final Translations$chat$thinking$ru thinking = Translations$chat$thinking$ru._(_root);
	@override late final Translations$chat$json$ru json = Translations$chat$json$ru._(_root);
	@override late final Translations$chat$permissions$ru permissions = Translations$chat$permissions$ru._(_root);
	@override late final Translations$chat$todo$ru todo = Translations$chat$todo$ru._(_root);
	@override late final Translations$chat$plan$ru plan = Translations$chat$plan$ru._(_root);
	@override late final Translations$chat$usageLimit$ru usageLimit = Translations$chat$usageLimit$ru._(_root);
	@override late final Translations$chat$codex$ru codex = Translations$chat$codex$ru._(_root);
	@override late final Translations$chat$voice$ru voice = Translations$chat$voice$ru._(_root);
	@override late final Translations$chat$input$ru input = Translations$chat$input$ru._(_root);
	@override late final Translations$chat$composer$ru composer = Translations$chat$composer$ru._(_root);
	@override late final Translations$chat$providerSelection$ru providerSelection = Translations$chat$providerSelection$ru._(_root);
	@override late final Translations$chat$session$ru session = Translations$chat$session$ru._(_root);
	@override late final Translations$chat$shell$ru shell = Translations$chat$shell$ru._(_root);
	@override late final Translations$chat$claudeStatus$ru claudeStatus = Translations$chat$claudeStatus$ru._(_root);
	@override late final Translations$chat$projectSelection$ru projectSelection = Translations$chat$projectSelection$ru._(_root);
	@override late final Translations$chat$tasks$ru tasks = Translations$chat$tasks$ru._(_root);
	@override late final Translations$chat$splitSession$ru splitSession = Translations$chat$splitSession$ru._(_root);
	@override late final Translations$chat$sessionPicker$ru sessionPicker = Translations$chat$sessionPicker$ru._(_root);
	@override late final Translations$chat$splitWorkspace$ru splitWorkspace = Translations$chat$splitWorkspace$ru._(_root);
	@override late final Translations$chat$splitOverview$ru splitOverview = Translations$chat$splitOverview$ru._(_root);
	@override late final Translations$chat$askUserQuestion$ru askUserQuestion = Translations$chat$askUserQuestion$ru._(_root);
	@override late final Translations$chat$attachments$ru attachments = Translations$chat$attachments$ru._(_root);
	@override late final Translations$chat$checkpoint$ru checkpoint = Translations$chat$checkpoint$ru._(_root);
	@override late final Translations$chat$common$ru common = Translations$chat$common$ru._(_root);
	@override late final Translations$chat$taskMaster$ru taskMaster = Translations$chat$taskMaster$ru._(_root);
	@override late final Translations$chat$tokenUsage$ru tokenUsage = Translations$chat$tokenUsage$ru._(_root);
	@override late final Translations$chat$tool$ru tool = Translations$chat$tool$ru._(_root);
	@override late final Translations$chat$quotaBadge$ru quotaBadge = Translations$chat$quotaBadge$ru._(_root);
	@override late final Translations$chat$broadcast$ru broadcast = Translations$chat$broadcast$ru._(_root);
	@override late final Translations$chat$paneHeader$ru paneHeader = Translations$chat$paneHeader$ru._(_root);
	@override late final Translations$chat$export$ru export = Translations$chat$export$ru._(_root);
	@override late final Translations$chat$commandResult$ru commandResult = Translations$chat$commandResult$ru._(_root);
	@override late final Translations$chat$commands$ru commands = Translations$chat$commands$ru._(_root);
	@override late final Translations$chat$pinFile$ru pinFile = Translations$chat$pinFile$ru._(_root);
	@override late final Translations$chat$modelLibrary$ru modelLibrary = Translations$chat$modelLibrary$ru._(_root);
	@override late final Translations$chat$changes$ru changes = Translations$chat$changes$ru._(_root);
	@override late final Translations$chat$message$ru message = Translations$chat$message$ru._(_root);
	@override late final Translations$chat$permissionRequest$ru permissionRequest = Translations$chat$permissionRequest$ru._(_root);
	@override late final Translations$chat$commandDialog$ru commandDialog = Translations$chat$commandDialog$ru._(_root);
	@override late final Translations$chat$utilities$ru utilities = Translations$chat$utilities$ru._(_root);
	@override late final Translations$chat$toolBlocks$ru toolBlocks = Translations$chat$toolBlocks$ru._(_root);
	@override late final Translations$chat$commandMenu$ru commandMenu = Translations$chat$commandMenu$ru._(_root);
	@override late final Translations$chat$mentionMenu$ru mentionMenu = Translations$chat$mentionMenu$ru._(_root);
	@override late final Translations$chat$subheader$ru subheader = Translations$chat$subheader$ru._(_root);
	@override late final Translations$chat$transcript$ru transcript = Translations$chat$transcript$ru._(_root);
	@override late final Translations$chat$review$ru review = Translations$chat$review$ru._(_root);
}

// Path: codeEditor
class Translations$codeEditor$ru extends Translations$codeEditor$en {
	Translations$codeEditor$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$ru toolbar = Translations$codeEditor$toolbar$ru._(_root);
	@override String loading({required Object fileName}) => 'Загрузка ${fileName}...';
	@override late final Translations$codeEditor$header$ru header = Translations$codeEditor$header$ru._(_root);
	@override late final Translations$codeEditor$actions$ru actions = Translations$codeEditor$actions$ru._(_root);
	@override late final Translations$codeEditor$footer$ru footer = Translations$codeEditor$footer$ru._(_root);
	@override late final Translations$codeEditor$binaryFile$ru binaryFile = Translations$codeEditor$binaryFile$ru._(_root);
	@override late final Translations$codeEditor$filePreview$ru filePreview = Translations$codeEditor$filePreview$ru._(_root);
	@override String unsavedChanges({required Object name}) => 'Несохранённые изменения в ${name}';
	@override String get discardUnsavedChanges => 'Отменить несохранённые изменения?';
	@override late final Translations$codeEditor$mediaFile$ru mediaFile = Translations$codeEditor$mediaFile$ru._(_root);
	@override String get failedToLoad => 'Не удалось загрузить файл';
	@override late final Translations$codeEditor$hexDump$ru hexDump = Translations$codeEditor$hexDump$ru._(_root);
	@override late final Translations$codeEditor$settings$ru settings = Translations$codeEditor$settings$ru._(_root);
	@override late final Translations$codeEditor$diff$ru diff = Translations$codeEditor$diff$ru._(_root);
	@override late final Translations$codeEditor$emptyState$ru emptyState = Translations$codeEditor$emptyState$ru._(_root);
	@override late final Translations$codeEditor$toasts$ru toasts = Translations$codeEditor$toasts$ru._(_root);
}

// Path: common
class Translations$common$ru extends Translations$common$en {
	Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$ru buttons = Translations$common$buttons$ru._(_root);
	@override late final Translations$common$tabs$ru tabs = Translations$common$tabs$ru._(_root);
	@override late final Translations$common$quota$ru quota = Translations$common$quota$ru._(_root);
	@override late final Translations$common$status$ru status = Translations$common$status$ru._(_root);
	@override late final Translations$common$messages$ru messages = Translations$common$messages$ru._(_root);
	@override late final Translations$common$navigation$ru navigation = Translations$common$navigation$ru._(_root);
	@override late final Translations$common$common$ru common = Translations$common$common$ru._(_root);
	@override late final Translations$common$time$ru time = Translations$common$time$ru._(_root);
	@override late final Translations$common$fileOperations$ru fileOperations = Translations$common$fileOperations$ru._(_root);
	@override late final Translations$common$mainContent$ru mainContent = Translations$common$mainContent$ru._(_root);
	@override late final Translations$common$fileTree$ru fileTree = Translations$common$fileTree$ru._(_root);
	@override late final Translations$common$projectWizard$ru projectWizard = Translations$common$projectWizard$ru._(_root);
	@override late final Translations$common$notifications$ru notifications = Translations$common$notifications$ru._(_root);
	@override late final Translations$common$versionUpdate$ru versionUpdate = Translations$common$versionUpdate$ru._(_root);
	@override late final Translations$common$actions$ru actions = Translations$common$actions$ru._(_root);
	@override late final Translations$common$browserPane$ru browserPane = Translations$common$browserPane$ru._(_root);
	@override late final Translations$common$browserUse$ru browserUse = Translations$common$browserUse$ru._(_root);
	@override late final Translations$common$commandPalette$ru commandPalette = Translations$common$commandPalette$ru._(_root);
	@override late final Translations$common$gitPanel$ru gitPanel = Translations$common$gitPanel$ru._(_root);
	@override late final Translations$common$sessions$ru sessions = Translations$common$sessions$ru._(_root);
	@override late final Translations$common$projects$ru projects = Translations$common$projects$ru._(_root);
	@override late final Translations$common$sharedNotes$ru sharedNotes = Translations$common$sharedNotes$ru._(_root);
	@override late final Translations$common$codeBlock$ru codeBlock = Translations$common$codeBlock$ru._(_root);
	@override late final Translations$common$update$ru update = Translations$common$update$ru._(_root);
	@override late final Translations$common$appShell$ru appShell = Translations$common$appShell$ru._(_root);
	@override late final Translations$common$errors$ru errors = Translations$common$errors$ru._(_root);
}

// Path: settings
class Translations$settings$ru extends Translations$settings$en {
	Translations$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override late final Translations$settings$changelog$ru changelog = Translations$settings$changelog$ru._(_root);
	@override late final Translations$settings$server$ru server = Translations$settings$server$ru._(_root);
	@override late final Translations$settings$updates$ru updates = Translations$settings$updates$ru._(_root);
	@override late final Translations$settings$tabs$ru tabs = Translations$settings$tabs$ru._(_root);
	@override late final Translations$settings$account$ru account = Translations$settings$account$ru._(_root);
	@override late final Translations$settings$mcp$ru mcp = Translations$settings$mcp$ru._(_root);
	@override late final Translations$settings$appearance$ru appearance = Translations$settings$appearance$ru._(_root);
	@override late final Translations$settings$actions$ru actions = Translations$settings$actions$ru._(_root);
	@override late final Translations$settings$quickSettings$ru quickSettings = Translations$settings$quickSettings$ru._(_root);
	@override late final Translations$settings$terminalShortcuts$ru terminalShortcuts = Translations$settings$terminalShortcuts$ru._(_root);
	@override late final Translations$settings$mainTabs$ru mainTabs = Translations$settings$mainTabs$ru._(_root);
	@override late final Translations$settings$miniOrchestration$ru miniOrchestration = Translations$settings$miniOrchestration$ru._(_root);
	@override late final Translations$settings$orchestration$ru orchestration = Translations$settings$orchestration$ru._(_root);
	@override late final Translations$settings$notifications$ru notifications = Translations$settings$notifications$ru._(_root);
	@override late final Translations$settings$appearanceSettings$ru appearanceSettings = Translations$settings$appearanceSettings$ru._(_root);
	@override late final Translations$settings$mcpForm$ru mcpForm = Translations$settings$mcpForm$ru._(_root);
	@override late final Translations$settings$saveStatus$ru saveStatus = Translations$settings$saveStatus$ru._(_root);
	@override late final Translations$settings$footerActions$ru footerActions = Translations$settings$footerActions$ru._(_root);
	@override late final Translations$settings$git$ru git = Translations$settings$git$ru._(_root);
	@override late final Translations$settings$apiKeys$ru apiKeys = Translations$settings$apiKeys$ru._(_root);
	@override late final Translations$settings$tasks$ru tasks = Translations$settings$tasks$ru._(_root);
	@override late final Translations$settings$agents$ru agents = Translations$settings$agents$ru._(_root);
	@override late final Translations$settings$permissions$ru permissions = Translations$settings$permissions$ru._(_root);
	@override late final Translations$settings$mcpServers$ru mcpServers = Translations$settings$mcpServers$ru._(_root);
	@override late final Translations$settings$quota$ru quota = Translations$settings$quota$ru._(_root);
	@override late final Translations$settings$browser$ru browser = Translations$settings$browser$ru._(_root);
	@override late final Translations$settings$workspaces$ru workspaces = Translations$settings$workspaces$ru._(_root);
	@override late final Translations$settings$stt$ru stt = Translations$settings$stt$ru._(_root);
	@override late final Translations$settings$schedules$ru schedules = Translations$settings$schedules$ru._(_root);
	@override late final Translations$settings$mcpTokens$ru mcpTokens = Translations$settings$mcpTokens$ru._(_root);
	@override late final Translations$settings$about$ru about = Translations$settings$about$ru._(_root);
	@override late final Translations$settings$shortcuts$ru shortcuts = Translations$settings$shortcuts$ru._(_root);
}

// Path: sidebar
class Translations$sidebar$ru extends Translations$sidebar$en {
	Translations$sidebar$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$ru projects = Translations$sidebar$projects$ru._(_root);
	@override late final Translations$sidebar$app$ru app = Translations$sidebar$app$ru._(_root);
	@override late final Translations$sidebar$panel$ru panel = Translations$sidebar$panel$ru._(_root);
	@override late final Translations$sidebar$sessions$ru sessions = Translations$sidebar$sessions$ru._(_root);
	@override late final Translations$sidebar$tooltips$ru tooltips = Translations$sidebar$tooltips$ru._(_root);
	@override late final Translations$sidebar$navigation$ru navigation = Translations$sidebar$navigation$ru._(_root);
	@override late final Translations$sidebar$actions$ru actions = Translations$sidebar$actions$ru._(_root);
	@override late final Translations$sidebar$workspace$ru workspace = Translations$sidebar$workspace$ru._(_root);
	@override late final Translations$sidebar$branding$ru branding = Translations$sidebar$branding$ru._(_root);
	@override late final Translations$sidebar$status$ru status = Translations$sidebar$status$ru._(_root);
	@override late final Translations$sidebar$time$ru time = Translations$sidebar$time$ru._(_root);
	@override late final Translations$sidebar$messages$ru messages = Translations$sidebar$messages$ru._(_root);
	@override late final Translations$sidebar$version$ru version = Translations$sidebar$version$ru._(_root);
	@override late final Translations$sidebar$search$ru search = Translations$sidebar$search$ru._(_root);
	@override late final Translations$sidebar$recent$ru recent = Translations$sidebar$recent$ru._(_root);
	@override late final Translations$sidebar$deleteConfirmation$ru deleteConfirmation = Translations$sidebar$deleteConfirmation$ru._(_root);
	@override late final Translations$sidebar$zones$ru zones = Translations$sidebar$zones$ru._(_root);
	@override late final Translations$sidebar$tabs$ru tabs = Translations$sidebar$tabs$ru._(_root);
}

// Path: tasks
class Translations$tasks$ru extends Translations$tasks$en {
	Translations$tasks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$ru notConfigured = Translations$tasks$notConfigured$ru._(_root);
	@override late final Translations$tasks$gettingStarted$ru gettingStarted = Translations$tasks$gettingStarted$ru._(_root);
	@override late final Translations$tasks$setupModal$ru setupModal = Translations$tasks$setupModal$ru._(_root);
	@override late final Translations$tasks$helpGuide$ru helpGuide = Translations$tasks$helpGuide$ru._(_root);
	@override late final Translations$tasks$search$ru search = Translations$tasks$search$ru._(_root);
	@override late final Translations$tasks$filters$ru filters = Translations$tasks$filters$ru._(_root);
	@override late final Translations$tasks$sort$ru sort = Translations$tasks$sort$ru._(_root);
	@override late final Translations$tasks$views$ru views = Translations$tasks$views$ru._(_root);
	@override late final Translations$tasks$kanban$ru kanban = Translations$tasks$kanban$ru._(_root);
	@override late final Translations$tasks$buttons$ru buttons = Translations$tasks$buttons$ru._(_root);
	@override late final Translations$tasks$prd$ru prd = Translations$tasks$prd$ru._(_root);
	@override late final Translations$tasks$statuses$ru statuses = Translations$tasks$statuses$ru._(_root);
	@override late final Translations$tasks$priorities$ru priorities = Translations$tasks$priorities$ru._(_root);
	@override late final Translations$tasks$noMatchingTasks$ru noMatchingTasks = Translations$tasks$noMatchingTasks$ru._(_root);
	@override late final Translations$tasks$board$ru board = Translations$tasks$board$ru._(_root);
	@override late final Translations$tasks$card$ru card = Translations$tasks$card$ru._(_root);
	@override late final Translations$tasks$createTask$ru createTask = Translations$tasks$createTask$ru._(_root);
	@override late final Translations$tasks$list$ru list = Translations$tasks$list$ru._(_root);
	@override late final Translations$tasks$nextTask$ru nextTask = Translations$tasks$nextTask$ru._(_root);
	@override late final Translations$tasks$taskDetail$ru taskDetail = Translations$tasks$taskDetail$ru._(_root);
	@override late final Translations$tasks$toasts$ru toasts = Translations$tasks$toasts$ru._(_root);
	@override late final Translations$tasks$taskmaster$ru taskmaster = Translations$tasks$taskmaster$ru._(_root);
}

// Path: knowledge
class Translations$knowledge$ru extends Translations$knowledge$en {
	Translations$knowledge$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Знания';
	@override late final Translations$knowledge$tabs$ru tabs = Translations$knowledge$tabs$ru._(_root);
	@override late final Translations$knowledge$common$ru common = Translations$knowledge$common$ru._(_root);
	@override late final Translations$knowledge$actions$ru actions = Translations$knowledge$actions$ru._(_root);
	@override late final Translations$knowledge$dialog$ru dialog = Translations$knowledge$dialog$ru._(_root);
	@override late final Translations$knowledge$fields$ru fields = Translations$knowledge$fields$ru._(_root);
	@override late final Translations$knowledge$dashboard$ru dashboard = Translations$knowledge$dashboard$ru._(_root);
	@override late final Translations$knowledge$empty$ru empty = Translations$knowledge$empty$ru._(_root);
	@override late final Translations$knowledge$history$ru history = Translations$knowledge$history$ru._(_root);
	@override late final Translations$knowledge$priorities$ru priorities = Translations$knowledge$priorities$ru._(_root);
	@override late final Translations$knowledge$search$ru search = Translations$knowledge$search$ru._(_root);
	@override late final Translations$knowledge$links$ru links = Translations$knowledge$links$ru._(_root);
	@override late final Translations$knowledge$tags$ru tags = Translations$knowledge$tags$ru._(_root);
	@override late final Translations$knowledge$graph$ru graph = Translations$knowledge$graph$ru._(_root);
	@override late final Translations$knowledge$importAll$ru importAll = Translations$knowledge$importAll$ru._(_root);
	@override late final Translations$knowledge$migrate$ru migrate = Translations$knowledge$migrate$ru._(_root);
	@override late final Translations$knowledge$importSkills$ru importSkills = Translations$knowledge$importSkills$ru._(_root);
	@override late final Translations$knowledge$critical$ru critical = Translations$knowledge$critical$ru._(_root);
	@override late final Translations$knowledge$contextBudget$ru contextBudget = Translations$knowledge$contextBudget$ru._(_root);
	@override late final Translations$knowledge$linkOptions$ru linkOptions = Translations$knowledge$linkOptions$ru._(_root);
	@override late final Translations$knowledge$errors$ru errors = Translations$knowledge$errors$ru._(_root);
	@override late final Translations$knowledge$entityTypes$ru entityTypes = Translations$knowledge$entityTypes$ru._(_root);
}

// Path: browser
class Translations$browser$ru extends Translations$browser$en {
	Translations$browser$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Браузер агента';
	@override String get viewError => 'Ошибка представления браузера';
	@override String get web => 'Веб';
}

// Path: collab
class Translations$collab$ru extends Translations$collab$en {
	Translations$collab$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get team => 'Команда';
	@override String get invite => 'Пригласить';
	@override String get inviteTeammate => 'Пригласить коллегу';
	@override String get shareTokenHint => 'Поделитесь этим токеном приглашения — он показывается один раз и действует 72 ч:';
	@override String get createInvite => 'Создать приглашение';
	@override String get copyToken => 'Копировать токен';
	@override late final Translations$collab$roles$ru roles = Translations$collab$roles$ru._(_root);
	@override late final Translations$collab$viewing$ru viewing = Translations$collab$viewing$ru._(_root);
}

// Path: fileTree
class Translations$fileTree$ru extends Translations$fileTree$en {
	Translations$fileTree$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get uploadTo => 'Загрузить в';
	@override String get uploadHere => 'Загрузить сюда';
	@override String get browseServerFilesystem => 'Обзор файловой системы сервера';
	@override String get noFiles => 'Нет файлов';
	@override String get copyContents => 'Копировать содержимое';
	@override String get chooseFolder => 'Выбрать папку';
	@override late final Translations$fileTree$search$ru search = Translations$fileTree$search$ru._(_root);
	@override late final Translations$fileTree$titles$ru titles = Translations$fileTree$titles$ru._(_root);
	@override String uploadedCount({required Object count}) => 'Загружено файлов: ${count}';
	@override String get newName => 'Новое имя';
	@override String notRegisteredProject({required Object path}) => 'Проект не зарегистрирован: ${path}';
	@override String get showGitignoredFiles => 'Показать игнорируемые файлы';
	@override String get hideGitignoredFiles => 'Скрыть игнорируемые файлы';
	@override String get downloadUnsupportedOnWeb => 'Скачивание не поддерживается в веб-версии';
	@override String get saveToPath => 'Сохранить по пути';
	@override String savedTo({required Object path}) => 'Сохранено в ${path}';
	@override late final Translations$fileTree$relative$ru relative = Translations$fileTree$relative$ru._(_root);
	@override String get projectRoot => '(корень проекта)';
	@override String uploadLimitCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'За раз можно загрузить не более ${count} файла.',
		few: 'За раз можно загрузить не более ${count} файлов.',
		many: 'За раз можно загрузить не более ${count} файлов.',
		other: 'За раз можно загрузить не более ${count} файла.',
	);
	@override String fileTooLarge({required Object name}) => '${name} больше 200 МБ.';
	@override String deleteFolderConfirm({required Object path}) => 'Удалить папку «${path}»? Это действие нельзя отменить.';
	@override String deleteFileConfirm({required Object path}) => 'Удалить файл «${path}»? Это действие нельзя отменить.';
}

// Path: git
class Translations$git$ru extends Translations$git$en {
	Translations$git$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$git$checkpoints$ru checkpoints = Translations$git$checkpoints$ru._(_root);
	@override String get stagedChanges => 'Подготовленные изменения';
	@override String get statusStaged => 'Подготовлено';
	@override String get switchBranch => 'Переключить ветку';
	@override String get unifiedDiff => 'Единый';
	@override String get splitDiff => 'Рядом';
	@override String get noDiff => 'Нет доступного diff';
	@override String get largeDiff => 'Большой diff: отрисовка ограничена, чтобы вкладка оставалась отзывчивой.';
	@override String loadDiffFailed({required Object error}) => 'Не удалось загрузить diff: ${error}';
	@override String get hunkStage => '+ Фрагмент';
	@override String get hunkUnstage => '− Фрагмент';
	@override String get stageHunk => 'Подготовить фрагмент';
	@override String get unstageHunk => 'Отменить подготовку фрагмента';
	@override String get deleteFile => 'Удалить файл';
	@override String get commitMessage => 'Сообщение коммита';
	@override String get aiButton => '✦ ИИ';
	@override String get commitCreated => 'Коммит создан';
	@override String get noBranch => 'нет ветки';
	@override String get selectProject => 'Выберите проект';
	@override late final Translations$git$branchSections$ru branchSections = Translations$git$branchSections$ru._(_root);
}

// Path: kanban
class Translations$kanban$ru extends Translations$kanban$en {
	Translations$kanban$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$ru card = Translations$kanban$card$ru._(_root);
	@override late final Translations$kanban$comments$ru comments = Translations$kanban$comments$ru._(_root);
	@override late final Translations$kanban$dialog$ru dialog = Translations$kanban$dialog$ru._(_root);
	@override late final Translations$kanban$details$ru details = Translations$kanban$details$ru._(_root);
	@override late final Translations$kanban$empty$ru empty = Translations$kanban$empty$ru._(_root);
	@override String get saveFailed => 'Не удалось сохранить карточку';
	@override late final Translations$kanban$time$ru time = Translations$kanban$time$ru._(_root);
}

// Path: mcp
class Translations$mcp$ru extends Translations$mcp$en {
	Translations$mcp$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$install$ru install = Translations$mcp$install$ru._(_root);
	@override late final Translations$mcp$servers$ru servers = Translations$mcp$servers$ru._(_root);
	@override late final Translations$mcp$team$ru team = Translations$mcp$team$ru._(_root);
	@override late final Translations$mcp$tokens$ru tokens = Translations$mcp$tokens$ru._(_root);
	@override late final Translations$mcp$form$ru form = Translations$mcp$form$ru._(_root);
}

// Path: notifications
class Translations$notifications$ru extends Translations$notifications$en {
	Translations$notifications$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$ru errors = Translations$notifications$errors$ru._(_root);
	@override late final Translations$notifications$androidChannel$ru androidChannel = Translations$notifications$androidChannel$ru._(_root);
}

// Path: onboarding
class Translations$onboarding$ru extends Translations$onboarding$en {
	Translations$onboarding$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get gitHint => 'Используется для коммитов, создаваемых сессиями DDAgent.';
	@override String get completeSetup => 'Завершить настройку';
	@override late final Translations$onboarding$errors$ru errors = Translations$onboarding$errors$ru._(_root);
	@override late final Translations$onboarding$agents$ru agents = Translations$onboarding$agents$ru._(_root);
	@override late final Translations$onboarding$mcp$ru mcp = Translations$onboarding$mcp$ru._(_root);
}

// Path: projects
class Translations$projects$ru extends Translations$projects$en {
	Translations$projects$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cloneRepository => 'Клонировать репозиторий';
	@override String get repositoryCloned => 'Репозиторий клонирован';
	@override String get clone => 'Клонировать';
	@override String get cloneFinished => 'Клонирование завершено. Обновление списка проектов…';
	@override String get cloneFailed => 'Не удалось клонировать';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get destinationPath => 'Путь назначения';
	@override String get destinationPathRequired => 'Укажите путь назначения';
	@override String get repositoryUrlRequired => 'Укажите URL репозитория';
	@override String get githubTokenOptional => 'Токен GitHub (необязательно)';
	@override String get archive => 'Архивировать';
	@override String get restore => 'Восстановить';
	@override String get deletePermanently => 'Удалить навсегда';
	@override String get deleteProjectTitle => 'Удалить проект?';
	@override String deleteProjectMessage({required Object name}) => 'Безвозвратно удаляет «${name}» вместе со всеми сессиями и сохранённой историей (очистка JSONL). Действие необратимо.';
	@override String archivedSection({required Object count}) => 'Архивные (${count})';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} сессия',
		other: '${count} сессий',
	);
	@override String get newer => 'Новее';
	@override String get older => 'Старее';
	@override String get projectArchived => 'Проект архивирован';
	@override String get projectRestored => 'Проект восстановлен';
	@override String get projectRenamed => 'Проект переименован';
	@override String get projectDeleted => 'Проект удалён';
	@override String get failedToLoadTokens => 'Не удалось загрузить токены GitHub';
	@override String get displayNameOptional => 'Отображаемое имя (необязательно)';
	@override String usingStoredToken({required Object name}) => 'Используется сохранённый токен: ${name}';
	@override String get unknown => 'Неизвестно';
	@override String get project => 'Проект';
}

// Path: quota
class Translations$quota$ru extends Translations$quota$en {
	Translations$quota$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$section$ru section = Translations$quota$section$ru._(_root);
	@override late final Translations$quota$overview$ru overview = Translations$quota$overview$ru._(_root);
	@override late final Translations$quota$agents$ru agents = Translations$quota$agents$ru._(_root);
	@override late final Translations$quota$config$ru config = Translations$quota$config$ru._(_root);
	@override late final Translations$quota$chart$ru chart = Translations$quota$chart$ru._(_root);
	@override late final Translations$quota$duration$ru duration = Translations$quota$duration$ru._(_root);
}

// Path: scheduler
class Translations$scheduler$ru extends Translations$scheduler$en {
	Translations$scheduler$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newLabel => 'Новый';
	@override String get runs => 'Запуски';
	@override String get editTitle => 'Редактировать расписание';
	@override String get deleteTitle => 'Удалить расписание?';
	@override String deleteMessage({required Object id}) => 'Это удалит повторяющуюся задачу ${id}. Существующие сессии сохранятся.';
	@override String get checking => 'Проверка…';
	@override String nextIn({required Object time}) => 'через ${time}';
	@override String get worktree => 'worktree';
	@override String session({required Object id}) => 'сессия ${id}';
	@override String get cronHint => 'Cron (мин час день месяц день недели) — напр. 0 9 * * *';
	@override String get promptHint => 'Запрос для агента';
	@override late final Translations$scheduler$runStatus$ru runStatus = Translations$scheduler$runStatus$ru._(_root);
	@override late final Translations$scheduler$cronErrors$ru cronErrors = Translations$scheduler$cronErrors$ru._(_root);
}

// Path: serverConnect
class Translations$serverConnect$ru extends Translations$serverConnect$en {
	Translations$serverConnect$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Подключитесь к вашему серверу DDAgent';
	@override String get enterUrl => 'Введите URL сервера';
	@override String connectionFailed({required Object error}) => 'Не удалось подключиться (${error})';
	@override String get connect => 'Подключить';
	@override String get connecting => 'Подключение…';
	@override String get changeServer => 'Сменить сервер';
	@override late final Translations$serverConnect$local$ru local = Translations$serverConnect$local$ru._(_root);
	@override String httpStatus({required Object code}) => 'HTTP ${code}';
	@override String get networkError => 'Ошибка сети';
}

// Path: sessions
class Translations$sessions$ru extends Translations$sessions$en {
	Translations$sessions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get noSessions => 'Нет сессий';
	@override String get noRecentSessions => 'Нет недавних сессий';
	@override String get archivedSessions => 'Архивные сессии';
	@override String get rename => 'Переименовать';
	@override String get archive => 'Архивировать';
	@override String get compareWith => 'Сравнить с…';
	@override String get projectPath => 'Путь к проекту';
	@override String get newSessionProvider => 'Новая сессия — провайдер';
	@override String get autoOrchestrator => 'Авто (оркестратор)';
	@override String createFailed({required Object error}) => 'Не удалось создать сессию: ${error}';
	@override String deleteSessionMessage({required Object name}) => 'Удаляет «${name}» и её транскрипт. Действие необратимо.';
	@override late final Translations$sessions$toasts$ru toasts = Translations$sessions$toasts$ru._(_root);
	@override late final Translations$sessions$age$ru age = Translations$sessions$age$ru._(_root);
	@override late final Translations$sessions$activity$ru activity = Translations$sessions$activity$ru._(_root);
	@override String get autoMini => 'Авто (мини)';
}

// Path: sharedContext
class Translations$sharedContext$ru extends Translations$sharedContext$en {
	Translations$sharedContext$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Общие заметки';
}

// Path: skills
class Translations$skills$ru extends Translations$skills$en {
	Translations$skills$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String moveSkill({required Object name}) => 'Переместить ${name}';
	@override String deleteSkill({required Object name}) => 'Удалить ${name}';
	@override String get projectLabel => 'Проект';
	@override late final Translations$skills$addDialog$ru addDialog = Translations$skills$addDialog$ru._(_root);
	@override late final Translations$skills$moveDialog$ru moveDialog = Translations$skills$moveDialog$ru._(_root);
	@override late final Translations$skills$screen$ru screen = Translations$skills$screen$ru._(_root);
	@override late final Translations$skills$empty$ru empty = Translations$skills$empty$ru._(_root);
	@override late final Translations$skills$scopes$ru scopes = Translations$skills$scopes$ru._(_root);
	@override late final Translations$skills$errors$ru errors = Translations$skills$errors$ru._(_root);
	@override String get providerShared => 'Общие';
}

// Path: terminal
class Translations$terminal$ru extends Translations$terminal$en {
	Translations$terminal$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$tabs$ru tabs = Translations$terminal$tabs$ru._(_root);
	@override late final Translations$terminal$actions$ru actions = Translations$terminal$actions$ru._(_root);
	@override late final Translations$terminal$authUrl$ru authUrl = Translations$terminal$authUrl$ru._(_root);
	@override late final Translations$terminal$fileLink$ru fileLink = Translations$terminal$fileLink$ru._(_root);
	@override late final Translations$terminal$shortcuts$ru shortcuts = Translations$terminal$shortcuts$ru._(_root);
	@override late final Translations$terminal$paste$ru paste = Translations$terminal$paste$ru._(_root);
	@override late final Translations$terminal$errors$ru errors = Translations$terminal$errors$ru._(_root);
	@override late final Translations$terminal$loginDialog$ru loginDialog = Translations$terminal$loginDialog$ru._(_root);
	@override late final Translations$terminal$empty$ru empty = Translations$terminal$empty$ru._(_root);
	@override late final Translations$terminal$overlay$ru overlay = Translations$terminal$overlay$ru._(_root);
}

// Path: voice
class Translations$voice$ru extends Translations$voice$en {
	Translations$voice$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get preview => 'Предпросмотр';
	@override String get settingsSaved => 'Настройки голосового ввода сохранены';
	@override String get saveFailed => 'Не удалось сохранить конфигурацию STT';
	@override String get apiKeySaved => 'API-ключ (сохранён, введите, чтобы заменить)';
}

// Path: workspace
class Translations$workspace$ru extends Translations$workspace$en {
	Translations$workspace$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get exportChat => 'Экспортировать чат';
	@override String get searchTranscript => 'Поиск по транскрипту';
	@override String get previousMatch => 'Предыдущее совпадение';
	@override String get nextMatch => 'Следующее совпадение';
	@override String get closeSearch => 'Закрыть поиск';
	@override String get newChatProvider => 'Новый чат — провайдер';
	@override String get closePane => 'Закрыть панель';
	@override String get jumpToSession => 'Перейти к сессии…';
	@override String get archivedWorkspaceName => 'Архив';
	@override String sendTo({required Object count}) => 'Отправить в ${count}';
	@override String get deleteSessionNotice => 'Удаляет сессию и её транскрипт. Действие необратимо.';
	@override String accountWithLabel({required Object label}) => 'По умолчанию · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Завершите запуск перед сменой рабочей области';
	@override String get restored => 'Рабочая область восстановлена';
	@override String get maximizePane => 'Развернуть панель';
	@override String get restorePanes => 'Восстановить панели';
	@override String get reviewChangedFiles => 'Просмотреть изменённые файлы';
	@override late final Translations$workspace$paneTitle$ru paneTitle = Translations$workspace$paneTitle$ru._(_root);
	@override String get addEditorPane => 'Добавить панель редактора';
	@override String get addGitPane => 'Добавить панель Git';
	@override String get unknownProjectPath => 'Неизвестный путь проекта';
	@override String get autoMini => 'Авто (mini)';
	@override String get exportAs => 'Экспортировать как:';
	@override String get exportMarkdown => 'Markdown (.md)';
	@override String get exportHtml => 'Веб-страница (.html)';
	@override String get exportPdf => 'PDF (печать в файл)';
	@override String matchPosition({required Object current, required Object total}) => '${current} из ${total}';
	@override String get launcherDescription => 'Выберите рабочую область для этой панели или создайте новую.';
	@override String get createWorkspace => 'Создать рабочую область';
}

// Path: worktrees
class Translations$worktrees$ru extends Translations$worktrees$en {
	Translations$worktrees$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get scripts => 'Скрипты';
	@override String get emptyTitle => 'Worktree не найдены';
	@override String get emptyDescription => 'Создайте worktree, чтобы изолировать работу над функцией или запуски агентов.';
	@override String opened({required Object branch}) => 'Открыт worktree: ${branch}';
	@override String get created => 'Worktree создан';
	@override String get removed => 'Worktree удалён';
	@override String merged({required Object branch}) => 'Worktree слит в ${branch}';
	@override String get scriptsSaved => 'Конфигурация скриптов сохранена';
	@override String get setupLabel => 'Настройка: ';
	@override String get serverLabel => 'Сервер: ';
	@override String get runRunning => 'выполняется';
	@override String runRunningWithPort({required Object port}) => 'выполняется :${port}';
	@override String get runButton => 'Запустить';
	@override String get stopButton => 'Остановить';
	@override String get mainBadge => 'main';
	@override String headDetachedAt({required Object sha}) => 'HEAD откреплён на ${sha}';
	@override String get branchHint => 'Имя новой ветки (напр. feature/login)';
	@override String branchingOff({required Object branch}) => 'Ветвление от ${branch}';
	@override String mergeTitle({required Object branch}) => 'Слить ${branch}';
	@override String mergeDescription({required Object branch}) => 'Слить изменения в ${branch}.';
	@override String get squashDescription => 'Объединить все коммиты в один коммит';
	@override String get cleanupDescription => 'Удалить worktree и ветку после слияния';
	@override String removeTitle({required Object branch}) => 'Удалить worktree ${branch}?';
	@override String get removeDescription => 'Это удалит папку worktree. Связанные проекты будут заархивированы.';
	@override String dirtyWarning({required Object count}) => 'Внимание: в этом worktree есть ${count} незафиксированных изменений, которые будут потеряны.';
	@override String get forceRemoveLabel => 'Принудительно удалить (отменить изменения)';
	@override String get deleteBranchLabel => 'Также удалить ветку';
	@override String get setupHint => 'Команда настройки (напр. npm install)';
	@override String get runHint => 'Команда запуска (напр. npm run dev)';
	@override String get portHint => 'Порт запуска (необязательно, напр. 3000)';
	@override String get unknownSha => 'неизвестно';
	@override String get baseBranchFallback => 'базовая ветка';
	@override late final Translations$worktrees$runtimeStatus$ru runtimeStatus = Translations$worktrees$runtimeStatus$ru._(_root);
}

// Path: browserUse
class Translations$browserUse$ru extends Translations$browserUse$en {
	Translations$browserUse$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$browserUse$sessionStatus$ru sessionStatus = Translations$browserUse$sessionStatus$ru._(_root);
}

// Path: orchestrator
class Translations$orchestrator$ru extends Translations$orchestrator$en {
	Translations$orchestrator$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String stepFallback({required Object n}) => 'Шаг ${n}';
}

// Path: miniOrchestrator
class Translations$miniOrchestrator$ru extends Translations$miniOrchestrator$en {
	Translations$miniOrchestrator$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$miniOrchestrator$taskTypes$ru taskTypes = Translations$miniOrchestrator$taskTypes$ru._(_root);
	@override late final Translations$miniOrchestrator$roles$ru roles = Translations$miniOrchestrator$roles$ru._(_root);
}

// Path: auth.login
class Translations$auth$login$ru extends Translations$auth$login$en {
	Translations$auth$login$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Добро пожаловать';
	@override String get description => 'Войдите в свой аккаунт DDAgent';
	@override String get username => 'Имя пользователя';
	@override String get password => 'Пароль';
	@override String get submit => 'Войти';
	@override String get loading => 'Вход...';
	@override late final Translations$auth$login$errors$ru errors = Translations$auth$login$errors$ru._(_root);
	@override late final Translations$auth$login$placeholders$ru placeholders = Translations$auth$login$placeholders$ru._(_root);
}

// Path: auth.register
class Translations$auth$register$ru extends Translations$auth$register$en {
	Translations$auth$register$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Создать аккаунт';
	@override String get username => 'Имя пользователя';
	@override String get password => 'Пароль';
	@override String get confirmPassword => 'Подтвердите пароль';
	@override String get submit => 'Создать аккаунт';
	@override String get loading => 'Создание аккаунта...';
	@override late final Translations$auth$register$errors$ru errors = Translations$auth$register$errors$ru._(_root);
}

// Path: auth.logout
class Translations$auth$logout$ru extends Translations$auth$logout$en {
	Translations$auth$logout$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Выйти';
	@override String get confirm => 'Вы уверены, что хотите выйти?';
	@override String get button => 'Выйти';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$ru extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Копировать';
	@override String get copied => 'Скопировано';
	@override String get copyCode => 'Копировать код';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$ru extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Копировать сообщение';
	@override String get copied => 'Сообщение скопировано';
	@override String get failed => 'Не удалось скопировать';
	@override String get selectFormat => 'Выбрать формат копирования';
	@override String get copyAsMarkdown => 'Копировать как Markdown';
	@override String get copyAsText => 'Копировать как текст';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$ru extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get user => 'П';
	@override String get error => 'Ошибка';
	@override String get tool => 'Инструмент';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
	@override String get orchestrator => 'Авто';
}

// Path: chat.orchestrator
class Translations$chat$orchestrator$ru extends Translations$chat$orchestrator$en {
	Translations$chat$orchestrator$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$orchestrator$routing$ru routing = Translations$chat$orchestrator$routing$ru._(_root);
	@override late final Translations$chat$orchestrator$plan$ru plan = Translations$chat$orchestrator$plan$ru._(_root);
	@override late final Translations$chat$orchestrator$decision$ru decision = Translations$chat$orchestrator$decision$ru._(_root);
	@override late final Translations$chat$orchestrator$delegation$ru delegation = Translations$chat$orchestrator$delegation$ru._(_root);
	@override late final Translations$chat$orchestrator$summary$ru summary = Translations$chat$orchestrator$summary$ru._(_root);
	@override String get backToParent => 'Назад к оркестрации';
	@override late final Translations$chat$orchestrator$taskmaster$ru taskmaster = Translations$chat$orchestrator$taskmaster$ru._(_root);
	@override late final Translations$chat$orchestrator$gate$ru gate = Translations$chat$orchestrator$gate$ru._(_root);
}

// Path: chat.tools
class Translations$chat$tools$ru extends Translations$chat$tools$en {
	Translations$chat$tools$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки инструмента';
	@override String get error => 'Ошибка инструмента';
	@override String get result => 'Результат инструмента';
	@override String get viewParams => 'Просмотр входных параметров';
	@override String get viewRawParams => 'Просмотр сырых параметров';
	@override String get viewDiff => 'Просмотр различий редактирования для';
	@override String get creatingFile => 'Создание нового файла:';
	@override String get updatingTodo => 'Обновление списка задач';
	@override String get read => 'Чтение';
	@override String get readFile => 'Чтение файла';
	@override String get updateTodo => 'Обновить список задач';
	@override String get readTodo => 'Прочитать список задач';
	@override String get searchResults => 'результаты';
	@override String get todoReadLabel => 'TodoRead: чтение списка задач';
}

// Path: chat.search
class Translations$chat$search$ru extends Translations$chat$search$en {
	Translations$chat$search$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => 'Найдено ${count} ${type}';
	@override String get file => 'файл';
	@override String get files => 'файлов';
	@override String get pattern => 'шаблон:';
	@override String get kIn => 'в:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$ru extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Файл успешно обновлен';
	@override String get created => 'Файл успешно создан';
	@override String get written => 'Файл успешно записан';
	@override String get diff => 'Различия';
	@override String get newFile => 'Новый файл';
	@override String get viewContent => 'Просмотр содержимого файла';
	@override String viewFullOutput({required Object count}) => 'Просмотр полного вывода (${count} символов)';
	@override String get contentDisplayed => 'Содержимое файла отображено в представлении различий выше';
}

// Path: chat.interactive
class Translations$chat$interactive$ru extends Translations$chat$interactive$en {
	Translations$chat$interactive$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Интерактивный запрос';
	@override String get waiting => 'Ожидание вашего ответа в CLI';
	@override String get instruction => 'Пожалуйста, выберите опцию в терминале, где запущен Claude.';
	@override String selectedOption({required Object number}) => '✓ Claude выбрал опцию ${number}';
	@override String get instructionDetail => 'В CLI вы бы выбрали эту опцию интерактивно, используя клавиши со стрелками или введя номер.';
}

// Path: chat.thinking
class Translations$chat$thinking$ru extends Translations$chat$thinking$en {
	Translations$chat$thinking$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Думаю...';
	@override String get emoji => '💭 Думаю...';
	@override String get thoughtFewSeconds => 'Размышлял несколько секунд';
}

// Path: chat.json
class Translations$chat$json$ru extends Translations$chat$json$en {
	Translations$chat$json$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSON ответ';
}

// Path: chat.permissions
class Translations$chat$permissions$ru extends Translations$chat$permissions$en {
	Translations$chat$permissions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => 'Предоставить разрешение для ${tool}';
	@override String get added => 'Разрешение добавлено';
	@override String addTo({required Object entry}) => 'Добавляет ${entry} в разрешенные инструменты.';
	@override String get retry => 'Разрешение сохранено. Повторите запрос для использования инструмента.';
	@override String get error => 'Не удалось обновить разрешения. Попробуйте снова.';
	@override String get openSettings => 'Открыть настройки';
	@override String get allow => 'Разрешить';
	@override String get always => 'Всегда';
	@override String get editAndAllow => 'Изменить и разрешить';
	@override String get deny => 'Запретить';
	@override String get reject => 'Отклонить';
	@override String allowAll({required Object count}) => 'Разрешить все (${count})';
	@override String get editInput => 'Изменить ввод';
	@override String get invalidJson => 'Неверный JSON';
	@override String get allowWithChanges => 'Разрешить с изменениями';
}

// Path: chat.todo
class Translations$chat$todo$ru extends Translations$chat$todo$en {
	Translations$chat$todo$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Список задач успешно обновлен';
	@override String get current => 'Текущий список задач';
}

// Path: chat.plan
class Translations$chat$plan$ru extends Translations$chat$plan$en {
	Translations$chat$plan$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Просмотр плана реализации';
	@override String get title => 'План реализации';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$ru extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Достигнут лимит использования Claude. Ваш лимит будет сброшен в **${time} ${timezone}** - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$ru extends Translations$chat$codex$en {
	Translations$chat$codex$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Режим разрешений';
	@override late final Translations$chat$codex$modes$ru modes = Translations$chat$codex$modes$ru._(_root);
	@override late final Translations$chat$codex$descriptions$ru descriptions = Translations$chat$codex$descriptions$ru._(_root);
	@override String get technicalDetails => 'Технические детали';
}

// Path: chat.voice
class Translations$chat$voice$ru extends Translations$chat$voice$en {
	Translations$chat$voice$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Читать ответы вслух';
	@override String get autoReadOn => 'Чтение ответов вслух: вкл';
	@override String get autoReadOff => 'Чтение ответов вслух: выкл';
	@override String get autoReadVoice => 'Голос озвучки';
	@override String get autoReadVoiceAuto => 'Автоматический голос';
	@override String get autoReadPreview => 'Так будут звучать ответы.';
	@override String get speakMessage => 'Прочитать вслух';
	@override String get stopSpeaking => 'Остановить чтение';
}

// Path: chat.input
class Translations$chat$input$ru extends Translations$chat$input$en {
	Translations$chat$input$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Введите / для команд, @ для файлов, или спросите ${provider} что угодно...';
	@override String get placeholderDefault => 'Введите ваше сообщение...';
	@override String get disabled => 'Ввод отключен';
	@override String get attachFiles => 'Прикрепить файлы';
	@override String get attachFilesDesc => 'Загрузить фото, файлы или документы';
	@override String get takePhoto => 'Сделать фото';
	@override String get takePhotoDesc => 'Использовать камеру для фото';
	@override String get moreTools => 'Больше инструментов';
	@override String get commandsDesc => 'Обзор сочетаний клавиш и команд';
	@override String get clearInputDesc => 'Отменить текущий текст';
	@override String get attachImages => 'Прикрепить изображения';
	@override String get send => 'Отправить';
	@override String get stop => 'Остановить';
	@override late final Translations$chat$input$hintText$ru hintText = Translations$chat$input$hintText$ru._(_root);
	@override String get clickToChangeMode => 'Нажмите для смены режима разрешений';
	@override String get showAllCommands => 'Показать все команды';
	@override String get clearInput => 'Очистить ввод';
	@override String get scrollToBottom => 'Прокрутить вниз';
	@override String get newMessage => 'Новое сообщение';
	@override String get newMessages => 'Новые сообщения';
	@override late final Translations$chat$input$queue$ru queue = Translations$chat$input$queue$ru._(_root);
	@override String get autoContinueTasks => 'Автопродолжение';
	@override String get autoContinueTasksTooltip => 'Включите, чтобы Devin автоматически переходил к следующей задаче Task Master';
	@override late final Translations$chat$input$offlineQueue$ru offlineQueue = Translations$chat$input$offlineQueue$ru._(_root);
	@override String get voice => 'Голосовой ввод';
	@override String get voiceStart => 'Надиктовать сообщение';
	@override String get voiceStop => 'Остановить диктовку';
	@override String get pinFile => 'Закрепить файл в контексте';
	@override String get voiceSettings => 'Настройки голоса (STT)';
	@override String cameraUnavailable({required Object error}) => 'Камера недоступна: ${error}';
}

// Path: chat.composer
class Translations$chat$composer$ru extends Translations$chat$composer$en {
	Translations$chat$composer$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Инструменты и действия';
	@override String get toolsAndActionsDesc => 'Инструменты и элементы управления полем ввода';
	@override String get reasoning => 'Рассуждает';
	@override String get model => 'Модель';
	@override String get effortDefault => 'По умолчанию';
	@override String get loadingModels => 'Загрузка моделей…';
	@override String get modelMenu => 'Выбрать модель и уровень рассуждений';
	@override String permissionHeading({required Object provider}) => 'Как должны одобряться действия ${provider}?';
	@override String get favorites => 'Избранное';
	@override String get account => 'Аккаунт';
	@override String get accountMenu => 'Выбрать аккаунт';
	@override String get accountDefault => 'Аккаунт по умолчанию';
	@override String get accountAuto => 'Авто (по умолчанию)';
	@override String get accountIsDefault => 'По умолчанию';
	@override late final Translations$chat$composer$effortLevels$ru effortLevels = Translations$chat$composer$effortLevels$ru._(_root);
	@override String contextWindow({required Object size}) => 'контекст ${size}';
	@override String get accountAutoShort => 'Авто';
	@override String get uploadNoRecords => 'Загрузка не вернула ни одной записи';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$ru extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Выберите вашего AI-ассистента';
	@override String get description => 'Выберите провайдера для начала нового разговора';
	@override String get selectModel => 'Выбрать модель';
	@override String get workspace => 'Рабочая область';
	@override String get noWorkspace => 'Нет';
	@override String get clickToChangeWorkspace => 'Нажмите, чтобы сменить рабочую область';
	@override String get chooseWorkspace => 'Выберите рабочую область';
	@override String get searchWorkspaces => 'Поиск рабочих областей...';
	@override String get noWorkspacesFound => 'Рабочие области не найдены.';
	@override late final Translations$chat$providerSelection$providerInfo$ru providerInfo = Translations$chat$providerSelection$providerInfo$ru._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$ru readyPrompt = Translations$chat$providerSelection$readyPrompt$ru._(_root);
	@override String get autoGroup => 'Авто';
	@override String get autoLabel => 'Авто (оркестрация)';
	@override String get autoDescription => 'Направляет каждый шаг к лучшему доступному провайдеру и модели';
	@override String get orchestrated => 'оркестрация';
	@override String pressToSearch({required Object shortcut}) => 'Нажмите <kbd>${shortcut}</kbd>, чтобы искать сессии, файлы и коммиты';
	@override String get all => 'Все';
	@override String get free => 'Бесплатные';
	@override String get noModelsFound => 'Модели не найдены.';
	@override String get paid => 'Платные';
	@override String get searchModels => 'Поиск моделей...';
	@override String get addModel => 'Добавить модель';
	@override String get chooseModel => 'Выберите модель';
	@override String get chooseModelDescription => 'Встроенные и пользовательские модели в одном списке';
	@override String get clickToChange => 'Нажмите, чтобы сменить модель';
	@override String get favorites => 'Избранное';
	@override String get loadingModels => 'Загрузка моделей…';
	@override String get manageModels => 'Управление моделями';
	@override String get refresh => 'Обновить модели';
}

// Path: chat.session
class Translations$chat$session$ru extends Translations$chat$session$en {
	Translations$chat$session$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$ru kContinue = Translations$chat$session$kContinue$ru._(_root);
	@override late final Translations$chat$session$loading$ru loading = Translations$chat$session$loading$ru._(_root);
	@override late final Translations$chat$session$messages$ru messages = Translations$chat$session$messages$ru._(_root);
	@override String get deleteConfirm => 'Удаляет сессию и её транскрипт. Действие необратимо.';
	@override String get finishRunBeforeWorkspaceChange => 'Завершите запуск перед сменой рабочей области';
	@override String get fallbackTitle => 'Сессия';
}

// Path: chat.shell
class Translations$chat$shell$ru extends Translations$chat$shell$en {
	Translations$chat$shell$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$ru selectProject = Translations$chat$shell$selectProject$ru._(_root);
	@override late final Translations$chat$shell$status$ru status = Translations$chat$shell$status$ru._(_root);
	@override late final Translations$chat$shell$actions$ru actions = Translations$chat$shell$actions$ru._(_root);
	@override String get loading => 'Загрузка терминала...';
	@override String get connecting => 'Подключение к оболочке...';
	@override String get startSession => 'Начать новый сеанс Claude';
	@override String resumeSession({required Object displayName}) => 'Возобновить сеанс: ${displayName}...';
	@override String runCommand({required Object command, required Object projectName}) => 'Выполнить ${command} в ${projectName}';
	@override String startCli({required Object projectName}) => 'Запуск Claude CLI в ${projectName}';
	@override String get defaultCommand => 'команда';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$ru extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$ru actions = Translations$chat$claudeStatus$actions$ru._(_root);
	@override late final Translations$chat$claudeStatus$state$ru state = Translations$chat$claudeStatus$state$ru._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$ru elapsed = Translations$chat$claudeStatus$elapsed$ru._(_root);
	@override String get stop => 'Остановить';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Выполняется ${count} фоновая задача',
		few: 'Выполняются ${count} фоновые задачи',
		many: 'Выполняется ${count} фоновых задач',
		other: 'Выполняется ${count} фоновой задачи',
	);
	@override late final Translations$chat$claudeStatus$controls$ru controls = Translations$chat$claudeStatus$controls$ru._(_root);
	@override late final Translations$chat$claudeStatus$providers$ru providers = Translations$chat$claudeStatus$providers$ru._(_root);
	@override String get backgroundTasksTitle => 'Выполняется в фоне';
	@override String get backgroundTaskUnnamed => 'Задача без названия';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$ru extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'Выберите проект для начала чата с ${provider}';
}

// Path: chat.tasks
class Translations$chat$tasks$ru extends Translations$chat$tasks$en {
	Translations$chat$tasks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Начать следующую задачу';
}

// Path: chat.splitSession
class Translations$chat$splitSession$ru extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Разделить сессию';
	@override String get close => 'Закрыть разделённую сессию';
	@override String get selectSession => 'Выберите сессию для сравнения';
	@override String get noOtherSessions => 'Других сессий нет';
	@override String get newSessionOption => '+ Новая сессия в разделённом виде';
	@override String currentProjectGroup({required Object name}) => 'Текущий проект (${name})';
	@override String get otherProjectsGroup => 'Другие проекты';
	@override String get recentSessionsGroup => 'Недавние сессии';
	@override String get startNewSession => 'Начать новую сессию в разделённом виде';
	@override String get selectFromList => 'Выберите сессию из списка существующих';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$ru extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Выбрать сессию';
	@override String get searchPlaceholder => 'Поиск сессий...';
	@override String get clearSearch => 'Очистить поиск';
	@override String get newChat => '+ Новый чат';
	@override String get archivedToggle => 'Архивные';
	@override String get changeSession => 'Сменить сессию';
	@override String get archivedLoading => 'Загрузка архивных сессий...';
	@override String get archivedError => 'Не удалось загрузить архивные сессии';
	@override String get archivedEmpty => 'Нет архивных сессий';
	@override String get archivedProjectOnly => 'Рабочая область архивирована — восстановите её, чтобы увидеть сессии.';
	@override String get emptySearch => 'Нет сессий, соответствующих поиску';
	@override String get restore => 'Восстановить';
	@override String get restoreSession => 'Восстановить сессию';
	@override String get restoreProject => 'Восстановить рабочую область';
	@override String get restoreSessionFailed => 'Не удалось восстановить сессию. Попробуйте снова.';
	@override String get restoreProjectFailed => 'Не удалось восстановить рабочую область. Попробуйте снова.';
	@override String get archiveFailed => 'Не удалось архивировать сессию. Попробуйте снова.';
	@override String get deleteFailed => 'Не удалось удалить сессию. Попробуйте снова.';
	@override String get running => 'Сессия выполняется';
	@override String get unread => 'Непрочитано — завершена с новым выводом';
	@override String get account => 'Аккаунт';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$ru extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Добавить панель чата';
	@override String get addBrowser => 'Добавить панель браузера';
	@override String get addTerminal => 'Добавить панель терминала';
	@override String get addPreview => 'Добавить панель предпросмотра';
	@override String get overview => 'Показать все панели';
	@override String get exitFocusMode => 'Выйти из режима фокуса (Ctrl+Shift+F)';
	@override String get focusMode => 'Режим фокуса (Ctrl+Shift+F)';
	@override String get broadcast => 'Отправить во все сеансы';
	@override String get addNotes => 'Добавить панель общих заметок';
	@override String get browseSessions => 'Открыть список сессий';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$ru extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Обзор разделённых панелей';
	@override String count({required Object count}) => '${count} панелей';
	@override String get close => 'Закрыть обзор';
	@override String get question => 'ВОПРОС — требуется ввод';
	@override String get processing => 'ОБРАБОТКА';
	@override String get idle => 'Бездействует';
	@override String get active => 'Активна';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$ru extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} ждёт вашего ответа';
	@override String get skip => 'Пропустить';
	@override String get other => 'Другое…';
	@override String get answerHint => 'Введите ваш ответ…';
}

// Path: chat.attachments
class Translations$chat$attachments$ru extends Translations$chat$attachments$en {
	Translations$chat$attachments$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Загрузка не удалась — нажмите, чтобы повторить';
	@override String get fileAttachment => 'Вложение';
	@override String download({required Object name}) => 'Скачать ${name}';
	@override String get attachedFile => 'Прикреплённый файл';
	@override String downloaded({required Object name}) => '${name} загружен';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$ru extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Создание снимка…';
	@override String get revertChanges => 'Вернуть файлы к последнему чекпоинту';
	@override String get undo => 'Отменить чекпоинт';
	@override String get undoAiRun => 'Отменить запуск AI';
	@override String get undoing => 'Отмена…';
	@override String get undone => 'Отменено';
	@override String get beforeAiTurn => 'перед ходом ИИ';
}

// Path: chat.common
class Translations$chat$common$ru extends Translations$chat$common$en {
	Translations$chat$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get close => 'Закрыть';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$ru extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Задача';
	@override String get saved => 'Сохранено';
	@override String get saving => 'Сохранение...';
	@override String get taskShort => 'ЗАДАЧА';
	@override String get addToTask => 'Добавить в TaskMaster';
	@override String get added => 'Добавлено в TaskMaster';
	@override String get defaultTaskTitle => 'Задача из чата';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$ru extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Просмотр потребления токенов в сессии';
	@override String get title => 'Использование токенов';
	@override String get notAvailable => 'н/д';
	@override String tokensBadge({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} токен',
		few: '${count} токена',
		many: '${count} токенов',
		other: '${count} токена',
	);
}

// Path: chat.tool
class Translations$chat$tool$ru extends Translations$chat$tool$en {
	Translations$chat$tool$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(пока нет вывода — инструмент вернул пустой результат)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$ru extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Лимиты подписки';
	@override String get noData => 'Нет данных о подписке для этой модели';
	@override String get noSubscription => 'нет подписки';
	@override String windowLineReset({required Object label, required Object percent, required Object time}) => '${label}: ${percent}% · сброс ${time}';
	@override String windowRemaining({required Object percent}) => 'До сброса осталось ${percent}% окна';
}

// Path: chat.broadcast
class Translations$chat$broadcast$ru extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Отправить во все сеансы';
	@override String get noSessions => 'Нет доступных сеансов';
	@override String get placeholder => 'Сообщение для каждого выбранного сеанса…';
	@override String partial({required Object count}) => 'Сеансов, отклонивших сообщение: ${count}';
	@override String sent({required Object count}) => 'Поставлено в очередь для сеансов: ${count}';
	@override String get selectAll => 'Выбрать все';
	@override String get selectOrchestrators => 'Выбрать оркестраторы';
	@override String get orchestratorsOnly => 'Только оркестраторы';
	@override String get noOrchestrators => 'Нет доступных сессий оркестратора';
	@override String get sending => 'Отправка…';
	@override String send({required Object count}) => 'Отправить (${count})';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$ru extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Обработка…';
	@override String get switchSession => 'Сменить сессию';
}

// Path: chat.export
class Translations$chat$export$ru extends Translations$chat$export$en {
	Translations$chat$export$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Сессия ${id}';
	@override String get pdfFailed => 'Не удалось экспортировать PDF';
	@override String get transcriptDownloaded => 'Транскрипт скачан';
	@override String savedTo({required Object path}) => 'Сохранено ${path}';
}

// Path: chat.commandResult
class Translations$chat$commandResult$ru extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$ru fallback = Translations$chat$commandResult$fallback$ru._(_root);
	@override String get filterCommands => 'Фильтр команд...';
	@override String searchModels({required Object provider}) => 'Поиск моделей ${provider}...';
}

// Path: chat.commands
class Translations$chat$commands$ru extends Translations$chat$commands$en {
	Translations$chat$commands$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'Выполнить команду?';
	@override String get executionCancelled => 'Выполнение команды отменено';
	@override String get bashConfirmMessage => 'Эта команда содержит команды bash, которые будут выполнены. Продолжить?';
	@override String get proceed => 'Продолжить';
}

// Path: chat.pinFile
class Translations$chat$pinFile$ru extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Закрепить файл';
	@override String get pathHint => 'path/to/file.ext';
	@override String get action => 'Закрепить';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$ru extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String editTooltip({required Object name}) => 'Изменить ${name}';
	@override String deleteTooltip({required Object name}) => 'Удалить ${name}';
	@override String get enterNameAndId => 'Введите и имя модели, и ID модели.';
	@override String get idNoSpaces => 'ID модели не может содержать пробелы.';
	@override String get setAsDefault => 'Сделать по умолчанию';
	@override String get defaultModel => 'Модель по умолчанию';
	@override String get title => 'Библиотека моделей';
	@override String get subtitle => 'Добавьте ID моделей, которые поддерживает ваш провайдер. Встроенные модели заблокированы. Кружок отмечает модель по умолчанию.';
	@override String get yourModels => 'Ваши модели';
	@override String get yourModelsHint => 'Редактируемые, хранятся в auth.db';
	@override String get emptyTitle => 'Пока нет пользовательских моделей';
	@override String get emptyHint => 'Добавьте модель через форму — она появится во всех списках выбора моделей.';
	@override String get builtInModels => 'Встроенные модели';
	@override String get builtInModelsHint => 'Поддерживаются DDAgent, только для чтения';
	@override String get editTitle => 'Изменить пользовательскую модель';
	@override String get addTitle => 'Добавить пользовательскую модель';
	@override String idSentAsWritten({required Object provider}) => 'ID отправляется в ${provider} в точности как написан.';
	@override String get nameLabel => 'Название модели';
	@override String get nameHint => 'например, GPT-5.5 Pro';
	@override String get idLabel => 'ID модели';
	@override String get idHint => 'например, gpt-5.5-pro';
	@override String get idHelp => 'Используйте точный идентификатор, который принимает CLI провайдера. ID не может содержать пробелы.';
	@override String updatedNotice({required Object name}) => '${name} обновлена.';
	@override String addedNotice({required Object name}) => '${name} добавлена.';
	@override String deletedNotice({required Object name}) => '${name} удалена.';
	@override String get saving => 'Сохранение…';
	@override String get saveChanges => 'Сохранить изменения';
	@override String get deleteConfirm => 'Удалить эту модель из всех списков выбора?';
	@override String get customBadge => 'Свой';
}

// Path: chat.changes
class Translations$chat$changes$ru extends Translations$chat$changes$en {
	Translations$chat$changes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get failedToLoad => 'Не удалось загрузить изменения';
	@override String get empty => 'Нет изменений файлов';
}

// Path: chat.message
class Translations$chat$message$ru extends Translations$chat$message$en {
	Translations$chat$message$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Сжатая сводка';
	@override String get resendHint => 'Отправить повторно из поля ввода';
	@override String get rawView => 'Исходный вид';
	@override String get runComplete => 'Запуск завершён';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$ru extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'Запрос разрешения · ${tool}';
	@override String get question => 'Вопрос';
	@override String get subagent => 'Субагент';
	@override String get viewersCannotApprove => 'Наблюдатели не могут подтверждать';
	@override late final Translations$chat$permissionRequest$recap$ru recap = Translations$chat$permissionRequest$recap$ru._(_root);
	@override String needsApproval({required Object tool}) => '${tool} требует подтверждения';
	@override String subagentNeedsApproval({required Object tool}) => 'Субагент: ${tool} требует подтверждения';
	@override String moreQuestions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Ожидает ещё ${count} вопрос',
		few: 'Ожидают ещё ${count} вопроса',
		many: 'Ожидают ещё ${count} вопросов',
		other: 'Ожидают ещё ${count} вопроса',
	);
}

// Path: chat.commandDialog
class Translations$chat$commandDialog$ru extends Translations$chat$commandDialog$en {
	Translations$chat$commandDialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandDialog$help$ru help = Translations$chat$commandDialog$help$ru._(_root);
	@override late final Translations$chat$commandDialog$models$ru models = Translations$chat$commandDialog$models$ru._(_root);
	@override late final Translations$chat$commandDialog$cost$ru cost = Translations$chat$commandDialog$cost$ru._(_root);
	@override late final Translations$chat$commandDialog$status$ru status = Translations$chat$commandDialog$status$ru._(_root);
	@override String get defaultEyebrow => 'Команда';
	@override String get defaultTitle => 'Результат команды';
	@override String get escHint => 'Esc закрывает окно.';
	@override String get unknown => 'Неизвестно';
	@override String get noDescription => 'Описание отсутствует.';
	@override String get noCommandsMatch => 'Нет команд, соответствующих фильтру.';
	@override late final Translations$chat$commandDialog$syntax$ru syntax = Translations$chat$commandDialog$syntax$ru._(_root);
	@override String get commandFinished => 'Команда выполнена.';
}

// Path: chat.utilities
class Translations$chat$utilities$ru extends Translations$chat$utilities$en {
	Translations$chat$utilities$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get tokenUsageUnavailable => 'Данные об использовании токенов недоступны';
	@override late final Translations$chat$utilities$tooltip$ru tooltip = Translations$chat$utilities$tooltip$ru._(_root);
	@override String get used => 'Использовано';
	@override String get cacheWrite => 'Запись в кэш';
	@override String get contextLabel => 'Контекст';
	@override String get usageUnsupported => 'учёт расхода не поддерживается';
	@override String get chatTranscript => 'Стенограмма чата';
	@override String get you => 'Вы:';
	@override String get providerAutoMini => 'Авто (mini)';
}

// Path: chat.toolBlocks
class Translations$chat$toolBlocks$ru extends Translations$chat$toolBlocks$en {
	Translations$chat$toolBlocks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String moreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '… ещё ${count} строка',
		few: '… ещё ${count} строки',
		many: '… ещё ${count} строк',
		other: '… ещё ${count} строки',
	);
	@override late final Translations$chat$toolBlocks$status$ru status = Translations$chat$toolBlocks$status$ru._(_root);
	@override String get showLess => 'Свернуть';
	@override String get showMore => 'Показать больше';
	@override String showMoreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Показать ещё ${count} строку',
		few: 'Показать ещё ${count} строки',
		many: 'Показать ещё ${count} строк',
		other: 'Показать ещё ${count} строки',
	);
	@override String get tools => 'Инструменты';
	@override String get planReview => 'Проверка плана';
	@override String get planUpdate => 'Обновление плана';
	@override String get todoListUpdated => 'Список задач обновлён';
	@override String get creatingTask => 'Создание задачи';
	@override String get updatingTask => 'обновление';
	@override String get fetchingTask => 'получение';
	@override String get listingTasks => 'получение списка задач';
	@override String get search => 'Поиск';
	@override late final Translations$chat$toolBlocks$verbs$ru verbs = Translations$chat$toolBlocks$verbs$ru._(_root);
	@override String get subagent => 'Субагент';
	@override String toolCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} инструмент',
		few: '${count} инструмента',
		many: '${count} инструментов',
		other: '${count} инструмента',
	);
	@override String get result => 'результат';
	@override String plusMore({required Object count}) => '+${count} ещё';
	@override String get plan => 'План';
	@override String questionProgress({required Object current, required Object total}) => 'Вопрос ${current}/${total}';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} строка',
		few: '${count} строки',
		many: '${count} строк',
		other: '${count} строки',
	);
	@override String todoListItems({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Список задач (${count} пункт)',
		few: 'Список задач (${count} пункта)',
		many: 'Список задач (${count} пунктов)',
		other: 'Список задач (${count} пункта)',
	);
	@override String tasksCompleted({required Object done, required Object total}) => 'выполнено ${done}/${total}';
}

// Path: chat.commandMenu
class Translations$chat$commandMenu$ru extends Translations$chat$commandMenu$en {
	Translations$chat$commandMenu$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Нет доступных команд';
	@override late final Translations$chat$commandMenu$namespaces$ru namespaces = Translations$chat$commandMenu$namespaces$ru._(_root);
}

// Path: chat.mentionMenu
class Translations$chat$mentionMenu$ru extends Translations$chat$mentionMenu$en {
	Translations$chat$mentionMenu$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$mentionMenu$kinds$ru kinds = Translations$chat$mentionMenu$kinds$ru._(_root);
	@override String taskTitle({required Object id}) => 'Задача ${id}';
}

// Path: chat.subheader
class Translations$chat$subheader$ru extends Translations$chat$subheader$en {
	Translations$chat$subheader$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String contextTooltip({required Object used, required Object total, required Object percent}) => 'Контекст: ${used} / ${total} токенов · использовано ${percent}%';
}

// Path: chat.transcript
class Translations$chat$transcript$ru extends Translations$chat$transcript$en {
	Translations$chat$transcript$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get requestFailed => 'Запрос не выполнен';
}

// Path: chat.review
class Translations$chat$review$ru extends Translations$chat$review$en {
	Translations$chat$review$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get changedFiles => 'Изменённые файлы';
	@override String changedFilesCount({required Object count}) => 'Изменённые файлы (${count})';
	@override String get subagent => 'субагент';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$ru extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get changes => 'изменения';
	@override String get previousChange => 'Предыдущее изменение';
	@override String get nextChange => 'Следующее изменение';
	@override String get hideDiff => 'Скрыть подсветку различий';
	@override String get showDiff => 'Показать подсветку различий';
	@override String get settings => 'Настройки редактора';
	@override String get collapse => 'Свернуть редактор';
	@override String get expand => 'Развернуть редактор на всю ширину';
	@override String get toggleDock => 'Переключить панель файлов';
	@override String get diffMerge => 'Diff / слияние';
	@override String get previewInBrowser => 'Предпросмотр в браузере';
	@override String get reload => 'Перезагрузить с диска';
}

// Path: codeEditor.header
class Translations$codeEditor$header$ru extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Показаны изменения';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$ru extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Копировать путь к файлу';
	@override String get pathCopied => 'Путь к файлу скопирован';
	@override String get download => 'Скачать файл';
	@override String get save => 'Сохранить';
	@override String get saving => 'Сохранение...';
	@override String get saved => 'Сохранено!';
	@override String get exitFullscreen => 'Выйти из полноэкранного режима';
	@override String get fullscreen => 'Полноэкранный режим';
	@override String get close => 'Закрыть';
	@override String get previewMarkdown => 'Предпросмотр markdown';
	@override String get editMarkdown => 'Редактировать markdown';
	@override String get pinFile => 'Закрепить файл в контексте';
	@override String get unpinFile => 'Открепить файл от контекста';
	@override String get previewHtml => 'Открыть HTML-предпросмотр в новой вкладке';
	@override String get retry => 'Повторить';
	@override String get saveAll => 'Сохранить все';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$ru extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Строк:';
	@override String get characters => 'Символов:';
	@override String get shortcuts => 'Нажмите Ctrl+S для сохранения • Esc для закрытия';
	@override String get plainText => 'обычный текст';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} строка',
		few: '${count} строки',
		many: '${count} строк',
		other: '${count} строки',
	);
	@override String get modified => 'изменён';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$ru extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Бинарный файл';
	@override String message({required Object fileName}) => 'Файл "${fileName}" не может быть отображен в текстовом редакторе, так как это бинарный файл.';
	@override String get cannotDisplayAsText => 'Невозможно отобразить как текст';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$ru extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка предпросмотра...';
	@override String get error => 'Не удалось отобразить этот файл.';
	@override String get openInNewTab => 'Открыть в новой вкладке';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$ru extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Медиафайл';
	@override String get subtitle => 'Предпросмотр аудио и видео пока не поддерживается';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$ru extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… ещё ${size}';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$ru extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get minimap => 'Миникарта';
	@override String tabSize({required Object size}) => 'Размер табуляции: ${size}';
	@override String fontSizeDecrease({required Object size}) => 'Размер шрифта −  (сейчас ${size})';
	@override String get fontSizeIncrease => 'Размер шрифта +';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$ru extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get noChanges => 'Нет изменений';
	@override String hunk({required Object number}) => 'Фрагмент ${number}';
	@override String get close => 'Закрыть diff';
	@override String get base => 'Базовый';
	@override String get current => 'Текущий';
	@override String get applyMerge => 'Применить слияние';
	@override String get deletedOnDisk => 'удалён с диска';
	@override String get untrackedWillBeDeleted => 'Этот неотслеживаемый файл будет удалён.';
	@override String restoreConfirm({required Object name}) => 'Восстановить ${name} до закоммиченного состояния?';
	@override String get headVsWorkingCopy => 'HEAD и рабочая копия';
	@override String get savedVsBuffer => 'Последнее сохранение и буфер (без git)';
	@override String unchangedLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} неизменённая строка',
		few: '${count} неизменённые строки',
		many: '${count} неизменённых строк',
		other: '${count} неизменённой строки',
	);
	@override String get revertToSaved => 'Вернуть сохранённую версию';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$ru extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Файл не открыт';
	@override String get hint => 'Откройте файлы на вкладке «Файлы»';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$ru extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => 'Сохранено ${name}';
	@override String get saveFailed => 'Не удалось сохранить';
	@override String get allSaved => 'Всё сохранено';
	@override String get someSavesFailed => 'Некоторые сохранения не удались';
	@override String savedTo({required Object path}) => 'Сохранено в ${path}';
	@override String get mergeApplied => 'Слияние применено — сохраните, чтобы зафиксировать';
}

// Path: common.buttons
class Translations$common$buttons$ru extends Translations$common$buttons$en {
	Translations$common$buttons$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get save => 'Сохранить';
	@override String get cancel => 'Отмена';
	@override String get delete => 'Удалить';
	@override String get create => 'Создать';
	@override String get edit => 'Редактировать';
	@override String get close => 'Закрыть';
	@override String get confirm => 'Подтвердить';
	@override String get submit => 'Отправить';
	@override String get retry => 'Повторить';
	@override String get refresh => 'Обновить';
	@override String get search => 'Поиск';
	@override String get clear => 'Очистить';
	@override String get copy => 'Копировать';
	@override String get download => 'Скачать';
	@override String get upload => 'Загрузить';
	@override String get browse => 'Обзор';
	@override String get update => 'Обновить';
	@override String get openDiagram => 'Открыть диаграмму';
}

// Path: common.tabs
class Translations$common$tabs$ru extends Translations$common$tabs$en {
	Translations$common$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Чат';
	@override String get shell => 'Терминал';
	@override String get files => 'Файлы';
	@override String get git => 'Система контроля версий';
	@override String get tasks => 'Задачи';
	@override String get board => 'Доска';
	@override String get browser => 'Браузер';
	@override String get computer => 'Компьютер';
	@override String get usage => 'AI Control';
}

// Path: common.quota
class Translations$common$quota$ru extends Translations$common$quota$en {
	Translations$common$quota$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'Центр управления AI';
	@override late final Translations$common$quota$section$ru section = Translations$common$quota$section$ru._(_root);
	@override late final Translations$common$quota$filter$ru filter = Translations$common$quota$filter$ru._(_root);
	@override late final Translations$common$quota$period$ru period = Translations$common$quota$period$ru._(_root);
	@override late final Translations$common$quota$group$ru group = Translations$common$quota$group$ru._(_root);
	@override late final Translations$common$quota$metric$ru metric = Translations$common$quota$metric$ru._(_root);
	@override late final Translations$common$quota$cost$ru cost = Translations$common$quota$cost$ru._(_root);
	@override late final Translations$common$quota$cost3$ru cost3 = Translations$common$quota$cost3$ru._(_root);
	@override late final Translations$common$quota$overview$ru overview = Translations$common$quota$overview$ru._(_root);
	@override late final Translations$common$quota$usage$ru usage = Translations$common$quota$usage$ru._(_root);
	@override late final Translations$common$quota$agents$ru agents = Translations$common$quota$agents$ru._(_root);
	@override late final Translations$common$quota$agentStatus$ru agentStatus = Translations$common$quota$agentStatus$ru._(_root);
	@override late final Translations$common$quota$alert$ru alert = Translations$common$quota$alert$ru._(_root);
	@override String get backToChat => 'Назад к чату';
	@override String get syncNow => 'Синхронизировать';
	@override String generatedAt({required Object value}) => 'Обновлено ${value}';
	@override String get loading => 'Загрузка лимитов аккаунтов…';
	@override String remaining({required Object value}) => 'осталось ${value}%';
	@override String resetsIn({required Object value}) => 'сброс через ${value}';
	@override String projected({required Object value}) => 'при текущем темпе этот лимит исчерпается через ${value}';
	@override String syncedAgo({required Object value}) => 'синхронизировано ${value} назад';
	@override String get refreshAccount => 'Обновить аккаунт';
	@override String get syncFailed => 'Сбой синхронизации';
	@override String get history => 'История';
	@override String historyPoints({required Object value}) => 'Записано ${value} показаний';
	@override String get historyEmpty => 'История пока не записана';
	@override String get noAgents => 'Нет назначенных агентов';
	@override String get noSubscription => 'Нет подписки';
	@override String get noSubscriptionHint => 'Провайдер не сообщает об активном плане для этого аккаунта.';
	@override late final Translations$common$quota$quality$ru quality = Translations$common$quota$quality$ru._(_root);
	@override late final Translations$common$quota$kpi$ru kpi = Translations$common$quota$kpi$ru._(_root);
	@override late final Translations$common$quota$empty$ru empty = Translations$common$quota$empty$ru._(_root);
	@override late final Translations$common$quota$settings$ru settings = Translations$common$quota$settings$ru._(_root);
	@override late final Translations$common$quota$range$ru range = Translations$common$quota$range$ru._(_root);
}

// Path: common.status
class Translations$common$status$ru extends Translations$common$status$en {
	Translations$common$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка...';
	@override String get success => 'Успешно';
	@override String get error => 'Ошибка';
	@override String get failed => 'Не удалось';
	@override String get pending => 'Ожидание';
	@override String get completed => 'Завершено';
	@override String get inProgress => 'В процессе';
}

// Path: common.messages
class Translations$common$messages$ru extends Translations$common$messages$en {
	Translations$common$messages$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Успешно сохранено';
	@override String get deletedSuccessfully => 'Успешно удалено';
	@override String get updatedSuccessfully => 'Успешно обновлено';
	@override String get operationFailed => 'Операция не удалась';
	@override String get networkError => 'Ошибка сети. Проверьте подключение.';
	@override String get unauthorized => 'Не авторизован. Пожалуйста, войдите.';
	@override String get notFound => 'Не найдено';
	@override String get invalidInput => 'Неверный ввод';
	@override String get requiredField => 'Это поле обязательно';
	@override String get unknownError => 'Произошла неизвестная ошибка';
	@override String get renameSessionFailed => 'Не удалось переименовать сессию. Повторите попытку.';
}

// Path: common.navigation
class Translations$common$navigation$ru extends Translations$common$navigation$en {
	Translations$common$navigation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки';
	@override String get home => 'Главная';
	@override String get back => 'Назад';
	@override String get next => 'Далее';
	@override String get previous => 'Предыдущий';
	@override String get logout => 'Выйти';
	@override String get backToChat => 'Назад к чату';
}

// Path: common.common
class Translations$common$common$ru extends Translations$common$common$en {
	Translations$common$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get language => 'Язык';
	@override String get theme => 'Тема';
	@override String get darkMode => 'Темная тема';
	@override String get lightMode => 'Светлая тема';
	@override String get name => 'Имя';
	@override String get description => 'Описание';
	@override String get enabled => 'Включено';
	@override String get disabled => 'Отключено';
	@override String get optional => 'Необязательно';
	@override String get version => 'Версия';
	@override String get select => 'Выбрать';
	@override String get selectAll => 'Выбрать все';
	@override String get deselectAll => 'Снять выделение';
	@override String get done => 'Готово';
	@override String get failed => 'Не удалось';
}

// Path: common.time
class Translations$common$time$ru extends Translations$common$time$en {
	Translations$common$time$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Только что';
	@override String minutesAgo({required Object count}) => '${count} мин. назад';
	@override String hoursAgo({required Object count}) => '${count} ч. назад';
	@override String daysAgo({required Object count}) => '${count} дн. назад';
	@override String get yesterday => 'Вчера';
}

// Path: common.fileOperations
class Translations$common$fileOperations$ru extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Новый файл';
	@override String get newFolder => 'Новая папка';
	@override String get rename => 'Переименовать';
	@override String get move => 'Переместить';
	@override String get copyPath => 'Копировать путь';
	@override String get openInEditor => 'Открыть в редакторе';
}

// Path: common.mainContent
class Translations$common$mainContent$ru extends Translations$common$mainContent$en {
	Translations$common$mainContent$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка DDAgent';
	@override String get settingUpWorkspace => 'Настройка рабочего пространства...';
	@override String get chooseProject => 'Выберите проект';
	@override String get selectProjectDescription => 'Выберите проект на боковой панели, чтобы начать работу с Claude. Каждый проект содержит ваши сеансы чата и историю файлов.';
	@override String get tip => 'Совет';
	@override String get createProjectMobile => 'Нажмите кнопку меню выше для доступа к проектам';
	@override String get createProjectDesktop => 'Создайте новый проект, нажав на значок папки на боковой панели';
	@override String get newSession => 'Новый сеанс';
	@override String get untitledSession => 'Безымянный сеанс';
	@override String get projectFiles => 'Файлы проекта';
	@override String get focusMode => 'Режим фокуса (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Выйти из режима фокуса (Ctrl+Shift+F)';
	@override String get splitSession => 'Разделить сессию';
	@override String get closeSplitSession => 'Закрыть разделённую сессию';
	@override String get chooseWorkspace => 'Выберите рабочую область';
	@override String get chooseWorkspaceDescription => 'Выберите рабочую область для этого чата или создайте новую в Настройках.';
	@override String get createWorkspace => 'Создать рабочую область в Настройках';
	@override String get recentProjects => 'Недавние проекты';
}

// Path: common.fileTree
class Translations$common$fileTree$ru extends Translations$common$fileTree$en {
	Translations$common$fileTree$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка файлов...';
	@override String get files => 'Файлы';
	@override String get simpleView => 'Простой вид';
	@override String get compactView => 'Компактный вид';
	@override String get detailedView => 'Подробный вид';
	@override String get searchPlaceholder => 'Поиск файлов и папок...';
	@override String get searchContentPlaceholder => 'Поиск в файлах...';
	@override String get searchInFiles => 'Поиск в файлах';
	@override String get searchByName => 'Поиск по имени';
	@override String get clearSearch => 'Очистить поиск';
	@override String get name => 'Имя';
	@override String get size => 'Размер';
	@override String get modified => 'Изменено';
	@override String get permissions => 'Права доступа';
	@override String get noFilesFound => 'Файлы не найдены';
	@override String get checkProjectPath => 'Проверьте доступность пути к проекту';
	@override String get loadFailed => 'Не удалось загрузить файлы';
	@override String get noMatchesFound => 'Совпадений не найдено';
	@override String get noSearchResults => 'Совпадений не найдено';
	@override String get tryDifferentSearch => 'Попробуйте другой поисковый запрос или очистите поиск';
	@override String get searchError => 'Ошибка поиска';
	@override String get searching => 'Поиск...';
	@override String resultsTruncated({required Object count}) => 'Показаны первые ${count} результатов';
	@override String get justNow => 'только что';
	@override String minAgo({required Object count}) => '${count} мин. назад';
	@override String hoursAgo({required Object count}) => '${count} ч. назад';
	@override String daysAgo({required Object count}) => '${count} дн. назад';
	@override String get newFile => 'Новый файл (Cmd+N)';
	@override String get newFolder => 'Новая папка (Cmd+Shift+N)';
	@override String get refresh => 'Обновить';
	@override String get collapseAll => 'Свернуть все';
	@override late final Translations$common$fileTree$context$ru context = Translations$common$fileTree$context$ru._(_root);
	@override String get allWorkspaces => 'Все рабочие области';
	@override late final Translations$common$fileTree$delete$ru delete = Translations$common$fileTree$delete$ru._(_root);
	@override String get dropToUpload => 'Перетащите файлы для загрузки';
	@override String dropToUploadTo({required Object folder}) => 'Перетащите файлы для загрузки в «${folder}»';
	@override String get noProject => 'Сначала добавьте проект';
	@override String get noRecentFiles => 'Нет файлов, изменённых за последние 7 дней';
	@override String get showAllFiles => 'Показать все файлы';
	@override String get showAllFilesHint => 'Отключите фильтр недавних, чтобы увидеть всё.';
	@override String get showRecentOnly => 'Показать файлы, изменённые за последние 7 дней';
	@override late final Translations$common$fileTree$toast$ru toast = Translations$common$fileTree$toast$ru._(_root);
	@override String get uploadComplete => 'Загрузка завершена';
	@override String get uploadFailed => 'Загрузка не удалась';
	@override String uploadFiles({required Object size}) => 'Загрузить файлы (макс. ${size} каждый)';
	@override String uploadToFolder({required Object folder}) => 'Загрузить файлы в «${folder}»';
	@override String uploadedCount({required Object uploaded, required Object total, required Object label}) => 'Загружено ${uploaded} из ${total} ${label}';
	@override String get uploadingFiles => 'Загрузка файлов';
	@override late final Translations$common$fileTree$validation$ru validation = Translations$common$fileTree$validation$ru._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$ru extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Создать новый проект';
	@override late final Translations$common$projectWizard$steps$ru steps = Translations$common$projectWizard$steps$ru._(_root);
	@override late final Translations$common$projectWizard$step1$ru step1 = Translations$common$projectWizard$step1$ru._(_root);
	@override late final Translations$common$projectWizard$step2$ru step2 = Translations$common$projectWizard$step2$ru._(_root);
	@override late final Translations$common$projectWizard$step3$ru step3 = Translations$common$projectWizard$step3$ru._(_root);
	@override late final Translations$common$projectWizard$buttons$ru buttons = Translations$common$projectWizard$buttons$ru._(_root);
	@override late final Translations$common$projectWizard$errors$ru errors = Translations$common$projectWizard$errors$ru._(_root);
}

// Path: common.notifications
class Translations$common$notifications$ru extends Translations$common$notifications$en {
	Translations$common$notifications$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'инструмент';
	@override late final Translations$common$notifications$codes$ru codes = Translations$common$notifications$codes$ru._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$ru extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Доступно обновление';
	@override String get newVersionReady => 'Новая версия готова';
	@override String get currentVersion => 'Текущая версия';
	@override String get latestVersion => 'Последняя версия';
	@override String get whatsNew => 'Что нового:';
	@override String get viewFullRelease => 'Посмотреть полный релиз';
	@override String get updateProgress => 'Прогресс обновления:';
	@override String get manualUpgrade => 'Ручное обновление:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'Или нажмите "Обновить сейчас" для автоматического обновления.';
	@override String get updateCompleted => 'Обновление успешно завершено!';
	@override String get restartServer => 'Пожалуйста, перезапустите сервер для применения изменений.';
	@override String get updateFailed => 'Обновление не удалось';
	@override late final Translations$common$versionUpdate$buttons$ru buttons = Translations$common$versionUpdate$buttons$ru._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$ru ariaLabels = Translations$common$versionUpdate$ariaLabels$ru._(_root);
}

// Path: common.actions
class Translations$common$actions$ru extends Translations$common$actions$en {
	Translations$common$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get retry => 'Повторить';
	@override String get save => 'Сохранить';
}

// Path: common.browserPane
class Translations$common$browserPane$ru extends Translations$common$browserPane$en {
	Translations$common$browserPane$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get address => 'Адрес';
	@override String get back => 'Назад';
	@override String get connecting => 'Подключение к браузеру…';
	@override String get connectionFailed => 'Не удалось подключиться к браузеру.';
	@override String couldNotLoad({required Object url}) => 'Не удалось загрузить ${url}';
	@override String get disconnected => 'Представление браузера отключено';
	@override String get enterUrl => 'Введите URL';
	@override String get forward => 'Вперёд';
	@override String get invalidUrl => 'Введите корректный http(s) URL';
	@override String get noAuthToken => 'Нет доступного токена аутентификации.';
	@override String get openExternal => 'Открыть в системном браузере';
	@override String get reload => 'Обновить';
	@override String get retry => 'Повторить';
	@override String get stop => 'Остановить';
}

// Path: common.browserUse
class Translations$common$browserUse$ru extends Translations$common$browserUse$en {
	Translations$common$browserUse$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} активных';
	@override String get cancel => 'Отмена';
	@override String get close => 'Закрыть';
	@override String get delete => 'Удалить';
	@override String deleteDesc({required Object name}) => '${name} будет удалена безвозвратно.';
	@override String get deleteSession => 'Удалить сессию';
	@override String get deleteTitle => 'Удалить сессию браузера?';
	@override late final Translations$common$browserUse$empty$ru empty = Translations$common$browserUse$empty$ru._(_root);
	@override String get emptyStatus => 'пусто';
	@override late final Translations$common$browserUse$errors$ru errors = Translations$common$browserUse$errors$ru._(_root);
	@override String get fullscreen => 'Полный экран';
	@override String get installRuntime => 'Установить среду выполнения';
	@override String get installing => 'Установка...';
	@override String get lastAction => 'Последнее действие';
	@override String get nextSnapshot => 'Следующий снимок браузера агента появится здесь.';
	@override String get noPageLoaded => 'Страница не загружена';
	@override String get noSessions => 'Нет сессий браузера агентов.';
	@override String get none => 'Нет';
	@override String get openSettings => 'Открыть настройки Browser';
	@override String get profile => 'Профиль';
	@override String get promptLabel => 'Промпт';
	@override late final Translations$common$browserUse$prompts$ru prompts = Translations$common$browserUse$prompts$ru._(_root);
	@override String get refresh => 'Обновить сессии браузера';
	@override late final Translations$common$browserUse$relative$ru relative = Translations$common$browserUse$relative$ru._(_root);
	@override late final Translations$common$browserUse$runtime$ru runtime = Translations$common$browserUse$runtime$ru._(_root);
	@override String get runtimeSetup => 'Требуется настройка среды выполнения';
	@override String get selected => 'Выбрана';
	@override String get sessionFallback => 'Сессия браузера';
	@override String get sessionScreenshot => 'Снимок экрана сессии браузера';
	@override String get sessions => 'Сессии';
	@override String get status => 'Статус';
	@override String get stop => 'Остановить';
	@override String get stopSession => 'Остановить сессию';
	@override String get subtitle => 'Наблюдайте за сессиями браузера, открытыми ИИ-агентами.';
	@override String get temporary => 'Временный';
	@override String get thisSession => 'Эта сессия';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => 'всего ${count}';
	@override String updated({required Object time}) => 'Обновлено ${time}';
	@override String get waiting => 'Ожидание';
	@override String get waitingForScreenshot => 'Ожидание снимка экрана';
}

// Path: common.commandPalette
class Translations$common$commandPalette$ru extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Назад ко всем';
	@override String get backspaceHint => 'Backspace для возврата';
	@override late final Translations$common$commandPalette$browseAll$ru browseAll = Translations$common$commandPalette$browseAll$ru._(_root);
	@override late final Translations$common$commandPalette$compare$ru compare = Translations$common$commandPalette$compare$ru._(_root);
	@override late final Translations$common$commandPalette$groups$ru groups = Translations$common$commandPalette$groups$ru._(_root);
	@override late final Translations$common$commandPalette$hints$ru hints = Translations$common$commandPalette$hints$ru._(_root);
	@override late final Translations$common$commandPalette$items$ru items = Translations$common$commandPalette$items$ru._(_root);
	@override late final Translations$common$commandPalette$nav$ru nav = Translations$common$commandPalette$nav$ru._(_root);
	@override String get noResults => 'Нет результатов.';
	@override late final Translations$common$commandPalette$pages$ru pages = Translations$common$commandPalette$pages$ru._(_root);
	@override String get placeholder => 'Введите для поиска…';
	@override String searchPagePlaceholder({required Object page}) => 'Поиск: ${page}…';
	@override String get title => 'Палитра команд';
}

// Path: common.gitPanel
class Translations$common$gitPanel$ru extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => 'на ${count} впереди';
	@override String get aheadLabel => 'впереди';
	@override String get aiSuggest => 'Предложение ИИ';
	@override String get aiSuggestTitle => 'Сгенерировать сообщение коммита с помощью ИИ';
	@override String get all => 'Все';
	@override String get allStaged => 'Все изменения подготовлены';
	@override String behind({required Object count}) => 'на ${count} позади';
	@override String get behindLabel => 'позади';
	@override late final Translations$common$gitPanel$branches$ru branches = Translations$common$gitPanel$branches$ru._(_root);
	@override String get cancel => 'Отмена';
	@override String changesCount({required Object count}) => 'Изменения (${count})';
	@override String get clearSearch => 'Очистить поиск';
	@override String get collapseDiff => 'Свернуть diff';
	@override String get commit => 'Коммит';
	@override String get commitChanges => 'Зафиксировать изменения';
	@override String commitFiles({required Object count}) => 'Зафиксировать ${count} файл(ов)';
	@override String get committing => 'Фиксация...';
	@override late final Translations$common$gitPanel$confirmActions$ru confirmActions = Translations$common$gitPanel$confirmActions$ru._(_root);
	@override String confirmCommit({required Object count, required Object message}) => 'Зафиксировать ${count} файл(ов) с сообщением: «${message}»?';
	@override String confirmDeleteFile({required Object file}) => 'Удалить неотслеживаемый файл «${file}»? Действие необратимо.';
	@override String confirmDiscardFile({required Object file}) => 'Отменить все изменения в «${file}»? Действие необратимо.';
	@override String confirmPublish({required Object branch, required Object remote}) => 'Опубликовать ветку «${branch}» в ${remote}?';
	@override String confirmPull({required Object count, required Object remote}) => 'Получить ${count} коммит(ов) из ${remote}?';
	@override String confirmPush({required Object count, required Object remote}) => 'Отправить ${count} коммит(ов) в ${remote}?';
	@override String get confirmRevert => 'Отменить последний локальный коммит? Коммит будет удалён, но его изменения останутся подготовленными.';
	@override late final Translations$common$gitPanel$confirmTitles$ru confirmTitles = Translations$common$gitPanel$confirmTitles$ru._(_root);
	@override String get createBranch => 'Создать новую ветку';
	@override String get creating => 'Создание...';
	@override String get delete => 'Удалить';
	@override String get deleteUntracked => 'Удалить неотслеживаемый файл';
	@override String get deselectAll => 'Снять выделение';
	@override String get discard => 'Отменить';
	@override String get discardChanges => 'Отменить изменения';
	@override String get dismiss => 'Закрыть';
	@override String get dismissError => 'Закрыть ошибку';
	@override late final Translations$common$gitPanel$errors$ru errors = Translations$common$gitPanel$errors$ru._(_root);
	@override String get expandDiff => 'Развернуть diff';
	@override String get fetch => 'Получить';
	@override String fetchTitle({required Object remote}) => 'Fetch из ${remote}';
	@override String get fetching => 'Получение…';
	@override String filesSelected({required Object count}) => 'Выбрано файл(ов): ${count}';
	@override String get generating => 'Генерация...';
	@override late final Translations$common$gitPanel$history$ru history = Translations$common$gitPanel$history$ru._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$ru mergeWorktree = Translations$common$gitPanel$mergeWorktree$ru._(_root);
	@override String get merging => 'Слияние...';
	@override String get messagePlaceholder => 'Сообщение (Ctrl+Enter для фиксации)';
	@override late final Translations$common$gitPanel$newBranch$ru newBranch = Translations$common$gitPanel$newBranch$ru._(_root);
	@override late final Translations$common$gitPanel$newWorktree$ru newWorktree = Translations$common$gitPanel$newWorktree$ru._(_root);
	@override String get noChanges => 'Изменений не обнаружено';
	@override String get noChangesToCommit => 'Нет изменений для фиксации';
	@override late final Translations$common$gitPanel$noCommits$ru noCommits = Translations$common$gitPanel$noCommits$ru._(_root);
	@override String get noMatchingBranches => 'Нет подходящих веток';
	@override late final Translations$common$gitPanel$noRepo$ru noRepo = Translations$common$gitPanel$noRepo$ru._(_root);
	@override String get noStagedFiles => 'Нет подготовленных файлов';
	@override String get none => 'Нет';
	@override String nothingToPush({required Object remote}) => 'Нечего отправлять в ${remote}';
	@override String get openFile => 'Нажмите, чтобы открыть файл';
	@override String get publish => 'Опубликовать';
	@override String publishTitle({required Object branch, required Object remote}) => 'Опубликовать «${branch}» в ${remote}';
	@override String get publishing => 'Публикация…';
	@override String get pull => 'Вытянуть';
	@override String pullCount({required Object count}) => 'Вытянуть ${count}';
	@override String pullTitle({required Object count, required Object remote}) => 'Получить ${count} из ${remote}';
	@override String get pulling => 'Получение…';
	@override String get push => 'Отправить';
	@override String pushCount({required Object count}) => 'Отправить ${count}';
	@override String pushTitle({required Object count, required Object remote}) => 'Отправить ${count} в ${remote}';
	@override String get pushing => 'Отправка…';
	@override String get recentCommits => 'Последние коммиты';
	@override String get refresh => 'Обновить статус git';
	@override String get remove => 'Удалить';
	@override late final Translations$common$gitPanel$removeWorktree$ru removeWorktree = Translations$common$gitPanel$removeWorktree$ru._(_root);
	@override String get removing => 'Удаление...';
	@override String get revertLatest => 'Отменить последний локальный коммит';
	@override String get scroll => 'Прокрутка';
	@override String get searchBranches => 'Поиск веток...';
	@override String get selectAll => 'Выбрать все';
	@override String get selectProject => 'Выберите проект для просмотра контроля версий';
	@override String selectedOf({required Object selected, required Object total}) => 'Выбрано ${selected} из ${total} файлов';
	@override String selectedOfMobile({required Object selected, required Object total}) => 'Выбрано ${selected} из ${total}';
	@override String get sideBySide => 'Рядом';
	@override String get stageAll => 'Подготовить все';
	@override String get stageHunk => 'Подготовить этот фрагмент';
	@override String staged({required Object count}) => 'Подготовлено (${count})';
	@override late final Translations$common$gitPanel$status$ru status = Translations$common$gitPanel$status$ru._(_root);
	@override String get statusGuide => 'Справка по статусам файлов';
	@override String get switchScroll => 'Переключить на горизонтальную прокрутку';
	@override String get switchSplit => 'Переключить на вид рядом';
	@override String get switchUnified => 'Переключить на единый вид';
	@override String get switchWrap => 'Переключить на перенос текста';
	@override String get unified => 'Единый';
	@override String get unstageAll => 'Отменить подготовку всех';
	@override String get unstageHunk => 'Отменить подготовку фрагмента';
	@override String get upToDate => 'Актуально';
	@override String upToDateWith({required Object remote}) => 'Актуально с ${remote}';
	@override String get viewAll => 'Показать все';
	@override String get viewsAria => 'Представления контроля версий';
	@override late final Translations$common$gitPanel$worktrees$ru worktrees = Translations$common$gitPanel$worktrees$ru._(_root);
	@override String get wrap => 'Перенос';
	@override late final Translations$common$gitPanel$tabs$ru tabs = Translations$common$gitPanel$tabs$ru._(_root);
	@override String get save => 'Сохранить';
	@override late final Translations$common$gitPanel$worktreeScripts$ru worktreeScripts = Translations$common$gitPanel$worktreeScripts$ru._(_root);
}

// Path: common.sessions
class Translations$common$sessions$ru extends Translations$common$sessions$en {
	Translations$common$sessions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Переименовать сессию';
}

// Path: common.projects
class Translations$common$projects$ru extends Translations$common$projects$en {
	Translations$common$projects$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Новая сессия';
}

// Path: common.sharedNotes
class Translations$common$sharedNotes$ru extends Translations$common$sharedNotes$en {
	Translations$common$sharedNotes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Общая память — добавляется в каждый сеанс этого проекта';
	@override String get save => 'Сохранить';
	@override String get saving => 'Сохранение…';
	@override String get noProject => 'Выберите рабочую область, чтобы редактировать её общий контекст';
	@override String get placeholder => '# Общий контекст\nСоглашения, решения и подсказки, которые должен знать каждый агент…';
}

// Path: common.codeBlock
class Translations$common$codeBlock$ru extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'Переносить строки';
	@override String get noWrap => 'Без переноса';
}

// Path: common.update
class Translations$common$update$ru extends Translations$common$update$en {
	Translations$common$update$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Доступно обновление · v${version}';
	@override String confirm({required Object version}) => 'Обновить до v${version}? Сервер обновится сам и перезапустится — активные сессии будут прерваны.';
	@override String get downloading => 'Скачивание и применение обновления…';
	@override String get restarting => 'Перезапуск сервера — это займёт мгновение…';
	@override String done({required Object version}) => 'Обновлено до v${version}. Перезагрузите приложение, чтобы применить новую сборку.';
	@override String get manualRestart => 'Обновление применено, но сервер не перезапустился сам — перезапустите его вручную, чтобы завершить.';
	@override String get failed => 'Обновление не удалось.';
	@override String get failedTitle => 'Не удалось обновить';
	@override String appConfirm({required Object version}) => 'Установить DDAgent v${version} на это устройство? При первом запуске Android запросит разрешение на установку приложений из DDAgent.';
	@override String get appPermission => 'Разрешите DDAgent «Установка неизвестных приложений», затем снова нажмите «Обновить».';
	@override String get chooseTitle => 'Доступны обновления';
	@override String get targetApp => 'Это приложение';
	@override String get targetWeb => 'Веб-интерфейс';
	@override String get targetServer => 'Сервер';
	@override String get updateApp => 'Обновить приложение';
	@override String get updateWeb => 'Обновить веб-интерфейс';
	@override String get updateServer => 'Обновить сервер';
	@override String webConfirm({required Object version}) => 'Обновить веб-интерфейс до v${version}? После обновления страница перезагрузится.';
	@override String webDone({required Object version}) => 'Веб-интерфейс обновлён до v${version} — перезагружаю…';
	@override String localServerConfirm({required Object version}) => 'Обновить локальный сервер на этом устройстве до v${version}? Активные сессии будут прерваны.';
	@override String get localServerUpdating => 'Загружаю и запускаю локальный сервер…';
	@override String serverDone({required Object version}) => 'Сервер работает на v${version}.';
	@override String staged({required Object version}) => 'Обновление v${version} загружено — перезапустите сервер, чтобы установить его.';
	@override String get upToDate => 'На сервере уже последний релиз.';
	@override String webHostFailed({required Object message}) => 'Сервер обновлён, а его веб-интерфейс — нет: ${message}';
}

// Path: common.appShell
class Translations$common$appShell$ru extends Translations$common$appShell$en {
	Translations$common$appShell$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String panelActive({required Object count}) => 'Панель · активных: ${count}';
}

// Path: common.errors
class Translations$common$errors$ru extends Translations$common$errors$en {
	Translations$common$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get forbidden => 'Доступ запрещён';
}

// Path: settings.changelog
class Translations$settings$changelog$ru extends Translations$settings$changelog$en {
	Translations$settings$changelog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Журнал изменений';
	@override String get loading => 'Загрузка…';
	@override String get empty => 'Нет релизов для отображения';
	@override String get current => 'текущая';
	@override String get kNew => 'новая';
}

// Path: settings.server
class Translations$settings$server$ru extends Translations$settings$server$en {
	Translations$settings$server$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Сервер';
	@override String get description => 'Перезапускает процесс DDAgent — полезно после обновления или при зависании.';
	@override String get restart => 'Перезапустить';
	@override String get restartConfirm => 'Перезапустить сервер DDAgent? Активные сессии будут прерваны.';
	@override String get restarting => 'Перезапуск… страница перезагрузится, когда сервер вернётся.';
	@override String get restartFailed => 'Перезапуск не удался';
	@override String get unsupported => 'Перезапуск доступен только когда сервер работает под менеджером служб.';
	@override String get ok => 'OK';
	@override String get restartTitle => 'Перезапуск сервера';
	@override String get restartRequesting => 'Отправляю серверу команду перезапуска…';
	@override String restartWaiting({required Object seconds}) => 'Жду, пока сервер вернётся… (${seconds} с)';
	@override String restartBack({required Object version}) => 'Сервер снова работает — версия ${version}.';
	@override String get restartReloading => 'Перезагружаю страницу…';
	@override String restartTimeout({required Object seconds}) => 'Сервер не вернулся за ${seconds} с. Проверьте журнал службы (/tmp/ddagent.log) или перезапустите её вручную.';
}

// Path: settings.updates
class Translations$settings$updates$ru extends Translations$settings$updates$en {
	Translations$settings$updates$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Обновления';
	@override String get description => 'Проверить GitHub на наличие новой десктопной сборки. Новые версии скачиваются автоматически и устанавливаются при выходе.';
	@override String get descriptionMobile => 'Проверить на GitHub наличие новой сборки этого приложения. Обновления устанавливаются системным установщиком устройства.';
	@override String get descriptionServer => 'Проверить на GitHub наличие нового выпуска DDAgent. Подключённый сервер может обновиться сам — активные сеансы будут прерваны во время перезапуска.';
	@override String get check => 'Проверить обновления';
	@override String get checking => 'Проверка…';
	@override String upToDate({required Object version}) => 'У вас последняя версия (v${version}).';
	@override String available({required Object version}) => 'Найдено обновление v${version} — скачивается в фоне; установится при выходе из DDAgent.';
	@override String appAvailable({required Object version}) => 'Доступно обновление приложения v${version} — нажмите «Обновить», чтобы установить его на это устройство.';
	@override String downloaded({required Object version}) => 'Обновление v${version} загружено — закройте и перезапустите DDAgent для установки.';
	@override String get unavailable => 'Проверка обновлений доступна только в упакованных десктопных сборках.';
	@override String error({required Object message}) => 'Не удалось проверить обновления: ${message}';
	@override String get errorGeneric => 'Не удалось проверить обновления.';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · последняя v${latest}';
	@override String current({required Object version}) => 'v${version} — актуальна';
	@override String webNotHosted({required Object version}) => 'Этот веб-интерфейс размещён отдельно — замените его файлы на ddagent-flutter-web-v${version}.zip из релиза.';
	@override String get serverCannotUpdate => 'Этот сервер не может обновиться отсюда — переустановите его через install.sh или из архива релиза.';
}

// Path: settings.tabs
class Translations$settings$tabs$ru extends Translations$settings$tabs$en {
	Translations$settings$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get account => 'Аккаунт';
	@override String get permissions => 'Разрешения';
	@override String get mcpServers => 'MCP серверы';
	@override String get skills => 'Навыки';
	@override String get appearance => 'Внешний вид';
}

// Path: settings.account
class Translations$settings$account$ru extends Translations$settings$account$en {
	Translations$settings$account$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Аккаунт';
	@override String get language => 'Язык';
	@override String get languageLabel => 'Язык интерфейса';
	@override String get languageDescription => 'Выберите предпочитаемый язык для интерфейса';
	@override String get username => 'Имя пользователя';
	@override String get email => 'Эл. почта';
	@override String get profile => 'Профиль';
	@override String get changePassword => 'Изменить пароль';
}

// Path: settings.mcp
class Translations$settings$mcp$ru extends Translations$settings$mcp$en {
	Translations$settings$mcp$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP серверы';
	@override String get addServer => 'Добавить сервер';
	@override String get editServer => 'Редактировать сервер';
	@override String get deleteServer => 'Удалить сервер';
	@override String get serverName => 'Имя сервера';
	@override String get serverType => 'Тип сервера';
	@override String get config => 'Конфигурация';
	@override String get testConnection => 'Проверить подключение';
	@override String get status => 'Статус';
	@override String get connected => 'Подключен';
	@override String get disconnected => 'Отключен';
	@override late final Translations$settings$mcp$scope$ru scope = Translations$settings$mcp$scope$ru._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$ru extends Translations$settings$appearance$en {
	Translations$settings$appearance$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Внешний вид';
	@override String get theme => 'Тема';
	@override String get codeEditor => 'Редактор кода';
	@override String get editorTheme => 'Тема редактора';
	@override String get wordWrap => 'Перенос слов';
	@override String get showMinimap => 'Показать миникарту';
	@override String get lineNumbers => 'Номера строк';
	@override String get fontSize => 'Размер шрифта';
	@override late final Translations$settings$appearance$themeModes$ru themeModes = Translations$settings$appearance$themeModes$ru._(_root);
}

// Path: settings.actions
class Translations$settings$actions$ru extends Translations$settings$actions$en {
	Translations$settings$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Сохранить изменения';
	@override String get resetToDefaults => 'Сбросить к значениям по умолчанию';
	@override String get cancelChanges => 'Отменить изменения';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$ru extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Быстрые настройки';
	@override late final Translations$settings$quickSettings$sections$ru sections = Translations$settings$quickSettings$sections$ru._(_root);
	@override String get darkMode => 'Темная тема';
	@override String get showRawParameters => 'Показывать сырые параметры';
	@override String get showThinking => 'Показывать размышления';
	@override String get sendByCtrlEnter => 'Отправка по Ctrl+Enter';
	@override String get sendByCtrlEnterDescription => 'Когда включено, нажатие Ctrl+Enter будет отправлять сообщение вместо просто Enter. Это полезно для пользователей IME, чтобы избежать случайной отправки.';
	@override late final Translations$settings$quickSettings$dragHandle$ru dragHandle = Translations$settings$quickSettings$dragHandle$ru._(_root);
	@override String get sendWithCtrlEnter => 'Отправлять по Ctrl+Enter';
	@override String get enterSendsHint => 'Если выключено, Enter отправляет сообщение, а Shift+Enter вставляет перенос строки.';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$ru extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Горячие клавиши терминала';
	@override String get sectionKeys => 'Клавиши';
	@override String get sectionNavigation => 'Навигация';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => 'Стрелка вверх';
	@override String get arrowDown => 'Стрелка вниз';
	@override String get scrollDown => 'Прокрутка вниз';
	@override String get killTitle => 'Завершить выполняющийся процесс (Ctrl+C)';
	@override late final Translations$settings$terminalShortcuts$handle$ru handle = Translations$settings$terminalShortcuts$handle$ru._(_root);
	@override String get paste => 'Вставить';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$ru extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Настройки';
	@override String get agents => 'Агенты';
	@override String get orchestration => 'Оркестрация';
	@override String get miniOrchestration => 'Мини-оркестрация';
	@override String get appearance => 'Внешний вид';
	@override String get workspaces => 'Рабочие области';
	@override String get git => 'Git';
	@override String get apiTokens => 'API и токены';
	@override String get models => 'Модели';
	@override String get tasks => 'Задачи';
	@override String get browser => 'Browser';
	@override String get tools => 'Инструменты';
	@override String get notifications => 'Уведомления';
	@override String get about => 'О программе';
	@override String get quota => 'Центр управления';
	@override String get shortcuts => 'Сочетания клавиш';
}

// Path: settings.miniOrchestration
class Translations$settings$miniOrchestration$ru extends Translations$settings$miniOrchestration$en {
	Translations$settings$miniOrchestration$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Мини-оркестрация';
	@override String get description => 'Конвейер из двух моделей: не-flash «мыслитель» планирует, flash-исполнитель выполняет.';
	@override String get loading => 'Загрузка настроек мини-оркестрации…';
	@override String get loadError => 'Не удалось загрузить настройки мини-оркестрации.';
	@override late final Translations$settings$miniOrchestration$enable$ru enable = Translations$settings$miniOrchestration$enable$ru._(_root);
	@override late final Translations$settings$miniOrchestration$thinker$ru thinker = Translations$settings$miniOrchestration$thinker$ru._(_root);
	@override late final Translations$settings$miniOrchestration$worker$ru worker = Translations$settings$miniOrchestration$worker$ru._(_root);
	@override late final Translations$settings$miniOrchestration$fields$ru fields = Translations$settings$miniOrchestration$fields$ru._(_root);
	@override late final Translations$settings$miniOrchestration$roles$ru roles = Translations$settings$miniOrchestration$roles$ru._(_root);
	@override late final Translations$settings$miniOrchestration$planner$ru planner = Translations$settings$miniOrchestration$planner$ru._(_root);
}

// Path: settings.orchestration
class Translations$settings$orchestration$ru extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Распределяйте задачи чата между вашими провайдерами и моделями.';
	@override String get loading => 'Загрузка настроек оркестрации…';
	@override String get loadError => 'Не удалось загрузить настройки оркестрации.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$ru enable = Translations$settings$orchestration$enable$ru._(_root);
	@override late final Translations$settings$orchestration$pool$ru pool = Translations$settings$orchestration$pool$ru._(_root);
	@override late final Translations$settings$orchestration$tiers$ru tiers = Translations$settings$orchestration$tiers$ru._(_root);
	@override late final Translations$settings$orchestration$rules$ru rules = Translations$settings$orchestration$rules$ru._(_root);
	@override late final Translations$settings$orchestration$planner$ru planner = Translations$settings$orchestration$planner$ru._(_root);
	@override late final Translations$settings$orchestration$execution$ru execution = Translations$settings$orchestration$execution$ru._(_root);
	@override late final Translations$settings$orchestration$save$ru save = Translations$settings$orchestration$save$ru._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$ru extends Translations$settings$notifications$en {
	Translations$settings$notifications$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уведомления';
	@override String get description => 'Управляйте тем, какие события уведомлений вы получаете.';
	@override late final Translations$settings$notifications$webPush$ru webPush = Translations$settings$notifications$webPush$ru._(_root);
	@override late final Translations$settings$notifications$device$ru device = Translations$settings$notifications$device$ru._(_root);
	@override late final Translations$settings$notifications$desktop$ru desktop = Translations$settings$notifications$desktop$ru._(_root);
	@override late final Translations$settings$notifications$sound$ru sound = Translations$settings$notifications$sound$ru._(_root);
	@override late final Translations$settings$notifications$events$ru events = Translations$settings$notifications$events$ru._(_root);
	@override late final Translations$settings$notifications$messaging$ru messaging = Translations$settings$notifications$messaging$ru._(_root);
	@override late final Translations$settings$notifications$channels$ru channels = Translations$settings$notifications$channels$ru._(_root);
	@override String get unpair => 'Отвязать';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$ru extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$ru darkMode = Translations$settings$appearanceSettings$darkMode$ru._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$ru codeEditor = Translations$settings$appearanceSettings$codeEditor$ru._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$ru terminal = Translations$settings$appearanceSettings$terminal$ru._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$ru extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$ru title = Translations$settings$mcpForm$title$ru._(_root);
	@override late final Translations$settings$mcpForm$importMode$ru importMode = Translations$settings$mcpForm$importMode$ru._(_root);
	@override late final Translations$settings$mcpForm$scope$ru scope = Translations$settings$mcpForm$scope$ru._(_root);
	@override late final Translations$settings$mcpForm$fields$ru fields = Translations$settings$mcpForm$fields$ru._(_root);
	@override late final Translations$settings$mcpForm$placeholders$ru placeholders = Translations$settings$mcpForm$placeholders$ru._(_root);
	@override late final Translations$settings$mcpForm$validation$ru validation = Translations$settings$mcpForm$validation$ru._(_root);
	@override String configDetails({required Object configFile}) => 'Детали конфигурации (из ${configFile})';
	@override String projectPath({required Object path}) => 'Путь: ${path}';
	@override late final Translations$settings$mcpForm$actions$ru actions = Translations$settings$mcpForm$actions$ru._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$ru extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get success => 'Настройки успешно сохранены!';
	@override String get error => 'Не удалось сохранить настройки';
	@override String get saving => 'Сохранение...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$ru extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get save => 'Сохранить настройки';
	@override String get cancel => 'Отмена';
}

// Path: settings.git
class Translations$settings$git$ru extends Translations$settings$git$en {
	Translations$settings$git$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Конфигурация Git';
	@override String get description => 'Настройте вашу git идентичность для коммитов. Эти настройки будут применены глобально через git config --global';
	@override late final Translations$settings$git$name$ru name = Translations$settings$git$name$ru._(_root);
	@override late final Translations$settings$git$email$ru email = Translations$settings$git$email$ru._(_root);
	@override late final Translations$settings$git$actions$ru actions = Translations$settings$git$actions$ru._(_root);
	@override late final Translations$settings$git$status$ru status = Translations$settings$git$status$ru._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$ru extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'API ключи';
	@override String get description => 'Генерируйте API ключи для доступа к внешнему API из других приложений.';
	@override late final Translations$settings$apiKeys$newKey$ru newKey = Translations$settings$apiKeys$newKey$ru._(_root);
	@override late final Translations$settings$apiKeys$form$ru form = Translations$settings$apiKeys$form$ru._(_root);
	@override String get newButton => 'Новый API ключ';
	@override String get empty => 'API ключи еще не созданы.';
	@override late final Translations$settings$apiKeys$list$ru list = Translations$settings$apiKeys$list$ru._(_root);
	@override String get confirmDelete => 'Вы уверены, что хотите удалить этот API ключ?';
	@override late final Translations$settings$apiKeys$status$ru status = Translations$settings$apiKeys$status$ru._(_root);
	@override late final Translations$settings$apiKeys$github$ru github = Translations$settings$apiKeys$github$ru._(_root);
	@override String get apiDocsLink => 'Документация API';
	@override late final Translations$settings$apiKeys$documentation$ru documentation = Translations$settings$apiKeys$documentation$ru._(_root);
	@override String get loading => 'Загрузка...';
	@override late final Translations$settings$apiKeys$version$ru version = Translations$settings$apiKeys$version$ru._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$ru extends Translations$settings$tasks$en {
	Translations$settings$tasks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Проверка установки TaskMaster...';
	@override late final Translations$settings$tasks$notInstalled$ru notInstalled = Translations$settings$tasks$notInstalled$ru._(_root);
	@override late final Translations$settings$tasks$settings$ru settings = Translations$settings$tasks$settings$ru._(_root);
}

// Path: settings.agents
class Translations$settings$agents$ru extends Translations$settings$agents$en {
	Translations$settings$agents$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$ru authStatus = Translations$settings$agents$authStatus$ru._(_root);
	@override late final Translations$settings$agents$install$ru install = Translations$settings$agents$install$ru._(_root);
	@override late final Translations$settings$agents$update$ru update = Translations$settings$agents$update$ru._(_root);
	@override late final Translations$settings$agents$account$ru account = Translations$settings$agents$account$ru._(_root);
	@override String get connectionStatus => 'Статус подключения';
	@override late final Translations$settings$agents$login$ru login = Translations$settings$agents$login$ru._(_root);
	@override late final Translations$settings$agents$logout$ru logout = Translations$settings$agents$logout$ru._(_root);
	@override String error({required Object error}) => 'Ошибка: ${error}';
	@override late final Translations$settings$agents$accounts$ru accounts = Translations$settings$agents$accounts$ru._(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$ru extends Translations$settings$permissions$en {
	Translations$settings$permissions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки разрешений';
	@override late final Translations$settings$permissions$permissionMode$ru permissionMode = Translations$settings$permissions$permissionMode$ru._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$ru extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP серверы';
	@override late final Translations$settings$mcpServers$description$ru description = Translations$settings$mcpServers$description$ru._(_root);
	@override String get addButton => 'Добавить MCP сервер';
	@override String get empty => 'MCP серверы не настроены';
	@override String get serverType => 'Тип';
	@override late final Translations$settings$mcpServers$scope$ru scope = Translations$settings$mcpServers$scope$ru._(_root);
	@override late final Translations$settings$mcpServers$config$ru config = Translations$settings$mcpServers$config$ru._(_root);
	@override late final Translations$settings$mcpServers$tools$ru tools = Translations$settings$mcpServers$tools$ru._(_root);
	@override late final Translations$settings$mcpServers$actions$ru actions = Translations$settings$mcpServers$actions$ru._(_root);
	@override late final Translations$settings$mcpServers$managed$ru managed = Translations$settings$mcpServers$managed$ru._(_root);
	@override late final Translations$settings$mcpServers$help$ru help = Translations$settings$mcpServers$help$ru._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$ru deleteConfirm = Translations$settings$mcpServers$deleteConfirm$ru._(_root);
}

// Path: settings.quota
class Translations$settings$quota$ru extends Translations$settings$quota$en {
	Translations$settings$quota$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$ru settings = Translations$settings$quota$settings$ru._(_root);
	@override late final Translations$settings$quota$empty$ru empty = Translations$settings$quota$empty$ru._(_root);
	@override late final Translations$settings$quota$quality$ru quality = Translations$settings$quota$quality$ru._(_root);
	@override String get syncFailed => 'Синхронизация не удалась';
	@override String get syncNow => 'Синхронизировать';
}

// Path: settings.browser
class Translations$settings$browser$ru extends Translations$settings$browser$en {
	Translations$settings$browser$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get checking => 'проверка...';
	@override String get description => 'Разрешите агентам создавать контролируемые сессии браузера Playwright, которые можно наблюдать на вкладке Browser.';
	@override String get enableDescription => 'Регистрирует Browser для поддерживаемых агентов. Агенты могут создавать сессии браузера; вы можете наблюдать, останавливать и удалять их.';
	@override String get enableLabel => 'Включить Browser';
	@override late final Translations$settings$browser$errors$ru errors = Translations$settings$browser$errors$ru._(_root);
	@override String get installHint => 'Установите среду выполнения браузера, прежде чем агенты смогут создавать сессии Browser.';
	@override String get installRuntime => 'Установить среду выполнения';
	@override String get installed => 'установлено';
	@override String get installing => 'Установка...';
	@override String get missing => 'отсутствует';
	@override String get runtimeRequired => 'Требуется среда выполнения браузера';
	@override String get statusDisabled => 'отключён';
	@override String get statusLabel => 'Статус';
	@override String get statusReady => 'готов';
	@override String get statusSetupRequired => 'требуется настройка';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$ru extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get create => 'Добавить рабочую область';
	@override String get deleteConfirm => 'Удалить эту рабочую область из DDAgent? Её файлы останутся на диске.';
	@override String get deleteFailed => 'Не удалось удалить рабочую область.';
	@override String get deleteTitle => 'Удалить рабочую область';
	@override String get description => 'Рабочие области — каталоги, в которых DDAgent может вести чаты, запускать код и просматривать файлы.';
	@override String get remove => 'Удалить рабочую область';
	@override String get title => 'Рабочие области';
	@override String get pathRequired => 'Требуется путь';
}

// Path: settings.stt
class Translations$settings$stt$ru extends Translations$settings$stt$en {
	Translations$settings$stt$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Голосовой ввод (распознавание речи)';
	@override String get description => 'Whisper-совместимая конечная точка /audio/transcriptions (OpenAI, whisper.cpp, faster-whisper, Speaches). Включает кнопку микрофона в поле ввода.';
	@override String get configured => 'настроено';
	@override String get endpoint => 'URL конечной точки (например, https://api.openai.com/v1)';
	@override String get apiKey => 'Ключ API';
	@override String get model => 'Модель (по умолчанию: whisper-1)';
	@override String get save => 'Сохранить';
}

// Path: settings.schedules
class Translations$settings$schedules$ru extends Translations$settings$schedules$en {
	Translations$settings$schedules$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Расписания';
	@override String get description => 'Повторяющиеся запуски агентов по расписанию cron. Запуски выполняются без присмотра и в обход запросов разрешений.';
	@override String get preventSleep => 'Не давать уходить в сон во время работы агентов';
	@override String get preventSleepHint => 'Десктопное приложение не даёт экрану погаснуть; в браузере используется блокировка отключения экрана (wake lock).';
	@override String get kNew => 'Новое расписание';
	@override String get loading => 'Загрузка…';
	@override String get empty => 'Расписаний пока нет.';
	@override String get project => 'Проект';
	@override String get provider => 'Провайдер';
	@override String get cron => 'Cron (минута час день месяц день_недели)';
	@override String nextRun({required Object time}) => 'Следующий запуск: ${time}';
	@override String get cronInvalid => 'Для этого выражения нет предстоящих запусков';
	@override String get prompt => 'Промпт';
	@override String get useWorktree => 'Запускать в новом worktree';
	@override String get catchUp => 'Наверстать пропущенные запуски';
	@override String failures({required Object count}) => 'Сбоев: ${count}';
	@override String get disabled => 'отключено';
	@override String get history => 'История';
	@override String get runNow => 'Запустить сейчас';
	@override String get delete => 'Удалить';
	@override String get noRuns => 'Запусков пока нет.';
	@override String get next => 'следующий';
	@override String get create => 'Создать';
	@override String get toggleSchedule => 'Включить расписание';
}

// Path: settings.mcpTokens
class Translations$settings$mcpTokens$ru extends Translations$settings$mcpTokens$en {
	Translations$settings$mcpTokens$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Токены MCP-сервера DDAgent';
	@override String get description => 'Внешние инструменты (Claude Desktop, OpenClaw) вызывают инструменты DDAgent через POST /mcp с одним из этих bearer-токенов.';
	@override String get dismiss => 'Закрыть';
	@override String get labelPlaceholder => 'Метка токена (например, Claude Desktop)';
	@override String get create => 'Создать';
	@override String get empty => 'MCP-токенов пока нет.';
	@override String lastUsed({required Object time}) => 'использован ${time}';
	@override String get neverUsed => 'ни разу не использован';
}

// Path: settings.about
class Translations$settings$about$ru extends Translations$settings$about$en {
	Translations$settings$about$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Поддержать проект';
	@override String get buyMeACoffee => 'Угостите меня кофе';
	@override String get tryHosted => 'Попробовать DDAgent Hosted';
	@override String get learnMore => 'Подробнее';
	@override String get proFeatures => 'Возможности DDAgent Pro';
	@override late final Translations$settings$about$pro$ru pro = Translations$settings$about$pro$ru._(_root);
	@override String get versionInfo => 'Информация о версии';
	@override String get client => 'Приложение';
	@override String get server => 'Сервер';
	@override String get platformMobile => 'Мобильное';
	@override String get platformDesktop => 'Десктоп';
	@override String get platformWeb => 'Веб';
	@override String get unknown => 'неизвестно';
	@override String get copyright => '© 2026 DDAgent — все права защищены';
	@override String get tagline => 'Интерфейс ИИ-ассистента для программирования с открытым исходным кодом';
	@override String get docs => 'Документация';
	@override String get hostedDescription => 'Командная работа, общие конфигурации MCP, синхронизация настроек между средами и управляемая инфраструктура.';
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$ru extends Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'Все сочетания клавиш DDAgent с разбивкой по платформам.';
	@override String get action => 'Действие';
	@override String get winLinux => 'Windows / Linux';
	@override String get mac => 'macOS';
	@override String get navigation => 'Навигация';
	@override String get navWorkspace => 'Перейти в рабочую область';
	@override String get navTasks => 'Перейти к задачам / Git';
	@override String get navGit => 'Перейти к Git';
	@override String get navFocus => 'Переключить режим фокуса (боковая панель)';
	@override String get navSwitcher => 'Быстрое переключение сеансов';
	@override String get navPalette => 'Палитра команд';
	@override String get navSettings => 'Открыть настройки';
	@override String get navClose => 'Закрыть диалог / восстановить разделённые панели';
	@override String get composer => 'Поле ввода';
	@override String get compSend => 'Отправить сообщение';
	@override String get compNewline => 'Новая строка';
	@override String get compNav => 'Перемещение по подсказкам';
	@override String get compAccept => 'Принять подсказку';
	@override String get compCloseSuggest => 'Закрыть подсказки';
	@override String get transcript => 'Переписка';
	@override String get trCopy => 'Копировать выделенный текст';
	@override String get trClose => 'Закрыть поиск / панель проверки';
	@override String get terminal => 'Терминал';
	@override String get termCopy => 'Копировать выделение';
	@override String get termInterrupt => 'Прервать процесс (без выделения)';
	@override String get termPaste => 'Вставить';
	@override String get termSelectAll => 'Выделить всё';
	@override String get editor => 'Редактор';
	@override String get edSave => 'Сохранить файл';
	@override String get edSaveAll => 'Сохранить все файлы';
	@override String get edClose => 'Закрыть вкладку';
	@override String get edNextTab => 'Следующая вкладка';
	@override String get edPrevTab => 'Предыдущая вкладка';
	@override String get edIndent => 'Увеличить / уменьшить отступ';
	@override String get palette => 'Палитра команд';
	@override String get palNav => 'Перемещение по элементам';
	@override String get palRun => 'Выполнить / открыть';
	@override String get palBack => 'Назад (пустой поиск)';
	@override String get palClose => 'Закрыть';
}

// Path: sidebar.projects
class Translations$sidebar$projects$ru extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Проекты';
	@override String get newProject => 'Новый проект';
	@override String get deleteProject => 'Убрать проект';
	@override String get renameProject => 'Переименовать проект';
	@override String get noProjects => 'Проекты не найдены';
	@override String get loadingProjects => 'Загрузка проектов...';
	@override String get searchPlaceholder => 'Поиск проектов...';
	@override String get projectNamePlaceholder => 'Имя проекта';
	@override String get starred => 'Избранное';
	@override String get all => 'Все';
	@override String get untitledSession => 'Безымянный сеанс';
	@override String get newSession => 'Новый сеанс';
	@override String get codexSession => 'Сеанс Codex';
	@override String get fetchingProjects => 'Получение ваших проектов и сеансов Claude';
	@override String get projects => 'проекты';
	@override String get noMatchingProjects => 'Нет подходящих проектов';
	@override String get tryDifferentSearch => 'Попробуйте изменить поисковый запрос';
	@override String get runClaudeCli => 'Запустите Claude CLI в каталоге проекта для начала работы';
}

// Path: sidebar.app
class Translations$sidebar$app$ru extends Translations$sidebar$app$en {
	Translations$sidebar$app$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'Интерфейс AI помощника для программирования';
}

// Path: sidebar.panel
class Translations$sidebar$panel$ru extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get open => 'Панель';
	@override String get newChat => 'Новый чат';
	@override String get navigation => 'Навигация';
	@override String get sessions => 'Сессии';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$ru extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Сеансы';
	@override String get newSession => 'Новый сеанс';
	@override String get deleteSession => 'Удалить сеанс';
	@override String get renameSession => 'Переименовать сеанс';
	@override String get noSessions => 'Сеансов пока нет';
	@override String get loadingSessions => 'Загрузка сеансов...';
	@override String get unnamed => 'Без имени';
	@override String get loading => 'Загрузка...';
	@override String get showMore => 'Показать больше сеансов';
	@override String get selectMode => 'Выбрать';
	@override String get selectAll => 'Выбрать все';
	@override String archiveSelected({required Object count}) => 'Архивировать (${count})';
	@override String deleteSelected({required Object count}) => 'Удалить (${count})';
	@override String get cancelSelection => 'Отменить выбор';
	@override String get toggleSelection => 'Переключить выбор сессий';
	@override String get selectionToolbar => 'Действия с выбранными сессиями';
	@override String get options => 'Опции сессии';
	@override String get pinSession => 'Закрепить сессию';
	@override String get unpinSession => 'Открепить сессию';
	@override String get pinned => 'Закреплённая сессия';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Выбрано: ${count}',
		other: 'Выбрано: ${count}',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$ru extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Просмотр окружений';
	@override String get hideSidebar => 'Скрыть боковую панель';
	@override String get createProject => 'Создать новый проект';
	@override String get refresh => 'Обновить проекты и сеансы (Ctrl+R)';
	@override String get renameProject => 'Переименовать проект (F2)';
	@override String get deleteProject => 'Убрать проект из боковой панели (Delete)';
	@override String get addToFavorites => 'Добавить в избранное';
	@override String get removeFromFavorites => 'Удалить из избранного';
	@override String get editSessionName => 'Вручную редактировать имя сеанса';
	@override String get deleteSession => 'Удалить этот сеанс навсегда';
	@override String get activeSessionIndicator => 'Недавно активный сеанс (последние 10 минут)';
	@override String get save => 'Сохранить';
	@override String get cancel => 'Отмена';
	@override String get clearSearch => 'Очистить поиск';
	@override String get openCommandPalette => 'Открыть палитру команд';
	@override String get attentionRequiredIndicator => 'Сессия требует внимания';
	@override String get openSessions => 'Просмотр сессий';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$ru extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Чат';
	@override String get files => 'Файлы';
	@override String get git => 'Git';
	@override String get terminal => 'Терминал';
	@override String get tasks => 'Задачи';
}

// Path: sidebar.actions
class Translations$sidebar$actions$ru extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Обновить';
	@override String get settings => 'Настройки';
	@override String get collapseAll => 'Свернуть все';
	@override String get expandAll => 'Развернуть все';
	@override String get cancel => 'Отмена';
	@override String get save => 'Сохранить';
	@override String get delete => 'Удалить';
	@override String get rename => 'Переименовать';
	@override String get joinCommunity => 'Присоединиться к сообществу';
	@override String get reportIssue => 'Сообщить о проблеме';
	@override String get starOnGithub => 'Звезда на GitHub';
	@override String get buyMeACoffee => 'Угостите меня кофе';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$ru extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Сменить рабочую область сессии';
	@override String get description => 'Агент выполняет следующие шаги в этом каталоге. Существующая история сессии сохраняется.';
	@override String get pathLabel => 'Путь рабочей области';
	@override String get pathRequired => 'Требуется путь рабочей области.';
	@override String get submit => 'Сменить рабочую область';
	@override String get saving => 'Смена…';
	@override String get changeAction => 'Сменить рабочую область';
}

// Path: sidebar.branding
class Translations$sidebar$branding$ru extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Открытый исходный код';
}

// Path: sidebar.status
class Translations$sidebar$status$ru extends Translations$sidebar$status$en {
	Translations$sidebar$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get active => 'Активен';
	@override String get inactive => 'Неактивен';
	@override String get thinking => 'Думает...';
	@override String get error => 'Ошибка';
	@override String get aborted => 'Прервано';
	@override String get unknown => 'Неизвестно';
}

// Path: sidebar.time
class Translations$sidebar$time$ru extends Translations$sidebar$time$en {
	Translations$sidebar$time$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Только что';
	@override String get oneMinuteAgo => '1 мин. назад';
	@override String minutesAgo({required Object count}) => '${count} мин. назад';
	@override String get oneHourAgo => '1 час назад';
	@override String hoursAgo({required Object count}) => '${count} ч. назад';
	@override String get oneDayAgo => '1 день назад';
	@override String daysAgo({required Object count}) => '${count} дн. назад';
}

// Path: sidebar.messages
class Translations$sidebar$messages$ru extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => 'Вы уверены, что хотите это удалить?';
	@override String get renameSuccess => 'Успешно переименовано';
	@override String get deleteSuccess => 'Успешно удалено';
	@override String get errorOccurred => 'Произошла ошибка';
	@override String get deleteSessionConfirm => 'Вы уверены, что хотите удалить этот сеанс? Это действие нельзя отменить.';
	@override String get deleteProjectConfirm => 'Убрать этот проект из боковой панели? Файлы проекта, воспоминания и данные сеансов не будут удалены.';
	@override String get enterProjectPath => 'Пожалуйста, введите путь к проекту';
	@override String get deleteSessionFailed => 'Не удалось удалить сеанс. Попробуйте снова.';
	@override String get deleteSessionError => 'Ошибка при удалении сеанса. Попробуйте снова.';
	@override String get renameSessionFailed => 'Не удалось переименовать сеанс. Попробуйте снова.';
	@override String get renameSessionError => 'Ошибка при переименовании сеанса. Попробуйте снова.';
	@override String get changeWorkspaceFailed => 'Не удалось сменить рабочую область. Попробуйте снова.';
	@override String get changeWorkspaceError => 'Ошибка при смене рабочей области. Попробуйте снова.';
	@override String get deleteProjectFailed => 'Не удалось убрать проект. Попробуйте снова.';
	@override String get deleteProjectError => 'Ошибка при удалении проекта из списка. Попробуйте снова.';
	@override String get createProjectFailed => 'Не удалось создать проект. Попробуйте снова.';
	@override String get createProjectError => 'Ошибка при создании проекта. Попробуйте снова.';
	@override String get updateProjectError => 'Ошибка при обновлении проекта. Попробуйте снова.';
	@override String get refreshError => 'Не удалось обновить. Попробуйте снова.';
	@override String get restoreProjectFailed => 'Не удалось восстановить проект. Попробуйте снова.';
	@override String get restoreProjectError => 'Ошибка при восстановлении проекта. Попробуйте снова.';
	@override String get restoreSessionFailed => 'Не удалось восстановить сеанс. Попробуйте снова.';
	@override String get restoreSessionError => 'Ошибка при восстановлении сеанса. Попробуйте снова.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Не удалось удалить ${count} сессию. Попробуйте снова.',
		other: 'Не удалось удалить ${count} сессий. Попробуйте снова.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$ru extends Translations$sidebar$version$en {
	Translations$sidebar$version$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Доступно обновление';
	@override String get restartRequired => 'Обновление установлено — перезапустите сервер для применения';
	@override String get updateNow => 'Обновить';
	@override String updateConfirm({required Object version}) => 'Обновить DDAgent до v${version}? Будет получен и собран последний код, сервер перезапустится — активные сессии будут прерваны.';
	@override String get updating => 'Обновление… может занять несколько минут';
	@override String get restarting => 'Обновление установлено — перезапуск…';
	@override String get updateFailed => 'Ошибка обновления';
	@override String get releaseNotes => 'Примечания к релизу';
}

// Path: sidebar.search
class Translations$sidebar$search$ru extends Translations$sidebar$search$en {
	Translations$sidebar$search$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Проекты';
	@override String get modeConversations => 'Разговоры';
	@override String get conversationsPlaceholder => 'Поиск в разговорах...';
	@override String get searching => 'Поиск...';
	@override String get sessionTitles => 'Названия сеансов';
	@override String get conversationContents => 'Содержимое разговоров';
	@override String get noResults => 'Результаты не найдены';
	@override String get tryDifferentQuery => 'Попробуйте другой поисковый запрос';
	@override String get modeRunning => 'Выполняется';
	@override String get archiveOnly => 'Архив';
	@override String get runningTooltip => 'Активные сессии';
	@override String get archiveOnlyTooltip => 'Только архив';
	@override String runningCount({required Object count}) => '${count} активных';
	@override String get viewMenu => 'Вид';
	@override String get backToProjects => 'Назад к проектам';
	@override String get archivedPlaceholder => 'Поиск по архиву...';
	@override String get runningPlaceholder => 'Поиск активных сессий...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} совпадение',
		few: '${count} совпадения',
		many: '${count} совпадений',
		other: '${count} совпадений',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} проект просканирован',
		few: '${count} проекта просканировано',
		many: '${count} проектов просканировано',
		other: '${count} проектов просканировано',
	);
}

// Path: sidebar.recent
class Translations$sidebar$recent$ru extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Недавние разговоры';
	@override String get emptyTitle => 'Пока нет разговоров';
	@override String get emptyDescription => 'Здесь появятся ваши недавно обновлённые разговоры.';
	@override String get loadFailed => 'Не удалось загрузить недавние разговоры';
	@override String get loadMore => 'Загрузить более старые разговоры';
	@override String get loadingMore => 'Загрузка...';
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$ru extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Убрать проект';
	@override String get deleteSession => 'Удалить сеанс';
	@override String get confirmDelete => 'Что вы хотите сделать с';
	@override String get removeFromSidebar => 'Убрать только из боковой панели';
	@override String get deleteAllData => 'Удалить все данные навсегда';
	@override String get allConversationsDeleted => 'Проект будет убран из боковой панели. Ваши файлы, воспоминания и данные сеансов сохранятся.';
	@override String get cannotUndo => 'Вы сможете добавить проект позже.';
	@override String get bulkDeleteSessionsDescription => 'Архивирование скрывает выбранные сессии из активного списка, сохраняя их истории.';
	@override String get archiveSession => 'Архивировать сессию';
	@override String get archiveSessionNotice => 'Архивирование убирает сессию из активного списка, сохраняя её историю.';
	@override String get archivedSessionNotice => 'Эта сессия уже в архиве. Можно оставить её скрытой или удалить навсегда.';
	@override String get deleteSessionNotice => 'Это навсегда удалит сессию и её транскрипт. Действие необратимо.';
	@override String get deleteSessionPermanently => 'Удалить навсегда';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Этот проект содержит ${count} разговор.',
		few: 'Этот проект содержит ${count} разговора.',
		many: 'Этот проект содержит ${count} разговоров.',
		other: 'Этот проект содержит ${count} разговоров.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Управление выбранной сессией',
		other: 'Управление ${count} выбранными сессиями',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Архивировать сессию',
		other: 'Архивировать ${count} сессий',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$ru extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Активные сейчас';
	@override String get recent => 'Недавно использованные';
	@override String get today => 'Сегодня';
	@override String get yesterday => 'Вчера';
	@override String get thisWeek => 'На этой неделе';
	@override String showMore({required Object count}) => 'Показать ещё ${count}';
	@override String get showLess => 'Показать меньше';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$ru extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get board => 'Панель агентов';
	@override String get files => 'Файлы';
	@override String get git => 'Контроль версий';
	@override String get tasks => 'Задачи';
	@override String get usage => 'Квоты и использование';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$ru extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI не настроен';
	@override String get description => 'TaskMaster помогает разбивать сложные проекты на управляемые задачи с помощью AI';
	@override String get whatIsTitle => '🎯 Что такое TaskMaster?';
	@override late final Translations$tasks$notConfigured$features$ru features = Translations$tasks$notConfigured$features$ru._(_root);
	@override String get initializeButton => 'Инициализировать TaskMaster AI';
	@override String get writePrdFirst => 'Сначала создайте PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$ru extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Начало работы с TaskMaster';
	@override String get subtitle => 'TaskMaster инициализирован! Вот что делать дальше:';
	@override late final Translations$tasks$gettingStarted$steps$ru steps = Translations$tasks$gettingStarted$steps$ru._(_root);
	@override String get tip => '💡 Совет: начните с PRD, чтобы получить максимум от AI-генерации задач TaskMaster';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$ru extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройка TaskMaster';
	@override String subtitle({required Object projectName}) => 'Интерактивный CLI для ${projectName}';
	@override String get willStart => 'Инициализация TaskMaster начнется автоматически';
	@override String get completed => 'Настройка TaskMaster завершена! Теперь вы можете закрыть это окно.';
	@override String get closeButton => 'Закрыть';
	@override String get closeContinueButton => 'Закрыть и продолжить';
	@override String get closeTitle => 'Закрыть';
	@override String get description => 'Создаёт папку .taskmaster в этом проекте. Внешние инструменты и ключи API не требуются — задачи хранятся локально.';
	@override String get initializeButton => 'Инициализировать';
	@override String get initializing => 'Инициализация...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$ru extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Начало работы с TaskMaster';
	@override String get subtitle => 'Ваш гид по продуктивному управлению задачами';
	@override late final Translations$tasks$helpGuide$examples$ru examples = Translations$tasks$helpGuide$examples$ru._(_root);
	@override String get moreExamples => 'Посмотреть больше примеров и шаблонов использования →';
	@override late final Translations$tasks$helpGuide$proTips$ru proTips = Translations$tasks$helpGuide$proTips$ru._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$ru learnMore = Translations$tasks$helpGuide$learnMore$ru._(_root);
	@override String get closeTitle => 'Закрыть';
}

// Path: tasks.search
class Translations$tasks$search$ru extends Translations$tasks$search$en {
	Translations$tasks$search$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Поиск задач...';
}

// Path: tasks.filters
class Translations$tasks$filters$ru extends Translations$tasks$filters$en {
	Translations$tasks$filters$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get button => 'Фильтры';
	@override String get status => 'Статус';
	@override String get priority => 'Приоритет';
	@override String get sortBy => 'Сортировать по';
	@override String get allStatuses => 'Все статусы';
	@override String get allPriorities => 'Все приоритеты';
	@override String showing({required Object filtered, required Object total}) => 'Показано ${filtered} из ${total} задач';
	@override String get clearFilters => 'Очистить фильтры';
}

// Path: tasks.sort
class Translations$tasks$sort$ru extends Translations$tasks$sort$en {
	Translations$tasks$sort$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Статус';
	@override String get priority => 'Приоритет';
	@override String get idAsc => 'ID (по возрастанию)';
	@override String get idDesc => 'ID (по убыванию)';
	@override String get titleAsc => 'Название (А-Я)';
	@override String get titleDesc => 'Название (Я-А)';
	@override String get statusAsc => 'Статус (сначала ожидающие)';
	@override String get statusDesc => 'Статус (сначала выполненные)';
	@override String get priorityAsc => 'Приоритет (сначала высокий)';
	@override String get priorityDesc => 'Приоритет (сначала низкий)';
}

// Path: tasks.views
class Translations$tasks$views$ru extends Translations$tasks$views$en {
	Translations$tasks$views$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Представление Канбан';
	@override String get list => 'Представление списком';
	@override String get grid => 'Представление сеткой';
}

// Path: tasks.kanban
class Translations$tasks$kanban$ru extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 К выполнению';
	@override String get inProgress => '🚀 В процессе';
	@override String get review => '👀 Ревью';
	@override String get done => '✅ Выполнено';
	@override String get blocked => '🚫 Заблокировано';
	@override String get deferred => '⏳ Отложено';
	@override String get cancelled => '❌ Отменено';
	@override String get noTasksYet => 'Задач пока нет';
	@override String get tasksWillAppear => 'Задачи появятся здесь';
	@override String get moveTasksHere => 'Перемещайте задачи сюда при начале работы';
	@override String get completedTasksHere => 'Завершенные задачи появляются здесь';
	@override String get statusTasksHere => 'Задачи с этим статусом появятся здесь';
}

// Path: tasks.buttons
class Translations$tasks$buttons$ru extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get help => 'Руководство по началу работы с TaskMaster';
	@override String get prds => 'PRD';
	@override String get addPRD => 'Добавить PRD';
	@override String get addTask => 'Добавить задачу';
	@override String get createNewPRD => 'Создать новый PRD';
	@override String prdsAvailable({required Object count}) => 'Доступно ${count} PRD';
}

// Path: tasks.prd
class Translations$tasks$prd$ru extends Translations$tasks$prd$en {
	Translations$tasks$prd$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Изменено: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String get newFile => 'новый файл';
	@override String get template => 'Шаблон';
	@override String get parse => 'Разобрать PRD';
	@override String get fileExistsTitle => 'Файл уже существует';
	@override String fileExistsMessage({required Object name}) => 'PRD с именем «${name}» уже существует. Перезаписать его?';
	@override String get fileNameHint => 'имя файла (например, prd.txt)';
	@override String get saved => 'PRD сохранён';
	@override String get tasksGenerated => 'Задачи созданы из PRD';
}

// Path: tasks.statuses
class Translations$tasks$statuses$ru extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Ожидание';
	@override String get inProgress => 'В процессе';
	@override String get done => 'Выполнено';
	@override String get blocked => 'Заблокировано';
	@override String get deferred => 'Отложено';
	@override String get cancelled => 'Отменено';
	@override String get review => 'Ревью';
}

// Path: tasks.priorities
class Translations$tasks$priorities$ru extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get high => 'Высокий';
	@override String get medium => 'Средний';
	@override String get low => 'Низкий';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$ru extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Нет задач, соответствующих вашим фильтрам';
	@override String get description => 'Попробуйте изменить критерии поиска или фильтрации.';
}

// Path: tasks.board
class Translations$tasks$board$ru extends Translations$tasks$board$en {
	Translations$tasks$board$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Доска агентов';
	@override String get subtitle => 'Переместите карточку в Готово — агент её подхватит. Нажмите на карточку, чтобы открыть её сессию.';
	@override String get newCard => 'Новая карточка';
	@override String get addCard => 'Добавить карточку';
	@override String get refresh => 'Обновить';
	@override late final Translations$tasks$board$empty$ru empty = Translations$tasks$board$empty$ru._(_root);
	@override late final Translations$tasks$board$columns$ru columns = Translations$tasks$board$columns$ru._(_root);
	@override late final Translations$tasks$board$card$ru card = Translations$tasks$board$card$ru._(_root);
	@override late final Translations$tasks$board$dialog$ru dialog = Translations$tasks$board$dialog$ru._(_root);
	@override String get noProject => 'Сначала добавьте проект, затем создавайте для него карточки.';
	@override String get projectLabel => 'Проект';
	@override String get backToChat => 'Назад к чату';
	@override late final Translations$tasks$board$agent$ru agent = Translations$tasks$board$agent$ru._(_root);
	@override late final Translations$tasks$board$deleteConfirm$ru deleteConfirm = Translations$tasks$board$deleteConfirm$ru._(_root);
	@override String get project => 'Проект';
	@override late final Translations$tasks$board$assignee$ru assignee = Translations$tasks$board$assignee$ru._(_root);
	@override late final Translations$tasks$board$presence$ru presence = Translations$tasks$board$presence$ru._(_root);
	@override late final Translations$tasks$board$activity$ru activity = Translations$tasks$board$activity$ru._(_root);
	@override late final Translations$tasks$board$comments$ru comments = Translations$tasks$board$comments$ru._(_root);
}

// Path: tasks.card
class Translations$tasks$card$ru extends Translations$tasks$card$en {
	Translations$tasks$card$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Зависит от: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Задача ${id}';
	@override String get highPriority => 'Высокий приоритет';
	@override String get lowPriority => 'Низкий приоритет';
	@override String get mediumPriority => 'Средний приоритет';
	@override String get noPriority => 'Приоритет не задан';
	@override String parentTask({required Object id}) => 'Задача ${id}';
	@override String get progressLabel => 'Прогресс:';
	@override String progressTooltip({required Object completed, required Object total}) => 'Выполнено ${completed} из ${total} подзадач';
	@override String get runTask => 'Запустить задачу';
	@override String runTaskAria({required Object id}) => 'Запустить задачу ${id}';
	@override String statusTooltip({required Object status}) => 'Статус: ${status}';
	@override String taskIdTitle({required Object id}) => 'ID задачи: ${id}';
	@override String get taskInProgress => 'Задача выполняется';
}

// Path: tasks.createTask
class Translations$tasks$createTask$ru extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get descriptionLabel => 'Описание';
	@override String get descriptionPlaceholder => 'Дополнительные детали';
	@override String get error => 'Не удалось добавить задачу';
	@override String get priorityLabel => 'Приоритет';
	@override String get submit => 'Добавить задачу';
	@override String get submitting => 'Добавление...';
	@override String get title => 'Добавить задачу';
	@override String get titleLabel => 'Название';
	@override String get titlePlaceholder => 'Что нужно сделать?';
}

// Path: tasks.list
class Translations$tasks$list$ru extends Translations$tasks$list$en {
	Translations$tasks$list$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Выполнена (нажмите, чтобы переоткрыть)';
	@override String get inProgressComplete => 'Выполняется (нажмите, чтобы завершить)';
	@override String get markCompleted => 'Отметить как выполненную';
	@override String toggleStatusAria({required Object id}) => 'Переключить статус задачи ${id}';
	@override String get markDone => 'Отметить как выполненную';
	@override String get reopen => 'Возобновить';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$ru extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Все задачи выполнены';
	@override String get feature1 => '- Управление задачами с ИИ: зависимости и подзадачи.';
	@override String get feature2 => '- Генерация задач из PRD для быстрого старта проекта.';
	@override String get feature3 => '- Kanban и список для повседневной работы.';
	@override String get hideDetails => 'Скрыть детали';
	@override String get initialize => 'Инициализировать';
	@override String get noPending => 'Нет ожидающих задач';
	@override String get notConfigured => 'TaskMaster AI не настроен';
	@override String get review => 'Проверить';
	@override String get startTask => 'Начать задачу';
	@override String taskId({required Object id}) => 'Задача ${id}';
	@override String get viewAll => 'Все задачи';
	@override String get viewDetails => 'Детали задачи';
	@override String get whatIs => 'Что такое TaskMaster?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$ru extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Отменить редактирование';
	@override String get close => 'Закрыть';
	@override String get copyTaskId => 'Копировать ID задачи';
	@override String get delete => 'Удалить задачу';
	@override String deleteConfirmDescription({required Object title}) => '«${title}» будет безвозвратно удалена.';
	@override String get deleteConfirmTitle => 'Удалить задачу?';
	@override String get deleteFailed => 'Не удалось удалить задачу';
	@override String get dependencies => 'Зависимости';
	@override String get dependenciesPlaceholder => 'напр. 1, 2, 3';
	@override String get description => 'Описание';
	@override String get edit => 'Редактировать задачу';
	@override String get implDetails => 'Детали реализации';
	@override String get noDependencies => 'Нет зависимостей';
	@override String get noDescription => 'Описание отсутствует';
	@override String get priority => 'Приоритет';
	@override String get priorityNotSet => 'Не задан';
	@override String get save => 'Сохранить';
	@override String get status => 'Статус';
	@override String get statusFailed => 'Не удалось обновить статус задачи';
	@override String taskId({required Object id}) => 'Задача ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Задача ${id}: ${title}';
	@override String get testStrategy => 'Стратегия тестирования';
	@override String get titleRequired => 'Название обязательно';
	@override String get updateFailed => 'Не удалось обновить задачу';
	@override String get notFound => 'Задача не найдена';
	@override String get subtasks => 'Подзадачи';
	@override String deleteConfirmMessage({required Object id}) => 'Задача #${id} будет удалена. Действие необратимо.';
	@override String get idCopied => 'ID задачи скопирован';
}

// Path: tasks.toasts
class Translations$tasks$toasts$ru extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Задача ${id} переведена в статус «В процессе»';
}

// Path: tasks.taskmaster
class Translations$tasks$taskmaster$ru extends Translations$tasks$taskmaster$en {
	Translations$tasks$taskmaster$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get noProjectHint => 'Сначала добавьте проект, затем создайте для него задачи.';
	@override late final Translations$tasks$taskmaster$sort$ru sort = Translations$tasks$taskmaster$sort$ru._(_root);
	@override String installedVersion({required Object version}) => 'Установлено: ${version}';
	@override String get initFailed => 'Не удалось инициализировать TaskMaster';
	@override late final Translations$tasks$taskmaster$prd$ru prd = Translations$tasks$taskmaster$prd$ru._(_root);
	@override late final Translations$tasks$taskmaster$detail$ru detail = Translations$tasks$taskmaster$detail$ru._(_root);
	@override String get untitledTask => 'Задача без названия';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$ru extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Панель';
	@override String get memories => 'Память';
	@override String get rules => 'Правила';
	@override String get skills => 'Навыки';
	@override String get personal => 'Личное';
	@override String get graph => 'Граф';
}

// Path: knowledge.common
class Translations$knowledge$common$ru extends Translations$knowledge$common$en {
	Translations$knowledge$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get add => 'Добавить';
	@override String get save => 'Сохранить';
	@override String get cancel => 'Отмена';
	@override String get delete => 'Удалить';
	@override String get edit => 'Изменить';
	@override String get close => 'Закрыть';
	@override String get restore => 'Восстановить';
	@override String get refresh => 'Обновить';
	@override String get allProjects => 'Все проекты';
	@override String get global => 'Глобально';
}

// Path: knowledge.actions
class Translations$knowledge$actions$ru extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Сканировать файлы проекта';
	@override String get export => 'Экспорт JSON';
	@override String get import => 'Импорт JSON';
	@override String get scanComplete => 'Сканирование завершено';
	@override String get importComplete => 'Импорт завершён';
	@override String get importFailed => 'Не удалось импортировать';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$ru extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Новая запись';
	@override String get editEntity => 'Изменить запись';
	@override String get deleteTitle => 'Удалить';
	@override String get deleteMessage => 'Удалить эту запись? Действие необратимо (история сохраняется).';
	@override String get pickIcon => 'Выбрать значок';
	@override String get removeIcon => 'Удалить значок';
	@override String get iconTooLarge => 'Значок слишком большой (макс. 40 КБ).';
	@override String get importTitle => 'Импортировать знания';
	@override String get importHint => 'Вставьте сюда экспортированный JSON';
	@override String get exportTitle => 'Экспортировать знания';
	@override String get import => 'Импорт';
}

// Path: knowledge.fields
class Translations$knowledge$fields$ru extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get key => 'Ключ';
	@override String get title => 'Заголовок';
	@override String get name => 'Имя';
	@override String get description => 'Описание';
	@override String get category => 'Категория';
	@override String get content => 'Содержимое';
	@override String get priority => 'Приоритет';
	@override String get tags => 'Теги';
	@override String get enabled => 'Включено';
	@override String get projectScope => 'Область проекта';
	@override String get tagsHint => 'через запятую';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$ru extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Память';
	@override String get rules => 'Правила';
	@override String get skills => 'Навыки';
	@override String get personal => 'Личное';
	@override String get connections => 'Связи';
	@override String get recent => 'Последние записи';
	@override String get noMemories => 'Записей нет. Добавьте в разделе Память.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$ru extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Записей нет.';
	@override String get rules => 'Правил нет.';
	@override String get skills => 'Навыков нет.';
	@override String get personal => 'Личных данных нет.';
	@override String get graph => 'Нет сущностей для графа.';
}

// Path: knowledge.history
class Translations$knowledge$history$ru extends Translations$knowledge$history$en {
	Translations$knowledge$history$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'История';
	@override String get none => 'Истории нет.';
	@override String get untitled => '(без названия)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$ru extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Критический';
	@override String get high => 'Высокий';
	@override String get normal => 'Обычный';
	@override String get low => 'Низкий';
}

// Path: knowledge.search
class Translations$knowledge$search$ru extends Translations$knowledge$search$en {
	Translations$knowledge$search$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Поиск по знаниям';
	@override String get hint => 'Поиск по памяти, правилам, навыкам…';
	@override String get noResults => 'Ничего не найдено.';
}

// Path: knowledge.links
class Translations$knowledge$links$ru extends Translations$knowledge$links$en {
	Translations$knowledge$links$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Связать сущности';
	@override String get source => 'Источник';
	@override String get target => 'Цель';
	@override String get relationship => 'Тип связи';
	@override String get add => 'Создать связь';
}

// Path: knowledge.tags
class Translations$knowledge$tags$ru extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get all => 'Все теги';
	@override String get manage => 'Управление тегами';
	@override String get none => 'Тегов нет.';
}

// Path: knowledge.graph
class Translations$knowledge$graph$ru extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'обрезано';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$ru extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Импортировать всё в DDAgent';
	@override String projectsScanned({required Object count}) => 'Просканировано проектов: ${count}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Найдено навыков агентов: ${found} (новых: ${newSkills})';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Правила: ${total} · группы дубликатов: ${duplicates}';
	@override String get mergeDuplicates => 'Объединить дублирующиеся записи';
	@override String get mergeDuplicatesHint => 'Объединяет дублирующиеся строки в DDAgent (не файлы)';
	@override String get action => 'Импортировать всё';
	@override String get readOnlyNotice => 'Для ваших агентов только чтение: импорт выполняется в собственную базу данных DDAgent и НЕ изменяет и не удаляет файлы или настройки CLI. Параметры ниже меняют только данные DDAgent.';
	@override String get dryRunNote => 'Пробный запуск — пока ничего не записано.';
	@override String get importedNote => 'Импортировано.';
	@override String result({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'Импортировано — правила: ${rules}, новые навыки: ${newSkills}, удалено: ${removed}, повышено: ${promoted}';
	@override String get description => 'Просканировать все проекты и импортировать навыки ваших агентов в базу знаний. Для агентов только чтение — в CLI ничего не меняется.';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$ru extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Мигрировать существующие правила';
	@override String scanned({required Object count}) => 'Просканировано проектов: ${count}.';
	@override String rulesSummary({required Object total, required Object critical}) => 'Правила: всего ${total}, критических: ${critical}.';
	@override String duplicates({required Object count}) => 'Группы дубликатов по проектам: ${count}';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Удалено: ${removed}, повышено: ${promoted}';
	@override String get mergeDuplicates => 'Объединить дубликаты';
	@override String get dryRunNote => 'Пробный запуск — пока ничего не изменено.';
	@override String get applied => 'Применено.';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$ru extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Импортировать навыки агентов';
	@override String found({required Object count}) => 'Найдено навыков у ваших агентов: ${count}.';
	@override String summary({required Object imported, required Object skipped}) => 'Новых: ${imported} · пропущено: ${skipped}';
	@override String get dryRunHint => 'Импортирует глобальные/стандартные навыки ваших агентов (пользовательские, системные, из плагинов) как навыки базы знаний. Пробный запуск — пока ничего не импортировано.';
	@override String get importedNote => 'Импортировано в базу знаний.';
}

// Path: knowledge.critical
class Translations$knowledge$critical$ru extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get make => 'Сделать критическим';
	@override String get makeAll => 'Сделать все правила критическими';
	@override String get makeAllHint => 'Добавляет их в бюджет внедряемого контекста';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$ru extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} токенов';
	@override String get title => 'Контекст правил (передаётся всегда)';
	@override String get selectProject => 'Выберите проект, чтобы увидеть размер его критического контекста.';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$ru extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Память: ${title}';
	@override String rule({required Object title}) => 'Правило: ${title}';
	@override String skill({required Object name}) => 'Навык: ${name}';
	@override String personal({required Object title}) => 'Личное: ${title}';
}

// Path: knowledge.errors
class Translations$knowledge$errors$ru extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'Импорт не удался: ${error}';
	@override String migrationFailed({required Object error}) => 'Миграция не удалась: ${error}';
}

// Path: knowledge.entityTypes
class Translations$knowledge$entityTypes$ru extends Translations$knowledge$entityTypes$en {
	Translations$knowledge$entityTypes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get memory => 'Воспоминание';
	@override String get rule => 'Правило';
	@override String get skill => 'Навык';
	@override String get personal => 'Личное';
	@override String get project => 'Проект';
	@override String get tag => 'Тег';
}

// Path: collab.roles
class Translations$collab$roles$ru extends Translations$collab$roles$en {
	Translations$collab$roles$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get member => 'Участник';
	@override String get viewer => 'Наблюдатель';
}

// Path: collab.viewing
class Translations$collab$viewing$ru extends Translations$collab$viewing$en {
	Translations$collab$viewing$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get session => 'сессия';
	@override String get card => 'карточка';
	@override String get board => 'доска';
}

// Path: fileTree.search
class Translations$fileTree$search$ru extends Translations$fileTree$search$en {
	Translations$fileTree$search$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Фильтр по именам / Enter — поиск по содержимому';
	@override String get prompt => 'Введите запрос и нажмите Enter';
	@override String get noMatches => 'Совпадений нет';
	@override String get resultsTruncated => 'Результаты усечены';
}

// Path: fileTree.titles
class Translations$fileTree$titles$ru extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String rename({required Object name}) => 'Переименовать ${name}';
	@override String delete({required Object name}) => 'Удалить ${name}';
	@override String download({required Object name}) => 'Скачать ${name}';
}

// Path: fileTree.relative
class Translations$fileTree$relative$ru extends Translations$fileTree$relative$en {
	Translations$fileTree$relative$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get now => 'сейчас';
	@override String minutes({required Object n}) => '${n} мин';
	@override String hours({required Object n}) => '${n} ч';
	@override String days({required Object n}) => '${n} д';
}

// Path: git.checkpoints
class Translations$git$checkpoints$ru extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Чекпоинты';
	@override String get restoreTitle => 'Восстановить чекпоинт';
	@override String get restoreMessage => 'Сбросить рабочее дерево к этому чекпоинту? Текущие изменения будут заменены.';
	@override String get restored => 'Чекпоинт восстановлен';
	@override String get labelHint => 'Метка чекпоинта (необязательно)';
	@override String get empty => 'Чекпоинтов пока нет';
	@override String get create => 'Новый';
}

// Path: git.branchSections
class Translations$git$branchSections$ru extends Translations$git$branchSections$en {
	Translations$git$branchSections$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get local => 'ЛОКАЛЬНЫЕ';
	@override String get remote => 'УДАЛЁННЫЕ';
}

// Path: kanban.card
class Translations$kanban$card$ru extends Translations$kanban$card$en {
	Translations$kanban$card$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Без названия';
}

// Path: kanban.comments
class Translations$kanban$comments$ru extends Translations$kanban$comments$en {
	Translations$kanban$comments$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Комментариев пока нет';
	@override String get add => 'Добавить комментарий';
}

// Path: kanban.dialog
class Translations$kanban$dialog$ru extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Сохранение…';
}

// Path: kanban.details
class Translations$kanban$details$ru extends Translations$kanban$details$en {
	Translations$kanban$details$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Детали карточки';
	@override String status({required Object status}) => 'Статус: ${status}';
}

// Path: kanban.empty
class Translations$kanban$empty$ru extends Translations$kanban$empty$en {
	Translations$kanban$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Проект не выбран';
}

// Path: kanban.time
class Translations$kanban$time$ru extends Translations$kanban$time$en {
	Translations$kanban$time$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get now => 'сейчас';
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '1 минуту назад',
		other: '${count} мин. назад',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '1 час назад',
		other: '${count} ч. назад',
	);
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '1 день назад',
		other: '${count} дн. назад',
	);
}

// Path: mcp.install
class Translations$mcp$install$ru extends Translations$mcp$install$en {
	Translations$mcp$install$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Установить MCP сервер DDAgent';
	@override String get description => 'Позволяет выбранным агентам использовать базу знаний и инструменты DDAgent через MCP.';
	@override String get cardDescription => 'Дайте своим агентам базу знаний и инструменты DDAgent через MCP — выберите агентов или установите для всех.';
	@override String get installSelected => 'Установить выбранным';
	@override String get installForAll => 'Установить для всех';
	@override String get button => 'Установить';
	@override String failed({required Object error}) => 'Установка не удалась: ${error}';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Установлено для ${count} агента.',
		other: 'Установлено для ${count} агентов.',
	);
	@override String partialFailure({required Object count, required Object failed}) => 'Установлено для ${count}; не удалось: ${failed}';
	@override String get errorFallback => 'ошибка';
}

// Path: mcp.servers
class Translations$mcp$servers$ru extends Translations$mcp$servers$en {
	Translations$mcp$servers$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Загрузка MCP серверов…';
	@override String get refreshingScopes => 'Обновление областей проектов…';
	@override String descriptionGeneric({required Object provider}) => 'Серверы Model Context Protocol предоставляют ${provider} дополнительные инструменты и источники данных';
	@override String get addGlobalTitle => 'Добавить глобальный MCP сервер';
	@override String get addGlobalDescription => 'Добавляет этот MCP сервер всем провайдерам: Claude, Cursor, Codex, OpenCode и Devin. Поддерживаются только транспорты stdio и HTTP, поскольку одна и та же конфигурация должна работать у всех провайдеров.';
	@override String get addGlobalMenuDescription => '«Добавить глобальный MCP сервер» записывает один общий stdio- или HTTP-сервер в Claude, Cursor, Codex, OpenCode и Devin.';
	@override String addProviderTitle({required Object provider}) => 'Добавить MCP сервер для ${provider}';
	@override String addProviderDescription({required Object provider}) => '«Добавить MCP сервер для ${provider}» изменяет только ${provider}.';
	@override late final Translations$mcp$servers$config$ru config = Translations$mcp$servers$config$ru._(_root);
	@override String get selectProjectRequired => 'Выберите проект для MCP-серверов с областью проекта';
	@override String get globalScopeUnsupported => 'Добавление MCP-сервера для всех провайдеров поддерживает только область пользователя или проекта.';
	@override String globalAddFailed({required Object details}) => 'Не удалось добавить MCP-сервер ко всем провайдерам. ${details}';
	@override String get scopeProject => 'проект';
}

// Path: mcp.team
class Translations$mcp$team$ru extends Translations$mcp$team$en {
	Translations$mcp$team$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Командные конфигурации MCP';
	@override String get description => 'Делитесь конфигурациями MCP серверов с командой. Все синхронизируются автоматически.';
	@override String get cta => 'Доступно с DDAgent Pro';
}

// Path: mcp.tokens
class Translations$mcp$tokens$ru extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Запись';
	@override String get scopeRead => 'Чтение';
}

// Path: mcp.form
class Translations$mcp$form$ru extends Translations$mcp$form$en {
	Translations$mcp$form$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String submitTo({required Object provider}) => 'Добавить сервер в ${provider}';
	@override late final Translations$mcp$form$scope$ru scope = Translations$mcp$form$scope$ru._(_root);
	@override late final Translations$mcp$form$fields$ru fields = Translations$mcp$form$fields$ru._(_root);
	@override late final Translations$mcp$form$validation$ru validation = Translations$mcp$form$validation$ru._(_root);
}

// Path: notifications.errors
class Translations$notifications$errors$ru extends Translations$notifications$errors$en {
	Translations$notifications$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get registrationRejected => 'Сервер отклонил регистрацию';
	@override String get noResponse => 'Нет ответа от сервера';
}

// Path: notifications.androidChannel
class Translations$notifications$androidChannel$ru extends Translations$notifications$androidChannel$en {
	Translations$notifications$androidChannel$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get name => 'Оповещения DDAgent';
	@override String get description => 'Уведомления о запусках агентов, подтверждениях и ошибках';
}

// Path: onboarding.errors
class Translations$onboarding$errors$ru extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get nameAndEmailRequired => 'Требуются и имя, и эл. почта для git.';
	@override String get invalidEmail => 'Введите корректный адрес электронной почты.';
}

// Path: onboarding.agents
class Translations$onboarding$agents$ru extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Подключите своих ИИ-агентов';
	@override String get description => 'Войдите в одного или нескольких ИИ-ассистентов программирования. Все они необязательны.';
	@override String get laterHint => 'Вы можете настроить их позже в Настройках.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$ru extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Подключить агентов к DDAgent';
	@override String get description => 'Установите MCP сервер DDAgent, чтобы ваши агенты могли использовать базу знаний и инструменты DDAgent. Выберите агентов или установите для всех.';
	@override String get installSelected => 'Установить выбранным';
	@override String get installForAll => 'Установить для всех';
	@override String get laterHint => 'Необязательно — вы также можете установить это позже в Настройках → MCP.';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Установлено для ${count} агента.',
		other: 'Установлено для ${count} агентов.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => 'Установлено для ${installedCount}; не удалось: ${failed}';
}

// Path: quota.section
class Translations$quota$section$ru extends Translations$quota$section$en {
	Translations$quota$section$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get config => 'Конфигурация';
}

// Path: quota.overview
class Translations$quota$overview$ru extends Translations$quota$overview$en {
	Translations$quota$overview$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Токены и стоимость';
}

// Path: quota.agents
class Translations$quota$agents$ru extends Translations$quota$agents$en {
	Translations$quota$agents$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.config
class Translations$quota$config$ru extends Translations$quota$config$en {
	Translations$quota$config$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get pollerTitle => 'Опрос и оповещения';
	@override String get accountRouting => 'Маршрутизация аккаунтов';
	@override String get save => 'Сохранить конфигурацию';
}

// Path: quota.chart
class Translations$quota$chart$ru extends Translations$quota$chart$en {
	Translations$quota$chart$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get show => 'Показать';
	@override String get hide => 'Скрыть';
	@override String get noData => 'Недостаточно данных для тренда.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} токенов · ${cost}';
}

// Path: quota.duration
class Translations$quota$duration$ru extends Translations$quota$duration$en {
	Translations$quota$duration$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String minutes({required Object minutes}) => '${minutes} мин';
	@override String hoursMinutes({required Object hours, required Object minutes}) => '${hours} ч ${minutes} мин';
	@override String daysHours({required Object days, required Object hours}) => '${days} д ${hours} ч';
	@override String get now => 'сейчас';
}

// Path: scheduler.runStatus
class Translations$scheduler$runStatus$ru extends Translations$scheduler$runStatus$en {
	Translations$scheduler$runStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get fired => 'запущен';
	@override String get skipped => 'пропущен';
	@override String get failed => 'ошибка';
	@override String get completed => 'завершён';
}

// Path: scheduler.cronErrors
class Translations$scheduler$cronErrors$ru extends Translations$scheduler$cronErrors$en {
	Translations$scheduler$cronErrors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String fieldCount({required Object got}) => 'Ожидалось 5 полей, получено ${got}';
	@override String fieldError({required Object index, required Object error}) => 'Поле ${index}: ${error}';
	@override String get empty => 'пусто';
	@override String invalidPart({required Object part}) => 'недопустимо: «${part}»';
	@override String invalidValue({required Object value}) => 'недопустимое значение «${value}»';
}

// Path: serverConnect.local
class Translations$serverConnect$local$ru extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Это устройство';
	@override String get subtitle => 'Запустить сервер DDAgent на этой машине';
	@override String get install => 'Установить локальный сервер';
	@override String get start => 'Запустить локальный сервер';
	@override String get stop => 'Остановить';
	@override String get starting => 'Запуск локального сервера…';
	@override String downloading({required Object percent}) => 'Загрузка сервера… ${percent}%';
	@override String get installing => 'Установка…';
	@override String running({required Object url}) => 'Запущен по адресу ${url}';
	@override String installed({required Object version}) => 'Установлен (v${version})';
	@override String get connect => 'Использовать этот сервер';
	@override String error({required Object error}) => 'Ошибка локального сервера: ${error}';
	@override String get or => 'или подключитесь к удалённому серверу';
	@override late final Translations$serverConnect$local$errors$ru errors = Translations$serverConnect$local$errors$ru._(_root);
}

// Path: sessions.toasts
class Translations$sessions$toasts$ru extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Сессия архивирована';
	@override String get restored => 'Сессия восстановлена';
	@override String get deleted => 'Сессия удалена';
	@override String get renamed => 'Сессия переименована';
	@override String get pinned => 'Сессия закреплена';
	@override String get unpinned => 'Сессия откреплена';
	@override String get workspaceChanged => 'Рабочая область изменена';
}

// Path: sessions.age
class Translations$sessions$age$ru extends Translations$sessions$age$en {
	Translations$sessions$age$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get lessThanMinute => '<1 мин.';
	@override String minutes({required Object count}) => '${count} мин.';
	@override String hours({required Object hours}) => '${hours} ч.';
	@override String days({required Object days}) => '${days} дн.';
}

// Path: sessions.activity
class Translations$sessions$activity$ru extends Translations$sessions$activity$en {
	Translations$sessions$activity$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get subagentRunning => 'Выполняется субагент';
	@override String readingFile({required Object file}) => 'Чтение ${file}';
	@override String runningTool({required Object name}) => 'Выполнение ${name}';
	@override String editingFile({required Object file}) => 'Редактирование ${file}';
	@override String get editingFileGeneric => 'Редактирование файла';
	@override String get runningShellCommand => 'Выполнение команды оболочки';
	@override String runningCommand({required Object command}) => 'Выполнение `${command}`';
	@override String get committingChanges => 'Фиксация изменений';
	@override String get pushingBranch => 'Отправка ветки';
	@override String fetchingUrl({required Object url}) => 'Получение ${url}';
	@override String searching({required Object query}) => 'Поиск «${query}»';
}

// Path: skills.addDialog
class Translations$skills$addDialog$ru extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => 'Добавить навык ${provider}';
	@override String get chooseFileTitle => 'Выбрать SKILL.md';
	@override String get chooseFolderTitle => 'Выберите папку навыка';
	@override String get uploadHint => 'Загрузите файл SKILL.md или папку навыка целиком.';
	@override String get pickTitle => 'Выберите папку навыка или SKILL.md';
	@override String get pickHint => 'Папки могут содержать скрипты, справочные материалы и ресурсы.';
	@override String get chooseFiles => 'Выбрать файлы';
	@override String get chooseFolder => 'Выбрать папку';
	@override String get readyToInstall => 'Готово к установке';
	@override String markdownFileMeta({required Object size}) => 'Файл Markdown · ${size}';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} файл · ${size}',
		other: '${count} файлов · ${size}',
	);
	@override String removeQueued({required Object name}) => 'Удалить ${name}';
	@override String get whereWillThisInstall => 'Куда это установится?';
	@override String get hideInstallLocation => 'Скрыть место установки';
	@override String get folderUploadsNote => 'При загрузке папки сохраняется её имя; для отдельных файлов используется `name` из `SKILL.md`.';
	@override String get installSkill => 'Установить навык';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'Установить ${count} навык',
		other: 'Установить ${count} навыков',
	);
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$ru extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get toProjectHint => 'Выберите проект, которому будет принадлежать этот навык. Он будет перемещён из глобальной папки навыков провайдера.';
	@override String get toGlobalHint => 'Переместите этот навык в глобальную папку навыков, чтобы его могли использовать все проекты.';
	@override String get moveToProject => 'Переместить в проект';
	@override String get moveToGlobal => 'Переместить в глобальные';
}

// Path: skills.screen
class Translations$skills$screen$ru extends Translations$skills$screen$en {
	Translations$skills$screen$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String manageDescription({required Object provider}) => 'Управляйте навыками ${provider} из локальных файлов, папок целиком и мест, зависящих от проекта.';
	@override String get searchHint => 'Поиск навыков…';
	@override String get clearSearch => 'Очистить поиск навыков';
	@override String get addSkill => 'Добавить навык';
	@override String get scanningProjectSkills => 'Сканирование навыков проекта…';
	@override String get savedSuccessfully => 'Навыки успешно сохранены.';
	@override String loadingSkills({required Object provider}) => 'Загрузка навыков ${provider}…';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} НАВЫК',
		other: '${count} НАВЫКОВ',
	);
	@override String deleteTitle({required Object name}) => 'Удалить ${name}?';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Это удалит папку ${directory} из управляемой папки навыков ${provider}. Действие необратимо.';
	@override String get noDescription => 'Описание не указано во front matter навыка.';
	@override String pluginBadge({required Object name}) => 'Плагин: ${name}';
	@override String projectBadge({required Object name}) => 'Проект: ${name}';
	@override String get sourceLabel => 'ИСТОЧНИК';
}

// Path: skills.empty
class Translations$skills$empty$ru extends Translations$skills$empty$en {
	Translations$skills$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get noProjects => 'Нет доступных проектов';
	@override String get noProjectsDescription => 'Добавьте проект или рабочую область, чтобы просмотреть его навыки.';
	@override String get noSkillsInProject => 'В этом проекте нет навыков';
	@override String get noSkillsInProjectDescription => 'Создайте папку .claude/skills, .cursor/skills или .agents/skills в выбранном проекте.';
	@override String get noGlobalSkills => 'Глобальные навыки пока не найдены';
	@override String get noGlobalSkillsDescription => 'Добавьте глобальный навык выше, чтобы он был доступен во всех проектах.';
	@override String get noMatchingSkills => 'Нет подходящих навыков';
	@override String get noMatchingSkillsDescription => 'Попробуйте другую команду, имя, область, проект или исходный путь.';
}

// Path: skills.scopes
class Translations$skills$scopes$ru extends Translations$skills$scopes$en {
	Translations$skills$scopes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get user => 'Пользователь';
	@override String get plugin => 'Плагин';
	@override String get repo => 'Репозиторий';
	@override String get project => 'Проект';
	@override String get admin => 'Администратор';
	@override String get system => 'Система';
}

// Path: skills.errors
class Translations$skills$errors$ru extends Translations$skills$errors$en {
	Translations$skills$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get dropMarkdownOrFolder => 'Перетащите один или несколько файлов markdown или папку с SKILL.md.';
	@override String get addMarkdownFirst => 'Сначала добавьте один или несколько файлов markdown.';
	@override String get importFailed => 'Не удалось импортировать навыки';
	@override String get folderReadFailed => 'Не удалось прочитать папку навыка';
	@override String folderFileLimit({required Object count}) => 'Папка навыка может содержать до ${count} файлов.';
	@override String get folderSizeLimit => 'Общий размер выбранных папок навыков должен быть меньше 30 МБ.';
	@override String get missingSkillFile => 'В выбранной папке нет файла SKILL.md.';
	@override String couldNotReadSkillFile({required Object name}) => 'Не удалось прочитать SKILL.md из ${name}.';
}

// Path: terminal.tabs
class Translations$terminal$tabs$ru extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String shellName({required Object index}) => 'Оболочка ${index}';
	@override String get plainShell => 'Простая оболочка';
	@override String get claudeCli => 'Claude CLI';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'Вход: ${provider}';
	@override String runTitle({required Object command}) => 'Запуск: ${command}';
}

// Path: terminal.actions
class Translations$terminal$actions$ru extends Translations$terminal$actions$en {
	Translations$terminal$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newTab => 'Новая вкладка терминала';
	@override String get providerLogin => 'Вход в провайдер';
	@override String get restartSession => 'Перезапустить сессию';
	@override String get clearOutput => 'Очистить вывод';
	@override String get newShell => 'Новая оболочка';
	@override String get connect => 'Подключить';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$ru extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Открыть в браузере';
	@override String linkLabel({required Object url}) => 'Ссылка для входа: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$ru extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'Обнаружен файл: ${path}';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$ru extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get interrupt => 'Прервать (SIGINT)';
	@override String get eof => 'EOF';
	@override String get suspend => 'Приостановить (SIGTSTP)';
	@override String get hide => 'Скрыть панель горячих клавиш';
	@override String get showTooltip => 'Показать горячие клавиши';
	@override String get hideTooltip => 'Скрыть горячие клавиши';
}

// Path: terminal.paste
class Translations$terminal$paste$ru extends Translations$terminal$paste$en {
	Translations$terminal$paste$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Вставить в терминал';
	@override String get hint => 'Ctrl+V / правый клик → Вставить';
}

// Path: terminal.errors
class Translations$terminal$errors$ru extends Translations$terminal$errors$en {
	Translations$terminal$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'Не удалось открыть ссылку: ${url}';
	@override String frameError({required Object message}) => '[Ошибка] ${message}';
	@override String connectionError({required Object message}) => '[Ошибка подключения] ${message}';
}

// Path: terminal.loginDialog
class Translations$terminal$loginDialog$ru extends Translations$terminal$loginDialog$en {
	Translations$terminal$loginDialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => 'Вход в ${provider} CLI';
	@override String exited({required Object code}) => 'Завершено (${code})';
	@override String get authLinkDetected => 'Обнаружена ссылка для аутентификации';
}

// Path: terminal.empty
class Translations$terminal$empty$ru extends Translations$terminal$empty$en {
	Translations$terminal$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Нет активного терминала';
	@override String get description => 'Создайте новую вкладку, чтобы начать';
}

// Path: terminal.overlay
class Translations$terminal$overlay$ru extends Translations$terminal$overlay$en {
	Translations$terminal$overlay$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get processExited => 'Процесс завершён — подключитесь, чтобы запустить его снова';
	@override String processExitedWithCode({required Object code}) => 'Процесс завершён (код ${code}) — подключитесь, чтобы запустить его снова';
	@override String resumeSession({required Object title}) => 'Возобновить сеанс ${title}';
	@override String startSession({required Object path}) => 'Начать новый сеанс в ${path}';
}

// Path: workspace.paneTitle
class Translations$workspace$paneTitle$ru extends Translations$workspace$paneTitle$en {
	Translations$workspace$paneTitle$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Чат';
	@override String get browser => 'Браузер';
	@override String get terminal => 'Терминал';
	@override String get notes => 'Общие заметки';
	@override String get editor => 'Редактор';
	@override String get git => 'Git';
}

// Path: worktrees.runtimeStatus
class Translations$worktrees$runtimeStatus$ru extends Translations$worktrees$runtimeStatus$en {
	Translations$worktrees$runtimeStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get idle => 'простаивает';
	@override String get running => 'выполняется';
	@override String get done => 'готово';
	@override String get failed => 'ошибка';
	@override String get exited => 'завершён';
}

// Path: browserUse.sessionStatus
class Translations$browserUse$sessionStatus$ru extends Translations$browserUse$sessionStatus$en {
	Translations$browserUse$sessionStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get ready => 'Готова';
	@override String get stopped => 'Остановлена';
	@override String get unavailable => 'Недоступна';
}

// Path: miniOrchestrator.taskTypes
class Translations$miniOrchestrator$taskTypes$ru extends Translations$miniOrchestrator$taskTypes$en {
	Translations$miniOrchestrator$taskTypes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get gate => 'Шлюз';
}

// Path: miniOrchestrator.roles
class Translations$miniOrchestrator$roles$ru extends Translations$miniOrchestrator$roles$en {
	Translations$miniOrchestrator$roles$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get thinker => 'Мыслитель';
	@override String get worker => 'Исполнитель';
}

// Path: auth.login.errors
class Translations$auth$login$errors$ru extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Неверное имя пользователя или пароль';
	@override String get requiredFields => 'Пожалуйста, заполните все поля';
	@override String get networkError => 'Ошибка сети. Попробуйте снова.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$ru extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get username => 'Введите имя пользователя';
	@override String get password => 'Введите пароль';
}

// Path: auth.register.errors
class Translations$auth$register$errors$ru extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Пароли не совпадают';
	@override String get usernameTaken => 'Имя пользователя уже занято';
	@override String get weakPassword => 'Пароль слишком слабый';
	@override String get usernameTooShort => 'Имя пользователя должно содержать не менее 3 символов';
	@override String get passwordTooShort => 'Пароль должен содержать не менее 6 символов';
}

// Path: chat.orchestrator.routing
class Translations$chat$orchestrator$routing$ru extends Translations$chat$orchestrator$routing$en {
	Translations$chat$orchestrator$routing$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Маршрутизация';
	@override String alternatives({required Object list}) => 'Альтернативы: ${list}';
	@override String first({required Object label, required Object task}) => '${label} — первый кандидат для ${task}';
	@override String skipped({required Object label, required Object list}) => '${label} — предыдущие кандидаты пропущены (${list})';
}

// Path: chat.orchestrator.plan
class Translations$chat$orchestrator$plan$ru extends Translations$chat$orchestrator$plan$en {
	Translations$chat$orchestrator$plan$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'План';
	@override String get disabled => 'отключён';
	@override String get awaitingConfirm => 'Ожидание подтверждения плана.';
	@override String get run => 'Запустить план';
	@override String get toggleStep => 'Включить шаг';
	@override String get confirmFailed => 'Не удалось запустить — попробуйте снова.';
	@override String get fallback => 'планировщик недоступен — запасной вариант в один шаг';
	@override String get templateSource => 'из шаблона конвейера';
	@override String get offSource => 'планировщик выключен';
	@override String stepCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} шаг',
		few: '${count} шага',
		many: '${count} шагов',
		other: '${count} шага',
	);
	@override String get supervisedSource => 'контролируемый цикл';
}

// Path: chat.orchestrator.decision
class Translations$chat$orchestrator$decision$ru extends Translations$chat$orchestrator$decision$en {
	Translations$chat$orchestrator$decision$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Решение супервизора';
	@override String iteration({required Object n}) => 'итерация ${n}';
	@override String get rationaleLabel => 'Почему';
	@override String get awaitingConfirm => 'Ожидается ваше одобрение перед выполнением этих шагов.';
	@override String get proposedSteps => 'Предложенные шаги';
	@override late final Translations$chat$orchestrator$decision$action$ru action = Translations$chat$orchestrator$decision$action$ru._(_root);
	@override late final Translations$chat$orchestrator$decision$outcome$ru outcome = Translations$chat$orchestrator$decision$outcome$ru._(_root);
}

// Path: chat.orchestrator.delegation
class Translations$chat$orchestrator$delegation$ru extends Translations$chat$orchestrator$delegation$en {
	Translations$chat$orchestrator$delegation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Делегированный шаг';
	@override String get openSession => 'Открыть полный сеанс';
	@override String attempt({required Object n}) => 'попытка ${n}';
	@override String get retryStep => 'Повторить / Исправить';
	@override String get continueStep => 'Продолжить / Исправить';
	@override String get continueFailed => 'Ошибка — попробуйте снова.';
	@override late final Translations$chat$orchestrator$delegation$status$ru status = Translations$chat$orchestrator$delegation$status$ru._(_root);
	@override String attempts({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} попытка',
		few: '${count} попытки',
		many: '${count} попыток',
		other: '${count} попытки',
	);
	@override String candidates({required Object list}) => 'кандидаты: ${list}';
	@override String candidateCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} кандидат',
		few: '${count} кандидата',
		many: '${count} кандидатов',
		other: '${count} кандидата',
	);
}

// Path: chat.orchestrator.summary
class Translations$chat$orchestrator$summary$ru extends Translations$chat$orchestrator$summary$en {
	Translations$chat$orchestrator$summary$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Итоги';
	@override String progress({required Object done, required Object total}) => 'Выполнено шагов: ${done}/${total}';
	@override String get aborted => 'прервано';
	@override String get timedOut => 'истекло время ожидания';
	@override String get capped => 'лимит итераций';
	@override String failed({required Object list}) => 'Шаги с ошибкой: ${list}';
	@override String get kContinue => 'Продолжить';
	@override String get continueWork => 'Продолжить работу';
	@override String get resumeFailed => 'Не удалось возобновить — попробуйте снова.';
	@override String get runNextTask => 'Запустить следующую задачу';
	@override String get endAllTasks => 'Завершить все задачи';
	@override String get tasksRunning => 'Выполнение задач…';
	@override String get cancelTasks => 'Отмена';
}

// Path: chat.orchestrator.taskmaster
class Translations$chat$orchestrator$taskmaster$ru extends Translations$chat$orchestrator$taskmaster$en {
	Translations$chat$orchestrator$taskmaster$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Очередь задач';
	@override String remaining({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: 'осталась ${count}',
		few: 'осталось ${count}',
		many: 'осталось ${count}',
		other: 'осталось ${count}',
	);
	@override late final Translations$chat$orchestrator$taskmaster$status$ru status = Translations$chat$orchestrator$taskmaster$status$ru._(_root);
}

// Path: chat.orchestrator.gate
class Translations$chat$orchestrator$gate$ru extends Translations$chat$orchestrator$gate$en {
	Translations$chat$orchestrator$gate$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'истекло время ожидания';
	@override String exit({required Object code}) => 'код выхода ${code}';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$ru extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Режим по умолчанию';
	@override String get auto => 'Авторежим';
	@override String get acceptEdits => 'Принимать правки';
	@override String get bypassPermissions => 'Обход разрешений';
	@override String get plan => 'Режим планирования';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$ru extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Только доверенные команды (ls, cat, grep, git status и т.д.) выполняются автоматически. Другие команды пропускаются. Может записывать в рабочее пространство.';
	@override String get auto => 'Классификатор модели решает для каждого вызова инструмента, одобрить или отклонить. Высокая автономность.';
	@override String get acceptEdits => 'Все команды выполняются автоматически в рабочем пространстве. Полный автоматический режим с изолированным выполнением.';
	@override String get bypassPermissions => 'Полный системный доступ без ограничений. Все команды выполняются автоматически с полным доступом к диску и сети. Используйте с осторожностью.';
	@override String get plan => 'Режим планирования - команды не выполняются';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$ru extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter — отправить • / — команды • @ — файлы';
	@override String get enter => 'Enter — отправить • Shift+Enter — новая строка • / — команды • @ — файлы';
	@override String get queue => 'Enter — поставить следующее сообщение в очередь';
	@override String get updateQueued => 'Enter — обновить сообщение в очереди';
}

// Path: chat.input.queue
class Translations$chat$input$queue$ru extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Поставить следующее сообщение в очередь';
	@override String get update => 'Обновить сообщение в очереди';
	@override String get label => 'В очереди';
	@override String get willSend => 'Будет отправлено после завершения';
	@override String get edit => 'Редактировать сообщение в очереди';
	@override String get delete => 'Удалить сообщение из очереди';
	@override String get failed => 'Не удалось отправить';
	@override String get sendNow => 'Отправить сейчас';
	@override String get sendNowAfterTurn => 'Этот агент не принимает сообщения во время хода — оно будет отправлено после текущего хода';
	@override String filesAttached({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count,
		one: '${count} файл прикреплён',
		few: '${count} файла прикреплено',
		many: '${count} файлов прикреплено',
		other: '${count} файла прикреплено',
	);
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$ru extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Отменить и очистить офлайн-очередь';
	@override String get clearBtn => 'Отмена';
	@override String multiple({required Object count}) => '${count} сообщений в офлайн-очереди — отправятся автоматически при переподключении';
	@override String get single => '1 сообщение в офлайн-очереди — отправится автоматически при переподключении';
}

// Path: chat.composer.effortLevels
class Translations$chat$composer$effortLevels$ru extends Translations$chat$composer$effortLevels$en {
	Translations$chat$composer$effortLevels$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get off => 'Выкл.';
	@override String get none => 'Нет';
	@override String get minimal => 'Минимальный';
	@override String get low => 'Низкий';
	@override String get medium => 'Средний';
	@override String get high => 'Высокий';
	@override String get xhigh => 'Очень высокий';
	@override String get max => 'Максимальный';
	@override String get ultra => 'Ультра';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$ru extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'от Anthropic';
	@override String get openai => 'от OpenAI';
	@override String get cursorEditor => 'AI редактор кода';
	@override String get google => 'от Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$ru extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Готов использовать Claude с ${model}. Начните вводить сообщение ниже.';
	@override String cursor({required Object model}) => 'Готов использовать Cursor с ${model}. Начните вводить сообщение ниже.';
	@override String codex({required Object model}) => 'Готов использовать Codex с ${model}. Начните вводить сообщение ниже.';
	@override String opencode({required Object model}) => 'OpenCode с ${model} готов к работе. Начните вводить сообщение ниже.';
	@override String get kDefault => 'Выберите провайдера выше для начала';
	@override String devin({required Object model}) => 'Готово с Devin ${model}';
	@override String get orchestrator => 'Готово в режиме Авто — маршрутизатор выбирает лучшую модель для каждого шага';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$ru extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Продолжить разговор';
	@override String get description => 'Задавайте вопросы о вашем коде, запрашивайте изменения или получайте помощь с задачами разработки';
	@override String get action => 'Продолжить ввод';
}

// Path: chat.session.loading
class Translations$chat$session$loading$ru extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Загрузка старых сообщений...';
	@override String get sessionMessages => 'Загрузка сообщений сеанса...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$ru extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => 'Показано ${shown} из ${total} сообщений';
	@override String get scrollToLoad => 'Прокрутите вверх для загрузки еще';
	@override String showingLast({required Object count, required Object total}) => 'Показаны последние ${count} сообщений (всего ${total})';
	@override String get loadEarlier => 'Загрузить более ранние сообщения';
	@override String get loadOlderFailed => 'Не удалось загрузить старые сообщения.';
	@override String get retry => 'Повторить';
	@override String get loadAll => 'Загрузить все сообщения';
	@override String get loadingAll => 'Загрузка всех сообщений...';
	@override String get allLoaded => 'Все сообщения загружены';
	@override String get perfWarning => 'Все сообщения загружены — прокрутка может быть медленнее. Нажмите "Прокрутить вниз" для восстановления производительности.';
	@override String get noSearchMatches => 'Нет сообщений, соответствующих запросу.';
	@override String get loadOlder => 'Загрузить старые сообщения';
	@override String loadAllCount({required Object count}) => 'Загрузить все (${count})';
	@override String retryLoadOlder({required Object error}) => 'Повторить загрузку старых — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$ru extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Выберите проект';
	@override String get description => 'Выберите проект для открытия интерактивной оболочки в этом каталоге';
}

// Path: chat.shell.status
class Translations$chat$shell$status$ru extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Новый сеанс';
	@override String get initializing => 'Инициализация...';
	@override String get restarting => 'Перезапуск...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$ru extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Отключиться';
	@override String get disconnectTitle => 'Отключиться от оболочки';
	@override String get restart => 'Перезапустить';
	@override String get restartTitle => 'Перезапустить оболочку (сначала отключитесь)';
	@override String get kill => 'Завершить (SIGINT)';
	@override String get killTitle => 'Завершить выполняющийся процесс (Ctrl+C)';
	@override String get copyOutput => 'Копировать вывод';
	@override String get copyOutputTitle => 'Копировать вывод терминала';
	@override String get copied => 'Скопировано!';
	@override String get zoomInTitle => 'Увеличить';
	@override String get zoomOutTitle => 'Уменьшить';
	@override String get connect => 'Продолжить в оболочке';
	@override String get connectTitle => 'Подключиться к оболочке';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$ru extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Думает';
	@override String get processing => 'Обрабатывает';
	@override String get analyzing => 'Анализирует';
	@override String get working => 'Работает';
	@override String get computing => 'Вычисляет';
	@override String get reasoning => 'Рассуждает';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$ru extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get live => 'В сети';
	@override String get paused => 'Приостановлен';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$ru extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}с';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}м ${seconds}с';
	@override String label({required Object time}) => 'Прошло ${time}';
	@override String get startingNow => 'Начинается сейчас';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$ru extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Остановить генерацию';
	@override String get pressEscToStop => 'Нажмите Esc в любое время для остановки';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$ru extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Ассистент';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$ru extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get models => 'Просмотрите доступные модели для активного провайдера.';
	@override String get cost => 'Просмотрите использование токенов для активной сессии.';
	@override String get status => 'Проверьте состояние среды выполнения, версии, провайдера и окружения.';
	@override String get memory => 'Откройте файл памяти CLAUDE.md проекта.';
	@override String get config => 'Откройте настройки и конфигурацию.';
	@override String get help => 'Показать документацию и синтаксис команд.';
}

// Path: chat.permissionRequest.recap
class Translations$chat$permissionRequest$recap$ru extends Translations$chat$permissionRequest$recap$en {
	Translations$chat$permissionRequest$recap$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'Время истекло — отклонено автоматически';
	@override String get cancelled => 'Отменено — ход был остановлен';
	@override String get autoApproved => 'Подтверждено автоматически';
	@override String get expired => 'Срок запроса истёк — агент больше его не ждёт';
	@override String get answered => 'Отвечено';
	@override String get skipped => 'Пропущено';
	@override String get decided => 'Решено';
}

// Path: chat.commandDialog.help
class Translations$chat$commandDialog$help$ru extends Translations$chat$commandDialog$help$en {
	Translations$chat$commandDialog$help$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Командный центр';
	@override String get title => 'Справка и горячие клавиши';
	@override String get subtitle => 'Поиск встроенных команд, шаблонов синтаксиса и способов использования.';
}

// Path: chat.commandDialog.models
class Translations$chat$commandDialog$models$ru extends Translations$chat$commandDialog$models$en {
	Translations$chat$commandDialog$models$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Выбор модели';
	@override String get title => 'Выберите модель';
	@override String get subtitle => 'Выберите модель, которую будет использовать этот провайдер.';
	@override String modelSetTo({required Object model}) => 'Выбрана модель ${model}.';
	@override String get activeModel => 'Активная модель';
	@override String get noModelsMatch => 'Нет моделей, соответствующих фильтру.';
	@override String get choiceSavedForSession => 'Ваш выбор сохраняется для этой сессии и становится значением по умолчанию для новых чатов.';
	@override String get choiceDefault => 'Выбранная модель станет моделью по умолчанию для новых чатов.';
	@override String get custom => 'Свой';
	@override String get currentSelection => 'Текущий выбор';
}

// Path: chat.commandDialog.cost
class Translations$chat$commandDialog$cost$ru extends Translations$chat$commandDialog$cost$en {
	Translations$chat$commandDialog$cost$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Телеметрия сессии';
	@override String get title => 'Использование токенов';
	@override String get subtitle => 'Количество входных, выходных и всего токенов в этой сессии.';
	@override String get totalTokensUsed => 'Всего использовано токенов';
	@override String get inputTokens => 'Входные токены';
	@override String get cacheReadTokens => 'Токены чтения из кэша';
	@override String get cacheWriteTokens => 'Токены записи в кэш';
	@override String get outputTokens => 'Выходные токены';
	@override String get breakdown => 'Детализация';
	@override String get unavailable => 'Недоступно';
	@override String get contextWindow => 'Окно контекста';
	@override String get estimatedCost => 'Примерная стоимость';
}

// Path: chat.commandDialog.status
class Translations$chat$commandDialog$status$ru extends Translations$chat$commandDialog$status$en {
	Translations$chat$commandDialog$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Состояние среды';
	@override String get title => 'Состояние системы';
	@override String get subtitle => 'Версия, провайдер, среда выполнения и сведения об окружении.';
	@override String get package => 'Пакет';
	@override String get uptime => 'Время работы';
	@override String get platform => 'Платформа';
	@override String get memory => 'Память';
	@override String memoryRss({required Object mb}) => '${mb} МБ RSS';
	@override String get runtimeOnline => 'Среда работает';
	@override String processResponding({required Object pid}) => 'Процесс #${pid} отвечает.';
	@override String get processStatusResponding => 'Процесс отвечает.';
	@override String get healthy => 'Исправно';
}

// Path: chat.commandDialog.syntax
class Translations$chat$commandDialog$syntax$ru extends Translations$chat$commandDialog$syntax$en {
	Translations$chat$commandDialog$syntax$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Синтаксис';
	@override String arguments({required Object arguments, required Object first, required Object second}) => '${arguments} передаёт все аргументы; ${first}, ${second} — позиционные.';
	@override String file({required Object token}) => '${token} вставляет содержимое файла.';
	@override String bash({required Object token}) => '${token} запускает bash.';
}

// Path: chat.utilities.tooltip
class Translations$chat$utilities$tooltip$ru extends Translations$chat$utilities$tooltip$en {
	Translations$chat$utilities$tooltip$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String tokensUsed({required Object tokens}) => 'использовано токенов: ${tokens}';
	@override String contextOf({required Object percent, required Object total}) => 'контекст ${percent}% из ${total}';
	@override String input({required Object value}) => 'вход ${value}';
	@override String cache({required Object read, required Object write}) => 'кэш: чтение ${read} · запись ${write}';
	@override String output({required Object value}) => 'выход ${value}';
}

// Path: chat.toolBlocks.status
class Translations$chat$toolBlocks$status$ru extends Translations$chat$toolBlocks$status$en {
	Translations$chat$toolBlocks$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get running => 'Выполняется';
	@override String get denied => 'Отклонено';
}

// Path: chat.toolBlocks.verbs
class Translations$chat$toolBlocks$verbs$ru extends Translations$chat$toolBlocks$verbs$en {
	Translations$chat$toolBlocks$verbs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get read => 'чтение';
	@override String get write => 'запись';
	@override String get edit => 'правка';
	@override String get delete => 'удаление';
	@override String get move => 'перемещение';
}

// Path: chat.commandMenu.namespaces
class Translations$chat$commandMenu$namespaces$ru extends Translations$chat$commandMenu$namespaces$en {
	Translations$chat$commandMenu$namespaces$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get frequent => 'Часто используемые';
	@override String get builtin => 'Встроенные команды';
	@override String get skill => 'Навыки';
	@override String get project => 'Команды проекта';
	@override String get user => 'Пользовательские команды';
	@override String get other => 'Другие команды';
}

// Path: chat.mentionMenu.kinds
class Translations$chat$mentionMenu$kinds$ru extends Translations$chat$mentionMenu$kinds$en {
	Translations$chat$mentionMenu$kinds$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get file => 'файл';
	@override String get session => 'сессия';
	@override String get task => 'задача';
}

// Path: common.quota.section
class Translations$common$quota$section$ru extends Translations$common$quota$section$en {
	Translations$common$quota$section$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Обзор';
	@override String get quotas => 'Квоты';
	@override String get usage => 'Использование';
	@override String get agents => 'Агенты';
}

// Path: common.quota.filter
class Translations$common$quota$filter$ru extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get all => 'Все';
}

// Path: common.quota.period
class Translations$common$quota$period$ru extends Translations$common$quota$period$en {
	Translations$common$quota$period$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 дней';
	@override String get k30d => '30 дней';
	@override String get all => 'Все';
}

// Path: common.quota.group
class Translations$common$quota$group$ru extends Translations$common$quota$group$en {
	Translations$common$quota$group$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Провайдер';
	@override String get model => 'Модель';
	@override String get agent => 'Агент';
	@override String get tool => 'Инструмент';
}

// Path: common.quota.metric
class Translations$common$quota$metric$ru extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Токены';
	@override String get input => 'Ввод';
	@override String get output => 'Вывод';
	@override String get cache => 'Чтения кэша';
	@override String get calls => 'Вызовы API';
	@override String get cost => 'Стоимость';
	@override String get sessions => 'Сессии';
}

// Path: common.quota.cost
class Translations$common$quota$cost$ru extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Оплачено (API + перерасход)';
	@override String get listPrice => 'Прейскурантная цена использованных токенов';
	@override String get subscriptionValue => 'Покрыто подписками';
	@override String get cacheSavings => 'Экономия кэша';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$ru extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Оплачено (API + перерасход)';
	@override String get listPrice => 'Прейскурантная цена использованных токенов';
	@override String get subscriptionValue => 'Покрыто подписками';
}

// Path: common.quota.overview
class Translations$common$quota$overview$ru extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Токены и стоимость — последние 7 дней';
	@override String get effectiveCost => 'Фактическая стоимость (7 дней)';
	@override String get alertsTitle => 'Оповещения';
	@override String get noAlerts => 'Сейчас ничего не требует внимания.';
	@override String get limitsTitle => 'Использование и лимиты';
	@override String get activeTasks => 'Активные задачи';
	@override String get viewAccounts => 'Все аккаунты';
	@override String get viewAgents => 'Все агенты';
	@override String get noTasks => 'Сейчас нет выполняющихся агентов.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$ru extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Дневной тренд';
	@override String breakdownTitle({required Object group}) => 'Разбивка по ${group}';
	@override String get colName => 'Имя';
	@override String get sourceUnavailable => 'Хранилище аналитики недоступно; данные не показаны.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$ru extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} выполняется';
	@override String get colAgent => 'Агент';
	@override String get colStatus => 'Статус';
	@override String get colTask => 'Задача';
	@override String get colModel => 'Аккаунт / модель';
	@override String get colTime => 'Время';
	@override String get empty => 'Нет агентов, соответствующих фильтру.';
	@override String get detailSession => 'Сессия';
	@override String get detailStarted => 'Запущено';
	@override String get detailRetries => 'Повторы';
	@override String get detailResult => 'Результат';
	@override String get notTracked => 'не отслеживается';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$ru extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get running => 'Выполняется';
	@override String get waiting => 'Ожидание';
	@override String get failed => 'Ошибка';
	@override String get finished => 'Завершено';
	@override String get queued => 'В очереди';
}

// Path: common.quota.alert
class Translations$common$quota$alert$ru extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: при текущем темпе лимит исчерпается через ${value}';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: использовано ${value}% (порог ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$ru extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get live => 'Live';
	@override String get cached => 'Кэшировано';
	@override String get estimate => 'Оценка';
	@override String get unknown => 'Неизвестно';
	@override String get error => 'Ошибка';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$ru extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Лимиты под угрозой';
	@override String atRiskHint({required Object value}) => 'аккаунтов выше ${value}%';
	@override String get windowsAtRisk => 'Исчерпывающиеся окна';
	@override String get errored => 'Сбои синхронизации';
	@override String get activeAgents => 'Активные агенты';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} ожидают · ${queued} в очереди';
	@override String get nextReset => 'Следующий сброс';
	@override String get tokens => 'Токены';
	@override String sessionsHint({required Object value}) => '${value} сессий';
	@override String get cost => 'Оценочная стоимость';
	@override String costHint({required Object value}) => '${value} покрыто планами';
}

// Path: common.quota.empty
class Translations$common$quota$empty$ru extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Нет подключённых аккаунтов';
	@override String get description => 'Войдите в Claude, Codex, Gemini или CommandCode, чтобы квоты отслеживались здесь.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$ru extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Оповещения и маршрутизация';
	@override String get description => 'Управляйте тем, когда панель предупреждает вас и как предлагаются аккаунты для новой работы.';
	@override String get alertsEnabled => 'Прогнозные и пороговые оповещения';
	@override String get alertsEnabledHint => 'Предупреждать до исчерпания лимита при текущем темпе, а не только на 90%.';
	@override String get watchThreshold => 'Порог наблюдения (%)';
	@override String get dangerThreshold => 'Порог опасности (%)';
	@override String get routingMode => 'Маршрутизация';
	@override late final Translations$common$quota$settings$routing$ru routing = Translations$common$quota$settings$routing$ru._(_root);
	@override String get logSources => 'Источники журналов';
	@override String get logSourcesHint => 'Экраны использования и агентов читают эти источники только для чтения.';
	@override String get quotaConsent => 'Разрешить опрос квот';
	@override String get quotaConsentHint => 'Опрашивает эндпоинты провайдеров с вашими сохранёнными учётными данными для чтения лимитов в реальном времени.';
	@override String get perAccount => 'Переопределения по аккаунтам';
	@override String get tab => 'Настройки Control Center';
}

// Path: common.quota.range
class Translations$common$quota$range$ru extends Translations$common$quota$range$en {
	Translations$common$quota$range$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Все';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$ru extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Переименовать';
	@override String get delete => 'Удалить';
	@override String get copyPath => 'Копировать путь';
	@override String get download => 'Скачать';
	@override String get newFile => 'Новый файл';
	@override String get newFolder => 'Новая папка';
	@override String get upload => 'Загрузить файлы';
	@override String get refresh => 'Обновить';
	@override String get menuLabel => 'Контекстное меню файла';
	@override String get loading => 'Загрузка...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$ru extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Удалить';
	@override String get fileWarning => 'Этот файл будет удалён безвозвратно.';
	@override String get folderWarning => 'Эта папка и всё её содержимое будут удалены безвозвратно.';
	@override String title({required Object type}) => 'Удалить ${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$ru extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'Не удалось скопировать путь';
	@override String get fileCreated => 'Файл успешно создан';
	@override String get fileDeleted => 'Файл удалён';
	@override String get folderCreated => 'Папка успешно создана';
	@override String get folderDeleted => 'Папка удалена';
	@override String get folderDownloaded => 'Папка скачана как ZIP';
	@override String get pathCopied => 'Путь скопирован в буфер обмена';
	@override String get renamed => 'Успешно переименовано';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$ru extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'Имя файла не может состоять только из точек';
	@override String get emptyName => 'Имя файла не может быть пустым';
	@override String get invalidChars => 'Имя файла содержит недопустимые символы';
	@override String get reserved => 'Имя файла является зарезервированным';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$ru extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get type => 'Тип';
	@override String get configure => 'Настройка';
	@override String get confirm => 'Подтверждение';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$ru extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get question => 'У вас уже есть рабочее пространство или вы хотите создать новое?';
	@override late final Translations$common$projectWizard$step1$existing$ru existing = Translations$common$projectWizard$step1$existing$ru._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$ru kNew = Translations$common$projectWizard$step1$kNew$ru._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$ru extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Путь к рабочему пространству';
	@override String get newPath => 'Путь к рабочему пространству';
	@override String get existingPlaceholder => '/путь/к/существующему/пространству';
	@override String get newPlaceholder => '/путь/к/новому/пространству';
	@override String get existingHelp => 'Полный путь к каталогу вашего рабочего пространства';
	@override String get newHelp => 'Полный путь к каталогу вашего рабочего пространства';
	@override String get githubUrl => 'URL GitHub (необязательно)';
	@override String get githubPlaceholder => 'https://github.com/username/repository';
	@override String get githubHelp => 'Необязательно: укажите URL GitHub для клонирования репозитория';
	@override String get githubAuth => 'Аутентификация GitHub (необязательно)';
	@override String get githubAuthHelp => 'Требуется только для приватных репозиториев. Публичные репозитории можно клонировать без аутентификации.';
	@override String get loadingTokens => 'Загрузка сохраненных токенов...';
	@override String get storedToken => 'Сохраненный токен';
	@override String get newToken => 'Новый токен';
	@override String get nonePublic => 'Нет (публичный)';
	@override String get selectToken => 'Выбрать токен';
	@override String get selectTokenPlaceholder => '-- Выберите токен --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Этот токен будет использован только для этой операции';
	@override String get publicRepoInfo => 'Публичные репозитории не требуют аутентификации. Вы можете пропустить токен при клонировании публичного репозитория.';
	@override String get noTokensHelp => 'Нет доступных сохраненных токенов. Вы можете добавить токены в Настройки → API ключи для удобного повторного использования.';
	@override String get optionalTokenPublic => 'Токен GitHub (необязательно для публичных репозиториев)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (оставьте пустым для публичных репозиториев)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$ru extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Проверьте вашу конфигурацию';
	@override String get existingWorkspace => 'Существующее рабочее пространство';
	@override String get newWorkspace => 'Новое рабочее пространство';
	@override String get path => 'Путь:';
	@override String get cloneFrom => 'Клонировать из:';
	@override String get authentication => 'Аутентификация:';
	@override String get usingStoredToken => 'Использование сохраненного токена:';
	@override String get usingProvidedToken => 'Использование предоставленного токена';
	@override String get noAuthentication => 'Без аутентификации';
	@override String get sshKey => 'SSH ключ';
	@override String get existingInfo => 'Рабочее пространство будет добавлено в список проектов и будет доступно для сеансов Claude/Cursor.';
	@override String get newWithClone => 'Репозиторий будет клонирован в эту папку.';
	@override String get newEmpty => 'Рабочее пространство будет добавлено в список проектов и будет доступно для сеансов Claude/Cursor.';
	@override String get cloningRepository => 'Клонирование репозитория...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$ru extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get back => 'Назад';
	@override String get next => 'Далее';
	@override String get createProject => 'Создать проект';
	@override String get creating => 'Создание...';
	@override String get cloning => 'Клонирование...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$ru extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Пожалуйста, выберите, есть ли у вас существующее рабочее пространство или вы хотите создать новое';
	@override String get providePath => 'Пожалуйста, укажите путь к рабочему пространству';
	@override String get failedToCreate => 'Не удалось создать рабочее пространство';
	@override String get failedToCreateFolder => 'Не удалось создать папку';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$ru extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$ru generic = Translations$common$notifications$codes$generic$ru._(_root);
	@override late final Translations$common$notifications$codes$permission$ru permission = Translations$common$notifications$codes$permission$ru._(_root);
	@override late final Translations$common$notifications$codes$run$ru run = Translations$common$notifications$codes$run$ru._(_root);
	@override late final Translations$common$notifications$codes$agent$ru agent = Translations$common$notifications$codes$agent$ru._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$ru extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get close => 'Закрыть';
	@override String get later => 'Позже';
	@override String get copyCommand => 'Копировать команду';
	@override String get updateNow => 'Обновить сейчас';
	@override String get updating => 'Обновление...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$ru extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Закрыть модальное окно обновления версии';
	@override String get showSidebar => 'Показать боковую панель';
	@override String get settings => 'Настройки';
	@override String get updateAvailable => 'Доступно обновление';
	@override String get closeSidebar => 'Закрыть боковую панель';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$ru extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Включите Browser в настройках, чтобы агенты могли открывать наблюдаемые сессии браузера.';
	@override String get descEnabled => 'Сессии браузера агента появляются здесь, пока задача ИИ использует Browser.';
	@override String get titleDisabled => 'Browser отключён';
	@override String get titleEnabled => 'Пока нет сессий браузера';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$ru extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'Действие браузера не удалось';
	@override String get loadFailed => 'Не удалось загрузить Browser';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$ru extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Используйте Browser, чтобы проверить процесс оформления заказа и сообщить о неработающих состояниях UI.';
	@override String get prompt2 => 'Откройте <url> в Browser, взаимодействуйте со страницей и резюмируйте, что изменилось после каждого шага.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$ru extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' дн. назад';
	@override String get hoursAgo => ' ч. назад';
	@override String get justNow => 'Только что';
	@override String get minutesAgo => ' мин. назад';
	@override String get never => 'Никогда';
	@override String get secondsAgo => ' сек. назад';
	@override String get unknown => 'Неизвестно';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$ru extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Отключён';
	@override String get installing => 'Установка';
	@override String get ready => 'Готов';
	@override String get setupRequired => 'Требуется настройка';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$ru extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Все ветки (${count})';
	@override String commits({required Object count}) => 'Все коммиты (${count})';
	@override String files({required Object count}) => 'Все файлы (${count})';
	@override String sessions({required Object count}) => 'Все сессии (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$ru extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'Стоимость — клиентская оценка по опубликованным тарифам за токен; неизвестные модели показывают «—».';
	@override String get estCost => 'Прим. стоимость';
	@override String get inputOutput => 'Ввод / Вывод';
	@override String get model => 'Модель';
	@override String get na => 'Н/Д';
	@override String get openSplit => 'Открыть в разделённом виде';
	@override String get provider => 'Провайдер';
	@override String get selectSession => 'Выберите сессию…';
	@override String get tokensUsed => 'Использовано токенов';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$ru extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Действия';
	@override String get branches => 'Ветки';
	@override String get commits => 'Коммиты';
	@override String get files => 'Файлы';
	@override String get git => 'Git';
	@override String get navigate => 'Навигация';
	@override String get sessions => 'Сессии';
	@override String get settings => 'Настройки';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$ru extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get close => 'Закрыть';
	@override String get navigate => 'Навигация';
	@override String get select => 'Выбрать';
	@override String get togglePalette => 'Переключить палитру';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$ru extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Сравнить сессии';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => 'Открыть настройки';
	@override String get selectProjectFirst => 'Сначала выберите проект';
	@override String settingsEntry({required Object label}) => 'Настройки: ${label}';
	@override String get startNewChat => 'Начать новый чат';
	@override String switchTo({required Object name}) => 'Переключиться на: ${name}';
	@override String get toggleTheme => 'Переключить тему';
	@override String get tokensAndCost => 'токены и стоимость';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$ru extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get board => 'К панели агентов';
	@override String get chat => 'К чату';
	@override String get files => 'К файлам';
	@override String get git => 'К Git';
	@override String get sourceControl => 'К контролю версий';
	@override String get tasks => 'К задачам';
	@override String get usage => 'К квотам и использованию';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$ru extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Действия';
	@override String get branches => 'Ветки';
	@override String get commits => 'Коммиты';
	@override String get compare => 'Сравнение';
	@override String get files => 'Файлы';
	@override String get sessions => 'Сессии';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$ru extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => 'Удалить ветку «${branch}»? Обычное удаление сработает только если ветка полностью слита. Действие необратимо.';
	@override String confirmSwitch({required Object branch}) => 'Переключиться на ветку «${branch}»? Убедитесь, что нет незафиксированных изменений.';
	@override String countBoth({required Object local, required Object remote}) => '${local} локальных, ${remote} удалённых';
	@override String countLocal({required Object count}) => '${count} локальных';
	@override String get current => 'текущая';
	@override String deleteTitle({required Object branch}) => 'Удалить ${branch}';
	@override String get emptyDesc => 'Создайте ветку, чтобы начать параллельную работу.';
	@override String get forceDelete => 'Принудительное удаление';
	@override String get forceDeleteDesc => 'Безвозвратно удаляет ветку, даже если она содержит коммиты, никуда не слитые.';
	@override String get forceDeleteLabel => 'Принудительно удалить эту неслитую ветку';
	@override String get local => 'Локальные';
	@override String get kNew => 'Новая ветка';
	@override String get noMatch => 'Нет веток, соответствующих запросу';
	@override String get none => 'Ветки не найдены';
	@override String get remote => 'удалённые';
	@override String get kSwitch => 'Переключить';
	@override String switchTo({required Object branch}) => 'Переключиться на ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$ru extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Подтвердить';
	@override String get delete => 'Удалить';
	@override String get deleteBranch => 'Удалить';
	@override String get discard => 'Отменить';
	@override String get publish => 'Опубликовать';
	@override String get pull => 'Вытянуть';
	@override String get push => 'Отправить';
	@override String get revertLocalCommit => 'Отменить коммит';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$ru extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Подтвердить действие';
	@override String get delete => 'Удалить файл';
	@override String get deleteBranch => 'Удалить ветку';
	@override String get discard => 'Отменить изменения';
	@override String get publish => 'Опубликовать ветку';
	@override String get pull => 'Подтвердить pull';
	@override String get push => 'Подтвердить push';
	@override String get revertLocalCommit => 'Отменить локальный коммит';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$ru extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Не удалось создать ветку';
	@override String get createWorktreeFailed => 'Не удалось создать worktree';
	@override String get deleteBranchFailed => 'Не удалось удалить ветку';
	@override String get fetchFailed => 'Fetch не удался';
	@override String get initFailed => 'Не удалось инициализировать репозиторий';
	@override String get initialCommitFailed => 'Не удалось создать первый коммит';
	@override String get mergeFailed => 'Слияние не удалось';
	@override String get openWorktreeFailed => 'Не удалось открыть worktree';
	@override String get operationFailed => 'Операция git не удалась';
	@override String get publishFailed => 'Публикация не удалась';
	@override String get pullFailed => 'Pull не удался';
	@override String get pushFailed => 'Push не удался';
	@override String get removeWorktreeFailed => 'Не удалось удалить worktree';
	@override String get stageFailed => 'Подготовка не удалась';
	@override String get stageHunksFailed => 'Подготовка фрагментов не удалась';
	@override String get switchFailed => 'Переключение ветки не удалось';
	@override String get unstageFailed => 'Отмена подготовки не удалась';
	@override String get unstageHunksFailed => 'Отмена подготовки фрагментов не удалась';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$ru extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get added => 'Добавлено';
	@override String get author => 'Автор';
	@override String get changedFiles => 'Изменённые файлы';
	@override String get date => 'Дата';
	@override String get empty => 'Коммиты не найдены';
	@override String get files => 'Файлы';
	@override String get removed => 'Удалено';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$ru extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Удалить worktree и его ветку после слияния';
	@override String get cleanupLabel => 'Очистить после слияния';
	@override String commitCount({required Object count}) => '${count} коммит(ов)';
	@override String get merge => 'Слить';
	@override String mergeMessage({required Object branch}) => 'Слить ветку \'${branch}\'';
	@override String get messageLabel => 'Сообщение коммита';
	@override String squashDesc({required Object commits, required Object branch}) => 'Объединить все ${commits} в один коммит в ${branch}';
	@override String get squashLabel => 'Сжать коммиты (squash)';
	@override String get squashMerge => 'Squash и слияние';
	@override String squashMessage({required Object branch}) => 'Squash-слияние ветки \'${branch}\'';
	@override String get title => 'Слить Worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$ru extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Будет создана новая ветка из текущей (${branch})';
	@override String get nameLabel => 'Имя ветки';
	@override String get submit => 'Создать ветку';
	@override String get title => 'Создать новую ветку';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$ru extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Ветка';
	@override String get createFrom => 'Создать из';
	@override String get description => 'Извлеките ветку в отдельную папку и работайте над ней параллельно.';
	@override String get existingBranch => 'Существующая ветка — будет извлечена как есть.';
	@override String get submit => 'Создать worktree';
	@override String get switchAfter => 'Переключиться на worktree после создания';
	@override String get title => 'Новый Worktree';
	@override String get willCreateIn => 'Будет создан в';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$ru extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get create => 'Создать первый коммит';
	@override String get creating => 'Создание первого коммита...';
	@override String get description => 'В этом репозитории ещё нет коммитов. Создайте первый коммит, чтобы начать отслеживать изменения.';
	@override String get title => 'Пока нет коммитов';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$ru extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'Этот проект ещё не является git-репозиторием. Инициализируйте его, чтобы отслеживать изменения и использовать контроль версий.';
	@override String get init => 'Выполнить git init';
	@override String get initializing => 'Инициализация репозитория...';
	@override String get title => 'Нет git-репозитория';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$ru extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Также удалить ветку';
	@override String description({required Object branch}) => 'Удалить worktree для ${branch}? Его папка будет удалена, а связанный проект заархивирован — сессии чата останутся восстановимыми.';
	@override String dirtyWarning({required Object count}) => 'В этом worktree есть ${count} незафиксированных изменений, которые будут потеряны.';
	@override String get discardChanges => 'Отменить незафиксированные изменения';
	@override String get title => 'Удалить Worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$ru extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get added => 'Добавлен';
	@override String get deleted => 'Удалён';
	@override String get modified => 'Изменён';
	@override String get untracked => 'Не отслеживается';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$ru extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} изменений';
	@override String count({required Object count}) => '${count} worktree';
	@override String get createFirst => 'Создайте первый worktree';
	@override String get detached => 'откреплён';
	@override String detachedAt({required Object sha}) => 'откреплён @ ${sha}';
	@override String get detachedHead => 'откреплённый HEAD';
	@override String get emptyDesc => 'Worktree извлекает ветку в отдельную папку, чтобы можно было вести параллельные сессии чата и слить результаты, когда они будут готовы.';
	@override String get emptyTitle => 'Работайте над ветками параллельно';
	@override String get locked => 'заблокирован';
	@override String get mainWorktree => 'основной worktree';
	@override String mergeTitle({required Object branch}) => 'Слить ${branch} в базовую ветку';
	@override String get kNew => 'Новый worktree';
	@override String get none => 'Нет worktree';
	@override String get nothingToMerge => 'Нечего слить — нет коммитов впереди базовой ветки';
	@override String get open => 'Открыть';
	@override String get refresh => 'Обновить worktree';
	@override String removeTitle({required Object branch}) => 'Удалить worktree для ${branch}';
	@override String switchTo({required Object branch}) => 'Переключиться на ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$ru extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Изменения';
	@override String get history => 'Коммиты';
	@override String get branches => 'Ветки';
	@override String get worktrees => 'Ворктри';
}

// Path: common.gitPanel.worktreeScripts
class Translations$common$gitPanel$worktreeScripts$ru extends Translations$common$gitPanel$worktreeScripts$en {
	Translations$common$gitPanel$worktreeScripts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Скрипты worktree';
	@override String get setup => 'Скрипт настройки (запускается после создания/открытия)';
	@override String get run => 'Запустить dev-сервер';
	@override String get stop => 'Остановить dev-сервер';
	@override String get runScript => 'Скрипт запуска (dev-сервер, по требованию)';
	@override String get runPort => 'Порт предпросмотра (необязательно — определяется автоматически, если пусто)';
	@override String get invalidPort => 'Порт должен быть от 1 до 65535';
	@override String get sourceProject => 'Сохранено как переопределение проекта';
	@override String get sourceFile => 'Из .ddagent/worktree.json — сохранение создаст переопределение проекта';
	@override String get sourceNone => 'Пока ничего не настроено';
	@override String get saving => 'Сохранение…';
	@override String get setupRunning => 'идёт настройка';
	@override String get setupFailed => 'ошибка настройки';
	@override String get running => 'запущен';
	@override String get openPreview => 'Открыть предпросмотр';
	@override String runExited({required Object code}) => 'запуск завершён (${code})';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$ru extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Область';
	@override String get user => 'Пользователь';
	@override String get project => 'Проект';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$ru extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get system => 'Системная';
	@override String get light => 'Светлая';
	@override String get dark => 'Темная';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$ru extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Внешний вид';
	@override String get toolDisplay => 'Отображение инструментов';
	@override String get inputSettings => 'Настройки ввода';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$ru extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Перетаскивание ручки';
	@override String get closePanel => 'Закрыть панель настроек';
	@override String get openPanel => 'Открыть панель настроек';
	@override String get draggingStatus => 'Перетаскивание...';
	@override String get toggleAndMove => 'Нажмите для переключения, перетащите для перемещения';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$ru extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Закрыть панель горячих клавиш';
	@override String get openPanel => 'Открыть панель горячих клавиш';
}

// Path: settings.miniOrchestration.enable
class Translations$settings$miniOrchestration$enable$ru extends Translations$settings$miniOrchestration$enable$en {
	Translations$settings$miniOrchestration$enable$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Включить мини-оркестрацию';
	@override String get description => 'Направлять сеансы Авто (мини) через движок с двумя ролями вместо полного оркестратора.';
}

// Path: settings.miniOrchestration.thinker
class Translations$settings$miniOrchestration$thinker$ru extends Translations$settings$miniOrchestration$thinker$en {
	Translations$settings$miniOrchestration$thinker$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Мыслитель (не-flash)';
	@override String get description => 'Планирует, принимает решения, проверяет и пишет итоговый отчёт.';
}

// Path: settings.miniOrchestration.worker
class Translations$settings$miniOrchestration$worker$ru extends Translations$settings$miniOrchestration$worker$en {
	Translations$settings$miniOrchestration$worker$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Исполнитель (flash)';
	@override String get description => 'Выполняет каждый запланированный шаг.';
}

// Path: settings.miniOrchestration.fields
class Translations$settings$miniOrchestration$fields$ru extends Translations$settings$miniOrchestration$fields$en {
	Translations$settings$miniOrchestration$fields$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Провайдер';
	@override String get model => 'Модель';
	@override String get modelPlaceholder => 'Выберите модель';
	@override String get tier => 'Уровень';
}

// Path: settings.miniOrchestration.roles
class Translations$settings$miniOrchestration$roles$ru extends Translations$settings$miniOrchestration$roles$en {
	Translations$settings$miniOrchestration$roles$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Модель для каждой задачи';
	@override String get description => 'Какая модель (роль) обрабатывает каждый тип задач.';
}

// Path: settings.miniOrchestration.planner
class Translations$settings$miniOrchestration$planner$ru extends Translations$settings$miniOrchestration$planner$en {
	Translations$settings$miniOrchestration$planner$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Планировщик';
	@override String get mode => 'Режим';
	@override late final Translations$settings$miniOrchestration$planner$modes$ru modes = Translations$settings$miniOrchestration$planner$modes$ru._(_root);
	@override String get requireConfirmLabel => 'Подтверждать план перед запуском';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$ru extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Включить оркестрацию';
	@override String get description => 'Позволить оркестратору выбирать модель для каждого шага вместо выполнения всего у одного провайдера.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$ru extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Пул кандидатов';
	@override String get description => 'Модели, из которых может выбирать маршрутизатор; каждая привязана к ценовому уровню.';
	@override String get add => 'Добавить кандидата';
	@override String get empty => 'Кандидатов пока нет — добавьте одного, чтобы начать маршрутизацию.';
	@override late final Translations$settings$orchestration$pool$fields$ru fields = Translations$settings$orchestration$pool$fields$ru._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$ru extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$ru extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Правила маршрутизации';
	@override String get description => 'Упорядоченные кандидаты для каждого типа задач — побеждает первый доступный.';
	@override String get addCandidate => 'Добавить кандидата…';
	@override String get empty => 'Нет кандидатов — этот тип задач некуда направить.';
	@override String get missing => '(removed)';
	@override String get remove => 'Удалить кандидата';
	@override late final Translations$settings$orchestration$rules$taskTypes$ru taskTypes = Translations$settings$orchestration$rules$taskTypes$ru._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$ru extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'Как запрос разбивается на маршрутизируемые шаги.';
	@override String get modeLabel => 'Режим планирования';
	@override late final Translations$settings$orchestration$planner$modes$ru modes = Translations$settings$orchestration$planner$modes$ru._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$ru modeHints = Translations$settings$orchestration$planner$modeHints$ru._(_root);
	@override String get candidateLabel => 'Модель-планировщик';
	@override String get candidateDescription => 'Кандидат из пула для генерации планов и вызовов классификации.';
	@override String get candidatePlaceholder => 'Выберите кандидата из пула';
	@override late final Translations$settings$orchestration$planner$templates$ru templates = Translations$settings$orchestration$planner$templates$ru._(_root);
	@override String get requireConfirm => 'Подтверждать план перед запуском';
	@override String get requireConfirmDescription => 'Приостанавливать после планирования, чтобы вы могли изменить или отключить шаги в карточке плана.';
	@override String get checkpointLabel => 'Автономность';
	@override late final Translations$settings$orchestration$planner$checkpointModes$ru checkpointModes = Translations$settings$orchestration$planner$checkpointModes$ru._(_root);
	@override late final Translations$settings$orchestration$planner$checkpointHints$ru checkpointHints = Translations$settings$orchestration$planner$checkpointHints$ru._(_root);
	@override String get checkpointIntervalLabel => 'Шагов между контрольными точками (1–50)';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$ru extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ограничения выполнения';
	@override String get description => 'Ограничители для параллельных запусков и циклов исправлений.';
	@override String get maxParallel => 'Макс. параллельных шагов';
	@override String get maxParallelDescription => 'Сколько подзадач может выполняться одновременно (1–8).';
	@override String get maxFixLoops => 'Макс. циклов исправлений';
	@override String get maxFixLoopsDescription => 'Повторы, когда шаг не проходит проверку (0–5).';
	@override String get onNoCandidate => 'Если нет доступного кандидата';
	@override String get onNoCandidateDescription => 'Спросить перед переходом к запасному варианту или пропустить шаг.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$ru onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$ru._(_root);
	@override String get useWorktree => 'Изолированный worktree';
	@override String get useWorktreeDescription => 'Выполнять все делегированные шаги в одном общем git worktree вместо каталога проекта.';
	@override String get maxSupervisorIterations => 'Макс. итераций супервизора';
	@override String get maxSupervisorIterationsDescription => 'Ограничение числа раундов решений супервизора в автоматическом режиме (1–100); при его достижении запуск завершается частичным отчётом.';
	@override String get maxAttempts => 'Макс. попыток на шаг';
	@override String get maxAttemptsDescription => 'Общий бюджет попыток для одного шага по всем линиям и повторам (1–50).';
	@override String get stepTimeoutMs => 'Тайм-аут шага (мс)';
	@override String get stepTimeoutMsDescription => 'Тайм-аут дочернего запуска для каждой попытки в миллисекундах; 0 — отключено.';
	@override String get runTimeoutMs => 'Тайм-аут запуска (мс)';
	@override String get runTimeoutMsDescription => 'Общий тайм-аут выполнения плана в миллисекундах; 0 — отключено.';
	@override String get retryBackoffBaseMs => 'База задержки повтора (мс)';
	@override String get retryBackoffBaseMsDescription => 'База экспоненциальной задержки между повторами на той же линии (полный jitter).';
	@override String get retryBudgetTitle => 'Бюджет повторов по классу ошибки';
	@override String get retryBudgetDescription => 'Повторы на той же линии перед переключением/паузой (0–5).';
	@override late final Translations$settings$orchestration$execution$retryClasses$ru retryClasses = Translations$settings$orchestration$execution$retryClasses$ru._(_root);
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$ru extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get unsaved => 'Несохранённые изменения';
	@override String get save => 'Save';
	@override String get saving => 'Saving…';
	@override String get saved => 'Saved';
	@override String get discard => 'Discard';
	@override String get error => 'Save failed';
	@override String get emptyPool => 'Перед сохранением добавьте хотя бы одного кандидата.';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$ru extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Web Push уведомления';
	@override String get enable => 'Включить Push уведомления';
	@override String get disable => 'Отключить Push уведомления';
	@override String get enabled => 'Push уведомления включены';
	@override String get loading => 'Обновление...';
	@override String get unsupported => 'Push уведомления не поддерживаются в этом браузере.';
	@override String get denied => 'Push уведомления заблокированы. Разрешите их в настройках браузера.';
	@override String get iosHint => 'На iPhone/iPad уведомления работают только после добавления DDAgent на домашний экран (Поделиться → На экран «Домой») и их включения в установленном приложении.';
	@override String get test => 'Отправить тестовое уведомление';
	@override String get testNoSubscription => 'Нет подписанных устройств. Сначала нажмите «Включить» на телефоне.';
	@override String testSuccess({required Object count}) => 'Отправлено на ${count} устройств. Если на телефоне ничего не появилось, добавьте DDAgent на домашний экран (это требование iOS).';
	@override String get testNotDelivered => 'Ни одно устройство не было доступно. Убедитесь, что приложение запущено и уведомления включены.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$ru extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уведомлять это устройство';
	@override String get enabled => 'Уведомления включены для этого устройства';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$ru extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уведомлять это десктопное приложение';
	@override String get enable => 'Включить Push уведомления';
	@override String get disable => 'Отключить Push уведомления';
	@override String get enabled => 'Уведомления включены для этого десктопного приложения';
	@override String get unsupported => 'Десктопные уведомления не поддерживаются в этой системе.';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$ru extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Звук';
	@override String get description => 'Воспроизводить короткий сигнал при завершении запуска чата.';
	@override String get enabled => 'Включено';
	@override String get test => 'Проверить звук';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$ru extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Типы событий';
	@override String get actionRequired => 'Требуется действие';
	@override String get stop => 'Запуск остановлен';
	@override String get error => 'Запуск завершился с ошибкой';
}

// Path: settings.notifications.messaging
class Translations$settings$notifications$messaging$ru extends Translations$settings$notifications$messaging$en {
	Translations$settings$notifications$messaging$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Одобрения через мессенджеры';
	@override String get description => 'Одобряйте или отклоняйте запросы разрешений агентов из Telegram и получайте уведомления о запусках в Discord.';
	@override String get enabled => 'Включено';
	@override String get save => 'Сохранить';
	@override String get test => 'Проверить';
	@override String get pair => 'Связать';
	@override String get telegramToken => 'Токен бота от @BotFather (123456:ABC…)';
	@override String get telegramHint => 'Отправьте любое сообщение своему боту, затем свяжите чат ниже.';
	@override String get discordWebhook => 'https://discord.com/api/webhooks/…';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$ru extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get telegram => 'Telegram';
	@override String get discord => 'Discord';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$ru extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Темная тема';
	@override String get description => 'Переключение между светлой и темной темами';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$ru extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Редактор кода';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$ru theme = Translations$settings$appearanceSettings$codeEditor$theme$ru._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$ru wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$ru._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$ru showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$ru._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$ru lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$ru._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$ru fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$ru._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$ru extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Терминал';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ru focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ru._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$ru extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get add => 'Добавить MCP сервер';
	@override String get edit => 'Редактировать MCP сервер';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$ru extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get form => 'Ввод формы';
	@override String get json => 'Импорт JSON';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$ru extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Область';
	@override String get userGlobal => 'Пользователь (глобально)';
	@override String get projectLocal => 'Проект (локально)';
	@override String get userDescription => 'Область пользователя: доступно во всех проектах на вашей машине';
	@override String get projectDescription => 'Локальная область: доступно только в выбранном проекте';
	@override String get cannotChange => 'Область не может быть изменена при редактировании существующего сервера';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$ru extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Имя сервера';
	@override String get transportType => 'Тип транспорта';
	@override String get command => 'Команда';
	@override String get arguments => 'Аргументы (по одному на строку)';
	@override String get jsonConfig => 'JSON конфигурация';
	@override String get url => 'URL';
	@override String get envVars => 'Переменные окружения (КЛЮЧ=значение, по одной на строку)';
	@override String get headers => 'Заголовки (КЛЮЧ=значение, по одному на строку)';
	@override String get selectProject => 'Выберите проект...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$ru extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'мой-сервер';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$ru extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Отсутствует обязательное поле: type';
	@override String get stdioRequiresCommand => 'тип stdio требует поле command';
	@override String httpRequiresUrl({required Object type}) => 'тип ${type} требует поле url';
	@override String get invalidJson => 'Неверный формат JSON';
	@override String get jsonHelp => 'Вставьте конфигурацию вашего MCP сервера в формате JSON. Примеры форматов:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$ru extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get saving => 'Сохранение...';
	@override String get addServer => 'Добавить сервер';
	@override String get updateServer => 'Обновить сервер';
}

// Path: settings.git.name
class Translations$settings$git$name$ru extends Translations$settings$git$name$en {
	Translations$settings$git$name$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Имя Git';
	@override String get help => 'Ваше имя для git коммитов';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$ru extends Translations$settings$git$email$en {
	Translations$settings$git$email$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Email Git';
	@override String get help => 'Ваш email для git коммитов';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$ru extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get save => 'Сохранить конфигурацию';
	@override String get saving => 'Сохранение...';
}

// Path: settings.git.status
class Translations$settings$git$status$ru extends Translations$settings$git$status$en {
	Translations$settings$git$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get success => 'Успешно сохранено';
	@override String get error => 'Не удалось сохранить';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$ru extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ Сохраните ваш API ключ';
	@override String get alertMessage => 'Это единственный раз, когда вы увидите этот ключ. Сохраните его в безопасном месте.';
	@override String get iveSavedIt => 'Я сохранил его';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$ru extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Имя API ключа (например, Продакшн сервер)';
	@override String get createButton => 'Создать';
	@override String get cancelButton => 'Отмена';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$ru extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get created => 'Создан:';
	@override String get lastUsed => 'Последнее использование:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$ru extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get active => 'Активен';
	@override String get inactive => 'Неактивен';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$ru extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub токены';
	@override String get description => 'Добавьте персональные токены доступа GitHub для клонирования приватных репозиториев через внешний API.';
	@override String get descriptionAlt => 'Добавьте персональные токены доступа GitHub для клонирования приватных репозиториев. Вы также можете передавать токены напрямую в API запросах без их сохранения.';
	@override String get addButton => 'Добавить токен';
	@override late final Translations$settings$apiKeys$github$form$ru form = Translations$settings$apiKeys$github$form$ru._(_root);
	@override String get empty => 'GitHub токены еще не добавлены.';
	@override String get added => 'Добавлен:';
	@override String get confirmDelete => 'Вы уверены, что хотите удалить этот GitHub токен?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$ru extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Документация внешнего API';
	@override String get description => 'Узнайте, как использовать внешний API для запуска сеансов Claude/Cursor из ваших приложений.';
	@override String get viewLink => 'Просмотр документации API →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$ru extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Доступно обновление: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$ru extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLI не установлен';
	@override String get description => 'TaskMaster CLI требуется для использования функций управления задачами. Установите его для начала работы:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'Посмотреть на GitHub';
	@override String get afterInstallation => 'После установки:';
	@override late final Translations$settings$tasks$notInstalled$steps$ru steps = Translations$settings$tasks$notInstalled$steps$ru._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$ru extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'Включить интеграцию TaskMaster';
	@override String get enableDescription => 'Показывать задачи TaskMaster, баннеры и индикаторы боковой панели в интерфейсе';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$ru extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Проверка...';
	@override String get connected => 'Подключен';
	@override String get notConnected => 'Не подключен';
	@override String get disconnected => 'Отключен';
	@override String get checkingAuth => 'Проверка статуса аутентификации...';
	@override String loggedInAs({required Object email}) => 'Вошли как ${email}';
	@override String providerAccount({required Object provider}) => 'Аккаунт ${provider}';
	@override String get authenticatedUser => 'аутентифицированный пользователь';
}

// Path: settings.agents.install
class Translations$settings$agents$install$ru extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => 'CLI ${agent} не установлен';
	@override String description({required Object agent}) => 'Установите CLI ${agent}, чтобы войти и запускать сессии.';
	@override String get button => 'Установить';
	@override String get installing => 'Установка…';
	@override String get copyCommand => 'Копировать команду';
	@override String get docs => 'Документация';
	@override String success({required Object agent}) => 'CLI ${agent} установлен';
	@override String get failed => 'Установка не удалась — проверьте вывод терминала';
}

// Path: settings.agents.update
class Translations$settings$agents$update$ru extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Обновить CLI';
	@override String description({required Object agent}) => 'Установить последнюю версию CLI ${agent} на хосте сервера.';
	@override String get button => 'Обновить';
	@override String get updating => 'Обновление…';
	@override String success({required Object agent}) => 'CLI ${agent} обновлён';
	@override String get failed => 'Не удалось обновить — проверьте вывод терминала';
}

// Path: settings.agents.account
class Translations$settings$agents$account$ru extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$ru claude = Translations$settings$agents$account$claude$ru._(_root);
	@override late final Translations$settings$agents$account$cursor$ru cursor = Translations$settings$agents$account$cursor$ru._(_root);
	@override late final Translations$settings$agents$account$codex$ru codex = Translations$settings$agents$account$codex$ru._(_root);
	@override late final Translations$settings$agents$account$opencode$ru opencode = Translations$settings$agents$account$opencode$ru._(_root);
	@override late final Translations$settings$agents$account$commandcode$ru commandcode = Translations$settings$agents$account$commandcode$ru._(_root);
	@override late final Translations$settings$agents$account$antigravity$ru antigravity = Translations$settings$agents$account$antigravity$ru._(_root);
	@override late final Translations$settings$agents$account$devin$ru devin = Translations$settings$agents$account$devin$ru._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$ru extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Вход';
	@override String get reAuthenticate => 'Повторная аутентификация';
	@override String description({required Object agent}) => 'Войдите в ваш аккаунт ${agent} для включения AI функций';
	@override String get reAuthDescription => 'Войдите с другим аккаунтом или обновите учетные данные';
	@override String get button => 'Войти';
	@override String get reLoginButton => 'Войти снова';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$ru extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Выйти';
	@override String get description => 'Выйти из этого провайдера и удалить сохранённые учётные данные';
	@override String get button => 'Выйти';
	@override String confirmTitle({required Object agent}) => 'Выйти из ${agent}?';
	@override String confirmDescription({required Object agent}) => 'Это удалит сохранённые учётные данные ${agent} на сервере. Войдите снова, чтобы продолжить использовать ${agent}.';
	@override String get success => 'Вы вышли';
	@override String get failed => 'Не удалось выйти';
}

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$ru extends Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Именованные аккаунты';
	@override String get description => 'Дополнительные наборы учётных данных. Сеанс, привязанный к аккаунту, запускает CLI с его изолированным каталогом конфигурации. Чтобы войти, один раз запустите CLI провайдера с указанными переменными окружения.';
	@override String get sharedCli => 'Все аккаунты используют одну установку CLI — обновите её в карточке подключения выше.';
	@override String get loading => 'Загрузка аккаунтов…';
	@override String get kDefault => 'По умолчанию';
	@override String usage({required Object tokens}) => 'Токенов: ${tokens}';
	@override String get usageButton => 'Использование';
	@override String get showUsage => 'Показать расход токенов';
	@override String get makeDefault => 'Сделать основным';
	@override String get remove => 'Удалить аккаунт';
	@override String get newLabel => 'Метка аккаунта (например, Работа)';
	@override String get add => 'Добавить аккаунт';
	@override late final Translations$settings$agents$accounts$autoSwitch$ru autoSwitch = Translations$settings$agents$accounts$autoSwitch$ru._(_root);
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$ru extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Режим разрешений';
	@override String description({required Object provider}) => 'Режим разрешений по умолчанию для новых сессий ${provider}. Его всё ещё можно переопределить для отдельной сессии.';
	@override late final Translations$settings$permissions$permissionMode$modes$ru modes = Translations$settings$permissions$permissionMode$modes$ru._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$ru extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Серверы Model Context Protocol предоставляют дополнительные инструменты и источники данных для Claude';
	@override String get cursor => 'Серверы Model Context Protocol предоставляют дополнительные инструменты и источники данных для Cursor';
	@override String get codex => 'Серверы Model Context Protocol предоставляют дополнительные инструменты и источники данных для Codex';
	@override String get opencode => 'Серверы Model Context Protocol предоставляют OpenCode дополнительные инструменты и источники данных';
	@override String get commandcode => 'Серверы Model Context Protocol предоставляют Command Code дополнительные инструменты и источники данных';
	@override String get antigravity => 'Серверы Model Context Protocol предоставляют Antigravity дополнительные инструменты и источники данных';
	@override String get devin => 'Серверы Model Context Protocol предоставляют Devin дополнительные инструменты и источники данных';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$ru extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get local => 'локальный';
	@override String get user => 'пользователь';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$ru extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get command => 'Команда';
	@override String get url => 'URL';
	@override String get args => 'Аргументы';
	@override String get environment => 'Окружение';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$ru extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Инструменты';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count} еще';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$ru extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Редактировать сервер';
	@override String get delete => 'Удалить сервер';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$ru extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Управляемый';
	@override String get hint => 'Управляется DDAgent.';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$ru extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'О Codex MCP';
	@override String get description => 'Codex поддерживает MCP серверы на основе stdio. Вы можете добавлять серверы, которые расширяют возможности Codex дополнительными инструментами и ресурсами.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$ru extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '«${serverName}» будет удалён из конфигурации провайдера.';
	@override String get title => 'Удалить сервер MCP?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$ru extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Центр управления';
	@override String get title => 'Центр управления';
	@override String get description => 'Пороги оповещений, политика маршрутизации и аккаунты, опрашиваемые для квот.';
	@override String get saved => 'Сохранено';
	@override String get alertsSection => 'Оповещения';
	@override String get alertsSectionHint => 'Предупреждать до фактического исчерпания лимита, а не только на 100%.';
	@override String get alertsEnabled => 'Прогнозные оповещения о лимитах';
	@override String get alertsEnabledHint => 'Показывать прогнозы на основе темпа в обзоре и на карточках аккаунтов.';
	@override String get watchThreshold => 'Порог наблюдения (%)';
	@override String get watchThresholdHint => 'Аккаунты с показаниями на этом уровне или выше считаются под угрозой.';
	@override String get dangerThreshold => 'Порог опасности (%)';
	@override String get dangerThresholdHint => 'Показания на этом уровне или выше отображаются красным.';
	@override String get routingSection => 'Маршрутизация';
	@override String get routingSectionHint => 'Как панель может переносить работу на аккаунт с наибольшим запасом.';
	@override late final Translations$settings$quota$settings$routing$ru routing = Translations$settings$quota$settings$routing$ru._(_root);
	@override String get routingNote => 'Смена аккаунта меняет стоимость и качество модели, поэтому всегда требует явного решения.';
	@override String get accountsSection => 'Опрашиваемые аккаунты';
	@override String get accountsSectionHint => 'Учётные данные читаются из каждого инструмента; панель никуда их не отправляет.';
	@override String get sourcesSection => 'Источники данных';
	@override String get sourcesSectionHint => 'Откуда берутся данные об использовании и стоимости.';
	@override String get logSources => 'Хранилище журналов токенов и затрат';
	@override String get logSourcesHint => 'Агрегированное хранилище только для чтения, общее с коллектором tokboard.';
	@override String get readOnly => 'Только чтение';
	@override String get quotaConsent => 'Опрос квот';
	@override String get quotaConsentHint => 'Читает эндпоинты квот провайдеров с локально сохранёнными учётными данными.';
	@override String get localOnly => 'Только локально';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$ru extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'Аккаунты пока не обнаружены.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$ru extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cached => 'из кэша';
	@override String get error => 'ошибка';
	@override String get estimate => 'оценка';
	@override String get live => 'live';
	@override String get unknown => 'неизвестно';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$ru extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'Не удалось установить среду выполнения браузера';
	@override String get loadSettings => 'Не удалось загрузить настройки Browser';
	@override String get loadStatus => 'Не удалось загрузить статус Browser';
	@override String get saveSettings => 'Не удалось сохранить настройки Browser';
}

// Path: settings.about.pro
class Translations$settings$about$pro$ru extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Синхронизация настроек';
	@override String get teamManagement => 'Управление командой';
	@override String get syncSettingsDescription => 'Синхронизируйте настройки, конфигурации MCP и тему во всех своих средах.';
	@override String get teamManagementDescription => 'Несколько пользователей, ролевой доступ и общие проекты для вашей команды.';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$ru extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'Управление задачами с AI: разбивайте сложные проекты на управляемые подзадачи';
	@override String get prdTemplates => 'Шаблоны PRD: генерируйте задачи из документов требований к продукту';
	@override String get dependencyTracking => 'Отслеживание зависимостей: понимайте связи задач и порядок выполнения';
	@override String get progressVisualization => 'Визуализация прогресса: канбан-доски и детальная аналитика задач';
	@override String get cliIntegration => 'Интеграция с CLI: используйте команды taskmaster для продвинутых рабочих процессов';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$ru extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$ru createPRD = Translations$tasks$gettingStarted$steps$createPRD$ru._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$ru generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$ru._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$ru analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$ru._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$ru startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$ru._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$ru extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Пример:\n"Я только что инициализировал новый проект с Claude Task Master. У меня есть PRD в .taskmaster/docs/prd.txt. Можете помочь мне разобрать его и настроить начальные задачи?"';
	@override String get expandTask => '💬 Пример:\n"Задача 5 кажется сложной. Можете разбить её на подзадачи?"';
	@override String get addTask => '💬 Пример:\n"Пожалуйста, добавьте новую задачу для реализации загрузки изображений профиля пользователя с использованием Cloudinary, изучите лучший подход."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$ru extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Профессиональные советы';
	@override String get search => 'Используйте строку поиска для быстрого поиска конкретных задач';
	@override String get views => 'Переключайтесь между представлениями Канбан, Список и Сетка, используя переключатели представлений';
	@override String get filters => 'Используйте фильтры для фокусировки на конкретных статусах или приоритетах задач';
	@override String get details => 'Нажмите на любую задачу для просмотра детальной информации и управления подзадачами';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$ru extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 Узнать больше';
	@override String get description => 'TaskMaster AI - это продвинутая система управления задачами, созданная для разработчиков. Получите документацию, примеры и внесите вклад в проект.';
	@override String get githubButton => 'Посмотреть на GitHub';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$ru extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Пока нет карточек';
	@override String get description => 'Добавьте карточку, опишите задачу, затем перетащите её в Готово, чтобы агент начал работу.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$ru extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Бэклог';
	@override String get ready => 'Готово к запуску';
	@override String get working => 'В работе';
	@override String get needsDecision => 'Нужно ваше решение';
	@override String get done => 'Выполнено';
	@override String get archived => 'Архив';
}

// Path: tasks.board.card
class Translations$tasks$board$card$ru extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get running => 'Выполняется';
	@override String get abort => 'Прервать';
	@override String get delete => 'Удалить';
	@override String get openSession => 'Открыть сессию';
	@override String get pullRequest => 'Pull request';
	@override String get edit => 'Изменить';
	@override String get moveTo => 'Переместить в';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$ru extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Новая карточка';
	@override String get editTitle => 'Редактировать карточку';
	@override String get titleLabel => 'Заголовок';
	@override String get titlePlaceholder => 'Что должен сделать агент?';
	@override String get descriptionLabel => 'Описание';
	@override String get descriptionPlaceholder => 'Добавьте контекст, критерии приёмки, ссылки...';
	@override String get cancel => 'Отмена';
	@override String get save => 'Сохранить';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$ru extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Агент';
	@override String get anyProvider => 'Любой агент';
	@override String get model => 'Модель';
	@override String get defaultModel => 'Модель по умолчанию';
	@override String get effort => 'Рассуждение';
	@override String get defaultEffort => 'По умолчанию';
	@override String get searchModel => 'Поиск моделей…';
	@override String get noModels => 'Нет подходящих моделей';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$ru extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '«${cardTitle}» будет удалена безвозвратно.';
	@override String get title => 'Удалить карточку?';
}

// Path: tasks.board.assignee
class Translations$tasks$board$assignee$ru extends Translations$tasks$board$assignee$en {
	Translations$tasks$board$assignee$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Исполнитель';
	@override String get all => 'Все исполнители';
	@override String get unassigned => 'Не назначено';
}

// Path: tasks.board.presence
class Translations$tasks$board$presence$ru extends Translations$tasks$board$presence$en {
	Translations$tasks$board$presence$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String online({required Object count}) => 'В сети: ${count}';
}

// Path: tasks.board.activity
class Translations$tasks$board$activity$ru extends Translations$tasks$board$activity$en {
	Translations$tasks$board$activity$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Активность';
	@override String get empty => 'Активности пока нет';
}

// Path: tasks.board.comments
class Translations$tasks$board$comments$ru extends Translations$tasks$board$comments$en {
	Translations$tasks$board$comments$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Комментарии';
	@override String get placeholder => 'Напишите комментарий…';
	@override String get send => 'Отправить';
	@override String get unknownAuthor => 'Кто-то';
}

// Path: tasks.taskmaster.sort
class Translations$tasks$taskmaster$sort$ru extends Translations$tasks$taskmaster$sort$en {
	Translations$tasks$taskmaster$sort$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get statusAz => 'Статус (А–Я)';
	@override String get statusZa => 'Статус (Я–А)';
}

// Path: tasks.taskmaster.prd
class Translations$tasks$taskmaster$prd$ru extends Translations$tasks$taskmaster$prd$en {
	Translations$tasks$taskmaster$prd$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get fileNameRequired => 'Укажите имя файла для PRD.';
	@override String get contentRequired => 'Добавьте содержимое перед сохранением.';
	@override String get overwrite => 'Перезаписать';
	@override String get contentHint => '# Документ требований к продукту…';
}

// Path: tasks.taskmaster.detail
class Translations$tasks$taskmaster$detail$ru extends Translations$tasks$taskmaster$detail$en {
	Translations$tasks$taskmaster$detail$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get dependenciesLabel => 'Зависимости (ID через запятую)';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$ru extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Рабочий каталог';
	@override String get envVars => 'Переменные окружения';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$ru extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get userAllProviders => 'Пользователь (все провайдеры)';
	@override String get claudeLocal => 'Claude (локально)';
	@override String get projectAllProviders => 'Проект (все провайдеры)';
	@override late final Translations$mcp$form$scope$description$ru description = Translations$mcp$form$scope$description$ru._(_root);
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$ru extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get workingDirectory => 'Рабочий каталог';
	@override String get envVarNames => 'Имена переменных окружения';
	@override String get bearerTokenEnvVar => 'Переменная окружения с Bearer-токеном';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$ru extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => '«Добавить MCP сервер» поддерживает только stdio и http у всех провайдеров, а не ${type}.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} не поддерживает MCP серверы типа ${type}';
	@override String get jsonMustBeObject => 'Конфигурация JSON должна быть объектом';
}

// Path: serverConnect.local.errors
class Translations$serverConnect$local$errors$ru extends Translations$serverConnect$local$errors$en {
	Translations$serverConnect$local$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get releaseTagUnresolved => 'Не удалось определить тег последнего релиза DDAgent.';
	@override String get unsupportedPlatform => 'Локальный сервер не поддерживается на этой платформе.';
	@override String unsupportedPlatformDetail({required Object platform}) => 'Локальный сервер не поддерживается на этой платформе (${platform}).';
	@override String nodeExtractionFailed({required Object path}) => 'Распаковка Node.js не создала ${path}';
	@override String downloadFailed({required Object error}) => 'Не удалось скачать сервер: ${error}';
	@override String installFailed({required Object error}) => 'Не удалось установить сервер: ${error}';
	@override String get bundleNotInstalled => 'Пакет сервера не установлен.';
	@override String spawnFailed({required Object error}) => 'Не удалось запустить локальный сервер: ${error}';
	@override String portInUse({required Object port}) => 'Порт ${port} уже используется другим приложением.';
	@override String get exitedDuringStartup => 'Локальный сервер завершил работу во время запуска.';
	@override String exitedDuringStartupWithOutput({required Object output}) => 'Локальный сервер завершил работу во время запуска: ${output}';
	@override String get startTimeout => 'Истекло время ожидания запуска локального сервера.';
	@override String tarFailed({required Object command, required Object code, required Object output}) => '${command} завершилась с ошибкой (код ${code}): ${output}';
}

// Path: chat.orchestrator.decision.action
class Translations$chat$orchestrator$decision$action$ru extends Translations$chat$orchestrator$decision$action$en {
	Translations$chat$orchestrator$decision$action$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'делегирование';
	@override String get done => 'завершено';
	@override String get invalid => 'нет решения';
}

// Path: chat.orchestrator.decision.outcome
class Translations$chat$orchestrator$decision$outcome$ru extends Translations$chat$orchestrator$decision$outcome$en {
	Translations$chat$orchestrator$decision$outcome$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get success => 'успех';
	@override String get partial => 'частично';
	@override String get failed => 'ошибка';
}

// Path: chat.orchestrator.delegation.status
class Translations$chat$orchestrator$delegation$status$ru extends Translations$chat$orchestrator$delegation$status$en {
	Translations$chat$orchestrator$delegation$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get queued => 'в очереди';
	@override String get running => 'выполняется';
	@override String get done => 'готово';
	@override String get failed => 'ошибка';
	@override String get aborted => 'прервано';
	@override String get skipped => 'пропущено';
	@override String get awaitingDecision => 'ожидает решения';
}

// Path: chat.orchestrator.taskmaster.status
class Translations$chat$orchestrator$taskmaster$status$ru extends Translations$chat$orchestrator$taskmaster$status$en {
	Translations$chat$orchestrator$taskmaster$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get started => 'выполняется';
	@override String get done => 'готово';
	@override String get complete => 'завершено';
	@override String get failed => 'ошибка';
	@override String get paused => 'приостановлено';
	@override String get blocked => 'заблокировано';
	@override String get aborted => 'прервано';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$ru extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Вручную — только рекомендация';
	@override String get ask => 'Спрашивать перед сменой аккаунта';
	@override String get autoLowRisk => 'Автопереключение для задач с низким риском';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$ru extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Существующее рабочее пространство';
	@override String get description => 'У меня уже есть рабочее пространство на сервере, нужно только добавить его в список проектов';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$ru extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Новое рабочее пространство';
	@override String get description => 'Создать новое рабочее пространство, опционально клонировать из репозитория GitHub';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$ru extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$ru info = Translations$common$notifications$codes$generic$info$ru._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$ru extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$ru required = Translations$common$notifications$codes$permission$required$ru._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$ru extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$ru stopped = Translations$common$notifications$codes$run$stopped$ru._(_root);
	@override late final Translations$common$notifications$codes$run$failed$ru failed = Translations$common$notifications$codes$run$failed$ru._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$ru extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$ru notification = Translations$common$notifications$codes$agent$notification$ru._(_root);
}

// Path: settings.miniOrchestration.planner.modes
class Translations$settings$miniOrchestration$planner$modes$ru extends Translations$settings$miniOrchestration$planner$modes$en {
	Translations$settings$miniOrchestration$planner$modes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Планировать с мыслителем';
	@override String get off => 'Один шаг';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$ru extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Label';
	@override String get labelPlaceholder => 'например, SWE-2 Medium';
	@override String get provider => 'Provider';
	@override String get model => 'Model';
	@override String get modelPlaceholder => 'Выберите модель';
	@override String get effort => 'Effort';
	@override String get effortDefault => 'По умолчанию провайдера';
	@override String get effortPlaceholder => 'default';
	@override String get account => 'Account';
	@override String get accountDefault => 'По умолчанию провайдера';
	@override String get redundantAccounts => 'Резервные аккаунты';
	@override String get redundantAccountsNone => 'Нет других аккаунтов для этого провайдера';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Удалить кандидата';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$ru extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get plan => 'Planning';
	@override String get quick => 'Быстрые ответы';
	@override String get research => 'Research';
	@override String get docs => 'Documentation';
	@override String get code => 'Coding';
	@override String get codeHard => 'Сложное программирование';
	@override String get test => 'Testing';
	@override String get review => 'Review';
	@override String get report => 'Отчёт';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$ru extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$ru extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Модель-планировщик разбивает каждый запрос на типизированные шаги.';
	@override String get template => 'Запросы проходят через фиксированный конвейер, выбранный ниже.';
	@override String get off => 'Без планирования — весь запрос направляется как один шаг.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$ru extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Шаблоны конвейеров';
	@override String get add => 'Add template';
	@override String get namePlaceholder => 'Название шаблона';
	@override String get addStep => 'Add step…';
	@override String get remove => 'Удалить шаблон';
	@override String get removeStep => 'Remove step';
	@override String get empty => 'Шаблонов пока нет.';
	@override String get emptySteps => 'Шагов пока нет — добавьте ниже.';
}

// Path: settings.orchestration.planner.checkpointModes
class Translations$settings$orchestration$planner$checkpointModes$ru extends Translations$settings$orchestration$planner$checkpointModes$en {
	Translations$settings$orchestration$planner$checkpointModes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get off => 'Автономно';
	@override String get perStep => 'Каждый шаг';
	@override String get everyN => 'Каждые N';
}

// Path: settings.orchestration.planner.checkpointHints
class Translations$settings$orchestration$planner$checkpointHints$ru extends Translations$settings$orchestration$planner$checkpointHints$en {
	Translations$settings$orchestration$planner$checkpointHints$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get off => 'Решения супервизора выполняются без запроса (автоматический режим).';
	@override String get perStep => 'Запрашивать одобрение перед каждым предложенным набором шагов.';
	@override String get everyN => 'Запрашивать одобрение после каждых N выполненных шагов.';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$ru extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.orchestration.execution.retryClasses
class Translations$settings$orchestration$execution$retryClasses$ru extends Translations$settings$orchestration$execution$retryClasses$en {
	Translations$settings$orchestration$execution$retryClasses$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get rateLimit => 'Лимит запросов';
	@override String get quota => 'Квота';
	@override String get auth => 'Авторизация';
	@override String get timeout => 'Тайм-аут';
	@override String get transient => 'Временная ошибка';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$ru extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Тема редактора';
	@override String get description => 'Тема по умолчанию для редактора кода';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$ru extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Перенос слов';
	@override String get description => 'Включить перенос слов по умолчанию в редакторе';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$ru extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Показать миникарту';
	@override String get description => 'Отображать миникарту для упрощения навигации в представлении различий';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$ru extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Показать номера строк';
	@override String get description => 'Отображать номера строк в редакторе';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$ru extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Размер шрифта';
	@override String get description => 'Размер шрифта редактора в пикселях';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ru extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Фокус следует за указателем';
	@override String get description => 'Фокусировать терминал для ввода при наведении мыши';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$ru extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Имя токена (например, Личные репозитории)';
	@override String get tokenPlaceholder => 'Персональный токен доступа GitHub (ghp_...)';
	@override String get descriptionPlaceholder => 'Описание (необязательно)';
	@override String get addButton => 'Добавить токен';
	@override String get cancelButton => 'Отмена';
	@override String get howToCreate => 'Как создать персональный токен доступа GitHub →';
	@override String get showToken => 'Показать токен';
	@override String get hideToken => 'Скрыть токен';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$ru extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Перезапустите это приложение';
	@override String get autoAvailable => 'Функции TaskMaster станут автоматически доступны';
	@override String get initCommand => 'Используйте task-master init в каталоге вашего проекта';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$ru extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'AI-ассистент Anthropic Claude';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$ru extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'Редактор кода с AI Cursor';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$ru extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'AI-ассистент OpenAI Codex';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$ru extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'CLI-ассистент OpenCode';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$ru extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'CLI-ассистент Command Code';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$ru extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'CLI-ассистент Antigravity';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$ru extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'CLI-ассистент Devin';
}

// Path: settings.agents.accounts.autoSwitch
class Translations$settings$agents$accounts$autoSwitch$ru extends Translations$settings$agents$accounts$autoSwitch$en {
	Translations$settings$agents$accounts$autoSwitch$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Автоматически переключать аккаунт при исчерпании лимита';
	@override String get description => 'Когда аккаунт достигает лимита использования, сессия переходит на другой аккаунт того же агента, у которого ещё есть лимит, — даже если исчерпанный аккаунт выбран вручную. Никогда не переключает на другого агента. Claude и Codex сохраняют беседу; другие агенты переключаются только в новых чатах.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$ru extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$ru kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$ru._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$ru auto = Translations$settings$permissions$permissionMode$modes$auto$ru._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$ru acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$ru._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$ru bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$ru._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$ru plan = Translations$settings$permissions$permissionMode$modes$plan$ru._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$ru extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Вручную';
	@override String get manualHint => 'Показывать только рекомендацию; никогда не переключать аккаунты автоматически.';
	@override String get ask => 'Спрашивать перед переключением';
	@override String get askHint => 'Переключение предлагается и ждёт вашего одобрения.';
	@override String get autoLowRisk => 'Авто для задач с низким риском';
	@override String get autoLowRiskHint => 'Автоматически могут перемещаться только задачи с пометкой низкого риска.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$ru extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Создайте документ требований к продукту (PRD)';
	@override String get description => 'Обсудите идею вашего проекта и создайте PRD, описывающий то, что вы хотите построить.';
	@override String get addButton => 'Добавить PRD';
	@override String get existingPRDs => 'Существующие PRD:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$ru extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Генерация задач из PRD';
	@override String get description => 'Когда у вас есть PRD, попросите вашего AI-ассистента разобрать его, и TaskMaster автоматически разобьет его на управляемые задачи с деталями реализации.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$ru extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Анализ и расширение задач';
	@override String get description => 'Попросите вашего AI-ассистента проанализировать сложность задач и расширить их в детальные подзадачи для упрощения реализации.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$ru extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Начните разработку';
	@override String get description => 'Попросите вашего AI-ассистента начать работу над задачами, обновлять их статус и добавлять новые задачи по мере развития вашего проекта.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$ru extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get userGlobal => 'Записывается в пользовательскую конфигурацию каждого провайдера и доступно во всех проектах на этой машине';
	@override String get user => 'Доступно во всех проектах на вашей машине';
	@override String get local => 'Хранится в пользовательских настройках Claude для выбранного проекта';
	@override String get projectGlobal => 'Записывается в рабочую область выбранного проекта для всех провайдеров';
	@override String get project => 'Хранится в рабочей области выбранного проекта';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$ru extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уведомление';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$ru extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Требуется действие';
	@override String body({required Object toolName}) => '${toolName} ожидает вашего решения.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$ru extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Запуск остановлен';
	@override String body({required Object reason}) => 'Причина: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$ru extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Запуск завершился сбоем';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$ru extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Уведомление агента';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$ru extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'По умолчанию';
	@override String get description => 'Действия, требующие разрешения, показываются вам для одобрения в чате.';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$ru extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Авторежим';
	@override String get description => 'Классификатор модели решает для каждого вызова инструмента, одобрить или отклонить. Высокая автономность.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$ru extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Принимать правки';
	@override String get description => 'Правки файлов одобряются автоматически; другие действия по-прежнему запрашивают одобрение.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$ru extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Обход разрешений';
	@override String get description => 'Каждое действие одобряется автоматически — полный доступ без запросов. Используйте с осторожностью.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$ru extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'План';
	@override String get description => 'Режим планирования: агент исследует и планирует, не выполняя команд.';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Срок действия сеанса истёк. Войдите снова.',
			'auth.login.title' => 'Добро пожаловать',
			'auth.login.description' => 'Войдите в свой аккаунт DDAgent',
			'auth.login.username' => 'Имя пользователя',
			'auth.login.password' => 'Пароль',
			'auth.login.submit' => 'Войти',
			'auth.login.loading' => 'Вход...',
			'auth.login.errors.invalidCredentials' => 'Неверное имя пользователя или пароль',
			'auth.login.errors.requiredFields' => 'Пожалуйста, заполните все поля',
			'auth.login.errors.networkError' => 'Ошибка сети. Попробуйте снова.',
			'auth.login.placeholders.username' => 'Введите имя пользователя',
			'auth.login.placeholders.password' => 'Введите пароль',
			'auth.register.title' => 'Создать аккаунт',
			'auth.register.username' => 'Имя пользователя',
			'auth.register.password' => 'Пароль',
			'auth.register.confirmPassword' => 'Подтвердите пароль',
			'auth.register.submit' => 'Создать аккаунт',
			'auth.register.loading' => 'Создание аккаунта...',
			'auth.register.errors.passwordMismatch' => 'Пароли не совпадают',
			'auth.register.errors.usernameTaken' => 'Имя пользователя уже занято',
			'auth.register.errors.weakPassword' => 'Пароль слишком слабый',
			'auth.register.errors.usernameTooShort' => 'Имя пользователя должно содержать не менее 3 символов',
			'auth.register.errors.passwordTooShort' => 'Пароль должен содержать не менее 6 символов',
			'auth.logout.title' => 'Выйти',
			'auth.logout.confirm' => 'Вы уверены, что хотите выйти?',
			'auth.logout.button' => 'Выйти',
			'chat.codeBlock.copy' => 'Копировать',
			'chat.codeBlock.copied' => 'Скопировано',
			'chat.codeBlock.copyCode' => 'Копировать код',
			'chat.copyMessage.copy' => 'Копировать сообщение',
			'chat.copyMessage.copied' => 'Сообщение скопировано',
			'chat.copyMessage.failed' => 'Не удалось скопировать',
			'chat.copyMessage.selectFormat' => 'Выбрать формат копирования',
			'chat.copyMessage.copyAsMarkdown' => 'Копировать как Markdown',
			'chat.copyMessage.copyAsText' => 'Копировать как текст',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'П',
			'chat.messageTypes.error' => 'Ошибка',
			'chat.messageTypes.tool' => 'Инструмент',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.messageTypes.orchestrator' => 'Авто',
			'chat.orchestrator.routing.title' => 'Маршрутизация',
			'chat.orchestrator.routing.alternatives' => ({required Object list}) => 'Альтернативы: ${list}',
			'chat.orchestrator.routing.first' => ({required Object label, required Object task}) => '${label} — первый кандидат для ${task}',
			'chat.orchestrator.routing.skipped' => ({required Object label, required Object list}) => '${label} — предыдущие кандидаты пропущены (${list})',
			'chat.orchestrator.plan.title' => 'План',
			'chat.orchestrator.plan.disabled' => 'отключён',
			'chat.orchestrator.plan.awaitingConfirm' => 'Ожидание подтверждения плана.',
			'chat.orchestrator.plan.run' => 'Запустить план',
			'chat.orchestrator.plan.toggleStep' => 'Включить шаг',
			'chat.orchestrator.plan.confirmFailed' => 'Не удалось запустить — попробуйте снова.',
			'chat.orchestrator.plan.fallback' => 'планировщик недоступен — запасной вариант в один шаг',
			'chat.orchestrator.plan.templateSource' => 'из шаблона конвейера',
			'chat.orchestrator.plan.offSource' => 'планировщик выключен',
			'chat.orchestrator.plan.stepCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} шаг', few: '${count} шага', many: '${count} шагов', other: '${count} шага', ), 
			'chat.orchestrator.plan.supervisedSource' => 'контролируемый цикл',
			'chat.orchestrator.decision.title' => 'Решение супервизора',
			'chat.orchestrator.decision.iteration' => ({required Object n}) => 'итерация ${n}',
			'chat.orchestrator.decision.rationaleLabel' => 'Почему',
			'chat.orchestrator.decision.awaitingConfirm' => 'Ожидается ваше одобрение перед выполнением этих шагов.',
			'chat.orchestrator.decision.proposedSteps' => 'Предложенные шаги',
			'chat.orchestrator.decision.action.kContinue' => 'делегирование',
			'chat.orchestrator.decision.action.done' => 'завершено',
			'chat.orchestrator.decision.action.invalid' => 'нет решения',
			'chat.orchestrator.decision.outcome.success' => 'успех',
			'chat.orchestrator.decision.outcome.partial' => 'частично',
			'chat.orchestrator.decision.outcome.failed' => 'ошибка',
			'chat.orchestrator.delegation.title' => 'Делегированный шаг',
			'chat.orchestrator.delegation.openSession' => 'Открыть полный сеанс',
			'chat.orchestrator.delegation.attempt' => ({required Object n}) => 'попытка ${n}',
			'chat.orchestrator.delegation.retryStep' => 'Повторить / Исправить',
			'chat.orchestrator.delegation.continueStep' => 'Продолжить / Исправить',
			'chat.orchestrator.delegation.continueFailed' => 'Ошибка — попробуйте снова.',
			'chat.orchestrator.delegation.status.queued' => 'в очереди',
			'chat.orchestrator.delegation.status.running' => 'выполняется',
			'chat.orchestrator.delegation.status.done' => 'готово',
			'chat.orchestrator.delegation.status.failed' => 'ошибка',
			'chat.orchestrator.delegation.status.aborted' => 'прервано',
			'chat.orchestrator.delegation.status.skipped' => 'пропущено',
			'chat.orchestrator.delegation.status.awaitingDecision' => 'ожидает решения',
			'chat.orchestrator.delegation.attempts' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} попытка', few: '${count} попытки', many: '${count} попыток', other: '${count} попытки', ), 
			'chat.orchestrator.delegation.candidates' => ({required Object list}) => 'кандидаты: ${list}',
			'chat.orchestrator.delegation.candidateCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} кандидат', few: '${count} кандидата', many: '${count} кандидатов', other: '${count} кандидата', ), 
			'chat.orchestrator.summary.title' => 'Итоги',
			'chat.orchestrator.summary.progress' => ({required Object done, required Object total}) => 'Выполнено шагов: ${done}/${total}',
			'chat.orchestrator.summary.aborted' => 'прервано',
			'chat.orchestrator.summary.timedOut' => 'истекло время ожидания',
			'chat.orchestrator.summary.capped' => 'лимит итераций',
			'chat.orchestrator.summary.failed' => ({required Object list}) => 'Шаги с ошибкой: ${list}',
			'chat.orchestrator.summary.kContinue' => 'Продолжить',
			'chat.orchestrator.summary.continueWork' => 'Продолжить работу',
			'chat.orchestrator.summary.resumeFailed' => 'Не удалось возобновить — попробуйте снова.',
			'chat.orchestrator.summary.runNextTask' => 'Запустить следующую задачу',
			'chat.orchestrator.summary.endAllTasks' => 'Завершить все задачи',
			'chat.orchestrator.summary.tasksRunning' => 'Выполнение задач…',
			'chat.orchestrator.summary.cancelTasks' => 'Отмена',
			'chat.orchestrator.backToParent' => 'Назад к оркестрации',
			'chat.orchestrator.taskmaster.title' => 'Очередь задач',
			'chat.orchestrator.taskmaster.remaining' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'осталась ${count}', few: 'осталось ${count}', many: 'осталось ${count}', other: 'осталось ${count}', ), 
			'chat.orchestrator.taskmaster.status.started' => 'выполняется',
			'chat.orchestrator.taskmaster.status.done' => 'готово',
			'chat.orchestrator.taskmaster.status.complete' => 'завершено',
			'chat.orchestrator.taskmaster.status.failed' => 'ошибка',
			'chat.orchestrator.taskmaster.status.paused' => 'приостановлено',
			'chat.orchestrator.taskmaster.status.blocked' => 'заблокировано',
			'chat.orchestrator.taskmaster.status.aborted' => 'прервано',
			'chat.orchestrator.gate.timedOut' => 'истекло время ожидания',
			'chat.orchestrator.gate.exit' => ({required Object code}) => 'код выхода ${code}',
			'chat.tools.settings' => 'Настройки инструмента',
			'chat.tools.error' => 'Ошибка инструмента',
			'chat.tools.result' => 'Результат инструмента',
			'chat.tools.viewParams' => 'Просмотр входных параметров',
			'chat.tools.viewRawParams' => 'Просмотр сырых параметров',
			'chat.tools.viewDiff' => 'Просмотр различий редактирования для',
			'chat.tools.creatingFile' => 'Создание нового файла:',
			'chat.tools.updatingTodo' => 'Обновление списка задач',
			'chat.tools.read' => 'Чтение',
			'chat.tools.readFile' => 'Чтение файла',
			'chat.tools.updateTodo' => 'Обновить список задач',
			'chat.tools.readTodo' => 'Прочитать список задач',
			'chat.tools.searchResults' => 'результаты',
			'chat.tools.todoReadLabel' => 'TodoRead: чтение списка задач',
			'chat.search.found' => ({required Object count, required Object type}) => 'Найдено ${count} ${type}',
			'chat.search.file' => 'файл',
			'chat.search.files' => 'файлов',
			'chat.search.pattern' => 'шаблон:',
			'chat.search.kIn' => 'в:',
			'chat.fileOperations.updated' => 'Файл успешно обновлен',
			'chat.fileOperations.created' => 'Файл успешно создан',
			'chat.fileOperations.written' => 'Файл успешно записан',
			'chat.fileOperations.diff' => 'Различия',
			'chat.fileOperations.newFile' => 'Новый файл',
			'chat.fileOperations.viewContent' => 'Просмотр содержимого файла',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Просмотр полного вывода (${count} символов)',
			'chat.fileOperations.contentDisplayed' => 'Содержимое файла отображено в представлении различий выше',
			'chat.interactive.title' => 'Интерактивный запрос',
			'chat.interactive.waiting' => 'Ожидание вашего ответа в CLI',
			'chat.interactive.instruction' => 'Пожалуйста, выберите опцию в терминале, где запущен Claude.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude выбрал опцию ${number}',
			'chat.interactive.instructionDetail' => 'В CLI вы бы выбрали эту опцию интерактивно, используя клавиши со стрелками или введя номер.',
			'chat.thinking.title' => 'Думаю...',
			'chat.thinking.emoji' => '💭 Думаю...',
			'chat.thinking.thoughtFewSeconds' => 'Размышлял несколько секунд',
			'chat.json.response' => 'JSON ответ',
			'chat.permissions.grant' => ({required Object tool}) => 'Предоставить разрешение для ${tool}',
			'chat.permissions.added' => 'Разрешение добавлено',
			'chat.permissions.addTo' => ({required Object entry}) => 'Добавляет ${entry} в разрешенные инструменты.',
			'chat.permissions.retry' => 'Разрешение сохранено. Повторите запрос для использования инструмента.',
			'chat.permissions.error' => 'Не удалось обновить разрешения. Попробуйте снова.',
			'chat.permissions.openSettings' => 'Открыть настройки',
			'chat.permissions.allow' => 'Разрешить',
			'chat.permissions.always' => 'Всегда',
			'chat.permissions.editAndAllow' => 'Изменить и разрешить',
			'chat.permissions.deny' => 'Запретить',
			'chat.permissions.reject' => 'Отклонить',
			'chat.permissions.allowAll' => ({required Object count}) => 'Разрешить все (${count})',
			'chat.permissions.editInput' => 'Изменить ввод',
			'chat.permissions.invalidJson' => 'Неверный JSON',
			'chat.permissions.allowWithChanges' => 'Разрешить с изменениями',
			'chat.todo.updated' => 'Список задач успешно обновлен',
			'chat.todo.current' => 'Текущий список задач',
			'chat.plan.viewPlan' => '📋 Просмотр плана реализации',
			'chat.plan.title' => 'План реализации',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Достигнут лимит использования Claude. Ваш лимит будет сброшен в **${time} ${timezone}** - ${date}',
			'chat.codex.permissionMode' => 'Режим разрешений',
			'chat.codex.modes.kDefault' => 'Режим по умолчанию',
			'chat.codex.modes.auto' => 'Авторежим',
			'chat.codex.modes.acceptEdits' => 'Принимать правки',
			'chat.codex.modes.bypassPermissions' => 'Обход разрешений',
			'chat.codex.modes.plan' => 'Режим планирования',
			'chat.codex.descriptions.kDefault' => 'Только доверенные команды (ls, cat, grep, git status и т.д.) выполняются автоматически. Другие команды пропускаются. Может записывать в рабочее пространство.',
			'chat.codex.descriptions.auto' => 'Классификатор модели решает для каждого вызова инструмента, одобрить или отклонить. Высокая автономность.',
			'chat.codex.descriptions.acceptEdits' => 'Все команды выполняются автоматически в рабочем пространстве. Полный автоматический режим с изолированным выполнением.',
			'chat.codex.descriptions.bypassPermissions' => 'Полный системный доступ без ограничений. Все команды выполняются автоматически с полным доступом к диску и сети. Используйте с осторожностью.',
			'chat.codex.descriptions.plan' => 'Режим планирования - команды не выполняются',
			'chat.codex.technicalDetails' => 'Технические детали',
			'chat.voice.autoRead' => 'Читать ответы вслух',
			'chat.voice.autoReadOn' => 'Чтение ответов вслух: вкл',
			'chat.voice.autoReadOff' => 'Чтение ответов вслух: выкл',
			'chat.voice.autoReadVoice' => 'Голос озвучки',
			'chat.voice.autoReadVoiceAuto' => 'Автоматический голос',
			'chat.voice.autoReadPreview' => 'Так будут звучать ответы.',
			'chat.voice.speakMessage' => 'Прочитать вслух',
			'chat.voice.stopSpeaking' => 'Остановить чтение',
			'chat.input.placeholder' => ({required Object provider}) => 'Введите / для команд, @ для файлов, или спросите ${provider} что угодно...',
			'chat.input.placeholderDefault' => 'Введите ваше сообщение...',
			'chat.input.disabled' => 'Ввод отключен',
			'chat.input.attachFiles' => 'Прикрепить файлы',
			'chat.input.attachFilesDesc' => 'Загрузить фото, файлы или документы',
			'chat.input.takePhoto' => 'Сделать фото',
			'chat.input.takePhotoDesc' => 'Использовать камеру для фото',
			'chat.input.moreTools' => 'Больше инструментов',
			'chat.input.commandsDesc' => 'Обзор сочетаний клавиш и команд',
			'chat.input.clearInputDesc' => 'Отменить текущий текст',
			'chat.input.attachImages' => 'Прикрепить изображения',
			'chat.input.send' => 'Отправить',
			'chat.input.stop' => 'Остановить',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter — отправить • / — команды • @ — файлы',
			'chat.input.hintText.enter' => 'Enter — отправить • Shift+Enter — новая строка • / — команды • @ — файлы',
			'chat.input.hintText.queue' => 'Enter — поставить следующее сообщение в очередь',
			'chat.input.hintText.updateQueued' => 'Enter — обновить сообщение в очереди',
			'chat.input.clickToChangeMode' => 'Нажмите для смены режима разрешений',
			'chat.input.showAllCommands' => 'Показать все команды',
			'chat.input.clearInput' => 'Очистить ввод',
			'chat.input.scrollToBottom' => 'Прокрутить вниз',
			'chat.input.newMessage' => 'Новое сообщение',
			'chat.input.newMessages' => 'Новые сообщения',
			'chat.input.queue.sendNext' => 'Поставить следующее сообщение в очередь',
			'chat.input.queue.update' => 'Обновить сообщение в очереди',
			'chat.input.queue.label' => 'В очереди',
			'chat.input.queue.willSend' => 'Будет отправлено после завершения',
			'chat.input.queue.edit' => 'Редактировать сообщение в очереди',
			'chat.input.queue.delete' => 'Удалить сообщение из очереди',
			'chat.input.queue.failed' => 'Не удалось отправить',
			'chat.input.queue.sendNow' => 'Отправить сейчас',
			'chat.input.queue.sendNowAfterTurn' => 'Этот агент не принимает сообщения во время хода — оно будет отправлено после текущего хода',
			'chat.input.queue.filesAttached' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} файл прикреплён', few: '${count} файла прикреплено', many: '${count} файлов прикреплено', other: '${count} файла прикреплено', ), 
			'chat.input.autoContinueTasks' => 'Автопродолжение',
			'chat.input.autoContinueTasksTooltip' => 'Включите, чтобы Devin автоматически переходил к следующей задаче Task Master',
			'chat.input.offlineQueue.clear' => 'Отменить и очистить офлайн-очередь',
			'chat.input.offlineQueue.clearBtn' => 'Отмена',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} сообщений в офлайн-очереди — отправятся автоматически при переподключении',
			'chat.input.offlineQueue.single' => '1 сообщение в офлайн-очереди — отправится автоматически при переподключении',
			'chat.input.voice' => 'Голосовой ввод',
			'chat.input.voiceStart' => 'Надиктовать сообщение',
			'chat.input.voiceStop' => 'Остановить диктовку',
			'chat.input.pinFile' => 'Закрепить файл в контексте',
			'chat.input.voiceSettings' => 'Настройки голоса (STT)',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Камера недоступна: ${error}',
			'chat.composer.toolsAndActions' => 'Инструменты и действия',
			'chat.composer.toolsAndActionsDesc' => 'Инструменты и элементы управления полем ввода',
			'chat.composer.reasoning' => 'Рассуждает',
			'chat.composer.model' => 'Модель',
			'chat.composer.effortDefault' => 'По умолчанию',
			'chat.composer.loadingModels' => 'Загрузка моделей…',
			'chat.composer.modelMenu' => 'Выбрать модель и уровень рассуждений',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'Как должны одобряться действия ${provider}?',
			'chat.composer.favorites' => 'Избранное',
			'chat.composer.account' => 'Аккаунт',
			'chat.composer.accountMenu' => 'Выбрать аккаунт',
			'chat.composer.accountDefault' => 'Аккаунт по умолчанию',
			'chat.composer.accountAuto' => 'Авто (по умолчанию)',
			'chat.composer.accountIsDefault' => 'По умолчанию',
			'chat.composer.effortLevels.off' => 'Выкл.',
			'chat.composer.effortLevels.none' => 'Нет',
			'chat.composer.effortLevels.minimal' => 'Минимальный',
			'chat.composer.effortLevels.low' => 'Низкий',
			'chat.composer.effortLevels.medium' => 'Средний',
			'chat.composer.effortLevels.high' => 'Высокий',
			'chat.composer.effortLevels.xhigh' => 'Очень высокий',
			'chat.composer.effortLevels.max' => 'Максимальный',
			'chat.composer.effortLevels.ultra' => 'Ультра',
			'chat.composer.contextWindow' => ({required Object size}) => 'контекст ${size}',
			'chat.composer.accountAutoShort' => 'Авто',
			'chat.composer.uploadNoRecords' => 'Загрузка не вернула ни одной записи',
			'chat.providerSelection.title' => 'Выберите вашего AI-ассистента',
			'chat.providerSelection.description' => 'Выберите провайдера для начала нового разговора',
			'chat.providerSelection.selectModel' => 'Выбрать модель',
			'chat.providerSelection.workspace' => 'Рабочая область',
			'chat.providerSelection.noWorkspace' => 'Нет',
			'chat.providerSelection.clickToChangeWorkspace' => 'Нажмите, чтобы сменить рабочую область',
			'chat.providerSelection.chooseWorkspace' => 'Выберите рабочую область',
			'chat.providerSelection.searchWorkspaces' => 'Поиск рабочих областей...',
			'chat.providerSelection.noWorkspacesFound' => 'Рабочие области не найдены.',
			'chat.providerSelection.providerInfo.anthropic' => 'от Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'от OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI редактор кода',
			'chat.providerSelection.providerInfo.google' => 'от Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Готов использовать Claude с ${model}. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Готов использовать Cursor с ${model}. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Готов использовать Codex с ${model}. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'OpenCode с ${model} готов к работе. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Выберите провайдера выше для начала',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Готово с Devin ${model}',
			'chat.providerSelection.readyPrompt.orchestrator' => 'Готово в режиме Авто — маршрутизатор выбирает лучшую модель для каждого шага',
			'chat.providerSelection.autoGroup' => 'Авто',
			'chat.providerSelection.autoLabel' => 'Авто (оркестрация)',
			'chat.providerSelection.autoDescription' => 'Направляет каждый шаг к лучшему доступному провайдеру и модели',
			'chat.providerSelection.orchestrated' => 'оркестрация',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Нажмите <kbd>${shortcut}</kbd>, чтобы искать сессии, файлы и коммиты',
			'chat.providerSelection.all' => 'Все',
			'chat.providerSelection.free' => 'Бесплатные',
			'chat.providerSelection.noModelsFound' => 'Модели не найдены.',
			'chat.providerSelection.paid' => 'Платные',
			'chat.providerSelection.searchModels' => 'Поиск моделей...',
			'chat.providerSelection.addModel' => 'Добавить модель',
			'chat.providerSelection.chooseModel' => 'Выберите модель',
			'chat.providerSelection.chooseModelDescription' => 'Встроенные и пользовательские модели в одном списке',
			'chat.providerSelection.clickToChange' => 'Нажмите, чтобы сменить модель',
			'chat.providerSelection.favorites' => 'Избранное',
			'chat.providerSelection.loadingModels' => 'Загрузка моделей…',
			'chat.providerSelection.manageModels' => 'Управление моделями',
			'chat.providerSelection.refresh' => 'Обновить модели',
			'chat.session.kContinue.title' => 'Продолжить разговор',
			'chat.session.kContinue.description' => 'Задавайте вопросы о вашем коде, запрашивайте изменения или получайте помощь с задачами разработки',
			'chat.session.kContinue.action' => 'Продолжить ввод',
			'chat.session.loading.olderMessages' => 'Загрузка старых сообщений...',
			'chat.session.loading.sessionMessages' => 'Загрузка сообщений сеанса...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => 'Показано ${shown} из ${total} сообщений',
			'chat.session.messages.scrollToLoad' => 'Прокрутите вверх для загрузки еще',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Показаны последние ${count} сообщений (всего ${total})',
			'chat.session.messages.loadEarlier' => 'Загрузить более ранние сообщения',
			'chat.session.messages.loadOlderFailed' => 'Не удалось загрузить старые сообщения.',
			'chat.session.messages.retry' => 'Повторить',
			'chat.session.messages.loadAll' => 'Загрузить все сообщения',
			'chat.session.messages.loadingAll' => 'Загрузка всех сообщений...',
			'chat.session.messages.allLoaded' => 'Все сообщения загружены',
			'chat.session.messages.perfWarning' => 'Все сообщения загружены — прокрутка может быть медленнее. Нажмите "Прокрутить вниз" для восстановления производительности.',
			'chat.session.messages.noSearchMatches' => 'Нет сообщений, соответствующих запросу.',
			'chat.session.messages.loadOlder' => 'Загрузить старые сообщения',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Загрузить все (${count})',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Повторить загрузку старых — ${error}',
			'chat.session.deleteConfirm' => 'Удаляет сессию и её транскрипт. Действие необратимо.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Завершите запуск перед сменой рабочей области',
			'chat.session.fallbackTitle' => 'Сессия',
			'chat.shell.selectProject.title' => 'Выберите проект',
			'chat.shell.selectProject.description' => 'Выберите проект для открытия интерактивной оболочки в этом каталоге',
			'chat.shell.status.newSession' => 'Новый сеанс',
			'chat.shell.status.initializing' => 'Инициализация...',
			'chat.shell.status.restarting' => 'Перезапуск...',
			'chat.shell.actions.disconnect' => 'Отключиться',
			'chat.shell.actions.disconnectTitle' => 'Отключиться от оболочки',
			'chat.shell.actions.restart' => 'Перезапустить',
			'chat.shell.actions.restartTitle' => 'Перезапустить оболочку (сначала отключитесь)',
			'chat.shell.actions.kill' => 'Завершить (SIGINT)',
			'chat.shell.actions.killTitle' => 'Завершить выполняющийся процесс (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Копировать вывод',
			'chat.shell.actions.copyOutputTitle' => 'Копировать вывод терминала',
			'chat.shell.actions.copied' => 'Скопировано!',
			'chat.shell.actions.zoomInTitle' => 'Увеличить',
			'chat.shell.actions.zoomOutTitle' => 'Уменьшить',
			'chat.shell.actions.connect' => 'Продолжить в оболочке',
			'chat.shell.actions.connectTitle' => 'Подключиться к оболочке',
			'chat.shell.loading' => 'Загрузка терминала...',
			'chat.shell.connecting' => 'Подключение к оболочке...',
			'chat.shell.startSession' => 'Начать новый сеанс Claude',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Возобновить сеанс: ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => 'Выполнить ${command} в ${projectName}',
			'chat.shell.startCli' => ({required Object projectName}) => 'Запуск Claude CLI в ${projectName}',
			'chat.shell.defaultCommand' => 'команда',
			'chat.claudeStatus.actions.thinking' => 'Думает',
			'chat.claudeStatus.actions.processing' => 'Обрабатывает',
			'chat.claudeStatus.actions.analyzing' => 'Анализирует',
			'chat.claudeStatus.actions.working' => 'Работает',
			'chat.claudeStatus.actions.computing' => 'Вычисляет',
			'chat.claudeStatus.actions.reasoning' => 'Рассуждает',
			'chat.claudeStatus.state.live' => 'В сети',
			'chat.claudeStatus.state.paused' => 'Приостановлен',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}с',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}м ${seconds}с',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => 'Прошло ${time}',
			'chat.claudeStatus.elapsed.startingNow' => 'Начинается сейчас',
			'chat.claudeStatus.stop' => 'Остановить',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Выполняется ${count} фоновая задача', few: 'Выполняются ${count} фоновые задачи', many: 'Выполняется ${count} фоновых задач', other: 'Выполняется ${count} фоновой задачи', ), 
			'chat.claudeStatus.controls.stopGeneration' => 'Остановить генерацию',
			'chat.claudeStatus.controls.pressEscToStop' => 'Нажмите Esc в любое время для остановки',
			'chat.claudeStatus.providers.assistant' => 'Ассистент',
			'chat.claudeStatus.backgroundTasksTitle' => 'Выполняется в фоне',
			'chat.claudeStatus.backgroundTaskUnnamed' => 'Задача без названия',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Выберите проект для начала чата с ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Начать следующую задачу',
			'chat.splitSession.toggle' => 'Разделить сессию',
			'chat.splitSession.close' => 'Закрыть разделённую сессию',
			'chat.splitSession.selectSession' => 'Выберите сессию для сравнения',
			'chat.splitSession.noOtherSessions' => 'Других сессий нет',
			'chat.splitSession.newSessionOption' => '+ Новая сессия в разделённом виде',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Текущий проект (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Другие проекты',
			'chat.splitSession.recentSessionsGroup' => 'Недавние сессии',
			'chat.splitSession.startNewSession' => 'Начать новую сессию в разделённом виде',
			'chat.splitSession.selectFromList' => 'Выберите сессию из списка существующих',
			'chat.sessionPicker.title' => 'Выбрать сессию',
			'chat.sessionPicker.searchPlaceholder' => 'Поиск сессий...',
			'chat.sessionPicker.clearSearch' => 'Очистить поиск',
			'chat.sessionPicker.newChat' => '+ Новый чат',
			'chat.sessionPicker.archivedToggle' => 'Архивные',
			'chat.sessionPicker.changeSession' => 'Сменить сессию',
			'chat.sessionPicker.archivedLoading' => 'Загрузка архивных сессий...',
			'chat.sessionPicker.archivedError' => 'Не удалось загрузить архивные сессии',
			'chat.sessionPicker.archivedEmpty' => 'Нет архивных сессий',
			'chat.sessionPicker.archivedProjectOnly' => 'Рабочая область архивирована — восстановите её, чтобы увидеть сессии.',
			'chat.sessionPicker.emptySearch' => 'Нет сессий, соответствующих поиску',
			'chat.sessionPicker.restore' => 'Восстановить',
			'chat.sessionPicker.restoreSession' => 'Восстановить сессию',
			'chat.sessionPicker.restoreProject' => 'Восстановить рабочую область',
			'chat.sessionPicker.restoreSessionFailed' => 'Не удалось восстановить сессию. Попробуйте снова.',
			'chat.sessionPicker.restoreProjectFailed' => 'Не удалось восстановить рабочую область. Попробуйте снова.',
			'chat.sessionPicker.archiveFailed' => 'Не удалось архивировать сессию. Попробуйте снова.',
			'chat.sessionPicker.deleteFailed' => 'Не удалось удалить сессию. Попробуйте снова.',
			'chat.sessionPicker.running' => 'Сессия выполняется',
			'chat.sessionPicker.unread' => 'Непрочитано — завершена с новым выводом',
			'chat.sessionPicker.account' => 'Аккаунт',
			'chat.splitWorkspace.addChat' => 'Добавить панель чата',
			'chat.splitWorkspace.addBrowser' => 'Добавить панель браузера',
			'chat.splitWorkspace.addTerminal' => 'Добавить панель терминала',
			'chat.splitWorkspace.addPreview' => 'Добавить панель предпросмотра',
			'chat.splitWorkspace.overview' => 'Показать все панели',
			'chat.splitWorkspace.exitFocusMode' => 'Выйти из режима фокуса (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => 'Режим фокуса (Ctrl+Shift+F)',
			'chat.splitWorkspace.broadcast' => 'Отправить во все сеансы',
			'chat.splitWorkspace.addNotes' => 'Добавить панель общих заметок',
			'chat.splitWorkspace.browseSessions' => 'Открыть список сессий',
			'chat.splitOverview.title' => 'Обзор разделённых панелей',
			'chat.splitOverview.count' => ({required Object count}) => '${count} панелей',
			'chat.splitOverview.close' => 'Закрыть обзор',
			'chat.splitOverview.question' => 'ВОПРОС — требуется ввод',
			'chat.splitOverview.processing' => 'ОБРАБОТКА',
			'chat.splitOverview.idle' => 'Бездействует',
			'chat.splitOverview.active' => 'Активна',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} ждёт вашего ответа',
			'chat.askUserQuestion.skip' => 'Пропустить',
			'chat.askUserQuestion.other' => 'Другое…',
			'chat.askUserQuestion.answerHint' => 'Введите ваш ответ…',
			'chat.attachments.downloadFailedRetry' => 'Загрузка не удалась — нажмите, чтобы повторить',
			'chat.attachments.fileAttachment' => 'Вложение',
			'chat.attachments.download' => ({required Object name}) => 'Скачать ${name}',
			'chat.attachments.attachedFile' => 'Прикреплённый файл',
			'chat.attachments.downloaded' => ({required Object name}) => '${name} загружен',
			'chat.checkpoint.creating' => 'Создание снимка…',
			'chat.checkpoint.revertChanges' => 'Вернуть файлы к последнему чекпоинту',
			'chat.checkpoint.undo' => 'Отменить чекпоинт',
			'chat.checkpoint.undoAiRun' => 'Отменить запуск AI',
			'chat.checkpoint.undoing' => 'Отмена…',
			'chat.checkpoint.undone' => 'Отменено',
			'chat.checkpoint.beforeAiTurn' => 'перед ходом ИИ',
			'chat.common.close' => 'Закрыть',
			'chat.taskMaster.saveToTask' => 'Задача',
			'chat.taskMaster.saved' => 'Сохранено',
			'chat.taskMaster.saving' => 'Сохранение...',
			'chat.taskMaster.taskShort' => 'ЗАДАЧА',
			'chat.taskMaster.addToTask' => 'Добавить в TaskMaster',
			'chat.taskMaster.added' => 'Добавлено в TaskMaster',
			'chat.taskMaster.defaultTaskTitle' => 'Задача из чата',
			'chat.tokenUsage.desc' => 'Просмотр потребления токенов в сессии',
			'chat.tokenUsage.title' => 'Использование токенов',
			'chat.tokenUsage.notAvailable' => 'н/д',
			'chat.tokenUsage.tokensBadge' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} токен', few: '${count} токена', many: '${count} токенов', other: '${count} токена', ), 
			'chat.tool.emptyResult' => '(пока нет вывода — инструмент вернул пустой результат)',
			'chat.quotaBadge.ariaLabel' => 'Лимиты подписки',
			'chat.quotaBadge.noData' => 'Нет данных о подписке для этой модели',
			'chat.quotaBadge.noSubscription' => 'нет подписки',
			'chat.quotaBadge.windowLineReset' => ({required Object label, required Object percent, required Object time}) => '${label}: ${percent}% · сброс ${time}',
			'chat.quotaBadge.windowRemaining' => ({required Object percent}) => 'До сброса осталось ${percent}% окна',
			'chat.broadcast.title' => 'Отправить во все сеансы',
			'chat.broadcast.noSessions' => 'Нет доступных сеансов',
			'chat.broadcast.placeholder' => 'Сообщение для каждого выбранного сеанса…',
			'chat.broadcast.partial' => ({required Object count}) => 'Сеансов, отклонивших сообщение: ${count}',
			'chat.broadcast.sent' => ({required Object count}) => 'Поставлено в очередь для сеансов: ${count}',
			'chat.broadcast.selectAll' => 'Выбрать все',
			'chat.broadcast.selectOrchestrators' => 'Выбрать оркестраторы',
			'chat.broadcast.orchestratorsOnly' => 'Только оркестраторы',
			'chat.broadcast.noOrchestrators' => 'Нет доступных сессий оркестратора',
			'chat.broadcast.sending' => 'Отправка…',
			'chat.broadcast.send' => ({required Object count}) => 'Отправить (${count})',
			'chat.paneHeader.processing' => 'Обработка…',
			'chat.paneHeader.switchSession' => 'Сменить сессию',
			'chat.export.sessionTitle' => ({required Object id}) => 'Сессия ${id}',
			'chat.export.pdfFailed' => 'Не удалось экспортировать PDF',
			'chat.export.transcriptDownloaded' => 'Транскрипт скачан',
			'chat.export.savedTo' => ({required Object path}) => 'Сохранено ${path}',
			'chat.commandResult.fallback.models' => 'Просмотрите доступные модели для активного провайдера.',
			'chat.commandResult.fallback.cost' => 'Просмотрите использование токенов для активной сессии.',
			'chat.commandResult.fallback.status' => 'Проверьте состояние среды выполнения, версии, провайдера и окружения.',
			'chat.commandResult.fallback.memory' => 'Откройте файл памяти CLAUDE.md проекта.',
			'chat.commandResult.fallback.config' => 'Откройте настройки и конфигурацию.',
			'chat.commandResult.fallback.help' => 'Показать документацию и синтаксис команд.',
			'chat.commandResult.filterCommands' => 'Фильтр команд...',
			'chat.commandResult.searchModels' => ({required Object provider}) => 'Поиск моделей ${provider}...',
			'chat.commands.runConfirmTitle' => 'Выполнить команду?',
			'chat.commands.executionCancelled' => 'Выполнение команды отменено',
			'chat.commands.bashConfirmMessage' => 'Эта команда содержит команды bash, которые будут выполнены. Продолжить?',
			'chat.commands.proceed' => 'Продолжить',
			'chat.pinFile.title' => 'Закрепить файл',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.action' => 'Закрепить',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => 'Изменить ${name}',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => 'Удалить ${name}',
			'chat.modelLibrary.enterNameAndId' => 'Введите и имя модели, и ID модели.',
			'chat.modelLibrary.idNoSpaces' => 'ID модели не может содержать пробелы.',
			'chat.modelLibrary.setAsDefault' => 'Сделать по умолчанию',
			'chat.modelLibrary.defaultModel' => 'Модель по умолчанию',
			'chat.modelLibrary.title' => 'Библиотека моделей',
			'chat.modelLibrary.subtitle' => 'Добавьте ID моделей, которые поддерживает ваш провайдер. Встроенные модели заблокированы. Кружок отмечает модель по умолчанию.',
			'chat.modelLibrary.yourModels' => 'Ваши модели',
			'chat.modelLibrary.yourModelsHint' => 'Редактируемые, хранятся в auth.db',
			'chat.modelLibrary.emptyTitle' => 'Пока нет пользовательских моделей',
			'chat.modelLibrary.emptyHint' => 'Добавьте модель через форму — она появится во всех списках выбора моделей.',
			'chat.modelLibrary.builtInModels' => 'Встроенные модели',
			'chat.modelLibrary.builtInModelsHint' => 'Поддерживаются DDAgent, только для чтения',
			'chat.modelLibrary.editTitle' => 'Изменить пользовательскую модель',
			'chat.modelLibrary.addTitle' => 'Добавить пользовательскую модель',
			'chat.modelLibrary.idSentAsWritten' => ({required Object provider}) => 'ID отправляется в ${provider} в точности как написан.',
			'chat.modelLibrary.nameLabel' => 'Название модели',
			'chat.modelLibrary.nameHint' => 'например, GPT-5.5 Pro',
			'chat.modelLibrary.idLabel' => 'ID модели',
			'chat.modelLibrary.idHint' => 'например, gpt-5.5-pro',
			'chat.modelLibrary.idHelp' => 'Используйте точный идентификатор, который принимает CLI провайдера. ID не может содержать пробелы.',
			'chat.modelLibrary.updatedNotice' => ({required Object name}) => '${name} обновлена.',
			'chat.modelLibrary.addedNotice' => ({required Object name}) => '${name} добавлена.',
			'chat.modelLibrary.deletedNotice' => ({required Object name}) => '${name} удалена.',
			'chat.modelLibrary.saving' => 'Сохранение…',
			'chat.modelLibrary.saveChanges' => 'Сохранить изменения',
			'chat.modelLibrary.deleteConfirm' => 'Удалить эту модель из всех списков выбора?',
			'chat.modelLibrary.customBadge' => 'Свой',
			'chat.changes.failedToLoad' => 'Не удалось загрузить изменения',
			'chat.changes.empty' => 'Нет изменений файлов',
			'chat.message.compactedSummary' => 'Сжатая сводка',
			_ => null,
		} ?? switch (path) {
			'chat.message.resendHint' => 'Отправить повторно из поля ввода',
			'chat.message.rawView' => 'Исходный вид',
			'chat.message.runComplete' => 'Запуск завершён',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Запрос разрешения · ${tool}',
			'chat.permissionRequest.question' => 'Вопрос',
			'chat.permissionRequest.subagent' => 'Субагент',
			'chat.permissionRequest.viewersCannotApprove' => 'Наблюдатели не могут подтверждать',
			'chat.permissionRequest.recap.timedOut' => 'Время истекло — отклонено автоматически',
			'chat.permissionRequest.recap.cancelled' => 'Отменено — ход был остановлен',
			'chat.permissionRequest.recap.autoApproved' => 'Подтверждено автоматически',
			'chat.permissionRequest.recap.expired' => 'Срок запроса истёк — агент больше его не ждёт',
			'chat.permissionRequest.recap.answered' => 'Отвечено',
			'chat.permissionRequest.recap.skipped' => 'Пропущено',
			'chat.permissionRequest.recap.decided' => 'Решено',
			'chat.permissionRequest.needsApproval' => ({required Object tool}) => '${tool} требует подтверждения',
			'chat.permissionRequest.subagentNeedsApproval' => ({required Object tool}) => 'Субагент: ${tool} требует подтверждения',
			'chat.permissionRequest.moreQuestions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Ожидает ещё ${count} вопрос', few: 'Ожидают ещё ${count} вопроса', many: 'Ожидают ещё ${count} вопросов', other: 'Ожидают ещё ${count} вопроса', ), 
			'chat.commandDialog.help.eyebrow' => 'Командный центр',
			'chat.commandDialog.help.title' => 'Справка и горячие клавиши',
			'chat.commandDialog.help.subtitle' => 'Поиск встроенных команд, шаблонов синтаксиса и способов использования.',
			'chat.commandDialog.models.eyebrow' => 'Выбор модели',
			'chat.commandDialog.models.title' => 'Выберите модель',
			'chat.commandDialog.models.subtitle' => 'Выберите модель, которую будет использовать этот провайдер.',
			'chat.commandDialog.models.modelSetTo' => ({required Object model}) => 'Выбрана модель ${model}.',
			'chat.commandDialog.models.activeModel' => 'Активная модель',
			'chat.commandDialog.models.noModelsMatch' => 'Нет моделей, соответствующих фильтру.',
			'chat.commandDialog.models.choiceSavedForSession' => 'Ваш выбор сохраняется для этой сессии и становится значением по умолчанию для новых чатов.',
			'chat.commandDialog.models.choiceDefault' => 'Выбранная модель станет моделью по умолчанию для новых чатов.',
			'chat.commandDialog.models.custom' => 'Свой',
			'chat.commandDialog.models.currentSelection' => 'Текущий выбор',
			'chat.commandDialog.cost.eyebrow' => 'Телеметрия сессии',
			'chat.commandDialog.cost.title' => 'Использование токенов',
			'chat.commandDialog.cost.subtitle' => 'Количество входных, выходных и всего токенов в этой сессии.',
			'chat.commandDialog.cost.totalTokensUsed' => 'Всего использовано токенов',
			'chat.commandDialog.cost.inputTokens' => 'Входные токены',
			'chat.commandDialog.cost.cacheReadTokens' => 'Токены чтения из кэша',
			'chat.commandDialog.cost.cacheWriteTokens' => 'Токены записи в кэш',
			'chat.commandDialog.cost.outputTokens' => 'Выходные токены',
			'chat.commandDialog.cost.breakdown' => 'Детализация',
			'chat.commandDialog.cost.unavailable' => 'Недоступно',
			'chat.commandDialog.cost.contextWindow' => 'Окно контекста',
			'chat.commandDialog.cost.estimatedCost' => 'Примерная стоимость',
			'chat.commandDialog.status.eyebrow' => 'Состояние среды',
			'chat.commandDialog.status.title' => 'Состояние системы',
			'chat.commandDialog.status.subtitle' => 'Версия, провайдер, среда выполнения и сведения об окружении.',
			'chat.commandDialog.status.package' => 'Пакет',
			'chat.commandDialog.status.uptime' => 'Время работы',
			'chat.commandDialog.status.platform' => 'Платформа',
			'chat.commandDialog.status.memory' => 'Память',
			'chat.commandDialog.status.memoryRss' => ({required Object mb}) => '${mb} МБ RSS',
			'chat.commandDialog.status.runtimeOnline' => 'Среда работает',
			'chat.commandDialog.status.processResponding' => ({required Object pid}) => 'Процесс #${pid} отвечает.',
			'chat.commandDialog.status.processStatusResponding' => 'Процесс отвечает.',
			'chat.commandDialog.status.healthy' => 'Исправно',
			'chat.commandDialog.defaultEyebrow' => 'Команда',
			'chat.commandDialog.defaultTitle' => 'Результат команды',
			'chat.commandDialog.escHint' => 'Esc закрывает окно.',
			'chat.commandDialog.unknown' => 'Неизвестно',
			'chat.commandDialog.noDescription' => 'Описание отсутствует.',
			'chat.commandDialog.noCommandsMatch' => 'Нет команд, соответствующих фильтру.',
			'chat.commandDialog.syntax.title' => 'Синтаксис',
			'chat.commandDialog.syntax.arguments' => ({required Object arguments, required Object first, required Object second}) => '${arguments} передаёт все аргументы; ${first}, ${second} — позиционные.',
			'chat.commandDialog.syntax.file' => ({required Object token}) => '${token} вставляет содержимое файла.',
			'chat.commandDialog.syntax.bash' => ({required Object token}) => '${token} запускает bash.',
			'chat.commandDialog.commandFinished' => 'Команда выполнена.',
			'chat.utilities.tokenUsageUnavailable' => 'Данные об использовании токенов недоступны',
			'chat.utilities.tooltip.tokensUsed' => ({required Object tokens}) => 'использовано токенов: ${tokens}',
			'chat.utilities.tooltip.contextOf' => ({required Object percent, required Object total}) => 'контекст ${percent}% из ${total}',
			'chat.utilities.tooltip.input' => ({required Object value}) => 'вход ${value}',
			'chat.utilities.tooltip.cache' => ({required Object read, required Object write}) => 'кэш: чтение ${read} · запись ${write}',
			'chat.utilities.tooltip.output' => ({required Object value}) => 'выход ${value}',
			'chat.utilities.used' => 'Использовано',
			'chat.utilities.cacheWrite' => 'Запись в кэш',
			'chat.utilities.contextLabel' => 'Контекст',
			'chat.utilities.usageUnsupported' => 'учёт расхода не поддерживается',
			'chat.utilities.chatTranscript' => 'Стенограмма чата',
			'chat.utilities.you' => 'Вы:',
			'chat.utilities.providerAutoMini' => 'Авто (mini)',
			'chat.toolBlocks.moreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '… ещё ${count} строка', few: '… ещё ${count} строки', many: '… ещё ${count} строк', other: '… ещё ${count} строки', ), 
			'chat.toolBlocks.status.running' => 'Выполняется',
			'chat.toolBlocks.status.denied' => 'Отклонено',
			'chat.toolBlocks.showLess' => 'Свернуть',
			'chat.toolBlocks.showMore' => 'Показать больше',
			'chat.toolBlocks.showMoreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Показать ещё ${count} строку', few: 'Показать ещё ${count} строки', many: 'Показать ещё ${count} строк', other: 'Показать ещё ${count} строки', ), 
			'chat.toolBlocks.tools' => 'Инструменты',
			'chat.toolBlocks.planReview' => 'Проверка плана',
			'chat.toolBlocks.planUpdate' => 'Обновление плана',
			'chat.toolBlocks.todoListUpdated' => 'Список задач обновлён',
			'chat.toolBlocks.creatingTask' => 'Создание задачи',
			'chat.toolBlocks.updatingTask' => 'обновление',
			'chat.toolBlocks.fetchingTask' => 'получение',
			'chat.toolBlocks.listingTasks' => 'получение списка задач',
			'chat.toolBlocks.search' => 'Поиск',
			'chat.toolBlocks.verbs.read' => 'чтение',
			'chat.toolBlocks.verbs.write' => 'запись',
			'chat.toolBlocks.verbs.edit' => 'правка',
			'chat.toolBlocks.verbs.delete' => 'удаление',
			'chat.toolBlocks.verbs.move' => 'перемещение',
			'chat.toolBlocks.subagent' => 'Субагент',
			'chat.toolBlocks.toolCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} инструмент', few: '${count} инструмента', many: '${count} инструментов', other: '${count} инструмента', ), 
			'chat.toolBlocks.result' => 'результат',
			'chat.toolBlocks.plusMore' => ({required Object count}) => '+${count} ещё',
			'chat.toolBlocks.plan' => 'План',
			'chat.toolBlocks.questionProgress' => ({required Object current, required Object total}) => 'Вопрос ${current}/${total}',
			'chat.toolBlocks.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} строка', few: '${count} строки', many: '${count} строк', other: '${count} строки', ), 
			'chat.toolBlocks.todoListItems' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Список задач (${count} пункт)', few: 'Список задач (${count} пункта)', many: 'Список задач (${count} пунктов)', other: 'Список задач (${count} пункта)', ), 
			'chat.toolBlocks.tasksCompleted' => ({required Object done, required Object total}) => 'выполнено ${done}/${total}',
			'chat.commandMenu.empty' => 'Нет доступных команд',
			'chat.commandMenu.namespaces.frequent' => 'Часто используемые',
			'chat.commandMenu.namespaces.builtin' => 'Встроенные команды',
			'chat.commandMenu.namespaces.skill' => 'Навыки',
			'chat.commandMenu.namespaces.project' => 'Команды проекта',
			'chat.commandMenu.namespaces.user' => 'Пользовательские команды',
			'chat.commandMenu.namespaces.other' => 'Другие команды',
			'chat.mentionMenu.kinds.file' => 'файл',
			'chat.mentionMenu.kinds.session' => 'сессия',
			'chat.mentionMenu.kinds.task' => 'задача',
			'chat.mentionMenu.taskTitle' => ({required Object id}) => 'Задача ${id}',
			'chat.subheader.contextTooltip' => ({required Object used, required Object total, required Object percent}) => 'Контекст: ${used} / ${total} токенов · использовано ${percent}%',
			'chat.transcript.requestFailed' => 'Запрос не выполнен',
			'chat.review.changedFiles' => 'Изменённые файлы',
			'chat.review.changedFilesCount' => ({required Object count}) => 'Изменённые файлы (${count})',
			'chat.review.subagent' => 'субагент',
			'codeEditor.toolbar.changes' => 'изменения',
			'codeEditor.toolbar.previousChange' => 'Предыдущее изменение',
			'codeEditor.toolbar.nextChange' => 'Следующее изменение',
			'codeEditor.toolbar.hideDiff' => 'Скрыть подсветку различий',
			'codeEditor.toolbar.showDiff' => 'Показать подсветку различий',
			'codeEditor.toolbar.settings' => 'Настройки редактора',
			'codeEditor.toolbar.collapse' => 'Свернуть редактор',
			'codeEditor.toolbar.expand' => 'Развернуть редактор на всю ширину',
			'codeEditor.toolbar.toggleDock' => 'Переключить панель файлов',
			'codeEditor.toolbar.diffMerge' => 'Diff / слияние',
			'codeEditor.toolbar.previewInBrowser' => 'Предпросмотр в браузере',
			'codeEditor.toolbar.reload' => 'Перезагрузить с диска',
			'codeEditor.loading' => ({required Object fileName}) => 'Загрузка ${fileName}...',
			'codeEditor.header.showingChanges' => 'Показаны изменения',
			'codeEditor.actions.copyPath' => 'Копировать путь к файлу',
			'codeEditor.actions.pathCopied' => 'Путь к файлу скопирован',
			'codeEditor.actions.download' => 'Скачать файл',
			'codeEditor.actions.save' => 'Сохранить',
			'codeEditor.actions.saving' => 'Сохранение...',
			'codeEditor.actions.saved' => 'Сохранено!',
			'codeEditor.actions.exitFullscreen' => 'Выйти из полноэкранного режима',
			'codeEditor.actions.fullscreen' => 'Полноэкранный режим',
			'codeEditor.actions.close' => 'Закрыть',
			'codeEditor.actions.previewMarkdown' => 'Предпросмотр markdown',
			'codeEditor.actions.editMarkdown' => 'Редактировать markdown',
			'codeEditor.actions.pinFile' => 'Закрепить файл в контексте',
			'codeEditor.actions.unpinFile' => 'Открепить файл от контекста',
			'codeEditor.actions.previewHtml' => 'Открыть HTML-предпросмотр в новой вкладке',
			'codeEditor.actions.retry' => 'Повторить',
			'codeEditor.actions.saveAll' => 'Сохранить все',
			'codeEditor.footer.lines' => 'Строк:',
			'codeEditor.footer.characters' => 'Символов:',
			'codeEditor.footer.shortcuts' => 'Нажмите Ctrl+S для сохранения • Esc для закрытия',
			'codeEditor.footer.plainText' => 'обычный текст',
			'codeEditor.footer.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} строка', few: '${count} строки', many: '${count} строк', other: '${count} строки', ), 
			'codeEditor.footer.modified' => 'изменён',
			'codeEditor.binaryFile.title' => 'Бинарный файл',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Файл "${fileName}" не может быть отображен в текстовом редакторе, так как это бинарный файл.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Невозможно отобразить как текст',
			'codeEditor.filePreview.loading' => 'Загрузка предпросмотра...',
			'codeEditor.filePreview.error' => 'Не удалось отобразить этот файл.',
			'codeEditor.filePreview.openInNewTab' => 'Открыть в новой вкладке',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Несохранённые изменения в ${name}',
			'codeEditor.discardUnsavedChanges' => 'Отменить несохранённые изменения?',
			'codeEditor.mediaFile.title' => 'Медиафайл',
			'codeEditor.mediaFile.subtitle' => 'Предпросмотр аудио и видео пока не поддерживается',
			'codeEditor.failedToLoad' => 'Не удалось загрузить файл',
			'codeEditor.hexDump.more' => ({required Object size}) => '… ещё ${size}',
			'codeEditor.settings.minimap' => 'Миникарта',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Размер табуляции: ${size}',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Размер шрифта −  (сейчас ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Размер шрифта +',
			'codeEditor.diff.noChanges' => 'Нет изменений',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Фрагмент ${number}',
			'codeEditor.diff.close' => 'Закрыть diff',
			'codeEditor.diff.base' => 'Базовый',
			'codeEditor.diff.current' => 'Текущий',
			'codeEditor.diff.applyMerge' => 'Применить слияние',
			'codeEditor.diff.deletedOnDisk' => 'удалён с диска',
			'codeEditor.diff.untrackedWillBeDeleted' => 'Этот неотслеживаемый файл будет удалён.',
			'codeEditor.diff.restoreConfirm' => ({required Object name}) => 'Восстановить ${name} до закоммиченного состояния?',
			'codeEditor.diff.headVsWorkingCopy' => 'HEAD и рабочая копия',
			'codeEditor.diff.savedVsBuffer' => 'Последнее сохранение и буфер (без git)',
			'codeEditor.diff.unchangedLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} неизменённая строка', few: '${count} неизменённые строки', many: '${count} неизменённых строк', other: '${count} неизменённой строки', ), 
			'codeEditor.diff.revertToSaved' => 'Вернуть сохранённую версию',
			'codeEditor.emptyState.title' => 'Файл не открыт',
			'codeEditor.emptyState.hint' => 'Откройте файлы на вкладке «Файлы»',
			'codeEditor.toasts.savedFile' => ({required Object name}) => 'Сохранено ${name}',
			'codeEditor.toasts.saveFailed' => 'Не удалось сохранить',
			'codeEditor.toasts.allSaved' => 'Всё сохранено',
			'codeEditor.toasts.someSavesFailed' => 'Некоторые сохранения не удались',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Сохранено в ${path}',
			'codeEditor.toasts.mergeApplied' => 'Слияние применено — сохраните, чтобы зафиксировать',
			'common.buttons.save' => 'Сохранить',
			'common.buttons.cancel' => 'Отмена',
			'common.buttons.delete' => 'Удалить',
			'common.buttons.create' => 'Создать',
			'common.buttons.edit' => 'Редактировать',
			'common.buttons.close' => 'Закрыть',
			'common.buttons.confirm' => 'Подтвердить',
			'common.buttons.submit' => 'Отправить',
			'common.buttons.retry' => 'Повторить',
			'common.buttons.refresh' => 'Обновить',
			'common.buttons.search' => 'Поиск',
			'common.buttons.clear' => 'Очистить',
			'common.buttons.copy' => 'Копировать',
			'common.buttons.download' => 'Скачать',
			'common.buttons.upload' => 'Загрузить',
			'common.buttons.browse' => 'Обзор',
			'common.buttons.update' => 'Обновить',
			'common.buttons.openDiagram' => 'Открыть диаграмму',
			'common.tabs.chat' => 'Чат',
			'common.tabs.shell' => 'Терминал',
			'common.tabs.files' => 'Файлы',
			'common.tabs.git' => 'Система контроля версий',
			'common.tabs.tasks' => 'Задачи',
			'common.tabs.board' => 'Доска',
			'common.tabs.browser' => 'Браузер',
			'common.tabs.computer' => 'Компьютер',
			'common.tabs.usage' => 'AI Control',
			'common.quota.controlCenter' => 'Центр управления AI',
			'common.quota.section.overview' => 'Обзор',
			'common.quota.section.quotas' => 'Квоты',
			'common.quota.section.usage' => 'Использование',
			'common.quota.section.agents' => 'Агенты',
			'common.quota.filter.all' => 'Все',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 дней',
			'common.quota.period.k30d' => '30 дней',
			'common.quota.period.all' => 'Все',
			'common.quota.group.provider' => 'Провайдер',
			'common.quota.group.model' => 'Модель',
			'common.quota.group.agent' => 'Агент',
			'common.quota.group.tool' => 'Инструмент',
			'common.quota.metric.tokens' => 'Токены',
			'common.quota.metric.input' => 'Ввод',
			'common.quota.metric.output' => 'Вывод',
			'common.quota.metric.cache' => 'Чтения кэша',
			'common.quota.metric.calls' => 'Вызовы API',
			'common.quota.metric.cost' => 'Стоимость',
			'common.quota.metric.sessions' => 'Сессии',
			'common.quota.cost.billed' => 'Оплачено (API + перерасход)',
			'common.quota.cost.listPrice' => 'Прейскурантная цена использованных токенов',
			'common.quota.cost.subscriptionValue' => 'Покрыто подписками',
			'common.quota.cost.cacheSavings' => 'Экономия кэша',
			'common.quota.cost3.billed' => 'Оплачено (API + перерасход)',
			'common.quota.cost3.listPrice' => 'Прейскурантная цена использованных токенов',
			'common.quota.cost3.subscriptionValue' => 'Покрыто подписками',
			'common.quota.overview.trendTitle' => 'Токены и стоимость — последние 7 дней',
			'common.quota.overview.effectiveCost' => 'Фактическая стоимость (7 дней)',
			'common.quota.overview.alertsTitle' => 'Оповещения',
			'common.quota.overview.noAlerts' => 'Сейчас ничего не требует внимания.',
			'common.quota.overview.limitsTitle' => 'Использование и лимиты',
			'common.quota.overview.activeTasks' => 'Активные задачи',
			'common.quota.overview.viewAccounts' => 'Все аккаунты',
			'common.quota.overview.viewAgents' => 'Все агенты',
			'common.quota.overview.noTasks' => 'Сейчас нет выполняющихся агентов.',
			'common.quota.usage.trendTitle' => 'Дневной тренд',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Разбивка по ${group}',
			'common.quota.usage.colName' => 'Имя',
			'common.quota.usage.sourceUnavailable' => 'Хранилище аналитики недоступно; данные не показаны.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} выполняется',
			'common.quota.agents.colAgent' => 'Агент',
			'common.quota.agents.colStatus' => 'Статус',
			'common.quota.agents.colTask' => 'Задача',
			'common.quota.agents.colModel' => 'Аккаунт / модель',
			'common.quota.agents.colTime' => 'Время',
			'common.quota.agents.empty' => 'Нет агентов, соответствующих фильтру.',
			'common.quota.agents.detailSession' => 'Сессия',
			'common.quota.agents.detailStarted' => 'Запущено',
			'common.quota.agents.detailRetries' => 'Повторы',
			'common.quota.agents.detailResult' => 'Результат',
			'common.quota.agents.notTracked' => 'не отслеживается',
			'common.quota.agentStatus.running' => 'Выполняется',
			'common.quota.agentStatus.waiting' => 'Ожидание',
			'common.quota.agentStatus.failed' => 'Ошибка',
			'common.quota.agentStatus.finished' => 'Завершено',
			'common.quota.agentStatus.queued' => 'В очереди',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: при текущем темпе лимит исчерпается через ${value}',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: использовано ${value}% (порог ${watch}%)',
			'common.quota.backToChat' => 'Назад к чату',
			'common.quota.syncNow' => 'Синхронизировать',
			'common.quota.generatedAt' => ({required Object value}) => 'Обновлено ${value}',
			'common.quota.loading' => 'Загрузка лимитов аккаунтов…',
			'common.quota.remaining' => ({required Object value}) => 'осталось ${value}%',
			'common.quota.resetsIn' => ({required Object value}) => 'сброс через ${value}',
			'common.quota.projected' => ({required Object value}) => 'при текущем темпе этот лимит исчерпается через ${value}',
			'common.quota.syncedAgo' => ({required Object value}) => 'синхронизировано ${value} назад',
			'common.quota.refreshAccount' => 'Обновить аккаунт',
			'common.quota.syncFailed' => 'Сбой синхронизации',
			'common.quota.history' => 'История',
			'common.quota.historyPoints' => ({required Object value}) => 'Записано ${value} показаний',
			'common.quota.historyEmpty' => 'История пока не записана',
			'common.quota.noAgents' => 'Нет назначенных агентов',
			'common.quota.noSubscription' => 'Нет подписки',
			'common.quota.noSubscriptionHint' => 'Провайдер не сообщает об активном плане для этого аккаунта.',
			'common.quota.quality.live' => 'Live',
			'common.quota.quality.cached' => 'Кэшировано',
			'common.quota.quality.estimate' => 'Оценка',
			'common.quota.quality.unknown' => 'Неизвестно',
			'common.quota.quality.error' => 'Ошибка',
			'common.quota.kpi.atRisk' => 'Лимиты под угрозой',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'аккаунтов выше ${value}%',
			'common.quota.kpi.windowsAtRisk' => 'Исчерпывающиеся окна',
			'common.quota.kpi.errored' => 'Сбои синхронизации',
			'common.quota.kpi.activeAgents' => 'Активные агенты',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} ожидают · ${queued} в очереди',
			'common.quota.kpi.nextReset' => 'Следующий сброс',
			'common.quota.kpi.tokens' => 'Токены',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} сессий',
			'common.quota.kpi.cost' => 'Оценочная стоимость',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} покрыто планами',
			'common.quota.empty.title' => 'Нет подключённых аккаунтов',
			'common.quota.empty.description' => 'Войдите в Claude, Codex, Gemini или CommandCode, чтобы квоты отслеживались здесь.',
			'common.quota.settings.title' => 'Оповещения и маршрутизация',
			'common.quota.settings.description' => 'Управляйте тем, когда панель предупреждает вас и как предлагаются аккаунты для новой работы.',
			'common.quota.settings.alertsEnabled' => 'Прогнозные и пороговые оповещения',
			'common.quota.settings.alertsEnabledHint' => 'Предупреждать до исчерпания лимита при текущем темпе, а не только на 90%.',
			'common.quota.settings.watchThreshold' => 'Порог наблюдения (%)',
			'common.quota.settings.dangerThreshold' => 'Порог опасности (%)',
			'common.quota.settings.routingMode' => 'Маршрутизация',
			'common.quota.settings.routing.manual' => 'Вручную — только рекомендация',
			'common.quota.settings.routing.ask' => 'Спрашивать перед сменой аккаунта',
			'common.quota.settings.routing.autoLowRisk' => 'Автопереключение для задач с низким риском',
			'common.quota.settings.logSources' => 'Источники журналов',
			'common.quota.settings.logSourcesHint' => 'Экраны использования и агентов читают эти источники только для чтения.',
			'common.quota.settings.quotaConsent' => 'Разрешить опрос квот',
			'common.quota.settings.quotaConsentHint' => 'Опрашивает эндпоинты провайдеров с вашими сохранёнными учётными данными для чтения лимитов в реальном времени.',
			'common.quota.settings.perAccount' => 'Переопределения по аккаунтам',
			'common.quota.settings.tab' => 'Настройки Control Center',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Все',
			'common.status.loading' => 'Загрузка...',
			'common.status.success' => 'Успешно',
			'common.status.error' => 'Ошибка',
			'common.status.failed' => 'Не удалось',
			'common.status.pending' => 'Ожидание',
			'common.status.completed' => 'Завершено',
			'common.status.inProgress' => 'В процессе',
			'common.messages.savedSuccessfully' => 'Успешно сохранено',
			'common.messages.deletedSuccessfully' => 'Успешно удалено',
			'common.messages.updatedSuccessfully' => 'Успешно обновлено',
			'common.messages.operationFailed' => 'Операция не удалась',
			'common.messages.networkError' => 'Ошибка сети. Проверьте подключение.',
			'common.messages.unauthorized' => 'Не авторизован. Пожалуйста, войдите.',
			'common.messages.notFound' => 'Не найдено',
			'common.messages.invalidInput' => 'Неверный ввод',
			'common.messages.requiredField' => 'Это поле обязательно',
			'common.messages.unknownError' => 'Произошла неизвестная ошибка',
			'common.messages.renameSessionFailed' => 'Не удалось переименовать сессию. Повторите попытку.',
			'common.navigation.settings' => 'Настройки',
			'common.navigation.home' => 'Главная',
			'common.navigation.back' => 'Назад',
			'common.navigation.next' => 'Далее',
			'common.navigation.previous' => 'Предыдущий',
			'common.navigation.logout' => 'Выйти',
			'common.navigation.backToChat' => 'Назад к чату',
			'common.common.language' => 'Язык',
			'common.common.theme' => 'Тема',
			'common.common.darkMode' => 'Темная тема',
			'common.common.lightMode' => 'Светлая тема',
			'common.common.name' => 'Имя',
			'common.common.description' => 'Описание',
			'common.common.enabled' => 'Включено',
			'common.common.disabled' => 'Отключено',
			'common.common.optional' => 'Необязательно',
			'common.common.version' => 'Версия',
			'common.common.select' => 'Выбрать',
			'common.common.selectAll' => 'Выбрать все',
			'common.common.deselectAll' => 'Снять выделение',
			'common.common.done' => 'Готово',
			'common.common.failed' => 'Не удалось',
			'common.time.justNow' => 'Только что',
			'common.time.minutesAgo' => ({required Object count}) => '${count} мин. назад',
			'common.time.hoursAgo' => ({required Object count}) => '${count} ч. назад',
			'common.time.daysAgo' => ({required Object count}) => '${count} дн. назад',
			'common.time.yesterday' => 'Вчера',
			'common.fileOperations.newFile' => 'Новый файл',
			'common.fileOperations.newFolder' => 'Новая папка',
			'common.fileOperations.rename' => 'Переименовать',
			'common.fileOperations.move' => 'Переместить',
			'common.fileOperations.copyPath' => 'Копировать путь',
			'common.fileOperations.openInEditor' => 'Открыть в редакторе',
			'common.mainContent.loading' => 'Загрузка DDAgent',
			'common.mainContent.settingUpWorkspace' => 'Настройка рабочего пространства...',
			'common.mainContent.chooseProject' => 'Выберите проект',
			'common.mainContent.selectProjectDescription' => 'Выберите проект на боковой панели, чтобы начать работу с Claude. Каждый проект содержит ваши сеансы чата и историю файлов.',
			'common.mainContent.tip' => 'Совет',
			'common.mainContent.createProjectMobile' => 'Нажмите кнопку меню выше для доступа к проектам',
			'common.mainContent.createProjectDesktop' => 'Создайте новый проект, нажав на значок папки на боковой панели',
			'common.mainContent.newSession' => 'Новый сеанс',
			'common.mainContent.untitledSession' => 'Безымянный сеанс',
			'common.mainContent.projectFiles' => 'Файлы проекта',
			'common.mainContent.focusMode' => 'Режим фокуса (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Выйти из режима фокуса (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Разделить сессию',
			'common.mainContent.closeSplitSession' => 'Закрыть разделённую сессию',
			'common.mainContent.chooseWorkspace' => 'Выберите рабочую область',
			'common.mainContent.chooseWorkspaceDescription' => 'Выберите рабочую область для этого чата или создайте новую в Настройках.',
			'common.mainContent.createWorkspace' => 'Создать рабочую область в Настройках',
			'common.mainContent.recentProjects' => 'Недавние проекты',
			'common.fileTree.loading' => 'Загрузка файлов...',
			'common.fileTree.files' => 'Файлы',
			'common.fileTree.simpleView' => 'Простой вид',
			'common.fileTree.compactView' => 'Компактный вид',
			'common.fileTree.detailedView' => 'Подробный вид',
			'common.fileTree.searchPlaceholder' => 'Поиск файлов и папок...',
			'common.fileTree.searchContentPlaceholder' => 'Поиск в файлах...',
			'common.fileTree.searchInFiles' => 'Поиск в файлах',
			'common.fileTree.searchByName' => 'Поиск по имени',
			'common.fileTree.clearSearch' => 'Очистить поиск',
			'common.fileTree.name' => 'Имя',
			'common.fileTree.size' => 'Размер',
			'common.fileTree.modified' => 'Изменено',
			'common.fileTree.permissions' => 'Права доступа',
			'common.fileTree.noFilesFound' => 'Файлы не найдены',
			'common.fileTree.checkProjectPath' => 'Проверьте доступность пути к проекту',
			'common.fileTree.loadFailed' => 'Не удалось загрузить файлы',
			'common.fileTree.noMatchesFound' => 'Совпадений не найдено',
			'common.fileTree.noSearchResults' => 'Совпадений не найдено',
			'common.fileTree.tryDifferentSearch' => 'Попробуйте другой поисковый запрос или очистите поиск',
			'common.fileTree.searchError' => 'Ошибка поиска',
			'common.fileTree.searching' => 'Поиск...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Показаны первые ${count} результатов',
			'common.fileTree.justNow' => 'только что',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} мин. назад',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} ч. назад',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} дн. назад',
			'common.fileTree.newFile' => 'Новый файл (Cmd+N)',
			'common.fileTree.newFolder' => 'Новая папка (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Обновить',
			'common.fileTree.collapseAll' => 'Свернуть все',
			'common.fileTree.context.rename' => 'Переименовать',
			'common.fileTree.context.delete' => 'Удалить',
			'common.fileTree.context.copyPath' => 'Копировать путь',
			'common.fileTree.context.download' => 'Скачать',
			'common.fileTree.context.newFile' => 'Новый файл',
			'common.fileTree.context.newFolder' => 'Новая папка',
			'common.fileTree.context.upload' => 'Загрузить файлы',
			'common.fileTree.context.refresh' => 'Обновить',
			'common.fileTree.context.menuLabel' => 'Контекстное меню файла',
			'common.fileTree.context.loading' => 'Загрузка...',
			'common.fileTree.allWorkspaces' => 'Все рабочие области',
			'common.fileTree.delete.confirm' => 'Удалить',
			'common.fileTree.delete.fileWarning' => 'Этот файл будет удалён безвозвратно.',
			'common.fileTree.delete.folderWarning' => 'Эта папка и всё её содержимое будут удалены безвозвратно.',
			'common.fileTree.delete.title' => ({required Object type}) => 'Удалить ${type}',
			'common.fileTree.dropToUpload' => 'Перетащите файлы для загрузки',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Перетащите файлы для загрузки в «${folder}»',
			'common.fileTree.noProject' => 'Сначала добавьте проект',
			'common.fileTree.noRecentFiles' => 'Нет файлов, изменённых за последние 7 дней',
			'common.fileTree.showAllFiles' => 'Показать все файлы',
			'common.fileTree.showAllFilesHint' => 'Отключите фильтр недавних, чтобы увидеть всё.',
			'common.fileTree.showRecentOnly' => 'Показать файлы, изменённые за последние 7 дней',
			'common.fileTree.toast.copyFailed' => 'Не удалось скопировать путь',
			'common.fileTree.toast.fileCreated' => 'Файл успешно создан',
			'common.fileTree.toast.fileDeleted' => 'Файл удалён',
			'common.fileTree.toast.folderCreated' => 'Папка успешно создана',
			'common.fileTree.toast.folderDeleted' => 'Папка удалена',
			'common.fileTree.toast.folderDownloaded' => 'Папка скачана как ZIP',
			'common.fileTree.toast.pathCopied' => 'Путь скопирован в буфер обмена',
			'common.fileTree.toast.renamed' => 'Успешно переименовано',
			'common.fileTree.uploadComplete' => 'Загрузка завершена',
			'common.fileTree.uploadFailed' => 'Загрузка не удалась',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Загрузить файлы (макс. ${size} каждый)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Загрузить файлы в «${folder}»',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => 'Загружено ${uploaded} из ${total} ${label}',
			'common.fileTree.uploadingFiles' => 'Загрузка файлов',
			'common.fileTree.validation.dotsOnly' => 'Имя файла не может состоять только из точек',
			'common.fileTree.validation.emptyName' => 'Имя файла не может быть пустым',
			'common.fileTree.validation.invalidChars' => 'Имя файла содержит недопустимые символы',
			'common.fileTree.validation.reserved' => 'Имя файла является зарезервированным',
			'common.projectWizard.title' => 'Создать новый проект',
			'common.projectWizard.steps.type' => 'Тип',
			'common.projectWizard.steps.configure' => 'Настройка',
			'common.projectWizard.steps.confirm' => 'Подтверждение',
			'common.projectWizard.step1.question' => 'У вас уже есть рабочее пространство или вы хотите создать новое?',
			'common.projectWizard.step1.existing.title' => 'Существующее рабочее пространство',
			'common.projectWizard.step1.existing.description' => 'У меня уже есть рабочее пространство на сервере, нужно только добавить его в список проектов',
			'common.projectWizard.step1.kNew.title' => 'Новое рабочее пространство',
			'common.projectWizard.step1.kNew.description' => 'Создать новое рабочее пространство, опционально клонировать из репозитория GitHub',
			'common.projectWizard.step2.existingPath' => 'Путь к рабочему пространству',
			'common.projectWizard.step2.newPath' => 'Путь к рабочему пространству',
			'common.projectWizard.step2.existingPlaceholder' => '/путь/к/существующему/пространству',
			'common.projectWizard.step2.newPlaceholder' => '/путь/к/новому/пространству',
			'common.projectWizard.step2.existingHelp' => 'Полный путь к каталогу вашего рабочего пространства',
			'common.projectWizard.step2.newHelp' => 'Полный путь к каталогу вашего рабочего пространства',
			'common.projectWizard.step2.githubUrl' => 'URL GitHub (необязательно)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => 'Необязательно: укажите URL GitHub для клонирования репозитория',
			'common.projectWizard.step2.githubAuth' => 'Аутентификация GitHub (необязательно)',
			'common.projectWizard.step2.githubAuthHelp' => 'Требуется только для приватных репозиториев. Публичные репозитории можно клонировать без аутентификации.',
			'common.projectWizard.step2.loadingTokens' => 'Загрузка сохраненных токенов...',
			'common.projectWizard.step2.storedToken' => 'Сохраненный токен',
			'common.projectWizard.step2.newToken' => 'Новый токен',
			'common.projectWizard.step2.nonePublic' => 'Нет (публичный)',
			'common.projectWizard.step2.selectToken' => 'Выбрать токен',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Выберите токен --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Этот токен будет использован только для этой операции',
			'common.projectWizard.step2.publicRepoInfo' => 'Публичные репозитории не требуют аутентификации. Вы можете пропустить токен при клонировании публичного репозитория.',
			'common.projectWizard.step2.noTokensHelp' => 'Нет доступных сохраненных токенов. Вы можете добавить токены в Настройки → API ключи для удобного повторного использования.',
			'common.projectWizard.step2.optionalTokenPublic' => 'Токен GitHub (необязательно для публичных репозиториев)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (оставьте пустым для публичных репозиториев)',
			'common.projectWizard.step3.reviewConfig' => 'Проверьте вашу конфигурацию',
			'common.projectWizard.step3.existingWorkspace' => 'Существующее рабочее пространство',
			'common.projectWizard.step3.newWorkspace' => 'Новое рабочее пространство',
			_ => null,
		} ?? switch (path) {
			'common.projectWizard.step3.path' => 'Путь:',
			'common.projectWizard.step3.cloneFrom' => 'Клонировать из:',
			'common.projectWizard.step3.authentication' => 'Аутентификация:',
			'common.projectWizard.step3.usingStoredToken' => 'Использование сохраненного токена:',
			'common.projectWizard.step3.usingProvidedToken' => 'Использование предоставленного токена',
			'common.projectWizard.step3.noAuthentication' => 'Без аутентификации',
			'common.projectWizard.step3.sshKey' => 'SSH ключ',
			'common.projectWizard.step3.existingInfo' => 'Рабочее пространство будет добавлено в список проектов и будет доступно для сеансов Claude/Cursor.',
			'common.projectWizard.step3.newWithClone' => 'Репозиторий будет клонирован в эту папку.',
			'common.projectWizard.step3.newEmpty' => 'Рабочее пространство будет добавлено в список проектов и будет доступно для сеансов Claude/Cursor.',
			'common.projectWizard.step3.cloningRepository' => 'Клонирование репозитория...',
			'common.projectWizard.buttons.cancel' => 'Отмена',
			'common.projectWizard.buttons.back' => 'Назад',
			'common.projectWizard.buttons.next' => 'Далее',
			'common.projectWizard.buttons.createProject' => 'Создать проект',
			'common.projectWizard.buttons.creating' => 'Создание...',
			'common.projectWizard.buttons.cloning' => 'Клонирование...',
			'common.projectWizard.errors.selectType' => 'Пожалуйста, выберите, есть ли у вас существующее рабочее пространство или вы хотите создать новое',
			'common.projectWizard.errors.providePath' => 'Пожалуйста, укажите путь к рабочему пространству',
			'common.projectWizard.errors.failedToCreate' => 'Не удалось создать рабочее пространство',
			'common.projectWizard.errors.failedToCreateFolder' => 'Не удалось создать папку',
			'common.notifications.genericTool' => 'инструмент',
			'common.notifications.codes.generic.info.title' => 'Уведомление',
			'common.notifications.codes.permission.required.title' => 'Требуется действие',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} ожидает вашего решения.',
			'common.notifications.codes.run.stopped.title' => 'Запуск остановлен',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Причина: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Запуск завершился сбоем',
			'common.notifications.codes.agent.notification.title' => 'Уведомление агента',
			'common.versionUpdate.title' => 'Доступно обновление',
			'common.versionUpdate.newVersionReady' => 'Новая версия готова',
			'common.versionUpdate.currentVersion' => 'Текущая версия',
			'common.versionUpdate.latestVersion' => 'Последняя версия',
			'common.versionUpdate.whatsNew' => 'Что нового:',
			'common.versionUpdate.viewFullRelease' => 'Посмотреть полный релиз',
			'common.versionUpdate.updateProgress' => 'Прогресс обновления:',
			'common.versionUpdate.manualUpgrade' => 'Ручное обновление:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Или нажмите "Обновить сейчас" для автоматического обновления.',
			'common.versionUpdate.updateCompleted' => 'Обновление успешно завершено!',
			'common.versionUpdate.restartServer' => 'Пожалуйста, перезапустите сервер для применения изменений.',
			'common.versionUpdate.updateFailed' => 'Обновление не удалось',
			'common.versionUpdate.buttons.close' => 'Закрыть',
			'common.versionUpdate.buttons.later' => 'Позже',
			'common.versionUpdate.buttons.copyCommand' => 'Копировать команду',
			'common.versionUpdate.buttons.updateNow' => 'Обновить сейчас',
			'common.versionUpdate.buttons.updating' => 'Обновление...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Закрыть модальное окно обновления версии',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Показать боковую панель',
			'common.versionUpdate.ariaLabels.settings' => 'Настройки',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Доступно обновление',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Закрыть боковую панель',
			'common.actions.cancel' => 'Отмена',
			'common.actions.retry' => 'Повторить',
			'common.actions.save' => 'Сохранить',
			'common.browserPane.address' => 'Адрес',
			'common.browserPane.back' => 'Назад',
			'common.browserPane.connecting' => 'Подключение к браузеру…',
			'common.browserPane.connectionFailed' => 'Не удалось подключиться к браузеру.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => 'Не удалось загрузить ${url}',
			'common.browserPane.disconnected' => 'Представление браузера отключено',
			'common.browserPane.enterUrl' => 'Введите URL',
			'common.browserPane.forward' => 'Вперёд',
			'common.browserPane.invalidUrl' => 'Введите корректный http(s) URL',
			'common.browserPane.noAuthToken' => 'Нет доступного токена аутентификации.',
			'common.browserPane.openExternal' => 'Открыть в системном браузере',
			'common.browserPane.reload' => 'Обновить',
			'common.browserPane.retry' => 'Повторить',
			'common.browserPane.stop' => 'Остановить',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} активных',
			'common.browserUse.cancel' => 'Отмена',
			'common.browserUse.close' => 'Закрыть',
			'common.browserUse.delete' => 'Удалить',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} будет удалена безвозвратно.',
			'common.browserUse.deleteSession' => 'Удалить сессию',
			'common.browserUse.deleteTitle' => 'Удалить сессию браузера?',
			'common.browserUse.empty.descDisabled' => 'Включите Browser в настройках, чтобы агенты могли открывать наблюдаемые сессии браузера.',
			'common.browserUse.empty.descEnabled' => 'Сессии браузера агента появляются здесь, пока задача ИИ использует Browser.',
			'common.browserUse.empty.titleDisabled' => 'Browser отключён',
			'common.browserUse.empty.titleEnabled' => 'Пока нет сессий браузера',
			'common.browserUse.emptyStatus' => 'пусто',
			'common.browserUse.errors.actionFailed' => 'Действие браузера не удалось',
			'common.browserUse.errors.loadFailed' => 'Не удалось загрузить Browser',
			'common.browserUse.fullscreen' => 'Полный экран',
			'common.browserUse.installRuntime' => 'Установить среду выполнения',
			'common.browserUse.installing' => 'Установка...',
			'common.browserUse.lastAction' => 'Последнее действие',
			'common.browserUse.nextSnapshot' => 'Следующий снимок браузера агента появится здесь.',
			'common.browserUse.noPageLoaded' => 'Страница не загружена',
			'common.browserUse.noSessions' => 'Нет сессий браузера агентов.',
			'common.browserUse.none' => 'Нет',
			'common.browserUse.openSettings' => 'Открыть настройки Browser',
			'common.browserUse.profile' => 'Профиль',
			'common.browserUse.promptLabel' => 'Промпт',
			'common.browserUse.prompts.prompt1' => 'Используйте Browser, чтобы проверить процесс оформления заказа и сообщить о неработающих состояниях UI.',
			'common.browserUse.prompts.prompt2' => 'Откройте <url> в Browser, взаимодействуйте со страницей и резюмируйте, что изменилось после каждого шага.',
			'common.browserUse.refresh' => 'Обновить сессии браузера',
			'common.browserUse.relative.daysAgo' => ' дн. назад',
			'common.browserUse.relative.hoursAgo' => ' ч. назад',
			'common.browserUse.relative.justNow' => 'Только что',
			'common.browserUse.relative.minutesAgo' => ' мин. назад',
			'common.browserUse.relative.never' => 'Никогда',
			'common.browserUse.relative.secondsAgo' => ' сек. назад',
			'common.browserUse.relative.unknown' => 'Неизвестно',
			'common.browserUse.runtime.disabled' => 'Отключён',
			'common.browserUse.runtime.installing' => 'Установка',
			'common.browserUse.runtime.ready' => 'Готов',
			'common.browserUse.runtime.setupRequired' => 'Требуется настройка',
			'common.browserUse.runtimeSetup' => 'Требуется настройка среды выполнения',
			'common.browserUse.selected' => 'Выбрана',
			'common.browserUse.sessionFallback' => 'Сессия браузера',
			'common.browserUse.sessionScreenshot' => 'Снимок экрана сессии браузера',
			'common.browserUse.sessions' => 'Сессии',
			'common.browserUse.status' => 'Статус',
			'common.browserUse.stop' => 'Остановить',
			'common.browserUse.stopSession' => 'Остановить сессию',
			'common.browserUse.subtitle' => 'Наблюдайте за сессиями браузера, открытыми ИИ-агентами.',
			'common.browserUse.temporary' => 'Временный',
			'common.browserUse.thisSession' => 'Эта сессия',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => 'всего ${count}',
			'common.browserUse.updated' => ({required Object time}) => 'Обновлено ${time}',
			'common.browserUse.waiting' => 'Ожидание',
			'common.browserUse.waitingForScreenshot' => 'Ожидание снимка экрана',
			'common.commandPalette.backToAll' => 'Назад ко всем',
			'common.commandPalette.backspaceHint' => 'Backspace для возврата',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Все ветки (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Все коммиты (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Все файлы (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Все сессии (${count})',
			'common.commandPalette.compare.costNote' => 'Стоимость — клиентская оценка по опубликованным тарифам за токен; неизвестные модели показывают «—».',
			'common.commandPalette.compare.estCost' => 'Прим. стоимость',
			'common.commandPalette.compare.inputOutput' => 'Ввод / Вывод',
			'common.commandPalette.compare.model' => 'Модель',
			'common.commandPalette.compare.na' => 'Н/Д',
			'common.commandPalette.compare.openSplit' => 'Открыть в разделённом виде',
			'common.commandPalette.compare.provider' => 'Провайдер',
			'common.commandPalette.compare.selectSession' => 'Выберите сессию…',
			'common.commandPalette.compare.tokensUsed' => 'Использовано токенов',
			'common.commandPalette.groups.actions' => 'Действия',
			'common.commandPalette.groups.branches' => 'Ветки',
			'common.commandPalette.groups.commits' => 'Коммиты',
			'common.commandPalette.groups.files' => 'Файлы',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Навигация',
			'common.commandPalette.groups.sessions' => 'Сессии',
			'common.commandPalette.groups.settings' => 'Настройки',
			'common.commandPalette.hints.close' => 'Закрыть',
			'common.commandPalette.hints.navigate' => 'Навигация',
			'common.commandPalette.hints.select' => 'Выбрать',
			'common.commandPalette.hints.togglePalette' => 'Переключить палитру',
			'common.commandPalette.items.compareSessions' => 'Сравнить сессии',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Открыть настройки',
			'common.commandPalette.items.selectProjectFirst' => 'Сначала выберите проект',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Настройки: ${label}',
			'common.commandPalette.items.startNewChat' => 'Начать новый чат',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Переключиться на: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Переключить тему',
			'common.commandPalette.items.tokensAndCost' => 'токены и стоимость',
			'common.commandPalette.nav.board' => 'К панели агентов',
			'common.commandPalette.nav.chat' => 'К чату',
			'common.commandPalette.nav.files' => 'К файлам',
			'common.commandPalette.nav.git' => 'К Git',
			'common.commandPalette.nav.sourceControl' => 'К контролю версий',
			'common.commandPalette.nav.tasks' => 'К задачам',
			'common.commandPalette.nav.usage' => 'К квотам и использованию',
			'common.commandPalette.noResults' => 'Нет результатов.',
			'common.commandPalette.pages.actions' => 'Действия',
			'common.commandPalette.pages.branches' => 'Ветки',
			'common.commandPalette.pages.commits' => 'Коммиты',
			'common.commandPalette.pages.compare' => 'Сравнение',
			'common.commandPalette.pages.files' => 'Файлы',
			'common.commandPalette.pages.sessions' => 'Сессии',
			'common.commandPalette.placeholder' => 'Введите для поиска…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => 'Поиск: ${page}…',
			'common.commandPalette.title' => 'Палитра команд',
			'common.gitPanel.ahead' => ({required Object count}) => 'на ${count} впереди',
			'common.gitPanel.aheadLabel' => 'впереди',
			'common.gitPanel.aiSuggest' => 'Предложение ИИ',
			'common.gitPanel.aiSuggestTitle' => 'Сгенерировать сообщение коммита с помощью ИИ',
			'common.gitPanel.all' => 'Все',
			'common.gitPanel.allStaged' => 'Все изменения подготовлены',
			'common.gitPanel.behind' => ({required Object count}) => 'на ${count} позади',
			'common.gitPanel.behindLabel' => 'позади',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'Удалить ветку «${branch}»? Обычное удаление сработает только если ветка полностью слита. Действие необратимо.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'Переключиться на ветку «${branch}»? Убедитесь, что нет незафиксированных изменений.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} локальных, ${remote} удалённых',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} локальных',
			'common.gitPanel.branches.current' => 'текущая',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => 'Удалить ${branch}',
			'common.gitPanel.branches.emptyDesc' => 'Создайте ветку, чтобы начать параллельную работу.',
			'common.gitPanel.branches.forceDelete' => 'Принудительное удаление',
			'common.gitPanel.branches.forceDeleteDesc' => 'Безвозвратно удаляет ветку, даже если она содержит коммиты, никуда не слитые.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Принудительно удалить эту неслитую ветку',
			'common.gitPanel.branches.local' => 'Локальные',
			'common.gitPanel.branches.kNew' => 'Новая ветка',
			'common.gitPanel.branches.noMatch' => 'Нет веток, соответствующих запросу',
			'common.gitPanel.branches.none' => 'Ветки не найдены',
			'common.gitPanel.branches.remote' => 'удалённые',
			'common.gitPanel.branches.kSwitch' => 'Переключить',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Переключиться на ${branch}',
			'common.gitPanel.cancel' => 'Отмена',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Изменения (${count})',
			'common.gitPanel.clearSearch' => 'Очистить поиск',
			'common.gitPanel.collapseDiff' => 'Свернуть diff',
			'common.gitPanel.commit' => 'Коммит',
			'common.gitPanel.commitChanges' => 'Зафиксировать изменения',
			'common.gitPanel.commitFiles' => ({required Object count}) => 'Зафиксировать ${count} файл(ов)',
			'common.gitPanel.committing' => 'Фиксация...',
			'common.gitPanel.confirmActions.commit' => 'Подтвердить',
			'common.gitPanel.confirmActions.delete' => 'Удалить',
			'common.gitPanel.confirmActions.deleteBranch' => 'Удалить',
			'common.gitPanel.confirmActions.discard' => 'Отменить',
			'common.gitPanel.confirmActions.publish' => 'Опубликовать',
			'common.gitPanel.confirmActions.pull' => 'Вытянуть',
			'common.gitPanel.confirmActions.push' => 'Отправить',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Отменить коммит',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => 'Зафиксировать ${count} файл(ов) с сообщением: «${message}»?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'Удалить неотслеживаемый файл «${file}»? Действие необратимо.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => 'Отменить все изменения в «${file}»? Действие необратимо.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'Опубликовать ветку «${branch}» в ${remote}?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => 'Получить ${count} коммит(ов) из ${remote}?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => 'Отправить ${count} коммит(ов) в ${remote}?',
			'common.gitPanel.confirmRevert' => 'Отменить последний локальный коммит? Коммит будет удалён, но его изменения останутся подготовленными.',
			'common.gitPanel.confirmTitles.commit' => 'Подтвердить действие',
			'common.gitPanel.confirmTitles.delete' => 'Удалить файл',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Удалить ветку',
			'common.gitPanel.confirmTitles.discard' => 'Отменить изменения',
			'common.gitPanel.confirmTitles.publish' => 'Опубликовать ветку',
			'common.gitPanel.confirmTitles.pull' => 'Подтвердить pull',
			'common.gitPanel.confirmTitles.push' => 'Подтвердить push',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Отменить локальный коммит',
			'common.gitPanel.createBranch' => 'Создать новую ветку',
			'common.gitPanel.creating' => 'Создание...',
			'common.gitPanel.delete' => 'Удалить',
			'common.gitPanel.deleteUntracked' => 'Удалить неотслеживаемый файл',
			'common.gitPanel.deselectAll' => 'Снять выделение',
			'common.gitPanel.discard' => 'Отменить',
			'common.gitPanel.discardChanges' => 'Отменить изменения',
			'common.gitPanel.dismiss' => 'Закрыть',
			'common.gitPanel.dismissError' => 'Закрыть ошибку',
			'common.gitPanel.errors.createBranchFailed' => 'Не удалось создать ветку',
			'common.gitPanel.errors.createWorktreeFailed' => 'Не удалось создать worktree',
			'common.gitPanel.errors.deleteBranchFailed' => 'Не удалось удалить ветку',
			'common.gitPanel.errors.fetchFailed' => 'Fetch не удался',
			'common.gitPanel.errors.initFailed' => 'Не удалось инициализировать репозиторий',
			'common.gitPanel.errors.initialCommitFailed' => 'Не удалось создать первый коммит',
			'common.gitPanel.errors.mergeFailed' => 'Слияние не удалось',
			'common.gitPanel.errors.openWorktreeFailed' => 'Не удалось открыть worktree',
			'common.gitPanel.errors.operationFailed' => 'Операция git не удалась',
			'common.gitPanel.errors.publishFailed' => 'Публикация не удалась',
			'common.gitPanel.errors.pullFailed' => 'Pull не удался',
			'common.gitPanel.errors.pushFailed' => 'Push не удался',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Не удалось удалить worktree',
			'common.gitPanel.errors.stageFailed' => 'Подготовка не удалась',
			'common.gitPanel.errors.stageHunksFailed' => 'Подготовка фрагментов не удалась',
			'common.gitPanel.errors.switchFailed' => 'Переключение ветки не удалось',
			'common.gitPanel.errors.unstageFailed' => 'Отмена подготовки не удалась',
			'common.gitPanel.errors.unstageHunksFailed' => 'Отмена подготовки фрагментов не удалась',
			'common.gitPanel.expandDiff' => 'Развернуть diff',
			'common.gitPanel.fetch' => 'Получить',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Fetch из ${remote}',
			'common.gitPanel.fetching' => 'Получение…',
			'common.gitPanel.filesSelected' => ({required Object count}) => 'Выбрано файл(ов): ${count}',
			'common.gitPanel.generating' => 'Генерация...',
			'common.gitPanel.history.added' => 'Добавлено',
			'common.gitPanel.history.author' => 'Автор',
			'common.gitPanel.history.changedFiles' => 'Изменённые файлы',
			'common.gitPanel.history.date' => 'Дата',
			'common.gitPanel.history.empty' => 'Коммиты не найдены',
			'common.gitPanel.history.files' => 'Файлы',
			'common.gitPanel.history.removed' => 'Удалено',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Удалить worktree и его ветку после слияния',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Очистить после слияния',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} коммит(ов)',
			'common.gitPanel.mergeWorktree.merge' => 'Слить',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Слить ветку \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Сообщение коммита',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Объединить все ${commits} в один коммит в ${branch}',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Сжать коммиты (squash)',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squash и слияние',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Squash-слияние ветки \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => 'Слить Worktree',
			'common.gitPanel.merging' => 'Слияние...',
			'common.gitPanel.messagePlaceholder' => 'Сообщение (Ctrl+Enter для фиксации)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Будет создана новая ветка из текущей (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Имя ветки',
			'common.gitPanel.newBranch.submit' => 'Создать ветку',
			'common.gitPanel.newBranch.title' => 'Создать новую ветку',
			'common.gitPanel.newWorktree.branchLabel' => 'Ветка',
			'common.gitPanel.newWorktree.createFrom' => 'Создать из',
			'common.gitPanel.newWorktree.description' => 'Извлеките ветку в отдельную папку и работайте над ней параллельно.',
			'common.gitPanel.newWorktree.existingBranch' => 'Существующая ветка — будет извлечена как есть.',
			'common.gitPanel.newWorktree.submit' => 'Создать worktree',
			'common.gitPanel.newWorktree.switchAfter' => 'Переключиться на worktree после создания',
			'common.gitPanel.newWorktree.title' => 'Новый Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Будет создан в',
			'common.gitPanel.noChanges' => 'Изменений не обнаружено',
			'common.gitPanel.noChangesToCommit' => 'Нет изменений для фиксации',
			'common.gitPanel.noCommits.create' => 'Создать первый коммит',
			'common.gitPanel.noCommits.creating' => 'Создание первого коммита...',
			'common.gitPanel.noCommits.description' => 'В этом репозитории ещё нет коммитов. Создайте первый коммит, чтобы начать отслеживать изменения.',
			'common.gitPanel.noCommits.title' => 'Пока нет коммитов',
			'common.gitPanel.noMatchingBranches' => 'Нет подходящих веток',
			'common.gitPanel.noRepo.description' => 'Этот проект ещё не является git-репозиторием. Инициализируйте его, чтобы отслеживать изменения и использовать контроль версий.',
			'common.gitPanel.noRepo.init' => 'Выполнить git init',
			'common.gitPanel.noRepo.initializing' => 'Инициализация репозитория...',
			'common.gitPanel.noRepo.title' => 'Нет git-репозитория',
			'common.gitPanel.noStagedFiles' => 'Нет подготовленных файлов',
			'common.gitPanel.none' => 'Нет',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Нечего отправлять в ${remote}',
			'common.gitPanel.openFile' => 'Нажмите, чтобы открыть файл',
			'common.gitPanel.publish' => 'Опубликовать',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => 'Опубликовать «${branch}» в ${remote}',
			'common.gitPanel.publishing' => 'Публикация…',
			'common.gitPanel.pull' => 'Вытянуть',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Вытянуть ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => 'Получить ${count} из ${remote}',
			'common.gitPanel.pulling' => 'Получение…',
			'common.gitPanel.push' => 'Отправить',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Отправить ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => 'Отправить ${count} в ${remote}',
			'common.gitPanel.pushing' => 'Отправка…',
			'common.gitPanel.recentCommits' => 'Последние коммиты',
			'common.gitPanel.refresh' => 'Обновить статус git',
			'common.gitPanel.remove' => 'Удалить',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Также удалить ветку',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => 'Удалить worktree для ${branch}? Его папка будет удалена, а связанный проект заархивирован — сессии чата останутся восстановимыми.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'В этом worktree есть ${count} незафиксированных изменений, которые будут потеряны.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Отменить незафиксированные изменения',
			'common.gitPanel.removeWorktree.title' => 'Удалить Worktree',
			'common.gitPanel.removing' => 'Удаление...',
			'common.gitPanel.revertLatest' => 'Отменить последний локальный коммит',
			'common.gitPanel.scroll' => 'Прокрутка',
			'common.gitPanel.searchBranches' => 'Поиск веток...',
			'common.gitPanel.selectAll' => 'Выбрать все',
			'common.gitPanel.selectProject' => 'Выберите проект для просмотра контроля версий',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => 'Выбрано ${selected} из ${total} файлов',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => 'Выбрано ${selected} из ${total}',
			'common.gitPanel.sideBySide' => 'Рядом',
			'common.gitPanel.stageAll' => 'Подготовить все',
			'common.gitPanel.stageHunk' => 'Подготовить этот фрагмент',
			'common.gitPanel.staged' => ({required Object count}) => 'Подготовлено (${count})',
			'common.gitPanel.status.added' => 'Добавлен',
			'common.gitPanel.status.deleted' => 'Удалён',
			'common.gitPanel.status.modified' => 'Изменён',
			'common.gitPanel.status.untracked' => 'Не отслеживается',
			'common.gitPanel.statusGuide' => 'Справка по статусам файлов',
			'common.gitPanel.switchScroll' => 'Переключить на горизонтальную прокрутку',
			'common.gitPanel.switchSplit' => 'Переключить на вид рядом',
			'common.gitPanel.switchUnified' => 'Переключить на единый вид',
			'common.gitPanel.switchWrap' => 'Переключить на перенос текста',
			'common.gitPanel.unified' => 'Единый',
			'common.gitPanel.unstageAll' => 'Отменить подготовку всех',
			'common.gitPanel.unstageHunk' => 'Отменить подготовку фрагмента',
			'common.gitPanel.upToDate' => 'Актуально',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'Актуально с ${remote}',
			'common.gitPanel.viewAll' => 'Показать все',
			'common.gitPanel.viewsAria' => 'Представления контроля версий',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} изменений',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree',
			'common.gitPanel.worktrees.createFirst' => 'Создайте первый worktree',
			'common.gitPanel.worktrees.detached' => 'откреплён',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'откреплён @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'откреплённый HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'Worktree извлекает ветку в отдельную папку, чтобы можно было вести параллельные сессии чата и слить результаты, когда они будут готовы.',
			'common.gitPanel.worktrees.emptyTitle' => 'Работайте над ветками параллельно',
			'common.gitPanel.worktrees.locked' => 'заблокирован',
			'common.gitPanel.worktrees.mainWorktree' => 'основной worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => 'Слить ${branch} в базовую ветку',
			'common.gitPanel.worktrees.kNew' => 'Новый worktree',
			'common.gitPanel.worktrees.none' => 'Нет worktree',
			'common.gitPanel.worktrees.nothingToMerge' => 'Нечего слить — нет коммитов впереди базовой ветки',
			'common.gitPanel.worktrees.open' => 'Открыть',
			'common.gitPanel.worktrees.refresh' => 'Обновить worktree',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Удалить worktree для ${branch}',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Переключиться на ${branch}',
			'common.gitPanel.wrap' => 'Перенос',
			'common.gitPanel.tabs.changes' => 'Изменения',
			'common.gitPanel.tabs.history' => 'Коммиты',
			'common.gitPanel.tabs.branches' => 'Ветки',
			'common.gitPanel.tabs.worktrees' => 'Ворктри',
			'common.gitPanel.save' => 'Сохранить',
			'common.gitPanel.worktreeScripts.title' => 'Скрипты worktree',
			'common.gitPanel.worktreeScripts.setup' => 'Скрипт настройки (запускается после создания/открытия)',
			'common.gitPanel.worktreeScripts.run' => 'Запустить dev-сервер',
			'common.gitPanel.worktreeScripts.stop' => 'Остановить dev-сервер',
			'common.gitPanel.worktreeScripts.runScript' => 'Скрипт запуска (dev-сервер, по требованию)',
			'common.gitPanel.worktreeScripts.runPort' => 'Порт предпросмотра (необязательно — определяется автоматически, если пусто)',
			'common.gitPanel.worktreeScripts.invalidPort' => 'Порт должен быть от 1 до 65535',
			'common.gitPanel.worktreeScripts.sourceProject' => 'Сохранено как переопределение проекта',
			'common.gitPanel.worktreeScripts.sourceFile' => 'Из .ddagent/worktree.json — сохранение создаст переопределение проекта',
			'common.gitPanel.worktreeScripts.sourceNone' => 'Пока ничего не настроено',
			'common.gitPanel.worktreeScripts.saving' => 'Сохранение…',
			'common.gitPanel.worktreeScripts.setupRunning' => 'идёт настройка',
			'common.gitPanel.worktreeScripts.setupFailed' => 'ошибка настройки',
			'common.gitPanel.worktreeScripts.running' => 'запущен',
			'common.gitPanel.worktreeScripts.openPreview' => 'Открыть предпросмотр',
			'common.gitPanel.worktreeScripts.runExited' => ({required Object code}) => 'запуск завершён (${code})',
			'common.sessions.renameSession' => 'Переименовать сессию',
			'common.projects.newSession' => 'Новая сессия',
			'common.sharedNotes.subtitle' => 'Общая память — добавляется в каждый сеанс этого проекта',
			'common.sharedNotes.save' => 'Сохранить',
			'common.sharedNotes.saving' => 'Сохранение…',
			'common.sharedNotes.noProject' => 'Выберите рабочую область, чтобы редактировать её общий контекст',
			'common.sharedNotes.placeholder' => '# Общий контекст\nСоглашения, решения и подсказки, которые должен знать каждый агент…',
			'common.codeBlock.wrapLines' => 'Переносить строки',
			'common.codeBlock.noWrap' => 'Без переноса',
			'common.update.available' => ({required Object version}) => 'Доступно обновление · v${version}',
			'common.update.confirm' => ({required Object version}) => 'Обновить до v${version}? Сервер обновится сам и перезапустится — активные сессии будут прерваны.',
			'common.update.downloading' => 'Скачивание и применение обновления…',
			'common.update.restarting' => 'Перезапуск сервера — это займёт мгновение…',
			'common.update.done' => ({required Object version}) => 'Обновлено до v${version}. Перезагрузите приложение, чтобы применить новую сборку.',
			'common.update.manualRestart' => 'Обновление применено, но сервер не перезапустился сам — перезапустите его вручную, чтобы завершить.',
			'common.update.failed' => 'Обновление не удалось.',
			'common.update.failedTitle' => 'Не удалось обновить',
			'common.update.appConfirm' => ({required Object version}) => 'Установить DDAgent v${version} на это устройство? При первом запуске Android запросит разрешение на установку приложений из DDAgent.',
			'common.update.appPermission' => 'Разрешите DDAgent «Установка неизвестных приложений», затем снова нажмите «Обновить».',
			'common.update.chooseTitle' => 'Доступны обновления',
			'common.update.targetApp' => 'Это приложение',
			'common.update.targetWeb' => 'Веб-интерфейс',
			'common.update.targetServer' => 'Сервер',
			'common.update.updateApp' => 'Обновить приложение',
			'common.update.updateWeb' => 'Обновить веб-интерфейс',
			'common.update.updateServer' => 'Обновить сервер',
			'common.update.webConfirm' => ({required Object version}) => 'Обновить веб-интерфейс до v${version}? После обновления страница перезагрузится.',
			'common.update.webDone' => ({required Object version}) => 'Веб-интерфейс обновлён до v${version} — перезагружаю…',
			'common.update.localServerConfirm' => ({required Object version}) => 'Обновить локальный сервер на этом устройстве до v${version}? Активные сессии будут прерваны.',
			'common.update.localServerUpdating' => 'Загружаю и запускаю локальный сервер…',
			'common.update.serverDone' => ({required Object version}) => 'Сервер работает на v${version}.',
			'common.update.staged' => ({required Object version}) => 'Обновление v${version} загружено — перезапустите сервер, чтобы установить его.',
			'common.update.upToDate' => 'На сервере уже последний релиз.',
			'common.update.webHostFailed' => ({required Object message}) => 'Сервер обновлён, а его веб-интерфейс — нет: ${message}',
			'common.appShell.panelActive' => ({required Object count}) => 'Панель · активных: ${count}',
			'common.errors.forbidden' => 'Доступ запрещён',
			'settings.title' => 'Настройки',
			'settings.changelog.title' => 'Журнал изменений',
			'settings.changelog.loading' => 'Загрузка…',
			'settings.changelog.empty' => 'Нет релизов для отображения',
			'settings.changelog.current' => 'текущая',
			'settings.changelog.kNew' => 'новая',
			'settings.server.title' => 'Сервер',
			'settings.server.description' => 'Перезапускает процесс DDAgent — полезно после обновления или при зависании.',
			'settings.server.restart' => 'Перезапустить',
			'settings.server.restartConfirm' => 'Перезапустить сервер DDAgent? Активные сессии будут прерваны.',
			'settings.server.restarting' => 'Перезапуск… страница перезагрузится, когда сервер вернётся.',
			'settings.server.restartFailed' => 'Перезапуск не удался',
			'settings.server.unsupported' => 'Перезапуск доступен только когда сервер работает под менеджером служб.',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'Перезапуск сервера',
			'settings.server.restartRequesting' => 'Отправляю серверу команду перезапуска…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'Жду, пока сервер вернётся… (${seconds} с)',
			'settings.server.restartBack' => ({required Object version}) => 'Сервер снова работает — версия ${version}.',
			'settings.server.restartReloading' => 'Перезагружаю страницу…',
			'settings.server.restartTimeout' => ({required Object seconds}) => 'Сервер не вернулся за ${seconds} с. Проверьте журнал службы (/tmp/ddagent.log) или перезапустите её вручную.',
			'settings.updates.title' => 'Обновления',
			'settings.updates.description' => 'Проверить GitHub на наличие новой десктопной сборки. Новые версии скачиваются автоматически и устанавливаются при выходе.',
			'settings.updates.descriptionMobile' => 'Проверить на GitHub наличие новой сборки этого приложения. Обновления устанавливаются системным установщиком устройства.',
			'settings.updates.descriptionServer' => 'Проверить на GitHub наличие нового выпуска DDAgent. Подключённый сервер может обновиться сам — активные сеансы будут прерваны во время перезапуска.',
			'settings.updates.check' => 'Проверить обновления',
			'settings.updates.checking' => 'Проверка…',
			'settings.updates.upToDate' => ({required Object version}) => 'У вас последняя версия (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Найдено обновление v${version} — скачивается в фоне; установится при выходе из DDAgent.',
			'settings.updates.appAvailable' => ({required Object version}) => 'Доступно обновление приложения v${version} — нажмите «Обновить», чтобы установить его на это устройство.',
			'settings.updates.downloaded' => ({required Object version}) => 'Обновление v${version} загружено — закройте и перезапустите DDAgent для установки.',
			'settings.updates.unavailable' => 'Проверка обновлений доступна только в упакованных десктопных сборках.',
			'settings.updates.error' => ({required Object message}) => 'Не удалось проверить обновления: ${message}',
			'settings.updates.errorGeneric' => 'Не удалось проверить обновления.',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · последняя v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — актуальна',
			'settings.updates.webNotHosted' => ({required Object version}) => 'Этот веб-интерфейс размещён отдельно — замените его файлы на ddagent-flutter-web-v${version}.zip из релиза.',
			'settings.updates.serverCannotUpdate' => 'Этот сервер не может обновиться отсюда — переустановите его через install.sh или из архива релиза.',
			'settings.tabs.account' => 'Аккаунт',
			'settings.tabs.permissions' => 'Разрешения',
			'settings.tabs.mcpServers' => 'MCP серверы',
			'settings.tabs.skills' => 'Навыки',
			'settings.tabs.appearance' => 'Внешний вид',
			'settings.account.title' => 'Аккаунт',
			'settings.account.language' => 'Язык',
			'settings.account.languageLabel' => 'Язык интерфейса',
			'settings.account.languageDescription' => 'Выберите предпочитаемый язык для интерфейса',
			'settings.account.username' => 'Имя пользователя',
			'settings.account.email' => 'Эл. почта',
			'settings.account.profile' => 'Профиль',
			'settings.account.changePassword' => 'Изменить пароль',
			'settings.mcp.title' => 'MCP серверы',
			'settings.mcp.addServer' => 'Добавить сервер',
			'settings.mcp.editServer' => 'Редактировать сервер',
			'settings.mcp.deleteServer' => 'Удалить сервер',
			'settings.mcp.serverName' => 'Имя сервера',
			'settings.mcp.serverType' => 'Тип сервера',
			'settings.mcp.config' => 'Конфигурация',
			'settings.mcp.testConnection' => 'Проверить подключение',
			'settings.mcp.status' => 'Статус',
			'settings.mcp.connected' => 'Подключен',
			'settings.mcp.disconnected' => 'Отключен',
			'settings.mcp.scope.label' => 'Область',
			'settings.mcp.scope.user' => 'Пользователь',
			'settings.mcp.scope.project' => 'Проект',
			'settings.appearance.title' => 'Внешний вид',
			'settings.appearance.theme' => 'Тема',
			'settings.appearance.codeEditor' => 'Редактор кода',
			'settings.appearance.editorTheme' => 'Тема редактора',
			'settings.appearance.wordWrap' => 'Перенос слов',
			'settings.appearance.showMinimap' => 'Показать миникарту',
			'settings.appearance.lineNumbers' => 'Номера строк',
			'settings.appearance.fontSize' => 'Размер шрифта',
			'settings.appearance.themeModes.system' => 'Системная',
			'settings.appearance.themeModes.light' => 'Светлая',
			_ => null,
		} ?? switch (path) {
			'settings.appearance.themeModes.dark' => 'Темная',
			'settings.actions.saveChanges' => 'Сохранить изменения',
			'settings.actions.resetToDefaults' => 'Сбросить к значениям по умолчанию',
			'settings.actions.cancelChanges' => 'Отменить изменения',
			'settings.quickSettings.title' => 'Быстрые настройки',
			'settings.quickSettings.sections.appearance' => 'Внешний вид',
			'settings.quickSettings.sections.toolDisplay' => 'Отображение инструментов',
			'settings.quickSettings.sections.inputSettings' => 'Настройки ввода',
			'settings.quickSettings.darkMode' => 'Темная тема',
			'settings.quickSettings.showRawParameters' => 'Показывать сырые параметры',
			'settings.quickSettings.showThinking' => 'Показывать размышления',
			'settings.quickSettings.sendByCtrlEnter' => 'Отправка по Ctrl+Enter',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Когда включено, нажатие Ctrl+Enter будет отправлять сообщение вместо просто Enter. Это полезно для пользователей IME, чтобы избежать случайной отправки.',
			'settings.quickSettings.dragHandle.dragging' => 'Перетаскивание ручки',
			'settings.quickSettings.dragHandle.closePanel' => 'Закрыть панель настроек',
			'settings.quickSettings.dragHandle.openPanel' => 'Открыть панель настроек',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Перетаскивание...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Нажмите для переключения, перетащите для перемещения',
			'settings.quickSettings.sendWithCtrlEnter' => 'Отправлять по Ctrl+Enter',
			'settings.quickSettings.enterSendsHint' => 'Если выключено, Enter отправляет сообщение, а Shift+Enter вставляет перенос строки.',
			'settings.terminalShortcuts.title' => 'Горячие клавиши терминала',
			'settings.terminalShortcuts.sectionKeys' => 'Клавиши',
			'settings.terminalShortcuts.sectionNavigation' => 'Навигация',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Стрелка вверх',
			'settings.terminalShortcuts.arrowDown' => 'Стрелка вниз',
			'settings.terminalShortcuts.scrollDown' => 'Прокрутка вниз',
			'settings.terminalShortcuts.killTitle' => 'Завершить выполняющийся процесс (Ctrl+C)',
			'settings.terminalShortcuts.handle.closePanel' => 'Закрыть панель горячих клавиш',
			'settings.terminalShortcuts.handle.openPanel' => 'Открыть панель горячих клавиш',
			'settings.terminalShortcuts.paste' => 'Вставить',
			'settings.mainTabs.label' => 'Настройки',
			'settings.mainTabs.agents' => 'Агенты',
			'settings.mainTabs.orchestration' => 'Оркестрация',
			'settings.mainTabs.miniOrchestration' => 'Мини-оркестрация',
			'settings.mainTabs.appearance' => 'Внешний вид',
			'settings.mainTabs.workspaces' => 'Рабочие области',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API и токены',
			'settings.mainTabs.models' => 'Модели',
			'settings.mainTabs.tasks' => 'Задачи',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Инструменты',
			'settings.mainTabs.notifications' => 'Уведомления',
			'settings.mainTabs.about' => 'О программе',
			'settings.mainTabs.quota' => 'Центр управления',
			'settings.mainTabs.shortcuts' => 'Сочетания клавиш',
			'settings.miniOrchestration.title' => 'Мини-оркестрация',
			'settings.miniOrchestration.description' => 'Конвейер из двух моделей: не-flash «мыслитель» планирует, flash-исполнитель выполняет.',
			'settings.miniOrchestration.loading' => 'Загрузка настроек мини-оркестрации…',
			'settings.miniOrchestration.loadError' => 'Не удалось загрузить настройки мини-оркестрации.',
			'settings.miniOrchestration.enable.label' => 'Включить мини-оркестрацию',
			'settings.miniOrchestration.enable.description' => 'Направлять сеансы Авто (мини) через движок с двумя ролями вместо полного оркестратора.',
			'settings.miniOrchestration.thinker.title' => 'Мыслитель (не-flash)',
			'settings.miniOrchestration.thinker.description' => 'Планирует, принимает решения, проверяет и пишет итоговый отчёт.',
			'settings.miniOrchestration.worker.title' => 'Исполнитель (flash)',
			'settings.miniOrchestration.worker.description' => 'Выполняет каждый запланированный шаг.',
			'settings.miniOrchestration.fields.provider' => 'Провайдер',
			'settings.miniOrchestration.fields.model' => 'Модель',
			'settings.miniOrchestration.fields.modelPlaceholder' => 'Выберите модель',
			'settings.miniOrchestration.fields.tier' => 'Уровень',
			'settings.miniOrchestration.roles.title' => 'Модель для каждой задачи',
			'settings.miniOrchestration.roles.description' => 'Какая модель (роль) обрабатывает каждый тип задач.',
			'settings.miniOrchestration.planner.title' => 'Планировщик',
			'settings.miniOrchestration.planner.mode' => 'Режим',
			'settings.miniOrchestration.planner.modes.auto' => 'Планировать с мыслителем',
			'settings.miniOrchestration.planner.modes.off' => 'Один шаг',
			'settings.miniOrchestration.planner.requireConfirmLabel' => 'Подтверждать план перед запуском',
			'settings.orchestration.title' => 'Orchestration',
			'settings.orchestration.description' => 'Распределяйте задачи чата между вашими провайдерами и моделями.',
			'settings.orchestration.loading' => 'Загрузка настроек оркестрации…',
			'settings.orchestration.loadError' => 'Не удалось загрузить настройки оркестрации.',
			'settings.orchestration.retry' => 'Retry',
			'settings.orchestration.enable.label' => 'Включить оркестрацию',
			'settings.orchestration.enable.description' => 'Позволить оркестратору выбирать модель для каждого шага вместо выполнения всего у одного провайдера.',
			'settings.orchestration.pool.title' => 'Пул кандидатов',
			'settings.orchestration.pool.description' => 'Модели, из которых может выбирать маршрутизатор; каждая привязана к ценовому уровню.',
			'settings.orchestration.pool.add' => 'Добавить кандидата',
			'settings.orchestration.pool.empty' => 'Кандидатов пока нет — добавьте одного, чтобы начать маршрутизацию.',
			'settings.orchestration.pool.fields.label' => 'Label',
			'settings.orchestration.pool.fields.labelPlaceholder' => 'например, SWE-2 Medium',
			'settings.orchestration.pool.fields.provider' => 'Provider',
			'settings.orchestration.pool.fields.model' => 'Model',
			'settings.orchestration.pool.fields.modelPlaceholder' => 'Выберите модель',
			'settings.orchestration.pool.fields.effort' => 'Effort',
			'settings.orchestration.pool.fields.effortDefault' => 'По умолчанию провайдера',
			'settings.orchestration.pool.fields.effortPlaceholder' => 'default',
			'settings.orchestration.pool.fields.account' => 'Account',
			'settings.orchestration.pool.fields.accountDefault' => 'По умолчанию провайдера',
			'settings.orchestration.pool.fields.redundantAccounts' => 'Резервные аккаунты',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Нет других аккаунтов для этого провайдера',
			'settings.orchestration.pool.fields.tier' => 'Cost tier',
			'settings.orchestration.pool.fields.remove' => 'Удалить кандидата',
			'settings.orchestration.pool.fields.moveUp' => 'Move up',
			'settings.orchestration.pool.fields.moveDown' => 'Move down',
			'settings.orchestration.tiers.free' => 'Free',
			'settings.orchestration.tiers.cheap' => 'Cheap',
			'settings.orchestration.tiers.mid' => 'Mid',
			'settings.orchestration.tiers.premium' => 'Premium',
			'settings.orchestration.rules.title' => 'Правила маршрутизации',
			'settings.orchestration.rules.description' => 'Упорядоченные кандидаты для каждого типа задач — побеждает первый доступный.',
			'settings.orchestration.rules.addCandidate' => 'Добавить кандидата…',
			'settings.orchestration.rules.empty' => 'Нет кандидатов — этот тип задач некуда направить.',
			'settings.orchestration.rules.missing' => '(removed)',
			'settings.orchestration.rules.remove' => 'Удалить кандидата',
			'settings.orchestration.rules.taskTypes.plan' => 'Planning',
			'settings.orchestration.rules.taskTypes.quick' => 'Быстрые ответы',
			'settings.orchestration.rules.taskTypes.research' => 'Research',
			'settings.orchestration.rules.taskTypes.docs' => 'Documentation',
			'settings.orchestration.rules.taskTypes.code' => 'Coding',
			'settings.orchestration.rules.taskTypes.codeHard' => 'Сложное программирование',
			'settings.orchestration.rules.taskTypes.test' => 'Testing',
			'settings.orchestration.rules.taskTypes.review' => 'Review',
			'settings.orchestration.rules.taskTypes.report' => 'Отчёт',
			'settings.orchestration.planner.title' => 'Planner',
			'settings.orchestration.planner.description' => 'Как запрос разбивается на маршрутизируемые шаги.',
			'settings.orchestration.planner.modeLabel' => 'Режим планирования',
			'settings.orchestration.planner.modes.auto' => 'Auto (LLM)',
			'settings.orchestration.planner.modes.template' => 'Templates',
			'settings.orchestration.planner.modes.off' => 'Off',
			'settings.orchestration.planner.modeHints.auto' => 'Модель-планировщик разбивает каждый запрос на типизированные шаги.',
			'settings.orchestration.planner.modeHints.template' => 'Запросы проходят через фиксированный конвейер, выбранный ниже.',
			'settings.orchestration.planner.modeHints.off' => 'Без планирования — весь запрос направляется как один шаг.',
			'settings.orchestration.planner.candidateLabel' => 'Модель-планировщик',
			'settings.orchestration.planner.candidateDescription' => 'Кандидат из пула для генерации планов и вызовов классификации.',
			'settings.orchestration.planner.candidatePlaceholder' => 'Выберите кандидата из пула',
			'settings.orchestration.planner.templates.title' => 'Шаблоны конвейеров',
			'settings.orchestration.planner.templates.add' => 'Add template',
			'settings.orchestration.planner.templates.namePlaceholder' => 'Название шаблона',
			'settings.orchestration.planner.templates.addStep' => 'Add step…',
			'settings.orchestration.planner.templates.remove' => 'Удалить шаблон',
			'settings.orchestration.planner.templates.removeStep' => 'Remove step',
			'settings.orchestration.planner.templates.empty' => 'Шаблонов пока нет.',
			'settings.orchestration.planner.templates.emptySteps' => 'Шагов пока нет — добавьте ниже.',
			'settings.orchestration.planner.requireConfirm' => 'Подтверждать план перед запуском',
			'settings.orchestration.planner.requireConfirmDescription' => 'Приостанавливать после планирования, чтобы вы могли изменить или отключить шаги в карточке плана.',
			'settings.orchestration.planner.checkpointLabel' => 'Автономность',
			'settings.orchestration.planner.checkpointModes.off' => 'Автономно',
			'settings.orchestration.planner.checkpointModes.perStep' => 'Каждый шаг',
			'settings.orchestration.planner.checkpointModes.everyN' => 'Каждые N',
			'settings.orchestration.planner.checkpointHints.off' => 'Решения супервизора выполняются без запроса (автоматический режим).',
			'settings.orchestration.planner.checkpointHints.perStep' => 'Запрашивать одобрение перед каждым предложенным набором шагов.',
			'settings.orchestration.planner.checkpointHints.everyN' => 'Запрашивать одобрение после каждых N выполненных шагов.',
			'settings.orchestration.planner.checkpointIntervalLabel' => 'Шагов между контрольными точками (1–50)',
			'settings.orchestration.execution.title' => 'Ограничения выполнения',
			'settings.orchestration.execution.description' => 'Ограничители для параллельных запусков и циклов исправлений.',
			'settings.orchestration.execution.maxParallel' => 'Макс. параллельных шагов',
			'settings.orchestration.execution.maxParallelDescription' => 'Сколько подзадач может выполняться одновременно (1–8).',
			'settings.orchestration.execution.maxFixLoops' => 'Макс. циклов исправлений',
			'settings.orchestration.execution.maxFixLoopsDescription' => 'Повторы, когда шаг не проходит проверку (0–5).',
			'settings.orchestration.execution.onNoCandidate' => 'Если нет доступного кандидата',
			'settings.orchestration.execution.onNoCandidateDescription' => 'Спросить перед переходом к запасному варианту или пропустить шаг.',
			'settings.orchestration.execution.onNoCandidateOptions.ask' => 'Ask',
			'settings.orchestration.execution.onNoCandidateOptions.skip' => 'Skip step',
			'settings.orchestration.execution.useWorktree' => 'Изолированный worktree',
			'settings.orchestration.execution.useWorktreeDescription' => 'Выполнять все делегированные шаги в одном общем git worktree вместо каталога проекта.',
			'settings.orchestration.execution.maxSupervisorIterations' => 'Макс. итераций супервизора',
			'settings.orchestration.execution.maxSupervisorIterationsDescription' => 'Ограничение числа раундов решений супервизора в автоматическом режиме (1–100); при его достижении запуск завершается частичным отчётом.',
			'settings.orchestration.execution.maxAttempts' => 'Макс. попыток на шаг',
			'settings.orchestration.execution.maxAttemptsDescription' => 'Общий бюджет попыток для одного шага по всем линиям и повторам (1–50).',
			'settings.orchestration.execution.stepTimeoutMs' => 'Тайм-аут шага (мс)',
			'settings.orchestration.execution.stepTimeoutMsDescription' => 'Тайм-аут дочернего запуска для каждой попытки в миллисекундах; 0 — отключено.',
			'settings.orchestration.execution.runTimeoutMs' => 'Тайм-аут запуска (мс)',
			'settings.orchestration.execution.runTimeoutMsDescription' => 'Общий тайм-аут выполнения плана в миллисекундах; 0 — отключено.',
			'settings.orchestration.execution.retryBackoffBaseMs' => 'База задержки повтора (мс)',
			'settings.orchestration.execution.retryBackoffBaseMsDescription' => 'База экспоненциальной задержки между повторами на той же линии (полный jitter).',
			'settings.orchestration.execution.retryBudgetTitle' => 'Бюджет повторов по классу ошибки',
			'settings.orchestration.execution.retryBudgetDescription' => 'Повторы на той же линии перед переключением/паузой (0–5).',
			'settings.orchestration.execution.retryClasses.rateLimit' => 'Лимит запросов',
			'settings.orchestration.execution.retryClasses.quota' => 'Квота',
			'settings.orchestration.execution.retryClasses.auth' => 'Авторизация',
			'settings.orchestration.execution.retryClasses.timeout' => 'Тайм-аут',
			'settings.orchestration.execution.retryClasses.transient' => 'Временная ошибка',
			'settings.orchestration.save.unsaved' => 'Несохранённые изменения',
			'settings.orchestration.save.save' => 'Save',
			'settings.orchestration.save.saving' => 'Saving…',
			'settings.orchestration.save.saved' => 'Saved',
			'settings.orchestration.save.discard' => 'Discard',
			'settings.orchestration.save.error' => 'Save failed',
			'settings.orchestration.save.emptyPool' => 'Перед сохранением добавьте хотя бы одного кандидата.',
			'settings.notifications.title' => 'Уведомления',
			'settings.notifications.description' => 'Управляйте тем, какие события уведомлений вы получаете.',
			'settings.notifications.webPush.title' => 'Web Push уведомления',
			'settings.notifications.webPush.enable' => 'Включить Push уведомления',
			'settings.notifications.webPush.disable' => 'Отключить Push уведомления',
			'settings.notifications.webPush.enabled' => 'Push уведомления включены',
			'settings.notifications.webPush.loading' => 'Обновление...',
			'settings.notifications.webPush.unsupported' => 'Push уведомления не поддерживаются в этом браузере.',
			'settings.notifications.webPush.denied' => 'Push уведомления заблокированы. Разрешите их в настройках браузера.',
			'settings.notifications.webPush.iosHint' => 'На iPhone/iPad уведомления работают только после добавления DDAgent на домашний экран (Поделиться → На экран «Домой») и их включения в установленном приложении.',
			'settings.notifications.webPush.test' => 'Отправить тестовое уведомление',
			'settings.notifications.webPush.testNoSubscription' => 'Нет подписанных устройств. Сначала нажмите «Включить» на телефоне.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Отправлено на ${count} устройств. Если на телефоне ничего не появилось, добавьте DDAgent на домашний экран (это требование iOS).',
			'settings.notifications.webPush.testNotDelivered' => 'Ни одно устройство не было доступно. Убедитесь, что приложение запущено и уведомления включены.',
			'settings.notifications.device.title' => 'Уведомлять это устройство',
			'settings.notifications.device.enabled' => 'Уведомления включены для этого устройства',
			'settings.notifications.desktop.title' => 'Уведомлять это десктопное приложение',
			'settings.notifications.desktop.enable' => 'Включить Push уведомления',
			'settings.notifications.desktop.disable' => 'Отключить Push уведомления',
			'settings.notifications.desktop.enabled' => 'Уведомления включены для этого десктопного приложения',
			'settings.notifications.desktop.unsupported' => 'Десктопные уведомления не поддерживаются в этой системе.',
			'settings.notifications.sound.title' => 'Звук',
			'settings.notifications.sound.description' => 'Воспроизводить короткий сигнал при завершении запуска чата.',
			'settings.notifications.sound.enabled' => 'Включено',
			'settings.notifications.sound.test' => 'Проверить звук',
			'settings.notifications.events.title' => 'Типы событий',
			'settings.notifications.events.actionRequired' => 'Требуется действие',
			'settings.notifications.events.stop' => 'Запуск остановлен',
			'settings.notifications.events.error' => 'Запуск завершился с ошибкой',
			'settings.notifications.messaging.title' => 'Одобрения через мессенджеры',
			'settings.notifications.messaging.description' => 'Одобряйте или отклоняйте запросы разрешений агентов из Telegram и получайте уведомления о запусках в Discord.',
			'settings.notifications.messaging.enabled' => 'Включено',
			'settings.notifications.messaging.save' => 'Сохранить',
			'settings.notifications.messaging.test' => 'Проверить',
			'settings.notifications.messaging.pair' => 'Связать',
			'settings.notifications.messaging.telegramToken' => 'Токен бота от @BotFather (123456:ABC…)',
			'settings.notifications.messaging.telegramHint' => 'Отправьте любое сообщение своему боту, затем свяжите чат ниже.',
			'settings.notifications.messaging.discordWebhook' => 'https://discord.com/api/webhooks/…',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.unpair' => 'Отвязать',
			'settings.appearanceSettings.darkMode.label' => 'Темная тема',
			'settings.appearanceSettings.darkMode.description' => 'Переключение между светлой и темной темами',
			'settings.appearanceSettings.codeEditor.title' => 'Редактор кода',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Тема редактора',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Тема по умолчанию для редактора кода',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Перенос слов',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Включить перенос слов по умолчанию в редакторе',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Показать миникарту',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Отображать миникарту для упрощения навигации в представлении различий',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Показать номера строк',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Отображать номера строк в редакторе',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Размер шрифта',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Размер шрифта редактора в пикселях',
			'settings.appearanceSettings.terminal.title' => 'Терминал',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Фокус следует за указателем',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Фокусировать терминал для ввода при наведении мыши',
			'settings.mcpForm.title.add' => 'Добавить MCP сервер',
			'settings.mcpForm.title.edit' => 'Редактировать MCP сервер',
			'settings.mcpForm.importMode.form' => 'Ввод формы',
			'settings.mcpForm.importMode.json' => 'Импорт JSON',
			'settings.mcpForm.scope.label' => 'Область',
			'settings.mcpForm.scope.userGlobal' => 'Пользователь (глобально)',
			'settings.mcpForm.scope.projectLocal' => 'Проект (локально)',
			'settings.mcpForm.scope.userDescription' => 'Область пользователя: доступно во всех проектах на вашей машине',
			'settings.mcpForm.scope.projectDescription' => 'Локальная область: доступно только в выбранном проекте',
			'settings.mcpForm.scope.cannotChange' => 'Область не может быть изменена при редактировании существующего сервера',
			'settings.mcpForm.fields.serverName' => 'Имя сервера',
			'settings.mcpForm.fields.transportType' => 'Тип транспорта',
			'settings.mcpForm.fields.command' => 'Команда',
			'settings.mcpForm.fields.arguments' => 'Аргументы (по одному на строку)',
			'settings.mcpForm.fields.jsonConfig' => 'JSON конфигурация',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Переменные окружения (КЛЮЧ=значение, по одной на строку)',
			'settings.mcpForm.fields.headers' => 'Заголовки (КЛЮЧ=значение, по одному на строку)',
			'settings.mcpForm.fields.selectProject' => 'Выберите проект...',
			'settings.mcpForm.placeholders.serverName' => 'мой-сервер',
			'settings.mcpForm.validation.missingType' => 'Отсутствует обязательное поле: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'тип stdio требует поле command',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => 'тип ${type} требует поле url',
			'settings.mcpForm.validation.invalidJson' => 'Неверный формат JSON',
			'settings.mcpForm.validation.jsonHelp' => 'Вставьте конфигурацию вашего MCP сервера в формате JSON. Примеры форматов:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Детали конфигурации (из ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Путь: ${path}',
			'settings.mcpForm.actions.cancel' => 'Отмена',
			'settings.mcpForm.actions.saving' => 'Сохранение...',
			'settings.mcpForm.actions.addServer' => 'Добавить сервер',
			'settings.mcpForm.actions.updateServer' => 'Обновить сервер',
			'settings.saveStatus.success' => 'Настройки успешно сохранены!',
			'settings.saveStatus.error' => 'Не удалось сохранить настройки',
			'settings.saveStatus.saving' => 'Сохранение...',
			'settings.footerActions.save' => 'Сохранить настройки',
			'settings.footerActions.cancel' => 'Отмена',
			'settings.git.title' => 'Конфигурация Git',
			'settings.git.description' => 'Настройте вашу git идентичность для коммитов. Эти настройки будут применены глобально через git config --global',
			'settings.git.name.label' => 'Имя Git',
			'settings.git.name.help' => 'Ваше имя для git коммитов',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'Email Git',
			'settings.git.email.help' => 'Ваш email для git коммитов',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Сохранить конфигурацию',
			'settings.git.actions.saving' => 'Сохранение...',
			'settings.git.status.success' => 'Успешно сохранено',
			'settings.git.status.error' => 'Не удалось сохранить',
			'settings.apiKeys.title' => 'API ключи',
			'settings.apiKeys.description' => 'Генерируйте API ключи для доступа к внешнему API из других приложений.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ Сохраните ваш API ключ',
			'settings.apiKeys.newKey.alertMessage' => 'Это единственный раз, когда вы увидите этот ключ. Сохраните его в безопасном месте.',
			'settings.apiKeys.newKey.iveSavedIt' => 'Я сохранил его',
			'settings.apiKeys.form.placeholder' => 'Имя API ключа (например, Продакшн сервер)',
			'settings.apiKeys.form.createButton' => 'Создать',
			'settings.apiKeys.form.cancelButton' => 'Отмена',
			'settings.apiKeys.newButton' => 'Новый API ключ',
			'settings.apiKeys.empty' => 'API ключи еще не созданы.',
			'settings.apiKeys.list.created' => 'Создан:',
			'settings.apiKeys.list.lastUsed' => 'Последнее использование:',
			'settings.apiKeys.confirmDelete' => 'Вы уверены, что хотите удалить этот API ключ?',
			'settings.apiKeys.status.active' => 'Активен',
			'settings.apiKeys.status.inactive' => 'Неактивен',
			'settings.apiKeys.github.title' => 'GitHub токены',
			'settings.apiKeys.github.description' => 'Добавьте персональные токены доступа GitHub для клонирования приватных репозиториев через внешний API.',
			'settings.apiKeys.github.descriptionAlt' => 'Добавьте персональные токены доступа GitHub для клонирования приватных репозиториев. Вы также можете передавать токены напрямую в API запросах без их сохранения.',
			'settings.apiKeys.github.addButton' => 'Добавить токен',
			'settings.apiKeys.github.form.namePlaceholder' => 'Имя токена (например, Личные репозитории)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'Персональный токен доступа GitHub (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Описание (необязательно)',
			'settings.apiKeys.github.form.addButton' => 'Добавить токен',
			'settings.apiKeys.github.form.cancelButton' => 'Отмена',
			'settings.apiKeys.github.form.howToCreate' => 'Как создать персональный токен доступа GitHub →',
			'settings.apiKeys.github.form.showToken' => 'Показать токен',
			'settings.apiKeys.github.form.hideToken' => 'Скрыть токен',
			'settings.apiKeys.github.empty' => 'GitHub токены еще не добавлены.',
			'settings.apiKeys.github.added' => 'Добавлен:',
			'settings.apiKeys.github.confirmDelete' => 'Вы уверены, что хотите удалить этот GitHub токен?',
			'settings.apiKeys.apiDocsLink' => 'Документация API',
			'settings.apiKeys.documentation.title' => 'Документация внешнего API',
			'settings.apiKeys.documentation.description' => 'Узнайте, как использовать внешний API для запуска сеансов Claude/Cursor из ваших приложений.',
			'settings.apiKeys.documentation.viewLink' => 'Просмотр документации API →',
			'settings.apiKeys.loading' => 'Загрузка...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Доступно обновление: v${version}',
			'settings.tasks.checking' => 'Проверка установки TaskMaster...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI не установлен',
			'settings.tasks.notInstalled.description' => 'TaskMaster CLI требуется для использования функций управления задачами. Установите его для начала работы:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'Посмотреть на GitHub',
			'settings.tasks.notInstalled.afterInstallation' => 'После установки:',
			'settings.tasks.notInstalled.steps.restart' => 'Перезапустите это приложение',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'Функции TaskMaster станут автоматически доступны',
			'settings.tasks.notInstalled.steps.initCommand' => 'Используйте task-master init в каталоге вашего проекта',
			'settings.tasks.settings.enableLabel' => 'Включить интеграцию TaskMaster',
			'settings.tasks.settings.enableDescription' => 'Показывать задачи TaskMaster, баннеры и индикаторы боковой панели в интерфейсе',
			'settings.agents.authStatus.checking' => 'Проверка...',
			'settings.agents.authStatus.connected' => 'Подключен',
			'settings.agents.authStatus.notConnected' => 'Не подключен',
			'settings.agents.authStatus.disconnected' => 'Отключен',
			'settings.agents.authStatus.checkingAuth' => 'Проверка статуса аутентификации...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Вошли как ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => 'Аккаунт ${provider}',
			'settings.agents.authStatus.authenticatedUser' => 'аутентифицированный пользователь',
			'settings.agents.install.title' => ({required Object agent}) => 'CLI ${agent} не установлен',
			'settings.agents.install.description' => ({required Object agent}) => 'Установите CLI ${agent}, чтобы войти и запускать сессии.',
			'settings.agents.install.button' => 'Установить',
			'settings.agents.install.installing' => 'Установка…',
			'settings.agents.install.copyCommand' => 'Копировать команду',
			'settings.agents.install.docs' => 'Документация',
			'settings.agents.install.success' => ({required Object agent}) => 'CLI ${agent} установлен',
			'settings.agents.install.failed' => 'Установка не удалась — проверьте вывод терминала',
			'settings.agents.update.title' => 'Обновить CLI',
			'settings.agents.update.description' => ({required Object agent}) => 'Установить последнюю версию CLI ${agent} на хосте сервера.',
			'settings.agents.update.button' => 'Обновить',
			'settings.agents.update.updating' => 'Обновление…',
			'settings.agents.update.success' => ({required Object agent}) => 'CLI ${agent} обновлён',
			'settings.agents.update.failed' => 'Не удалось обновить — проверьте вывод терминала',
			'settings.agents.account.claude.description' => 'AI-ассистент Anthropic Claude',
			'settings.agents.account.cursor.description' => 'Редактор кода с AI Cursor',
			'settings.agents.account.codex.description' => 'AI-ассистент OpenAI Codex',
			'settings.agents.account.opencode.description' => 'CLI-ассистент OpenCode',
			'settings.agents.account.commandcode.description' => 'CLI-ассистент Command Code',
			'settings.agents.account.antigravity.description' => 'CLI-ассистент Antigravity',
			'settings.agents.account.devin.description' => 'CLI-ассистент Devin',
			'settings.agents.connectionStatus' => 'Статус подключения',
			'settings.agents.login.title' => 'Вход',
			'settings.agents.login.reAuthenticate' => 'Повторная аутентификация',
			'settings.agents.login.description' => ({required Object agent}) => 'Войдите в ваш аккаунт ${agent} для включения AI функций',
			'settings.agents.login.reAuthDescription' => 'Войдите с другим аккаунтом или обновите учетные данные',
			'settings.agents.login.button' => 'Войти',
			'settings.agents.login.reLoginButton' => 'Войти снова',
			'settings.agents.logout.title' => 'Выйти',
			'settings.agents.logout.description' => 'Выйти из этого провайдера и удалить сохранённые учётные данные',
			'settings.agents.logout.button' => 'Выйти',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => 'Выйти из ${agent}?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Это удалит сохранённые учётные данные ${agent} на сервере. Войдите снова, чтобы продолжить использовать ${agent}.',
			'settings.agents.logout.success' => 'Вы вышли',
			'settings.agents.logout.failed' => 'Не удалось выйти',
			'settings.agents.error' => ({required Object error}) => 'Ошибка: ${error}',
			'settings.agents.accounts.title' => 'Именованные аккаунты',
			'settings.agents.accounts.description' => 'Дополнительные наборы учётных данных. Сеанс, привязанный к аккаунту, запускает CLI с его изолированным каталогом конфигурации. Чтобы войти, один раз запустите CLI провайдера с указанными переменными окружения.',
			'settings.agents.accounts.sharedCli' => 'Все аккаунты используют одну установку CLI — обновите её в карточке подключения выше.',
			'settings.agents.accounts.loading' => 'Загрузка аккаунтов…',
			'settings.agents.accounts.kDefault' => 'По умолчанию',
			'settings.agents.accounts.usage' => ({required Object tokens}) => 'Токенов: ${tokens}',
			'settings.agents.accounts.usageButton' => 'Использование',
			'settings.agents.accounts.showUsage' => 'Показать расход токенов',
			'settings.agents.accounts.makeDefault' => 'Сделать основным',
			'settings.agents.accounts.remove' => 'Удалить аккаунт',
			'settings.agents.accounts.newLabel' => 'Метка аккаунта (например, Работа)',
			'settings.agents.accounts.add' => 'Добавить аккаунт',
			'settings.agents.accounts.autoSwitch.label' => 'Автоматически переключать аккаунт при исчерпании лимита',
			'settings.agents.accounts.autoSwitch.description' => 'Когда аккаунт достигает лимита использования, сессия переходит на другой аккаунт того же агента, у которого ещё есть лимит, — даже если исчерпанный аккаунт выбран вручную. Никогда не переключает на другого агента. Claude и Codex сохраняют беседу; другие агенты переключаются только в новых чатах.',
			'settings.permissions.title' => 'Настройки разрешений',
			'settings.permissions.permissionMode.title' => 'Режим разрешений',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Режим разрешений по умолчанию для новых сессий ${provider}. Его всё ещё можно переопределить для отдельной сессии.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'По умолчанию',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Действия, требующие разрешения, показываются вам для одобрения в чате.',
			'settings.permissions.permissionMode.modes.auto.title' => 'Авторежим',
			'settings.permissions.permissionMode.modes.auto.description' => 'Классификатор модели решает для каждого вызова инструмента, одобрить или отклонить. Высокая автономность.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Принимать правки',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Правки файлов одобряются автоматически; другие действия по-прежнему запрашивают одобрение.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Обход разрешений',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Каждое действие одобряется автоматически — полный доступ без запросов. Используйте с осторожностью.',
			'settings.permissions.permissionMode.modes.plan.title' => 'План',
			'settings.permissions.permissionMode.modes.plan.description' => 'Режим планирования: агент исследует и планирует, не выполняя команд.',
			'settings.mcpServers.title' => 'MCP серверы',
			'settings.mcpServers.description.claude' => 'Серверы Model Context Protocol предоставляют дополнительные инструменты и источники данных для Claude',
			'settings.mcpServers.description.cursor' => 'Серверы Model Context Protocol предоставляют дополнительные инструменты и источники данных для Cursor',
			'settings.mcpServers.description.codex' => 'Серверы Model Context Protocol предоставляют дополнительные инструменты и источники данных для Codex',
			'settings.mcpServers.description.opencode' => 'Серверы Model Context Protocol предоставляют OpenCode дополнительные инструменты и источники данных',
			'settings.mcpServers.description.commandcode' => 'Серверы Model Context Protocol предоставляют Command Code дополнительные инструменты и источники данных',
			'settings.mcpServers.description.antigravity' => 'Серверы Model Context Protocol предоставляют Antigravity дополнительные инструменты и источники данных',
			'settings.mcpServers.description.devin' => 'Серверы Model Context Protocol предоставляют Devin дополнительные инструменты и источники данных',
			'settings.mcpServers.addButton' => 'Добавить MCP сервер',
			'settings.mcpServers.empty' => 'MCP серверы не настроены',
			'settings.mcpServers.serverType' => 'Тип',
			'settings.mcpServers.scope.local' => 'локальный',
			'settings.mcpServers.scope.user' => 'пользователь',
			'settings.mcpServers.config.command' => 'Команда',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Аргументы',
			'settings.mcpServers.config.environment' => 'Окружение',
			'settings.mcpServers.tools.title' => 'Инструменты',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} еще',
			'settings.mcpServers.actions.edit' => 'Редактировать сервер',
			'settings.mcpServers.actions.delete' => 'Удалить сервер',
			'settings.mcpServers.managed.badge' => 'Управляемый',
			'settings.mcpServers.managed.hint' => 'Управляется DDAgent.',
			'settings.mcpServers.help.title' => 'О Codex MCP',
			'settings.mcpServers.help.description' => 'Codex поддерживает MCP серверы на основе stdio. Вы можете добавлять серверы, которые расширяют возможности Codex дополнительными инструментами и ресурсами.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '«${serverName}» будет удалён из конфигурации провайдера.',
			'settings.mcpServers.deleteConfirm.title' => 'Удалить сервер MCP?',
			'settings.quota.settings.tab' => 'Центр управления',
			'settings.quota.settings.title' => 'Центр управления',
			'settings.quota.settings.description' => 'Пороги оповещений, политика маршрутизации и аккаунты, опрашиваемые для квот.',
			'settings.quota.settings.saved' => 'Сохранено',
			'settings.quota.settings.alertsSection' => 'Оповещения',
			'settings.quota.settings.alertsSectionHint' => 'Предупреждать до фактического исчерпания лимита, а не только на 100%.',
			'settings.quota.settings.alertsEnabled' => 'Прогнозные оповещения о лимитах',
			'settings.quota.settings.alertsEnabledHint' => 'Показывать прогнозы на основе темпа в обзоре и на карточках аккаунтов.',
			'settings.quota.settings.watchThreshold' => 'Порог наблюдения (%)',
			'settings.quota.settings.watchThresholdHint' => 'Аккаунты с показаниями на этом уровне или выше считаются под угрозой.',
			'settings.quota.settings.dangerThreshold' => 'Порог опасности (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Показания на этом уровне или выше отображаются красным.',
			'settings.quota.settings.routingSection' => 'Маршрутизация',
			'settings.quota.settings.routingSectionHint' => 'Как панель может переносить работу на аккаунт с наибольшим запасом.',
			'settings.quota.settings.routing.manual' => 'Вручную',
			'settings.quota.settings.routing.manualHint' => 'Показывать только рекомендацию; никогда не переключать аккаунты автоматически.',
			'settings.quota.settings.routing.ask' => 'Спрашивать перед переключением',
			'settings.quota.settings.routing.askHint' => 'Переключение предлагается и ждёт вашего одобрения.',
			'settings.quota.settings.routing.autoLowRisk' => 'Авто для задач с низким риском',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Автоматически могут перемещаться только задачи с пометкой низкого риска.',
			'settings.quota.settings.routingNote' => 'Смена аккаунта меняет стоимость и качество модели, поэтому всегда требует явного решения.',
			'settings.quota.settings.accountsSection' => 'Опрашиваемые аккаунты',
			'settings.quota.settings.accountsSectionHint' => 'Учётные данные читаются из каждого инструмента; панель никуда их не отправляет.',
			'settings.quota.settings.sourcesSection' => 'Источники данных',
			'settings.quota.settings.sourcesSectionHint' => 'Откуда берутся данные об использовании и стоимости.',
			'settings.quota.settings.logSources' => 'Хранилище журналов токенов и затрат',
			'settings.quota.settings.logSourcesHint' => 'Агрегированное хранилище только для чтения, общее с коллектором tokboard.',
			'settings.quota.settings.readOnly' => 'Только чтение',
			'settings.quota.settings.quotaConsent' => 'Опрос квот',
			'settings.quota.settings.quotaConsentHint' => 'Читает эндпоинты квот провайдеров с локально сохранёнными учётными данными.',
			'settings.quota.settings.localOnly' => 'Только локально',
			'settings.quota.empty.description' => 'Аккаунты пока не обнаружены.',
			'settings.quota.quality.cached' => 'из кэша',
			'settings.quota.quality.error' => 'ошибка',
			'settings.quota.quality.estimate' => 'оценка',
			'settings.quota.quality.live' => 'live',
			'settings.quota.quality.unknown' => 'неизвестно',
			'settings.quota.syncFailed' => 'Синхронизация не удалась',
			'settings.quota.syncNow' => 'Синхронизировать',
			'settings.browser.checking' => 'проверка...',
			'settings.browser.description' => 'Разрешите агентам создавать контролируемые сессии браузера Playwright, которые можно наблюдать на вкладке Browser.',
			'settings.browser.enableDescription' => 'Регистрирует Browser для поддерживаемых агентов. Агенты могут создавать сессии браузера; вы можете наблюдать, останавливать и удалять их.',
			'settings.browser.enableLabel' => 'Включить Browser',
			'settings.browser.errors.installRuntime' => 'Не удалось установить среду выполнения браузера',
			'settings.browser.errors.loadSettings' => 'Не удалось загрузить настройки Browser',
			'settings.browser.errors.loadStatus' => 'Не удалось загрузить статус Browser',
			'settings.browser.errors.saveSettings' => 'Не удалось сохранить настройки Browser',
			'settings.browser.installHint' => 'Установите среду выполнения браузера, прежде чем агенты смогут создавать сессии Browser.',
			'settings.browser.installRuntime' => 'Установить среду выполнения',
			'settings.browser.installed' => 'установлено',
			'settings.browser.installing' => 'Установка...',
			'settings.browser.missing' => 'отсутствует',
			'settings.browser.runtimeRequired' => 'Требуется среда выполнения браузера',
			'settings.browser.statusDisabled' => 'отключён',
			'settings.browser.statusLabel' => 'Статус',
			'settings.browser.statusReady' => 'готов',
			'settings.browser.statusSetupRequired' => 'требуется настройка',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Отмена',
			'settings.workspaces.create' => 'Добавить рабочую область',
			'settings.workspaces.deleteConfirm' => 'Удалить эту рабочую область из DDAgent? Её файлы останутся на диске.',
			'settings.workspaces.deleteFailed' => 'Не удалось удалить рабочую область.',
			'settings.workspaces.deleteTitle' => 'Удалить рабочую область',
			'settings.workspaces.description' => 'Рабочие области — каталоги, в которых DDAgent может вести чаты, запускать код и просматривать файлы.',
			'settings.workspaces.remove' => 'Удалить рабочую область',
			'settings.workspaces.title' => 'Рабочие области',
			'settings.workspaces.pathRequired' => 'Требуется путь',
			'settings.stt.title' => 'Голосовой ввод (распознавание речи)',
			'settings.stt.description' => 'Whisper-совместимая конечная точка /audio/transcriptions (OpenAI, whisper.cpp, faster-whisper, Speaches). Включает кнопку микрофона в поле ввода.',
			'settings.stt.configured' => 'настроено',
			'settings.stt.endpoint' => 'URL конечной точки (например, https://api.openai.com/v1)',
			'settings.stt.apiKey' => 'Ключ API',
			'settings.stt.model' => 'Модель (по умолчанию: whisper-1)',
			'settings.stt.save' => 'Сохранить',
			'settings.schedules.title' => 'Расписания',
			'settings.schedules.description' => 'Повторяющиеся запуски агентов по расписанию cron. Запуски выполняются без присмотра и в обход запросов разрешений.',
			'settings.schedules.preventSleep' => 'Не давать уходить в сон во время работы агентов',
			_ => null,
		} ?? switch (path) {
			'settings.schedules.preventSleepHint' => 'Десктопное приложение не даёт экрану погаснуть; в браузере используется блокировка отключения экрана (wake lock).',
			'settings.schedules.kNew' => 'Новое расписание',
			'settings.schedules.loading' => 'Загрузка…',
			'settings.schedules.empty' => 'Расписаний пока нет.',
			'settings.schedules.project' => 'Проект',
			'settings.schedules.provider' => 'Провайдер',
			'settings.schedules.cron' => 'Cron (минута час день месяц день_недели)',
			'settings.schedules.nextRun' => ({required Object time}) => 'Следующий запуск: ${time}',
			'settings.schedules.cronInvalid' => 'Для этого выражения нет предстоящих запусков',
			'settings.schedules.prompt' => 'Промпт',
			'settings.schedules.useWorktree' => 'Запускать в новом worktree',
			'settings.schedules.catchUp' => 'Наверстать пропущенные запуски',
			'settings.schedules.failures' => ({required Object count}) => 'Сбоев: ${count}',
			'settings.schedules.disabled' => 'отключено',
			'settings.schedules.history' => 'История',
			'settings.schedules.runNow' => 'Запустить сейчас',
			'settings.schedules.delete' => 'Удалить',
			'settings.schedules.noRuns' => 'Запусков пока нет.',
			'settings.schedules.next' => 'следующий',
			'settings.schedules.create' => 'Создать',
			'settings.schedules.toggleSchedule' => 'Включить расписание',
			'settings.mcpTokens.title' => 'Токены MCP-сервера DDAgent',
			'settings.mcpTokens.description' => 'Внешние инструменты (Claude Desktop, OpenClaw) вызывают инструменты DDAgent через POST /mcp с одним из этих bearer-токенов.',
			'settings.mcpTokens.dismiss' => 'Закрыть',
			'settings.mcpTokens.labelPlaceholder' => 'Метка токена (например, Claude Desktop)',
			'settings.mcpTokens.create' => 'Создать',
			'settings.mcpTokens.empty' => 'MCP-токенов пока нет.',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => 'использован ${time}',
			'settings.mcpTokens.neverUsed' => 'ни разу не использован',
			'settings.about.supportTitle' => 'Поддержать проект',
			'settings.about.buyMeACoffee' => 'Угостите меня кофе',
			'settings.about.tryHosted' => 'Попробовать DDAgent Hosted',
			'settings.about.learnMore' => 'Подробнее',
			'settings.about.proFeatures' => 'Возможности DDAgent Pro',
			'settings.about.pro.syncSettings' => 'Синхронизация настроек',
			'settings.about.pro.teamManagement' => 'Управление командой',
			'settings.about.pro.syncSettingsDescription' => 'Синхронизируйте настройки, конфигурации MCP и тему во всех своих средах.',
			'settings.about.pro.teamManagementDescription' => 'Несколько пользователей, ролевой доступ и общие проекты для вашей команды.',
			'settings.about.versionInfo' => 'Информация о версии',
			'settings.about.client' => 'Приложение',
			'settings.about.server' => 'Сервер',
			'settings.about.platformMobile' => 'Мобильное',
			'settings.about.platformDesktop' => 'Десктоп',
			'settings.about.platformWeb' => 'Веб',
			'settings.about.unknown' => 'неизвестно',
			'settings.about.copyright' => '© 2026 DDAgent — все права защищены',
			'settings.about.tagline' => 'Интерфейс ИИ-ассистента для программирования с открытым исходным кодом',
			'settings.about.docs' => 'Документация',
			'settings.about.hostedDescription' => 'Командная работа, общие конфигурации MCP, синхронизация настроек между средами и управляемая инфраструктура.',
			'settings.shortcuts.description' => 'Все сочетания клавиш DDAgent с разбивкой по платформам.',
			'settings.shortcuts.action' => 'Действие',
			'settings.shortcuts.winLinux' => 'Windows / Linux',
			'settings.shortcuts.mac' => 'macOS',
			'settings.shortcuts.navigation' => 'Навигация',
			'settings.shortcuts.navWorkspace' => 'Перейти в рабочую область',
			'settings.shortcuts.navTasks' => 'Перейти к задачам / Git',
			'settings.shortcuts.navGit' => 'Перейти к Git',
			'settings.shortcuts.navFocus' => 'Переключить режим фокуса (боковая панель)',
			'settings.shortcuts.navSwitcher' => 'Быстрое переключение сеансов',
			'settings.shortcuts.navPalette' => 'Палитра команд',
			'settings.shortcuts.navSettings' => 'Открыть настройки',
			'settings.shortcuts.navClose' => 'Закрыть диалог / восстановить разделённые панели',
			'settings.shortcuts.composer' => 'Поле ввода',
			'settings.shortcuts.compSend' => 'Отправить сообщение',
			'settings.shortcuts.compNewline' => 'Новая строка',
			'settings.shortcuts.compNav' => 'Перемещение по подсказкам',
			'settings.shortcuts.compAccept' => 'Принять подсказку',
			'settings.shortcuts.compCloseSuggest' => 'Закрыть подсказки',
			'settings.shortcuts.transcript' => 'Переписка',
			'settings.shortcuts.trCopy' => 'Копировать выделенный текст',
			'settings.shortcuts.trClose' => 'Закрыть поиск / панель проверки',
			'settings.shortcuts.terminal' => 'Терминал',
			'settings.shortcuts.termCopy' => 'Копировать выделение',
			'settings.shortcuts.termInterrupt' => 'Прервать процесс (без выделения)',
			'settings.shortcuts.termPaste' => 'Вставить',
			'settings.shortcuts.termSelectAll' => 'Выделить всё',
			'settings.shortcuts.editor' => 'Редактор',
			'settings.shortcuts.edSave' => 'Сохранить файл',
			'settings.shortcuts.edSaveAll' => 'Сохранить все файлы',
			'settings.shortcuts.edClose' => 'Закрыть вкладку',
			'settings.shortcuts.edNextTab' => 'Следующая вкладка',
			'settings.shortcuts.edPrevTab' => 'Предыдущая вкладка',
			'settings.shortcuts.edIndent' => 'Увеличить / уменьшить отступ',
			'settings.shortcuts.palette' => 'Палитра команд',
			'settings.shortcuts.palNav' => 'Перемещение по элементам',
			'settings.shortcuts.palRun' => 'Выполнить / открыть',
			'settings.shortcuts.palBack' => 'Назад (пустой поиск)',
			'settings.shortcuts.palClose' => 'Закрыть',
			'sidebar.projects.title' => 'Проекты',
			'sidebar.projects.newProject' => 'Новый проект',
			'sidebar.projects.deleteProject' => 'Убрать проект',
			'sidebar.projects.renameProject' => 'Переименовать проект',
			'sidebar.projects.noProjects' => 'Проекты не найдены',
			'sidebar.projects.loadingProjects' => 'Загрузка проектов...',
			'sidebar.projects.searchPlaceholder' => 'Поиск проектов...',
			'sidebar.projects.projectNamePlaceholder' => 'Имя проекта',
			'sidebar.projects.starred' => 'Избранное',
			'sidebar.projects.all' => 'Все',
			'sidebar.projects.untitledSession' => 'Безымянный сеанс',
			'sidebar.projects.newSession' => 'Новый сеанс',
			'sidebar.projects.codexSession' => 'Сеанс Codex',
			'sidebar.projects.fetchingProjects' => 'Получение ваших проектов и сеансов Claude',
			'sidebar.projects.projects' => 'проекты',
			'sidebar.projects.noMatchingProjects' => 'Нет подходящих проектов',
			'sidebar.projects.tryDifferentSearch' => 'Попробуйте изменить поисковый запрос',
			'sidebar.projects.runClaudeCli' => 'Запустите Claude CLI в каталоге проекта для начала работы',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'Интерфейс AI помощника для программирования',
			'sidebar.panel.open' => 'Панель',
			'sidebar.panel.newChat' => 'Новый чат',
			'sidebar.panel.navigation' => 'Навигация',
			'sidebar.panel.sessions' => 'Сессии',
			'sidebar.sessions.title' => 'Сеансы',
			'sidebar.sessions.newSession' => 'Новый сеанс',
			'sidebar.sessions.deleteSession' => 'Удалить сеанс',
			'sidebar.sessions.renameSession' => 'Переименовать сеанс',
			'sidebar.sessions.noSessions' => 'Сеансов пока нет',
			'sidebar.sessions.loadingSessions' => 'Загрузка сеансов...',
			'sidebar.sessions.unnamed' => 'Без имени',
			'sidebar.sessions.loading' => 'Загрузка...',
			'sidebar.sessions.showMore' => 'Показать больше сеансов',
			'sidebar.sessions.selectMode' => 'Выбрать',
			'sidebar.sessions.selectAll' => 'Выбрать все',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Архивировать (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Удалить (${count})',
			'sidebar.sessions.cancelSelection' => 'Отменить выбор',
			'sidebar.sessions.toggleSelection' => 'Переключить выбор сессий',
			'sidebar.sessions.selectionToolbar' => 'Действия с выбранными сессиями',
			'sidebar.sessions.options' => 'Опции сессии',
			'sidebar.sessions.pinSession' => 'Закрепить сессию',
			'sidebar.sessions.unpinSession' => 'Открепить сессию',
			'sidebar.sessions.pinned' => 'Закреплённая сессия',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Выбрано: ${count}', other: 'Выбрано: ${count}', ), 
			'sidebar.tooltips.viewEnvironments' => 'Просмотр окружений',
			'sidebar.tooltips.hideSidebar' => 'Скрыть боковую панель',
			'sidebar.tooltips.createProject' => 'Создать новый проект',
			'sidebar.tooltips.refresh' => 'Обновить проекты и сеансы (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Переименовать проект (F2)',
			'sidebar.tooltips.deleteProject' => 'Убрать проект из боковой панели (Delete)',
			'sidebar.tooltips.addToFavorites' => 'Добавить в избранное',
			'sidebar.tooltips.removeFromFavorites' => 'Удалить из избранного',
			'sidebar.tooltips.editSessionName' => 'Вручную редактировать имя сеанса',
			'sidebar.tooltips.deleteSession' => 'Удалить этот сеанс навсегда',
			'sidebar.tooltips.activeSessionIndicator' => 'Недавно активный сеанс (последние 10 минут)',
			'sidebar.tooltips.save' => 'Сохранить',
			'sidebar.tooltips.cancel' => 'Отмена',
			'sidebar.tooltips.clearSearch' => 'Очистить поиск',
			'sidebar.tooltips.openCommandPalette' => 'Открыть палитру команд',
			'sidebar.tooltips.attentionRequiredIndicator' => 'Сессия требует внимания',
			'sidebar.tooltips.openSessions' => 'Просмотр сессий',
			'sidebar.navigation.chat' => 'Чат',
			'sidebar.navigation.files' => 'Файлы',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Терминал',
			'sidebar.navigation.tasks' => 'Задачи',
			'sidebar.actions.refresh' => 'Обновить',
			'sidebar.actions.settings' => 'Настройки',
			'sidebar.actions.collapseAll' => 'Свернуть все',
			'sidebar.actions.expandAll' => 'Развернуть все',
			'sidebar.actions.cancel' => 'Отмена',
			'sidebar.actions.save' => 'Сохранить',
			'sidebar.actions.delete' => 'Удалить',
			'sidebar.actions.rename' => 'Переименовать',
			'sidebar.actions.joinCommunity' => 'Присоединиться к сообществу',
			'sidebar.actions.reportIssue' => 'Сообщить о проблеме',
			'sidebar.actions.starOnGithub' => 'Звезда на GitHub',
			'sidebar.actions.buyMeACoffee' => 'Угостите меня кофе',
			'sidebar.workspace.title' => 'Сменить рабочую область сессии',
			'sidebar.workspace.description' => 'Агент выполняет следующие шаги в этом каталоге. Существующая история сессии сохраняется.',
			'sidebar.workspace.pathLabel' => 'Путь рабочей области',
			'sidebar.workspace.pathRequired' => 'Требуется путь рабочей области.',
			'sidebar.workspace.submit' => 'Сменить рабочую область',
			'sidebar.workspace.saving' => 'Смена…',
			'sidebar.workspace.changeAction' => 'Сменить рабочую область',
			'sidebar.branding.openSource' => 'Открытый исходный код',
			'sidebar.status.active' => 'Активен',
			'sidebar.status.inactive' => 'Неактивен',
			'sidebar.status.thinking' => 'Думает...',
			'sidebar.status.error' => 'Ошибка',
			'sidebar.status.aborted' => 'Прервано',
			'sidebar.status.unknown' => 'Неизвестно',
			'sidebar.time.justNow' => 'Только что',
			'sidebar.time.oneMinuteAgo' => '1 мин. назад',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} мин. назад',
			'sidebar.time.oneHourAgo' => '1 час назад',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} ч. назад',
			'sidebar.time.oneDayAgo' => '1 день назад',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} дн. назад',
			'sidebar.messages.deleteConfirm' => 'Вы уверены, что хотите это удалить?',
			'sidebar.messages.renameSuccess' => 'Успешно переименовано',
			'sidebar.messages.deleteSuccess' => 'Успешно удалено',
			'sidebar.messages.errorOccurred' => 'Произошла ошибка',
			'sidebar.messages.deleteSessionConfirm' => 'Вы уверены, что хотите удалить этот сеанс? Это действие нельзя отменить.',
			'sidebar.messages.deleteProjectConfirm' => 'Убрать этот проект из боковой панели? Файлы проекта, воспоминания и данные сеансов не будут удалены.',
			'sidebar.messages.enterProjectPath' => 'Пожалуйста, введите путь к проекту',
			'sidebar.messages.deleteSessionFailed' => 'Не удалось удалить сеанс. Попробуйте снова.',
			'sidebar.messages.deleteSessionError' => 'Ошибка при удалении сеанса. Попробуйте снова.',
			'sidebar.messages.renameSessionFailed' => 'Не удалось переименовать сеанс. Попробуйте снова.',
			'sidebar.messages.renameSessionError' => 'Ошибка при переименовании сеанса. Попробуйте снова.',
			'sidebar.messages.changeWorkspaceFailed' => 'Не удалось сменить рабочую область. Попробуйте снова.',
			'sidebar.messages.changeWorkspaceError' => 'Ошибка при смене рабочей области. Попробуйте снова.',
			'sidebar.messages.deleteProjectFailed' => 'Не удалось убрать проект. Попробуйте снова.',
			'sidebar.messages.deleteProjectError' => 'Ошибка при удалении проекта из списка. Попробуйте снова.',
			'sidebar.messages.createProjectFailed' => 'Не удалось создать проект. Попробуйте снова.',
			'sidebar.messages.createProjectError' => 'Ошибка при создании проекта. Попробуйте снова.',
			'sidebar.messages.updateProjectError' => 'Ошибка при обновлении проекта. Попробуйте снова.',
			'sidebar.messages.refreshError' => 'Не удалось обновить. Попробуйте снова.',
			'sidebar.messages.restoreProjectFailed' => 'Не удалось восстановить проект. Попробуйте снова.',
			'sidebar.messages.restoreProjectError' => 'Ошибка при восстановлении проекта. Попробуйте снова.',
			'sidebar.messages.restoreSessionFailed' => 'Не удалось восстановить сеанс. Попробуйте снова.',
			'sidebar.messages.restoreSessionError' => 'Ошибка при восстановлении сеанса. Попробуйте снова.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Не удалось удалить ${count} сессию. Попробуйте снова.', other: 'Не удалось удалить ${count} сессий. Попробуйте снова.', ), 
			'sidebar.version.updateAvailable' => 'Доступно обновление',
			'sidebar.version.restartRequired' => 'Обновление установлено — перезапустите сервер для применения',
			'sidebar.version.updateNow' => 'Обновить',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Обновить DDAgent до v${version}? Будет получен и собран последний код, сервер перезапустится — активные сессии будут прерваны.',
			'sidebar.version.updating' => 'Обновление… может занять несколько минут',
			'sidebar.version.restarting' => 'Обновление установлено — перезапуск…',
			'sidebar.version.updateFailed' => 'Ошибка обновления',
			'sidebar.version.releaseNotes' => 'Примечания к релизу',
			'sidebar.search.modeProjects' => 'Проекты',
			'sidebar.search.modeConversations' => 'Разговоры',
			'sidebar.search.conversationsPlaceholder' => 'Поиск в разговорах...',
			'sidebar.search.searching' => 'Поиск...',
			'sidebar.search.sessionTitles' => 'Названия сеансов',
			'sidebar.search.conversationContents' => 'Содержимое разговоров',
			'sidebar.search.noResults' => 'Результаты не найдены',
			'sidebar.search.tryDifferentQuery' => 'Попробуйте другой поисковый запрос',
			'sidebar.search.modeRunning' => 'Выполняется',
			'sidebar.search.archiveOnly' => 'Архив',
			'sidebar.search.runningTooltip' => 'Активные сессии',
			'sidebar.search.archiveOnlyTooltip' => 'Только архив',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} активных',
			'sidebar.search.viewMenu' => 'Вид',
			'sidebar.search.backToProjects' => 'Назад к проектам',
			'sidebar.search.archivedPlaceholder' => 'Поиск по архиву...',
			'sidebar.search.runningPlaceholder' => 'Поиск активных сессий...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} совпадение', few: '${count} совпадения', many: '${count} совпадений', other: '${count} совпадений', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} проект просканирован', few: '${count} проекта просканировано', many: '${count} проектов просканировано', other: '${count} проектов просканировано', ), 
			'sidebar.recent.title' => 'Недавние разговоры',
			'sidebar.recent.emptyTitle' => 'Пока нет разговоров',
			'sidebar.recent.emptyDescription' => 'Здесь появятся ваши недавно обновлённые разговоры.',
			'sidebar.recent.loadFailed' => 'Не удалось загрузить недавние разговоры',
			'sidebar.recent.loadMore' => 'Загрузить более старые разговоры',
			'sidebar.recent.loadingMore' => 'Загрузка...',
			'sidebar.deleteConfirmation.deleteProject' => 'Убрать проект',
			'sidebar.deleteConfirmation.deleteSession' => 'Удалить сеанс',
			'sidebar.deleteConfirmation.confirmDelete' => 'Что вы хотите сделать с',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Убрать только из боковой панели',
			'sidebar.deleteConfirmation.deleteAllData' => 'Удалить все данные навсегда',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'Проект будет убран из боковой панели. Ваши файлы, воспоминания и данные сеансов сохранятся.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Вы сможете добавить проект позже.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'Архивирование скрывает выбранные сессии из активного списка, сохраняя их истории.',
			'sidebar.deleteConfirmation.archiveSession' => 'Архивировать сессию',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'Архивирование убирает сессию из активного списка, сохраняя её историю.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Эта сессия уже в архиве. Можно оставить её скрытой или удалить навсегда.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'Это навсегда удалит сессию и её транскрипт. Действие необратимо.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Удалить навсегда',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Этот проект содержит ${count} разговор.', few: 'Этот проект содержит ${count} разговора.', many: 'Этот проект содержит ${count} разговоров.', other: 'Этот проект содержит ${count} разговоров.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Управление выбранной сессией', other: 'Управление ${count} выбранными сессиями', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Архивировать сессию', other: 'Архивировать ${count} сессий', ), 
			'sidebar.zones.activeNow' => 'Активные сейчас',
			'sidebar.zones.recent' => 'Недавно использованные',
			'sidebar.zones.today' => 'Сегодня',
			'sidebar.zones.yesterday' => 'Вчера',
			'sidebar.zones.thisWeek' => 'На этой неделе',
			'sidebar.zones.showMore' => ({required Object count}) => 'Показать ещё ${count}',
			'sidebar.zones.showLess' => 'Показать меньше',
			'sidebar.tabs.board' => 'Панель агентов',
			'sidebar.tabs.files' => 'Файлы',
			'sidebar.tabs.git' => 'Контроль версий',
			'sidebar.tabs.tasks' => 'Задачи',
			'sidebar.tabs.usage' => 'Квоты и использование',
			'tasks.notConfigured.title' => 'TaskMaster AI не настроен',
			'tasks.notConfigured.description' => 'TaskMaster помогает разбивать сложные проекты на управляемые задачи с помощью AI',
			'tasks.notConfigured.whatIsTitle' => '🎯 Что такое TaskMaster?',
			'tasks.notConfigured.features.aiPowered' => 'Управление задачами с AI: разбивайте сложные проекты на управляемые подзадачи',
			'tasks.notConfigured.features.prdTemplates' => 'Шаблоны PRD: генерируйте задачи из документов требований к продукту',
			'tasks.notConfigured.features.dependencyTracking' => 'Отслеживание зависимостей: понимайте связи задач и порядок выполнения',
			'tasks.notConfigured.features.progressVisualization' => 'Визуализация прогресса: канбан-доски и детальная аналитика задач',
			'tasks.notConfigured.features.cliIntegration' => 'Интеграция с CLI: используйте команды taskmaster для продвинутых рабочих процессов',
			'tasks.notConfigured.initializeButton' => 'Инициализировать TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => 'Сначала создайте PRD',
			'tasks.gettingStarted.title' => 'Начало работы с TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster инициализирован! Вот что делать дальше:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Создайте документ требований к продукту (PRD)',
			'tasks.gettingStarted.steps.createPRD.description' => 'Обсудите идею вашего проекта и создайте PRD, описывающий то, что вы хотите построить.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'Добавить PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'Существующие PRD:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Генерация задач из PRD',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Когда у вас есть PRD, попросите вашего AI-ассистента разобрать его, и TaskMaster автоматически разобьет его на управляемые задачи с деталями реализации.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Анализ и расширение задач',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Попросите вашего AI-ассистента проанализировать сложность задач и расширить их в детальные подзадачи для упрощения реализации.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Начните разработку',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Попросите вашего AI-ассистента начать работу над задачами, обновлять их статус и добавлять новые задачи по мере развития вашего проекта.',
			'tasks.gettingStarted.tip' => '💡 Совет: начните с PRD, чтобы получить максимум от AI-генерации задач TaskMaster',
			'tasks.setupModal.title' => 'Настройка TaskMaster',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'Интерактивный CLI для ${projectName}',
			'tasks.setupModal.willStart' => 'Инициализация TaskMaster начнется автоматически',
			'tasks.setupModal.completed' => 'Настройка TaskMaster завершена! Теперь вы можете закрыть это окно.',
			'tasks.setupModal.closeButton' => 'Закрыть',
			'tasks.setupModal.closeContinueButton' => 'Закрыть и продолжить',
			'tasks.setupModal.closeTitle' => 'Закрыть',
			'tasks.setupModal.description' => 'Создаёт папку .taskmaster в этом проекте. Внешние инструменты и ключи API не требуются — задачи хранятся локально.',
			'tasks.setupModal.initializeButton' => 'Инициализировать',
			'tasks.setupModal.initializing' => 'Инициализация...',
			'tasks.helpGuide.title' => 'Начало работы с TaskMaster',
			'tasks.helpGuide.subtitle' => 'Ваш гид по продуктивному управлению задачами',
			'tasks.helpGuide.examples.parsePRD' => '💬 Пример:\n"Я только что инициализировал новый проект с Claude Task Master. У меня есть PRD в .taskmaster/docs/prd.txt. Можете помочь мне разобрать его и настроить начальные задачи?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Пример:\n"Задача 5 кажется сложной. Можете разбить её на подзадачи?"',
			'tasks.helpGuide.examples.addTask' => '💬 Пример:\n"Пожалуйста, добавьте новую задачу для реализации загрузки изображений профиля пользователя с использованием Cloudinary, изучите лучший подход."',
			'tasks.helpGuide.moreExamples' => 'Посмотреть больше примеров и шаблонов использования →',
			'tasks.helpGuide.proTips.title' => '💡 Профессиональные советы',
			'tasks.helpGuide.proTips.search' => 'Используйте строку поиска для быстрого поиска конкретных задач',
			'tasks.helpGuide.proTips.views' => 'Переключайтесь между представлениями Канбан, Список и Сетка, используя переключатели представлений',
			'tasks.helpGuide.proTips.filters' => 'Используйте фильтры для фокусировки на конкретных статусах или приоритетах задач',
			'tasks.helpGuide.proTips.details' => 'Нажмите на любую задачу для просмотра детальной информации и управления подзадачами',
			'tasks.helpGuide.learnMore.title' => '📚 Узнать больше',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI - это продвинутая система управления задачами, созданная для разработчиков. Получите документацию, примеры и внесите вклад в проект.',
			'tasks.helpGuide.learnMore.githubButton' => 'Посмотреть на GitHub',
			'tasks.helpGuide.closeTitle' => 'Закрыть',
			'tasks.search.placeholder' => 'Поиск задач...',
			'tasks.filters.button' => 'Фильтры',
			'tasks.filters.status' => 'Статус',
			'tasks.filters.priority' => 'Приоритет',
			'tasks.filters.sortBy' => 'Сортировать по',
			'tasks.filters.allStatuses' => 'Все статусы',
			'tasks.filters.allPriorities' => 'Все приоритеты',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => 'Показано ${filtered} из ${total} задач',
			'tasks.filters.clearFilters' => 'Очистить фильтры',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Статус',
			'tasks.sort.priority' => 'Приоритет',
			'tasks.sort.idAsc' => 'ID (по возрастанию)',
			'tasks.sort.idDesc' => 'ID (по убыванию)',
			'tasks.sort.titleAsc' => 'Название (А-Я)',
			'tasks.sort.titleDesc' => 'Название (Я-А)',
			'tasks.sort.statusAsc' => 'Статус (сначала ожидающие)',
			'tasks.sort.statusDesc' => 'Статус (сначала выполненные)',
			'tasks.sort.priorityAsc' => 'Приоритет (сначала высокий)',
			'tasks.sort.priorityDesc' => 'Приоритет (сначала низкий)',
			'tasks.views.kanban' => 'Представление Канбан',
			'tasks.views.list' => 'Представление списком',
			'tasks.views.grid' => 'Представление сеткой',
			'tasks.kanban.pending' => '📋 К выполнению',
			'tasks.kanban.inProgress' => '🚀 В процессе',
			'tasks.kanban.review' => '👀 Ревью',
			'tasks.kanban.done' => '✅ Выполнено',
			'tasks.kanban.blocked' => '🚫 Заблокировано',
			'tasks.kanban.deferred' => '⏳ Отложено',
			'tasks.kanban.cancelled' => '❌ Отменено',
			'tasks.kanban.noTasksYet' => 'Задач пока нет',
			'tasks.kanban.tasksWillAppear' => 'Задачи появятся здесь',
			'tasks.kanban.moveTasksHere' => 'Перемещайте задачи сюда при начале работы',
			'tasks.kanban.completedTasksHere' => 'Завершенные задачи появляются здесь',
			'tasks.kanban.statusTasksHere' => 'Задачи с этим статусом появятся здесь',
			'tasks.buttons.help' => 'Руководство по началу работы с TaskMaster',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => 'Добавить PRD',
			'tasks.buttons.addTask' => 'Добавить задачу',
			'tasks.buttons.createNewPRD' => 'Создать новый PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => 'Доступно ${count} PRD',
			'tasks.prd.modified' => ({required Object date}) => 'Изменено: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.newFile' => 'новый файл',
			'tasks.prd.template' => 'Шаблон',
			'tasks.prd.parse' => 'Разобрать PRD',
			'tasks.prd.fileExistsTitle' => 'Файл уже существует',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'PRD с именем «${name}» уже существует. Перезаписать его?',
			'tasks.prd.fileNameHint' => 'имя файла (например, prd.txt)',
			'tasks.prd.saved' => 'PRD сохранён',
			'tasks.prd.tasksGenerated' => 'Задачи созданы из PRD',
			'tasks.statuses.pending' => 'Ожидание',
			'tasks.statuses.inProgress' => 'В процессе',
			'tasks.statuses.done' => 'Выполнено',
			'tasks.statuses.blocked' => 'Заблокировано',
			'tasks.statuses.deferred' => 'Отложено',
			'tasks.statuses.cancelled' => 'Отменено',
			'tasks.statuses.review' => 'Ревью',
			'tasks.priorities.high' => 'Высокий',
			'tasks.priorities.medium' => 'Средний',
			'tasks.priorities.low' => 'Низкий',
			'tasks.noMatchingTasks.title' => 'Нет задач, соответствующих вашим фильтрам',
			'tasks.noMatchingTasks.description' => 'Попробуйте изменить критерии поиска или фильтрации.',
			'tasks.board.title' => 'Доска агентов',
			'tasks.board.subtitle' => 'Переместите карточку в Готово — агент её подхватит. Нажмите на карточку, чтобы открыть её сессию.',
			'tasks.board.newCard' => 'Новая карточка',
			'tasks.board.addCard' => 'Добавить карточку',
			'tasks.board.refresh' => 'Обновить',
			'tasks.board.empty.title' => 'Пока нет карточек',
			'tasks.board.empty.description' => 'Добавьте карточку, опишите задачу, затем перетащите её в Готово, чтобы агент начал работу.',
			'tasks.board.columns.backlog' => 'Бэклог',
			'tasks.board.columns.ready' => 'Готово к запуску',
			'tasks.board.columns.working' => 'В работе',
			'tasks.board.columns.needsDecision' => 'Нужно ваше решение',
			'tasks.board.columns.done' => 'Выполнено',
			'tasks.board.columns.archived' => 'Архив',
			'tasks.board.card.running' => 'Выполняется',
			'tasks.board.card.abort' => 'Прервать',
			'tasks.board.card.delete' => 'Удалить',
			'tasks.board.card.openSession' => 'Открыть сессию',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.card.edit' => 'Изменить',
			'tasks.board.card.moveTo' => 'Переместить в',
			'tasks.board.dialog.createTitle' => 'Новая карточка',
			'tasks.board.dialog.editTitle' => 'Редактировать карточку',
			'tasks.board.dialog.titleLabel' => 'Заголовок',
			'tasks.board.dialog.titlePlaceholder' => 'Что должен сделать агент?',
			'tasks.board.dialog.descriptionLabel' => 'Описание',
			'tasks.board.dialog.descriptionPlaceholder' => 'Добавьте контекст, критерии приёмки, ссылки...',
			'tasks.board.dialog.cancel' => 'Отмена',
			'tasks.board.dialog.save' => 'Сохранить',
			'tasks.board.noProject' => 'Сначала добавьте проект, затем создавайте для него карточки.',
			'tasks.board.projectLabel' => 'Проект',
			'tasks.board.backToChat' => 'Назад к чату',
			'tasks.board.agent.provider' => 'Агент',
			'tasks.board.agent.anyProvider' => 'Любой агент',
			'tasks.board.agent.model' => 'Модель',
			'tasks.board.agent.defaultModel' => 'Модель по умолчанию',
			'tasks.board.agent.effort' => 'Рассуждение',
			'tasks.board.agent.defaultEffort' => 'По умолчанию',
			'tasks.board.agent.searchModel' => 'Поиск моделей…',
			'tasks.board.agent.noModels' => 'Нет подходящих моделей',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '«${cardTitle}» будет удалена безвозвратно.',
			'tasks.board.deleteConfirm.title' => 'Удалить карточку?',
			'tasks.board.project' => 'Проект',
			'tasks.board.assignee.label' => 'Исполнитель',
			'tasks.board.assignee.all' => 'Все исполнители',
			'tasks.board.assignee.unassigned' => 'Не назначено',
			'tasks.board.presence.online' => ({required Object count}) => 'В сети: ${count}',
			'tasks.board.activity.title' => 'Активность',
			'tasks.board.activity.empty' => 'Активности пока нет',
			'tasks.board.comments.label' => 'Комментарии',
			'tasks.board.comments.placeholder' => 'Напишите комментарий…',
			'tasks.board.comments.send' => 'Отправить',
			'tasks.board.comments.unknownAuthor' => 'Кто-то',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Зависит от: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Задача ${id}',
			'tasks.card.highPriority' => 'Высокий приоритет',
			'tasks.card.lowPriority' => 'Низкий приоритет',
			'tasks.card.mediumPriority' => 'Средний приоритет',
			'tasks.card.noPriority' => 'Приоритет не задан',
			'tasks.card.parentTask' => ({required Object id}) => 'Задача ${id}',
			'tasks.card.progressLabel' => 'Прогресс:',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => 'Выполнено ${completed} из ${total} подзадач',
			'tasks.card.runTask' => 'Запустить задачу',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Запустить задачу ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Статус: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'ID задачи: ${id}',
			'tasks.card.taskInProgress' => 'Задача выполняется',
			'tasks.createTask.cancel' => 'Отмена',
			'tasks.createTask.descriptionLabel' => 'Описание',
			'tasks.createTask.descriptionPlaceholder' => 'Дополнительные детали',
			'tasks.createTask.error' => 'Не удалось добавить задачу',
			'tasks.createTask.priorityLabel' => 'Приоритет',
			'tasks.createTask.submit' => 'Добавить задачу',
			'tasks.createTask.submitting' => 'Добавление...',
			'tasks.createTask.title' => 'Добавить задачу',
			'tasks.createTask.titleLabel' => 'Название',
			'tasks.createTask.titlePlaceholder' => 'Что нужно сделать?',
			'tasks.list.completedReopen' => 'Выполнена (нажмите, чтобы переоткрыть)',
			'tasks.list.inProgressComplete' => 'Выполняется (нажмите, чтобы завершить)',
			'tasks.list.markCompleted' => 'Отметить как выполненную',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Переключить статус задачи ${id}',
			'tasks.list.markDone' => 'Отметить как выполненную',
			'tasks.list.reopen' => 'Возобновить',
			'tasks.nextTask.allComplete' => 'Все задачи выполнены',
			'tasks.nextTask.feature1' => '- Управление задачами с ИИ: зависимости и подзадачи.',
			'tasks.nextTask.feature2' => '- Генерация задач из PRD для быстрого старта проекта.',
			'tasks.nextTask.feature3' => '- Kanban и список для повседневной работы.',
			'tasks.nextTask.hideDetails' => 'Скрыть детали',
			'tasks.nextTask.initialize' => 'Инициализировать',
			'tasks.nextTask.noPending' => 'Нет ожидающих задач',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI не настроен',
			'tasks.nextTask.review' => 'Проверить',
			'tasks.nextTask.startTask' => 'Начать задачу',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Задача ${id}',
			'tasks.nextTask.viewAll' => 'Все задачи',
			'tasks.nextTask.viewDetails' => 'Детали задачи',
			'tasks.nextTask.whatIs' => 'Что такое TaskMaster?',
			'tasks.taskDetail.cancelEdit' => 'Отменить редактирование',
			'tasks.taskDetail.close' => 'Закрыть',
			'tasks.taskDetail.copyTaskId' => 'Копировать ID задачи',
			'tasks.taskDetail.delete' => 'Удалить задачу',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '«${title}» будет безвозвратно удалена.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Удалить задачу?',
			'tasks.taskDetail.deleteFailed' => 'Не удалось удалить задачу',
			'tasks.taskDetail.dependencies' => 'Зависимости',
			'tasks.taskDetail.dependenciesPlaceholder' => 'напр. 1, 2, 3',
			'tasks.taskDetail.description' => 'Описание',
			'tasks.taskDetail.edit' => 'Редактировать задачу',
			'tasks.taskDetail.implDetails' => 'Детали реализации',
			'tasks.taskDetail.noDependencies' => 'Нет зависимостей',
			'tasks.taskDetail.noDescription' => 'Описание отсутствует',
			'tasks.taskDetail.priority' => 'Приоритет',
			'tasks.taskDetail.priorityNotSet' => 'Не задан',
			'tasks.taskDetail.save' => 'Сохранить',
			'tasks.taskDetail.status' => 'Статус',
			'tasks.taskDetail.statusFailed' => 'Не удалось обновить статус задачи',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Задача ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Задача ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Стратегия тестирования',
			'tasks.taskDetail.titleRequired' => 'Название обязательно',
			'tasks.taskDetail.updateFailed' => 'Не удалось обновить задачу',
			'tasks.taskDetail.notFound' => 'Задача не найдена',
			'tasks.taskDetail.subtasks' => 'Подзадачи',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'Задача #${id} будет удалена. Действие необратимо.',
			'tasks.taskDetail.idCopied' => 'ID задачи скопирован',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Задача ${id} переведена в статус «В процессе»',
			'tasks.taskmaster.noProjectHint' => 'Сначала добавьте проект, затем создайте для него задачи.',
			'tasks.taskmaster.sort.statusAz' => 'Статус (А–Я)',
			'tasks.taskmaster.sort.statusZa' => 'Статус (Я–А)',
			_ => null,
		} ?? switch (path) {
			'tasks.taskmaster.installedVersion' => ({required Object version}) => 'Установлено: ${version}',
			'tasks.taskmaster.initFailed' => 'Не удалось инициализировать TaskMaster',
			'tasks.taskmaster.prd.fileNameRequired' => 'Укажите имя файла для PRD.',
			'tasks.taskmaster.prd.contentRequired' => 'Добавьте содержимое перед сохранением.',
			'tasks.taskmaster.prd.overwrite' => 'Перезаписать',
			'tasks.taskmaster.prd.contentHint' => '# Документ требований к продукту…',
			'tasks.taskmaster.detail.dependenciesLabel' => 'Зависимости (ID через запятую)',
			'tasks.taskmaster.untitledTask' => 'Задача без названия',
			'knowledge.title' => 'Знания',
			'knowledge.tabs.dashboard' => 'Панель',
			'knowledge.tabs.memories' => 'Память',
			'knowledge.tabs.rules' => 'Правила',
			'knowledge.tabs.skills' => 'Навыки',
			'knowledge.tabs.personal' => 'Личное',
			'knowledge.tabs.graph' => 'Граф',
			'knowledge.common.add' => 'Добавить',
			'knowledge.common.save' => 'Сохранить',
			'knowledge.common.cancel' => 'Отмена',
			'knowledge.common.delete' => 'Удалить',
			'knowledge.common.edit' => 'Изменить',
			'knowledge.common.close' => 'Закрыть',
			'knowledge.common.restore' => 'Восстановить',
			'knowledge.common.refresh' => 'Обновить',
			'knowledge.common.allProjects' => 'Все проекты',
			'knowledge.common.global' => 'Глобально',
			'knowledge.actions.scan' => 'Сканировать файлы проекта',
			'knowledge.actions.export' => 'Экспорт JSON',
			'knowledge.actions.import' => 'Импорт JSON',
			'knowledge.actions.scanComplete' => 'Сканирование завершено',
			'knowledge.actions.importComplete' => 'Импорт завершён',
			'knowledge.actions.importFailed' => 'Не удалось импортировать',
			'knowledge.dialog.newEntity' => 'Новая запись',
			'knowledge.dialog.editEntity' => 'Изменить запись',
			'knowledge.dialog.deleteTitle' => 'Удалить',
			'knowledge.dialog.deleteMessage' => 'Удалить эту запись? Действие необратимо (история сохраняется).',
			'knowledge.dialog.pickIcon' => 'Выбрать значок',
			'knowledge.dialog.removeIcon' => 'Удалить значок',
			'knowledge.dialog.iconTooLarge' => 'Значок слишком большой (макс. 40 КБ).',
			'knowledge.dialog.importTitle' => 'Импортировать знания',
			'knowledge.dialog.importHint' => 'Вставьте сюда экспортированный JSON',
			'knowledge.dialog.exportTitle' => 'Экспортировать знания',
			'knowledge.dialog.import' => 'Импорт',
			'knowledge.fields.key' => 'Ключ',
			'knowledge.fields.title' => 'Заголовок',
			'knowledge.fields.name' => 'Имя',
			'knowledge.fields.description' => 'Описание',
			'knowledge.fields.category' => 'Категория',
			'knowledge.fields.content' => 'Содержимое',
			'knowledge.fields.priority' => 'Приоритет',
			'knowledge.fields.tags' => 'Теги',
			'knowledge.fields.enabled' => 'Включено',
			'knowledge.fields.projectScope' => 'Область проекта',
			'knowledge.fields.tagsHint' => 'через запятую',
			'knowledge.dashboard.memories' => 'Память',
			'knowledge.dashboard.rules' => 'Правила',
			'knowledge.dashboard.skills' => 'Навыки',
			'knowledge.dashboard.personal' => 'Личное',
			'knowledge.dashboard.connections' => 'Связи',
			'knowledge.dashboard.recent' => 'Последние записи',
			'knowledge.dashboard.noMemories' => 'Записей нет. Добавьте в разделе Память.',
			'knowledge.empty.memories' => 'Записей нет.',
			'knowledge.empty.rules' => 'Правил нет.',
			'knowledge.empty.skills' => 'Навыков нет.',
			'knowledge.empty.personal' => 'Личных данных нет.',
			'knowledge.empty.graph' => 'Нет сущностей для графа.',
			'knowledge.history.title' => 'История',
			'knowledge.history.none' => 'Истории нет.',
			'knowledge.history.untitled' => '(без названия)',
			'knowledge.priorities.critical' => 'Критический',
			'knowledge.priorities.high' => 'Высокий',
			'knowledge.priorities.normal' => 'Обычный',
			'knowledge.priorities.low' => 'Низкий',
			'knowledge.search.title' => 'Поиск по знаниям',
			'knowledge.search.hint' => 'Поиск по памяти, правилам, навыкам…',
			'knowledge.search.noResults' => 'Ничего не найдено.',
			'knowledge.links.title' => 'Связать сущности',
			'knowledge.links.source' => 'Источник',
			'knowledge.links.target' => 'Цель',
			'knowledge.links.relationship' => 'Тип связи',
			'knowledge.links.add' => 'Создать связь',
			'knowledge.tags.all' => 'Все теги',
			'knowledge.tags.manage' => 'Управление тегами',
			'knowledge.tags.none' => 'Тегов нет.',
			'knowledge.graph.truncated' => 'обрезано',
			'knowledge.importAll.title' => 'Импортировать всё в DDAgent',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Просканировано проектов: ${count}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Найдено навыков агентов: ${found} (новых: ${newSkills})',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Правила: ${total} · группы дубликатов: ${duplicates}',
			'knowledge.importAll.mergeDuplicates' => 'Объединить дублирующиеся записи',
			'knowledge.importAll.mergeDuplicatesHint' => 'Объединяет дублирующиеся строки в DDAgent (не файлы)',
			'knowledge.importAll.action' => 'Импортировать всё',
			'knowledge.importAll.readOnlyNotice' => 'Для ваших агентов только чтение: импорт выполняется в собственную базу данных DDAgent и НЕ изменяет и не удаляет файлы или настройки CLI. Параметры ниже меняют только данные DDAgent.',
			'knowledge.importAll.dryRunNote' => 'Пробный запуск — пока ничего не записано.',
			'knowledge.importAll.importedNote' => 'Импортировано.',
			'knowledge.importAll.result' => ({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'Импортировано — правила: ${rules}, новые навыки: ${newSkills}, удалено: ${removed}, повышено: ${promoted}',
			'knowledge.importAll.description' => 'Просканировать все проекты и импортировать навыки ваших агентов в базу знаний. Для агентов только чтение — в CLI ничего не меняется.',
			'knowledge.migrate.title' => 'Мигрировать существующие правила',
			'knowledge.migrate.scanned' => ({required Object count}) => 'Просканировано проектов: ${count}.',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Правила: всего ${total}, критических: ${critical}.',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Группы дубликатов по проектам: ${count}',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Удалено: ${removed}, повышено: ${promoted}',
			'knowledge.migrate.mergeDuplicates' => 'Объединить дубликаты',
			'knowledge.migrate.dryRunNote' => 'Пробный запуск — пока ничего не изменено.',
			'knowledge.migrate.applied' => 'Применено.',
			'knowledge.importSkills.title' => 'Импортировать навыки агентов',
			'knowledge.importSkills.found' => ({required Object count}) => 'Найдено навыков у ваших агентов: ${count}.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Новых: ${imported} · пропущено: ${skipped}',
			'knowledge.importSkills.dryRunHint' => 'Импортирует глобальные/стандартные навыки ваших агентов (пользовательские, системные, из плагинов) как навыки базы знаний. Пробный запуск — пока ничего не импортировано.',
			'knowledge.importSkills.importedNote' => 'Импортировано в базу знаний.',
			'knowledge.critical.make' => 'Сделать критическим',
			'knowledge.critical.makeAll' => 'Сделать все правила критическими',
			'knowledge.critical.makeAllHint' => 'Добавляет их в бюджет внедряемого контекста',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} токенов',
			'knowledge.contextBudget.title' => 'Контекст правил (передаётся всегда)',
			'knowledge.contextBudget.selectProject' => 'Выберите проект, чтобы увидеть размер его критического контекста.',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Память: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Правило: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Навык: ${name}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Личное: ${title}',
			'knowledge.errors.importFailed' => ({required Object error}) => 'Импорт не удался: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Миграция не удалась: ${error}',
			'knowledge.entityTypes.memory' => 'Воспоминание',
			'knowledge.entityTypes.rule' => 'Правило',
			'knowledge.entityTypes.skill' => 'Навык',
			'knowledge.entityTypes.personal' => 'Личное',
			'knowledge.entityTypes.project' => 'Проект',
			'knowledge.entityTypes.tag' => 'Тег',
			'browser.dialogTitle' => 'Браузер агента',
			'browser.viewError' => 'Ошибка представления браузера',
			'browser.web' => 'Веб',
			'collab.team' => 'Команда',
			'collab.invite' => 'Пригласить',
			'collab.inviteTeammate' => 'Пригласить коллегу',
			'collab.shareTokenHint' => 'Поделитесь этим токеном приглашения — он показывается один раз и действует 72 ч:',
			'collab.createInvite' => 'Создать приглашение',
			'collab.copyToken' => 'Копировать токен',
			'collab.roles.member' => 'Участник',
			'collab.roles.viewer' => 'Наблюдатель',
			'collab.viewing.session' => 'сессия',
			'collab.viewing.card' => 'карточка',
			'collab.viewing.board' => 'доска',
			'fileTree.uploadTo' => 'Загрузить в',
			'fileTree.uploadHere' => 'Загрузить сюда',
			'fileTree.browseServerFilesystem' => 'Обзор файловой системы сервера',
			'fileTree.noFiles' => 'Нет файлов',
			'fileTree.copyContents' => 'Копировать содержимое',
			'fileTree.chooseFolder' => 'Выбрать папку',
			'fileTree.search.hint' => 'Фильтр по именам / Enter — поиск по содержимому',
			'fileTree.search.prompt' => 'Введите запрос и нажмите Enter',
			'fileTree.search.noMatches' => 'Совпадений нет',
			'fileTree.search.resultsTruncated' => 'Результаты усечены',
			'fileTree.titles.rename' => ({required Object name}) => 'Переименовать ${name}',
			'fileTree.titles.delete' => ({required Object name}) => 'Удалить ${name}',
			'fileTree.titles.download' => ({required Object name}) => 'Скачать ${name}',
			'fileTree.uploadedCount' => ({required Object count}) => 'Загружено файлов: ${count}',
			'fileTree.newName' => 'Новое имя',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Проект не зарегистрирован: ${path}',
			'fileTree.showGitignoredFiles' => 'Показать игнорируемые файлы',
			'fileTree.hideGitignoredFiles' => 'Скрыть игнорируемые файлы',
			'fileTree.downloadUnsupportedOnWeb' => 'Скачивание не поддерживается в веб-версии',
			'fileTree.saveToPath' => 'Сохранить по пути',
			'fileTree.savedTo' => ({required Object path}) => 'Сохранено в ${path}',
			'fileTree.relative.now' => 'сейчас',
			'fileTree.relative.minutes' => ({required Object n}) => '${n} мин',
			'fileTree.relative.hours' => ({required Object n}) => '${n} ч',
			'fileTree.relative.days' => ({required Object n}) => '${n} д',
			'fileTree.projectRoot' => '(корень проекта)',
			'fileTree.uploadLimitCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'За раз можно загрузить не более ${count} файла.', few: 'За раз можно загрузить не более ${count} файлов.', many: 'За раз можно загрузить не более ${count} файлов.', other: 'За раз можно загрузить не более ${count} файла.', ), 
			'fileTree.fileTooLarge' => ({required Object name}) => '${name} больше 200 МБ.',
			'fileTree.deleteFolderConfirm' => ({required Object path}) => 'Удалить папку «${path}»? Это действие нельзя отменить.',
			'fileTree.deleteFileConfirm' => ({required Object path}) => 'Удалить файл «${path}»? Это действие нельзя отменить.',
			'git.checkpoints.title' => 'Чекпоинты',
			'git.checkpoints.restoreTitle' => 'Восстановить чекпоинт',
			'git.checkpoints.restoreMessage' => 'Сбросить рабочее дерево к этому чекпоинту? Текущие изменения будут заменены.',
			'git.checkpoints.restored' => 'Чекпоинт восстановлен',
			'git.checkpoints.labelHint' => 'Метка чекпоинта (необязательно)',
			'git.checkpoints.empty' => 'Чекпоинтов пока нет',
			'git.checkpoints.create' => 'Новый',
			'git.stagedChanges' => 'Подготовленные изменения',
			'git.statusStaged' => 'Подготовлено',
			'git.switchBranch' => 'Переключить ветку',
			'git.unifiedDiff' => 'Единый',
			'git.splitDiff' => 'Рядом',
			'git.noDiff' => 'Нет доступного diff',
			'git.largeDiff' => 'Большой diff: отрисовка ограничена, чтобы вкладка оставалась отзывчивой.',
			'git.loadDiffFailed' => ({required Object error}) => 'Не удалось загрузить diff: ${error}',
			'git.hunkStage' => '+ Фрагмент',
			'git.hunkUnstage' => '− Фрагмент',
			'git.stageHunk' => 'Подготовить фрагмент',
			'git.unstageHunk' => 'Отменить подготовку фрагмента',
			'git.deleteFile' => 'Удалить файл',
			'git.commitMessage' => 'Сообщение коммита',
			'git.aiButton' => '✦ ИИ',
			'git.commitCreated' => 'Коммит создан',
			'git.noBranch' => 'нет ветки',
			'git.selectProject' => 'Выберите проект',
			'git.branchSections.local' => 'ЛОКАЛЬНЫЕ',
			'git.branchSections.remote' => 'УДАЛЁННЫЕ',
			'kanban.card.untitled' => 'Без названия',
			'kanban.comments.empty' => 'Комментариев пока нет',
			'kanban.comments.add' => 'Добавить комментарий',
			'kanban.dialog.saving' => 'Сохранение…',
			'kanban.details.title' => 'Детали карточки',
			'kanban.details.status' => ({required Object status}) => 'Статус: ${status}',
			'kanban.empty.noProject' => 'Проект не выбран',
			'kanban.saveFailed' => 'Не удалось сохранить карточку',
			'kanban.time.now' => 'сейчас',
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '1 минуту назад', other: '${count} мин. назад', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '1 час назад', other: '${count} ч. назад', ), 
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '1 день назад', other: '${count} дн. назад', ), 
			'mcp.install.title' => 'Установить MCP сервер DDAgent',
			'mcp.install.description' => 'Позволяет выбранным агентам использовать базу знаний и инструменты DDAgent через MCP.',
			'mcp.install.cardDescription' => 'Дайте своим агентам базу знаний и инструменты DDAgent через MCP — выберите агентов или установите для всех.',
			'mcp.install.installSelected' => 'Установить выбранным',
			'mcp.install.installForAll' => 'Установить для всех',
			'mcp.install.button' => 'Установить',
			'mcp.install.failed' => ({required Object error}) => 'Установка не удалась: ${error}',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Установлено для ${count} агента.', other: 'Установлено для ${count} агентов.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Установлено для ${count}; не удалось: ${failed}',
			'mcp.install.errorFallback' => 'ошибка',
			'mcp.servers.loading' => 'Загрузка MCP серверов…',
			'mcp.servers.refreshingScopes' => 'Обновление областей проектов…',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Серверы Model Context Protocol предоставляют ${provider} дополнительные инструменты и источники данных',
			'mcp.servers.addGlobalTitle' => 'Добавить глобальный MCP сервер',
			'mcp.servers.addGlobalDescription' => 'Добавляет этот MCP сервер всем провайдерам: Claude, Cursor, Codex, OpenCode и Devin. Поддерживаются только транспорты stdio и HTTP, поскольку одна и та же конфигурация должна работать у всех провайдеров.',
			'mcp.servers.addGlobalMenuDescription' => '«Добавить глобальный MCP сервер» записывает один общий stdio- или HTTP-сервер в Claude, Cursor, Codex, OpenCode и Devin.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => 'Добавить MCP сервер для ${provider}',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => '«Добавить MCP сервер для ${provider}» изменяет только ${provider}.',
			'mcp.servers.config.cwd' => 'Рабочий каталог',
			'mcp.servers.config.envVars' => 'Переменные окружения',
			'mcp.servers.selectProjectRequired' => 'Выберите проект для MCP-серверов с областью проекта',
			'mcp.servers.globalScopeUnsupported' => 'Добавление MCP-сервера для всех провайдеров поддерживает только область пользователя или проекта.',
			'mcp.servers.globalAddFailed' => ({required Object details}) => 'Не удалось добавить MCP-сервер ко всем провайдерам. ${details}',
			'mcp.servers.scopeProject' => 'проект',
			'mcp.team.title' => 'Командные конфигурации MCP',
			'mcp.team.description' => 'Делитесь конфигурациями MCP серверов с командой. Все синхронизируются автоматически.',
			'mcp.team.cta' => 'Доступно с DDAgent Pro',
			'mcp.tokens.scopeWrite' => 'Запись',
			'mcp.tokens.scopeRead' => 'Чтение',
			'mcp.form.submitTo' => ({required Object provider}) => 'Добавить сервер в ${provider}',
			'mcp.form.scope.userAllProviders' => 'Пользователь (все провайдеры)',
			'mcp.form.scope.claudeLocal' => 'Claude (локально)',
			'mcp.form.scope.projectAllProviders' => 'Проект (все провайдеры)',
			'mcp.form.scope.description.userGlobal' => 'Записывается в пользовательскую конфигурацию каждого провайдера и доступно во всех проектах на этой машине',
			'mcp.form.scope.description.user' => 'Доступно во всех проектах на вашей машине',
			'mcp.form.scope.description.local' => 'Хранится в пользовательских настройках Claude для выбранного проекта',
			'mcp.form.scope.description.projectGlobal' => 'Записывается в рабочую область выбранного проекта для всех провайдеров',
			'mcp.form.scope.description.project' => 'Хранится в рабочей области выбранного проекта',
			'mcp.form.fields.workingDirectory' => 'Рабочий каталог',
			'mcp.form.fields.envVarNames' => 'Имена переменных окружения',
			'mcp.form.fields.bearerTokenEnvVar' => 'Переменная окружения с Bearer-токеном',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => '«Добавить MCP сервер» поддерживает только stdio и http у всех провайдеров, а не ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} не поддерживает MCP серверы типа ${type}',
			'mcp.form.validation.jsonMustBeObject' => 'Конфигурация JSON должна быть объектом',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.registrationRejected' => 'Сервер отклонил регистрацию',
			'notifications.errors.noResponse' => 'Нет ответа от сервера',
			'notifications.androidChannel.name' => 'Оповещения DDAgent',
			'notifications.androidChannel.description' => 'Уведомления о запусках агентов, подтверждениях и ошибках',
			'onboarding.gitHint' => 'Используется для коммитов, создаваемых сессиями DDAgent.',
			'onboarding.completeSetup' => 'Завершить настройку',
			'onboarding.errors.nameAndEmailRequired' => 'Требуются и имя, и эл. почта для git.',
			'onboarding.errors.invalidEmail' => 'Введите корректный адрес электронной почты.',
			'onboarding.agents.title' => 'Подключите своих ИИ-агентов',
			'onboarding.agents.description' => 'Войдите в одного или нескольких ИИ-ассистентов программирования. Все они необязательны.',
			'onboarding.agents.laterHint' => 'Вы можете настроить их позже в Настройках.',
			'onboarding.mcp.title' => 'Подключить агентов к DDAgent',
			'onboarding.mcp.description' => 'Установите MCP сервер DDAgent, чтобы ваши агенты могли использовать базу знаний и инструменты DDAgent. Выберите агентов или установите для всех.',
			'onboarding.mcp.installSelected' => 'Установить выбранным',
			'onboarding.mcp.installForAll' => 'Установить для всех',
			'onboarding.mcp.laterHint' => 'Необязательно — вы также можете установить это позже в Настройках → MCP.',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Установлено для ${count} агента.', other: 'Установлено для ${count} агентов.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Установлено для ${installedCount}; не удалось: ${failed}',
			'projects.cloneRepository' => 'Клонировать репозиторий',
			'projects.repositoryCloned' => 'Репозиторий клонирован',
			'projects.clone' => 'Клонировать',
			'projects.cloneFinished' => 'Клонирование завершено. Обновление списка проектов…',
			'projects.cloneFailed' => 'Не удалось клонировать',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.destinationPath' => 'Путь назначения',
			'projects.destinationPathRequired' => 'Укажите путь назначения',
			'projects.repositoryUrlRequired' => 'Укажите URL репозитория',
			'projects.githubTokenOptional' => 'Токен GitHub (необязательно)',
			'projects.archive' => 'Архивировать',
			'projects.restore' => 'Восстановить',
			'projects.deletePermanently' => 'Удалить навсегда',
			'projects.deleteProjectTitle' => 'Удалить проект?',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Безвозвратно удаляет «${name}» вместе со всеми сессиями и сохранённой историей (очистка JSONL). Действие необратимо.',
			'projects.archivedSection' => ({required Object count}) => 'Архивные (${count})',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} сессия', other: '${count} сессий', ), 
			'projects.newer' => 'Новее',
			'projects.older' => 'Старее',
			'projects.projectArchived' => 'Проект архивирован',
			'projects.projectRestored' => 'Проект восстановлен',
			'projects.projectRenamed' => 'Проект переименован',
			'projects.projectDeleted' => 'Проект удалён',
			'projects.failedToLoadTokens' => 'Не удалось загрузить токены GitHub',
			'projects.displayNameOptional' => 'Отображаемое имя (необязательно)',
			'projects.usingStoredToken' => ({required Object name}) => 'Используется сохранённый токен: ${name}',
			'projects.unknown' => 'Неизвестно',
			'projects.project' => 'Проект',
			'quota.section.config' => 'Конфигурация',
			'quota.overview.tokensAndCost' => 'Токены и стоимость',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.config.pollerTitle' => 'Опрос и оповещения',
			'quota.config.accountRouting' => 'Маршрутизация аккаунтов',
			'quota.config.save' => 'Сохранить конфигурацию',
			'quota.chart.show' => 'Показать',
			'quota.chart.hide' => 'Скрыть',
			'quota.chart.noData' => 'Недостаточно данных для тренда.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} токенов · ${cost}',
			'quota.duration.minutes' => ({required Object minutes}) => '${minutes} мин',
			'quota.duration.hoursMinutes' => ({required Object hours, required Object minutes}) => '${hours} ч ${minutes} мин',
			'quota.duration.daysHours' => ({required Object days, required Object hours}) => '${days} д ${hours} ч',
			'quota.duration.now' => 'сейчас',
			'scheduler.newLabel' => 'Новый',
			'scheduler.runs' => 'Запуски',
			'scheduler.editTitle' => 'Редактировать расписание',
			'scheduler.deleteTitle' => 'Удалить расписание?',
			'scheduler.deleteMessage' => ({required Object id}) => 'Это удалит повторяющуюся задачу ${id}. Существующие сессии сохранятся.',
			'scheduler.checking' => 'Проверка…',
			'scheduler.nextIn' => ({required Object time}) => 'через ${time}',
			'scheduler.worktree' => 'worktree',
			'scheduler.session' => ({required Object id}) => 'сессия ${id}',
			'scheduler.cronHint' => 'Cron (мин час день месяц день недели) — напр. 0 9 * * *',
			'scheduler.promptHint' => 'Запрос для агента',
			'scheduler.runStatus.fired' => 'запущен',
			'scheduler.runStatus.skipped' => 'пропущен',
			'scheduler.runStatus.failed' => 'ошибка',
			'scheduler.runStatus.completed' => 'завершён',
			'scheduler.cronErrors.fieldCount' => ({required Object got}) => 'Ожидалось 5 полей, получено ${got}',
			'scheduler.cronErrors.fieldError' => ({required Object index, required Object error}) => 'Поле ${index}: ${error}',
			'scheduler.cronErrors.empty' => 'пусто',
			'scheduler.cronErrors.invalidPart' => ({required Object part}) => 'недопустимо: «${part}»',
			'scheduler.cronErrors.invalidValue' => ({required Object value}) => 'недопустимое значение «${value}»',
			'serverConnect.subtitle' => 'Подключитесь к вашему серверу DDAgent',
			'serverConnect.enterUrl' => 'Введите URL сервера',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Не удалось подключиться (${error})',
			'serverConnect.connect' => 'Подключить',
			'serverConnect.connecting' => 'Подключение…',
			'serverConnect.changeServer' => 'Сменить сервер',
			'serverConnect.local.title' => 'Это устройство',
			'serverConnect.local.subtitle' => 'Запустить сервер DDAgent на этой машине',
			'serverConnect.local.install' => 'Установить локальный сервер',
			'serverConnect.local.start' => 'Запустить локальный сервер',
			'serverConnect.local.stop' => 'Остановить',
			'serverConnect.local.starting' => 'Запуск локального сервера…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Загрузка сервера… ${percent}%',
			'serverConnect.local.installing' => 'Установка…',
			'serverConnect.local.running' => ({required Object url}) => 'Запущен по адресу ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Установлен (v${version})',
			'serverConnect.local.connect' => 'Использовать этот сервер',
			'serverConnect.local.error' => ({required Object error}) => 'Ошибка локального сервера: ${error}',
			'serverConnect.local.or' => 'или подключитесь к удалённому серверу',
			'serverConnect.local.errors.releaseTagUnresolved' => 'Не удалось определить тег последнего релиза DDAgent.',
			'serverConnect.local.errors.unsupportedPlatform' => 'Локальный сервер не поддерживается на этой платформе.',
			'serverConnect.local.errors.unsupportedPlatformDetail' => ({required Object platform}) => 'Локальный сервер не поддерживается на этой платформе (${platform}).',
			'serverConnect.local.errors.nodeExtractionFailed' => ({required Object path}) => 'Распаковка Node.js не создала ${path}',
			'serverConnect.local.errors.downloadFailed' => ({required Object error}) => 'Не удалось скачать сервер: ${error}',
			'serverConnect.local.errors.installFailed' => ({required Object error}) => 'Не удалось установить сервер: ${error}',
			'serverConnect.local.errors.bundleNotInstalled' => 'Пакет сервера не установлен.',
			'serverConnect.local.errors.spawnFailed' => ({required Object error}) => 'Не удалось запустить локальный сервер: ${error}',
			'serverConnect.local.errors.portInUse' => ({required Object port}) => 'Порт ${port} уже используется другим приложением.',
			'serverConnect.local.errors.exitedDuringStartup' => 'Локальный сервер завершил работу во время запуска.',
			'serverConnect.local.errors.exitedDuringStartupWithOutput' => ({required Object output}) => 'Локальный сервер завершил работу во время запуска: ${output}',
			'serverConnect.local.errors.startTimeout' => 'Истекло время ожидания запуска локального сервера.',
			'serverConnect.local.errors.tarFailed' => ({required Object command, required Object code, required Object output}) => '${command} завершилась с ошибкой (код ${code}): ${output}',
			'serverConnect.httpStatus' => ({required Object code}) => 'HTTP ${code}',
			'serverConnect.networkError' => 'Ошибка сети',
			'sessions.noSessions' => 'Нет сессий',
			'sessions.noRecentSessions' => 'Нет недавних сессий',
			'sessions.archivedSessions' => 'Архивные сессии',
			'sessions.rename' => 'Переименовать',
			'sessions.archive' => 'Архивировать',
			'sessions.compareWith' => 'Сравнить с…',
			'sessions.projectPath' => 'Путь к проекту',
			'sessions.newSessionProvider' => 'Новая сессия — провайдер',
			'sessions.autoOrchestrator' => 'Авто (оркестратор)',
			'sessions.createFailed' => ({required Object error}) => 'Не удалось создать сессию: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Удаляет «${name}» и её транскрипт. Действие необратимо.',
			'sessions.toasts.archived' => 'Сессия архивирована',
			'sessions.toasts.restored' => 'Сессия восстановлена',
			'sessions.toasts.deleted' => 'Сессия удалена',
			'sessions.toasts.renamed' => 'Сессия переименована',
			'sessions.toasts.pinned' => 'Сессия закреплена',
			'sessions.toasts.unpinned' => 'Сессия откреплена',
			'sessions.toasts.workspaceChanged' => 'Рабочая область изменена',
			'sessions.age.lessThanMinute' => '<1 мин.',
			'sessions.age.minutes' => ({required Object count}) => '${count} мин.',
			'sessions.age.hours' => ({required Object hours}) => '${hours} ч.',
			'sessions.age.days' => ({required Object days}) => '${days} дн.',
			'sessions.activity.subagentRunning' => 'Выполняется субагент',
			'sessions.activity.readingFile' => ({required Object file}) => 'Чтение ${file}',
			'sessions.activity.runningTool' => ({required Object name}) => 'Выполнение ${name}',
			'sessions.activity.editingFile' => ({required Object file}) => 'Редактирование ${file}',
			'sessions.activity.editingFileGeneric' => 'Редактирование файла',
			'sessions.activity.runningShellCommand' => 'Выполнение команды оболочки',
			'sessions.activity.runningCommand' => ({required Object command}) => 'Выполнение `${command}`',
			'sessions.activity.committingChanges' => 'Фиксация изменений',
			'sessions.activity.pushingBranch' => 'Отправка ветки',
			'sessions.activity.fetchingUrl' => ({required Object url}) => 'Получение ${url}',
			'sessions.activity.searching' => ({required Object query}) => 'Поиск «${query}»',
			'sessions.autoMini' => 'Авто (мини)',
			'sharedContext.title' => 'Общие заметки',
			'skills.moveSkill' => ({required Object name}) => 'Переместить ${name}',
			'skills.deleteSkill' => ({required Object name}) => 'Удалить ${name}',
			'skills.projectLabel' => 'Проект',
			'skills.addDialog.title' => ({required Object provider}) => 'Добавить навык ${provider}',
			'skills.addDialog.chooseFileTitle' => 'Выбрать SKILL.md',
			'skills.addDialog.chooseFolderTitle' => 'Выберите папку навыка',
			'skills.addDialog.uploadHint' => 'Загрузите файл SKILL.md или папку навыка целиком.',
			'skills.addDialog.pickTitle' => 'Выберите папку навыка или SKILL.md',
			'skills.addDialog.pickHint' => 'Папки могут содержать скрипты, справочные материалы и ресурсы.',
			'skills.addDialog.chooseFiles' => 'Выбрать файлы',
			'skills.addDialog.chooseFolder' => 'Выбрать папку',
			'skills.addDialog.readyToInstall' => 'Готово к установке',
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Файл Markdown · ${size}',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} файл · ${size}', other: '${count} файлов · ${size}', ), 
			'skills.addDialog.removeQueued' => ({required Object name}) => 'Удалить ${name}',
			'skills.addDialog.whereWillThisInstall' => 'Куда это установится?',
			'skills.addDialog.hideInstallLocation' => 'Скрыть место установки',
			'skills.addDialog.folderUploadsNote' => 'При загрузке папки сохраняется её имя; для отдельных файлов используется `name` из `SKILL.md`.',
			'skills.addDialog.installSkill' => 'Установить навык',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Установить ${count} навык', other: 'Установить ${count} навыков', ), 
			'skills.moveDialog.toProjectHint' => 'Выберите проект, которому будет принадлежать этот навык. Он будет перемещён из глобальной папки навыков провайдера.',
			'skills.moveDialog.toGlobalHint' => 'Переместите этот навык в глобальную папку навыков, чтобы его могли использовать все проекты.',
			'skills.moveDialog.moveToProject' => 'Переместить в проект',
			'skills.moveDialog.moveToGlobal' => 'Переместить в глобальные',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Управляйте навыками ${provider} из локальных файлов, папок целиком и мест, зависящих от проекта.',
			'skills.screen.searchHint' => 'Поиск навыков…',
			'skills.screen.clearSearch' => 'Очистить поиск навыков',
			'skills.screen.addSkill' => 'Добавить навык',
			'skills.screen.scanningProjectSkills' => 'Сканирование навыков проекта…',
			'skills.screen.savedSuccessfully' => 'Навыки успешно сохранены.',
			'skills.screen.loadingSkills' => ({required Object provider}) => 'Загрузка навыков ${provider}…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: '${count} НАВЫК', other: '${count} НАВЫКОВ', ), 
			'skills.screen.deleteTitle' => ({required Object name}) => 'Удалить ${name}?',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Это удалит папку ${directory} из управляемой папки навыков ${provider}. Действие необратимо.',
			'skills.screen.noDescription' => 'Описание не указано во front matter навыка.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Плагин: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Проект: ${name}',
			'skills.screen.sourceLabel' => 'ИСТОЧНИК',
			'skills.empty.noProjects' => 'Нет доступных проектов',
			'skills.empty.noProjectsDescription' => 'Добавьте проект или рабочую область, чтобы просмотреть его навыки.',
			'skills.empty.noSkillsInProject' => 'В этом проекте нет навыков',
			'skills.empty.noSkillsInProjectDescription' => 'Создайте папку .claude/skills, .cursor/skills или .agents/skills в выбранном проекте.',
			'skills.empty.noGlobalSkills' => 'Глобальные навыки пока не найдены',
			'skills.empty.noGlobalSkillsDescription' => 'Добавьте глобальный навык выше, чтобы он был доступен во всех проектах.',
			'skills.empty.noMatchingSkills' => 'Нет подходящих навыков',
			'skills.empty.noMatchingSkillsDescription' => 'Попробуйте другую команду, имя, область, проект или исходный путь.',
			'skills.scopes.user' => 'Пользователь',
			'skills.scopes.plugin' => 'Плагин',
			'skills.scopes.repo' => 'Репозиторий',
			'skills.scopes.project' => 'Проект',
			'skills.scopes.admin' => 'Администратор',
			'skills.scopes.system' => 'Система',
			'skills.errors.dropMarkdownOrFolder' => 'Перетащите один или несколько файлов markdown или папку с SKILL.md.',
			'skills.errors.addMarkdownFirst' => 'Сначала добавьте один или несколько файлов markdown.',
			'skills.errors.importFailed' => 'Не удалось импортировать навыки',
			'skills.errors.folderReadFailed' => 'Не удалось прочитать папку навыка',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Папка навыка может содержать до ${count} файлов.',
			'skills.errors.folderSizeLimit' => 'Общий размер выбранных папок навыков должен быть меньше 30 МБ.',
			'skills.errors.missingSkillFile' => 'В выбранной папке нет файла SKILL.md.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'Не удалось прочитать SKILL.md из ${name}.',
			'skills.providerShared' => 'Общие',
			'terminal.tabs.shellName' => ({required Object index}) => 'Оболочка ${index}',
			'terminal.tabs.plainShell' => 'Простая оболочка',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Вход: ${provider}',
			'terminal.tabs.runTitle' => ({required Object command}) => 'Запуск: ${command}',
			'terminal.actions.newTab' => 'Новая вкладка терминала',
			'terminal.actions.providerLogin' => 'Вход в провайдер',
			'terminal.actions.restartSession' => 'Перезапустить сессию',
			'terminal.actions.clearOutput' => 'Очистить вывод',
			'terminal.actions.newShell' => 'Новая оболочка',
			'terminal.actions.connect' => 'Подключить',
			'terminal.authUrl.openInBrowser' => 'Открыть в браузере',
			'terminal.authUrl.linkLabel' => ({required Object url}) => 'Ссылка для входа: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'Обнаружен файл: ${path}',
			'terminal.shortcuts.interrupt' => 'Прервать (SIGINT)',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.suspend' => 'Приостановить (SIGTSTP)',
			'terminal.shortcuts.hide' => 'Скрыть панель горячих клавиш',
			'terminal.shortcuts.showTooltip' => 'Показать горячие клавиши',
			'terminal.shortcuts.hideTooltip' => 'Скрыть горячие клавиши',
			'terminal.paste.title' => 'Вставить в терминал',
			'terminal.paste.hint' => 'Ctrl+V / правый клик → Вставить',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Не удалось открыть ссылку: ${url}',
			'terminal.errors.frameError' => ({required Object message}) => '[Ошибка] ${message}',
			'terminal.errors.connectionError' => ({required Object message}) => '[Ошибка подключения] ${message}',
			'terminal.loginDialog.title' => ({required Object provider}) => 'Вход в ${provider} CLI',
			'terminal.loginDialog.exited' => ({required Object code}) => 'Завершено (${code})',
			'terminal.loginDialog.authLinkDetected' => 'Обнаружена ссылка для аутентификации',
			'terminal.empty.title' => 'Нет активного терминала',
			'terminal.empty.description' => 'Создайте новую вкладку, чтобы начать',
			'terminal.overlay.processExited' => 'Процесс завершён — подключитесь, чтобы запустить его снова',
			'terminal.overlay.processExitedWithCode' => ({required Object code}) => 'Процесс завершён (код ${code}) — подключитесь, чтобы запустить его снова',
			'terminal.overlay.resumeSession' => ({required Object title}) => 'Возобновить сеанс ${title}',
			'terminal.overlay.startSession' => ({required Object path}) => 'Начать новый сеанс в ${path}',
			'voice.preview' => 'Предпросмотр',
			'voice.settingsSaved' => 'Настройки голосового ввода сохранены',
			'voice.saveFailed' => 'Не удалось сохранить конфигурацию STT',
			'voice.apiKeySaved' => 'API-ключ (сохранён, введите, чтобы заменить)',
			'workspace.exportChat' => 'Экспортировать чат',
			'workspace.searchTranscript' => 'Поиск по транскрипту',
			'workspace.previousMatch' => 'Предыдущее совпадение',
			'workspace.nextMatch' => 'Следующее совпадение',
			_ => null,
		} ?? switch (path) {
			'workspace.closeSearch' => 'Закрыть поиск',
			'workspace.newChatProvider' => 'Новый чат — провайдер',
			'workspace.closePane' => 'Закрыть панель',
			'workspace.jumpToSession' => 'Перейти к сессии…',
			'workspace.archivedWorkspaceName' => 'Архив',
			'workspace.sendTo' => ({required Object count}) => 'Отправить в ${count}',
			'workspace.deleteSessionNotice' => 'Удаляет сессию и её транскрипт. Действие необратимо.',
			'workspace.accountWithLabel' => ({required Object label}) => 'По умолчанию · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Завершите запуск перед сменой рабочей области',
			'workspace.restored' => 'Рабочая область восстановлена',
			'workspace.maximizePane' => 'Развернуть панель',
			'workspace.restorePanes' => 'Восстановить панели',
			'workspace.reviewChangedFiles' => 'Просмотреть изменённые файлы',
			'workspace.paneTitle.chat' => 'Чат',
			'workspace.paneTitle.browser' => 'Браузер',
			'workspace.paneTitle.terminal' => 'Терминал',
			'workspace.paneTitle.notes' => 'Общие заметки',
			'workspace.paneTitle.editor' => 'Редактор',
			'workspace.paneTitle.git' => 'Git',
			'workspace.addEditorPane' => 'Добавить панель редактора',
			'workspace.addGitPane' => 'Добавить панель Git',
			'workspace.unknownProjectPath' => 'Неизвестный путь проекта',
			'workspace.autoMini' => 'Авто (mini)',
			'workspace.exportAs' => 'Экспортировать как:',
			'workspace.exportMarkdown' => 'Markdown (.md)',
			'workspace.exportHtml' => 'Веб-страница (.html)',
			'workspace.exportPdf' => 'PDF (печать в файл)',
			'workspace.matchPosition' => ({required Object current, required Object total}) => '${current} из ${total}',
			'workspace.launcherDescription' => 'Выберите рабочую область для этой панели или создайте новую.',
			'workspace.createWorkspace' => 'Создать рабочую область',
			'worktrees.scripts' => 'Скрипты',
			'worktrees.emptyTitle' => 'Worktree не найдены',
			'worktrees.emptyDescription' => 'Создайте worktree, чтобы изолировать работу над функцией или запуски агентов.',
			'worktrees.opened' => ({required Object branch}) => 'Открыт worktree: ${branch}',
			'worktrees.created' => 'Worktree создан',
			'worktrees.removed' => 'Worktree удалён',
			'worktrees.merged' => ({required Object branch}) => 'Worktree слит в ${branch}',
			'worktrees.scriptsSaved' => 'Конфигурация скриптов сохранена',
			'worktrees.setupLabel' => 'Настройка: ',
			'worktrees.serverLabel' => 'Сервер: ',
			'worktrees.runRunning' => 'выполняется',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'выполняется :${port}',
			'worktrees.runButton' => 'Запустить',
			'worktrees.stopButton' => 'Остановить',
			'worktrees.mainBadge' => 'main',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD откреплён на ${sha}',
			'worktrees.branchHint' => 'Имя новой ветки (напр. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Ветвление от ${branch}',
			'worktrees.mergeTitle' => ({required Object branch}) => 'Слить ${branch}',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Слить изменения в ${branch}.',
			'worktrees.squashDescription' => 'Объединить все коммиты в один коммит',
			'worktrees.cleanupDescription' => 'Удалить worktree и ветку после слияния',
			'worktrees.removeTitle' => ({required Object branch}) => 'Удалить worktree ${branch}?',
			'worktrees.removeDescription' => 'Это удалит папку worktree. Связанные проекты будут заархивированы.',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Внимание: в этом worktree есть ${count} незафиксированных изменений, которые будут потеряны.',
			'worktrees.forceRemoveLabel' => 'Принудительно удалить (отменить изменения)',
			'worktrees.deleteBranchLabel' => 'Также удалить ветку',
			'worktrees.setupHint' => 'Команда настройки (напр. npm install)',
			'worktrees.runHint' => 'Команда запуска (напр. npm run dev)',
			'worktrees.portHint' => 'Порт запуска (необязательно, напр. 3000)',
			'worktrees.unknownSha' => 'неизвестно',
			'worktrees.baseBranchFallback' => 'базовая ветка',
			'worktrees.runtimeStatus.idle' => 'простаивает',
			'worktrees.runtimeStatus.running' => 'выполняется',
			'worktrees.runtimeStatus.done' => 'готово',
			'worktrees.runtimeStatus.failed' => 'ошибка',
			'worktrees.runtimeStatus.exited' => 'завершён',
			'browserUse.sessionStatus.ready' => 'Готова',
			'browserUse.sessionStatus.stopped' => 'Остановлена',
			'browserUse.sessionStatus.unavailable' => 'Недоступна',
			'orchestrator.stepFallback' => ({required Object n}) => 'Шаг ${n}',
			'miniOrchestrator.taskTypes.gate' => 'Шлюз',
			'miniOrchestrator.roles.thinker' => 'Мыслитель',
			'miniOrchestrator.roles.worker' => 'Исполнитель',
			_ => null,
		};
	}
}
