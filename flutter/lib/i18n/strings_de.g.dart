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
class TranslationsDe extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$de auth = Translations$auth$de._(_root);
	@override late final Translations$chat$de chat = Translations$chat$de._(_root);
	@override late final Translations$codeEditor$de codeEditor = Translations$codeEditor$de._(_root);
	@override late final Translations$common$de common = Translations$common$de._(_root);
	@override late final Translations$settings$de settings = Translations$settings$de._(_root);
	@override late final Translations$sidebar$de sidebar = Translations$sidebar$de._(_root);
	@override late final Translations$tasks$de tasks = Translations$tasks$de._(_root);
	@override late final Translations$knowledge$de knowledge = Translations$knowledge$de._(_root);
	@override late final Translations$skills$de skills = Translations$skills$de._(_root);
	@override late final Translations$mcp$de mcp = Translations$mcp$de._(_root);
	@override late final Translations$terminal$de terminal = Translations$terminal$de._(_root);
	@override late final Translations$worktrees$de worktrees = Translations$worktrees$de._(_root);
	@override late final Translations$quota$de quota = Translations$quota$de._(_root);
	@override late final Translations$scheduler$de scheduler = Translations$scheduler$de._(_root);
	@override late final Translations$notifications$de notifications = Translations$notifications$de._(_root);
	@override late final Translations$serverConnect$de serverConnect = Translations$serverConnect$de._(_root);
	@override late final Translations$voice$de voice = Translations$voice$de._(_root);
	@override late final Translations$preview$de preview = Translations$preview$de._(_root);
	@override late final Translations$sharedContext$de sharedContext = Translations$sharedContext$de._(_root);
	@override late final Translations$collab$de collab = Translations$collab$de._(_root);
	@override late final Translations$browser$de browser = Translations$browser$de._(_root);
	@override late final Translations$projects$de projects = Translations$projects$de._(_root);
	@override late final Translations$sessions$de sessions = Translations$sessions$de._(_root);
	@override late final Translations$git$de git = Translations$git$de._(_root);
	@override late final Translations$kanban$de kanban = Translations$kanban$de._(_root);
	@override late final Translations$onboarding$de onboarding = Translations$onboarding$de._(_root);
	@override late final Translations$fileTree$de fileTree = Translations$fileTree$de._(_root);
	@override late final Translations$workspace$de workspace = Translations$workspace$de._(_root);
}

// Path: auth
class Translations$auth$de extends Translations$auth$en {
	Translations$auth$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.';
	@override late final Translations$auth$login$de login = Translations$auth$login$de._(_root);
	@override late final Translations$auth$register$de register = Translations$auth$register$de._(_root);
	@override late final Translations$auth$logout$de logout = Translations$auth$logout$de._(_root);
}

// Path: chat
class Translations$chat$de extends Translations$chat$en {
	Translations$chat$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$de codeBlock = Translations$chat$codeBlock$de._(_root);
	@override late final Translations$chat$copyMessage$de copyMessage = Translations$chat$copyMessage$de._(_root);
	@override late final Translations$chat$messageTypes$de messageTypes = Translations$chat$messageTypes$de._(_root);
	@override late final Translations$chat$tools$de tools = Translations$chat$tools$de._(_root);
	@override late final Translations$chat$search$de search = Translations$chat$search$de._(_root);
	@override late final Translations$chat$fileOperations$de fileOperations = Translations$chat$fileOperations$de._(_root);
	@override late final Translations$chat$interactive$de interactive = Translations$chat$interactive$de._(_root);
	@override late final Translations$chat$thinking$de thinking = Translations$chat$thinking$de._(_root);
	@override late final Translations$chat$json$de json = Translations$chat$json$de._(_root);
	@override late final Translations$chat$permissions$de permissions = Translations$chat$permissions$de._(_root);
	@override late final Translations$chat$todo$de todo = Translations$chat$todo$de._(_root);
	@override late final Translations$chat$plan$de plan = Translations$chat$plan$de._(_root);
	@override late final Translations$chat$usageLimit$de usageLimit = Translations$chat$usageLimit$de._(_root);
	@override late final Translations$chat$codex$de codex = Translations$chat$codex$de._(_root);
	@override late final Translations$chat$input$de input = Translations$chat$input$de._(_root);
	@override late final Translations$chat$providerSelection$de providerSelection = Translations$chat$providerSelection$de._(_root);
	@override late final Translations$chat$session$de session = Translations$chat$session$de._(_root);
	@override late final Translations$chat$shell$de shell = Translations$chat$shell$de._(_root);
	@override late final Translations$chat$claudeStatus$de claudeStatus = Translations$chat$claudeStatus$de._(_root);
	@override late final Translations$chat$projectSelection$de projectSelection = Translations$chat$projectSelection$de._(_root);
	@override late final Translations$chat$tasks$de tasks = Translations$chat$tasks$de._(_root);
	@override late final Translations$chat$voice$de voice = Translations$chat$voice$de._(_root);
	@override late final Translations$chat$composer$de composer = Translations$chat$composer$de._(_root);
	@override late final Translations$chat$splitSession$de splitSession = Translations$chat$splitSession$de._(_root);
	@override late final Translations$chat$sessionPicker$de sessionPicker = Translations$chat$sessionPicker$de._(_root);
	@override late final Translations$chat$splitWorkspace$de splitWorkspace = Translations$chat$splitWorkspace$de._(_root);
	@override late final Translations$chat$splitOverview$de splitOverview = Translations$chat$splitOverview$de._(_root);
	@override late final Translations$chat$askUserQuestion$de askUserQuestion = Translations$chat$askUserQuestion$de._(_root);
	@override late final Translations$chat$attachments$de attachments = Translations$chat$attachments$de._(_root);
	@override late final Translations$chat$checkpoint$de checkpoint = Translations$chat$checkpoint$de._(_root);
	@override late final Translations$chat$common$de common = Translations$chat$common$de._(_root);
	@override late final Translations$chat$taskMaster$de taskMaster = Translations$chat$taskMaster$de._(_root);
	@override late final Translations$chat$tokenUsage$de tokenUsage = Translations$chat$tokenUsage$de._(_root);
	@override late final Translations$chat$tool$de tool = Translations$chat$tool$de._(_root);
	@override late final Translations$chat$quotaBadge$de quotaBadge = Translations$chat$quotaBadge$de._(_root);
	@override late final Translations$chat$paneHeader$de paneHeader = Translations$chat$paneHeader$de._(_root);
	@override late final Translations$chat$broadcast$de broadcast = Translations$chat$broadcast$de._(_root);
	@override late final Translations$chat$changes$de changes = Translations$chat$changes$de._(_root);
	@override late final Translations$chat$commandResult$de commandResult = Translations$chat$commandResult$de._(_root);
	@override late final Translations$chat$commands$de commands = Translations$chat$commands$de._(_root);
	@override late final Translations$chat$export$de export = Translations$chat$export$de._(_root);
	@override late final Translations$chat$message$de message = Translations$chat$message$de._(_root);
	@override late final Translations$chat$modelLibrary$de modelLibrary = Translations$chat$modelLibrary$de._(_root);
	@override late final Translations$chat$pinFile$de pinFile = Translations$chat$pinFile$de._(_root);
	@override late final Translations$chat$permissionRequest$de permissionRequest = Translations$chat$permissionRequest$de._(_root);
}

// Path: codeEditor
class Translations$codeEditor$de extends Translations$codeEditor$en {
	Translations$codeEditor$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$de toolbar = Translations$codeEditor$toolbar$de._(_root);
	@override String loading({required Object fileName}) => '${fileName} wird geladen...';
	@override late final Translations$codeEditor$header$de header = Translations$codeEditor$header$de._(_root);
	@override late final Translations$codeEditor$actions$de actions = Translations$codeEditor$actions$de._(_root);
	@override late final Translations$codeEditor$footer$de footer = Translations$codeEditor$footer$de._(_root);
	@override late final Translations$codeEditor$binaryFile$de binaryFile = Translations$codeEditor$binaryFile$de._(_root);
	@override late final Translations$codeEditor$filePreview$de filePreview = Translations$codeEditor$filePreview$de._(_root);
	@override late final Translations$codeEditor$diff$de diff = Translations$codeEditor$diff$de._(_root);
	@override String get discardUnsavedChanges => 'Nicht gespeicherte Änderungen verwerfen?';
	@override late final Translations$codeEditor$emptyState$de emptyState = Translations$codeEditor$emptyState$de._(_root);
	@override String get failedToLoad => 'Datei konnte nicht geladen werden';
	@override late final Translations$codeEditor$hexDump$de hexDump = Translations$codeEditor$hexDump$de._(_root);
	@override late final Translations$codeEditor$mediaFile$de mediaFile = Translations$codeEditor$mediaFile$de._(_root);
	@override late final Translations$codeEditor$settings$de settings = Translations$codeEditor$settings$de._(_root);
	@override String unsavedChanges({required Object name}) => 'Nicht gespeicherte Änderungen in ${name}';
	@override late final Translations$codeEditor$toasts$de toasts = Translations$codeEditor$toasts$de._(_root);
}

// Path: common
class Translations$common$de extends Translations$common$en {
	Translations$common$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$de buttons = Translations$common$buttons$de._(_root);
	@override late final Translations$common$tabs$de tabs = Translations$common$tabs$de._(_root);
	@override late final Translations$common$status$de status = Translations$common$status$de._(_root);
	@override late final Translations$common$messages$de messages = Translations$common$messages$de._(_root);
	@override late final Translations$common$navigation$de navigation = Translations$common$navigation$de._(_root);
	@override late final Translations$common$common$de common = Translations$common$common$de._(_root);
	@override late final Translations$common$time$de time = Translations$common$time$de._(_root);
	@override late final Translations$common$fileOperations$de fileOperations = Translations$common$fileOperations$de._(_root);
	@override late final Translations$common$mainContent$de mainContent = Translations$common$mainContent$de._(_root);
	@override late final Translations$common$fileTree$de fileTree = Translations$common$fileTree$de._(_root);
	@override late final Translations$common$projectWizard$de projectWizard = Translations$common$projectWizard$de._(_root);
	@override late final Translations$common$versionUpdate$de versionUpdate = Translations$common$versionUpdate$de._(_root);
	@override late final Translations$common$quota$de quota = Translations$common$quota$de._(_root);
	@override late final Translations$common$notifications$de notifications = Translations$common$notifications$de._(_root);
	@override late final Translations$common$actions$de actions = Translations$common$actions$de._(_root);
	@override late final Translations$common$browserPane$de browserPane = Translations$common$browserPane$de._(_root);
	@override late final Translations$common$browserUse$de browserUse = Translations$common$browserUse$de._(_root);
	@override late final Translations$common$commandPalette$de commandPalette = Translations$common$commandPalette$de._(_root);
	@override late final Translations$common$gitPanel$de gitPanel = Translations$common$gitPanel$de._(_root);
	@override late final Translations$common$sessions$de sessions = Translations$common$sessions$de._(_root);
	@override late final Translations$common$projects$de projects = Translations$common$projects$de._(_root);
	@override late final Translations$common$codeBlock$de codeBlock = Translations$common$codeBlock$de._(_root);
	@override late final Translations$common$update$de update = Translations$common$update$de._(_root);
}

// Path: settings
class Translations$settings$de extends Translations$settings$en {
	Translations$settings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Einstellungen';
	@override late final Translations$settings$changelog$de changelog = Translations$settings$changelog$de._(_root);
	@override late final Translations$settings$server$de server = Translations$settings$server$de._(_root);
	@override late final Translations$settings$updates$de updates = Translations$settings$updates$de._(_root);
	@override late final Translations$settings$tabs$de tabs = Translations$settings$tabs$de._(_root);
	@override late final Translations$settings$account$de account = Translations$settings$account$de._(_root);
	@override late final Translations$settings$mcp$de mcp = Translations$settings$mcp$de._(_root);
	@override late final Translations$settings$appearance$de appearance = Translations$settings$appearance$de._(_root);
	@override late final Translations$settings$actions$de actions = Translations$settings$actions$de._(_root);
	@override late final Translations$settings$quickSettings$de quickSettings = Translations$settings$quickSettings$de._(_root);
	@override late final Translations$settings$terminalShortcuts$de terminalShortcuts = Translations$settings$terminalShortcuts$de._(_root);
	@override late final Translations$settings$mainTabs$de mainTabs = Translations$settings$mainTabs$de._(_root);
	@override late final Translations$settings$orchestration$de orchestration = Translations$settings$orchestration$de._(_root);
	@override late final Translations$settings$notifications$de notifications = Translations$settings$notifications$de._(_root);
	@override late final Translations$settings$appearanceSettings$de appearanceSettings = Translations$settings$appearanceSettings$de._(_root);
	@override late final Translations$settings$mcpForm$de mcpForm = Translations$settings$mcpForm$de._(_root);
	@override late final Translations$settings$saveStatus$de saveStatus = Translations$settings$saveStatus$de._(_root);
	@override late final Translations$settings$footerActions$de footerActions = Translations$settings$footerActions$de._(_root);
	@override late final Translations$settings$git$de git = Translations$settings$git$de._(_root);
	@override late final Translations$settings$apiKeys$de apiKeys = Translations$settings$apiKeys$de._(_root);
	@override late final Translations$settings$tasks$de tasks = Translations$settings$tasks$de._(_root);
	@override late final Translations$settings$agents$de agents = Translations$settings$agents$de._(_root);
	@override late final Translations$settings$permissions$de permissions = Translations$settings$permissions$de._(_root);
	@override late final Translations$settings$mcpServers$de mcpServers = Translations$settings$mcpServers$de._(_root);
	@override late final Translations$settings$quota$de quota = Translations$settings$quota$de._(_root);
	@override late final Translations$settings$browser$de browser = Translations$settings$browser$de._(_root);
	@override late final Translations$settings$workspaces$de workspaces = Translations$settings$workspaces$de._(_root);
	@override late final Translations$settings$about$de about = Translations$settings$about$de._(_root);
}

// Path: sidebar
class Translations$sidebar$de extends Translations$sidebar$en {
	Translations$sidebar$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$de projects = Translations$sidebar$projects$de._(_root);
	@override late final Translations$sidebar$app$de app = Translations$sidebar$app$de._(_root);
	@override late final Translations$sidebar$sessions$de sessions = Translations$sidebar$sessions$de._(_root);
	@override late final Translations$sidebar$tooltips$de tooltips = Translations$sidebar$tooltips$de._(_root);
	@override late final Translations$sidebar$navigation$de navigation = Translations$sidebar$navigation$de._(_root);
	@override late final Translations$sidebar$actions$de actions = Translations$sidebar$actions$de._(_root);
	@override late final Translations$sidebar$branding$de branding = Translations$sidebar$branding$de._(_root);
	@override late final Translations$sidebar$status$de status = Translations$sidebar$status$de._(_root);
	@override late final Translations$sidebar$time$de time = Translations$sidebar$time$de._(_root);
	@override late final Translations$sidebar$messages$de messages = Translations$sidebar$messages$de._(_root);
	@override late final Translations$sidebar$version$de version = Translations$sidebar$version$de._(_root);
	@override late final Translations$sidebar$search$de search = Translations$sidebar$search$de._(_root);
	@override late final Translations$sidebar$deleteConfirmation$de deleteConfirmation = Translations$sidebar$deleteConfirmation$de._(_root);
	@override late final Translations$sidebar$zones$de zones = Translations$sidebar$zones$de._(_root);
	@override late final Translations$sidebar$panel$de panel = Translations$sidebar$panel$de._(_root);
	@override late final Translations$sidebar$workspace$de workspace = Translations$sidebar$workspace$de._(_root);
	@override late final Translations$sidebar$recent$de recent = Translations$sidebar$recent$de._(_root);
	@override late final Translations$sidebar$tabs$de tabs = Translations$sidebar$tabs$de._(_root);
}

// Path: tasks
class Translations$tasks$de extends Translations$tasks$en {
	Translations$tasks$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$de notConfigured = Translations$tasks$notConfigured$de._(_root);
	@override late final Translations$tasks$gettingStarted$de gettingStarted = Translations$tasks$gettingStarted$de._(_root);
	@override late final Translations$tasks$setupModal$de setupModal = Translations$tasks$setupModal$de._(_root);
	@override late final Translations$tasks$helpGuide$de helpGuide = Translations$tasks$helpGuide$de._(_root);
	@override late final Translations$tasks$search$de search = Translations$tasks$search$de._(_root);
	@override late final Translations$tasks$filters$de filters = Translations$tasks$filters$de._(_root);
	@override late final Translations$tasks$sort$de sort = Translations$tasks$sort$de._(_root);
	@override late final Translations$tasks$views$de views = Translations$tasks$views$de._(_root);
	@override late final Translations$tasks$kanban$de kanban = Translations$tasks$kanban$de._(_root);
	@override late final Translations$tasks$buttons$de buttons = Translations$tasks$buttons$de._(_root);
	@override late final Translations$tasks$prd$de prd = Translations$tasks$prd$de._(_root);
	@override late final Translations$tasks$statuses$de statuses = Translations$tasks$statuses$de._(_root);
	@override late final Translations$tasks$priorities$de priorities = Translations$tasks$priorities$de._(_root);
	@override late final Translations$tasks$noMatchingTasks$de noMatchingTasks = Translations$tasks$noMatchingTasks$de._(_root);
	@override late final Translations$tasks$board$de board = Translations$tasks$board$de._(_root);
	@override late final Translations$tasks$card$de card = Translations$tasks$card$de._(_root);
	@override late final Translations$tasks$createTask$de createTask = Translations$tasks$createTask$de._(_root);
	@override late final Translations$tasks$list$de list = Translations$tasks$list$de._(_root);
	@override late final Translations$tasks$nextTask$de nextTask = Translations$tasks$nextTask$de._(_root);
	@override late final Translations$tasks$taskDetail$de taskDetail = Translations$tasks$taskDetail$de._(_root);
	@override late final Translations$tasks$toasts$de toasts = Translations$tasks$toasts$de._(_root);
}

// Path: knowledge
class Translations$knowledge$de extends Translations$knowledge$en {
	Translations$knowledge$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wissen';
	@override late final Translations$knowledge$tabs$de tabs = Translations$knowledge$tabs$de._(_root);
	@override late final Translations$knowledge$common$de common = Translations$knowledge$common$de._(_root);
	@override late final Translations$knowledge$actions$de actions = Translations$knowledge$actions$de._(_root);
	@override late final Translations$knowledge$dialog$de dialog = Translations$knowledge$dialog$de._(_root);
	@override late final Translations$knowledge$fields$de fields = Translations$knowledge$fields$de._(_root);
	@override late final Translations$knowledge$dashboard$de dashboard = Translations$knowledge$dashboard$de._(_root);
	@override late final Translations$knowledge$empty$de empty = Translations$knowledge$empty$de._(_root);
	@override late final Translations$knowledge$history$de history = Translations$knowledge$history$de._(_root);
	@override late final Translations$knowledge$priorities$de priorities = Translations$knowledge$priorities$de._(_root);
	@override late final Translations$knowledge$search$de search = Translations$knowledge$search$de._(_root);
	@override late final Translations$knowledge$links$de links = Translations$knowledge$links$de._(_root);
	@override late final Translations$knowledge$tags$de tags = Translations$knowledge$tags$de._(_root);
	@override late final Translations$knowledge$contextBudget$de contextBudget = Translations$knowledge$contextBudget$de._(_root);
	@override late final Translations$knowledge$critical$de critical = Translations$knowledge$critical$de._(_root);
	@override late final Translations$knowledge$errors$de errors = Translations$knowledge$errors$de._(_root);
	@override late final Translations$knowledge$graph$de graph = Translations$knowledge$graph$de._(_root);
	@override late final Translations$knowledge$importAll$de importAll = Translations$knowledge$importAll$de._(_root);
	@override late final Translations$knowledge$importSkills$de importSkills = Translations$knowledge$importSkills$de._(_root);
	@override late final Translations$knowledge$linkOptions$de linkOptions = Translations$knowledge$linkOptions$de._(_root);
	@override late final Translations$knowledge$migrate$de migrate = Translations$knowledge$migrate$de._(_root);
}

// Path: skills
class Translations$skills$de extends Translations$skills$en {
	Translations$skills$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$skills$addDialog$de addDialog = Translations$skills$addDialog$de._(_root);
	@override String deleteSkill({required Object name}) => '${name} löschen';
	@override late final Translations$skills$empty$de empty = Translations$skills$empty$de._(_root);
	@override late final Translations$skills$errors$de errors = Translations$skills$errors$de._(_root);
	@override late final Translations$skills$moveDialog$de moveDialog = Translations$skills$moveDialog$de._(_root);
	@override String moveSkill({required Object name}) => '${name} verschieben';
	@override String get projectLabel => 'Projekt';
	@override late final Translations$skills$scopes$de scopes = Translations$skills$scopes$de._(_root);
	@override late final Translations$skills$screen$de screen = Translations$skills$screen$de._(_root);
}

// Path: mcp
class Translations$mcp$de extends Translations$mcp$en {
	Translations$mcp$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$de form = Translations$mcp$form$de._(_root);
	@override late final Translations$mcp$install$de install = Translations$mcp$install$de._(_root);
	@override late final Translations$mcp$servers$de servers = Translations$mcp$servers$de._(_root);
	@override late final Translations$mcp$team$de team = Translations$mcp$team$de._(_root);
	@override late final Translations$mcp$tokens$de tokens = Translations$mcp$tokens$de._(_root);
}

// Path: terminal
class Translations$terminal$de extends Translations$terminal$en {
	Translations$terminal$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$actions$de actions = Translations$terminal$actions$de._(_root);
	@override late final Translations$terminal$authUrl$de authUrl = Translations$terminal$authUrl$de._(_root);
	@override late final Translations$terminal$errors$de errors = Translations$terminal$errors$de._(_root);
	@override late final Translations$terminal$fileLink$de fileLink = Translations$terminal$fileLink$de._(_root);
	@override late final Translations$terminal$paste$de paste = Translations$terminal$paste$de._(_root);
	@override late final Translations$terminal$shortcuts$de shortcuts = Translations$terminal$shortcuts$de._(_root);
	@override late final Translations$terminal$tabs$de tabs = Translations$terminal$tabs$de._(_root);
}

// Path: worktrees
class Translations$worktrees$de extends Translations$worktrees$en {
	Translations$worktrees$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get branchHint => 'Neuer Branch-Name (z. B. feature/login)';
	@override String branchingOff({required Object branch}) => 'Neuer Branch von ${branch}';
	@override String get cleanupDescription => 'Worktree entfernen und seinen Branch nach dem Merge löschen';
	@override String get created => 'Worktree erstellt';
	@override String get deleteBranchLabel => 'Branch ebenfalls löschen';
	@override String dirtyWarning({required Object count}) => 'Warnung: Dieser Worktree hat ${count} nicht committete Änderungen, die verloren gehen.';
	@override String get emptyDescription => 'Erstelle einen Worktree, um Feature-Arbeit oder Agent-Läufe zu isolieren.';
	@override String get emptyTitle => 'Keine Worktrees gefunden';
	@override String get forceRemoveLabel => 'Entfernen erzwingen (Änderungen verwerfen)';
	@override String headDetachedAt({required Object sha}) => 'HEAD losgelöst bei ${sha}';
	@override String get mainBadge => 'main';
	@override String mergeDescription({required Object branch}) => 'Änderungen in ${branch} mergen.';
	@override String mergeTitle({required Object branch}) => '${branch} mergen';
	@override String merged({required Object branch}) => 'Worktree in ${branch} gemergt';
	@override String opened({required Object branch}) => 'Worktree geöffnet: ${branch}';
	@override String get portHint => 'Port (optional, z. B. 3000)';
	@override String get removeDescription => 'Dies löscht den Worktree-Ordner. Verknüpfte Projekte werden archiviert.';
	@override String removeTitle({required Object branch}) => 'Worktree ${branch} entfernen?';
	@override String get removed => 'Worktree entfernt';
	@override String get runButton => 'Ausführen';
	@override String get runHint => 'Befehl ausführen (z. B. npm run dev)';
	@override String get runRunning => 'läuft';
	@override String runRunningWithPort({required Object port}) => 'läuft :${port}';
	@override String get scripts => 'Skripte';
	@override String get scriptsSaved => 'Skript-Konfiguration gespeichert';
	@override String get serverLabel => 'Server: ';
	@override String get setupHint => 'Setup-Befehl (z. B. npm install)';
	@override String get setupLabel => 'Setup: ';
	@override String get squashDescription => 'Alle Commits zu einem einzigen Commit zusammenfassen';
	@override String get stopButton => 'Stoppen';
}

// Path: quota
class Translations$quota$de extends Translations$quota$en {
	Translations$quota$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$agents$de agents = Translations$quota$agents$de._(_root);
	@override late final Translations$quota$chart$de chart = Translations$quota$chart$de._(_root);
	@override late final Translations$quota$config$de config = Translations$quota$config$de._(_root);
	@override late final Translations$quota$overview$de overview = Translations$quota$overview$de._(_root);
	@override late final Translations$quota$section$de section = Translations$quota$section$de._(_root);
}

// Path: scheduler
class Translations$scheduler$de extends Translations$scheduler$en {
	Translations$scheduler$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Wird geprüft…';
	@override String get cronHint => 'Cron (Minute Stunde Tag Monat Wochentag) — z. B. 0 9 * * *';
	@override String deleteMessage({required Object id}) => 'Dies entfernt den wiederkehrenden Auftrag ${id}. Vorhandene Sitzungen bleiben erhalten.';
	@override String get deleteTitle => 'Zeitplan löschen?';
	@override String get editTitle => 'Zeitplan bearbeiten';
	@override String get newLabel => 'Neu';
	@override String nextIn({required Object time}) => 'nächster Lauf in ${time}';
	@override String get promptHint => 'Prompt für den Agenten';
	@override String get runs => 'Läufe';
	@override String session({required Object id}) => 'Sitzung ${id}';
	@override String get worktree => 'Worktree';
}

// Path: notifications
class Translations$notifications$de extends Translations$notifications$en {
	Translations$notifications$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'ddagent Flutter';
	@override late final Translations$notifications$errors$de errors = Translations$notifications$errors$de._(_root);
}

// Path: serverConnect
class Translations$serverConnect$de extends Translations$serverConnect$en {
	Translations$serverConnect$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get connect => 'Verbinden';
	@override String get connecting => 'Verbinde…';
	@override String get changeServer => 'Server wechseln';
	@override String connectionFailed({required Object error}) => 'Verbindung fehlgeschlagen (${error})';
	@override String get enterUrl => 'Server-URL eingeben';
	@override late final Translations$serverConnect$local$de local = Translations$serverConnect$local$de._(_root);
	@override String get subtitle => 'Mit deinem ddagent-Server verbinden';
}

// Path: voice
class Translations$voice$de extends Translations$voice$en {
	Translations$voice$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get apiKeySaved => 'API-Schlüssel (gespeichert, zum Ersetzen eingeben)';
	@override String get preview => 'Vorschau';
	@override String get saveFailed => 'STT-Konfiguration konnte nicht gespeichert werden';
	@override String get settingsSaved => 'Spracheingabe-Einstellungen gespeichert';
}

// Path: preview
class Translations$preview$de extends Translations$preview$en {
	Translations$preview$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get embeddedWebOnly => 'Die eingebettete Vorschau ist im Web-Build verfügbar';
	@override String get startDevServerHint => 'Starte einen Dev-Server (npm run dev, flutter run -d web-server…)\nund sein Port erscheint hier.';
}

// Path: sharedContext
class Translations$sharedContext$de extends Translations$sharedContext$en {
	Translations$sharedContext$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Gemeinsame Notizen';
}

// Path: collab
class Translations$collab$de extends Translations$collab$en {
	Translations$collab$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get copyToken => 'Token kopieren';
	@override String get createInvite => 'Einladung erstellen';
	@override String get invite => 'Einladen';
	@override String get inviteTeammate => 'Teammitglied einladen';
	@override late final Translations$collab$roles$de roles = Translations$collab$roles$de._(_root);
	@override String get shareTokenHint => 'Teile diesen Einladungs-Token — er wird nur einmal angezeigt und läuft in 72 Std. ab:';
	@override String get team => 'Team';
}

// Path: browser
class Translations$browser$de extends Translations$browser$en {
	Translations$browser$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Agenten-Browser';
	@override String get viewError => 'Fehler in der Browser-Ansicht';
	@override String get web => 'Web';
}

// Path: projects
class Translations$projects$de extends Translations$projects$en {
	Translations$projects$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get archive => 'Archivieren';
	@override String archivedSection({required Object count}) => 'Archiviert (${count})';
	@override String get clone => 'Klonen';
	@override String get cloneFailed => 'Klonen fehlgeschlagen';
	@override String get cloneFinished => 'Klonen abgeschlossen. Projektliste wird aktualisiert…';
	@override String get cloneRepository => 'Repository klonen';
	@override String get deletePermanently => 'Endgültig löschen';
	@override String deleteProjectMessage({required Object name}) => 'Entfernt „${name}“ endgültig, einschließlich aller Sitzungen und des gespeicherten Verlaufs (JSONL wird gelöscht). Dies kann nicht rückgängig gemacht werden.';
	@override String get deleteProjectTitle => 'Projekt löschen?';
	@override String get destinationPath => 'Zielpfad';
	@override String get destinationPathRequired => 'Zielpfad ist erforderlich';
	@override String get displayNameOptional => 'Anzeigename (optional)';
	@override String get failedToLoadTokens => 'GitHub-Token konnten nicht geladen werden';
	@override String get githubTokenOptional => 'GitHub-Token (optional)';
	@override String get newer => 'Neuer';
	@override String get older => 'Älter';
	@override String get projectArchived => 'Projekt archiviert';
	@override String get projectDeleted => 'Projekt gelöscht';
	@override String get projectRenamed => 'Projekt umbenannt';
	@override String get projectRestored => 'Projekt wiederhergestellt';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get repositoryCloned => 'Repository geklont';
	@override String get repositoryUrlRequired => 'Repository-URL ist erforderlich';
	@override String get restore => 'Wiederherstellen';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} Sitzung',
		other: '${count} Sitzungen',
	);
	@override String get unknown => 'Unbekannt';
	@override String usingStoredToken({required Object name}) => 'Gespeicherter Token wird verwendet: ${name}';
}

// Path: sessions
class Translations$sessions$de extends Translations$sessions$en {
	Translations$sessions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$sessions$activity$de activity = Translations$sessions$activity$de._(_root);
	@override late final Translations$sessions$age$de age = Translations$sessions$age$de._(_root);
	@override String get archive => 'Archivieren';
	@override String get archivedSessions => 'Archivierte Sitzungen';
	@override String get autoOrchestrator => 'Auto (Orchestrator)';
	@override String get compareWith => 'Vergleichen mit…';
	@override String createFailed({required Object error}) => 'Sitzung konnte nicht erstellt werden: ${error}';
	@override String deleteSessionMessage({required Object name}) => 'Entfernt „${name}“ und sein Transkript. Dies kann nicht rückgängig gemacht werden.';
	@override String get newSessionProvider => 'Neue Sitzung — Anbieter';
	@override String get noRecentSessions => 'Keine letzten Sitzungen';
	@override String get noSessions => 'Keine Sitzungen';
	@override String get projectPath => 'Projektpfad';
	@override String get rename => 'Umbenennen';
	@override late final Translations$sessions$toasts$de toasts = Translations$sessions$toasts$de._(_root);
}

// Path: git
class Translations$git$de extends Translations$git$en {
	Translations$git$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get aiButton => '✦ KI';
	@override late final Translations$git$checkpoints$de checkpoints = Translations$git$checkpoints$de._(_root);
	@override String get commitCreated => 'Commit erstellt';
	@override String get commitMessage => 'Commit-Nachricht';
	@override String get deleteFile => 'Datei löschen';
	@override String get hunkStage => '+ Hunk';
	@override String get hunkUnstage => '− Hunk';
	@override String get largeDiff => 'Große Diff-Vorschau: Die Darstellung ist begrenzt, damit der Tab reaktionsschnell bleibt.';
	@override String loadDiffFailed({required Object error}) => 'Diff konnte nicht geladen werden: ${error}';
	@override String get noBranch => 'kein Branch';
	@override String get noDiff => 'Kein Diff verfügbar';
	@override String get selectProject => 'Projekt auswählen';
	@override String get splitDiff => 'Nebeneinander';
	@override String get stageHunk => 'Hunk stagen';
	@override String get stagedChanges => 'Vorgemerkte Änderungen';
	@override String get statusStaged => 'Vorgemerkt';
	@override String get switchBranch => 'Branch wechseln';
	@override String get unifiedDiff => 'Einheitlich';
	@override String get unstageHunk => 'Hunk unstagen';
}

// Path: kanban
class Translations$kanban$de extends Translations$kanban$en {
	Translations$kanban$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$de card = Translations$kanban$card$de._(_root);
	@override late final Translations$kanban$comments$de comments = Translations$kanban$comments$de._(_root);
	@override late final Translations$kanban$details$de details = Translations$kanban$details$de._(_root);
	@override late final Translations$kanban$dialog$de dialog = Translations$kanban$dialog$de._(_root);
	@override late final Translations$kanban$empty$de empty = Translations$kanban$empty$de._(_root);
	@override String get saveFailed => 'Karte konnte nicht gespeichert werden';
	@override late final Translations$kanban$time$de time = Translations$kanban$time$de._(_root);
}

// Path: onboarding
class Translations$onboarding$de extends Translations$onboarding$en {
	Translations$onboarding$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$onboarding$agents$de agents = Translations$onboarding$agents$de._(_root);
	@override String get completeSetup => 'Einrichtung abschließen';
	@override late final Translations$onboarding$errors$de errors = Translations$onboarding$errors$de._(_root);
	@override String get gitHint => 'Wird für Commits verwendet, die von ddagent-Sitzungen erstellt werden.';
	@override late final Translations$onboarding$mcp$de mcp = Translations$onboarding$mcp$de._(_root);
}

// Path: fileTree
class Translations$fileTree$de extends Translations$fileTree$en {
	Translations$fileTree$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get browseServerFilesystem => 'Server-Dateisystem durchsuchen';
	@override String get chooseFolder => 'Ordner wählen';
	@override String get copyContents => 'Inhalt kopieren';
	@override String get noFiles => 'Keine Dateien';
	@override late final Translations$fileTree$search$de search = Translations$fileTree$search$de._(_root);
	@override late final Translations$fileTree$titles$de titles = Translations$fileTree$titles$de._(_root);
	@override String get uploadHere => 'Hier hochladen';
	@override String get uploadTo => 'Hochladen nach';
	@override String uploadedCount({required Object count}) => '${count} Datei(en) hochgeladen';
	@override String get newName => 'Neuer Name';
	@override String notRegisteredProject({required Object path}) => 'Kein registriertes Projekt: ${path}';
	@override String get showGitignoredFiles => 'Gitignorierte Dateien anzeigen';
	@override String get hideGitignoredFiles => 'Gitignorierte Dateien ausblenden';
	@override String get downloadUnsupportedOnWeb => 'Download im Web nicht unterstützt';
	@override String get saveToPath => 'Unter Pfad speichern';
	@override String savedTo({required Object path}) => 'Gespeichert unter ${path}';
}

// Path: workspace
class Translations$workspace$de extends Translations$workspace$en {
	Translations$workspace$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get archivedWorkspaceName => 'Archiviert';
	@override String get closePane => 'Bereich schließen';
	@override String get closeSearch => 'Suche schließen';
	@override String get deleteSessionNotice => 'Entfernt die Sitzung und ihr Transkript. Kann nicht rückgängig gemacht werden.';
	@override String get exportChat => 'Chat exportieren';
	@override String get jumpToSession => 'Zur Sitzung springen…';
	@override String get newChatProvider => 'Neuer Chat — Anbieter';
	@override String get nextMatch => 'Nächster Treffer';
	@override String get previousMatch => 'Vorheriger Treffer';
	@override String get searchTranscript => 'Transkript durchsuchen';
	@override String sendTo({required Object count}) => 'An ${count} senden';
	@override String accountWithLabel({required Object label}) => 'Standard · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Beende den Lauf, bevor du den Arbeitsbereich wechselst';
	@override String get restored => 'Arbeitsbereich wiederhergestellt';
	@override String get maximizePane => 'Bereich maximieren';
	@override String get restorePanes => 'Bereiche wiederherstellen';
	@override String get reviewChangedFiles => 'Geänderte Dateien überprüfen';
}

// Path: auth.login
class Translations$auth$login$de extends Translations$auth$login$en {
	Translations$auth$login$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Willkommen zurück';
	@override String get description => 'Meld dich bei deinem ddagent-Konto an';
	@override String get username => 'Benutzername';
	@override String get password => 'Passwort';
	@override String get submit => 'Anmelden';
	@override String get loading => 'Wird angemeldet...';
	@override late final Translations$auth$login$errors$de errors = Translations$auth$login$errors$de._(_root);
	@override late final Translations$auth$login$placeholders$de placeholders = Translations$auth$login$placeholders$de._(_root);
}

// Path: auth.register
class Translations$auth$register$de extends Translations$auth$register$en {
	Translations$auth$register$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konto erstellen';
	@override String get username => 'Benutzername';
	@override String get password => 'Passwort';
	@override String get confirmPassword => 'Passwort bestätigen';
	@override String get submit => 'Konto erstellen';
	@override String get loading => 'Konto wird erstellt...';
	@override late final Translations$auth$register$errors$de errors = Translations$auth$register$errors$de._(_root);
}

// Path: auth.logout
class Translations$auth$logout$de extends Translations$auth$logout$en {
	Translations$auth$logout$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Abmelden';
	@override String get confirm => 'Möchtest du dich wirklich abmelden?';
	@override String get button => 'Abmelden';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$de extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Kopieren';
	@override String get copied => 'Kopiert';
	@override String get copyCode => 'Code kopieren';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$de extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Nachricht kopieren';
	@override String get copied => 'Nachricht kopiert';
	@override String get failed => 'Kopieren fehlgeschlagen';
	@override String get selectFormat => 'Kopierformat auswählen';
	@override String get copyAsMarkdown => 'Als Markdown kopieren';
	@override String get copyAsText => 'Als Text kopieren';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$de extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get user => 'Benutzer:in';
	@override String get error => 'Fehler';
	@override String get tool => 'Werkzeug';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
}

// Path: chat.tools
class Translations$chat$tools$de extends Translations$chat$tools$en {
	Translations$chat$tools$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Werkzeugeinstellungen';
	@override String get error => 'Werkzeugfehler';
	@override String get result => 'Werkzeugergebnis';
	@override String get viewParams => 'Eingabeparameter anzeigen';
	@override String get viewRawParams => 'Rohe Parameter anzeigen';
	@override String get viewDiff => 'Bearbeitungs-Diff anzeigen für';
	@override String get creatingFile => 'Neue Datei wird erstellt:';
	@override String get updatingTodo => 'Aufgabenliste wird aktualisiert';
	@override String get read => 'Gelesen';
	@override String get readFile => 'Datei lesen';
	@override String get updateTodo => 'Aufgabenliste aktualisieren';
	@override String get readTodo => 'Aufgabenliste lesen';
	@override String get searchResults => 'Ergebnisse';
	@override String get todoReadLabel => 'TodoRead liest die Aufgabenliste';
}

// Path: chat.search
class Translations$chat$search$de extends Translations$chat$search$en {
	Translations$chat$search$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '${count} ${type} gefunden';
	@override String get file => 'Datei';
	@override String get files => 'Dateien';
	@override String get pattern => 'Muster:';
	@override String get kIn => 'in:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$de extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Datei erfolgreich aktualisiert';
	@override String get created => 'Datei erfolgreich erstellt';
	@override String get written => 'Datei erfolgreich geschrieben';
	@override String get diff => 'Diff';
	@override String get newFile => 'Neue Datei';
	@override String get viewContent => 'Dateiinhalt anzeigen';
	@override String viewFullOutput({required Object count}) => 'Vollständige Ausgabe anzeigen (${count} Zeichen)';
	@override String get contentDisplayed => 'Der Dateiinhalt wird in der Diff-Ansicht oben angezeigt';
}

// Path: chat.interactive
class Translations$chat$interactive$de extends Translations$chat$interactive$en {
	Translations$chat$interactive$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Interaktive Eingabeaufforderung';
	@override String get waiting => 'Warte auf deine Antwort in der CLI';
	@override String get instruction => 'Bitte wähl eine Option in deinem Terminal, in dem Claude läuft.';
	@override String selectedOption({required Object number}) => '✓ Claude hat Option ${number} ausgewählt';
	@override String get instructionDetail => 'In der CLI würdest du diese Option interaktiv mit den Pfeiltasten oder durch Eingabe der Nummer auswählen.';
}

// Path: chat.thinking
class Translations$chat$thinking$de extends Translations$chat$thinking$en {
	Translations$chat$thinking$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Denkt nach...';
	@override String get emoji => '💭 Denkt nach...';
}

// Path: chat.json
class Translations$chat$json$de extends Translations$chat$json$en {
	Translations$chat$json$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSON-Antwort';
}

// Path: chat.permissions
class Translations$chat$permissions$de extends Translations$chat$permissions$en {
	Translations$chat$permissions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => 'Berechtigung für ${tool} erteilen';
	@override String get added => 'Berechtigung hinzugefügt';
	@override String addTo({required Object entry}) => 'Fügt ${entry} zu erlaubten Werkzeugen hinzu.';
	@override String get retry => 'Berechtigung gespeichert. Wiederhole die Anfrage, um das Werkzeug zu verwenden.';
	@override String get error => 'Berechtigungen konnten nicht aktualisiert werden. Bitte erneut versuchen.';
	@override String get openSettings => 'Einstellungen öffnen';
	@override String get allow => 'Zulassen';
	@override String allowAll({required Object count}) => 'Alle zulassen (${count})';
	@override String get allowWithChanges => 'Mit Änderungen zulassen';
	@override String get always => 'Immer';
	@override String get deny => 'Ablehnen';
	@override String get editAndAllow => 'Bearbeiten & zulassen';
	@override String get editInput => 'Eingabe bearbeiten';
	@override String get invalidJson => 'Ungültiges JSON';
	@override String get reject => 'Zurückweisen';
}

// Path: chat.todo
class Translations$chat$todo$de extends Translations$chat$todo$en {
	Translations$chat$todo$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Aufgabenliste wurde erfolgreich aktualisiert';
	@override String get current => 'Aktuelle Aufgabenliste';
}

// Path: chat.plan
class Translations$chat$plan$de extends Translations$chat$plan$en {
	Translations$chat$plan$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Implementierungsplan anzeigen';
	@override String get title => 'Implementierungsplan';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$de extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Claude-Nutzungslimit erreicht. Dein Limit wird um **${time} ${timezone}** zurückgesetzt - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$de extends Translations$chat$codex$en {
	Translations$chat$codex$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Berechtigungsmodus';
	@override late final Translations$chat$codex$modes$de modes = Translations$chat$codex$modes$de._(_root);
	@override late final Translations$chat$codex$descriptions$de descriptions = Translations$chat$codex$descriptions$de._(_root);
	@override String get technicalDetails => 'Technische Details';
}

// Path: chat.input
class Translations$chat$input$de extends Translations$chat$input$en {
	Translations$chat$input$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => '/ für Befehle, @ für Dateien eingeben oder ${provider} etwas fragen...';
	@override String get placeholderDefault => 'Nachricht eingeben...';
	@override String get disabled => 'Eingabe deaktiviert';
	@override String get attachFiles => 'Dateien anhängen';
	@override String get attachImages => 'Bilder anhängen';
	@override String get send => 'Senden';
	@override String get stop => 'Stoppen';
	@override late final Translations$chat$input$hintText$de hintText = Translations$chat$input$hintText$de._(_root);
	@override String get clickToChangeMode => 'Klicken, um den Berechtigungsmodus zu ändern';
	@override String get showAllCommands => 'Alle Befehle anzeigen';
	@override String get clearInput => 'Eingabe leeren';
	@override String get scrollToBottom => 'Nach unten scrollen';
	@override String get attachFilesDesc => 'Fotos, Dateien oder Dokumente hochladen';
	@override String get takePhoto => 'Foto aufnehmen';
	@override String get takePhotoDesc => 'Kamera zum Aufnehmen eines Fotos verwenden';
	@override String get moreTools => 'Mehr Werkzeuge';
	@override String get commandsDesc => 'Tastenkürzel und Befehle erkunden';
	@override String get clearInputDesc => 'Aktuellen Text verwerfen';
	@override String get newMessage => 'Neue Nachricht';
	@override String get newMessages => 'Neue Nachrichten';
	@override late final Translations$chat$input$queue$de queue = Translations$chat$input$queue$de._(_root);
	@override String get autoContinueTasks => 'Auto-Fortsetzen';
	@override String get autoContinueTasksTooltip => 'Aktivieren, damit Devin automatisch mit der nächsten Task-Master-Aufgabe fortfährt';
	@override late final Translations$chat$input$offlineQueue$de offlineQueue = Translations$chat$input$offlineQueue$de._(_root);
	@override String cameraUnavailable({required Object error}) => 'Kamera nicht verfügbar: ${error}';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$de extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'KI-Assistent wählen';
	@override String get description => 'Anbieter auswählen, um eine neue Unterhaltung zu starten';
	@override String get selectModel => 'Modell auswählen';
	@override late final Translations$chat$providerSelection$providerInfo$de providerInfo = Translations$chat$providerSelection$providerInfo$de._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$de readyPrompt = Translations$chat$providerSelection$readyPrompt$de._(_root);
	@override String pressToSearch({required Object shortcut}) => 'Drücke <kbd>${shortcut}</kbd>, um Sitzungen, Dateien und Commits zu durchsuchen';
	@override String get workspace => 'Arbeitsbereich';
	@override String get noWorkspace => 'Keiner';
	@override String get clickToChangeWorkspace => 'Klicken, um Arbeitsbereich zu wechseln';
	@override String get chooseWorkspace => 'Arbeitsbereich wählen';
	@override String get searchWorkspaces => 'Arbeitsbereiche suchen...';
	@override String get noWorkspacesFound => 'Keine Arbeitsbereiche gefunden.';
	@override String get all => 'Alle';
	@override String get free => 'Kostenlos';
	@override String get noModelsFound => 'Keine Modelle gefunden.';
	@override String get paid => 'Kostenpflichtig';
	@override String get searchModels => 'Modelle suchen...';
	@override String get addModel => 'Modell hinzufügen';
	@override String get chooseModel => 'Modell wählen';
	@override String get chooseModelDescription => 'Integrierte und benutzerdefinierte Modelle in einer Liste';
	@override String get clickToChange => 'Klicken, um Modell zu ändern';
	@override String get favorites => 'Favoriten';
	@override String get loadingModels => 'Modelle werden geladen…';
	@override String get manageModels => 'Modelle verwalten';
	@override String get refresh => 'Modelle aktualisieren';
}

// Path: chat.session
class Translations$chat$session$de extends Translations$chat$session$en {
	Translations$chat$session$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$de kContinue = Translations$chat$session$kContinue$de._(_root);
	@override late final Translations$chat$session$loading$de loading = Translations$chat$session$loading$de._(_root);
	@override late final Translations$chat$session$messages$de messages = Translations$chat$session$messages$de._(_root);
	@override String get deleteConfirm => 'Entfernt die Sitzung und ihr Transkript. Kann nicht rückgängig gemacht werden.';
	@override String get finishRunBeforeWorkspaceChange => 'Beende den Lauf, bevor du den Arbeitsbereich wechselst';
}

// Path: chat.shell
class Translations$chat$shell$de extends Translations$chat$shell$en {
	Translations$chat$shell$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$de selectProject = Translations$chat$shell$selectProject$de._(_root);
	@override late final Translations$chat$shell$status$de status = Translations$chat$shell$status$de._(_root);
	@override late final Translations$chat$shell$actions$de actions = Translations$chat$shell$actions$de._(_root);
	@override String get loading => 'Terminal wird geladen...';
	@override String get connecting => 'Verbindung zum Terminal wird hergestellt...';
	@override String get startSession => 'Neue Claude-Sitzung starten';
	@override String resumeSession({required Object displayName}) => 'Sitzung fortsetzen: ${displayName}...';
	@override String runCommand({required Object command, required Object projectName}) => '${command} in ${projectName} ausführen';
	@override String startCli({required Object projectName}) => 'Claude CLI wird in ${projectName} gestartet';
	@override String get defaultCommand => 'Befehl';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$de extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$de actions = Translations$chat$claudeStatus$actions$de._(_root);
	@override late final Translations$chat$claudeStatus$state$de state = Translations$chat$claudeStatus$state$de._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$de elapsed = Translations$chat$claudeStatus$elapsed$de._(_root);
	@override late final Translations$chat$claudeStatus$controls$de controls = Translations$chat$claudeStatus$controls$de._(_root);
	@override late final Translations$chat$claudeStatus$providers$de providers = Translations$chat$claudeStatus$providers$de._(_root);
	@override String get stop => 'Stoppen';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} Hintergrundaufgabe läuft',
		other: '${count} Hintergrundaufgaben laufen',
	);
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$de extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'Wähl ein Projekt, um mit ${provider} zu chatten';
}

// Path: chat.tasks
class Translations$chat$tasks$de extends Translations$chat$tasks$en {
	Translations$chat$tasks$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Nächste Aufgabe starten';
}

// Path: chat.voice
class Translations$chat$voice$de extends Translations$chat$voice$en {
	Translations$chat$voice$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Antworten vorlesen';
	@override String get autoReadOn => 'Antworten vorlesen: an';
	@override String get autoReadOff => 'Antworten vorlesen: aus';
	@override String get autoReadVoice => 'Stimme zum Vorlesen';
	@override String get autoReadVoiceAuto => 'Automatische Stimme';
	@override String get autoReadPreview => 'So werden Antworten klingen.';
	@override String get speakMessage => 'Vorlesen';
	@override String get stopSpeaking => 'Vorlesen stoppen';
}

// Path: chat.composer
class Translations$chat$composer$de extends Translations$chat$composer$en {
	Translations$chat$composer$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Werkzeuge & Aktionen';
	@override String get toolsAndActionsDesc => 'Werkzeuge und Steuerungen für den Chat-Editor';
	@override String get reasoning => 'Schlussfolgert';
	@override String get model => 'Modell';
	@override String get effortDefault => 'Standard';
	@override String get loadingModels => 'Modelle werden geladen…';
	@override String get modelMenu => 'Modell und Reasoning-Aufwand wählen';
	@override String permissionHeading({required Object provider}) => 'Wie sollen ${provider}-Aktionen genehmigt werden?';
	@override String get favorites => 'Favoriten';
}

// Path: chat.splitSession
class Translations$chat$splitSession$de extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Sitzung teilen';
	@override String get close => 'Geteilte Sitzung schließen';
	@override String get selectSession => 'Sitzung zum Vergleichen wählen';
	@override String get noOtherSessions => 'Keine weiteren Sitzungen verfügbar';
	@override String get newSessionOption => '+ Neue Sitzung in geteilter Ansicht';
	@override String currentProjectGroup({required Object name}) => 'Aktuelles Projekt (${name})';
	@override String get otherProjectsGroup => 'Andere Projekte';
	@override String get recentSessionsGroup => 'Letzte Sitzungen';
	@override String get startNewSession => 'Neue Sitzung in geteilter Ansicht starten';
	@override String get selectFromList => 'Sitzung aus der Liste vorhandener Sitzungen wählen';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$de extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sitzung auswählen';
	@override String get searchPlaceholder => 'Sitzungen suchen...';
	@override String get clearSearch => 'Suche löschen';
	@override String get newChat => '+ Neuer Chat';
	@override String get archivedToggle => 'Archiviert';
	@override String get changeSession => 'Sitzung wechseln';
	@override String get archivedLoading => 'Archivierte Sitzungen werden geladen...';
	@override String get archivedError => 'Archivierte Sitzungen konnten nicht geladen werden';
	@override String get archivedEmpty => 'Keine archivierten Sitzungen';
	@override String get archivedProjectOnly => 'Arbeitsbereich archiviert — wiederherstellen, um seine Sitzungen zu sehen.';
	@override String get emptySearch => 'Keine Sitzungen entsprechen der Suche';
	@override String get restore => 'Wiederherstellen';
	@override String get restoreSession => 'Sitzung wiederherstellen';
	@override String get restoreProject => 'Arbeitsbereich wiederherstellen';
	@override String get restoreSessionFailed => 'Wiederherstellen der Sitzung fehlgeschlagen. Bitte erneut versuchen.';
	@override String get restoreProjectFailed => 'Wiederherstellen des Arbeitsbereichs fehlgeschlagen. Bitte erneut versuchen.';
	@override String get archiveFailed => 'Archivieren der Sitzung fehlgeschlagen. Bitte erneut versuchen.';
	@override String get deleteFailed => 'Löschen der Sitzung fehlgeschlagen. Bitte erneut versuchen.';
	@override String get running => 'Sitzung läuft';
	@override String get unread => 'Ungelesen — mit neuer Ausgabe beendet';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$de extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Chat-Bereich hinzufügen';
	@override String get addBrowser => 'Browser-Bereich hinzufügen';
	@override String get addTerminal => 'Terminal-Bereich hinzufügen';
	@override String get overview => 'Alle Bereiche anzeigen';
	@override String get exitFocusMode => 'Fokusmodus beenden (Strg+Umschalt+F)';
	@override String get focusMode => 'Fokusmodus (Strg+Umschalt+F)';
	@override String get browseSessions => 'Sitzungsliste öffnen';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$de extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Übersicht geteilter Bereiche';
	@override String count({required Object count}) => '${count} Bereiche';
	@override String get close => 'Übersicht schließen';
	@override String get question => 'FRAGE — Eingabe erforderlich';
	@override String get processing => 'VERARBEITUNG';
	@override String get idle => 'Inaktiv';
	@override String get active => 'Aktiv';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$de extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} benötigt deine Eingabe';
	@override String get answerHint => 'Antwort eingeben…';
	@override String get other => 'Andere…';
	@override String get skip => 'Überspringen';
}

// Path: chat.attachments
class Translations$chat$attachments$de extends Translations$chat$attachments$en {
	Translations$chat$attachments$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Download fehlgeschlagen — klicken zum Wiederholen';
	@override String get fileAttachment => 'Dateianhang';
	@override String download({required Object name}) => '${name} herunterladen';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$de extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Erstelle Snapshot…';
	@override String get revertChanges => 'Dateien auf letzten Checkpoint zurücksetzen';
	@override String get undo => 'Checkpoint rückgängig machen';
	@override String get beforeAiTurn => 'vor dem KI-Schritt';
}

// Path: chat.common
class Translations$chat$common$de extends Translations$chat$common$en {
	Translations$chat$common$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get close => 'Schließen';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$de extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Aufgabe';
	@override String get saved => 'Gespeichert';
	@override String get saving => 'Speichere...';
	@override String get taskShort => 'TASK';
	@override String get addToTask => 'Zu TaskMaster hinzufügen';
	@override String get added => 'Zu TaskMaster hinzugefügt';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$de extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Tokenverbrauch der Sitzung anzeigen';
	@override String get title => 'Tokenverbrauch';
}

// Path: chat.tool
class Translations$chat$tool$de extends Translations$chat$tool$en {
	Translations$chat$tool$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(noch keine Ausgabe — das Tool hat ein leeres Ergebnis zurückgegeben)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$de extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Abo-Limits';
	@override String get noData => 'Keine Abodaten für dieses Modell';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$de extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Verarbeitung…';
	@override String get switchSession => 'Sitzung wechseln';
}

// Path: chat.broadcast
class Translations$chat$broadcast$de extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => 'Orchestratoren auswählen';
	@override String get orchestratorsOnly => 'Nur Orchestratoren';
	@override String get noOrchestrators => 'Keine Orchestrator-Sitzungen verfügbar';
}

// Path: chat.changes
class Translations$chat$changes$de extends Translations$chat$changes$en {
	Translations$chat$changes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Keine Dateiänderungen';
	@override String get failedToLoad => 'Änderungen konnten nicht geladen werden';
}

// Path: chat.commandResult
class Translations$chat$commandResult$de extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$de fallback = Translations$chat$commandResult$fallback$de._(_root);
	@override String get filterCommands => 'Befehle filtern...';
	@override String searchModels({required Object provider}) => '${provider}-Modelle suchen...';
}

// Path: chat.commands
class Translations$chat$commands$de extends Translations$chat$commands$en {
	Translations$chat$commands$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'Befehl ausführen?';
	@override String get executionCancelled => 'Befehlsausführung abgebrochen';
}

// Path: chat.export
class Translations$chat$export$de extends Translations$chat$export$en {
	Translations$chat$export$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Sitzung ${id}';
	@override String get pdfFailed => 'PDF-Export fehlgeschlagen';
	@override String get transcriptDownloaded => 'Transkript heruntergeladen';
	@override String savedTo({required Object path}) => 'Gespeichert: ${path}';
}

// Path: chat.message
class Translations$chat$message$de extends Translations$chat$message$en {
	Translations$chat$message$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Verdichtete Zusammenfassung';
	@override String get rawView => 'Rohansicht';
	@override String get resendHint => 'Aus dem Chat-Editor erneut senden';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$de extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String deleteTooltip({required Object name}) => '${name} löschen';
	@override String editTooltip({required Object name}) => '${name} bearbeiten';
	@override String get enterNameAndId => 'Gib sowohl einen Modellnamen als auch eine Modell-ID ein.';
	@override String get idNoSpaces => 'Modell-IDs dürfen keine Leerzeichen enthalten.';
	@override String get setAsDefault => 'Als Standard festlegen';
	@override String get defaultModel => 'Standardmodell';
}

// Path: chat.pinFile
class Translations$chat$pinFile$de extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get action => 'Anheften';
	@override String get pathHint => 'path/to/file.ext';
	@override String get title => 'Datei anheften';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$de extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'Berechtigungsanfrage · ${tool}';
	@override String get question => 'Frage';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$de extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Änderungen';
	@override String get previousChange => 'Vorherige Änderung';
	@override String get nextChange => 'Nächste Änderung';
	@override String get hideDiff => 'Diff-Hervorhebung ausblenden';
	@override String get showDiff => 'Diff-Hervorhebung anzeigen';
	@override String get settings => 'Editor-Einstellungen';
	@override String get collapse => 'Editor einklappen';
	@override String get expand => 'Editor auf volle Breite erweitern';
	@override String get diffMerge => 'Diff / Merge';
	@override String get previewInBrowser => 'Im Browser ansehen';
	@override String get reload => 'Von der Festplatte neu laden';
	@override String get toggleDock => 'Datei-Dock umschalten';
}

// Path: codeEditor.header
class Translations$codeEditor$header$de extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Änderungen werden angezeigt';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$de extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Dateipfad kopieren';
	@override String get pathCopied => 'Dateipfad kopiert';
	@override String get download => 'Datei herunterladen';
	@override String get save => 'Speichern';
	@override String get saving => 'Wird gespeichert...';
	@override String get saved => 'Gespeichert!';
	@override String get exitFullscreen => 'Vollbild beenden';
	@override String get fullscreen => 'Vollbild';
	@override String get close => 'Schließen';
	@override String get previewMarkdown => 'Markdown-Vorschau';
	@override String get editMarkdown => 'Markdown bearbeiten';
	@override String get pinFile => 'Datei an Kontext anheften';
	@override String get unpinFile => 'Datei vom Kontext lösen';
	@override String get previewHtml => 'HTML-Vorschau in neuem Tab öffnen';
	@override String get retry => 'Wiederholen';
	@override String get saveAll => 'Alle speichern';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$de extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Zeilen:';
	@override String get characters => 'Zeichen:';
	@override String get shortcuts => 'Strg+S zum Speichern • Esc zum Schließen';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$de extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Binärdatei';
	@override String message({required Object fileName}) => 'Die Datei "${fileName}" kann im Texteditor nicht angezeigt werden, da es sich um eine Binärdatei handelt.';
	@override String get cannotDisplayAsText => 'Kann nicht als Text angezeigt werden';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$de extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Vorschau wird geladen...';
	@override String get error => 'Diese Datei kann nicht angezeigt werden.';
	@override String get openInNewTab => 'In neuem Tab öffnen';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$de extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get applyMerge => 'Merge anwenden';
	@override String get base => 'Basis';
	@override String get close => 'Diff schließen';
	@override String get current => 'Aktuell';
	@override String hunk({required Object number}) => 'Hunk ${number}';
	@override String get noChanges => 'Keine Änderungen';
	@override String get deletedOnDisk => 'auf der Festplatte gelöscht';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$de extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Keine Datei geöffnet';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$de extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… ${size} weitere';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$de extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Audio-/Video-Vorschau wird noch nicht unterstützt';
	@override String get title => 'Mediendatei';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$de extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String fontSizeDecrease({required Object size}) => 'Schriftgröße −  (jetzt ${size})';
	@override String get fontSizeIncrease => 'Schriftgröße +';
	@override String get minimap => 'Minimap';
	@override String tabSize({required Object size}) => 'Tab-Größe: ${size}';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$de extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => '${name} gespeichert';
	@override String get saveFailed => 'Speichern fehlgeschlagen';
	@override String get allSaved => 'Alle gespeichert';
	@override String get someSavesFailed => 'Einige Speichervorgänge fehlgeschlagen';
	@override String savedTo({required Object path}) => 'Gespeichert unter ${path}';
	@override String get mergeApplied => 'Merge angewendet — zum Beibehalten speichern';
}

// Path: common.buttons
class Translations$common$buttons$de extends Translations$common$buttons$en {
	Translations$common$buttons$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get save => 'Speichern';
	@override String get cancel => 'Abbrechen';
	@override String get delete => 'Löschen';
	@override String get create => 'Erstellen';
	@override String get edit => 'Bearbeiten';
	@override String get close => 'Schließen';
	@override String get confirm => 'Bestätigen';
	@override String get submit => 'Absenden';
	@override String get retry => 'Erneut versuchen';
	@override String get refresh => 'Aktualisieren';
	@override String get search => 'Suchen';
	@override String get clear => 'Leeren';
	@override String get copy => 'Kopieren';
	@override String get download => 'Herunterladen';
	@override String get upload => 'Hochladen';
	@override String get browse => 'Durchsuchen';
	@override String get openDiagram => 'Diagramm öffnen';
	@override String get update => 'Aktualisieren';
}

// Path: common.tabs
class Translations$common$tabs$de extends Translations$common$tabs$en {
	Translations$common$tabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get shell => 'Terminal';
	@override String get files => 'Dateien';
	@override String get git => 'Quellcodeverwaltung';
	@override String get tasks => 'Aufgaben';
	@override String get browser => 'Browser';
	@override String get computer => 'Computer';
	@override String get board => 'Board';
	@override String get usage => 'AI Control';
}

// Path: common.status
class Translations$common$status$de extends Translations$common$status$en {
	Translations$common$status$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Lädt...';
	@override String get success => 'Erfolgreich';
	@override String get error => 'Fehler';
	@override String get failed => 'Fehlgeschlagen';
	@override String get pending => 'Ausstehend';
	@override String get completed => 'Abgeschlossen';
	@override String get inProgress => 'In Bearbeitung';
}

// Path: common.messages
class Translations$common$messages$de extends Translations$common$messages$en {
	Translations$common$messages$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Erfolgreich gespeichert';
	@override String get deletedSuccessfully => 'Erfolgreich gelöscht';
	@override String get updatedSuccessfully => 'Erfolgreich aktualisiert';
	@override String get operationFailed => 'Vorgang fehlgeschlagen';
	@override String get networkError => 'Netzwerkfehler. Bitte überprüf deine Verbindung.';
	@override String get unauthorized => 'Nicht autorisiert. Bitte meld dich an.';
	@override String get notFound => 'Nicht gefunden';
	@override String get invalidInput => 'Ungültige Eingabe';
	@override String get requiredField => 'Dieses Feld ist erforderlich';
	@override String get unknownError => 'Ein unbekannter Fehler ist aufgetreten';
	@override String get renameSessionFailed => 'Sitzung konnte nicht umbenannt werden. Bitte erneut versuchen.';
}

// Path: common.navigation
class Translations$common$navigation$de extends Translations$common$navigation$en {
	Translations$common$navigation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Einstellungen';
	@override String get home => 'Startseite';
	@override String get back => 'Zurück';
	@override String get next => 'Weiter';
	@override String get previous => 'Zurück';
	@override String get logout => 'Abmelden';
}

// Path: common.common
class Translations$common$common$de extends Translations$common$common$en {
	Translations$common$common$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get language => 'Sprache';
	@override String get theme => 'Design';
	@override String get darkMode => 'Darkmode';
	@override String get lightMode => 'Hellmodus';
	@override String get name => 'Name';
	@override String get description => 'Beschreibung';
	@override String get enabled => 'Aktiviert';
	@override String get disabled => 'Deaktiviert';
	@override String get optional => 'Optional';
	@override String get version => 'Version';
	@override String get select => 'Auswählen';
	@override String get selectAll => 'Alle auswählen';
	@override String get deselectAll => 'Alle abwählen';
	@override String get done => 'Fertig';
	@override String get failed => 'Fehlgeschlagen';
}

// Path: common.time
class Translations$common$time$de extends Translations$common$time$en {
	Translations$common$time$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Gerade eben';
	@override String minutesAgo({required Object count}) => 'vor ${count} Min.';
	@override String hoursAgo({required Object count}) => 'vor ${count} Std.';
	@override String daysAgo({required Object count}) => 'vor ${count} Tagen';
	@override String get yesterday => 'Gestern';
}

// Path: common.fileOperations
class Translations$common$fileOperations$de extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Neue Datei';
	@override String get newFolder => 'Neuer Ordner';
	@override String get rename => 'Umbenennen';
	@override String get move => 'Verschieben';
	@override String get copyPath => 'Pfad kopieren';
	@override String get openInEditor => 'Im Editor öffnen';
}

// Path: common.mainContent
class Translations$common$mainContent$de extends Translations$common$mainContent$en {
	Translations$common$mainContent$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'ddagent wird geladen';
	@override String get settingUpWorkspace => 'Arbeitsbereich wird eingerichtet...';
	@override String get chooseProject => 'Projekt auswählen';
	@override String get selectProjectDescription => 'Wähl ein Projekt aus der Seitenleiste, um mit Claude zu programmieren. Jedes Projekt enthält deine Chat-Sitzungen und den Dateiverlauf.';
	@override String get tip => 'Tipp';
	@override String get createProjectMobile => 'Tipp oben auf die Menüschaltfläche, um auf Projekte zuzugreifen';
	@override String get createProjectDesktop => 'Erstell ein neues Projekt, indem du auf das Ordnersymbol in der Seitenleiste klickst';
	@override String get newSession => 'Neue Sitzung';
	@override String get untitledSession => 'Unbenannte Sitzung';
	@override String get projectFiles => 'Projektdateien';
	@override String get focusMode => 'Fokusmodus (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Fokusmodus beenden (Ctrl+Shift+F)';
	@override String get splitSession => 'Sitzung teilen';
	@override String get closeSplitSession => 'Geteilte Sitzung schließen';
	@override String get chooseWorkspace => 'Workspace auswählen';
	@override String get chooseWorkspaceDescription => 'Wähle einen Workspace für diesen Chat oder erstelle einen neuen in den Einstellungen.';
	@override String get createWorkspace => 'Workspace in den Einstellungen erstellen';
	@override String get recentProjects => 'Letzte Projekte';
}

// Path: common.fileTree
class Translations$common$fileTree$de extends Translations$common$fileTree$en {
	Translations$common$fileTree$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Dateien werden geladen...';
	@override String get files => 'Dateien';
	@override String get simpleView => 'Einfache Ansicht';
	@override String get compactView => 'Kompakte Ansicht';
	@override String get detailedView => 'Detailansicht';
	@override String get searchPlaceholder => 'Dateien und Ordner durchsuchen...';
	@override String get clearSearch => 'Suche leeren';
	@override String get name => 'Name';
	@override String get size => 'Größe';
	@override String get modified => 'Geändert';
	@override String get permissions => 'Berechtigungen';
	@override String get noFilesFound => 'Keine Dateien gefunden';
	@override String get checkProjectPath => 'Überprüf, ob der Projektpfad zugänglich ist';
	@override String get noMatchesFound => 'Keine Treffer gefunden';
	@override String get tryDifferentSearch => 'Versuch einen anderen Suchbegriff oder leere die Suche';
	@override String get justNow => 'gerade eben';
	@override String minAgo({required Object count}) => 'vor ${count} Min.';
	@override String hoursAgo({required Object count}) => 'vor ${count} Std.';
	@override String daysAgo({required Object count}) => 'vor ${count} Tagen';
	@override String get newFile => 'Neue Datei (Cmd+N)';
	@override String get newFolder => 'Neuer Ordner (Cmd+Shift+N)';
	@override String get refresh => 'Aktualisieren';
	@override String get collapseAll => 'Alle einklappen';
	@override late final Translations$common$fileTree$context$de context = Translations$common$fileTree$context$de._(_root);
	@override String get searchContentPlaceholder => 'In Dateien suchen...';
	@override String get searchInFiles => 'In Dateien suchen';
	@override String get searchByName => 'Nach Name suchen';
	@override String get loadFailed => 'Dateien konnten nicht geladen werden';
	@override String get noSearchResults => 'Keine Treffer gefunden';
	@override String get searchError => 'Suche fehlgeschlagen';
	@override String get searching => 'Suche läuft...';
	@override String resultsTruncated({required Object count}) => 'Erste ${count} Ergebnisse werden angezeigt';
	@override String get allWorkspaces => 'Alle Workspaces';
	@override late final Translations$common$fileTree$delete$de delete = Translations$common$fileTree$delete$de._(_root);
	@override String get dropToUpload => 'Dateien zum Hochladen ablegen';
	@override String dropToUploadTo({required Object folder}) => 'Dateien zum Hochladen nach „${folder}“ ablegen';
	@override String get noProject => 'Zuerst ein Projekt hinzufügen';
	@override String get noRecentFiles => 'Keine Dateien in den letzten 7 Tagen geändert';
	@override String get showAllFiles => 'Alle Dateien anzeigen';
	@override String get showAllFilesHint => 'Deaktiviere den Filter „zuletzt geändert“, um alles zu sehen.';
	@override String get showRecentOnly => 'Nur in den letzten 7 Tagen geänderte Dateien anzeigen';
	@override late final Translations$common$fileTree$toast$de toast = Translations$common$fileTree$toast$de._(_root);
	@override String get uploadComplete => 'Upload abgeschlossen';
	@override String get uploadFailed => 'Upload fehlgeschlagen';
	@override String uploadFiles({required Object size}) => 'Dateien hochladen (max. ${size} pro Datei)';
	@override String uploadToFolder({required Object folder}) => 'Dateien nach „${folder}“ hochladen';
	@override String uploadedCount({required Object uploaded, required Object total, required Object label}) => '${uploaded} von ${total} ${label} hochgeladen';
	@override String get uploadingFiles => 'Dateien werden hochgeladen';
	@override late final Translations$common$fileTree$validation$de validation = Translations$common$fileTree$validation$de._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$de extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Neues Projekt erstellen';
	@override late final Translations$common$projectWizard$steps$de steps = Translations$common$projectWizard$steps$de._(_root);
	@override late final Translations$common$projectWizard$step1$de step1 = Translations$common$projectWizard$step1$de._(_root);
	@override late final Translations$common$projectWizard$step2$de step2 = Translations$common$projectWizard$step2$de._(_root);
	@override late final Translations$common$projectWizard$step3$de step3 = Translations$common$projectWizard$step3$de._(_root);
	@override late final Translations$common$projectWizard$buttons$de buttons = Translations$common$projectWizard$buttons$de._(_root);
	@override late final Translations$common$projectWizard$errors$de errors = Translations$common$projectWizard$errors$de._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$de extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Update verfügbar';
	@override String get newVersionReady => 'Eine neue Version ist verfügbar';
	@override String get currentVersion => 'Aktuelle Version';
	@override String get latestVersion => 'Neueste Version';
	@override String get whatsNew => 'Neuigkeiten:';
	@override String get viewFullRelease => 'Vollständige Version anzeigen';
	@override String get updateProgress => 'Update-Fortschritt:';
	@override String get manualUpgrade => 'Manuelles Upgrade:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'Oder klick auf "Jetzt aktualisieren", um das Update automatisch durchzuführen.';
	@override String get updateCompleted => 'Update erfolgreich abgeschlossen!';
	@override String get restartServer => 'Bitte starte den Server neu, um die Änderungen anzuwenden.';
	@override String get updateFailed => 'Update fehlgeschlagen';
	@override late final Translations$common$versionUpdate$buttons$de buttons = Translations$common$versionUpdate$buttons$de._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$de ariaLabels = Translations$common$versionUpdate$ariaLabels$de._(_root);
}

// Path: common.quota
class Translations$common$quota$de extends Translations$common$quota$en {
	Translations$common$quota$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$de section = Translations$common$quota$section$de._(_root);
	@override late final Translations$common$quota$filter$de filter = Translations$common$quota$filter$de._(_root);
	@override late final Translations$common$quota$period$de period = Translations$common$quota$period$de._(_root);
	@override late final Translations$common$quota$group$de group = Translations$common$quota$group$de._(_root);
	@override late final Translations$common$quota$metric$de metric = Translations$common$quota$metric$de._(_root);
	@override late final Translations$common$quota$cost$de cost = Translations$common$quota$cost$de._(_root);
	@override late final Translations$common$quota$cost3$de cost3 = Translations$common$quota$cost3$de._(_root);
	@override late final Translations$common$quota$overview$de overview = Translations$common$quota$overview$de._(_root);
	@override late final Translations$common$quota$usage$de usage = Translations$common$quota$usage$de._(_root);
	@override late final Translations$common$quota$agents$de agents = Translations$common$quota$agents$de._(_root);
	@override late final Translations$common$quota$agentStatus$de agentStatus = Translations$common$quota$agentStatus$de._(_root);
	@override late final Translations$common$quota$alert$de alert = Translations$common$quota$alert$de._(_root);
	@override String get backToChat => 'Zurück zum Chat';
	@override String get syncNow => 'Jetzt synchronisieren';
	@override String generatedAt({required Object value}) => 'Aktualisiert ${value}';
	@override String get loading => 'Kontolimits werden geladen…';
	@override String remaining({required Object value}) => '${value}% übrig';
	@override String resetsIn({required Object value}) => 'Reset in ${value}';
	@override String projected({required Object value}) => 'beim aktuellen Tempo ist dieses Limit in ${value} erreicht';
	@override String syncedAgo({required Object value}) => 'vor ${value} synchronisiert';
	@override String get refreshAccount => 'Konto aktualisieren';
	@override String get syncFailed => 'Synchronisierung fehlgeschlagen';
	@override String get history => 'Verlauf';
	@override String historyPoints({required Object value}) => '${value} Messwerte aufgezeichnet';
	@override String get historyEmpty => 'Noch kein Verlauf aufgezeichnet';
	@override String get noAgents => 'Keine Agents zugewiesen';
	@override String get noSubscription => 'Kein Abonnement';
	@override String get noSubscriptionHint => 'Der Anbieter meldet keinen aktiven Plan für dieses Konto.';
	@override late final Translations$common$quota$quality$de quality = Translations$common$quota$quality$de._(_root);
	@override late final Translations$common$quota$kpi$de kpi = Translations$common$quota$kpi$de._(_root);
	@override late final Translations$common$quota$empty$de empty = Translations$common$quota$empty$de._(_root);
	@override late final Translations$common$quota$settings$de settings = Translations$common$quota$settings$de._(_root);
	@override late final Translations$common$quota$range$de range = Translations$common$quota$range$de._(_root);
}

// Path: common.notifications
class Translations$common$notifications$de extends Translations$common$notifications$en {
	Translations$common$notifications$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'ein Werkzeug';
	@override late final Translations$common$notifications$codes$de codes = Translations$common$notifications$codes$de._(_root);
}

// Path: common.actions
class Translations$common$actions$de extends Translations$common$actions$en {
	Translations$common$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get retry => 'Erneut versuchen';
	@override String get save => 'Speichern';
}

// Path: common.browserPane
class Translations$common$browserPane$de extends Translations$common$browserPane$en {
	Translations$common$browserPane$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get address => 'Adresse';
	@override String get back => 'Zurück';
	@override String get connecting => 'Verbinde mit Browser…';
	@override String get connectionFailed => 'Browser-Verbindung fehlgeschlagen.';
	@override String couldNotLoad({required Object url}) => '${url} konnte nicht geladen werden';
	@override String get disconnected => 'Browser-Ansicht getrennt';
	@override String get enterUrl => 'URL eingeben';
	@override String get forward => 'Vorwärts';
	@override String get invalidUrl => 'Gültige http(s)-URL eingeben';
	@override String get noAuthToken => 'Kein Authentifizierungstoken verfügbar.';
	@override String get openExternal => 'Im Systembrowser öffnen';
	@override String get reload => 'Neu laden';
	@override String get retry => 'Wiederholen';
	@override String get stop => 'Stopp';
}

// Path: common.browserUse
class Translations$common$browserUse$de extends Translations$common$browserUse$en {
	Translations$common$browserUse$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} aktiv';
	@override String get cancel => 'Abbrechen';
	@override String get close => 'Schließen';
	@override String get delete => 'Löschen';
	@override String deleteDesc({required Object name}) => '${name} wird endgültig gelöscht.';
	@override String get deleteSession => 'Sitzung löschen';
	@override String get deleteTitle => 'Browser-Sitzung löschen?';
	@override late final Translations$common$browserUse$empty$de empty = Translations$common$browserUse$empty$de._(_root);
	@override String get emptyStatus => 'leer';
	@override late final Translations$common$browserUse$errors$de errors = Translations$common$browserUse$errors$de._(_root);
	@override String get fullscreen => 'Vollbild';
	@override String get installRuntime => 'Runtime installieren';
	@override String get installing => 'Installiere...';
	@override String get lastAction => 'Letzte Aktion';
	@override String get nextSnapshot => 'Der nächste Browser-Snapshot des Agenten wird hier angezeigt.';
	@override String get noPageLoaded => 'Keine Seite geladen';
	@override String get noSessions => 'Keine Agenten-Browser-Sitzungen.';
	@override String get none => 'Keine';
	@override String get openSettings => 'Browser-Einstellungen öffnen';
	@override String get profile => 'Profil';
	@override String get promptLabel => 'Prompt';
	@override late final Translations$common$browserUse$prompts$de prompts = Translations$common$browserUse$prompts$de._(_root);
	@override String get refresh => 'Browser-Sitzungen aktualisieren';
	@override late final Translations$common$browserUse$relative$de relative = Translations$common$browserUse$relative$de._(_root);
	@override late final Translations$common$browserUse$runtime$de runtime = Translations$common$browserUse$runtime$de._(_root);
	@override String get runtimeSetup => 'Runtime-Einrichtung erforderlich';
	@override String get selected => 'Ausgewählt';
	@override String get sessionFallback => 'Browser-Sitzung';
	@override String get sessionScreenshot => 'Screenshot der Browser-Sitzung';
	@override String get sessions => 'Sitzungen';
	@override String get status => 'Status';
	@override String get stop => 'Stopp';
	@override String get stopSession => 'Sitzung stoppen';
	@override String get subtitle => 'Überwache Browser-Sitzungen, die von KI-Agenten geöffnet wurden.';
	@override String get temporary => 'Temporär';
	@override String get thisSession => 'Diese Sitzung';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '${count} gesamt';
	@override String updated({required Object time}) => 'Aktualisiert ${time}';
	@override String get waiting => 'Warten';
	@override String get waitingForScreenshot => 'Warte auf Screenshot';
}

// Path: common.commandPalette
class Translations$common$commandPalette$de extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Zurück zu allen';
	@override String get backspaceHint => 'Rücktaste zum Zurückgehen';
	@override late final Translations$common$commandPalette$browseAll$de browseAll = Translations$common$commandPalette$browseAll$de._(_root);
	@override late final Translations$common$commandPalette$compare$de compare = Translations$common$commandPalette$compare$de._(_root);
	@override late final Translations$common$commandPalette$groups$de groups = Translations$common$commandPalette$groups$de._(_root);
	@override late final Translations$common$commandPalette$hints$de hints = Translations$common$commandPalette$hints$de._(_root);
	@override late final Translations$common$commandPalette$items$de items = Translations$common$commandPalette$items$de._(_root);
	@override late final Translations$common$commandPalette$nav$de nav = Translations$common$commandPalette$nav$de._(_root);
	@override String get noResults => 'Keine Ergebnisse.';
	@override late final Translations$common$commandPalette$pages$de pages = Translations$common$commandPalette$pages$de._(_root);
	@override String get placeholder => 'Zum Suchen tippen…';
	@override String searchPagePlaceholder({required Object page}) => '${page} durchsuchen…';
	@override String get title => 'Befehlspalette';
}

// Path: common.gitPanel
class Translations$common$gitPanel$de extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} voraus';
	@override String get aheadLabel => 'voraus';
	@override String get aiSuggest => 'KI-Vorschlag';
	@override String get aiSuggestTitle => 'Commit-Nachricht mit KI generieren';
	@override String get all => 'Alle';
	@override String get allStaged => 'Alle Änderungen staged';
	@override String behind({required Object count}) => '${count} zurück';
	@override String get behindLabel => 'zurück';
	@override late final Translations$common$gitPanel$branches$de branches = Translations$common$gitPanel$branches$de._(_root);
	@override String get cancel => 'Abbrechen';
	@override String changesCount({required Object count}) => 'Änderungen (${count})';
	@override String get clearSearch => 'Suche löschen';
	@override String get collapseDiff => 'Diff einklappen';
	@override String get commit => 'Commit';
	@override String get commitChanges => 'Änderungen committen';
	@override String commitFiles({required Object count}) => '${count} Datei(en) committen';
	@override String get committing => 'Committe...';
	@override late final Translations$common$gitPanel$confirmActions$de confirmActions = Translations$common$gitPanel$confirmActions$de._(_root);
	@override String confirmCommit({required Object count, required Object message}) => '${count} Datei(en) mit Nachricht committen: „${message}“?';
	@override String confirmDeleteFile({required Object file}) => 'Untracked Datei „${file}“ löschen? Dies kann nicht rückgängig gemacht werden.';
	@override String confirmDiscardFile({required Object file}) => 'Alle Änderungen an „${file}“ verwerfen? Dies kann nicht rückgängig gemacht werden.';
	@override String confirmPublish({required Object branch, required Object remote}) => 'Branch „${branch}“ nach ${remote} veröffentlichen?';
	@override String confirmPull({required Object count, required Object remote}) => '${count} Commit(s) von ${remote} pullen?';
	@override String confirmPush({required Object count, required Object remote}) => '${count} Commit(s) nach ${remote} pushen?';
	@override String get confirmRevert => 'Letzten lokalen Commit zurücksetzen? Entfernt den Commit, behält aber seine Änderungen staged.';
	@override late final Translations$common$gitPanel$confirmTitles$de confirmTitles = Translations$common$gitPanel$confirmTitles$de._(_root);
	@override String get createBranch => 'Neuen Branch erstellen';
	@override String get creating => 'Erstelle...';
	@override String get delete => 'Löschen';
	@override String get deleteUntracked => 'Untracked Datei löschen';
	@override String get deselectAll => 'Alle abwählen';
	@override String get discard => 'Verwerfen';
	@override String get discardChanges => 'Änderungen verwerfen';
	@override String get dismiss => 'Schließen';
	@override String get dismissError => 'Fehler schließen';
	@override late final Translations$common$gitPanel$errors$de errors = Translations$common$gitPanel$errors$de._(_root);
	@override String get expandDiff => 'Diff ausklappen';
	@override String get fetch => 'Fetch';
	@override String fetchTitle({required Object remote}) => 'Von ${remote} fetchen';
	@override String get fetching => 'Fetche…';
	@override String filesSelected({required Object count}) => '${count} Datei(en) ausgewählt';
	@override String get generating => 'Generiere...';
	@override late final Translations$common$gitPanel$history$de history = Translations$common$gitPanel$history$de._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$de mergeWorktree = Translations$common$gitPanel$mergeWorktree$de._(_root);
	@override String get merging => 'Merge…';
	@override String get messagePlaceholder => 'Nachricht (Strg+Enter zum Committen)';
	@override late final Translations$common$gitPanel$newBranch$de newBranch = Translations$common$gitPanel$newBranch$de._(_root);
	@override late final Translations$common$gitPanel$newWorktree$de newWorktree = Translations$common$gitPanel$newWorktree$de._(_root);
	@override String get noChanges => 'Keine Änderungen erkannt';
	@override String get noChangesToCommit => 'Keine Änderungen zum Committen';
	@override late final Translations$common$gitPanel$noCommits$de noCommits = Translations$common$gitPanel$noCommits$de._(_root);
	@override String get noMatchingBranches => 'Keine passenden Branches';
	@override late final Translations$common$gitPanel$noRepo$de noRepo = Translations$common$gitPanel$noRepo$de._(_root);
	@override String get noStagedFiles => 'Keine staged Dateien';
	@override String get none => 'Keine';
	@override String nothingToPush({required Object remote}) => 'Nichts nach ${remote} zu pushen';
	@override String get openFile => 'Klicken, um Datei zu öffnen';
	@override String get publish => 'Veröffentlichen';
	@override String publishTitle({required Object branch, required Object remote}) => '„${branch}“ nach ${remote} veröffentlichen';
	@override String get publishing => 'Veröffentliche…';
	@override String get pull => 'Pull';
	@override String pullCount({required Object count}) => 'Pull ${count}';
	@override String pullTitle({required Object count, required Object remote}) => '${count} von ${remote} pullen';
	@override String get pulling => 'Pulle…';
	@override String get push => 'Push';
	@override String pushCount({required Object count}) => 'Push ${count}';
	@override String pushTitle({required Object count, required Object remote}) => '${count} nach ${remote} pushen';
	@override String get pushing => 'Pushe…';
	@override String get recentCommits => 'Letzte Commits';
	@override String get refresh => 'Git-Status aktualisieren';
	@override String get remove => 'Entfernen';
	@override late final Translations$common$gitPanel$removeWorktree$de removeWorktree = Translations$common$gitPanel$removeWorktree$de._(_root);
	@override String get removing => 'Entferne...';
	@override String get revertLatest => 'Letzten lokalen Commit zurücksetzen';
	@override String get scroll => 'Scrollen';
	@override String get searchBranches => 'Branches suchen...';
	@override String get selectAll => 'Alle auswählen';
	@override String get selectProject => 'Projekt auswählen, um die Quellcodeverwaltung zu sehen';
	@override String selectedOf({required Object selected, required Object total}) => '${selected} von ${total} Dateien ausgewählt';
	@override String selectedOfMobile({required Object selected, required Object total}) => '${selected} von ${total} ausgewählt';
	@override String get sideBySide => 'Ne-beneinander';
	@override String get stageAll => 'Alle stagen';
	@override String get stageHunk => 'Diesen Hunk stagen';
	@override String staged({required Object count}) => 'Vorgemerkt (${count})';
	@override late final Translations$common$gitPanel$status$de status = Translations$common$gitPanel$status$de._(_root);
	@override String get statusGuide => 'Datei-Status-Legende';
	@override String get switchScroll => 'Zu horizontalem Scrollen wechseln';
	@override String get switchSplit => 'Zur Nebeneinander-Ansicht wechseln';
	@override String get switchUnified => 'Zur einheitlichen Ansicht wechseln';
	@override String get switchWrap => 'Zu Textumbruch wechseln';
	@override String get unified => 'Einheitlich';
	@override String get unstageAll => 'Alle unstagen';
	@override String get unstageHunk => 'Diesen Hunk unstagen';
	@override String get upToDate => 'Aktuell';
	@override String upToDateWith({required Object remote}) => 'Aktuell mit ${remote}';
	@override String get viewAll => 'Alle anzeigen';
	@override String get viewsAria => 'Ansichten der Quellcodeverwaltung';
	@override late final Translations$common$gitPanel$worktrees$de worktrees = Translations$common$gitPanel$worktrees$de._(_root);
	@override String get wrap => 'Umbruch';
	@override late final Translations$common$gitPanel$tabs$de tabs = Translations$common$gitPanel$tabs$de._(_root);
}

// Path: common.sessions
class Translations$common$sessions$de extends Translations$common$sessions$en {
	Translations$common$sessions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Sitzung umbenennen';
}

// Path: common.projects
class Translations$common$projects$de extends Translations$common$projects$en {
	Translations$common$projects$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Neue Sitzung';
}

// Path: common.codeBlock
class Translations$common$codeBlock$de extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'Zeilen umbrechen';
	@override String get noWrap => 'Kein Umbruch';
}

// Path: common.update
class Translations$common$update$de extends Translations$common$update$en {
	Translations$common$update$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Update verfügbar · v${version}';
	@override String confirm({required Object version}) => 'Auf v${version} aktualisieren? Der Server aktualisiert sich selbst und startet neu — aktive Sitzungen werden unterbrochen.';
	@override String get downloading => 'Update wird heruntergeladen und angewendet…';
	@override String get restarting => 'Server wird neu gestartet — das dauert einen Moment…';
	@override String done({required Object version}) => 'Auf v${version} aktualisiert. Lade die App neu, um das neue Bundle zu übernehmen.';
	@override String get manualRestart => 'Das Update wurde angewendet, aber der Server hat nicht von selbst neu gestartet — starte ihn manuell neu, um abzuschließen.';
	@override String get failed => 'Update fehlgeschlagen.';
	@override String get failedTitle => 'Update fehlgeschlagen';
	@override String appConfirm({required Object version}) => 'ddagent v${version} auf diesem Gerät installieren? Android fragt beim ersten Mal, ob Installationen aus ddagent erlaubt sind.';
	@override String get appPermission => 'Erlaube ddagent „Unbekannte Apps installieren“ und tippe dann erneut auf Aktualisieren.';
	@override String get chooseTitle => 'Updates verfügbar';
	@override String get targetApp => 'Diese App';
	@override String get targetWeb => 'Weboberfläche';
	@override String get targetServer => 'Server';
	@override String get updateApp => 'App aktualisieren';
	@override String get updateWeb => 'Weboberfläche aktualisieren';
	@override String get updateServer => 'Server aktualisieren';
	@override String webConfirm({required Object version}) => 'Weboberfläche auf v${version} aktualisieren? Die Seite wird danach neu geladen.';
	@override String webDone({required Object version}) => 'Weboberfläche auf v${version} aktualisiert — wird neu geladen…';
	@override String localServerConfirm({required Object version}) => 'Den lokalen Server auf diesem Gerät auf v${version} aktualisieren? Laufende Sitzungen werden unterbrochen.';
	@override String get localServerUpdating => 'Lokaler Server wird heruntergeladen und gestartet…';
	@override String serverDone({required Object version}) => 'Der Server läuft mit v${version}.';
	@override String staged({required Object version}) => 'Update v${version} heruntergeladen — starte den Server neu, um es zu installieren.';
	@override String get upToDate => 'Der Server ist bereits auf der neuesten Version.';
	@override String webHostFailed({required Object message}) => 'Der Server wurde aktualisiert, seine Weboberfläche aber nicht: ${message}';
}

// Path: settings.changelog
class Translations$settings$changelog$de extends Translations$settings$changelog$en {
	Translations$settings$changelog$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Änderungsprotokoll';
	@override String get loading => 'Laden…';
	@override String get empty => 'Keine Veröffentlichungen vorhanden';
	@override String get current => 'aktuell';
	@override String get kNew => 'neu';
}

// Path: settings.server
class Translations$settings$server$de extends Translations$settings$server$en {
	Translations$settings$server$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Server';
	@override String get description => 'Startet den ddagent-Prozess neu — nützlich nach Updates oder wenn etwas hängt.';
	@override String get restart => 'Neu starten';
	@override String get restartConfirm => 'ddagent-Server neu starten? Aktive Sitzungen werden unterbrochen.';
	@override String get restarting => 'Neustart läuft… die Seite lädt neu, sobald der Server zurück ist.';
	@override String get restartFailed => 'Neustart fehlgeschlagen';
	@override String get unsupported => 'Neustart ist nur verfügbar, wenn der Server unter dem Dienst-Manager läuft.';
	@override String get ok => 'OK';
	@override String get restartTitle => 'Server wird neu gestartet';
	@override String get restartRequesting => 'Server wird zum Neustart aufgefordert…';
	@override String restartWaiting({required Object seconds}) => 'Warte, bis der Server wieder da ist… (${seconds} s)';
	@override String restartBack({required Object version}) => 'Der Server läuft wieder — Version ${version}.';
	@override String get restartReloading => 'Seite wird neu geladen…';
	@override String restartTimeout({required Object seconds}) => 'Der Server ist nicht innerhalb von ${seconds} s zurückgekehrt. Prüfe das Dienstprotokoll (/tmp/ddagent.log) oder starte ihn manuell neu.';
}

// Path: settings.updates
class Translations$settings$updates$de extends Translations$settings$updates$en {
	Translations$settings$updates$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'App-Updates';
	@override String get description => 'Auf GitHub nach einer neueren Desktop-Version suchen. Neue Versionen werden automatisch heruntergeladen und beim Beenden installiert.';
	@override String get check => 'Nach Updates suchen';
	@override String get checking => 'Suche läuft…';
	@override String upToDate({required Object version}) => 'Du hast die neueste Version (v${version}).';
	@override String available({required Object version}) => 'Update v${version} gefunden — Download im Hintergrund; Installation beim Beenden von ddagent.';
	@override String downloaded({required Object version}) => 'Update v${version} heruntergeladen — ddagent beenden und neu starten, um es zu installieren.';
	@override String get unavailable => 'Die Update-Prüfung ist nur in paketierten Desktop-Builds verfügbar.';
	@override String error({required Object message}) => 'Update-Prüfung fehlgeschlagen: ${message}';
	@override String get errorGeneric => 'Update-Prüfung fehlgeschlagen.';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · neueste v${latest}';
	@override String current({required Object version}) => 'v${version} — aktuell';
	@override String webNotHosted({required Object version}) => 'Diese Weboberfläche wird separat gehostet — ersetze ihre Dateien durch ddagent-flutter-web-v${version}.zip aus dem Release.';
	@override String get serverCannotUpdate => 'Dieser Server kann sich von hier aus nicht selbst aktualisieren — installiere ihn mit install.sh oder einem Release-Tarball neu.';
}

// Path: settings.tabs
class Translations$settings$tabs$de extends Translations$settings$tabs$en {
	Translations$settings$tabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get account => 'Konto';
	@override String get permissions => 'Berechtigungen';
	@override String get mcpServers => 'MCP-Server';
	@override String get appearance => 'Darstellung';
	@override String get skills => 'Skills';
}

// Path: settings.account
class Translations$settings$account$de extends Translations$settings$account$en {
	Translations$settings$account$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konto';
	@override String get language => 'Sprache';
	@override String get languageLabel => 'Anzeigesprache';
	@override String get languageDescription => 'Wähl deine bevorzugte Sprache für die Oberfläche';
	@override String get username => 'Benutzername';
	@override String get email => 'E-Mail';
	@override String get profile => 'Profil';
	@override String get changePassword => 'Passwort ändern';
}

// Path: settings.mcp
class Translations$settings$mcp$de extends Translations$settings$mcp$en {
	Translations$settings$mcp$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP-Server';
	@override String get addServer => 'Server hinzufügen';
	@override String get editServer => 'Server bearbeiten';
	@override String get deleteServer => 'Server löschen';
	@override String get serverName => 'Servername';
	@override String get serverType => 'Servertyp';
	@override String get config => 'Konfiguration';
	@override String get testConnection => 'Verbindung testen';
	@override String get status => 'Status';
	@override String get connected => 'Verbunden';
	@override String get disconnected => 'Getrennt';
	@override late final Translations$settings$mcp$scope$de scope = Translations$settings$mcp$scope$de._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$de extends Translations$settings$appearance$en {
	Translations$settings$appearance$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Darstellung';
	@override String get theme => 'Design';
	@override String get codeEditor => 'Code-Editor';
	@override String get editorTheme => 'Editor-Design';
	@override String get wordWrap => 'Zeilenumbruch';
	@override String get showMinimap => 'Minimap anzeigen';
	@override String get lineNumbers => 'Zeilennummern';
	@override String get fontSize => 'Schriftgröße';
	@override late final Translations$settings$appearance$themeModes$de themeModes = Translations$settings$appearance$themeModes$de._(_root);
}

// Path: settings.actions
class Translations$settings$actions$de extends Translations$settings$actions$en {
	Translations$settings$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Änderungen speichern';
	@override String get resetToDefaults => 'Auf Standardwerte zurücksetzen';
	@override String get cancelChanges => 'Änderungen abbrechen';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$de extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Schnelleinstellungen';
	@override late final Translations$settings$quickSettings$sections$de sections = Translations$settings$quickSettings$sections$de._(_root);
	@override String get darkMode => 'Darkmode';
	@override String get showRawParameters => 'Rohe Parameter anzeigen';
	@override String get showThinking => 'Denken anzeigen';
	@override String get sendByCtrlEnter => 'Mit Strg+Enter senden';
	@override String get sendByCtrlEnterDescription => 'Wenn aktiviert, sendet Strg+Enter die Nachricht anstelle von Enter. Dies ist nützlich für IME-Benutzer:innen, um versehentliches Senden zu vermeiden.';
	@override late final Translations$settings$quickSettings$dragHandle$de dragHandle = Translations$settings$quickSettings$dragHandle$de._(_root);
	@override String get sendWithCtrlEnter => 'Mit Strg+Enter senden';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$de extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal-Tastenkürzel';
	@override String get sectionKeys => 'Tasten';
	@override String get sectionNavigation => 'Navigation';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => 'Pfeil oben';
	@override String get arrowDown => 'Pfeil unten';
	@override String get scrollDown => 'Nach unten scrollen';
	@override late final Translations$settings$terminalShortcuts$handle$de handle = Translations$settings$terminalShortcuts$handle$de._(_root);
	@override String get killTitle => 'Laufenden Prozess beenden (Ctrl+C)';
	@override String get paste => 'Einfügen';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$de extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Einstellungen';
	@override String get agents => 'Agenten';
	@override String get orchestration => 'Orchestrierung';
	@override String get appearance => 'Darstellung';
	@override String get git => 'Git';
	@override String get apiTokens => 'API & Token';
	@override String get models => 'Modelle';
	@override String get tasks => 'Aufgaben';
	@override String get notifications => 'Benachrichtigungen';
	@override String get about => 'Info';
	@override String get workspaces => 'Arbeitsbereiche';
	@override String get browser => 'Browser';
	@override String get tools => 'Werkzeuge';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$de extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$de enable = Translations$settings$orchestration$enable$de._(_root);
	@override late final Translations$settings$orchestration$pool$de pool = Translations$settings$orchestration$pool$de._(_root);
	@override late final Translations$settings$orchestration$tiers$de tiers = Translations$settings$orchestration$tiers$de._(_root);
	@override late final Translations$settings$orchestration$rules$de rules = Translations$settings$orchestration$rules$de._(_root);
	@override late final Translations$settings$orchestration$planner$de planner = Translations$settings$orchestration$planner$de._(_root);
	@override late final Translations$settings$orchestration$execution$de execution = Translations$settings$orchestration$execution$de._(_root);
	@override late final Translations$settings$orchestration$save$de save = Translations$settings$orchestration$save$de._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$de extends Translations$settings$notifications$en {
	Translations$settings$notifications$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Benachrichtigungen';
	@override String get description => 'Lege fest, welche Benachrichtigungen du erhältst.';
	@override late final Translations$settings$notifications$webPush$de webPush = Translations$settings$notifications$webPush$de._(_root);
	@override late final Translations$settings$notifications$device$de device = Translations$settings$notifications$device$de._(_root);
	@override late final Translations$settings$notifications$sound$de sound = Translations$settings$notifications$sound$de._(_root);
	@override late final Translations$settings$notifications$events$de events = Translations$settings$notifications$events$de._(_root);
	@override late final Translations$settings$notifications$desktop$de desktop = Translations$settings$notifications$desktop$de._(_root);
	@override late final Translations$settings$notifications$channels$de channels = Translations$settings$notifications$channels$de._(_root);
	@override String get unpair => 'Kopplung aufheben';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$de extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$de darkMode = Translations$settings$appearanceSettings$darkMode$de._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$de codeEditor = Translations$settings$appearanceSettings$codeEditor$de._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$de terminal = Translations$settings$appearanceSettings$terminal$de._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$de extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$de title = Translations$settings$mcpForm$title$de._(_root);
	@override late final Translations$settings$mcpForm$importMode$de importMode = Translations$settings$mcpForm$importMode$de._(_root);
	@override late final Translations$settings$mcpForm$scope$de scope = Translations$settings$mcpForm$scope$de._(_root);
	@override late final Translations$settings$mcpForm$fields$de fields = Translations$settings$mcpForm$fields$de._(_root);
	@override late final Translations$settings$mcpForm$placeholders$de placeholders = Translations$settings$mcpForm$placeholders$de._(_root);
	@override late final Translations$settings$mcpForm$validation$de validation = Translations$settings$mcpForm$validation$de._(_root);
	@override String configDetails({required Object configFile}) => 'Konfigurationsdetails (aus ${configFile})';
	@override String projectPath({required Object path}) => 'Pfad: ${path}';
	@override late final Translations$settings$mcpForm$actions$de actions = Translations$settings$mcpForm$actions$de._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$de extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get success => 'Einstellungen erfolgreich gespeichert!';
	@override String get error => 'Einstellungen konnten nicht gespeichert werden';
	@override String get saving => 'Wird gespeichert...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$de extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get save => 'Einstellungen speichern';
	@override String get cancel => 'Abbrechen';
}

// Path: settings.git
class Translations$settings$git$de extends Translations$settings$git$en {
	Translations$settings$git$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Git-Konfiguration';
	@override String get description => 'Konfiguriere deine Git-Identität für Commits. Diese Einstellungen werden global über git config --global angewendet';
	@override late final Translations$settings$git$name$de name = Translations$settings$git$name$de._(_root);
	@override late final Translations$settings$git$email$de email = Translations$settings$git$email$de._(_root);
	@override late final Translations$settings$git$actions$de actions = Translations$settings$git$actions$de._(_root);
	@override late final Translations$settings$git$status$de status = Translations$settings$git$status$de._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$de extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'API-Schlüssel';
	@override String get description => 'Generiere API-Schlüssel, um von anderen Anwendungen auf die externe API zuzugreifen.';
	@override late final Translations$settings$apiKeys$newKey$de newKey = Translations$settings$apiKeys$newKey$de._(_root);
	@override late final Translations$settings$apiKeys$form$de form = Translations$settings$apiKeys$form$de._(_root);
	@override String get newButton => 'Neuer API-Schlüssel';
	@override String get empty => 'Noch keine API-Schlüssel erstellt.';
	@override late final Translations$settings$apiKeys$list$de list = Translations$settings$apiKeys$list$de._(_root);
	@override String get confirmDelete => 'Möchtest du diesen API-Schlüssel wirklich löschen?';
	@override late final Translations$settings$apiKeys$status$de status = Translations$settings$apiKeys$status$de._(_root);
	@override late final Translations$settings$apiKeys$github$de github = Translations$settings$apiKeys$github$de._(_root);
	@override String get apiDocsLink => 'API-Dokumentation';
	@override late final Translations$settings$apiKeys$documentation$de documentation = Translations$settings$apiKeys$documentation$de._(_root);
	@override String get loading => 'Lädt...';
	@override late final Translations$settings$apiKeys$version$de version = Translations$settings$apiKeys$version$de._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$de extends Translations$settings$tasks$en {
	Translations$settings$tasks$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get checking => 'TaskMaster-Installation wird überprüft...';
	@override late final Translations$settings$tasks$notInstalled$de notInstalled = Translations$settings$tasks$notInstalled$de._(_root);
	@override late final Translations$settings$tasks$settings$de settings = Translations$settings$tasks$settings$de._(_root);
}

// Path: settings.agents
class Translations$settings$agents$de extends Translations$settings$agents$en {
	Translations$settings$agents$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$de authStatus = Translations$settings$agents$authStatus$de._(_root);
	@override late final Translations$settings$agents$install$de install = Translations$settings$agents$install$de._(_root);
	@override late final Translations$settings$agents$update$de update = Translations$settings$agents$update$de._(_root);
	@override late final Translations$settings$agents$account$de account = Translations$settings$agents$account$de._(_root);
	@override String get connectionStatus => 'Verbindungsstatus';
	@override late final Translations$settings$agents$login$de login = Translations$settings$agents$login$de._(_root);
	@override late final Translations$settings$agents$logout$de logout = Translations$settings$agents$logout$de._(_root);
	@override String error({required Object error}) => 'Fehler: ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$de extends Translations$settings$permissions$en {
	Translations$settings$permissions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Berechtigungseinstellungen';
	@override late final Translations$settings$permissions$permissionMode$de permissionMode = Translations$settings$permissions$permissionMode$de._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$de extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP-Server';
	@override late final Translations$settings$mcpServers$description$de description = Translations$settings$mcpServers$description$de._(_root);
	@override String get addButton => 'MCP-Server hinzufügen';
	@override String get empty => 'Keine MCP-Server konfiguriert';
	@override String get serverType => 'Typ';
	@override late final Translations$settings$mcpServers$scope$de scope = Translations$settings$mcpServers$scope$de._(_root);
	@override late final Translations$settings$mcpServers$config$de config = Translations$settings$mcpServers$config$de._(_root);
	@override late final Translations$settings$mcpServers$tools$de tools = Translations$settings$mcpServers$tools$de._(_root);
	@override late final Translations$settings$mcpServers$actions$de actions = Translations$settings$mcpServers$actions$de._(_root);
	@override late final Translations$settings$mcpServers$help$de help = Translations$settings$mcpServers$help$de._(_root);
	@override late final Translations$settings$mcpServers$managed$de managed = Translations$settings$mcpServers$managed$de._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$de deleteConfirm = Translations$settings$mcpServers$deleteConfirm$de._(_root);
}

// Path: settings.quota
class Translations$settings$quota$de extends Translations$settings$quota$en {
	Translations$settings$quota$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$de settings = Translations$settings$quota$settings$de._(_root);
	@override late final Translations$settings$quota$empty$de empty = Translations$settings$quota$empty$de._(_root);
	@override late final Translations$settings$quota$quality$de quality = Translations$settings$quota$quality$de._(_root);
	@override String get syncFailed => 'Synchronisierung fehlgeschlagen';
	@override String get syncNow => 'Jetzt synchronisieren';
}

// Path: settings.browser
class Translations$settings$browser$de extends Translations$settings$browser$en {
	Translations$settings$browser$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get checking => 'prüfe...';
	@override String get description => 'Erlaube Agenten, überwachte Playwright-Browser-Sitzungen zu erstellen, die du im Browser-Tab beobachten kannst.';
	@override String get enableDescription => 'Registriert Browser für unterstützte Agenten. Agenten können Browser-Sitzungen erstellen; du kannst sie ansehen, stoppen und löschen.';
	@override String get enableLabel => 'Browser aktivieren';
	@override late final Translations$settings$browser$errors$de errors = Translations$settings$browser$errors$de._(_root);
	@override String get installHint => 'Installiere die Browser-Runtime, bevor Agenten Browser-Sitzungen erstellen können.';
	@override String get installRuntime => 'Runtime installieren';
	@override String get installed => 'installiert';
	@override String get installing => 'Installiere...';
	@override String get missing => 'fehlt';
	@override String get runtimeRequired => 'Browser-Runtime erforderlich';
	@override String get statusDisabled => 'deaktiviert';
	@override String get statusLabel => 'Status';
	@override String get statusReady => 'bereit';
	@override String get statusSetupRequired => 'Einrichtung erforderlich';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$de extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get create => 'Workspace hinzufügen';
	@override String get deleteConfirm => 'Diesen Workspace aus ddagent entfernen? Seine Dateien bleiben auf der Festplatte.';
	@override String get deleteFailed => 'Workspace konnte nicht entfernt werden.';
	@override String get deleteTitle => 'Workspace entfernen';
	@override String get description => 'Workspaces sind Verzeichnisse, in denen ddagent chatten, Code ausführen und browsen kann.';
	@override String get remove => 'Workspace entfernen';
	@override String get title => 'Arbeitsbereiche';
	@override String get pathRequired => 'Pfad ist erforderlich';
}

// Path: settings.about
class Translations$settings$about$de extends Translations$settings$about$en {
	Translations$settings$about$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Unterstütze das Projekt';
	@override String get buyMeACoffee => 'Buy Me a Coffee';
	@override String get learnMore => 'Mehr erfahren';
	@override late final Translations$settings$about$pro$de pro = Translations$settings$about$pro$de._(_root);
	@override String get proFeatures => 'ddagent Pro-Funktionen';
	@override String get tryHosted => 'ddagent Hosted testen';
	@override String get versionInfo => 'Versionsinfo';
	@override String get client => 'App';
	@override String get server => 'Server';
	@override String get platformMobile => 'Mobil';
	@override String get platformDesktop => 'Desktop';
	@override String get platformWeb => 'Web';
	@override String get unknown => 'unbekannt';
}

// Path: sidebar.projects
class Translations$sidebar$projects$de extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Projekte';
	@override String get newProject => 'Neues Projekt';
	@override String get deleteProject => 'Projekt entfernen';
	@override String get renameProject => 'Projekt umbenennen';
	@override String get noProjects => 'Keine Projekte gefunden';
	@override String get loadingProjects => 'Projekte werden geladen...';
	@override String get searchPlaceholder => 'Projekte durchsuchen...';
	@override String get projectNamePlaceholder => 'Projektname';
	@override String get starred => 'Favoriten';
	@override String get all => 'Alle';
	@override String get untitledSession => 'Unbenannte Sitzung';
	@override String get newSession => 'Neue Sitzung';
	@override String get codexSession => 'Codex-Sitzung';
	@override String get fetchingProjects => 'Deine Claude-Projekte und -Sitzungen werden abgerufen';
	@override String get projects => 'Projekte';
	@override String get noMatchingProjects => 'Keine passenden Projekte';
	@override String get tryDifferentSearch => 'Versuch, den Suchbegriff anzupassen';
	@override String get runClaudeCli => 'Führ Claude CLI in einem Projektverzeichnis aus, um zu beginnen';
}

// Path: sidebar.app
class Translations$sidebar$app$de extends Translations$sidebar$app$en {
	Translations$sidebar$app$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'ddagent';
	@override String get subtitle => 'KI-Programmierassistent-Oberfläche';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$de extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sitzungen';
	@override String get newSession => 'Neue Sitzung';
	@override String get deleteSession => 'Sitzung löschen';
	@override String get renameSession => 'Sitzung umbenennen';
	@override String get noSessions => 'Noch keine Sitzungen';
	@override String get loadingSessions => 'Sitzungen werden geladen...';
	@override String get unnamed => 'Unbenannt';
	@override String get loading => 'Lädt...';
	@override String get showMore => 'Weitere Sitzungen anzeigen';
	@override String get selectMode => 'Auswählen';
	@override String get selectAll => 'Alle auswählen';
	@override String archiveSelected({required Object count}) => 'Archivieren (${count})';
	@override String deleteSelected({required Object count}) => 'Löschen (${count})';
	@override String get cancelSelection => 'Auswahl abbrechen';
	@override String get toggleSelection => 'Sitzungsauswahl umschalten';
	@override String get selectionToolbar => 'Aktionen zur Sitzungsauswahl';
	@override String get options => 'Sitzungsoptionen';
	@override String get pinSession => 'Sitzung anheften';
	@override String get unpinSession => 'Sitzung lösen';
	@override String get pinned => 'Angeheftete Sitzung';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} ausgewählt',
		other: '${count} ausgewählt',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$de extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Umgebungen anzeigen';
	@override String get hideSidebar => 'Seitenleiste ausblenden';
	@override String get createProject => 'Neues Projekt erstellen';
	@override String get refresh => 'Projekte und Sitzungen aktualisieren (Strg+R)';
	@override String get renameProject => 'Projekt umbenennen (F2)';
	@override String get deleteProject => 'Projekt aus Seitenleiste entfernen (Entf)';
	@override String get addToFavorites => 'Zu Favoriten hinzufügen';
	@override String get removeFromFavorites => 'Aus Favoriten entfernen';
	@override String get editSessionName => 'Sitzungsname manuell bearbeiten';
	@override String get deleteSession => 'Diese Sitzung dauerhaft löschen';
	@override String get activeSessionIndicator => 'Kürzlich aktive Sitzung (letzte 10 Minuten)';
	@override String get save => 'Speichern';
	@override String get cancel => 'Abbrechen';
	@override String get clearSearch => 'Suche leeren';
	@override String get openCommandPalette => 'Befehlspalette öffnen';
	@override String get attentionRequiredIndicator => 'Sitzung erfordert Aufmerksamkeit';
	@override String get openSessions => 'Sitzungen durchsuchen';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$de extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get files => 'Dateien';
	@override String get git => 'Git';
	@override String get terminal => 'Terminal';
	@override String get tasks => 'Aufgaben';
}

// Path: sidebar.actions
class Translations$sidebar$actions$de extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Aktualisieren';
	@override String get settings => 'Einstellungen';
	@override String get collapseAll => 'Alle einklappen';
	@override String get expandAll => 'Alle ausklappen';
	@override String get cancel => 'Abbrechen';
	@override String get save => 'Speichern';
	@override String get delete => 'Löschen';
	@override String get rename => 'Umbenennen';
	@override String get joinCommunity => 'Community beitreten';
	@override String get reportIssue => 'Problem melden';
	@override String get starOnGithub => 'Stern auf GitHub';
	@override String get buyMeACoffee => 'Buy Me a Coffee';
}

// Path: sidebar.branding
class Translations$sidebar$branding$de extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Open Source';
}

// Path: sidebar.status
class Translations$sidebar$status$de extends Translations$sidebar$status$en {
	Translations$sidebar$status$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get active => 'Aktiv';
	@override String get inactive => 'Inaktiv';
	@override String get thinking => 'Denkt nach...';
	@override String get error => 'Fehler';
	@override String get aborted => 'Abgebrochen';
	@override String get unknown => 'Unbekannt';
}

// Path: sidebar.time
class Translations$sidebar$time$de extends Translations$sidebar$time$en {
	Translations$sidebar$time$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Gerade eben';
	@override String get oneMinuteAgo => 'vor 1 Min.';
	@override String minutesAgo({required Object count}) => 'vor ${count} Min.';
	@override String get oneHourAgo => 'vor 1 Std.';
	@override String hoursAgo({required Object count}) => 'vor ${count} Std.';
	@override String get oneDayAgo => 'vor 1 Tag';
	@override String daysAgo({required Object count}) => 'vor ${count} Tagen';
}

// Path: sidebar.messages
class Translations$sidebar$messages$de extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => 'Möchtest du das wirklich löschen?';
	@override String get renameSuccess => 'Erfolgreich umbenannt';
	@override String get deleteSuccess => 'Erfolgreich gelöscht';
	@override String get errorOccurred => 'Ein Fehler ist aufgetreten';
	@override String get deleteSessionConfirm => 'Möchtest du diese Sitzung wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
	@override String get deleteProjectConfirm => 'Projekt aus der Seitenleiste entfernen? Deine Projektdateien, Erinnerungen und Sitzungsdaten werden nicht gelöscht.';
	@override String get enterProjectPath => 'Bitte gib einen Projektpfad ein';
	@override String get deleteSessionFailed => 'Sitzung konnte nicht gelöscht werden. Bitte erneut versuchen.';
	@override String get deleteSessionError => 'Fehler beim Löschen der Sitzung. Bitte erneut versuchen.';
	@override String get renameSessionFailed => 'Sitzung konnte nicht umbenannt werden. Bitte erneut versuchen.';
	@override String get renameSessionError => 'Fehler beim Umbenennen der Sitzung. Bitte erneut versuchen.';
	@override String get deleteProjectFailed => 'Projekt konnte nicht entfernt werden. Bitte erneut versuchen.';
	@override String get deleteProjectError => 'Fehler beim Entfernen des Projekts. Bitte erneut versuchen.';
	@override String get createProjectFailed => 'Projekt konnte nicht erstellt werden. Bitte erneut versuchen.';
	@override String get createProjectError => 'Fehler beim Erstellen des Projekts. Bitte erneut versuchen.';
	@override String get updateProjectError => 'Fehler beim Aktualisieren des Projekts. Bitte erneut versuchen.';
	@override String get refreshError => 'Aktualisierung fehlgeschlagen. Bitte erneut versuchen.';
	@override String get restoreProjectFailed => 'Projekt konnte nicht wiederhergestellt werden. Bitte erneut versuchen.';
	@override String get restoreProjectError => 'Fehler beim Wiederherstellen des Projekts. Bitte erneut versuchen.';
	@override String get restoreSessionFailed => 'Sitzung konnte nicht wiederhergestellt werden. Bitte erneut versuchen.';
	@override String get restoreSessionError => 'Fehler beim Wiederherstellen der Sitzung. Bitte erneut versuchen.';
	@override String get changeWorkspaceFailed => 'Wechseln des Arbeitsbereichs fehlgeschlagen. Bitte erneut versuchen.';
	@override String get changeWorkspaceError => 'Fehler beim Wechseln des Arbeitsbereichs. Bitte erneut versuchen.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'Löschen von ${count} Sitzung fehlgeschlagen. Bitte erneut versuchen.',
		other: 'Löschen von ${count} Sitzungen fehlgeschlagen. Bitte erneut versuchen.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$de extends Translations$sidebar$version$en {
	Translations$sidebar$version$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Update verfügbar';
	@override String get restartRequired => 'Update installiert – zum Anwenden Server neu starten';
	@override String get updateNow => 'Jetzt aktualisieren';
	@override String updateConfirm({required Object version}) => 'ddagent auf v${version} aktualisieren? Der neueste Code wird geholt und gebaut, der Server startet neu — aktive Sitzungen werden unterbrochen.';
	@override String get updating => 'Aktualisierung läuft… kann ein paar Minuten dauern';
	@override String get restarting => 'Update installiert — Neustart…';
	@override String get updateFailed => 'Update fehlgeschlagen';
	@override String get releaseNotes => 'Versionshinweise';
}

// Path: sidebar.search
class Translations$sidebar$search$de extends Translations$sidebar$search$en {
	Translations$sidebar$search$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Projekte';
	@override String get modeConversations => 'Unterhaltungen';
	@override String get conversationsPlaceholder => 'In Unterhaltungen suchen...';
	@override String get searching => 'Sucht...';
	@override String get sessionTitles => 'Sitzungstitel';
	@override String get conversationContents => 'Unterhaltungsinhalte';
	@override String get noResults => 'Keine Ergebnisse gefunden';
	@override String get tryDifferentQuery => 'Versuch eine andere Suchanfrage';
	@override String get modeRunning => 'Läuft';
	@override String get archiveOnly => 'Archiv';
	@override String get runningTooltip => 'Laufende Sitzungen';
	@override String get archiveOnlyTooltip => 'Nur Archiv';
	@override String runningCount({required Object count}) => '${count} aktiv';
	@override String get viewMenu => 'Ansicht';
	@override String get backToProjects => 'Zurück zu Projekten';
	@override String get archivedPlaceholder => 'Archivierte Sitzungen durchsuchen...';
	@override String get runningPlaceholder => 'Laufende Sitzungen durchsuchen...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} Treffer',
		other: '${count} Treffer',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} Projekt durchsucht',
		other: '${count} Projekte durchsucht',
	);
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$de extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Projekt entfernen';
	@override String get deleteSession => 'Sitzung löschen';
	@override String get confirmDelete => 'Was möchtest du mit';
	@override String get removeFromSidebar => 'Nur aus der Seitenleiste entfernen';
	@override String get deleteAllData => 'Alle Daten dauerhaft löschen';
	@override String get allConversationsDeleted => 'Das Projekt wird aus der Seitenleiste entfernt. Deine Dateien, Erinnerungen und Sitzungsdaten bleiben erhalten.';
	@override String get cannotUndo => 'Du kannst das Projekt später erneut hinzufügen.';
	@override String get bulkDeleteSessionsDescription => 'Archivieren blendet die ausgewählten Sitzungen aus der aktiven Liste aus und bewahrt ihre Verläufe.';
	@override String get archiveSession => 'Sitzung archivieren';
	@override String get archiveSessionNotice => 'Archivieren hält die Sitzung aus der aktiven Liste, bewahrt aber ihren Verlauf.';
	@override String get archivedSessionNotice => 'Diese Sitzung ist bereits archiviert. Du kannst sie verborgen halten oder dauerhaft löschen.';
	@override String get deleteSessionNotice => 'Dies entfernt die Sitzung und ihr Transkript dauerhaft. Diese Aktion kann nicht rückgängig gemacht werden.';
	@override String get deleteSessionPermanently => 'Endgültig löschen';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'Dieses Projekt enthält ${count} Unterhaltung.',
		other: 'Dieses Projekt enthält ${count} Unterhaltungen.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'Ausgewählte Sitzung verwalten',
		other: '${count} ausgewählte Sitzungen verwalten',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'Sitzung archivieren',
		other: '${count} Sitzungen archivieren',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$de extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Jetzt aktiv';
	@override String get recent => 'Zuletzt verwendet';
	@override String get today => 'Heute';
	@override String get yesterday => 'Gestern';
	@override String get thisWeek => 'Diese Woche';
	@override String showMore({required Object count}) => '${count} weitere anzeigen';
	@override String get showLess => 'Weniger anzeigen';
}

// Path: sidebar.panel
class Translations$sidebar$panel$de extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get open => 'Panel';
	@override String get newChat => 'Neuer Chat';
	@override String get navigation => 'Navigation';
	@override String get sessions => 'Sitzungen';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$de extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sitzungs-Arbeitsbereich wechseln';
	@override String get description => 'Der Agent führt seine nächsten Schritte in diesem Verzeichnis aus. Der vorhandene Sitzungsverlauf bleibt erhalten.';
	@override String get pathLabel => 'Arbeitsbereich-Pfad';
	@override String get pathRequired => 'Arbeitsbereich-Pfad ist erforderlich.';
	@override String get submit => 'Arbeitsbereich wechseln';
	@override String get saving => 'Wechsel läuft…';
	@override String get changeAction => 'Arbeitsbereich wechseln';
}

// Path: sidebar.recent
class Translations$sidebar$recent$de extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Letzte Unterhaltungen';
	@override String get emptyTitle => 'Noch keine Unterhaltungen';
	@override String get emptyDescription => 'Deine zuletzt aktualisierten Unterhaltungen erscheinen hier.';
	@override String get loadFailed => 'Letzte Unterhaltungen konnten nicht geladen werden';
	@override String get loadMore => 'Ältere Unterhaltungen laden';
	@override String get loadingMore => 'Mehr laden...';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$de extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get board => 'Agent-Board';
	@override String get files => 'Dateien';
	@override String get git => 'Quellcodeverwaltung';
	@override String get tasks => 'Aufgaben';
	@override String get usage => 'Quota & Nutzung';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$de extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI ist nicht konfiguriert';
	@override String get description => 'TaskMaster hilft dabei, komplexe Projekte mit KI-Unterstützung in überschaubare Aufgaben aufzuteilen';
	@override String get whatIsTitle => '🎯 Was ist TaskMaster?';
	@override late final Translations$tasks$notConfigured$features$de features = Translations$tasks$notConfigured$features$de._(_root);
	@override String get initializeButton => 'TaskMaster AI initialisieren';
	@override String get writePrdFirst => 'Zuerst PRD schreiben';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$de extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Erste Schritte mit TaskMaster';
	@override String get subtitle => 'TaskMaster ist initialisiert! Hier ist, was du als Nächstes tun kannst:';
	@override late final Translations$tasks$gettingStarted$steps$de steps = Translations$tasks$gettingStarted$steps$de._(_root);
	@override String get tip => '💡 Tipp: Beginne mit einem PRD, um das Beste aus TaskMasters KI-gestützter Aufgabengenerierung herauszuholen';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$de extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster-Einrichtung';
	@override String subtitle({required Object projectName}) => 'Interaktives CLI für ${projectName}';
	@override String get willStart => 'Die TaskMaster-Initialisierung startet automatisch';
	@override String get completed => 'TaskMaster-Einrichtung abgeschlossen! Du kannst dieses Fenster jetzt schließen.';
	@override String get closeButton => 'Schließen';
	@override String get closeContinueButton => 'Schließen & Fortfahren';
	@override String get closeTitle => 'Schließen';
	@override String get description => 'Erstellt einen .taskmaster-Ordner in diesem Projekt. Keine externen Tools oder API-Schlüssel erforderlich — Aufgaben werden lokal gespeichert.';
	@override String get initializeButton => 'Initialisieren';
	@override String get initializing => 'Initialisiere...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$de extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Erste Schritte mit TaskMaster';
	@override String get subtitle => 'Dein Leitfaden für produktives Aufgabenmanagement';
	@override late final Translations$tasks$helpGuide$examples$de examples = Translations$tasks$helpGuide$examples$de._(_root);
	@override String get moreExamples => 'Weitere Beispiele und Verwendungsmuster anzeigen →';
	@override late final Translations$tasks$helpGuide$proTips$de proTips = Translations$tasks$helpGuide$proTips$de._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$de learnMore = Translations$tasks$helpGuide$learnMore$de._(_root);
	@override String get closeTitle => 'Schließen';
}

// Path: tasks.search
class Translations$tasks$search$de extends Translations$tasks$search$en {
	Translations$tasks$search$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Aufgaben suchen...';
}

// Path: tasks.filters
class Translations$tasks$filters$de extends Translations$tasks$filters$en {
	Translations$tasks$filters$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get button => 'Filter';
	@override String get status => 'Status';
	@override String get priority => 'Priorität';
	@override String get sortBy => 'Sortieren nach';
	@override String get allStatuses => 'Alle Status';
	@override String get allPriorities => 'Alle Prioritäten';
	@override String showing({required Object filtered, required Object total}) => '${filtered} von ${total} Aufgaben werden angezeigt';
	@override String get clearFilters => 'Filter zurücksetzen';
}

// Path: tasks.sort
class Translations$tasks$sort$de extends Translations$tasks$sort$en {
	Translations$tasks$sort$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Status';
	@override String get priority => 'Priorität';
	@override String get idAsc => 'ID (aufsteigend)';
	@override String get idDesc => 'ID (absteigend)';
	@override String get titleAsc => 'Titel (A-Z)';
	@override String get titleDesc => 'Titel (Z-A)';
	@override String get statusAsc => 'Status (Ausstehend zuerst)';
	@override String get statusDesc => 'Status (Erledigt zuerst)';
	@override String get priorityAsc => 'Priorität (Hoch zuerst)';
	@override String get priorityDesc => 'Priorität (Niedrig zuerst)';
}

// Path: tasks.views
class Translations$tasks$views$de extends Translations$tasks$views$en {
	Translations$tasks$views$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Kanban-Ansicht';
	@override String get list => 'Listenansicht';
	@override String get grid => 'Rasteransicht';
}

// Path: tasks.kanban
class Translations$tasks$kanban$de extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 Ausstehend';
	@override String get inProgress => '🚀 In Bearbeitung';
	@override String get review => '👀 Review';
	@override String get done => '✅ Erledigt';
	@override String get blocked => '🚫 Blockiert';
	@override String get deferred => '⏳ Zurückgestellt';
	@override String get cancelled => '❌ Abgebrochen';
	@override String get noTasksYet => 'Noch keine Aufgaben';
	@override String get tasksWillAppear => 'Aufgaben werden hier angezeigt';
	@override String get moveTasksHere => 'Aufgaben hierher verschieben, wenn sie gestartet werden';
	@override String get completedTasksHere => 'Abgeschlossene Aufgaben erscheinen hier';
	@override String get statusTasksHere => 'Aufgaben mit diesem Status werden hier angezeigt';
}

// Path: tasks.buttons
class Translations$tasks$buttons$de extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get help => 'TaskMaster-Leitfaden für Erste Schritte';
	@override String get prds => 'PRDs';
	@override String get addPRD => 'PRD hinzufügen';
	@override String get addTask => 'Aufgabe hinzufügen';
	@override String get createNewPRD => 'Neues PRD erstellen';
	@override String prdsAvailable({required Object count}) => '${count} PRD(s) verfügbar';
}

// Path: tasks.prd
class Translations$tasks$prd$de extends Translations$tasks$prd$en {
	Translations$tasks$prd$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Geändert: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String fileExistsMessage({required Object name}) => 'Ein PRD mit dem Namen „${name}“ existiert bereits. Möchtest du es überschreiben?';
	@override String get fileExistsTitle => 'Datei existiert bereits';
	@override String get newFile => 'neue Datei';
	@override String get parse => 'PRD analysieren';
	@override String get template => 'Vorlage';
	@override String get fileNameHint => 'Dateiname (z. B. prd.txt)';
	@override String get saved => 'PRD gespeichert';
	@override String get tasksGenerated => 'Aufgaben aus PRD generiert';
}

// Path: tasks.statuses
class Translations$tasks$statuses$de extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Ausstehend';
	@override String get inProgress => 'In Bearbeitung';
	@override String get done => 'Erledigt';
	@override String get blocked => 'Blockiert';
	@override String get deferred => 'Zurückgestellt';
	@override String get cancelled => 'Abgebrochen';
	@override String get review => 'Überprüfung';
}

// Path: tasks.priorities
class Translations$tasks$priorities$de extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get high => 'Hoch';
	@override String get medium => 'Mittel';
	@override String get low => 'Niedrig';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$de extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Keine Aufgaben entsprechen deinen Filtern';
	@override String get description => 'Versuche, deine Such- oder Filterkriterien anzupassen.';
}

// Path: tasks.board
class Translations$tasks$board$de extends Translations$tasks$board$en {
	Translations$tasks$board$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Agent-Board';
	@override String get subtitle => 'Verschiebe eine Karte auf Bereit und der Agent nimmt sie auf. Klicke auf eine Karte, um ihre Sitzung zu öffnen.';
	@override String get newCard => 'Neue Karte';
	@override String get addCard => 'Karte hinzufügen';
	@override String get refresh => 'Aktualisieren';
	@override late final Translations$tasks$board$empty$de empty = Translations$tasks$board$empty$de._(_root);
	@override late final Translations$tasks$board$columns$de columns = Translations$tasks$board$columns$de._(_root);
	@override late final Translations$tasks$board$card$de card = Translations$tasks$board$card$de._(_root);
	@override late final Translations$tasks$board$dialog$de dialog = Translations$tasks$board$dialog$de._(_root);
	@override String get noProject => 'Füge zuerst ein Projekt hinzu und erstelle dann Karten dafür.';
	@override String get projectLabel => 'Projekt';
	@override String get backToChat => 'Zurück zum Chat';
	@override late final Translations$tasks$board$agent$de agent = Translations$tasks$board$agent$de._(_root);
	@override late final Translations$tasks$board$deleteConfirm$de deleteConfirm = Translations$tasks$board$deleteConfirm$de._(_root);
	@override String get project => 'Projekt';
}

// Path: tasks.card
class Translations$tasks$card$de extends Translations$tasks$card$en {
	Translations$tasks$card$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Abhängig von: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Aufgabe ${id}';
	@override String get highPriority => 'Hohe Priorität';
	@override String get lowPriority => 'Niedrige Priorität';
	@override String get mediumPriority => 'Mittlere Priorität';
	@override String get noPriority => 'Keine Priorität gesetzt';
	@override String parentTask({required Object id}) => 'Aufgabe ${id}';
	@override String get progressLabel => 'Fortschritt:';
	@override String progressTooltip({required Object completed, required Object total}) => '${completed} von ${total} Teilaufgaben abgeschlossen';
	@override String get runTask => 'Aufgabe ausführen';
	@override String runTaskAria({required Object id}) => 'Aufgabe ${id} ausführen';
	@override String statusTooltip({required Object status}) => 'Status: ${status}';
	@override String taskIdTitle({required Object id}) => 'Aufgaben-ID: ${id}';
	@override String get taskInProgress => 'Aufgabe in Bearbeitung';
}

// Path: tasks.createTask
class Translations$tasks$createTask$de extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get descriptionLabel => 'Beschreibung';
	@override String get descriptionPlaceholder => 'Optionale Details';
	@override String get error => 'Aufgabe konnte nicht hinzugefügt werden';
	@override String get priorityLabel => 'Priorität';
	@override String get submit => 'Aufgabe hinzufügen';
	@override String get submitting => 'Füge hinzu...';
	@override String get title => 'Aufgabe hinzufügen';
	@override String get titleLabel => 'Titel';
	@override String get titlePlaceholder => 'Was muss erledigt werden?';
}

// Path: tasks.list
class Translations$tasks$list$de extends Translations$tasks$list$en {
	Translations$tasks$list$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Abgeschlossen (klicken zum Wiederöffnen)';
	@override String get inProgressComplete => 'In Bearbeitung (klicken zum Abschließen)';
	@override String get markCompleted => 'Als abgeschlossen markieren';
	@override String toggleStatusAria({required Object id}) => 'Status von Aufgabe ${id} umschalten';
	@override String get markDone => 'Als erledigt markieren';
	@override String get reopen => 'Wieder öffnen';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$de extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Alle Aufgaben abgeschlossen';
	@override String get feature1 => '- KI-gestützte Aufgabenverwaltung mit Abhängigkeiten und Teilaufgaben.';
	@override String get feature2 => '- PRD-basierte Aufgabengenerierung für schnelleren Projektstart.';
	@override String get feature3 => '- Kanban- und Listenansichten für die tägliche Arbeit.';
	@override String get hideDetails => 'Details ausblenden';
	@override String get initialize => 'Initialisieren';
	@override String get noPending => 'Keine ausstehenden Aufgaben';
	@override String get notConfigured => 'TaskMaster AI ist nicht konfiguriert';
	@override String get review => 'Überprüfen';
	@override String get startTask => 'Aufgabe starten';
	@override String taskId({required Object id}) => 'Aufgabe ${id}';
	@override String get viewAll => 'Alle Aufgaben anzeigen';
	@override String get viewDetails => 'Aufgabendetails anzeigen';
	@override String get whatIs => 'Was ist TaskMaster?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$de extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Bearbeiten abbrechen';
	@override String get close => 'Schließen';
	@override String get copyTaskId => 'Aufgaben-ID kopieren';
	@override String get delete => 'Aufgabe löschen';
	@override String deleteConfirmDescription({required Object title}) => '„${title}" wird dauerhaft gelöscht.';
	@override String get deleteConfirmTitle => 'Aufgabe löschen?';
	@override String get deleteFailed => 'Aufgabe konnte nicht gelöscht werden';
	@override String get dependencies => 'Abhängigkeiten';
	@override String get dependenciesPlaceholder => 'z. B. 1, 2, 3';
	@override String get description => 'Beschreibung';
	@override String get edit => 'Aufgabe bearbeiten';
	@override String get implDetails => 'Implementierungsdetails';
	@override String get noDependencies => 'Keine Abhängigkeiten';
	@override String get noDescription => 'Keine Beschreibung vorhanden';
	@override String get priority => 'Priorität';
	@override String get priorityNotSet => 'Nicht gesetzt';
	@override String get save => 'Speichern';
	@override String get status => 'Status';
	@override String get statusFailed => 'Aufgabenstatus konnte nicht aktualisiert werden';
	@override String taskId({required Object id}) => 'Aufgabe ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Aufgabe ${id}: ${title}';
	@override String get testStrategy => 'Teststrategie';
	@override String get titleRequired => 'Titel ist erforderlich';
	@override String get updateFailed => 'Aufgabe konnte nicht aktualisiert werden';
	@override String deleteConfirmMessage({required Object id}) => 'Aufgabe #${id} wird entfernt. Dies kann nicht rückgängig gemacht werden.';
	@override String get notFound => 'Aufgabe nicht gefunden';
	@override String get subtasks => 'Unteraufgaben';
	@override String get idCopied => 'Aufgaben-ID kopiert';
}

// Path: tasks.toasts
class Translations$tasks$toasts$de extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Aufgabe ${id} auf „In Bearbeitung“ gesetzt';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$de extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Übersicht';
	@override String get memories => 'Erinnerungen';
	@override String get rules => 'Regeln';
	@override String get skills => 'Fähigkeiten';
	@override String get personal => 'Persönlich';
	@override String get graph => 'Graph';
}

// Path: knowledge.common
class Translations$knowledge$common$de extends Translations$knowledge$common$en {
	Translations$knowledge$common$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get add => 'Hinzufügen';
	@override String get save => 'Speichern';
	@override String get cancel => 'Abbrechen';
	@override String get delete => 'Löschen';
	@override String get edit => 'Bearbeiten';
	@override String get close => 'Schließen';
	@override String get restore => 'Wiederherstellen';
	@override String get refresh => 'Aktualisieren';
	@override String get allProjects => 'Alle Projekte';
	@override String get global => 'Global';
}

// Path: knowledge.actions
class Translations$knowledge$actions$de extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Projektdateien scannen';
	@override String get export => 'JSON exportieren';
	@override String get import => 'JSON importieren';
	@override String get scanComplete => 'Projekt-Scan abgeschlossen';
	@override String get importComplete => 'Import abgeschlossen';
	@override String get importFailed => 'Import fehlgeschlagen';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$de extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Neuer Eintrag';
	@override String get editEntity => 'Eintrag bearbeiten';
	@override String get deleteTitle => 'Löschen';
	@override String get deleteMessage => 'Diesen Eintrag löschen? Das kann nicht rückgängig gemacht werden (Verlauf bleibt erhalten).';
	@override String get pickIcon => 'Symbol wählen';
	@override String get removeIcon => 'Symbol entfernen';
	@override String get iconTooLarge => 'Symbol ist zu groß (max. 40 KB).';
	@override String get importTitle => 'Wissen importieren';
	@override String get importHint => 'Exportiertes JSON hier einfügen';
	@override String get exportTitle => 'Wissen exportieren';
	@override String get import => 'Importieren';
}

// Path: knowledge.fields
class Translations$knowledge$fields$de extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get key => 'Schlüssel';
	@override String get title => 'Titel';
	@override String get name => 'Name';
	@override String get description => 'Beschreibung';
	@override String get category => 'Kategorie';
	@override String get content => 'Inhalt';
	@override String get priority => 'Priorität';
	@override String get tags => 'Tags';
	@override String get enabled => 'Aktiviert';
	@override String get projectScope => 'Projektbereich';
	@override String get tagsHint => 'durch Kommas getrennt';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$de extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Erinnerungen';
	@override String get rules => 'Regeln';
	@override String get skills => 'Fähigkeiten';
	@override String get personal => 'Persönlich';
	@override String get connections => 'Verbindungen';
	@override String get recent => 'Letzte Erinnerungen';
	@override String get noMemories => 'Noch keine Erinnerungen. Füge eine im Tab Erinnerungen hinzu.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$de extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Noch keine Erinnerungen.';
	@override String get rules => 'Noch keine Regeln.';
	@override String get skills => 'Noch keine Fähigkeiten.';
	@override String get personal => 'Noch keine persönlichen Daten.';
	@override String get graph => 'Noch keine Entitäten für den Graphen.';
}

// Path: knowledge.history
class Translations$knowledge$history$de extends Translations$knowledge$history$en {
	Translations$knowledge$history$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Verlauf';
	@override String get none => 'Noch kein Verlauf.';
	@override String get untitled => '(ohne Titel)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$de extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Kritisch';
	@override String get high => 'Hoch';
	@override String get normal => 'Normal';
	@override String get low => 'Niedrig';
}

// Path: knowledge.search
class Translations$knowledge$search$de extends Translations$knowledge$search$en {
	Translations$knowledge$search$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Wissen durchsuchen';
	@override String get hint => 'Erinnerungen, Regeln, Fähigkeiten suchen…';
	@override String get noResults => 'Keine Ergebnisse.';
}

// Path: knowledge.links
class Translations$knowledge$links$de extends Translations$knowledge$links$en {
	Translations$knowledge$links$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Entitäten verknüpfen';
	@override String get source => 'Quelle';
	@override String get target => 'Ziel';
	@override String get relationship => 'Beziehung';
	@override String get add => 'Verknüpfung erstellen';
}

// Path: knowledge.tags
class Translations$knowledge$tags$de extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get all => 'Alle Tags';
	@override String get manage => 'Tags verwalten';
	@override String get none => 'Noch keine Tags.';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$de extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
}

// Path: knowledge.critical
class Translations$knowledge$critical$de extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get make => 'Als kritisch markieren';
	@override String get makeAll => 'Alle Regeln als kritisch markieren';
	@override String get makeAllHint => 'Fügt sie zum injizierten Kontextbudget hinzu';
}

// Path: knowledge.errors
class Translations$knowledge$errors$de extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'Import fehlgeschlagen: ${error}';
	@override String migrationFailed({required Object error}) => 'Migration fehlgeschlagen: ${error}';
}

// Path: knowledge.graph
class Translations$knowledge$graph$de extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'gekürzt';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$de extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get action => 'Alles importieren';
	@override String get mergeDuplicates => 'Doppelte Einträge zusammenführen';
	@override String get mergeDuplicatesHint => 'Führt doppelte Zeilen in ddagent zusammen (keine Dateien)';
	@override String projectsScanned({required Object count}) => 'Gescannte Projekte: ${count}';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Regeln: ${total} · doppelte Gruppen: ${duplicates}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Agent-Skills gefunden: ${found} (neu: ${newSkills})';
	@override String get title => 'Alles in ddagent importieren';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$de extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String found({required Object count}) => '${count} Skill(s) bei deinen Agenten gefunden.';
	@override String summary({required Object imported, required Object skipped}) => 'Neu: ${imported} · übersprungen: ${skipped}';
	@override String get title => 'Agent-Skills importieren';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$de extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Erinnerung: ${title}';
	@override String personal({required Object title}) => 'Persönlich: ${title}';
	@override String rule({required Object title}) => 'Regel: ${title}';
	@override String skill({required Object name}) => 'Skill: ${name}';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$de extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String duplicates({required Object count}) => 'Doppelte Gruppen über Projekte: ${count}';
	@override String get mergeDuplicates => 'Duplikate zusammenführen';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Entfernt: ${removed}, hochgestuft: ${promoted}';
	@override String rulesSummary({required Object total, required Object critical}) => 'Regeln: ${total} gesamt, ${critical} kritisch.';
	@override String scanned({required Object count}) => '${count} Projekt(e) gescannt.';
	@override String get title => 'Vorhandene Regeln migrieren';
}

// Path: skills.addDialog
class Translations$skills$addDialog$de extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => 'SKILL.md wählen';
	@override String get chooseFiles => 'Dateien wählen';
	@override String get chooseFolder => 'Ordner wählen';
	@override String get chooseFolderTitle => 'Skill-Ordner wählen';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} Datei · ${size}',
		other: '${count} Dateien · ${size}',
	);
	@override String get folderUploadsNote => 'Bei Ordner-Uploads bleibt der ausgewählte Ordnername erhalten; einzelne Dateien verwenden `name` aus `SKILL.md`.';
	@override String get hideInstallLocation => 'Installationspfad ausblenden';
	@override String get installSkill => 'Skill installieren';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} Skill installieren',
		other: '${count} Skills installieren',
	);
	@override String markdownFileMeta({required Object size}) => 'Markdown-Datei · ${size}';
	@override String get pickHint => 'Ordner können Skripte, Referenzen und Assets enthalten.';
	@override String get pickTitle => 'Skill-Ordner oder SKILL.md auswählen';
	@override String get readyToInstall => 'Bereit zur Installation';
	@override String removeQueued({required Object name}) => '${name} entfernen';
	@override String title({required Object provider}) => '${provider}-Skill hinzufügen';
	@override String get uploadHint => 'Lade eine SKILL.md-Datei oder einen kompletten Skill-Ordner hoch.';
	@override String get whereWillThisInstall => 'Wo wird dies installiert?';
}

// Path: skills.empty
class Translations$skills$empty$de extends Translations$skills$empty$en {
	Translations$skills$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get noGlobalSkills => 'Noch keine globalen Skills gefunden';
	@override String get noGlobalSkillsDescription => 'Füge oben einen globalen Skill hinzu, damit er in allen Projekten verfügbar ist.';
	@override String get noMatchingSkills => 'Keine passenden Skills';
	@override String get noMatchingSkillsDescription => 'Versuch es mit einem anderen Befehl, Namen, Geltungsbereich, Projekt oder Quellpfad.';
	@override String get noProjects => 'Keine Projekte verfügbar';
	@override String get noProjectsDescription => 'Füge ein Projekt oder einen Workspace hinzu, um seine Skills zu durchsuchen.';
	@override String get noSkillsInProject => 'Keine Skills in diesem Projekt';
	@override String get noSkillsInProjectDescription => 'Erstelle im ausgewählten Projekt einen Ordner .claude/skills, .cursor/skills oder .agents/skills.';
}

// Path: skills.errors
class Translations$skills$errors$de extends Translations$skills$errors$en {
	Translations$skills$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get addMarkdownFirst => 'Füge zuerst eine oder mehrere Markdown-Dateien hinzu.';
	@override String couldNotReadSkillFile({required Object name}) => 'SKILL.md konnte nicht aus ${name} gelesen werden.';
	@override String get dropMarkdownOrFolder => 'Zieh eine oder mehrere Markdown-Dateien oder einen Ordner mit SKILL.md hierher.';
	@override String folderFileLimit({required Object count}) => 'Ein Skill-Ordner kann bis zu ${count} Dateien enthalten.';
	@override String get folderReadFailed => 'Skill-Ordner konnte nicht gelesen werden';
	@override String get folderSizeLimit => 'Ausgewählte Skill-Ordner müssen zusammen kleiner als 30 MB sein.';
	@override String get importFailed => 'Skills konnten nicht importiert werden';
	@override String get missingSkillFile => 'Der ausgewählte Ordner enthält keine SKILL.md-Datei.';
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$de extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get moveToGlobal => 'Nach Global verschieben';
	@override String get moveToProject => 'In Projekt verschieben';
	@override String get toGlobalHint => 'Verschiebe diesen Skill in das globale Skill-Verzeichnis, damit ihn jedes Projekt verwenden kann.';
	@override String get toProjectHint => 'Wähle das Projekt, dem dieser Skill gehören soll. Er wird aus dem globalen Skill-Verzeichnis des Anbieters verschoben.';
}

// Path: skills.scopes
class Translations$skills$scopes$de extends Translations$skills$scopes$en {
	Translations$skills$scopes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get admin => 'Admin';
	@override String get plugin => 'Plugin';
	@override String get project => 'Projekt';
	@override String get repo => 'Repo';
	@override String get system => 'System';
	@override String get user => 'Benutzer:in';
}

// Path: skills.screen
class Translations$skills$screen$de extends Translations$skills$screen$en {
	Translations$skills$screen$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get addSkill => 'Skill hinzufügen';
	@override String get clearSearch => 'Skill-Suche leeren';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Dies entfernt das Verzeichnis ${directory} aus dem verwalteten Skill-Verzeichnis von ${provider}. Dies kann nicht rückgängig gemacht werden.';
	@override String deleteTitle({required Object name}) => '${name} löschen?';
	@override String loadingSkills({required Object provider}) => '${provider}-Skills werden geladen…';
	@override String manageDescription({required Object provider}) => 'Verwalte ${provider}-Skills aus lokalen Dateien, kompletten Ordnern und projektbezogenen Speicherorten.';
	@override String get noDescription => 'Keine Beschreibung im Front Matter des Skills angegeben.';
	@override String pluginBadge({required Object name}) => 'Plugin: ${name}';
	@override String projectBadge({required Object name}) => 'Projekt: ${name}';
	@override String get savedSuccessfully => 'Skills erfolgreich gespeichert.';
	@override String get scanningProjectSkills => 'Projekt-Skills werden gescannt...';
	@override String get searchHint => 'Skills suchen...';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: '${count} SKILL',
		other: '${count} SKILLS',
	);
	@override String get sourceLabel => 'QUELLE';
}

// Path: mcp.form
class Translations$mcp$form$de extends Translations$mcp$form$en {
	Translations$mcp$form$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$fields$de fields = Translations$mcp$form$fields$de._(_root);
	@override late final Translations$mcp$form$scope$de scope = Translations$mcp$form$scope$de._(_root);
	@override String submitTo({required Object provider}) => 'Server zu ${provider} hinzufügen';
	@override late final Translations$mcp$form$validation$de validation = Translations$mcp$form$validation$de._(_root);
}

// Path: mcp.install
class Translations$mcp$install$de extends Translations$mcp$install$en {
	Translations$mcp$install$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get button => 'Installieren';
	@override String get cardDescription => 'Gib deinen Agenten die Wissensdatenbank und die ddagent-Werkzeuge über MCP — wähle Agenten aus oder installiere für alle.';
	@override String get description => 'Ermöglicht den ausgewählten Agenten die Nutzung der ddagent-Wissensdatenbank und -Werkzeuge über MCP.';
	@override String get errorFallback => 'Fehler';
	@override String failed({required Object error}) => 'Installation fehlgeschlagen: ${error}';
	@override String get installForAll => 'Für alle installieren';
	@override String get installSelected => 'Ausgewählte installieren';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'Auf ${count} Agenten installiert.',
		other: 'Auf ${count} Agenten installiert.',
	);
	@override String partialFailure({required Object count, required Object failed}) => 'Auf ${count} installiert; fehlgeschlagen: ${failed}';
	@override String get title => 'ddagent MCP-Server installieren';
}

// Path: mcp.servers
class Translations$mcp$servers$de extends Translations$mcp$servers$en {
	Translations$mcp$servers$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get addGlobalDescription => 'Fügt diesen MCP-Server zu jedem Anbieter hinzu: Claude, Cursor, Codex, OpenCode und Devin. Nur stdio- und HTTP-Transporte werden unterstützt, da dieselbe Konfiguration bei allen Anbietern funktionieren muss.';
	@override String get addGlobalMenuDescription => '„Globalen MCP-Server hinzufügen“ schreibt einen gemeinsamen stdio- oder HTTP-Server in Claude, Cursor, Codex, OpenCode und Devin.';
	@override String get addGlobalTitle => 'Globalen MCP-Server hinzufügen';
	@override String addProviderDescription({required Object provider}) => '„${provider} MCP-Server hinzufügen“ ändert nur ${provider}.';
	@override String addProviderTitle({required Object provider}) => '${provider} MCP-Server hinzufügen';
	@override late final Translations$mcp$servers$config$de config = Translations$mcp$servers$config$de._(_root);
	@override String descriptionGeneric({required Object provider}) => 'Model Context Protocol-Server stellen ${provider} zusätzliche Werkzeuge und Datenquellen bereit';
	@override String get loading => 'MCP-Server werden geladen...';
	@override String get refreshingScopes => 'Projekt-Geltungsbereiche werden aktualisiert...';
}

// Path: mcp.team
class Translations$mcp$team$de extends Translations$mcp$team$en {
	Translations$mcp$team$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cta => 'Verfügbar mit ddagent Pro';
	@override String get description => 'Teile MCP-Server-Konfigurationen mit deinem Team. Alle bleiben automatisch synchron.';
	@override String get title => 'Team-MCP-Konfigurationen';
}

// Path: mcp.tokens
class Translations$mcp$tokens$de extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Schreiben';
}

// Path: terminal.actions
class Translations$terminal$actions$de extends Translations$terminal$actions$en {
	Translations$terminal$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get clearOutput => 'Ausgabe leeren';
	@override String get connect => 'Verbinden';
	@override String get newShell => 'Neue Shell';
	@override String get newTab => 'Neuer Terminal-Tab';
	@override String get providerLogin => 'Anbieter-Anmeldung';
	@override String get restartSession => 'Sitzung neu starten';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$de extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Im Browser öffnen';
}

// Path: terminal.errors
class Translations$terminal$errors$de extends Translations$terminal$errors$en {
	Translations$terminal$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'Link konnte nicht geöffnet werden: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$de extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'Datei erkannt: ${path}';
}

// Path: terminal.paste
class Translations$terminal$paste$de extends Translations$terminal$paste$en {
	Translations$terminal$paste$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Strg+V / Rechtsklick → Einfügen';
	@override String get title => 'In Terminal einfügen';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$de extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get eof => 'EOF';
	@override String get hide => 'Tastenkürzel-Leiste ausblenden';
	@override String get interrupt => 'Unterbrechen (SIGINT)';
	@override String get suspend => 'Anhalten (SIGTSTP)';
	@override String get showTooltip => 'Tastenkürzel anzeigen';
	@override String get hideTooltip => 'Tastenkürzel ausblenden';
}

// Path: terminal.tabs
class Translations$terminal$tabs$de extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get claudeCli => 'Claude CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'Anmeldung: ${provider}';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get plainShell => 'Einfache Shell';
	@override String shellName({required Object index}) => 'Shell ${index}';
}

// Path: quota.agents
class Translations$quota$agents$de extends Translations$quota$agents$en {
	Translations$quota$agents$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.chart
class Translations$quota$chart$de extends Translations$quota$chart$en {
	Translations$quota$chart$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get hide => 'Ausblenden';
	@override String get noData => 'Nicht genug Daten für einen Trend.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} Tokens · ${cost}';
	@override String get show => 'Anzeigen';
}

// Path: quota.config
class Translations$quota$config$de extends Translations$quota$config$en {
	Translations$quota$config$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get accountRouting => 'Konto-Routing';
	@override String get pollerTitle => 'Abfrage & Warnungen';
	@override String get save => 'Konfiguration speichern';
}

// Path: quota.overview
class Translations$quota$overview$de extends Translations$quota$overview$en {
	Translations$quota$overview$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Tokens und Kosten';
}

// Path: quota.section
class Translations$quota$section$de extends Translations$quota$section$en {
	Translations$quota$section$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get config => 'Konfiguration';
}

// Path: notifications.errors
class Translations$notifications$errors$de extends Translations$notifications$errors$en {
	Translations$notifications$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get noResponse => 'Keine Antwort vom Server';
	@override String get registrationRejected => 'Registrierung vom Server abgelehnt';
}

// Path: serverConnect.local
class Translations$serverConnect$local$de extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dieses Gerät';
	@override String get subtitle => 'ddagent-Server auf diesem Rechner ausführen';
	@override String get install => 'Lokalen Server installieren';
	@override String get start => 'Lokalen Server starten';
	@override String get stop => 'Stoppen';
	@override String get starting => 'Lokaler Server wird gestartet…';
	@override String downloading({required Object percent}) => 'Server wird heruntergeladen… ${percent}%';
	@override String get installing => 'Wird installiert…';
	@override String running({required Object url}) => 'Läuft unter ${url}';
	@override String installed({required Object version}) => 'Installiert (v${version})';
	@override String get connect => 'Diesen Server verwenden';
	@override String error({required Object error}) => 'Fehler des lokalen Servers: ${error}';
	@override String get or => 'oder mit einem Remote-Server verbinden';
}

// Path: collab.roles
class Translations$collab$roles$de extends Translations$collab$roles$en {
	Translations$collab$roles$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get member => 'Mitglied';
	@override String get viewer => 'Betrachter:in';
}

// Path: sessions.activity
class Translations$sessions$activity$de extends Translations$sessions$activity$en {
	Translations$sessions$activity$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get committingChanges => 'Änderungen werden committet';
	@override String editingFile({required Object file}) => '${file} wird bearbeitet';
	@override String get editingFileGeneric => 'Eine Datei wird bearbeitet';
	@override String fetchingUrl({required Object url}) => '${url} wird abgerufen';
	@override String get pushingBranch => 'Branch wird gepusht';
	@override String readingFile({required Object file}) => '${file} wird gelesen';
	@override String runningCommand({required Object command}) => '`${command}` wird ausgeführt';
	@override String get runningShellCommand => 'Ein Shell-Befehl wird ausgeführt';
	@override String runningTool({required Object name}) => '${name} wird ausgeführt';
	@override String searching({required Object query}) => 'Suche nach „${query}“';
	@override String get subagentRunning => 'Subagent läuft';
}

// Path: sessions.age
class Translations$sessions$age$de extends Translations$sessions$age$en {
	Translations$sessions$age$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String days({required Object days}) => '${days}T';
	@override String hours({required Object hours}) => '${hours}Std.';
	@override String get lessThanMinute => '<1Min.';
	@override String minutes({required Object count}) => '${count}Min.';
}

// Path: sessions.toasts
class Translations$sessions$toasts$de extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Sitzung archiviert';
	@override String get deleted => 'Sitzung gelöscht';
	@override String get pinned => 'Sitzung angeheftet';
	@override String get renamed => 'Sitzung umbenannt';
	@override String get restored => 'Sitzung wiederhergestellt';
	@override String get unpinned => 'Sitzung gelöst';
	@override String get workspaceChanged => 'Workspace geändert';
}

// Path: git.checkpoints
class Translations$git$checkpoints$de extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get create => 'Neu';
	@override String get empty => 'Noch keine Checkpoints';
	@override String get labelHint => 'Checkpoint-Label (optional)';
	@override String get restoreMessage => 'Arbeitsverzeichnis auf diesen Checkpoint zurücksetzen? Aktuelle Änderungen werden ersetzt.';
	@override String get restoreTitle => 'Checkpoint wiederherstellen';
	@override String get restored => 'Checkpoint wiederhergestellt';
	@override String get title => 'Checkpoints';
}

// Path: kanban.card
class Translations$kanban$card$de extends Translations$kanban$card$en {
	Translations$kanban$card$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Unbenannt';
}

// Path: kanban.comments
class Translations$kanban$comments$de extends Translations$kanban$comments$en {
	Translations$kanban$comments$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get add => 'Kommentar hinzufügen';
	@override String get empty => 'Noch keine Kommentare';
}

// Path: kanban.details
class Translations$kanban$details$de extends Translations$kanban$details$en {
	Translations$kanban$details$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String status({required Object status}) => 'Status: ${status}';
	@override String get title => 'Kartendetails';
}

// Path: kanban.dialog
class Translations$kanban$dialog$de extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Speichern…';
}

// Path: kanban.empty
class Translations$kanban$empty$de extends Translations$kanban$empty$en {
	Translations$kanban$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Kein Projekt ausgewählt';
}

// Path: kanban.time
class Translations$kanban$time$de extends Translations$kanban$time$en {
	Translations$kanban$time$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'vor 1 Tag',
		other: 'vor ${count} Tagen',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'vor 1 Stunde',
		other: 'vor ${count} Stunden',
	);
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'vor 1 Minute',
		other: 'vor ${count} Minuten',
	);
	@override String get now => 'jetzt';
}

// Path: onboarding.agents
class Translations$onboarding$agents$de extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Melde dich bei einem oder mehreren KI-Programmierassistenten an. Alle sind optional.';
	@override String get laterHint => 'Du kannst diese später in den Einstellungen konfigurieren.';
	@override String get title => 'Verbinde deine KI-Agenten';
}

// Path: onboarding.errors
class Translations$onboarding$errors$de extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get invalidEmail => 'Bitte gib eine gültige E-Mail-Adresse ein.';
	@override String get nameAndEmailRequired => 'Git-Name und E-Mail sind beide erforderlich.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$de extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Installiere den ddagent MCP-Server, damit deine Agenten die Wissensdatenbank und die ddagent-Werkzeuge nutzen können. Wähle Agenten aus oder installiere für alle.';
	@override String get installForAll => 'Für alle installieren';
	@override String get installSelected => 'Ausgewählte installieren';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count,
		one: 'Auf ${count} Agenten installiert.',
		other: 'Auf ${count} Agenten installiert.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => 'Auf ${installedCount} installiert; fehlgeschlagen: ${failed}';
	@override String get laterHint => 'Optional — du kannst dies auch später unter Einstellungen → MCP installieren.';
	@override String get title => 'Agenten mit ddagent verbinden';
}

// Path: fileTree.search
class Translations$fileTree$search$de extends Translations$fileTree$search$en {
	Translations$fileTree$search$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Namen filtern / Enter, um Inhalte zu durchsuchen';
	@override String get noMatches => 'Keine Treffer';
	@override String get prompt => 'Suchbegriff eingeben und Enter drücken';
	@override String get resultsTruncated => 'Ergebnisse gekürzt';
}

// Path: fileTree.titles
class Translations$fileTree$titles$de extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String delete({required Object name}) => '${name} löschen';
	@override String download({required Object name}) => '${name} herunterladen';
	@override String rename({required Object name}) => '${name} umbenennen';
}

// Path: auth.login.errors
class Translations$auth$login$errors$de extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Ungültiger Benutzername oder Passwort';
	@override String get requiredFields => 'Bitte alle Felder ausfüllen';
	@override String get networkError => 'Netzwerkfehler. Bitte erneut versuchen.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$de extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get username => 'Benutzernamen eingeben';
	@override String get password => 'Passwort eingeben';
}

// Path: auth.register.errors
class Translations$auth$register$errors$de extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Passwörter stimmen nicht überein';
	@override String get usernameTaken => 'Benutzername ist bereits vergeben';
	@override String get weakPassword => 'Passwort ist zu schwach';
	@override String get usernameTooShort => 'Benutzername muss mindestens 3 Zeichen lang sein';
	@override String get passwordTooShort => 'Passwort muss mindestens 6 Zeichen lang sein';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$de extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Standardmodus';
	@override String get auto => 'Auto-Modus';
	@override String get acceptEdits => 'Bearbeitungen akzeptieren';
	@override String get bypassPermissions => 'Berechtigungen umgehen';
	@override String get plan => 'Planungsmodus';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$de extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Nur vertrauenswürdige Befehle (ls, cat, grep, git status usw.) werden automatisch ausgeführt. Andere Befehle werden übersprungen. Kann in den Arbeitsbereich schreiben.';
	@override String get auto => 'Ein Modell-Klassifizierer entscheidet pro Tool-Aufruf, ob genehmigt oder abgelehnt wird. Hohe Autonomie.';
	@override String get acceptEdits => 'Alle Befehle werden automatisch innerhalb des Arbeitsbereichs ausgeführt. Vollautomatischer Modus mit isolierter Ausführung.';
	@override String get bypassPermissions => 'Vollständiger Systemzugriff ohne Einschränkungen. Alle Befehle werden automatisch mit vollem Festplatten- und Netzwerkzugriff ausgeführt. Mit Vorsicht verwenden.';
	@override String get plan => 'Planungsmodus – keine Befehle werden ausgeführt';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$de extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Strg+Enter zum Senden • / Befehle • @ Dateien';
	@override String get enter => 'Enter zum Senden • Shift+Enter neue Zeile • / Befehle • @ Dateien';
	@override String get queue => 'Enter, um die nächste Nachricht einzureihen';
	@override String get updateQueued => 'Enter, um die eingereihte Nachricht zu aktualisieren';
}

// Path: chat.input.queue
class Translations$chat$input$queue$de extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Nächste Nachricht einreihen';
	@override String get update => 'Eingereihte Nachricht aktualisieren';
	@override String get label => 'Eingereiht';
	@override String get willSend => 'Wird gesendet, wenn dies abgeschlossen ist';
	@override String get edit => 'Eingereihte Nachricht bearbeiten';
	@override String get delete => 'Eingereihte Nachricht löschen';
	@override String get failed => 'Senden fehlgeschlagen';
	@override String get sendNow => 'Jetzt senden';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$de extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Offline-Warteschlange abbrechen und leeren';
	@override String get clearBtn => 'Abbrechen';
	@override String multiple({required Object count}) => '${count} Nachrichten offline in der Warteschlange — werden bei Wiederverbindung automatisch gesendet';
	@override String get single => '1 Nachricht offline in der Warteschlange — wird bei Wiederverbindung automatisch gesendet';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$de extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'von Anthropic';
	@override String get openai => 'von OpenAI';
	@override String get cursorEditor => 'KI-Code-Editor';
	@override String get google => 'von Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$de extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Bereit, Claude mit ${model} zu verwenden. Gib unten deine Nachricht ein.';
	@override String cursor({required Object model}) => 'Bereit, Cursor mit ${model} zu verwenden. Gib unten deine Nachricht ein.';
	@override String codex({required Object model}) => 'Bereit, Codex mit ${model} zu verwenden. Gib unten deine Nachricht ein.';
	@override String get kDefault => 'Wähl oben einen Anbieter, um zu beginnen';
	@override String opencode({required Object model}) => 'Bereit, OpenCode mit ${model} zu verwenden. Tippe unten deine Nachricht.';
	@override String devin({required Object model}) => 'Bereit mit Devin ${model}';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$de extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Unterhaltung fortsetzen';
	@override String get description => 'Stell Fragen zu deinem Code, fordere Änderungen an oder hol Hilfe bei Entwicklungsaufgaben';
	@override String get action => 'Weiterschreiben';
}

// Path: chat.session.loading
class Translations$chat$session$loading$de extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Ältere Nachrichten werden geladen...';
	@override String get sessionMessages => 'Sitzungsnachrichten werden geladen...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$de extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => '${shown} von ${total} Nachrichten werden angezeigt';
	@override String get scrollToLoad => 'Nach oben scrollen, um mehr zu laden';
	@override String showingLast({required Object count, required Object total}) => 'Letzte ${count} Nachrichten werden angezeigt (${total} gesamt)';
	@override String get loadEarlier => 'Frühere Nachrichten laden';
	@override String get loadAll => 'Alle Nachrichten laden';
	@override String get loadingAll => 'Alle Nachrichten werden geladen...';
	@override String get allLoaded => 'Alle Nachrichten geladen';
	@override String get perfWarning => 'Alle Nachrichten geladen – Scrollen kann langsamer sein. Klick auf \'Nach unten scrollen\', um die Leistung wiederherzustellen.';
	@override String get loadOlderFailed => 'Ältere Nachrichten konnten nicht geladen werden.';
	@override String get retry => 'Wiederholen';
	@override String get noSearchMatches => 'Keine Nachrichten entsprechen der Suche.';
	@override String loadAllCount({required Object count}) => 'Alle laden (${count})';
	@override String get loadOlder => 'Ältere Nachrichten laden';
	@override String retryLoadOlder({required Object error}) => 'Laden älterer Nachrichten erneut versuchen — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$de extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Projekt auswählen';
	@override String get description => 'Wähl ein Projekt, um ein interaktives Terminal in diesem Verzeichnis zu öffnen';
}

// Path: chat.shell.status
class Translations$chat$shell$status$de extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Neue Sitzung';
	@override String get initializing => 'Wird initialisiert...';
	@override String get restarting => 'Wird neu gestartet...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$de extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Trennen';
	@override String get disconnectTitle => 'Vom Terminal trennen';
	@override String get restart => 'Neu starten';
	@override String get restartTitle => 'Terminal neu starten (zuerst trennen)';
	@override String get connect => 'Im Terminal fortfahren';
	@override String get connectTitle => 'Mit Terminal verbinden';
	@override String get kill => 'Beenden (SIGINT)';
	@override String get killTitle => 'Laufenden Prozess beenden (Ctrl+C)';
	@override String get copyOutput => 'Ausgabe kopieren';
	@override String get copyOutputTitle => 'Terminalausgabe kopieren';
	@override String get copied => 'Kopiert!';
	@override String get zoomInTitle => 'Vergrößern';
	@override String get zoomOutTitle => 'Verkleinern';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$de extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Denkt nach';
	@override String get processing => 'Verarbeitet';
	@override String get analyzing => 'Analysiert';
	@override String get working => 'Arbeitet';
	@override String get computing => 'Berechnet';
	@override String get reasoning => 'Schlussfolgert';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$de extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get live => 'Live';
	@override String get paused => 'Pausiert';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$de extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}s';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '${time} vergangen';
	@override String get startingNow => 'Startet jetzt';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$de extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Generierung stoppen';
	@override String get pressEscToStop => 'Jederzeit Esc drücken, um zu stoppen';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$de extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Assistent';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$de extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get config => 'Einstellungen und Konfiguration öffnen.';
	@override String get cost => 'Tokenverbrauch der aktiven Sitzung prüfen.';
	@override String get help => 'Befehlsdokumentation und Syntax anzeigen.';
	@override String get memory => 'Die CLAUDE.md-Speicherdatei des Projekts öffnen.';
	@override String get models => 'Verfügbare Modelle für den aktiven Anbieter durchsuchen.';
	@override String get status => 'Laufzeit-, Versions-, Anbieter- und Umgebungsstatus prüfen.';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$de extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Umbenennen';
	@override String get delete => 'Löschen';
	@override String get copyPath => 'Pfad kopieren';
	@override String get download => 'Herunterladen';
	@override String get newFile => 'Neue Datei';
	@override String get newFolder => 'Neuer Ordner';
	@override String get upload => 'Dateien hochladen';
	@override String get refresh => 'Aktualisieren';
	@override String get menuLabel => 'Datei-Kontextmenü';
	@override String get loading => 'Lädt...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$de extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Löschen';
	@override String get fileWarning => 'Diese Datei wird endgültig gelöscht.';
	@override String get folderWarning => 'Dieser Ordner und sein gesamter Inhalt werden endgültig gelöscht.';
	@override String title({required Object type}) => '${type} löschen';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$de extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'Pfad konnte nicht kopiert werden';
	@override String get fileCreated => 'Datei erfolgreich erstellt';
	@override String get fileDeleted => 'Datei gelöscht';
	@override String get folderCreated => 'Ordner erfolgreich erstellt';
	@override String get folderDeleted => 'Ordner gelöscht';
	@override String get folderDownloaded => 'Ordner als ZIP heruntergeladen';
	@override String get pathCopied => 'Pfad in die Zwischenablage kopiert';
	@override String get renamed => 'Erfolgreich umbenannt';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$de extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'Dateiname darf nicht nur aus Punkten bestehen';
	@override String get emptyName => 'Dateiname darf nicht leer sein';
	@override String get invalidChars => 'Dateiname enthält ungültige Zeichen';
	@override String get reserved => 'Dateiname ist ein reservierter Name';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$de extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get type => 'Typ';
	@override String get configure => 'Konfigurieren';
	@override String get confirm => 'Bestätigen';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$de extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get question => 'Hast du bereits einen Arbeitsbereich, oder möchtest du einen neuen erstellen?';
	@override late final Translations$common$projectWizard$step1$existing$de existing = Translations$common$projectWizard$step1$existing$de._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$de kNew = Translations$common$projectWizard$step1$kNew$de._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$de extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Arbeitsbereichspfad';
	@override String get newPath => 'Arbeitsbereichspfad';
	@override String get existingPlaceholder => '/Pfad/zum/vorhandenen/Arbeitsbereich';
	@override String get newPlaceholder => '/Pfad/zum/neuen/Arbeitsbereich';
	@override String get existingHelp => 'Vollständiger Pfad zu deinem vorhandenen Arbeitsbereichsverzeichnis';
	@override String get newHelp => 'Vollständiger Pfad zu deinem Arbeitsbereichsverzeichnis';
	@override String get githubUrl => 'GitHub-URL (Optional)';
	@override String get githubPlaceholder => 'https://github.com/benutzername/repository';
	@override String get githubHelp => 'Optional: GitHub-URL angeben, um ein Repository zu klonen';
	@override String get githubAuth => 'GitHub-Authentifizierung (Optional)';
	@override String get githubAuthHelp => 'Nur für private Repositories erforderlich. Öffentliche Repos können ohne Authentifizierung geklont werden.';
	@override String get loadingTokens => 'Gespeicherte Token werden geladen...';
	@override String get storedToken => 'Gespeicherter Token';
	@override String get newToken => 'Neuer Token';
	@override String get nonePublic => 'Keiner (Öffentlich)';
	@override String get selectToken => 'Token auswählen';
	@override String get selectTokenPlaceholder => '-- Token auswählen --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Dieser Token wird nur für diesen Vorgang verwendet';
	@override String get publicRepoInfo => 'Öffentliche Repositories benötigen keine Authentifizierung. Du kannst das Token beim Klonen eines öffentlichen Repos weglassen.';
	@override String get noTokensHelp => 'Keine gespeicherten Token verfügbar. Du kannst Token unter Einstellungen → API-Schlüssel für einfachere Wiederverwendung hinzufügen.';
	@override String get optionalTokenPublic => 'GitHub-Token (Optional für öffentliche Repos)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (leer lassen für öffentliche Repos)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$de extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Konfiguration überprüfen';
	@override String get existingWorkspace => 'Vorhandener Arbeitsbereich';
	@override String get newWorkspace => 'Neuer Arbeitsbereich';
	@override String get path => 'Pfad:';
	@override String get cloneFrom => 'Klonen von:';
	@override String get authentication => 'Authentifizierung:';
	@override String get usingStoredToken => 'Gespeicherter Token wird verwendet:';
	@override String get usingProvidedToken => 'Angegebener Token wird verwendet';
	@override String get noAuthentication => 'Keine Authentifizierung';
	@override String get sshKey => 'SSH-Schlüssel';
	@override String get existingInfo => 'Der Arbeitsbereich wird zur Projektliste hinzugefügt und steht für Claude/Cursor-Sitzungen zur Verfügung.';
	@override String get newWithClone => 'Das Repository wird aus diesem Ordner geklont.';
	@override String get newEmpty => 'Der Arbeitsbereich wird zur Projektliste hinzugefügt und steht für Claude/Cursor-Sitzungen zur Verfügung.';
	@override String get cloningRepository => 'Repository wird geklont...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$de extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get back => 'Zurück';
	@override String get next => 'Weiter';
	@override String get createProject => 'Projekt erstellen';
	@override String get creating => 'Wird erstellt...';
	@override String get cloning => 'Wird geklont...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$de extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Bitte wähl aus, ob du einen vorhandenen Arbeitsbereich hast oder einen neuen erstellen möchtest';
	@override String get providePath => 'Bitte gib einen Arbeitsbereichspfad an';
	@override String get failedToCreate => 'Arbeitsbereich konnte nicht erstellt werden';
	@override String get failedToCreateFolder => 'Ordner konnte nicht erstellt werden';
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$de extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get close => 'Schließen';
	@override String get later => 'Später';
	@override String get copyCommand => 'Befehl kopieren';
	@override String get updateNow => 'Jetzt aktualisieren';
	@override String get updating => 'Wird aktualisiert...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$de extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Versions-Update-Modal schließen';
	@override String get showSidebar => 'Seitenleiste anzeigen';
	@override String get settings => 'Einstellungen';
	@override String get updateAvailable => 'Update verfügbar';
	@override String get closeSidebar => 'Seitenleiste schließen';
}

// Path: common.quota.section
class Translations$common$quota$section$de extends Translations$common$quota$section$en {
	Translations$common$quota$section$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Übersicht';
	@override String get quotas => 'Quotas';
	@override String get usage => 'Nutzung';
	@override String get agents => 'Agents';
}

// Path: common.quota.filter
class Translations$common$quota$filter$de extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get all => 'Alle';
}

// Path: common.quota.period
class Translations$common$quota$period$de extends Translations$common$quota$period$en {
	Translations$common$quota$period$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 Tage';
	@override String get k30d => '30 Tage';
	@override String get all => 'Alle';
}

// Path: common.quota.group
class Translations$common$quota$group$de extends Translations$common$quota$group$en {
	Translations$common$quota$group$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Anbieter';
	@override String get model => 'Modell';
	@override String get agent => 'Agent';
	@override String get tool => 'Werkzeug';
}

// Path: common.quota.metric
class Translations$common$quota$metric$de extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Tokens';
	@override String get input => 'Eingabe';
	@override String get output => 'Ausgabe';
	@override String get cache => 'Cache-Lesungen';
	@override String get calls => 'API-Aufrufe';
	@override String get cost => 'Kosten';
	@override String get sessions => 'Sitzungen';
}

// Path: common.quota.cost
class Translations$common$quota$cost$de extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Abgerechnet (API + Mehrverbrauch)';
	@override String get listPrice => 'Listenpreis der verwendeten Tokens';
	@override String get subscriptionValue => 'Durch Abonnements abgedeckt';
	@override String get cacheSavings => 'Cache-Einsparungen';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$de extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Abgerechnet (API + Mehrverbrauch)';
	@override String get listPrice => 'Listenpreis der verwendeten Tokens';
	@override String get subscriptionValue => 'Durch Abonnements abgedeckt';
}

// Path: common.quota.overview
class Translations$common$quota$overview$de extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tokens und Kosten — letzte 7 Tage';
	@override String get effectiveCost => 'Effektive Kosten (7 Tage)';
	@override String get alertsTitle => 'Warnungen';
	@override String get noAlerts => 'Derzeit erfordert nichts Aufmerksamkeit.';
	@override String get limitsTitle => 'Nutzung und Limits';
	@override String get activeTasks => 'Aktive Aufgaben';
	@override String get viewAccounts => 'Alle Konten';
	@override String get viewAgents => 'Alle Agents';
	@override String get noTasks => 'Derzeit laufen keine Agents.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$de extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Täglicher Trend';
	@override String breakdownTitle({required Object group}) => 'Aufschlüsselung nach ${group}';
	@override String get colName => 'Name';
	@override String get sourceUnavailable => 'Analysespeicher nicht verfügbar; keine Daten.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$de extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} laufend';
	@override String get colAgent => 'Agent';
	@override String get colStatus => 'Status';
	@override String get colTask => 'Aufgabe';
	@override String get colModel => 'Konto / Modell';
	@override String get colTime => 'Zeit';
	@override String get empty => 'Keine Agents entsprechen diesem Filter.';
	@override String get detailSession => 'Sitzung';
	@override String get detailStarted => 'Gestartet';
	@override String get detailRetries => 'Wiederholungen';
	@override String get detailResult => 'Ergebnis';
	@override String get notTracked => 'nicht erfasst';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$de extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get running => 'Läuft';
	@override String get waiting => 'Wartet';
	@override String get failed => 'Fehlgeschlagen';
	@override String get finished => 'Abgeschlossen';
	@override String get queued => 'In Warteschlange';
}

// Path: common.quota.alert
class Translations$common$quota$alert$de extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: beim aktuellen Tempo ist das Limit in ${value} erreicht';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% verbraucht (Schwelle ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$de extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get live => 'Live';
	@override String get cached => 'Zwischengespeichert';
	@override String get estimate => 'Schätzung';
	@override String get unknown => 'Unbekannt';
	@override String get error => 'Fehler';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$de extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Gefährdete Limits';
	@override String atRiskHint({required Object value}) => 'Konten über ${value}%';
	@override String get windowsAtRisk => 'Fenster laufen ab';
	@override String get errored => 'Sync-Fehler';
	@override String get activeAgents => 'Aktive Agents';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} wartend · ${queued} in Warteschlange';
	@override String get nextReset => 'Nächster Reset';
	@override String get tokens => 'Tokens';
	@override String sessionsHint({required Object value}) => '${value} Sitzungen';
	@override String get cost => 'Geschätzte Kosten';
	@override String costHint({required Object value}) => '${value} durch Abos abgedeckt';
}

// Path: common.quota.empty
class Translations$common$quota$empty$de extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Keine Konten verbunden';
	@override String get description => 'Melde dich bei Claude, Codex, Gemini oder CommandCode an, damit Quotas hier verfolgt werden können.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$de extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Warnungen und Routing';
	@override String get description => 'Steuere, wann das Dashboard warnt und wie Konten für neue Arbeit vorgeschlagen werden.';
	@override String get alertsEnabled => 'Prognose- und Schwellenwarnungen';
	@override String get alertsEnabledHint => 'Warnen, bevor ein Limit beim aktuellen Tempo erreicht ist, nicht erst bei 90%.';
	@override String get watchThreshold => 'Beobachtungsschwelle (%)';
	@override String get dangerThreshold => 'Gefahrenschwelle (%)';
	@override String get routingMode => 'Routing';
	@override late final Translations$common$quota$settings$routing$de routing = Translations$common$quota$settings$routing$de._(_root);
	@override String get logSources => 'Protokollquellen';
	@override String get logSourcesHint => 'Nutzungs- und Agent-Ansichten lesen diese schreibgeschützten Quellen.';
	@override String get quotaConsent => 'Quota-Abfrage erlauben';
	@override String get quotaConsentHint => 'Anbieter-Endpunkte mit deinen gespeicherten Zugangsdaten abfragen, um Live-Limits zu lesen.';
	@override String get perAccount => 'Kontospezifische Überschreibungen';
	@override String get tab => 'Control-Center-Einstellungen';
}

// Path: common.quota.range
class Translations$common$quota$range$de extends Translations$common$quota$range$en {
	Translations$common$quota$range$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Alle';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$de extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$de generic = Translations$common$notifications$codes$generic$de._(_root);
	@override late final Translations$common$notifications$codes$permission$de permission = Translations$common$notifications$codes$permission$de._(_root);
	@override late final Translations$common$notifications$codes$run$de run = Translations$common$notifications$codes$run$de._(_root);
	@override late final Translations$common$notifications$codes$agent$de agent = Translations$common$notifications$codes$agent$de._(_root);
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$de extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Aktiviere Browser in den Einstellungen, damit Agenten überwachte Browser-Sitzungen öffnen können.';
	@override String get descEnabled => 'Agenten-Browser-Sitzungen erscheinen hier, während eine KI-Aufgabe Browser verwendet.';
	@override String get titleDisabled => 'Browser ist deaktiviert';
	@override String get titleEnabled => 'Noch keine Browser-Sitzungen';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$de extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'Browser-Aktion fehlgeschlagen';
	@override String get loadFailed => 'Browser konnte nicht geladen werden';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$de extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Verwende Browser, um den Checkout-Ablauf zu prüfen und defekte UI-Zustände zu melden.';
	@override String get prompt2 => 'Öffne <url> mit Browser, interagiere mit der Seite und fasse zusammen, was sich nach jedem Schritt geändert hat.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$de extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => 'T zuvor';
	@override String get hoursAgo => 'Std. zuvor';
	@override String get justNow => 'Gerade eben';
	@override String get minutesAgo => 'Min. zuvor';
	@override String get never => 'Nie';
	@override String get secondsAgo => 'Sek. zuvor';
	@override String get unknown => 'Unbekannt';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$de extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Deaktiviert';
	@override String get installing => 'Installiere';
	@override String get ready => 'Bereit';
	@override String get setupRequired => 'Einrichtung erforderlich';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$de extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Alle Branches durchsuchen (${count})';
	@override String commits({required Object count}) => 'Alle Commits durchsuchen (${count})';
	@override String files({required Object count}) => 'Alle Dateien durchsuchen (${count})';
	@override String sessions({required Object count}) => 'Alle Sitzungen durchsuchen (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$de extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'Die Kosten sind eine clientseitige Schätzung aus veröffentlichten Token-Preisen; unbekannte Modelle zeigen „—“.';
	@override String get estCost => 'Gesch. Kosten';
	@override String get inputOutput => 'Eingabe / Ausgabe';
	@override String get model => 'Modell';
	@override String get na => 'k. A.';
	@override String get openSplit => 'In geteilter Ansicht öffnen';
	@override String get provider => 'Anbieter';
	@override String get selectSession => 'Sitzung auswählen…';
	@override String get tokensUsed => 'Verwendete Tokens';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$de extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Aktionen';
	@override String get branches => 'Branches';
	@override String get commits => 'Commits';
	@override String get files => 'Dateien';
	@override String get git => 'Git';
	@override String get navigate => 'Navigieren';
	@override String get sessions => 'Sitzungen';
	@override String get settings => 'Einstellungen';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$de extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get close => 'Schließen';
	@override String get navigate => 'Navigieren';
	@override String get select => 'Auswählen';
	@override String get togglePalette => 'Palette umschalten';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$de extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Sitzungen vergleichen';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => 'Einstellungen öffnen';
	@override String get selectProjectFirst => 'Zuerst ein Projekt auswählen';
	@override String settingsEntry({required Object label}) => 'Einstellungen: ${label}';
	@override String get startNewChat => 'Neuen Chat starten';
	@override String switchTo({required Object name}) => 'Wechseln zu: ${name}';
	@override String get toggleTheme => 'Theme umschalten';
	@override String get tokensAndCost => 'Tokens & Kosten';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$de extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get board => 'Zum Agent Board';
	@override String get chat => 'Zum Chat';
	@override String get files => 'Zu Dateien';
	@override String get git => 'Zu Git';
	@override String get sourceControl => 'Zur Quellcodeverwaltung';
	@override String get tasks => 'Zu Aufgaben';
	@override String get usage => 'Zu Quota & Nutzung';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$de extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Aktionen';
	@override String get branches => 'Branches';
	@override String get commits => 'Commits';
	@override String get compare => 'Vergleichen';
	@override String get files => 'Dateien';
	@override String get sessions => 'Sitzungen';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$de extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => 'Branch „${branch}“ löschen? Ein normales Löschen gelingt nur, wenn der Branch vollständig gemergt ist. Dies kann nicht rückgängig gemacht werden.';
	@override String confirmSwitch({required Object branch}) => 'Zu Branch „${branch}“ wechseln? Stelle sicher, dass du keine nicht committeten Änderungen hast.';
	@override String countBoth({required Object local, required Object remote}) => '${local} lokal, ${remote} remote';
	@override String countLocal({required Object count}) => '${count} lokal';
	@override String get current => 'aktuell';
	@override String deleteTitle({required Object branch}) => '${branch} löschen';
	@override String get emptyDesc => 'Erstelle einen Branch, um parallel zu arbeiten.';
	@override String get forceDelete => 'Löschen erzwingen';
	@override String get forceDeleteDesc => 'Entfernt den Branch endgültig, auch wenn er Commits enthält, die nirgendwo gemergt wurden.';
	@override String get forceDeleteLabel => 'Diesen nicht gemergten Branch endgültig löschen';
	@override String get local => 'Lokal';
	@override String get kNew => 'Neuer Branch';
	@override String get noMatch => 'Keine Branches entsprechen der Suche';
	@override String get none => 'Keine Branches gefunden';
	@override String get remote => 'Remote';
	@override String get kSwitch => 'Wechseln';
	@override String switchTo({required Object branch}) => 'Wechseln zu ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$de extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Bestätigen';
	@override String get delete => 'Löschen';
	@override String get deleteBranch => 'Löschen';
	@override String get discard => 'Verwerfen';
	@override String get publish => 'Veröffentlichen';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get revertLocalCommit => 'Commit zurücksetzen';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$de extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Aktion bestätigen';
	@override String get delete => 'Datei löschen';
	@override String get deleteBranch => 'Branch löschen';
	@override String get discard => 'Änderungen verwerfen';
	@override String get publish => 'Branch veröffentlichen';
	@override String get pull => 'Pull bestätigen';
	@override String get push => 'Push bestätigen';
	@override String get revertLocalCommit => 'Lokalen Commit zurücksetzen';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$de extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Branch-Erstellung fehlgeschlagen';
	@override String get createWorktreeFailed => 'Worktree konnte nicht erstellt werden';
	@override String get deleteBranchFailed => 'Branch-Löschung fehlgeschlagen';
	@override String get fetchFailed => 'Fetch fehlgeschlagen';
	@override String get initFailed => 'Repository konnte nicht initialisiert werden';
	@override String get initialCommitFailed => 'Erster Commit konnte nicht erstellt werden';
	@override String get mergeFailed => 'Merge fehlgeschlagen';
	@override String get openWorktreeFailed => 'Worktree konnte nicht geöffnet werden';
	@override String get operationFailed => 'Git-Operation fehlgeschlagen';
	@override String get publishFailed => 'Veröffentlichung fehlgeschlagen';
	@override String get pullFailed => 'Pull fehlgeschlagen';
	@override String get pushFailed => 'Push fehlgeschlagen';
	@override String get removeWorktreeFailed => 'Worktree konnte nicht entfernt werden';
	@override String get stageFailed => 'Stagen fehlgeschlagen';
	@override String get stageHunksFailed => 'Hunks stagen fehlgeschlagen';
	@override String get switchFailed => 'Branch-Wechsel fehlgeschlagen';
	@override String get unstageFailed => 'Unstagen fehlgeschlagen';
	@override String get unstageHunksFailed => 'Hunks unstagen fehlgeschlagen';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$de extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get added => 'Hinzugefügt';
	@override String get author => 'Autor';
	@override String get changedFiles => 'Geänderte Dateien';
	@override String get date => 'Datum';
	@override String get empty => 'Keine Commits gefunden';
	@override String get files => 'Dateien';
	@override String get removed => 'Entfernt';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$de extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Worktree entfernen und seinen Branch nach dem Merge löschen';
	@override String get cleanupLabel => 'Nach dem Merge aufräumen';
	@override String commitCount({required Object count}) => '${count} Commit(s)';
	@override String get merge => 'Mergen';
	@override String mergeMessage({required Object branch}) => 'Branch \'${branch}\' mergen';
	@override String get messageLabel => 'Commit-Nachricht';
	@override String squashDesc({required Object commits, required Object branch}) => 'Alle ${commits} zu einem einzigen Commit auf ${branch} zusammenfassen';
	@override String get squashLabel => 'Commits squashen';
	@override String get squashMerge => 'Squashen & mergen';
	@override String squashMessage({required Object branch}) => 'Branch \'${branch}\' squash-mergen';
	@override String get title => 'Worktree mergen';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$de extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Erstellt einen neuen Branch vom aktuellen Branch (${branch})';
	@override String get nameLabel => 'Branch-Name';
	@override String get submit => 'Branch erstellen';
	@override String get title => 'Neuen Branch erstellen';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$de extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Branch';
	@override String get createFrom => 'Erstellen aus';
	@override String get description => 'Checke einen Branch in einem eigenen Ordner aus und arbeite parallel daran.';
	@override String get existingBranch => 'Bestehender Branch — wird unverändert ausgecheckt.';
	@override String get submit => 'Worktree erstellen';
	@override String get switchAfter => 'Nach dem Erstellen zum Worktree wechseln';
	@override String get title => 'Neuer Worktree';
	@override String get willCreateIn => 'Wird erstellt in';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$de extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get create => 'Ersten Commit erstellen';
	@override String get creating => 'Erstelle ersten Commit...';
	@override String get description => 'Dieses Repository hat noch keine Commits. Erstelle deinen ersten Commit, um Änderungen zu verfolgen.';
	@override String get title => 'Noch keine Commits';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$de extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Dieses Projekt ist noch kein Git-Repository. Initialisiere eines, um Änderungen zu verfolgen und Quellcodeverwaltung zu nutzen.';
	@override String get init => 'git init ausführen';
	@override String get initializing => 'Initialisiere Repository...';
	@override String get title => 'Kein Git-Repository';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$de extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Branch ebenfalls löschen';
	@override String description({required Object branch}) => 'Worktree für ${branch} entfernen? Sein Ordner wird gelöscht und das verknüpfte Projekt archiviert — Chat-Sitzungen bleiben wiederherstellbar.';
	@override String dirtyWarning({required Object count}) => 'Dieser Worktree hat ${count} nicht committete Änderung(en), die verloren gehen.';
	@override String get discardChanges => 'Nicht committete Änderungen verwerfen';
	@override String get title => 'Worktree entfernen';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$de extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get added => 'Hinzugefügt';
	@override String get deleted => 'Gelöscht';
	@override String get modified => 'Geändert';
	@override String get untracked => 'Nicht verfolgt';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$de extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} Änderung(en)';
	@override String count({required Object count}) => '${count} Worktree(s)';
	@override String get createFirst => 'Erstelle deinen ersten Worktree';
	@override String get detached => 'losgelöst';
	@override String detachedAt({required Object sha}) => 'losgelöst @ ${sha}';
	@override String get detachedHead => 'losgelöster HEAD';
	@override String get emptyDesc => 'Ein Worktree checkt einen Branch in einem eigenen Ordner aus, sodass du separate Chat-Sitzungen parallel führen und die Ergebnisse mergen kannst, sobald sie fertig sind.';
	@override String get emptyTitle => 'Arbeite parallel an Branches';
	@override String get locked => 'gesperrt';
	@override String get mainWorktree => 'Haupt-Worktree';
	@override String mergeTitle({required Object branch}) => '${branch} in den Basis-Branch mergen';
	@override String get kNew => 'Neuer Worktree';
	@override String get none => 'Keine Worktrees';
	@override String get nothingToMerge => 'Nichts zu mergen — keine Commits vor dem Basis-Branch';
	@override String get open => 'Öffnen';
	@override String get refresh => 'Worktrees aktualisieren';
	@override String removeTitle({required Object branch}) => 'Worktree für ${branch} entfernen';
	@override String switchTo({required Object branch}) => 'Wechseln zu ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$de extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Änderungen';
	@override String get history => 'Commits';
	@override String get branches => 'Branches';
	@override String get worktrees => 'Worktrees';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$de extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Geltungsbereich';
	@override String get user => 'Benutzer:in';
	@override String get project => 'Projekt';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$de extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get dark => 'Dunkel';
	@override String get light => 'Hell';
	@override String get system => 'System';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$de extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Darstellung';
	@override String get toolDisplay => 'Werkzeuganzeige';
	@override String get inputSettings => 'Eingabeeinstellungen';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$de extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Handle wird gezogen';
	@override String get closePanel => 'Einstellungspanel schließen';
	@override String get openPanel => 'Einstellungspanel öffnen';
	@override String get draggingStatus => 'Wird gezogen...';
	@override String get toggleAndMove => 'Klicken zum Umschalten, ziehen zum Verschieben';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$de extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Tastenkürzel-Panel schließen';
	@override String get openPanel => 'Tastenkürzel-Panel öffnen';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$de extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$de extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
	@override late final Translations$settings$orchestration$pool$fields$de fields = Translations$settings$orchestration$pool$fields$de._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$de extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$de extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$de taskTypes = Translations$settings$orchestration$rules$taskTypes$de._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$de extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$de modes = Translations$settings$orchestration$planner$modes$de._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$de modeHints = Translations$settings$orchestration$planner$modeHints$de._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$de templates = Translations$settings$orchestration$planner$templates$de._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$de extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$de onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$de._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$de extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

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
class Translations$settings$notifications$webPush$de extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Web-Push-Benachrichtigungen';
	@override String get enable => 'Push-Benachrichtigungen aktivieren';
	@override String get disable => 'Push-Benachrichtigungen deaktivieren';
	@override String get enabled => 'Push-Benachrichtigungen sind aktiviert';
	@override String get loading => 'Wird aktualisiert...';
	@override String get unsupported => 'Push-Benachrichtigungen werden in diesem Browser nicht unterstützt.';
	@override String get denied => 'Push-Benachrichtigungen sind blockiert. Bitte erlaube sie in den Browsereinstellungen.';
	@override String get iosHint => 'Auf iPhone/iPad funktionieren Benachrichtigungen erst, nachdem ddagent zum Home-Bildschirm hinzugefügt wurde (Teilen → Zum Home-Bildschirm) und sie in der installierten App aktiviert wurden.';
	@override String get test => 'Test-Benachrichtigung senden';
	@override String get testNoSubscription => 'Kein Gerät ist angemeldet. Tippe zuerst auf dem Telefon auf „Aktivieren“.';
	@override String testSuccess({required Object count}) => 'An ${count} Gerät(e) gesendet. Falls nichts auf dem Telefon erscheint, füge ddagent zum Home-Bildschirm hinzu (iOS erfordert dies).';
	@override String get testNotDelivered => 'Kein Gerät war erreichbar. Stelle sicher, dass die App läuft und Benachrichtigungen aktiviert sind.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$de extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dieses Gerät benachrichtigen';
	@override String get enabled => 'Benachrichtigungen sind für dieses Gerät aktiviert';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$de extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ton';
	@override String get description => 'Spielt einen kurzen Ton ab, wenn ein Chat-Lauf abgeschlossen ist.';
	@override String get enabled => 'Aktiviert';
	@override String get test => 'Ton testen';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$de extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ereignistypen';
	@override String get actionRequired => 'Aktion erforderlich';
	@override String get stop => 'Lauf gestoppt';
	@override String get error => 'Lauf fehlgeschlagen';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$de extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Diese Desktop-App benachrichtigen';
	@override String get enable => 'Push-Benachrichtigungen aktivieren';
	@override String get disable => 'Push-Benachrichtigungen deaktivieren';
	@override String get enabled => 'Benachrichtigungen sind für diese Desktop-App aktiviert';
	@override String get unsupported => 'Desktop-Benachrichtigungen werden auf diesem System nicht unterstützt.';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$de extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get discord => 'Discord';
	@override String get telegram => 'Telegram';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$de extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Darkmode';
	@override String get description => 'Zwischen hellem und dunklem Design wechseln';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$de extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Code-Editor';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$de theme = Translations$settings$appearanceSettings$codeEditor$theme$de._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$de wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$de._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$de showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$de._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$de lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$de._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$de fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$de._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$de extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$de focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$de._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$de extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get add => 'MCP-Server hinzufügen';
	@override String get edit => 'MCP-Server bearbeiten';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$de extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get form => 'Formulareingabe';
	@override String get json => 'JSON-Import';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$de extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Geltungsbereich';
	@override String get userGlobal => 'Benutzer:in (Global)';
	@override String get projectLocal => 'Projekt (Lokal)';
	@override String get userDescription => 'Benutzerbereich: Auf allen Projekten deines Computers verfügbar';
	@override String get projectDescription => 'Lokaler Bereich: Nur im ausgewählten Projekt verfügbar';
	@override String get cannotChange => 'Der Geltungsbereich kann beim Bearbeiten eines vorhandenen Servers nicht geändert werden';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$de extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Servername';
	@override String get transportType => 'Transporttyp';
	@override String get command => 'Befehl';
	@override String get arguments => 'Argumente (eines pro Zeile)';
	@override String get jsonConfig => 'JSON-Konfiguration';
	@override String get url => 'URL';
	@override String get envVars => 'Umgebungsvariablen (SCHLÜSSEL=Wert, eine pro Zeile)';
	@override String get headers => 'Header (SCHLÜSSEL=Wert, eine pro Zeile)';
	@override String get selectProject => 'Projekt auswählen...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$de extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'mein-server';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$de extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Pflichtfeld fehlt: type';
	@override String get stdioRequiresCommand => 'stdio-Typ erfordert ein Befehlsfeld';
	@override String httpRequiresUrl({required Object type}) => '${type}-Typ erfordert ein URL-Feld';
	@override String get invalidJson => 'Ungültiges JSON-Format';
	@override String get jsonHelp => 'Füge deine MCP-Server-Konfiguration im JSON-Format ein. Beispielformate:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$de extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Abbrechen';
	@override String get saving => 'Wird gespeichert...';
	@override String get addServer => 'Server hinzufügen';
	@override String get updateServer => 'Server aktualisieren';
}

// Path: settings.git.name
class Translations$settings$git$name$de extends Translations$settings$git$name$en {
	Translations$settings$git$name$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git-Name';
	@override String get help => 'Dein Name für Git-Commits';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$de extends Translations$settings$git$email$en {
	Translations$settings$git$email$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git-E-Mail';
	@override String get help => 'Deine E-Mail-Adresse für Git-Commits';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$de extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get save => 'Konfiguration speichern';
	@override String get saving => 'Wird gespeichert...';
}

// Path: settings.git.status
class Translations$settings$git$status$de extends Translations$settings$git$status$en {
	Translations$settings$git$status$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get success => 'Erfolgreich gespeichert';
	@override String get error => 'Speichern fehlgeschlagen';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$de extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ API-Schlüssel speichern';
	@override String get alertMessage => 'Dies ist das einzige Mal, dass du diesen Schlüssel siehst. Speichere ihn sicher.';
	@override String get iveSavedIt => 'Ich habe ihn gespeichert';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$de extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'API-Schlüsselname (z. B. Produktionsserver)';
	@override String get createButton => 'Erstellen';
	@override String get cancelButton => 'Abbrechen';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$de extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get created => 'Erstellt:';
	@override String get lastUsed => 'Zuletzt verwendet:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$de extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get active => 'Aktiv';
	@override String get inactive => 'Inaktiv';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$de extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub-Token';
	@override String get description => 'Füge GitHub Personal Access Tokens hinzu, um private Repositories über die externe API zu klonen.';
	@override String get descriptionAlt => 'Füge GitHub Personal Access Tokens hinzu, um private Repositories zu klonen. Du kannst Token auch direkt in API-Anfragen übergeben, ohne sie zu speichern.';
	@override String get addButton => 'Token hinzufügen';
	@override late final Translations$settings$apiKeys$github$form$de form = Translations$settings$apiKeys$github$form$de._(_root);
	@override String get empty => 'Noch keine GitHub-Token hinzugefügt.';
	@override String get added => 'Hinzugefügt:';
	@override String get confirmDelete => 'Möchtest du diesen GitHub-Token wirklich löschen?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$de extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Externe API-Dokumentation';
	@override String get description => 'Erfahre, wie du die externe API nutzen kannst, um Claude/Cursor-Sitzungen aus deinen Anwendungen heraus zu starten.';
	@override String get viewLink => 'API-Dokumentation anzeigen →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$de extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Update verfügbar: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$de extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLI nicht installiert';
	@override String get description => 'TaskMaster CLI ist erforderlich, um Aufgabenverwaltungsfunktionen zu nutzen. Installiere es, um loszulegen:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'Auf GitHub anzeigen';
	@override String get afterInstallation => 'Nach der Installation:';
	@override late final Translations$settings$tasks$notInstalled$steps$de steps = Translations$settings$tasks$notInstalled$steps$de._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$de extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'TaskMaster-Integration aktivieren';
	@override String get enableDescription => 'TaskMaster-Aufgaben, Banner und Seitenleisten-Indikatoren in der gesamten Oberfläche anzeigen';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$de extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Wird überprüft...';
	@override String get connected => 'Verbunden';
	@override String get notConnected => 'Nicht verbunden';
	@override String get disconnected => 'Getrennt';
	@override String get checkingAuth => 'Authentifizierungsstatus wird überprüft...';
	@override String loggedInAs({required Object email}) => 'Angemeldet als ${email}';
	@override String providerAccount({required Object provider}) => '${provider}-Konto';
	@override String get authenticatedUser => 'authentifizierte:r Benutzer:in';
}

// Path: settings.agents.install
class Translations$settings$agents$install$de extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => '${agent}-CLI ist nicht installiert';
	@override String description({required Object agent}) => 'Installiere die ${agent}-CLI, um dich anzumelden und Sitzungen auszuführen.';
	@override String get button => 'Installieren';
	@override String get installing => 'Wird installiert…';
	@override String get copyCommand => 'Befehl kopieren';
	@override String get docs => 'Dokumentation';
	@override String success({required Object agent}) => '${agent}-CLI installiert';
	@override String get failed => 'Installation fehlgeschlagen — prüfe die Terminal-Ausgabe';
}

// Path: settings.agents.update
class Translations$settings$agents$update$de extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'CLI aktualisieren';
	@override String description({required Object agent}) => 'Installiert die neueste ${agent}-CLI-Version auf dem Server-Host.';
	@override String get button => 'Aktualisieren';
	@override String get updating => 'Wird aktualisiert…';
	@override String success({required Object agent}) => '${agent} CLI aktualisiert';
	@override String get failed => 'Aktualisierung fehlgeschlagen — siehe Terminalausgabe';
}

// Path: settings.agents.account
class Translations$settings$agents$account$de extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$de claude = Translations$settings$agents$account$claude$de._(_root);
	@override late final Translations$settings$agents$account$cursor$de cursor = Translations$settings$agents$account$cursor$de._(_root);
	@override late final Translations$settings$agents$account$codex$de codex = Translations$settings$agents$account$codex$de._(_root);
	@override late final Translations$settings$agents$account$opencode$de opencode = Translations$settings$agents$account$opencode$de._(_root);
	@override late final Translations$settings$agents$account$commandcode$de commandcode = Translations$settings$agents$account$commandcode$de._(_root);
	@override late final Translations$settings$agents$account$antigravity$de antigravity = Translations$settings$agents$account$antigravity$de._(_root);
	@override late final Translations$settings$agents$account$devin$de devin = Translations$settings$agents$account$devin$de._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$de extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Anmelden';
	@override String get reAuthenticate => 'Erneut authentifizieren';
	@override String description({required Object agent}) => 'Meld dich bei deinem ${agent}-Konto an, um KI-Funktionen zu aktivieren';
	@override String get reAuthDescription => 'Mit einem anderen Konto anmelden oder Anmeldedaten aktualisieren';
	@override String get button => 'Anmelden';
	@override String get reLoginButton => 'Erneut anmelden';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$de extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Abmelden';
	@override String get description => 'Von diesem Anbieter abmelden und gespeicherte Zugangsdaten löschen';
	@override String get button => 'Abmelden';
	@override String confirmTitle({required Object agent}) => 'Von ${agent} abmelden?';
	@override String confirmDescription({required Object agent}) => 'Dadurch werden die gespeicherten ${agent}-Zugangsdaten auf dem Server entfernt. Melde dich erneut an, um ${agent} weiter zu nutzen.';
	@override String get success => 'Abgemeldet';
	@override String get failed => 'Abmelden fehlgeschlagen';
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$de extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Berechtigungsmodus';
	@override String description({required Object provider}) => 'Standard-Berechtigungsmodus für neue ${provider}-Sitzungen. Du kannst ihn für eine einzelne Sitzung noch überschreiben.';
	@override late final Translations$settings$permissions$permissionMode$modes$de modes = Translations$settings$permissions$permissionMode$modes$de._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$de extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Model Context Protocol-Server stellen Claude zusätzliche Werkzeuge und Datenquellen zur Verfügung';
	@override String get cursor => 'Model Context Protocol-Server stellen Cursor zusätzliche Werkzeuge und Datenquellen zur Verfügung';
	@override String get codex => 'Model Context Protocol-Server stellen Codex zusätzliche Werkzeuge und Datenquellen zur Verfügung';
	@override String get opencode => 'Model Context Protocol-Server stellen OpenCode zusätzliche Werkzeuge und Datenquellen bereit';
	@override String get commandcode => 'Model Context Protocol-Server stellen Command Code zusätzliche Werkzeuge und Datenquellen bereit';
	@override String get antigravity => 'Model Context Protocol-Server stellen Antigravity zusätzliche Werkzeuge und Datenquellen bereit';
	@override String get devin => 'Model Context Protocol-Server stellen Devin zusätzliche Tools und Datenquellen bereit';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$de extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get local => 'lokal';
	@override String get user => 'benutzer';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$de extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get command => 'Befehl';
	@override String get url => 'URL';
	@override String get args => 'Argumente';
	@override String get environment => 'Umgebung';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$de extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Werkzeuge';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count} weitere';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$de extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Server bearbeiten';
	@override String get delete => 'Server löschen';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$de extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Über Codex MCP';
	@override String get description => 'Codex unterstützt stdio-basierte MCP-Server. Du kannst Server hinzufügen, die die Fähigkeiten von Codex mit zusätzlichen Werkzeugen und Ressourcen erweitern.';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$de extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Verwaltet';
	@override String get hint => 'Verwaltet von ddagent.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$de extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '„${serverName}“ wird aus der Anbieterkonfiguration entfernt.';
	@override String get title => 'MCP-Server löschen?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$de extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => 'Warnschwellen, Routing-Richtlinie und die für Quotas abgefragten Konten.';
	@override String get saved => 'Gespeichert';
	@override String get alertsSection => 'Warnungen';
	@override String get alertsSectionHint => 'Warnen, bevor ein Limit tatsächlich erschöpft ist, nicht erst bei 100%.';
	@override String get alertsEnabled => 'Prognostizierte Limit-Warnungen';
	@override String get alertsEnabledHint => 'Tempobasierte Prognosen auf der Übersicht und den Kontokarten anzeigen.';
	@override String get watchThreshold => 'Beobachtungsschwelle (%)';
	@override String get watchThresholdHint => 'Konten ab diesem Messwert gelten als gefährdet.';
	@override String get dangerThreshold => 'Gefahrenschwelle (%)';
	@override String get dangerThresholdHint => 'Messwerte ab diesem Wert werden rot angezeigt.';
	@override String get routingSection => 'Routing';
	@override String get routingSectionHint => 'Wie das Panel Arbeit auf das Konto mit dem meisten Spielraum verlagern darf.';
	@override late final Translations$settings$quota$settings$routing$de routing = Translations$settings$quota$settings$routing$de._(_root);
	@override String get routingNote => 'Ein Kontowechsel ändert Kosten und Modellqualität und erfordert daher immer eine explizite Entscheidung.';
	@override String get accountsSection => 'Abgefragte Konten';
	@override String get accountsSectionHint => 'Zugangsdaten werden aus jedem Tool gelesen; das Panel sendet sie nirgendwo anders hin.';
	@override String get sourcesSection => 'Datenquellen';
	@override String get sourcesSectionHint => 'Woher Nutzungs- und Kostenzahlen stammen.';
	@override String get logSources => 'Token- und Kostenprotokoll-Speicher';
	@override String get logSourcesHint => 'Schreibgeschützter Aggregatspeicher, gemeinsam mit dem Tokboard-Collector genutzt.';
	@override String get readOnly => 'Schreibgeschützt';
	@override String get quotaConsent => 'Quota-Abfrage';
	@override String get quotaConsentHint => 'Liest Anbieter-Quota-Endpunkte mit lokal gespeicherten Zugangsdaten aus.';
	@override String get localOnly => 'Nur lokal';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$de extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Noch keine Konten erkannt.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$de extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cached => 'gecacht';
	@override String get error => 'Fehler';
	@override String get estimate => 'Schätzung';
	@override String get live => 'live';
	@override String get unknown => 'unbekannt';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$de extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'Browser-Runtime konnte nicht installiert werden';
	@override String get loadSettings => 'Browser-Einstellungen konnten nicht geladen werden';
	@override String get loadStatus => 'Browser-Status konnte nicht geladen werden';
	@override String get saveSettings => 'Browser-Einstellungen konnten nicht gespeichert werden';
}

// Path: settings.about.pro
class Translations$settings$about$pro$de extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Einstellungen synchronisieren';
	@override String get teamManagement => 'Teamverwaltung';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$de extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'KI-gestütztes Aufgabenmanagement: Komplexe Projekte in handhabbare Unteraufgaben aufteilen';
	@override String get prdTemplates => 'PRD-Vorlagen: Aufgaben aus Produktanforderungsdokumenten generieren';
	@override String get dependencyTracking => 'Abhängigkeitsverfolgung: Aufgabenbeziehungen und Ausführungsreihenfolge verstehen';
	@override String get progressVisualization => 'Fortschrittsvisualisierung: Kanban-Boards und detaillierte Aufgabenanalysen';
	@override String get cliIntegration => 'CLI-Integration: Taskmaster-Befehle für erweiterte Workflows verwenden';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$de extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$de createPRD = Translations$tasks$gettingStarted$steps$createPRD$de._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$de generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$de._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$de analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$de._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$de startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$de._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$de extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Beispiel:\n"Ich habe gerade ein neues Projekt mit Claude Task Master initialisiert. Ich habe ein PRD unter .taskmaster/docs/prd.txt. Kannst du mir helfen, es zu analysieren und die ersten Aufgaben einzurichten?"';
	@override String get expandTask => '💬 Beispiel:\n"Aufgabe 5 scheint komplex. Kannst du sie in Unteraufgaben aufteilen?"';
	@override String get addTask => '💬 Beispiel:\n"Bitte füge eine neue Aufgabe hinzu, um Benutzerprofilbild-Uploads mit Cloudinary zu implementieren, und recherchiere den besten Ansatz."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$de extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Profi-Tipps';
	@override String get search => 'Verwende die Suchleiste, um bestimmte Aufgaben schnell zu finden';
	@override String get views => 'Wechsle mit den Ansichts-Umschaltern zwischen Kanban-, Listen- und Rasteransicht';
	@override String get filters => 'Verwende Filter, um dich auf bestimmte Aufgabenstatus oder Prioritäten zu konzentrieren';
	@override String get details => 'Klicke auf eine Aufgabe, um detaillierte Informationen anzuzeigen und Unteraufgaben zu verwalten';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$de extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 Mehr erfahren';
	@override String get description => 'TaskMaster AI ist ein fortschrittliches Aufgabenmanagementsystem für Entwickler:innen. Dokumentation, Beispiele und Möglichkeiten zur Mitarbeit am Projekt.';
	@override String get githubButton => 'Auf GitHub ansehen';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$de extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Noch keine Karten';
	@override String get description => 'Füge eine Karte hinzu, beschreibe die Aufgabe und ziehe sie dann auf Bereit, damit ein Agent mit der Arbeit beginnt.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$de extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Backlog';
	@override String get ready => 'Bereit zum Start';
	@override String get working => 'In Arbeit';
	@override String get needsDecision => 'Braucht deine Entscheidung';
	@override String get done => 'Erledigt';
	@override String get archived => 'Archiviert';
}

// Path: tasks.board.card
class Translations$tasks$board$card$de extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get running => 'Läuft';
	@override String get abort => 'Abbrechen';
	@override String get delete => 'Löschen';
	@override String get openSession => 'Sitzung öffnen';
	@override String get pullRequest => 'Pull Request';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$de extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Neue Karte';
	@override String get editTitle => 'Karte bearbeiten';
	@override String get titleLabel => 'Titel';
	@override String get titlePlaceholder => 'Was soll der Agent tun?';
	@override String get descriptionLabel => 'Beschreibung';
	@override String get descriptionPlaceholder => 'Kontext, Akzeptanzkriterien, Links hinzufügen...';
	@override String get cancel => 'Abbrechen';
	@override String get save => 'Speichern';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$de extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Agent';
	@override String get anyProvider => 'Beliebiger Agent';
	@override String get model => 'Modell';
	@override String get defaultModel => 'Standardmodell';
	@override String get effort => 'Reasoning';
	@override String get defaultEffort => 'Standard';
	@override String get searchModel => 'Modelle suchen…';
	@override String get noModels => 'Keine passenden Modelle';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$de extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '„${cardTitle}“ wird endgültig gelöscht.';
	@override String get title => 'Karte löschen?';
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$de extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get bearerTokenEnvVar => 'Umgebungsvariable für Bearer-Token';
	@override String get envVarNames => 'Namen der Umgebungsvariablen';
	@override String get workingDirectory => 'Arbeitsverzeichnis';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$de extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get claudeLocal => 'Claude lokal';
	@override late final Translations$mcp$form$scope$description$de description = Translations$mcp$form$scope$description$de._(_root);
	@override String get projectAllProviders => 'Projekt (alle Anbieter)';
	@override String get userAllProviders => 'Benutzer:in (alle Anbieter)';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$de extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => '„MCP-Server hinzufügen“ unterstützt bei allen Anbietern nur stdio und http, nicht ${type}.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} unterstützt keine ${type}-MCP-Server';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$de extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Arbeitsverzeichnis';
	@override String get envVars => 'Umgebungsvariablen';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$de extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vorhandener Arbeitsbereich';
	@override String get description => 'Ich habe bereits einen Arbeitsbereich auf meinem Server und möchte ihn nur zur Projektliste hinzufügen';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$de extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Neuer Arbeitsbereich';
	@override String get description => 'Einen neuen Arbeitsbereich erstellen, optional aus einem GitHub-Repository klonen';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$de extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuell — nur Empfehlung';
	@override String get ask => 'Vor Kontowechsel fragen';
	@override String get autoLowRisk => 'Auto-Wechsel für risikoarme Aufgaben';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$de extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$de info = Translations$common$notifications$codes$generic$info$de._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$de extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$de required = Translations$common$notifications$codes$permission$required$de._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$de extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$de stopped = Translations$common$notifications$codes$run$stopped$de._(_root);
	@override late final Translations$common$notifications$codes$run$failed$de failed = Translations$common$notifications$codes$run$failed$de._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$de extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$de notification = Translations$common$notifications$codes$agent$notification$de._(_root);
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$de extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

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
	@override String get redundantAccounts => 'Redundante Konten';
	@override String get redundantAccountsNone => 'Keine weiteren Konten für diesen Anbieter';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$de extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

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
class Translations$settings$orchestration$planner$modes$de extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$de extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$de extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$de extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$de extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Editor-Design';
	@override String get description => 'Standarddesign für den Code-Editor';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$de extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Zeilenumbruch';
	@override String get description => 'Zeilenumbruch standardmäßig im Editor aktivieren';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$de extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Minimap anzeigen';
	@override String get description => 'Minimap zur einfacheren Navigation in der Diff-Ansicht anzeigen';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$de extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Zeilennummern anzeigen';
	@override String get description => 'Zeilennummern im Editor anzeigen';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$de extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Schriftgröße';
	@override String get description => 'Editor-Schriftgröße in Pixeln';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$de extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get label => 'Fokus folgt dem Zeiger';
	@override String get description => 'Terminal für die Eingabe fokussieren, wenn du die Maus darüber bewegst';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$de extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Token-Name (z. B. Persönliche Repos)';
	@override String get tokenPlaceholder => 'GitHub Personal Access Token (ghp_...)';
	@override String get descriptionPlaceholder => 'Beschreibung (optional)';
	@override String get addButton => 'Token hinzufügen';
	@override String get cancelButton => 'Abbrechen';
	@override String get howToCreate => 'Wie man einen GitHub Personal Access Token erstellt →';
	@override String get showToken => 'Token anzeigen';
	@override String get hideToken => 'Token ausblenden';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$de extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Diese Anwendung neu starten';
	@override String get autoAvailable => 'TaskMaster-Funktionen werden automatisch verfügbar';
	@override String get initCommand => 'task-master init in deinem Projektverzeichnis verwenden';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$de extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Anthropic Claude KI-Assistent';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$de extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Cursor KI-gestützter Code-Editor';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$de extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenAI Codex KI-Assistent';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$de extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenCode CLI-Assistent';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$de extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Command Code CLI-Assistent';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$de extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Antigravity CLI-Assistent';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$de extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get description => 'Devin CLI-Assistent';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$de extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$de kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$de._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$de auto = Translations$settings$permissions$permissionMode$modes$auto$de._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$de acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$de._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$de bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$de._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$de plan = Translations$settings$permissions$permissionMode$modes$plan$de._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$de extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuell';
	@override String get manualHint => 'Nur eine Empfehlung anzeigen; Konten nie automatisch wechseln.';
	@override String get ask => 'Vor dem Wechsel fragen';
	@override String get askHint => 'Ein Wechsel wird vorgeschlagen und wartet auf deine Zustimmung.';
	@override String get autoLowRisk => 'Automatisch bei risikoarmen Aufgaben';
	@override String get autoLowRiskHint => 'Nur als risikoarm markierte Aufgaben dürfen automatisch verschoben werden.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$de extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Produktanforderungsdokument (PRD) erstellen';
	@override String get description => 'Besprich deine Projektidee und erstelle ein PRD, das beschreibt, was du bauen möchtest.';
	@override String get addButton => 'PRD hinzufügen';
	@override String get existingPRDs => 'Vorhandene PRDs:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$de extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aufgaben aus PRD generieren';
	@override String get description => 'Sobald du ein PRD hast, bitte deinen KI-Assistenten, es zu analysieren. TaskMaster wird es automatisch in überschaubare Aufgaben mit Implementierungsdetails aufteilen.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$de extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aufgaben analysieren und erweitern';
	@override String get description => 'Bitte deinen KI-Assistenten, die Aufgabenkomplexität zu analysieren und sie in detaillierte Unteraufgaben für eine einfachere Implementierung zu erweitern.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$de extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mit dem Bauen beginnen';
	@override String get description => 'Bitte deinen KI-Assistenten, mit der Bearbeitung von Aufgaben zu beginnen, deren Status zu aktualisieren und neue Aufgaben hinzuzufügen, wenn dein Projekt sich weiterentwickelt.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$de extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get local => 'Wird in den Claude-Benutzereinstellungen für das ausgewählte Projekt gespeichert';
	@override String get project => 'Wird im Arbeitsbereich des ausgewählten Projekts gespeichert';
	@override String get projectGlobal => 'Schreibt für jeden Anbieter in den Arbeitsbereich des ausgewählten Projekts';
	@override String get user => 'In allen Projekten auf deinem Computer verfügbar';
	@override String get userGlobal => 'Schreibt in die Benutzerkonfiguration jedes Anbieters und ist projektübergreifend auf diesem Computer verfügbar';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$de extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Benachrichtigung';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$de extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aktion erforderlich';
	@override String body({required Object toolName}) => '${toolName} wartet auf deine Entscheidung.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$de extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Lauf gestoppt';
	@override String body({required Object reason}) => 'Grund: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$de extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Lauf fehlgeschlagen';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$de extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Agent-Benachrichtigung';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$de extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Standard';
	@override String get description => 'Aktionen, die eine Berechtigung benötigen, werden dir im Chat zur Genehmigung gezeigt.';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$de extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Auto-Modus';
	@override String get description => 'Ein Modell-Klassifizierer entscheidet pro Tool-Aufruf, ob genehmigt oder abgelehnt wird. Hohe Autonomie.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$de extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bearbeitungen akzeptieren';
	@override String get description => 'Dateibearbeitungen werden automatisch genehmigt; andere Aktionen fragen weiterhin nach deiner Zustimmung.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$de extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Berechtigungen umgehen';
	@override String get description => 'Jede Aktion wird automatisch genehmigt — voller Zugriff ohne Nachfragen. Mit Vorsicht verwenden.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$de extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$de._(TranslationsDe root) : this._root = root, super.internal(root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get description => 'Planungsmodus: Der Agent erkundet und plant, ohne Befehle auszuführen.';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.',
			'auth.login.title' => 'Willkommen zurück',
			'auth.login.description' => 'Meld dich bei deinem ddagent-Konto an',
			'auth.login.username' => 'Benutzername',
			'auth.login.password' => 'Passwort',
			'auth.login.submit' => 'Anmelden',
			'auth.login.loading' => 'Wird angemeldet...',
			'auth.login.errors.invalidCredentials' => 'Ungültiger Benutzername oder Passwort',
			'auth.login.errors.requiredFields' => 'Bitte alle Felder ausfüllen',
			'auth.login.errors.networkError' => 'Netzwerkfehler. Bitte erneut versuchen.',
			'auth.login.placeholders.username' => 'Benutzernamen eingeben',
			'auth.login.placeholders.password' => 'Passwort eingeben',
			'auth.register.title' => 'Konto erstellen',
			'auth.register.username' => 'Benutzername',
			'auth.register.password' => 'Passwort',
			'auth.register.confirmPassword' => 'Passwort bestätigen',
			'auth.register.submit' => 'Konto erstellen',
			'auth.register.loading' => 'Konto wird erstellt...',
			'auth.register.errors.passwordMismatch' => 'Passwörter stimmen nicht überein',
			'auth.register.errors.usernameTaken' => 'Benutzername ist bereits vergeben',
			'auth.register.errors.weakPassword' => 'Passwort ist zu schwach',
			'auth.register.errors.usernameTooShort' => 'Benutzername muss mindestens 3 Zeichen lang sein',
			'auth.register.errors.passwordTooShort' => 'Passwort muss mindestens 6 Zeichen lang sein',
			'auth.logout.title' => 'Abmelden',
			'auth.logout.confirm' => 'Möchtest du dich wirklich abmelden?',
			'auth.logout.button' => 'Abmelden',
			'chat.codeBlock.copy' => 'Kopieren',
			'chat.codeBlock.copied' => 'Kopiert',
			'chat.codeBlock.copyCode' => 'Code kopieren',
			'chat.copyMessage.copy' => 'Nachricht kopieren',
			'chat.copyMessage.copied' => 'Nachricht kopiert',
			'chat.copyMessage.failed' => 'Kopieren fehlgeschlagen',
			'chat.copyMessage.selectFormat' => 'Kopierformat auswählen',
			'chat.copyMessage.copyAsMarkdown' => 'Als Markdown kopieren',
			'chat.copyMessage.copyAsText' => 'Als Text kopieren',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'Benutzer:in',
			'chat.messageTypes.error' => 'Fehler',
			'chat.messageTypes.tool' => 'Werkzeug',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.tools.settings' => 'Werkzeugeinstellungen',
			'chat.tools.error' => 'Werkzeugfehler',
			'chat.tools.result' => 'Werkzeugergebnis',
			'chat.tools.viewParams' => 'Eingabeparameter anzeigen',
			'chat.tools.viewRawParams' => 'Rohe Parameter anzeigen',
			'chat.tools.viewDiff' => 'Bearbeitungs-Diff anzeigen für',
			'chat.tools.creatingFile' => 'Neue Datei wird erstellt:',
			'chat.tools.updatingTodo' => 'Aufgabenliste wird aktualisiert',
			'chat.tools.read' => 'Gelesen',
			'chat.tools.readFile' => 'Datei lesen',
			'chat.tools.updateTodo' => 'Aufgabenliste aktualisieren',
			'chat.tools.readTodo' => 'Aufgabenliste lesen',
			'chat.tools.searchResults' => 'Ergebnisse',
			'chat.tools.todoReadLabel' => 'TodoRead liest die Aufgabenliste',
			'chat.search.found' => ({required Object count, required Object type}) => '${count} ${type} gefunden',
			'chat.search.file' => 'Datei',
			'chat.search.files' => 'Dateien',
			'chat.search.pattern' => 'Muster:',
			'chat.search.kIn' => 'in:',
			'chat.fileOperations.updated' => 'Datei erfolgreich aktualisiert',
			'chat.fileOperations.created' => 'Datei erfolgreich erstellt',
			'chat.fileOperations.written' => 'Datei erfolgreich geschrieben',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => 'Neue Datei',
			'chat.fileOperations.viewContent' => 'Dateiinhalt anzeigen',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Vollständige Ausgabe anzeigen (${count} Zeichen)',
			'chat.fileOperations.contentDisplayed' => 'Der Dateiinhalt wird in der Diff-Ansicht oben angezeigt',
			'chat.interactive.title' => 'Interaktive Eingabeaufforderung',
			'chat.interactive.waiting' => 'Warte auf deine Antwort in der CLI',
			'chat.interactive.instruction' => 'Bitte wähl eine Option in deinem Terminal, in dem Claude läuft.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude hat Option ${number} ausgewählt',
			'chat.interactive.instructionDetail' => 'In der CLI würdest du diese Option interaktiv mit den Pfeiltasten oder durch Eingabe der Nummer auswählen.',
			'chat.thinking.title' => 'Denkt nach...',
			'chat.thinking.emoji' => '💭 Denkt nach...',
			'chat.json.response' => 'JSON-Antwort',
			'chat.permissions.grant' => ({required Object tool}) => 'Berechtigung für ${tool} erteilen',
			'chat.permissions.added' => 'Berechtigung hinzugefügt',
			'chat.permissions.addTo' => ({required Object entry}) => 'Fügt ${entry} zu erlaubten Werkzeugen hinzu.',
			'chat.permissions.retry' => 'Berechtigung gespeichert. Wiederhole die Anfrage, um das Werkzeug zu verwenden.',
			'chat.permissions.error' => 'Berechtigungen konnten nicht aktualisiert werden. Bitte erneut versuchen.',
			'chat.permissions.openSettings' => 'Einstellungen öffnen',
			'chat.permissions.allow' => 'Zulassen',
			'chat.permissions.allowAll' => ({required Object count}) => 'Alle zulassen (${count})',
			'chat.permissions.allowWithChanges' => 'Mit Änderungen zulassen',
			'chat.permissions.always' => 'Immer',
			'chat.permissions.deny' => 'Ablehnen',
			'chat.permissions.editAndAllow' => 'Bearbeiten & zulassen',
			'chat.permissions.editInput' => 'Eingabe bearbeiten',
			'chat.permissions.invalidJson' => 'Ungültiges JSON',
			'chat.permissions.reject' => 'Zurückweisen',
			'chat.todo.updated' => 'Aufgabenliste wurde erfolgreich aktualisiert',
			'chat.todo.current' => 'Aktuelle Aufgabenliste',
			'chat.plan.viewPlan' => '📋 Implementierungsplan anzeigen',
			'chat.plan.title' => 'Implementierungsplan',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claude-Nutzungslimit erreicht. Dein Limit wird um **${time} ${timezone}** zurückgesetzt - ${date}',
			'chat.codex.permissionMode' => 'Berechtigungsmodus',
			'chat.codex.modes.kDefault' => 'Standardmodus',
			'chat.codex.modes.auto' => 'Auto-Modus',
			'chat.codex.modes.acceptEdits' => 'Bearbeitungen akzeptieren',
			'chat.codex.modes.bypassPermissions' => 'Berechtigungen umgehen',
			'chat.codex.modes.plan' => 'Planungsmodus',
			'chat.codex.descriptions.kDefault' => 'Nur vertrauenswürdige Befehle (ls, cat, grep, git status usw.) werden automatisch ausgeführt. Andere Befehle werden übersprungen. Kann in den Arbeitsbereich schreiben.',
			'chat.codex.descriptions.auto' => 'Ein Modell-Klassifizierer entscheidet pro Tool-Aufruf, ob genehmigt oder abgelehnt wird. Hohe Autonomie.',
			'chat.codex.descriptions.acceptEdits' => 'Alle Befehle werden automatisch innerhalb des Arbeitsbereichs ausgeführt. Vollautomatischer Modus mit isolierter Ausführung.',
			'chat.codex.descriptions.bypassPermissions' => 'Vollständiger Systemzugriff ohne Einschränkungen. Alle Befehle werden automatisch mit vollem Festplatten- und Netzwerkzugriff ausgeführt. Mit Vorsicht verwenden.',
			'chat.codex.descriptions.plan' => 'Planungsmodus – keine Befehle werden ausgeführt',
			'chat.codex.technicalDetails' => 'Technische Details',
			'chat.input.placeholder' => ({required Object provider}) => '/ für Befehle, @ für Dateien eingeben oder ${provider} etwas fragen...',
			'chat.input.placeholderDefault' => 'Nachricht eingeben...',
			'chat.input.disabled' => 'Eingabe deaktiviert',
			'chat.input.attachFiles' => 'Dateien anhängen',
			'chat.input.attachImages' => 'Bilder anhängen',
			'chat.input.send' => 'Senden',
			'chat.input.stop' => 'Stoppen',
			'chat.input.hintText.ctrlEnter' => 'Strg+Enter zum Senden • / Befehle • @ Dateien',
			'chat.input.hintText.enter' => 'Enter zum Senden • Shift+Enter neue Zeile • / Befehle • @ Dateien',
			'chat.input.hintText.queue' => 'Enter, um die nächste Nachricht einzureihen',
			'chat.input.hintText.updateQueued' => 'Enter, um die eingereihte Nachricht zu aktualisieren',
			'chat.input.clickToChangeMode' => 'Klicken, um den Berechtigungsmodus zu ändern',
			'chat.input.showAllCommands' => 'Alle Befehle anzeigen',
			'chat.input.clearInput' => 'Eingabe leeren',
			'chat.input.scrollToBottom' => 'Nach unten scrollen',
			'chat.input.attachFilesDesc' => 'Fotos, Dateien oder Dokumente hochladen',
			'chat.input.takePhoto' => 'Foto aufnehmen',
			'chat.input.takePhotoDesc' => 'Kamera zum Aufnehmen eines Fotos verwenden',
			'chat.input.moreTools' => 'Mehr Werkzeuge',
			'chat.input.commandsDesc' => 'Tastenkürzel und Befehle erkunden',
			'chat.input.clearInputDesc' => 'Aktuellen Text verwerfen',
			'chat.input.newMessage' => 'Neue Nachricht',
			'chat.input.newMessages' => 'Neue Nachrichten',
			'chat.input.queue.sendNext' => 'Nächste Nachricht einreihen',
			'chat.input.queue.update' => 'Eingereihte Nachricht aktualisieren',
			'chat.input.queue.label' => 'Eingereiht',
			'chat.input.queue.willSend' => 'Wird gesendet, wenn dies abgeschlossen ist',
			'chat.input.queue.edit' => 'Eingereihte Nachricht bearbeiten',
			'chat.input.queue.delete' => 'Eingereihte Nachricht löschen',
			'chat.input.queue.failed' => 'Senden fehlgeschlagen',
			'chat.input.queue.sendNow' => 'Jetzt senden',
			'chat.input.autoContinueTasks' => 'Auto-Fortsetzen',
			'chat.input.autoContinueTasksTooltip' => 'Aktivieren, damit Devin automatisch mit der nächsten Task-Master-Aufgabe fortfährt',
			'chat.input.offlineQueue.clear' => 'Offline-Warteschlange abbrechen und leeren',
			'chat.input.offlineQueue.clearBtn' => 'Abbrechen',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} Nachrichten offline in der Warteschlange — werden bei Wiederverbindung automatisch gesendet',
			'chat.input.offlineQueue.single' => '1 Nachricht offline in der Warteschlange — wird bei Wiederverbindung automatisch gesendet',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Kamera nicht verfügbar: ${error}',
			'chat.providerSelection.title' => 'KI-Assistent wählen',
			'chat.providerSelection.description' => 'Anbieter auswählen, um eine neue Unterhaltung zu starten',
			'chat.providerSelection.selectModel' => 'Modell auswählen',
			'chat.providerSelection.providerInfo.anthropic' => 'von Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'von OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'KI-Code-Editor',
			'chat.providerSelection.providerInfo.google' => 'von Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Bereit, Claude mit ${model} zu verwenden. Gib unten deine Nachricht ein.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Bereit, Cursor mit ${model} zu verwenden. Gib unten deine Nachricht ein.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Bereit, Codex mit ${model} zu verwenden. Gib unten deine Nachricht ein.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Wähl oben einen Anbieter, um zu beginnen',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'Bereit, OpenCode mit ${model} zu verwenden. Tippe unten deine Nachricht.',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Bereit mit Devin ${model}',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Drücke <kbd>${shortcut}</kbd>, um Sitzungen, Dateien und Commits zu durchsuchen',
			'chat.providerSelection.workspace' => 'Arbeitsbereich',
			'chat.providerSelection.noWorkspace' => 'Keiner',
			'chat.providerSelection.clickToChangeWorkspace' => 'Klicken, um Arbeitsbereich zu wechseln',
			'chat.providerSelection.chooseWorkspace' => 'Arbeitsbereich wählen',
			'chat.providerSelection.searchWorkspaces' => 'Arbeitsbereiche suchen...',
			'chat.providerSelection.noWorkspacesFound' => 'Keine Arbeitsbereiche gefunden.',
			'chat.providerSelection.all' => 'Alle',
			'chat.providerSelection.free' => 'Kostenlos',
			'chat.providerSelection.noModelsFound' => 'Keine Modelle gefunden.',
			'chat.providerSelection.paid' => 'Kostenpflichtig',
			'chat.providerSelection.searchModels' => 'Modelle suchen...',
			'chat.providerSelection.addModel' => 'Modell hinzufügen',
			'chat.providerSelection.chooseModel' => 'Modell wählen',
			'chat.providerSelection.chooseModelDescription' => 'Integrierte und benutzerdefinierte Modelle in einer Liste',
			'chat.providerSelection.clickToChange' => 'Klicken, um Modell zu ändern',
			'chat.providerSelection.favorites' => 'Favoriten',
			'chat.providerSelection.loadingModels' => 'Modelle werden geladen…',
			'chat.providerSelection.manageModels' => 'Modelle verwalten',
			'chat.providerSelection.refresh' => 'Modelle aktualisieren',
			'chat.session.kContinue.title' => 'Unterhaltung fortsetzen',
			'chat.session.kContinue.description' => 'Stell Fragen zu deinem Code, fordere Änderungen an oder hol Hilfe bei Entwicklungsaufgaben',
			'chat.session.kContinue.action' => 'Weiterschreiben',
			'chat.session.loading.olderMessages' => 'Ältere Nachrichten werden geladen...',
			'chat.session.loading.sessionMessages' => 'Sitzungsnachrichten werden geladen...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => '${shown} von ${total} Nachrichten werden angezeigt',
			'chat.session.messages.scrollToLoad' => 'Nach oben scrollen, um mehr zu laden',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Letzte ${count} Nachrichten werden angezeigt (${total} gesamt)',
			'chat.session.messages.loadEarlier' => 'Frühere Nachrichten laden',
			'chat.session.messages.loadAll' => 'Alle Nachrichten laden',
			'chat.session.messages.loadingAll' => 'Alle Nachrichten werden geladen...',
			'chat.session.messages.allLoaded' => 'Alle Nachrichten geladen',
			'chat.session.messages.perfWarning' => 'Alle Nachrichten geladen – Scrollen kann langsamer sein. Klick auf \'Nach unten scrollen\', um die Leistung wiederherzustellen.',
			'chat.session.messages.loadOlderFailed' => 'Ältere Nachrichten konnten nicht geladen werden.',
			'chat.session.messages.retry' => 'Wiederholen',
			'chat.session.messages.noSearchMatches' => 'Keine Nachrichten entsprechen der Suche.',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Alle laden (${count})',
			'chat.session.messages.loadOlder' => 'Ältere Nachrichten laden',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Laden älterer Nachrichten erneut versuchen — ${error}',
			'chat.session.deleteConfirm' => 'Entfernt die Sitzung und ihr Transkript. Kann nicht rückgängig gemacht werden.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Beende den Lauf, bevor du den Arbeitsbereich wechselst',
			'chat.shell.selectProject.title' => 'Projekt auswählen',
			'chat.shell.selectProject.description' => 'Wähl ein Projekt, um ein interaktives Terminal in diesem Verzeichnis zu öffnen',
			'chat.shell.status.newSession' => 'Neue Sitzung',
			'chat.shell.status.initializing' => 'Wird initialisiert...',
			'chat.shell.status.restarting' => 'Wird neu gestartet...',
			'chat.shell.actions.disconnect' => 'Trennen',
			'chat.shell.actions.disconnectTitle' => 'Vom Terminal trennen',
			'chat.shell.actions.restart' => 'Neu starten',
			'chat.shell.actions.restartTitle' => 'Terminal neu starten (zuerst trennen)',
			'chat.shell.actions.connect' => 'Im Terminal fortfahren',
			'chat.shell.actions.connectTitle' => 'Mit Terminal verbinden',
			'chat.shell.actions.kill' => 'Beenden (SIGINT)',
			'chat.shell.actions.killTitle' => 'Laufenden Prozess beenden (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Ausgabe kopieren',
			'chat.shell.actions.copyOutputTitle' => 'Terminalausgabe kopieren',
			'chat.shell.actions.copied' => 'Kopiert!',
			'chat.shell.actions.zoomInTitle' => 'Vergrößern',
			'chat.shell.actions.zoomOutTitle' => 'Verkleinern',
			'chat.shell.loading' => 'Terminal wird geladen...',
			'chat.shell.connecting' => 'Verbindung zum Terminal wird hergestellt...',
			'chat.shell.startSession' => 'Neue Claude-Sitzung starten',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Sitzung fortsetzen: ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => '${command} in ${projectName} ausführen',
			'chat.shell.startCli' => ({required Object projectName}) => 'Claude CLI wird in ${projectName} gestartet',
			'chat.shell.defaultCommand' => 'Befehl',
			'chat.claudeStatus.actions.thinking' => 'Denkt nach',
			'chat.claudeStatus.actions.processing' => 'Verarbeitet',
			'chat.claudeStatus.actions.analyzing' => 'Analysiert',
			'chat.claudeStatus.actions.working' => 'Arbeitet',
			'chat.claudeStatus.actions.computing' => 'Berechnet',
			'chat.claudeStatus.actions.reasoning' => 'Schlussfolgert',
			'chat.claudeStatus.state.live' => 'Live',
			'chat.claudeStatus.state.paused' => 'Pausiert',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}s',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} vergangen',
			'chat.claudeStatus.elapsed.startingNow' => 'Startet jetzt',
			'chat.claudeStatus.controls.stopGeneration' => 'Generierung stoppen',
			'chat.claudeStatus.controls.pressEscToStop' => 'Jederzeit Esc drücken, um zu stoppen',
			'chat.claudeStatus.providers.assistant' => 'Assistent',
			'chat.claudeStatus.stop' => 'Stoppen',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} Hintergrundaufgabe läuft', other: '${count} Hintergrundaufgaben laufen', ), 
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Wähl ein Projekt, um mit ${provider} zu chatten',
			'chat.tasks.nextTaskPrompt' => 'Nächste Aufgabe starten',
			'chat.voice.autoRead' => 'Antworten vorlesen',
			'chat.voice.autoReadOn' => 'Antworten vorlesen: an',
			'chat.voice.autoReadOff' => 'Antworten vorlesen: aus',
			'chat.voice.autoReadVoice' => 'Stimme zum Vorlesen',
			'chat.voice.autoReadVoiceAuto' => 'Automatische Stimme',
			'chat.voice.autoReadPreview' => 'So werden Antworten klingen.',
			'chat.voice.speakMessage' => 'Vorlesen',
			'chat.voice.stopSpeaking' => 'Vorlesen stoppen',
			'chat.composer.toolsAndActions' => 'Werkzeuge & Aktionen',
			'chat.composer.toolsAndActionsDesc' => 'Werkzeuge und Steuerungen für den Chat-Editor',
			'chat.composer.reasoning' => 'Schlussfolgert',
			'chat.composer.model' => 'Modell',
			'chat.composer.effortDefault' => 'Standard',
			'chat.composer.loadingModels' => 'Modelle werden geladen…',
			'chat.composer.modelMenu' => 'Modell und Reasoning-Aufwand wählen',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'Wie sollen ${provider}-Aktionen genehmigt werden?',
			'chat.composer.favorites' => 'Favoriten',
			'chat.splitSession.toggle' => 'Sitzung teilen',
			'chat.splitSession.close' => 'Geteilte Sitzung schließen',
			'chat.splitSession.selectSession' => 'Sitzung zum Vergleichen wählen',
			'chat.splitSession.noOtherSessions' => 'Keine weiteren Sitzungen verfügbar',
			'chat.splitSession.newSessionOption' => '+ Neue Sitzung in geteilter Ansicht',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Aktuelles Projekt (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Andere Projekte',
			'chat.splitSession.recentSessionsGroup' => 'Letzte Sitzungen',
			'chat.splitSession.startNewSession' => 'Neue Sitzung in geteilter Ansicht starten',
			'chat.splitSession.selectFromList' => 'Sitzung aus der Liste vorhandener Sitzungen wählen',
			'chat.sessionPicker.title' => 'Sitzung auswählen',
			'chat.sessionPicker.searchPlaceholder' => 'Sitzungen suchen...',
			'chat.sessionPicker.clearSearch' => 'Suche löschen',
			'chat.sessionPicker.newChat' => '+ Neuer Chat',
			'chat.sessionPicker.archivedToggle' => 'Archiviert',
			'chat.sessionPicker.changeSession' => 'Sitzung wechseln',
			'chat.sessionPicker.archivedLoading' => 'Archivierte Sitzungen werden geladen...',
			'chat.sessionPicker.archivedError' => 'Archivierte Sitzungen konnten nicht geladen werden',
			'chat.sessionPicker.archivedEmpty' => 'Keine archivierten Sitzungen',
			'chat.sessionPicker.archivedProjectOnly' => 'Arbeitsbereich archiviert — wiederherstellen, um seine Sitzungen zu sehen.',
			'chat.sessionPicker.emptySearch' => 'Keine Sitzungen entsprechen der Suche',
			'chat.sessionPicker.restore' => 'Wiederherstellen',
			'chat.sessionPicker.restoreSession' => 'Sitzung wiederherstellen',
			'chat.sessionPicker.restoreProject' => 'Arbeitsbereich wiederherstellen',
			'chat.sessionPicker.restoreSessionFailed' => 'Wiederherstellen der Sitzung fehlgeschlagen. Bitte erneut versuchen.',
			'chat.sessionPicker.restoreProjectFailed' => 'Wiederherstellen des Arbeitsbereichs fehlgeschlagen. Bitte erneut versuchen.',
			'chat.sessionPicker.archiveFailed' => 'Archivieren der Sitzung fehlgeschlagen. Bitte erneut versuchen.',
			'chat.sessionPicker.deleteFailed' => 'Löschen der Sitzung fehlgeschlagen. Bitte erneut versuchen.',
			'chat.sessionPicker.running' => 'Sitzung läuft',
			'chat.sessionPicker.unread' => 'Ungelesen — mit neuer Ausgabe beendet',
			'chat.splitWorkspace.addChat' => 'Chat-Bereich hinzufügen',
			'chat.splitWorkspace.addBrowser' => 'Browser-Bereich hinzufügen',
			'chat.splitWorkspace.addTerminal' => 'Terminal-Bereich hinzufügen',
			'chat.splitWorkspace.overview' => 'Alle Bereiche anzeigen',
			'chat.splitWorkspace.exitFocusMode' => 'Fokusmodus beenden (Strg+Umschalt+F)',
			'chat.splitWorkspace.focusMode' => 'Fokusmodus (Strg+Umschalt+F)',
			'chat.splitWorkspace.browseSessions' => 'Sitzungsliste öffnen',
			'chat.splitOverview.title' => 'Übersicht geteilter Bereiche',
			'chat.splitOverview.count' => ({required Object count}) => '${count} Bereiche',
			'chat.splitOverview.close' => 'Übersicht schließen',
			'chat.splitOverview.question' => 'FRAGE — Eingabe erforderlich',
			'chat.splitOverview.processing' => 'VERARBEITUNG',
			'chat.splitOverview.idle' => 'Inaktiv',
			'chat.splitOverview.active' => 'Aktiv',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} benötigt deine Eingabe',
			'chat.askUserQuestion.answerHint' => 'Antwort eingeben…',
			'chat.askUserQuestion.other' => 'Andere…',
			'chat.askUserQuestion.skip' => 'Überspringen',
			'chat.attachments.downloadFailedRetry' => 'Download fehlgeschlagen — klicken zum Wiederholen',
			'chat.attachments.fileAttachment' => 'Dateianhang',
			'chat.attachments.download' => ({required Object name}) => '${name} herunterladen',
			'chat.checkpoint.creating' => 'Erstelle Snapshot…',
			'chat.checkpoint.revertChanges' => 'Dateien auf letzten Checkpoint zurücksetzen',
			'chat.checkpoint.undo' => 'Checkpoint rückgängig machen',
			'chat.checkpoint.beforeAiTurn' => 'vor dem KI-Schritt',
			'chat.common.close' => 'Schließen',
			'chat.taskMaster.saveToTask' => 'Aufgabe',
			'chat.taskMaster.saved' => 'Gespeichert',
			'chat.taskMaster.saving' => 'Speichere...',
			'chat.taskMaster.taskShort' => 'TASK',
			'chat.taskMaster.addToTask' => 'Zu TaskMaster hinzufügen',
			'chat.taskMaster.added' => 'Zu TaskMaster hinzugefügt',
			'chat.tokenUsage.desc' => 'Tokenverbrauch der Sitzung anzeigen',
			'chat.tokenUsage.title' => 'Tokenverbrauch',
			'chat.tool.emptyResult' => '(noch keine Ausgabe — das Tool hat ein leeres Ergebnis zurückgegeben)',
			'chat.quotaBadge.ariaLabel' => 'Abo-Limits',
			'chat.quotaBadge.noData' => 'Keine Abodaten für dieses Modell',
			'chat.paneHeader.processing' => 'Verarbeitung…',
			'chat.paneHeader.switchSession' => 'Sitzung wechseln',
			'chat.broadcast.selectOrchestrators' => 'Orchestratoren auswählen',
			'chat.broadcast.orchestratorsOnly' => 'Nur Orchestratoren',
			'chat.broadcast.noOrchestrators' => 'Keine Orchestrator-Sitzungen verfügbar',
			'chat.changes.empty' => 'Keine Dateiänderungen',
			'chat.changes.failedToLoad' => 'Änderungen konnten nicht geladen werden',
			'chat.commandResult.fallback.config' => 'Einstellungen und Konfiguration öffnen.',
			'chat.commandResult.fallback.cost' => 'Tokenverbrauch der aktiven Sitzung prüfen.',
			'chat.commandResult.fallback.help' => 'Befehlsdokumentation und Syntax anzeigen.',
			'chat.commandResult.fallback.memory' => 'Die CLAUDE.md-Speicherdatei des Projekts öffnen.',
			'chat.commandResult.fallback.models' => 'Verfügbare Modelle für den aktiven Anbieter durchsuchen.',
			'chat.commandResult.fallback.status' => 'Laufzeit-, Versions-, Anbieter- und Umgebungsstatus prüfen.',
			'chat.commandResult.filterCommands' => 'Befehle filtern...',
			'chat.commandResult.searchModels' => ({required Object provider}) => '${provider}-Modelle suchen...',
			'chat.commands.runConfirmTitle' => 'Befehl ausführen?',
			'chat.commands.executionCancelled' => 'Befehlsausführung abgebrochen',
			'chat.export.sessionTitle' => ({required Object id}) => 'Sitzung ${id}',
			'chat.export.pdfFailed' => 'PDF-Export fehlgeschlagen',
			'chat.export.transcriptDownloaded' => 'Transkript heruntergeladen',
			'chat.export.savedTo' => ({required Object path}) => 'Gespeichert: ${path}',
			'chat.message.compactedSummary' => 'Verdichtete Zusammenfassung',
			'chat.message.rawView' => 'Rohansicht',
			'chat.message.resendHint' => 'Aus dem Chat-Editor erneut senden',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => '${name} löschen',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => '${name} bearbeiten',
			'chat.modelLibrary.enterNameAndId' => 'Gib sowohl einen Modellnamen als auch eine Modell-ID ein.',
			'chat.modelLibrary.idNoSpaces' => 'Modell-IDs dürfen keine Leerzeichen enthalten.',
			'chat.modelLibrary.setAsDefault' => 'Als Standard festlegen',
			'chat.modelLibrary.defaultModel' => 'Standardmodell',
			'chat.pinFile.action' => 'Anheften',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.title' => 'Datei anheften',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Berechtigungsanfrage · ${tool}',
			'chat.permissionRequest.question' => 'Frage',
			'codeEditor.toolbar.changes' => 'Änderungen',
			'codeEditor.toolbar.previousChange' => 'Vorherige Änderung',
			'codeEditor.toolbar.nextChange' => 'Nächste Änderung',
			'codeEditor.toolbar.hideDiff' => 'Diff-Hervorhebung ausblenden',
			'codeEditor.toolbar.showDiff' => 'Diff-Hervorhebung anzeigen',
			'codeEditor.toolbar.settings' => 'Editor-Einstellungen',
			'codeEditor.toolbar.collapse' => 'Editor einklappen',
			'codeEditor.toolbar.expand' => 'Editor auf volle Breite erweitern',
			'codeEditor.toolbar.diffMerge' => 'Diff / Merge',
			'codeEditor.toolbar.previewInBrowser' => 'Im Browser ansehen',
			'codeEditor.toolbar.reload' => 'Von der Festplatte neu laden',
			'codeEditor.toolbar.toggleDock' => 'Datei-Dock umschalten',
			'codeEditor.loading' => ({required Object fileName}) => '${fileName} wird geladen...',
			'codeEditor.header.showingChanges' => 'Änderungen werden angezeigt',
			'codeEditor.actions.copyPath' => 'Dateipfad kopieren',
			'codeEditor.actions.pathCopied' => 'Dateipfad kopiert',
			'codeEditor.actions.download' => 'Datei herunterladen',
			'codeEditor.actions.save' => 'Speichern',
			'codeEditor.actions.saving' => 'Wird gespeichert...',
			'codeEditor.actions.saved' => 'Gespeichert!',
			'codeEditor.actions.exitFullscreen' => 'Vollbild beenden',
			'codeEditor.actions.fullscreen' => 'Vollbild',
			'codeEditor.actions.close' => 'Schließen',
			'codeEditor.actions.previewMarkdown' => 'Markdown-Vorschau',
			'codeEditor.actions.editMarkdown' => 'Markdown bearbeiten',
			'codeEditor.actions.pinFile' => 'Datei an Kontext anheften',
			'codeEditor.actions.unpinFile' => 'Datei vom Kontext lösen',
			'codeEditor.actions.previewHtml' => 'HTML-Vorschau in neuem Tab öffnen',
			'codeEditor.actions.retry' => 'Wiederholen',
			'codeEditor.actions.saveAll' => 'Alle speichern',
			'codeEditor.footer.lines' => 'Zeilen:',
			'codeEditor.footer.characters' => 'Zeichen:',
			'codeEditor.footer.shortcuts' => 'Strg+S zum Speichern • Esc zum Schließen',
			'codeEditor.binaryFile.title' => 'Binärdatei',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Die Datei "${fileName}" kann im Texteditor nicht angezeigt werden, da es sich um eine Binärdatei handelt.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Kann nicht als Text angezeigt werden',
			'codeEditor.filePreview.loading' => 'Vorschau wird geladen...',
			'codeEditor.filePreview.error' => 'Diese Datei kann nicht angezeigt werden.',
			'codeEditor.filePreview.openInNewTab' => 'In neuem Tab öffnen',
			'codeEditor.diff.applyMerge' => 'Merge anwenden',
			'codeEditor.diff.base' => 'Basis',
			'codeEditor.diff.close' => 'Diff schließen',
			'codeEditor.diff.current' => 'Aktuell',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Hunk ${number}',
			'codeEditor.diff.noChanges' => 'Keine Änderungen',
			'codeEditor.diff.deletedOnDisk' => 'auf der Festplatte gelöscht',
			'codeEditor.discardUnsavedChanges' => 'Nicht gespeicherte Änderungen verwerfen?',
			'codeEditor.emptyState.title' => 'Keine Datei geöffnet',
			'codeEditor.failedToLoad' => 'Datei konnte nicht geladen werden',
			'codeEditor.hexDump.more' => ({required Object size}) => '… ${size} weitere',
			'codeEditor.mediaFile.subtitle' => 'Audio-/Video-Vorschau wird noch nicht unterstützt',
			'codeEditor.mediaFile.title' => 'Mediendatei',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Schriftgröße −  (jetzt ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Schriftgröße +',
			'codeEditor.settings.minimap' => 'Minimap',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Tab-Größe: ${size}',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Nicht gespeicherte Änderungen in ${name}',
			'codeEditor.toasts.savedFile' => ({required Object name}) => '${name} gespeichert',
			'codeEditor.toasts.saveFailed' => 'Speichern fehlgeschlagen',
			'codeEditor.toasts.allSaved' => 'Alle gespeichert',
			'codeEditor.toasts.someSavesFailed' => 'Einige Speichervorgänge fehlgeschlagen',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Gespeichert unter ${path}',
			'codeEditor.toasts.mergeApplied' => 'Merge angewendet — zum Beibehalten speichern',
			'common.buttons.save' => 'Speichern',
			'common.buttons.cancel' => 'Abbrechen',
			'common.buttons.delete' => 'Löschen',
			'common.buttons.create' => 'Erstellen',
			'common.buttons.edit' => 'Bearbeiten',
			'common.buttons.close' => 'Schließen',
			'common.buttons.confirm' => 'Bestätigen',
			'common.buttons.submit' => 'Absenden',
			'common.buttons.retry' => 'Erneut versuchen',
			'common.buttons.refresh' => 'Aktualisieren',
			'common.buttons.search' => 'Suchen',
			'common.buttons.clear' => 'Leeren',
			'common.buttons.copy' => 'Kopieren',
			'common.buttons.download' => 'Herunterladen',
			'common.buttons.upload' => 'Hochladen',
			'common.buttons.browse' => 'Durchsuchen',
			'common.buttons.openDiagram' => 'Diagramm öffnen',
			'common.buttons.update' => 'Aktualisieren',
			'common.tabs.chat' => 'Chat',
			'common.tabs.shell' => 'Terminal',
			'common.tabs.files' => 'Dateien',
			'common.tabs.git' => 'Quellcodeverwaltung',
			'common.tabs.tasks' => 'Aufgaben',
			'common.tabs.browser' => 'Browser',
			'common.tabs.computer' => 'Computer',
			'common.tabs.board' => 'Board',
			'common.tabs.usage' => 'AI Control',
			'common.status.loading' => 'Lädt...',
			'common.status.success' => 'Erfolgreich',
			'common.status.error' => 'Fehler',
			'common.status.failed' => 'Fehlgeschlagen',
			'common.status.pending' => 'Ausstehend',
			'common.status.completed' => 'Abgeschlossen',
			'common.status.inProgress' => 'In Bearbeitung',
			'common.messages.savedSuccessfully' => 'Erfolgreich gespeichert',
			'common.messages.deletedSuccessfully' => 'Erfolgreich gelöscht',
			'common.messages.updatedSuccessfully' => 'Erfolgreich aktualisiert',
			'common.messages.operationFailed' => 'Vorgang fehlgeschlagen',
			'common.messages.networkError' => 'Netzwerkfehler. Bitte überprüf deine Verbindung.',
			'common.messages.unauthorized' => 'Nicht autorisiert. Bitte meld dich an.',
			'common.messages.notFound' => 'Nicht gefunden',
			'common.messages.invalidInput' => 'Ungültige Eingabe',
			'common.messages.requiredField' => 'Dieses Feld ist erforderlich',
			'common.messages.unknownError' => 'Ein unbekannter Fehler ist aufgetreten',
			'common.messages.renameSessionFailed' => 'Sitzung konnte nicht umbenannt werden. Bitte erneut versuchen.',
			'common.navigation.settings' => 'Einstellungen',
			'common.navigation.home' => 'Startseite',
			'common.navigation.back' => 'Zurück',
			'common.navigation.next' => 'Weiter',
			'common.navigation.previous' => 'Zurück',
			'common.navigation.logout' => 'Abmelden',
			'common.common.language' => 'Sprache',
			'common.common.theme' => 'Design',
			'common.common.darkMode' => 'Darkmode',
			'common.common.lightMode' => 'Hellmodus',
			'common.common.name' => 'Name',
			'common.common.description' => 'Beschreibung',
			'common.common.enabled' => 'Aktiviert',
			'common.common.disabled' => 'Deaktiviert',
			'common.common.optional' => 'Optional',
			'common.common.version' => 'Version',
			'common.common.select' => 'Auswählen',
			'common.common.selectAll' => 'Alle auswählen',
			'common.common.deselectAll' => 'Alle abwählen',
			'common.common.done' => 'Fertig',
			'common.common.failed' => 'Fehlgeschlagen',
			'common.time.justNow' => 'Gerade eben',
			'common.time.minutesAgo' => ({required Object count}) => 'vor ${count} Min.',
			'common.time.hoursAgo' => ({required Object count}) => 'vor ${count} Std.',
			'common.time.daysAgo' => ({required Object count}) => 'vor ${count} Tagen',
			'common.time.yesterday' => 'Gestern',
			'common.fileOperations.newFile' => 'Neue Datei',
			'common.fileOperations.newFolder' => 'Neuer Ordner',
			'common.fileOperations.rename' => 'Umbenennen',
			'common.fileOperations.move' => 'Verschieben',
			'common.fileOperations.copyPath' => 'Pfad kopieren',
			'common.fileOperations.openInEditor' => 'Im Editor öffnen',
			'common.mainContent.loading' => 'ddagent wird geladen',
			'common.mainContent.settingUpWorkspace' => 'Arbeitsbereich wird eingerichtet...',
			'common.mainContent.chooseProject' => 'Projekt auswählen',
			'common.mainContent.selectProjectDescription' => 'Wähl ein Projekt aus der Seitenleiste, um mit Claude zu programmieren. Jedes Projekt enthält deine Chat-Sitzungen und den Dateiverlauf.',
			'common.mainContent.tip' => 'Tipp',
			_ => null,
		} ?? switch (path) {
			'common.mainContent.createProjectMobile' => 'Tipp oben auf die Menüschaltfläche, um auf Projekte zuzugreifen',
			'common.mainContent.createProjectDesktop' => 'Erstell ein neues Projekt, indem du auf das Ordnersymbol in der Seitenleiste klickst',
			'common.mainContent.newSession' => 'Neue Sitzung',
			'common.mainContent.untitledSession' => 'Unbenannte Sitzung',
			'common.mainContent.projectFiles' => 'Projektdateien',
			'common.mainContent.focusMode' => 'Fokusmodus (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Fokusmodus beenden (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Sitzung teilen',
			'common.mainContent.closeSplitSession' => 'Geteilte Sitzung schließen',
			'common.mainContent.chooseWorkspace' => 'Workspace auswählen',
			'common.mainContent.chooseWorkspaceDescription' => 'Wähle einen Workspace für diesen Chat oder erstelle einen neuen in den Einstellungen.',
			'common.mainContent.createWorkspace' => 'Workspace in den Einstellungen erstellen',
			'common.mainContent.recentProjects' => 'Letzte Projekte',
			'common.fileTree.loading' => 'Dateien werden geladen...',
			'common.fileTree.files' => 'Dateien',
			'common.fileTree.simpleView' => 'Einfache Ansicht',
			'common.fileTree.compactView' => 'Kompakte Ansicht',
			'common.fileTree.detailedView' => 'Detailansicht',
			'common.fileTree.searchPlaceholder' => 'Dateien und Ordner durchsuchen...',
			'common.fileTree.clearSearch' => 'Suche leeren',
			'common.fileTree.name' => 'Name',
			'common.fileTree.size' => 'Größe',
			'common.fileTree.modified' => 'Geändert',
			'common.fileTree.permissions' => 'Berechtigungen',
			'common.fileTree.noFilesFound' => 'Keine Dateien gefunden',
			'common.fileTree.checkProjectPath' => 'Überprüf, ob der Projektpfad zugänglich ist',
			'common.fileTree.noMatchesFound' => 'Keine Treffer gefunden',
			'common.fileTree.tryDifferentSearch' => 'Versuch einen anderen Suchbegriff oder leere die Suche',
			'common.fileTree.justNow' => 'gerade eben',
			'common.fileTree.minAgo' => ({required Object count}) => 'vor ${count} Min.',
			'common.fileTree.hoursAgo' => ({required Object count}) => 'vor ${count} Std.',
			'common.fileTree.daysAgo' => ({required Object count}) => 'vor ${count} Tagen',
			'common.fileTree.newFile' => 'Neue Datei (Cmd+N)',
			'common.fileTree.newFolder' => 'Neuer Ordner (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Aktualisieren',
			'common.fileTree.collapseAll' => 'Alle einklappen',
			'common.fileTree.context.rename' => 'Umbenennen',
			'common.fileTree.context.delete' => 'Löschen',
			'common.fileTree.context.copyPath' => 'Pfad kopieren',
			'common.fileTree.context.download' => 'Herunterladen',
			'common.fileTree.context.newFile' => 'Neue Datei',
			'common.fileTree.context.newFolder' => 'Neuer Ordner',
			'common.fileTree.context.upload' => 'Dateien hochladen',
			'common.fileTree.context.refresh' => 'Aktualisieren',
			'common.fileTree.context.menuLabel' => 'Datei-Kontextmenü',
			'common.fileTree.context.loading' => 'Lädt...',
			'common.fileTree.searchContentPlaceholder' => 'In Dateien suchen...',
			'common.fileTree.searchInFiles' => 'In Dateien suchen',
			'common.fileTree.searchByName' => 'Nach Name suchen',
			'common.fileTree.loadFailed' => 'Dateien konnten nicht geladen werden',
			'common.fileTree.noSearchResults' => 'Keine Treffer gefunden',
			'common.fileTree.searchError' => 'Suche fehlgeschlagen',
			'common.fileTree.searching' => 'Suche läuft...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Erste ${count} Ergebnisse werden angezeigt',
			'common.fileTree.allWorkspaces' => 'Alle Workspaces',
			'common.fileTree.delete.confirm' => 'Löschen',
			'common.fileTree.delete.fileWarning' => 'Diese Datei wird endgültig gelöscht.',
			'common.fileTree.delete.folderWarning' => 'Dieser Ordner und sein gesamter Inhalt werden endgültig gelöscht.',
			'common.fileTree.delete.title' => ({required Object type}) => '${type} löschen',
			'common.fileTree.dropToUpload' => 'Dateien zum Hochladen ablegen',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Dateien zum Hochladen nach „${folder}“ ablegen',
			'common.fileTree.noProject' => 'Zuerst ein Projekt hinzufügen',
			'common.fileTree.noRecentFiles' => 'Keine Dateien in den letzten 7 Tagen geändert',
			'common.fileTree.showAllFiles' => 'Alle Dateien anzeigen',
			'common.fileTree.showAllFilesHint' => 'Deaktiviere den Filter „zuletzt geändert“, um alles zu sehen.',
			'common.fileTree.showRecentOnly' => 'Nur in den letzten 7 Tagen geänderte Dateien anzeigen',
			'common.fileTree.toast.copyFailed' => 'Pfad konnte nicht kopiert werden',
			'common.fileTree.toast.fileCreated' => 'Datei erfolgreich erstellt',
			'common.fileTree.toast.fileDeleted' => 'Datei gelöscht',
			'common.fileTree.toast.folderCreated' => 'Ordner erfolgreich erstellt',
			'common.fileTree.toast.folderDeleted' => 'Ordner gelöscht',
			'common.fileTree.toast.folderDownloaded' => 'Ordner als ZIP heruntergeladen',
			'common.fileTree.toast.pathCopied' => 'Pfad in die Zwischenablage kopiert',
			'common.fileTree.toast.renamed' => 'Erfolgreich umbenannt',
			'common.fileTree.uploadComplete' => 'Upload abgeschlossen',
			'common.fileTree.uploadFailed' => 'Upload fehlgeschlagen',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Dateien hochladen (max. ${size} pro Datei)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Dateien nach „${folder}“ hochladen',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => '${uploaded} von ${total} ${label} hochgeladen',
			'common.fileTree.uploadingFiles' => 'Dateien werden hochgeladen',
			'common.fileTree.validation.dotsOnly' => 'Dateiname darf nicht nur aus Punkten bestehen',
			'common.fileTree.validation.emptyName' => 'Dateiname darf nicht leer sein',
			'common.fileTree.validation.invalidChars' => 'Dateiname enthält ungültige Zeichen',
			'common.fileTree.validation.reserved' => 'Dateiname ist ein reservierter Name',
			'common.projectWizard.title' => 'Neues Projekt erstellen',
			'common.projectWizard.steps.type' => 'Typ',
			'common.projectWizard.steps.configure' => 'Konfigurieren',
			'common.projectWizard.steps.confirm' => 'Bestätigen',
			'common.projectWizard.step1.question' => 'Hast du bereits einen Arbeitsbereich, oder möchtest du einen neuen erstellen?',
			'common.projectWizard.step1.existing.title' => 'Vorhandener Arbeitsbereich',
			'common.projectWizard.step1.existing.description' => 'Ich habe bereits einen Arbeitsbereich auf meinem Server und möchte ihn nur zur Projektliste hinzufügen',
			'common.projectWizard.step1.kNew.title' => 'Neuer Arbeitsbereich',
			'common.projectWizard.step1.kNew.description' => 'Einen neuen Arbeitsbereich erstellen, optional aus einem GitHub-Repository klonen',
			'common.projectWizard.step2.existingPath' => 'Arbeitsbereichspfad',
			'common.projectWizard.step2.newPath' => 'Arbeitsbereichspfad',
			'common.projectWizard.step2.existingPlaceholder' => '/Pfad/zum/vorhandenen/Arbeitsbereich',
			'common.projectWizard.step2.newPlaceholder' => '/Pfad/zum/neuen/Arbeitsbereich',
			'common.projectWizard.step2.existingHelp' => 'Vollständiger Pfad zu deinem vorhandenen Arbeitsbereichsverzeichnis',
			'common.projectWizard.step2.newHelp' => 'Vollständiger Pfad zu deinem Arbeitsbereichsverzeichnis',
			'common.projectWizard.step2.githubUrl' => 'GitHub-URL (Optional)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/benutzername/repository',
			'common.projectWizard.step2.githubHelp' => 'Optional: GitHub-URL angeben, um ein Repository zu klonen',
			'common.projectWizard.step2.githubAuth' => 'GitHub-Authentifizierung (Optional)',
			'common.projectWizard.step2.githubAuthHelp' => 'Nur für private Repositories erforderlich. Öffentliche Repos können ohne Authentifizierung geklont werden.',
			'common.projectWizard.step2.loadingTokens' => 'Gespeicherte Token werden geladen...',
			'common.projectWizard.step2.storedToken' => 'Gespeicherter Token',
			'common.projectWizard.step2.newToken' => 'Neuer Token',
			'common.projectWizard.step2.nonePublic' => 'Keiner (Öffentlich)',
			'common.projectWizard.step2.selectToken' => 'Token auswählen',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Token auswählen --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Dieser Token wird nur für diesen Vorgang verwendet',
			'common.projectWizard.step2.publicRepoInfo' => 'Öffentliche Repositories benötigen keine Authentifizierung. Du kannst das Token beim Klonen eines öffentlichen Repos weglassen.',
			'common.projectWizard.step2.noTokensHelp' => 'Keine gespeicherten Token verfügbar. Du kannst Token unter Einstellungen → API-Schlüssel für einfachere Wiederverwendung hinzufügen.',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHub-Token (Optional für öffentliche Repos)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (leer lassen für öffentliche Repos)',
			'common.projectWizard.step3.reviewConfig' => 'Konfiguration überprüfen',
			'common.projectWizard.step3.existingWorkspace' => 'Vorhandener Arbeitsbereich',
			'common.projectWizard.step3.newWorkspace' => 'Neuer Arbeitsbereich',
			'common.projectWizard.step3.path' => 'Pfad:',
			'common.projectWizard.step3.cloneFrom' => 'Klonen von:',
			'common.projectWizard.step3.authentication' => 'Authentifizierung:',
			'common.projectWizard.step3.usingStoredToken' => 'Gespeicherter Token wird verwendet:',
			'common.projectWizard.step3.usingProvidedToken' => 'Angegebener Token wird verwendet',
			'common.projectWizard.step3.noAuthentication' => 'Keine Authentifizierung',
			'common.projectWizard.step3.sshKey' => 'SSH-Schlüssel',
			'common.projectWizard.step3.existingInfo' => 'Der Arbeitsbereich wird zur Projektliste hinzugefügt und steht für Claude/Cursor-Sitzungen zur Verfügung.',
			'common.projectWizard.step3.newWithClone' => 'Das Repository wird aus diesem Ordner geklont.',
			'common.projectWizard.step3.newEmpty' => 'Der Arbeitsbereich wird zur Projektliste hinzugefügt und steht für Claude/Cursor-Sitzungen zur Verfügung.',
			'common.projectWizard.step3.cloningRepository' => 'Repository wird geklont...',
			'common.projectWizard.buttons.cancel' => 'Abbrechen',
			'common.projectWizard.buttons.back' => 'Zurück',
			'common.projectWizard.buttons.next' => 'Weiter',
			'common.projectWizard.buttons.createProject' => 'Projekt erstellen',
			'common.projectWizard.buttons.creating' => 'Wird erstellt...',
			'common.projectWizard.buttons.cloning' => 'Wird geklont...',
			'common.projectWizard.errors.selectType' => 'Bitte wähl aus, ob du einen vorhandenen Arbeitsbereich hast oder einen neuen erstellen möchtest',
			'common.projectWizard.errors.providePath' => 'Bitte gib einen Arbeitsbereichspfad an',
			'common.projectWizard.errors.failedToCreate' => 'Arbeitsbereich konnte nicht erstellt werden',
			'common.projectWizard.errors.failedToCreateFolder' => 'Ordner konnte nicht erstellt werden',
			'common.versionUpdate.title' => 'Update verfügbar',
			'common.versionUpdate.newVersionReady' => 'Eine neue Version ist verfügbar',
			'common.versionUpdate.currentVersion' => 'Aktuelle Version',
			'common.versionUpdate.latestVersion' => 'Neueste Version',
			'common.versionUpdate.whatsNew' => 'Neuigkeiten:',
			'common.versionUpdate.viewFullRelease' => 'Vollständige Version anzeigen',
			'common.versionUpdate.updateProgress' => 'Update-Fortschritt:',
			'common.versionUpdate.manualUpgrade' => 'Manuelles Upgrade:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Oder klick auf "Jetzt aktualisieren", um das Update automatisch durchzuführen.',
			'common.versionUpdate.updateCompleted' => 'Update erfolgreich abgeschlossen!',
			'common.versionUpdate.restartServer' => 'Bitte starte den Server neu, um die Änderungen anzuwenden.',
			'common.versionUpdate.updateFailed' => 'Update fehlgeschlagen',
			'common.versionUpdate.buttons.close' => 'Schließen',
			'common.versionUpdate.buttons.later' => 'Später',
			'common.versionUpdate.buttons.copyCommand' => 'Befehl kopieren',
			'common.versionUpdate.buttons.updateNow' => 'Jetzt aktualisieren',
			'common.versionUpdate.buttons.updating' => 'Wird aktualisiert...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Versions-Update-Modal schließen',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Seitenleiste anzeigen',
			'common.versionUpdate.ariaLabels.settings' => 'Einstellungen',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Update verfügbar',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Seitenleiste schließen',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => 'Übersicht',
			'common.quota.section.quotas' => 'Quotas',
			'common.quota.section.usage' => 'Nutzung',
			'common.quota.section.agents' => 'Agents',
			'common.quota.filter.all' => 'Alle',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 Tage',
			'common.quota.period.k30d' => '30 Tage',
			'common.quota.period.all' => 'Alle',
			'common.quota.group.provider' => 'Anbieter',
			'common.quota.group.model' => 'Modell',
			'common.quota.group.agent' => 'Agent',
			'common.quota.group.tool' => 'Werkzeug',
			'common.quota.metric.tokens' => 'Tokens',
			'common.quota.metric.input' => 'Eingabe',
			'common.quota.metric.output' => 'Ausgabe',
			'common.quota.metric.cache' => 'Cache-Lesungen',
			'common.quota.metric.calls' => 'API-Aufrufe',
			'common.quota.metric.cost' => 'Kosten',
			'common.quota.metric.sessions' => 'Sitzungen',
			'common.quota.cost.billed' => 'Abgerechnet (API + Mehrverbrauch)',
			'common.quota.cost.listPrice' => 'Listenpreis der verwendeten Tokens',
			'common.quota.cost.subscriptionValue' => 'Durch Abonnements abgedeckt',
			'common.quota.cost.cacheSavings' => 'Cache-Einsparungen',
			'common.quota.cost3.billed' => 'Abgerechnet (API + Mehrverbrauch)',
			'common.quota.cost3.listPrice' => 'Listenpreis der verwendeten Tokens',
			'common.quota.cost3.subscriptionValue' => 'Durch Abonnements abgedeckt',
			'common.quota.overview.trendTitle' => 'Tokens und Kosten — letzte 7 Tage',
			'common.quota.overview.effectiveCost' => 'Effektive Kosten (7 Tage)',
			'common.quota.overview.alertsTitle' => 'Warnungen',
			'common.quota.overview.noAlerts' => 'Derzeit erfordert nichts Aufmerksamkeit.',
			'common.quota.overview.limitsTitle' => 'Nutzung und Limits',
			'common.quota.overview.activeTasks' => 'Aktive Aufgaben',
			'common.quota.overview.viewAccounts' => 'Alle Konten',
			'common.quota.overview.viewAgents' => 'Alle Agents',
			'common.quota.overview.noTasks' => 'Derzeit laufen keine Agents.',
			'common.quota.usage.trendTitle' => 'Täglicher Trend',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Aufschlüsselung nach ${group}',
			'common.quota.usage.colName' => 'Name',
			'common.quota.usage.sourceUnavailable' => 'Analysespeicher nicht verfügbar; keine Daten.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} laufend',
			'common.quota.agents.colAgent' => 'Agent',
			'common.quota.agents.colStatus' => 'Status',
			'common.quota.agents.colTask' => 'Aufgabe',
			'common.quota.agents.colModel' => 'Konto / Modell',
			'common.quota.agents.colTime' => 'Zeit',
			'common.quota.agents.empty' => 'Keine Agents entsprechen diesem Filter.',
			'common.quota.agents.detailSession' => 'Sitzung',
			'common.quota.agents.detailStarted' => 'Gestartet',
			'common.quota.agents.detailRetries' => 'Wiederholungen',
			'common.quota.agents.detailResult' => 'Ergebnis',
			'common.quota.agents.notTracked' => 'nicht erfasst',
			'common.quota.agentStatus.running' => 'Läuft',
			'common.quota.agentStatus.waiting' => 'Wartet',
			'common.quota.agentStatus.failed' => 'Fehlgeschlagen',
			'common.quota.agentStatus.finished' => 'Abgeschlossen',
			'common.quota.agentStatus.queued' => 'In Warteschlange',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: beim aktuellen Tempo ist das Limit in ${value} erreicht',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% verbraucht (Schwelle ${watch}%)',
			'common.quota.backToChat' => 'Zurück zum Chat',
			'common.quota.syncNow' => 'Jetzt synchronisieren',
			'common.quota.generatedAt' => ({required Object value}) => 'Aktualisiert ${value}',
			'common.quota.loading' => 'Kontolimits werden geladen…',
			'common.quota.remaining' => ({required Object value}) => '${value}% übrig',
			'common.quota.resetsIn' => ({required Object value}) => 'Reset in ${value}',
			'common.quota.projected' => ({required Object value}) => 'beim aktuellen Tempo ist dieses Limit in ${value} erreicht',
			'common.quota.syncedAgo' => ({required Object value}) => 'vor ${value} synchronisiert',
			'common.quota.refreshAccount' => 'Konto aktualisieren',
			'common.quota.syncFailed' => 'Synchronisierung fehlgeschlagen',
			'common.quota.history' => 'Verlauf',
			'common.quota.historyPoints' => ({required Object value}) => '${value} Messwerte aufgezeichnet',
			'common.quota.historyEmpty' => 'Noch kein Verlauf aufgezeichnet',
			'common.quota.noAgents' => 'Keine Agents zugewiesen',
			'common.quota.noSubscription' => 'Kein Abonnement',
			'common.quota.noSubscriptionHint' => 'Der Anbieter meldet keinen aktiven Plan für dieses Konto.',
			'common.quota.quality.live' => 'Live',
			'common.quota.quality.cached' => 'Zwischengespeichert',
			'common.quota.quality.estimate' => 'Schätzung',
			'common.quota.quality.unknown' => 'Unbekannt',
			'common.quota.quality.error' => 'Fehler',
			'common.quota.kpi.atRisk' => 'Gefährdete Limits',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'Konten über ${value}%',
			'common.quota.kpi.windowsAtRisk' => 'Fenster laufen ab',
			'common.quota.kpi.errored' => 'Sync-Fehler',
			'common.quota.kpi.activeAgents' => 'Aktive Agents',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} wartend · ${queued} in Warteschlange',
			'common.quota.kpi.nextReset' => 'Nächster Reset',
			'common.quota.kpi.tokens' => 'Tokens',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} Sitzungen',
			'common.quota.kpi.cost' => 'Geschätzte Kosten',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} durch Abos abgedeckt',
			'common.quota.empty.title' => 'Keine Konten verbunden',
			'common.quota.empty.description' => 'Melde dich bei Claude, Codex, Gemini oder CommandCode an, damit Quotas hier verfolgt werden können.',
			'common.quota.settings.title' => 'Warnungen und Routing',
			'common.quota.settings.description' => 'Steuere, wann das Dashboard warnt und wie Konten für neue Arbeit vorgeschlagen werden.',
			'common.quota.settings.alertsEnabled' => 'Prognose- und Schwellenwarnungen',
			'common.quota.settings.alertsEnabledHint' => 'Warnen, bevor ein Limit beim aktuellen Tempo erreicht ist, nicht erst bei 90%.',
			'common.quota.settings.watchThreshold' => 'Beobachtungsschwelle (%)',
			'common.quota.settings.dangerThreshold' => 'Gefahrenschwelle (%)',
			'common.quota.settings.routingMode' => 'Routing',
			'common.quota.settings.routing.manual' => 'Manuell — nur Empfehlung',
			'common.quota.settings.routing.ask' => 'Vor Kontowechsel fragen',
			'common.quota.settings.routing.autoLowRisk' => 'Auto-Wechsel für risikoarme Aufgaben',
			'common.quota.settings.logSources' => 'Protokollquellen',
			'common.quota.settings.logSourcesHint' => 'Nutzungs- und Agent-Ansichten lesen diese schreibgeschützten Quellen.',
			'common.quota.settings.quotaConsent' => 'Quota-Abfrage erlauben',
			'common.quota.settings.quotaConsentHint' => 'Anbieter-Endpunkte mit deinen gespeicherten Zugangsdaten abfragen, um Live-Limits zu lesen.',
			'common.quota.settings.perAccount' => 'Kontospezifische Überschreibungen',
			'common.quota.settings.tab' => 'Control-Center-Einstellungen',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Alle',
			'common.notifications.genericTool' => 'ein Werkzeug',
			'common.notifications.codes.generic.info.title' => 'Benachrichtigung',
			'common.notifications.codes.permission.required.title' => 'Aktion erforderlich',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} wartet auf deine Entscheidung.',
			'common.notifications.codes.run.stopped.title' => 'Lauf gestoppt',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Grund: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Lauf fehlgeschlagen',
			'common.notifications.codes.agent.notification.title' => 'Agent-Benachrichtigung',
			'common.actions.cancel' => 'Abbrechen',
			'common.actions.retry' => 'Erneut versuchen',
			'common.actions.save' => 'Speichern',
			'common.browserPane.address' => 'Adresse',
			'common.browserPane.back' => 'Zurück',
			'common.browserPane.connecting' => 'Verbinde mit Browser…',
			'common.browserPane.connectionFailed' => 'Browser-Verbindung fehlgeschlagen.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => '${url} konnte nicht geladen werden',
			'common.browserPane.disconnected' => 'Browser-Ansicht getrennt',
			'common.browserPane.enterUrl' => 'URL eingeben',
			'common.browserPane.forward' => 'Vorwärts',
			'common.browserPane.invalidUrl' => 'Gültige http(s)-URL eingeben',
			'common.browserPane.noAuthToken' => 'Kein Authentifizierungstoken verfügbar.',
			'common.browserPane.openExternal' => 'Im Systembrowser öffnen',
			'common.browserPane.reload' => 'Neu laden',
			'common.browserPane.retry' => 'Wiederholen',
			'common.browserPane.stop' => 'Stopp',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} aktiv',
			'common.browserUse.cancel' => 'Abbrechen',
			'common.browserUse.close' => 'Schließen',
			'common.browserUse.delete' => 'Löschen',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} wird endgültig gelöscht.',
			'common.browserUse.deleteSession' => 'Sitzung löschen',
			'common.browserUse.deleteTitle' => 'Browser-Sitzung löschen?',
			'common.browserUse.empty.descDisabled' => 'Aktiviere Browser in den Einstellungen, damit Agenten überwachte Browser-Sitzungen öffnen können.',
			'common.browserUse.empty.descEnabled' => 'Agenten-Browser-Sitzungen erscheinen hier, während eine KI-Aufgabe Browser verwendet.',
			'common.browserUse.empty.titleDisabled' => 'Browser ist deaktiviert',
			'common.browserUse.empty.titleEnabled' => 'Noch keine Browser-Sitzungen',
			'common.browserUse.emptyStatus' => 'leer',
			'common.browserUse.errors.actionFailed' => 'Browser-Aktion fehlgeschlagen',
			'common.browserUse.errors.loadFailed' => 'Browser konnte nicht geladen werden',
			'common.browserUse.fullscreen' => 'Vollbild',
			'common.browserUse.installRuntime' => 'Runtime installieren',
			'common.browserUse.installing' => 'Installiere...',
			'common.browserUse.lastAction' => 'Letzte Aktion',
			'common.browserUse.nextSnapshot' => 'Der nächste Browser-Snapshot des Agenten wird hier angezeigt.',
			'common.browserUse.noPageLoaded' => 'Keine Seite geladen',
			'common.browserUse.noSessions' => 'Keine Agenten-Browser-Sitzungen.',
			'common.browserUse.none' => 'Keine',
			'common.browserUse.openSettings' => 'Browser-Einstellungen öffnen',
			'common.browserUse.profile' => 'Profil',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Verwende Browser, um den Checkout-Ablauf zu prüfen und defekte UI-Zustände zu melden.',
			'common.browserUse.prompts.prompt2' => 'Öffne <url> mit Browser, interagiere mit der Seite und fasse zusammen, was sich nach jedem Schritt geändert hat.',
			'common.browserUse.refresh' => 'Browser-Sitzungen aktualisieren',
			'common.browserUse.relative.daysAgo' => 'T zuvor',
			'common.browserUse.relative.hoursAgo' => 'Std. zuvor',
			'common.browserUse.relative.justNow' => 'Gerade eben',
			'common.browserUse.relative.minutesAgo' => 'Min. zuvor',
			'common.browserUse.relative.never' => 'Nie',
			'common.browserUse.relative.secondsAgo' => 'Sek. zuvor',
			'common.browserUse.relative.unknown' => 'Unbekannt',
			'common.browserUse.runtime.disabled' => 'Deaktiviert',
			'common.browserUse.runtime.installing' => 'Installiere',
			'common.browserUse.runtime.ready' => 'Bereit',
			'common.browserUse.runtime.setupRequired' => 'Einrichtung erforderlich',
			'common.browserUse.runtimeSetup' => 'Runtime-Einrichtung erforderlich',
			'common.browserUse.selected' => 'Ausgewählt',
			'common.browserUse.sessionFallback' => 'Browser-Sitzung',
			'common.browserUse.sessionScreenshot' => 'Screenshot der Browser-Sitzung',
			'common.browserUse.sessions' => 'Sitzungen',
			'common.browserUse.status' => 'Status',
			'common.browserUse.stop' => 'Stopp',
			'common.browserUse.stopSession' => 'Sitzung stoppen',
			'common.browserUse.subtitle' => 'Überwache Browser-Sitzungen, die von KI-Agenten geöffnet wurden.',
			'common.browserUse.temporary' => 'Temporär',
			'common.browserUse.thisSession' => 'Diese Sitzung',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '${count} gesamt',
			'common.browserUse.updated' => ({required Object time}) => 'Aktualisiert ${time}',
			'common.browserUse.waiting' => 'Warten',
			'common.browserUse.waitingForScreenshot' => 'Warte auf Screenshot',
			'common.commandPalette.backToAll' => 'Zurück zu allen',
			'common.commandPalette.backspaceHint' => 'Rücktaste zum Zurückgehen',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Alle Branches durchsuchen (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Alle Commits durchsuchen (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Alle Dateien durchsuchen (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Alle Sitzungen durchsuchen (${count})',
			'common.commandPalette.compare.costNote' => 'Die Kosten sind eine clientseitige Schätzung aus veröffentlichten Token-Preisen; unbekannte Modelle zeigen „—“.',
			'common.commandPalette.compare.estCost' => 'Gesch. Kosten',
			'common.commandPalette.compare.inputOutput' => 'Eingabe / Ausgabe',
			'common.commandPalette.compare.model' => 'Modell',
			'common.commandPalette.compare.na' => 'k. A.',
			'common.commandPalette.compare.openSplit' => 'In geteilter Ansicht öffnen',
			'common.commandPalette.compare.provider' => 'Anbieter',
			'common.commandPalette.compare.selectSession' => 'Sitzung auswählen…',
			'common.commandPalette.compare.tokensUsed' => 'Verwendete Tokens',
			'common.commandPalette.groups.actions' => 'Aktionen',
			'common.commandPalette.groups.branches' => 'Branches',
			'common.commandPalette.groups.commits' => 'Commits',
			'common.commandPalette.groups.files' => 'Dateien',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Navigieren',
			'common.commandPalette.groups.sessions' => 'Sitzungen',
			'common.commandPalette.groups.settings' => 'Einstellungen',
			'common.commandPalette.hints.close' => 'Schließen',
			'common.commandPalette.hints.navigate' => 'Navigieren',
			'common.commandPalette.hints.select' => 'Auswählen',
			'common.commandPalette.hints.togglePalette' => 'Palette umschalten',
			'common.commandPalette.items.compareSessions' => 'Sitzungen vergleichen',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Einstellungen öffnen',
			'common.commandPalette.items.selectProjectFirst' => 'Zuerst ein Projekt auswählen',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Einstellungen: ${label}',
			'common.commandPalette.items.startNewChat' => 'Neuen Chat starten',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Wechseln zu: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Theme umschalten',
			'common.commandPalette.items.tokensAndCost' => 'Tokens & Kosten',
			'common.commandPalette.nav.board' => 'Zum Agent Board',
			'common.commandPalette.nav.chat' => 'Zum Chat',
			'common.commandPalette.nav.files' => 'Zu Dateien',
			'common.commandPalette.nav.git' => 'Zu Git',
			'common.commandPalette.nav.sourceControl' => 'Zur Quellcodeverwaltung',
			'common.commandPalette.nav.tasks' => 'Zu Aufgaben',
			'common.commandPalette.nav.usage' => 'Zu Quota & Nutzung',
			'common.commandPalette.noResults' => 'Keine Ergebnisse.',
			'common.commandPalette.pages.actions' => 'Aktionen',
			'common.commandPalette.pages.branches' => 'Branches',
			'common.commandPalette.pages.commits' => 'Commits',
			'common.commandPalette.pages.compare' => 'Vergleichen',
			'common.commandPalette.pages.files' => 'Dateien',
			'common.commandPalette.pages.sessions' => 'Sitzungen',
			'common.commandPalette.placeholder' => 'Zum Suchen tippen…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => '${page} durchsuchen…',
			'common.commandPalette.title' => 'Befehlspalette',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} voraus',
			'common.gitPanel.aheadLabel' => 'voraus',
			'common.gitPanel.aiSuggest' => 'KI-Vorschlag',
			'common.gitPanel.aiSuggestTitle' => 'Commit-Nachricht mit KI generieren',
			'common.gitPanel.all' => 'Alle',
			'common.gitPanel.allStaged' => 'Alle Änderungen staged',
			'common.gitPanel.behind' => ({required Object count}) => '${count} zurück',
			'common.gitPanel.behindLabel' => 'zurück',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'Branch „${branch}“ löschen? Ein normales Löschen gelingt nur, wenn der Branch vollständig gemergt ist. Dies kann nicht rückgängig gemacht werden.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'Zu Branch „${branch}“ wechseln? Stelle sicher, dass du keine nicht committeten Änderungen hast.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} lokal, ${remote} remote',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} lokal',
			'common.gitPanel.branches.current' => 'aktuell',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => '${branch} löschen',
			'common.gitPanel.branches.emptyDesc' => 'Erstelle einen Branch, um parallel zu arbeiten.',
			'common.gitPanel.branches.forceDelete' => 'Löschen erzwingen',
			'common.gitPanel.branches.forceDeleteDesc' => 'Entfernt den Branch endgültig, auch wenn er Commits enthält, die nirgendwo gemergt wurden.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Diesen nicht gemergten Branch endgültig löschen',
			'common.gitPanel.branches.local' => 'Lokal',
			'common.gitPanel.branches.kNew' => 'Neuer Branch',
			'common.gitPanel.branches.noMatch' => 'Keine Branches entsprechen der Suche',
			'common.gitPanel.branches.none' => 'Keine Branches gefunden',
			'common.gitPanel.branches.remote' => 'Remote',
			'common.gitPanel.branches.kSwitch' => 'Wechseln',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Wechseln zu ${branch}',
			'common.gitPanel.cancel' => 'Abbrechen',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Änderungen (${count})',
			'common.gitPanel.clearSearch' => 'Suche löschen',
			'common.gitPanel.collapseDiff' => 'Diff einklappen',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Änderungen committen',
			'common.gitPanel.commitFiles' => ({required Object count}) => '${count} Datei(en) committen',
			'common.gitPanel.committing' => 'Committe...',
			'common.gitPanel.confirmActions.commit' => 'Bestätigen',
			'common.gitPanel.confirmActions.delete' => 'Löschen',
			'common.gitPanel.confirmActions.deleteBranch' => 'Löschen',
			'common.gitPanel.confirmActions.discard' => 'Verwerfen',
			'common.gitPanel.confirmActions.publish' => 'Veröffentlichen',
			'common.gitPanel.confirmActions.pull' => 'Pull',
			'common.gitPanel.confirmActions.push' => 'Push',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Commit zurücksetzen',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => '${count} Datei(en) mit Nachricht committen: „${message}“?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'Untracked Datei „${file}“ löschen? Dies kann nicht rückgängig gemacht werden.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => 'Alle Änderungen an „${file}“ verwerfen? Dies kann nicht rückgängig gemacht werden.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'Branch „${branch}“ nach ${remote} veröffentlichen?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => '${count} Commit(s) von ${remote} pullen?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => '${count} Commit(s) nach ${remote} pushen?',
			'common.gitPanel.confirmRevert' => 'Letzten lokalen Commit zurücksetzen? Entfernt den Commit, behält aber seine Änderungen staged.',
			'common.gitPanel.confirmTitles.commit' => 'Aktion bestätigen',
			'common.gitPanel.confirmTitles.delete' => 'Datei löschen',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Branch löschen',
			'common.gitPanel.confirmTitles.discard' => 'Änderungen verwerfen',
			'common.gitPanel.confirmTitles.publish' => 'Branch veröffentlichen',
			'common.gitPanel.confirmTitles.pull' => 'Pull bestätigen',
			'common.gitPanel.confirmTitles.push' => 'Push bestätigen',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Lokalen Commit zurücksetzen',
			'common.gitPanel.createBranch' => 'Neuen Branch erstellen',
			'common.gitPanel.creating' => 'Erstelle...',
			'common.gitPanel.delete' => 'Löschen',
			'common.gitPanel.deleteUntracked' => 'Untracked Datei löschen',
			'common.gitPanel.deselectAll' => 'Alle abwählen',
			'common.gitPanel.discard' => 'Verwerfen',
			'common.gitPanel.discardChanges' => 'Änderungen verwerfen',
			'common.gitPanel.dismiss' => 'Schließen',
			'common.gitPanel.dismissError' => 'Fehler schließen',
			'common.gitPanel.errors.createBranchFailed' => 'Branch-Erstellung fehlgeschlagen',
			'common.gitPanel.errors.createWorktreeFailed' => 'Worktree konnte nicht erstellt werden',
			'common.gitPanel.errors.deleteBranchFailed' => 'Branch-Löschung fehlgeschlagen',
			'common.gitPanel.errors.fetchFailed' => 'Fetch fehlgeschlagen',
			'common.gitPanel.errors.initFailed' => 'Repository konnte nicht initialisiert werden',
			'common.gitPanel.errors.initialCommitFailed' => 'Erster Commit konnte nicht erstellt werden',
			'common.gitPanel.errors.mergeFailed' => 'Merge fehlgeschlagen',
			'common.gitPanel.errors.openWorktreeFailed' => 'Worktree konnte nicht geöffnet werden',
			'common.gitPanel.errors.operationFailed' => 'Git-Operation fehlgeschlagen',
			'common.gitPanel.errors.publishFailed' => 'Veröffentlichung fehlgeschlagen',
			'common.gitPanel.errors.pullFailed' => 'Pull fehlgeschlagen',
			'common.gitPanel.errors.pushFailed' => 'Push fehlgeschlagen',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Worktree konnte nicht entfernt werden',
			'common.gitPanel.errors.stageFailed' => 'Stagen fehlgeschlagen',
			'common.gitPanel.errors.stageHunksFailed' => 'Hunks stagen fehlgeschlagen',
			'common.gitPanel.errors.switchFailed' => 'Branch-Wechsel fehlgeschlagen',
			'common.gitPanel.errors.unstageFailed' => 'Unstagen fehlgeschlagen',
			'common.gitPanel.errors.unstageHunksFailed' => 'Hunks unstagen fehlgeschlagen',
			'common.gitPanel.expandDiff' => 'Diff ausklappen',
			'common.gitPanel.fetch' => 'Fetch',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Von ${remote} fetchen',
			'common.gitPanel.fetching' => 'Fetche…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} Datei(en) ausgewählt',
			'common.gitPanel.generating' => 'Generiere...',
			'common.gitPanel.history.added' => 'Hinzugefügt',
			'common.gitPanel.history.author' => 'Autor',
			'common.gitPanel.history.changedFiles' => 'Geänderte Dateien',
			'common.gitPanel.history.date' => 'Datum',
			'common.gitPanel.history.empty' => 'Keine Commits gefunden',
			'common.gitPanel.history.files' => 'Dateien',
			'common.gitPanel.history.removed' => 'Entfernt',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Worktree entfernen und seinen Branch nach dem Merge löschen',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Nach dem Merge aufräumen',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} Commit(s)',
			'common.gitPanel.mergeWorktree.merge' => 'Mergen',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Branch \'${branch}\' mergen',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Commit-Nachricht',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Alle ${commits} zu einem einzigen Commit auf ${branch} zusammenfassen',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Commits squashen',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squashen & mergen',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Branch \'${branch}\' squash-mergen',
			'common.gitPanel.mergeWorktree.title' => 'Worktree mergen',
			'common.gitPanel.merging' => 'Merge…',
			'common.gitPanel.messagePlaceholder' => 'Nachricht (Strg+Enter zum Committen)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Erstellt einen neuen Branch vom aktuellen Branch (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Branch-Name',
			'common.gitPanel.newBranch.submit' => 'Branch erstellen',
			'common.gitPanel.newBranch.title' => 'Neuen Branch erstellen',
			'common.gitPanel.newWorktree.branchLabel' => 'Branch',
			'common.gitPanel.newWorktree.createFrom' => 'Erstellen aus',
			'common.gitPanel.newWorktree.description' => 'Checke einen Branch in einem eigenen Ordner aus und arbeite parallel daran.',
			'common.gitPanel.newWorktree.existingBranch' => 'Bestehender Branch — wird unverändert ausgecheckt.',
			'common.gitPanel.newWorktree.submit' => 'Worktree erstellen',
			'common.gitPanel.newWorktree.switchAfter' => 'Nach dem Erstellen zum Worktree wechseln',
			'common.gitPanel.newWorktree.title' => 'Neuer Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Wird erstellt in',
			'common.gitPanel.noChanges' => 'Keine Änderungen erkannt',
			'common.gitPanel.noChangesToCommit' => 'Keine Änderungen zum Committen',
			'common.gitPanel.noCommits.create' => 'Ersten Commit erstellen',
			'common.gitPanel.noCommits.creating' => 'Erstelle ersten Commit...',
			'common.gitPanel.noCommits.description' => 'Dieses Repository hat noch keine Commits. Erstelle deinen ersten Commit, um Änderungen zu verfolgen.',
			'common.gitPanel.noCommits.title' => 'Noch keine Commits',
			'common.gitPanel.noMatchingBranches' => 'Keine passenden Branches',
			'common.gitPanel.noRepo.description' => 'Dieses Projekt ist noch kein Git-Repository. Initialisiere eines, um Änderungen zu verfolgen und Quellcodeverwaltung zu nutzen.',
			'common.gitPanel.noRepo.init' => 'git init ausführen',
			'common.gitPanel.noRepo.initializing' => 'Initialisiere Repository...',
			'common.gitPanel.noRepo.title' => 'Kein Git-Repository',
			'common.gitPanel.noStagedFiles' => 'Keine staged Dateien',
			'common.gitPanel.none' => 'Keine',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Nichts nach ${remote} zu pushen',
			'common.gitPanel.openFile' => 'Klicken, um Datei zu öffnen',
			'common.gitPanel.publish' => 'Veröffentlichen',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => '„${branch}“ nach ${remote} veröffentlichen',
			'common.gitPanel.publishing' => 'Veröffentliche…',
			'common.gitPanel.pull' => 'Pull',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Pull ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => '${count} von ${remote} pullen',
			'common.gitPanel.pulling' => 'Pulle…',
			'common.gitPanel.push' => 'Push',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Push ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => '${count} nach ${remote} pushen',
			'common.gitPanel.pushing' => 'Pushe…',
			'common.gitPanel.recentCommits' => 'Letzte Commits',
			'common.gitPanel.refresh' => 'Git-Status aktualisieren',
			'common.gitPanel.remove' => 'Entfernen',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Branch ebenfalls löschen',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => 'Worktree für ${branch} entfernen? Sein Ordner wird gelöscht und das verknüpfte Projekt archiviert — Chat-Sitzungen bleiben wiederherstellbar.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'Dieser Worktree hat ${count} nicht committete Änderung(en), die verloren gehen.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Nicht committete Änderungen verwerfen',
			'common.gitPanel.removeWorktree.title' => 'Worktree entfernen',
			'common.gitPanel.removing' => 'Entferne...',
			'common.gitPanel.revertLatest' => 'Letzten lokalen Commit zurücksetzen',
			'common.gitPanel.scroll' => 'Scrollen',
			'common.gitPanel.searchBranches' => 'Branches suchen...',
			'common.gitPanel.selectAll' => 'Alle auswählen',
			'common.gitPanel.selectProject' => 'Projekt auswählen, um die Quellcodeverwaltung zu sehen',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => '${selected} von ${total} Dateien ausgewählt',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => '${selected} von ${total} ausgewählt',
			'common.gitPanel.sideBySide' => 'Ne-beneinander',
			'common.gitPanel.stageAll' => 'Alle stagen',
			'common.gitPanel.stageHunk' => 'Diesen Hunk stagen',
			'common.gitPanel.staged' => ({required Object count}) => 'Vorgemerkt (${count})',
			'common.gitPanel.status.added' => 'Hinzugefügt',
			'common.gitPanel.status.deleted' => 'Gelöscht',
			'common.gitPanel.status.modified' => 'Geändert',
			'common.gitPanel.status.untracked' => 'Nicht verfolgt',
			'common.gitPanel.statusGuide' => 'Datei-Status-Legende',
			'common.gitPanel.switchScroll' => 'Zu horizontalem Scrollen wechseln',
			'common.gitPanel.switchSplit' => 'Zur Nebeneinander-Ansicht wechseln',
			'common.gitPanel.switchUnified' => 'Zur einheitlichen Ansicht wechseln',
			'common.gitPanel.switchWrap' => 'Zu Textumbruch wechseln',
			'common.gitPanel.unified' => 'Einheitlich',
			'common.gitPanel.unstageAll' => 'Alle unstagen',
			'common.gitPanel.unstageHunk' => 'Diesen Hunk unstagen',
			'common.gitPanel.upToDate' => 'Aktuell',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'Aktuell mit ${remote}',
			'common.gitPanel.viewAll' => 'Alle anzeigen',
			'common.gitPanel.viewsAria' => 'Ansichten der Quellcodeverwaltung',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} Änderung(en)',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} Worktree(s)',
			'common.gitPanel.worktrees.createFirst' => 'Erstelle deinen ersten Worktree',
			'common.gitPanel.worktrees.detached' => 'losgelöst',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'losgelöst @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'losgelöster HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'Ein Worktree checkt einen Branch in einem eigenen Ordner aus, sodass du separate Chat-Sitzungen parallel führen und die Ergebnisse mergen kannst, sobald sie fertig sind.',
			'common.gitPanel.worktrees.emptyTitle' => 'Arbeite parallel an Branches',
			'common.gitPanel.worktrees.locked' => 'gesperrt',
			'common.gitPanel.worktrees.mainWorktree' => 'Haupt-Worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => '${branch} in den Basis-Branch mergen',
			'common.gitPanel.worktrees.kNew' => 'Neuer Worktree',
			'common.gitPanel.worktrees.none' => 'Keine Worktrees',
			'common.gitPanel.worktrees.nothingToMerge' => 'Nichts zu mergen — keine Commits vor dem Basis-Branch',
			'common.gitPanel.worktrees.open' => 'Öffnen',
			'common.gitPanel.worktrees.refresh' => 'Worktrees aktualisieren',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Worktree für ${branch} entfernen',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Wechseln zu ${branch}',
			'common.gitPanel.wrap' => 'Umbruch',
			'common.gitPanel.tabs.changes' => 'Änderungen',
			'common.gitPanel.tabs.history' => 'Commits',
			'common.gitPanel.tabs.branches' => 'Branches',
			'common.gitPanel.tabs.worktrees' => 'Worktrees',
			'common.sessions.renameSession' => 'Sitzung umbenennen',
			'common.projects.newSession' => 'Neue Sitzung',
			'common.codeBlock.wrapLines' => 'Zeilen umbrechen',
			'common.codeBlock.noWrap' => 'Kein Umbruch',
			'common.update.available' => ({required Object version}) => 'Update verfügbar · v${version}',
			'common.update.confirm' => ({required Object version}) => 'Auf v${version} aktualisieren? Der Server aktualisiert sich selbst und startet neu — aktive Sitzungen werden unterbrochen.',
			'common.update.downloading' => 'Update wird heruntergeladen und angewendet…',
			'common.update.restarting' => 'Server wird neu gestartet — das dauert einen Moment…',
			'common.update.done' => ({required Object version}) => 'Auf v${version} aktualisiert. Lade die App neu, um das neue Bundle zu übernehmen.',
			'common.update.manualRestart' => 'Das Update wurde angewendet, aber der Server hat nicht von selbst neu gestartet — starte ihn manuell neu, um abzuschließen.',
			'common.update.failed' => 'Update fehlgeschlagen.',
			'common.update.failedTitle' => 'Update fehlgeschlagen',
			'common.update.appConfirm' => ({required Object version}) => 'ddagent v${version} auf diesem Gerät installieren? Android fragt beim ersten Mal, ob Installationen aus ddagent erlaubt sind.',
			'common.update.appPermission' => 'Erlaube ddagent „Unbekannte Apps installieren“ und tippe dann erneut auf Aktualisieren.',
			'common.update.chooseTitle' => 'Updates verfügbar',
			'common.update.targetApp' => 'Diese App',
			'common.update.targetWeb' => 'Weboberfläche',
			'common.update.targetServer' => 'Server',
			'common.update.updateApp' => 'App aktualisieren',
			'common.update.updateWeb' => 'Weboberfläche aktualisieren',
			'common.update.updateServer' => 'Server aktualisieren',
			'common.update.webConfirm' => ({required Object version}) => 'Weboberfläche auf v${version} aktualisieren? Die Seite wird danach neu geladen.',
			'common.update.webDone' => ({required Object version}) => 'Weboberfläche auf v${version} aktualisiert — wird neu geladen…',
			'common.update.localServerConfirm' => ({required Object version}) => 'Den lokalen Server auf diesem Gerät auf v${version} aktualisieren? Laufende Sitzungen werden unterbrochen.',
			'common.update.localServerUpdating' => 'Lokaler Server wird heruntergeladen und gestartet…',
			'common.update.serverDone' => ({required Object version}) => 'Der Server läuft mit v${version}.',
			'common.update.staged' => ({required Object version}) => 'Update v${version} heruntergeladen — starte den Server neu, um es zu installieren.',
			'common.update.upToDate' => 'Der Server ist bereits auf der neuesten Version.',
			'common.update.webHostFailed' => ({required Object message}) => 'Der Server wurde aktualisiert, seine Weboberfläche aber nicht: ${message}',
			'settings.title' => 'Einstellungen',
			'settings.changelog.title' => 'Änderungsprotokoll',
			'settings.changelog.loading' => 'Laden…',
			'settings.changelog.empty' => 'Keine Veröffentlichungen vorhanden',
			'settings.changelog.current' => 'aktuell',
			'settings.changelog.kNew' => 'neu',
			'settings.server.title' => 'Server',
			'settings.server.description' => 'Startet den ddagent-Prozess neu — nützlich nach Updates oder wenn etwas hängt.',
			'settings.server.restart' => 'Neu starten',
			'settings.server.restartConfirm' => 'ddagent-Server neu starten? Aktive Sitzungen werden unterbrochen.',
			'settings.server.restarting' => 'Neustart läuft… die Seite lädt neu, sobald der Server zurück ist.',
			'settings.server.restartFailed' => 'Neustart fehlgeschlagen',
			'settings.server.unsupported' => 'Neustart ist nur verfügbar, wenn der Server unter dem Dienst-Manager läuft.',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'Server wird neu gestartet',
			'settings.server.restartRequesting' => 'Server wird zum Neustart aufgefordert…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'Warte, bis der Server wieder da ist… (${seconds} s)',
			'settings.server.restartBack' => ({required Object version}) => 'Der Server läuft wieder — Version ${version}.',
			'settings.server.restartReloading' => 'Seite wird neu geladen…',
			'settings.server.restartTimeout' => ({required Object seconds}) => 'Der Server ist nicht innerhalb von ${seconds} s zurückgekehrt. Prüfe das Dienstprotokoll (/tmp/ddagent.log) oder starte ihn manuell neu.',
			'settings.updates.title' => 'App-Updates',
			'settings.updates.description' => 'Auf GitHub nach einer neueren Desktop-Version suchen. Neue Versionen werden automatisch heruntergeladen und beim Beenden installiert.',
			'settings.updates.check' => 'Nach Updates suchen',
			'settings.updates.checking' => 'Suche läuft…',
			'settings.updates.upToDate' => ({required Object version}) => 'Du hast die neueste Version (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Update v${version} gefunden — Download im Hintergrund; Installation beim Beenden von ddagent.',
			'settings.updates.downloaded' => ({required Object version}) => 'Update v${version} heruntergeladen — ddagent beenden und neu starten, um es zu installieren.',
			'settings.updates.unavailable' => 'Die Update-Prüfung ist nur in paketierten Desktop-Builds verfügbar.',
			'settings.updates.error' => ({required Object message}) => 'Update-Prüfung fehlgeschlagen: ${message}',
			'settings.updates.errorGeneric' => 'Update-Prüfung fehlgeschlagen.',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · neueste v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — aktuell',
			'settings.updates.webNotHosted' => ({required Object version}) => 'Diese Weboberfläche wird separat gehostet — ersetze ihre Dateien durch ddagent-flutter-web-v${version}.zip aus dem Release.',
			'settings.updates.serverCannotUpdate' => 'Dieser Server kann sich von hier aus nicht selbst aktualisieren — installiere ihn mit install.sh oder einem Release-Tarball neu.',
			'settings.tabs.account' => 'Konto',
			'settings.tabs.permissions' => 'Berechtigungen',
			'settings.tabs.mcpServers' => 'MCP-Server',
			'settings.tabs.appearance' => 'Darstellung',
			'settings.tabs.skills' => 'Skills',
			'settings.account.title' => 'Konto',
			'settings.account.language' => 'Sprache',
			'settings.account.languageLabel' => 'Anzeigesprache',
			'settings.account.languageDescription' => 'Wähl deine bevorzugte Sprache für die Oberfläche',
			'settings.account.username' => 'Benutzername',
			'settings.account.email' => 'E-Mail',
			'settings.account.profile' => 'Profil',
			'settings.account.changePassword' => 'Passwort ändern',
			'settings.mcp.title' => 'MCP-Server',
			'settings.mcp.addServer' => 'Server hinzufügen',
			'settings.mcp.editServer' => 'Server bearbeiten',
			'settings.mcp.deleteServer' => 'Server löschen',
			'settings.mcp.serverName' => 'Servername',
			'settings.mcp.serverType' => 'Servertyp',
			'settings.mcp.config' => 'Konfiguration',
			'settings.mcp.testConnection' => 'Verbindung testen',
			'settings.mcp.status' => 'Status',
			'settings.mcp.connected' => 'Verbunden',
			'settings.mcp.disconnected' => 'Getrennt',
			'settings.mcp.scope.label' => 'Geltungsbereich',
			'settings.mcp.scope.user' => 'Benutzer:in',
			'settings.mcp.scope.project' => 'Projekt',
			'settings.appearance.title' => 'Darstellung',
			'settings.appearance.theme' => 'Design',
			'settings.appearance.codeEditor' => 'Code-Editor',
			'settings.appearance.editorTheme' => 'Editor-Design',
			'settings.appearance.wordWrap' => 'Zeilenumbruch',
			'settings.appearance.showMinimap' => 'Minimap anzeigen',
			'settings.appearance.lineNumbers' => 'Zeilennummern',
			'settings.appearance.fontSize' => 'Schriftgröße',
			'settings.appearance.themeModes.dark' => 'Dunkel',
			'settings.appearance.themeModes.light' => 'Hell',
			'settings.appearance.themeModes.system' => 'System',
			'settings.actions.saveChanges' => 'Änderungen speichern',
			'settings.actions.resetToDefaults' => 'Auf Standardwerte zurücksetzen',
			'settings.actions.cancelChanges' => 'Änderungen abbrechen',
			'settings.quickSettings.title' => 'Schnelleinstellungen',
			'settings.quickSettings.sections.appearance' => 'Darstellung',
			'settings.quickSettings.sections.toolDisplay' => 'Werkzeuganzeige',
			'settings.quickSettings.sections.inputSettings' => 'Eingabeeinstellungen',
			'settings.quickSettings.darkMode' => 'Darkmode',
			'settings.quickSettings.showRawParameters' => 'Rohe Parameter anzeigen',
			'settings.quickSettings.showThinking' => 'Denken anzeigen',
			'settings.quickSettings.sendByCtrlEnter' => 'Mit Strg+Enter senden',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Wenn aktiviert, sendet Strg+Enter die Nachricht anstelle von Enter. Dies ist nützlich für IME-Benutzer:innen, um versehentliches Senden zu vermeiden.',
			'settings.quickSettings.dragHandle.dragging' => 'Handle wird gezogen',
			'settings.quickSettings.dragHandle.closePanel' => 'Einstellungspanel schließen',
			'settings.quickSettings.dragHandle.openPanel' => 'Einstellungspanel öffnen',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Wird gezogen...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Klicken zum Umschalten, ziehen zum Verschieben',
			'settings.quickSettings.sendWithCtrlEnter' => 'Mit Strg+Enter senden',
			'settings.terminalShortcuts.title' => 'Terminal-Tastenkürzel',
			'settings.terminalShortcuts.sectionKeys' => 'Tasten',
			'settings.terminalShortcuts.sectionNavigation' => 'Navigation',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Pfeil oben',
			'settings.terminalShortcuts.arrowDown' => 'Pfeil unten',
			'settings.terminalShortcuts.scrollDown' => 'Nach unten scrollen',
			'settings.terminalShortcuts.handle.closePanel' => 'Tastenkürzel-Panel schließen',
			'settings.terminalShortcuts.handle.openPanel' => 'Tastenkürzel-Panel öffnen',
			'settings.terminalShortcuts.killTitle' => 'Laufenden Prozess beenden (Ctrl+C)',
			'settings.terminalShortcuts.paste' => 'Einfügen',
			'settings.mainTabs.label' => 'Einstellungen',
			'settings.mainTabs.agents' => 'Agenten',
			'settings.mainTabs.orchestration' => 'Orchestrierung',
			'settings.mainTabs.appearance' => 'Darstellung',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API & Token',
			'settings.mainTabs.models' => 'Modelle',
			'settings.mainTabs.tasks' => 'Aufgaben',
			'settings.mainTabs.notifications' => 'Benachrichtigungen',
			'settings.mainTabs.about' => 'Info',
			'settings.mainTabs.workspaces' => 'Arbeitsbereiche',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Werkzeuge',
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
			'settings.orchestration.pool.fields.redundantAccounts' => 'Redundante Konten',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Keine weiteren Konten für diesen Anbieter',
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
			'settings.notifications.title' => 'Benachrichtigungen',
			'settings.notifications.description' => 'Lege fest, welche Benachrichtigungen du erhältst.',
			'settings.notifications.webPush.title' => 'Web-Push-Benachrichtigungen',
			'settings.notifications.webPush.enable' => 'Push-Benachrichtigungen aktivieren',
			'settings.notifications.webPush.disable' => 'Push-Benachrichtigungen deaktivieren',
			'settings.notifications.webPush.enabled' => 'Push-Benachrichtigungen sind aktiviert',
			'settings.notifications.webPush.loading' => 'Wird aktualisiert...',
			'settings.notifications.webPush.unsupported' => 'Push-Benachrichtigungen werden in diesem Browser nicht unterstützt.',
			'settings.notifications.webPush.denied' => 'Push-Benachrichtigungen sind blockiert. Bitte erlaube sie in den Browsereinstellungen.',
			'settings.notifications.webPush.iosHint' => 'Auf iPhone/iPad funktionieren Benachrichtigungen erst, nachdem ddagent zum Home-Bildschirm hinzugefügt wurde (Teilen → Zum Home-Bildschirm) und sie in der installierten App aktiviert wurden.',
			'settings.notifications.webPush.test' => 'Test-Benachrichtigung senden',
			'settings.notifications.webPush.testNoSubscription' => 'Kein Gerät ist angemeldet. Tippe zuerst auf dem Telefon auf „Aktivieren“.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'An ${count} Gerät(e) gesendet. Falls nichts auf dem Telefon erscheint, füge ddagent zum Home-Bildschirm hinzu (iOS erfordert dies).',
			'settings.notifications.webPush.testNotDelivered' => 'Kein Gerät war erreichbar. Stelle sicher, dass die App läuft und Benachrichtigungen aktiviert sind.',
			'settings.notifications.device.title' => 'Dieses Gerät benachrichtigen',
			'settings.notifications.device.enabled' => 'Benachrichtigungen sind für dieses Gerät aktiviert',
			'settings.notifications.sound.title' => 'Ton',
			'settings.notifications.sound.description' => 'Spielt einen kurzen Ton ab, wenn ein Chat-Lauf abgeschlossen ist.',
			'settings.notifications.sound.enabled' => 'Aktiviert',
			'settings.notifications.sound.test' => 'Ton testen',
			'settings.notifications.events.title' => 'Ereignistypen',
			'settings.notifications.events.actionRequired' => 'Aktion erforderlich',
			'settings.notifications.events.stop' => 'Lauf gestoppt',
			'settings.notifications.events.error' => 'Lauf fehlgeschlagen',
			'settings.notifications.desktop.title' => 'Diese Desktop-App benachrichtigen',
			'settings.notifications.desktop.enable' => 'Push-Benachrichtigungen aktivieren',
			'settings.notifications.desktop.disable' => 'Push-Benachrichtigungen deaktivieren',
			'settings.notifications.desktop.enabled' => 'Benachrichtigungen sind für diese Desktop-App aktiviert',
			'settings.notifications.desktop.unsupported' => 'Desktop-Benachrichtigungen werden auf diesem System nicht unterstützt.',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.unpair' => 'Kopplung aufheben',
			'settings.appearanceSettings.darkMode.label' => 'Darkmode',
			'settings.appearanceSettings.darkMode.description' => 'Zwischen hellem und dunklem Design wechseln',
			'settings.appearanceSettings.codeEditor.title' => 'Code-Editor',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Editor-Design',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Standarddesign für den Code-Editor',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Zeilenumbruch',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Zeilenumbruch standardmäßig im Editor aktivieren',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Minimap anzeigen',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Minimap zur einfacheren Navigation in der Diff-Ansicht anzeigen',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Zeilennummern anzeigen',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Zeilennummern im Editor anzeigen',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Schriftgröße',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Editor-Schriftgröße in Pixeln',
			'settings.appearanceSettings.terminal.title' => 'Terminal',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Fokus folgt dem Zeiger',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Terminal für die Eingabe fokussieren, wenn du die Maus darüber bewegst',
			'settings.mcpForm.title.add' => 'MCP-Server hinzufügen',
			'settings.mcpForm.title.edit' => 'MCP-Server bearbeiten',
			'settings.mcpForm.importMode.form' => 'Formulareingabe',
			'settings.mcpForm.importMode.json' => 'JSON-Import',
			'settings.mcpForm.scope.label' => 'Geltungsbereich',
			'settings.mcpForm.scope.userGlobal' => 'Benutzer:in (Global)',
			'settings.mcpForm.scope.projectLocal' => 'Projekt (Lokal)',
			'settings.mcpForm.scope.userDescription' => 'Benutzerbereich: Auf allen Projekten deines Computers verfügbar',
			'settings.mcpForm.scope.projectDescription' => 'Lokaler Bereich: Nur im ausgewählten Projekt verfügbar',
			'settings.mcpForm.scope.cannotChange' => 'Der Geltungsbereich kann beim Bearbeiten eines vorhandenen Servers nicht geändert werden',
			'settings.mcpForm.fields.serverName' => 'Servername',
			'settings.mcpForm.fields.transportType' => 'Transporttyp',
			'settings.mcpForm.fields.command' => 'Befehl',
			'settings.mcpForm.fields.arguments' => 'Argumente (eines pro Zeile)',
			'settings.mcpForm.fields.jsonConfig' => 'JSON-Konfiguration',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Umgebungsvariablen (SCHLÜSSEL=Wert, eine pro Zeile)',
			'settings.mcpForm.fields.headers' => 'Header (SCHLÜSSEL=Wert, eine pro Zeile)',
			'settings.mcpForm.fields.selectProject' => 'Projekt auswählen...',
			'settings.mcpForm.placeholders.serverName' => 'mein-server',
			'settings.mcpForm.validation.missingType' => 'Pflichtfeld fehlt: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdio-Typ erfordert ein Befehlsfeld',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type}-Typ erfordert ein URL-Feld',
			'settings.mcpForm.validation.invalidJson' => 'Ungültiges JSON-Format',
			'settings.mcpForm.validation.jsonHelp' => 'Füge deine MCP-Server-Konfiguration im JSON-Format ein. Beispielformate:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Konfigurationsdetails (aus ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Pfad: ${path}',
			'settings.mcpForm.actions.cancel' => 'Abbrechen',
			'settings.mcpForm.actions.saving' => 'Wird gespeichert...',
			'settings.mcpForm.actions.addServer' => 'Server hinzufügen',
			'settings.mcpForm.actions.updateServer' => 'Server aktualisieren',
			'settings.saveStatus.success' => 'Einstellungen erfolgreich gespeichert!',
			'settings.saveStatus.error' => 'Einstellungen konnten nicht gespeichert werden',
			'settings.saveStatus.saving' => 'Wird gespeichert...',
			'settings.footerActions.save' => 'Einstellungen speichern',
			'settings.footerActions.cancel' => 'Abbrechen',
			'settings.git.title' => 'Git-Konfiguration',
			'settings.git.description' => 'Konfiguriere deine Git-Identität für Commits. Diese Einstellungen werden global über git config --global angewendet',
			'settings.git.name.label' => 'Git-Name',
			'settings.git.name.help' => 'Dein Name für Git-Commits',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'Git-E-Mail',
			'settings.git.email.help' => 'Deine E-Mail-Adresse für Git-Commits',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Konfiguration speichern',
			'settings.git.actions.saving' => 'Wird gespeichert...',
			'settings.git.status.success' => 'Erfolgreich gespeichert',
			'settings.git.status.error' => 'Speichern fehlgeschlagen',
			'settings.apiKeys.title' => 'API-Schlüssel',
			'settings.apiKeys.description' => 'Generiere API-Schlüssel, um von anderen Anwendungen auf die externe API zuzugreifen.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ API-Schlüssel speichern',
			'settings.apiKeys.newKey.alertMessage' => 'Dies ist das einzige Mal, dass du diesen Schlüssel siehst. Speichere ihn sicher.',
			'settings.apiKeys.newKey.iveSavedIt' => 'Ich habe ihn gespeichert',
			'settings.apiKeys.form.placeholder' => 'API-Schlüsselname (z. B. Produktionsserver)',
			'settings.apiKeys.form.createButton' => 'Erstellen',
			'settings.apiKeys.form.cancelButton' => 'Abbrechen',
			'settings.apiKeys.newButton' => 'Neuer API-Schlüssel',
			'settings.apiKeys.empty' => 'Noch keine API-Schlüssel erstellt.',
			'settings.apiKeys.list.created' => 'Erstellt:',
			'settings.apiKeys.list.lastUsed' => 'Zuletzt verwendet:',
			'settings.apiKeys.confirmDelete' => 'Möchtest du diesen API-Schlüssel wirklich löschen?',
			'settings.apiKeys.status.active' => 'Aktiv',
			'settings.apiKeys.status.inactive' => 'Inaktiv',
			'settings.apiKeys.github.title' => 'GitHub-Token',
			'settings.apiKeys.github.description' => 'Füge GitHub Personal Access Tokens hinzu, um private Repositories über die externe API zu klonen.',
			'settings.apiKeys.github.descriptionAlt' => 'Füge GitHub Personal Access Tokens hinzu, um private Repositories zu klonen. Du kannst Token auch direkt in API-Anfragen übergeben, ohne sie zu speichern.',
			'settings.apiKeys.github.addButton' => 'Token hinzufügen',
			'settings.apiKeys.github.form.namePlaceholder' => 'Token-Name (z. B. Persönliche Repos)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHub Personal Access Token (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Beschreibung (optional)',
			'settings.apiKeys.github.form.addButton' => 'Token hinzufügen',
			'settings.apiKeys.github.form.cancelButton' => 'Abbrechen',
			'settings.apiKeys.github.form.howToCreate' => 'Wie man einen GitHub Personal Access Token erstellt →',
			'settings.apiKeys.github.form.showToken' => 'Token anzeigen',
			'settings.apiKeys.github.form.hideToken' => 'Token ausblenden',
			'settings.apiKeys.github.empty' => 'Noch keine GitHub-Token hinzugefügt.',
			'settings.apiKeys.github.added' => 'Hinzugefügt:',
			'settings.apiKeys.github.confirmDelete' => 'Möchtest du diesen GitHub-Token wirklich löschen?',
			'settings.apiKeys.apiDocsLink' => 'API-Dokumentation',
			'settings.apiKeys.documentation.title' => 'Externe API-Dokumentation',
			'settings.apiKeys.documentation.description' => 'Erfahre, wie du die externe API nutzen kannst, um Claude/Cursor-Sitzungen aus deinen Anwendungen heraus zu starten.',
			'settings.apiKeys.documentation.viewLink' => 'API-Dokumentation anzeigen →',
			'settings.apiKeys.loading' => 'Lädt...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Update verfügbar: v${version}',
			'settings.tasks.checking' => 'TaskMaster-Installation wird überprüft...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI nicht installiert',
			'settings.tasks.notInstalled.description' => 'TaskMaster CLI ist erforderlich, um Aufgabenverwaltungsfunktionen zu nutzen. Installiere es, um loszulegen:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'Auf GitHub anzeigen',
			'settings.tasks.notInstalled.afterInstallation' => 'Nach der Installation:',
			'settings.tasks.notInstalled.steps.restart' => 'Diese Anwendung neu starten',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster-Funktionen werden automatisch verfügbar',
			'settings.tasks.notInstalled.steps.initCommand' => 'task-master init in deinem Projektverzeichnis verwenden',
			'settings.tasks.settings.enableLabel' => 'TaskMaster-Integration aktivieren',
			'settings.tasks.settings.enableDescription' => 'TaskMaster-Aufgaben, Banner und Seitenleisten-Indikatoren in der gesamten Oberfläche anzeigen',
			'settings.agents.authStatus.checking' => 'Wird überprüft...',
			'settings.agents.authStatus.connected' => 'Verbunden',
			'settings.agents.authStatus.notConnected' => 'Nicht verbunden',
			'settings.agents.authStatus.disconnected' => 'Getrennt',
			'settings.agents.authStatus.checkingAuth' => 'Authentifizierungsstatus wird überprüft...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Angemeldet als ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider}-Konto',
			'settings.agents.authStatus.authenticatedUser' => 'authentifizierte:r Benutzer:in',
			'settings.agents.install.title' => ({required Object agent}) => '${agent}-CLI ist nicht installiert',
			'settings.agents.install.description' => ({required Object agent}) => 'Installiere die ${agent}-CLI, um dich anzumelden und Sitzungen auszuführen.',
			'settings.agents.install.button' => 'Installieren',
			'settings.agents.install.installing' => 'Wird installiert…',
			'settings.agents.install.copyCommand' => 'Befehl kopieren',
			'settings.agents.install.docs' => 'Dokumentation',
			'settings.agents.install.success' => ({required Object agent}) => '${agent}-CLI installiert',
			'settings.agents.install.failed' => 'Installation fehlgeschlagen — prüfe die Terminal-Ausgabe',
			'settings.agents.update.title' => 'CLI aktualisieren',
			'settings.agents.update.description' => ({required Object agent}) => 'Installiert die neueste ${agent}-CLI-Version auf dem Server-Host.',
			'settings.agents.update.button' => 'Aktualisieren',
			'settings.agents.update.updating' => 'Wird aktualisiert…',
			'settings.agents.update.success' => ({required Object agent}) => '${agent} CLI aktualisiert',
			'settings.agents.update.failed' => 'Aktualisierung fehlgeschlagen — siehe Terminalausgabe',
			'settings.agents.account.claude.description' => 'Anthropic Claude KI-Assistent',
			'settings.agents.account.cursor.description' => 'Cursor KI-gestützter Code-Editor',
			'settings.agents.account.codex.description' => 'OpenAI Codex KI-Assistent',
			'settings.agents.account.opencode.description' => 'OpenCode CLI-Assistent',
			'settings.agents.account.commandcode.description' => 'Command Code CLI-Assistent',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI-Assistent',
			'settings.agents.account.devin.description' => 'Devin CLI-Assistent',
			_ => null,
		} ?? switch (path) {
			'settings.agents.connectionStatus' => 'Verbindungsstatus',
			'settings.agents.login.title' => 'Anmelden',
			'settings.agents.login.reAuthenticate' => 'Erneut authentifizieren',
			'settings.agents.login.description' => ({required Object agent}) => 'Meld dich bei deinem ${agent}-Konto an, um KI-Funktionen zu aktivieren',
			'settings.agents.login.reAuthDescription' => 'Mit einem anderen Konto anmelden oder Anmeldedaten aktualisieren',
			'settings.agents.login.button' => 'Anmelden',
			'settings.agents.login.reLoginButton' => 'Erneut anmelden',
			'settings.agents.logout.title' => 'Abmelden',
			'settings.agents.logout.description' => 'Von diesem Anbieter abmelden und gespeicherte Zugangsdaten löschen',
			'settings.agents.logout.button' => 'Abmelden',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => 'Von ${agent} abmelden?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Dadurch werden die gespeicherten ${agent}-Zugangsdaten auf dem Server entfernt. Melde dich erneut an, um ${agent} weiter zu nutzen.',
			'settings.agents.logout.success' => 'Abgemeldet',
			'settings.agents.logout.failed' => 'Abmelden fehlgeschlagen',
			'settings.agents.error' => ({required Object error}) => 'Fehler: ${error}',
			'settings.permissions.title' => 'Berechtigungseinstellungen',
			'settings.permissions.permissionMode.title' => 'Berechtigungsmodus',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Standard-Berechtigungsmodus für neue ${provider}-Sitzungen. Du kannst ihn für eine einzelne Sitzung noch überschreiben.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Standard',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Aktionen, die eine Berechtigung benötigen, werden dir im Chat zur Genehmigung gezeigt.',
			'settings.permissions.permissionMode.modes.auto.title' => 'Auto-Modus',
			'settings.permissions.permissionMode.modes.auto.description' => 'Ein Modell-Klassifizierer entscheidet pro Tool-Aufruf, ob genehmigt oder abgelehnt wird. Hohe Autonomie.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Bearbeitungen akzeptieren',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Dateibearbeitungen werden automatisch genehmigt; andere Aktionen fragen weiterhin nach deiner Zustimmung.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Berechtigungen umgehen',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Jede Aktion wird automatisch genehmigt — voller Zugriff ohne Nachfragen. Mit Vorsicht verwenden.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Planungsmodus: Der Agent erkundet und plant, ohne Befehle auszuführen.',
			'settings.mcpServers.title' => 'MCP-Server',
			'settings.mcpServers.description.claude' => 'Model Context Protocol-Server stellen Claude zusätzliche Werkzeuge und Datenquellen zur Verfügung',
			'settings.mcpServers.description.cursor' => 'Model Context Protocol-Server stellen Cursor zusätzliche Werkzeuge und Datenquellen zur Verfügung',
			'settings.mcpServers.description.codex' => 'Model Context Protocol-Server stellen Codex zusätzliche Werkzeuge und Datenquellen zur Verfügung',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol-Server stellen OpenCode zusätzliche Werkzeuge und Datenquellen bereit',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol-Server stellen Command Code zusätzliche Werkzeuge und Datenquellen bereit',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol-Server stellen Antigravity zusätzliche Werkzeuge und Datenquellen bereit',
			'settings.mcpServers.description.devin' => 'Model Context Protocol-Server stellen Devin zusätzliche Tools und Datenquellen bereit',
			'settings.mcpServers.addButton' => 'MCP-Server hinzufügen',
			'settings.mcpServers.empty' => 'Keine MCP-Server konfiguriert',
			'settings.mcpServers.serverType' => 'Typ',
			'settings.mcpServers.scope.local' => 'lokal',
			'settings.mcpServers.scope.user' => 'benutzer',
			'settings.mcpServers.config.command' => 'Befehl',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Argumente',
			'settings.mcpServers.config.environment' => 'Umgebung',
			'settings.mcpServers.tools.title' => 'Werkzeuge',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} weitere',
			'settings.mcpServers.actions.edit' => 'Server bearbeiten',
			'settings.mcpServers.actions.delete' => 'Server löschen',
			'settings.mcpServers.help.title' => 'Über Codex MCP',
			'settings.mcpServers.help.description' => 'Codex unterstützt stdio-basierte MCP-Server. Du kannst Server hinzufügen, die die Fähigkeiten von Codex mit zusätzlichen Werkzeugen und Ressourcen erweitern.',
			'settings.mcpServers.managed.badge' => 'Verwaltet',
			'settings.mcpServers.managed.hint' => 'Verwaltet von ddagent.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '„${serverName}“ wird aus der Anbieterkonfiguration entfernt.',
			'settings.mcpServers.deleteConfirm.title' => 'MCP-Server löschen?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => 'Warnschwellen, Routing-Richtlinie und die für Quotas abgefragten Konten.',
			'settings.quota.settings.saved' => 'Gespeichert',
			'settings.quota.settings.alertsSection' => 'Warnungen',
			'settings.quota.settings.alertsSectionHint' => 'Warnen, bevor ein Limit tatsächlich erschöpft ist, nicht erst bei 100%.',
			'settings.quota.settings.alertsEnabled' => 'Prognostizierte Limit-Warnungen',
			'settings.quota.settings.alertsEnabledHint' => 'Tempobasierte Prognosen auf der Übersicht und den Kontokarten anzeigen.',
			'settings.quota.settings.watchThreshold' => 'Beobachtungsschwelle (%)',
			'settings.quota.settings.watchThresholdHint' => 'Konten ab diesem Messwert gelten als gefährdet.',
			'settings.quota.settings.dangerThreshold' => 'Gefahrenschwelle (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Messwerte ab diesem Wert werden rot angezeigt.',
			'settings.quota.settings.routingSection' => 'Routing',
			'settings.quota.settings.routingSectionHint' => 'Wie das Panel Arbeit auf das Konto mit dem meisten Spielraum verlagern darf.',
			'settings.quota.settings.routing.manual' => 'Manuell',
			'settings.quota.settings.routing.manualHint' => 'Nur eine Empfehlung anzeigen; Konten nie automatisch wechseln.',
			'settings.quota.settings.routing.ask' => 'Vor dem Wechsel fragen',
			'settings.quota.settings.routing.askHint' => 'Ein Wechsel wird vorgeschlagen und wartet auf deine Zustimmung.',
			'settings.quota.settings.routing.autoLowRisk' => 'Automatisch bei risikoarmen Aufgaben',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Nur als risikoarm markierte Aufgaben dürfen automatisch verschoben werden.',
			'settings.quota.settings.routingNote' => 'Ein Kontowechsel ändert Kosten und Modellqualität und erfordert daher immer eine explizite Entscheidung.',
			'settings.quota.settings.accountsSection' => 'Abgefragte Konten',
			'settings.quota.settings.accountsSectionHint' => 'Zugangsdaten werden aus jedem Tool gelesen; das Panel sendet sie nirgendwo anders hin.',
			'settings.quota.settings.sourcesSection' => 'Datenquellen',
			'settings.quota.settings.sourcesSectionHint' => 'Woher Nutzungs- und Kostenzahlen stammen.',
			'settings.quota.settings.logSources' => 'Token- und Kostenprotokoll-Speicher',
			'settings.quota.settings.logSourcesHint' => 'Schreibgeschützter Aggregatspeicher, gemeinsam mit dem Tokboard-Collector genutzt.',
			'settings.quota.settings.readOnly' => 'Schreibgeschützt',
			'settings.quota.settings.quotaConsent' => 'Quota-Abfrage',
			'settings.quota.settings.quotaConsentHint' => 'Liest Anbieter-Quota-Endpunkte mit lokal gespeicherten Zugangsdaten aus.',
			'settings.quota.settings.localOnly' => 'Nur lokal',
			'settings.quota.empty.description' => 'Noch keine Konten erkannt.',
			'settings.quota.quality.cached' => 'gecacht',
			'settings.quota.quality.error' => 'Fehler',
			'settings.quota.quality.estimate' => 'Schätzung',
			'settings.quota.quality.live' => 'live',
			'settings.quota.quality.unknown' => 'unbekannt',
			'settings.quota.syncFailed' => 'Synchronisierung fehlgeschlagen',
			'settings.quota.syncNow' => 'Jetzt synchronisieren',
			'settings.browser.checking' => 'prüfe...',
			'settings.browser.description' => 'Erlaube Agenten, überwachte Playwright-Browser-Sitzungen zu erstellen, die du im Browser-Tab beobachten kannst.',
			'settings.browser.enableDescription' => 'Registriert Browser für unterstützte Agenten. Agenten können Browser-Sitzungen erstellen; du kannst sie ansehen, stoppen und löschen.',
			'settings.browser.enableLabel' => 'Browser aktivieren',
			'settings.browser.errors.installRuntime' => 'Browser-Runtime konnte nicht installiert werden',
			'settings.browser.errors.loadSettings' => 'Browser-Einstellungen konnten nicht geladen werden',
			'settings.browser.errors.loadStatus' => 'Browser-Status konnte nicht geladen werden',
			'settings.browser.errors.saveSettings' => 'Browser-Einstellungen konnten nicht gespeichert werden',
			'settings.browser.installHint' => 'Installiere die Browser-Runtime, bevor Agenten Browser-Sitzungen erstellen können.',
			'settings.browser.installRuntime' => 'Runtime installieren',
			'settings.browser.installed' => 'installiert',
			'settings.browser.installing' => 'Installiere...',
			'settings.browser.missing' => 'fehlt',
			'settings.browser.runtimeRequired' => 'Browser-Runtime erforderlich',
			'settings.browser.statusDisabled' => 'deaktiviert',
			'settings.browser.statusLabel' => 'Status',
			'settings.browser.statusReady' => 'bereit',
			'settings.browser.statusSetupRequired' => 'Einrichtung erforderlich',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Abbrechen',
			'settings.workspaces.create' => 'Workspace hinzufügen',
			'settings.workspaces.deleteConfirm' => 'Diesen Workspace aus ddagent entfernen? Seine Dateien bleiben auf der Festplatte.',
			'settings.workspaces.deleteFailed' => 'Workspace konnte nicht entfernt werden.',
			'settings.workspaces.deleteTitle' => 'Workspace entfernen',
			'settings.workspaces.description' => 'Workspaces sind Verzeichnisse, in denen ddagent chatten, Code ausführen und browsen kann.',
			'settings.workspaces.remove' => 'Workspace entfernen',
			'settings.workspaces.title' => 'Arbeitsbereiche',
			'settings.workspaces.pathRequired' => 'Pfad ist erforderlich',
			'settings.about.supportTitle' => 'Unterstütze das Projekt',
			'settings.about.buyMeACoffee' => 'Buy Me a Coffee',
			'settings.about.learnMore' => 'Mehr erfahren',
			'settings.about.pro.syncSettings' => 'Einstellungen synchronisieren',
			'settings.about.pro.teamManagement' => 'Teamverwaltung',
			'settings.about.proFeatures' => 'ddagent Pro-Funktionen',
			'settings.about.tryHosted' => 'ddagent Hosted testen',
			'settings.about.versionInfo' => 'Versionsinfo',
			'settings.about.client' => 'App',
			'settings.about.server' => 'Server',
			'settings.about.platformMobile' => 'Mobil',
			'settings.about.platformDesktop' => 'Desktop',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'unbekannt',
			'sidebar.projects.title' => 'Projekte',
			'sidebar.projects.newProject' => 'Neues Projekt',
			'sidebar.projects.deleteProject' => 'Projekt entfernen',
			'sidebar.projects.renameProject' => 'Projekt umbenennen',
			'sidebar.projects.noProjects' => 'Keine Projekte gefunden',
			'sidebar.projects.loadingProjects' => 'Projekte werden geladen...',
			'sidebar.projects.searchPlaceholder' => 'Projekte durchsuchen...',
			'sidebar.projects.projectNamePlaceholder' => 'Projektname',
			'sidebar.projects.starred' => 'Favoriten',
			'sidebar.projects.all' => 'Alle',
			'sidebar.projects.untitledSession' => 'Unbenannte Sitzung',
			'sidebar.projects.newSession' => 'Neue Sitzung',
			'sidebar.projects.codexSession' => 'Codex-Sitzung',
			'sidebar.projects.fetchingProjects' => 'Deine Claude-Projekte und -Sitzungen werden abgerufen',
			'sidebar.projects.projects' => 'Projekte',
			'sidebar.projects.noMatchingProjects' => 'Keine passenden Projekte',
			'sidebar.projects.tryDifferentSearch' => 'Versuch, den Suchbegriff anzupassen',
			'sidebar.projects.runClaudeCli' => 'Führ Claude CLI in einem Projektverzeichnis aus, um zu beginnen',
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'KI-Programmierassistent-Oberfläche',
			'sidebar.sessions.title' => 'Sitzungen',
			'sidebar.sessions.newSession' => 'Neue Sitzung',
			'sidebar.sessions.deleteSession' => 'Sitzung löschen',
			'sidebar.sessions.renameSession' => 'Sitzung umbenennen',
			'sidebar.sessions.noSessions' => 'Noch keine Sitzungen',
			'sidebar.sessions.loadingSessions' => 'Sitzungen werden geladen...',
			'sidebar.sessions.unnamed' => 'Unbenannt',
			'sidebar.sessions.loading' => 'Lädt...',
			'sidebar.sessions.showMore' => 'Weitere Sitzungen anzeigen',
			'sidebar.sessions.selectMode' => 'Auswählen',
			'sidebar.sessions.selectAll' => 'Alle auswählen',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Archivieren (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Löschen (${count})',
			'sidebar.sessions.cancelSelection' => 'Auswahl abbrechen',
			'sidebar.sessions.toggleSelection' => 'Sitzungsauswahl umschalten',
			'sidebar.sessions.selectionToolbar' => 'Aktionen zur Sitzungsauswahl',
			'sidebar.sessions.options' => 'Sitzungsoptionen',
			'sidebar.sessions.pinSession' => 'Sitzung anheften',
			'sidebar.sessions.unpinSession' => 'Sitzung lösen',
			'sidebar.sessions.pinned' => 'Angeheftete Sitzung',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} ausgewählt', other: '${count} ausgewählt', ), 
			'sidebar.tooltips.viewEnvironments' => 'Umgebungen anzeigen',
			'sidebar.tooltips.hideSidebar' => 'Seitenleiste ausblenden',
			'sidebar.tooltips.createProject' => 'Neues Projekt erstellen',
			'sidebar.tooltips.refresh' => 'Projekte und Sitzungen aktualisieren (Strg+R)',
			'sidebar.tooltips.renameProject' => 'Projekt umbenennen (F2)',
			'sidebar.tooltips.deleteProject' => 'Projekt aus Seitenleiste entfernen (Entf)',
			'sidebar.tooltips.addToFavorites' => 'Zu Favoriten hinzufügen',
			'sidebar.tooltips.removeFromFavorites' => 'Aus Favoriten entfernen',
			'sidebar.tooltips.editSessionName' => 'Sitzungsname manuell bearbeiten',
			'sidebar.tooltips.deleteSession' => 'Diese Sitzung dauerhaft löschen',
			'sidebar.tooltips.activeSessionIndicator' => 'Kürzlich aktive Sitzung (letzte 10 Minuten)',
			'sidebar.tooltips.save' => 'Speichern',
			'sidebar.tooltips.cancel' => 'Abbrechen',
			'sidebar.tooltips.clearSearch' => 'Suche leeren',
			'sidebar.tooltips.openCommandPalette' => 'Befehlspalette öffnen',
			'sidebar.tooltips.attentionRequiredIndicator' => 'Sitzung erfordert Aufmerksamkeit',
			'sidebar.tooltips.openSessions' => 'Sitzungen durchsuchen',
			'sidebar.navigation.chat' => 'Chat',
			'sidebar.navigation.files' => 'Dateien',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminal',
			'sidebar.navigation.tasks' => 'Aufgaben',
			'sidebar.actions.refresh' => 'Aktualisieren',
			'sidebar.actions.settings' => 'Einstellungen',
			'sidebar.actions.collapseAll' => 'Alle einklappen',
			'sidebar.actions.expandAll' => 'Alle ausklappen',
			'sidebar.actions.cancel' => 'Abbrechen',
			'sidebar.actions.save' => 'Speichern',
			'sidebar.actions.delete' => 'Löschen',
			'sidebar.actions.rename' => 'Umbenennen',
			'sidebar.actions.joinCommunity' => 'Community beitreten',
			'sidebar.actions.reportIssue' => 'Problem melden',
			'sidebar.actions.starOnGithub' => 'Stern auf GitHub',
			'sidebar.actions.buyMeACoffee' => 'Buy Me a Coffee',
			'sidebar.branding.openSource' => 'Open Source',
			'sidebar.status.active' => 'Aktiv',
			'sidebar.status.inactive' => 'Inaktiv',
			'sidebar.status.thinking' => 'Denkt nach...',
			'sidebar.status.error' => 'Fehler',
			'sidebar.status.aborted' => 'Abgebrochen',
			'sidebar.status.unknown' => 'Unbekannt',
			'sidebar.time.justNow' => 'Gerade eben',
			'sidebar.time.oneMinuteAgo' => 'vor 1 Min.',
			'sidebar.time.minutesAgo' => ({required Object count}) => 'vor ${count} Min.',
			'sidebar.time.oneHourAgo' => 'vor 1 Std.',
			'sidebar.time.hoursAgo' => ({required Object count}) => 'vor ${count} Std.',
			'sidebar.time.oneDayAgo' => 'vor 1 Tag',
			'sidebar.time.daysAgo' => ({required Object count}) => 'vor ${count} Tagen',
			'sidebar.messages.deleteConfirm' => 'Möchtest du das wirklich löschen?',
			'sidebar.messages.renameSuccess' => 'Erfolgreich umbenannt',
			'sidebar.messages.deleteSuccess' => 'Erfolgreich gelöscht',
			'sidebar.messages.errorOccurred' => 'Ein Fehler ist aufgetreten',
			'sidebar.messages.deleteSessionConfirm' => 'Möchtest du diese Sitzung wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
			'sidebar.messages.deleteProjectConfirm' => 'Projekt aus der Seitenleiste entfernen? Deine Projektdateien, Erinnerungen und Sitzungsdaten werden nicht gelöscht.',
			'sidebar.messages.enterProjectPath' => 'Bitte gib einen Projektpfad ein',
			'sidebar.messages.deleteSessionFailed' => 'Sitzung konnte nicht gelöscht werden. Bitte erneut versuchen.',
			'sidebar.messages.deleteSessionError' => 'Fehler beim Löschen der Sitzung. Bitte erneut versuchen.',
			'sidebar.messages.renameSessionFailed' => 'Sitzung konnte nicht umbenannt werden. Bitte erneut versuchen.',
			'sidebar.messages.renameSessionError' => 'Fehler beim Umbenennen der Sitzung. Bitte erneut versuchen.',
			'sidebar.messages.deleteProjectFailed' => 'Projekt konnte nicht entfernt werden. Bitte erneut versuchen.',
			'sidebar.messages.deleteProjectError' => 'Fehler beim Entfernen des Projekts. Bitte erneut versuchen.',
			'sidebar.messages.createProjectFailed' => 'Projekt konnte nicht erstellt werden. Bitte erneut versuchen.',
			'sidebar.messages.createProjectError' => 'Fehler beim Erstellen des Projekts. Bitte erneut versuchen.',
			'sidebar.messages.updateProjectError' => 'Fehler beim Aktualisieren des Projekts. Bitte erneut versuchen.',
			'sidebar.messages.refreshError' => 'Aktualisierung fehlgeschlagen. Bitte erneut versuchen.',
			'sidebar.messages.restoreProjectFailed' => 'Projekt konnte nicht wiederhergestellt werden. Bitte erneut versuchen.',
			'sidebar.messages.restoreProjectError' => 'Fehler beim Wiederherstellen des Projekts. Bitte erneut versuchen.',
			'sidebar.messages.restoreSessionFailed' => 'Sitzung konnte nicht wiederhergestellt werden. Bitte erneut versuchen.',
			'sidebar.messages.restoreSessionError' => 'Fehler beim Wiederherstellen der Sitzung. Bitte erneut versuchen.',
			'sidebar.messages.changeWorkspaceFailed' => 'Wechseln des Arbeitsbereichs fehlgeschlagen. Bitte erneut versuchen.',
			'sidebar.messages.changeWorkspaceError' => 'Fehler beim Wechseln des Arbeitsbereichs. Bitte erneut versuchen.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'Löschen von ${count} Sitzung fehlgeschlagen. Bitte erneut versuchen.', other: 'Löschen von ${count} Sitzungen fehlgeschlagen. Bitte erneut versuchen.', ), 
			'sidebar.version.updateAvailable' => 'Update verfügbar',
			'sidebar.version.restartRequired' => 'Update installiert – zum Anwenden Server neu starten',
			'sidebar.version.updateNow' => 'Jetzt aktualisieren',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'ddagent auf v${version} aktualisieren? Der neueste Code wird geholt und gebaut, der Server startet neu — aktive Sitzungen werden unterbrochen.',
			'sidebar.version.updating' => 'Aktualisierung läuft… kann ein paar Minuten dauern',
			'sidebar.version.restarting' => 'Update installiert — Neustart…',
			'sidebar.version.updateFailed' => 'Update fehlgeschlagen',
			'sidebar.version.releaseNotes' => 'Versionshinweise',
			'sidebar.search.modeProjects' => 'Projekte',
			'sidebar.search.modeConversations' => 'Unterhaltungen',
			'sidebar.search.conversationsPlaceholder' => 'In Unterhaltungen suchen...',
			'sidebar.search.searching' => 'Sucht...',
			'sidebar.search.sessionTitles' => 'Sitzungstitel',
			'sidebar.search.conversationContents' => 'Unterhaltungsinhalte',
			'sidebar.search.noResults' => 'Keine Ergebnisse gefunden',
			'sidebar.search.tryDifferentQuery' => 'Versuch eine andere Suchanfrage',
			'sidebar.search.modeRunning' => 'Läuft',
			'sidebar.search.archiveOnly' => 'Archiv',
			'sidebar.search.runningTooltip' => 'Laufende Sitzungen',
			'sidebar.search.archiveOnlyTooltip' => 'Nur Archiv',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} aktiv',
			'sidebar.search.viewMenu' => 'Ansicht',
			'sidebar.search.backToProjects' => 'Zurück zu Projekten',
			'sidebar.search.archivedPlaceholder' => 'Archivierte Sitzungen durchsuchen...',
			'sidebar.search.runningPlaceholder' => 'Laufende Sitzungen durchsuchen...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} Treffer', other: '${count} Treffer', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} Projekt durchsucht', other: '${count} Projekte durchsucht', ), 
			'sidebar.deleteConfirmation.deleteProject' => 'Projekt entfernen',
			'sidebar.deleteConfirmation.deleteSession' => 'Sitzung löschen',
			'sidebar.deleteConfirmation.confirmDelete' => 'Was möchtest du mit',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Nur aus der Seitenleiste entfernen',
			'sidebar.deleteConfirmation.deleteAllData' => 'Alle Daten dauerhaft löschen',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'Das Projekt wird aus der Seitenleiste entfernt. Deine Dateien, Erinnerungen und Sitzungsdaten bleiben erhalten.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Du kannst das Projekt später erneut hinzufügen.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'Archivieren blendet die ausgewählten Sitzungen aus der aktiven Liste aus und bewahrt ihre Verläufe.',
			'sidebar.deleteConfirmation.archiveSession' => 'Sitzung archivieren',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'Archivieren hält die Sitzung aus der aktiven Liste, bewahrt aber ihren Verlauf.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Diese Sitzung ist bereits archiviert. Du kannst sie verborgen halten oder dauerhaft löschen.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'Dies entfernt die Sitzung und ihr Transkript dauerhaft. Diese Aktion kann nicht rückgängig gemacht werden.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Endgültig löschen',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'Dieses Projekt enthält ${count} Unterhaltung.', other: 'Dieses Projekt enthält ${count} Unterhaltungen.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'Ausgewählte Sitzung verwalten', other: '${count} ausgewählte Sitzungen verwalten', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'Sitzung archivieren', other: '${count} Sitzungen archivieren', ), 
			'sidebar.zones.activeNow' => 'Jetzt aktiv',
			'sidebar.zones.recent' => 'Zuletzt verwendet',
			'sidebar.zones.today' => 'Heute',
			'sidebar.zones.yesterday' => 'Gestern',
			'sidebar.zones.thisWeek' => 'Diese Woche',
			'sidebar.zones.showMore' => ({required Object count}) => '${count} weitere anzeigen',
			'sidebar.zones.showLess' => 'Weniger anzeigen',
			'sidebar.panel.open' => 'Panel',
			'sidebar.panel.newChat' => 'Neuer Chat',
			'sidebar.panel.navigation' => 'Navigation',
			'sidebar.panel.sessions' => 'Sitzungen',
			'sidebar.workspace.title' => 'Sitzungs-Arbeitsbereich wechseln',
			'sidebar.workspace.description' => 'Der Agent führt seine nächsten Schritte in diesem Verzeichnis aus. Der vorhandene Sitzungsverlauf bleibt erhalten.',
			'sidebar.workspace.pathLabel' => 'Arbeitsbereich-Pfad',
			'sidebar.workspace.pathRequired' => 'Arbeitsbereich-Pfad ist erforderlich.',
			'sidebar.workspace.submit' => 'Arbeitsbereich wechseln',
			'sidebar.workspace.saving' => 'Wechsel läuft…',
			'sidebar.workspace.changeAction' => 'Arbeitsbereich wechseln',
			'sidebar.recent.title' => 'Letzte Unterhaltungen',
			'sidebar.recent.emptyTitle' => 'Noch keine Unterhaltungen',
			'sidebar.recent.emptyDescription' => 'Deine zuletzt aktualisierten Unterhaltungen erscheinen hier.',
			'sidebar.recent.loadFailed' => 'Letzte Unterhaltungen konnten nicht geladen werden',
			'sidebar.recent.loadMore' => 'Ältere Unterhaltungen laden',
			'sidebar.recent.loadingMore' => 'Mehr laden...',
			'sidebar.tabs.board' => 'Agent-Board',
			'sidebar.tabs.files' => 'Dateien',
			'sidebar.tabs.git' => 'Quellcodeverwaltung',
			'sidebar.tabs.tasks' => 'Aufgaben',
			'sidebar.tabs.usage' => 'Quota & Nutzung',
			'tasks.notConfigured.title' => 'TaskMaster AI ist nicht konfiguriert',
			'tasks.notConfigured.description' => 'TaskMaster hilft dabei, komplexe Projekte mit KI-Unterstützung in überschaubare Aufgaben aufzuteilen',
			'tasks.notConfigured.whatIsTitle' => '🎯 Was ist TaskMaster?',
			'tasks.notConfigured.features.aiPowered' => 'KI-gestütztes Aufgabenmanagement: Komplexe Projekte in handhabbare Unteraufgaben aufteilen',
			'tasks.notConfigured.features.prdTemplates' => 'PRD-Vorlagen: Aufgaben aus Produktanforderungsdokumenten generieren',
			'tasks.notConfigured.features.dependencyTracking' => 'Abhängigkeitsverfolgung: Aufgabenbeziehungen und Ausführungsreihenfolge verstehen',
			'tasks.notConfigured.features.progressVisualization' => 'Fortschrittsvisualisierung: Kanban-Boards und detaillierte Aufgabenanalysen',
			'tasks.notConfigured.features.cliIntegration' => 'CLI-Integration: Taskmaster-Befehle für erweiterte Workflows verwenden',
			'tasks.notConfigured.initializeButton' => 'TaskMaster AI initialisieren',
			'tasks.notConfigured.writePrdFirst' => 'Zuerst PRD schreiben',
			'tasks.gettingStarted.title' => 'Erste Schritte mit TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster ist initialisiert! Hier ist, was du als Nächstes tun kannst:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Produktanforderungsdokument (PRD) erstellen',
			'tasks.gettingStarted.steps.createPRD.description' => 'Besprich deine Projektidee und erstelle ein PRD, das beschreibt, was du bauen möchtest.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'PRD hinzufügen',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'Vorhandene PRDs:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Aufgaben aus PRD generieren',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Sobald du ein PRD hast, bitte deinen KI-Assistenten, es zu analysieren. TaskMaster wird es automatisch in überschaubare Aufgaben mit Implementierungsdetails aufteilen.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Aufgaben analysieren und erweitern',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Bitte deinen KI-Assistenten, die Aufgabenkomplexität zu analysieren und sie in detaillierte Unteraufgaben für eine einfachere Implementierung zu erweitern.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Mit dem Bauen beginnen',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Bitte deinen KI-Assistenten, mit der Bearbeitung von Aufgaben zu beginnen, deren Status zu aktualisieren und neue Aufgaben hinzuzufügen, wenn dein Projekt sich weiterentwickelt.',
			'tasks.gettingStarted.tip' => '💡 Tipp: Beginne mit einem PRD, um das Beste aus TaskMasters KI-gestützter Aufgabengenerierung herauszuholen',
			'tasks.setupModal.title' => 'TaskMaster-Einrichtung',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'Interaktives CLI für ${projectName}',
			'tasks.setupModal.willStart' => 'Die TaskMaster-Initialisierung startet automatisch',
			'tasks.setupModal.completed' => 'TaskMaster-Einrichtung abgeschlossen! Du kannst dieses Fenster jetzt schließen.',
			'tasks.setupModal.closeButton' => 'Schließen',
			'tasks.setupModal.closeContinueButton' => 'Schließen & Fortfahren',
			'tasks.setupModal.closeTitle' => 'Schließen',
			'tasks.setupModal.description' => 'Erstellt einen .taskmaster-Ordner in diesem Projekt. Keine externen Tools oder API-Schlüssel erforderlich — Aufgaben werden lokal gespeichert.',
			'tasks.setupModal.initializeButton' => 'Initialisieren',
			'tasks.setupModal.initializing' => 'Initialisiere...',
			'tasks.helpGuide.title' => 'Erste Schritte mit TaskMaster',
			'tasks.helpGuide.subtitle' => 'Dein Leitfaden für produktives Aufgabenmanagement',
			'tasks.helpGuide.examples.parsePRD' => '💬 Beispiel:\n"Ich habe gerade ein neues Projekt mit Claude Task Master initialisiert. Ich habe ein PRD unter .taskmaster/docs/prd.txt. Kannst du mir helfen, es zu analysieren und die ersten Aufgaben einzurichten?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Beispiel:\n"Aufgabe 5 scheint komplex. Kannst du sie in Unteraufgaben aufteilen?"',
			'tasks.helpGuide.examples.addTask' => '💬 Beispiel:\n"Bitte füge eine neue Aufgabe hinzu, um Benutzerprofilbild-Uploads mit Cloudinary zu implementieren, und recherchiere den besten Ansatz."',
			'tasks.helpGuide.moreExamples' => 'Weitere Beispiele und Verwendungsmuster anzeigen →',
			'tasks.helpGuide.proTips.title' => '💡 Profi-Tipps',
			'tasks.helpGuide.proTips.search' => 'Verwende die Suchleiste, um bestimmte Aufgaben schnell zu finden',
			'tasks.helpGuide.proTips.views' => 'Wechsle mit den Ansichts-Umschaltern zwischen Kanban-, Listen- und Rasteransicht',
			'tasks.helpGuide.proTips.filters' => 'Verwende Filter, um dich auf bestimmte Aufgabenstatus oder Prioritäten zu konzentrieren',
			'tasks.helpGuide.proTips.details' => 'Klicke auf eine Aufgabe, um detaillierte Informationen anzuzeigen und Unteraufgaben zu verwalten',
			'tasks.helpGuide.learnMore.title' => '📚 Mehr erfahren',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI ist ein fortschrittliches Aufgabenmanagementsystem für Entwickler:innen. Dokumentation, Beispiele und Möglichkeiten zur Mitarbeit am Projekt.',
			'tasks.helpGuide.learnMore.githubButton' => 'Auf GitHub ansehen',
			'tasks.helpGuide.closeTitle' => 'Schließen',
			'tasks.search.placeholder' => 'Aufgaben suchen...',
			'tasks.filters.button' => 'Filter',
			'tasks.filters.status' => 'Status',
			'tasks.filters.priority' => 'Priorität',
			'tasks.filters.sortBy' => 'Sortieren nach',
			'tasks.filters.allStatuses' => 'Alle Status',
			'tasks.filters.allPriorities' => 'Alle Prioritäten',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => '${filtered} von ${total} Aufgaben werden angezeigt',
			'tasks.filters.clearFilters' => 'Filter zurücksetzen',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Status',
			'tasks.sort.priority' => 'Priorität',
			'tasks.sort.idAsc' => 'ID (aufsteigend)',
			'tasks.sort.idDesc' => 'ID (absteigend)',
			'tasks.sort.titleAsc' => 'Titel (A-Z)',
			'tasks.sort.titleDesc' => 'Titel (Z-A)',
			'tasks.sort.statusAsc' => 'Status (Ausstehend zuerst)',
			'tasks.sort.statusDesc' => 'Status (Erledigt zuerst)',
			'tasks.sort.priorityAsc' => 'Priorität (Hoch zuerst)',
			'tasks.sort.priorityDesc' => 'Priorität (Niedrig zuerst)',
			'tasks.views.kanban' => 'Kanban-Ansicht',
			'tasks.views.list' => 'Listenansicht',
			'tasks.views.grid' => 'Rasteransicht',
			'tasks.kanban.pending' => '📋 Ausstehend',
			'tasks.kanban.inProgress' => '🚀 In Bearbeitung',
			'tasks.kanban.review' => '👀 Review',
			'tasks.kanban.done' => '✅ Erledigt',
			'tasks.kanban.blocked' => '🚫 Blockiert',
			'tasks.kanban.deferred' => '⏳ Zurückgestellt',
			'tasks.kanban.cancelled' => '❌ Abgebrochen',
			'tasks.kanban.noTasksYet' => 'Noch keine Aufgaben',
			'tasks.kanban.tasksWillAppear' => 'Aufgaben werden hier angezeigt',
			'tasks.kanban.moveTasksHere' => 'Aufgaben hierher verschieben, wenn sie gestartet werden',
			'tasks.kanban.completedTasksHere' => 'Abgeschlossene Aufgaben erscheinen hier',
			'tasks.kanban.statusTasksHere' => 'Aufgaben mit diesem Status werden hier angezeigt',
			'tasks.buttons.help' => 'TaskMaster-Leitfaden für Erste Schritte',
			'tasks.buttons.prds' => 'PRDs',
			'tasks.buttons.addPRD' => 'PRD hinzufügen',
			'tasks.buttons.addTask' => 'Aufgabe hinzufügen',
			'tasks.buttons.createNewPRD' => 'Neues PRD erstellen',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} PRD(s) verfügbar',
			'tasks.prd.modified' => ({required Object date}) => 'Geändert: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'Ein PRD mit dem Namen „${name}“ existiert bereits. Möchtest du es überschreiben?',
			'tasks.prd.fileExistsTitle' => 'Datei existiert bereits',
			'tasks.prd.newFile' => 'neue Datei',
			'tasks.prd.parse' => 'PRD analysieren',
			'tasks.prd.template' => 'Vorlage',
			'tasks.prd.fileNameHint' => 'Dateiname (z. B. prd.txt)',
			'tasks.prd.saved' => 'PRD gespeichert',
			'tasks.prd.tasksGenerated' => 'Aufgaben aus PRD generiert',
			'tasks.statuses.pending' => 'Ausstehend',
			'tasks.statuses.inProgress' => 'In Bearbeitung',
			'tasks.statuses.done' => 'Erledigt',
			'tasks.statuses.blocked' => 'Blockiert',
			'tasks.statuses.deferred' => 'Zurückgestellt',
			'tasks.statuses.cancelled' => 'Abgebrochen',
			'tasks.statuses.review' => 'Überprüfung',
			'tasks.priorities.high' => 'Hoch',
			'tasks.priorities.medium' => 'Mittel',
			'tasks.priorities.low' => 'Niedrig',
			'tasks.noMatchingTasks.title' => 'Keine Aufgaben entsprechen deinen Filtern',
			'tasks.noMatchingTasks.description' => 'Versuche, deine Such- oder Filterkriterien anzupassen.',
			'tasks.board.title' => 'Agent-Board',
			'tasks.board.subtitle' => 'Verschiebe eine Karte auf Bereit und der Agent nimmt sie auf. Klicke auf eine Karte, um ihre Sitzung zu öffnen.',
			'tasks.board.newCard' => 'Neue Karte',
			'tasks.board.addCard' => 'Karte hinzufügen',
			'tasks.board.refresh' => 'Aktualisieren',
			'tasks.board.empty.title' => 'Noch keine Karten',
			'tasks.board.empty.description' => 'Füge eine Karte hinzu, beschreibe die Aufgabe und ziehe sie dann auf Bereit, damit ein Agent mit der Arbeit beginnt.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Bereit zum Start',
			'tasks.board.columns.working' => 'In Arbeit',
			'tasks.board.columns.needsDecision' => 'Braucht deine Entscheidung',
			'tasks.board.columns.done' => 'Erledigt',
			'tasks.board.columns.archived' => 'Archiviert',
			'tasks.board.card.running' => 'Läuft',
			'tasks.board.card.abort' => 'Abbrechen',
			'tasks.board.card.delete' => 'Löschen',
			'tasks.board.card.openSession' => 'Sitzung öffnen',
			'tasks.board.card.pullRequest' => 'Pull Request',
			'tasks.board.dialog.createTitle' => 'Neue Karte',
			'tasks.board.dialog.editTitle' => 'Karte bearbeiten',
			'tasks.board.dialog.titleLabel' => 'Titel',
			'tasks.board.dialog.titlePlaceholder' => 'Was soll der Agent tun?',
			'tasks.board.dialog.descriptionLabel' => 'Beschreibung',
			'tasks.board.dialog.descriptionPlaceholder' => 'Kontext, Akzeptanzkriterien, Links hinzufügen...',
			'tasks.board.dialog.cancel' => 'Abbrechen',
			'tasks.board.dialog.save' => 'Speichern',
			'tasks.board.noProject' => 'Füge zuerst ein Projekt hinzu und erstelle dann Karten dafür.',
			'tasks.board.projectLabel' => 'Projekt',
			'tasks.board.backToChat' => 'Zurück zum Chat',
			'tasks.board.agent.provider' => 'Agent',
			'tasks.board.agent.anyProvider' => 'Beliebiger Agent',
			'tasks.board.agent.model' => 'Modell',
			'tasks.board.agent.defaultModel' => 'Standardmodell',
			'tasks.board.agent.effort' => 'Reasoning',
			'tasks.board.agent.defaultEffort' => 'Standard',
			'tasks.board.agent.searchModel' => 'Modelle suchen…',
			'tasks.board.agent.noModels' => 'Keine passenden Modelle',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '„${cardTitle}“ wird endgültig gelöscht.',
			'tasks.board.deleteConfirm.title' => 'Karte löschen?',
			'tasks.board.project' => 'Projekt',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Abhängig von: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Aufgabe ${id}',
			'tasks.card.highPriority' => 'Hohe Priorität',
			'tasks.card.lowPriority' => 'Niedrige Priorität',
			'tasks.card.mediumPriority' => 'Mittlere Priorität',
			'tasks.card.noPriority' => 'Keine Priorität gesetzt',
			'tasks.card.parentTask' => ({required Object id}) => 'Aufgabe ${id}',
			'tasks.card.progressLabel' => 'Fortschritt:',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => '${completed} von ${total} Teilaufgaben abgeschlossen',
			'tasks.card.runTask' => 'Aufgabe ausführen',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Aufgabe ${id} ausführen',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Status: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'Aufgaben-ID: ${id}',
			'tasks.card.taskInProgress' => 'Aufgabe in Bearbeitung',
			'tasks.createTask.cancel' => 'Abbrechen',
			'tasks.createTask.descriptionLabel' => 'Beschreibung',
			'tasks.createTask.descriptionPlaceholder' => 'Optionale Details',
			'tasks.createTask.error' => 'Aufgabe konnte nicht hinzugefügt werden',
			'tasks.createTask.priorityLabel' => 'Priorität',
			'tasks.createTask.submit' => 'Aufgabe hinzufügen',
			'tasks.createTask.submitting' => 'Füge hinzu...',
			'tasks.createTask.title' => 'Aufgabe hinzufügen',
			'tasks.createTask.titleLabel' => 'Titel',
			'tasks.createTask.titlePlaceholder' => 'Was muss erledigt werden?',
			'tasks.list.completedReopen' => 'Abgeschlossen (klicken zum Wiederöffnen)',
			'tasks.list.inProgressComplete' => 'In Bearbeitung (klicken zum Abschließen)',
			'tasks.list.markCompleted' => 'Als abgeschlossen markieren',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Status von Aufgabe ${id} umschalten',
			'tasks.list.markDone' => 'Als erledigt markieren',
			'tasks.list.reopen' => 'Wieder öffnen',
			'tasks.nextTask.allComplete' => 'Alle Aufgaben abgeschlossen',
			'tasks.nextTask.feature1' => '- KI-gestützte Aufgabenverwaltung mit Abhängigkeiten und Teilaufgaben.',
			'tasks.nextTask.feature2' => '- PRD-basierte Aufgabengenerierung für schnelleren Projektstart.',
			'tasks.nextTask.feature3' => '- Kanban- und Listenansichten für die tägliche Arbeit.',
			'tasks.nextTask.hideDetails' => 'Details ausblenden',
			'tasks.nextTask.initialize' => 'Initialisieren',
			'tasks.nextTask.noPending' => 'Keine ausstehenden Aufgaben',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI ist nicht konfiguriert',
			'tasks.nextTask.review' => 'Überprüfen',
			_ => null,
		} ?? switch (path) {
			'tasks.nextTask.startTask' => 'Aufgabe starten',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Aufgabe ${id}',
			'tasks.nextTask.viewAll' => 'Alle Aufgaben anzeigen',
			'tasks.nextTask.viewDetails' => 'Aufgabendetails anzeigen',
			'tasks.nextTask.whatIs' => 'Was ist TaskMaster?',
			'tasks.taskDetail.cancelEdit' => 'Bearbeiten abbrechen',
			'tasks.taskDetail.close' => 'Schließen',
			'tasks.taskDetail.copyTaskId' => 'Aufgaben-ID kopieren',
			'tasks.taskDetail.delete' => 'Aufgabe löschen',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '„${title}" wird dauerhaft gelöscht.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Aufgabe löschen?',
			'tasks.taskDetail.deleteFailed' => 'Aufgabe konnte nicht gelöscht werden',
			'tasks.taskDetail.dependencies' => 'Abhängigkeiten',
			'tasks.taskDetail.dependenciesPlaceholder' => 'z. B. 1, 2, 3',
			'tasks.taskDetail.description' => 'Beschreibung',
			'tasks.taskDetail.edit' => 'Aufgabe bearbeiten',
			'tasks.taskDetail.implDetails' => 'Implementierungsdetails',
			'tasks.taskDetail.noDependencies' => 'Keine Abhängigkeiten',
			'tasks.taskDetail.noDescription' => 'Keine Beschreibung vorhanden',
			'tasks.taskDetail.priority' => 'Priorität',
			'tasks.taskDetail.priorityNotSet' => 'Nicht gesetzt',
			'tasks.taskDetail.save' => 'Speichern',
			'tasks.taskDetail.status' => 'Status',
			'tasks.taskDetail.statusFailed' => 'Aufgabenstatus konnte nicht aktualisiert werden',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Aufgabe ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Aufgabe ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Teststrategie',
			'tasks.taskDetail.titleRequired' => 'Titel ist erforderlich',
			'tasks.taskDetail.updateFailed' => 'Aufgabe konnte nicht aktualisiert werden',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'Aufgabe #${id} wird entfernt. Dies kann nicht rückgängig gemacht werden.',
			'tasks.taskDetail.notFound' => 'Aufgabe nicht gefunden',
			'tasks.taskDetail.subtasks' => 'Unteraufgaben',
			'tasks.taskDetail.idCopied' => 'Aufgaben-ID kopiert',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Aufgabe ${id} auf „In Bearbeitung“ gesetzt',
			'knowledge.title' => 'Wissen',
			'knowledge.tabs.dashboard' => 'Übersicht',
			'knowledge.tabs.memories' => 'Erinnerungen',
			'knowledge.tabs.rules' => 'Regeln',
			'knowledge.tabs.skills' => 'Fähigkeiten',
			'knowledge.tabs.personal' => 'Persönlich',
			'knowledge.tabs.graph' => 'Graph',
			'knowledge.common.add' => 'Hinzufügen',
			'knowledge.common.save' => 'Speichern',
			'knowledge.common.cancel' => 'Abbrechen',
			'knowledge.common.delete' => 'Löschen',
			'knowledge.common.edit' => 'Bearbeiten',
			'knowledge.common.close' => 'Schließen',
			'knowledge.common.restore' => 'Wiederherstellen',
			'knowledge.common.refresh' => 'Aktualisieren',
			'knowledge.common.allProjects' => 'Alle Projekte',
			'knowledge.common.global' => 'Global',
			'knowledge.actions.scan' => 'Projektdateien scannen',
			'knowledge.actions.export' => 'JSON exportieren',
			'knowledge.actions.import' => 'JSON importieren',
			'knowledge.actions.scanComplete' => 'Projekt-Scan abgeschlossen',
			'knowledge.actions.importComplete' => 'Import abgeschlossen',
			'knowledge.actions.importFailed' => 'Import fehlgeschlagen',
			'knowledge.dialog.newEntity' => 'Neuer Eintrag',
			'knowledge.dialog.editEntity' => 'Eintrag bearbeiten',
			'knowledge.dialog.deleteTitle' => 'Löschen',
			'knowledge.dialog.deleteMessage' => 'Diesen Eintrag löschen? Das kann nicht rückgängig gemacht werden (Verlauf bleibt erhalten).',
			'knowledge.dialog.pickIcon' => 'Symbol wählen',
			'knowledge.dialog.removeIcon' => 'Symbol entfernen',
			'knowledge.dialog.iconTooLarge' => 'Symbol ist zu groß (max. 40 KB).',
			'knowledge.dialog.importTitle' => 'Wissen importieren',
			'knowledge.dialog.importHint' => 'Exportiertes JSON hier einfügen',
			'knowledge.dialog.exportTitle' => 'Wissen exportieren',
			'knowledge.dialog.import' => 'Importieren',
			'knowledge.fields.key' => 'Schlüssel',
			'knowledge.fields.title' => 'Titel',
			'knowledge.fields.name' => 'Name',
			'knowledge.fields.description' => 'Beschreibung',
			'knowledge.fields.category' => 'Kategorie',
			'knowledge.fields.content' => 'Inhalt',
			'knowledge.fields.priority' => 'Priorität',
			'knowledge.fields.tags' => 'Tags',
			'knowledge.fields.enabled' => 'Aktiviert',
			'knowledge.fields.projectScope' => 'Projektbereich',
			'knowledge.fields.tagsHint' => 'durch Kommas getrennt',
			'knowledge.dashboard.memories' => 'Erinnerungen',
			'knowledge.dashboard.rules' => 'Regeln',
			'knowledge.dashboard.skills' => 'Fähigkeiten',
			'knowledge.dashboard.personal' => 'Persönlich',
			'knowledge.dashboard.connections' => 'Verbindungen',
			'knowledge.dashboard.recent' => 'Letzte Erinnerungen',
			'knowledge.dashboard.noMemories' => 'Noch keine Erinnerungen. Füge eine im Tab Erinnerungen hinzu.',
			'knowledge.empty.memories' => 'Noch keine Erinnerungen.',
			'knowledge.empty.rules' => 'Noch keine Regeln.',
			'knowledge.empty.skills' => 'Noch keine Fähigkeiten.',
			'knowledge.empty.personal' => 'Noch keine persönlichen Daten.',
			'knowledge.empty.graph' => 'Noch keine Entitäten für den Graphen.',
			'knowledge.history.title' => 'Verlauf',
			'knowledge.history.none' => 'Noch kein Verlauf.',
			'knowledge.history.untitled' => '(ohne Titel)',
			'knowledge.priorities.critical' => 'Kritisch',
			'knowledge.priorities.high' => 'Hoch',
			'knowledge.priorities.normal' => 'Normal',
			'knowledge.priorities.low' => 'Niedrig',
			'knowledge.search.title' => 'Wissen durchsuchen',
			'knowledge.search.hint' => 'Erinnerungen, Regeln, Fähigkeiten suchen…',
			'knowledge.search.noResults' => 'Keine Ergebnisse.',
			'knowledge.links.title' => 'Entitäten verknüpfen',
			'knowledge.links.source' => 'Quelle',
			'knowledge.links.target' => 'Ziel',
			'knowledge.links.relationship' => 'Beziehung',
			'knowledge.links.add' => 'Verknüpfung erstellen',
			'knowledge.tags.all' => 'Alle Tags',
			'knowledge.tags.manage' => 'Tags verwalten',
			'knowledge.tags.none' => 'Noch keine Tags.',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.critical.make' => 'Als kritisch markieren',
			'knowledge.critical.makeAll' => 'Alle Regeln als kritisch markieren',
			'knowledge.critical.makeAllHint' => 'Fügt sie zum injizierten Kontextbudget hinzu',
			'knowledge.errors.importFailed' => ({required Object error}) => 'Import fehlgeschlagen: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Migration fehlgeschlagen: ${error}',
			'knowledge.graph.truncated' => 'gekürzt',
			'knowledge.importAll.action' => 'Alles importieren',
			'knowledge.importAll.mergeDuplicates' => 'Doppelte Einträge zusammenführen',
			'knowledge.importAll.mergeDuplicatesHint' => 'Führt doppelte Zeilen in ddagent zusammen (keine Dateien)',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Gescannte Projekte: ${count}',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Regeln: ${total} · doppelte Gruppen: ${duplicates}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Agent-Skills gefunden: ${found} (neu: ${newSkills})',
			'knowledge.importAll.title' => 'Alles in ddagent importieren',
			'knowledge.importSkills.found' => ({required Object count}) => '${count} Skill(s) bei deinen Agenten gefunden.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Neu: ${imported} · übersprungen: ${skipped}',
			'knowledge.importSkills.title' => 'Agent-Skills importieren',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Erinnerung: ${title}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Persönlich: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Regel: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Skill: ${name}',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Doppelte Gruppen über Projekte: ${count}',
			'knowledge.migrate.mergeDuplicates' => 'Duplikate zusammenführen',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Entfernt: ${removed}, hochgestuft: ${promoted}',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Regeln: ${total} gesamt, ${critical} kritisch.',
			'knowledge.migrate.scanned' => ({required Object count}) => '${count} Projekt(e) gescannt.',
			'knowledge.migrate.title' => 'Vorhandene Regeln migrieren',
			'skills.addDialog.chooseFileTitle' => 'SKILL.md wählen',
			'skills.addDialog.chooseFiles' => 'Dateien wählen',
			'skills.addDialog.chooseFolder' => 'Ordner wählen',
			'skills.addDialog.chooseFolderTitle' => 'Skill-Ordner wählen',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} Datei · ${size}', other: '${count} Dateien · ${size}', ), 
			'skills.addDialog.folderUploadsNote' => 'Bei Ordner-Uploads bleibt der ausgewählte Ordnername erhalten; einzelne Dateien verwenden `name` aus `SKILL.md`.',
			'skills.addDialog.hideInstallLocation' => 'Installationspfad ausblenden',
			'skills.addDialog.installSkill' => 'Skill installieren',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} Skill installieren', other: '${count} Skills installieren', ), 
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Markdown-Datei · ${size}',
			'skills.addDialog.pickHint' => 'Ordner können Skripte, Referenzen und Assets enthalten.',
			'skills.addDialog.pickTitle' => 'Skill-Ordner oder SKILL.md auswählen',
			'skills.addDialog.readyToInstall' => 'Bereit zur Installation',
			'skills.addDialog.removeQueued' => ({required Object name}) => '${name} entfernen',
			'skills.addDialog.title' => ({required Object provider}) => '${provider}-Skill hinzufügen',
			'skills.addDialog.uploadHint' => 'Lade eine SKILL.md-Datei oder einen kompletten Skill-Ordner hoch.',
			'skills.addDialog.whereWillThisInstall' => 'Wo wird dies installiert?',
			'skills.deleteSkill' => ({required Object name}) => '${name} löschen',
			'skills.empty.noGlobalSkills' => 'Noch keine globalen Skills gefunden',
			'skills.empty.noGlobalSkillsDescription' => 'Füge oben einen globalen Skill hinzu, damit er in allen Projekten verfügbar ist.',
			'skills.empty.noMatchingSkills' => 'Keine passenden Skills',
			'skills.empty.noMatchingSkillsDescription' => 'Versuch es mit einem anderen Befehl, Namen, Geltungsbereich, Projekt oder Quellpfad.',
			'skills.empty.noProjects' => 'Keine Projekte verfügbar',
			'skills.empty.noProjectsDescription' => 'Füge ein Projekt oder einen Workspace hinzu, um seine Skills zu durchsuchen.',
			'skills.empty.noSkillsInProject' => 'Keine Skills in diesem Projekt',
			'skills.empty.noSkillsInProjectDescription' => 'Erstelle im ausgewählten Projekt einen Ordner .claude/skills, .cursor/skills oder .agents/skills.',
			'skills.errors.addMarkdownFirst' => 'Füge zuerst eine oder mehrere Markdown-Dateien hinzu.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'SKILL.md konnte nicht aus ${name} gelesen werden.',
			'skills.errors.dropMarkdownOrFolder' => 'Zieh eine oder mehrere Markdown-Dateien oder einen Ordner mit SKILL.md hierher.',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Ein Skill-Ordner kann bis zu ${count} Dateien enthalten.',
			'skills.errors.folderReadFailed' => 'Skill-Ordner konnte nicht gelesen werden',
			'skills.errors.folderSizeLimit' => 'Ausgewählte Skill-Ordner müssen zusammen kleiner als 30 MB sein.',
			'skills.errors.importFailed' => 'Skills konnten nicht importiert werden',
			'skills.errors.missingSkillFile' => 'Der ausgewählte Ordner enthält keine SKILL.md-Datei.',
			'skills.moveDialog.moveToGlobal' => 'Nach Global verschieben',
			'skills.moveDialog.moveToProject' => 'In Projekt verschieben',
			'skills.moveDialog.toGlobalHint' => 'Verschiebe diesen Skill in das globale Skill-Verzeichnis, damit ihn jedes Projekt verwenden kann.',
			'skills.moveDialog.toProjectHint' => 'Wähle das Projekt, dem dieser Skill gehören soll. Er wird aus dem globalen Skill-Verzeichnis des Anbieters verschoben.',
			'skills.moveSkill' => ({required Object name}) => '${name} verschieben',
			'skills.projectLabel' => 'Projekt',
			'skills.scopes.admin' => 'Admin',
			'skills.scopes.plugin' => 'Plugin',
			'skills.scopes.project' => 'Projekt',
			'skills.scopes.repo' => 'Repo',
			'skills.scopes.system' => 'System',
			'skills.scopes.user' => 'Benutzer:in',
			'skills.screen.addSkill' => 'Skill hinzufügen',
			'skills.screen.clearSearch' => 'Skill-Suche leeren',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Dies entfernt das Verzeichnis ${directory} aus dem verwalteten Skill-Verzeichnis von ${provider}. Dies kann nicht rückgängig gemacht werden.',
			'skills.screen.deleteTitle' => ({required Object name}) => '${name} löschen?',
			'skills.screen.loadingSkills' => ({required Object provider}) => '${provider}-Skills werden geladen…',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Verwalte ${provider}-Skills aus lokalen Dateien, kompletten Ordnern und projektbezogenen Speicherorten.',
			'skills.screen.noDescription' => 'Keine Beschreibung im Front Matter des Skills angegeben.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Plugin: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Projekt: ${name}',
			'skills.screen.savedSuccessfully' => 'Skills erfolgreich gespeichert.',
			'skills.screen.scanningProjectSkills' => 'Projekt-Skills werden gescannt...',
			'skills.screen.searchHint' => 'Skills suchen...',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} SKILL', other: '${count} SKILLS', ), 
			'skills.screen.sourceLabel' => 'QUELLE',
			'mcp.form.fields.bearerTokenEnvVar' => 'Umgebungsvariable für Bearer-Token',
			'mcp.form.fields.envVarNames' => 'Namen der Umgebungsvariablen',
			'mcp.form.fields.workingDirectory' => 'Arbeitsverzeichnis',
			'mcp.form.scope.claudeLocal' => 'Claude lokal',
			'mcp.form.scope.description.local' => 'Wird in den Claude-Benutzereinstellungen für das ausgewählte Projekt gespeichert',
			'mcp.form.scope.description.project' => 'Wird im Arbeitsbereich des ausgewählten Projekts gespeichert',
			'mcp.form.scope.description.projectGlobal' => 'Schreibt für jeden Anbieter in den Arbeitsbereich des ausgewählten Projekts',
			'mcp.form.scope.description.user' => 'In allen Projekten auf deinem Computer verfügbar',
			'mcp.form.scope.description.userGlobal' => 'Schreibt in die Benutzerkonfiguration jedes Anbieters und ist projektübergreifend auf diesem Computer verfügbar',
			'mcp.form.scope.projectAllProviders' => 'Projekt (alle Anbieter)',
			'mcp.form.scope.userAllProviders' => 'Benutzer:in (alle Anbieter)',
			'mcp.form.submitTo' => ({required Object provider}) => 'Server zu ${provider} hinzufügen',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => '„MCP-Server hinzufügen“ unterstützt bei allen Anbietern nur stdio und http, nicht ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} unterstützt keine ${type}-MCP-Server',
			'mcp.install.button' => 'Installieren',
			'mcp.install.cardDescription' => 'Gib deinen Agenten die Wissensdatenbank und die ddagent-Werkzeuge über MCP — wähle Agenten aus oder installiere für alle.',
			'mcp.install.description' => 'Ermöglicht den ausgewählten Agenten die Nutzung der ddagent-Wissensdatenbank und -Werkzeuge über MCP.',
			'mcp.install.errorFallback' => 'Fehler',
			'mcp.install.failed' => ({required Object error}) => 'Installation fehlgeschlagen: ${error}',
			'mcp.install.installForAll' => 'Für alle installieren',
			'mcp.install.installSelected' => 'Ausgewählte installieren',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'Auf ${count} Agenten installiert.', other: 'Auf ${count} Agenten installiert.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Auf ${count} installiert; fehlgeschlagen: ${failed}',
			'mcp.install.title' => 'ddagent MCP-Server installieren',
			'mcp.servers.addGlobalDescription' => 'Fügt diesen MCP-Server zu jedem Anbieter hinzu: Claude, Cursor, Codex, OpenCode und Devin. Nur stdio- und HTTP-Transporte werden unterstützt, da dieselbe Konfiguration bei allen Anbietern funktionieren muss.',
			'mcp.servers.addGlobalMenuDescription' => '„Globalen MCP-Server hinzufügen“ schreibt einen gemeinsamen stdio- oder HTTP-Server in Claude, Cursor, Codex, OpenCode und Devin.',
			'mcp.servers.addGlobalTitle' => 'Globalen MCP-Server hinzufügen',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => '„${provider} MCP-Server hinzufügen“ ändert nur ${provider}.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => '${provider} MCP-Server hinzufügen',
			'mcp.servers.config.cwd' => 'Arbeitsverzeichnis',
			'mcp.servers.config.envVars' => 'Umgebungsvariablen',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Model Context Protocol-Server stellen ${provider} zusätzliche Werkzeuge und Datenquellen bereit',
			'mcp.servers.loading' => 'MCP-Server werden geladen...',
			'mcp.servers.refreshingScopes' => 'Projekt-Geltungsbereiche werden aktualisiert...',
			'mcp.team.cta' => 'Verfügbar mit ddagent Pro',
			'mcp.team.description' => 'Teile MCP-Server-Konfigurationen mit deinem Team. Alle bleiben automatisch synchron.',
			'mcp.team.title' => 'Team-MCP-Konfigurationen',
			'mcp.tokens.scopeWrite' => 'Schreiben',
			'terminal.actions.clearOutput' => 'Ausgabe leeren',
			'terminal.actions.connect' => 'Verbinden',
			'terminal.actions.newShell' => 'Neue Shell',
			'terminal.actions.newTab' => 'Neuer Terminal-Tab',
			'terminal.actions.providerLogin' => 'Anbieter-Anmeldung',
			'terminal.actions.restartSession' => 'Sitzung neu starten',
			'terminal.authUrl.openInBrowser' => 'Im Browser öffnen',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Link konnte nicht geöffnet werden: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'Datei erkannt: ${path}',
			'terminal.paste.hint' => 'Strg+V / Rechtsklick → Einfügen',
			'terminal.paste.title' => 'In Terminal einfügen',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.hide' => 'Tastenkürzel-Leiste ausblenden',
			'terminal.shortcuts.interrupt' => 'Unterbrechen (SIGINT)',
			'terminal.shortcuts.suspend' => 'Anhalten (SIGTSTP)',
			'terminal.shortcuts.showTooltip' => 'Tastenkürzel anzeigen',
			'terminal.shortcuts.hideTooltip' => 'Tastenkürzel ausblenden',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Anmeldung: ${provider}',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.plainShell' => 'Einfache Shell',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'worktrees.branchHint' => 'Neuer Branch-Name (z. B. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Neuer Branch von ${branch}',
			'worktrees.cleanupDescription' => 'Worktree entfernen und seinen Branch nach dem Merge löschen',
			'worktrees.created' => 'Worktree erstellt',
			'worktrees.deleteBranchLabel' => 'Branch ebenfalls löschen',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Warnung: Dieser Worktree hat ${count} nicht committete Änderungen, die verloren gehen.',
			'worktrees.emptyDescription' => 'Erstelle einen Worktree, um Feature-Arbeit oder Agent-Läufe zu isolieren.',
			'worktrees.emptyTitle' => 'Keine Worktrees gefunden',
			'worktrees.forceRemoveLabel' => 'Entfernen erzwingen (Änderungen verwerfen)',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD losgelöst bei ${sha}',
			'worktrees.mainBadge' => 'main',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Änderungen in ${branch} mergen.',
			'worktrees.mergeTitle' => ({required Object branch}) => '${branch} mergen',
			'worktrees.merged' => ({required Object branch}) => 'Worktree in ${branch} gemergt',
			'worktrees.opened' => ({required Object branch}) => 'Worktree geöffnet: ${branch}',
			'worktrees.portHint' => 'Port (optional, z. B. 3000)',
			'worktrees.removeDescription' => 'Dies löscht den Worktree-Ordner. Verknüpfte Projekte werden archiviert.',
			'worktrees.removeTitle' => ({required Object branch}) => 'Worktree ${branch} entfernen?',
			'worktrees.removed' => 'Worktree entfernt',
			'worktrees.runButton' => 'Ausführen',
			'worktrees.runHint' => 'Befehl ausführen (z. B. npm run dev)',
			'worktrees.runRunning' => 'läuft',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'läuft :${port}',
			'worktrees.scripts' => 'Skripte',
			'worktrees.scriptsSaved' => 'Skript-Konfiguration gespeichert',
			'worktrees.serverLabel' => 'Server: ',
			'worktrees.setupHint' => 'Setup-Befehl (z. B. npm install)',
			'worktrees.setupLabel' => 'Setup: ',
			'worktrees.squashDescription' => 'Alle Commits zu einem einzigen Commit zusammenfassen',
			'worktrees.stopButton' => 'Stoppen',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.chart.hide' => 'Ausblenden',
			'quota.chart.noData' => 'Nicht genug Daten für einen Trend.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} Tokens · ${cost}',
			'quota.chart.show' => 'Anzeigen',
			'quota.config.accountRouting' => 'Konto-Routing',
			'quota.config.pollerTitle' => 'Abfrage & Warnungen',
			'quota.config.save' => 'Konfiguration speichern',
			'quota.overview.tokensAndCost' => 'Tokens und Kosten',
			'quota.section.config' => 'Konfiguration',
			'scheduler.checking' => 'Wird geprüft…',
			'scheduler.cronHint' => 'Cron (Minute Stunde Tag Monat Wochentag) — z. B. 0 9 * * *',
			'scheduler.deleteMessage' => ({required Object id}) => 'Dies entfernt den wiederkehrenden Auftrag ${id}. Vorhandene Sitzungen bleiben erhalten.',
			'scheduler.deleteTitle' => 'Zeitplan löschen?',
			'scheduler.editTitle' => 'Zeitplan bearbeiten',
			'scheduler.newLabel' => 'Neu',
			'scheduler.nextIn' => ({required Object time}) => 'nächster Lauf in ${time}',
			'scheduler.promptHint' => 'Prompt für den Agenten',
			'scheduler.runs' => 'Läufe',
			'scheduler.session' => ({required Object id}) => 'Sitzung ${id}',
			'scheduler.worktree' => 'Worktree',
			'notifications.deviceLabel' => 'ddagent Flutter',
			'notifications.errors.noResponse' => 'Keine Antwort vom Server',
			'notifications.errors.registrationRejected' => 'Registrierung vom Server abgelehnt',
			'serverConnect.connect' => 'Verbinden',
			'serverConnect.connecting' => 'Verbinde…',
			'serverConnect.changeServer' => 'Server wechseln',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Verbindung fehlgeschlagen (${error})',
			'serverConnect.enterUrl' => 'Server-URL eingeben',
			'serverConnect.local.title' => 'Dieses Gerät',
			'serverConnect.local.subtitle' => 'ddagent-Server auf diesem Rechner ausführen',
			'serverConnect.local.install' => 'Lokalen Server installieren',
			'serverConnect.local.start' => 'Lokalen Server starten',
			'serverConnect.local.stop' => 'Stoppen',
			'serverConnect.local.starting' => 'Lokaler Server wird gestartet…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Server wird heruntergeladen… ${percent}%',
			'serverConnect.local.installing' => 'Wird installiert…',
			'serverConnect.local.running' => ({required Object url}) => 'Läuft unter ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Installiert (v${version})',
			'serverConnect.local.connect' => 'Diesen Server verwenden',
			'serverConnect.local.error' => ({required Object error}) => 'Fehler des lokalen Servers: ${error}',
			'serverConnect.local.or' => 'oder mit einem Remote-Server verbinden',
			'serverConnect.subtitle' => 'Mit deinem ddagent-Server verbinden',
			'voice.apiKeySaved' => 'API-Schlüssel (gespeichert, zum Ersetzen eingeben)',
			'voice.preview' => 'Vorschau',
			'voice.saveFailed' => 'STT-Konfiguration konnte nicht gespeichert werden',
			'voice.settingsSaved' => 'Spracheingabe-Einstellungen gespeichert',
			'preview.embeddedWebOnly' => 'Die eingebettete Vorschau ist im Web-Build verfügbar',
			'preview.startDevServerHint' => 'Starte einen Dev-Server (npm run dev, flutter run -d web-server…)\nund sein Port erscheint hier.',
			'sharedContext.title' => 'Gemeinsame Notizen',
			'collab.copyToken' => 'Token kopieren',
			'collab.createInvite' => 'Einladung erstellen',
			'collab.invite' => 'Einladen',
			'collab.inviteTeammate' => 'Teammitglied einladen',
			'collab.roles.member' => 'Mitglied',
			'collab.roles.viewer' => 'Betrachter:in',
			'collab.shareTokenHint' => 'Teile diesen Einladungs-Token — er wird nur einmal angezeigt und läuft in 72 Std. ab:',
			'collab.team' => 'Team',
			'browser.dialogTitle' => 'Agenten-Browser',
			'browser.viewError' => 'Fehler in der Browser-Ansicht',
			'browser.web' => 'Web',
			'projects.archive' => 'Archivieren',
			'projects.archivedSection' => ({required Object count}) => 'Archiviert (${count})',
			'projects.clone' => 'Klonen',
			'projects.cloneFailed' => 'Klonen fehlgeschlagen',
			'projects.cloneFinished' => 'Klonen abgeschlossen. Projektliste wird aktualisiert…',
			'projects.cloneRepository' => 'Repository klonen',
			'projects.deletePermanently' => 'Endgültig löschen',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Entfernt „${name}“ endgültig, einschließlich aller Sitzungen und des gespeicherten Verlaufs (JSONL wird gelöscht). Dies kann nicht rückgängig gemacht werden.',
			'projects.deleteProjectTitle' => 'Projekt löschen?',
			'projects.destinationPath' => 'Zielpfad',
			'projects.destinationPathRequired' => 'Zielpfad ist erforderlich',
			'projects.displayNameOptional' => 'Anzeigename (optional)',
			'projects.failedToLoadTokens' => 'GitHub-Token konnten nicht geladen werden',
			'projects.githubTokenOptional' => 'GitHub-Token (optional)',
			'projects.newer' => 'Neuer',
			'projects.older' => 'Älter',
			'projects.projectArchived' => 'Projekt archiviert',
			'projects.projectDeleted' => 'Projekt gelöscht',
			'projects.projectRenamed' => 'Projekt umbenannt',
			'projects.projectRestored' => 'Projekt wiederhergestellt',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.repositoryCloned' => 'Repository geklont',
			'projects.repositoryUrlRequired' => 'Repository-URL ist erforderlich',
			'projects.restore' => 'Wiederherstellen',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: '${count} Sitzung', other: '${count} Sitzungen', ), 
			'projects.unknown' => 'Unbekannt',
			'projects.usingStoredToken' => ({required Object name}) => 'Gespeicherter Token wird verwendet: ${name}',
			'sessions.activity.committingChanges' => 'Änderungen werden committet',
			'sessions.activity.editingFile' => ({required Object file}) => '${file} wird bearbeitet',
			'sessions.activity.editingFileGeneric' => 'Eine Datei wird bearbeitet',
			'sessions.activity.fetchingUrl' => ({required Object url}) => '${url} wird abgerufen',
			'sessions.activity.pushingBranch' => 'Branch wird gepusht',
			'sessions.activity.readingFile' => ({required Object file}) => '${file} wird gelesen',
			'sessions.activity.runningCommand' => ({required Object command}) => '`${command}` wird ausgeführt',
			'sessions.activity.runningShellCommand' => 'Ein Shell-Befehl wird ausgeführt',
			'sessions.activity.runningTool' => ({required Object name}) => '${name} wird ausgeführt',
			'sessions.activity.searching' => ({required Object query}) => 'Suche nach „${query}“',
			'sessions.activity.subagentRunning' => 'Subagent läuft',
			'sessions.age.days' => ({required Object days}) => '${days}T',
			'sessions.age.hours' => ({required Object hours}) => '${hours}Std.',
			'sessions.age.lessThanMinute' => '<1Min.',
			'sessions.age.minutes' => ({required Object count}) => '${count}Min.',
			'sessions.archive' => 'Archivieren',
			'sessions.archivedSessions' => 'Archivierte Sitzungen',
			'sessions.autoOrchestrator' => 'Auto (Orchestrator)',
			'sessions.compareWith' => 'Vergleichen mit…',
			'sessions.createFailed' => ({required Object error}) => 'Sitzung konnte nicht erstellt werden: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Entfernt „${name}“ und sein Transkript. Dies kann nicht rückgängig gemacht werden.',
			'sessions.newSessionProvider' => 'Neue Sitzung — Anbieter',
			'sessions.noRecentSessions' => 'Keine letzten Sitzungen',
			'sessions.noSessions' => 'Keine Sitzungen',
			'sessions.projectPath' => 'Projektpfad',
			'sessions.rename' => 'Umbenennen',
			'sessions.toasts.archived' => 'Sitzung archiviert',
			'sessions.toasts.deleted' => 'Sitzung gelöscht',
			'sessions.toasts.pinned' => 'Sitzung angeheftet',
			'sessions.toasts.renamed' => 'Sitzung umbenannt',
			'sessions.toasts.restored' => 'Sitzung wiederhergestellt',
			'sessions.toasts.unpinned' => 'Sitzung gelöst',
			'sessions.toasts.workspaceChanged' => 'Workspace geändert',
			'git.aiButton' => '✦ KI',
			'git.checkpoints.create' => 'Neu',
			'git.checkpoints.empty' => 'Noch keine Checkpoints',
			'git.checkpoints.labelHint' => 'Checkpoint-Label (optional)',
			'git.checkpoints.restoreMessage' => 'Arbeitsverzeichnis auf diesen Checkpoint zurücksetzen? Aktuelle Änderungen werden ersetzt.',
			'git.checkpoints.restoreTitle' => 'Checkpoint wiederherstellen',
			'git.checkpoints.restored' => 'Checkpoint wiederhergestellt',
			'git.checkpoints.title' => 'Checkpoints',
			'git.commitCreated' => 'Commit erstellt',
			'git.commitMessage' => 'Commit-Nachricht',
			'git.deleteFile' => 'Datei löschen',
			'git.hunkStage' => '+ Hunk',
			'git.hunkUnstage' => '− Hunk',
			'git.largeDiff' => 'Große Diff-Vorschau: Die Darstellung ist begrenzt, damit der Tab reaktionsschnell bleibt.',
			'git.loadDiffFailed' => ({required Object error}) => 'Diff konnte nicht geladen werden: ${error}',
			'git.noBranch' => 'kein Branch',
			'git.noDiff' => 'Kein Diff verfügbar',
			'git.selectProject' => 'Projekt auswählen',
			'git.splitDiff' => 'Nebeneinander',
			'git.stageHunk' => 'Hunk stagen',
			'git.stagedChanges' => 'Vorgemerkte Änderungen',
			'git.statusStaged' => 'Vorgemerkt',
			'git.switchBranch' => 'Branch wechseln',
			'git.unifiedDiff' => 'Einheitlich',
			'git.unstageHunk' => 'Hunk unstagen',
			'kanban.card.untitled' => 'Unbenannt',
			'kanban.comments.add' => 'Kommentar hinzufügen',
			'kanban.comments.empty' => 'Noch keine Kommentare',
			'kanban.details.status' => ({required Object status}) => 'Status: ${status}',
			'kanban.details.title' => 'Kartendetails',
			'kanban.dialog.saving' => 'Speichern…',
			'kanban.empty.noProject' => 'Kein Projekt ausgewählt',
			'kanban.saveFailed' => 'Karte konnte nicht gespeichert werden',
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'vor 1 Tag', other: 'vor ${count} Tagen', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'vor 1 Stunde', other: 'vor ${count} Stunden', ), 
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'vor 1 Minute', other: 'vor ${count} Minuten', ), 
			'kanban.time.now' => 'jetzt',
			'onboarding.agents.description' => 'Melde dich bei einem oder mehreren KI-Programmierassistenten an. Alle sind optional.',
			'onboarding.agents.laterHint' => 'Du kannst diese später in den Einstellungen konfigurieren.',
			'onboarding.agents.title' => 'Verbinde deine KI-Agenten',
			'onboarding.completeSetup' => 'Einrichtung abschließen',
			'onboarding.errors.invalidEmail' => 'Bitte gib eine gültige E-Mail-Adresse ein.',
			'onboarding.errors.nameAndEmailRequired' => 'Git-Name und E-Mail sind beide erforderlich.',
			'onboarding.gitHint' => 'Wird für Commits verwendet, die von ddagent-Sitzungen erstellt werden.',
			'onboarding.mcp.description' => 'Installiere den ddagent MCP-Server, damit deine Agenten die Wissensdatenbank und die ddagent-Werkzeuge nutzen können. Wähle Agenten aus oder installiere für alle.',
			'onboarding.mcp.installForAll' => 'Für alle installieren',
			'onboarding.mcp.installSelected' => 'Ausgewählte installieren',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('de'))(count, one: 'Auf ${count} Agenten installiert.', other: 'Auf ${count} Agenten installiert.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Auf ${installedCount} installiert; fehlgeschlagen: ${failed}',
			'onboarding.mcp.laterHint' => 'Optional — du kannst dies auch später unter Einstellungen → MCP installieren.',
			'onboarding.mcp.title' => 'Agenten mit ddagent verbinden',
			'fileTree.browseServerFilesystem' => 'Server-Dateisystem durchsuchen',
			'fileTree.chooseFolder' => 'Ordner wählen',
			'fileTree.copyContents' => 'Inhalt kopieren',
			'fileTree.noFiles' => 'Keine Dateien',
			'fileTree.search.hint' => 'Namen filtern / Enter, um Inhalte zu durchsuchen',
			'fileTree.search.noMatches' => 'Keine Treffer',
			'fileTree.search.prompt' => 'Suchbegriff eingeben und Enter drücken',
			'fileTree.search.resultsTruncated' => 'Ergebnisse gekürzt',
			'fileTree.titles.delete' => ({required Object name}) => '${name} löschen',
			'fileTree.titles.download' => ({required Object name}) => '${name} herunterladen',
			'fileTree.titles.rename' => ({required Object name}) => '${name} umbenennen',
			'fileTree.uploadHere' => 'Hier hochladen',
			'fileTree.uploadTo' => 'Hochladen nach',
			'fileTree.uploadedCount' => ({required Object count}) => '${count} Datei(en) hochgeladen',
			'fileTree.newName' => 'Neuer Name',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Kein registriertes Projekt: ${path}',
			'fileTree.showGitignoredFiles' => 'Gitignorierte Dateien anzeigen',
			'fileTree.hideGitignoredFiles' => 'Gitignorierte Dateien ausblenden',
			'fileTree.downloadUnsupportedOnWeb' => 'Download im Web nicht unterstützt',
			'fileTree.saveToPath' => 'Unter Pfad speichern',
			'fileTree.savedTo' => ({required Object path}) => 'Gespeichert unter ${path}',
			'workspace.archivedWorkspaceName' => 'Archiviert',
			'workspace.closePane' => 'Bereich schließen',
			'workspace.closeSearch' => 'Suche schließen',
			'workspace.deleteSessionNotice' => 'Entfernt die Sitzung und ihr Transkript. Kann nicht rückgängig gemacht werden.',
			'workspace.exportChat' => 'Chat exportieren',
			'workspace.jumpToSession' => 'Zur Sitzung springen…',
			'workspace.newChatProvider' => 'Neuer Chat — Anbieter',
			'workspace.nextMatch' => 'Nächster Treffer',
			'workspace.previousMatch' => 'Vorheriger Treffer',
			'workspace.searchTranscript' => 'Transkript durchsuchen',
			'workspace.sendTo' => ({required Object count}) => 'An ${count} senden',
			'workspace.accountWithLabel' => ({required Object label}) => 'Standard · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Beende den Lauf, bevor du den Arbeitsbereich wechselst',
			'workspace.restored' => 'Arbeitsbereich wiederhergestellt',
			'workspace.maximizePane' => 'Bereich maximieren',
			'workspace.restorePanes' => 'Bereiche wiederherstellen',
			'workspace.reviewChangedFiles' => 'Geänderte Dateien überprüfen',
			_ => null,
		};
	}
}
