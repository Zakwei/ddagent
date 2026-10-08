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
class TranslationsPl extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPl({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.pl,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pl>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsPl _root = this; // ignore: unused_field

	@override 
	TranslationsPl $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPl(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$pl auth = Translations$auth$pl._(_root);
	@override late final Translations$chat$pl chat = Translations$chat$pl._(_root);
	@override late final Translations$codeEditor$pl codeEditor = Translations$codeEditor$pl._(_root);
	@override late final Translations$common$pl common = Translations$common$pl._(_root);
	@override late final Translations$settings$pl settings = Translations$settings$pl._(_root);
	@override late final Translations$sidebar$pl sidebar = Translations$sidebar$pl._(_root);
	@override late final Translations$tasks$pl tasks = Translations$tasks$pl._(_root);
	@override late final Translations$knowledge$pl knowledge = Translations$knowledge$pl._(_root);
	@override late final Translations$browser$pl browser = Translations$browser$pl._(_root);
	@override late final Translations$collab$pl collab = Translations$collab$pl._(_root);
	@override late final Translations$fileTree$pl fileTree = Translations$fileTree$pl._(_root);
	@override late final Translations$git$pl git = Translations$git$pl._(_root);
	@override late final Translations$kanban$pl kanban = Translations$kanban$pl._(_root);
	@override late final Translations$mcp$pl mcp = Translations$mcp$pl._(_root);
	@override late final Translations$notifications$pl notifications = Translations$notifications$pl._(_root);
	@override late final Translations$onboarding$pl onboarding = Translations$onboarding$pl._(_root);
	@override late final Translations$projects$pl projects = Translations$projects$pl._(_root);
	@override late final Translations$quota$pl quota = Translations$quota$pl._(_root);
	@override late final Translations$scheduler$pl scheduler = Translations$scheduler$pl._(_root);
	@override late final Translations$serverConnect$pl serverConnect = Translations$serverConnect$pl._(_root);
	@override late final Translations$sessions$pl sessions = Translations$sessions$pl._(_root);
	@override late final Translations$sharedContext$pl sharedContext = Translations$sharedContext$pl._(_root);
	@override late final Translations$skills$pl skills = Translations$skills$pl._(_root);
	@override late final Translations$terminal$pl terminal = Translations$terminal$pl._(_root);
	@override late final Translations$voice$pl voice = Translations$voice$pl._(_root);
	@override late final Translations$workspace$pl workspace = Translations$workspace$pl._(_root);
	@override late final Translations$worktrees$pl worktrees = Translations$worktrees$pl._(_root);
	@override late final Translations$browserUse$pl browserUse = Translations$browserUse$pl._(_root);
	@override late final Translations$orchestrator$pl orchestrator = Translations$orchestrator$pl._(_root);
	@override late final Translations$miniOrchestrator$pl miniOrchestrator = Translations$miniOrchestrator$pl._(_root);
}

// Path: auth
class Translations$auth$pl extends Translations$auth$en {
	Translations$auth$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'Twoja sesja wygasła. Zaloguj się ponownie.';
	@override late final Translations$auth$login$pl login = Translations$auth$login$pl._(_root);
	@override late final Translations$auth$register$pl register = Translations$auth$register$pl._(_root);
	@override late final Translations$auth$logout$pl logout = Translations$auth$logout$pl._(_root);
}

// Path: chat
class Translations$chat$pl extends Translations$chat$en {
	Translations$chat$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$pl codeBlock = Translations$chat$codeBlock$pl._(_root);
	@override late final Translations$chat$copyMessage$pl copyMessage = Translations$chat$copyMessage$pl._(_root);
	@override late final Translations$chat$messageTypes$pl messageTypes = Translations$chat$messageTypes$pl._(_root);
	@override late final Translations$chat$orchestrator$pl orchestrator = Translations$chat$orchestrator$pl._(_root);
	@override late final Translations$chat$tools$pl tools = Translations$chat$tools$pl._(_root);
	@override late final Translations$chat$search$pl search = Translations$chat$search$pl._(_root);
	@override late final Translations$chat$fileOperations$pl fileOperations = Translations$chat$fileOperations$pl._(_root);
	@override late final Translations$chat$interactive$pl interactive = Translations$chat$interactive$pl._(_root);
	@override late final Translations$chat$thinking$pl thinking = Translations$chat$thinking$pl._(_root);
	@override late final Translations$chat$json$pl json = Translations$chat$json$pl._(_root);
	@override late final Translations$chat$permissions$pl permissions = Translations$chat$permissions$pl._(_root);
	@override late final Translations$chat$todo$pl todo = Translations$chat$todo$pl._(_root);
	@override late final Translations$chat$plan$pl plan = Translations$chat$plan$pl._(_root);
	@override late final Translations$chat$usageLimit$pl usageLimit = Translations$chat$usageLimit$pl._(_root);
	@override late final Translations$chat$codex$pl codex = Translations$chat$codex$pl._(_root);
	@override late final Translations$chat$voice$pl voice = Translations$chat$voice$pl._(_root);
	@override late final Translations$chat$input$pl input = Translations$chat$input$pl._(_root);
	@override late final Translations$chat$composer$pl composer = Translations$chat$composer$pl._(_root);
	@override late final Translations$chat$providerSelection$pl providerSelection = Translations$chat$providerSelection$pl._(_root);
	@override late final Translations$chat$session$pl session = Translations$chat$session$pl._(_root);
	@override late final Translations$chat$shell$pl shell = Translations$chat$shell$pl._(_root);
	@override late final Translations$chat$claudeStatus$pl claudeStatus = Translations$chat$claudeStatus$pl._(_root);
	@override late final Translations$chat$projectSelection$pl projectSelection = Translations$chat$projectSelection$pl._(_root);
	@override late final Translations$chat$tasks$pl tasks = Translations$chat$tasks$pl._(_root);
	@override late final Translations$chat$splitSession$pl splitSession = Translations$chat$splitSession$pl._(_root);
	@override late final Translations$chat$sessionPicker$pl sessionPicker = Translations$chat$sessionPicker$pl._(_root);
	@override late final Translations$chat$splitWorkspace$pl splitWorkspace = Translations$chat$splitWorkspace$pl._(_root);
	@override late final Translations$chat$splitOverview$pl splitOverview = Translations$chat$splitOverview$pl._(_root);
	@override late final Translations$chat$askUserQuestion$pl askUserQuestion = Translations$chat$askUserQuestion$pl._(_root);
	@override late final Translations$chat$attachments$pl attachments = Translations$chat$attachments$pl._(_root);
	@override late final Translations$chat$checkpoint$pl checkpoint = Translations$chat$checkpoint$pl._(_root);
	@override late final Translations$chat$common$pl common = Translations$chat$common$pl._(_root);
	@override late final Translations$chat$taskMaster$pl taskMaster = Translations$chat$taskMaster$pl._(_root);
	@override late final Translations$chat$tokenUsage$pl tokenUsage = Translations$chat$tokenUsage$pl._(_root);
	@override late final Translations$chat$tool$pl tool = Translations$chat$tool$pl._(_root);
	@override late final Translations$chat$quotaBadge$pl quotaBadge = Translations$chat$quotaBadge$pl._(_root);
	@override late final Translations$chat$broadcast$pl broadcast = Translations$chat$broadcast$pl._(_root);
	@override late final Translations$chat$paneHeader$pl paneHeader = Translations$chat$paneHeader$pl._(_root);
	@override late final Translations$chat$export$pl export = Translations$chat$export$pl._(_root);
	@override late final Translations$chat$commandResult$pl commandResult = Translations$chat$commandResult$pl._(_root);
	@override late final Translations$chat$commands$pl commands = Translations$chat$commands$pl._(_root);
	@override late final Translations$chat$pinFile$pl pinFile = Translations$chat$pinFile$pl._(_root);
	@override late final Translations$chat$modelLibrary$pl modelLibrary = Translations$chat$modelLibrary$pl._(_root);
	@override late final Translations$chat$changes$pl changes = Translations$chat$changes$pl._(_root);
	@override late final Translations$chat$message$pl message = Translations$chat$message$pl._(_root);
	@override late final Translations$chat$permissionRequest$pl permissionRequest = Translations$chat$permissionRequest$pl._(_root);
	@override late final Translations$chat$commandDialog$pl commandDialog = Translations$chat$commandDialog$pl._(_root);
	@override late final Translations$chat$utilities$pl utilities = Translations$chat$utilities$pl._(_root);
	@override late final Translations$chat$toolBlocks$pl toolBlocks = Translations$chat$toolBlocks$pl._(_root);
	@override late final Translations$chat$commandMenu$pl commandMenu = Translations$chat$commandMenu$pl._(_root);
	@override late final Translations$chat$mentionMenu$pl mentionMenu = Translations$chat$mentionMenu$pl._(_root);
	@override late final Translations$chat$subheader$pl subheader = Translations$chat$subheader$pl._(_root);
	@override late final Translations$chat$transcript$pl transcript = Translations$chat$transcript$pl._(_root);
	@override late final Translations$chat$review$pl review = Translations$chat$review$pl._(_root);
}

// Path: codeEditor
class Translations$codeEditor$pl extends Translations$codeEditor$en {
	Translations$codeEditor$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$pl toolbar = Translations$codeEditor$toolbar$pl._(_root);
	@override String loading({required Object fileName}) => 'Wczytywanie ${fileName}...';
	@override late final Translations$codeEditor$header$pl header = Translations$codeEditor$header$pl._(_root);
	@override late final Translations$codeEditor$actions$pl actions = Translations$codeEditor$actions$pl._(_root);
	@override late final Translations$codeEditor$footer$pl footer = Translations$codeEditor$footer$pl._(_root);
	@override late final Translations$codeEditor$binaryFile$pl binaryFile = Translations$codeEditor$binaryFile$pl._(_root);
	@override late final Translations$codeEditor$filePreview$pl filePreview = Translations$codeEditor$filePreview$pl._(_root);
	@override String unsavedChanges({required Object name}) => 'Niezapisane zmiany w ${name}';
	@override String get discardUnsavedChanges => 'Odrzucić niezapisane zmiany?';
	@override late final Translations$codeEditor$mediaFile$pl mediaFile = Translations$codeEditor$mediaFile$pl._(_root);
	@override String get failedToLoad => 'Nie udało się wczytać pliku';
	@override late final Translations$codeEditor$hexDump$pl hexDump = Translations$codeEditor$hexDump$pl._(_root);
	@override late final Translations$codeEditor$settings$pl settings = Translations$codeEditor$settings$pl._(_root);
	@override late final Translations$codeEditor$diff$pl diff = Translations$codeEditor$diff$pl._(_root);
	@override late final Translations$codeEditor$emptyState$pl emptyState = Translations$codeEditor$emptyState$pl._(_root);
	@override late final Translations$codeEditor$toasts$pl toasts = Translations$codeEditor$toasts$pl._(_root);
}

// Path: common
class Translations$common$pl extends Translations$common$en {
	Translations$common$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$pl buttons = Translations$common$buttons$pl._(_root);
	@override late final Translations$common$tabs$pl tabs = Translations$common$tabs$pl._(_root);
	@override late final Translations$common$quota$pl quota = Translations$common$quota$pl._(_root);
	@override late final Translations$common$status$pl status = Translations$common$status$pl._(_root);
	@override late final Translations$common$messages$pl messages = Translations$common$messages$pl._(_root);
	@override late final Translations$common$navigation$pl navigation = Translations$common$navigation$pl._(_root);
	@override late final Translations$common$common$pl common = Translations$common$common$pl._(_root);
	@override late final Translations$common$time$pl time = Translations$common$time$pl._(_root);
	@override late final Translations$common$fileOperations$pl fileOperations = Translations$common$fileOperations$pl._(_root);
	@override late final Translations$common$mainContent$pl mainContent = Translations$common$mainContent$pl._(_root);
	@override late final Translations$common$fileTree$pl fileTree = Translations$common$fileTree$pl._(_root);
	@override late final Translations$common$projectWizard$pl projectWizard = Translations$common$projectWizard$pl._(_root);
	@override late final Translations$common$notifications$pl notifications = Translations$common$notifications$pl._(_root);
	@override late final Translations$common$versionUpdate$pl versionUpdate = Translations$common$versionUpdate$pl._(_root);
	@override late final Translations$common$actions$pl actions = Translations$common$actions$pl._(_root);
	@override late final Translations$common$browserPane$pl browserPane = Translations$common$browserPane$pl._(_root);
	@override late final Translations$common$browserUse$pl browserUse = Translations$common$browserUse$pl._(_root);
	@override late final Translations$common$commandPalette$pl commandPalette = Translations$common$commandPalette$pl._(_root);
	@override late final Translations$common$gitPanel$pl gitPanel = Translations$common$gitPanel$pl._(_root);
	@override late final Translations$common$sessions$pl sessions = Translations$common$sessions$pl._(_root);
	@override late final Translations$common$projects$pl projects = Translations$common$projects$pl._(_root);
	@override late final Translations$common$sharedNotes$pl sharedNotes = Translations$common$sharedNotes$pl._(_root);
	@override late final Translations$common$codeBlock$pl codeBlock = Translations$common$codeBlock$pl._(_root);
	@override late final Translations$common$update$pl update = Translations$common$update$pl._(_root);
	@override late final Translations$common$appShell$pl appShell = Translations$common$appShell$pl._(_root);
	@override late final Translations$common$errors$pl errors = Translations$common$errors$pl._(_root);
}

// Path: settings
class Translations$settings$pl extends Translations$settings$en {
	Translations$settings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ustawienia';
	@override late final Translations$settings$changelog$pl changelog = Translations$settings$changelog$pl._(_root);
	@override late final Translations$settings$server$pl server = Translations$settings$server$pl._(_root);
	@override late final Translations$settings$updates$pl updates = Translations$settings$updates$pl._(_root);
	@override late final Translations$settings$tabs$pl tabs = Translations$settings$tabs$pl._(_root);
	@override late final Translations$settings$account$pl account = Translations$settings$account$pl._(_root);
	@override late final Translations$settings$mcp$pl mcp = Translations$settings$mcp$pl._(_root);
	@override late final Translations$settings$appearance$pl appearance = Translations$settings$appearance$pl._(_root);
	@override late final Translations$settings$actions$pl actions = Translations$settings$actions$pl._(_root);
	@override late final Translations$settings$quickSettings$pl quickSettings = Translations$settings$quickSettings$pl._(_root);
	@override late final Translations$settings$terminalShortcuts$pl terminalShortcuts = Translations$settings$terminalShortcuts$pl._(_root);
	@override late final Translations$settings$mainTabs$pl mainTabs = Translations$settings$mainTabs$pl._(_root);
	@override late final Translations$settings$miniOrchestration$pl miniOrchestration = Translations$settings$miniOrchestration$pl._(_root);
	@override late final Translations$settings$orchestration$pl orchestration = Translations$settings$orchestration$pl._(_root);
	@override late final Translations$settings$notifications$pl notifications = Translations$settings$notifications$pl._(_root);
	@override late final Translations$settings$appearanceSettings$pl appearanceSettings = Translations$settings$appearanceSettings$pl._(_root);
	@override late final Translations$settings$mcpForm$pl mcpForm = Translations$settings$mcpForm$pl._(_root);
	@override late final Translations$settings$saveStatus$pl saveStatus = Translations$settings$saveStatus$pl._(_root);
	@override late final Translations$settings$footerActions$pl footerActions = Translations$settings$footerActions$pl._(_root);
	@override late final Translations$settings$git$pl git = Translations$settings$git$pl._(_root);
	@override late final Translations$settings$apiKeys$pl apiKeys = Translations$settings$apiKeys$pl._(_root);
	@override late final Translations$settings$tasks$pl tasks = Translations$settings$tasks$pl._(_root);
	@override late final Translations$settings$agents$pl agents = Translations$settings$agents$pl._(_root);
	@override late final Translations$settings$permissions$pl permissions = Translations$settings$permissions$pl._(_root);
	@override late final Translations$settings$mcpServers$pl mcpServers = Translations$settings$mcpServers$pl._(_root);
	@override late final Translations$settings$quota$pl quota = Translations$settings$quota$pl._(_root);
	@override late final Translations$settings$browser$pl browser = Translations$settings$browser$pl._(_root);
	@override late final Translations$settings$workspaces$pl workspaces = Translations$settings$workspaces$pl._(_root);
	@override late final Translations$settings$stt$pl stt = Translations$settings$stt$pl._(_root);
	@override late final Translations$settings$schedules$pl schedules = Translations$settings$schedules$pl._(_root);
	@override late final Translations$settings$mcpTokens$pl mcpTokens = Translations$settings$mcpTokens$pl._(_root);
	@override late final Translations$settings$about$pl about = Translations$settings$about$pl._(_root);
	@override late final Translations$settings$shortcuts$pl shortcuts = Translations$settings$shortcuts$pl._(_root);
}

// Path: sidebar
class Translations$sidebar$pl extends Translations$sidebar$en {
	Translations$sidebar$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$pl projects = Translations$sidebar$projects$pl._(_root);
	@override late final Translations$sidebar$app$pl app = Translations$sidebar$app$pl._(_root);
	@override late final Translations$sidebar$panel$pl panel = Translations$sidebar$panel$pl._(_root);
	@override late final Translations$sidebar$sessions$pl sessions = Translations$sidebar$sessions$pl._(_root);
	@override late final Translations$sidebar$tooltips$pl tooltips = Translations$sidebar$tooltips$pl._(_root);
	@override late final Translations$sidebar$navigation$pl navigation = Translations$sidebar$navigation$pl._(_root);
	@override late final Translations$sidebar$actions$pl actions = Translations$sidebar$actions$pl._(_root);
	@override late final Translations$sidebar$workspace$pl workspace = Translations$sidebar$workspace$pl._(_root);
	@override late final Translations$sidebar$branding$pl branding = Translations$sidebar$branding$pl._(_root);
	@override late final Translations$sidebar$status$pl status = Translations$sidebar$status$pl._(_root);
	@override late final Translations$sidebar$time$pl time = Translations$sidebar$time$pl._(_root);
	@override late final Translations$sidebar$messages$pl messages = Translations$sidebar$messages$pl._(_root);
	@override late final Translations$sidebar$version$pl version = Translations$sidebar$version$pl._(_root);
	@override late final Translations$sidebar$search$pl search = Translations$sidebar$search$pl._(_root);
	@override late final Translations$sidebar$recent$pl recent = Translations$sidebar$recent$pl._(_root);
	@override late final Translations$sidebar$deleteConfirmation$pl deleteConfirmation = Translations$sidebar$deleteConfirmation$pl._(_root);
	@override late final Translations$sidebar$zones$pl zones = Translations$sidebar$zones$pl._(_root);
	@override late final Translations$sidebar$tabs$pl tabs = Translations$sidebar$tabs$pl._(_root);
}

// Path: tasks
class Translations$tasks$pl extends Translations$tasks$en {
	Translations$tasks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$pl notConfigured = Translations$tasks$notConfigured$pl._(_root);
	@override late final Translations$tasks$gettingStarted$pl gettingStarted = Translations$tasks$gettingStarted$pl._(_root);
	@override late final Translations$tasks$setupModal$pl setupModal = Translations$tasks$setupModal$pl._(_root);
	@override late final Translations$tasks$helpGuide$pl helpGuide = Translations$tasks$helpGuide$pl._(_root);
	@override late final Translations$tasks$search$pl search = Translations$tasks$search$pl._(_root);
	@override late final Translations$tasks$filters$pl filters = Translations$tasks$filters$pl._(_root);
	@override late final Translations$tasks$sort$pl sort = Translations$tasks$sort$pl._(_root);
	@override late final Translations$tasks$views$pl views = Translations$tasks$views$pl._(_root);
	@override late final Translations$tasks$kanban$pl kanban = Translations$tasks$kanban$pl._(_root);
	@override late final Translations$tasks$buttons$pl buttons = Translations$tasks$buttons$pl._(_root);
	@override late final Translations$tasks$prd$pl prd = Translations$tasks$prd$pl._(_root);
	@override late final Translations$tasks$statuses$pl statuses = Translations$tasks$statuses$pl._(_root);
	@override late final Translations$tasks$priorities$pl priorities = Translations$tasks$priorities$pl._(_root);
	@override late final Translations$tasks$noMatchingTasks$pl noMatchingTasks = Translations$tasks$noMatchingTasks$pl._(_root);
	@override late final Translations$tasks$board$pl board = Translations$tasks$board$pl._(_root);
	@override late final Translations$tasks$card$pl card = Translations$tasks$card$pl._(_root);
	@override late final Translations$tasks$createTask$pl createTask = Translations$tasks$createTask$pl._(_root);
	@override late final Translations$tasks$list$pl list = Translations$tasks$list$pl._(_root);
	@override late final Translations$tasks$nextTask$pl nextTask = Translations$tasks$nextTask$pl._(_root);
	@override late final Translations$tasks$taskDetail$pl taskDetail = Translations$tasks$taskDetail$pl._(_root);
	@override late final Translations$tasks$toasts$pl toasts = Translations$tasks$toasts$pl._(_root);
	@override late final Translations$tasks$taskmaster$pl taskmaster = Translations$tasks$taskmaster$pl._(_root);
}

// Path: knowledge
class Translations$knowledge$pl extends Translations$knowledge$en {
	Translations$knowledge$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wiedza';
	@override late final Translations$knowledge$tabs$pl tabs = Translations$knowledge$tabs$pl._(_root);
	@override late final Translations$knowledge$common$pl common = Translations$knowledge$common$pl._(_root);
	@override late final Translations$knowledge$actions$pl actions = Translations$knowledge$actions$pl._(_root);
	@override late final Translations$knowledge$dialog$pl dialog = Translations$knowledge$dialog$pl._(_root);
	@override late final Translations$knowledge$fields$pl fields = Translations$knowledge$fields$pl._(_root);
	@override late final Translations$knowledge$dashboard$pl dashboard = Translations$knowledge$dashboard$pl._(_root);
	@override late final Translations$knowledge$empty$pl empty = Translations$knowledge$empty$pl._(_root);
	@override late final Translations$knowledge$history$pl history = Translations$knowledge$history$pl._(_root);
	@override late final Translations$knowledge$priorities$pl priorities = Translations$knowledge$priorities$pl._(_root);
	@override late final Translations$knowledge$search$pl search = Translations$knowledge$search$pl._(_root);
	@override late final Translations$knowledge$links$pl links = Translations$knowledge$links$pl._(_root);
	@override late final Translations$knowledge$tags$pl tags = Translations$knowledge$tags$pl._(_root);
	@override late final Translations$knowledge$graph$pl graph = Translations$knowledge$graph$pl._(_root);
	@override late final Translations$knowledge$importAll$pl importAll = Translations$knowledge$importAll$pl._(_root);
	@override late final Translations$knowledge$migrate$pl migrate = Translations$knowledge$migrate$pl._(_root);
	@override late final Translations$knowledge$importSkills$pl importSkills = Translations$knowledge$importSkills$pl._(_root);
	@override late final Translations$knowledge$critical$pl critical = Translations$knowledge$critical$pl._(_root);
	@override late final Translations$knowledge$contextBudget$pl contextBudget = Translations$knowledge$contextBudget$pl._(_root);
	@override late final Translations$knowledge$linkOptions$pl linkOptions = Translations$knowledge$linkOptions$pl._(_root);
	@override late final Translations$knowledge$errors$pl errors = Translations$knowledge$errors$pl._(_root);
	@override late final Translations$knowledge$entityTypes$pl entityTypes = Translations$knowledge$entityTypes$pl._(_root);
}

// Path: browser
class Translations$browser$pl extends Translations$browser$en {
	Translations$browser$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Browser agenta';
	@override String get viewError => 'Błąd widoku przeglądarki';
	@override String get web => 'Web';
}

// Path: collab
class Translations$collab$pl extends Translations$collab$en {
	Translations$collab$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get team => 'Zespół';
	@override String get invite => 'Zaproś';
	@override String get inviteTeammate => 'Zaproś członka zespołu';
	@override String get shareTokenHint => 'Udostępnij ten token zaproszenia — jest pokazywany jednorazowo i wygasa po 72 godz.:';
	@override String get createInvite => 'Utwórz zaproszenie';
	@override String get copyToken => 'Kopiuj token';
	@override late final Translations$collab$roles$pl roles = Translations$collab$roles$pl._(_root);
	@override late final Translations$collab$viewing$pl viewing = Translations$collab$viewing$pl._(_root);
}

// Path: fileTree
class Translations$fileTree$pl extends Translations$fileTree$en {
	Translations$fileTree$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get uploadTo => 'Wgraj do';
	@override String get uploadHere => 'Wgraj tutaj';
	@override String get browseServerFilesystem => 'Przeglądaj system plików serwera';
	@override String get noFiles => 'Brak plików';
	@override String get copyContents => 'Kopiuj zawartość';
	@override String get chooseFolder => 'Wybierz folder';
	@override late final Translations$fileTree$search$pl search = Translations$fileTree$search$pl._(_root);
	@override late final Translations$fileTree$titles$pl titles = Translations$fileTree$titles$pl._(_root);
	@override String uploadedCount({required Object count}) => 'Przesłano ${count} plik(ów)';
	@override String get newName => 'Nowa nazwa';
	@override String notRegisteredProject({required Object path}) => 'Nie jest zarejestrowanym projektem: ${path}';
	@override String get showGitignoredFiles => 'Pokaż pliki ignorowane przez Git';
	@override String get hideGitignoredFiles => 'Ukryj pliki ignorowane przez Git';
	@override String get downloadUnsupportedOnWeb => 'Pobieranie niedostępne w wersji webowej';
	@override String get saveToPath => 'Zapisz do ścieżki';
	@override String savedTo({required Object path}) => 'Zapisano w ${path}';
	@override late final Translations$fileTree$relative$pl relative = Translations$fileTree$relative$pl._(_root);
	@override String get projectRoot => '(katalog główny projektu)';
	@override String uploadLimitCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Naraz możesz przesłać maksymalnie ${count} plik.',
		few: 'Naraz możesz przesłać maksymalnie ${count} pliki.',
		many: 'Naraz możesz przesłać maksymalnie ${count} plików.',
		other: 'Naraz możesz przesłać maksymalnie ${count} pliku.',
	);
	@override String fileTooLarge({required Object name}) => 'Plik ${name} jest większy niż 200 MB.';
	@override String deleteFolderConfirm({required Object path}) => 'Usunąć folder „${path}”? Tej operacji nie można cofnąć.';
	@override String deleteFileConfirm({required Object path}) => 'Usunąć plik „${path}”? Tej operacji nie można cofnąć.';
}

// Path: git
class Translations$git$pl extends Translations$git$en {
	Translations$git$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$git$checkpoints$pl checkpoints = Translations$git$checkpoints$pl._(_root);
	@override String get stagedChanges => 'Przygotowane zmiany';
	@override String get statusStaged => 'Przygotowane';
	@override String get switchBranch => 'Przełącz gałąź';
	@override String get unifiedDiff => 'Diff ujednolicony';
	@override String get splitDiff => 'Diff obok siebie';
	@override String get noDiff => 'Brak dostępnego diff';
	@override String get largeDiff => 'Duży podgląd diff: renderowanie jest ograniczone, aby karta działała płynnie.';
	@override String loadDiffFailed({required Object error}) => 'Nie udało się wczytać diff: ${error}';
	@override String get hunkStage => '+ Fragment';
	@override String get hunkUnstage => '− Fragment';
	@override String get stageHunk => 'Przygotuj fragment';
	@override String get unstageHunk => 'Cofnij przygotowanie fragmentu';
	@override String get deleteFile => 'Usuń plik';
	@override String get commitMessage => 'Wiadomość commita';
	@override String get aiButton => '✦ AI';
	@override String get commitCreated => 'Utworzono commit';
	@override String get noBranch => 'brak gałęzi';
	@override String get selectProject => 'Wybierz projekt';
	@override late final Translations$git$branchSections$pl branchSections = Translations$git$branchSections$pl._(_root);
}

// Path: kanban
class Translations$kanban$pl extends Translations$kanban$en {
	Translations$kanban$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$pl card = Translations$kanban$card$pl._(_root);
	@override late final Translations$kanban$comments$pl comments = Translations$kanban$comments$pl._(_root);
	@override late final Translations$kanban$dialog$pl dialog = Translations$kanban$dialog$pl._(_root);
	@override late final Translations$kanban$details$pl details = Translations$kanban$details$pl._(_root);
	@override late final Translations$kanban$empty$pl empty = Translations$kanban$empty$pl._(_root);
	@override String get saveFailed => 'Nie udało się zapisać karty';
	@override late final Translations$kanban$time$pl time = Translations$kanban$time$pl._(_root);
}

// Path: mcp
class Translations$mcp$pl extends Translations$mcp$en {
	Translations$mcp$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$install$pl install = Translations$mcp$install$pl._(_root);
	@override late final Translations$mcp$servers$pl servers = Translations$mcp$servers$pl._(_root);
	@override late final Translations$mcp$team$pl team = Translations$mcp$team$pl._(_root);
	@override late final Translations$mcp$tokens$pl tokens = Translations$mcp$tokens$pl._(_root);
	@override late final Translations$mcp$form$pl form = Translations$mcp$form$pl._(_root);
}

// Path: notifications
class Translations$notifications$pl extends Translations$notifications$en {
	Translations$notifications$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$pl errors = Translations$notifications$errors$pl._(_root);
	@override late final Translations$notifications$androidChannel$pl androidChannel = Translations$notifications$androidChannel$pl._(_root);
}

// Path: onboarding
class Translations$onboarding$pl extends Translations$onboarding$en {
	Translations$onboarding$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get gitHint => 'Używane dla commitów tworzonych przez sesje DDAgent.';
	@override String get completeSetup => 'Zakończ konfigurację';
	@override late final Translations$onboarding$errors$pl errors = Translations$onboarding$errors$pl._(_root);
	@override late final Translations$onboarding$agents$pl agents = Translations$onboarding$agents$pl._(_root);
	@override late final Translations$onboarding$mcp$pl mcp = Translations$onboarding$mcp$pl._(_root);
}

// Path: projects
class Translations$projects$pl extends Translations$projects$en {
	Translations$projects$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cloneRepository => 'Klonuj repozytorium';
	@override String get repositoryCloned => 'Repozytorium sklonowane';
	@override String get clone => 'Klonuj';
	@override String get cloneFinished => 'Klonowanie zakończone. Odświeżanie listy projektów…';
	@override String get cloneFailed => 'Klonowanie nie powiodło się';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get destinationPath => 'Ścieżka docelowa';
	@override String get destinationPathRequired => 'Ścieżka docelowa jest wymagana';
	@override String get repositoryUrlRequired => 'Adres URL repozytorium jest wymagany';
	@override String get githubTokenOptional => 'Token GitHub (opcjonalnie)';
	@override String get archive => 'Archiwizuj';
	@override String get restore => 'Przywróć';
	@override String get deletePermanently => 'Usuń trwale';
	@override String get deleteProjectTitle => 'Usunąć projekt?';
	@override String deleteProjectMessage({required Object name}) => 'Trwale usuwa "${name}" wraz ze wszystkimi sesjami i zapisaną historią (czyszczenie JSONL). Tej operacji nie można cofnąć.';
	@override String archivedSection({required Object count}) => 'Zarchiwizowane (${count})';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} sesja',
		other: '${count} sesji',
	);
	@override String get newer => 'Nowsze';
	@override String get older => 'Starsze';
	@override String get projectArchived => 'Projekt zarchiwizowany';
	@override String get projectRestored => 'Projekt przywrócony';
	@override String get projectRenamed => 'Zmieniono nazwę projektu';
	@override String get projectDeleted => 'Projekt usunięty';
	@override String get failedToLoadTokens => 'Nie udało się wczytać tokenów GitHub';
	@override String get displayNameOptional => 'Nazwa wyświetlana (opcjonalnie)';
	@override String usingStoredToken({required Object name}) => 'Używanie zapisanego tokenu: ${name}';
	@override String get unknown => 'Nieznane';
	@override String get project => 'Projekt';
}

// Path: quota
class Translations$quota$pl extends Translations$quota$en {
	Translations$quota$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$section$pl section = Translations$quota$section$pl._(_root);
	@override late final Translations$quota$overview$pl overview = Translations$quota$overview$pl._(_root);
	@override late final Translations$quota$agents$pl agents = Translations$quota$agents$pl._(_root);
	@override late final Translations$quota$config$pl config = Translations$quota$config$pl._(_root);
	@override late final Translations$quota$chart$pl chart = Translations$quota$chart$pl._(_root);
	@override late final Translations$quota$duration$pl duration = Translations$quota$duration$pl._(_root);
}

// Path: scheduler
class Translations$scheduler$pl extends Translations$scheduler$en {
	Translations$scheduler$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get newLabel => 'Nowy';
	@override String get runs => 'Uruchomienia';
	@override String get editTitle => 'Edytuj harmonogram';
	@override String get deleteTitle => 'Usunąć harmonogram?';
	@override String deleteMessage({required Object id}) => 'Spowoduje to usunięcie zadania cyklicznego ${id}. Istniejące sesje zostaną zachowane.';
	@override String get checking => 'Sprawdzanie…';
	@override String nextIn({required Object time}) => 'następne za ${time}';
	@override String get worktree => 'worktree';
	@override String session({required Object id}) => 'sesja ${id}';
	@override String get cronHint => 'Cron (min godz dzień mies dzień-tyg) — np. 0 9 * * *';
	@override String get promptHint => 'Prompt dla agenta';
	@override late final Translations$scheduler$runStatus$pl runStatus = Translations$scheduler$runStatus$pl._(_root);
	@override late final Translations$scheduler$cronErrors$pl cronErrors = Translations$scheduler$cronErrors$pl._(_root);
}

// Path: serverConnect
class Translations$serverConnect$pl extends Translations$serverConnect$en {
	Translations$serverConnect$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Połącz się ze swoim serwerem DDAgent';
	@override String get enterUrl => 'Wpisz adres URL serwera';
	@override String connectionFailed({required Object error}) => 'Połączenie nie powiodło się (${error})';
	@override String get connect => 'Połącz';
	@override String get connecting => 'Łączenie…';
	@override String get changeServer => 'Zmień serwer';
	@override late final Translations$serverConnect$local$pl local = Translations$serverConnect$local$pl._(_root);
	@override String httpStatus({required Object code}) => 'HTTP ${code}';
	@override String get networkError => 'Błąd sieci';
}

// Path: sessions
class Translations$sessions$pl extends Translations$sessions$en {
	Translations$sessions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get noSessions => 'Brak sesji';
	@override String get noRecentSessions => 'Brak ostatnich sesji';
	@override String get archivedSessions => 'Zarchiwizowane sesje';
	@override String get rename => 'Zmień nazwę';
	@override String get archive => 'Archiwizuj';
	@override String get compareWith => 'Porównaj z…';
	@override String get projectPath => 'Ścieżka projektu';
	@override String get newSessionProvider => 'Nowa sesja — dostawca';
	@override String get autoOrchestrator => 'Auto (orkiestrator)';
	@override String createFailed({required Object error}) => 'Nie udało się utworzyć sesji: ${error}';
	@override String deleteSessionMessage({required Object name}) => 'Usuwa "${name}" wraz z transkryptem. Tej operacji nie można cofnąć.';
	@override late final Translations$sessions$toasts$pl toasts = Translations$sessions$toasts$pl._(_root);
	@override late final Translations$sessions$age$pl age = Translations$sessions$age$pl._(_root);
	@override late final Translations$sessions$activity$pl activity = Translations$sessions$activity$pl._(_root);
	@override String get autoMini => 'Auto (mini)';
}

// Path: sharedContext
class Translations$sharedContext$pl extends Translations$sharedContext$en {
	Translations$sharedContext$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Współdzielone notatki';
}

// Path: skills
class Translations$skills$pl extends Translations$skills$en {
	Translations$skills$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String moveSkill({required Object name}) => 'Przenieś ${name}';
	@override String deleteSkill({required Object name}) => 'Usuń ${name}';
	@override String get projectLabel => 'Projekt';
	@override late final Translations$skills$addDialog$pl addDialog = Translations$skills$addDialog$pl._(_root);
	@override late final Translations$skills$moveDialog$pl moveDialog = Translations$skills$moveDialog$pl._(_root);
	@override late final Translations$skills$screen$pl screen = Translations$skills$screen$pl._(_root);
	@override late final Translations$skills$empty$pl empty = Translations$skills$empty$pl._(_root);
	@override late final Translations$skills$scopes$pl scopes = Translations$skills$scopes$pl._(_root);
	@override late final Translations$skills$errors$pl errors = Translations$skills$errors$pl._(_root);
	@override String get providerShared => 'Wspólne';
}

// Path: terminal
class Translations$terminal$pl extends Translations$terminal$en {
	Translations$terminal$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$tabs$pl tabs = Translations$terminal$tabs$pl._(_root);
	@override late final Translations$terminal$actions$pl actions = Translations$terminal$actions$pl._(_root);
	@override late final Translations$terminal$authUrl$pl authUrl = Translations$terminal$authUrl$pl._(_root);
	@override late final Translations$terminal$fileLink$pl fileLink = Translations$terminal$fileLink$pl._(_root);
	@override late final Translations$terminal$shortcuts$pl shortcuts = Translations$terminal$shortcuts$pl._(_root);
	@override late final Translations$terminal$paste$pl paste = Translations$terminal$paste$pl._(_root);
	@override late final Translations$terminal$errors$pl errors = Translations$terminal$errors$pl._(_root);
	@override late final Translations$terminal$loginDialog$pl loginDialog = Translations$terminal$loginDialog$pl._(_root);
	@override late final Translations$terminal$empty$pl empty = Translations$terminal$empty$pl._(_root);
	@override late final Translations$terminal$overlay$pl overlay = Translations$terminal$overlay$pl._(_root);
}

// Path: voice
class Translations$voice$pl extends Translations$voice$en {
	Translations$voice$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get preview => 'Podgląd';
	@override String get settingsSaved => 'Zapisano ustawienia wprowadzania głosowego';
	@override String get saveFailed => 'Nie udało się zapisać konfiguracji STT';
	@override String get apiKeySaved => 'Klucz API (zapisany, wpisz nowy, aby zastąpić)';
}

// Path: workspace
class Translations$workspace$pl extends Translations$workspace$en {
	Translations$workspace$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get exportChat => 'Eksportuj czat';
	@override String get searchTranscript => 'Szukaj w transkrypcji';
	@override String get previousMatch => 'Poprzednie dopasowanie';
	@override String get nextMatch => 'Następne dopasowanie';
	@override String get closeSearch => 'Zamknij wyszukiwanie';
	@override String get newChatProvider => 'Nowy czat — dostawca';
	@override String get closePane => 'Zamknij panel';
	@override String get jumpToSession => 'Przejdź do sesji…';
	@override String get archivedWorkspaceName => 'Zarchiwizowane';
	@override String sendTo({required Object count}) => 'Wyślij do ${count}';
	@override String get deleteSessionNotice => 'Usuwa sesję i jej transkrypt. Tej operacji nie można cofnąć.';
	@override String accountWithLabel({required Object label}) => 'Domyślne · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Zakończ przebieg przed zmianą obszaru roboczego';
	@override String get restored => 'Przywrócono obszar roboczy';
	@override String get maximizePane => 'Maksymalizuj panel';
	@override String get restorePanes => 'Przywróć panele';
	@override String get reviewChangedFiles => 'Przejrzyj zmienione pliki';
	@override late final Translations$workspace$paneTitle$pl paneTitle = Translations$workspace$paneTitle$pl._(_root);
	@override String get addEditorPane => 'Dodaj panel edytora';
	@override String get addGitPane => 'Dodaj panel Git';
	@override String get unknownProjectPath => 'Nieznana ścieżka projektu';
	@override String get autoMini => 'Auto (mini)';
	@override String get exportAs => 'Eksportuj jako:';
	@override String get exportMarkdown => 'Markdown (.md)';
	@override String get exportHtml => 'Strona WWW (.html)';
	@override String get exportPdf => 'PDF (drukuj do pliku)';
	@override String matchPosition({required Object current, required Object total}) => '${current} z ${total}';
	@override String get launcherDescription => 'Wybierz obszar roboczy dla tego panelu lub utwórz nowy.';
	@override String get createWorkspace => 'Utwórz obszar roboczy';
}

// Path: worktrees
class Translations$worktrees$pl extends Translations$worktrees$en {
	Translations$worktrees$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get scripts => 'Skrypty';
	@override String get emptyTitle => 'Nie znaleziono worktree';
	@override String get emptyDescription => 'Utwórz worktree, aby odizolować pracę nad funkcją lub uruchomienia agentów.';
	@override String opened({required Object branch}) => 'Otwarto worktree: ${branch}';
	@override String get created => 'Utworzono worktree';
	@override String get removed => 'Usunięto worktree';
	@override String merged({required Object branch}) => 'Worktree scalony do ${branch}';
	@override String get scriptsSaved => 'Zapisano konfigurację skryptów';
	@override String get setupLabel => 'Setup: ';
	@override String get serverLabel => 'Serwer: ';
	@override String get runRunning => 'działa';
	@override String runRunningWithPort({required Object port}) => 'działa :${port}';
	@override String get runButton => 'Uruchom';
	@override String get stopButton => 'Zatrzymaj';
	@override String get mainBadge => 'main';
	@override String headDetachedAt({required Object sha}) => 'HEAD odczepiony na ${sha}';
	@override String get branchHint => 'Nazwa nowej gałęzi (np. feature/login)';
	@override String branchingOff({required Object branch}) => 'Odgałęzienie od ${branch}';
	@override String mergeTitle({required Object branch}) => 'Scal ${branch}';
	@override String mergeDescription({required Object branch}) => 'Scal zmiany do ${branch}.';
	@override String get squashDescription => 'Połącz wszystkie commity w jeden commit';
	@override String get cleanupDescription => 'Usuń worktree i skasuj gałąź po scaleniu';
	@override String removeTitle({required Object branch}) => 'Usunąć worktree ${branch}?';
	@override String get removeDescription => 'Spowoduje to usunięcie folderu worktree. Powiązane projekty zostaną zarchiwizowane.';
	@override String dirtyWarning({required Object count}) => 'Uwaga: ten worktree ma ${count} niezatwierdzonych zmian, które zostaną utracone.';
	@override String get forceRemoveLabel => 'Wymuś usunięcie (odrzuć zmiany)';
	@override String get deleteBranchLabel => 'Usuń także gałąź';
	@override String get setupHint => 'Polecenie setup (np. npm install)';
	@override String get runHint => 'Polecenie uruchomienia (np. npm run dev)';
	@override String get portHint => 'Port uruchomienia (opcjonalnie, np. 3000)';
	@override String get unknownSha => 'nieznany';
	@override String get baseBranchFallback => 'gałąź bazowa';
	@override late final Translations$worktrees$runtimeStatus$pl runtimeStatus = Translations$worktrees$runtimeStatus$pl._(_root);
}

// Path: browserUse
class Translations$browserUse$pl extends Translations$browserUse$en {
	Translations$browserUse$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$browserUse$sessionStatus$pl sessionStatus = Translations$browserUse$sessionStatus$pl._(_root);
}

// Path: orchestrator
class Translations$orchestrator$pl extends Translations$orchestrator$en {
	Translations$orchestrator$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String stepFallback({required Object n}) => 'Krok ${n}';
}

// Path: miniOrchestrator
class Translations$miniOrchestrator$pl extends Translations$miniOrchestrator$en {
	Translations$miniOrchestrator$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$miniOrchestrator$taskTypes$pl taskTypes = Translations$miniOrchestrator$taskTypes$pl._(_root);
	@override late final Translations$miniOrchestrator$roles$pl roles = Translations$miniOrchestrator$roles$pl._(_root);
}

// Path: auth.login
class Translations$auth$login$pl extends Translations$auth$login$en {
	Translations$auth$login$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Witaj ponownie';
	@override String get description => 'Zaloguj się do swojego samodzielnie hostowanego konta DDAgent';
	@override String get username => 'Nazwa użytkownika';
	@override String get password => 'Hasło';
	@override String get submit => 'Zaloguj się';
	@override String get loading => 'Logowanie...';
	@override late final Translations$auth$login$errors$pl errors = Translations$auth$login$errors$pl._(_root);
	@override late final Translations$auth$login$placeholders$pl placeholders = Translations$auth$login$placeholders$pl._(_root);
}

// Path: auth.register
class Translations$auth$register$pl extends Translations$auth$register$en {
	Translations$auth$register$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Utwórz konto';
	@override String get username => 'Nazwa użytkownika';
	@override String get password => 'Hasło';
	@override String get confirmPassword => 'Potwierdź hasło';
	@override String get submit => 'Utwórz konto';
	@override String get loading => 'Tworzenie konta...';
	@override late final Translations$auth$register$errors$pl errors = Translations$auth$register$errors$pl._(_root);
}

// Path: auth.logout
class Translations$auth$logout$pl extends Translations$auth$logout$en {
	Translations$auth$logout$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wyloguj się';
	@override String get confirm => 'Czy na pewno chcesz się wylogować?';
	@override String get button => 'Wyloguj się';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$pl extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Kopiuj';
	@override String get copied => 'Skopiowano';
	@override String get copyCode => 'Kopiuj kod';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$pl extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Kopiuj wiadomość';
	@override String get copied => 'Wiadomość skopiowana';
	@override String get failed => 'Nie udało się skopiować';
	@override String get selectFormat => 'Wybierz format kopiowania';
	@override String get copyAsMarkdown => 'Kopiuj jako markdown';
	@override String get copyAsText => 'Kopiuj jako tekst';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$pl extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => 'Błąd';
	@override String get tool => 'Narzędzie';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
	@override String get orchestrator => 'Auto';
}

// Path: chat.orchestrator
class Translations$chat$orchestrator$pl extends Translations$chat$orchestrator$en {
	Translations$chat$orchestrator$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$orchestrator$routing$pl routing = Translations$chat$orchestrator$routing$pl._(_root);
	@override late final Translations$chat$orchestrator$plan$pl plan = Translations$chat$orchestrator$plan$pl._(_root);
	@override late final Translations$chat$orchestrator$decision$pl decision = Translations$chat$orchestrator$decision$pl._(_root);
	@override late final Translations$chat$orchestrator$delegation$pl delegation = Translations$chat$orchestrator$delegation$pl._(_root);
	@override late final Translations$chat$orchestrator$summary$pl summary = Translations$chat$orchestrator$summary$pl._(_root);
	@override String get backToParent => 'Wróć do orkiestracji';
	@override late final Translations$chat$orchestrator$taskmaster$pl taskmaster = Translations$chat$orchestrator$taskmaster$pl._(_root);
	@override late final Translations$chat$orchestrator$gate$pl gate = Translations$chat$orchestrator$gate$pl._(_root);
}

// Path: chat.tools
class Translations$chat$tools$pl extends Translations$chat$tools$en {
	Translations$chat$tools$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Ustawienia narzędzia';
	@override String get error => 'Błąd narzędzia';
	@override String get result => 'Wynik narzędzia';
	@override String get viewParams => 'Wyświetl parametry wejściowe';
	@override String get viewRawParams => 'Wyświetl surowe parametry';
	@override String get viewDiff => 'Wyświetl diff edycji dla';
	@override String get creatingFile => 'Tworzenie nowego pliku:';
	@override String get updatingTodo => 'Aktualizowanie listy zadań';
	@override String get read => 'Odczyt';
	@override String get readFile => 'Odczytaj plik';
	@override String get updateTodo => 'Aktualizuj listę zadań';
	@override String get readTodo => 'Odczytaj listę zadań';
	@override String get searchResults => 'wyników';
	@override String get todoReadLabel => 'TodoRead — odczyt listy zadań';
}

// Path: chat.search
class Translations$chat$search$pl extends Translations$chat$search$en {
	Translations$chat$search$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => 'Znaleziono ${count} ${type}';
	@override String get file => 'plik';
	@override String get files => 'pliki';
	@override String get pattern => 'wzorzec:';
	@override String get kIn => 'w:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$pl extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Plik pomyślnie zaktualizowany';
	@override String get created => 'Plik pomyślnie utworzony';
	@override String get written => 'Plik pomyślnie zapisany';
	@override String get diff => 'Diff';
	@override String get newFile => 'Nowy plik';
	@override String get viewContent => 'Wyświetl zawartość pliku';
	@override String viewFullOutput({required Object count}) => 'Wyświetl pełne wyjście (${count} znaków)';
	@override String get contentDisplayed => 'Zawartość pliku jest wyświetlana w powyższym widoku diff';
}

// Path: chat.interactive
class Translations$chat$interactive$pl extends Translations$chat$interactive$en {
	Translations$chat$interactive$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Interaktywny prompt';
	@override String get waiting => 'Oczekiwanie na Twoją odpowiedź w CLI';
	@override String get instruction => 'Wybierz opcję w terminalu, w którym uruchomiony jest Claude.';
	@override String selectedOption({required Object number}) => '✓ Claude wybrał opcję ${number}';
	@override String get instructionDetail => 'W CLI tę opcję wybiera się interaktywnie za pomocą klawiszy strzałek lub wpisując numer.';
}

// Path: chat.thinking
class Translations$chat$thinking$pl extends Translations$chat$thinking$en {
	Translations$chat$thinking$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Myślenie...';
	@override String get emoji => '💭 Myślenie...';
	@override String get thoughtFewSeconds => 'Myślał przez kilka sekund';
}

// Path: chat.json
class Translations$chat$json$pl extends Translations$chat$json$en {
	Translations$chat$json$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get response => 'Odpowiedź JSON';
}

// Path: chat.permissions
class Translations$chat$permissions$pl extends Translations$chat$permissions$en {
	Translations$chat$permissions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => 'Nadaj uprawnienia dla ${tool}';
	@override String get added => 'Dodano uprawnienie';
	@override String addTo({required Object entry}) => 'Dodaje ${entry} do dozwolonych narzędzi.';
	@override String get retry => 'Uprawnienie zapisane. Ponów żądanie, aby użyć narzędzia.';
	@override String get error => 'Nie można zaktualizować uprawnień. Spróbuj ponownie.';
	@override String get openSettings => 'Otwórz ustawienia';
	@override String get allow => 'Zezwól';
	@override String get always => 'Zawsze';
	@override String get editAndAllow => 'Edytuj i zezwól';
	@override String get deny => 'Odmów';
	@override String get reject => 'Odrzuć';
	@override String allowAll({required Object count}) => 'Zezwól na wszystko (${count})';
	@override String get editInput => 'Edytuj dane wejściowe';
	@override String get invalidJson => 'Nieprawidłowy JSON';
	@override String get allowWithChanges => 'Zezwól ze zmianami';
	@override String get alwaysDeny => 'Zawsze odmawiaj';
	@override String get denyFeedbackTitle => 'Odrzuć plan';
	@override String get denyFeedbackHint => 'Co agent powinien zmienić? (opcjonalnie)';
	@override String get modeAppliesNextMessage => 'Nowy tryb uprawnień zacznie obowiązywać od następnej wiadomości.';
}

// Path: chat.todo
class Translations$chat$todo$pl extends Translations$chat$todo$en {
	Translations$chat$todo$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Lista zadań została pomyślnie zaktualizowana';
	@override String get current => 'Aktualna lista zadań';
}

// Path: chat.plan
class Translations$chat$plan$pl extends Translations$chat$plan$en {
	Translations$chat$plan$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Wyświetl plan implementacji';
	@override String get title => 'Plan implementacji';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$pl extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Osiągnięto limit użycia Claude. Limit zostanie zresetowany o **${time} ${timezone}** - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$pl extends Translations$chat$codex$en {
	Translations$chat$codex$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Tryb uprawnień';
	@override late final Translations$chat$codex$modes$pl modes = Translations$chat$codex$modes$pl._(_root);
	@override late final Translations$chat$codex$descriptions$pl descriptions = Translations$chat$codex$descriptions$pl._(_root);
	@override String get technicalDetails => 'Szczegóły techniczne';
}

// Path: chat.voice
class Translations$chat$voice$pl extends Translations$chat$voice$en {
	Translations$chat$voice$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Czytaj odpowiedzi na głos';
	@override String get autoReadOn => 'Czytanie odpowiedzi: włączone';
	@override String get autoReadOff => 'Czytanie odpowiedzi: wyłączone';
	@override String get autoReadVoice => 'Głos czytania';
	@override String get autoReadVoiceAuto => 'Głos automatyczny';
	@override String get autoReadPreview => 'Tak będą brzmiały odpowiedzi.';
	@override String get speakMessage => 'Czytaj na głos';
	@override String get stopSpeaking => 'Zatrzymaj czytanie';
}

// Path: chat.input
class Translations$chat$input$pl extends Translations$chat$input$en {
	Translations$chat$input$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Wpisz / dla poleceń, @ dla plików lub zapytaj ${provider} o cokolwiek...';
	@override String get placeholderDefault => 'Wpisz swoją wiadomość...';
	@override String get disabled => 'Wprowadzanie wyłączone';
	@override String get attachFiles => 'Załącz pliki';
	@override String get attachFilesDesc => 'Prześlij zdjęcia, pliki lub dokumenty';
	@override String get takePhoto => 'Zrób zdjęcie';
	@override String get takePhotoDesc => 'Użyj aparatu, aby zrobić zdjęcie';
	@override String get moreTools => 'Więcej narzędzi';
	@override String get commandsDesc => 'Komendy i skróty';
	@override String get clearInputDesc => 'Wyczyść wpisany tekst';
	@override String get attachImages => 'Załącz obrazy';
	@override String get send => 'Wyślij';
	@override String get stop => 'Zatrzymaj';
	@override late final Translations$chat$input$hintText$pl hintText = Translations$chat$input$hintText$pl._(_root);
	@override String get clickToChangeMode => 'Kliknij, aby zmienić tryb uprawnień';
	@override String get showAllCommands => 'Pokaż wszystkie polecenia';
	@override String get clearInput => 'Wyczyść pole';
	@override String get scrollToBottom => 'Przewiń na dół';
	@override String get newMessage => 'Nowa wiadomość';
	@override String get newMessages => 'Nowe wiadomości';
	@override late final Translations$chat$input$queue$pl queue = Translations$chat$input$queue$pl._(_root);
	@override String get autoContinueTasks => 'Auto-kontynuacja';
	@override String get autoContinueTasksTooltip => 'Włącz, by Devin automatycznie przechodził do kolejnych zadań Task Mastera';
	@override late final Translations$chat$input$offlineQueue$pl offlineQueue = Translations$chat$input$offlineQueue$pl._(_root);
	@override String get voice => 'Wprowadzanie głosowe';
	@override String get voiceStart => 'Dyktuj wiadomość';
	@override String get voiceStop => 'Zatrzymaj dyktowanie';
	@override String get pinFile => 'Przypnij plik do kontekstu';
	@override String get voiceSettings => 'Ustawienia głosu (STT)';
	@override String cameraUnavailable({required Object error}) => 'Aparat niedostępny: ${error}';
}

// Path: chat.composer
class Translations$chat$composer$pl extends Translations$chat$composer$en {
	Translations$chat$composer$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Narzędzia i akcje';
	@override String get toolsAndActionsDesc => 'Narzędzia i akcje dla pola wiadomości';
	@override String get reasoning => 'Rozumowanie';
	@override String get model => 'Model';
	@override String get effortDefault => 'Domyślny';
	@override String get loadingModels => 'Wczytywanie modeli…';
	@override String get modelMenu => 'Wybierz model i poziom rozumowania';
	@override String permissionHeading({required Object provider}) => 'Jak mają być zatwierdzane działania ${provider}?';
	@override String get favorites => 'Ulubione';
	@override String get account => 'Konto';
	@override String get accountMenu => 'Wybierz konto';
	@override String get accountDefault => 'Konto domyślne';
	@override String get accountAuto => 'Automatycznie (domyślne)';
	@override String get accountIsDefault => 'Domyślne';
	@override late final Translations$chat$composer$effortLevels$pl effortLevels = Translations$chat$composer$effortLevels$pl._(_root);
	@override String contextWindow({required Object size}) => 'kontekst ${size}';
	@override String get accountAutoShort => 'Automatycznie';
	@override String get uploadNoRecords => 'Przesyłanie nie zwróciło żadnych plików';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$pl extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wybierz swojego asystenta AI';
	@override String get description => 'Wybierz dostawcę, aby rozpocząć nową rozmowę';
	@override String get selectModel => 'Wybierz model';
	@override String get workspace => 'Obszar roboczy';
	@override String get noWorkspace => 'Brak';
	@override String get clickToChangeWorkspace => 'Kliknij, aby zmienić obszar roboczy';
	@override String get chooseWorkspace => 'Wybierz obszar roboczy';
	@override String get searchWorkspaces => 'Szukaj obszarów roboczych...';
	@override String get noWorkspacesFound => 'Nie znaleziono obszarów roboczych.';
	@override late final Translations$chat$providerSelection$providerInfo$pl providerInfo = Translations$chat$providerSelection$providerInfo$pl._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$pl readyPrompt = Translations$chat$providerSelection$readyPrompt$pl._(_root);
	@override String get autoGroup => 'Auto';
	@override String get autoLabel => 'Auto (orkiestrowane)';
	@override String get autoDescription => 'Kieruje każdy krok do najlepszego dostępnego dostawcy i modelu';
	@override String get orchestrated => 'orkiestrowane';
	@override String pressToSearch({required Object shortcut}) => 'Naciśnij <kbd>${shortcut}</kbd>, aby wyszukiwać sesje, pliki i commity';
	@override String get all => 'Wszystkie';
	@override String get free => 'Darmowe';
	@override String get noModelsFound => 'Nie znaleziono modeli.';
	@override String get paid => 'Płatne';
	@override String get searchModels => 'Szukaj modeli...';
	@override String get addModel => 'Dodaj model';
	@override String get chooseModel => 'Wybierz model';
	@override String get chooseModelDescription => 'Wbudowane i niestandardowe modele na jednej liście';
	@override String get clickToChange => 'Kliknij, aby zmienić model';
	@override String get favorites => 'Ulubione';
	@override String get loadingModels => 'Ładowanie modeli…';
	@override String get manageModels => 'Zarządzaj modelami';
	@override String get refresh => 'Odśwież modele';
}

// Path: chat.session
class Translations$chat$session$pl extends Translations$chat$session$en {
	Translations$chat$session$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$pl kContinue = Translations$chat$session$kContinue$pl._(_root);
	@override late final Translations$chat$session$loading$pl loading = Translations$chat$session$loading$pl._(_root);
	@override late final Translations$chat$session$messages$pl messages = Translations$chat$session$messages$pl._(_root);
	@override String get deleteConfirm => 'Usuwa sesję i jej transkrypt. Tej operacji nie można cofnąć.';
	@override String get finishRunBeforeWorkspaceChange => 'Zakończ przebieg przed zmianą obszaru roboczego';
	@override String get fallbackTitle => 'Sesja';
}

// Path: chat.shell
class Translations$chat$shell$pl extends Translations$chat$shell$en {
	Translations$chat$shell$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$pl selectProject = Translations$chat$shell$selectProject$pl._(_root);
	@override late final Translations$chat$shell$status$pl status = Translations$chat$shell$status$pl._(_root);
	@override late final Translations$chat$shell$actions$pl actions = Translations$chat$shell$actions$pl._(_root);
	@override String get loading => 'Wczytywanie terminala...';
	@override String get connecting => 'Łączenie z shellem...';
	@override String get startSession => 'Rozpocznij nową sesję agenta';
	@override String resumeSession({required Object displayName}) => 'Wznów sesję: ${displayName}...';
	@override String runCommand({required Object command, required Object projectName}) => 'Uruchom ${command} w ${projectName}';
	@override String startCli({required Object projectName}) => 'Uruchamianie CLI agenta w ${projectName}';
	@override String get defaultCommand => 'polecenie';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$pl extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$pl actions = Translations$chat$claudeStatus$actions$pl._(_root);
	@override late final Translations$chat$claudeStatus$state$pl state = Translations$chat$claudeStatus$state$pl._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$pl elapsed = Translations$chat$claudeStatus$elapsed$pl._(_root);
	@override String get stop => 'Zatrzymaj';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} zadanie w tle w toku',
		few: '${count} zadania w tle w toku',
		many: '${count} zadań w tle w toku',
		other: '${count} zadania w tle w toku',
	);
	@override late final Translations$chat$claudeStatus$controls$pl controls = Translations$chat$claudeStatus$controls$pl._(_root);
	@override late final Translations$chat$claudeStatus$providers$pl providers = Translations$chat$claudeStatus$providers$pl._(_root);
	@override String get backgroundTasksTitle => 'Działa w tle';
	@override String get backgroundTaskUnnamed => 'Zadanie bez nazwy';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$pl extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'Wybierz projekt, aby rozpocząć rozmowę z ${provider}';
}

// Path: chat.tasks
class Translations$chat$tasks$pl extends Translations$chat$tasks$en {
	Translations$chat$tasks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Rozpocznij następne zadanie';
}

// Path: chat.splitSession
class Translations$chat$splitSession$pl extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Podziel widok sesji';
	@override String get close => 'Zamknij podzielony widok sesji';
	@override String get selectSession => 'Wybierz sesję z listy bieżących';
	@override String get noOtherSessions => 'Brak innych dostępnych sesji';
	@override String get newSessionOption => '+ Nowa sesja w drugim oknie';
	@override String currentProjectGroup({required Object name}) => 'Bieżący projekt (${name})';
	@override String get otherProjectsGroup => 'Inne projekty';
	@override String get recentSessionsGroup => 'Ostatnie sesje';
	@override String get startNewSession => 'Rozpocznij nową sesję w widoku podzielonym';
	@override String get selectFromList => 'Wybierz sesję z listy bieżących';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$pl extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wybierz sesję';
	@override String get searchPlaceholder => 'Szukaj sesji...';
	@override String get clearSearch => 'Wyczyść wyszukiwanie';
	@override String get newChat => '+ Nowy czat';
	@override String get archivedToggle => 'Zarchiwizowane';
	@override String get changeSession => 'Zmień sesję';
	@override String get archivedLoading => 'Wczytywanie zarchiwizowanych sesji...';
	@override String get archivedError => 'Nie udało się wczytać zarchiwizowanych sesji';
	@override String get archivedEmpty => 'Brak zarchiwizowanych sesji';
	@override String get archivedProjectOnly => 'Workspace zarchiwizowany — przywróć go, aby zobaczyć jego sesje.';
	@override String get emptySearch => 'Brak sesji pasujących do wyszukiwania';
	@override String get restore => 'Przywróć';
	@override String get restoreSession => 'Przywróć sesję';
	@override String get restoreProject => 'Przywróć workspace';
	@override String get restoreSessionFailed => 'Nie udało się przywrócić sesji. Spróbuj ponownie.';
	@override String get restoreProjectFailed => 'Nie udało się przywrócić workspace\'a. Spróbuj ponownie.';
	@override String get archiveFailed => 'Nie udało się zarchiwizować sesji. Spróbuj ponownie.';
	@override String get deleteFailed => 'Nie udało się usunąć sesji. Spróbuj ponownie.';
	@override String get running => 'Sesja jest uruchomiona';
	@override String get unread => 'Nieprzeczytana — zakończona z nową odpowiedzią';
	@override String get account => 'Konto';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$pl extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Dodaj panel czatu';
	@override String get addBrowser => 'Dodaj panel przeglądarki';
	@override String get addTerminal => 'Dodaj panel terminala';
	@override String get addPreview => 'Dodaj panel podglądu';
	@override String get overview => 'Pokaż wszystkie panele';
	@override String get exitFocusMode => 'Wyjdź z trybu skupienia (Ctrl+Shift+F)';
	@override String get focusMode => 'Tryb skupienia (Ctrl+Shift+F)';
	@override String get broadcast => 'Wyślij do wielu sesji';
	@override String get addNotes => 'Dodaj panel notatek współdzielonych';
	@override String get browseSessions => 'Otwórz listę sesji';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$pl extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Przegląd paneli';
	@override String count({required Object count}) => '${count} paneli';
	@override String get close => 'Zamknij przegląd';
	@override String get question => 'PYTANIE — wymagane działanie';
	@override String get processing => 'PRZETWARZANIE';
	@override String get idle => 'Bezczynny';
	@override String get active => 'Aktywna';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$pl extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} potrzebuje Twojej odpowiedzi';
	@override String get skip => 'Pomiń';
	@override String get other => 'Inne…';
	@override String get answerHint => 'Wpisz swoją odpowiedź…';
}

// Path: chat.attachments
class Translations$chat$attachments$pl extends Translations$chat$attachments$en {
	Translations$chat$attachments$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Pobieranie nie powiodło się — kliknij, aby ponowić';
	@override String get fileAttachment => 'Załącznik pliku';
	@override String download({required Object name}) => 'Pobierz ${name}';
	@override String get attachedFile => 'Załączony plik';
	@override String downloaded({required Object name}) => 'Pobrano ${name}';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$pl extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Tworzenie migawki…';
	@override String get revertChanges => 'Przywróć pliki do ostatniego punktu kontrolnego';
	@override String get undo => 'Cofnij punkt kontrolny';
	@override String get undoAiRun => 'Cofnij przebieg AI';
	@override String get undoing => 'Cofiwanie…';
	@override String get undone => 'Cofnięto';
	@override String get beforeAiTurn => 'przed turą AI';
}

// Path: chat.common
class Translations$chat$common$pl extends Translations$chat$common$en {
	Translations$chat$common$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get close => 'Zamknij';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$pl extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Zadanie';
	@override String get saved => 'Zapisano';
	@override String get saving => 'Zapisywanie...';
	@override String get taskShort => 'TASK';
	@override String get addToTask => 'Dodaj do TaskMaster';
	@override String get added => 'Dodano do TaskMaster';
	@override String get defaultTaskTitle => 'Zadanie z czatu';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$pl extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Zobacz zużycie tokenów w sesji';
	@override String get title => 'Zużycie tokenów';
	@override String get notAvailable => 'b.d.';
	@override String tokensBadge({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} token',
		few: '${count} tokeny',
		many: '${count} tokenów',
		other: '${count} tokena',
	);
}

// Path: chat.tool
class Translations$chat$tool$pl extends Translations$chat$tool$en {
	Translations$chat$tool$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(brak wyjścia — narzędzie zwróciło pusty wynik)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$pl extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Limity subskrypcji';
	@override String get noData => 'Brak danych o subskrypcji dla tego modelu';
	@override String get noSubscription => 'brak subskrypcji';
	@override String windowLineReset({required Object label, required Object percent, required Object time}) => '${label}: ${percent}% · reset ${time}';
	@override String windowRemaining({required Object percent}) => 'Do resetu zostało ${percent}% okna';
}

// Path: chat.broadcast
class Translations$chat$broadcast$pl extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wyślij do wielu sesji';
	@override String get noSessions => 'Brak dostępnych sesji';
	@override String get placeholder => 'Wiadomość dla wszystkich zaznaczonych sesji…';
	@override String partial({required Object count}) => '${count} sesji odrzuciło wiadomość';
	@override String sent({required Object count}) => 'W kolejce dla ${count} sesji';
	@override String get selectAll => 'Zaznacz wszystkie';
	@override String get selectOrchestrators => 'Zaznacz orchestratory';
	@override String get orchestratorsOnly => 'Tylko orchestratory';
	@override String get noOrchestrators => 'Brak dostępnych sesji orchestratora';
	@override String get sending => 'Wysyłanie…';
	@override String send({required Object count}) => 'Wyślij do ${count}';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$pl extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Przetwarzanie…';
	@override String get switchSession => 'Zmień sesję';
}

// Path: chat.export
class Translations$chat$export$pl extends Translations$chat$export$en {
	Translations$chat$export$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Sesja ${id}';
	@override String get pdfFailed => 'Eksport PDF nie powiódł się';
	@override String get transcriptDownloaded => 'Pobrano transkrypt';
	@override String savedTo({required Object path}) => 'Zapisano ${path}';
}

// Path: chat.commandResult
class Translations$chat$commandResult$pl extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$pl fallback = Translations$chat$commandResult$fallback$pl._(_root);
	@override String get filterCommands => 'Filtruj polecenia...';
	@override String searchModels({required Object provider}) => 'Szukaj modeli ${provider}...';
}

// Path: chat.commands
class Translations$chat$commands$pl extends Translations$chat$commands$en {
	Translations$chat$commands$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'Uruchomić polecenie?';
	@override String get executionCancelled => 'Anulowano wykonywanie polecenia';
	@override String get bashConfirmMessage => 'To polecenie zawiera polecenia bash, które zostaną wykonane. Czy chcesz kontynuować?';
	@override String get proceed => 'Kontynuuj';
}

// Path: chat.pinFile
class Translations$chat$pinFile$pl extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Przypnij plik';
	@override String get pathHint => 'path/to/file.ext';
	@override String get action => 'Przypnij';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$pl extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String editTooltip({required Object name}) => 'Edytuj ${name}';
	@override String deleteTooltip({required Object name}) => 'Usuń ${name}';
	@override String get enterNameAndId => 'Podaj zarówno nazwę modelu, jak i identyfikator modelu.';
	@override String get idNoSpaces => 'Identyfikatory modeli nie mogą zawierać spacji.';
	@override String get setAsDefault => 'Ustaw jako domyślne';
	@override String get defaultModel => 'Domyślny model';
	@override String get title => 'Biblioteka modeli';
	@override String get subtitle => 'Dodaj identyfikatory modeli obsługiwane przez dostawcę. Modele wbudowane pozostają zablokowane. Kółko oznacza model domyślny.';
	@override String get yourModels => 'Twoje modele';
	@override String get yourModelsHint => 'Edytowalne, przechowywane w auth.db';
	@override String get emptyTitle => 'Brak własnych modeli';
	@override String get emptyHint => 'Dodaj model za pomocą formularza, a pojawi się w każdym selektorze modeli.';
	@override String get builtInModels => 'Modele wbudowane';
	@override String get builtInModelsHint => 'Utrzymywane przez DDAgent, tylko do odczytu';
	@override String get editTitle => 'Edytuj własny model';
	@override String get addTitle => 'Dodaj własny model';
	@override String idSentAsWritten({required Object provider}) => 'Identyfikator jest wysyłany do ${provider} dokładnie w tej postaci.';
	@override String get nameLabel => 'Nazwa modelu';
	@override String get nameHint => 'np. GPT-5.5 Pro';
	@override String get idLabel => 'Identyfikator modelu';
	@override String get idHint => 'np. gpt-5.5-pro';
	@override String get idHelp => 'Użyj dokładnie tego identyfikatora, który akceptuje CLI dostawcy. Identyfikatory nie mogą zawierać spacji.';
	@override String updatedNotice({required Object name}) => 'Zaktualizowano ${name}.';
	@override String addedNotice({required Object name}) => 'Dodano ${name}.';
	@override String deletedNotice({required Object name}) => 'Usunięto ${name}.';
	@override String get saving => 'Zapisywanie…';
	@override String get saveChanges => 'Zapisz zmiany';
	@override String get deleteConfirm => 'Usunąć ten model ze wszystkich selektorów?';
	@override String get customBadge => 'Własny';
}

// Path: chat.changes
class Translations$chat$changes$pl extends Translations$chat$changes$en {
	Translations$chat$changes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get failedToLoad => 'Nie udało się wczytać zmian';
	@override String get empty => 'Brak zmian w plikach';
}

// Path: chat.message
class Translations$chat$message$pl extends Translations$chat$message$en {
	Translations$chat$message$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Skrócone podsumowanie';
	@override String get resendHint => 'Wyślij ponownie z pola wiadomości';
	@override String get rawView => 'Widok surowy';
	@override String get runComplete => 'Przebieg zakończony';
	@override String get runStopped => 'Zatrzymano';
	@override String runFailed({required Object code}) => 'Uruchomienie nie powiodło się (kod ${code})';
	@override String get taskKilled => 'Przerwane';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$pl extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'Prośba o uprawnienie · ${tool}';
	@override String get question => 'Pytanie';
	@override String get subagent => 'Subagent';
	@override String get viewersCannotApprove => 'Obserwatorzy nie mogą zatwierdzać';
	@override late final Translations$chat$permissionRequest$recap$pl recap = Translations$chat$permissionRequest$recap$pl._(_root);
	@override String needsApproval({required Object tool}) => '${tool} wymaga zatwierdzenia';
	@override String subagentNeedsApproval({required Object tool}) => 'Subagent: ${tool} wymaga zatwierdzenia';
	@override String moreQuestions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Czeka jeszcze ${count} pytanie',
		few: 'Czekają jeszcze ${count} pytania',
		many: 'Czeka jeszcze ${count} pytań',
		other: 'Czeka jeszcze ${count} pytania',
	);
}

// Path: chat.commandDialog
class Translations$chat$commandDialog$pl extends Translations$chat$commandDialog$en {
	Translations$chat$commandDialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandDialog$help$pl help = Translations$chat$commandDialog$help$pl._(_root);
	@override late final Translations$chat$commandDialog$models$pl models = Translations$chat$commandDialog$models$pl._(_root);
	@override late final Translations$chat$commandDialog$cost$pl cost = Translations$chat$commandDialog$cost$pl._(_root);
	@override late final Translations$chat$commandDialog$status$pl status = Translations$chat$commandDialog$status$pl._(_root);
	@override String get defaultEyebrow => 'Polecenie';
	@override String get defaultTitle => 'Wynik polecenia';
	@override String get escHint => 'Esc zamyka to okno.';
	@override String get unknown => 'Nieznany';
	@override String get noDescription => 'Brak opisu.';
	@override String get noCommandsMatch => 'Żadne polecenie nie pasuje do tego filtra.';
	@override late final Translations$chat$commandDialog$syntax$pl syntax = Translations$chat$commandDialog$syntax$pl._(_root);
	@override String get commandFinished => 'Polecenie zakończone.';
}

// Path: chat.utilities
class Translations$chat$utilities$pl extends Translations$chat$utilities$en {
	Translations$chat$utilities$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get tokenUsageUnavailable => 'Zużycie tokenów jest niedostępne';
	@override late final Translations$chat$utilities$tooltip$pl tooltip = Translations$chat$utilities$tooltip$pl._(_root);
	@override String get used => 'Użyte';
	@override String get cacheWrite => 'Cache (zapis)';
	@override String get contextLabel => 'Kontekst';
	@override String get usageUnsupported => 'zużycie nieobsługiwane';
	@override String get chatTranscript => 'Zapis czatu';
	@override String get you => 'Ty:';
	@override String get providerAutoMini => 'Auto (mini)';
}

// Path: chat.toolBlocks
class Translations$chat$toolBlocks$pl extends Translations$chat$toolBlocks$en {
	Translations$chat$toolBlocks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String moreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '… jeszcze ${count} wiersz',
		few: '… jeszcze ${count} wiersze',
		many: '… jeszcze ${count} wierszy',
		other: '… jeszcze ${count} wiersza',
	);
	@override late final Translations$chat$toolBlocks$status$pl status = Translations$chat$toolBlocks$status$pl._(_root);
	@override String get showLess => 'Pokaż mniej';
	@override String get showMore => 'Pokaż więcej';
	@override String showMoreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Pokaż jeszcze ${count} wiersz',
		few: 'Pokaż jeszcze ${count} wiersze',
		many: 'Pokaż jeszcze ${count} wierszy',
		other: 'Pokaż jeszcze ${count} wiersza',
	);
	@override String get tools => 'Narzędzia';
	@override String get planReview => 'Przegląd planu';
	@override String get planUpdate => 'Aktualizacja planu';
	@override String get todoListUpdated => 'Zaktualizowano listę zadań';
	@override String get creatingTask => 'Tworzenie zadania';
	@override String get updatingTask => 'aktualizacja';
	@override String get fetchingTask => 'pobieranie';
	@override String get listingTasks => 'pobieranie listy zadań';
	@override String get search => 'Szukaj';
	@override late final Translations$chat$toolBlocks$verbs$pl verbs = Translations$chat$toolBlocks$verbs$pl._(_root);
	@override String get subagent => 'Podagent';
	@override String toolCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} narzędzie',
		few: '${count} narzędzia',
		many: '${count} narzędzi',
		other: '${count} narzędzia',
	);
	@override String get result => 'wynik';
	@override String plusMore({required Object count}) => '+${count} więcej';
	@override String get plan => 'Plan';
	@override String questionProgress({required Object current, required Object total}) => 'Pytanie ${current}/${total}';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} wiersz',
		few: '${count} wiersze',
		many: '${count} wierszy',
		other: '${count} wiersza',
	);
	@override String todoListItems({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Lista zadań (${count} pozycja)',
		few: 'Lista zadań (${count} pozycje)',
		many: 'Lista zadań (${count} pozycji)',
		other: 'Lista zadań (${count} pozycji)',
	);
	@override String tasksCompleted({required Object done, required Object total}) => 'ukończono ${done}/${total}';
}

// Path: chat.commandMenu
class Translations$chat$commandMenu$pl extends Translations$chat$commandMenu$en {
	Translations$chat$commandMenu$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Brak dostępnych poleceń';
	@override late final Translations$chat$commandMenu$namespaces$pl namespaces = Translations$chat$commandMenu$namespaces$pl._(_root);
}

// Path: chat.mentionMenu
class Translations$chat$mentionMenu$pl extends Translations$chat$mentionMenu$en {
	Translations$chat$mentionMenu$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$mentionMenu$kinds$pl kinds = Translations$chat$mentionMenu$kinds$pl._(_root);
	@override String taskTitle({required Object id}) => 'Zadanie ${id}';
}

// Path: chat.subheader
class Translations$chat$subheader$pl extends Translations$chat$subheader$en {
	Translations$chat$subheader$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String contextTooltip({required Object used, required Object total, required Object percent}) => 'Kontekst: ${used} / ${total} tokenów · wykorzystano ${percent}%';
}

// Path: chat.transcript
class Translations$chat$transcript$pl extends Translations$chat$transcript$en {
	Translations$chat$transcript$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get requestFailed => 'Żądanie nie powiodło się';
}

// Path: chat.review
class Translations$chat$review$pl extends Translations$chat$review$en {
	Translations$chat$review$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get changedFiles => 'Zmienione pliki';
	@override String changedFilesCount({required Object count}) => 'Zmienione pliki (${count})';
	@override String get subagent => 'subagent';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$pl extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get changes => 'zmiany';
	@override String get previousChange => 'Poprzednia zmiana';
	@override String get nextChange => 'Następna zmiana';
	@override String get hideDiff => 'Ukryj podświetlanie diff';
	@override String get showDiff => 'Pokaż podświetlanie diff';
	@override String get settings => 'Ustawienia edytora';
	@override String get collapse => 'Zwiń edytor';
	@override String get expand => 'Rozszerz edytor na pełną szerokość';
	@override String get toggleDock => 'Przełącz dok plików';
	@override String get diffMerge => 'Diff / scalanie';
	@override String get previewInBrowser => 'Podgląd w przeglądarce';
	@override String get reload => 'Wczytaj ponownie z dysku';
}

// Path: codeEditor.header
class Translations$codeEditor$header$pl extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Wyświetlanie zmian';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$pl extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Kopiuj ścieżkę pliku';
	@override String get pathCopied => 'Skopiowano ścieżkę pliku';
	@override String get download => 'Pobierz plik';
	@override String get save => 'Zapisz';
	@override String get saving => 'Zapisywanie...';
	@override String get saved => 'Zapisano!';
	@override String get exitFullscreen => 'Wyjdź z pełnego ekranu';
	@override String get fullscreen => 'Pełny ekran';
	@override String get close => 'Zamknij';
	@override String get previewMarkdown => 'Podgląd markdown';
	@override String get editMarkdown => 'Edytuj markdown';
	@override String get pinFile => 'Przypnij plik do kontekstu';
	@override String get unpinFile => 'Odepnij plik od kontekstu';
	@override String get previewHtml => 'Otwórz podgląd HTML w nowej karcie';
	@override String get retry => 'Ponów';
	@override String get saveAll => 'Zapisz wszystko';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$pl extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Linie:';
	@override String get characters => 'Znaki:';
	@override String get shortcuts => 'Naciśnij Ctrl+S, aby zapisać • Esc, aby zamknąć';
	@override String get plainText => 'zwykły tekst';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} wiersz',
		few: '${count} wiersze',
		many: '${count} wierszy',
		other: '${count} wiersza',
	);
	@override String get modified => 'zmodyfikowany';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$pl extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plik binarny';
	@override String message({required Object fileName}) => 'Plik "${fileName}" nie może zostać wyświetlony w edytorze tekstu, ponieważ jest to plik binarny.';
	@override String get cannotDisplayAsText => 'Nie można wyświetlić jako tekst';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$pl extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Wczytywanie podglądu...';
	@override String get error => 'Nie można wyświetlić tego pliku.';
	@override String get openInNewTab => 'Otwórz w nowej karcie';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$pl extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plik multimedialny';
	@override String get subtitle => 'Podgląd audio/wideo nie jest jeszcze obsługiwany';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$pl extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… jeszcze ${size}';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$pl extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get minimap => 'Minimapa';
	@override String tabSize({required Object size}) => 'Rozmiar tabulacji: ${size}';
	@override String fontSizeDecrease({required Object size}) => 'Rozmiar czcionki −  (teraz ${size})';
	@override String get fontSizeIncrease => 'Rozmiar czcionki +';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$pl extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get noChanges => 'Brak zmian';
	@override String hunk({required Object number}) => 'Fragment ${number}';
	@override String get close => 'Zamknij diff';
	@override String get base => 'Baza';
	@override String get current => 'Bieżący';
	@override String get applyMerge => 'Zastosuj scalenie';
	@override String get deletedOnDisk => 'usunięty z dysku';
	@override String get untrackedWillBeDeleted => 'Ten nieśledzony plik zostanie usunięty.';
	@override String restoreConfirm({required Object name}) => 'Przywrócić ${name} do stanu z ostatniego commita?';
	@override String get headVsWorkingCopy => 'HEAD a kopia robocza';
	@override String get savedVsBuffer => 'Ostatni zapis a bufor (bez gita)';
	@override String unchangedLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} niezmieniony wiersz',
		few: '${count} niezmienione wiersze',
		many: '${count} niezmienionych wierszy',
		other: '${count} niezmienionego wiersza',
	);
	@override String get revertToSaved => 'Przywróć zapisaną wersję';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$pl extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Brak otwartego pliku';
	@override String get hint => 'Otwórz pliki z karty Pliki';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$pl extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => 'Zapisano ${name}';
	@override String get saveFailed => 'Zapis nie powiódł się';
	@override String get allSaved => 'Zapisano wszystko';
	@override String get someSavesFailed => 'Nie udało się zapisać niektórych plików';
	@override String savedTo({required Object path}) => 'Zapisano w ${path}';
	@override String get mergeApplied => 'Scalanie zastosowane — zapisz, aby zachować zmiany';
}

// Path: common.buttons
class Translations$common$buttons$pl extends Translations$common$buttons$en {
	Translations$common$buttons$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get save => 'Zapisz';
	@override String get cancel => 'Anuluj';
	@override String get delete => 'Usuń';
	@override String get create => 'Utwórz';
	@override String get edit => 'Edytuj';
	@override String get close => 'Zamknij';
	@override String get confirm => 'Potwierdź';
	@override String get submit => 'Wyślij';
	@override String get retry => 'Ponów';
	@override String get refresh => 'Odśwież';
	@override String get search => 'Szukaj';
	@override String get clear => 'Wyczyść';
	@override String get copy => 'Kopiuj';
	@override String get download => 'Pobierz';
	@override String get upload => 'Wgraj';
	@override String get browse => 'Przeglądaj';
	@override String get update => 'Aktualizuj';
	@override String get openDiagram => 'Otwórz diagram';
}

// Path: common.tabs
class Translations$common$tabs$pl extends Translations$common$tabs$en {
	Translations$common$tabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Czat';
	@override String get shell => 'Shell';
	@override String get files => 'Pliki';
	@override String get git => 'Kontrola źródła';
	@override String get tasks => 'Zadania';
	@override String get board => 'Tablica';
	@override String get browser => 'Przeglądarka';
	@override String get computer => 'Komputer';
	@override String get usage => 'Control Center';
}

// Path: common.quota
class Translations$common$quota$pl extends Translations$common$quota$en {
	Translations$common$quota$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$pl section = Translations$common$quota$section$pl._(_root);
	@override late final Translations$common$quota$filter$pl filter = Translations$common$quota$filter$pl._(_root);
	@override late final Translations$common$quota$period$pl period = Translations$common$quota$period$pl._(_root);
	@override late final Translations$common$quota$group$pl group = Translations$common$quota$group$pl._(_root);
	@override late final Translations$common$quota$metric$pl metric = Translations$common$quota$metric$pl._(_root);
	@override late final Translations$common$quota$cost$pl cost = Translations$common$quota$cost$pl._(_root);
	@override late final Translations$common$quota$cost3$pl cost3 = Translations$common$quota$cost3$pl._(_root);
	@override late final Translations$common$quota$overview$pl overview = Translations$common$quota$overview$pl._(_root);
	@override late final Translations$common$quota$usage$pl usage = Translations$common$quota$usage$pl._(_root);
	@override late final Translations$common$quota$agents$pl agents = Translations$common$quota$agents$pl._(_root);
	@override late final Translations$common$quota$agentStatus$pl agentStatus = Translations$common$quota$agentStatus$pl._(_root);
	@override late final Translations$common$quota$alert$pl alert = Translations$common$quota$alert$pl._(_root);
	@override String get backToChat => 'Wróć do czatu';
	@override String get syncNow => 'Synchronizuj';
	@override String generatedAt({required Object value}) => 'Zaktualizowano ${value}';
	@override String get loading => 'Wczytywanie limitów kont…';
	@override String remaining({required Object value}) => 'pozostało ${value}%';
	@override String resetsIn({required Object value}) => 'reset za ${value}';
	@override String projected({required Object value}) => 'przy obecnym tempie limit skończy się za ${value}';
	@override String syncedAgo({required Object value}) => 'synchronizacja ${value} temu';
	@override String get refreshAccount => 'Odśwież konto';
	@override String get syncFailed => 'Synchronizacja nieudana';
	@override String get history => 'Historia';
	@override String historyPoints({required Object value}) => 'zapisano ${value} odczytów';
	@override String get historyEmpty => 'Brak zapisanej historii';
	@override String get noAgents => 'Brak przypisanych agentów';
	@override String get noSubscription => 'Brak subskrypcji';
	@override String get noSubscriptionHint => 'Provider nie widzi aktywnego planu dla tego konta.';
	@override late final Translations$common$quota$quality$pl quality = Translations$common$quota$quality$pl._(_root);
	@override late final Translations$common$quota$kpi$pl kpi = Translations$common$quota$kpi$pl._(_root);
	@override late final Translations$common$quota$empty$pl empty = Translations$common$quota$empty$pl._(_root);
	@override late final Translations$common$quota$settings$pl settings = Translations$common$quota$settings$pl._(_root);
	@override late final Translations$common$quota$range$pl range = Translations$common$quota$range$pl._(_root);
}

// Path: common.status
class Translations$common$status$pl extends Translations$common$status$en {
	Translations$common$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Ładowanie...';
	@override String get success => 'Powodzenie';
	@override String get error => 'Błąd';
	@override String get failed => 'Niepowodzenie';
	@override String get pending => 'Oczekujące';
	@override String get completed => 'Ukończono';
	@override String get inProgress => 'W toku';
}

// Path: common.messages
class Translations$common$messages$pl extends Translations$common$messages$en {
	Translations$common$messages$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Zapisano pomyślnie';
	@override String get deletedSuccessfully => 'Usunięto pomyślnie';
	@override String get updatedSuccessfully => 'Zaktualizowano pomyślnie';
	@override String get operationFailed => 'Operacja nie powiodła się';
	@override String get networkError => 'Błąd sieci. Sprawdź swoje połączenie.';
	@override String get unauthorized => 'Brak autoryzacji. Zaloguj się.';
	@override String get notFound => 'Nie znaleziono';
	@override String get invalidInput => 'Nieprawidłowe dane wejściowe';
	@override String get requiredField => 'To pole jest wymagane';
	@override String get unknownError => 'Wystąpił nieznany błąd';
	@override String get renameSessionFailed => 'Nie udało się zmienić nazwy sesji. Spróbuj ponownie.';
}

// Path: common.navigation
class Translations$common$navigation$pl extends Translations$common$navigation$en {
	Translations$common$navigation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Ustawienia';
	@override String get home => 'Strona główna';
	@override String get back => 'Wstecz';
	@override String get next => 'Dalej';
	@override String get previous => 'Poprzedni';
	@override String get logout => 'Wyloguj się';
	@override String get backToChat => 'Powrót do czatu';
}

// Path: common.common
class Translations$common$common$pl extends Translations$common$common$en {
	Translations$common$common$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get language => 'Język';
	@override String get theme => 'Motyw';
	@override String get darkMode => 'Tryb ciemny';
	@override String get lightMode => 'Tryb jasny';
	@override String get name => 'Nazwa';
	@override String get description => 'Opis';
	@override String get enabled => 'Włączone';
	@override String get disabled => 'Wyłączone';
	@override String get optional => 'Opcjonalne';
	@override String get version => 'Wersja';
	@override String get select => 'Wybierz';
	@override String get selectAll => 'Zaznacz wszystko';
	@override String get deselectAll => 'Odznacz wszystko';
	@override String get done => 'Gotowe';
	@override String get failed => 'Niepowodzenie';
}

// Path: common.time
class Translations$common$time$pl extends Translations$common$time$en {
	Translations$common$time$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Właśnie teraz';
	@override String minutesAgo({required Object count}) => '${count} min temu';
	@override String hoursAgo({required Object count}) => '${count} godz. temu';
	@override String daysAgo({required Object count}) => '${count} dni temu';
	@override String get yesterday => 'Wczoraj';
}

// Path: common.fileOperations
class Translations$common$fileOperations$pl extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Nowy plik';
	@override String get newFolder => 'Nowy folder';
	@override String get rename => 'Zmień nazwę';
	@override String get move => 'Przenieś';
	@override String get copyPath => 'Kopiuj ścieżkę';
	@override String get openInEditor => 'Otwórz w edytorze';
}

// Path: common.mainContent
class Translations$common$mainContent$pl extends Translations$common$mainContent$en {
	Translations$common$mainContent$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Ładowanie DDAgent';
	@override String get settingUpWorkspace => 'Konfigurowanie obszaru roboczego...';
	@override String get chooseProject => 'Wybierz swój projekt';
	@override String get selectProjectDescription => 'Wybierz sesję w Panelu, aby rozpocząć kodowanie z Claude. Każdy projekt zawiera Twoje sesje czatu i historię plików.';
	@override String get tip => 'Wskazówka';
	@override String get createProjectMobile => 'Naciśnij przycisk menu powyżej, aby uzyskać dostęp do projektów';
	@override String get createProjectDesktop => 'Utwórz nowy projekt, klikając ikonę folderu w panelu bocznym';
	@override String get newSession => 'Nowa sesja';
	@override String get untitledSession => 'Sesja bez nazwy';
	@override String get projectFiles => 'Pliki projektu';
	@override String get focusMode => 'Tryb skupienia (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Opuść tryb skupienia (Ctrl+Shift+F)';
	@override String get splitSession => 'Podziel widok sesji';
	@override String get closeSplitSession => 'Zamknij podzielony widok sesji';
	@override String get chooseWorkspace => 'Wybierz obszar roboczy';
	@override String get chooseWorkspaceDescription => 'Wybierz obszar roboczy dla tego czatu lub utwórz nowy w Ustawieniach.';
	@override String get createWorkspace => 'Utwórz obszar roboczy w Ustawieniach';
	@override String get recentProjects => 'Ostatnie projekty';
}

// Path: common.fileTree
class Translations$common$fileTree$pl extends Translations$common$fileTree$en {
	Translations$common$fileTree$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Ładowanie plików...';
	@override String get files => 'Pliki';
	@override String get simpleView => 'Widok prosty';
	@override String get compactView => 'Widok kompaktowy';
	@override String get detailedView => 'Widok szczegółowy';
	@override String get searchPlaceholder => 'Szukaj plików i folderów...';
	@override String get searchContentPlaceholder => 'Szukaj w plikach...';
	@override String get searchInFiles => 'Szukaj w plikach';
	@override String get searchByName => 'Szukaj po nazwie';
	@override String get clearSearch => 'Wyczyść wyszukiwanie';
	@override String get name => 'Nazwa';
	@override String get size => 'Rozmiar';
	@override String get modified => 'Zmodyfikowano';
	@override String get permissions => 'Uprawnienia';
	@override String get noFilesFound => 'Nie znaleziono plików';
	@override String get checkProjectPath => 'Sprawdź, czy ścieżka projektu jest dostępna';
	@override String get loadFailed => 'Nie można załadować plików';
	@override String get noMatchesFound => 'Nie znaleziono dopasowań';
	@override String get noSearchResults => 'Nie znaleziono dopasowań';
	@override String get tryDifferentSearch => 'Spróbuj innego wyszukiwanego hasła lub wyczyść wyszukiwanie';
	@override String get searchError => 'Wyszukiwanie nie powiodło się';
	@override String get searching => 'Wyszukiwanie...';
	@override String resultsTruncated({required Object count}) => 'Pokazano pierwsze ${count} wyników';
	@override String get justNow => 'właśnie teraz';
	@override String minAgo({required Object count}) => '${count} min temu';
	@override String hoursAgo({required Object count}) => '${count} godz. temu';
	@override String daysAgo({required Object count}) => '${count} dni temu';
	@override String get newFile => 'Nowy plik (Cmd+N)';
	@override String get newFolder => 'Nowy folder (Cmd+Shift+N)';
	@override String get refresh => 'Odśwież';
	@override String get collapseAll => 'Zwiń wszystko';
	@override late final Translations$common$fileTree$context$pl context = Translations$common$fileTree$context$pl._(_root);
	@override String get allWorkspaces => 'Wszystkie obszary robocze';
	@override late final Translations$common$fileTree$delete$pl delete = Translations$common$fileTree$delete$pl._(_root);
	@override String get dropToUpload => 'Upuść pliki, aby przesłać';
	@override String dropToUploadTo({required Object folder}) => 'Upuść pliki, aby przesłać do „${folder}”';
	@override String get noProject => 'Najpierw dodaj projekt';
	@override String get noRecentFiles => 'Brak plików zmienionych w ciągu ostatnich 7 dni';
	@override String get showAllFiles => 'Pokaż wszystkie pliki';
	@override String get showAllFilesHint => 'Wyłącz filtr ostatnich, aby zobaczyć wszystko.';
	@override String get showRecentOnly => 'Pokaż pliki zmienione w ciągu ostatnich 7 dni';
	@override late final Translations$common$fileTree$toast$pl toast = Translations$common$fileTree$toast$pl._(_root);
	@override String get uploadComplete => 'Przesyłanie zakończone';
	@override String get uploadFailed => 'Przesyłanie nie powiodło się';
	@override String uploadFiles({required Object size}) => 'Prześlij pliki (maks. ${size} każdy)';
	@override String uploadToFolder({required Object folder}) => 'Prześlij pliki do „${folder}”';
	@override String uploadedCount({required Object uploaded, required Object total, required Object label}) => 'Przesłano ${uploaded} z ${total} ${label}';
	@override String get uploadingFiles => 'Przesyłanie plików';
	@override late final Translations$common$fileTree$validation$pl validation = Translations$common$fileTree$validation$pl._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$pl extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Utwórz nowy projekt';
	@override late final Translations$common$projectWizard$steps$pl steps = Translations$common$projectWizard$steps$pl._(_root);
	@override late final Translations$common$projectWizard$step1$pl step1 = Translations$common$projectWizard$step1$pl._(_root);
	@override late final Translations$common$projectWizard$step2$pl step2 = Translations$common$projectWizard$step2$pl._(_root);
	@override late final Translations$common$projectWizard$step3$pl step3 = Translations$common$projectWizard$step3$pl._(_root);
	@override late final Translations$common$projectWizard$buttons$pl buttons = Translations$common$projectWizard$buttons$pl._(_root);
	@override late final Translations$common$projectWizard$errors$pl errors = Translations$common$projectWizard$errors$pl._(_root);
}

// Path: common.notifications
class Translations$common$notifications$pl extends Translations$common$notifications$en {
	Translations$common$notifications$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'narzędzie';
	@override late final Translations$common$notifications$codes$pl codes = Translations$common$notifications$codes$pl._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$pl extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dostępna aktualizacja';
	@override String get newVersionReady => 'Nowa wersja jest gotowa';
	@override String get currentVersion => 'Aktualna wersja';
	@override String get latestVersion => 'Najnowsza wersja';
	@override String get whatsNew => 'Co nowego:';
	@override String get viewFullRelease => 'Zobacz pełne wydanie';
	@override String get updateProgress => 'Postęp aktualizacji:';
	@override String get manualUpgrade => 'Ręczna aktualizacja:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'Albo kliknij "Zaktualizuj teraz", aby przeprowadzić aktualizację automatycznie.';
	@override String get updateCompleted => 'Aktualizacja zakończona pomyślnie!';
	@override String get restartServer => 'Uruchom ponownie serwer, aby zastosować zmiany.';
	@override String get updateFailed => 'Aktualizacja nie powiodła się';
	@override late final Translations$common$versionUpdate$buttons$pl buttons = Translations$common$versionUpdate$buttons$pl._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$pl ariaLabels = Translations$common$versionUpdate$ariaLabels$pl._(_root);
}

// Path: common.actions
class Translations$common$actions$pl extends Translations$common$actions$en {
	Translations$common$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Anuluj';
	@override String get retry => 'Spróbuj ponownie';
	@override String get save => 'Zapisz';
}

// Path: common.browserPane
class Translations$common$browserPane$pl extends Translations$common$browserPane$en {
	Translations$common$browserPane$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get address => 'Adres';
	@override String get back => 'Wstecz';
	@override String get connecting => 'Łączenie z przeglądarką…';
	@override String get connectionFailed => 'Połączenie z przeglądarką nie powiodło się.';
	@override String couldNotLoad({required Object url}) => 'Nie można załadować ${url}';
	@override String get disconnected => 'Widok przeglądarki rozłączony';
	@override String get enterUrl => 'Wpisz adres URL';
	@override String get forward => 'Dalej';
	@override String get invalidUrl => 'Wpisz prawidłowy adres http(s)';
	@override String get noAuthToken => 'Brak tokenu uwierzytelniającego.';
	@override String get openExternal => 'Otwórz w przeglądarce systemowej';
	@override String get reload => 'Odśwież';
	@override String get retry => 'Ponów';
	@override String get stop => 'Zatrzymaj';
}

// Path: common.browserUse
class Translations$common$browserUse$pl extends Translations$common$browserUse$en {
	Translations$common$browserUse$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} aktywne';
	@override String get cancel => 'Anuluj';
	@override String get close => 'Zamknij';
	@override String get delete => 'Usuń';
	@override String deleteDesc({required Object name}) => '${name} zostanie trwale usunięte.';
	@override String get deleteSession => 'Usuń sesję';
	@override String get deleteTitle => 'Usunąć sesję przeglądarki?';
	@override late final Translations$common$browserUse$empty$pl empty = Translations$common$browserUse$empty$pl._(_root);
	@override String get emptyStatus => 'pusta';
	@override late final Translations$common$browserUse$errors$pl errors = Translations$common$browserUse$errors$pl._(_root);
	@override String get fullscreen => 'Pełny ekran';
	@override String get installRuntime => 'Zainstaluj środowisko';
	@override String get installing => 'Instalowanie...';
	@override String get lastAction => 'Ostatnia akcja';
	@override String get nextSnapshot => 'Kolejny zrzut ekranu przeglądarki agenta pojawi się tutaj.';
	@override String get noPageLoaded => 'Nie załadowano strony';
	@override String get noSessions => 'Brak sesji przeglądarki agentów.';
	@override String get none => 'Brak';
	@override String get openSettings => 'Otwórz ustawienia Browser';
	@override String get profile => 'Profil';
	@override String get promptLabel => 'Prompt';
	@override late final Translations$common$browserUse$prompts$pl prompts = Translations$common$browserUse$prompts$pl._(_root);
	@override String get refresh => 'Odśwież sesje przeglądarki';
	@override late final Translations$common$browserUse$relative$pl relative = Translations$common$browserUse$relative$pl._(_root);
	@override late final Translations$common$browserUse$runtime$pl runtime = Translations$common$browserUse$runtime$pl._(_root);
	@override String get runtimeSetup => 'Wymagana konfiguracja środowiska';
	@override String get selected => 'Wybrana';
	@override String get sessionFallback => 'Sesja przeglądarki';
	@override String get sessionScreenshot => 'Zrzut ekranu sesji przeglądarki';
	@override String get sessions => 'Sesje';
	@override String get status => 'Status';
	@override String get stop => 'Zatrzymaj';
	@override String get stopSession => 'Zatrzymaj sesję';
	@override String get subtitle => 'Monitoruj sesje przeglądarki otwierane przez agentów AI.';
	@override String get temporary => 'Tymczasowy';
	@override String get thisSession => 'Ta sesja';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => 'łącznie ${count}';
	@override String updated({required Object time}) => 'Zaktualizowano ${time}';
	@override String get waiting => 'Oczekiwanie';
	@override String get waitingForScreenshot => 'Oczekiwanie na zrzut ekranu';
}

// Path: common.commandPalette
class Translations$common$commandPalette$pl extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Wróć do wszystkich';
	@override String get backspaceHint => 'Backspace, aby wrócić';
	@override late final Translations$common$commandPalette$browseAll$pl browseAll = Translations$common$commandPalette$browseAll$pl._(_root);
	@override late final Translations$common$commandPalette$compare$pl compare = Translations$common$commandPalette$compare$pl._(_root);
	@override late final Translations$common$commandPalette$groups$pl groups = Translations$common$commandPalette$groups$pl._(_root);
	@override late final Translations$common$commandPalette$hints$pl hints = Translations$common$commandPalette$hints$pl._(_root);
	@override late final Translations$common$commandPalette$items$pl items = Translations$common$commandPalette$items$pl._(_root);
	@override late final Translations$common$commandPalette$nav$pl nav = Translations$common$commandPalette$nav$pl._(_root);
	@override String get noResults => 'Brak wyników.';
	@override late final Translations$common$commandPalette$pages$pl pages = Translations$common$commandPalette$pages$pl._(_root);
	@override String get placeholder => 'Wpisz, aby wyszukać cokolwiek…';
	@override String searchPagePlaceholder({required Object page}) => 'Szukaj: ${page}…';
	@override String get title => 'Paleta poleceń';
}

// Path: common.gitPanel
class Translations$common$gitPanel$pl extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} do przodu';
	@override String get aheadLabel => 'do przodu';
	@override String get aiSuggest => 'Sugestia AI';
	@override String get aiSuggestTitle => 'Wygeneruj wiadomość commita za pomocą AI';
	@override String get all => 'Wszystkie';
	@override String get allStaged => 'Wszystkie zmiany przygotowane';
	@override String behind({required Object count}) => '${count} do tyłu';
	@override String get behindLabel => 'do tyłu';
	@override late final Translations$common$gitPanel$branches$pl branches = Translations$common$gitPanel$branches$pl._(_root);
	@override String get cancel => 'Anuluj';
	@override String changesCount({required Object count}) => 'Zmiany (${count})';
	@override String get clearSearch => 'Wyczyść wyszukiwanie';
	@override String get collapseDiff => 'Zwiń diff';
	@override String get commit => 'Commit';
	@override String get commitChanges => 'Zatwierdź zmiany';
	@override String commitFiles({required Object count}) => 'Zatwierdź ${count} plik(ów)';
	@override String get committing => 'Zatwierdzanie...';
	@override late final Translations$common$gitPanel$confirmActions$pl confirmActions = Translations$common$gitPanel$confirmActions$pl._(_root);
	@override String confirmCommit({required Object count, required Object message}) => 'Zatwierdzić ${count} plik(ów) z wiadomością: „${message}”?';
	@override String confirmDeleteFile({required Object file}) => 'Usunąć nieśledzony plik „${file}”? Tej operacji nie można cofnąć.';
	@override String confirmDiscardFile({required Object file}) => 'Odrzucić wszystkie zmiany w „${file}”? Tej operacji nie można cofnąć.';
	@override String confirmPublish({required Object branch, required Object remote}) => 'Opublikować gałąź „${branch}” do ${remote}?';
	@override String confirmPull({required Object count, required Object remote}) => 'Pobrać ${count} commit(ów) z ${remote}?';
	@override String confirmPush({required Object count, required Object remote}) => 'Wysłać ${count} commit(ów) do ${remote}?';
	@override String get confirmRevert => 'Cofnąć ostatni lokalny commit? Usuwa commit, ale zachowuje jego zmiany jako przygotowane.';
	@override late final Translations$common$gitPanel$confirmTitles$pl confirmTitles = Translations$common$gitPanel$confirmTitles$pl._(_root);
	@override String get createBranch => 'Utwórz nową gałąź';
	@override String get creating => 'Tworzenie...';
	@override String get delete => 'Usuń';
	@override String get deleteUntracked => 'Usuń nieśledzony plik';
	@override String get deselectAll => 'Odznacz wszystko';
	@override String get discard => 'Odrzuć';
	@override String get discardChanges => 'Odrzuć zmiany';
	@override String get dismiss => 'Zamknij';
	@override String get dismissError => 'Zamknij błąd';
	@override late final Translations$common$gitPanel$errors$pl errors = Translations$common$gitPanel$errors$pl._(_root);
	@override String get expandDiff => 'Rozwiń diff';
	@override String get fetch => 'Fetch';
	@override String fetchTitle({required Object remote}) => 'Pobierz z ${remote}';
	@override String get fetching => 'Pobieranie…';
	@override String filesSelected({required Object count}) => 'Wybrano ${count} plik(ów)';
	@override String get generating => 'Generowanie...';
	@override late final Translations$common$gitPanel$history$pl history = Translations$common$gitPanel$history$pl._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$pl mergeWorktree = Translations$common$gitPanel$mergeWorktree$pl._(_root);
	@override String get merging => 'Scalanie...';
	@override String get messagePlaceholder => 'Wiadomość (Ctrl+Enter, aby zatwierdzić)';
	@override late final Translations$common$gitPanel$newBranch$pl newBranch = Translations$common$gitPanel$newBranch$pl._(_root);
	@override late final Translations$common$gitPanel$newWorktree$pl newWorktree = Translations$common$gitPanel$newWorktree$pl._(_root);
	@override String get noChanges => 'Nie wykryto zmian';
	@override String get noChangesToCommit => 'Brak zmian do zatwierdzenia';
	@override late final Translations$common$gitPanel$noCommits$pl noCommits = Translations$common$gitPanel$noCommits$pl._(_root);
	@override String get noMatchingBranches => 'Brak pasujących gałęzi';
	@override late final Translations$common$gitPanel$noRepo$pl noRepo = Translations$common$gitPanel$noRepo$pl._(_root);
	@override String get noStagedFiles => 'Brak przygotowanych plików';
	@override String get none => 'Brak';
	@override String nothingToPush({required Object remote}) => 'Nic do wysłania do ${remote}';
	@override String get openFile => 'Kliknij, aby otworzyć plik';
	@override String get publish => 'Opublikuj';
	@override String publishTitle({required Object branch, required Object remote}) => 'Opublikuj „${branch}” do ${remote}';
	@override String get publishing => 'Publikowanie…';
	@override String get pull => 'Pull';
	@override String pullCount({required Object count}) => 'Pull ${count}';
	@override String pullTitle({required Object count, required Object remote}) => 'Pobierz ${count} z ${remote}';
	@override String get pulling => 'Pobieranie…';
	@override String get push => 'Push';
	@override String pushCount({required Object count}) => 'Push ${count}';
	@override String pushTitle({required Object count, required Object remote}) => 'Wyślij ${count} do ${remote}';
	@override String get pushing => 'Wysyłanie…';
	@override String get recentCommits => 'Ostatnie commity';
	@override String get refresh => 'Odśwież status git';
	@override String get remove => 'Usuń';
	@override late final Translations$common$gitPanel$removeWorktree$pl removeWorktree = Translations$common$gitPanel$removeWorktree$pl._(_root);
	@override String get removing => 'Usuwanie...';
	@override String get revertLatest => 'Cofnij ostatni lokalny commit';
	@override String get scroll => 'Przewijanie';
	@override String get searchBranches => 'Szukaj gałęzi...';
	@override String get selectAll => 'Zaznacz wszystko';
	@override String get selectProject => 'Wybierz projekt, aby wyświetlić kontrolę źródła';
	@override String selectedOf({required Object selected, required Object total}) => 'Wybrano ${selected} z ${total} plików';
	@override String selectedOfMobile({required Object selected, required Object total}) => 'Wybrano ${selected} z ${total}';
	@override String get sideBySide => 'Obok siebie';
	@override String get stageAll => 'Przygotuj wszystko';
	@override String get stageHunk => 'Przygotuj ten fragment';
	@override String staged({required Object count}) => 'Przygotowane (${count})';
	@override late final Translations$common$gitPanel$status$pl status = Translations$common$gitPanel$status$pl._(_root);
	@override String get statusGuide => 'Przewodnik po statusach plików';
	@override String get switchScroll => 'Przełącz na przewijanie poziome';
	@override String get switchSplit => 'Przełącz na widok obok siebie';
	@override String get switchUnified => 'Przełącz na widok ujednolicony';
	@override String get switchWrap => 'Przełącz na zawijanie tekstu';
	@override String get unified => 'Ujednolicony';
	@override String get unstageAll => 'Cofnij przygotowanie wszystkiego';
	@override String get unstageHunk => 'Cofnij przygotowanie tego fragmentu';
	@override String get upToDate => 'Aktualne';
	@override String upToDateWith({required Object remote}) => 'Aktualne z ${remote}';
	@override String get viewAll => 'Zobacz wszystkie';
	@override String get viewsAria => 'Widoki kontroli źródła';
	@override late final Translations$common$gitPanel$worktrees$pl worktrees = Translations$common$gitPanel$worktrees$pl._(_root);
	@override String get wrap => 'Zawijaj';
	@override late final Translations$common$gitPanel$tabs$pl tabs = Translations$common$gitPanel$tabs$pl._(_root);
	@override String get save => 'Zapisz';
	@override late final Translations$common$gitPanel$worktreeScripts$pl worktreeScripts = Translations$common$gitPanel$worktreeScripts$pl._(_root);
}

// Path: common.sessions
class Translations$common$sessions$pl extends Translations$common$sessions$en {
	Translations$common$sessions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Zmień nazwę sesji';
}

// Path: common.projects
class Translations$common$projects$pl extends Translations$common$projects$en {
	Translations$common$projects$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nowa sesja';
}

// Path: common.sharedNotes
class Translations$common$sharedNotes$pl extends Translations$common$sharedNotes$en {
	Translations$common$sharedNotes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Współdzielona pamięć — dołączana do każdej sesji projektu';
	@override String get save => 'Zapisz';
	@override String get saving => 'Zapisywanie…';
	@override String get noProject => 'Wybierz workspace, aby edytować współdzielony kontekst';
	@override String get placeholder => '# Współdzielony kontekst\nKonwencje, decyzje i wskazówki dla wszystkich agentów…';
}

// Path: common.codeBlock
class Translations$common$codeBlock$pl extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'Zawijaj wiersze';
	@override String get noWrap => 'Bez zawijania';
}

// Path: common.update
class Translations$common$update$pl extends Translations$common$update$en {
	Translations$common$update$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Dostępna aktualizacja · v${version}';
	@override String confirm({required Object version}) => 'Zaktualizować do v${version}? Serwer zaktualizuje się i uruchomi ponownie — aktywne sesje zostaną przerwane.';
	@override String get downloading => 'Pobieranie i stosowanie aktualizacji…';
	@override String get restarting => 'Restartowanie serwera — to zajmie chwilę…';
	@override String done({required Object version}) => 'Zaktualizowano do v${version}. Przeładuj aplikację, aby wczytać nowy pakiet.';
	@override String get manualRestart => 'Aktualizacja została zastosowana, ale serwer nie uruchomił się ponownie sam — uruchom go ręcznie, aby dokończyć.';
	@override String get failed => 'Aktualizacja nie powiodła się.';
	@override String get failedTitle => 'Aktualizacja nie powiodła się';
	@override String appConfirm({required Object version}) => 'Zainstalować DDAgent v${version} na tym urządzeniu? Android za pierwszym razem zapyta o zgodę na instalowanie aplikacji z DDAgent.';
	@override String get appPermission => 'Zezwól DDAgent na „Instalowanie nieznanych aplikacji”, a potem dotknij ponownie Aktualizuj.';
	@override String get chooseTitle => 'Dostępne aktualizacje';
	@override String get targetApp => 'Ta aplikacja';
	@override String get targetWeb => 'Interfejs web';
	@override String get targetServer => 'Serwer';
	@override String get updateApp => 'Aktualizuj aplikację';
	@override String get updateWeb => 'Aktualizuj interfejs web';
	@override String get updateServer => 'Aktualizuj serwer';
	@override String webConfirm({required Object version}) => 'Zaktualizować interfejs web do v${version}? Strona przeładuje się po aktualizacji.';
	@override String webDone({required Object version}) => 'Interfejs web zaktualizowany do v${version} — przeładowuję…';
	@override String localServerConfirm({required Object version}) => 'Zaktualizować lokalny serwer na tym urządzeniu do v${version}? Trwające sesje zostaną przerwane.';
	@override String get localServerUpdating => 'Pobieram i uruchamiam lokalny serwer…';
	@override String serverDone({required Object version}) => 'Serwer działa w wersji v${version}.';
	@override String staged({required Object version}) => 'Pobrano aktualizację v${version} — zrestartuj serwer, aby ją zainstalować.';
	@override String get upToDate => 'Serwer ma już najnowsze wydanie.';
	@override String webHostFailed({required Object message}) => 'Serwer został zaktualizowany, ale jego interfejs web nie: ${message}';
}

// Path: common.appShell
class Translations$common$appShell$pl extends Translations$common$appShell$en {
	Translations$common$appShell$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String panelActive({required Object count}) => 'Panel · aktywne: ${count}';
}

// Path: common.errors
class Translations$common$errors$pl extends Translations$common$errors$en {
	Translations$common$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get forbidden => 'Brak dostępu';
}

// Path: settings.changelog
class Translations$settings$changelog$pl extends Translations$settings$changelog$en {
	Translations$settings$changelog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dziennik zmian';
	@override String get loading => 'Ładowanie…';
	@override String get empty => 'Brak wydań do wyświetlenia';
	@override String get current => 'aktualna';
	@override String get kNew => 'nowa';
}

// Path: settings.server
class Translations$settings$server$pl extends Translations$settings$server$en {
	Translations$settings$server$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Serwer';
	@override String get description => 'Uruchamia ponownie proces DDAgent — przydatne po aktualizacji lub gdy coś się zawiesi.';
	@override String get restart => 'Uruchom ponownie';
	@override String get restartConfirm => 'Zrestartować serwer DDAgent? Aktywne sesje zostaną przerwane.';
	@override String get restarting => 'Restartowanie… strona przeładuje się, gdy serwer wróci.';
	@override String get restartFailed => 'Restart nie powiódł się';
	@override String get unsupported => 'Restart jest dostępny tylko, gdy serwer działa pod menedżerem usług.';
	@override String get ok => 'OK';
	@override String get restartTitle => 'Restart serwera';
	@override String get restartRequesting => 'Wysyłam do serwera polecenie restartu…';
	@override String restartWaiting({required Object seconds}) => 'Czekam, aż serwer wróci… (${seconds} s)';
	@override String restartBack({required Object version}) => 'Serwer działa — wersja ${version}.';
	@override String get restartReloading => 'Przeładowuję stronę…';
	@override String restartTimeout({required Object seconds}) => 'Serwer nie wrócił w ciągu ${seconds} s. Sprawdź log usługi (/tmp/ddagent.log) albo zrestartuj go ręcznie.';
}

// Path: settings.updates
class Translations$settings$updates$pl extends Translations$settings$updates$en {
	Translations$settings$updates$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aktualizacje';
	@override String get description => 'Sprawdź GitHub w poszukiwaniu nowszej wersji desktopowej. Nowe wersje pobierają się automatycznie i instalują przy zamknięciu.';
	@override String get descriptionMobile => 'Sprawdź GitHub w poszukiwaniu nowszej wersji tej aplikacji. Aktualizację instaluje instalator systemowy urządzenia.';
	@override String get descriptionServer => 'Sprawdza na GitHubie, czy jest nowsze wydanie DDAgent. Podłączony serwer może zaktualizować się sam — trwające sesje zostaną przerwane na czas restartu.';
	@override String get check => 'Sprawdź aktualizacje';
	@override String get checking => 'Sprawdzanie…';
	@override String upToDate({required Object version}) => 'Masz najnowszą wersję (v${version}).';
	@override String available({required Object version}) => 'Znaleziono aktualizację v${version} — pobieranie w tle; zainstaluje się przy zamknięciu DDAgent.';
	@override String appAvailable({required Object version}) => 'Dostępna aktualizacja aplikacji v${version} — dotknij Aktualizuj, aby zainstalować ją na tym urządzeniu.';
	@override String downloaded({required Object version}) => 'Aktualizacja v${version} pobrana — zamknij i uruchom DDAgent ponownie, aby ją zainstalować.';
	@override String get unavailable => 'Sprawdzanie aktualizacji dostępne tylko w spakietowanej aplikacji desktopowej.';
	@override String error({required Object message}) => 'Sprawdzanie aktualizacji nie powiodło się: ${message}';
	@override String get errorGeneric => 'Sprawdzanie aktualizacji nie powiodło się.';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · najnowsza v${latest}';
	@override String current({required Object version}) => 'v${version} — aktualna';
	@override String webNotHosted({required Object version}) => 'Ten interfejs web jest hostowany osobno — podmień jego pliki na ddagent-flutter-web-v${version}.zip z wydania.';
	@override String get serverCannotUpdate => 'Ten serwer nie może zaktualizować się stąd — zainstaluj go ponownie przez install.sh albo z tarballa wydania.';
}

// Path: settings.tabs
class Translations$settings$tabs$pl extends Translations$settings$tabs$en {
	Translations$settings$tabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get account => 'Konto';
	@override String get permissions => 'Uprawnienia';
	@override String get mcpServers => 'Serwery MCP';
	@override String get skills => 'Umiejętności';
	@override String get appearance => 'Wygląd';
}

// Path: settings.account
class Translations$settings$account$pl extends Translations$settings$account$en {
	Translations$settings$account$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konto';
	@override String get language => 'Język';
	@override String get languageLabel => 'Język interfejsu';
	@override String get languageDescription => 'Wybierz preferowany język interfejsu';
	@override String get username => 'Nazwa użytkownika';
	@override String get email => 'E-mail';
	@override String get profile => 'Profil';
	@override String get changePassword => 'Zmień hasło';
}

// Path: settings.mcp
class Translations$settings$mcp$pl extends Translations$settings$mcp$en {
	Translations$settings$mcp$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Serwery MCP';
	@override String get addServer => 'Dodaj serwer';
	@override String get editServer => 'Edytuj serwer';
	@override String get deleteServer => 'Usuń serwer';
	@override String get serverName => 'Nazwa serwera';
	@override String get serverType => 'Typ serwera';
	@override String get config => 'Konfiguracja';
	@override String get testConnection => 'Testuj połączenie';
	@override String get status => 'Stan';
	@override String get connected => 'Połączono';
	@override String get disconnected => 'Rozłączono';
	@override late final Translations$settings$mcp$scope$pl scope = Translations$settings$mcp$scope$pl._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$pl extends Translations$settings$appearance$en {
	Translations$settings$appearance$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wygląd';
	@override String get theme => 'Motyw';
	@override String get codeEditor => 'Edytor kodu';
	@override String get editorTheme => 'Motyw edytora';
	@override String get wordWrap => 'Zawijanie wierszy';
	@override String get showMinimap => 'Pokaż minimapę';
	@override String get lineNumbers => 'Numery wierszy';
	@override String get fontSize => 'Rozmiar czcionki';
	@override late final Translations$settings$appearance$themeModes$pl themeModes = Translations$settings$appearance$themeModes$pl._(_root);
}

// Path: settings.actions
class Translations$settings$actions$pl extends Translations$settings$actions$en {
	Translations$settings$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Zapisz zmiany';
	@override String get resetToDefaults => 'Przywróć ustawienia domyślne';
	@override String get cancelChanges => 'Anuluj zmiany';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$pl extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Szybkie ustawienia';
	@override late final Translations$settings$quickSettings$sections$pl sections = Translations$settings$quickSettings$sections$pl._(_root);
	@override String get darkMode => 'Tryb ciemny';
	@override String get showRawParameters => 'Pokaż surowe parametry';
	@override String get showThinking => 'Pokaż myślenie';
	@override String get sendByCtrlEnter => 'Wysyłaj przez Ctrl+Enter';
	@override String get sendByCtrlEnterDescription => 'Po włączeniu naciśnięcie Ctrl+Enter wyśle wiadomość zamiast samego Entera. Przydatne dla użytkowników IME, aby uniknąć przypadkowego wysłania.';
	@override late final Translations$settings$quickSettings$dragHandle$pl dragHandle = Translations$settings$quickSettings$dragHandle$pl._(_root);
	@override String get sendWithCtrlEnter => 'Wysyłaj przez Ctrl+Enter';
	@override String get enterSendsHint => 'Gdy wyłączone, Enter wysyła wiadomość, a Shift+Enter wstawia nową linię.';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$pl extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Skróty terminala';
	@override String get sectionKeys => 'Klawisze';
	@override String get sectionNavigation => 'Nawigacja';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => 'Strzałka w górę';
	@override String get arrowDown => 'Strzałka w dół';
	@override String get scrollDown => 'Przewiń w dół';
	@override String get killTitle => 'Zatrzymaj proces (SIGINT)';
	@override late final Translations$settings$terminalShortcuts$handle$pl handle = Translations$settings$terminalShortcuts$handle$pl._(_root);
	@override String get paste => 'Wklej';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$pl extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ustawienia';
	@override String get agents => 'Agenci';
	@override String get orchestration => 'Orkiestracja';
	@override String get miniOrchestration => 'Mini-orkiestracja';
	@override String get appearance => 'Wygląd';
	@override String get workspaces => 'Obszary robocze';
	@override String get git => 'Git';
	@override String get apiTokens => 'API i tokeny';
	@override String get models => 'Modele';
	@override String get tasks => 'Zadania';
	@override String get browser => 'Przeglądarka';
	@override String get tools => 'Narzędzia';
	@override String get notifications => 'Powiadomienia';
	@override String get about => 'O aplikacji';
	@override String get quota => 'Control Center';
	@override String get shortcuts => 'Skróty klawiszowe';
}

// Path: settings.miniOrchestration
class Translations$settings$miniOrchestration$pl extends Translations$settings$miniOrchestration$en {
	Translations$settings$miniOrchestration$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mini-orkiestracja';
	@override String get description => 'Potok z dwoma modelami: model myślący (nie-flash) planuje, a wykonawca (flash) realizuje kroki.';
	@override String get loading => 'Wczytywanie ustawień mini-orkiestracji…';
	@override String get loadError => 'Nie udało się wczytać ustawień mini-orkiestracji.';
	@override late final Translations$settings$miniOrchestration$enable$pl enable = Translations$settings$miniOrchestration$enable$pl._(_root);
	@override late final Translations$settings$miniOrchestration$thinker$pl thinker = Translations$settings$miniOrchestration$thinker$pl._(_root);
	@override late final Translations$settings$miniOrchestration$worker$pl worker = Translations$settings$miniOrchestration$worker$pl._(_root);
	@override late final Translations$settings$miniOrchestration$fields$pl fields = Translations$settings$miniOrchestration$fields$pl._(_root);
	@override late final Translations$settings$miniOrchestration$roles$pl roles = Translations$settings$miniOrchestration$roles$pl._(_root);
	@override late final Translations$settings$miniOrchestration$planner$pl planner = Translations$settings$miniOrchestration$planner$pl._(_root);
}

// Path: settings.orchestration
class Translations$settings$orchestration$pl extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orkiestracja';
	@override String get description => 'Kieruj zadania z czatu do różnych dostawców i modeli.';
	@override String get loading => 'Wczytywanie ustawień orkiestracji…';
	@override String get loadError => 'Nie udało się wczytać ustawień orkiestracji.';
	@override String get retry => 'Spróbuj ponownie';
	@override late final Translations$settings$orchestration$enable$pl enable = Translations$settings$orchestration$enable$pl._(_root);
	@override late final Translations$settings$orchestration$pool$pl pool = Translations$settings$orchestration$pool$pl._(_root);
	@override late final Translations$settings$orchestration$tiers$pl tiers = Translations$settings$orchestration$tiers$pl._(_root);
	@override late final Translations$settings$orchestration$rules$pl rules = Translations$settings$orchestration$rules$pl._(_root);
	@override late final Translations$settings$orchestration$planner$pl planner = Translations$settings$orchestration$planner$pl._(_root);
	@override late final Translations$settings$orchestration$execution$pl execution = Translations$settings$orchestration$execution$pl._(_root);
	@override late final Translations$settings$orchestration$save$pl save = Translations$settings$orchestration$save$pl._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$pl extends Translations$settings$notifications$en {
	Translations$settings$notifications$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Powiadomienia';
	@override String get description => 'Kontroluj, które zdarzenia powiadomień otrzymujesz.';
	@override late final Translations$settings$notifications$webPush$pl webPush = Translations$settings$notifications$webPush$pl._(_root);
	@override late final Translations$settings$notifications$device$pl device = Translations$settings$notifications$device$pl._(_root);
	@override late final Translations$settings$notifications$desktop$pl desktop = Translations$settings$notifications$desktop$pl._(_root);
	@override late final Translations$settings$notifications$sound$pl sound = Translations$settings$notifications$sound$pl._(_root);
	@override late final Translations$settings$notifications$events$pl events = Translations$settings$notifications$events$pl._(_root);
	@override late final Translations$settings$notifications$messaging$pl messaging = Translations$settings$notifications$messaging$pl._(_root);
	@override late final Translations$settings$notifications$channels$pl channels = Translations$settings$notifications$channels$pl._(_root);
	@override String get unpair => 'Rozłącz parę';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$pl extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$pl darkMode = Translations$settings$appearanceSettings$darkMode$pl._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$pl codeEditor = Translations$settings$appearanceSettings$codeEditor$pl._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$pl terminal = Translations$settings$appearanceSettings$terminal$pl._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$pl extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$pl title = Translations$settings$mcpForm$title$pl._(_root);
	@override late final Translations$settings$mcpForm$importMode$pl importMode = Translations$settings$mcpForm$importMode$pl._(_root);
	@override late final Translations$settings$mcpForm$scope$pl scope = Translations$settings$mcpForm$scope$pl._(_root);
	@override late final Translations$settings$mcpForm$fields$pl fields = Translations$settings$mcpForm$fields$pl._(_root);
	@override late final Translations$settings$mcpForm$placeholders$pl placeholders = Translations$settings$mcpForm$placeholders$pl._(_root);
	@override late final Translations$settings$mcpForm$validation$pl validation = Translations$settings$mcpForm$validation$pl._(_root);
	@override String configDetails({required Object configFile}) => 'Szczegóły konfiguracji (z ${configFile})';
	@override String projectPath({required Object path}) => 'Ścieżka: ${path}';
	@override late final Translations$settings$mcpForm$actions$pl actions = Translations$settings$mcpForm$actions$pl._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$pl extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get success => 'Ustawienia zapisano pomyślnie!';
	@override String get error => 'Nie udało się zapisać ustawień';
	@override String get saving => 'Zapisywanie...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$pl extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get save => 'Zapisz ustawienia';
	@override String get cancel => 'Anuluj';
}

// Path: settings.git
class Translations$settings$git$pl extends Translations$settings$git$en {
	Translations$settings$git$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konfiguracja Git';
	@override String get description => 'Skonfiguruj swoją tożsamość Git do commitów. Te ustawienia zostaną zastosowane globalnie przez git config --global';
	@override late final Translations$settings$git$name$pl name = Translations$settings$git$name$pl._(_root);
	@override late final Translations$settings$git$email$pl email = Translations$settings$git$email$pl._(_root);
	@override late final Translations$settings$git$actions$pl actions = Translations$settings$git$actions$pl._(_root);
	@override late final Translations$settings$git$status$pl status = Translations$settings$git$status$pl._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$pl extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Klucze API';
	@override String get description => 'Generuj klucze API, aby uzyskiwać dostęp do zewnętrznego API z innych aplikacji.';
	@override late final Translations$settings$apiKeys$newKey$pl newKey = Translations$settings$apiKeys$newKey$pl._(_root);
	@override late final Translations$settings$apiKeys$form$pl form = Translations$settings$apiKeys$form$pl._(_root);
	@override String get newButton => 'Nowy klucz API';
	@override String get empty => 'Nie utworzono jeszcze żadnych kluczy API.';
	@override late final Translations$settings$apiKeys$list$pl list = Translations$settings$apiKeys$list$pl._(_root);
	@override String get confirmDelete => 'Czy na pewno chcesz usunąć ten klucz API?';
	@override late final Translations$settings$apiKeys$status$pl status = Translations$settings$apiKeys$status$pl._(_root);
	@override late final Translations$settings$apiKeys$github$pl github = Translations$settings$apiKeys$github$pl._(_root);
	@override String get apiDocsLink => 'Dokumentacja API';
	@override late final Translations$settings$apiKeys$documentation$pl documentation = Translations$settings$apiKeys$documentation$pl._(_root);
	@override String get loading => 'Ładowanie...';
	@override late final Translations$settings$apiKeys$version$pl version = Translations$settings$apiKeys$version$pl._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$pl extends Translations$settings$tasks$en {
	Translations$settings$tasks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Sprawdzanie instalacji TaskMaster...';
	@override late final Translations$settings$tasks$notInstalled$pl notInstalled = Translations$settings$tasks$notInstalled$pl._(_root);
	@override late final Translations$settings$tasks$settings$pl settings = Translations$settings$tasks$settings$pl._(_root);
}

// Path: settings.agents
class Translations$settings$agents$pl extends Translations$settings$agents$en {
	Translations$settings$agents$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$pl authStatus = Translations$settings$agents$authStatus$pl._(_root);
	@override late final Translations$settings$agents$install$pl install = Translations$settings$agents$install$pl._(_root);
	@override late final Translations$settings$agents$update$pl update = Translations$settings$agents$update$pl._(_root);
	@override late final Translations$settings$agents$account$pl account = Translations$settings$agents$account$pl._(_root);
	@override String get connectionStatus => 'Stan połączenia';
	@override late final Translations$settings$agents$login$pl login = Translations$settings$agents$login$pl._(_root);
	@override late final Translations$settings$agents$logout$pl logout = Translations$settings$agents$logout$pl._(_root);
	@override String error({required Object error}) => 'Błąd: ${error}';
	@override late final Translations$settings$agents$accounts$pl accounts = Translations$settings$agents$accounts$pl._(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$pl extends Translations$settings$permissions$en {
	Translations$settings$permissions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ustawienia uprawnień';
	@override late final Translations$settings$permissions$permissionMode$pl permissionMode = Translations$settings$permissions$permissionMode$pl._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$pl extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Serwery MCP';
	@override late final Translations$settings$mcpServers$description$pl description = Translations$settings$mcpServers$description$pl._(_root);
	@override String get addButton => 'Dodaj serwer MCP';
	@override String get empty => 'Brak skonfigurowanych serwerów MCP';
	@override String get serverType => 'Typ';
	@override late final Translations$settings$mcpServers$scope$pl scope = Translations$settings$mcpServers$scope$pl._(_root);
	@override late final Translations$settings$mcpServers$config$pl config = Translations$settings$mcpServers$config$pl._(_root);
	@override late final Translations$settings$mcpServers$tools$pl tools = Translations$settings$mcpServers$tools$pl._(_root);
	@override late final Translations$settings$mcpServers$actions$pl actions = Translations$settings$mcpServers$actions$pl._(_root);
	@override late final Translations$settings$mcpServers$managed$pl managed = Translations$settings$mcpServers$managed$pl._(_root);
	@override late final Translations$settings$mcpServers$help$pl help = Translations$settings$mcpServers$help$pl._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$pl deleteConfirm = Translations$settings$mcpServers$deleteConfirm$pl._(_root);
}

// Path: settings.quota
class Translations$settings$quota$pl extends Translations$settings$quota$en {
	Translations$settings$quota$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$pl settings = Translations$settings$quota$settings$pl._(_root);
	@override late final Translations$settings$quota$empty$pl empty = Translations$settings$quota$empty$pl._(_root);
	@override late final Translations$settings$quota$quality$pl quality = Translations$settings$quota$quality$pl._(_root);
	@override String get syncFailed => 'Synchronizacja nie powiodła się';
	@override String get syncNow => 'Synchronizuj teraz';
}

// Path: settings.browser
class Translations$settings$browser$pl extends Translations$settings$browser$en {
	Translations$settings$browser$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get checking => 'sprawdzanie...';
	@override String get description => 'Pozwól agentom tworzyć nadzorowane sesje przeglądarki Playwright, które możesz monitorować w zakładce Browser.';
	@override String get enableDescription => 'Rejestruje Browser dla obsługiwanych agentów. Agenci mogą tworzyć sesje przeglądarki; możesz je obserwować, zatrzymywać i usuwać.';
	@override String get enableLabel => 'Włącz Browser';
	@override late final Translations$settings$browser$errors$pl errors = Translations$settings$browser$errors$pl._(_root);
	@override String get installHint => 'Zainstaluj środowisko przeglądarki, zanim agenci będą mogli tworzyć sesje Browser.';
	@override String get installRuntime => 'Zainstaluj środowisko';
	@override String get installed => 'zainstalowane';
	@override String get installing => 'Instalowanie...';
	@override String get missing => 'brak';
	@override String get runtimeRequired => 'Wymagane środowisko przeglądarki';
	@override String get statusDisabled => 'wyłączony';
	@override String get statusLabel => 'Status';
	@override String get statusReady => 'gotowy';
	@override String get statusSetupRequired => 'wymagana konfiguracja';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$pl extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Anuluj';
	@override String get create => 'Dodaj obszar roboczy';
	@override String get deleteConfirm => 'Usunąć ten obszar roboczy z DDAgent? Jego pliki pozostaną na dysku.';
	@override String get deleteFailed => 'Nie udało się usunąć obszaru roboczego.';
	@override String get deleteTitle => 'Usuń obszar roboczy';
	@override String get description => 'Obszary robocze to katalogi, w których DDAgent może czatować, uruchamiać kod i przeglądać.';
	@override String get remove => 'Usuń obszar roboczy';
	@override String get title => 'Obszary robocze';
	@override String get pathRequired => 'Ścieżka jest wymagana';
}

// Path: settings.stt
class Translations$settings$stt$pl extends Translations$settings$stt$en {
	Translations$settings$stt$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wprowadzanie głosowe (speech-to-text)';
	@override String get description => 'Endpoint zgodny z Whisper /audio/transcriptions (OpenAI, whisper.cpp, faster-whisper, Speaches). Włącza przycisk mikrofonu w polu wiadomości.';
	@override String get configured => 'skonfigurowano';
	@override String get endpoint => 'URL endpointu (np. https://api.openai.com/v1)';
	@override String get apiKey => 'Klucz API';
	@override String get model => 'Model (domyślnie: whisper-1)';
	@override String get save => 'Zapisz';
}

// Path: settings.schedules
class Translations$settings$schedules$pl extends Translations$settings$schedules$en {
	Translations$settings$schedules$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Harmonogram';
	@override String get description => 'Cykliczne uruchomienia agentów wg cron. Uruchamiają się bez nadzoru z pominięciem uprawnień.';
	@override String get preventSleep => 'Blokuj uśpienie, gdy agenty pracują';
	@override String get preventSleepHint => 'Na desktopie utrzymuje ekran wybudzony; w przeglądarce używa Wake Lock API.';
	@override String get kNew => 'Nowy harmonogram';
	@override String get loading => 'Ładowanie…';
	@override String get empty => 'Brak harmonogramów.';
	@override String get project => 'Projekt';
	@override String get provider => 'Provider';
	@override String get cron => 'Cron (min godz dzień mies dzień-tyg)';
	@override String nextRun({required Object time}) => 'Następne uruchomienie: ${time}';
	@override String get cronInvalid => 'Brak nadchodzącego uruchomienia dla tego wyrażenia';
	@override String get prompt => 'Prompt';
	@override String get useWorktree => 'Uruchom w nowym worktree';
	@override String get catchUp => 'Nadrabiaj przegapione uruchomienia';
	@override String failures({required Object count}) => '${count} błędów';
	@override String get disabled => 'wyłączony';
	@override String get history => 'Historia';
	@override String get runNow => 'Uruchom teraz';
	@override String get delete => 'Usuń';
	@override String get noRuns => 'Brak uruchomień.';
	@override String get next => 'nast.';
	@override String get create => 'Utwórz';
	@override String get toggleSchedule => 'Włącz harmonogram';
}

// Path: settings.mcpTokens
class Translations$settings$mcpTokens$pl extends Translations$settings$mcpTokens$en {
	Translations$settings$mcpTokens$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tokeny serwera MCP DDAgenta';
	@override String get description => 'Zewnętrzne narzędzia (Claude Desktop, OpenClaw) wywołują narzędzia DDAgenta przez POST /mcp z tymi tokenami bearer.';
	@override String get dismiss => 'Zamknij';
	@override String get labelPlaceholder => 'Etykieta tokenu (np. Claude Desktop)';
	@override String get create => 'Utwórz';
	@override String get empty => 'Brak tokenów MCP.';
	@override String lastUsed({required Object time}) => 'użyty ${time}';
	@override String get neverUsed => 'nigdy nie użyty';
}

// Path: settings.about
class Translations$settings$about$pl extends Translations$settings$about$en {
	Translations$settings$about$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Wesprzyj projekt';
	@override String get buyMeACoffee => 'Postaw mi kawę';
	@override String get tryHosted => 'Wypróbuj DDAgent Hosted';
	@override String get learnMore => 'Dowiedz się więcej';
	@override String get proFeatures => 'Funkcje DDAgent Pro';
	@override late final Translations$settings$about$pro$pl pro = Translations$settings$about$pro$pl._(_root);
	@override String get versionInfo => 'Informacje o wersji';
	@override String get client => 'Aplikacja';
	@override String get server => 'Serwer';
	@override String get platformMobile => 'Mobilna';
	@override String get platformDesktop => 'Desktopowa';
	@override String get platformWeb => 'Web';
	@override String get unknown => 'nieznana';
	@override String get copyright => '© 2026 DDAgent — wszelkie prawa zastrzeżone';
	@override String get tagline => 'Otwartoźródłowy interfejs asystenta AI do programowania';
	@override String get docs => 'Dokumentacja';
	@override String get hostedDescription => 'Współpraca zespołowa, współdzielone konfiguracje MCP, synchronizacja ustawień między środowiskami i zarządzana infrastruktura.';
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$pl extends Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Wszystkie skróty klawiszowe w DDAgent, wg platformy.';
	@override String get action => 'Akcja';
	@override String get winLinux => 'Windows / Linux';
	@override String get mac => 'macOS';
	@override String get navigation => 'Nawigacja';
	@override String get navWorkspace => 'Przejdź do Workspace';
	@override String get navTasks => 'Przejdź do Zadań / Git';
	@override String get navGit => 'Przejdź do Git';
	@override String get navFocus => 'Tryb fokusowy (pasek boczny)';
	@override String get navSwitcher => 'Szybkie przełączanie sesji';
	@override String get navPalette => 'Paleta poleceń';
	@override String get navSettings => 'Otwórz ustawienia';
	@override String get navClose => 'Zamknij dialog / przywróć podział';
	@override String get composer => 'Pole wiadomości';
	@override String get compSend => 'Wyślij wiadomość';
	@override String get compNewline => 'Nowa linia';
	@override String get compNav => 'Nawigacja po podpowiedziach';
	@override String get compAccept => 'Wybierz podpowiedź';
	@override String get compCloseSuggest => 'Zamknij podpowiedzi';
	@override String get transcript => 'Transkrypcja';
	@override String get trCopy => 'Kopiuj zaznaczony tekst';
	@override String get trClose => 'Zamknij wyszukiwanie / podgląd';
	@override String get terminal => 'Terminal';
	@override String get termCopy => 'Kopiuj zaznaczenie';
	@override String get termInterrupt => 'Przerwij proces (bez zaznaczenia)';
	@override String get termPaste => 'Wklej';
	@override String get termSelectAll => 'Zaznacz wszystko';
	@override String get editor => 'Edytor';
	@override String get edSave => 'Zapisz plik';
	@override String get edSaveAll => 'Zapisz wszystkie pliki';
	@override String get edClose => 'Zamknij kartę';
	@override String get edNextTab => 'Następna karta';
	@override String get edPrevTab => 'Poprzednia karta';
	@override String get edIndent => 'Wcięcie / cofnięcie wcięcia';
	@override String get palette => 'Paleta poleceń';
	@override String get palNav => 'Nawigacja po elementach';
	@override String get palRun => 'Uruchom / otwórz';
	@override String get palBack => 'Wstecz (puste pole)';
	@override String get palClose => 'Zamknij';
}

// Path: sidebar.projects
class Translations$sidebar$projects$pl extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Projekty';
	@override String get newProject => 'Nowy projekt';
	@override String get deleteProject => 'Usuń projekt';
	@override String get renameProject => 'Zmień nazwę projektu';
	@override String get noProjects => 'Nie znaleziono projektów';
	@override String get loadingProjects => 'Ładowanie projektów...';
	@override String get searchPlaceholder => 'Szukaj projektów...';
	@override String get projectNamePlaceholder => 'Nazwa projektu';
	@override String get starred => 'Ulubione';
	@override String get all => 'Wszystkie';
	@override String get untitledSession => 'Sesja bez nazwy';
	@override String get newSession => 'Nowa sesja';
	@override String get codexSession => 'Sesja Codex';
	@override String get fetchingProjects => 'Pobieranie Twoich projektów i sesji Claude';
	@override String get projects => 'projekty';
	@override String get noMatchingProjects => 'Brak pasujących projektów';
	@override String get tryDifferentSearch => 'Spróbuj zmienić wyszukiwane hasło';
	@override String get runClaudeCli => 'Uruchom Claude CLI w katalogu projektu, aby rozpocząć';
}

// Path: sidebar.app
class Translations$sidebar$app$pl extends Translations$sidebar$app$en {
	Translations$sidebar$app$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'Interfejs asystenta programowania AI';
}

// Path: sidebar.panel
class Translations$sidebar$panel$pl extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get open => 'Panel';
	@override String get newChat => 'Nowy czat';
	@override String get navigation => 'Nawigacja';
	@override String get sessions => 'Sesje';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$pl extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sesje';
	@override String get newSession => 'Nowa sesja';
	@override String get deleteSession => 'Usuń sesję';
	@override String get renameSession => 'Zmień nazwę sesji';
	@override String get noSessions => 'Nie ma jeszcze żadnych sesji';
	@override String get loadingSessions => 'Ładowanie sesji...';
	@override String get unnamed => 'Bez nazwy';
	@override String get loading => 'Ładowanie...';
	@override String get showMore => 'Pokaż więcej sesji';
	@override String get selectMode => 'Zaznacz';
	@override String get selectAll => 'Zaznacz wszystkie';
	@override String archiveSelected({required Object count}) => 'Archiwizuj (${count})';
	@override String deleteSelected({required Object count}) => 'Usuń (${count})';
	@override String get cancelSelection => 'Anuluj zaznaczanie';
	@override String get toggleSelection => 'Przełącz zaznaczenie sesji';
	@override String get selectionToolbar => 'Akcje zaznaczonych sesji';
	@override String get options => 'Opcje sesji';
	@override String get pinSession => 'Przypnij sesję';
	@override String get unpinSession => 'Odepnij sesję';
	@override String get pinned => 'Przypięta sesja';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Zaznaczono ${count}',
		few: 'Zaznaczono ${count}',
		many: 'Zaznaczono ${count}',
		other: 'Zaznaczono ${count}',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$pl extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Wyświetl środowiska';
	@override String get hideSidebar => 'Ukryj panel boczny';
	@override String get createProject => 'Utwórz nowy projekt';
	@override String get refresh => 'Odśwież projekty i sesje (Ctrl+R)';
	@override String get renameProject => 'Zmień nazwę projektu (F2)';
	@override String get deleteProject => 'Usuń projekt z panelu bocznego (Delete)';
	@override String get addToFavorites => 'Dodaj do ulubionych';
	@override String get removeFromFavorites => 'Usuń z ulubionych';
	@override String get editSessionName => 'Ręcznie zmień nazwę sesji';
	@override String get deleteSession => 'Usuń tę sesję trwale';
	@override String get activeSessionIndicator => 'Ostatnio aktywna sesja (w ciągu ostatnich 10 minut)';
	@override String get save => 'Zapisz';
	@override String get cancel => 'Anuluj';
	@override String get clearSearch => 'Wyczyść wyszukiwanie';
	@override String get openCommandPalette => 'Otwórz paletę poleceń';
	@override String get attentionRequiredIndicator => 'Sesja wymaga uwagi';
	@override String get openSessions => 'Przeglądaj sesje';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$pl extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Czat';
	@override String get files => 'Pliki';
	@override String get git => 'Git';
	@override String get terminal => 'Terminal';
	@override String get tasks => 'Zadania';
}

// Path: sidebar.actions
class Translations$sidebar$actions$pl extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Odśwież';
	@override String get settings => 'Ustawienia';
	@override String get collapseAll => 'Zwiń wszystko';
	@override String get expandAll => 'Rozwiń wszystko';
	@override String get cancel => 'Anuluj';
	@override String get save => 'Zapisz';
	@override String get delete => 'Usuń';
	@override String get rename => 'Zmień nazwę';
	@override String get joinCommunity => 'Dołącz do społeczności';
	@override String get reportIssue => 'Zgłoś problem';
	@override String get starOnGithub => 'Dodaj gwiazdkę na GitHub';
	@override String get buyMeACoffee => 'Postaw mi kawę';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$pl extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zmień workspace sesji';
	@override String get description => 'Agent wykona kolejne tury w tym katalogu. Historia sesji zostanie zachowana.';
	@override String get pathLabel => 'Ścieżka workspace';
	@override String get pathRequired => 'Ścieżka workspace jest wymagana.';
	@override String get submit => 'Zmień workspace';
	@override String get saving => 'Zmienianie…';
	@override String get changeAction => 'Zmień workspace';
}

// Path: sidebar.branding
class Translations$sidebar$branding$pl extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Open Source';
}

// Path: sidebar.status
class Translations$sidebar$status$pl extends Translations$sidebar$status$en {
	Translations$sidebar$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get active => 'Aktywna';
	@override String get inactive => 'Nieaktywna';
	@override String get thinking => 'Myślenie...';
	@override String get error => 'Błąd';
	@override String get aborted => 'Przerwano';
	@override String get unknown => 'Nieznany';
}

// Path: sidebar.time
class Translations$sidebar$time$pl extends Translations$sidebar$time$en {
	Translations$sidebar$time$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Właśnie teraz';
	@override String get oneMinuteAgo => '1 min temu';
	@override String minutesAgo({required Object count}) => '${count} min temu';
	@override String get oneHourAgo => '1 godz. temu';
	@override String hoursAgo({required Object count}) => '${count} godz. temu';
	@override String get oneDayAgo => '1 dzień temu';
	@override String daysAgo({required Object count}) => '${count} dni temu';
}

// Path: sidebar.messages
class Translations$sidebar$messages$pl extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => 'Czy na pewno chcesz to usunąć?';
	@override String get renameSuccess => 'Pomyślnie zmieniono nazwę';
	@override String get deleteSuccess => 'Pomyślnie usunięto';
	@override String get errorOccurred => 'Wystąpił błąd';
	@override String get deleteSessionConfirm => 'Czy na pewno chcesz usunąć tę sesję? Tej operacji nie można cofnąć.';
	@override String get deleteProjectConfirm => 'Usunąć ten projekt z panelu bocznego? Pliki projektu, pamięci i dane sesji nie zostaną usunięte.';
	@override String get enterProjectPath => 'Podaj ścieżkę projektu';
	@override String get deleteSessionFailed => 'Nie udało się usunąć sesji. Spróbuj ponownie.';
	@override String get deleteSessionError => 'Błąd podczas usuwania sesji. Spróbuj ponownie.';
	@override String get renameSessionFailed => 'Nie udało się zmienić nazwy sesji. Spróbuj ponownie.';
	@override String get renameSessionError => 'Błąd podczas zmiany nazwy sesji. Spróbuj ponownie.';
	@override String get changeWorkspaceFailed => 'Nie udało się zmienić workspace. Spróbuj ponownie.';
	@override String get changeWorkspaceError => 'Błąd podczas zmiany workspace. Spróbuj ponownie.';
	@override String get deleteProjectFailed => 'Nie udało się usunąć projektu. Spróbuj ponownie.';
	@override String get deleteProjectError => 'Błąd podczas usuwania projektu. Spróbuj ponownie.';
	@override String get createProjectFailed => 'Nie udało się utworzyć projektu. Spróbuj ponownie.';
	@override String get createProjectError => 'Błąd podczas tworzenia projektu. Spróbuj ponownie.';
	@override String get updateProjectError => 'Błąd podczas aktualizowania projektu. Spróbuj ponownie.';
	@override String get refreshError => 'Nie udało się odświeżyć. Spróbuj ponownie.';
	@override String get restoreProjectFailed => 'Nie udało się przywrócić projektu. Spróbuj ponownie.';
	@override String get restoreProjectError => 'Błąd podczas przywracania projektu. Spróbuj ponownie.';
	@override String get restoreSessionFailed => 'Nie udało się przywrócić sesji. Spróbuj ponownie.';
	@override String get restoreSessionError => 'Błąd podczas przywracania sesji. Spróbuj ponownie.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Nie udało się usunąć sesji. Spróbuj ponownie.',
		few: 'Nie udało się usunąć ${count} sesji. Spróbuj ponownie.',
		many: 'Nie udało się usunąć ${count} sesji. Spróbuj ponownie.',
		other: 'Nie udało się usunąć ${count} sesji. Spróbuj ponownie.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$pl extends Translations$sidebar$version$en {
	Translations$sidebar$version$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Dostępna aktualizacja';
	@override String get restartRequired => 'Zainstalowano aktualizację — uruchom ponownie serwer, aby zastosować zmiany';
	@override String get updateNow => 'Aktualizuj';
	@override String updateConfirm({required Object version}) => 'Zaktualizować DDAgent do v${version}? Najnowszy kod zostanie pobrany i zbudowany, a serwer uruchomi się ponownie — aktywne sesje zostaną przerwane.';
	@override String get updating => 'Aktualizowanie… może potrwać kilka minut';
	@override String get restarting => 'Zainstalowano — restartowanie…';
	@override String get updateFailed => 'Aktualizacja nie powiodła się';
	@override String get releaseNotes => 'Informacje o wydaniu';
}

// Path: sidebar.search
class Translations$sidebar$search$pl extends Translations$sidebar$search$en {
	Translations$sidebar$search$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Projekty';
	@override String get modeConversations => 'Rozmowy';
	@override String get conversationsPlaceholder => 'Szukaj w rozmowach...';
	@override String get searching => 'Wyszukiwanie...';
	@override String get sessionTitles => 'Sesja';
	@override String get conversationContents => 'Treść rozmowy';
	@override String get noResults => 'Brak wyników';
	@override String get tryDifferentQuery => 'Spróbuj innego zapytania';
	@override String get modeRunning => 'W toku';
	@override String get archiveOnly => 'Archiwum';
	@override String get runningTooltip => 'Sesje w toku';
	@override String get archiveOnlyTooltip => 'Tylko archiwum';
	@override String runningCount({required Object count}) => '${count} aktywnych';
	@override String get viewMenu => 'Widok';
	@override String get backToProjects => 'Wróć do projektów';
	@override String get archivedPlaceholder => 'Szukaj w archiwum...';
	@override String get runningPlaceholder => 'Szukaj w sesjach w toku...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} dopasowanie',
		other: '${count} dopasowań',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Przeskanowano ${count} projekt',
		other: 'Przeskanowano ${count} projektów',
	);
}

// Path: sidebar.recent
class Translations$sidebar$recent$pl extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ostatnie rozmowy';
	@override String get emptyTitle => 'Nie ma jeszcze żadnych rozmów';
	@override String get emptyDescription => 'Tutaj pojawią się Twoje ostatnio aktualizowane rozmowy.';
	@override String get loadFailed => 'Nie można załadować ostatnich rozmów';
	@override String get loadMore => 'Załaduj starsze rozmowy';
	@override String get loadingMore => 'Ładowanie kolejnych...';
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$pl extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Usuń projekt';
	@override String get deleteSession => 'Usuń sesję';
	@override String get confirmDelete => 'Co chcesz zrobić z:';
	@override String get removeFromSidebar => 'Usuń tylko z panelu bocznego';
	@override String get deleteAllData => 'Usuń trwale wszystkie dane';
	@override String get allConversationsDeleted => 'Projekt zostanie usunięty z panelu bocznego. Twoje pliki, pamięci i dane sesji zostaną zachowane.';
	@override String get cannotUndo => 'Możesz później dodać projekt ponownie.';
	@override String get bulkDeleteSessionsDescription => 'Archiwizacja ukryje zaznaczone sesje na liście aktywnych, zachowując ich historię. Usunięcie trwałe skasuje je wraz z transkryptami.';
	@override String get archiveSession => 'Archiwizuj sesję';
	@override String get archiveSessionNotice => 'Archiwizacja ukryje sesję na liście aktywnych, zachowując jej historię.';
	@override String get archivedSessionNotice => 'Ta sesja jest już zarchiwizowana. Możesz ją pozostawić ukrytą lub usunąć trwale.';
	@override String get deleteSessionNotice => 'To trwale usunie sesję wraz z transkryptem. Tej operacji nie można cofnąć.';
	@override String get deleteSessionPermanently => 'Usuń trwale';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Ten projekt zawiera ${count} rozmowę.',
		other: 'Ten projekt zawiera ${count} rozmów.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Zarządzaj zaznaczoną sesją',
		few: 'Zarządzaj ${count} zaznaczonymi sesjami',
		many: 'Zarządzaj ${count} zaznaczonymi sesjami',
		other: 'Zarządzaj ${count} zaznaczonymi sesjami',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Archiwizuj sesję',
		few: 'Archiwizuj ${count} sesje',
		many: 'Archiwizuj ${count} sesji',
		other: 'Archiwizuj ${count} sesji',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$pl extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Aktywne teraz';
	@override String get recent => 'Ostatnio używane';
	@override String get today => 'Dzisiaj';
	@override String get yesterday => 'Wczoraj';
	@override String get thisWeek => 'W tym tygodniu';
	@override String showMore({required Object count}) => 'Pokaż jeszcze ${count}';
	@override String get showLess => 'Pokaż mniej';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$pl extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get board => 'Tablica agentów';
	@override String get files => 'Pliki';
	@override String get git => 'Kontrola źródła';
	@override String get tasks => 'Zadania';
	@override String get usage => 'Limity i zużycie';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$pl extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI nie jest skonfigurowany';
	@override String get description => 'TaskMaster pomaga dzielić złożone projekty na łatwe w realizacji zadania dzięki wsparciu AI';
	@override String get whatIsTitle => '🎯 Czym jest TaskMaster?';
	@override late final Translations$tasks$notConfigured$features$pl features = Translations$tasks$notConfigured$features$pl._(_root);
	@override String get initializeButton => 'Zainicjuj TaskMaster AI';
	@override String get writePrdFirst => 'Najpierw napisz PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$pl extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pierwsze kroki z TaskMaster';
	@override String get subtitle => 'TaskMaster został zainicjowany! Oto co zrobić dalej:';
	@override late final Translations$tasks$gettingStarted$steps$pl steps = Translations$tasks$gettingStarted$steps$pl._(_root);
	@override String get tip => '💡 Wskazówka: zacznij od PRD, aby w pełni wykorzystać generowanie zadań przez AI w TaskMaster';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$pl extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konfiguracja TaskMaster';
	@override String subtitle({required Object projectName}) => 'Interaktywny CLI dla ${projectName}';
	@override String get willStart => 'Inicjalizacja TaskMaster rozpocznie się automatycznie';
	@override String get completed => 'Konfiguracja TaskMaster zakończona! Możesz teraz zamknąć to okno.';
	@override String get closeButton => 'Zamknij';
	@override String get closeContinueButton => 'Zamknij i kontynuuj';
	@override String get closeTitle => 'Zamknij';
	@override String get description => 'Tworzy folder .taskmaster w tym projekcie. Nie wymaga zewnętrznych narzędzi ani kluczy API — zadania są przechowywane lokalnie.';
	@override String get initializeButton => 'Zainicjuj';
	@override String get initializing => 'Inicjowanie...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$pl extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pierwsze kroki z TaskMaster';
	@override String get subtitle => 'Twój przewodnik po wydajnym zarządzaniu zadaniami';
	@override late final Translations$tasks$helpGuide$examples$pl examples = Translations$tasks$helpGuide$examples$pl._(_root);
	@override String get moreExamples => 'Zobacz więcej przykładów i wzorców użycia →';
	@override late final Translations$tasks$helpGuide$proTips$pl proTips = Translations$tasks$helpGuide$proTips$pl._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$pl learnMore = Translations$tasks$helpGuide$learnMore$pl._(_root);
	@override String get closeTitle => 'Zamknij';
}

// Path: tasks.search
class Translations$tasks$search$pl extends Translations$tasks$search$en {
	Translations$tasks$search$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Szukaj zadań...';
}

// Path: tasks.filters
class Translations$tasks$filters$pl extends Translations$tasks$filters$en {
	Translations$tasks$filters$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get button => 'Filtry';
	@override String get status => 'Status';
	@override String get priority => 'Priorytet';
	@override String get sortBy => 'Sortuj według';
	@override String get allStatuses => 'Wszystkie statusy';
	@override String get allPriorities => 'Wszystkie priorytety';
	@override String showing({required Object filtered, required Object total}) => 'Wyświetlanie ${filtered} z ${total} zadań';
	@override String get clearFilters => 'Wyczyść filtry';
}

// Path: tasks.sort
class Translations$tasks$sort$pl extends Translations$tasks$sort$en {
	Translations$tasks$sort$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Status';
	@override String get priority => 'Priorytet';
	@override String get idAsc => 'ID (rosnąco)';
	@override String get idDesc => 'ID (malejąco)';
	@override String get titleAsc => 'Tytuł (A-Z)';
	@override String get titleDesc => 'Tytuł (Z-A)';
	@override String get statusAsc => 'Status (najpierw oczekujące)';
	@override String get statusDesc => 'Status (najpierw ukończone)';
	@override String get priorityAsc => 'Priorytet (najpierw wysoki)';
	@override String get priorityDesc => 'Priorytet (najpierw niski)';
}

// Path: tasks.views
class Translations$tasks$views$pl extends Translations$tasks$views$en {
	Translations$tasks$views$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Widok Kanban';
	@override String get list => 'Widok listy';
	@override String get grid => 'Widok siatki';
}

// Path: tasks.kanban
class Translations$tasks$kanban$pl extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 Do zrobienia';
	@override String get inProgress => '🚀 W toku';
	@override String get review => '👀 Przegląd';
	@override String get done => '✅ Ukończone';
	@override String get blocked => '🚫 Zablokowane';
	@override String get deferred => '⏳ Odroczone';
	@override String get cancelled => '❌ Anulowane';
	@override String get noTasksYet => 'Brak zadań';
	@override String get tasksWillAppear => 'Zadania pojawią się tutaj';
	@override String get moveTasksHere => 'Przenieś tutaj zadania po rozpoczęciu';
	@override String get completedTasksHere => 'Ukończone zadania pojawią się tutaj';
	@override String get statusTasksHere => 'Zadania z tym statusem pojawią się tutaj';
}

// Path: tasks.buttons
class Translations$tasks$buttons$pl extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get help => 'Przewodnik po pierwszych krokach z TaskMaster';
	@override String get prds => 'PRD';
	@override String get addPRD => 'Dodaj PRD';
	@override String get addTask => 'Dodaj zadanie';
	@override String get createNewPRD => 'Utwórz nowy PRD';
	@override String prdsAvailable({required Object count}) => 'Dostępne PRD: ${count}';
}

// Path: tasks.prd
class Translations$tasks$prd$pl extends Translations$tasks$prd$en {
	Translations$tasks$prd$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Zmodyfikowano: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String get newFile => 'nowy plik';
	@override String get template => 'Szablon';
	@override String get parse => 'Przetwórz PRD';
	@override String get fileExistsTitle => 'Plik już istnieje';
	@override String fileExistsMessage({required Object name}) => 'PRD o nazwie "${name}" już istnieje. Czy chcesz go nadpisać?';
	@override String get fileNameHint => 'nazwa pliku (np. prd.txt)';
	@override String get saved => 'Zapisano PRD';
	@override String get tasksGenerated => 'Wygenerowano zadania z PRD';
}

// Path: tasks.statuses
class Translations$tasks$statuses$pl extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Oczekujące';
	@override String get inProgress => 'W toku';
	@override String get done => 'Ukończone';
	@override String get blocked => 'Zablokowane';
	@override String get deferred => 'Odroczone';
	@override String get cancelled => 'Anulowane';
	@override String get review => 'Przegląd';
}

// Path: tasks.priorities
class Translations$tasks$priorities$pl extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get high => 'Wysoki';
	@override String get medium => 'Średni';
	@override String get low => 'Niski';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$pl extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Brak zadań pasujących do filtrów';
	@override String get description => 'Spróbuj zmienić kryteria wyszukiwania lub filtrów.';
}

// Path: tasks.board
class Translations$tasks$board$pl extends Translations$tasks$board$en {
	Translations$tasks$board$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tablica agenta';
	@override String get subtitle => 'Przenieś kartę do „Do roboty”, a agent ją podejmie. Kliknij kartę, aby otworzyć jej sesję.';
	@override String get newCard => 'Nowa karta';
	@override String get addCard => 'Dodaj kartę';
	@override String get refresh => 'Odśwież';
	@override late final Translations$tasks$board$empty$pl empty = Translations$tasks$board$empty$pl._(_root);
	@override late final Translations$tasks$board$columns$pl columns = Translations$tasks$board$columns$pl._(_root);
	@override late final Translations$tasks$board$card$pl card = Translations$tasks$board$card$pl._(_root);
	@override late final Translations$tasks$board$dialog$pl dialog = Translations$tasks$board$dialog$pl._(_root);
	@override String get noProject => 'Najpierw dodaj projekt, potem twórz dla niego karty.';
	@override String get projectLabel => 'Projekt';
	@override String get backToChat => 'Powrót do czatu';
	@override late final Translations$tasks$board$agent$pl agent = Translations$tasks$board$agent$pl._(_root);
	@override late final Translations$tasks$board$deleteConfirm$pl deleteConfirm = Translations$tasks$board$deleteConfirm$pl._(_root);
	@override String get project => 'Projekt';
	@override late final Translations$tasks$board$assignee$pl assignee = Translations$tasks$board$assignee$pl._(_root);
	@override late final Translations$tasks$board$presence$pl presence = Translations$tasks$board$presence$pl._(_root);
	@override late final Translations$tasks$board$activity$pl activity = Translations$tasks$board$activity$pl._(_root);
	@override late final Translations$tasks$board$comments$pl comments = Translations$tasks$board$comments$pl._(_root);
}

// Path: tasks.card
class Translations$tasks$card$pl extends Translations$tasks$card$en {
	Translations$tasks$card$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Zależy od: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Zadanie ${id}';
	@override String get highPriority => 'Wysoki priorytet';
	@override String get lowPriority => 'Niski priorytet';
	@override String get mediumPriority => 'Średni priorytet';
	@override String get noPriority => 'Nie ustawiono priorytetu';
	@override String parentTask({required Object id}) => 'Zadanie ${id}';
	@override String get progressLabel => 'Postęp:';
	@override String progressTooltip({required Object completed, required Object total}) => 'Ukończono ${completed} z ${total} podzadań';
	@override String get runTask => 'Uruchom zadanie';
	@override String runTaskAria({required Object id}) => 'Uruchom zadanie ${id}';
	@override String statusTooltip({required Object status}) => 'Status: ${status}';
	@override String taskIdTitle({required Object id}) => 'ID zadania: ${id}';
	@override String get taskInProgress => 'Zadanie w trakcie';
}

// Path: tasks.createTask
class Translations$tasks$createTask$pl extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Anuluj';
	@override String get descriptionLabel => 'Opis';
	@override String get descriptionPlaceholder => 'Opcjonalne szczegóły';
	@override String get error => 'Nie udało się dodać zadania';
	@override String get priorityLabel => 'Priorytet';
	@override String get submit => 'Dodaj zadanie';
	@override String get submitting => 'Dodawanie...';
	@override String get title => 'Dodaj zadanie';
	@override String get titleLabel => 'Tytuł';
	@override String get titlePlaceholder => 'Co trzeba zrobić?';
}

// Path: tasks.list
class Translations$tasks$list$pl extends Translations$tasks$list$en {
	Translations$tasks$list$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Ukończone (kliknij, aby ponownie otworzyć)';
	@override String get inProgressComplete => 'W trakcie (kliknij, aby ukończyć)';
	@override String get markCompleted => 'Oznacz jako ukończone';
	@override String toggleStatusAria({required Object id}) => 'Przełącz status zadania ${id}';
	@override String get markDone => 'Oznacz jako ukończone';
	@override String get reopen => 'Otwórz ponownie';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$pl extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Wszystkie zadania ukończone';
	@override String get feature1 => '- Zarządzanie zadaniami wspomagane AI z zależnościami i podzadaniami.';
	@override String get feature2 => '- Generowanie zadań na podstawie PRD dla szybszego startu projektu.';
	@override String get feature3 => '- Widoki kanban i listy do codziennej pracy.';
	@override String get hideDetails => 'Ukryj szczegóły';
	@override String get initialize => 'Zainicjuj';
	@override String get noPending => 'Brak oczekujących zadań';
	@override String get notConfigured => 'TaskMaster AI nie jest skonfigurowany';
	@override String get review => 'Przejrzyj';
	@override String get startTask => 'Rozpocznij zadanie';
	@override String taskId({required Object id}) => 'Zadanie ${id}';
	@override String get viewAll => 'Zobacz wszystkie zadania';
	@override String get viewDetails => 'Zobacz szczegóły zadania';
	@override String get whatIs => 'Czym jest TaskMaster?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$pl extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Anuluj edycję';
	@override String get close => 'Zamknij';
	@override String get copyTaskId => 'Kopiuj ID zadania';
	@override String get delete => 'Usuń zadanie';
	@override String deleteConfirmDescription({required Object title}) => '„${title}" zostanie trwale usunięte.';
	@override String get deleteConfirmTitle => 'Usunąć zadanie?';
	@override String get deleteFailed => 'Nie udało się usunąć zadania';
	@override String get dependencies => 'Zależności';
	@override String get dependenciesPlaceholder => 'np. 1, 2, 3';
	@override String get description => 'Opis';
	@override String get edit => 'Edytuj zadanie';
	@override String get implDetails => 'Szczegóły implementacji';
	@override String get noDependencies => 'Brak zależności';
	@override String get noDescription => 'Brak opisu';
	@override String get priority => 'Priorytet';
	@override String get priorityNotSet => 'Nie ustawiono';
	@override String get save => 'Zapisz';
	@override String get status => 'Status';
	@override String get statusFailed => 'Nie udało się zaktualizować statusu zadania';
	@override String taskId({required Object id}) => 'Zadanie ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Zadanie ${id}: ${title}';
	@override String get testStrategy => 'Strategia testowania';
	@override String get titleRequired => 'Tytuł jest wymagany';
	@override String get updateFailed => 'Nie udało się zaktualizować zadania';
	@override String get notFound => 'Nie znaleziono zadania';
	@override String get subtasks => 'Podzadania';
	@override String deleteConfirmMessage({required Object id}) => 'Zadanie #${id} zostanie usunięte. Tej operacji nie można cofnąć.';
	@override String get idCopied => 'Skopiowano ID zadania';
}

// Path: tasks.toasts
class Translations$tasks$toasts$pl extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Zadanie ${id} ustawiono jako w toku';
}

// Path: tasks.taskmaster
class Translations$tasks$taskmaster$pl extends Translations$tasks$taskmaster$en {
	Translations$tasks$taskmaster$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get noProjectHint => 'Najpierw dodaj projekt, a potem utwórz dla niego zadania.';
	@override late final Translations$tasks$taskmaster$sort$pl sort = Translations$tasks$taskmaster$sort$pl._(_root);
	@override String installedVersion({required Object version}) => 'Zainstalowano: ${version}';
	@override String get initFailed => 'Nie udało się zainicjować TaskMaster';
	@override late final Translations$tasks$taskmaster$prd$pl prd = Translations$tasks$taskmaster$prd$pl._(_root);
	@override late final Translations$tasks$taskmaster$detail$pl detail = Translations$tasks$taskmaster$detail$pl._(_root);
	@override String get untitledTask => 'Zadanie bez tytułu';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$pl extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Pulpit';
	@override String get memories => 'Pamięci';
	@override String get rules => 'Reguły';
	@override String get skills => 'Skille';
	@override String get personal => 'Personal';
	@override String get graph => 'Graf';
}

// Path: knowledge.common
class Translations$knowledge$common$pl extends Translations$knowledge$common$en {
	Translations$knowledge$common$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get add => 'Dodaj';
	@override String get save => 'Zapisz';
	@override String get cancel => 'Anuluj';
	@override String get delete => 'Usuń';
	@override String get edit => 'Edytuj';
	@override String get close => 'Zamknij';
	@override String get restore => 'Przywróć';
	@override String get refresh => 'Odśwież';
	@override String get allProjects => 'Wszystkie projekty';
	@override String get global => 'Globalne';
}

// Path: knowledge.actions
class Translations$knowledge$actions$pl extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Skanuj pliki projektu';
	@override String get export => 'Eksportuj JSON';
	@override String get import => 'Importuj JSON';
	@override String get scanComplete => 'Skanowanie projektu zakończone';
	@override String get importComplete => 'Import zakończony';
	@override String get importFailed => 'Import nie powiódł się';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$pl extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Nowy wpis';
	@override String get editEntity => 'Edytuj wpis';
	@override String get deleteTitle => 'Usuń';
	@override String get deleteMessage => 'Usunąć ten wpis? Tego nie można cofnąć (historia zostaje zachowana).';
	@override String get pickIcon => 'Wybierz ikonę';
	@override String get removeIcon => 'Usuń ikonę';
	@override String get iconTooLarge => 'Ikona jest za duża (maks. 40 KB).';
	@override String get importTitle => 'Importuj wiedzę';
	@override String get importHint => 'Wklej tutaj wyeksportowany JSON';
	@override String get exportTitle => 'Eksportuj wiedzę';
	@override String get import => 'Importuj';
}

// Path: knowledge.fields
class Translations$knowledge$fields$pl extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get key => 'Klucz';
	@override String get title => 'Tytuł';
	@override String get name => 'Nazwa';
	@override String get description => 'Opis';
	@override String get category => 'Kategoria';
	@override String get content => 'Treść';
	@override String get priority => 'Priorytet';
	@override String get tags => 'Tagi';
	@override String get enabled => 'Włączone';
	@override String get projectScope => 'Zakres projektu';
	@override String get tagsHint => 'oddzielone przecinkami';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$pl extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Pamięci';
	@override String get rules => 'Reguły';
	@override String get skills => 'Skille';
	@override String get personal => 'Personal';
	@override String get connections => 'Połączenia';
	@override String get recent => 'Ostatnie pamięci';
	@override String get noMemories => 'Brak pamięci. Dodaj jedną w zakładce Pamięci.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$pl extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Brak pamięci.';
	@override String get rules => 'Brak reguł.';
	@override String get skills => 'Brak skilli.';
	@override String get personal => 'Brak danych osobowych.';
	@override String get graph => 'Brak encji do pokazania na grafie.';
}

// Path: knowledge.history
class Translations$knowledge$history$pl extends Translations$knowledge$history$en {
	Translations$knowledge$history$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Historia';
	@override String get none => 'Brak historii.';
	@override String get untitled => '(bez tytułu)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$pl extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Krytyczny';
	@override String get high => 'Wysoki';
	@override String get normal => 'Normalny';
	@override String get low => 'Niski';
}

// Path: knowledge.search
class Translations$knowledge$search$pl extends Translations$knowledge$search$en {
	Translations$knowledge$search$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Szukaj w wiedzy';
	@override String get hint => 'Szukaj pamięci, reguł, skilli…';
	@override String get noResults => 'Brak wyników.';
}

// Path: knowledge.links
class Translations$knowledge$links$pl extends Translations$knowledge$links$en {
	Translations$knowledge$links$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Połącz encje';
	@override String get source => 'Źródło';
	@override String get target => 'Cel';
	@override String get relationship => 'Relacja';
	@override String get add => 'Utwórz połączenie';
}

// Path: knowledge.tags
class Translations$knowledge$tags$pl extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get all => 'Wszystkie tagi';
	@override String get manage => 'Zarządzaj tagami';
	@override String get none => 'Brak tagów.';
}

// Path: knowledge.graph
class Translations$knowledge$graph$pl extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'obcięto';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$pl extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Importuj wszystko do DDAgent';
	@override String projectsScanned({required Object count}) => 'Przeskanowane projekty: ${count}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Znalezione skille agentów: ${found} (nowe: ${newSkills})';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Reguły: ${total} · grupy duplikatów: ${duplicates}';
	@override String get mergeDuplicates => 'Scal duplikaty wpisów';
	@override String get mergeDuplicatesHint => 'Scala zduplikowane wiersze w DDAgent (nie pliki)';
	@override String get action => 'Importuj wszystko';
	@override String get readOnlyNotice => 'Tylko odczyt po stronie agentów: import trafia do własnej bazy danych DDAgent i NIE modyfikuje ani nie usuwa żadnych plików ani konfiguracji CLI. Poniższe opcje zmieniają wyłącznie dane DDAgent.';
	@override String get dryRunNote => 'Próbny przebieg — nic jeszcze nie zapisano.';
	@override String get importedNote => 'Zaimportowano.';
	@override String result({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'Zaimportowano — reguły: ${rules}, nowe skille: ${newSkills}, usunięte: ${removed}, oznaczone jako krytyczne: ${promoted}';
	@override String get description => 'Przeskanuj wszystkie projekty i zaimportuj skille agentów do bazy wiedzy. Agenci są tylko odczytywani — w CLI nic się nie zmienia.';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$pl extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Migruj istniejące reguły';
	@override String scanned({required Object count}) => 'Przeskanowano ${count} projekt(ów).';
	@override String rulesSummary({required Object total, required Object critical}) => 'Reguły: ${total} łącznie, ${critical} krytycznych.';
	@override String duplicates({required Object count}) => 'Grupy duplikatów w projektach: ${count}';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Usunięte: ${removed}, awansowane: ${promoted}';
	@override String get mergeDuplicates => 'Scal duplikaty';
	@override String get dryRunNote => 'Próbny przebieg — nic jeszcze nie zostało zmienione.';
	@override String get applied => 'Zastosowano.';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$pl extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Importuj skille agentów';
	@override String found({required Object count}) => 'Znaleziono ${count} skill(i) u Twoich agentów.';
	@override String summary({required Object imported, required Object skipped}) => 'Nowe: ${imported} · pominięte: ${skipped}';
	@override String get dryRunHint => 'Importuje globalne/domyślne skille dostarczane przez agentów (użytkownika, systemowe, z wtyczek) jako skille w bazie wiedzy. Próbny przebieg — nic jeszcze nie zaimportowano.';
	@override String get importedNote => 'Zaimportowano do bazy wiedzy.';
}

// Path: knowledge.critical
class Translations$knowledge$critical$pl extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get make => 'Oznacz jako krytyczne';
	@override String get makeAll => 'Oznacz wszystkie reguły jako krytyczne';
	@override String get makeAllHint => 'Dodaje je do budżetu wstrzykiwanego kontekstu';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$pl extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
	@override String get title => 'Kontekst reguł (zawsze dołączany)';
	@override String get selectProject => 'Wybierz projekt, aby zobaczyć rozmiar jego krytycznego kontekstu.';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$pl extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Pamięć: ${title}';
	@override String rule({required Object title}) => 'Reguła: ${title}';
	@override String skill({required Object name}) => 'Skill: ${name}';
	@override String personal({required Object title}) => 'Osobiste: ${title}';
}

// Path: knowledge.errors
class Translations$knowledge$errors$pl extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'Import nie powiódł się: ${error}';
	@override String migrationFailed({required Object error}) => 'Migracja nie powiodła się: ${error}';
}

// Path: knowledge.entityTypes
class Translations$knowledge$entityTypes$pl extends Translations$knowledge$entityTypes$en {
	Translations$knowledge$entityTypes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get memory => 'Pamięć';
	@override String get rule => 'Reguła';
	@override String get skill => 'Skill';
	@override String get personal => 'Osobiste';
	@override String get project => 'Projekt';
	@override String get tag => 'Tag';
}

// Path: collab.roles
class Translations$collab$roles$pl extends Translations$collab$roles$en {
	Translations$collab$roles$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get member => 'Członek';
	@override String get viewer => 'Obserwator';
}

// Path: collab.viewing
class Translations$collab$viewing$pl extends Translations$collab$viewing$en {
	Translations$collab$viewing$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get session => 'sesja';
	@override String get card => 'karta';
	@override String get board => 'tablica';
}

// Path: fileTree.search
class Translations$fileTree$search$pl extends Translations$fileTree$search$en {
	Translations$fileTree$search$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Filtruj nazwy / Enter, aby przeszukać zawartość';
	@override String get prompt => 'Wpisz zapytanie i naciśnij Enter';
	@override String get noMatches => 'Brak dopasowań';
	@override String get resultsTruncated => 'Wyniki obcięte';
}

// Path: fileTree.titles
class Translations$fileTree$titles$pl extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String rename({required Object name}) => 'Zmień nazwę ${name}';
	@override String delete({required Object name}) => 'Usuń ${name}';
	@override String download({required Object name}) => 'Pobierz ${name}';
}

// Path: fileTree.relative
class Translations$fileTree$relative$pl extends Translations$fileTree$relative$en {
	Translations$fileTree$relative$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get now => 'teraz';
	@override String minutes({required Object n}) => '${n} min';
	@override String hours({required Object n}) => '${n} godz.';
	@override String days({required Object n}) => '${n} dni';
}

// Path: git.checkpoints
class Translations$git$checkpoints$pl extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Punkty kontrolne';
	@override String get restoreTitle => 'Przywróć punkt kontrolny';
	@override String get restoreMessage => 'Zresetować drzewo robocze do tego punktu kontrolnego? Bieżące zmiany zostaną zastąpione.';
	@override String get restored => 'Przywrócono punkt kontrolny';
	@override String get labelHint => 'Etykieta punktu kontrolnego (opcjonalnie)';
	@override String get empty => 'Brak punktów kontrolnych';
	@override String get create => 'Nowy';
}

// Path: git.branchSections
class Translations$git$branchSections$pl extends Translations$git$branchSections$en {
	Translations$git$branchSections$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get local => 'LOKALNE';
	@override String get remote => 'ZDALNE';
}

// Path: kanban.card
class Translations$kanban$card$pl extends Translations$kanban$card$en {
	Translations$kanban$card$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Bez tytułu';
}

// Path: kanban.comments
class Translations$kanban$comments$pl extends Translations$kanban$comments$en {
	Translations$kanban$comments$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Brak komentarzy';
	@override String get add => 'Dodaj komentarz';
}

// Path: kanban.dialog
class Translations$kanban$dialog$pl extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Zapisywanie…';
}

// Path: kanban.details
class Translations$kanban$details$pl extends Translations$kanban$details$en {
	Translations$kanban$details$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Szczegóły karty';
	@override String status({required Object status}) => 'Status: ${status}';
}

// Path: kanban.empty
class Translations$kanban$empty$pl extends Translations$kanban$empty$en {
	Translations$kanban$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Nie wybrano projektu';
}

// Path: kanban.time
class Translations$kanban$time$pl extends Translations$kanban$time$en {
	Translations$kanban$time$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get now => 'teraz';
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '1 min temu',
		other: '${count} min temu',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '1 godz. temu',
		other: '${count} godz. temu',
	);
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '1 dzień temu',
		other: '${count} dni temu',
	);
}

// Path: mcp.install
class Translations$mcp$install$pl extends Translations$mcp$install$en {
	Translations$mcp$install$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zainstaluj serwer MCP DDAgent';
	@override String get description => 'Pozwala wybranym agentom korzystać z bazy wiedzy i narzędzi DDAgent przez MCP.';
	@override String get cardDescription => 'Daj swoim agentom bazę wiedzy i narzędzia DDAgent przez MCP — wybierz agentów albo zainstaluj dla wszystkich.';
	@override String get installSelected => 'Zainstaluj wybrane';
	@override String get installForAll => 'Zainstaluj dla wszystkich';
	@override String get button => 'Zainstaluj';
	@override String failed({required Object error}) => 'Instalacja nie powiodła się: ${error}';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Zainstalowano u ${count} agenta.',
		other: 'Zainstalowano u ${count} agentów.',
	);
	@override String partialFailure({required Object count, required Object failed}) => 'Zainstalowano u ${count}; niepowodzenia: ${failed}';
	@override String get errorFallback => 'błąd';
}

// Path: mcp.servers
class Translations$mcp$servers$pl extends Translations$mcp$servers$en {
	Translations$mcp$servers$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Ładowanie serwerów MCP...';
	@override String get refreshingScopes => 'Odświeżanie zakresów projektu...';
	@override String descriptionGeneric({required Object provider}) => 'Serwery Model Context Protocol zapewniają ${provider} dodatkowe narzędzia i źródła danych';
	@override String get addGlobalTitle => 'Dodaj globalny serwer MCP';
	@override String get addGlobalDescription => 'Dodaje ten serwer MCP do każdego dostawcy: Claude, Cursor, Codex, OpenCode i Devin. Obsługiwane są tylko transporty stdio i HTTP, ponieważ ta sama konfiguracja musi działać u wszystkich dostawców.';
	@override String get addGlobalMenuDescription => 'Dodanie globalnego serwera MCP zapisuje jeden wspólny serwer stdio lub HTTP u dostawców Claude, Cursor, Codex, OpenCode i Devin.';
	@override String addProviderTitle({required Object provider}) => 'Dodaj serwer MCP ${provider}';
	@override String addProviderDescription({required Object provider}) => 'Dodanie serwera MCP ${provider} zmienia tylko ${provider}.';
	@override late final Translations$mcp$servers$config$pl config = Translations$mcp$servers$config$pl._(_root);
	@override String get selectProjectRequired => 'Wybierz projekt dla serwerów MCP o zakresie projektu';
	@override String get globalScopeUnsupported => 'Dodawanie serwera MCP dla wszystkich dostawców obsługuje tylko zakres użytkownika lub projektu.';
	@override String globalAddFailed({required Object details}) => 'Nie udało się dodać serwera MCP do wszystkich dostawców. ${details}';
	@override String get scopeProject => 'projekt';
}

// Path: mcp.team
class Translations$mcp$team$pl extends Translations$mcp$team$en {
	Translations$mcp$team$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konfiguracje MCP zespołu';
	@override String get description => 'Udostępniaj konfiguracje serwerów MCP całemu zespołowi. Wszyscy automatycznie pozostają zsynchronizowani.';
	@override String get cta => 'Dostępne w DDAgent Pro';
}

// Path: mcp.tokens
class Translations$mcp$tokens$pl extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Zapis';
	@override String get scopeRead => 'Odczyt';
}

// Path: mcp.form
class Translations$mcp$form$pl extends Translations$mcp$form$en {
	Translations$mcp$form$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String submitTo({required Object provider}) => 'Dodaj serwer do ${provider}';
	@override late final Translations$mcp$form$scope$pl scope = Translations$mcp$form$scope$pl._(_root);
	@override late final Translations$mcp$form$fields$pl fields = Translations$mcp$form$fields$pl._(_root);
	@override late final Translations$mcp$form$validation$pl validation = Translations$mcp$form$validation$pl._(_root);
}

// Path: notifications.errors
class Translations$notifications$errors$pl extends Translations$notifications$errors$en {
	Translations$notifications$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get registrationRejected => 'Serwer odrzucił rejestrację';
	@override String get noResponse => 'Brak odpowiedzi z serwera';
}

// Path: notifications.androidChannel
class Translations$notifications$androidChannel$pl extends Translations$notifications$androidChannel$en {
	Translations$notifications$androidChannel$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Alerty DDAgent';
	@override String get description => 'Powiadomienia o przebiegach agentów, zatwierdzeniach i błędach';
}

// Path: onboarding.errors
class Translations$onboarding$errors$pl extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get nameAndEmailRequired => 'Nazwa i e-mail Git są wymagane.';
	@override String get invalidEmail => 'Podaj prawidłowy adres e-mail.';
}

// Path: onboarding.agents
class Translations$onboarding$agents$pl extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Połącz swoich agentów AI';
	@override String get description => 'Zaloguj się do jednego lub więcej asystentów AI. Wszystkie są opcjonalne.';
	@override String get laterHint => 'Możesz je skonfigurować później w Ustawieniach.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$pl extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Połącz agentów z DDAgent';
	@override String get description => 'Zainstaluj serwer MCP DDAgent, aby Twoi agenci mogli korzystać z bazy wiedzy i narzędzi DDAgent. Wybierz agentów albo zainstaluj dla wszystkich.';
	@override String get installSelected => 'Zainstaluj wybrane';
	@override String get installForAll => 'Zainstaluj dla wszystkich';
	@override String get laterHint => 'Opcjonalne — możesz to też zainstalować później w Ustawieniach → MCP.';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Zainstalowano u ${count} agenta.',
		other: 'Zainstalowano u ${count} agentów.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => 'Zainstalowano u ${installedCount}; niepowodzenia: ${failed}';
}

// Path: quota.section
class Translations$quota$section$pl extends Translations$quota$section$en {
	Translations$quota$section$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get config => 'Konfiguracja';
}

// Path: quota.overview
class Translations$quota$overview$pl extends Translations$quota$overview$en {
	Translations$quota$overview$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Tokeny i koszt';
}

// Path: quota.agents
class Translations$quota$agents$pl extends Translations$quota$agents$en {
	Translations$quota$agents$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.config
class Translations$quota$config$pl extends Translations$quota$config$en {
	Translations$quota$config$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get pollerTitle => 'Odpytywanie i alerty';
	@override String get accountRouting => 'Routing kont';
	@override String get save => 'Zapisz konfigurację';
}

// Path: quota.chart
class Translations$quota$chart$pl extends Translations$quota$chart$en {
	Translations$quota$chart$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get show => 'Pokaż';
	@override String get hide => 'Ukryj';
	@override String get noData => 'Za mało danych, aby pokazać trend.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokenów · ${cost}';
}

// Path: quota.duration
class Translations$quota$duration$pl extends Translations$quota$duration$en {
	Translations$quota$duration$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String minutes({required Object minutes}) => '${minutes} min';
	@override String hoursMinutes({required Object hours, required Object minutes}) => '${hours} godz. ${minutes} min';
	@override String daysHours({required Object days, required Object hours}) => '${days} d. ${hours} godz.';
	@override String get now => 'teraz';
}

// Path: scheduler.runStatus
class Translations$scheduler$runStatus$pl extends Translations$scheduler$runStatus$en {
	Translations$scheduler$runStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get fired => 'uruchomiono';
	@override String get skipped => 'pominięto';
	@override String get failed => 'błąd';
	@override String get completed => 'ukończono';
}

// Path: scheduler.cronErrors
class Translations$scheduler$cronErrors$pl extends Translations$scheduler$cronErrors$en {
	Translations$scheduler$cronErrors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String fieldCount({required Object got}) => 'Oczekiwano 5 pól, podano ${got}';
	@override String fieldError({required Object index, required Object error}) => 'Pole ${index}: ${error}';
	@override String get empty => 'puste';
	@override String invalidPart({required Object part}) => 'nieprawidłowe „${part}”';
	@override String invalidValue({required Object value}) => 'nieprawidłowa wartość „${value}”';
}

// Path: serverConnect.local
class Translations$serverConnect$local$pl extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'To urządzenie';
	@override String get subtitle => 'Uruchom serwer DDAgent na tym komputerze';
	@override String get install => 'Zainstaluj serwer lokalny';
	@override String get start => 'Uruchom serwer lokalny';
	@override String get stop => 'Zatrzymaj';
	@override String get starting => 'Uruchamianie serwera lokalnego…';
	@override String downloading({required Object percent}) => 'Pobieranie serwera… ${percent}%';
	@override String get installing => 'Instalowanie…';
	@override String running({required Object url}) => 'Działa pod adresem ${url}';
	@override String installed({required Object version}) => 'Zainstalowany (v${version})';
	@override String get connect => 'Użyj tego serwera';
	@override String error({required Object error}) => 'Błąd serwera lokalnego: ${error}';
	@override String get or => 'lub połącz się ze zdalnym serwerem';
	@override late final Translations$serverConnect$local$errors$pl errors = Translations$serverConnect$local$errors$pl._(_root);
}

// Path: sessions.toasts
class Translations$sessions$toasts$pl extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Sesja zarchiwizowana';
	@override String get restored => 'Sesja przywrócona';
	@override String get deleted => 'Sesja usunięta';
	@override String get renamed => 'Zmieniono nazwę sesji';
	@override String get pinned => 'Sesja przypięta';
	@override String get unpinned => 'Sesja odpięta';
	@override String get workspaceChanged => 'Workspace zmieniony';
}

// Path: sessions.age
class Translations$sessions$age$pl extends Translations$sessions$age$en {
	Translations$sessions$age$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get lessThanMinute => '<1 min';
	@override String minutes({required Object count}) => '${count} min';
	@override String hours({required Object hours}) => '${hours} godz.';
	@override String days({required Object days}) => '${days} d';
}

// Path: sessions.activity
class Translations$sessions$activity$pl extends Translations$sessions$activity$en {
	Translations$sessions$activity$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get subagentRunning => 'Działa subagent';
	@override String readingFile({required Object file}) => 'Odczyt ${file}';
	@override String runningTool({required Object name}) => 'Uruchamianie ${name}';
	@override String editingFile({required Object file}) => 'Edytowanie ${file}';
	@override String get editingFileGeneric => 'Edytowanie pliku';
	@override String get runningShellCommand => 'Uruchamianie polecenia powłoki';
	@override String runningCommand({required Object command}) => 'Uruchamianie `${command}`';
	@override String get committingChanges => 'Zatwierdzanie zmian';
	@override String get pushingBranch => 'Wysyłanie gałęzi';
	@override String fetchingUrl({required Object url}) => 'Pobieranie ${url}';
	@override String searching({required Object query}) => 'Wyszukiwanie „${query}”';
}

// Path: skills.addDialog
class Translations$skills$addDialog$pl extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => 'Dodaj skill ${provider}';
	@override String get chooseFileTitle => 'Wybierz SKILL.md';
	@override String get chooseFolderTitle => 'Wybierz folder skilla';
	@override String get uploadHint => 'Wgraj plik SKILL.md lub kompletny folder skilla.';
	@override String get pickTitle => 'Wybierz folder skilla lub SKILL.md';
	@override String get pickHint => 'Foldery mogą zawierać skrypty, referencje i zasoby.';
	@override String get chooseFiles => 'Wybierz pliki';
	@override String get chooseFolder => 'Wybierz folder';
	@override String get readyToInstall => 'Gotowe do instalacji';
	@override String markdownFileMeta({required Object size}) => 'Plik Markdown · ${size}';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} plik · ${size}',
		other: '${count} plików · ${size}',
	);
	@override String removeQueued({required Object name}) => 'Usuń ${name}';
	@override String get whereWillThisInstall => 'Gdzie to zostanie zainstalowane?';
	@override String get hideInstallLocation => 'Ukryj lokalizację instalacji';
	@override String get folderUploadsNote => 'Przesyłanie folderu zachowuje nazwę wybranego folderu; pojedyncze pliki używają `name` z `SKILL.md`.';
	@override String get installSkill => 'Zainstaluj skill';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Zainstaluj ${count} skill',
		other: 'Zainstaluj ${count} skilli',
	);
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$pl extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get toProjectHint => 'Wybierz projekt, do którego ma należeć ten skill. Zostanie on przeniesiony z globalnego katalogu skilli dostawcy.';
	@override String get toGlobalHint => 'Przenieś ten skill do globalnego katalogu skilli, aby każdy projekt mógł z niego korzystać.';
	@override String get moveToProject => 'Przenieś do projektu';
	@override String get moveToGlobal => 'Przenieś do globalnych';
}

// Path: skills.screen
class Translations$skills$screen$pl extends Translations$skills$screen$en {
	Translations$skills$screen$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String manageDescription({required Object provider}) => 'Zarządzaj skillami ${provider} z plików lokalnych, kompletnych folderów i lokalizacji powiązanych z projektem.';
	@override String get searchHint => 'Szukaj skilli...';
	@override String get clearSearch => 'Wyczyść wyszukiwanie skilli';
	@override String get addSkill => 'Dodaj skill';
	@override String get scanningProjectSkills => 'Skanowanie skilli projektu...';
	@override String get savedSuccessfully => 'Skille zapisano pomyślnie.';
	@override String loadingSkills({required Object provider}) => 'Wczytywanie skilli ${provider}…';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} SKILL',
		other: '${count} SKILLI',
	);
	@override String deleteTitle({required Object name}) => 'Usunąć ${name}?';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Spowoduje to usunięcie katalogu ${directory} z zarządzanego katalogu skilli ${provider}. Tej operacji nie można cofnąć.';
	@override String get noDescription => 'Nie podano opisu w metadanych skilla.';
	@override String pluginBadge({required Object name}) => 'Wtyczka: ${name}';
	@override String projectBadge({required Object name}) => 'Projekt: ${name}';
	@override String get sourceLabel => 'ŹRÓDŁO';
}

// Path: skills.empty
class Translations$skills$empty$pl extends Translations$skills$empty$en {
	Translations$skills$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get noProjects => 'Brak dostępnych projektów';
	@override String get noProjectsDescription => 'Dodaj projekt lub obszar roboczy, aby przeglądać jego skille.';
	@override String get noSkillsInProject => 'Brak skilli w tym projekcie';
	@override String get noSkillsInProjectDescription => 'Utwórz folder .claude/skills, .cursor/skills lub .agents/skills w wybranym projekcie.';
	@override String get noGlobalSkills => 'Nie wykryto jeszcze globalnych skilli';
	@override String get noGlobalSkillsDescription => 'Dodaj globalny skill powyżej, aby był dostępny we wszystkich projektach.';
	@override String get noMatchingSkills => 'Brak pasujących skilli';
	@override String get noMatchingSkillsDescription => 'Spróbuj innego polecenia, nazwy, zakresu, projektu lub ścieżki źródłowej.';
}

// Path: skills.scopes
class Translations$skills$scopes$pl extends Translations$skills$scopes$en {
	Translations$skills$scopes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get user => 'Użytkownik';
	@override String get plugin => 'Wtyczka';
	@override String get repo => 'Repozytorium';
	@override String get project => 'Projekt';
	@override String get admin => 'Administrator';
	@override String get system => 'System';
}

// Path: skills.errors
class Translations$skills$errors$pl extends Translations$skills$errors$en {
	Translations$skills$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get dropMarkdownOrFolder => 'Upuść co najmniej jeden plik markdown lub folder zawierający SKILL.md.';
	@override String get addMarkdownFirst => 'Najpierw dodaj co najmniej jeden plik markdown.';
	@override String get importFailed => 'Nie udało się zaimportować skilli';
	@override String get folderReadFailed => 'Nie udało się odczytać folderu skilla';
	@override String folderFileLimit({required Object count}) => 'Folder skilla może zawierać maksymalnie ${count} plików.';
	@override String get folderSizeLimit => 'Wybrane foldery skilli mogą mieć łącznie mniej niż 30 MB.';
	@override String get missingSkillFile => 'Wybrany folder nie zawiera pliku SKILL.md.';
	@override String couldNotReadSkillFile({required Object name}) => 'Nie udało się odczytać SKILL.md z ${name}.';
}

// Path: terminal.tabs
class Translations$terminal$tabs$pl extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String shellName({required Object index}) => 'Shell ${index}';
	@override String get plainShell => 'Zwykły shell';
	@override String get claudeCli => 'Claude CLI';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'Logowanie: ${provider}';
	@override String runTitle({required Object command}) => 'Uruchom: ${command}';
}

// Path: terminal.actions
class Translations$terminal$actions$pl extends Translations$terminal$actions$en {
	Translations$terminal$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get newTab => 'Nowa karta terminala';
	@override String get providerLogin => 'Logowanie dostawcy';
	@override String get restartSession => 'Uruchom ponownie sesję';
	@override String get clearOutput => 'Wyczyść wyjście';
	@override String get newShell => 'Nowy shell';
	@override String get connect => 'Połącz';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$pl extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Otwórz w przeglądarce';
	@override String linkLabel({required Object url}) => 'Link logowania: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$pl extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'Wykryto plik: ${path}';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$pl extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get interrupt => 'Przerwij (SIGINT)';
	@override String get eof => 'EOF';
	@override String get suspend => 'Wstrzymaj (SIGTSTP)';
	@override String get hide => 'Ukryj pasek skrótów';
	@override String get showTooltip => 'Pokaż skróty';
	@override String get hideTooltip => 'Ukryj skróty';
}

// Path: terminal.paste
class Translations$terminal$paste$pl extends Translations$terminal$paste$en {
	Translations$terminal$paste$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wklej do terminala';
	@override String get hint => 'Ctrl+V / kliknij prawym przyciskiem → Wklej';
}

// Path: terminal.errors
class Translations$terminal$errors$pl extends Translations$terminal$errors$en {
	Translations$terminal$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'Nie udało się otworzyć linku: ${url}';
	@override String frameError({required Object message}) => '[Błąd] ${message}';
	@override String connectionError({required Object message}) => '[Błąd połączenia] ${message}';
}

// Path: terminal.loginDialog
class Translations$terminal$loginDialog$pl extends Translations$terminal$loginDialog$en {
	Translations$terminal$loginDialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => 'Logowanie do ${provider} CLI';
	@override String exited({required Object code}) => 'Zakończono (${code})';
	@override String get authLinkDetected => 'Wykryto link uwierzytelniający';
}

// Path: terminal.empty
class Translations$terminal$empty$pl extends Translations$terminal$empty$en {
	Translations$terminal$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Brak aktywnego terminala';
	@override String get description => 'Utwórz nową kartę, aby rozpocząć';
}

// Path: terminal.overlay
class Translations$terminal$overlay$pl extends Translations$terminal$overlay$en {
	Translations$terminal$overlay$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get processExited => 'Proces zakończył działanie — połącz się, aby uruchomić go ponownie';
	@override String processExitedWithCode({required Object code}) => 'Proces zakończył działanie (kod ${code}) — połącz się, aby uruchomić go ponownie';
	@override String resumeSession({required Object title}) => 'Wznów sesję ${title}';
	@override String startSession({required Object path}) => 'Rozpocznij nową sesję w ${path}';
}

// Path: workspace.paneTitle
class Translations$workspace$paneTitle$pl extends Translations$workspace$paneTitle$en {
	Translations$workspace$paneTitle$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Czat';
	@override String get browser => 'Przeglądarka';
	@override String get terminal => 'Terminal';
	@override String get notes => 'Wspólne notatki';
	@override String get editor => 'Edytor';
	@override String get git => 'Git';
}

// Path: worktrees.runtimeStatus
class Translations$worktrees$runtimeStatus$pl extends Translations$worktrees$runtimeStatus$en {
	Translations$worktrees$runtimeStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get idle => 'bezczynny';
	@override String get running => 'działa';
	@override String get done => 'gotowe';
	@override String get failed => 'błąd';
	@override String get exited => 'zakończony';
}

// Path: browserUse.sessionStatus
class Translations$browserUse$sessionStatus$pl extends Translations$browserUse$sessionStatus$en {
	Translations$browserUse$sessionStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get ready => 'Gotowa';
	@override String get stopped => 'Zatrzymana';
	@override String get unavailable => 'Niedostępna';
}

// Path: miniOrchestrator.taskTypes
class Translations$miniOrchestrator$taskTypes$pl extends Translations$miniOrchestrator$taskTypes$en {
	Translations$miniOrchestrator$taskTypes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get gate => 'Bramka';
}

// Path: miniOrchestrator.roles
class Translations$miniOrchestrator$roles$pl extends Translations$miniOrchestrator$roles$en {
	Translations$miniOrchestrator$roles$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get thinker => 'Myśliciel';
	@override String get worker => 'Wykonawca';
}

// Path: auth.login.errors
class Translations$auth$login$errors$pl extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Nieprawidłowa nazwa użytkownika lub hasło';
	@override String get requiredFields => 'Wypełnij wszystkie pola';
	@override String get networkError => 'Błąd sieci. Spróbuj ponownie.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$pl extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get username => 'Wpisz nazwę użytkownika';
	@override String get password => 'Wpisz hasło';
}

// Path: auth.register.errors
class Translations$auth$register$errors$pl extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Hasła nie są identyczne';
	@override String get usernameTaken => 'Ta nazwa użytkownika jest już zajęta';
	@override String get weakPassword => 'Hasło jest zbyt słabe';
	@override String get usernameTooShort => 'Nazwa użytkownika musi mieć co najmniej 3 znaki';
	@override String get passwordTooShort => 'Hasło musi mieć co najmniej 6 znaków';
}

// Path: chat.orchestrator.routing
class Translations$chat$orchestrator$routing$pl extends Translations$chat$orchestrator$routing$en {
	Translations$chat$orchestrator$routing$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing';
	@override String alternatives({required Object list}) => 'Alternatywy: ${list}';
	@override String first({required Object label, required Object task}) => '${label} — pierwszy kandydat dla ${task}';
	@override String skipped({required Object label, required Object list}) => '${label} — wcześniejsi kandydaci pominięci (${list})';
}

// Path: chat.orchestrator.plan
class Translations$chat$orchestrator$plan$pl extends Translations$chat$orchestrator$plan$en {
	Translations$chat$orchestrator$plan$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get disabled => 'wyłączony';
	@override String get awaitingConfirm => 'Oczekiwanie na potwierdzenie planu.';
	@override String get run => 'Uruchom plan';
	@override String get toggleStep => 'Włącz krok';
	@override String get confirmFailed => 'Nie udało się uruchomić — spróbuj ponownie.';
	@override String get fallback => 'planner niedostępny — fallback na pojedynczy krok';
	@override String get templateSource => 'z szablonu pipeline';
	@override String get offSource => 'planner wyłączony';
	@override String stepCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} krok',
		few: '${count} kroki',
		many: '${count} kroków',
		other: '${count} kroków',
	);
	@override String get supervisedSource => 'pętla nadzorowana';
}

// Path: chat.orchestrator.decision
class Translations$chat$orchestrator$decision$pl extends Translations$chat$orchestrator$decision$en {
	Translations$chat$orchestrator$decision$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Decyzja nadzorcy';
	@override String iteration({required Object n}) => 'iteracja ${n}';
	@override String get rationaleLabel => 'Dlaczego';
	@override String get awaitingConfirm => 'Oczekiwanie na Twoją zgodę przed uruchomieniem tych kroków.';
	@override String get proposedSteps => 'Proponowane kroki';
	@override late final Translations$chat$orchestrator$decision$action$pl action = Translations$chat$orchestrator$decision$action$pl._(_root);
	@override late final Translations$chat$orchestrator$decision$outcome$pl outcome = Translations$chat$orchestrator$decision$outcome$pl._(_root);
}

// Path: chat.orchestrator.delegation
class Translations$chat$orchestrator$delegation$pl extends Translations$chat$orchestrator$delegation$en {
	Translations$chat$orchestrator$delegation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delegowany krok';
	@override String get openSession => 'Otwórz pełną sesję';
	@override String attempt({required Object n}) => 'próba ${n}';
	@override String get retryStep => 'Ponów / Popraw';
	@override String get continueStep => 'Kontynuuj / Popraw';
	@override String get continueFailed => 'Nie udało się — spróbuj ponownie.';
	@override late final Translations$chat$orchestrator$delegation$status$pl status = Translations$chat$orchestrator$delegation$status$pl._(_root);
	@override String attempts({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} próba',
		few: '${count} próby',
		many: '${count} prób',
		other: '${count} prób',
	);
	@override String candidates({required Object list}) => 'kandydaci: ${list}';
	@override String candidateCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} kandydat',
		few: '${count} kandydatów',
		many: '${count} kandydatów',
		other: '${count} kandydatów',
	);
}

// Path: chat.orchestrator.summary
class Translations$chat$orchestrator$summary$pl extends Translations$chat$orchestrator$summary$en {
	Translations$chat$orchestrator$summary$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Podsumowanie';
	@override String progress({required Object done, required Object total}) => 'Ukończone kroki: ${done}/${total}';
	@override String get aborted => 'przerwano';
	@override String get timedOut => 'przekroczono czas';
	@override String get capped => 'limit iteracji';
	@override String failed({required Object list}) => 'Kroki z niepowodzeniem: ${list}';
	@override String get kContinue => 'Kontynuuj';
	@override String get continueWork => 'Kontynuuj pracę';
	@override String get resumeFailed => 'Nie udało się wznowić — spróbuj ponownie.';
	@override String get runNextTask => 'Uruchom następne zadanie';
	@override String get endAllTasks => 'Zakończ wszystkie zadania';
	@override String get tasksRunning => 'Praca nad zadaniami…';
	@override String get cancelTasks => 'Anuluj';
}

// Path: chat.orchestrator.taskmaster
class Translations$chat$orchestrator$taskmaster$pl extends Translations$chat$orchestrator$taskmaster$en {
	Translations$chat$orchestrator$taskmaster$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kolejka zadań';
	@override String remaining({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: 'Pozostało: ${count}',
		few: 'Pozostało: ${count}',
		many: 'Pozostało: ${count}',
		other: 'Pozostało: ${count}',
	);
	@override late final Translations$chat$orchestrator$taskmaster$status$pl status = Translations$chat$orchestrator$taskmaster$status$pl._(_root);
}

// Path: chat.orchestrator.gate
class Translations$chat$orchestrator$gate$pl extends Translations$chat$orchestrator$gate$en {
	Translations$chat$orchestrator$gate$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'przekroczono czas';
	@override String exit({required Object code}) => 'kod wyjścia ${code}';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$pl extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Tryb domyślny';
	@override String get auto => 'Tryb automatyczny';
	@override String get acceptEdits => 'Akceptuj edycje';
	@override String get bypassPermissions => 'Omijaj uprawnienia';
	@override String get plan => 'Tryb planowania';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$pl extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Tylko zaufane polecenia (ls, cat, grep, git status itd.) są uruchamiane automatycznie. Pozostałe polecenia są pomijane. Może zapisywać w obszarze roboczym.';
	@override String get auto => 'Klasyfikator modelu decyduje przy każdym wywołaniu narzędzia, czy je zatwierdzić, czy odrzucić. Tryb bezobsługowy, ale bezpieczniejszy niż omijanie uprawnień — odrzucenia nadal występują.';
	@override String get acceptEdits => 'Wszystkie polecenia są uruchamiane automatycznie w obrębie obszaru roboczego. Pełny tryb automatyczny z wykonaniem w piaskownicy.';
	@override String get bypassPermissions => 'Pełny dostęp do systemu bez ograniczeń. Wszystkie polecenia są uruchamiane automatycznie z pełnym dostępem do dysku i sieci. Używaj ostrożnie.';
	@override String get plan => 'Tryb planowania - żadne polecenia nie są wykonywane';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$pl extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter wyślij • / komendy • @ pliki';
	@override String get enter => 'Enter wyślij • Shift+Enter nowa linia • / komendy • @ pliki';
	@override String get queue => 'Enter, aby dodać kolejną wiadomość do kolejki';
	@override String get updateQueued => 'Enter, aby zaktualizować wiadomość w kolejce';
}

// Path: chat.input.queue
class Translations$chat$input$queue$pl extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Dodaj następną wiadomość do kolejki';
	@override String get update => 'Zaktualizuj wiadomość w kolejce';
	@override String get label => 'W kolejce';
	@override String get willSend => 'Zostanie wysłana po zakończeniu';
	@override String get edit => 'Edytuj wiadomość w kolejce';
	@override String get delete => 'Usuń wiadomość z kolejki';
	@override String get failed => 'Nie udało się wysłać';
	@override String get sendNow => 'Wyślij teraz';
	@override String get sendNowAfterTurn => 'Ten agent nie przyjmuje wiadomości w trakcie tury — zostanie wysłana po bieżącej turze';
	@override String filesAttached({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count,
		one: '${count} załączony plik',
		few: '${count} załączone pliki',
		many: '${count} załączonych plików',
		other: '${count} załączonego pliku',
	);
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$pl extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Anuluj i wyczyść kolejkę offline';
	@override String get clearBtn => 'Anuluj';
	@override String multiple({required Object count}) => '${count} wiadomości w kolejce offline — zostaną wysłane automatycznie po ponownym połączeniu';
	@override String get single => '1 wiadomość w kolejce offline — zostanie wysłana automatycznie po ponownym połączeniu';
}

// Path: chat.composer.effortLevels
class Translations$chat$composer$effortLevels$pl extends Translations$chat$composer$effortLevels$en {
	Translations$chat$composer$effortLevels$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get off => 'Wyłączone';
	@override String get none => 'Brak';
	@override String get minimal => 'Minimalny';
	@override String get low => 'Niski';
	@override String get medium => 'Średni';
	@override String get high => 'Wysoki';
	@override String get xhigh => 'Bardzo wysoki';
	@override String get max => 'Maksymalny';
	@override String get ultra => 'Ultra';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$pl extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'od Anthropic';
	@override String get openai => 'od OpenAI';
	@override String get cursorEditor => 'Edytor kodu AI';
	@override String get google => 'od Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$pl extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Claude z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.';
	@override String cursor({required Object model}) => 'Cursor z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.';
	@override String codex({required Object model}) => 'Codex z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.';
	@override String opencode({required Object model}) => 'OpenCode z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.';
	@override String get kDefault => 'Wybierz dostawcę powyżej, aby rozpocząć';
	@override String devin({required Object model}) => 'Gotowe z Devin ${model}';
	@override String get orchestrator => 'Gotowe z Auto — router wybiera najlepszy model dla każdego kroku';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$pl extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kontynuuj rozmowę';
	@override String get description => 'Zadawaj pytania o swój kod, proś o zmiany lub uzyskaj pomoc przy zadaniach deweloperskich';
	@override String get action => 'Kontynuuj pisanie';
}

// Path: chat.session.loading
class Translations$chat$session$loading$pl extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Wczytywanie starszych wiadomości...';
	@override String get sessionMessages => 'Wczytywanie wiadomości sesji...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$pl extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => 'Wyświetlanie ${shown} z ${total} wiadomości';
	@override String get scrollToLoad => 'Przewiń w górę, aby wczytać więcej';
	@override String showingLast({required Object count, required Object total}) => 'Wyświetlanie ostatnich ${count} wiadomości (łącznie ${total})';
	@override String get loadEarlier => 'Wczytaj wcześniejsze wiadomości';
	@override String get loadOlderFailed => 'Nie udało się załadować starszych wiadomości.';
	@override String get retry => 'Ponów';
	@override String get loadAll => 'Wczytaj wszystkie wiadomości';
	@override String get loadingAll => 'Wczytywanie wszystkich wiadomości...';
	@override String get allLoaded => 'Wczytano wszystkie wiadomości';
	@override String get perfWarning => 'Wczytano wszystkie wiadomości — przewijanie może być wolniejsze. Kliknij „Przewiń na dół”, aby przywrócić wydajność.';
	@override String get noSearchMatches => 'Żadne wiadomości nie pasują do wyszukiwania.';
	@override String get loadOlder => 'Wczytaj starsze wiadomości';
	@override String loadAllCount({required Object count}) => 'Wczytaj wszystkie (${count})';
	@override String retryLoadOlder({required Object error}) => 'Ponów wczytywanie starszych — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$pl extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wybierz projekt';
	@override String get description => 'Wybierz projekt, aby otworzyć interaktywny shell w tym katalogu';
}

// Path: chat.shell.status
class Translations$chat$shell$status$pl extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nowa sesja';
	@override String get initializing => 'Inicjalizacja...';
	@override String get restarting => 'Ponowne uruchamianie...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$pl extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Rozłącz';
	@override String get disconnectTitle => 'Rozłącz shell';
	@override String get restart => 'Uruchom ponownie';
	@override String get restartTitle => 'Uruchom ponownie shell';
	@override String get kill => 'Zatrzymaj (SIGINT)';
	@override String get killTitle => 'Zatrzymaj proces (SIGINT)';
	@override String get copyOutput => 'Kopiuj wyjście';
	@override String get copyOutputTitle => 'Kopiuj wyjście terminala';
	@override String get copied => 'Skopiowano!';
	@override String get zoomInTitle => 'Powiększ';
	@override String get zoomOutTitle => 'Pomniejsz';
	@override String get connect => 'Kontynuuj w shellu';
	@override String get connectTitle => 'Połącz z shellem';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$pl extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Myślę';
	@override String get processing => 'Przetwarzam';
	@override String get analyzing => 'Analizuję';
	@override String get working => 'Pracuję';
	@override String get computing => 'Obliczam';
	@override String get reasoning => 'Rozumuję';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$pl extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get live => 'Na żywo';
	@override String get paused => 'Wstrzymano';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$pl extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}s';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => 'Upłynęło ${time}';
	@override String get startingNow => 'Zaczynam teraz';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$pl extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Zatrzymaj generowanie';
	@override String get pressEscToStop => 'W dowolnym momencie naciśnij Esc, aby zatrzymać';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$pl extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Asystent';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$pl extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get models => 'Przeglądaj dostępne modele dla aktywnego dostawcy.';
	@override String get cost => 'Sprawdź zużycie tokenów w aktywnej sesji.';
	@override String get status => 'Sprawdź środowisko uruchomieniowe, wersję, dostawcę i stan środowiska.';
	@override String get memory => 'Otwórz plik pamięci CLAUDE.md projektu.';
	@override String get config => 'Otwórz ustawienia i konfigurację.';
	@override String get help => 'Pokaż dokumentację i składnię poleceń.';
}

// Path: chat.permissionRequest.recap
class Translations$chat$permissionRequest$recap$pl extends Translations$chat$permissionRequest$recap$en {
	Translations$chat$permissionRequest$recap$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'Upłynął limit czasu — odrzucono automatycznie';
	@override String get cancelled => 'Anulowano — tura została zatrzymana';
	@override String get autoApproved => 'Zatwierdzono automatycznie';
	@override String get expired => 'Żądanie wygasło — agent już na nie nie czeka';
	@override String get answered => 'Udzielono odpowiedzi';
	@override String get skipped => 'Pominięto';
	@override String get decided => 'Podjęto decyzję';
}

// Path: chat.commandDialog.help
class Translations$chat$commandDialog$help$pl extends Translations$chat$commandDialog$help$en {
	Translations$chat$commandDialog$help$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Centrum poleceń';
	@override String get title => 'Pomoc i skróty';
	@override String get subtitle => 'Przeszukuj wbudowane polecenia, wzorce składni i sposoby użycia.';
}

// Path: chat.commandDialog.models
class Translations$chat$commandDialog$models$pl extends Translations$chat$commandDialog$models$en {
	Translations$chat$commandDialog$models$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Wybór modelu';
	@override String get title => 'Wybierz model';
	@override String get subtitle => 'Wybierz model, którego ma używać ten dostawca.';
	@override String modelSetTo({required Object model}) => 'Ustawiono model ${model}.';
	@override String get activeModel => 'Aktywny model';
	@override String get noModelsMatch => 'Żaden model nie pasuje do tego filtra.';
	@override String get choiceSavedForSession => 'Twój wybór zostanie zapisany dla tej sesji i stanie się domyślny dla nowych czatów.';
	@override String get choiceDefault => 'Twój wybór stanie się domyślnym modelem dla nowych czatów.';
	@override String get custom => 'Własny';
	@override String get currentSelection => 'Bieżący wybór';
}

// Path: chat.commandDialog.cost
class Translations$chat$commandDialog$cost$pl extends Translations$chat$commandDialog$cost$en {
	Translations$chat$commandDialog$cost$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Telemetria sesji';
	@override String get title => 'Zużycie tokenów';
	@override String get subtitle => 'Liczba tokenów wejściowych, wyjściowych i łącznie w tej sesji.';
	@override String get totalTokensUsed => 'Łącznie użyte tokeny';
	@override String get inputTokens => 'Tokeny wejściowe';
	@override String get cacheReadTokens => 'Tokeny odczytane z cache';
	@override String get cacheWriteTokens => 'Tokeny zapisane do cache';
	@override String get outputTokens => 'Tokeny wyjściowe';
	@override String get breakdown => 'Podział';
	@override String get unavailable => 'Niedostępny';
	@override String get contextWindow => 'Okno kontekstu';
	@override String get estimatedCost => 'Szacowany koszt';
}

// Path: chat.commandDialog.status
class Translations$chat$commandDialog$status$pl extends Translations$chat$commandDialog$status$en {
	Translations$chat$commandDialog$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Stan środowiska';
	@override String get title => 'Stan systemu';
	@override String get subtitle => 'Wersja, dostawca, środowisko uruchomieniowe i szczegóły systemu.';
	@override String get package => 'Pakiet';
	@override String get uptime => 'Czas działania';
	@override String get platform => 'Platforma';
	@override String get memory => 'Pamięć';
	@override String memoryRss({required Object mb}) => '${mb} MB RSS';
	@override String get runtimeOnline => 'Środowisko działa';
	@override String processResponding({required Object pid}) => 'Proces #${pid} odpowiada.';
	@override String get processStatusResponding => 'Proces odpowiada.';
	@override String get healthy => 'Sprawny';
}

// Path: chat.commandDialog.syntax
class Translations$chat$commandDialog$syntax$pl extends Translations$chat$commandDialog$syntax$en {
	Translations$chat$commandDialog$syntax$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Składnia';
	@override String arguments({required Object arguments, required Object first, required Object second}) => '${arguments} przekazuje wszystkie argumenty; ${first}, ${second} – pozycyjne.';
	@override String file({required Object token}) => '${token} dołącza zawartość pliku.';
	@override String bash({required Object token}) => '${token} uruchamia bash.';
}

// Path: chat.utilities.tooltip
class Translations$chat$utilities$tooltip$pl extends Translations$chat$utilities$tooltip$en {
	Translations$chat$utilities$tooltip$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String tokensUsed({required Object tokens}) => 'użyte tokeny: ${tokens}';
	@override String contextOf({required Object percent, required Object total}) => 'kontekst ${percent}% z ${total}';
	@override String input({required Object value}) => 'wejście ${value}';
	@override String cache({required Object read, required Object write}) => 'cache: odczyt ${read} · zapis ${write}';
	@override String output({required Object value}) => 'wyjście ${value}';
}

// Path: chat.toolBlocks.status
class Translations$chat$toolBlocks$status$pl extends Translations$chat$toolBlocks$status$en {
	Translations$chat$toolBlocks$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get running => 'W toku';
	@override String get denied => 'Odrzucono';
}

// Path: chat.toolBlocks.verbs
class Translations$chat$toolBlocks$verbs$pl extends Translations$chat$toolBlocks$verbs$en {
	Translations$chat$toolBlocks$verbs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get read => 'odczyt';
	@override String get write => 'zapis';
	@override String get edit => 'edycja';
	@override String get delete => 'usunięcie';
	@override String get move => 'przeniesienie';
}

// Path: chat.commandMenu.namespaces
class Translations$chat$commandMenu$namespaces$pl extends Translations$chat$commandMenu$namespaces$en {
	Translations$chat$commandMenu$namespaces$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get frequent => 'Często używane';
	@override String get builtin => 'Polecenia wbudowane';
	@override String get skill => 'Umiejętności';
	@override String get project => 'Polecenia projektu';
	@override String get user => 'Polecenia użytkownika';
	@override String get other => 'Inne polecenia';
}

// Path: chat.mentionMenu.kinds
class Translations$chat$mentionMenu$kinds$pl extends Translations$chat$mentionMenu$kinds$en {
	Translations$chat$mentionMenu$kinds$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get file => 'plik';
	@override String get session => 'sesja';
	@override String get task => 'zadanie';
}

// Path: common.quota.section
class Translations$common$quota$section$pl extends Translations$common$quota$section$en {
	Translations$common$quota$section$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Przegląd';
	@override String get quotas => 'Limity';
	@override String get usage => 'Zużycie';
	@override String get agents => 'Agenci';
}

// Path: common.quota.filter
class Translations$common$quota$filter$pl extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get all => 'Wszystkie';
}

// Path: common.quota.period
class Translations$common$quota$period$pl extends Translations$common$quota$period$en {
	Translations$common$quota$period$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24 godz.';
	@override String get k7d => '7 dni';
	@override String get k30d => '30 dni';
	@override String get all => 'Wszystko';
}

// Path: common.quota.group
class Translations$common$quota$group$pl extends Translations$common$quota$group$en {
	Translations$common$quota$group$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Provider';
	@override String get model => 'Model';
	@override String get agent => 'Agent';
	@override String get tool => 'Narzędzie';
}

// Path: common.quota.metric
class Translations$common$quota$metric$pl extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Tokeny';
	@override String get input => 'Wejście';
	@override String get output => 'Wyjście';
	@override String get cache => 'Cache (odczyt)';
	@override String get calls => 'Wywołania API';
	@override String get cost => 'Koszt';
	@override String get sessions => 'Sesje';
}

// Path: common.quota.cost
class Translations$common$quota$cost$pl extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Faktura (API + overage)';
	@override String get listPrice => 'Cena katalogowa zużytych tokenów';
	@override String get subscriptionValue => 'Pokryte subskrypcją';
	@override String get cacheSavings => 'Oszczędność z cache';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$pl extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Faktura (API + overage)';
	@override String get listPrice => 'Cena katalogowa tokenów';
	@override String get subscriptionValue => 'Pokryte subskrypcją';
}

// Path: common.quota.overview
class Translations$common$quota$overview$pl extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tokeny i koszt — ostatnie 7 dni';
	@override String get effectiveCost => 'Efektywny koszt (7 dni)';
	@override String get alertsTitle => 'Alerty';
	@override String get noAlerts => 'Nic nie wymaga uwagi.';
	@override String get limitsTitle => 'Zużycie i limit';
	@override String get activeTasks => 'Aktywne zadania';
	@override String get viewAccounts => 'Wszystkie konta';
	@override String get viewAgents => 'Wszyscy agenci';
	@override String get noTasks => 'Żaden agent nie działa teraz.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$pl extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Trend dzienny';
	@override String breakdownTitle({required Object group}) => 'Podział wg ${group}';
	@override String get colName => 'Nazwa';
	@override String get sourceUnavailable => 'Magazyn analityczny niedostępny; brak danych.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$pl extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} działa';
	@override String get colAgent => 'Agent';
	@override String get colStatus => 'Status';
	@override String get colTask => 'Zadanie';
	@override String get colModel => 'Konto / model';
	@override String get colTime => 'Czas';
	@override String get empty => 'Brak agentów dla tego filtra.';
	@override String get detailSession => 'Sesja';
	@override String get detailStarted => 'Start';
	@override String get detailRetries => 'Ponowienia';
	@override String get detailResult => 'Wynik';
	@override String get notTracked => 'nieśledzone';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$pl extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get running => 'Działa';
	@override String get waiting => 'Oczekuje';
	@override String get failed => 'Błąd';
	@override String get finished => 'Zakończony';
	@override String get queued => 'W kolejce';
}

// Path: common.quota.alert
class Translations$common$quota$alert$pl extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: przy obecnym tempie limit skończy się za ${value}';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: zużyto ${value}% (próg ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$pl extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get live => 'Na żywo';
	@override String get cached => 'Cache';
	@override String get estimate => 'Szacunek';
	@override String get unknown => 'Nieznane';
	@override String get error => 'Błąd';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$pl extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Limity zagrożone';
	@override String atRiskHint({required Object value}) => 'konta powyżej ${value}%';
	@override String get windowsAtRisk => 'Okna na wyczerpaniu';
	@override String get errored => 'Błędy synchronizacji';
	@override String get activeAgents => 'Aktywne agenty';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} oczekuje · ${queued} w kolejce';
	@override String get nextReset => 'Najbliższy reset';
	@override String get tokens => 'Tokeny';
	@override String sessionsHint({required Object value}) => '${value} sesji';
	@override String get cost => 'Szacowany koszt';
	@override String costHint({required Object value}) => '${value} pokryte przez plany';
}

// Path: common.quota.empty
class Translations$common$quota$empty$pl extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Brak podłączonych kont';
	@override String get description => 'Zaloguj się do Claude, Codex, Gemini lub CommandCode, aby śledzić limity.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$pl extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Alerty i routing';
	@override String get description => 'Steruj tym, kiedy panel ostrzega i jak podpowiada konta do nowej pracy.';
	@override String get alertsEnabled => 'Alerty progowe i predykcyjne';
	@override String get alertsEnabledHint => 'Ostrzegaj, zanim limit się skończy, a nie dopiero przy 90%.';
	@override String get watchThreshold => 'Próg obserwacyjny (%)';
	@override String get dangerThreshold => 'Próg krytyczny (%)';
	@override String get routingMode => 'Routing';
	@override late final Translations$common$quota$settings$routing$pl routing = Translations$common$quota$settings$routing$pl._(_root);
	@override String get logSources => 'Źródła logów';
	@override String get logSourcesHint => 'Ekrany Zużycie i Agenci czytają te źródła tylko do odczytu.';
	@override String get quotaConsent => 'Zezwól na odpytywanie limitów';
	@override String get quotaConsentHint => 'Odpytywanie endpointów providerów zapisanymi poświadczeniami.';
	@override String get perAccount => 'Nadpisania per konto';
	@override String get tab => 'Ustawienia Centrum sterowania';
}

// Path: common.quota.range
class Translations$common$quota$range$pl extends Translations$common$quota$range$en {
	Translations$common$quota$range$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Wszystko';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$pl extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Zmień nazwę';
	@override String get delete => 'Usuń';
	@override String get copyPath => 'Kopiuj ścieżkę';
	@override String get download => 'Pobierz';
	@override String get newFile => 'Nowy plik';
	@override String get newFolder => 'Nowy folder';
	@override String get upload => 'Wgraj pliki';
	@override String get refresh => 'Odśwież';
	@override String get menuLabel => 'Menu kontekstowe pliku';
	@override String get loading => 'Ładowanie...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$pl extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Usuń';
	@override String get fileWarning => 'Ten plik zostanie trwale usunięty.';
	@override String get folderWarning => 'Ten folder i cała jego zawartość zostaną trwale usunięte.';
	@override String title({required Object type}) => 'Usuń ${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$pl extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'Nie udało się skopiować ścieżki';
	@override String get fileCreated => 'Plik utworzony pomyślnie';
	@override String get fileDeleted => 'Plik usunięty';
	@override String get folderCreated => 'Folder utworzony pomyślnie';
	@override String get folderDeleted => 'Folder usunięty';
	@override String get folderDownloaded => 'Folder pobrany jako ZIP';
	@override String get pathCopied => 'Ścieżka skopiowana do schowka';
	@override String get renamed => 'Zmieniono nazwę pomyślnie';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$pl extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'Nazwa pliku nie może składać się tylko z kropek';
	@override String get emptyName => 'Nazwa pliku nie może być pusta';
	@override String get invalidChars => 'Nazwa pliku zawiera nieprawidłowe znaki';
	@override String get reserved => 'Nazwa pliku jest zastrzeżona';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$pl extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get type => 'Typ';
	@override String get configure => 'Konfiguracja';
	@override String get confirm => 'Potwierdzenie';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$pl extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get question => 'Czy masz już obszar roboczy, czy chcesz utworzyć nowy?';
	@override late final Translations$common$projectWizard$step1$existing$pl existing = Translations$common$projectWizard$step1$existing$pl._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$pl kNew = Translations$common$projectWizard$step1$kNew$pl._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$pl extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Ścieżka obszaru roboczego';
	@override String get newPath => 'Ścieżka obszaru roboczego';
	@override String get existingPlaceholder => '/path/to/existing/workspace';
	@override String get newPlaceholder => '/path/to/new/workspace';
	@override String get existingHelp => 'Pełna ścieżka do istniejącego katalogu obszaru roboczego';
	@override String get newHelp => 'Pełna ścieżka do katalogu obszaru roboczego';
	@override String get githubUrl => 'Adres URL GitHub (opcjonalnie)';
	@override String get githubPlaceholder => 'https://github.com/username/repository';
	@override String get githubHelp => 'Opcjonalnie: podaj adres URL GitHub, aby sklonować repozytorium';
	@override String get githubAuth => 'Uwierzytelnianie GitHub (opcjonalnie)';
	@override String get githubAuthHelp => 'Wymagane tylko w przypadku prywatnych repozytoriów. Repozytoria publiczne można klonować bez uwierzytelniania.';
	@override String get loadingTokens => 'Ładowanie zapisanych tokenów...';
	@override String get storedToken => 'Zapisany token';
	@override String get newToken => 'Nowy token';
	@override String get nonePublic => 'Brak (publiczne)';
	@override String get selectToken => 'Wybierz token';
	@override String get selectTokenPlaceholder => '-- Wybierz token --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Ten token zostanie użyty tylko do tej operacji';
	@override String get publicRepoInfo => 'Repozytoria publiczne nie wymagają uwierzytelniania. Możesz pominąć podawanie tokenu, jeśli klonujesz publiczne repozytorium.';
	@override String get noTokensHelp => 'Brak zapisanych tokenów. Możesz dodać tokeny w Ustawienia → Klucze API, aby łatwiej używać ich ponownie.';
	@override String get optionalTokenPublic => 'Token GitHub (opcjonalny dla repozytoriów publicznych)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (pozostaw puste dla repozytoriów publicznych)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$pl extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Sprawdź swoją konfigurację';
	@override String get existingWorkspace => 'Istniejący obszar roboczy';
	@override String get newWorkspace => 'Nowy obszar roboczy';
	@override String get path => 'Ścieżka:';
	@override String get cloneFrom => 'Klonuj z:';
	@override String get authentication => 'Uwierzytelnianie:';
	@override String get usingStoredToken => 'Używanie zapisanego tokenu:';
	@override String get usingProvidedToken => 'Używanie podanego tokenu';
	@override String get noAuthentication => 'Bez uwierzytelniania';
	@override String get sshKey => 'Klucz SSH';
	@override String get existingInfo => 'Obszar roboczy zostanie dodany do Twojej listy projektów i będzie dostępny dla sesji Claude/Cursor.';
	@override String get newWithClone => 'Repozytorium zostanie sklonowane z tego folderu.';
	@override String get newEmpty => 'Obszar roboczy zostanie dodany do Twojej listy projektów i będzie dostępny dla sesji Claude/Cursor.';
	@override String get cloningRepository => 'Klonowanie repozytorium...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$pl extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Anuluj';
	@override String get back => 'Wstecz';
	@override String get next => 'Dalej';
	@override String get createProject => 'Utwórz projekt';
	@override String get creating => 'Tworzenie...';
	@override String get cloning => 'Klonowanie...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$pl extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Wybierz, czy masz istniejący obszar roboczy, czy chcesz utworzyć nowy';
	@override String get providePath => 'Podaj ścieżkę obszaru roboczego';
	@override String get failedToCreate => 'Nie udało się utworzyć obszaru roboczego';
	@override String get failedToCreateFolder => 'Nie udało się utworzyć folderu';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$pl extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$pl generic = Translations$common$notifications$codes$generic$pl._(_root);
	@override late final Translations$common$notifications$codes$permission$pl permission = Translations$common$notifications$codes$permission$pl._(_root);
	@override late final Translations$common$notifications$codes$run$pl run = Translations$common$notifications$codes$run$pl._(_root);
	@override late final Translations$common$notifications$codes$agent$pl agent = Translations$common$notifications$codes$agent$pl._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$pl extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get close => 'Zamknij';
	@override String get later => 'Później';
	@override String get copyCommand => 'Kopiuj polecenie';
	@override String get updateNow => 'Zaktualizuj teraz';
	@override String get updating => 'Aktualizowanie...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$pl extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Zamknij okno aktualizacji wersji';
	@override String get showSidebar => 'Pokaż panel boczny';
	@override String get settings => 'Ustawienia';
	@override String get updateAvailable => 'Dostępna aktualizacja';
	@override String get closeSidebar => 'Zamknij panel boczny';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$pl extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Włącz Browser w ustawieniach, aby agenty mogły otwierać monitorowane sesje przeglądarki.';
	@override String get descEnabled => 'Sesje przeglądarki agenta pojawiają się tutaj, gdy zadanie AI korzysta z Browser.';
	@override String get titleDisabled => 'Browser jest wyłączony';
	@override String get titleEnabled => 'Brak sesji przeglądarki';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$pl extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'Akcja przeglądarki nie powiodła się';
	@override String get loadFailed => 'Nie udało się załadować Browser';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$pl extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Użyj Browser, aby sprawdzić proces płatności i zgłosić wszelkie uszkodzone elementy UI.';
	@override String get prompt2 => 'Otwórz <url> w Browser, wchodź w interakcję ze stroną i podsumuj, co zmieniło się po każdym kroku.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$pl extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' d temu';
	@override String get hoursAgo => ' godz. temu';
	@override String get justNow => 'Przed chwilą';
	@override String get minutesAgo => ' min temu';
	@override String get never => 'Nigdy';
	@override String get secondsAgo => ' s temu';
	@override String get unknown => 'Nieznane';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$pl extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Wyłączony';
	@override String get installing => 'Instalowanie';
	@override String get ready => 'Gotowy';
	@override String get setupRequired => 'Wymagana konfiguracja';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$pl extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Przeglądaj wszystkie gałęzie (${count})';
	@override String commits({required Object count}) => 'Przeglądaj wszystkie commity (${count})';
	@override String files({required Object count}) => 'Przeglądaj wszystkie pliki (${count})';
	@override String sessions({required Object count}) => 'Przeglądaj wszystkie sesje (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$pl extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'Koszt jest szacowany po stronie klienta na podstawie opublikowanych stawek za token; nieznane modele pokazują „—”.';
	@override String get estCost => 'Szac. koszt';
	@override String get inputOutput => 'Wejście / Wyjście';
	@override String get model => 'Model';
	@override String get na => 'N/D';
	@override String get openSplit => 'Otwórz w widoku podzielonym';
	@override String get provider => 'Dostawca';
	@override String get selectSession => 'Wybierz sesję…';
	@override String get tokensUsed => 'Użyte tokeny';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$pl extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Akcje';
	@override String get branches => 'Gałęzie';
	@override String get commits => 'Commity';
	@override String get files => 'Pliki';
	@override String get git => 'Git';
	@override String get navigate => 'Nawigacja';
	@override String get sessions => 'Sesje';
	@override String get settings => 'Ustawienia';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$pl extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get close => 'Zamknij';
	@override String get navigate => 'Nawiguj';
	@override String get select => 'Wybierz';
	@override String get togglePalette => 'Przełącz paletę';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$pl extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Porównaj sesje';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => 'Otwórz ustawienia';
	@override String get selectProjectFirst => 'Najpierw wybierz projekt';
	@override String settingsEntry({required Object label}) => 'Ustawienia: ${label}';
	@override String get startNewChat => 'Rozpocznij nowy czat';
	@override String switchTo({required Object name}) => 'Przełącz na: ${name}';
	@override String get toggleTheme => 'Przełącz motyw';
	@override String get tokensAndCost => 'tokeny i koszt';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$pl extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get board => 'Przejdź do Tablicy agentów';
	@override String get chat => 'Przejdź do Czatu';
	@override String get files => 'Przejdź do Plików';
	@override String get git => 'Przejdź do Git';
	@override String get sourceControl => 'Przejdź do Kontroli źródła';
	@override String get tasks => 'Przejdź do Zadań';
	@override String get usage => 'Przejdź do Limitów i zużycia';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$pl extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Akcje';
	@override String get branches => 'Gałęzie';
	@override String get commits => 'Commity';
	@override String get compare => 'Porównanie';
	@override String get files => 'Pliki';
	@override String get sessions => 'Sesje';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$pl extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => 'Usunąć gałąź „${branch}”? Zwykłe usunięcie powiedzie się tylko wtedy, gdy gałąź jest w pełni scalona. Tej operacji nie można cofnąć.';
	@override String confirmSwitch({required Object branch}) => 'Przełączyć na gałąź „${branch}”? Upewnij się, że nie masz niezatwierdzonych zmian.';
	@override String countBoth({required Object local, required Object remote}) => '${local} lokalne, ${remote} zdalne';
	@override String countLocal({required Object count}) => '${count} lokalne';
	@override String get current => 'bieżąca';
	@override String deleteTitle({required Object branch}) => 'Usuń ${branch}';
	@override String get emptyDesc => 'Utwórz gałąź, aby rozpocząć pracę równoległą.';
	@override String get forceDelete => 'Wymuś usunięcie';
	@override String get forceDeleteDesc => 'Trwale usuwa gałąź, nawet jeśli zawiera commity niescalone gdzie indziej.';
	@override String get forceDeleteLabel => 'Wymuś usunięcie tej niescalonej gałęzi';
	@override String get local => 'Lokalne';
	@override String get kNew => 'Nowa gałąź';
	@override String get noMatch => 'Żadna gałąź nie pasuje do wyszukiwania';
	@override String get none => 'Nie znaleziono gałęzi';
	@override String get remote => 'zdalne';
	@override String get kSwitch => 'Przełącz';
	@override String switchTo({required Object branch}) => 'Przełącz na ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$pl extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Potwierdź';
	@override String get delete => 'Usuń';
	@override String get deleteBranch => 'Usuń';
	@override String get discard => 'Odrzuć';
	@override String get publish => 'Opublikuj';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get revertLocalCommit => 'Cofnij commit';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$pl extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Potwierdź akcję';
	@override String get delete => 'Usuń plik';
	@override String get deleteBranch => 'Usuń gałąź';
	@override String get discard => 'Odrzuć zmiany';
	@override String get publish => 'Opublikuj gałąź';
	@override String get pull => 'Potwierdź pull';
	@override String get push => 'Potwierdź push';
	@override String get revertLocalCommit => 'Cofnij lokalny commit';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$pl extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Tworzenie gałęzi nie powiodło się';
	@override String get createWorktreeFailed => 'Nie udało się utworzyć worktree';
	@override String get deleteBranchFailed => 'Usuwanie gałęzi nie powiodło się';
	@override String get fetchFailed => 'Fetch nie powiódł się';
	@override String get initFailed => 'Nie udało się zainicjować repozytorium';
	@override String get initialCommitFailed => 'Nie udało się utworzyć pierwszego commita';
	@override String get mergeFailed => 'Scalanie nie powiodło się';
	@override String get openWorktreeFailed => 'Nie udało się otworzyć worktree';
	@override String get operationFailed => 'Operacja git nie powiodła się';
	@override String get publishFailed => 'Publikowanie nie powiodło się';
	@override String get pullFailed => 'Pull nie powiódł się';
	@override String get pushFailed => 'Push nie powiódł się';
	@override String get removeWorktreeFailed => 'Nie udało się usunąć worktree';
	@override String get stageFailed => 'Przygotowanie nie powiodło się';
	@override String get stageHunksFailed => 'Przygotowanie fragmentów nie powiodło się';
	@override String get switchFailed => 'Przełączenie gałęzi nie powiodło się';
	@override String get unstageFailed => 'Cofnięcie przygotowania nie powiodło się';
	@override String get unstageHunksFailed => 'Cofnięcie przygotowania fragmentów nie powiodło się';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$pl extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get added => 'Dodane';
	@override String get author => 'Autor';
	@override String get changedFiles => 'Zmienione pliki';
	@override String get date => 'Data';
	@override String get empty => 'Nie znaleziono commitów';
	@override String get files => 'Pliki';
	@override String get removed => 'Usunięte';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$pl extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Usuń worktree i usuń jego gałąź po scaleniu';
	@override String get cleanupLabel => 'Wyczyść po scaleniu';
	@override String commitCount({required Object count}) => '${count} commit(ów)';
	@override String get merge => 'Scal';
	@override String mergeMessage({required Object branch}) => 'Scal gałąź \'${branch}\'';
	@override String get messageLabel => 'Wiadomość commita';
	@override String squashDesc({required Object commits, required Object branch}) => 'Połącz wszystkie ${commits} w jeden commit na ${branch}';
	@override String get squashLabel => 'Scal commity (squash)';
	@override String get squashMerge => 'Squash i scal';
	@override String squashMessage({required Object branch}) => 'Scal squash gałęzi \'${branch}\'';
	@override String get title => 'Scal Worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$pl extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Spowoduje to utworzenie nowej gałęzi z bieżącej gałęzi (${branch})';
	@override String get nameLabel => 'Nazwa gałęzi';
	@override String get submit => 'Utwórz gałąź';
	@override String get title => 'Utwórz nową gałąź';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$pl extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Gałąź';
	@override String get createFrom => 'Utwórz z';
	@override String get description => 'Wyewidencjonuj gałąź w osobnym folderze i pracuj nad nią równolegle.';
	@override String get existingBranch => 'Istniejąca gałąź — zostanie wyewidencjonowana bez zmian.';
	@override String get submit => 'Utwórz worktree';
	@override String get switchAfter => 'Przełącz na worktree po utworzeniu';
	@override String get title => 'Nowy Worktree';
	@override String get willCreateIn => 'Zostanie utworzony w';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$pl extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get create => 'Utwórz pierwszy commit';
	@override String get creating => 'Tworzenie pierwszego commita...';
	@override String get description => 'To repozytorium nie ma jeszcze żadnych commitów. Utwórz pierwszy commit, aby zacząć śledzić zmiany.';
	@override String get title => 'Brak commitów';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$pl extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Ten projekt nie jest jeszcze repozytorium git. Zainicjuj je, aby zacząć śledzić zmiany i korzystać z funkcji kontroli źródła.';
	@override String get init => 'Uruchom git init';
	@override String get initializing => 'Inicjowanie repozytorium...';
	@override String get title => 'Brak repozytorium git';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$pl extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Usuń także gałąź';
	@override String description({required Object branch}) => 'Usunąć worktree dla ${branch}? Jego folder zostanie usunięty, a powiązany projekt zarchiwizowany — sesje czatu pozostaną do odzyskania.';
	@override String dirtyWarning({required Object count}) => 'Ten worktree ma ${count} niezatwierdzonych zmian, które zostaną utracone.';
	@override String get discardChanges => 'Odrzuć niezatwierdzone zmiany';
	@override String get title => 'Usuń Worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$pl extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get added => 'Dodany';
	@override String get deleted => 'Usunięty';
	@override String get modified => 'Zmodyfikowany';
	@override String get untracked => 'Nieśledzony';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$pl extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} zmian(y)';
	@override String count({required Object count}) => '${count} worktree(ów)';
	@override String get createFirst => 'Utwórz pierwszy worktree';
	@override String get detached => 'odczepiony';
	@override String detachedAt({required Object sha}) => 'odczepiony @ ${sha}';
	@override String get detachedHead => 'odczepiony HEAD';
	@override String get emptyDesc => 'Worktree wyewidencjonowuje gałąź w osobnym folderze, dzięki czemu możesz prowadzić równoległe sesje czatu i scalić wyniki, gdy będą gotowe.';
	@override String get emptyTitle => 'Pracuj nad gałęziami równolegle';
	@override String get locked => 'zablokowany';
	@override String get mainWorktree => 'główny worktree';
	@override String mergeTitle({required Object branch}) => 'Scal ${branch} do gałęzi bazowej';
	@override String get kNew => 'Nowy worktree';
	@override String get none => 'Brak worktree';
	@override String get nothingToMerge => 'Nic do scalenia — brak commitów przed gałęzią bazową';
	@override String get open => 'Otwórz';
	@override String get refresh => 'Odśwież worktree';
	@override String removeTitle({required Object branch}) => 'Usuń worktree dla ${branch}';
	@override String switchTo({required Object branch}) => 'Przełącz na ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$pl extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Zmiany';
	@override String get history => 'Commity';
	@override String get branches => 'Gałęzie';
	@override String get worktrees => 'Worktrees';
}

// Path: common.gitPanel.worktreeScripts
class Translations$common$gitPanel$worktreeScripts$pl extends Translations$common$gitPanel$worktreeScripts$en {
	Translations$common$gitPanel$worktreeScripts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Skrypty worktree';
	@override String get setup => 'Skrypt setup (po utworzeniu/otwarciu)';
	@override String get run => 'Uruchom dev server';
	@override String get stop => 'Zatrzymaj dev server';
	@override String get runScript => 'Skrypt run (dev server, na żądanie)';
	@override String get runPort => 'Port podglądu (opcjonalnie — wykrywany auto.)';
	@override String get invalidPort => 'Port musi być w zakresie 1–65535';
	@override String get sourceProject => 'Zapisane jako nadpisanie projektu';
	@override String get sourceFile => 'Z .ddagent/worktree.json — zapis utworzy nadpisanie projektu';
	@override String get sourceNone => 'Nic nie skonfigurowano';
	@override String get saving => 'Zapisywanie…';
	@override String get setupRunning => 'setup w toku';
	@override String get setupFailed => 'setup nieudany';
	@override String get running => 'działa';
	@override String get openPreview => 'Otwórz podgląd';
	@override String runExited({required Object code}) => 'run zakończony (${code})';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$pl extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Zakres';
	@override String get user => 'Użytkownik';
	@override String get project => 'Projekt';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$pl extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get system => 'Systemowy';
	@override String get light => 'Jasny';
	@override String get dark => 'Ciemny';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$pl extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Wygląd';
	@override String get toolDisplay => 'Wyświetlanie narzędzi';
	@override String get inputSettings => 'Ustawienia wprowadzania';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$pl extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Przeciąganie uchwytu';
	@override String get closePanel => 'Zamknij panel ustawień';
	@override String get openPanel => 'Otwórz panel ustawień';
	@override String get draggingStatus => 'Przeciąganie...';
	@override String get toggleAndMove => 'Kliknij, aby przełączyć, przeciągnij, aby przenieść';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$pl extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Zamknij panel skrótów';
	@override String get openPanel => 'Otwórz panel skrótów';
}

// Path: settings.miniOrchestration.enable
class Translations$settings$miniOrchestration$enable$pl extends Translations$settings$miniOrchestration$enable$en {
	Translations$settings$miniOrchestration$enable$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Włącz mini-orkiestrację';
	@override String get description => 'Kieruj sesje Auto (mini) przez silnik dwóch ról zamiast pełnego orkiestratora.';
}

// Path: settings.miniOrchestration.thinker
class Translations$settings$miniOrchestration$thinker$pl extends Translations$settings$miniOrchestration$thinker$en {
	Translations$settings$miniOrchestration$thinker$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Myśliciel (nie-flash)';
	@override String get description => 'Planuje, podejmuje decyzje, weryfikuje i pisze raport końcowy.';
}

// Path: settings.miniOrchestration.worker
class Translations$settings$miniOrchestration$worker$pl extends Translations$settings$miniOrchestration$worker$en {
	Translations$settings$miniOrchestration$worker$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wykonawca (flash)';
	@override String get description => 'Wykonuje każdy zaplanowany krok.';
}

// Path: settings.miniOrchestration.fields
class Translations$settings$miniOrchestration$fields$pl extends Translations$settings$miniOrchestration$fields$en {
	Translations$settings$miniOrchestration$fields$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Dostawca';
	@override String get model => 'Model';
	@override String get modelPlaceholder => 'Wybierz model';
	@override String get tier => 'Poziom';
}

// Path: settings.miniOrchestration.roles
class Translations$settings$miniOrchestration$roles$pl extends Translations$settings$miniOrchestration$roles$en {
	Translations$settings$miniOrchestration$roles$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Model dla typu zadania';
	@override String get description => 'Który model (rola) obsługuje dany typ zadania.';
}

// Path: settings.miniOrchestration.planner
class Translations$settings$miniOrchestration$planner$pl extends Translations$settings$miniOrchestration$planner$en {
	Translations$settings$miniOrchestration$planner$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planista';
	@override String get mode => 'Tryb';
	@override late final Translations$settings$miniOrchestration$planner$modes$pl modes = Translations$settings$miniOrchestration$planner$modes$pl._(_root);
	@override String get requireConfirmLabel => 'Potwierdź plan przed uruchomieniem';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$pl extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Włącz orkiestrację';
	@override String get description => 'Pozwól orkiestratorowi dobierać model do każdego kroku zamiast uruchamiać wszystko na jednym dostawcy.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$pl extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pula kandydatów';
	@override String get description => 'Modele, spośród których wybiera router — każdy przypisany do progu kosztu.';
	@override String get add => 'Dodaj kandydata';
	@override String get empty => 'Brak kandydatów — dodaj pierwszego, aby zacząć routing.';
	@override late final Translations$settings$orchestration$pool$fields$pl fields = Translations$settings$orchestration$pool$fields$pl._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$pl extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get free => 'Darmowy';
	@override String get cheap => 'Tani';
	@override String get mid => 'Średni';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$pl extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reguły routingu';
	@override String get description => 'Uporządkowana lista kandydatów dla typu zadania — wygrywa pierwszy dostępny.';
	@override String get addCandidate => 'Dodaj kandydata…';
	@override String get empty => 'Brak kandydatów — ten typ zadania nie ma dokąd trafić.';
	@override String get missing => '(usunięty)';
	@override String get remove => 'Usuń kandydata';
	@override late final Translations$settings$orchestration$rules$taskTypes$pl taskTypes = Translations$settings$orchestration$rules$taskTypes$pl._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$pl extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planista';
	@override String get description => 'Jak zapytanie jest dzielone na kierowane kroki.';
	@override String get modeLabel => 'Tryb planowania';
	@override late final Translations$settings$orchestration$planner$modes$pl modes = Translations$settings$orchestration$planner$modes$pl._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$pl modeHints = Translations$settings$orchestration$planner$modeHints$pl._(_root);
	@override String get candidateLabel => 'Model planisty';
	@override String get candidateDescription => 'Kandydat z puli używany do generowania planu i klasyfikacji.';
	@override String get candidatePlaceholder => 'Wybierz kandydata z puli';
	@override late final Translations$settings$orchestration$planner$templates$pl templates = Translations$settings$orchestration$planner$templates$pl._(_root);
	@override String get requireConfirm => 'Potwierdź plan przed startem';
	@override String get requireConfirmDescription => 'Wstrzymaj wykonanie po zaplanowaniu — kroki można edytować/wyłączać na karcie planu.';
	@override String get checkpointLabel => 'Autonomia';
	@override late final Translations$settings$orchestration$planner$checkpointModes$pl checkpointModes = Translations$settings$orchestration$planner$checkpointModes$pl._(_root);
	@override late final Translations$settings$orchestration$planner$checkpointHints$pl checkpointHints = Translations$settings$orchestration$planner$checkpointHints$pl._(_root);
	@override String get checkpointIntervalLabel => 'Liczba kroków między punktami kontrolnymi (1–50)';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$pl extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Limity wykonania';
	@override String get description => 'Ograniczenia równoległości i pętli naprawczych.';
	@override String get maxParallel => 'Maks. równoległe kroki';
	@override String get maxParallelDescription => 'Ile podzadań może działać jednocześnie (1–8).';
	@override String get maxFixLoops => 'Maks. pętli naprawczych';
	@override String get maxFixLoopsDescription => 'Ponowienia gdy krok nie przejdzie weryfikacji (0–5).';
	@override String get onNoCandidate => 'Gdy brak dostępnego kandydata';
	@override String get onNoCandidateDescription => 'Pytaj przed fallbackiem albo pomiń krok.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$pl onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$pl._(_root);
	@override String get useWorktree => 'Izolowany worktree';
	@override String get useWorktreeDescription => 'Uruchamiaj wszystkie wydelegowane kroki w jednym wspólnym worktree git zamiast w katalogu projektu.';
	@override String get maxSupervisorIterations => 'Maks. iteracji nadzorcy';
	@override String get maxSupervisorIterationsDescription => 'Limit rund decyzyjnych nadzorcy w trybie auto (1–100); po jego osiągnięciu uruchomienie kończy się raportem częściowym.';
	@override String get maxAttempts => 'Maks. prób na krok';
	@override String get maxAttemptsDescription => 'Łączna pula prób dla jednego kroku, licząc wszystkie ścieżki i ponowienia (1–50).';
	@override String get stepTimeoutMs => 'Limit czasu kroku (ms)';
	@override String get stepTimeoutMsDescription => 'Limit czasu podrzędnego uruchomienia dla każdej próby w milisekundach; 0 wyłącza.';
	@override String get runTimeoutMs => 'Limit czasu uruchomienia (ms)';
	@override String get runTimeoutMsDescription => 'Globalny limit czasu wykonania planu w milisekundach; 0 wyłącza.';
	@override String get retryBackoffBaseMs => 'Bazowe opóźnienie ponowień (ms)';
	@override String get retryBackoffBaseMsDescription => 'Podstawa wykładniczego opóźnienia między ponowieniami na tej samej ścieżce (pełny jitter).';
	@override String get retryBudgetTitle => 'Pula ponowień według klasy błędu';
	@override String get retryBudgetDescription => 'Liczba ponowień na tej samej ścieżce przed przełączeniem awaryjnym lub schłodzeniem (0–5).';
	@override late final Translations$settings$orchestration$execution$retryClasses$pl retryClasses = Translations$settings$orchestration$execution$retryClasses$pl._(_root);
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$pl extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get unsaved => 'Niezapisane zmiany';
	@override String get save => 'Zapisz';
	@override String get saving => 'Zapisywanie…';
	@override String get saved => 'Zapisano';
	@override String get discard => 'Odrzuć';
	@override String get error => 'Zapis nie powiódł się';
	@override String get emptyPool => 'Dodaj przynajmniej jednego kandydata przed zapisem.';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$pl extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Powiadamiaj tę przeglądarkę';
	@override String get enable => 'Włącz powiadomienia';
	@override String get disable => 'Wyłącz powiadomienia';
	@override String get enabled => 'Powiadomienia są włączone dla tej przeglądarki';
	@override String get loading => 'Aktualizowanie...';
	@override String get unsupported => 'Powiadomienia push nie są obsługiwane w tej przeglądarce.';
	@override String get denied => 'Powiadomienia push są zablokowane. Zezwól na nie w ustawieniach przeglądarki.';
	@override String get iosHint => 'Na iPhone/iPadzie powiadomienia działają dopiero po dodaniu DDAgent do ekranu głównego (Udostępnij → Dodaj do ekranu głównego) i włączeniu ich w zainstalowanej aplikacji.';
	@override String get test => 'Wyślij powiadomienie testowe';
	@override String get testNoSubscription => 'Żadne urządzenie nie jest zasubskrybowane. Najpierw dotknij „Włącz” na telefonie.';
	@override String testSuccess({required Object count}) => 'Wysłano do ${count} urządzeń. Jeśli nic się nie pojawiło na telefonie, dodaj DDAgent do ekranu głównego (iOS tego wymaga).';
	@override String get testNotDelivered => 'Nie udało się dotrzeć do żadnego urządzenia. Upewnij się, że aplikacja działa, a powiadomienia są włączone.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$pl extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Powiadamiaj to urządzenie';
	@override String get enabled => 'Powiadomienia są włączone dla tego urządzenia';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$pl extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Powiadamiaj tę aplikację desktopową';
	@override String get enable => 'Włącz powiadomienia';
	@override String get disable => 'Wyłącz powiadomienia';
	@override String get enabled => 'Powiadomienia są włączone dla tej aplikacji desktopowej';
	@override String get unsupported => 'Powiadomienia desktopowe nie są obsługiwane w tym systemie.';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$pl extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dźwięk';
	@override String get description => 'Odtwarzaj krótki sygnał, gdy uruchomienie czatu się zakończy lub gdy narzędzie wymaga zatwierdzenia.';
	@override String get enabled => 'Włączone';
	@override String get test => 'Test dźwięku';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$pl extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Typy zdarzeń';
	@override String get actionRequired => 'Wymagana akcja';
	@override String get stop => 'Uruchomienie zatrzymane';
	@override String get error => 'Uruchomienie nie powiodło się';
}

// Path: settings.notifications.messaging
class Translations$settings$notifications$messaging$pl extends Translations$settings$notifications$messaging$en {
	Translations$settings$notifications$messaging$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zatwierdzanie przez komunikatory';
	@override String get description => 'Zatwierdzaj lub odrzucaj prośby agentów o uprawnienia z poziomu Telegrama i otrzymuj powiadomienia o uruchomieniach na Discordzie.';
	@override String get enabled => 'Włączone';
	@override String get save => 'Zapisz';
	@override String get test => 'Test';
	@override String get pair => 'Sparuj';
	@override String get telegramToken => 'Token bota od @BotFather (123456:ABC…)';
	@override String get telegramHint => 'Wyślij dowolną wiadomość do swojego bota, a następnie sparuj czat poniżej.';
	@override String get discordWebhook => 'https://discord.com/api/webhooks/…';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$pl extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get telegram => 'Telegram';
	@override String get discord => 'Discord';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$pl extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Tryb ciemny';
	@override String get description => 'Przełączaj między motywem jasnym i ciemnym';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$pl extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edytor kodu';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$pl theme = Translations$settings$appearanceSettings$codeEditor$theme$pl._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$pl wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$pl._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$pl showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$pl._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$pl lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$pl._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$pl fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$pl._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$pl extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$pl focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$pl._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$pl extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get add => 'Dodaj serwer MCP';
	@override String get edit => 'Edytuj serwer MCP';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$pl extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get form => 'Formularz';
	@override String get json => 'Import JSON';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$pl extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Zakres';
	@override String get userGlobal => 'Użytkownik (globalny)';
	@override String get projectLocal => 'Projekt (lokalny)';
	@override String get userDescription => 'Zakres użytkownika: dostępny we wszystkich projektach na Twojej maszynie';
	@override String get projectDescription => 'Zakres lokalny: dostępny tylko w wybranym projekcie';
	@override String get cannotChange => 'Zakresu nie można zmienić podczas edycji istniejącego serwera';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$pl extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Nazwa serwera';
	@override String get transportType => 'Typ transportu';
	@override String get command => 'Polecenie';
	@override String get arguments => 'Argumenty (po jednym w wierszu)';
	@override String get jsonConfig => 'Konfiguracja JSON';
	@override String get url => 'URL';
	@override String get envVars => 'Zmienne środowiskowe (KLUCZ=wartość, po jednej w wierszu)';
	@override String get headers => 'Nagłówki (KLUCZ=wartość, po jednym w wierszu)';
	@override String get selectProject => 'Wybierz projekt...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$pl extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'my-server';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$pl extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Brak wymaganego pola: type';
	@override String get stdioRequiresCommand => 'Typ stdio wymaga pola command';
	@override String httpRequiresUrl({required Object type}) => 'Typ ${type} wymaga pola url';
	@override String get invalidJson => 'Nieprawidłowy format JSON';
	@override String get jsonHelp => 'Wklej konfigurację serwera MCP w formacie JSON. Przykładowe formaty:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$pl extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Anuluj';
	@override String get saving => 'Zapisywanie...';
	@override String get addServer => 'Dodaj serwer';
	@override String get updateServer => 'Zaktualizuj serwer';
}

// Path: settings.git.name
class Translations$settings$git$name$pl extends Translations$settings$git$name$en {
	Translations$settings$git$name$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Nazwa Git';
	@override String get help => 'Twoja nazwa do commitów Git';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$pl extends Translations$settings$git$email$en {
	Translations$settings$git$email$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'E-mail Git';
	@override String get help => 'Twój e-mail do commitów Git';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$pl extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get save => 'Zapisz konfigurację';
	@override String get saving => 'Zapisywanie...';
}

// Path: settings.git.status
class Translations$settings$git$status$pl extends Translations$settings$git$status$en {
	Translations$settings$git$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get success => 'Zapisano pomyślnie';
	@override String get error => 'Nie udało się zapisać';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$pl extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ Zapisz swój klucz API';
	@override String get alertMessage => 'To jedyny raz, gdy zobaczysz ten klucz. Przechowuj go w bezpiecznym miejscu.';
	@override String get iveSavedIt => 'Zapisałem go';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$pl extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Nazwa klucza API (np. Serwer produkcyjny)';
	@override String get createButton => 'Utwórz';
	@override String get cancelButton => 'Anuluj';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$pl extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get created => 'Utworzono:';
	@override String get lastUsed => 'Ostatnio użyto:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$pl extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get active => 'Aktywny';
	@override String get inactive => 'Nieaktywny';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$pl extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tokeny GitHub';
	@override String get description => 'Dodaj osobiste tokeny dostępu GitHub, aby klonować prywatne repozytoria przez zewnętrzne API.';
	@override String get descriptionAlt => 'Dodaj osobiste tokeny dostępu GitHub, aby klonować prywatne repozytoria. Możesz też przekazywać tokeny bezpośrednio w żądaniach API bez ich przechowywania.';
	@override String get addButton => 'Dodaj token';
	@override late final Translations$settings$apiKeys$github$form$pl form = Translations$settings$apiKeys$github$form$pl._(_root);
	@override String get empty => 'Nie dodano jeszcze żadnych tokenów GitHub.';
	@override String get added => 'Dodano:';
	@override String get confirmDelete => 'Czy na pewno chcesz usunąć ten token GitHub?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$pl extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dokumentacja zewnętrznego API';
	@override String get description => 'Dowiedz się, jak używać zewnętrznego API do uruchamiania sesji Claude/Cursor ze swoich aplikacji.';
	@override String get viewLink => 'Zobacz dokumentację API →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$pl extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Dostępna aktualizacja: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$pl extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLI nie jest zainstalowany';
	@override String get description => 'Do korzystania z funkcji zarządzania zadaniami wymagany jest TaskMaster CLI. Zainstaluj go, aby rozpocząć:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'Zobacz na GitHub';
	@override String get afterInstallation => 'Po instalacji:';
	@override late final Translations$settings$tasks$notInstalled$steps$pl steps = Translations$settings$tasks$notInstalled$steps$pl._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$pl extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'Włącz integrację z TaskMaster';
	@override String get enableDescription => 'Pokazuj zadania, banery i wskaźniki TaskMaster w panelu bocznym i w całym interfejsie';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$pl extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Sprawdzanie...';
	@override String get connected => 'Połączono';
	@override String get notConnected => 'Brak połączenia';
	@override String get disconnected => 'Rozłączono';
	@override String get checkingAuth => 'Sprawdzanie stanu uwierzytelniania...';
	@override String loggedInAs({required Object email}) => 'Zalogowano jako ${email}';
	@override String providerAccount({required Object provider}) => 'Konto ${provider}';
	@override String get authenticatedUser => 'uwierzytelniony użytkownik';
}

// Path: settings.agents.install
class Translations$settings$agents$install$pl extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => 'CLI ${agent} nie jest zainstalowane';
	@override String description({required Object agent}) => 'Zainstaluj CLI ${agent}, aby się zalogować i uruchamiać sesje.';
	@override String get button => 'Zainstaluj';
	@override String get installing => 'Instalowanie…';
	@override String get copyCommand => 'Kopiuj polecenie';
	@override String get docs => 'Dokumentacja';
	@override String success({required Object agent}) => 'CLI ${agent} zainstalowane';
	@override String get failed => 'Instalacja nie powiodła się — sprawdź dane wyjściowe terminala';
}

// Path: settings.agents.update
class Translations$settings$agents$update$pl extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aktualizuj CLI';
	@override String description({required Object agent}) => 'Zainstaluj najnowszą wersję CLI ${agent} na hoście serwera.';
	@override String get button => 'Aktualizuj';
	@override String get updating => 'Aktualizowanie…';
	@override String success({required Object agent}) => 'CLI ${agent} zaktualizowane';
	@override String get failed => 'Aktualizacja nie powiodła się — sprawdź wynik w terminalu';
}

// Path: settings.agents.account
class Translations$settings$agents$account$pl extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$pl claude = Translations$settings$agents$account$claude$pl._(_root);
	@override late final Translations$settings$agents$account$cursor$pl cursor = Translations$settings$agents$account$cursor$pl._(_root);
	@override late final Translations$settings$agents$account$codex$pl codex = Translations$settings$agents$account$codex$pl._(_root);
	@override late final Translations$settings$agents$account$opencode$pl opencode = Translations$settings$agents$account$opencode$pl._(_root);
	@override late final Translations$settings$agents$account$commandcode$pl commandcode = Translations$settings$agents$account$commandcode$pl._(_root);
	@override late final Translations$settings$agents$account$antigravity$pl antigravity = Translations$settings$agents$account$antigravity$pl._(_root);
	@override late final Translations$settings$agents$account$devin$pl devin = Translations$settings$agents$account$devin$pl._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$pl extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Logowanie';
	@override String get reAuthenticate => 'Uwierzytelnij ponownie';
	@override String description({required Object agent}) => 'Zaloguj się do swojego konta ${agent}, aby włączyć funkcje AI';
	@override String get reAuthDescription => 'Zaloguj się innym kontem lub odśwież poświadczenia';
	@override String get button => 'Zaloguj się';
	@override String get reLoginButton => 'Zaloguj ponownie';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$pl extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wyloguj';
	@override String get description => 'Wyloguj się z tego dostawcy i usuń zapisane poświadczenia';
	@override String get button => 'Wyloguj';
	@override String confirmTitle({required Object agent}) => 'Wylogować z ${agent}?';
	@override String confirmDescription({required Object agent}) => 'Spowoduje to usunięcie zapisanych poświadczeń ${agent} na serwerze. Zaloguj się ponownie, aby dalej korzystać z ${agent}.';
	@override String get success => 'Wylogowano';
	@override String get failed => 'Wylogowanie nie powiodło się';
}

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$pl extends Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nazwane konta';
	@override String get description => 'Dodatkowe zestawy poświadczeń. Sesja przypięta do konta uruchamia CLI z izolowanym katalogiem konfiguracji. Zaloguj się, uruchamiając raz CLI providera z pokazanymi zmiennymi.';
	@override String get sharedCli => 'Wszystkie konta korzystają z jednej instalacji CLI — aktualizuj ją w karcie połączenia powyżej.';
	@override String get loading => 'Ładowanie kont…';
	@override String get kDefault => 'Domyślne';
	@override String usage({required Object tokens}) => '${tokens} tokenów';
	@override String get usageButton => 'Użycie';
	@override String get showUsage => 'Pokaż użycie tokenów';
	@override String get makeDefault => 'Ustaw jako domyślne';
	@override String get remove => 'Usuń konto';
	@override String get newLabel => 'Nazwa konta (np. Praca)';
	@override String get add => 'Dodaj konto';
	@override late final Translations$settings$agents$accounts$autoSwitch$pl autoSwitch = Translations$settings$agents$accounts$autoSwitch$pl._(_root);
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$pl extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tryb uprawnień';
	@override String description({required Object provider}) => 'Domyślny tryb uprawnień dla nowych sesji ${provider}. Możesz go nadal zmienić dla pojedynczej sesji przyciskiem trybu w oknie czatu.';
	@override late final Translations$settings$permissions$permissionMode$modes$pl modes = Translations$settings$permissions$permissionMode$modes$pl._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$pl extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Serwery Model Context Protocol zapewniają Claude dodatkowe narzędzia i źródła danych';
	@override String get cursor => 'Serwery Model Context Protocol zapewniają Cursor dodatkowe narzędzia i źródła danych';
	@override String get codex => 'Serwery Model Context Protocol zapewniają Codex dodatkowe narzędzia i źródła danych';
	@override String get opencode => 'Serwery Model Context Protocol zapewniają OpenCode dodatkowe narzędzia i źródła danych';
	@override String get commandcode => 'Serwery Model Context Protocol zapewniają Command Code dodatkowe narzędzia i źródła danych';
	@override String get antigravity => 'Serwery Model Context Protocol zapewniają Antigravity dodatkowe narzędzia i źródła danych';
	@override String get devin => 'Serwery Model Context Protocol zapewniają dodatkowe narzędzia i źródła danych dla Devin';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$pl extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get local => 'lokalny';
	@override String get user => 'użytkownik';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$pl extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get command => 'Polecenie';
	@override String get url => 'URL';
	@override String get args => 'Argumenty';
	@override String get environment => 'Środowisko';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$pl extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Narzędzia';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count} więcej';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$pl extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Edytuj serwer';
	@override String get delete => 'Usuń serwer';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$pl extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Zarządzany';
	@override String get hint => 'Zarządzane przez DDAgent.';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$pl extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'O Codex MCP';
	@override String get description => 'Codex obsługuje serwery MCP oparte na stdio. Możesz dodawać serwery rozszerzające możliwości Codex o dodatkowe narzędzia i zasoby.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$pl extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '„${serverName}” zostanie usunięty z konfiguracji dostawcy.';
	@override String get title => 'Usunąć serwer MCP?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$pl extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => 'Progi alertów, polityka routingu i konta odpytywane o limity.';
	@override String get saved => 'Zapisano';
	@override String get alertsSection => 'Alerty';
	@override String get alertsSectionHint => 'Ostrzegaj zanim limit faktycznie się skończy, nie tylko przy 100%.';
	@override String get alertsEnabled => 'Alerty przewidywane';
	@override String get alertsEnabledHint => 'Pokazuj prognozy tempa na przeglądzie i kartach kont.';
	@override String get watchThreshold => 'Próg obserwacji (%)';
	@override String get watchThresholdHint => 'Konta na tym poziomie lub wyżej są liczone jako zagrożone.';
	@override String get dangerThreshold => 'Próg krytyczny (%)';
	@override String get dangerThresholdHint => 'Odczyty na tym poziomie lub wyżej są pokazywane na czerwono.';
	@override String get routingSection => 'Routing';
	@override String get routingSectionHint => 'Jak panel może przenosić pracę na konto z największym zapasem.';
	@override late final Translations$settings$quota$settings$routing$pl routing = Translations$settings$quota$settings$routing$pl._(_root);
	@override String get routingNote => 'Zmiana konta wpływa na koszt i jakość modelu, więc zawsze wymaga decyzji.';
	@override String get accountsSection => 'Odpytywane konta';
	@override String get accountsSectionHint => 'Dane logowania są czytane z każdego narzędzia; panel nigdzie ich nie wysyła.';
	@override String get sourcesSection => 'Źródła danych';
	@override String get sourcesSectionHint => 'Skąd pochodzą zużycie i koszt.';
	@override String get logSources => 'Magazyn logów tokenów i kosztów';
	@override String get logSourcesHint => 'Zbiorczy magazyn tylko do odczytu, wspólny z kolektorem tokboard.';
	@override String get readOnly => 'Tylko odczyt';
	@override String get quotaConsent => 'Odpytywanie limitów';
	@override String get quotaConsentHint => 'Czyta endpointy limitów providerów lokalnymi danymi logowania.';
	@override String get localOnly => 'Tylko lokalnie';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$pl extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Nie wykryto jeszcze żadnych kont.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$pl extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cached => 'z pamięci podręcznej';
	@override String get error => 'błąd';
	@override String get estimate => 'szacunek';
	@override String get live => 'na żywo';
	@override String get unknown => 'nieznane';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$pl extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'Nie udało się zainstalować środowiska przeglądarki';
	@override String get loadSettings => 'Nie udało się załadować ustawień Browser';
	@override String get loadStatus => 'Nie udało się załadować statusu Browser';
	@override String get saveSettings => 'Nie udało się zapisać ustawień Browser';
}

// Path: settings.about.pro
class Translations$settings$about$pro$pl extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Synchronizuj ustawienia';
	@override String get teamManagement => 'Zarządzanie zespołem';
	@override String get syncSettingsDescription => 'Synchronizuj preferencje, konfiguracje MCP i motyw we wszystkich swoich środowiskach.';
	@override String get teamManagementDescription => 'Wielu użytkowników, dostęp oparty na rolach i współdzielone projekty dla Twojego zespołu.';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$pl extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'Zarządzanie zadaniami oparte na AI: dziel złożone projekty na łatwe w realizacji podzadania';
	@override String get prdTemplates => 'Szablony PRD: generuj zadania z dokumentów wymagań produktu';
	@override String get dependencyTracking => 'Śledzenie zależności: poznaj relacje między zadaniami i kolejność ich wykonywania';
	@override String get progressVisualization => 'Wizualizacja postępów: tablice Kanban i szczegółowe statystyki zadań';
	@override String get cliIntegration => 'Integracja z CLI: używaj poleceń taskmaster do zaawansowanych przepływów pracy';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$pl extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$pl createPRD = Translations$tasks$gettingStarted$steps$createPRD$pl._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$pl generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$pl._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$pl analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$pl._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$pl startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$pl._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$pl extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Przykład:\n"Właśnie zainicjowałem nowy projekt z Claude Task Master. Mam PRD w .taskmaster/docs/prd.txt. Czy możesz pomóc mi go przetworzyć i utworzyć początkowe zadania?"';
	@override String get expandTask => '💬 Przykład:\n"Zadanie 5 wygląda na złożone. Czy możesz rozbić je na podzadania?"';
	@override String get addTask => '💬 Przykład:\n"Dodaj proszę nowe zadanie na implementację przesyłania obrazów profilu użytkownika z użyciem Cloudinary i zbadaj najlepsze podejście."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$pl extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Wskazówki dla zaawansowanych';
	@override String get search => 'Użyj paska wyszukiwania, aby szybko znaleźć konkretne zadania';
	@override String get views => 'Przełączaj między widokami Kanban, Lista i Siatka za pomocą przełączników widoku';
	@override String get filters => 'Użyj filtrów, aby skupić się na określonych statusach lub priorytetach zadań';
	@override String get details => 'Kliknij dowolne zadanie, aby wyświetlić szczegółowe informacje i zarządzać podzadaniami';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$pl extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 Dowiedz się więcej';
	@override String get description => 'TaskMaster AI to zaawansowany system zarządzania zadaniami stworzony dla programistów. Znajdziesz tu dokumentację, przykłady i możliwość wkładu w rozwój projektu.';
	@override String get githubButton => 'Zobacz na GitHubie';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$pl extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Brak kart';
	@override String get description => 'Dodaj kartę, opisz zadanie, a potem przeciągnij ją do „Do roboty”, żeby agent zaczął pracę.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$pl extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Backlog';
	@override String get ready => 'Do roboty';
	@override String get working => 'W trakcie';
	@override String get needsDecision => 'Potrzeba decyzji';
	@override String get done => 'Zakończone';
	@override String get archived => 'Archiwum';
}

// Path: tasks.board.card
class Translations$tasks$board$card$pl extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get running => 'W trakcie';
	@override String get abort => 'Przerwij';
	@override String get delete => 'Usuń';
	@override String get openSession => 'Otwórz sesję';
	@override String get pullRequest => 'Pull request';
	@override String get edit => 'Edytuj';
	@override String get moveTo => 'Przenieś do';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$pl extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Nowa karta';
	@override String get editTitle => 'Edytuj kartę';
	@override String get titleLabel => 'Tytuł';
	@override String get titlePlaceholder => 'Co ma zrobić agent?';
	@override String get descriptionLabel => 'Opis';
	@override String get descriptionPlaceholder => 'Dodaj kontekst, kryteria akceptacji, linki...';
	@override String get cancel => 'Anuluj';
	@override String get save => 'Zapisz';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$pl extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Agent';
	@override String get anyProvider => 'Dowolny agent';
	@override String get model => 'Model';
	@override String get defaultModel => 'Domyślny model';
	@override String get effort => 'Rozumowanie';
	@override String get defaultEffort => 'Domyślne';
	@override String get searchModel => 'Szukaj modeli…';
	@override String get noModels => 'Brak pasujących modeli';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$pl extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '„${cardTitle}” zostanie trwale usunięte.';
	@override String get title => 'Usunąć kartę?';
}

// Path: tasks.board.assignee
class Translations$tasks$board$assignee$pl extends Translations$tasks$board$assignee$en {
	Translations$tasks$board$assignee$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Przypisana osoba';
	@override String get all => 'Wszystkie osoby';
	@override String get unassigned => 'Nieprzypisane';
}

// Path: tasks.board.presence
class Translations$tasks$board$presence$pl extends Translations$tasks$board$presence$en {
	Translations$tasks$board$presence$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String online({required Object count}) => 'Online: ${count}';
}

// Path: tasks.board.activity
class Translations$tasks$board$activity$pl extends Translations$tasks$board$activity$en {
	Translations$tasks$board$activity$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aktywność';
	@override String get empty => 'Brak aktywności';
}

// Path: tasks.board.comments
class Translations$tasks$board$comments$pl extends Translations$tasks$board$comments$en {
	Translations$tasks$board$comments$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Komentarze';
	@override String get placeholder => 'Napisz komentarz…';
	@override String get send => 'Wyślij';
	@override String get unknownAuthor => 'Ktoś';
}

// Path: tasks.taskmaster.sort
class Translations$tasks$taskmaster$sort$pl extends Translations$tasks$taskmaster$sort$en {
	Translations$tasks$taskmaster$sort$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get statusAz => 'Status (A–Z)';
	@override String get statusZa => 'Status (Z–A)';
}

// Path: tasks.taskmaster.prd
class Translations$tasks$taskmaster$prd$pl extends Translations$tasks$taskmaster$prd$en {
	Translations$tasks$taskmaster$prd$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get fileNameRequired => 'Podaj nazwę pliku PRD.';
	@override String get contentRequired => 'Przed zapisaniem dodaj treść.';
	@override String get overwrite => 'Nadpisz';
	@override String get contentHint => '# Dokument wymagań produktowych (PRD)…';
}

// Path: tasks.taskmaster.detail
class Translations$tasks$taskmaster$detail$pl extends Translations$tasks$taskmaster$detail$en {
	Translations$tasks$taskmaster$detail$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get dependenciesLabel => 'Zależności (identyfikatory oddzielone przecinkami)';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$pl extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Katalog roboczy';
	@override String get envVars => 'Zmienne środowiskowe';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$pl extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get userAllProviders => 'Użytkownik (wszyscy dostawcy)';
	@override String get claudeLocal => 'Claude (lokalny)';
	@override String get projectAllProviders => 'Projekt (wszyscy dostawcy)';
	@override late final Translations$mcp$form$scope$description$pl description = Translations$mcp$form$scope$description$pl._(_root);
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$pl extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get workingDirectory => 'Katalog roboczy';
	@override String get envVarNames => 'Nazwy zmiennych środowiskowych';
	@override String get bearerTokenEnvVar => 'Zmienna środowiskowa tokenu bearer';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$pl extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => 'Dodawanie serwera MCP obsługuje u wszystkich dostawców tylko stdio i http, a nie ${type}.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} nie obsługuje serwerów MCP typu ${type}';
	@override String get jsonMustBeObject => 'Konfiguracja JSON musi być obiektem';
}

// Path: serverConnect.local.errors
class Translations$serverConnect$local$errors$pl extends Translations$serverConnect$local$errors$en {
	Translations$serverConnect$local$errors$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get releaseTagUnresolved => 'Nie udało się ustalić najnowszego tagu wydania DDAgent.';
	@override String get unsupportedPlatform => 'Lokalny serwer nie jest obsługiwany na tej platformie.';
	@override String unsupportedPlatformDetail({required Object platform}) => 'Lokalny serwer nie jest obsługiwany na tej platformie (${platform}).';
	@override String nodeExtractionFailed({required Object path}) => 'Rozpakowanie Node.js nie utworzyło pliku ${path}';
	@override String downloadFailed({required Object error}) => 'Pobieranie serwera nie powiodło się: ${error}';
	@override String installFailed({required Object error}) => 'Instalacja serwera nie powiodła się: ${error}';
	@override String get bundleNotInstalled => 'Pakiet serwera nie jest zainstalowany.';
	@override String spawnFailed({required Object error}) => 'Nie udało się uruchomić procesu lokalnego serwera: ${error}';
	@override String portInUse({required Object port}) => 'Port ${port} jest już używany przez inną aplikację.';
	@override String get exitedDuringStartup => 'Lokalny serwer zakończył działanie podczas uruchamiania.';
	@override String exitedDuringStartupWithOutput({required Object output}) => 'Lokalny serwer zakończył działanie podczas uruchamiania: ${output}';
	@override String get startTimeout => 'Przekroczono czas oczekiwania na uruchomienie lokalnego serwera.';
	@override String tarFailed({required Object command, required Object code, required Object output}) => '${command} zakończyło się błędem (kod ${code}): ${output}';
}

// Path: chat.orchestrator.decision.action
class Translations$chat$orchestrator$decision$action$pl extends Translations$chat$orchestrator$decision$action$en {
	Translations$chat$orchestrator$decision$action$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'deleguje';
	@override String get done => 'kończy';
	@override String get invalid => 'brak decyzji';
}

// Path: chat.orchestrator.decision.outcome
class Translations$chat$orchestrator$decision$outcome$pl extends Translations$chat$orchestrator$decision$outcome$en {
	Translations$chat$orchestrator$decision$outcome$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get success => 'sukces';
	@override String get partial => 'częściowo';
	@override String get failed => 'niepowodzenie';
}

// Path: chat.orchestrator.delegation.status
class Translations$chat$orchestrator$delegation$status$pl extends Translations$chat$orchestrator$delegation$status$en {
	Translations$chat$orchestrator$delegation$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get queued => 'w kolejce';
	@override String get running => 'w toku';
	@override String get done => 'zakończony';
	@override String get failed => 'niepowodzenie';
	@override String get aborted => 'przerwany';
	@override String get skipped => 'pominięty';
	@override String get awaitingDecision => 'czeka na decyzję';
}

// Path: chat.orchestrator.taskmaster.status
class Translations$chat$orchestrator$taskmaster$status$pl extends Translations$chat$orchestrator$taskmaster$status$en {
	Translations$chat$orchestrator$taskmaster$status$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get started => 'w toku';
	@override String get done => 'zrobione';
	@override String get complete => 'ukończone';
	@override String get failed => 'niepowodzenie';
	@override String get paused => 'wstrzymane';
	@override String get blocked => 'zablokowane';
	@override String get aborted => 'przerwane';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$pl extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Ręczny — tylko rekomendacja';
	@override String get ask => 'Pytaj przed zmianą konta';
	@override String get autoLowRisk => 'Auto-przełączanie dla zadań niskiego ryzyka';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$pl extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Istniejący obszar roboczy';
	@override String get description => 'Mam już obszar roboczy na moim serwerze i chcę go tylko dodać do listy projektów';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$pl extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nowy obszar roboczy';
	@override String get description => 'Utwórz nowy obszar roboczy, opcjonalnie sklonuj z repozytorium GitHub';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$pl extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$pl info = Translations$common$notifications$codes$generic$info$pl._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$pl extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$pl required = Translations$common$notifications$codes$permission$required$pl._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$pl extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$pl stopped = Translations$common$notifications$codes$run$stopped$pl._(_root);
	@override late final Translations$common$notifications$codes$run$failed$pl failed = Translations$common$notifications$codes$run$failed$pl._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$pl extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$pl notification = Translations$common$notifications$codes$agent$notification$pl._(_root);
}

// Path: settings.miniOrchestration.planner.modes
class Translations$settings$miniOrchestration$planner$modes$pl extends Translations$settings$miniOrchestration$planner$modes$en {
	Translations$settings$miniOrchestration$planner$modes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Planuj modelem myślącym';
	@override String get off => 'Pojedynczy krok';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$pl extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Nazwa';
	@override String get labelPlaceholder => 'np. SWE-2 Medium';
	@override String get provider => 'Dostawca';
	@override String get model => 'Model';
	@override String get modelPlaceholder => 'Wybierz model';
	@override String get effort => 'Effort';
	@override String get effortDefault => 'Domyślny dostawcy';
	@override String get effortPlaceholder => 'domyślny';
	@override String get account => 'Konto';
	@override String get accountDefault => 'Domyślne dostawcy';
	@override String get redundantAccounts => 'Konta zapasowe (redundancja)';
	@override String get redundantAccountsNone => 'Brak innych kont dla tego dostawcy';
	@override String get tier => 'Próg kosztu';
	@override String get remove => 'Usuń kandydata';
	@override String get moveUp => 'Przesuń w górę';
	@override String get moveDown => 'Przesuń w dół';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$pl extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get plan => 'Planowanie';
	@override String get quick => 'Szybkie odpowiedzi';
	@override String get research => 'Research';
	@override String get docs => 'Dokumentacja';
	@override String get code => 'Kodowanie';
	@override String get codeHard => 'Złożone kodowanie';
	@override String get test => 'Testowanie';
	@override String get review => 'Review';
	@override String get report => 'Raport';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$pl extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Szablony';
	@override String get off => 'Wyłączony';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$pl extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Model planisty rozbija każde zapytanie na typowane kroki.';
	@override String get template => 'Zapytania przechodzą przez ustalony pipeline wybrany poniżej.';
	@override String get off => 'Bez planowania — całe zapytanie trafia jako pojedynczy krok.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$pl extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Szablony pipeline\'ów';
	@override String get add => 'Dodaj szablon';
	@override String get namePlaceholder => 'Nazwa szablonu';
	@override String get addStep => 'Dodaj krok…';
	@override String get remove => 'Usuń szablon';
	@override String get removeStep => 'Usuń krok';
	@override String get empty => 'Brak szablonów.';
	@override String get emptySteps => 'Brak kroków — dodaj pierwszy poniżej.';
}

// Path: settings.orchestration.planner.checkpointModes
class Translations$settings$orchestration$planner$checkpointModes$pl extends Translations$settings$orchestration$planner$checkpointModes$en {
	Translations$settings$orchestration$planner$checkpointModes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get off => 'Autonomicznie';
	@override String get perStep => 'Co krok';
	@override String get everyN => 'Co N kroków';
}

// Path: settings.orchestration.planner.checkpointHints
class Translations$settings$orchestration$planner$checkpointHints$pl extends Translations$settings$orchestration$planner$checkpointHints$en {
	Translations$settings$orchestration$planner$checkpointHints$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get off => 'Decyzje nadzorcy są wykonywane bez pytania (tryb auto).';
	@override String get perStep => 'Pytaj o zgodę przed każdą proponowaną partią kroków.';
	@override String get everyN => 'Pytaj o zgodę po każdych N ukończonych krokach.';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$pl extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Pytaj';
	@override String get skip => 'Pomiń krok';
}

// Path: settings.orchestration.execution.retryClasses
class Translations$settings$orchestration$execution$retryClasses$pl extends Translations$settings$orchestration$execution$retryClasses$en {
	Translations$settings$orchestration$execution$retryClasses$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get rateLimit => 'Limit zapytań';
	@override String get quota => 'Limit wykorzystania';
	@override String get auth => 'Uwierzytelnianie';
	@override String get timeout => 'Przekroczenie czasu';
	@override String get transient => 'Błąd przejściowy';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$pl extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Motyw edytora';
	@override String get description => 'Domyślny motyw edytora kodu';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$pl extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Zawijanie wierszy';
	@override String get description => 'Domyślnie włącz zawijanie wierszy w edytorze';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$pl extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Pokaż minimapę';
	@override String get description => 'Wyświetl minimapę ułatwiającą nawigację w widoku różnic';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$pl extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Pokaż numery wierszy';
	@override String get description => 'Wyświetlaj numery wierszy w edytorze';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$pl extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Rozmiar czcionki';
	@override String get description => 'Rozmiar czcionki edytora w pikselach';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$pl extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Fokus podąża za kursorem';
	@override String get description => 'Po najechaniu myszą terminal przejmuje fokus i można w nim pisać';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$pl extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Nazwa tokenu (np. Repozytoria osobiste)';
	@override String get tokenPlaceholder => 'Osobisty token dostępu GitHub (ghp_...)';
	@override String get descriptionPlaceholder => 'Opis (opcjonalnie)';
	@override String get addButton => 'Dodaj token';
	@override String get cancelButton => 'Anuluj';
	@override String get howToCreate => 'Jak utworzyć osobisty token dostępu GitHub →';
	@override String get showToken => 'Pokaż token';
	@override String get hideToken => 'Ukryj token';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$pl extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Uruchom tę aplikację ponownie';
	@override String get autoAvailable => 'Funkcje TaskMaster staną się automatycznie dostępne';
	@override String get initCommand => 'Użyj task-master init w katalogu swojego projektu';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$pl extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asystent AI Anthropic Claude';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$pl extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Edytor kodu Cursor napędzany AI';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$pl extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asystent AI OpenAI Codex';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$pl extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asystent CLI OpenCode';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$pl extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asystent CLI Command Code';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$pl extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asystent CLI Antigravity';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$pl extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asystent CLI Devin';
}

// Path: settings.agents.accounts.autoSwitch
class Translations$settings$agents$accounts$autoSwitch$pl extends Translations$settings$agents$accounts$autoSwitch$en {
	Translations$settings$agents$accounts$autoSwitch$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Automatycznie przełączaj konto po wyczerpaniu limitu';
	@override String get description => 'Gdy konto osiągnie limit użycia, sesja przechodzi na inne konto tego samego agenta, które ma jeszcze limit — nawet jeśli ręcznie wybrano wyczerpane konto. Nigdy nie przełącza na innego agenta. Claude i Codex zachowują rozmowę; inni agenci przełączają się tylko w nowych czatach.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$pl extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$pl kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$pl._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$pl auto = Translations$settings$permissions$permissionMode$modes$auto$pl._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$pl acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$pl._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$pl bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$pl._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$pl plan = Translations$settings$permissions$permissionMode$modes$plan$pl._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$pl extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Ręcznie';
	@override String get manualHint => 'Pokazuje tylko rekomendację; nigdy nie przełącza kont automatycznie.';
	@override String get ask => 'Pytaj przed przełączeniem';
	@override String get askHint => 'Przełączenie jest proponowane i czeka na Twoją zgodę.';
	@override String get autoLowRisk => 'Auto dla zadań niskiego ryzyka';
	@override String get autoLowRiskHint => 'Tylko zadania oznaczone jako niskiego ryzyka mogą być przenoszone automatycznie.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$pl extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Utwórz dokument wymagań produktu (PRD)';
	@override String get description => 'Omów swój pomysł na projekt i utwórz PRD opisujące, co chcesz zbudować.';
	@override String get addButton => 'Dodaj PRD';
	@override String get existingPRDs => 'Istniejące PRD:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$pl extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Generuj zadania z PRD';
	@override String get description => 'Gdy masz już PRD, poproś asystenta AI o jego przetworzenie, a TaskMaster automatycznie podzieli je na łatwe w realizacji zadania ze szczegółami implementacji.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$pl extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analizuj i rozwijaj zadania';
	@override String get description => 'Poproś asystenta AI o analizę złożoności zadań i rozwinięcie ich w szczegółowe podzadania, aby ułatwić implementację.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$pl extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zacznij budować';
	@override String get description => 'Poproś asystenta AI o rozpoczęcie pracy nad zadaniami, aktualizowanie ich statusu i dodawanie nowych zadań w miarę rozwoju projektu.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$pl extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get userGlobal => 'Zapisuje w konfiguracji użytkownika każdego dostawcy i jest dostępny we wszystkich projektach na tej maszynie';
	@override String get user => 'Dostępny we wszystkich projektach na Twojej maszynie';
	@override String get local => 'Zapisany w ustawieniach użytkownika Claude dla wybranego projektu';
	@override String get projectGlobal => 'Zapisuje w obszarze roboczym wybranego projektu dla każdego dostawcy';
	@override String get project => 'Zapisany w obszarze roboczym wybranego projektu';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$pl extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Powiadomienie';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$pl extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wymagana akcja';
	@override String body({required Object toolName}) => '${toolName} czeka na Twoją decyzję.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$pl extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Uruchomienie zatrzymane';
	@override String body({required Object reason}) => 'Powód: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$pl extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Uruchomienie nie powiodło się';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$pl extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Powiadomienie agenta';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$pl extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Domyślny';
	@override String get description => 'Akcje wymagające uprawnień są wyświetlane do zatwierdzenia w czacie.';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$pl extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tryb automatyczny';
	@override String get description => 'Klasyfikator modelu decyduje przy każdym wywołaniu narzędzia, czy je zatwierdzić, czy odrzucić. Tryb bezobsługowy, ale bezpieczniejszy niż omijanie uprawnień — odrzucenia nadal występują.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$pl extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Akceptuj zmiany';
	@override String get description => 'Zmiany plików są zatwierdzane automatycznie; pozostałe akcje nadal wymagają Twojej zgody.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$pl extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Omijaj uprawnienia';
	@override String get description => 'Wszystkie akcje są zatwierdzane automatycznie — pełny dostęp bez pytań. Używaj ostrożnie.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$pl extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get description => 'Tryb planowania: agent analizuje i planuje bez wykonywania poleceń.';
}

/// The flat map containing all translations for locale <pl>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPl {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Twoja sesja wygasła. Zaloguj się ponownie.',
			'auth.login.title' => 'Witaj ponownie',
			'auth.login.description' => 'Zaloguj się do swojego samodzielnie hostowanego konta DDAgent',
			'auth.login.username' => 'Nazwa użytkownika',
			'auth.login.password' => 'Hasło',
			'auth.login.submit' => 'Zaloguj się',
			'auth.login.loading' => 'Logowanie...',
			'auth.login.errors.invalidCredentials' => 'Nieprawidłowa nazwa użytkownika lub hasło',
			'auth.login.errors.requiredFields' => 'Wypełnij wszystkie pola',
			'auth.login.errors.networkError' => 'Błąd sieci. Spróbuj ponownie.',
			'auth.login.placeholders.username' => 'Wpisz nazwę użytkownika',
			'auth.login.placeholders.password' => 'Wpisz hasło',
			'auth.register.title' => 'Utwórz konto',
			'auth.register.username' => 'Nazwa użytkownika',
			'auth.register.password' => 'Hasło',
			'auth.register.confirmPassword' => 'Potwierdź hasło',
			'auth.register.submit' => 'Utwórz konto',
			'auth.register.loading' => 'Tworzenie konta...',
			'auth.register.errors.passwordMismatch' => 'Hasła nie są identyczne',
			'auth.register.errors.usernameTaken' => 'Ta nazwa użytkownika jest już zajęta',
			'auth.register.errors.weakPassword' => 'Hasło jest zbyt słabe',
			'auth.register.errors.usernameTooShort' => 'Nazwa użytkownika musi mieć co najmniej 3 znaki',
			'auth.register.errors.passwordTooShort' => 'Hasło musi mieć co najmniej 6 znaków',
			'auth.logout.title' => 'Wyloguj się',
			'auth.logout.confirm' => 'Czy na pewno chcesz się wylogować?',
			'auth.logout.button' => 'Wyloguj się',
			'chat.codeBlock.copy' => 'Kopiuj',
			'chat.codeBlock.copied' => 'Skopiowano',
			'chat.codeBlock.copyCode' => 'Kopiuj kod',
			'chat.copyMessage.copy' => 'Kopiuj wiadomość',
			'chat.copyMessage.copied' => 'Wiadomość skopiowana',
			'chat.copyMessage.failed' => 'Nie udało się skopiować',
			'chat.copyMessage.selectFormat' => 'Wybierz format kopiowania',
			'chat.copyMessage.copyAsMarkdown' => 'Kopiuj jako markdown',
			'chat.copyMessage.copyAsText' => 'Kopiuj jako tekst',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => 'Błąd',
			'chat.messageTypes.tool' => 'Narzędzie',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.messageTypes.orchestrator' => 'Auto',
			'chat.orchestrator.routing.title' => 'Routing',
			'chat.orchestrator.routing.alternatives' => ({required Object list}) => 'Alternatywy: ${list}',
			'chat.orchestrator.routing.first' => ({required Object label, required Object task}) => '${label} — pierwszy kandydat dla ${task}',
			'chat.orchestrator.routing.skipped' => ({required Object label, required Object list}) => '${label} — wcześniejsi kandydaci pominięci (${list})',
			'chat.orchestrator.plan.title' => 'Plan',
			'chat.orchestrator.plan.disabled' => 'wyłączony',
			'chat.orchestrator.plan.awaitingConfirm' => 'Oczekiwanie na potwierdzenie planu.',
			'chat.orchestrator.plan.run' => 'Uruchom plan',
			'chat.orchestrator.plan.toggleStep' => 'Włącz krok',
			'chat.orchestrator.plan.confirmFailed' => 'Nie udało się uruchomić — spróbuj ponownie.',
			'chat.orchestrator.plan.fallback' => 'planner niedostępny — fallback na pojedynczy krok',
			'chat.orchestrator.plan.templateSource' => 'z szablonu pipeline',
			'chat.orchestrator.plan.offSource' => 'planner wyłączony',
			'chat.orchestrator.plan.stepCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} krok', few: '${count} kroki', many: '${count} kroków', other: '${count} kroków', ), 
			'chat.orchestrator.plan.supervisedSource' => 'pętla nadzorowana',
			'chat.orchestrator.decision.title' => 'Decyzja nadzorcy',
			'chat.orchestrator.decision.iteration' => ({required Object n}) => 'iteracja ${n}',
			'chat.orchestrator.decision.rationaleLabel' => 'Dlaczego',
			'chat.orchestrator.decision.awaitingConfirm' => 'Oczekiwanie na Twoją zgodę przed uruchomieniem tych kroków.',
			'chat.orchestrator.decision.proposedSteps' => 'Proponowane kroki',
			'chat.orchestrator.decision.action.kContinue' => 'deleguje',
			'chat.orchestrator.decision.action.done' => 'kończy',
			'chat.orchestrator.decision.action.invalid' => 'brak decyzji',
			'chat.orchestrator.decision.outcome.success' => 'sukces',
			'chat.orchestrator.decision.outcome.partial' => 'częściowo',
			'chat.orchestrator.decision.outcome.failed' => 'niepowodzenie',
			'chat.orchestrator.delegation.title' => 'Delegowany krok',
			'chat.orchestrator.delegation.openSession' => 'Otwórz pełną sesję',
			'chat.orchestrator.delegation.attempt' => ({required Object n}) => 'próba ${n}',
			'chat.orchestrator.delegation.retryStep' => 'Ponów / Popraw',
			'chat.orchestrator.delegation.continueStep' => 'Kontynuuj / Popraw',
			'chat.orchestrator.delegation.continueFailed' => 'Nie udało się — spróbuj ponownie.',
			'chat.orchestrator.delegation.status.queued' => 'w kolejce',
			'chat.orchestrator.delegation.status.running' => 'w toku',
			'chat.orchestrator.delegation.status.done' => 'zakończony',
			'chat.orchestrator.delegation.status.failed' => 'niepowodzenie',
			'chat.orchestrator.delegation.status.aborted' => 'przerwany',
			'chat.orchestrator.delegation.status.skipped' => 'pominięty',
			'chat.orchestrator.delegation.status.awaitingDecision' => 'czeka na decyzję',
			'chat.orchestrator.delegation.attempts' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} próba', few: '${count} próby', many: '${count} prób', other: '${count} prób', ), 
			'chat.orchestrator.delegation.candidates' => ({required Object list}) => 'kandydaci: ${list}',
			'chat.orchestrator.delegation.candidateCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} kandydat', few: '${count} kandydatów', many: '${count} kandydatów', other: '${count} kandydatów', ), 
			'chat.orchestrator.summary.title' => 'Podsumowanie',
			'chat.orchestrator.summary.progress' => ({required Object done, required Object total}) => 'Ukończone kroki: ${done}/${total}',
			'chat.orchestrator.summary.aborted' => 'przerwano',
			'chat.orchestrator.summary.timedOut' => 'przekroczono czas',
			'chat.orchestrator.summary.capped' => 'limit iteracji',
			'chat.orchestrator.summary.failed' => ({required Object list}) => 'Kroki z niepowodzeniem: ${list}',
			'chat.orchestrator.summary.kContinue' => 'Kontynuuj',
			'chat.orchestrator.summary.continueWork' => 'Kontynuuj pracę',
			'chat.orchestrator.summary.resumeFailed' => 'Nie udało się wznowić — spróbuj ponownie.',
			'chat.orchestrator.summary.runNextTask' => 'Uruchom następne zadanie',
			'chat.orchestrator.summary.endAllTasks' => 'Zakończ wszystkie zadania',
			'chat.orchestrator.summary.tasksRunning' => 'Praca nad zadaniami…',
			'chat.orchestrator.summary.cancelTasks' => 'Anuluj',
			'chat.orchestrator.backToParent' => 'Wróć do orkiestracji',
			'chat.orchestrator.taskmaster.title' => 'Kolejka zadań',
			'chat.orchestrator.taskmaster.remaining' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Pozostało: ${count}', few: 'Pozostało: ${count}', many: 'Pozostało: ${count}', other: 'Pozostało: ${count}', ), 
			'chat.orchestrator.taskmaster.status.started' => 'w toku',
			'chat.orchestrator.taskmaster.status.done' => 'zrobione',
			'chat.orchestrator.taskmaster.status.complete' => 'ukończone',
			'chat.orchestrator.taskmaster.status.failed' => 'niepowodzenie',
			'chat.orchestrator.taskmaster.status.paused' => 'wstrzymane',
			'chat.orchestrator.taskmaster.status.blocked' => 'zablokowane',
			'chat.orchestrator.taskmaster.status.aborted' => 'przerwane',
			'chat.orchestrator.gate.timedOut' => 'przekroczono czas',
			'chat.orchestrator.gate.exit' => ({required Object code}) => 'kod wyjścia ${code}',
			'chat.tools.settings' => 'Ustawienia narzędzia',
			'chat.tools.error' => 'Błąd narzędzia',
			'chat.tools.result' => 'Wynik narzędzia',
			'chat.tools.viewParams' => 'Wyświetl parametry wejściowe',
			'chat.tools.viewRawParams' => 'Wyświetl surowe parametry',
			'chat.tools.viewDiff' => 'Wyświetl diff edycji dla',
			'chat.tools.creatingFile' => 'Tworzenie nowego pliku:',
			'chat.tools.updatingTodo' => 'Aktualizowanie listy zadań',
			'chat.tools.read' => 'Odczyt',
			'chat.tools.readFile' => 'Odczytaj plik',
			'chat.tools.updateTodo' => 'Aktualizuj listę zadań',
			'chat.tools.readTodo' => 'Odczytaj listę zadań',
			'chat.tools.searchResults' => 'wyników',
			'chat.tools.todoReadLabel' => 'TodoRead — odczyt listy zadań',
			'chat.search.found' => ({required Object count, required Object type}) => 'Znaleziono ${count} ${type}',
			'chat.search.file' => 'plik',
			'chat.search.files' => 'pliki',
			'chat.search.pattern' => 'wzorzec:',
			'chat.search.kIn' => 'w:',
			'chat.fileOperations.updated' => 'Plik pomyślnie zaktualizowany',
			'chat.fileOperations.created' => 'Plik pomyślnie utworzony',
			'chat.fileOperations.written' => 'Plik pomyślnie zapisany',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => 'Nowy plik',
			'chat.fileOperations.viewContent' => 'Wyświetl zawartość pliku',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Wyświetl pełne wyjście (${count} znaków)',
			'chat.fileOperations.contentDisplayed' => 'Zawartość pliku jest wyświetlana w powyższym widoku diff',
			'chat.interactive.title' => 'Interaktywny prompt',
			'chat.interactive.waiting' => 'Oczekiwanie na Twoją odpowiedź w CLI',
			'chat.interactive.instruction' => 'Wybierz opcję w terminalu, w którym uruchomiony jest Claude.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude wybrał opcję ${number}',
			'chat.interactive.instructionDetail' => 'W CLI tę opcję wybiera się interaktywnie za pomocą klawiszy strzałek lub wpisując numer.',
			'chat.thinking.title' => 'Myślenie...',
			'chat.thinking.emoji' => '💭 Myślenie...',
			'chat.thinking.thoughtFewSeconds' => 'Myślał przez kilka sekund',
			'chat.json.response' => 'Odpowiedź JSON',
			'chat.permissions.grant' => ({required Object tool}) => 'Nadaj uprawnienia dla ${tool}',
			'chat.permissions.added' => 'Dodano uprawnienie',
			'chat.permissions.addTo' => ({required Object entry}) => 'Dodaje ${entry} do dozwolonych narzędzi.',
			'chat.permissions.retry' => 'Uprawnienie zapisane. Ponów żądanie, aby użyć narzędzia.',
			'chat.permissions.error' => 'Nie można zaktualizować uprawnień. Spróbuj ponownie.',
			'chat.permissions.openSettings' => 'Otwórz ustawienia',
			'chat.permissions.allow' => 'Zezwól',
			'chat.permissions.always' => 'Zawsze',
			'chat.permissions.editAndAllow' => 'Edytuj i zezwól',
			'chat.permissions.deny' => 'Odmów',
			'chat.permissions.reject' => 'Odrzuć',
			'chat.permissions.allowAll' => ({required Object count}) => 'Zezwól na wszystko (${count})',
			'chat.permissions.editInput' => 'Edytuj dane wejściowe',
			'chat.permissions.invalidJson' => 'Nieprawidłowy JSON',
			'chat.permissions.allowWithChanges' => 'Zezwól ze zmianami',
			'chat.permissions.alwaysDeny' => 'Zawsze odmawiaj',
			'chat.permissions.denyFeedbackTitle' => 'Odrzuć plan',
			'chat.permissions.denyFeedbackHint' => 'Co agent powinien zmienić? (opcjonalnie)',
			'chat.permissions.modeAppliesNextMessage' => 'Nowy tryb uprawnień zacznie obowiązywać od następnej wiadomości.',
			'chat.todo.updated' => 'Lista zadań została pomyślnie zaktualizowana',
			'chat.todo.current' => 'Aktualna lista zadań',
			'chat.plan.viewPlan' => '📋 Wyświetl plan implementacji',
			'chat.plan.title' => 'Plan implementacji',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Osiągnięto limit użycia Claude. Limit zostanie zresetowany o **${time} ${timezone}** - ${date}',
			'chat.codex.permissionMode' => 'Tryb uprawnień',
			'chat.codex.modes.kDefault' => 'Tryb domyślny',
			'chat.codex.modes.auto' => 'Tryb automatyczny',
			'chat.codex.modes.acceptEdits' => 'Akceptuj edycje',
			'chat.codex.modes.bypassPermissions' => 'Omijaj uprawnienia',
			'chat.codex.modes.plan' => 'Tryb planowania',
			'chat.codex.descriptions.kDefault' => 'Tylko zaufane polecenia (ls, cat, grep, git status itd.) są uruchamiane automatycznie. Pozostałe polecenia są pomijane. Może zapisywać w obszarze roboczym.',
			'chat.codex.descriptions.auto' => 'Klasyfikator modelu decyduje przy każdym wywołaniu narzędzia, czy je zatwierdzić, czy odrzucić. Tryb bezobsługowy, ale bezpieczniejszy niż omijanie uprawnień — odrzucenia nadal występują.',
			'chat.codex.descriptions.acceptEdits' => 'Wszystkie polecenia są uruchamiane automatycznie w obrębie obszaru roboczego. Pełny tryb automatyczny z wykonaniem w piaskownicy.',
			'chat.codex.descriptions.bypassPermissions' => 'Pełny dostęp do systemu bez ograniczeń. Wszystkie polecenia są uruchamiane automatycznie z pełnym dostępem do dysku i sieci. Używaj ostrożnie.',
			'chat.codex.descriptions.plan' => 'Tryb planowania - żadne polecenia nie są wykonywane',
			'chat.codex.technicalDetails' => 'Szczegóły techniczne',
			'chat.voice.autoRead' => 'Czytaj odpowiedzi na głos',
			'chat.voice.autoReadOn' => 'Czytanie odpowiedzi: włączone',
			'chat.voice.autoReadOff' => 'Czytanie odpowiedzi: wyłączone',
			'chat.voice.autoReadVoice' => 'Głos czytania',
			'chat.voice.autoReadVoiceAuto' => 'Głos automatyczny',
			'chat.voice.autoReadPreview' => 'Tak będą brzmiały odpowiedzi.',
			'chat.voice.speakMessage' => 'Czytaj na głos',
			'chat.voice.stopSpeaking' => 'Zatrzymaj czytanie',
			'chat.input.placeholder' => ({required Object provider}) => 'Wpisz / dla poleceń, @ dla plików lub zapytaj ${provider} o cokolwiek...',
			'chat.input.placeholderDefault' => 'Wpisz swoją wiadomość...',
			'chat.input.disabled' => 'Wprowadzanie wyłączone',
			'chat.input.attachFiles' => 'Załącz pliki',
			'chat.input.attachFilesDesc' => 'Prześlij zdjęcia, pliki lub dokumenty',
			'chat.input.takePhoto' => 'Zrób zdjęcie',
			'chat.input.takePhotoDesc' => 'Użyj aparatu, aby zrobić zdjęcie',
			'chat.input.moreTools' => 'Więcej narzędzi',
			'chat.input.commandsDesc' => 'Komendy i skróty',
			'chat.input.clearInputDesc' => 'Wyczyść wpisany tekst',
			'chat.input.attachImages' => 'Załącz obrazy',
			'chat.input.send' => 'Wyślij',
			'chat.input.stop' => 'Zatrzymaj',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter wyślij • / komendy • @ pliki',
			'chat.input.hintText.enter' => 'Enter wyślij • Shift+Enter nowa linia • / komendy • @ pliki',
			'chat.input.hintText.queue' => 'Enter, aby dodać kolejną wiadomość do kolejki',
			'chat.input.hintText.updateQueued' => 'Enter, aby zaktualizować wiadomość w kolejce',
			'chat.input.clickToChangeMode' => 'Kliknij, aby zmienić tryb uprawnień',
			'chat.input.showAllCommands' => 'Pokaż wszystkie polecenia',
			'chat.input.clearInput' => 'Wyczyść pole',
			'chat.input.scrollToBottom' => 'Przewiń na dół',
			'chat.input.newMessage' => 'Nowa wiadomość',
			'chat.input.newMessages' => 'Nowe wiadomości',
			'chat.input.queue.sendNext' => 'Dodaj następną wiadomość do kolejki',
			'chat.input.queue.update' => 'Zaktualizuj wiadomość w kolejce',
			'chat.input.queue.label' => 'W kolejce',
			'chat.input.queue.willSend' => 'Zostanie wysłana po zakończeniu',
			'chat.input.queue.edit' => 'Edytuj wiadomość w kolejce',
			'chat.input.queue.delete' => 'Usuń wiadomość z kolejki',
			'chat.input.queue.failed' => 'Nie udało się wysłać',
			'chat.input.queue.sendNow' => 'Wyślij teraz',
			'chat.input.queue.sendNowAfterTurn' => 'Ten agent nie przyjmuje wiadomości w trakcie tury — zostanie wysłana po bieżącej turze',
			'chat.input.queue.filesAttached' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} załączony plik', few: '${count} załączone pliki', many: '${count} załączonych plików', other: '${count} załączonego pliku', ), 
			'chat.input.autoContinueTasks' => 'Auto-kontynuacja',
			'chat.input.autoContinueTasksTooltip' => 'Włącz, by Devin automatycznie przechodził do kolejnych zadań Task Mastera',
			'chat.input.offlineQueue.clear' => 'Anuluj i wyczyść kolejkę offline',
			'chat.input.offlineQueue.clearBtn' => 'Anuluj',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} wiadomości w kolejce offline — zostaną wysłane automatycznie po ponownym połączeniu',
			'chat.input.offlineQueue.single' => '1 wiadomość w kolejce offline — zostanie wysłana automatycznie po ponownym połączeniu',
			'chat.input.voice' => 'Wprowadzanie głosowe',
			'chat.input.voiceStart' => 'Dyktuj wiadomość',
			'chat.input.voiceStop' => 'Zatrzymaj dyktowanie',
			'chat.input.pinFile' => 'Przypnij plik do kontekstu',
			'chat.input.voiceSettings' => 'Ustawienia głosu (STT)',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Aparat niedostępny: ${error}',
			'chat.composer.toolsAndActions' => 'Narzędzia i akcje',
			'chat.composer.toolsAndActionsDesc' => 'Narzędzia i akcje dla pola wiadomości',
			'chat.composer.reasoning' => 'Rozumowanie',
			'chat.composer.model' => 'Model',
			'chat.composer.effortDefault' => 'Domyślny',
			'chat.composer.loadingModels' => 'Wczytywanie modeli…',
			'chat.composer.modelMenu' => 'Wybierz model i poziom rozumowania',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'Jak mają być zatwierdzane działania ${provider}?',
			'chat.composer.favorites' => 'Ulubione',
			'chat.composer.account' => 'Konto',
			'chat.composer.accountMenu' => 'Wybierz konto',
			'chat.composer.accountDefault' => 'Konto domyślne',
			'chat.composer.accountAuto' => 'Automatycznie (domyślne)',
			'chat.composer.accountIsDefault' => 'Domyślne',
			'chat.composer.effortLevels.off' => 'Wyłączone',
			'chat.composer.effortLevels.none' => 'Brak',
			'chat.composer.effortLevels.minimal' => 'Minimalny',
			'chat.composer.effortLevels.low' => 'Niski',
			'chat.composer.effortLevels.medium' => 'Średni',
			'chat.composer.effortLevels.high' => 'Wysoki',
			'chat.composer.effortLevels.xhigh' => 'Bardzo wysoki',
			'chat.composer.effortLevels.max' => 'Maksymalny',
			'chat.composer.effortLevels.ultra' => 'Ultra',
			'chat.composer.contextWindow' => ({required Object size}) => 'kontekst ${size}',
			'chat.composer.accountAutoShort' => 'Automatycznie',
			'chat.composer.uploadNoRecords' => 'Przesyłanie nie zwróciło żadnych plików',
			'chat.providerSelection.title' => 'Wybierz swojego asystenta AI',
			'chat.providerSelection.description' => 'Wybierz dostawcę, aby rozpocząć nową rozmowę',
			'chat.providerSelection.selectModel' => 'Wybierz model',
			'chat.providerSelection.workspace' => 'Obszar roboczy',
			'chat.providerSelection.noWorkspace' => 'Brak',
			'chat.providerSelection.clickToChangeWorkspace' => 'Kliknij, aby zmienić obszar roboczy',
			'chat.providerSelection.chooseWorkspace' => 'Wybierz obszar roboczy',
			'chat.providerSelection.searchWorkspaces' => 'Szukaj obszarów roboczych...',
			'chat.providerSelection.noWorkspacesFound' => 'Nie znaleziono obszarów roboczych.',
			'chat.providerSelection.providerInfo.anthropic' => 'od Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'od OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'Edytor kodu AI',
			'chat.providerSelection.providerInfo.google' => 'od Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Claude z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Cursor z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Codex z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'OpenCode z modelem ${model} jest gotowy do użycia. Zacznij wpisywać swoją wiadomość poniżej.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Wybierz dostawcę powyżej, aby rozpocząć',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Gotowe z Devin ${model}',
			'chat.providerSelection.readyPrompt.orchestrator' => 'Gotowe z Auto — router wybiera najlepszy model dla każdego kroku',
			'chat.providerSelection.autoGroup' => 'Auto',
			'chat.providerSelection.autoLabel' => 'Auto (orkiestrowane)',
			'chat.providerSelection.autoDescription' => 'Kieruje każdy krok do najlepszego dostępnego dostawcy i modelu',
			'chat.providerSelection.orchestrated' => 'orkiestrowane',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Naciśnij <kbd>${shortcut}</kbd>, aby wyszukiwać sesje, pliki i commity',
			'chat.providerSelection.all' => 'Wszystkie',
			'chat.providerSelection.free' => 'Darmowe',
			'chat.providerSelection.noModelsFound' => 'Nie znaleziono modeli.',
			'chat.providerSelection.paid' => 'Płatne',
			'chat.providerSelection.searchModels' => 'Szukaj modeli...',
			'chat.providerSelection.addModel' => 'Dodaj model',
			'chat.providerSelection.chooseModel' => 'Wybierz model',
			'chat.providerSelection.chooseModelDescription' => 'Wbudowane i niestandardowe modele na jednej liście',
			'chat.providerSelection.clickToChange' => 'Kliknij, aby zmienić model',
			'chat.providerSelection.favorites' => 'Ulubione',
			'chat.providerSelection.loadingModels' => 'Ładowanie modeli…',
			'chat.providerSelection.manageModels' => 'Zarządzaj modelami',
			'chat.providerSelection.refresh' => 'Odśwież modele',
			'chat.session.kContinue.title' => 'Kontynuuj rozmowę',
			'chat.session.kContinue.description' => 'Zadawaj pytania o swój kod, proś o zmiany lub uzyskaj pomoc przy zadaniach deweloperskich',
			'chat.session.kContinue.action' => 'Kontynuuj pisanie',
			'chat.session.loading.olderMessages' => 'Wczytywanie starszych wiadomości...',
			'chat.session.loading.sessionMessages' => 'Wczytywanie wiadomości sesji...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => 'Wyświetlanie ${shown} z ${total} wiadomości',
			'chat.session.messages.scrollToLoad' => 'Przewiń w górę, aby wczytać więcej',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Wyświetlanie ostatnich ${count} wiadomości (łącznie ${total})',
			'chat.session.messages.loadEarlier' => 'Wczytaj wcześniejsze wiadomości',
			'chat.session.messages.loadOlderFailed' => 'Nie udało się załadować starszych wiadomości.',
			'chat.session.messages.retry' => 'Ponów',
			'chat.session.messages.loadAll' => 'Wczytaj wszystkie wiadomości',
			'chat.session.messages.loadingAll' => 'Wczytywanie wszystkich wiadomości...',
			'chat.session.messages.allLoaded' => 'Wczytano wszystkie wiadomości',
			'chat.session.messages.perfWarning' => 'Wczytano wszystkie wiadomości — przewijanie może być wolniejsze. Kliknij „Przewiń na dół”, aby przywrócić wydajność.',
			'chat.session.messages.noSearchMatches' => 'Żadne wiadomości nie pasują do wyszukiwania.',
			'chat.session.messages.loadOlder' => 'Wczytaj starsze wiadomości',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Wczytaj wszystkie (${count})',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Ponów wczytywanie starszych — ${error}',
			'chat.session.deleteConfirm' => 'Usuwa sesję i jej transkrypt. Tej operacji nie można cofnąć.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Zakończ przebieg przed zmianą obszaru roboczego',
			'chat.session.fallbackTitle' => 'Sesja',
			'chat.shell.selectProject.title' => 'Wybierz projekt',
			'chat.shell.selectProject.description' => 'Wybierz projekt, aby otworzyć interaktywny shell w tym katalogu',
			'chat.shell.status.newSession' => 'Nowa sesja',
			'chat.shell.status.initializing' => 'Inicjalizacja...',
			'chat.shell.status.restarting' => 'Ponowne uruchamianie...',
			'chat.shell.actions.disconnect' => 'Rozłącz',
			'chat.shell.actions.disconnectTitle' => 'Rozłącz shell',
			'chat.shell.actions.restart' => 'Uruchom ponownie',
			'chat.shell.actions.restartTitle' => 'Uruchom ponownie shell',
			'chat.shell.actions.kill' => 'Zatrzymaj (SIGINT)',
			'chat.shell.actions.killTitle' => 'Zatrzymaj proces (SIGINT)',
			'chat.shell.actions.copyOutput' => 'Kopiuj wyjście',
			'chat.shell.actions.copyOutputTitle' => 'Kopiuj wyjście terminala',
			'chat.shell.actions.copied' => 'Skopiowano!',
			'chat.shell.actions.zoomInTitle' => 'Powiększ',
			'chat.shell.actions.zoomOutTitle' => 'Pomniejsz',
			'chat.shell.actions.connect' => 'Kontynuuj w shellu',
			'chat.shell.actions.connectTitle' => 'Połącz z shellem',
			'chat.shell.loading' => 'Wczytywanie terminala...',
			'chat.shell.connecting' => 'Łączenie z shellem...',
			'chat.shell.startSession' => 'Rozpocznij nową sesję agenta',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Wznów sesję: ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => 'Uruchom ${command} w ${projectName}',
			'chat.shell.startCli' => ({required Object projectName}) => 'Uruchamianie CLI agenta w ${projectName}',
			'chat.shell.defaultCommand' => 'polecenie',
			'chat.claudeStatus.actions.thinking' => 'Myślę',
			'chat.claudeStatus.actions.processing' => 'Przetwarzam',
			'chat.claudeStatus.actions.analyzing' => 'Analizuję',
			'chat.claudeStatus.actions.working' => 'Pracuję',
			'chat.claudeStatus.actions.computing' => 'Obliczam',
			'chat.claudeStatus.actions.reasoning' => 'Rozumuję',
			'chat.claudeStatus.state.live' => 'Na żywo',
			'chat.claudeStatus.state.paused' => 'Wstrzymano',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}s',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => 'Upłynęło ${time}',
			'chat.claudeStatus.elapsed.startingNow' => 'Zaczynam teraz',
			'chat.claudeStatus.stop' => 'Zatrzymaj',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} zadanie w tle w toku', few: '${count} zadania w tle w toku', many: '${count} zadań w tle w toku', other: '${count} zadania w tle w toku', ), 
			'chat.claudeStatus.controls.stopGeneration' => 'Zatrzymaj generowanie',
			'chat.claudeStatus.controls.pressEscToStop' => 'W dowolnym momencie naciśnij Esc, aby zatrzymać',
			'chat.claudeStatus.providers.assistant' => 'Asystent',
			'chat.claudeStatus.backgroundTasksTitle' => 'Działa w tle',
			'chat.claudeStatus.backgroundTaskUnnamed' => 'Zadanie bez nazwy',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Wybierz projekt, aby rozpocząć rozmowę z ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Rozpocznij następne zadanie',
			'chat.splitSession.toggle' => 'Podziel widok sesji',
			'chat.splitSession.close' => 'Zamknij podzielony widok sesji',
			'chat.splitSession.selectSession' => 'Wybierz sesję z listy bieżących',
			'chat.splitSession.noOtherSessions' => 'Brak innych dostępnych sesji',
			'chat.splitSession.newSessionOption' => '+ Nowa sesja w drugim oknie',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Bieżący projekt (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Inne projekty',
			'chat.splitSession.recentSessionsGroup' => 'Ostatnie sesje',
			'chat.splitSession.startNewSession' => 'Rozpocznij nową sesję w widoku podzielonym',
			'chat.splitSession.selectFromList' => 'Wybierz sesję z listy bieżących',
			'chat.sessionPicker.title' => 'Wybierz sesję',
			'chat.sessionPicker.searchPlaceholder' => 'Szukaj sesji...',
			'chat.sessionPicker.clearSearch' => 'Wyczyść wyszukiwanie',
			'chat.sessionPicker.newChat' => '+ Nowy czat',
			'chat.sessionPicker.archivedToggle' => 'Zarchiwizowane',
			'chat.sessionPicker.changeSession' => 'Zmień sesję',
			'chat.sessionPicker.archivedLoading' => 'Wczytywanie zarchiwizowanych sesji...',
			'chat.sessionPicker.archivedError' => 'Nie udało się wczytać zarchiwizowanych sesji',
			'chat.sessionPicker.archivedEmpty' => 'Brak zarchiwizowanych sesji',
			'chat.sessionPicker.archivedProjectOnly' => 'Workspace zarchiwizowany — przywróć go, aby zobaczyć jego sesje.',
			'chat.sessionPicker.emptySearch' => 'Brak sesji pasujących do wyszukiwania',
			'chat.sessionPicker.restore' => 'Przywróć',
			'chat.sessionPicker.restoreSession' => 'Przywróć sesję',
			'chat.sessionPicker.restoreProject' => 'Przywróć workspace',
			'chat.sessionPicker.restoreSessionFailed' => 'Nie udało się przywrócić sesji. Spróbuj ponownie.',
			'chat.sessionPicker.restoreProjectFailed' => 'Nie udało się przywrócić workspace\'a. Spróbuj ponownie.',
			'chat.sessionPicker.archiveFailed' => 'Nie udało się zarchiwizować sesji. Spróbuj ponownie.',
			'chat.sessionPicker.deleteFailed' => 'Nie udało się usunąć sesji. Spróbuj ponownie.',
			'chat.sessionPicker.running' => 'Sesja jest uruchomiona',
			'chat.sessionPicker.unread' => 'Nieprzeczytana — zakończona z nową odpowiedzią',
			'chat.sessionPicker.account' => 'Konto',
			'chat.splitWorkspace.addChat' => 'Dodaj panel czatu',
			'chat.splitWorkspace.addBrowser' => 'Dodaj panel przeglądarki',
			'chat.splitWorkspace.addTerminal' => 'Dodaj panel terminala',
			'chat.splitWorkspace.addPreview' => 'Dodaj panel podglądu',
			'chat.splitWorkspace.overview' => 'Pokaż wszystkie panele',
			'chat.splitWorkspace.exitFocusMode' => 'Wyjdź z trybu skupienia (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => 'Tryb skupienia (Ctrl+Shift+F)',
			'chat.splitWorkspace.broadcast' => 'Wyślij do wielu sesji',
			'chat.splitWorkspace.addNotes' => 'Dodaj panel notatek współdzielonych',
			'chat.splitWorkspace.browseSessions' => 'Otwórz listę sesji',
			'chat.splitOverview.title' => 'Przegląd paneli',
			'chat.splitOverview.count' => ({required Object count}) => '${count} paneli',
			'chat.splitOverview.close' => 'Zamknij przegląd',
			'chat.splitOverview.question' => 'PYTANIE — wymagane działanie',
			'chat.splitOverview.processing' => 'PRZETWARZANIE',
			'chat.splitOverview.idle' => 'Bezczynny',
			'chat.splitOverview.active' => 'Aktywna',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} potrzebuje Twojej odpowiedzi',
			'chat.askUserQuestion.skip' => 'Pomiń',
			'chat.askUserQuestion.other' => 'Inne…',
			'chat.askUserQuestion.answerHint' => 'Wpisz swoją odpowiedź…',
			'chat.attachments.downloadFailedRetry' => 'Pobieranie nie powiodło się — kliknij, aby ponowić',
			'chat.attachments.fileAttachment' => 'Załącznik pliku',
			'chat.attachments.download' => ({required Object name}) => 'Pobierz ${name}',
			'chat.attachments.attachedFile' => 'Załączony plik',
			'chat.attachments.downloaded' => ({required Object name}) => 'Pobrano ${name}',
			'chat.checkpoint.creating' => 'Tworzenie migawki…',
			'chat.checkpoint.revertChanges' => 'Przywróć pliki do ostatniego punktu kontrolnego',
			'chat.checkpoint.undo' => 'Cofnij punkt kontrolny',
			'chat.checkpoint.undoAiRun' => 'Cofnij przebieg AI',
			'chat.checkpoint.undoing' => 'Cofiwanie…',
			'chat.checkpoint.undone' => 'Cofnięto',
			'chat.checkpoint.beforeAiTurn' => 'przed turą AI',
			'chat.common.close' => 'Zamknij',
			'chat.taskMaster.saveToTask' => 'Zadanie',
			'chat.taskMaster.saved' => 'Zapisano',
			'chat.taskMaster.saving' => 'Zapisywanie...',
			'chat.taskMaster.taskShort' => 'TASK',
			'chat.taskMaster.addToTask' => 'Dodaj do TaskMaster',
			'chat.taskMaster.added' => 'Dodano do TaskMaster',
			'chat.taskMaster.defaultTaskTitle' => 'Zadanie z czatu',
			'chat.tokenUsage.desc' => 'Zobacz zużycie tokenów w sesji',
			'chat.tokenUsage.title' => 'Zużycie tokenów',
			'chat.tokenUsage.notAvailable' => 'b.d.',
			'chat.tokenUsage.tokensBadge' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} token', few: '${count} tokeny', many: '${count} tokenów', other: '${count} tokena', ), 
			'chat.tool.emptyResult' => '(brak wyjścia — narzędzie zwróciło pusty wynik)',
			'chat.quotaBadge.ariaLabel' => 'Limity subskrypcji',
			'chat.quotaBadge.noData' => 'Brak danych o subskrypcji dla tego modelu',
			'chat.quotaBadge.noSubscription' => 'brak subskrypcji',
			'chat.quotaBadge.windowLineReset' => ({required Object label, required Object percent, required Object time}) => '${label}: ${percent}% · reset ${time}',
			'chat.quotaBadge.windowRemaining' => ({required Object percent}) => 'Do resetu zostało ${percent}% okna',
			'chat.broadcast.title' => 'Wyślij do wielu sesji',
			'chat.broadcast.noSessions' => 'Brak dostępnych sesji',
			'chat.broadcast.placeholder' => 'Wiadomość dla wszystkich zaznaczonych sesji…',
			'chat.broadcast.partial' => ({required Object count}) => '${count} sesji odrzuciło wiadomość',
			'chat.broadcast.sent' => ({required Object count}) => 'W kolejce dla ${count} sesji',
			'chat.broadcast.selectAll' => 'Zaznacz wszystkie',
			'chat.broadcast.selectOrchestrators' => 'Zaznacz orchestratory',
			'chat.broadcast.orchestratorsOnly' => 'Tylko orchestratory',
			'chat.broadcast.noOrchestrators' => 'Brak dostępnych sesji orchestratora',
			'chat.broadcast.sending' => 'Wysyłanie…',
			'chat.broadcast.send' => ({required Object count}) => 'Wyślij do ${count}',
			'chat.paneHeader.processing' => 'Przetwarzanie…',
			'chat.paneHeader.switchSession' => 'Zmień sesję',
			'chat.export.sessionTitle' => ({required Object id}) => 'Sesja ${id}',
			'chat.export.pdfFailed' => 'Eksport PDF nie powiódł się',
			'chat.export.transcriptDownloaded' => 'Pobrano transkrypt',
			'chat.export.savedTo' => ({required Object path}) => 'Zapisano ${path}',
			'chat.commandResult.fallback.models' => 'Przeglądaj dostępne modele dla aktywnego dostawcy.',
			'chat.commandResult.fallback.cost' => 'Sprawdź zużycie tokenów w aktywnej sesji.',
			'chat.commandResult.fallback.status' => 'Sprawdź środowisko uruchomieniowe, wersję, dostawcę i stan środowiska.',
			'chat.commandResult.fallback.memory' => 'Otwórz plik pamięci CLAUDE.md projektu.',
			'chat.commandResult.fallback.config' => 'Otwórz ustawienia i konfigurację.',
			'chat.commandResult.fallback.help' => 'Pokaż dokumentację i składnię poleceń.',
			'chat.commandResult.filterCommands' => 'Filtruj polecenia...',
			'chat.commandResult.searchModels' => ({required Object provider}) => 'Szukaj modeli ${provider}...',
			'chat.commands.runConfirmTitle' => 'Uruchomić polecenie?',
			'chat.commands.executionCancelled' => 'Anulowano wykonywanie polecenia',
			'chat.commands.bashConfirmMessage' => 'To polecenie zawiera polecenia bash, które zostaną wykonane. Czy chcesz kontynuować?',
			'chat.commands.proceed' => 'Kontynuuj',
			'chat.pinFile.title' => 'Przypnij plik',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.action' => 'Przypnij',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => 'Edytuj ${name}',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => 'Usuń ${name}',
			'chat.modelLibrary.enterNameAndId' => 'Podaj zarówno nazwę modelu, jak i identyfikator modelu.',
			'chat.modelLibrary.idNoSpaces' => 'Identyfikatory modeli nie mogą zawierać spacji.',
			'chat.modelLibrary.setAsDefault' => 'Ustaw jako domyślne',
			'chat.modelLibrary.defaultModel' => 'Domyślny model',
			'chat.modelLibrary.title' => 'Biblioteka modeli',
			'chat.modelLibrary.subtitle' => 'Dodaj identyfikatory modeli obsługiwane przez dostawcę. Modele wbudowane pozostają zablokowane. Kółko oznacza model domyślny.',
			'chat.modelLibrary.yourModels' => 'Twoje modele',
			'chat.modelLibrary.yourModelsHint' => 'Edytowalne, przechowywane w auth.db',
			'chat.modelLibrary.emptyTitle' => 'Brak własnych modeli',
			'chat.modelLibrary.emptyHint' => 'Dodaj model za pomocą formularza, a pojawi się w każdym selektorze modeli.',
			'chat.modelLibrary.builtInModels' => 'Modele wbudowane',
			'chat.modelLibrary.builtInModelsHint' => 'Utrzymywane przez DDAgent, tylko do odczytu',
			'chat.modelLibrary.editTitle' => 'Edytuj własny model',
			'chat.modelLibrary.addTitle' => 'Dodaj własny model',
			'chat.modelLibrary.idSentAsWritten' => ({required Object provider}) => 'Identyfikator jest wysyłany do ${provider} dokładnie w tej postaci.',
			'chat.modelLibrary.nameLabel' => 'Nazwa modelu',
			'chat.modelLibrary.nameHint' => 'np. GPT-5.5 Pro',
			'chat.modelLibrary.idLabel' => 'Identyfikator modelu',
			'chat.modelLibrary.idHint' => 'np. gpt-5.5-pro',
			'chat.modelLibrary.idHelp' => 'Użyj dokładnie tego identyfikatora, który akceptuje CLI dostawcy. Identyfikatory nie mogą zawierać spacji.',
			'chat.modelLibrary.updatedNotice' => ({required Object name}) => 'Zaktualizowano ${name}.',
			'chat.modelLibrary.addedNotice' => ({required Object name}) => 'Dodano ${name}.',
			'chat.modelLibrary.deletedNotice' => ({required Object name}) => 'Usunięto ${name}.',
			'chat.modelLibrary.saving' => 'Zapisywanie…',
			'chat.modelLibrary.saveChanges' => 'Zapisz zmiany',
			'chat.modelLibrary.deleteConfirm' => 'Usunąć ten model ze wszystkich selektorów?',
			_ => null,
		} ?? switch (path) {
			'chat.modelLibrary.customBadge' => 'Własny',
			'chat.changes.failedToLoad' => 'Nie udało się wczytać zmian',
			'chat.changes.empty' => 'Brak zmian w plikach',
			'chat.message.compactedSummary' => 'Skrócone podsumowanie',
			'chat.message.resendHint' => 'Wyślij ponownie z pola wiadomości',
			'chat.message.rawView' => 'Widok surowy',
			'chat.message.runComplete' => 'Przebieg zakończony',
			'chat.message.runStopped' => 'Zatrzymano',
			'chat.message.runFailed' => ({required Object code}) => 'Uruchomienie nie powiodło się (kod ${code})',
			'chat.message.taskKilled' => 'Przerwane',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Prośba o uprawnienie · ${tool}',
			'chat.permissionRequest.question' => 'Pytanie',
			'chat.permissionRequest.subagent' => 'Subagent',
			'chat.permissionRequest.viewersCannotApprove' => 'Obserwatorzy nie mogą zatwierdzać',
			'chat.permissionRequest.recap.timedOut' => 'Upłynął limit czasu — odrzucono automatycznie',
			'chat.permissionRequest.recap.cancelled' => 'Anulowano — tura została zatrzymana',
			'chat.permissionRequest.recap.autoApproved' => 'Zatwierdzono automatycznie',
			'chat.permissionRequest.recap.expired' => 'Żądanie wygasło — agent już na nie nie czeka',
			'chat.permissionRequest.recap.answered' => 'Udzielono odpowiedzi',
			'chat.permissionRequest.recap.skipped' => 'Pominięto',
			'chat.permissionRequest.recap.decided' => 'Podjęto decyzję',
			'chat.permissionRequest.needsApproval' => ({required Object tool}) => '${tool} wymaga zatwierdzenia',
			'chat.permissionRequest.subagentNeedsApproval' => ({required Object tool}) => 'Subagent: ${tool} wymaga zatwierdzenia',
			'chat.permissionRequest.moreQuestions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Czeka jeszcze ${count} pytanie', few: 'Czekają jeszcze ${count} pytania', many: 'Czeka jeszcze ${count} pytań', other: 'Czeka jeszcze ${count} pytania', ), 
			'chat.commandDialog.help.eyebrow' => 'Centrum poleceń',
			'chat.commandDialog.help.title' => 'Pomoc i skróty',
			'chat.commandDialog.help.subtitle' => 'Przeszukuj wbudowane polecenia, wzorce składni i sposoby użycia.',
			'chat.commandDialog.models.eyebrow' => 'Wybór modelu',
			'chat.commandDialog.models.title' => 'Wybierz model',
			'chat.commandDialog.models.subtitle' => 'Wybierz model, którego ma używać ten dostawca.',
			'chat.commandDialog.models.modelSetTo' => ({required Object model}) => 'Ustawiono model ${model}.',
			'chat.commandDialog.models.activeModel' => 'Aktywny model',
			'chat.commandDialog.models.noModelsMatch' => 'Żaden model nie pasuje do tego filtra.',
			'chat.commandDialog.models.choiceSavedForSession' => 'Twój wybór zostanie zapisany dla tej sesji i stanie się domyślny dla nowych czatów.',
			'chat.commandDialog.models.choiceDefault' => 'Twój wybór stanie się domyślnym modelem dla nowych czatów.',
			'chat.commandDialog.models.custom' => 'Własny',
			'chat.commandDialog.models.currentSelection' => 'Bieżący wybór',
			'chat.commandDialog.cost.eyebrow' => 'Telemetria sesji',
			'chat.commandDialog.cost.title' => 'Zużycie tokenów',
			'chat.commandDialog.cost.subtitle' => 'Liczba tokenów wejściowych, wyjściowych i łącznie w tej sesji.',
			'chat.commandDialog.cost.totalTokensUsed' => 'Łącznie użyte tokeny',
			'chat.commandDialog.cost.inputTokens' => 'Tokeny wejściowe',
			'chat.commandDialog.cost.cacheReadTokens' => 'Tokeny odczytane z cache',
			'chat.commandDialog.cost.cacheWriteTokens' => 'Tokeny zapisane do cache',
			'chat.commandDialog.cost.outputTokens' => 'Tokeny wyjściowe',
			'chat.commandDialog.cost.breakdown' => 'Podział',
			'chat.commandDialog.cost.unavailable' => 'Niedostępny',
			'chat.commandDialog.cost.contextWindow' => 'Okno kontekstu',
			'chat.commandDialog.cost.estimatedCost' => 'Szacowany koszt',
			'chat.commandDialog.status.eyebrow' => 'Stan środowiska',
			'chat.commandDialog.status.title' => 'Stan systemu',
			'chat.commandDialog.status.subtitle' => 'Wersja, dostawca, środowisko uruchomieniowe i szczegóły systemu.',
			'chat.commandDialog.status.package' => 'Pakiet',
			'chat.commandDialog.status.uptime' => 'Czas działania',
			'chat.commandDialog.status.platform' => 'Platforma',
			'chat.commandDialog.status.memory' => 'Pamięć',
			'chat.commandDialog.status.memoryRss' => ({required Object mb}) => '${mb} MB RSS',
			'chat.commandDialog.status.runtimeOnline' => 'Środowisko działa',
			'chat.commandDialog.status.processResponding' => ({required Object pid}) => 'Proces #${pid} odpowiada.',
			'chat.commandDialog.status.processStatusResponding' => 'Proces odpowiada.',
			'chat.commandDialog.status.healthy' => 'Sprawny',
			'chat.commandDialog.defaultEyebrow' => 'Polecenie',
			'chat.commandDialog.defaultTitle' => 'Wynik polecenia',
			'chat.commandDialog.escHint' => 'Esc zamyka to okno.',
			'chat.commandDialog.unknown' => 'Nieznany',
			'chat.commandDialog.noDescription' => 'Brak opisu.',
			'chat.commandDialog.noCommandsMatch' => 'Żadne polecenie nie pasuje do tego filtra.',
			'chat.commandDialog.syntax.title' => 'Składnia',
			'chat.commandDialog.syntax.arguments' => ({required Object arguments, required Object first, required Object second}) => '${arguments} przekazuje wszystkie argumenty; ${first}, ${second} – pozycyjne.',
			'chat.commandDialog.syntax.file' => ({required Object token}) => '${token} dołącza zawartość pliku.',
			'chat.commandDialog.syntax.bash' => ({required Object token}) => '${token} uruchamia bash.',
			'chat.commandDialog.commandFinished' => 'Polecenie zakończone.',
			'chat.utilities.tokenUsageUnavailable' => 'Zużycie tokenów jest niedostępne',
			'chat.utilities.tooltip.tokensUsed' => ({required Object tokens}) => 'użyte tokeny: ${tokens}',
			'chat.utilities.tooltip.contextOf' => ({required Object percent, required Object total}) => 'kontekst ${percent}% z ${total}',
			'chat.utilities.tooltip.input' => ({required Object value}) => 'wejście ${value}',
			'chat.utilities.tooltip.cache' => ({required Object read, required Object write}) => 'cache: odczyt ${read} · zapis ${write}',
			'chat.utilities.tooltip.output' => ({required Object value}) => 'wyjście ${value}',
			'chat.utilities.used' => 'Użyte',
			'chat.utilities.cacheWrite' => 'Cache (zapis)',
			'chat.utilities.contextLabel' => 'Kontekst',
			'chat.utilities.usageUnsupported' => 'zużycie nieobsługiwane',
			'chat.utilities.chatTranscript' => 'Zapis czatu',
			'chat.utilities.you' => 'Ty:',
			'chat.utilities.providerAutoMini' => 'Auto (mini)',
			'chat.toolBlocks.moreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '… jeszcze ${count} wiersz', few: '… jeszcze ${count} wiersze', many: '… jeszcze ${count} wierszy', other: '… jeszcze ${count} wiersza', ), 
			'chat.toolBlocks.status.running' => 'W toku',
			'chat.toolBlocks.status.denied' => 'Odrzucono',
			'chat.toolBlocks.showLess' => 'Pokaż mniej',
			'chat.toolBlocks.showMore' => 'Pokaż więcej',
			'chat.toolBlocks.showMoreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Pokaż jeszcze ${count} wiersz', few: 'Pokaż jeszcze ${count} wiersze', many: 'Pokaż jeszcze ${count} wierszy', other: 'Pokaż jeszcze ${count} wiersza', ), 
			'chat.toolBlocks.tools' => 'Narzędzia',
			'chat.toolBlocks.planReview' => 'Przegląd planu',
			'chat.toolBlocks.planUpdate' => 'Aktualizacja planu',
			'chat.toolBlocks.todoListUpdated' => 'Zaktualizowano listę zadań',
			'chat.toolBlocks.creatingTask' => 'Tworzenie zadania',
			'chat.toolBlocks.updatingTask' => 'aktualizacja',
			'chat.toolBlocks.fetchingTask' => 'pobieranie',
			'chat.toolBlocks.listingTasks' => 'pobieranie listy zadań',
			'chat.toolBlocks.search' => 'Szukaj',
			'chat.toolBlocks.verbs.read' => 'odczyt',
			'chat.toolBlocks.verbs.write' => 'zapis',
			'chat.toolBlocks.verbs.edit' => 'edycja',
			'chat.toolBlocks.verbs.delete' => 'usunięcie',
			'chat.toolBlocks.verbs.move' => 'przeniesienie',
			'chat.toolBlocks.subagent' => 'Podagent',
			'chat.toolBlocks.toolCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} narzędzie', few: '${count} narzędzia', many: '${count} narzędzi', other: '${count} narzędzia', ), 
			'chat.toolBlocks.result' => 'wynik',
			'chat.toolBlocks.plusMore' => ({required Object count}) => '+${count} więcej',
			'chat.toolBlocks.plan' => 'Plan',
			'chat.toolBlocks.questionProgress' => ({required Object current, required Object total}) => 'Pytanie ${current}/${total}',
			'chat.toolBlocks.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} wiersz', few: '${count} wiersze', many: '${count} wierszy', other: '${count} wiersza', ), 
			'chat.toolBlocks.todoListItems' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Lista zadań (${count} pozycja)', few: 'Lista zadań (${count} pozycje)', many: 'Lista zadań (${count} pozycji)', other: 'Lista zadań (${count} pozycji)', ), 
			'chat.toolBlocks.tasksCompleted' => ({required Object done, required Object total}) => 'ukończono ${done}/${total}',
			'chat.commandMenu.empty' => 'Brak dostępnych poleceń',
			'chat.commandMenu.namespaces.frequent' => 'Często używane',
			'chat.commandMenu.namespaces.builtin' => 'Polecenia wbudowane',
			'chat.commandMenu.namespaces.skill' => 'Umiejętności',
			'chat.commandMenu.namespaces.project' => 'Polecenia projektu',
			'chat.commandMenu.namespaces.user' => 'Polecenia użytkownika',
			'chat.commandMenu.namespaces.other' => 'Inne polecenia',
			'chat.mentionMenu.kinds.file' => 'plik',
			'chat.mentionMenu.kinds.session' => 'sesja',
			'chat.mentionMenu.kinds.task' => 'zadanie',
			'chat.mentionMenu.taskTitle' => ({required Object id}) => 'Zadanie ${id}',
			'chat.subheader.contextTooltip' => ({required Object used, required Object total, required Object percent}) => 'Kontekst: ${used} / ${total} tokenów · wykorzystano ${percent}%',
			'chat.transcript.requestFailed' => 'Żądanie nie powiodło się',
			'chat.review.changedFiles' => 'Zmienione pliki',
			'chat.review.changedFilesCount' => ({required Object count}) => 'Zmienione pliki (${count})',
			'chat.review.subagent' => 'subagent',
			'codeEditor.toolbar.changes' => 'zmiany',
			'codeEditor.toolbar.previousChange' => 'Poprzednia zmiana',
			'codeEditor.toolbar.nextChange' => 'Następna zmiana',
			'codeEditor.toolbar.hideDiff' => 'Ukryj podświetlanie diff',
			'codeEditor.toolbar.showDiff' => 'Pokaż podświetlanie diff',
			'codeEditor.toolbar.settings' => 'Ustawienia edytora',
			'codeEditor.toolbar.collapse' => 'Zwiń edytor',
			'codeEditor.toolbar.expand' => 'Rozszerz edytor na pełną szerokość',
			'codeEditor.toolbar.toggleDock' => 'Przełącz dok plików',
			'codeEditor.toolbar.diffMerge' => 'Diff / scalanie',
			'codeEditor.toolbar.previewInBrowser' => 'Podgląd w przeglądarce',
			'codeEditor.toolbar.reload' => 'Wczytaj ponownie z dysku',
			'codeEditor.loading' => ({required Object fileName}) => 'Wczytywanie ${fileName}...',
			'codeEditor.header.showingChanges' => 'Wyświetlanie zmian',
			'codeEditor.actions.copyPath' => 'Kopiuj ścieżkę pliku',
			'codeEditor.actions.pathCopied' => 'Skopiowano ścieżkę pliku',
			'codeEditor.actions.download' => 'Pobierz plik',
			'codeEditor.actions.save' => 'Zapisz',
			'codeEditor.actions.saving' => 'Zapisywanie...',
			'codeEditor.actions.saved' => 'Zapisano!',
			'codeEditor.actions.exitFullscreen' => 'Wyjdź z pełnego ekranu',
			'codeEditor.actions.fullscreen' => 'Pełny ekran',
			'codeEditor.actions.close' => 'Zamknij',
			'codeEditor.actions.previewMarkdown' => 'Podgląd markdown',
			'codeEditor.actions.editMarkdown' => 'Edytuj markdown',
			'codeEditor.actions.pinFile' => 'Przypnij plik do kontekstu',
			'codeEditor.actions.unpinFile' => 'Odepnij plik od kontekstu',
			'codeEditor.actions.previewHtml' => 'Otwórz podgląd HTML w nowej karcie',
			'codeEditor.actions.retry' => 'Ponów',
			'codeEditor.actions.saveAll' => 'Zapisz wszystko',
			'codeEditor.footer.lines' => 'Linie:',
			'codeEditor.footer.characters' => 'Znaki:',
			'codeEditor.footer.shortcuts' => 'Naciśnij Ctrl+S, aby zapisać • Esc, aby zamknąć',
			'codeEditor.footer.plainText' => 'zwykły tekst',
			'codeEditor.footer.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} wiersz', few: '${count} wiersze', many: '${count} wierszy', other: '${count} wiersza', ), 
			'codeEditor.footer.modified' => 'zmodyfikowany',
			'codeEditor.binaryFile.title' => 'Plik binarny',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Plik "${fileName}" nie może zostać wyświetlony w edytorze tekstu, ponieważ jest to plik binarny.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Nie można wyświetlić jako tekst',
			'codeEditor.filePreview.loading' => 'Wczytywanie podglądu...',
			'codeEditor.filePreview.error' => 'Nie można wyświetlić tego pliku.',
			'codeEditor.filePreview.openInNewTab' => 'Otwórz w nowej karcie',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Niezapisane zmiany w ${name}',
			'codeEditor.discardUnsavedChanges' => 'Odrzucić niezapisane zmiany?',
			'codeEditor.mediaFile.title' => 'Plik multimedialny',
			'codeEditor.mediaFile.subtitle' => 'Podgląd audio/wideo nie jest jeszcze obsługiwany',
			'codeEditor.failedToLoad' => 'Nie udało się wczytać pliku',
			'codeEditor.hexDump.more' => ({required Object size}) => '… jeszcze ${size}',
			'codeEditor.settings.minimap' => 'Minimapa',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Rozmiar tabulacji: ${size}',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Rozmiar czcionki −  (teraz ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Rozmiar czcionki +',
			'codeEditor.diff.noChanges' => 'Brak zmian',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Fragment ${number}',
			'codeEditor.diff.close' => 'Zamknij diff',
			'codeEditor.diff.base' => 'Baza',
			'codeEditor.diff.current' => 'Bieżący',
			'codeEditor.diff.applyMerge' => 'Zastosuj scalenie',
			'codeEditor.diff.deletedOnDisk' => 'usunięty z dysku',
			'codeEditor.diff.untrackedWillBeDeleted' => 'Ten nieśledzony plik zostanie usunięty.',
			'codeEditor.diff.restoreConfirm' => ({required Object name}) => 'Przywrócić ${name} do stanu z ostatniego commita?',
			'codeEditor.diff.headVsWorkingCopy' => 'HEAD a kopia robocza',
			'codeEditor.diff.savedVsBuffer' => 'Ostatni zapis a bufor (bez gita)',
			'codeEditor.diff.unchangedLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} niezmieniony wiersz', few: '${count} niezmienione wiersze', many: '${count} niezmienionych wierszy', other: '${count} niezmienionego wiersza', ), 
			'codeEditor.diff.revertToSaved' => 'Przywróć zapisaną wersję',
			'codeEditor.emptyState.title' => 'Brak otwartego pliku',
			'codeEditor.emptyState.hint' => 'Otwórz pliki z karty Pliki',
			'codeEditor.toasts.savedFile' => ({required Object name}) => 'Zapisano ${name}',
			'codeEditor.toasts.saveFailed' => 'Zapis nie powiódł się',
			'codeEditor.toasts.allSaved' => 'Zapisano wszystko',
			'codeEditor.toasts.someSavesFailed' => 'Nie udało się zapisać niektórych plików',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Zapisano w ${path}',
			'codeEditor.toasts.mergeApplied' => 'Scalanie zastosowane — zapisz, aby zachować zmiany',
			'common.buttons.save' => 'Zapisz',
			'common.buttons.cancel' => 'Anuluj',
			'common.buttons.delete' => 'Usuń',
			'common.buttons.create' => 'Utwórz',
			'common.buttons.edit' => 'Edytuj',
			'common.buttons.close' => 'Zamknij',
			'common.buttons.confirm' => 'Potwierdź',
			'common.buttons.submit' => 'Wyślij',
			'common.buttons.retry' => 'Ponów',
			'common.buttons.refresh' => 'Odśwież',
			'common.buttons.search' => 'Szukaj',
			'common.buttons.clear' => 'Wyczyść',
			'common.buttons.copy' => 'Kopiuj',
			'common.buttons.download' => 'Pobierz',
			'common.buttons.upload' => 'Wgraj',
			'common.buttons.browse' => 'Przeglądaj',
			'common.buttons.update' => 'Aktualizuj',
			'common.buttons.openDiagram' => 'Otwórz diagram',
			'common.tabs.chat' => 'Czat',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => 'Pliki',
			'common.tabs.git' => 'Kontrola źródła',
			'common.tabs.tasks' => 'Zadania',
			'common.tabs.board' => 'Tablica',
			'common.tabs.browser' => 'Przeglądarka',
			'common.tabs.computer' => 'Komputer',
			'common.tabs.usage' => 'Control Center',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => 'Przegląd',
			'common.quota.section.quotas' => 'Limity',
			'common.quota.section.usage' => 'Zużycie',
			'common.quota.section.agents' => 'Agenci',
			'common.quota.filter.all' => 'Wszystkie',
			'common.quota.period.k24h' => '24 godz.',
			'common.quota.period.k7d' => '7 dni',
			'common.quota.period.k30d' => '30 dni',
			'common.quota.period.all' => 'Wszystko',
			'common.quota.group.provider' => 'Provider',
			'common.quota.group.model' => 'Model',
			'common.quota.group.agent' => 'Agent',
			'common.quota.group.tool' => 'Narzędzie',
			'common.quota.metric.tokens' => 'Tokeny',
			'common.quota.metric.input' => 'Wejście',
			'common.quota.metric.output' => 'Wyjście',
			'common.quota.metric.cache' => 'Cache (odczyt)',
			'common.quota.metric.calls' => 'Wywołania API',
			'common.quota.metric.cost' => 'Koszt',
			'common.quota.metric.sessions' => 'Sesje',
			'common.quota.cost.billed' => 'Faktura (API + overage)',
			'common.quota.cost.listPrice' => 'Cena katalogowa zużytych tokenów',
			'common.quota.cost.subscriptionValue' => 'Pokryte subskrypcją',
			'common.quota.cost.cacheSavings' => 'Oszczędność z cache',
			'common.quota.cost3.billed' => 'Faktura (API + overage)',
			'common.quota.cost3.listPrice' => 'Cena katalogowa tokenów',
			'common.quota.cost3.subscriptionValue' => 'Pokryte subskrypcją',
			'common.quota.overview.trendTitle' => 'Tokeny i koszt — ostatnie 7 dni',
			'common.quota.overview.effectiveCost' => 'Efektywny koszt (7 dni)',
			'common.quota.overview.alertsTitle' => 'Alerty',
			'common.quota.overview.noAlerts' => 'Nic nie wymaga uwagi.',
			'common.quota.overview.limitsTitle' => 'Zużycie i limit',
			'common.quota.overview.activeTasks' => 'Aktywne zadania',
			'common.quota.overview.viewAccounts' => 'Wszystkie konta',
			'common.quota.overview.viewAgents' => 'Wszyscy agenci',
			'common.quota.overview.noTasks' => 'Żaden agent nie działa teraz.',
			'common.quota.usage.trendTitle' => 'Trend dzienny',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Podział wg ${group}',
			'common.quota.usage.colName' => 'Nazwa',
			'common.quota.usage.sourceUnavailable' => 'Magazyn analityczny niedostępny; brak danych.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} działa',
			'common.quota.agents.colAgent' => 'Agent',
			'common.quota.agents.colStatus' => 'Status',
			'common.quota.agents.colTask' => 'Zadanie',
			'common.quota.agents.colModel' => 'Konto / model',
			'common.quota.agents.colTime' => 'Czas',
			'common.quota.agents.empty' => 'Brak agentów dla tego filtra.',
			'common.quota.agents.detailSession' => 'Sesja',
			'common.quota.agents.detailStarted' => 'Start',
			'common.quota.agents.detailRetries' => 'Ponowienia',
			'common.quota.agents.detailResult' => 'Wynik',
			'common.quota.agents.notTracked' => 'nieśledzone',
			'common.quota.agentStatus.running' => 'Działa',
			'common.quota.agentStatus.waiting' => 'Oczekuje',
			'common.quota.agentStatus.failed' => 'Błąd',
			'common.quota.agentStatus.finished' => 'Zakończony',
			'common.quota.agentStatus.queued' => 'W kolejce',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: przy obecnym tempie limit skończy się za ${value}',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: zużyto ${value}% (próg ${watch}%)',
			'common.quota.backToChat' => 'Wróć do czatu',
			'common.quota.syncNow' => 'Synchronizuj',
			'common.quota.generatedAt' => ({required Object value}) => 'Zaktualizowano ${value}',
			'common.quota.loading' => 'Wczytywanie limitów kont…',
			'common.quota.remaining' => ({required Object value}) => 'pozostało ${value}%',
			'common.quota.resetsIn' => ({required Object value}) => 'reset za ${value}',
			'common.quota.projected' => ({required Object value}) => 'przy obecnym tempie limit skończy się za ${value}',
			'common.quota.syncedAgo' => ({required Object value}) => 'synchronizacja ${value} temu',
			'common.quota.refreshAccount' => 'Odśwież konto',
			'common.quota.syncFailed' => 'Synchronizacja nieudana',
			'common.quota.history' => 'Historia',
			'common.quota.historyPoints' => ({required Object value}) => 'zapisano ${value} odczytów',
			'common.quota.historyEmpty' => 'Brak zapisanej historii',
			'common.quota.noAgents' => 'Brak przypisanych agentów',
			'common.quota.noSubscription' => 'Brak subskrypcji',
			'common.quota.noSubscriptionHint' => 'Provider nie widzi aktywnego planu dla tego konta.',
			'common.quota.quality.live' => 'Na żywo',
			'common.quota.quality.cached' => 'Cache',
			'common.quota.quality.estimate' => 'Szacunek',
			'common.quota.quality.unknown' => 'Nieznane',
			'common.quota.quality.error' => 'Błąd',
			'common.quota.kpi.atRisk' => 'Limity zagrożone',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'konta powyżej ${value}%',
			'common.quota.kpi.windowsAtRisk' => 'Okna na wyczerpaniu',
			'common.quota.kpi.errored' => 'Błędy synchronizacji',
			'common.quota.kpi.activeAgents' => 'Aktywne agenty',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} oczekuje · ${queued} w kolejce',
			'common.quota.kpi.nextReset' => 'Najbliższy reset',
			'common.quota.kpi.tokens' => 'Tokeny',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} sesji',
			'common.quota.kpi.cost' => 'Szacowany koszt',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} pokryte przez plany',
			'common.quota.empty.title' => 'Brak podłączonych kont',
			'common.quota.empty.description' => 'Zaloguj się do Claude, Codex, Gemini lub CommandCode, aby śledzić limity.',
			'common.quota.settings.title' => 'Alerty i routing',
			'common.quota.settings.description' => 'Steruj tym, kiedy panel ostrzega i jak podpowiada konta do nowej pracy.',
			'common.quota.settings.alertsEnabled' => 'Alerty progowe i predykcyjne',
			'common.quota.settings.alertsEnabledHint' => 'Ostrzegaj, zanim limit się skończy, a nie dopiero przy 90%.',
			'common.quota.settings.watchThreshold' => 'Próg obserwacyjny (%)',
			'common.quota.settings.dangerThreshold' => 'Próg krytyczny (%)',
			'common.quota.settings.routingMode' => 'Routing',
			'common.quota.settings.routing.manual' => 'Ręczny — tylko rekomendacja',
			'common.quota.settings.routing.ask' => 'Pytaj przed zmianą konta',
			'common.quota.settings.routing.autoLowRisk' => 'Auto-przełączanie dla zadań niskiego ryzyka',
			'common.quota.settings.logSources' => 'Źródła logów',
			'common.quota.settings.logSourcesHint' => 'Ekrany Zużycie i Agenci czytają te źródła tylko do odczytu.',
			'common.quota.settings.quotaConsent' => 'Zezwól na odpytywanie limitów',
			'common.quota.settings.quotaConsentHint' => 'Odpytywanie endpointów providerów zapisanymi poświadczeniami.',
			'common.quota.settings.perAccount' => 'Nadpisania per konto',
			'common.quota.settings.tab' => 'Ustawienia Centrum sterowania',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Wszystko',
			'common.status.loading' => 'Ładowanie...',
			'common.status.success' => 'Powodzenie',
			'common.status.error' => 'Błąd',
			'common.status.failed' => 'Niepowodzenie',
			'common.status.pending' => 'Oczekujące',
			'common.status.completed' => 'Ukończono',
			'common.status.inProgress' => 'W toku',
			'common.messages.savedSuccessfully' => 'Zapisano pomyślnie',
			'common.messages.deletedSuccessfully' => 'Usunięto pomyślnie',
			'common.messages.updatedSuccessfully' => 'Zaktualizowano pomyślnie',
			'common.messages.operationFailed' => 'Operacja nie powiodła się',
			'common.messages.networkError' => 'Błąd sieci. Sprawdź swoje połączenie.',
			'common.messages.unauthorized' => 'Brak autoryzacji. Zaloguj się.',
			'common.messages.notFound' => 'Nie znaleziono',
			'common.messages.invalidInput' => 'Nieprawidłowe dane wejściowe',
			'common.messages.requiredField' => 'To pole jest wymagane',
			'common.messages.unknownError' => 'Wystąpił nieznany błąd',
			'common.messages.renameSessionFailed' => 'Nie udało się zmienić nazwy sesji. Spróbuj ponownie.',
			'common.navigation.settings' => 'Ustawienia',
			'common.navigation.home' => 'Strona główna',
			'common.navigation.back' => 'Wstecz',
			'common.navigation.next' => 'Dalej',
			'common.navigation.previous' => 'Poprzedni',
			'common.navigation.logout' => 'Wyloguj się',
			'common.navigation.backToChat' => 'Powrót do czatu',
			'common.common.language' => 'Język',
			'common.common.theme' => 'Motyw',
			'common.common.darkMode' => 'Tryb ciemny',
			'common.common.lightMode' => 'Tryb jasny',
			'common.common.name' => 'Nazwa',
			'common.common.description' => 'Opis',
			'common.common.enabled' => 'Włączone',
			'common.common.disabled' => 'Wyłączone',
			'common.common.optional' => 'Opcjonalne',
			'common.common.version' => 'Wersja',
			'common.common.select' => 'Wybierz',
			'common.common.selectAll' => 'Zaznacz wszystko',
			'common.common.deselectAll' => 'Odznacz wszystko',
			'common.common.done' => 'Gotowe',
			'common.common.failed' => 'Niepowodzenie',
			'common.time.justNow' => 'Właśnie teraz',
			'common.time.minutesAgo' => ({required Object count}) => '${count} min temu',
			'common.time.hoursAgo' => ({required Object count}) => '${count} godz. temu',
			'common.time.daysAgo' => ({required Object count}) => '${count} dni temu',
			'common.time.yesterday' => 'Wczoraj',
			'common.fileOperations.newFile' => 'Nowy plik',
			'common.fileOperations.newFolder' => 'Nowy folder',
			'common.fileOperations.rename' => 'Zmień nazwę',
			'common.fileOperations.move' => 'Przenieś',
			'common.fileOperations.copyPath' => 'Kopiuj ścieżkę',
			'common.fileOperations.openInEditor' => 'Otwórz w edytorze',
			'common.mainContent.loading' => 'Ładowanie DDAgent',
			'common.mainContent.settingUpWorkspace' => 'Konfigurowanie obszaru roboczego...',
			'common.mainContent.chooseProject' => 'Wybierz swój projekt',
			'common.mainContent.selectProjectDescription' => 'Wybierz sesję w Panelu, aby rozpocząć kodowanie z Claude. Każdy projekt zawiera Twoje sesje czatu i historię plików.',
			'common.mainContent.tip' => 'Wskazówka',
			'common.mainContent.createProjectMobile' => 'Naciśnij przycisk menu powyżej, aby uzyskać dostęp do projektów',
			'common.mainContent.createProjectDesktop' => 'Utwórz nowy projekt, klikając ikonę folderu w panelu bocznym',
			'common.mainContent.newSession' => 'Nowa sesja',
			'common.mainContent.untitledSession' => 'Sesja bez nazwy',
			'common.mainContent.projectFiles' => 'Pliki projektu',
			'common.mainContent.focusMode' => 'Tryb skupienia (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Opuść tryb skupienia (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Podziel widok sesji',
			'common.mainContent.closeSplitSession' => 'Zamknij podzielony widok sesji',
			'common.mainContent.chooseWorkspace' => 'Wybierz obszar roboczy',
			'common.mainContent.chooseWorkspaceDescription' => 'Wybierz obszar roboczy dla tego czatu lub utwórz nowy w Ustawieniach.',
			'common.mainContent.createWorkspace' => 'Utwórz obszar roboczy w Ustawieniach',
			'common.mainContent.recentProjects' => 'Ostatnie projekty',
			'common.fileTree.loading' => 'Ładowanie plików...',
			'common.fileTree.files' => 'Pliki',
			'common.fileTree.simpleView' => 'Widok prosty',
			'common.fileTree.compactView' => 'Widok kompaktowy',
			'common.fileTree.detailedView' => 'Widok szczegółowy',
			'common.fileTree.searchPlaceholder' => 'Szukaj plików i folderów...',
			'common.fileTree.searchContentPlaceholder' => 'Szukaj w plikach...',
			'common.fileTree.searchInFiles' => 'Szukaj w plikach',
			'common.fileTree.searchByName' => 'Szukaj po nazwie',
			'common.fileTree.clearSearch' => 'Wyczyść wyszukiwanie',
			'common.fileTree.name' => 'Nazwa',
			'common.fileTree.size' => 'Rozmiar',
			'common.fileTree.modified' => 'Zmodyfikowano',
			'common.fileTree.permissions' => 'Uprawnienia',
			'common.fileTree.noFilesFound' => 'Nie znaleziono plików',
			'common.fileTree.checkProjectPath' => 'Sprawdź, czy ścieżka projektu jest dostępna',
			'common.fileTree.loadFailed' => 'Nie można załadować plików',
			'common.fileTree.noMatchesFound' => 'Nie znaleziono dopasowań',
			'common.fileTree.noSearchResults' => 'Nie znaleziono dopasowań',
			'common.fileTree.tryDifferentSearch' => 'Spróbuj innego wyszukiwanego hasła lub wyczyść wyszukiwanie',
			'common.fileTree.searchError' => 'Wyszukiwanie nie powiodło się',
			'common.fileTree.searching' => 'Wyszukiwanie...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Pokazano pierwsze ${count} wyników',
			'common.fileTree.justNow' => 'właśnie teraz',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} min temu',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} godz. temu',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} dni temu',
			'common.fileTree.newFile' => 'Nowy plik (Cmd+N)',
			'common.fileTree.newFolder' => 'Nowy folder (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Odśwież',
			'common.fileTree.collapseAll' => 'Zwiń wszystko',
			'common.fileTree.context.rename' => 'Zmień nazwę',
			'common.fileTree.context.delete' => 'Usuń',
			'common.fileTree.context.copyPath' => 'Kopiuj ścieżkę',
			'common.fileTree.context.download' => 'Pobierz',
			'common.fileTree.context.newFile' => 'Nowy plik',
			'common.fileTree.context.newFolder' => 'Nowy folder',
			'common.fileTree.context.upload' => 'Wgraj pliki',
			'common.fileTree.context.refresh' => 'Odśwież',
			'common.fileTree.context.menuLabel' => 'Menu kontekstowe pliku',
			'common.fileTree.context.loading' => 'Ładowanie...',
			'common.fileTree.allWorkspaces' => 'Wszystkie obszary robocze',
			'common.fileTree.delete.confirm' => 'Usuń',
			'common.fileTree.delete.fileWarning' => 'Ten plik zostanie trwale usunięty.',
			'common.fileTree.delete.folderWarning' => 'Ten folder i cała jego zawartość zostaną trwale usunięte.',
			'common.fileTree.delete.title' => ({required Object type}) => 'Usuń ${type}',
			'common.fileTree.dropToUpload' => 'Upuść pliki, aby przesłać',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Upuść pliki, aby przesłać do „${folder}”',
			'common.fileTree.noProject' => 'Najpierw dodaj projekt',
			'common.fileTree.noRecentFiles' => 'Brak plików zmienionych w ciągu ostatnich 7 dni',
			'common.fileTree.showAllFiles' => 'Pokaż wszystkie pliki',
			'common.fileTree.showAllFilesHint' => 'Wyłącz filtr ostatnich, aby zobaczyć wszystko.',
			'common.fileTree.showRecentOnly' => 'Pokaż pliki zmienione w ciągu ostatnich 7 dni',
			'common.fileTree.toast.copyFailed' => 'Nie udało się skopiować ścieżki',
			'common.fileTree.toast.fileCreated' => 'Plik utworzony pomyślnie',
			'common.fileTree.toast.fileDeleted' => 'Plik usunięty',
			'common.fileTree.toast.folderCreated' => 'Folder utworzony pomyślnie',
			'common.fileTree.toast.folderDeleted' => 'Folder usunięty',
			'common.fileTree.toast.folderDownloaded' => 'Folder pobrany jako ZIP',
			'common.fileTree.toast.pathCopied' => 'Ścieżka skopiowana do schowka',
			'common.fileTree.toast.renamed' => 'Zmieniono nazwę pomyślnie',
			'common.fileTree.uploadComplete' => 'Przesyłanie zakończone',
			'common.fileTree.uploadFailed' => 'Przesyłanie nie powiodło się',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Prześlij pliki (maks. ${size} każdy)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Prześlij pliki do „${folder}”',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => 'Przesłano ${uploaded} z ${total} ${label}',
			'common.fileTree.uploadingFiles' => 'Przesyłanie plików',
			'common.fileTree.validation.dotsOnly' => 'Nazwa pliku nie może składać się tylko z kropek',
			'common.fileTree.validation.emptyName' => 'Nazwa pliku nie może być pusta',
			'common.fileTree.validation.invalidChars' => 'Nazwa pliku zawiera nieprawidłowe znaki',
			'common.fileTree.validation.reserved' => 'Nazwa pliku jest zastrzeżona',
			'common.projectWizard.title' => 'Utwórz nowy projekt',
			'common.projectWizard.steps.type' => 'Typ',
			'common.projectWizard.steps.configure' => 'Konfiguracja',
			'common.projectWizard.steps.confirm' => 'Potwierdzenie',
			'common.projectWizard.step1.question' => 'Czy masz już obszar roboczy, czy chcesz utworzyć nowy?',
			'common.projectWizard.step1.existing.title' => 'Istniejący obszar roboczy',
			'common.projectWizard.step1.existing.description' => 'Mam już obszar roboczy na moim serwerze i chcę go tylko dodać do listy projektów',
			'common.projectWizard.step1.kNew.title' => 'Nowy obszar roboczy',
			'common.projectWizard.step1.kNew.description' => 'Utwórz nowy obszar roboczy, opcjonalnie sklonuj z repozytorium GitHub',
			'common.projectWizard.step2.existingPath' => 'Ścieżka obszaru roboczego',
			'common.projectWizard.step2.newPath' => 'Ścieżka obszaru roboczego',
			'common.projectWizard.step2.existingPlaceholder' => '/path/to/existing/workspace',
			'common.projectWizard.step2.newPlaceholder' => '/path/to/new/workspace',
			'common.projectWizard.step2.existingHelp' => 'Pełna ścieżka do istniejącego katalogu obszaru roboczego',
			'common.projectWizard.step2.newHelp' => 'Pełna ścieżka do katalogu obszaru roboczego',
			'common.projectWizard.step2.githubUrl' => 'Adres URL GitHub (opcjonalnie)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => 'Opcjonalnie: podaj adres URL GitHub, aby sklonować repozytorium',
			'common.projectWizard.step2.githubAuth' => 'Uwierzytelnianie GitHub (opcjonalnie)',
			'common.projectWizard.step2.githubAuthHelp' => 'Wymagane tylko w przypadku prywatnych repozytoriów. Repozytoria publiczne można klonować bez uwierzytelniania.',
			'common.projectWizard.step2.loadingTokens' => 'Ładowanie zapisanych tokenów...',
			'common.projectWizard.step2.storedToken' => 'Zapisany token',
			'common.projectWizard.step2.newToken' => 'Nowy token',
			'common.projectWizard.step2.nonePublic' => 'Brak (publiczne)',
			'common.projectWizard.step2.selectToken' => 'Wybierz token',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Wybierz token --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Ten token zostanie użyty tylko do tej operacji',
			_ => null,
		} ?? switch (path) {
			'common.projectWizard.step2.publicRepoInfo' => 'Repozytoria publiczne nie wymagają uwierzytelniania. Możesz pominąć podawanie tokenu, jeśli klonujesz publiczne repozytorium.',
			'common.projectWizard.step2.noTokensHelp' => 'Brak zapisanych tokenów. Możesz dodać tokeny w Ustawienia → Klucze API, aby łatwiej używać ich ponownie.',
			'common.projectWizard.step2.optionalTokenPublic' => 'Token GitHub (opcjonalny dla repozytoriów publicznych)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (pozostaw puste dla repozytoriów publicznych)',
			'common.projectWizard.step3.reviewConfig' => 'Sprawdź swoją konfigurację',
			'common.projectWizard.step3.existingWorkspace' => 'Istniejący obszar roboczy',
			'common.projectWizard.step3.newWorkspace' => 'Nowy obszar roboczy',
			'common.projectWizard.step3.path' => 'Ścieżka:',
			'common.projectWizard.step3.cloneFrom' => 'Klonuj z:',
			'common.projectWizard.step3.authentication' => 'Uwierzytelnianie:',
			'common.projectWizard.step3.usingStoredToken' => 'Używanie zapisanego tokenu:',
			'common.projectWizard.step3.usingProvidedToken' => 'Używanie podanego tokenu',
			'common.projectWizard.step3.noAuthentication' => 'Bez uwierzytelniania',
			'common.projectWizard.step3.sshKey' => 'Klucz SSH',
			'common.projectWizard.step3.existingInfo' => 'Obszar roboczy zostanie dodany do Twojej listy projektów i będzie dostępny dla sesji Claude/Cursor.',
			'common.projectWizard.step3.newWithClone' => 'Repozytorium zostanie sklonowane z tego folderu.',
			'common.projectWizard.step3.newEmpty' => 'Obszar roboczy zostanie dodany do Twojej listy projektów i będzie dostępny dla sesji Claude/Cursor.',
			'common.projectWizard.step3.cloningRepository' => 'Klonowanie repozytorium...',
			'common.projectWizard.buttons.cancel' => 'Anuluj',
			'common.projectWizard.buttons.back' => 'Wstecz',
			'common.projectWizard.buttons.next' => 'Dalej',
			'common.projectWizard.buttons.createProject' => 'Utwórz projekt',
			'common.projectWizard.buttons.creating' => 'Tworzenie...',
			'common.projectWizard.buttons.cloning' => 'Klonowanie...',
			'common.projectWizard.errors.selectType' => 'Wybierz, czy masz istniejący obszar roboczy, czy chcesz utworzyć nowy',
			'common.projectWizard.errors.providePath' => 'Podaj ścieżkę obszaru roboczego',
			'common.projectWizard.errors.failedToCreate' => 'Nie udało się utworzyć obszaru roboczego',
			'common.projectWizard.errors.failedToCreateFolder' => 'Nie udało się utworzyć folderu',
			'common.notifications.genericTool' => 'narzędzie',
			'common.notifications.codes.generic.info.title' => 'Powiadomienie',
			'common.notifications.codes.permission.required.title' => 'Wymagana akcja',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} czeka na Twoją decyzję.',
			'common.notifications.codes.run.stopped.title' => 'Uruchomienie zatrzymane',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Powód: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Uruchomienie nie powiodło się',
			'common.notifications.codes.agent.notification.title' => 'Powiadomienie agenta',
			'common.versionUpdate.title' => 'Dostępna aktualizacja',
			'common.versionUpdate.newVersionReady' => 'Nowa wersja jest gotowa',
			'common.versionUpdate.currentVersion' => 'Aktualna wersja',
			'common.versionUpdate.latestVersion' => 'Najnowsza wersja',
			'common.versionUpdate.whatsNew' => 'Co nowego:',
			'common.versionUpdate.viewFullRelease' => 'Zobacz pełne wydanie',
			'common.versionUpdate.updateProgress' => 'Postęp aktualizacji:',
			'common.versionUpdate.manualUpgrade' => 'Ręczna aktualizacja:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Albo kliknij "Zaktualizuj teraz", aby przeprowadzić aktualizację automatycznie.',
			'common.versionUpdate.updateCompleted' => 'Aktualizacja zakończona pomyślnie!',
			'common.versionUpdate.restartServer' => 'Uruchom ponownie serwer, aby zastosować zmiany.',
			'common.versionUpdate.updateFailed' => 'Aktualizacja nie powiodła się',
			'common.versionUpdate.buttons.close' => 'Zamknij',
			'common.versionUpdate.buttons.later' => 'Później',
			'common.versionUpdate.buttons.copyCommand' => 'Kopiuj polecenie',
			'common.versionUpdate.buttons.updateNow' => 'Zaktualizuj teraz',
			'common.versionUpdate.buttons.updating' => 'Aktualizowanie...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Zamknij okno aktualizacji wersji',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Pokaż panel boczny',
			'common.versionUpdate.ariaLabels.settings' => 'Ustawienia',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Dostępna aktualizacja',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Zamknij panel boczny',
			'common.actions.cancel' => 'Anuluj',
			'common.actions.retry' => 'Spróbuj ponownie',
			'common.actions.save' => 'Zapisz',
			'common.browserPane.address' => 'Adres',
			'common.browserPane.back' => 'Wstecz',
			'common.browserPane.connecting' => 'Łączenie z przeglądarką…',
			'common.browserPane.connectionFailed' => 'Połączenie z przeglądarką nie powiodło się.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => 'Nie można załadować ${url}',
			'common.browserPane.disconnected' => 'Widok przeglądarki rozłączony',
			'common.browserPane.enterUrl' => 'Wpisz adres URL',
			'common.browserPane.forward' => 'Dalej',
			'common.browserPane.invalidUrl' => 'Wpisz prawidłowy adres http(s)',
			'common.browserPane.noAuthToken' => 'Brak tokenu uwierzytelniającego.',
			'common.browserPane.openExternal' => 'Otwórz w przeglądarce systemowej',
			'common.browserPane.reload' => 'Odśwież',
			'common.browserPane.retry' => 'Ponów',
			'common.browserPane.stop' => 'Zatrzymaj',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} aktywne',
			'common.browserUse.cancel' => 'Anuluj',
			'common.browserUse.close' => 'Zamknij',
			'common.browserUse.delete' => 'Usuń',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} zostanie trwale usunięte.',
			'common.browserUse.deleteSession' => 'Usuń sesję',
			'common.browserUse.deleteTitle' => 'Usunąć sesję przeglądarki?',
			'common.browserUse.empty.descDisabled' => 'Włącz Browser w ustawieniach, aby agenty mogły otwierać monitorowane sesje przeglądarki.',
			'common.browserUse.empty.descEnabled' => 'Sesje przeglądarki agenta pojawiają się tutaj, gdy zadanie AI korzysta z Browser.',
			'common.browserUse.empty.titleDisabled' => 'Browser jest wyłączony',
			'common.browserUse.empty.titleEnabled' => 'Brak sesji przeglądarki',
			'common.browserUse.emptyStatus' => 'pusta',
			'common.browserUse.errors.actionFailed' => 'Akcja przeglądarki nie powiodła się',
			'common.browserUse.errors.loadFailed' => 'Nie udało się załadować Browser',
			'common.browserUse.fullscreen' => 'Pełny ekran',
			'common.browserUse.installRuntime' => 'Zainstaluj środowisko',
			'common.browserUse.installing' => 'Instalowanie...',
			'common.browserUse.lastAction' => 'Ostatnia akcja',
			'common.browserUse.nextSnapshot' => 'Kolejny zrzut ekranu przeglądarki agenta pojawi się tutaj.',
			'common.browserUse.noPageLoaded' => 'Nie załadowano strony',
			'common.browserUse.noSessions' => 'Brak sesji przeglądarki agentów.',
			'common.browserUse.none' => 'Brak',
			'common.browserUse.openSettings' => 'Otwórz ustawienia Browser',
			'common.browserUse.profile' => 'Profil',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Użyj Browser, aby sprawdzić proces płatności i zgłosić wszelkie uszkodzone elementy UI.',
			'common.browserUse.prompts.prompt2' => 'Otwórz <url> w Browser, wchodź w interakcję ze stroną i podsumuj, co zmieniło się po każdym kroku.',
			'common.browserUse.refresh' => 'Odśwież sesje przeglądarki',
			'common.browserUse.relative.daysAgo' => ' d temu',
			'common.browserUse.relative.hoursAgo' => ' godz. temu',
			'common.browserUse.relative.justNow' => 'Przed chwilą',
			'common.browserUse.relative.minutesAgo' => ' min temu',
			'common.browserUse.relative.never' => 'Nigdy',
			'common.browserUse.relative.secondsAgo' => ' s temu',
			'common.browserUse.relative.unknown' => 'Nieznane',
			'common.browserUse.runtime.disabled' => 'Wyłączony',
			'common.browserUse.runtime.installing' => 'Instalowanie',
			'common.browserUse.runtime.ready' => 'Gotowy',
			'common.browserUse.runtime.setupRequired' => 'Wymagana konfiguracja',
			'common.browserUse.runtimeSetup' => 'Wymagana konfiguracja środowiska',
			'common.browserUse.selected' => 'Wybrana',
			'common.browserUse.sessionFallback' => 'Sesja przeglądarki',
			'common.browserUse.sessionScreenshot' => 'Zrzut ekranu sesji przeglądarki',
			'common.browserUse.sessions' => 'Sesje',
			'common.browserUse.status' => 'Status',
			'common.browserUse.stop' => 'Zatrzymaj',
			'common.browserUse.stopSession' => 'Zatrzymaj sesję',
			'common.browserUse.subtitle' => 'Monitoruj sesje przeglądarki otwierane przez agentów AI.',
			'common.browserUse.temporary' => 'Tymczasowy',
			'common.browserUse.thisSession' => 'Ta sesja',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => 'łącznie ${count}',
			'common.browserUse.updated' => ({required Object time}) => 'Zaktualizowano ${time}',
			'common.browserUse.waiting' => 'Oczekiwanie',
			'common.browserUse.waitingForScreenshot' => 'Oczekiwanie na zrzut ekranu',
			'common.commandPalette.backToAll' => 'Wróć do wszystkich',
			'common.commandPalette.backspaceHint' => 'Backspace, aby wrócić',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Przeglądaj wszystkie gałęzie (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Przeglądaj wszystkie commity (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Przeglądaj wszystkie pliki (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Przeglądaj wszystkie sesje (${count})',
			'common.commandPalette.compare.costNote' => 'Koszt jest szacowany po stronie klienta na podstawie opublikowanych stawek za token; nieznane modele pokazują „—”.',
			'common.commandPalette.compare.estCost' => 'Szac. koszt',
			'common.commandPalette.compare.inputOutput' => 'Wejście / Wyjście',
			'common.commandPalette.compare.model' => 'Model',
			'common.commandPalette.compare.na' => 'N/D',
			'common.commandPalette.compare.openSplit' => 'Otwórz w widoku podzielonym',
			'common.commandPalette.compare.provider' => 'Dostawca',
			'common.commandPalette.compare.selectSession' => 'Wybierz sesję…',
			'common.commandPalette.compare.tokensUsed' => 'Użyte tokeny',
			'common.commandPalette.groups.actions' => 'Akcje',
			'common.commandPalette.groups.branches' => 'Gałęzie',
			'common.commandPalette.groups.commits' => 'Commity',
			'common.commandPalette.groups.files' => 'Pliki',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Nawigacja',
			'common.commandPalette.groups.sessions' => 'Sesje',
			'common.commandPalette.groups.settings' => 'Ustawienia',
			'common.commandPalette.hints.close' => 'Zamknij',
			'common.commandPalette.hints.navigate' => 'Nawiguj',
			'common.commandPalette.hints.select' => 'Wybierz',
			'common.commandPalette.hints.togglePalette' => 'Przełącz paletę',
			'common.commandPalette.items.compareSessions' => 'Porównaj sesje',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Otwórz ustawienia',
			'common.commandPalette.items.selectProjectFirst' => 'Najpierw wybierz projekt',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Ustawienia: ${label}',
			'common.commandPalette.items.startNewChat' => 'Rozpocznij nowy czat',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Przełącz na: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Przełącz motyw',
			'common.commandPalette.items.tokensAndCost' => 'tokeny i koszt',
			'common.commandPalette.nav.board' => 'Przejdź do Tablicy agentów',
			'common.commandPalette.nav.chat' => 'Przejdź do Czatu',
			'common.commandPalette.nav.files' => 'Przejdź do Plików',
			'common.commandPalette.nav.git' => 'Przejdź do Git',
			'common.commandPalette.nav.sourceControl' => 'Przejdź do Kontroli źródła',
			'common.commandPalette.nav.tasks' => 'Przejdź do Zadań',
			'common.commandPalette.nav.usage' => 'Przejdź do Limitów i zużycia',
			'common.commandPalette.noResults' => 'Brak wyników.',
			'common.commandPalette.pages.actions' => 'Akcje',
			'common.commandPalette.pages.branches' => 'Gałęzie',
			'common.commandPalette.pages.commits' => 'Commity',
			'common.commandPalette.pages.compare' => 'Porównanie',
			'common.commandPalette.pages.files' => 'Pliki',
			'common.commandPalette.pages.sessions' => 'Sesje',
			'common.commandPalette.placeholder' => 'Wpisz, aby wyszukać cokolwiek…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => 'Szukaj: ${page}…',
			'common.commandPalette.title' => 'Paleta poleceń',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} do przodu',
			'common.gitPanel.aheadLabel' => 'do przodu',
			'common.gitPanel.aiSuggest' => 'Sugestia AI',
			'common.gitPanel.aiSuggestTitle' => 'Wygeneruj wiadomość commita za pomocą AI',
			'common.gitPanel.all' => 'Wszystkie',
			'common.gitPanel.allStaged' => 'Wszystkie zmiany przygotowane',
			'common.gitPanel.behind' => ({required Object count}) => '${count} do tyłu',
			'common.gitPanel.behindLabel' => 'do tyłu',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'Usunąć gałąź „${branch}”? Zwykłe usunięcie powiedzie się tylko wtedy, gdy gałąź jest w pełni scalona. Tej operacji nie można cofnąć.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'Przełączyć na gałąź „${branch}”? Upewnij się, że nie masz niezatwierdzonych zmian.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} lokalne, ${remote} zdalne',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} lokalne',
			'common.gitPanel.branches.current' => 'bieżąca',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => 'Usuń ${branch}',
			'common.gitPanel.branches.emptyDesc' => 'Utwórz gałąź, aby rozpocząć pracę równoległą.',
			'common.gitPanel.branches.forceDelete' => 'Wymuś usunięcie',
			'common.gitPanel.branches.forceDeleteDesc' => 'Trwale usuwa gałąź, nawet jeśli zawiera commity niescalone gdzie indziej.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Wymuś usunięcie tej niescalonej gałęzi',
			'common.gitPanel.branches.local' => 'Lokalne',
			'common.gitPanel.branches.kNew' => 'Nowa gałąź',
			'common.gitPanel.branches.noMatch' => 'Żadna gałąź nie pasuje do wyszukiwania',
			'common.gitPanel.branches.none' => 'Nie znaleziono gałęzi',
			'common.gitPanel.branches.remote' => 'zdalne',
			'common.gitPanel.branches.kSwitch' => 'Przełącz',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Przełącz na ${branch}',
			'common.gitPanel.cancel' => 'Anuluj',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Zmiany (${count})',
			'common.gitPanel.clearSearch' => 'Wyczyść wyszukiwanie',
			'common.gitPanel.collapseDiff' => 'Zwiń diff',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Zatwierdź zmiany',
			'common.gitPanel.commitFiles' => ({required Object count}) => 'Zatwierdź ${count} plik(ów)',
			'common.gitPanel.committing' => 'Zatwierdzanie...',
			'common.gitPanel.confirmActions.commit' => 'Potwierdź',
			'common.gitPanel.confirmActions.delete' => 'Usuń',
			'common.gitPanel.confirmActions.deleteBranch' => 'Usuń',
			'common.gitPanel.confirmActions.discard' => 'Odrzuć',
			'common.gitPanel.confirmActions.publish' => 'Opublikuj',
			'common.gitPanel.confirmActions.pull' => 'Pull',
			'common.gitPanel.confirmActions.push' => 'Push',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Cofnij commit',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => 'Zatwierdzić ${count} plik(ów) z wiadomością: „${message}”?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'Usunąć nieśledzony plik „${file}”? Tej operacji nie można cofnąć.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => 'Odrzucić wszystkie zmiany w „${file}”? Tej operacji nie można cofnąć.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'Opublikować gałąź „${branch}” do ${remote}?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => 'Pobrać ${count} commit(ów) z ${remote}?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => 'Wysłać ${count} commit(ów) do ${remote}?',
			'common.gitPanel.confirmRevert' => 'Cofnąć ostatni lokalny commit? Usuwa commit, ale zachowuje jego zmiany jako przygotowane.',
			'common.gitPanel.confirmTitles.commit' => 'Potwierdź akcję',
			'common.gitPanel.confirmTitles.delete' => 'Usuń plik',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Usuń gałąź',
			'common.gitPanel.confirmTitles.discard' => 'Odrzuć zmiany',
			'common.gitPanel.confirmTitles.publish' => 'Opublikuj gałąź',
			'common.gitPanel.confirmTitles.pull' => 'Potwierdź pull',
			'common.gitPanel.confirmTitles.push' => 'Potwierdź push',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Cofnij lokalny commit',
			'common.gitPanel.createBranch' => 'Utwórz nową gałąź',
			'common.gitPanel.creating' => 'Tworzenie...',
			'common.gitPanel.delete' => 'Usuń',
			'common.gitPanel.deleteUntracked' => 'Usuń nieśledzony plik',
			'common.gitPanel.deselectAll' => 'Odznacz wszystko',
			'common.gitPanel.discard' => 'Odrzuć',
			'common.gitPanel.discardChanges' => 'Odrzuć zmiany',
			'common.gitPanel.dismiss' => 'Zamknij',
			'common.gitPanel.dismissError' => 'Zamknij błąd',
			'common.gitPanel.errors.createBranchFailed' => 'Tworzenie gałęzi nie powiodło się',
			'common.gitPanel.errors.createWorktreeFailed' => 'Nie udało się utworzyć worktree',
			'common.gitPanel.errors.deleteBranchFailed' => 'Usuwanie gałęzi nie powiodło się',
			'common.gitPanel.errors.fetchFailed' => 'Fetch nie powiódł się',
			'common.gitPanel.errors.initFailed' => 'Nie udało się zainicjować repozytorium',
			'common.gitPanel.errors.initialCommitFailed' => 'Nie udało się utworzyć pierwszego commita',
			'common.gitPanel.errors.mergeFailed' => 'Scalanie nie powiodło się',
			'common.gitPanel.errors.openWorktreeFailed' => 'Nie udało się otworzyć worktree',
			'common.gitPanel.errors.operationFailed' => 'Operacja git nie powiodła się',
			'common.gitPanel.errors.publishFailed' => 'Publikowanie nie powiodło się',
			'common.gitPanel.errors.pullFailed' => 'Pull nie powiódł się',
			'common.gitPanel.errors.pushFailed' => 'Push nie powiódł się',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Nie udało się usunąć worktree',
			'common.gitPanel.errors.stageFailed' => 'Przygotowanie nie powiodło się',
			'common.gitPanel.errors.stageHunksFailed' => 'Przygotowanie fragmentów nie powiodło się',
			'common.gitPanel.errors.switchFailed' => 'Przełączenie gałęzi nie powiodło się',
			'common.gitPanel.errors.unstageFailed' => 'Cofnięcie przygotowania nie powiodło się',
			'common.gitPanel.errors.unstageHunksFailed' => 'Cofnięcie przygotowania fragmentów nie powiodło się',
			'common.gitPanel.expandDiff' => 'Rozwiń diff',
			'common.gitPanel.fetch' => 'Fetch',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Pobierz z ${remote}',
			'common.gitPanel.fetching' => 'Pobieranie…',
			'common.gitPanel.filesSelected' => ({required Object count}) => 'Wybrano ${count} plik(ów)',
			'common.gitPanel.generating' => 'Generowanie...',
			'common.gitPanel.history.added' => 'Dodane',
			'common.gitPanel.history.author' => 'Autor',
			'common.gitPanel.history.changedFiles' => 'Zmienione pliki',
			'common.gitPanel.history.date' => 'Data',
			'common.gitPanel.history.empty' => 'Nie znaleziono commitów',
			'common.gitPanel.history.files' => 'Pliki',
			'common.gitPanel.history.removed' => 'Usunięte',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Usuń worktree i usuń jego gałąź po scaleniu',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Wyczyść po scaleniu',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} commit(ów)',
			'common.gitPanel.mergeWorktree.merge' => 'Scal',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Scal gałąź \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Wiadomość commita',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Połącz wszystkie ${commits} w jeden commit na ${branch}',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Scal commity (squash)',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squash i scal',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Scal squash gałęzi \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => 'Scal Worktree',
			'common.gitPanel.merging' => 'Scalanie...',
			'common.gitPanel.messagePlaceholder' => 'Wiadomość (Ctrl+Enter, aby zatwierdzić)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Spowoduje to utworzenie nowej gałęzi z bieżącej gałęzi (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Nazwa gałęzi',
			'common.gitPanel.newBranch.submit' => 'Utwórz gałąź',
			'common.gitPanel.newBranch.title' => 'Utwórz nową gałąź',
			'common.gitPanel.newWorktree.branchLabel' => 'Gałąź',
			'common.gitPanel.newWorktree.createFrom' => 'Utwórz z',
			'common.gitPanel.newWorktree.description' => 'Wyewidencjonuj gałąź w osobnym folderze i pracuj nad nią równolegle.',
			'common.gitPanel.newWorktree.existingBranch' => 'Istniejąca gałąź — zostanie wyewidencjonowana bez zmian.',
			'common.gitPanel.newWorktree.submit' => 'Utwórz worktree',
			'common.gitPanel.newWorktree.switchAfter' => 'Przełącz na worktree po utworzeniu',
			'common.gitPanel.newWorktree.title' => 'Nowy Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Zostanie utworzony w',
			'common.gitPanel.noChanges' => 'Nie wykryto zmian',
			'common.gitPanel.noChangesToCommit' => 'Brak zmian do zatwierdzenia',
			'common.gitPanel.noCommits.create' => 'Utwórz pierwszy commit',
			'common.gitPanel.noCommits.creating' => 'Tworzenie pierwszego commita...',
			'common.gitPanel.noCommits.description' => 'To repozytorium nie ma jeszcze żadnych commitów. Utwórz pierwszy commit, aby zacząć śledzić zmiany.',
			'common.gitPanel.noCommits.title' => 'Brak commitów',
			'common.gitPanel.noMatchingBranches' => 'Brak pasujących gałęzi',
			'common.gitPanel.noRepo.description' => 'Ten projekt nie jest jeszcze repozytorium git. Zainicjuj je, aby zacząć śledzić zmiany i korzystać z funkcji kontroli źródła.',
			'common.gitPanel.noRepo.init' => 'Uruchom git init',
			'common.gitPanel.noRepo.initializing' => 'Inicjowanie repozytorium...',
			'common.gitPanel.noRepo.title' => 'Brak repozytorium git',
			'common.gitPanel.noStagedFiles' => 'Brak przygotowanych plików',
			'common.gitPanel.none' => 'Brak',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Nic do wysłania do ${remote}',
			'common.gitPanel.openFile' => 'Kliknij, aby otworzyć plik',
			'common.gitPanel.publish' => 'Opublikuj',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => 'Opublikuj „${branch}” do ${remote}',
			'common.gitPanel.publishing' => 'Publikowanie…',
			'common.gitPanel.pull' => 'Pull',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Pull ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => 'Pobierz ${count} z ${remote}',
			'common.gitPanel.pulling' => 'Pobieranie…',
			'common.gitPanel.push' => 'Push',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Push ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => 'Wyślij ${count} do ${remote}',
			'common.gitPanel.pushing' => 'Wysyłanie…',
			'common.gitPanel.recentCommits' => 'Ostatnie commity',
			'common.gitPanel.refresh' => 'Odśwież status git',
			'common.gitPanel.remove' => 'Usuń',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Usuń także gałąź',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => 'Usunąć worktree dla ${branch}? Jego folder zostanie usunięty, a powiązany projekt zarchiwizowany — sesje czatu pozostaną do odzyskania.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'Ten worktree ma ${count} niezatwierdzonych zmian, które zostaną utracone.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Odrzuć niezatwierdzone zmiany',
			'common.gitPanel.removeWorktree.title' => 'Usuń Worktree',
			'common.gitPanel.removing' => 'Usuwanie...',
			'common.gitPanel.revertLatest' => 'Cofnij ostatni lokalny commit',
			'common.gitPanel.scroll' => 'Przewijanie',
			'common.gitPanel.searchBranches' => 'Szukaj gałęzi...',
			'common.gitPanel.selectAll' => 'Zaznacz wszystko',
			'common.gitPanel.selectProject' => 'Wybierz projekt, aby wyświetlić kontrolę źródła',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => 'Wybrano ${selected} z ${total} plików',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => 'Wybrano ${selected} z ${total}',
			'common.gitPanel.sideBySide' => 'Obok siebie',
			'common.gitPanel.stageAll' => 'Przygotuj wszystko',
			'common.gitPanel.stageHunk' => 'Przygotuj ten fragment',
			'common.gitPanel.staged' => ({required Object count}) => 'Przygotowane (${count})',
			'common.gitPanel.status.added' => 'Dodany',
			'common.gitPanel.status.deleted' => 'Usunięty',
			'common.gitPanel.status.modified' => 'Zmodyfikowany',
			'common.gitPanel.status.untracked' => 'Nieśledzony',
			'common.gitPanel.statusGuide' => 'Przewodnik po statusach plików',
			'common.gitPanel.switchScroll' => 'Przełącz na przewijanie poziome',
			'common.gitPanel.switchSplit' => 'Przełącz na widok obok siebie',
			'common.gitPanel.switchUnified' => 'Przełącz na widok ujednolicony',
			'common.gitPanel.switchWrap' => 'Przełącz na zawijanie tekstu',
			'common.gitPanel.unified' => 'Ujednolicony',
			'common.gitPanel.unstageAll' => 'Cofnij przygotowanie wszystkiego',
			'common.gitPanel.unstageHunk' => 'Cofnij przygotowanie tego fragmentu',
			'common.gitPanel.upToDate' => 'Aktualne',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'Aktualne z ${remote}',
			'common.gitPanel.viewAll' => 'Zobacz wszystkie',
			'common.gitPanel.viewsAria' => 'Widoki kontroli źródła',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} zmian(y)',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree(ów)',
			'common.gitPanel.worktrees.createFirst' => 'Utwórz pierwszy worktree',
			'common.gitPanel.worktrees.detached' => 'odczepiony',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'odczepiony @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'odczepiony HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'Worktree wyewidencjonowuje gałąź w osobnym folderze, dzięki czemu możesz prowadzić równoległe sesje czatu i scalić wyniki, gdy będą gotowe.',
			'common.gitPanel.worktrees.emptyTitle' => 'Pracuj nad gałęziami równolegle',
			'common.gitPanel.worktrees.locked' => 'zablokowany',
			'common.gitPanel.worktrees.mainWorktree' => 'główny worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => 'Scal ${branch} do gałęzi bazowej',
			'common.gitPanel.worktrees.kNew' => 'Nowy worktree',
			'common.gitPanel.worktrees.none' => 'Brak worktree',
			'common.gitPanel.worktrees.nothingToMerge' => 'Nic do scalenia — brak commitów przed gałęzią bazową',
			'common.gitPanel.worktrees.open' => 'Otwórz',
			'common.gitPanel.worktrees.refresh' => 'Odśwież worktree',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Usuń worktree dla ${branch}',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Przełącz na ${branch}',
			'common.gitPanel.wrap' => 'Zawijaj',
			'common.gitPanel.tabs.changes' => 'Zmiany',
			'common.gitPanel.tabs.history' => 'Commity',
			'common.gitPanel.tabs.branches' => 'Gałęzie',
			'common.gitPanel.tabs.worktrees' => 'Worktrees',
			'common.gitPanel.save' => 'Zapisz',
			'common.gitPanel.worktreeScripts.title' => 'Skrypty worktree',
			'common.gitPanel.worktreeScripts.setup' => 'Skrypt setup (po utworzeniu/otwarciu)',
			'common.gitPanel.worktreeScripts.run' => 'Uruchom dev server',
			'common.gitPanel.worktreeScripts.stop' => 'Zatrzymaj dev server',
			'common.gitPanel.worktreeScripts.runScript' => 'Skrypt run (dev server, na żądanie)',
			'common.gitPanel.worktreeScripts.runPort' => 'Port podglądu (opcjonalnie — wykrywany auto.)',
			'common.gitPanel.worktreeScripts.invalidPort' => 'Port musi być w zakresie 1–65535',
			'common.gitPanel.worktreeScripts.sourceProject' => 'Zapisane jako nadpisanie projektu',
			'common.gitPanel.worktreeScripts.sourceFile' => 'Z .ddagent/worktree.json — zapis utworzy nadpisanie projektu',
			'common.gitPanel.worktreeScripts.sourceNone' => 'Nic nie skonfigurowano',
			'common.gitPanel.worktreeScripts.saving' => 'Zapisywanie…',
			'common.gitPanel.worktreeScripts.setupRunning' => 'setup w toku',
			'common.gitPanel.worktreeScripts.setupFailed' => 'setup nieudany',
			'common.gitPanel.worktreeScripts.running' => 'działa',
			'common.gitPanel.worktreeScripts.openPreview' => 'Otwórz podgląd',
			'common.gitPanel.worktreeScripts.runExited' => ({required Object code}) => 'run zakończony (${code})',
			'common.sessions.renameSession' => 'Zmień nazwę sesji',
			'common.projects.newSession' => 'Nowa sesja',
			'common.sharedNotes.subtitle' => 'Współdzielona pamięć — dołączana do każdej sesji projektu',
			'common.sharedNotes.save' => 'Zapisz',
			'common.sharedNotes.saving' => 'Zapisywanie…',
			'common.sharedNotes.noProject' => 'Wybierz workspace, aby edytować współdzielony kontekst',
			'common.sharedNotes.placeholder' => '# Współdzielony kontekst\nKonwencje, decyzje i wskazówki dla wszystkich agentów…',
			'common.codeBlock.wrapLines' => 'Zawijaj wiersze',
			'common.codeBlock.noWrap' => 'Bez zawijania',
			'common.update.available' => ({required Object version}) => 'Dostępna aktualizacja · v${version}',
			'common.update.confirm' => ({required Object version}) => 'Zaktualizować do v${version}? Serwer zaktualizuje się i uruchomi ponownie — aktywne sesje zostaną przerwane.',
			'common.update.downloading' => 'Pobieranie i stosowanie aktualizacji…',
			'common.update.restarting' => 'Restartowanie serwera — to zajmie chwilę…',
			'common.update.done' => ({required Object version}) => 'Zaktualizowano do v${version}. Przeładuj aplikację, aby wczytać nowy pakiet.',
			'common.update.manualRestart' => 'Aktualizacja została zastosowana, ale serwer nie uruchomił się ponownie sam — uruchom go ręcznie, aby dokończyć.',
			'common.update.failed' => 'Aktualizacja nie powiodła się.',
			'common.update.failedTitle' => 'Aktualizacja nie powiodła się',
			'common.update.appConfirm' => ({required Object version}) => 'Zainstalować DDAgent v${version} na tym urządzeniu? Android za pierwszym razem zapyta o zgodę na instalowanie aplikacji z DDAgent.',
			'common.update.appPermission' => 'Zezwól DDAgent na „Instalowanie nieznanych aplikacji”, a potem dotknij ponownie Aktualizuj.',
			'common.update.chooseTitle' => 'Dostępne aktualizacje',
			'common.update.targetApp' => 'Ta aplikacja',
			'common.update.targetWeb' => 'Interfejs web',
			'common.update.targetServer' => 'Serwer',
			'common.update.updateApp' => 'Aktualizuj aplikację',
			'common.update.updateWeb' => 'Aktualizuj interfejs web',
			'common.update.updateServer' => 'Aktualizuj serwer',
			'common.update.webConfirm' => ({required Object version}) => 'Zaktualizować interfejs web do v${version}? Strona przeładuje się po aktualizacji.',
			'common.update.webDone' => ({required Object version}) => 'Interfejs web zaktualizowany do v${version} — przeładowuję…',
			'common.update.localServerConfirm' => ({required Object version}) => 'Zaktualizować lokalny serwer na tym urządzeniu do v${version}? Trwające sesje zostaną przerwane.',
			'common.update.localServerUpdating' => 'Pobieram i uruchamiam lokalny serwer…',
			'common.update.serverDone' => ({required Object version}) => 'Serwer działa w wersji v${version}.',
			'common.update.staged' => ({required Object version}) => 'Pobrano aktualizację v${version} — zrestartuj serwer, aby ją zainstalować.',
			'common.update.upToDate' => 'Serwer ma już najnowsze wydanie.',
			'common.update.webHostFailed' => ({required Object message}) => 'Serwer został zaktualizowany, ale jego interfejs web nie: ${message}',
			'common.appShell.panelActive' => ({required Object count}) => 'Panel · aktywne: ${count}',
			'common.errors.forbidden' => 'Brak dostępu',
			'settings.title' => 'Ustawienia',
			'settings.changelog.title' => 'Dziennik zmian',
			'settings.changelog.loading' => 'Ładowanie…',
			'settings.changelog.empty' => 'Brak wydań do wyświetlenia',
			'settings.changelog.current' => 'aktualna',
			'settings.changelog.kNew' => 'nowa',
			'settings.server.title' => 'Serwer',
			'settings.server.description' => 'Uruchamia ponownie proces DDAgent — przydatne po aktualizacji lub gdy coś się zawiesi.',
			'settings.server.restart' => 'Uruchom ponownie',
			'settings.server.restartConfirm' => 'Zrestartować serwer DDAgent? Aktywne sesje zostaną przerwane.',
			'settings.server.restarting' => 'Restartowanie… strona przeładuje się, gdy serwer wróci.',
			'settings.server.restartFailed' => 'Restart nie powiódł się',
			'settings.server.unsupported' => 'Restart jest dostępny tylko, gdy serwer działa pod menedżerem usług.',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'Restart serwera',
			'settings.server.restartRequesting' => 'Wysyłam do serwera polecenie restartu…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'Czekam, aż serwer wróci… (${seconds} s)',
			'settings.server.restartBack' => ({required Object version}) => 'Serwer działa — wersja ${version}.',
			'settings.server.restartReloading' => 'Przeładowuję stronę…',
			'settings.server.restartTimeout' => ({required Object seconds}) => 'Serwer nie wrócił w ciągu ${seconds} s. Sprawdź log usługi (/tmp/ddagent.log) albo zrestartuj go ręcznie.',
			'settings.updates.title' => 'Aktualizacje',
			'settings.updates.description' => 'Sprawdź GitHub w poszukiwaniu nowszej wersji desktopowej. Nowe wersje pobierają się automatycznie i instalują przy zamknięciu.',
			'settings.updates.descriptionMobile' => 'Sprawdź GitHub w poszukiwaniu nowszej wersji tej aplikacji. Aktualizację instaluje instalator systemowy urządzenia.',
			'settings.updates.descriptionServer' => 'Sprawdza na GitHubie, czy jest nowsze wydanie DDAgent. Podłączony serwer może zaktualizować się sam — trwające sesje zostaną przerwane na czas restartu.',
			'settings.updates.check' => 'Sprawdź aktualizacje',
			'settings.updates.checking' => 'Sprawdzanie…',
			'settings.updates.upToDate' => ({required Object version}) => 'Masz najnowszą wersję (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Znaleziono aktualizację v${version} — pobieranie w tle; zainstaluje się przy zamknięciu DDAgent.',
			'settings.updates.appAvailable' => ({required Object version}) => 'Dostępna aktualizacja aplikacji v${version} — dotknij Aktualizuj, aby zainstalować ją na tym urządzeniu.',
			'settings.updates.downloaded' => ({required Object version}) => 'Aktualizacja v${version} pobrana — zamknij i uruchom DDAgent ponownie, aby ją zainstalować.',
			'settings.updates.unavailable' => 'Sprawdzanie aktualizacji dostępne tylko w spakietowanej aplikacji desktopowej.',
			'settings.updates.error' => ({required Object message}) => 'Sprawdzanie aktualizacji nie powiodło się: ${message}',
			'settings.updates.errorGeneric' => 'Sprawdzanie aktualizacji nie powiodło się.',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · najnowsza v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — aktualna',
			'settings.updates.webNotHosted' => ({required Object version}) => 'Ten interfejs web jest hostowany osobno — podmień jego pliki na ddagent-flutter-web-v${version}.zip z wydania.',
			'settings.updates.serverCannotUpdate' => 'Ten serwer nie może zaktualizować się stąd — zainstaluj go ponownie przez install.sh albo z tarballa wydania.',
			'settings.tabs.account' => 'Konto',
			'settings.tabs.permissions' => 'Uprawnienia',
			'settings.tabs.mcpServers' => 'Serwery MCP',
			'settings.tabs.skills' => 'Umiejętności',
			'settings.tabs.appearance' => 'Wygląd',
			'settings.account.title' => 'Konto',
			'settings.account.language' => 'Język',
			'settings.account.languageLabel' => 'Język interfejsu',
			'settings.account.languageDescription' => 'Wybierz preferowany język interfejsu',
			'settings.account.username' => 'Nazwa użytkownika',
			'settings.account.email' => 'E-mail',
			'settings.account.profile' => 'Profil',
			'settings.account.changePassword' => 'Zmień hasło',
			'settings.mcp.title' => 'Serwery MCP',
			'settings.mcp.addServer' => 'Dodaj serwer',
			'settings.mcp.editServer' => 'Edytuj serwer',
			'settings.mcp.deleteServer' => 'Usuń serwer',
			'settings.mcp.serverName' => 'Nazwa serwera',
			'settings.mcp.serverType' => 'Typ serwera',
			'settings.mcp.config' => 'Konfiguracja',
			'settings.mcp.testConnection' => 'Testuj połączenie',
			'settings.mcp.status' => 'Stan',
			'settings.mcp.connected' => 'Połączono',
			'settings.mcp.disconnected' => 'Rozłączono',
			'settings.mcp.scope.label' => 'Zakres',
			'settings.mcp.scope.user' => 'Użytkownik',
			'settings.mcp.scope.project' => 'Projekt',
			'settings.appearance.title' => 'Wygląd',
			'settings.appearance.theme' => 'Motyw',
			'settings.appearance.codeEditor' => 'Edytor kodu',
			_ => null,
		} ?? switch (path) {
			'settings.appearance.editorTheme' => 'Motyw edytora',
			'settings.appearance.wordWrap' => 'Zawijanie wierszy',
			'settings.appearance.showMinimap' => 'Pokaż minimapę',
			'settings.appearance.lineNumbers' => 'Numery wierszy',
			'settings.appearance.fontSize' => 'Rozmiar czcionki',
			'settings.appearance.themeModes.system' => 'Systemowy',
			'settings.appearance.themeModes.light' => 'Jasny',
			'settings.appearance.themeModes.dark' => 'Ciemny',
			'settings.actions.saveChanges' => 'Zapisz zmiany',
			'settings.actions.resetToDefaults' => 'Przywróć ustawienia domyślne',
			'settings.actions.cancelChanges' => 'Anuluj zmiany',
			'settings.quickSettings.title' => 'Szybkie ustawienia',
			'settings.quickSettings.sections.appearance' => 'Wygląd',
			'settings.quickSettings.sections.toolDisplay' => 'Wyświetlanie narzędzi',
			'settings.quickSettings.sections.inputSettings' => 'Ustawienia wprowadzania',
			'settings.quickSettings.darkMode' => 'Tryb ciemny',
			'settings.quickSettings.showRawParameters' => 'Pokaż surowe parametry',
			'settings.quickSettings.showThinking' => 'Pokaż myślenie',
			'settings.quickSettings.sendByCtrlEnter' => 'Wysyłaj przez Ctrl+Enter',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Po włączeniu naciśnięcie Ctrl+Enter wyśle wiadomość zamiast samego Entera. Przydatne dla użytkowników IME, aby uniknąć przypadkowego wysłania.',
			'settings.quickSettings.dragHandle.dragging' => 'Przeciąganie uchwytu',
			'settings.quickSettings.dragHandle.closePanel' => 'Zamknij panel ustawień',
			'settings.quickSettings.dragHandle.openPanel' => 'Otwórz panel ustawień',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Przeciąganie...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Kliknij, aby przełączyć, przeciągnij, aby przenieść',
			'settings.quickSettings.sendWithCtrlEnter' => 'Wysyłaj przez Ctrl+Enter',
			'settings.quickSettings.enterSendsHint' => 'Gdy wyłączone, Enter wysyła wiadomość, a Shift+Enter wstawia nową linię.',
			'settings.terminalShortcuts.title' => 'Skróty terminala',
			'settings.terminalShortcuts.sectionKeys' => 'Klawisze',
			'settings.terminalShortcuts.sectionNavigation' => 'Nawigacja',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Strzałka w górę',
			'settings.terminalShortcuts.arrowDown' => 'Strzałka w dół',
			'settings.terminalShortcuts.scrollDown' => 'Przewiń w dół',
			'settings.terminalShortcuts.killTitle' => 'Zatrzymaj proces (SIGINT)',
			'settings.terminalShortcuts.handle.closePanel' => 'Zamknij panel skrótów',
			'settings.terminalShortcuts.handle.openPanel' => 'Otwórz panel skrótów',
			'settings.terminalShortcuts.paste' => 'Wklej',
			'settings.mainTabs.label' => 'Ustawienia',
			'settings.mainTabs.agents' => 'Agenci',
			'settings.mainTabs.orchestration' => 'Orkiestracja',
			'settings.mainTabs.miniOrchestration' => 'Mini-orkiestracja',
			'settings.mainTabs.appearance' => 'Wygląd',
			'settings.mainTabs.workspaces' => 'Obszary robocze',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API i tokeny',
			'settings.mainTabs.models' => 'Modele',
			'settings.mainTabs.tasks' => 'Zadania',
			'settings.mainTabs.browser' => 'Przeglądarka',
			'settings.mainTabs.tools' => 'Narzędzia',
			'settings.mainTabs.notifications' => 'Powiadomienia',
			'settings.mainTabs.about' => 'O aplikacji',
			'settings.mainTabs.quota' => 'Control Center',
			'settings.mainTabs.shortcuts' => 'Skróty klawiszowe',
			'settings.miniOrchestration.title' => 'Mini-orkiestracja',
			'settings.miniOrchestration.description' => 'Potok z dwoma modelami: model myślący (nie-flash) planuje, a wykonawca (flash) realizuje kroki.',
			'settings.miniOrchestration.loading' => 'Wczytywanie ustawień mini-orkiestracji…',
			'settings.miniOrchestration.loadError' => 'Nie udało się wczytać ustawień mini-orkiestracji.',
			'settings.miniOrchestration.enable.label' => 'Włącz mini-orkiestrację',
			'settings.miniOrchestration.enable.description' => 'Kieruj sesje Auto (mini) przez silnik dwóch ról zamiast pełnego orkiestratora.',
			'settings.miniOrchestration.thinker.title' => 'Myśliciel (nie-flash)',
			'settings.miniOrchestration.thinker.description' => 'Planuje, podejmuje decyzje, weryfikuje i pisze raport końcowy.',
			'settings.miniOrchestration.worker.title' => 'Wykonawca (flash)',
			'settings.miniOrchestration.worker.description' => 'Wykonuje każdy zaplanowany krok.',
			'settings.miniOrchestration.fields.provider' => 'Dostawca',
			'settings.miniOrchestration.fields.model' => 'Model',
			'settings.miniOrchestration.fields.modelPlaceholder' => 'Wybierz model',
			'settings.miniOrchestration.fields.tier' => 'Poziom',
			'settings.miniOrchestration.roles.title' => 'Model dla typu zadania',
			'settings.miniOrchestration.roles.description' => 'Który model (rola) obsługuje dany typ zadania.',
			'settings.miniOrchestration.planner.title' => 'Planista',
			'settings.miniOrchestration.planner.mode' => 'Tryb',
			'settings.miniOrchestration.planner.modes.auto' => 'Planuj modelem myślącym',
			'settings.miniOrchestration.planner.modes.off' => 'Pojedynczy krok',
			'settings.miniOrchestration.planner.requireConfirmLabel' => 'Potwierdź plan przed uruchomieniem',
			'settings.orchestration.title' => 'Orkiestracja',
			'settings.orchestration.description' => 'Kieruj zadania z czatu do różnych dostawców i modeli.',
			'settings.orchestration.loading' => 'Wczytywanie ustawień orkiestracji…',
			'settings.orchestration.loadError' => 'Nie udało się wczytać ustawień orkiestracji.',
			'settings.orchestration.retry' => 'Spróbuj ponownie',
			'settings.orchestration.enable.label' => 'Włącz orkiestrację',
			'settings.orchestration.enable.description' => 'Pozwól orkiestratorowi dobierać model do każdego kroku zamiast uruchamiać wszystko na jednym dostawcy.',
			'settings.orchestration.pool.title' => 'Pula kandydatów',
			'settings.orchestration.pool.description' => 'Modele, spośród których wybiera router — każdy przypisany do progu kosztu.',
			'settings.orchestration.pool.add' => 'Dodaj kandydata',
			'settings.orchestration.pool.empty' => 'Brak kandydatów — dodaj pierwszego, aby zacząć routing.',
			'settings.orchestration.pool.fields.label' => 'Nazwa',
			'settings.orchestration.pool.fields.labelPlaceholder' => 'np. SWE-2 Medium',
			'settings.orchestration.pool.fields.provider' => 'Dostawca',
			'settings.orchestration.pool.fields.model' => 'Model',
			'settings.orchestration.pool.fields.modelPlaceholder' => 'Wybierz model',
			'settings.orchestration.pool.fields.effort' => 'Effort',
			'settings.orchestration.pool.fields.effortDefault' => 'Domyślny dostawcy',
			'settings.orchestration.pool.fields.effortPlaceholder' => 'domyślny',
			'settings.orchestration.pool.fields.account' => 'Konto',
			'settings.orchestration.pool.fields.accountDefault' => 'Domyślne dostawcy',
			'settings.orchestration.pool.fields.redundantAccounts' => 'Konta zapasowe (redundancja)',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Brak innych kont dla tego dostawcy',
			'settings.orchestration.pool.fields.tier' => 'Próg kosztu',
			'settings.orchestration.pool.fields.remove' => 'Usuń kandydata',
			'settings.orchestration.pool.fields.moveUp' => 'Przesuń w górę',
			'settings.orchestration.pool.fields.moveDown' => 'Przesuń w dół',
			'settings.orchestration.tiers.free' => 'Darmowy',
			'settings.orchestration.tiers.cheap' => 'Tani',
			'settings.orchestration.tiers.mid' => 'Średni',
			'settings.orchestration.tiers.premium' => 'Premium',
			'settings.orchestration.rules.title' => 'Reguły routingu',
			'settings.orchestration.rules.description' => 'Uporządkowana lista kandydatów dla typu zadania — wygrywa pierwszy dostępny.',
			'settings.orchestration.rules.addCandidate' => 'Dodaj kandydata…',
			'settings.orchestration.rules.empty' => 'Brak kandydatów — ten typ zadania nie ma dokąd trafić.',
			'settings.orchestration.rules.missing' => '(usunięty)',
			'settings.orchestration.rules.remove' => 'Usuń kandydata',
			'settings.orchestration.rules.taskTypes.plan' => 'Planowanie',
			'settings.orchestration.rules.taskTypes.quick' => 'Szybkie odpowiedzi',
			'settings.orchestration.rules.taskTypes.research' => 'Research',
			'settings.orchestration.rules.taskTypes.docs' => 'Dokumentacja',
			'settings.orchestration.rules.taskTypes.code' => 'Kodowanie',
			'settings.orchestration.rules.taskTypes.codeHard' => 'Złożone kodowanie',
			'settings.orchestration.rules.taskTypes.test' => 'Testowanie',
			'settings.orchestration.rules.taskTypes.review' => 'Review',
			'settings.orchestration.rules.taskTypes.report' => 'Raport',
			'settings.orchestration.planner.title' => 'Planista',
			'settings.orchestration.planner.description' => 'Jak zapytanie jest dzielone na kierowane kroki.',
			'settings.orchestration.planner.modeLabel' => 'Tryb planowania',
			'settings.orchestration.planner.modes.auto' => 'Auto (LLM)',
			'settings.orchestration.planner.modes.template' => 'Szablony',
			'settings.orchestration.planner.modes.off' => 'Wyłączony',
			'settings.orchestration.planner.modeHints.auto' => 'Model planisty rozbija każde zapytanie na typowane kroki.',
			'settings.orchestration.planner.modeHints.template' => 'Zapytania przechodzą przez ustalony pipeline wybrany poniżej.',
			'settings.orchestration.planner.modeHints.off' => 'Bez planowania — całe zapytanie trafia jako pojedynczy krok.',
			'settings.orchestration.planner.candidateLabel' => 'Model planisty',
			'settings.orchestration.planner.candidateDescription' => 'Kandydat z puli używany do generowania planu i klasyfikacji.',
			'settings.orchestration.planner.candidatePlaceholder' => 'Wybierz kandydata z puli',
			'settings.orchestration.planner.templates.title' => 'Szablony pipeline\'ów',
			'settings.orchestration.planner.templates.add' => 'Dodaj szablon',
			'settings.orchestration.planner.templates.namePlaceholder' => 'Nazwa szablonu',
			'settings.orchestration.planner.templates.addStep' => 'Dodaj krok…',
			'settings.orchestration.planner.templates.remove' => 'Usuń szablon',
			'settings.orchestration.planner.templates.removeStep' => 'Usuń krok',
			'settings.orchestration.planner.templates.empty' => 'Brak szablonów.',
			'settings.orchestration.planner.templates.emptySteps' => 'Brak kroków — dodaj pierwszy poniżej.',
			'settings.orchestration.planner.requireConfirm' => 'Potwierdź plan przed startem',
			'settings.orchestration.planner.requireConfirmDescription' => 'Wstrzymaj wykonanie po zaplanowaniu — kroki można edytować/wyłączać na karcie planu.',
			'settings.orchestration.planner.checkpointLabel' => 'Autonomia',
			'settings.orchestration.planner.checkpointModes.off' => 'Autonomicznie',
			'settings.orchestration.planner.checkpointModes.perStep' => 'Co krok',
			'settings.orchestration.planner.checkpointModes.everyN' => 'Co N kroków',
			'settings.orchestration.planner.checkpointHints.off' => 'Decyzje nadzorcy są wykonywane bez pytania (tryb auto).',
			'settings.orchestration.planner.checkpointHints.perStep' => 'Pytaj o zgodę przed każdą proponowaną partią kroków.',
			'settings.orchestration.planner.checkpointHints.everyN' => 'Pytaj o zgodę po każdych N ukończonych krokach.',
			'settings.orchestration.planner.checkpointIntervalLabel' => 'Liczba kroków między punktami kontrolnymi (1–50)',
			'settings.orchestration.execution.title' => 'Limity wykonania',
			'settings.orchestration.execution.description' => 'Ograniczenia równoległości i pętli naprawczych.',
			'settings.orchestration.execution.maxParallel' => 'Maks. równoległe kroki',
			'settings.orchestration.execution.maxParallelDescription' => 'Ile podzadań może działać jednocześnie (1–8).',
			'settings.orchestration.execution.maxFixLoops' => 'Maks. pętli naprawczych',
			'settings.orchestration.execution.maxFixLoopsDescription' => 'Ponowienia gdy krok nie przejdzie weryfikacji (0–5).',
			'settings.orchestration.execution.onNoCandidate' => 'Gdy brak dostępnego kandydata',
			'settings.orchestration.execution.onNoCandidateDescription' => 'Pytaj przed fallbackiem albo pomiń krok.',
			'settings.orchestration.execution.onNoCandidateOptions.ask' => 'Pytaj',
			'settings.orchestration.execution.onNoCandidateOptions.skip' => 'Pomiń krok',
			'settings.orchestration.execution.useWorktree' => 'Izolowany worktree',
			'settings.orchestration.execution.useWorktreeDescription' => 'Uruchamiaj wszystkie wydelegowane kroki w jednym wspólnym worktree git zamiast w katalogu projektu.',
			'settings.orchestration.execution.maxSupervisorIterations' => 'Maks. iteracji nadzorcy',
			'settings.orchestration.execution.maxSupervisorIterationsDescription' => 'Limit rund decyzyjnych nadzorcy w trybie auto (1–100); po jego osiągnięciu uruchomienie kończy się raportem częściowym.',
			'settings.orchestration.execution.maxAttempts' => 'Maks. prób na krok',
			'settings.orchestration.execution.maxAttemptsDescription' => 'Łączna pula prób dla jednego kroku, licząc wszystkie ścieżki i ponowienia (1–50).',
			'settings.orchestration.execution.stepTimeoutMs' => 'Limit czasu kroku (ms)',
			'settings.orchestration.execution.stepTimeoutMsDescription' => 'Limit czasu podrzędnego uruchomienia dla każdej próby w milisekundach; 0 wyłącza.',
			'settings.orchestration.execution.runTimeoutMs' => 'Limit czasu uruchomienia (ms)',
			'settings.orchestration.execution.runTimeoutMsDescription' => 'Globalny limit czasu wykonania planu w milisekundach; 0 wyłącza.',
			'settings.orchestration.execution.retryBackoffBaseMs' => 'Bazowe opóźnienie ponowień (ms)',
			'settings.orchestration.execution.retryBackoffBaseMsDescription' => 'Podstawa wykładniczego opóźnienia między ponowieniami na tej samej ścieżce (pełny jitter).',
			'settings.orchestration.execution.retryBudgetTitle' => 'Pula ponowień według klasy błędu',
			'settings.orchestration.execution.retryBudgetDescription' => 'Liczba ponowień na tej samej ścieżce przed przełączeniem awaryjnym lub schłodzeniem (0–5).',
			'settings.orchestration.execution.retryClasses.rateLimit' => 'Limit zapytań',
			'settings.orchestration.execution.retryClasses.quota' => 'Limit wykorzystania',
			'settings.orchestration.execution.retryClasses.auth' => 'Uwierzytelnianie',
			'settings.orchestration.execution.retryClasses.timeout' => 'Przekroczenie czasu',
			'settings.orchestration.execution.retryClasses.transient' => 'Błąd przejściowy',
			'settings.orchestration.save.unsaved' => 'Niezapisane zmiany',
			'settings.orchestration.save.save' => 'Zapisz',
			'settings.orchestration.save.saving' => 'Zapisywanie…',
			'settings.orchestration.save.saved' => 'Zapisano',
			'settings.orchestration.save.discard' => 'Odrzuć',
			'settings.orchestration.save.error' => 'Zapis nie powiódł się',
			'settings.orchestration.save.emptyPool' => 'Dodaj przynajmniej jednego kandydata przed zapisem.',
			'settings.notifications.title' => 'Powiadomienia',
			'settings.notifications.description' => 'Kontroluj, które zdarzenia powiadomień otrzymujesz.',
			'settings.notifications.webPush.title' => 'Powiadamiaj tę przeglądarkę',
			'settings.notifications.webPush.enable' => 'Włącz powiadomienia',
			'settings.notifications.webPush.disable' => 'Wyłącz powiadomienia',
			'settings.notifications.webPush.enabled' => 'Powiadomienia są włączone dla tej przeglądarki',
			'settings.notifications.webPush.loading' => 'Aktualizowanie...',
			'settings.notifications.webPush.unsupported' => 'Powiadomienia push nie są obsługiwane w tej przeglądarce.',
			'settings.notifications.webPush.denied' => 'Powiadomienia push są zablokowane. Zezwól na nie w ustawieniach przeglądarki.',
			'settings.notifications.webPush.iosHint' => 'Na iPhone/iPadzie powiadomienia działają dopiero po dodaniu DDAgent do ekranu głównego (Udostępnij → Dodaj do ekranu głównego) i włączeniu ich w zainstalowanej aplikacji.',
			'settings.notifications.webPush.test' => 'Wyślij powiadomienie testowe',
			'settings.notifications.webPush.testNoSubscription' => 'Żadne urządzenie nie jest zasubskrybowane. Najpierw dotknij „Włącz” na telefonie.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Wysłano do ${count} urządzeń. Jeśli nic się nie pojawiło na telefonie, dodaj DDAgent do ekranu głównego (iOS tego wymaga).',
			'settings.notifications.webPush.testNotDelivered' => 'Nie udało się dotrzeć do żadnego urządzenia. Upewnij się, że aplikacja działa, a powiadomienia są włączone.',
			'settings.notifications.device.title' => 'Powiadamiaj to urządzenie',
			'settings.notifications.device.enabled' => 'Powiadomienia są włączone dla tego urządzenia',
			'settings.notifications.desktop.title' => 'Powiadamiaj tę aplikację desktopową',
			'settings.notifications.desktop.enable' => 'Włącz powiadomienia',
			'settings.notifications.desktop.disable' => 'Wyłącz powiadomienia',
			'settings.notifications.desktop.enabled' => 'Powiadomienia są włączone dla tej aplikacji desktopowej',
			'settings.notifications.desktop.unsupported' => 'Powiadomienia desktopowe nie są obsługiwane w tym systemie.',
			'settings.notifications.sound.title' => 'Dźwięk',
			'settings.notifications.sound.description' => 'Odtwarzaj krótki sygnał, gdy uruchomienie czatu się zakończy lub gdy narzędzie wymaga zatwierdzenia.',
			'settings.notifications.sound.enabled' => 'Włączone',
			'settings.notifications.sound.test' => 'Test dźwięku',
			'settings.notifications.events.title' => 'Typy zdarzeń',
			'settings.notifications.events.actionRequired' => 'Wymagana akcja',
			'settings.notifications.events.stop' => 'Uruchomienie zatrzymane',
			'settings.notifications.events.error' => 'Uruchomienie nie powiodło się',
			'settings.notifications.messaging.title' => 'Zatwierdzanie przez komunikatory',
			'settings.notifications.messaging.description' => 'Zatwierdzaj lub odrzucaj prośby agentów o uprawnienia z poziomu Telegrama i otrzymuj powiadomienia o uruchomieniach na Discordzie.',
			'settings.notifications.messaging.enabled' => 'Włączone',
			'settings.notifications.messaging.save' => 'Zapisz',
			'settings.notifications.messaging.test' => 'Test',
			'settings.notifications.messaging.pair' => 'Sparuj',
			'settings.notifications.messaging.telegramToken' => 'Token bota od @BotFather (123456:ABC…)',
			'settings.notifications.messaging.telegramHint' => 'Wyślij dowolną wiadomość do swojego bota, a następnie sparuj czat poniżej.',
			'settings.notifications.messaging.discordWebhook' => 'https://discord.com/api/webhooks/…',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.unpair' => 'Rozłącz parę',
			'settings.appearanceSettings.darkMode.label' => 'Tryb ciemny',
			'settings.appearanceSettings.darkMode.description' => 'Przełączaj między motywem jasnym i ciemnym',
			'settings.appearanceSettings.codeEditor.title' => 'Edytor kodu',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Motyw edytora',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Domyślny motyw edytora kodu',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Zawijanie wierszy',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Domyślnie włącz zawijanie wierszy w edytorze',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Pokaż minimapę',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Wyświetl minimapę ułatwiającą nawigację w widoku różnic',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Pokaż numery wierszy',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Wyświetlaj numery wierszy w edytorze',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Rozmiar czcionki',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Rozmiar czcionki edytora w pikselach',
			'settings.appearanceSettings.terminal.title' => 'Terminal',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Fokus podąża za kursorem',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Po najechaniu myszą terminal przejmuje fokus i można w nim pisać',
			'settings.mcpForm.title.add' => 'Dodaj serwer MCP',
			'settings.mcpForm.title.edit' => 'Edytuj serwer MCP',
			'settings.mcpForm.importMode.form' => 'Formularz',
			'settings.mcpForm.importMode.json' => 'Import JSON',
			'settings.mcpForm.scope.label' => 'Zakres',
			'settings.mcpForm.scope.userGlobal' => 'Użytkownik (globalny)',
			'settings.mcpForm.scope.projectLocal' => 'Projekt (lokalny)',
			'settings.mcpForm.scope.userDescription' => 'Zakres użytkownika: dostępny we wszystkich projektach na Twojej maszynie',
			'settings.mcpForm.scope.projectDescription' => 'Zakres lokalny: dostępny tylko w wybranym projekcie',
			'settings.mcpForm.scope.cannotChange' => 'Zakresu nie można zmienić podczas edycji istniejącego serwera',
			'settings.mcpForm.fields.serverName' => 'Nazwa serwera',
			'settings.mcpForm.fields.transportType' => 'Typ transportu',
			'settings.mcpForm.fields.command' => 'Polecenie',
			'settings.mcpForm.fields.arguments' => 'Argumenty (po jednym w wierszu)',
			'settings.mcpForm.fields.jsonConfig' => 'Konfiguracja JSON',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Zmienne środowiskowe (KLUCZ=wartość, po jednej w wierszu)',
			'settings.mcpForm.fields.headers' => 'Nagłówki (KLUCZ=wartość, po jednym w wierszu)',
			'settings.mcpForm.fields.selectProject' => 'Wybierz projekt...',
			'settings.mcpForm.placeholders.serverName' => 'my-server',
			'settings.mcpForm.validation.missingType' => 'Brak wymaganego pola: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'Typ stdio wymaga pola command',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => 'Typ ${type} wymaga pola url',
			'settings.mcpForm.validation.invalidJson' => 'Nieprawidłowy format JSON',
			'settings.mcpForm.validation.jsonHelp' => 'Wklej konfigurację serwera MCP w formacie JSON. Przykładowe formaty:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Szczegóły konfiguracji (z ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Ścieżka: ${path}',
			'settings.mcpForm.actions.cancel' => 'Anuluj',
			'settings.mcpForm.actions.saving' => 'Zapisywanie...',
			'settings.mcpForm.actions.addServer' => 'Dodaj serwer',
			'settings.mcpForm.actions.updateServer' => 'Zaktualizuj serwer',
			'settings.saveStatus.success' => 'Ustawienia zapisano pomyślnie!',
			'settings.saveStatus.error' => 'Nie udało się zapisać ustawień',
			'settings.saveStatus.saving' => 'Zapisywanie...',
			'settings.footerActions.save' => 'Zapisz ustawienia',
			'settings.footerActions.cancel' => 'Anuluj',
			'settings.git.title' => 'Konfiguracja Git',
			'settings.git.description' => 'Skonfiguruj swoją tożsamość Git do commitów. Te ustawienia zostaną zastosowane globalnie przez git config --global',
			'settings.git.name.label' => 'Nazwa Git',
			'settings.git.name.help' => 'Twoja nazwa do commitów Git',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'E-mail Git',
			'settings.git.email.help' => 'Twój e-mail do commitów Git',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Zapisz konfigurację',
			'settings.git.actions.saving' => 'Zapisywanie...',
			'settings.git.status.success' => 'Zapisano pomyślnie',
			'settings.git.status.error' => 'Nie udało się zapisać',
			'settings.apiKeys.title' => 'Klucze API',
			'settings.apiKeys.description' => 'Generuj klucze API, aby uzyskiwać dostęp do zewnętrznego API z innych aplikacji.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ Zapisz swój klucz API',
			'settings.apiKeys.newKey.alertMessage' => 'To jedyny raz, gdy zobaczysz ten klucz. Przechowuj go w bezpiecznym miejscu.',
			'settings.apiKeys.newKey.iveSavedIt' => 'Zapisałem go',
			'settings.apiKeys.form.placeholder' => 'Nazwa klucza API (np. Serwer produkcyjny)',
			'settings.apiKeys.form.createButton' => 'Utwórz',
			'settings.apiKeys.form.cancelButton' => 'Anuluj',
			'settings.apiKeys.newButton' => 'Nowy klucz API',
			'settings.apiKeys.empty' => 'Nie utworzono jeszcze żadnych kluczy API.',
			'settings.apiKeys.list.created' => 'Utworzono:',
			'settings.apiKeys.list.lastUsed' => 'Ostatnio użyto:',
			'settings.apiKeys.confirmDelete' => 'Czy na pewno chcesz usunąć ten klucz API?',
			'settings.apiKeys.status.active' => 'Aktywny',
			'settings.apiKeys.status.inactive' => 'Nieaktywny',
			'settings.apiKeys.github.title' => 'Tokeny GitHub',
			'settings.apiKeys.github.description' => 'Dodaj osobiste tokeny dostępu GitHub, aby klonować prywatne repozytoria przez zewnętrzne API.',
			'settings.apiKeys.github.descriptionAlt' => 'Dodaj osobiste tokeny dostępu GitHub, aby klonować prywatne repozytoria. Możesz też przekazywać tokeny bezpośrednio w żądaniach API bez ich przechowywania.',
			'settings.apiKeys.github.addButton' => 'Dodaj token',
			'settings.apiKeys.github.form.namePlaceholder' => 'Nazwa tokenu (np. Repozytoria osobiste)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'Osobisty token dostępu GitHub (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Opis (opcjonalnie)',
			'settings.apiKeys.github.form.addButton' => 'Dodaj token',
			'settings.apiKeys.github.form.cancelButton' => 'Anuluj',
			'settings.apiKeys.github.form.howToCreate' => 'Jak utworzyć osobisty token dostępu GitHub →',
			'settings.apiKeys.github.form.showToken' => 'Pokaż token',
			'settings.apiKeys.github.form.hideToken' => 'Ukryj token',
			'settings.apiKeys.github.empty' => 'Nie dodano jeszcze żadnych tokenów GitHub.',
			'settings.apiKeys.github.added' => 'Dodano:',
			'settings.apiKeys.github.confirmDelete' => 'Czy na pewno chcesz usunąć ten token GitHub?',
			'settings.apiKeys.apiDocsLink' => 'Dokumentacja API',
			'settings.apiKeys.documentation.title' => 'Dokumentacja zewnętrznego API',
			'settings.apiKeys.documentation.description' => 'Dowiedz się, jak używać zewnętrznego API do uruchamiania sesji Claude/Cursor ze swoich aplikacji.',
			'settings.apiKeys.documentation.viewLink' => 'Zobacz dokumentację API →',
			'settings.apiKeys.loading' => 'Ładowanie...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Dostępna aktualizacja: v${version}',
			'settings.tasks.checking' => 'Sprawdzanie instalacji TaskMaster...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI nie jest zainstalowany',
			'settings.tasks.notInstalled.description' => 'Do korzystania z funkcji zarządzania zadaniami wymagany jest TaskMaster CLI. Zainstaluj go, aby rozpocząć:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'Zobacz na GitHub',
			'settings.tasks.notInstalled.afterInstallation' => 'Po instalacji:',
			'settings.tasks.notInstalled.steps.restart' => 'Uruchom tę aplikację ponownie',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'Funkcje TaskMaster staną się automatycznie dostępne',
			'settings.tasks.notInstalled.steps.initCommand' => 'Użyj task-master init w katalogu swojego projektu',
			'settings.tasks.settings.enableLabel' => 'Włącz integrację z TaskMaster',
			'settings.tasks.settings.enableDescription' => 'Pokazuj zadania, banery i wskaźniki TaskMaster w panelu bocznym i w całym interfejsie',
			'settings.agents.authStatus.checking' => 'Sprawdzanie...',
			'settings.agents.authStatus.connected' => 'Połączono',
			'settings.agents.authStatus.notConnected' => 'Brak połączenia',
			'settings.agents.authStatus.disconnected' => 'Rozłączono',
			'settings.agents.authStatus.checkingAuth' => 'Sprawdzanie stanu uwierzytelniania...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Zalogowano jako ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => 'Konto ${provider}',
			'settings.agents.authStatus.authenticatedUser' => 'uwierzytelniony użytkownik',
			'settings.agents.install.title' => ({required Object agent}) => 'CLI ${agent} nie jest zainstalowane',
			'settings.agents.install.description' => ({required Object agent}) => 'Zainstaluj CLI ${agent}, aby się zalogować i uruchamiać sesje.',
			'settings.agents.install.button' => 'Zainstaluj',
			'settings.agents.install.installing' => 'Instalowanie…',
			'settings.agents.install.copyCommand' => 'Kopiuj polecenie',
			'settings.agents.install.docs' => 'Dokumentacja',
			'settings.agents.install.success' => ({required Object agent}) => 'CLI ${agent} zainstalowane',
			'settings.agents.install.failed' => 'Instalacja nie powiodła się — sprawdź dane wyjściowe terminala',
			'settings.agents.update.title' => 'Aktualizuj CLI',
			'settings.agents.update.description' => ({required Object agent}) => 'Zainstaluj najnowszą wersję CLI ${agent} na hoście serwera.',
			'settings.agents.update.button' => 'Aktualizuj',
			'settings.agents.update.updating' => 'Aktualizowanie…',
			'settings.agents.update.success' => ({required Object agent}) => 'CLI ${agent} zaktualizowane',
			'settings.agents.update.failed' => 'Aktualizacja nie powiodła się — sprawdź wynik w terminalu',
			'settings.agents.account.claude.description' => 'Asystent AI Anthropic Claude',
			'settings.agents.account.cursor.description' => 'Edytor kodu Cursor napędzany AI',
			'settings.agents.account.codex.description' => 'Asystent AI OpenAI Codex',
			'settings.agents.account.opencode.description' => 'Asystent CLI OpenCode',
			'settings.agents.account.commandcode.description' => 'Asystent CLI Command Code',
			'settings.agents.account.antigravity.description' => 'Asystent CLI Antigravity',
			'settings.agents.account.devin.description' => 'Asystent CLI Devin',
			'settings.agents.connectionStatus' => 'Stan połączenia',
			'settings.agents.login.title' => 'Logowanie',
			'settings.agents.login.reAuthenticate' => 'Uwierzytelnij ponownie',
			'settings.agents.login.description' => ({required Object agent}) => 'Zaloguj się do swojego konta ${agent}, aby włączyć funkcje AI',
			'settings.agents.login.reAuthDescription' => 'Zaloguj się innym kontem lub odśwież poświadczenia',
			'settings.agents.login.button' => 'Zaloguj się',
			'settings.agents.login.reLoginButton' => 'Zaloguj ponownie',
			'settings.agents.logout.title' => 'Wyloguj',
			'settings.agents.logout.description' => 'Wyloguj się z tego dostawcy i usuń zapisane poświadczenia',
			'settings.agents.logout.button' => 'Wyloguj',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => 'Wylogować z ${agent}?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Spowoduje to usunięcie zapisanych poświadczeń ${agent} na serwerze. Zaloguj się ponownie, aby dalej korzystać z ${agent}.',
			'settings.agents.logout.success' => 'Wylogowano',
			'settings.agents.logout.failed' => 'Wylogowanie nie powiodło się',
			'settings.agents.error' => ({required Object error}) => 'Błąd: ${error}',
			'settings.agents.accounts.title' => 'Nazwane konta',
			'settings.agents.accounts.description' => 'Dodatkowe zestawy poświadczeń. Sesja przypięta do konta uruchamia CLI z izolowanym katalogiem konfiguracji. Zaloguj się, uruchamiając raz CLI providera z pokazanymi zmiennymi.',
			'settings.agents.accounts.sharedCli' => 'Wszystkie konta korzystają z jednej instalacji CLI — aktualizuj ją w karcie połączenia powyżej.',
			'settings.agents.accounts.loading' => 'Ładowanie kont…',
			'settings.agents.accounts.kDefault' => 'Domyślne',
			'settings.agents.accounts.usage' => ({required Object tokens}) => '${tokens} tokenów',
			'settings.agents.accounts.usageButton' => 'Użycie',
			'settings.agents.accounts.showUsage' => 'Pokaż użycie tokenów',
			'settings.agents.accounts.makeDefault' => 'Ustaw jako domyślne',
			'settings.agents.accounts.remove' => 'Usuń konto',
			'settings.agents.accounts.newLabel' => 'Nazwa konta (np. Praca)',
			'settings.agents.accounts.add' => 'Dodaj konto',
			'settings.agents.accounts.autoSwitch.label' => 'Automatycznie przełączaj konto po wyczerpaniu limitu',
			'settings.agents.accounts.autoSwitch.description' => 'Gdy konto osiągnie limit użycia, sesja przechodzi na inne konto tego samego agenta, które ma jeszcze limit — nawet jeśli ręcznie wybrano wyczerpane konto. Nigdy nie przełącza na innego agenta. Claude i Codex zachowują rozmowę; inni agenci przełączają się tylko w nowych czatach.',
			'settings.permissions.title' => 'Ustawienia uprawnień',
			'settings.permissions.permissionMode.title' => 'Tryb uprawnień',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Domyślny tryb uprawnień dla nowych sesji ${provider}. Możesz go nadal zmienić dla pojedynczej sesji przyciskiem trybu w oknie czatu.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Domyślny',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Akcje wymagające uprawnień są wyświetlane do zatwierdzenia w czacie.',
			'settings.permissions.permissionMode.modes.auto.title' => 'Tryb automatyczny',
			'settings.permissions.permissionMode.modes.auto.description' => 'Klasyfikator modelu decyduje przy każdym wywołaniu narzędzia, czy je zatwierdzić, czy odrzucić. Tryb bezobsługowy, ale bezpieczniejszy niż omijanie uprawnień — odrzucenia nadal występują.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Akceptuj zmiany',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Zmiany plików są zatwierdzane automatycznie; pozostałe akcje nadal wymagają Twojej zgody.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Omijaj uprawnienia',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Wszystkie akcje są zatwierdzane automatycznie — pełny dostęp bez pytań. Używaj ostrożnie.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Tryb planowania: agent analizuje i planuje bez wykonywania poleceń.',
			'settings.mcpServers.title' => 'Serwery MCP',
			'settings.mcpServers.description.claude' => 'Serwery Model Context Protocol zapewniają Claude dodatkowe narzędzia i źródła danych',
			'settings.mcpServers.description.cursor' => 'Serwery Model Context Protocol zapewniają Cursor dodatkowe narzędzia i źródła danych',
			'settings.mcpServers.description.codex' => 'Serwery Model Context Protocol zapewniają Codex dodatkowe narzędzia i źródła danych',
			'settings.mcpServers.description.opencode' => 'Serwery Model Context Protocol zapewniają OpenCode dodatkowe narzędzia i źródła danych',
			'settings.mcpServers.description.commandcode' => 'Serwery Model Context Protocol zapewniają Command Code dodatkowe narzędzia i źródła danych',
			'settings.mcpServers.description.antigravity' => 'Serwery Model Context Protocol zapewniają Antigravity dodatkowe narzędzia i źródła danych',
			'settings.mcpServers.description.devin' => 'Serwery Model Context Protocol zapewniają dodatkowe narzędzia i źródła danych dla Devin',
			'settings.mcpServers.addButton' => 'Dodaj serwer MCP',
			'settings.mcpServers.empty' => 'Brak skonfigurowanych serwerów MCP',
			'settings.mcpServers.serverType' => 'Typ',
			'settings.mcpServers.scope.local' => 'lokalny',
			'settings.mcpServers.scope.user' => 'użytkownik',
			'settings.mcpServers.config.command' => 'Polecenie',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Argumenty',
			'settings.mcpServers.config.environment' => 'Środowisko',
			'settings.mcpServers.tools.title' => 'Narzędzia',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} więcej',
			'settings.mcpServers.actions.edit' => 'Edytuj serwer',
			'settings.mcpServers.actions.delete' => 'Usuń serwer',
			'settings.mcpServers.managed.badge' => 'Zarządzany',
			'settings.mcpServers.managed.hint' => 'Zarządzane przez DDAgent.',
			'settings.mcpServers.help.title' => 'O Codex MCP',
			'settings.mcpServers.help.description' => 'Codex obsługuje serwery MCP oparte na stdio. Możesz dodawać serwery rozszerzające możliwości Codex o dodatkowe narzędzia i zasoby.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '„${serverName}” zostanie usunięty z konfiguracji dostawcy.',
			'settings.mcpServers.deleteConfirm.title' => 'Usunąć serwer MCP?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => 'Progi alertów, polityka routingu i konta odpytywane o limity.',
			'settings.quota.settings.saved' => 'Zapisano',
			'settings.quota.settings.alertsSection' => 'Alerty',
			'settings.quota.settings.alertsSectionHint' => 'Ostrzegaj zanim limit faktycznie się skończy, nie tylko przy 100%.',
			'settings.quota.settings.alertsEnabled' => 'Alerty przewidywane',
			'settings.quota.settings.alertsEnabledHint' => 'Pokazuj prognozy tempa na przeglądzie i kartach kont.',
			'settings.quota.settings.watchThreshold' => 'Próg obserwacji (%)',
			'settings.quota.settings.watchThresholdHint' => 'Konta na tym poziomie lub wyżej są liczone jako zagrożone.',
			'settings.quota.settings.dangerThreshold' => 'Próg krytyczny (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Odczyty na tym poziomie lub wyżej są pokazywane na czerwono.',
			'settings.quota.settings.routingSection' => 'Routing',
			'settings.quota.settings.routingSectionHint' => 'Jak panel może przenosić pracę na konto z największym zapasem.',
			'settings.quota.settings.routing.manual' => 'Ręcznie',
			'settings.quota.settings.routing.manualHint' => 'Pokazuje tylko rekomendację; nigdy nie przełącza kont automatycznie.',
			'settings.quota.settings.routing.ask' => 'Pytaj przed przełączeniem',
			'settings.quota.settings.routing.askHint' => 'Przełączenie jest proponowane i czeka na Twoją zgodę.',
			'settings.quota.settings.routing.autoLowRisk' => 'Auto dla zadań niskiego ryzyka',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Tylko zadania oznaczone jako niskiego ryzyka mogą być przenoszone automatycznie.',
			'settings.quota.settings.routingNote' => 'Zmiana konta wpływa na koszt i jakość modelu, więc zawsze wymaga decyzji.',
			'settings.quota.settings.accountsSection' => 'Odpytywane konta',
			'settings.quota.settings.accountsSectionHint' => 'Dane logowania są czytane z każdego narzędzia; panel nigdzie ich nie wysyła.',
			'settings.quota.settings.sourcesSection' => 'Źródła danych',
			'settings.quota.settings.sourcesSectionHint' => 'Skąd pochodzą zużycie i koszt.',
			'settings.quota.settings.logSources' => 'Magazyn logów tokenów i kosztów',
			'settings.quota.settings.logSourcesHint' => 'Zbiorczy magazyn tylko do odczytu, wspólny z kolektorem tokboard.',
			'settings.quota.settings.readOnly' => 'Tylko odczyt',
			'settings.quota.settings.quotaConsent' => 'Odpytywanie limitów',
			'settings.quota.settings.quotaConsentHint' => 'Czyta endpointy limitów providerów lokalnymi danymi logowania.',
			'settings.quota.settings.localOnly' => 'Tylko lokalnie',
			'settings.quota.empty.description' => 'Nie wykryto jeszcze żadnych kont.',
			'settings.quota.quality.cached' => 'z pamięci podręcznej',
			'settings.quota.quality.error' => 'błąd',
			'settings.quota.quality.estimate' => 'szacunek',
			'settings.quota.quality.live' => 'na żywo',
			'settings.quota.quality.unknown' => 'nieznane',
			'settings.quota.syncFailed' => 'Synchronizacja nie powiodła się',
			'settings.quota.syncNow' => 'Synchronizuj teraz',
			'settings.browser.checking' => 'sprawdzanie...',
			'settings.browser.description' => 'Pozwól agentom tworzyć nadzorowane sesje przeglądarki Playwright, które możesz monitorować w zakładce Browser.',
			'settings.browser.enableDescription' => 'Rejestruje Browser dla obsługiwanych agentów. Agenci mogą tworzyć sesje przeglądarki; możesz je obserwować, zatrzymywać i usuwać.',
			'settings.browser.enableLabel' => 'Włącz Browser',
			'settings.browser.errors.installRuntime' => 'Nie udało się zainstalować środowiska przeglądarki',
			'settings.browser.errors.loadSettings' => 'Nie udało się załadować ustawień Browser',
			'settings.browser.errors.loadStatus' => 'Nie udało się załadować statusu Browser',
			'settings.browser.errors.saveSettings' => 'Nie udało się zapisać ustawień Browser',
			'settings.browser.installHint' => 'Zainstaluj środowisko przeglądarki, zanim agenci będą mogli tworzyć sesje Browser.',
			'settings.browser.installRuntime' => 'Zainstaluj środowisko',
			'settings.browser.installed' => 'zainstalowane',
			'settings.browser.installing' => 'Instalowanie...',
			'settings.browser.missing' => 'brak',
			'settings.browser.runtimeRequired' => 'Wymagane środowisko przeglądarki',
			'settings.browser.statusDisabled' => 'wyłączony',
			'settings.browser.statusLabel' => 'Status',
			'settings.browser.statusReady' => 'gotowy',
			'settings.browser.statusSetupRequired' => 'wymagana konfiguracja',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Anuluj',
			'settings.workspaces.create' => 'Dodaj obszar roboczy',
			'settings.workspaces.deleteConfirm' => 'Usunąć ten obszar roboczy z DDAgent? Jego pliki pozostaną na dysku.',
			'settings.workspaces.deleteFailed' => 'Nie udało się usunąć obszaru roboczego.',
			'settings.workspaces.deleteTitle' => 'Usuń obszar roboczy',
			'settings.workspaces.description' => 'Obszary robocze to katalogi, w których DDAgent może czatować, uruchamiać kod i przeglądać.',
			'settings.workspaces.remove' => 'Usuń obszar roboczy',
			'settings.workspaces.title' => 'Obszary robocze',
			'settings.workspaces.pathRequired' => 'Ścieżka jest wymagana',
			'settings.stt.title' => 'Wprowadzanie głosowe (speech-to-text)',
			'settings.stt.description' => 'Endpoint zgodny z Whisper /audio/transcriptions (OpenAI, whisper.cpp, faster-whisper, Speaches). Włącza przycisk mikrofonu w polu wiadomości.',
			'settings.stt.configured' => 'skonfigurowano',
			_ => null,
		} ?? switch (path) {
			'settings.stt.endpoint' => 'URL endpointu (np. https://api.openai.com/v1)',
			'settings.stt.apiKey' => 'Klucz API',
			'settings.stt.model' => 'Model (domyślnie: whisper-1)',
			'settings.stt.save' => 'Zapisz',
			'settings.schedules.title' => 'Harmonogram',
			'settings.schedules.description' => 'Cykliczne uruchomienia agentów wg cron. Uruchamiają się bez nadzoru z pominięciem uprawnień.',
			'settings.schedules.preventSleep' => 'Blokuj uśpienie, gdy agenty pracują',
			'settings.schedules.preventSleepHint' => 'Na desktopie utrzymuje ekran wybudzony; w przeglądarce używa Wake Lock API.',
			'settings.schedules.kNew' => 'Nowy harmonogram',
			'settings.schedules.loading' => 'Ładowanie…',
			'settings.schedules.empty' => 'Brak harmonogramów.',
			'settings.schedules.project' => 'Projekt',
			'settings.schedules.provider' => 'Provider',
			'settings.schedules.cron' => 'Cron (min godz dzień mies dzień-tyg)',
			'settings.schedules.nextRun' => ({required Object time}) => 'Następne uruchomienie: ${time}',
			'settings.schedules.cronInvalid' => 'Brak nadchodzącego uruchomienia dla tego wyrażenia',
			'settings.schedules.prompt' => 'Prompt',
			'settings.schedules.useWorktree' => 'Uruchom w nowym worktree',
			'settings.schedules.catchUp' => 'Nadrabiaj przegapione uruchomienia',
			'settings.schedules.failures' => ({required Object count}) => '${count} błędów',
			'settings.schedules.disabled' => 'wyłączony',
			'settings.schedules.history' => 'Historia',
			'settings.schedules.runNow' => 'Uruchom teraz',
			'settings.schedules.delete' => 'Usuń',
			'settings.schedules.noRuns' => 'Brak uruchomień.',
			'settings.schedules.next' => 'nast.',
			'settings.schedules.create' => 'Utwórz',
			'settings.schedules.toggleSchedule' => 'Włącz harmonogram',
			'settings.mcpTokens.title' => 'Tokeny serwera MCP DDAgenta',
			'settings.mcpTokens.description' => 'Zewnętrzne narzędzia (Claude Desktop, OpenClaw) wywołują narzędzia DDAgenta przez POST /mcp z tymi tokenami bearer.',
			'settings.mcpTokens.dismiss' => 'Zamknij',
			'settings.mcpTokens.labelPlaceholder' => 'Etykieta tokenu (np. Claude Desktop)',
			'settings.mcpTokens.create' => 'Utwórz',
			'settings.mcpTokens.empty' => 'Brak tokenów MCP.',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => 'użyty ${time}',
			'settings.mcpTokens.neverUsed' => 'nigdy nie użyty',
			'settings.about.supportTitle' => 'Wesprzyj projekt',
			'settings.about.buyMeACoffee' => 'Postaw mi kawę',
			'settings.about.tryHosted' => 'Wypróbuj DDAgent Hosted',
			'settings.about.learnMore' => 'Dowiedz się więcej',
			'settings.about.proFeatures' => 'Funkcje DDAgent Pro',
			'settings.about.pro.syncSettings' => 'Synchronizuj ustawienia',
			'settings.about.pro.teamManagement' => 'Zarządzanie zespołem',
			'settings.about.pro.syncSettingsDescription' => 'Synchronizuj preferencje, konfiguracje MCP i motyw we wszystkich swoich środowiskach.',
			'settings.about.pro.teamManagementDescription' => 'Wielu użytkowników, dostęp oparty na rolach i współdzielone projekty dla Twojego zespołu.',
			'settings.about.versionInfo' => 'Informacje o wersji',
			'settings.about.client' => 'Aplikacja',
			'settings.about.server' => 'Serwer',
			'settings.about.platformMobile' => 'Mobilna',
			'settings.about.platformDesktop' => 'Desktopowa',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'nieznana',
			'settings.about.copyright' => '© 2026 DDAgent — wszelkie prawa zastrzeżone',
			'settings.about.tagline' => 'Otwartoźródłowy interfejs asystenta AI do programowania',
			'settings.about.docs' => 'Dokumentacja',
			'settings.about.hostedDescription' => 'Współpraca zespołowa, współdzielone konfiguracje MCP, synchronizacja ustawień między środowiskami i zarządzana infrastruktura.',
			'settings.shortcuts.description' => 'Wszystkie skróty klawiszowe w DDAgent, wg platformy.',
			'settings.shortcuts.action' => 'Akcja',
			'settings.shortcuts.winLinux' => 'Windows / Linux',
			'settings.shortcuts.mac' => 'macOS',
			'settings.shortcuts.navigation' => 'Nawigacja',
			'settings.shortcuts.navWorkspace' => 'Przejdź do Workspace',
			'settings.shortcuts.navTasks' => 'Przejdź do Zadań / Git',
			'settings.shortcuts.navGit' => 'Przejdź do Git',
			'settings.shortcuts.navFocus' => 'Tryb fokusowy (pasek boczny)',
			'settings.shortcuts.navSwitcher' => 'Szybkie przełączanie sesji',
			'settings.shortcuts.navPalette' => 'Paleta poleceń',
			'settings.shortcuts.navSettings' => 'Otwórz ustawienia',
			'settings.shortcuts.navClose' => 'Zamknij dialog / przywróć podział',
			'settings.shortcuts.composer' => 'Pole wiadomości',
			'settings.shortcuts.compSend' => 'Wyślij wiadomość',
			'settings.shortcuts.compNewline' => 'Nowa linia',
			'settings.shortcuts.compNav' => 'Nawigacja po podpowiedziach',
			'settings.shortcuts.compAccept' => 'Wybierz podpowiedź',
			'settings.shortcuts.compCloseSuggest' => 'Zamknij podpowiedzi',
			'settings.shortcuts.transcript' => 'Transkrypcja',
			'settings.shortcuts.trCopy' => 'Kopiuj zaznaczony tekst',
			'settings.shortcuts.trClose' => 'Zamknij wyszukiwanie / podgląd',
			'settings.shortcuts.terminal' => 'Terminal',
			'settings.shortcuts.termCopy' => 'Kopiuj zaznaczenie',
			'settings.shortcuts.termInterrupt' => 'Przerwij proces (bez zaznaczenia)',
			'settings.shortcuts.termPaste' => 'Wklej',
			'settings.shortcuts.termSelectAll' => 'Zaznacz wszystko',
			'settings.shortcuts.editor' => 'Edytor',
			'settings.shortcuts.edSave' => 'Zapisz plik',
			'settings.shortcuts.edSaveAll' => 'Zapisz wszystkie pliki',
			'settings.shortcuts.edClose' => 'Zamknij kartę',
			'settings.shortcuts.edNextTab' => 'Następna karta',
			'settings.shortcuts.edPrevTab' => 'Poprzednia karta',
			'settings.shortcuts.edIndent' => 'Wcięcie / cofnięcie wcięcia',
			'settings.shortcuts.palette' => 'Paleta poleceń',
			'settings.shortcuts.palNav' => 'Nawigacja po elementach',
			'settings.shortcuts.palRun' => 'Uruchom / otwórz',
			'settings.shortcuts.palBack' => 'Wstecz (puste pole)',
			'settings.shortcuts.palClose' => 'Zamknij',
			'sidebar.projects.title' => 'Projekty',
			'sidebar.projects.newProject' => 'Nowy projekt',
			'sidebar.projects.deleteProject' => 'Usuń projekt',
			'sidebar.projects.renameProject' => 'Zmień nazwę projektu',
			'sidebar.projects.noProjects' => 'Nie znaleziono projektów',
			'sidebar.projects.loadingProjects' => 'Ładowanie projektów...',
			'sidebar.projects.searchPlaceholder' => 'Szukaj projektów...',
			'sidebar.projects.projectNamePlaceholder' => 'Nazwa projektu',
			'sidebar.projects.starred' => 'Ulubione',
			'sidebar.projects.all' => 'Wszystkie',
			'sidebar.projects.untitledSession' => 'Sesja bez nazwy',
			'sidebar.projects.newSession' => 'Nowa sesja',
			'sidebar.projects.codexSession' => 'Sesja Codex',
			'sidebar.projects.fetchingProjects' => 'Pobieranie Twoich projektów i sesji Claude',
			'sidebar.projects.projects' => 'projekty',
			'sidebar.projects.noMatchingProjects' => 'Brak pasujących projektów',
			'sidebar.projects.tryDifferentSearch' => 'Spróbuj zmienić wyszukiwane hasło',
			'sidebar.projects.runClaudeCli' => 'Uruchom Claude CLI w katalogu projektu, aby rozpocząć',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'Interfejs asystenta programowania AI',
			'sidebar.panel.open' => 'Panel',
			'sidebar.panel.newChat' => 'Nowy czat',
			'sidebar.panel.navigation' => 'Nawigacja',
			'sidebar.panel.sessions' => 'Sesje',
			'sidebar.sessions.title' => 'Sesje',
			'sidebar.sessions.newSession' => 'Nowa sesja',
			'sidebar.sessions.deleteSession' => 'Usuń sesję',
			'sidebar.sessions.renameSession' => 'Zmień nazwę sesji',
			'sidebar.sessions.noSessions' => 'Nie ma jeszcze żadnych sesji',
			'sidebar.sessions.loadingSessions' => 'Ładowanie sesji...',
			'sidebar.sessions.unnamed' => 'Bez nazwy',
			'sidebar.sessions.loading' => 'Ładowanie...',
			'sidebar.sessions.showMore' => 'Pokaż więcej sesji',
			'sidebar.sessions.selectMode' => 'Zaznacz',
			'sidebar.sessions.selectAll' => 'Zaznacz wszystkie',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Archiwizuj (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Usuń (${count})',
			'sidebar.sessions.cancelSelection' => 'Anuluj zaznaczanie',
			'sidebar.sessions.toggleSelection' => 'Przełącz zaznaczenie sesji',
			'sidebar.sessions.selectionToolbar' => 'Akcje zaznaczonych sesji',
			'sidebar.sessions.options' => 'Opcje sesji',
			'sidebar.sessions.pinSession' => 'Przypnij sesję',
			'sidebar.sessions.unpinSession' => 'Odepnij sesję',
			'sidebar.sessions.pinned' => 'Przypięta sesja',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Zaznaczono ${count}', few: 'Zaznaczono ${count}', many: 'Zaznaczono ${count}', other: 'Zaznaczono ${count}', ), 
			'sidebar.tooltips.viewEnvironments' => 'Wyświetl środowiska',
			'sidebar.tooltips.hideSidebar' => 'Ukryj panel boczny',
			'sidebar.tooltips.createProject' => 'Utwórz nowy projekt',
			'sidebar.tooltips.refresh' => 'Odśwież projekty i sesje (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Zmień nazwę projektu (F2)',
			'sidebar.tooltips.deleteProject' => 'Usuń projekt z panelu bocznego (Delete)',
			'sidebar.tooltips.addToFavorites' => 'Dodaj do ulubionych',
			'sidebar.tooltips.removeFromFavorites' => 'Usuń z ulubionych',
			'sidebar.tooltips.editSessionName' => 'Ręcznie zmień nazwę sesji',
			'sidebar.tooltips.deleteSession' => 'Usuń tę sesję trwale',
			'sidebar.tooltips.activeSessionIndicator' => 'Ostatnio aktywna sesja (w ciągu ostatnich 10 minut)',
			'sidebar.tooltips.save' => 'Zapisz',
			'sidebar.tooltips.cancel' => 'Anuluj',
			'sidebar.tooltips.clearSearch' => 'Wyczyść wyszukiwanie',
			'sidebar.tooltips.openCommandPalette' => 'Otwórz paletę poleceń',
			'sidebar.tooltips.attentionRequiredIndicator' => 'Sesja wymaga uwagi',
			'sidebar.tooltips.openSessions' => 'Przeglądaj sesje',
			'sidebar.navigation.chat' => 'Czat',
			'sidebar.navigation.files' => 'Pliki',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminal',
			'sidebar.navigation.tasks' => 'Zadania',
			'sidebar.actions.refresh' => 'Odśwież',
			'sidebar.actions.settings' => 'Ustawienia',
			'sidebar.actions.collapseAll' => 'Zwiń wszystko',
			'sidebar.actions.expandAll' => 'Rozwiń wszystko',
			'sidebar.actions.cancel' => 'Anuluj',
			'sidebar.actions.save' => 'Zapisz',
			'sidebar.actions.delete' => 'Usuń',
			'sidebar.actions.rename' => 'Zmień nazwę',
			'sidebar.actions.joinCommunity' => 'Dołącz do społeczności',
			'sidebar.actions.reportIssue' => 'Zgłoś problem',
			'sidebar.actions.starOnGithub' => 'Dodaj gwiazdkę na GitHub',
			'sidebar.actions.buyMeACoffee' => 'Postaw mi kawę',
			'sidebar.workspace.title' => 'Zmień workspace sesji',
			'sidebar.workspace.description' => 'Agent wykona kolejne tury w tym katalogu. Historia sesji zostanie zachowana.',
			'sidebar.workspace.pathLabel' => 'Ścieżka workspace',
			'sidebar.workspace.pathRequired' => 'Ścieżka workspace jest wymagana.',
			'sidebar.workspace.submit' => 'Zmień workspace',
			'sidebar.workspace.saving' => 'Zmienianie…',
			'sidebar.workspace.changeAction' => 'Zmień workspace',
			'sidebar.branding.openSource' => 'Open Source',
			'sidebar.status.active' => 'Aktywna',
			'sidebar.status.inactive' => 'Nieaktywna',
			'sidebar.status.thinking' => 'Myślenie...',
			'sidebar.status.error' => 'Błąd',
			'sidebar.status.aborted' => 'Przerwano',
			'sidebar.status.unknown' => 'Nieznany',
			'sidebar.time.justNow' => 'Właśnie teraz',
			'sidebar.time.oneMinuteAgo' => '1 min temu',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} min temu',
			'sidebar.time.oneHourAgo' => '1 godz. temu',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} godz. temu',
			'sidebar.time.oneDayAgo' => '1 dzień temu',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} dni temu',
			'sidebar.messages.deleteConfirm' => 'Czy na pewno chcesz to usunąć?',
			'sidebar.messages.renameSuccess' => 'Pomyślnie zmieniono nazwę',
			'sidebar.messages.deleteSuccess' => 'Pomyślnie usunięto',
			'sidebar.messages.errorOccurred' => 'Wystąpił błąd',
			'sidebar.messages.deleteSessionConfirm' => 'Czy na pewno chcesz usunąć tę sesję? Tej operacji nie można cofnąć.',
			'sidebar.messages.deleteProjectConfirm' => 'Usunąć ten projekt z panelu bocznego? Pliki projektu, pamięci i dane sesji nie zostaną usunięte.',
			'sidebar.messages.enterProjectPath' => 'Podaj ścieżkę projektu',
			'sidebar.messages.deleteSessionFailed' => 'Nie udało się usunąć sesji. Spróbuj ponownie.',
			'sidebar.messages.deleteSessionError' => 'Błąd podczas usuwania sesji. Spróbuj ponownie.',
			'sidebar.messages.renameSessionFailed' => 'Nie udało się zmienić nazwy sesji. Spróbuj ponownie.',
			'sidebar.messages.renameSessionError' => 'Błąd podczas zmiany nazwy sesji. Spróbuj ponownie.',
			'sidebar.messages.changeWorkspaceFailed' => 'Nie udało się zmienić workspace. Spróbuj ponownie.',
			'sidebar.messages.changeWorkspaceError' => 'Błąd podczas zmiany workspace. Spróbuj ponownie.',
			'sidebar.messages.deleteProjectFailed' => 'Nie udało się usunąć projektu. Spróbuj ponownie.',
			'sidebar.messages.deleteProjectError' => 'Błąd podczas usuwania projektu. Spróbuj ponownie.',
			'sidebar.messages.createProjectFailed' => 'Nie udało się utworzyć projektu. Spróbuj ponownie.',
			'sidebar.messages.createProjectError' => 'Błąd podczas tworzenia projektu. Spróbuj ponownie.',
			'sidebar.messages.updateProjectError' => 'Błąd podczas aktualizowania projektu. Spróbuj ponownie.',
			'sidebar.messages.refreshError' => 'Nie udało się odświeżyć. Spróbuj ponownie.',
			'sidebar.messages.restoreProjectFailed' => 'Nie udało się przywrócić projektu. Spróbuj ponownie.',
			'sidebar.messages.restoreProjectError' => 'Błąd podczas przywracania projektu. Spróbuj ponownie.',
			'sidebar.messages.restoreSessionFailed' => 'Nie udało się przywrócić sesji. Spróbuj ponownie.',
			'sidebar.messages.restoreSessionError' => 'Błąd podczas przywracania sesji. Spróbuj ponownie.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Nie udało się usunąć sesji. Spróbuj ponownie.', few: 'Nie udało się usunąć ${count} sesji. Spróbuj ponownie.', many: 'Nie udało się usunąć ${count} sesji. Spróbuj ponownie.', other: 'Nie udało się usunąć ${count} sesji. Spróbuj ponownie.', ), 
			'sidebar.version.updateAvailable' => 'Dostępna aktualizacja',
			'sidebar.version.restartRequired' => 'Zainstalowano aktualizację — uruchom ponownie serwer, aby zastosować zmiany',
			'sidebar.version.updateNow' => 'Aktualizuj',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Zaktualizować DDAgent do v${version}? Najnowszy kod zostanie pobrany i zbudowany, a serwer uruchomi się ponownie — aktywne sesje zostaną przerwane.',
			'sidebar.version.updating' => 'Aktualizowanie… może potrwać kilka minut',
			'sidebar.version.restarting' => 'Zainstalowano — restartowanie…',
			'sidebar.version.updateFailed' => 'Aktualizacja nie powiodła się',
			'sidebar.version.releaseNotes' => 'Informacje o wydaniu',
			'sidebar.search.modeProjects' => 'Projekty',
			'sidebar.search.modeConversations' => 'Rozmowy',
			'sidebar.search.conversationsPlaceholder' => 'Szukaj w rozmowach...',
			'sidebar.search.searching' => 'Wyszukiwanie...',
			'sidebar.search.sessionTitles' => 'Sesja',
			'sidebar.search.conversationContents' => 'Treść rozmowy',
			'sidebar.search.noResults' => 'Brak wyników',
			'sidebar.search.tryDifferentQuery' => 'Spróbuj innego zapytania',
			'sidebar.search.modeRunning' => 'W toku',
			'sidebar.search.archiveOnly' => 'Archiwum',
			'sidebar.search.runningTooltip' => 'Sesje w toku',
			'sidebar.search.archiveOnlyTooltip' => 'Tylko archiwum',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} aktywnych',
			'sidebar.search.viewMenu' => 'Widok',
			'sidebar.search.backToProjects' => 'Wróć do projektów',
			'sidebar.search.archivedPlaceholder' => 'Szukaj w archiwum...',
			'sidebar.search.runningPlaceholder' => 'Szukaj w sesjach w toku...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} dopasowanie', other: '${count} dopasowań', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Przeskanowano ${count} projekt', other: 'Przeskanowano ${count} projektów', ), 
			'sidebar.recent.title' => 'Ostatnie rozmowy',
			'sidebar.recent.emptyTitle' => 'Nie ma jeszcze żadnych rozmów',
			'sidebar.recent.emptyDescription' => 'Tutaj pojawią się Twoje ostatnio aktualizowane rozmowy.',
			'sidebar.recent.loadFailed' => 'Nie można załadować ostatnich rozmów',
			'sidebar.recent.loadMore' => 'Załaduj starsze rozmowy',
			'sidebar.recent.loadingMore' => 'Ładowanie kolejnych...',
			'sidebar.deleteConfirmation.deleteProject' => 'Usuń projekt',
			'sidebar.deleteConfirmation.deleteSession' => 'Usuń sesję',
			'sidebar.deleteConfirmation.confirmDelete' => 'Co chcesz zrobić z:',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Usuń tylko z panelu bocznego',
			'sidebar.deleteConfirmation.deleteAllData' => 'Usuń trwale wszystkie dane',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'Projekt zostanie usunięty z panelu bocznego. Twoje pliki, pamięci i dane sesji zostaną zachowane.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Możesz później dodać projekt ponownie.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'Archiwizacja ukryje zaznaczone sesje na liście aktywnych, zachowując ich historię. Usunięcie trwałe skasuje je wraz z transkryptami.',
			'sidebar.deleteConfirmation.archiveSession' => 'Archiwizuj sesję',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'Archiwizacja ukryje sesję na liście aktywnych, zachowując jej historię.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Ta sesja jest już zarchiwizowana. Możesz ją pozostawić ukrytą lub usunąć trwale.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'To trwale usunie sesję wraz z transkryptem. Tej operacji nie można cofnąć.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Usuń trwale',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Ten projekt zawiera ${count} rozmowę.', other: 'Ten projekt zawiera ${count} rozmów.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Zarządzaj zaznaczoną sesją', few: 'Zarządzaj ${count} zaznaczonymi sesjami', many: 'Zarządzaj ${count} zaznaczonymi sesjami', other: 'Zarządzaj ${count} zaznaczonymi sesjami', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Archiwizuj sesję', few: 'Archiwizuj ${count} sesje', many: 'Archiwizuj ${count} sesji', other: 'Archiwizuj ${count} sesji', ), 
			'sidebar.zones.activeNow' => 'Aktywne teraz',
			'sidebar.zones.recent' => 'Ostatnio używane',
			'sidebar.zones.today' => 'Dzisiaj',
			'sidebar.zones.yesterday' => 'Wczoraj',
			'sidebar.zones.thisWeek' => 'W tym tygodniu',
			'sidebar.zones.showMore' => ({required Object count}) => 'Pokaż jeszcze ${count}',
			'sidebar.zones.showLess' => 'Pokaż mniej',
			'sidebar.tabs.board' => 'Tablica agentów',
			'sidebar.tabs.files' => 'Pliki',
			'sidebar.tabs.git' => 'Kontrola źródła',
			'sidebar.tabs.tasks' => 'Zadania',
			'sidebar.tabs.usage' => 'Limity i zużycie',
			'tasks.notConfigured.title' => 'TaskMaster AI nie jest skonfigurowany',
			'tasks.notConfigured.description' => 'TaskMaster pomaga dzielić złożone projekty na łatwe w realizacji zadania dzięki wsparciu AI',
			'tasks.notConfigured.whatIsTitle' => '🎯 Czym jest TaskMaster?',
			'tasks.notConfigured.features.aiPowered' => 'Zarządzanie zadaniami oparte na AI: dziel złożone projekty na łatwe w realizacji podzadania',
			'tasks.notConfigured.features.prdTemplates' => 'Szablony PRD: generuj zadania z dokumentów wymagań produktu',
			'tasks.notConfigured.features.dependencyTracking' => 'Śledzenie zależności: poznaj relacje między zadaniami i kolejność ich wykonywania',
			'tasks.notConfigured.features.progressVisualization' => 'Wizualizacja postępów: tablice Kanban i szczegółowe statystyki zadań',
			'tasks.notConfigured.features.cliIntegration' => 'Integracja z CLI: używaj poleceń taskmaster do zaawansowanych przepływów pracy',
			'tasks.notConfigured.initializeButton' => 'Zainicjuj TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => 'Najpierw napisz PRD',
			'tasks.gettingStarted.title' => 'Pierwsze kroki z TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster został zainicjowany! Oto co zrobić dalej:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Utwórz dokument wymagań produktu (PRD)',
			'tasks.gettingStarted.steps.createPRD.description' => 'Omów swój pomysł na projekt i utwórz PRD opisujące, co chcesz zbudować.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'Dodaj PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'Istniejące PRD:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Generuj zadania z PRD',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Gdy masz już PRD, poproś asystenta AI o jego przetworzenie, a TaskMaster automatycznie podzieli je na łatwe w realizacji zadania ze szczegółami implementacji.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Analizuj i rozwijaj zadania',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Poproś asystenta AI o analizę złożoności zadań i rozwinięcie ich w szczegółowe podzadania, aby ułatwić implementację.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Zacznij budować',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Poproś asystenta AI o rozpoczęcie pracy nad zadaniami, aktualizowanie ich statusu i dodawanie nowych zadań w miarę rozwoju projektu.',
			'tasks.gettingStarted.tip' => '💡 Wskazówka: zacznij od PRD, aby w pełni wykorzystać generowanie zadań przez AI w TaskMaster',
			'tasks.setupModal.title' => 'Konfiguracja TaskMaster',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'Interaktywny CLI dla ${projectName}',
			'tasks.setupModal.willStart' => 'Inicjalizacja TaskMaster rozpocznie się automatycznie',
			'tasks.setupModal.completed' => 'Konfiguracja TaskMaster zakończona! Możesz teraz zamknąć to okno.',
			'tasks.setupModal.closeButton' => 'Zamknij',
			'tasks.setupModal.closeContinueButton' => 'Zamknij i kontynuuj',
			'tasks.setupModal.closeTitle' => 'Zamknij',
			'tasks.setupModal.description' => 'Tworzy folder .taskmaster w tym projekcie. Nie wymaga zewnętrznych narzędzi ani kluczy API — zadania są przechowywane lokalnie.',
			'tasks.setupModal.initializeButton' => 'Zainicjuj',
			'tasks.setupModal.initializing' => 'Inicjowanie...',
			'tasks.helpGuide.title' => 'Pierwsze kroki z TaskMaster',
			'tasks.helpGuide.subtitle' => 'Twój przewodnik po wydajnym zarządzaniu zadaniami',
			'tasks.helpGuide.examples.parsePRD' => '💬 Przykład:\n"Właśnie zainicjowałem nowy projekt z Claude Task Master. Mam PRD w .taskmaster/docs/prd.txt. Czy możesz pomóc mi go przetworzyć i utworzyć początkowe zadania?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Przykład:\n"Zadanie 5 wygląda na złożone. Czy możesz rozbić je na podzadania?"',
			'tasks.helpGuide.examples.addTask' => '💬 Przykład:\n"Dodaj proszę nowe zadanie na implementację przesyłania obrazów profilu użytkownika z użyciem Cloudinary i zbadaj najlepsze podejście."',
			'tasks.helpGuide.moreExamples' => 'Zobacz więcej przykładów i wzorców użycia →',
			'tasks.helpGuide.proTips.title' => '💡 Wskazówki dla zaawansowanych',
			'tasks.helpGuide.proTips.search' => 'Użyj paska wyszukiwania, aby szybko znaleźć konkretne zadania',
			'tasks.helpGuide.proTips.views' => 'Przełączaj między widokami Kanban, Lista i Siatka za pomocą przełączników widoku',
			'tasks.helpGuide.proTips.filters' => 'Użyj filtrów, aby skupić się na określonych statusach lub priorytetach zadań',
			'tasks.helpGuide.proTips.details' => 'Kliknij dowolne zadanie, aby wyświetlić szczegółowe informacje i zarządzać podzadaniami',
			'tasks.helpGuide.learnMore.title' => '📚 Dowiedz się więcej',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI to zaawansowany system zarządzania zadaniami stworzony dla programistów. Znajdziesz tu dokumentację, przykłady i możliwość wkładu w rozwój projektu.',
			'tasks.helpGuide.learnMore.githubButton' => 'Zobacz na GitHubie',
			'tasks.helpGuide.closeTitle' => 'Zamknij',
			'tasks.search.placeholder' => 'Szukaj zadań...',
			'tasks.filters.button' => 'Filtry',
			'tasks.filters.status' => 'Status',
			'tasks.filters.priority' => 'Priorytet',
			'tasks.filters.sortBy' => 'Sortuj według',
			'tasks.filters.allStatuses' => 'Wszystkie statusy',
			'tasks.filters.allPriorities' => 'Wszystkie priorytety',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => 'Wyświetlanie ${filtered} z ${total} zadań',
			'tasks.filters.clearFilters' => 'Wyczyść filtry',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Status',
			'tasks.sort.priority' => 'Priorytet',
			'tasks.sort.idAsc' => 'ID (rosnąco)',
			'tasks.sort.idDesc' => 'ID (malejąco)',
			'tasks.sort.titleAsc' => 'Tytuł (A-Z)',
			'tasks.sort.titleDesc' => 'Tytuł (Z-A)',
			'tasks.sort.statusAsc' => 'Status (najpierw oczekujące)',
			'tasks.sort.statusDesc' => 'Status (najpierw ukończone)',
			'tasks.sort.priorityAsc' => 'Priorytet (najpierw wysoki)',
			'tasks.sort.priorityDesc' => 'Priorytet (najpierw niski)',
			'tasks.views.kanban' => 'Widok Kanban',
			'tasks.views.list' => 'Widok listy',
			'tasks.views.grid' => 'Widok siatki',
			'tasks.kanban.pending' => '📋 Do zrobienia',
			'tasks.kanban.inProgress' => '🚀 W toku',
			'tasks.kanban.review' => '👀 Przegląd',
			'tasks.kanban.done' => '✅ Ukończone',
			'tasks.kanban.blocked' => '🚫 Zablokowane',
			'tasks.kanban.deferred' => '⏳ Odroczone',
			'tasks.kanban.cancelled' => '❌ Anulowane',
			'tasks.kanban.noTasksYet' => 'Brak zadań',
			'tasks.kanban.tasksWillAppear' => 'Zadania pojawią się tutaj',
			'tasks.kanban.moveTasksHere' => 'Przenieś tutaj zadania po rozpoczęciu',
			'tasks.kanban.completedTasksHere' => 'Ukończone zadania pojawią się tutaj',
			'tasks.kanban.statusTasksHere' => 'Zadania z tym statusem pojawią się tutaj',
			'tasks.buttons.help' => 'Przewodnik po pierwszych krokach z TaskMaster',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => 'Dodaj PRD',
			'tasks.buttons.addTask' => 'Dodaj zadanie',
			'tasks.buttons.createNewPRD' => 'Utwórz nowy PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => 'Dostępne PRD: ${count}',
			'tasks.prd.modified' => ({required Object date}) => 'Zmodyfikowano: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.newFile' => 'nowy plik',
			'tasks.prd.template' => 'Szablon',
			'tasks.prd.parse' => 'Przetwórz PRD',
			'tasks.prd.fileExistsTitle' => 'Plik już istnieje',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'PRD o nazwie "${name}" już istnieje. Czy chcesz go nadpisać?',
			'tasks.prd.fileNameHint' => 'nazwa pliku (np. prd.txt)',
			'tasks.prd.saved' => 'Zapisano PRD',
			'tasks.prd.tasksGenerated' => 'Wygenerowano zadania z PRD',
			'tasks.statuses.pending' => 'Oczekujące',
			'tasks.statuses.inProgress' => 'W toku',
			'tasks.statuses.done' => 'Ukończone',
			'tasks.statuses.blocked' => 'Zablokowane',
			'tasks.statuses.deferred' => 'Odroczone',
			'tasks.statuses.cancelled' => 'Anulowane',
			'tasks.statuses.review' => 'Przegląd',
			'tasks.priorities.high' => 'Wysoki',
			'tasks.priorities.medium' => 'Średni',
			'tasks.priorities.low' => 'Niski',
			'tasks.noMatchingTasks.title' => 'Brak zadań pasujących do filtrów',
			'tasks.noMatchingTasks.description' => 'Spróbuj zmienić kryteria wyszukiwania lub filtrów.',
			'tasks.board.title' => 'Tablica agenta',
			'tasks.board.subtitle' => 'Przenieś kartę do „Do roboty”, a agent ją podejmie. Kliknij kartę, aby otworzyć jej sesję.',
			'tasks.board.newCard' => 'Nowa karta',
			'tasks.board.addCard' => 'Dodaj kartę',
			'tasks.board.refresh' => 'Odśwież',
			'tasks.board.empty.title' => 'Brak kart',
			'tasks.board.empty.description' => 'Dodaj kartę, opisz zadanie, a potem przeciągnij ją do „Do roboty”, żeby agent zaczął pracę.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Do roboty',
			'tasks.board.columns.working' => 'W trakcie',
			'tasks.board.columns.needsDecision' => 'Potrzeba decyzji',
			'tasks.board.columns.done' => 'Zakończone',
			'tasks.board.columns.archived' => 'Archiwum',
			'tasks.board.card.running' => 'W trakcie',
			'tasks.board.card.abort' => 'Przerwij',
			'tasks.board.card.delete' => 'Usuń',
			'tasks.board.card.openSession' => 'Otwórz sesję',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.card.edit' => 'Edytuj',
			'tasks.board.card.moveTo' => 'Przenieś do',
			'tasks.board.dialog.createTitle' => 'Nowa karta',
			'tasks.board.dialog.editTitle' => 'Edytuj kartę',
			'tasks.board.dialog.titleLabel' => 'Tytuł',
			'tasks.board.dialog.titlePlaceholder' => 'Co ma zrobić agent?',
			'tasks.board.dialog.descriptionLabel' => 'Opis',
			'tasks.board.dialog.descriptionPlaceholder' => 'Dodaj kontekst, kryteria akceptacji, linki...',
			'tasks.board.dialog.cancel' => 'Anuluj',
			'tasks.board.dialog.save' => 'Zapisz',
			'tasks.board.noProject' => 'Najpierw dodaj projekt, potem twórz dla niego karty.',
			'tasks.board.projectLabel' => 'Projekt',
			'tasks.board.backToChat' => 'Powrót do czatu',
			'tasks.board.agent.provider' => 'Agent',
			'tasks.board.agent.anyProvider' => 'Dowolny agent',
			'tasks.board.agent.model' => 'Model',
			'tasks.board.agent.defaultModel' => 'Domyślny model',
			'tasks.board.agent.effort' => 'Rozumowanie',
			'tasks.board.agent.defaultEffort' => 'Domyślne',
			'tasks.board.agent.searchModel' => 'Szukaj modeli…',
			'tasks.board.agent.noModels' => 'Brak pasujących modeli',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '„${cardTitle}” zostanie trwale usunięte.',
			'tasks.board.deleteConfirm.title' => 'Usunąć kartę?',
			'tasks.board.project' => 'Projekt',
			'tasks.board.assignee.label' => 'Przypisana osoba',
			'tasks.board.assignee.all' => 'Wszystkie osoby',
			'tasks.board.assignee.unassigned' => 'Nieprzypisane',
			'tasks.board.presence.online' => ({required Object count}) => 'Online: ${count}',
			'tasks.board.activity.title' => 'Aktywność',
			'tasks.board.activity.empty' => 'Brak aktywności',
			'tasks.board.comments.label' => 'Komentarze',
			'tasks.board.comments.placeholder' => 'Napisz komentarz…',
			'tasks.board.comments.send' => 'Wyślij',
			'tasks.board.comments.unknownAuthor' => 'Ktoś',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Zależy od: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Zadanie ${id}',
			'tasks.card.highPriority' => 'Wysoki priorytet',
			'tasks.card.lowPriority' => 'Niski priorytet',
			'tasks.card.mediumPriority' => 'Średni priorytet',
			'tasks.card.noPriority' => 'Nie ustawiono priorytetu',
			'tasks.card.parentTask' => ({required Object id}) => 'Zadanie ${id}',
			'tasks.card.progressLabel' => 'Postęp:',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => 'Ukończono ${completed} z ${total} podzadań',
			'tasks.card.runTask' => 'Uruchom zadanie',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Uruchom zadanie ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Status: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'ID zadania: ${id}',
			'tasks.card.taskInProgress' => 'Zadanie w trakcie',
			'tasks.createTask.cancel' => 'Anuluj',
			'tasks.createTask.descriptionLabel' => 'Opis',
			'tasks.createTask.descriptionPlaceholder' => 'Opcjonalne szczegóły',
			'tasks.createTask.error' => 'Nie udało się dodać zadania',
			'tasks.createTask.priorityLabel' => 'Priorytet',
			'tasks.createTask.submit' => 'Dodaj zadanie',
			'tasks.createTask.submitting' => 'Dodawanie...',
			'tasks.createTask.title' => 'Dodaj zadanie',
			'tasks.createTask.titleLabel' => 'Tytuł',
			'tasks.createTask.titlePlaceholder' => 'Co trzeba zrobić?',
			'tasks.list.completedReopen' => 'Ukończone (kliknij, aby ponownie otworzyć)',
			'tasks.list.inProgressComplete' => 'W trakcie (kliknij, aby ukończyć)',
			'tasks.list.markCompleted' => 'Oznacz jako ukończone',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Przełącz status zadania ${id}',
			'tasks.list.markDone' => 'Oznacz jako ukończone',
			'tasks.list.reopen' => 'Otwórz ponownie',
			'tasks.nextTask.allComplete' => 'Wszystkie zadania ukończone',
			'tasks.nextTask.feature1' => '- Zarządzanie zadaniami wspomagane AI z zależnościami i podzadaniami.',
			'tasks.nextTask.feature2' => '- Generowanie zadań na podstawie PRD dla szybszego startu projektu.',
			'tasks.nextTask.feature3' => '- Widoki kanban i listy do codziennej pracy.',
			'tasks.nextTask.hideDetails' => 'Ukryj szczegóły',
			'tasks.nextTask.initialize' => 'Zainicjuj',
			'tasks.nextTask.noPending' => 'Brak oczekujących zadań',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI nie jest skonfigurowany',
			'tasks.nextTask.review' => 'Przejrzyj',
			'tasks.nextTask.startTask' => 'Rozpocznij zadanie',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Zadanie ${id}',
			'tasks.nextTask.viewAll' => 'Zobacz wszystkie zadania',
			'tasks.nextTask.viewDetails' => 'Zobacz szczegóły zadania',
			'tasks.nextTask.whatIs' => 'Czym jest TaskMaster?',
			'tasks.taskDetail.cancelEdit' => 'Anuluj edycję',
			'tasks.taskDetail.close' => 'Zamknij',
			'tasks.taskDetail.copyTaskId' => 'Kopiuj ID zadania',
			'tasks.taskDetail.delete' => 'Usuń zadanie',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '„${title}" zostanie trwale usunięte.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Usunąć zadanie?',
			'tasks.taskDetail.deleteFailed' => 'Nie udało się usunąć zadania',
			'tasks.taskDetail.dependencies' => 'Zależności',
			'tasks.taskDetail.dependenciesPlaceholder' => 'np. 1, 2, 3',
			'tasks.taskDetail.description' => 'Opis',
			'tasks.taskDetail.edit' => 'Edytuj zadanie',
			'tasks.taskDetail.implDetails' => 'Szczegóły implementacji',
			'tasks.taskDetail.noDependencies' => 'Brak zależności',
			'tasks.taskDetail.noDescription' => 'Brak opisu',
			'tasks.taskDetail.priority' => 'Priorytet',
			'tasks.taskDetail.priorityNotSet' => 'Nie ustawiono',
			'tasks.taskDetail.save' => 'Zapisz',
			'tasks.taskDetail.status' => 'Status',
			'tasks.taskDetail.statusFailed' => 'Nie udało się zaktualizować statusu zadania',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Zadanie ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Zadanie ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Strategia testowania',
			'tasks.taskDetail.titleRequired' => 'Tytuł jest wymagany',
			'tasks.taskDetail.updateFailed' => 'Nie udało się zaktualizować zadania',
			'tasks.taskDetail.notFound' => 'Nie znaleziono zadania',
			_ => null,
		} ?? switch (path) {
			'tasks.taskDetail.subtasks' => 'Podzadania',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'Zadanie #${id} zostanie usunięte. Tej operacji nie można cofnąć.',
			'tasks.taskDetail.idCopied' => 'Skopiowano ID zadania',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Zadanie ${id} ustawiono jako w toku',
			'tasks.taskmaster.noProjectHint' => 'Najpierw dodaj projekt, a potem utwórz dla niego zadania.',
			'tasks.taskmaster.sort.statusAz' => 'Status (A–Z)',
			'tasks.taskmaster.sort.statusZa' => 'Status (Z–A)',
			'tasks.taskmaster.installedVersion' => ({required Object version}) => 'Zainstalowano: ${version}',
			'tasks.taskmaster.initFailed' => 'Nie udało się zainicjować TaskMaster',
			'tasks.taskmaster.prd.fileNameRequired' => 'Podaj nazwę pliku PRD.',
			'tasks.taskmaster.prd.contentRequired' => 'Przed zapisaniem dodaj treść.',
			'tasks.taskmaster.prd.overwrite' => 'Nadpisz',
			'tasks.taskmaster.prd.contentHint' => '# Dokument wymagań produktowych (PRD)…',
			'tasks.taskmaster.detail.dependenciesLabel' => 'Zależności (identyfikatory oddzielone przecinkami)',
			'tasks.taskmaster.untitledTask' => 'Zadanie bez tytułu',
			'knowledge.title' => 'Wiedza',
			'knowledge.tabs.dashboard' => 'Pulpit',
			'knowledge.tabs.memories' => 'Pamięci',
			'knowledge.tabs.rules' => 'Reguły',
			'knowledge.tabs.skills' => 'Skille',
			'knowledge.tabs.personal' => 'Personal',
			'knowledge.tabs.graph' => 'Graf',
			'knowledge.common.add' => 'Dodaj',
			'knowledge.common.save' => 'Zapisz',
			'knowledge.common.cancel' => 'Anuluj',
			'knowledge.common.delete' => 'Usuń',
			'knowledge.common.edit' => 'Edytuj',
			'knowledge.common.close' => 'Zamknij',
			'knowledge.common.restore' => 'Przywróć',
			'knowledge.common.refresh' => 'Odśwież',
			'knowledge.common.allProjects' => 'Wszystkie projekty',
			'knowledge.common.global' => 'Globalne',
			'knowledge.actions.scan' => 'Skanuj pliki projektu',
			'knowledge.actions.export' => 'Eksportuj JSON',
			'knowledge.actions.import' => 'Importuj JSON',
			'knowledge.actions.scanComplete' => 'Skanowanie projektu zakończone',
			'knowledge.actions.importComplete' => 'Import zakończony',
			'knowledge.actions.importFailed' => 'Import nie powiódł się',
			'knowledge.dialog.newEntity' => 'Nowy wpis',
			'knowledge.dialog.editEntity' => 'Edytuj wpis',
			'knowledge.dialog.deleteTitle' => 'Usuń',
			'knowledge.dialog.deleteMessage' => 'Usunąć ten wpis? Tego nie można cofnąć (historia zostaje zachowana).',
			'knowledge.dialog.pickIcon' => 'Wybierz ikonę',
			'knowledge.dialog.removeIcon' => 'Usuń ikonę',
			'knowledge.dialog.iconTooLarge' => 'Ikona jest za duża (maks. 40 KB).',
			'knowledge.dialog.importTitle' => 'Importuj wiedzę',
			'knowledge.dialog.importHint' => 'Wklej tutaj wyeksportowany JSON',
			'knowledge.dialog.exportTitle' => 'Eksportuj wiedzę',
			'knowledge.dialog.import' => 'Importuj',
			'knowledge.fields.key' => 'Klucz',
			'knowledge.fields.title' => 'Tytuł',
			'knowledge.fields.name' => 'Nazwa',
			'knowledge.fields.description' => 'Opis',
			'knowledge.fields.category' => 'Kategoria',
			'knowledge.fields.content' => 'Treść',
			'knowledge.fields.priority' => 'Priorytet',
			'knowledge.fields.tags' => 'Tagi',
			'knowledge.fields.enabled' => 'Włączone',
			'knowledge.fields.projectScope' => 'Zakres projektu',
			'knowledge.fields.tagsHint' => 'oddzielone przecinkami',
			'knowledge.dashboard.memories' => 'Pamięci',
			'knowledge.dashboard.rules' => 'Reguły',
			'knowledge.dashboard.skills' => 'Skille',
			'knowledge.dashboard.personal' => 'Personal',
			'knowledge.dashboard.connections' => 'Połączenia',
			'knowledge.dashboard.recent' => 'Ostatnie pamięci',
			'knowledge.dashboard.noMemories' => 'Brak pamięci. Dodaj jedną w zakładce Pamięci.',
			'knowledge.empty.memories' => 'Brak pamięci.',
			'knowledge.empty.rules' => 'Brak reguł.',
			'knowledge.empty.skills' => 'Brak skilli.',
			'knowledge.empty.personal' => 'Brak danych osobowych.',
			'knowledge.empty.graph' => 'Brak encji do pokazania na grafie.',
			'knowledge.history.title' => 'Historia',
			'knowledge.history.none' => 'Brak historii.',
			'knowledge.history.untitled' => '(bez tytułu)',
			'knowledge.priorities.critical' => 'Krytyczny',
			'knowledge.priorities.high' => 'Wysoki',
			'knowledge.priorities.normal' => 'Normalny',
			'knowledge.priorities.low' => 'Niski',
			'knowledge.search.title' => 'Szukaj w wiedzy',
			'knowledge.search.hint' => 'Szukaj pamięci, reguł, skilli…',
			'knowledge.search.noResults' => 'Brak wyników.',
			'knowledge.links.title' => 'Połącz encje',
			'knowledge.links.source' => 'Źródło',
			'knowledge.links.target' => 'Cel',
			'knowledge.links.relationship' => 'Relacja',
			'knowledge.links.add' => 'Utwórz połączenie',
			'knowledge.tags.all' => 'Wszystkie tagi',
			'knowledge.tags.manage' => 'Zarządzaj tagami',
			'knowledge.tags.none' => 'Brak tagów.',
			'knowledge.graph.truncated' => 'obcięto',
			'knowledge.importAll.title' => 'Importuj wszystko do DDAgent',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Przeskanowane projekty: ${count}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Znalezione skille agentów: ${found} (nowe: ${newSkills})',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Reguły: ${total} · grupy duplikatów: ${duplicates}',
			'knowledge.importAll.mergeDuplicates' => 'Scal duplikaty wpisów',
			'knowledge.importAll.mergeDuplicatesHint' => 'Scala zduplikowane wiersze w DDAgent (nie pliki)',
			'knowledge.importAll.action' => 'Importuj wszystko',
			'knowledge.importAll.readOnlyNotice' => 'Tylko odczyt po stronie agentów: import trafia do własnej bazy danych DDAgent i NIE modyfikuje ani nie usuwa żadnych plików ani konfiguracji CLI. Poniższe opcje zmieniają wyłącznie dane DDAgent.',
			'knowledge.importAll.dryRunNote' => 'Próbny przebieg — nic jeszcze nie zapisano.',
			'knowledge.importAll.importedNote' => 'Zaimportowano.',
			'knowledge.importAll.result' => ({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'Zaimportowano — reguły: ${rules}, nowe skille: ${newSkills}, usunięte: ${removed}, oznaczone jako krytyczne: ${promoted}',
			'knowledge.importAll.description' => 'Przeskanuj wszystkie projekty i zaimportuj skille agentów do bazy wiedzy. Agenci są tylko odczytywani — w CLI nic się nie zmienia.',
			'knowledge.migrate.title' => 'Migruj istniejące reguły',
			'knowledge.migrate.scanned' => ({required Object count}) => 'Przeskanowano ${count} projekt(ów).',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Reguły: ${total} łącznie, ${critical} krytycznych.',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Grupy duplikatów w projektach: ${count}',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Usunięte: ${removed}, awansowane: ${promoted}',
			'knowledge.migrate.mergeDuplicates' => 'Scal duplikaty',
			'knowledge.migrate.dryRunNote' => 'Próbny przebieg — nic jeszcze nie zostało zmienione.',
			'knowledge.migrate.applied' => 'Zastosowano.',
			'knowledge.importSkills.title' => 'Importuj skille agentów',
			'knowledge.importSkills.found' => ({required Object count}) => 'Znaleziono ${count} skill(i) u Twoich agentów.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Nowe: ${imported} · pominięte: ${skipped}',
			'knowledge.importSkills.dryRunHint' => 'Importuje globalne/domyślne skille dostarczane przez agentów (użytkownika, systemowe, z wtyczek) jako skille w bazie wiedzy. Próbny przebieg — nic jeszcze nie zaimportowano.',
			'knowledge.importSkills.importedNote' => 'Zaimportowano do bazy wiedzy.',
			'knowledge.critical.make' => 'Oznacz jako krytyczne',
			'knowledge.critical.makeAll' => 'Oznacz wszystkie reguły jako krytyczne',
			'knowledge.critical.makeAllHint' => 'Dodaje je do budżetu wstrzykiwanego kontekstu',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.contextBudget.title' => 'Kontekst reguł (zawsze dołączany)',
			'knowledge.contextBudget.selectProject' => 'Wybierz projekt, aby zobaczyć rozmiar jego krytycznego kontekstu.',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Pamięć: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Reguła: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Skill: ${name}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Osobiste: ${title}',
			'knowledge.errors.importFailed' => ({required Object error}) => 'Import nie powiódł się: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Migracja nie powiodła się: ${error}',
			'knowledge.entityTypes.memory' => 'Pamięć',
			'knowledge.entityTypes.rule' => 'Reguła',
			'knowledge.entityTypes.skill' => 'Skill',
			'knowledge.entityTypes.personal' => 'Osobiste',
			'knowledge.entityTypes.project' => 'Projekt',
			'knowledge.entityTypes.tag' => 'Tag',
			'browser.dialogTitle' => 'Browser agenta',
			'browser.viewError' => 'Błąd widoku przeglądarki',
			'browser.web' => 'Web',
			'collab.team' => 'Zespół',
			'collab.invite' => 'Zaproś',
			'collab.inviteTeammate' => 'Zaproś członka zespołu',
			'collab.shareTokenHint' => 'Udostępnij ten token zaproszenia — jest pokazywany jednorazowo i wygasa po 72 godz.:',
			'collab.createInvite' => 'Utwórz zaproszenie',
			'collab.copyToken' => 'Kopiuj token',
			'collab.roles.member' => 'Członek',
			'collab.roles.viewer' => 'Obserwator',
			'collab.viewing.session' => 'sesja',
			'collab.viewing.card' => 'karta',
			'collab.viewing.board' => 'tablica',
			'fileTree.uploadTo' => 'Wgraj do',
			'fileTree.uploadHere' => 'Wgraj tutaj',
			'fileTree.browseServerFilesystem' => 'Przeglądaj system plików serwera',
			'fileTree.noFiles' => 'Brak plików',
			'fileTree.copyContents' => 'Kopiuj zawartość',
			'fileTree.chooseFolder' => 'Wybierz folder',
			'fileTree.search.hint' => 'Filtruj nazwy / Enter, aby przeszukać zawartość',
			'fileTree.search.prompt' => 'Wpisz zapytanie i naciśnij Enter',
			'fileTree.search.noMatches' => 'Brak dopasowań',
			'fileTree.search.resultsTruncated' => 'Wyniki obcięte',
			'fileTree.titles.rename' => ({required Object name}) => 'Zmień nazwę ${name}',
			'fileTree.titles.delete' => ({required Object name}) => 'Usuń ${name}',
			'fileTree.titles.download' => ({required Object name}) => 'Pobierz ${name}',
			'fileTree.uploadedCount' => ({required Object count}) => 'Przesłano ${count} plik(ów)',
			'fileTree.newName' => 'Nowa nazwa',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Nie jest zarejestrowanym projektem: ${path}',
			'fileTree.showGitignoredFiles' => 'Pokaż pliki ignorowane przez Git',
			'fileTree.hideGitignoredFiles' => 'Ukryj pliki ignorowane przez Git',
			'fileTree.downloadUnsupportedOnWeb' => 'Pobieranie niedostępne w wersji webowej',
			'fileTree.saveToPath' => 'Zapisz do ścieżki',
			'fileTree.savedTo' => ({required Object path}) => 'Zapisano w ${path}',
			'fileTree.relative.now' => 'teraz',
			'fileTree.relative.minutes' => ({required Object n}) => '${n} min',
			'fileTree.relative.hours' => ({required Object n}) => '${n} godz.',
			'fileTree.relative.days' => ({required Object n}) => '${n} dni',
			'fileTree.projectRoot' => '(katalog główny projektu)',
			'fileTree.uploadLimitCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Naraz możesz przesłać maksymalnie ${count} plik.', few: 'Naraz możesz przesłać maksymalnie ${count} pliki.', many: 'Naraz możesz przesłać maksymalnie ${count} plików.', other: 'Naraz możesz przesłać maksymalnie ${count} pliku.', ), 
			'fileTree.fileTooLarge' => ({required Object name}) => 'Plik ${name} jest większy niż 200 MB.',
			'fileTree.deleteFolderConfirm' => ({required Object path}) => 'Usunąć folder „${path}”? Tej operacji nie można cofnąć.',
			'fileTree.deleteFileConfirm' => ({required Object path}) => 'Usunąć plik „${path}”? Tej operacji nie można cofnąć.',
			'git.checkpoints.title' => 'Punkty kontrolne',
			'git.checkpoints.restoreTitle' => 'Przywróć punkt kontrolny',
			'git.checkpoints.restoreMessage' => 'Zresetować drzewo robocze do tego punktu kontrolnego? Bieżące zmiany zostaną zastąpione.',
			'git.checkpoints.restored' => 'Przywrócono punkt kontrolny',
			'git.checkpoints.labelHint' => 'Etykieta punktu kontrolnego (opcjonalnie)',
			'git.checkpoints.empty' => 'Brak punktów kontrolnych',
			'git.checkpoints.create' => 'Nowy',
			'git.stagedChanges' => 'Przygotowane zmiany',
			'git.statusStaged' => 'Przygotowane',
			'git.switchBranch' => 'Przełącz gałąź',
			'git.unifiedDiff' => 'Diff ujednolicony',
			'git.splitDiff' => 'Diff obok siebie',
			'git.noDiff' => 'Brak dostępnego diff',
			'git.largeDiff' => 'Duży podgląd diff: renderowanie jest ograniczone, aby karta działała płynnie.',
			'git.loadDiffFailed' => ({required Object error}) => 'Nie udało się wczytać diff: ${error}',
			'git.hunkStage' => '+ Fragment',
			'git.hunkUnstage' => '− Fragment',
			'git.stageHunk' => 'Przygotuj fragment',
			'git.unstageHunk' => 'Cofnij przygotowanie fragmentu',
			'git.deleteFile' => 'Usuń plik',
			'git.commitMessage' => 'Wiadomość commita',
			'git.aiButton' => '✦ AI',
			'git.commitCreated' => 'Utworzono commit',
			'git.noBranch' => 'brak gałęzi',
			'git.selectProject' => 'Wybierz projekt',
			'git.branchSections.local' => 'LOKALNE',
			'git.branchSections.remote' => 'ZDALNE',
			'kanban.card.untitled' => 'Bez tytułu',
			'kanban.comments.empty' => 'Brak komentarzy',
			'kanban.comments.add' => 'Dodaj komentarz',
			'kanban.dialog.saving' => 'Zapisywanie…',
			'kanban.details.title' => 'Szczegóły karty',
			'kanban.details.status' => ({required Object status}) => 'Status: ${status}',
			'kanban.empty.noProject' => 'Nie wybrano projektu',
			'kanban.saveFailed' => 'Nie udało się zapisać karty',
			'kanban.time.now' => 'teraz',
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '1 min temu', other: '${count} min temu', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '1 godz. temu', other: '${count} godz. temu', ), 
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '1 dzień temu', other: '${count} dni temu', ), 
			'mcp.install.title' => 'Zainstaluj serwer MCP DDAgent',
			'mcp.install.description' => 'Pozwala wybranym agentom korzystać z bazy wiedzy i narzędzi DDAgent przez MCP.',
			'mcp.install.cardDescription' => 'Daj swoim agentom bazę wiedzy i narzędzia DDAgent przez MCP — wybierz agentów albo zainstaluj dla wszystkich.',
			'mcp.install.installSelected' => 'Zainstaluj wybrane',
			'mcp.install.installForAll' => 'Zainstaluj dla wszystkich',
			'mcp.install.button' => 'Zainstaluj',
			'mcp.install.failed' => ({required Object error}) => 'Instalacja nie powiodła się: ${error}',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Zainstalowano u ${count} agenta.', other: 'Zainstalowano u ${count} agentów.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Zainstalowano u ${count}; niepowodzenia: ${failed}',
			'mcp.install.errorFallback' => 'błąd',
			'mcp.servers.loading' => 'Ładowanie serwerów MCP...',
			'mcp.servers.refreshingScopes' => 'Odświeżanie zakresów projektu...',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Serwery Model Context Protocol zapewniają ${provider} dodatkowe narzędzia i źródła danych',
			'mcp.servers.addGlobalTitle' => 'Dodaj globalny serwer MCP',
			'mcp.servers.addGlobalDescription' => 'Dodaje ten serwer MCP do każdego dostawcy: Claude, Cursor, Codex, OpenCode i Devin. Obsługiwane są tylko transporty stdio i HTTP, ponieważ ta sama konfiguracja musi działać u wszystkich dostawców.',
			'mcp.servers.addGlobalMenuDescription' => 'Dodanie globalnego serwera MCP zapisuje jeden wspólny serwer stdio lub HTTP u dostawców Claude, Cursor, Codex, OpenCode i Devin.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => 'Dodaj serwer MCP ${provider}',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => 'Dodanie serwera MCP ${provider} zmienia tylko ${provider}.',
			'mcp.servers.config.cwd' => 'Katalog roboczy',
			'mcp.servers.config.envVars' => 'Zmienne środowiskowe',
			'mcp.servers.selectProjectRequired' => 'Wybierz projekt dla serwerów MCP o zakresie projektu',
			'mcp.servers.globalScopeUnsupported' => 'Dodawanie serwera MCP dla wszystkich dostawców obsługuje tylko zakres użytkownika lub projektu.',
			'mcp.servers.globalAddFailed' => ({required Object details}) => 'Nie udało się dodać serwera MCP do wszystkich dostawców. ${details}',
			'mcp.servers.scopeProject' => 'projekt',
			'mcp.team.title' => 'Konfiguracje MCP zespołu',
			'mcp.team.description' => 'Udostępniaj konfiguracje serwerów MCP całemu zespołowi. Wszyscy automatycznie pozostają zsynchronizowani.',
			'mcp.team.cta' => 'Dostępne w DDAgent Pro',
			'mcp.tokens.scopeWrite' => 'Zapis',
			'mcp.tokens.scopeRead' => 'Odczyt',
			'mcp.form.submitTo' => ({required Object provider}) => 'Dodaj serwer do ${provider}',
			'mcp.form.scope.userAllProviders' => 'Użytkownik (wszyscy dostawcy)',
			'mcp.form.scope.claudeLocal' => 'Claude (lokalny)',
			'mcp.form.scope.projectAllProviders' => 'Projekt (wszyscy dostawcy)',
			'mcp.form.scope.description.userGlobal' => 'Zapisuje w konfiguracji użytkownika każdego dostawcy i jest dostępny we wszystkich projektach na tej maszynie',
			'mcp.form.scope.description.user' => 'Dostępny we wszystkich projektach na Twojej maszynie',
			'mcp.form.scope.description.local' => 'Zapisany w ustawieniach użytkownika Claude dla wybranego projektu',
			'mcp.form.scope.description.projectGlobal' => 'Zapisuje w obszarze roboczym wybranego projektu dla każdego dostawcy',
			'mcp.form.scope.description.project' => 'Zapisany w obszarze roboczym wybranego projektu',
			'mcp.form.fields.workingDirectory' => 'Katalog roboczy',
			'mcp.form.fields.envVarNames' => 'Nazwy zmiennych środowiskowych',
			'mcp.form.fields.bearerTokenEnvVar' => 'Zmienna środowiskowa tokenu bearer',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'Dodawanie serwera MCP obsługuje u wszystkich dostawców tylko stdio i http, a nie ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} nie obsługuje serwerów MCP typu ${type}',
			'mcp.form.validation.jsonMustBeObject' => 'Konfiguracja JSON musi być obiektem',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.registrationRejected' => 'Serwer odrzucił rejestrację',
			'notifications.errors.noResponse' => 'Brak odpowiedzi z serwera',
			'notifications.androidChannel.name' => 'Alerty DDAgent',
			'notifications.androidChannel.description' => 'Powiadomienia o przebiegach agentów, zatwierdzeniach i błędach',
			'onboarding.gitHint' => 'Używane dla commitów tworzonych przez sesje DDAgent.',
			'onboarding.completeSetup' => 'Zakończ konfigurację',
			'onboarding.errors.nameAndEmailRequired' => 'Nazwa i e-mail Git są wymagane.',
			'onboarding.errors.invalidEmail' => 'Podaj prawidłowy adres e-mail.',
			'onboarding.agents.title' => 'Połącz swoich agentów AI',
			'onboarding.agents.description' => 'Zaloguj się do jednego lub więcej asystentów AI. Wszystkie są opcjonalne.',
			'onboarding.agents.laterHint' => 'Możesz je skonfigurować później w Ustawieniach.',
			'onboarding.mcp.title' => 'Połącz agentów z DDAgent',
			'onboarding.mcp.description' => 'Zainstaluj serwer MCP DDAgent, aby Twoi agenci mogli korzystać z bazy wiedzy i narzędzi DDAgent. Wybierz agentów albo zainstaluj dla wszystkich.',
			'onboarding.mcp.installSelected' => 'Zainstaluj wybrane',
			'onboarding.mcp.installForAll' => 'Zainstaluj dla wszystkich',
			'onboarding.mcp.laterHint' => 'Opcjonalne — możesz to też zainstalować później w Ustawieniach → MCP.',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Zainstalowano u ${count} agenta.', other: 'Zainstalowano u ${count} agentów.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Zainstalowano u ${installedCount}; niepowodzenia: ${failed}',
			'projects.cloneRepository' => 'Klonuj repozytorium',
			'projects.repositoryCloned' => 'Repozytorium sklonowane',
			'projects.clone' => 'Klonuj',
			'projects.cloneFinished' => 'Klonowanie zakończone. Odświeżanie listy projektów…',
			'projects.cloneFailed' => 'Klonowanie nie powiodło się',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.destinationPath' => 'Ścieżka docelowa',
			'projects.destinationPathRequired' => 'Ścieżka docelowa jest wymagana',
			'projects.repositoryUrlRequired' => 'Adres URL repozytorium jest wymagany',
			'projects.githubTokenOptional' => 'Token GitHub (opcjonalnie)',
			'projects.archive' => 'Archiwizuj',
			'projects.restore' => 'Przywróć',
			'projects.deletePermanently' => 'Usuń trwale',
			'projects.deleteProjectTitle' => 'Usunąć projekt?',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Trwale usuwa "${name}" wraz ze wszystkimi sesjami i zapisaną historią (czyszczenie JSONL). Tej operacji nie można cofnąć.',
			'projects.archivedSection' => ({required Object count}) => 'Zarchiwizowane (${count})',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} sesja', other: '${count} sesji', ), 
			'projects.newer' => 'Nowsze',
			'projects.older' => 'Starsze',
			'projects.projectArchived' => 'Projekt zarchiwizowany',
			'projects.projectRestored' => 'Projekt przywrócony',
			'projects.projectRenamed' => 'Zmieniono nazwę projektu',
			'projects.projectDeleted' => 'Projekt usunięty',
			'projects.failedToLoadTokens' => 'Nie udało się wczytać tokenów GitHub',
			'projects.displayNameOptional' => 'Nazwa wyświetlana (opcjonalnie)',
			'projects.usingStoredToken' => ({required Object name}) => 'Używanie zapisanego tokenu: ${name}',
			'projects.unknown' => 'Nieznane',
			'projects.project' => 'Projekt',
			'quota.section.config' => 'Konfiguracja',
			'quota.overview.tokensAndCost' => 'Tokeny i koszt',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.config.pollerTitle' => 'Odpytywanie i alerty',
			'quota.config.accountRouting' => 'Routing kont',
			'quota.config.save' => 'Zapisz konfigurację',
			'quota.chart.show' => 'Pokaż',
			'quota.chart.hide' => 'Ukryj',
			'quota.chart.noData' => 'Za mało danych, aby pokazać trend.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokenów · ${cost}',
			'quota.duration.minutes' => ({required Object minutes}) => '${minutes} min',
			'quota.duration.hoursMinutes' => ({required Object hours, required Object minutes}) => '${hours} godz. ${minutes} min',
			'quota.duration.daysHours' => ({required Object days, required Object hours}) => '${days} d. ${hours} godz.',
			'quota.duration.now' => 'teraz',
			'scheduler.newLabel' => 'Nowy',
			'scheduler.runs' => 'Uruchomienia',
			'scheduler.editTitle' => 'Edytuj harmonogram',
			'scheduler.deleteTitle' => 'Usunąć harmonogram?',
			'scheduler.deleteMessage' => ({required Object id}) => 'Spowoduje to usunięcie zadania cyklicznego ${id}. Istniejące sesje zostaną zachowane.',
			'scheduler.checking' => 'Sprawdzanie…',
			'scheduler.nextIn' => ({required Object time}) => 'następne za ${time}',
			'scheduler.worktree' => 'worktree',
			'scheduler.session' => ({required Object id}) => 'sesja ${id}',
			'scheduler.cronHint' => 'Cron (min godz dzień mies dzień-tyg) — np. 0 9 * * *',
			'scheduler.promptHint' => 'Prompt dla agenta',
			'scheduler.runStatus.fired' => 'uruchomiono',
			'scheduler.runStatus.skipped' => 'pominięto',
			'scheduler.runStatus.failed' => 'błąd',
			'scheduler.runStatus.completed' => 'ukończono',
			'scheduler.cronErrors.fieldCount' => ({required Object got}) => 'Oczekiwano 5 pól, podano ${got}',
			'scheduler.cronErrors.fieldError' => ({required Object index, required Object error}) => 'Pole ${index}: ${error}',
			'scheduler.cronErrors.empty' => 'puste',
			'scheduler.cronErrors.invalidPart' => ({required Object part}) => 'nieprawidłowe „${part}”',
			'scheduler.cronErrors.invalidValue' => ({required Object value}) => 'nieprawidłowa wartość „${value}”',
			'serverConnect.subtitle' => 'Połącz się ze swoim serwerem DDAgent',
			'serverConnect.enterUrl' => 'Wpisz adres URL serwera',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Połączenie nie powiodło się (${error})',
			'serverConnect.connect' => 'Połącz',
			'serverConnect.connecting' => 'Łączenie…',
			'serverConnect.changeServer' => 'Zmień serwer',
			'serverConnect.local.title' => 'To urządzenie',
			'serverConnect.local.subtitle' => 'Uruchom serwer DDAgent na tym komputerze',
			'serverConnect.local.install' => 'Zainstaluj serwer lokalny',
			'serverConnect.local.start' => 'Uruchom serwer lokalny',
			'serverConnect.local.stop' => 'Zatrzymaj',
			'serverConnect.local.starting' => 'Uruchamianie serwera lokalnego…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Pobieranie serwera… ${percent}%',
			'serverConnect.local.installing' => 'Instalowanie…',
			'serverConnect.local.running' => ({required Object url}) => 'Działa pod adresem ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Zainstalowany (v${version})',
			'serverConnect.local.connect' => 'Użyj tego serwera',
			'serverConnect.local.error' => ({required Object error}) => 'Błąd serwera lokalnego: ${error}',
			'serverConnect.local.or' => 'lub połącz się ze zdalnym serwerem',
			'serverConnect.local.errors.releaseTagUnresolved' => 'Nie udało się ustalić najnowszego tagu wydania DDAgent.',
			'serverConnect.local.errors.unsupportedPlatform' => 'Lokalny serwer nie jest obsługiwany na tej platformie.',
			'serverConnect.local.errors.unsupportedPlatformDetail' => ({required Object platform}) => 'Lokalny serwer nie jest obsługiwany na tej platformie (${platform}).',
			'serverConnect.local.errors.nodeExtractionFailed' => ({required Object path}) => 'Rozpakowanie Node.js nie utworzyło pliku ${path}',
			'serverConnect.local.errors.downloadFailed' => ({required Object error}) => 'Pobieranie serwera nie powiodło się: ${error}',
			'serverConnect.local.errors.installFailed' => ({required Object error}) => 'Instalacja serwera nie powiodła się: ${error}',
			'serverConnect.local.errors.bundleNotInstalled' => 'Pakiet serwera nie jest zainstalowany.',
			'serverConnect.local.errors.spawnFailed' => ({required Object error}) => 'Nie udało się uruchomić procesu lokalnego serwera: ${error}',
			'serverConnect.local.errors.portInUse' => ({required Object port}) => 'Port ${port} jest już używany przez inną aplikację.',
			'serverConnect.local.errors.exitedDuringStartup' => 'Lokalny serwer zakończył działanie podczas uruchamiania.',
			'serverConnect.local.errors.exitedDuringStartupWithOutput' => ({required Object output}) => 'Lokalny serwer zakończył działanie podczas uruchamiania: ${output}',
			'serverConnect.local.errors.startTimeout' => 'Przekroczono czas oczekiwania na uruchomienie lokalnego serwera.',
			'serverConnect.local.errors.tarFailed' => ({required Object command, required Object code, required Object output}) => '${command} zakończyło się błędem (kod ${code}): ${output}',
			'serverConnect.httpStatus' => ({required Object code}) => 'HTTP ${code}',
			'serverConnect.networkError' => 'Błąd sieci',
			'sessions.noSessions' => 'Brak sesji',
			'sessions.noRecentSessions' => 'Brak ostatnich sesji',
			'sessions.archivedSessions' => 'Zarchiwizowane sesje',
			'sessions.rename' => 'Zmień nazwę',
			'sessions.archive' => 'Archiwizuj',
			'sessions.compareWith' => 'Porównaj z…',
			'sessions.projectPath' => 'Ścieżka projektu',
			'sessions.newSessionProvider' => 'Nowa sesja — dostawca',
			'sessions.autoOrchestrator' => 'Auto (orkiestrator)',
			'sessions.createFailed' => ({required Object error}) => 'Nie udało się utworzyć sesji: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Usuwa "${name}" wraz z transkryptem. Tej operacji nie można cofnąć.',
			'sessions.toasts.archived' => 'Sesja zarchiwizowana',
			'sessions.toasts.restored' => 'Sesja przywrócona',
			'sessions.toasts.deleted' => 'Sesja usunięta',
			'sessions.toasts.renamed' => 'Zmieniono nazwę sesji',
			'sessions.toasts.pinned' => 'Sesja przypięta',
			'sessions.toasts.unpinned' => 'Sesja odpięta',
			'sessions.toasts.workspaceChanged' => 'Workspace zmieniony',
			'sessions.age.lessThanMinute' => '<1 min',
			'sessions.age.minutes' => ({required Object count}) => '${count} min',
			'sessions.age.hours' => ({required Object hours}) => '${hours} godz.',
			'sessions.age.days' => ({required Object days}) => '${days} d',
			'sessions.activity.subagentRunning' => 'Działa subagent',
			'sessions.activity.readingFile' => ({required Object file}) => 'Odczyt ${file}',
			'sessions.activity.runningTool' => ({required Object name}) => 'Uruchamianie ${name}',
			'sessions.activity.editingFile' => ({required Object file}) => 'Edytowanie ${file}',
			'sessions.activity.editingFileGeneric' => 'Edytowanie pliku',
			'sessions.activity.runningShellCommand' => 'Uruchamianie polecenia powłoki',
			'sessions.activity.runningCommand' => ({required Object command}) => 'Uruchamianie `${command}`',
			'sessions.activity.committingChanges' => 'Zatwierdzanie zmian',
			'sessions.activity.pushingBranch' => 'Wysyłanie gałęzi',
			'sessions.activity.fetchingUrl' => ({required Object url}) => 'Pobieranie ${url}',
			'sessions.activity.searching' => ({required Object query}) => 'Wyszukiwanie „${query}”',
			'sessions.autoMini' => 'Auto (mini)',
			'sharedContext.title' => 'Współdzielone notatki',
			'skills.moveSkill' => ({required Object name}) => 'Przenieś ${name}',
			'skills.deleteSkill' => ({required Object name}) => 'Usuń ${name}',
			'skills.projectLabel' => 'Projekt',
			'skills.addDialog.title' => ({required Object provider}) => 'Dodaj skill ${provider}',
			'skills.addDialog.chooseFileTitle' => 'Wybierz SKILL.md',
			'skills.addDialog.chooseFolderTitle' => 'Wybierz folder skilla',
			'skills.addDialog.uploadHint' => 'Wgraj plik SKILL.md lub kompletny folder skilla.',
			'skills.addDialog.pickTitle' => 'Wybierz folder skilla lub SKILL.md',
			'skills.addDialog.pickHint' => 'Foldery mogą zawierać skrypty, referencje i zasoby.',
			'skills.addDialog.chooseFiles' => 'Wybierz pliki',
			'skills.addDialog.chooseFolder' => 'Wybierz folder',
			'skills.addDialog.readyToInstall' => 'Gotowe do instalacji',
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Plik Markdown · ${size}',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} plik · ${size}', other: '${count} plików · ${size}', ), 
			'skills.addDialog.removeQueued' => ({required Object name}) => 'Usuń ${name}',
			'skills.addDialog.whereWillThisInstall' => 'Gdzie to zostanie zainstalowane?',
			'skills.addDialog.hideInstallLocation' => 'Ukryj lokalizację instalacji',
			'skills.addDialog.folderUploadsNote' => 'Przesyłanie folderu zachowuje nazwę wybranego folderu; pojedyncze pliki używają `name` z `SKILL.md`.',
			'skills.addDialog.installSkill' => 'Zainstaluj skill',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: 'Zainstaluj ${count} skill', other: 'Zainstaluj ${count} skilli', ), 
			'skills.moveDialog.toProjectHint' => 'Wybierz projekt, do którego ma należeć ten skill. Zostanie on przeniesiony z globalnego katalogu skilli dostawcy.',
			'skills.moveDialog.toGlobalHint' => 'Przenieś ten skill do globalnego katalogu skilli, aby każdy projekt mógł z niego korzystać.',
			'skills.moveDialog.moveToProject' => 'Przenieś do projektu',
			'skills.moveDialog.moveToGlobal' => 'Przenieś do globalnych',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Zarządzaj skillami ${provider} z plików lokalnych, kompletnych folderów i lokalizacji powiązanych z projektem.',
			'skills.screen.searchHint' => 'Szukaj skilli...',
			'skills.screen.clearSearch' => 'Wyczyść wyszukiwanie skilli',
			'skills.screen.addSkill' => 'Dodaj skill',
			'skills.screen.scanningProjectSkills' => 'Skanowanie skilli projektu...',
			'skills.screen.savedSuccessfully' => 'Skille zapisano pomyślnie.',
			'skills.screen.loadingSkills' => ({required Object provider}) => 'Wczytywanie skilli ${provider}…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pl'))(count, one: '${count} SKILL', other: '${count} SKILLI', ), 
			'skills.screen.deleteTitle' => ({required Object name}) => 'Usunąć ${name}?',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Spowoduje to usunięcie katalogu ${directory} z zarządzanego katalogu skilli ${provider}. Tej operacji nie można cofnąć.',
			'skills.screen.noDescription' => 'Nie podano opisu w metadanych skilla.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Wtyczka: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Projekt: ${name}',
			'skills.screen.sourceLabel' => 'ŹRÓDŁO',
			'skills.empty.noProjects' => 'Brak dostępnych projektów',
			'skills.empty.noProjectsDescription' => 'Dodaj projekt lub obszar roboczy, aby przeglądać jego skille.',
			'skills.empty.noSkillsInProject' => 'Brak skilli w tym projekcie',
			'skills.empty.noSkillsInProjectDescription' => 'Utwórz folder .claude/skills, .cursor/skills lub .agents/skills w wybranym projekcie.',
			'skills.empty.noGlobalSkills' => 'Nie wykryto jeszcze globalnych skilli',
			'skills.empty.noGlobalSkillsDescription' => 'Dodaj globalny skill powyżej, aby był dostępny we wszystkich projektach.',
			'skills.empty.noMatchingSkills' => 'Brak pasujących skilli',
			'skills.empty.noMatchingSkillsDescription' => 'Spróbuj innego polecenia, nazwy, zakresu, projektu lub ścieżki źródłowej.',
			'skills.scopes.user' => 'Użytkownik',
			'skills.scopes.plugin' => 'Wtyczka',
			'skills.scopes.repo' => 'Repozytorium',
			'skills.scopes.project' => 'Projekt',
			'skills.scopes.admin' => 'Administrator',
			'skills.scopes.system' => 'System',
			'skills.errors.dropMarkdownOrFolder' => 'Upuść co najmniej jeden plik markdown lub folder zawierający SKILL.md.',
			'skills.errors.addMarkdownFirst' => 'Najpierw dodaj co najmniej jeden plik markdown.',
			'skills.errors.importFailed' => 'Nie udało się zaimportować skilli',
			'skills.errors.folderReadFailed' => 'Nie udało się odczytać folderu skilla',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Folder skilla może zawierać maksymalnie ${count} plików.',
			'skills.errors.folderSizeLimit' => 'Wybrane foldery skilli mogą mieć łącznie mniej niż 30 MB.',
			'skills.errors.missingSkillFile' => 'Wybrany folder nie zawiera pliku SKILL.md.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'Nie udało się odczytać SKILL.md z ${name}.',
			'skills.providerShared' => 'Wspólne',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'terminal.tabs.plainShell' => 'Zwykły shell',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Logowanie: ${provider}',
			'terminal.tabs.runTitle' => ({required Object command}) => 'Uruchom: ${command}',
			'terminal.actions.newTab' => 'Nowa karta terminala',
			'terminal.actions.providerLogin' => 'Logowanie dostawcy',
			'terminal.actions.restartSession' => 'Uruchom ponownie sesję',
			'terminal.actions.clearOutput' => 'Wyczyść wyjście',
			'terminal.actions.newShell' => 'Nowy shell',
			'terminal.actions.connect' => 'Połącz',
			'terminal.authUrl.openInBrowser' => 'Otwórz w przeglądarce',
			'terminal.authUrl.linkLabel' => ({required Object url}) => 'Link logowania: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'Wykryto plik: ${path}',
			'terminal.shortcuts.interrupt' => 'Przerwij (SIGINT)',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.suspend' => 'Wstrzymaj (SIGTSTP)',
			'terminal.shortcuts.hide' => 'Ukryj pasek skrótów',
			'terminal.shortcuts.showTooltip' => 'Pokaż skróty',
			'terminal.shortcuts.hideTooltip' => 'Ukryj skróty',
			'terminal.paste.title' => 'Wklej do terminala',
			'terminal.paste.hint' => 'Ctrl+V / kliknij prawym przyciskiem → Wklej',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Nie udało się otworzyć linku: ${url}',
			'terminal.errors.frameError' => ({required Object message}) => '[Błąd] ${message}',
			'terminal.errors.connectionError' => ({required Object message}) => '[Błąd połączenia] ${message}',
			'terminal.loginDialog.title' => ({required Object provider}) => 'Logowanie do ${provider} CLI',
			'terminal.loginDialog.exited' => ({required Object code}) => 'Zakończono (${code})',
			'terminal.loginDialog.authLinkDetected' => 'Wykryto link uwierzytelniający',
			'terminal.empty.title' => 'Brak aktywnego terminala',
			'terminal.empty.description' => 'Utwórz nową kartę, aby rozpocząć',
			'terminal.overlay.processExited' => 'Proces zakończył działanie — połącz się, aby uruchomić go ponownie',
			'terminal.overlay.processExitedWithCode' => ({required Object code}) => 'Proces zakończył działanie (kod ${code}) — połącz się, aby uruchomić go ponownie',
			'terminal.overlay.resumeSession' => ({required Object title}) => 'Wznów sesję ${title}',
			'terminal.overlay.startSession' => ({required Object path}) => 'Rozpocznij nową sesję w ${path}',
			'voice.preview' => 'Podgląd',
			_ => null,
		} ?? switch (path) {
			'voice.settingsSaved' => 'Zapisano ustawienia wprowadzania głosowego',
			'voice.saveFailed' => 'Nie udało się zapisać konfiguracji STT',
			'voice.apiKeySaved' => 'Klucz API (zapisany, wpisz nowy, aby zastąpić)',
			'workspace.exportChat' => 'Eksportuj czat',
			'workspace.searchTranscript' => 'Szukaj w transkrypcji',
			'workspace.previousMatch' => 'Poprzednie dopasowanie',
			'workspace.nextMatch' => 'Następne dopasowanie',
			'workspace.closeSearch' => 'Zamknij wyszukiwanie',
			'workspace.newChatProvider' => 'Nowy czat — dostawca',
			'workspace.closePane' => 'Zamknij panel',
			'workspace.jumpToSession' => 'Przejdź do sesji…',
			'workspace.archivedWorkspaceName' => 'Zarchiwizowane',
			'workspace.sendTo' => ({required Object count}) => 'Wyślij do ${count}',
			'workspace.deleteSessionNotice' => 'Usuwa sesję i jej transkrypt. Tej operacji nie można cofnąć.',
			'workspace.accountWithLabel' => ({required Object label}) => 'Domyślne · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Zakończ przebieg przed zmianą obszaru roboczego',
			'workspace.restored' => 'Przywrócono obszar roboczy',
			'workspace.maximizePane' => 'Maksymalizuj panel',
			'workspace.restorePanes' => 'Przywróć panele',
			'workspace.reviewChangedFiles' => 'Przejrzyj zmienione pliki',
			'workspace.paneTitle.chat' => 'Czat',
			'workspace.paneTitle.browser' => 'Przeglądarka',
			'workspace.paneTitle.terminal' => 'Terminal',
			'workspace.paneTitle.notes' => 'Wspólne notatki',
			'workspace.paneTitle.editor' => 'Edytor',
			'workspace.paneTitle.git' => 'Git',
			'workspace.addEditorPane' => 'Dodaj panel edytora',
			'workspace.addGitPane' => 'Dodaj panel Git',
			'workspace.unknownProjectPath' => 'Nieznana ścieżka projektu',
			'workspace.autoMini' => 'Auto (mini)',
			'workspace.exportAs' => 'Eksportuj jako:',
			'workspace.exportMarkdown' => 'Markdown (.md)',
			'workspace.exportHtml' => 'Strona WWW (.html)',
			'workspace.exportPdf' => 'PDF (drukuj do pliku)',
			'workspace.matchPosition' => ({required Object current, required Object total}) => '${current} z ${total}',
			'workspace.launcherDescription' => 'Wybierz obszar roboczy dla tego panelu lub utwórz nowy.',
			'workspace.createWorkspace' => 'Utwórz obszar roboczy',
			'worktrees.scripts' => 'Skrypty',
			'worktrees.emptyTitle' => 'Nie znaleziono worktree',
			'worktrees.emptyDescription' => 'Utwórz worktree, aby odizolować pracę nad funkcją lub uruchomienia agentów.',
			'worktrees.opened' => ({required Object branch}) => 'Otwarto worktree: ${branch}',
			'worktrees.created' => 'Utworzono worktree',
			'worktrees.removed' => 'Usunięto worktree',
			'worktrees.merged' => ({required Object branch}) => 'Worktree scalony do ${branch}',
			'worktrees.scriptsSaved' => 'Zapisano konfigurację skryptów',
			'worktrees.setupLabel' => 'Setup: ',
			'worktrees.serverLabel' => 'Serwer: ',
			'worktrees.runRunning' => 'działa',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'działa :${port}',
			'worktrees.runButton' => 'Uruchom',
			'worktrees.stopButton' => 'Zatrzymaj',
			'worktrees.mainBadge' => 'main',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD odczepiony na ${sha}',
			'worktrees.branchHint' => 'Nazwa nowej gałęzi (np. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Odgałęzienie od ${branch}',
			'worktrees.mergeTitle' => ({required Object branch}) => 'Scal ${branch}',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Scal zmiany do ${branch}.',
			'worktrees.squashDescription' => 'Połącz wszystkie commity w jeden commit',
			'worktrees.cleanupDescription' => 'Usuń worktree i skasuj gałąź po scaleniu',
			'worktrees.removeTitle' => ({required Object branch}) => 'Usunąć worktree ${branch}?',
			'worktrees.removeDescription' => 'Spowoduje to usunięcie folderu worktree. Powiązane projekty zostaną zarchiwizowane.',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Uwaga: ten worktree ma ${count} niezatwierdzonych zmian, które zostaną utracone.',
			'worktrees.forceRemoveLabel' => 'Wymuś usunięcie (odrzuć zmiany)',
			'worktrees.deleteBranchLabel' => 'Usuń także gałąź',
			'worktrees.setupHint' => 'Polecenie setup (np. npm install)',
			'worktrees.runHint' => 'Polecenie uruchomienia (np. npm run dev)',
			'worktrees.portHint' => 'Port uruchomienia (opcjonalnie, np. 3000)',
			'worktrees.unknownSha' => 'nieznany',
			'worktrees.baseBranchFallback' => 'gałąź bazowa',
			'worktrees.runtimeStatus.idle' => 'bezczynny',
			'worktrees.runtimeStatus.running' => 'działa',
			'worktrees.runtimeStatus.done' => 'gotowe',
			'worktrees.runtimeStatus.failed' => 'błąd',
			'worktrees.runtimeStatus.exited' => 'zakończony',
			'browserUse.sessionStatus.ready' => 'Gotowa',
			'browserUse.sessionStatus.stopped' => 'Zatrzymana',
			'browserUse.sessionStatus.unavailable' => 'Niedostępna',
			'orchestrator.stepFallback' => ({required Object n}) => 'Krok ${n}',
			'miniOrchestrator.taskTypes.gate' => 'Bramka',
			'miniOrchestrator.roles.thinker' => 'Myśliciel',
			'miniOrchestrator.roles.worker' => 'Wykonawca',
			_ => null,
		};
	}
}
