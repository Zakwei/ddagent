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
class TranslationsIt extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsIt({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.it,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <it>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsIt _root = this; // ignore: unused_field

	@override 
	TranslationsIt $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsIt(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$it auth = Translations$auth$it._(_root);
	@override late final Translations$chat$it chat = Translations$chat$it._(_root);
	@override late final Translations$codeEditor$it codeEditor = Translations$codeEditor$it._(_root);
	@override late final Translations$common$it common = Translations$common$it._(_root);
	@override late final Translations$settings$it settings = Translations$settings$it._(_root);
	@override late final Translations$sidebar$it sidebar = Translations$sidebar$it._(_root);
	@override late final Translations$tasks$it tasks = Translations$tasks$it._(_root);
	@override late final Translations$knowledge$it knowledge = Translations$knowledge$it._(_root);
	@override late final Translations$skills$it skills = Translations$skills$it._(_root);
	@override late final Translations$mcp$it mcp = Translations$mcp$it._(_root);
	@override late final Translations$terminal$it terminal = Translations$terminal$it._(_root);
	@override late final Translations$worktrees$it worktrees = Translations$worktrees$it._(_root);
	@override late final Translations$quota$it quota = Translations$quota$it._(_root);
	@override late final Translations$scheduler$it scheduler = Translations$scheduler$it._(_root);
	@override late final Translations$notifications$it notifications = Translations$notifications$it._(_root);
	@override late final Translations$serverConnect$it serverConnect = Translations$serverConnect$it._(_root);
	@override late final Translations$voice$it voice = Translations$voice$it._(_root);
	@override late final Translations$sharedContext$it sharedContext = Translations$sharedContext$it._(_root);
	@override late final Translations$collab$it collab = Translations$collab$it._(_root);
	@override late final Translations$browser$it browser = Translations$browser$it._(_root);
	@override late final Translations$projects$it projects = Translations$projects$it._(_root);
	@override late final Translations$sessions$it sessions = Translations$sessions$it._(_root);
	@override late final Translations$git$it git = Translations$git$it._(_root);
	@override late final Translations$kanban$it kanban = Translations$kanban$it._(_root);
	@override late final Translations$onboarding$it onboarding = Translations$onboarding$it._(_root);
	@override late final Translations$fileTree$it fileTree = Translations$fileTree$it._(_root);
	@override late final Translations$workspace$it workspace = Translations$workspace$it._(_root);
}

// Path: auth
class Translations$auth$it extends Translations$auth$en {
	Translations$auth$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'La sessione è scaduta. Accedi di nuovo.';
	@override late final Translations$auth$login$it login = Translations$auth$login$it._(_root);
	@override late final Translations$auth$register$it register = Translations$auth$register$it._(_root);
	@override late final Translations$auth$logout$it logout = Translations$auth$logout$it._(_root);
}

// Path: chat
class Translations$chat$it extends Translations$chat$en {
	Translations$chat$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$it codeBlock = Translations$chat$codeBlock$it._(_root);
	@override late final Translations$chat$copyMessage$it copyMessage = Translations$chat$copyMessage$it._(_root);
	@override late final Translations$chat$messageTypes$it messageTypes = Translations$chat$messageTypes$it._(_root);
	@override late final Translations$chat$tools$it tools = Translations$chat$tools$it._(_root);
	@override late final Translations$chat$search$it search = Translations$chat$search$it._(_root);
	@override late final Translations$chat$fileOperations$it fileOperations = Translations$chat$fileOperations$it._(_root);
	@override late final Translations$chat$interactive$it interactive = Translations$chat$interactive$it._(_root);
	@override late final Translations$chat$thinking$it thinking = Translations$chat$thinking$it._(_root);
	@override late final Translations$chat$json$it json = Translations$chat$json$it._(_root);
	@override late final Translations$chat$permissions$it permissions = Translations$chat$permissions$it._(_root);
	@override late final Translations$chat$todo$it todo = Translations$chat$todo$it._(_root);
	@override late final Translations$chat$plan$it plan = Translations$chat$plan$it._(_root);
	@override late final Translations$chat$usageLimit$it usageLimit = Translations$chat$usageLimit$it._(_root);
	@override late final Translations$chat$codex$it codex = Translations$chat$codex$it._(_root);
	@override late final Translations$chat$input$it input = Translations$chat$input$it._(_root);
	@override late final Translations$chat$providerSelection$it providerSelection = Translations$chat$providerSelection$it._(_root);
	@override late final Translations$chat$session$it session = Translations$chat$session$it._(_root);
	@override late final Translations$chat$shell$it shell = Translations$chat$shell$it._(_root);
	@override late final Translations$chat$claudeStatus$it claudeStatus = Translations$chat$claudeStatus$it._(_root);
	@override late final Translations$chat$projectSelection$it projectSelection = Translations$chat$projectSelection$it._(_root);
	@override late final Translations$chat$tasks$it tasks = Translations$chat$tasks$it._(_root);
	@override late final Translations$chat$voice$it voice = Translations$chat$voice$it._(_root);
	@override late final Translations$chat$composer$it composer = Translations$chat$composer$it._(_root);
	@override late final Translations$chat$splitSession$it splitSession = Translations$chat$splitSession$it._(_root);
	@override late final Translations$chat$sessionPicker$it sessionPicker = Translations$chat$sessionPicker$it._(_root);
	@override late final Translations$chat$splitWorkspace$it splitWorkspace = Translations$chat$splitWorkspace$it._(_root);
	@override late final Translations$chat$splitOverview$it splitOverview = Translations$chat$splitOverview$it._(_root);
	@override late final Translations$chat$askUserQuestion$it askUserQuestion = Translations$chat$askUserQuestion$it._(_root);
	@override late final Translations$chat$attachments$it attachments = Translations$chat$attachments$it._(_root);
	@override late final Translations$chat$checkpoint$it checkpoint = Translations$chat$checkpoint$it._(_root);
	@override late final Translations$chat$common$it common = Translations$chat$common$it._(_root);
	@override late final Translations$chat$taskMaster$it taskMaster = Translations$chat$taskMaster$it._(_root);
	@override late final Translations$chat$tokenUsage$it tokenUsage = Translations$chat$tokenUsage$it._(_root);
	@override late final Translations$chat$tool$it tool = Translations$chat$tool$it._(_root);
	@override late final Translations$chat$quotaBadge$it quotaBadge = Translations$chat$quotaBadge$it._(_root);
	@override late final Translations$chat$paneHeader$it paneHeader = Translations$chat$paneHeader$it._(_root);
	@override late final Translations$chat$broadcast$it broadcast = Translations$chat$broadcast$it._(_root);
	@override late final Translations$chat$changes$it changes = Translations$chat$changes$it._(_root);
	@override late final Translations$chat$commandResult$it commandResult = Translations$chat$commandResult$it._(_root);
	@override late final Translations$chat$commands$it commands = Translations$chat$commands$it._(_root);
	@override late final Translations$chat$export$it export = Translations$chat$export$it._(_root);
	@override late final Translations$chat$message$it message = Translations$chat$message$it._(_root);
	@override late final Translations$chat$modelLibrary$it modelLibrary = Translations$chat$modelLibrary$it._(_root);
	@override late final Translations$chat$pinFile$it pinFile = Translations$chat$pinFile$it._(_root);
	@override late final Translations$chat$permissionRequest$it permissionRequest = Translations$chat$permissionRequest$it._(_root);
}

// Path: codeEditor
class Translations$codeEditor$it extends Translations$codeEditor$en {
	Translations$codeEditor$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$it toolbar = Translations$codeEditor$toolbar$it._(_root);
	@override String loading({required Object fileName}) => 'Caricamento ${fileName}...';
	@override late final Translations$codeEditor$header$it header = Translations$codeEditor$header$it._(_root);
	@override late final Translations$codeEditor$actions$it actions = Translations$codeEditor$actions$it._(_root);
	@override late final Translations$codeEditor$footer$it footer = Translations$codeEditor$footer$it._(_root);
	@override late final Translations$codeEditor$binaryFile$it binaryFile = Translations$codeEditor$binaryFile$it._(_root);
	@override late final Translations$codeEditor$filePreview$it filePreview = Translations$codeEditor$filePreview$it._(_root);
	@override late final Translations$codeEditor$diff$it diff = Translations$codeEditor$diff$it._(_root);
	@override String get discardUnsavedChanges => 'Scartare le modifiche non salvate?';
	@override late final Translations$codeEditor$emptyState$it emptyState = Translations$codeEditor$emptyState$it._(_root);
	@override String get failedToLoad => 'Impossibile caricare il file';
	@override late final Translations$codeEditor$hexDump$it hexDump = Translations$codeEditor$hexDump$it._(_root);
	@override late final Translations$codeEditor$mediaFile$it mediaFile = Translations$codeEditor$mediaFile$it._(_root);
	@override late final Translations$codeEditor$settings$it settings = Translations$codeEditor$settings$it._(_root);
	@override String unsavedChanges({required Object name}) => 'Modifiche non salvate in ${name}';
	@override late final Translations$codeEditor$toasts$it toasts = Translations$codeEditor$toasts$it._(_root);
}

// Path: common
class Translations$common$it extends Translations$common$en {
	Translations$common$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$it buttons = Translations$common$buttons$it._(_root);
	@override late final Translations$common$tabs$it tabs = Translations$common$tabs$it._(_root);
	@override late final Translations$common$status$it status = Translations$common$status$it._(_root);
	@override late final Translations$common$messages$it messages = Translations$common$messages$it._(_root);
	@override late final Translations$common$navigation$it navigation = Translations$common$navigation$it._(_root);
	@override late final Translations$common$common$it common = Translations$common$common$it._(_root);
	@override late final Translations$common$time$it time = Translations$common$time$it._(_root);
	@override late final Translations$common$fileOperations$it fileOperations = Translations$common$fileOperations$it._(_root);
	@override late final Translations$common$mainContent$it mainContent = Translations$common$mainContent$it._(_root);
	@override late final Translations$common$fileTree$it fileTree = Translations$common$fileTree$it._(_root);
	@override late final Translations$common$projectWizard$it projectWizard = Translations$common$projectWizard$it._(_root);
	@override late final Translations$common$notifications$it notifications = Translations$common$notifications$it._(_root);
	@override late final Translations$common$versionUpdate$it versionUpdate = Translations$common$versionUpdate$it._(_root);
	@override late final Translations$common$quota$it quota = Translations$common$quota$it._(_root);
	@override late final Translations$common$actions$it actions = Translations$common$actions$it._(_root);
	@override late final Translations$common$browserPane$it browserPane = Translations$common$browserPane$it._(_root);
	@override late final Translations$common$browserUse$it browserUse = Translations$common$browserUse$it._(_root);
	@override late final Translations$common$commandPalette$it commandPalette = Translations$common$commandPalette$it._(_root);
	@override late final Translations$common$gitPanel$it gitPanel = Translations$common$gitPanel$it._(_root);
	@override late final Translations$common$sessions$it sessions = Translations$common$sessions$it._(_root);
	@override late final Translations$common$projects$it projects = Translations$common$projects$it._(_root);
	@override late final Translations$common$codeBlock$it codeBlock = Translations$common$codeBlock$it._(_root);
	@override late final Translations$common$update$it update = Translations$common$update$it._(_root);
}

// Path: settings
class Translations$settings$it extends Translations$settings$en {
	Translations$settings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Impostazioni';
	@override late final Translations$settings$changelog$it changelog = Translations$settings$changelog$it._(_root);
	@override late final Translations$settings$server$it server = Translations$settings$server$it._(_root);
	@override late final Translations$settings$updates$it updates = Translations$settings$updates$it._(_root);
	@override late final Translations$settings$tabs$it tabs = Translations$settings$tabs$it._(_root);
	@override late final Translations$settings$account$it account = Translations$settings$account$it._(_root);
	@override late final Translations$settings$mcp$it mcp = Translations$settings$mcp$it._(_root);
	@override late final Translations$settings$appearance$it appearance = Translations$settings$appearance$it._(_root);
	@override late final Translations$settings$actions$it actions = Translations$settings$actions$it._(_root);
	@override late final Translations$settings$quickSettings$it quickSettings = Translations$settings$quickSettings$it._(_root);
	@override late final Translations$settings$terminalShortcuts$it terminalShortcuts = Translations$settings$terminalShortcuts$it._(_root);
	@override late final Translations$settings$mainTabs$it mainTabs = Translations$settings$mainTabs$it._(_root);
	@override late final Translations$settings$orchestration$it orchestration = Translations$settings$orchestration$it._(_root);
	@override late final Translations$settings$notifications$it notifications = Translations$settings$notifications$it._(_root);
	@override late final Translations$settings$appearanceSettings$it appearanceSettings = Translations$settings$appearanceSettings$it._(_root);
	@override late final Translations$settings$mcpForm$it mcpForm = Translations$settings$mcpForm$it._(_root);
	@override late final Translations$settings$saveStatus$it saveStatus = Translations$settings$saveStatus$it._(_root);
	@override late final Translations$settings$footerActions$it footerActions = Translations$settings$footerActions$it._(_root);
	@override late final Translations$settings$git$it git = Translations$settings$git$it._(_root);
	@override late final Translations$settings$apiKeys$it apiKeys = Translations$settings$apiKeys$it._(_root);
	@override late final Translations$settings$tasks$it tasks = Translations$settings$tasks$it._(_root);
	@override late final Translations$settings$agents$it agents = Translations$settings$agents$it._(_root);
	@override late final Translations$settings$permissions$it permissions = Translations$settings$permissions$it._(_root);
	@override late final Translations$settings$mcpServers$it mcpServers = Translations$settings$mcpServers$it._(_root);
	@override late final Translations$settings$quota$it quota = Translations$settings$quota$it._(_root);
	@override late final Translations$settings$browser$it browser = Translations$settings$browser$it._(_root);
	@override late final Translations$settings$workspaces$it workspaces = Translations$settings$workspaces$it._(_root);
	@override late final Translations$settings$about$it about = Translations$settings$about$it._(_root);
}

// Path: sidebar
class Translations$sidebar$it extends Translations$sidebar$en {
	Translations$sidebar$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$it projects = Translations$sidebar$projects$it._(_root);
	@override late final Translations$sidebar$app$it app = Translations$sidebar$app$it._(_root);
	@override late final Translations$sidebar$sessions$it sessions = Translations$sidebar$sessions$it._(_root);
	@override late final Translations$sidebar$tooltips$it tooltips = Translations$sidebar$tooltips$it._(_root);
	@override late final Translations$sidebar$navigation$it navigation = Translations$sidebar$navigation$it._(_root);
	@override late final Translations$sidebar$actions$it actions = Translations$sidebar$actions$it._(_root);
	@override late final Translations$sidebar$branding$it branding = Translations$sidebar$branding$it._(_root);
	@override late final Translations$sidebar$status$it status = Translations$sidebar$status$it._(_root);
	@override late final Translations$sidebar$time$it time = Translations$sidebar$time$it._(_root);
	@override late final Translations$sidebar$messages$it messages = Translations$sidebar$messages$it._(_root);
	@override late final Translations$sidebar$version$it version = Translations$sidebar$version$it._(_root);
	@override late final Translations$sidebar$search$it search = Translations$sidebar$search$it._(_root);
	@override late final Translations$sidebar$deleteConfirmation$it deleteConfirmation = Translations$sidebar$deleteConfirmation$it._(_root);
	@override late final Translations$sidebar$zones$it zones = Translations$sidebar$zones$it._(_root);
	@override late final Translations$sidebar$panel$it panel = Translations$sidebar$panel$it._(_root);
	@override late final Translations$sidebar$workspace$it workspace = Translations$sidebar$workspace$it._(_root);
	@override late final Translations$sidebar$recent$it recent = Translations$sidebar$recent$it._(_root);
	@override late final Translations$sidebar$tabs$it tabs = Translations$sidebar$tabs$it._(_root);
}

// Path: tasks
class Translations$tasks$it extends Translations$tasks$en {
	Translations$tasks$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$it notConfigured = Translations$tasks$notConfigured$it._(_root);
	@override late final Translations$tasks$gettingStarted$it gettingStarted = Translations$tasks$gettingStarted$it._(_root);
	@override late final Translations$tasks$setupModal$it setupModal = Translations$tasks$setupModal$it._(_root);
	@override late final Translations$tasks$helpGuide$it helpGuide = Translations$tasks$helpGuide$it._(_root);
	@override late final Translations$tasks$search$it search = Translations$tasks$search$it._(_root);
	@override late final Translations$tasks$filters$it filters = Translations$tasks$filters$it._(_root);
	@override late final Translations$tasks$sort$it sort = Translations$tasks$sort$it._(_root);
	@override late final Translations$tasks$views$it views = Translations$tasks$views$it._(_root);
	@override late final Translations$tasks$kanban$it kanban = Translations$tasks$kanban$it._(_root);
	@override late final Translations$tasks$buttons$it buttons = Translations$tasks$buttons$it._(_root);
	@override late final Translations$tasks$prd$it prd = Translations$tasks$prd$it._(_root);
	@override late final Translations$tasks$statuses$it statuses = Translations$tasks$statuses$it._(_root);
	@override late final Translations$tasks$priorities$it priorities = Translations$tasks$priorities$it._(_root);
	@override late final Translations$tasks$noMatchingTasks$it noMatchingTasks = Translations$tasks$noMatchingTasks$it._(_root);
	@override late final Translations$tasks$board$it board = Translations$tasks$board$it._(_root);
	@override late final Translations$tasks$card$it card = Translations$tasks$card$it._(_root);
	@override late final Translations$tasks$createTask$it createTask = Translations$tasks$createTask$it._(_root);
	@override late final Translations$tasks$list$it list = Translations$tasks$list$it._(_root);
	@override late final Translations$tasks$nextTask$it nextTask = Translations$tasks$nextTask$it._(_root);
	@override late final Translations$tasks$taskDetail$it taskDetail = Translations$tasks$taskDetail$it._(_root);
	@override late final Translations$tasks$toasts$it toasts = Translations$tasks$toasts$it._(_root);
}

// Path: knowledge
class Translations$knowledge$it extends Translations$knowledge$en {
	Translations$knowledge$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conoscenza';
	@override late final Translations$knowledge$tabs$it tabs = Translations$knowledge$tabs$it._(_root);
	@override late final Translations$knowledge$common$it common = Translations$knowledge$common$it._(_root);
	@override late final Translations$knowledge$actions$it actions = Translations$knowledge$actions$it._(_root);
	@override late final Translations$knowledge$dialog$it dialog = Translations$knowledge$dialog$it._(_root);
	@override late final Translations$knowledge$fields$it fields = Translations$knowledge$fields$it._(_root);
	@override late final Translations$knowledge$dashboard$it dashboard = Translations$knowledge$dashboard$it._(_root);
	@override late final Translations$knowledge$empty$it empty = Translations$knowledge$empty$it._(_root);
	@override late final Translations$knowledge$history$it history = Translations$knowledge$history$it._(_root);
	@override late final Translations$knowledge$priorities$it priorities = Translations$knowledge$priorities$it._(_root);
	@override late final Translations$knowledge$search$it search = Translations$knowledge$search$it._(_root);
	@override late final Translations$knowledge$links$it links = Translations$knowledge$links$it._(_root);
	@override late final Translations$knowledge$tags$it tags = Translations$knowledge$tags$it._(_root);
	@override late final Translations$knowledge$contextBudget$it contextBudget = Translations$knowledge$contextBudget$it._(_root);
	@override late final Translations$knowledge$critical$it critical = Translations$knowledge$critical$it._(_root);
	@override late final Translations$knowledge$errors$it errors = Translations$knowledge$errors$it._(_root);
	@override late final Translations$knowledge$graph$it graph = Translations$knowledge$graph$it._(_root);
	@override late final Translations$knowledge$importAll$it importAll = Translations$knowledge$importAll$it._(_root);
	@override late final Translations$knowledge$importSkills$it importSkills = Translations$knowledge$importSkills$it._(_root);
	@override late final Translations$knowledge$linkOptions$it linkOptions = Translations$knowledge$linkOptions$it._(_root);
	@override late final Translations$knowledge$migrate$it migrate = Translations$knowledge$migrate$it._(_root);
}

// Path: skills
class Translations$skills$it extends Translations$skills$en {
	Translations$skills$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$skills$addDialog$it addDialog = Translations$skills$addDialog$it._(_root);
	@override String deleteSkill({required Object name}) => 'Elimina ${name}';
	@override late final Translations$skills$empty$it empty = Translations$skills$empty$it._(_root);
	@override late final Translations$skills$errors$it errors = Translations$skills$errors$it._(_root);
	@override late final Translations$skills$moveDialog$it moveDialog = Translations$skills$moveDialog$it._(_root);
	@override String moveSkill({required Object name}) => 'Sposta ${name}';
	@override String get projectLabel => 'Progetto';
	@override late final Translations$skills$scopes$it scopes = Translations$skills$scopes$it._(_root);
	@override late final Translations$skills$screen$it screen = Translations$skills$screen$it._(_root);
}

// Path: mcp
class Translations$mcp$it extends Translations$mcp$en {
	Translations$mcp$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$it form = Translations$mcp$form$it._(_root);
	@override late final Translations$mcp$install$it install = Translations$mcp$install$it._(_root);
	@override late final Translations$mcp$servers$it servers = Translations$mcp$servers$it._(_root);
	@override late final Translations$mcp$team$it team = Translations$mcp$team$it._(_root);
	@override late final Translations$mcp$tokens$it tokens = Translations$mcp$tokens$it._(_root);
}

// Path: terminal
class Translations$terminal$it extends Translations$terminal$en {
	Translations$terminal$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$actions$it actions = Translations$terminal$actions$it._(_root);
	@override late final Translations$terminal$authUrl$it authUrl = Translations$terminal$authUrl$it._(_root);
	@override late final Translations$terminal$errors$it errors = Translations$terminal$errors$it._(_root);
	@override late final Translations$terminal$fileLink$it fileLink = Translations$terminal$fileLink$it._(_root);
	@override late final Translations$terminal$paste$it paste = Translations$terminal$paste$it._(_root);
	@override late final Translations$terminal$shortcuts$it shortcuts = Translations$terminal$shortcuts$it._(_root);
	@override late final Translations$terminal$tabs$it tabs = Translations$terminal$tabs$it._(_root);
}

// Path: worktrees
class Translations$worktrees$it extends Translations$worktrees$en {
	Translations$worktrees$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get branchHint => 'Nome del nuovo branch (es. feature/login)';
	@override String branchingOff({required Object branch}) => 'Diramazione da ${branch}';
	@override String get cleanupDescription => 'Rimuovi il worktree ed elimina il branch una volta fuso';
	@override String get created => 'Worktree creato';
	@override String get deleteBranchLabel => 'Elimina anche il branch';
	@override String dirtyWarning({required Object count}) => 'Attenzione: questo worktree ha ${count} modifiche non committate che andranno perse.';
	@override String get emptyDescription => 'Crea un worktree per isolare il lavoro sulle funzionalità o le esecuzioni degli agenti.';
	@override String get emptyTitle => 'Nessun worktree trovato';
	@override String get forceRemoveLabel => 'Forza rimozione (scarta le modifiche)';
	@override String headDetachedAt({required Object sha}) => 'HEAD distaccato su ${sha}';
	@override String get mainBadge => 'main';
	@override String mergeDescription({required Object branch}) => 'Fondi le modifiche in ${branch}.';
	@override String mergeTitle({required Object branch}) => 'Fondi ${branch}';
	@override String merged({required Object branch}) => 'Worktree fuso in ${branch}';
	@override String opened({required Object branch}) => 'Worktree aperto: ${branch}';
	@override String get portHint => 'Porta di esecuzione (opzionale, es. 3000)';
	@override String get removeDescription => 'Elimina la cartella del worktree. I progetti collegati verranno archiviati.';
	@override String removeTitle({required Object branch}) => 'Rimuovere il worktree ${branch}?';
	@override String get removed => 'Worktree rimosso';
	@override String get runButton => 'Esegui';
	@override String get runHint => 'Comando di esecuzione (es. npm run dev)';
	@override String get runRunning => 'in esecuzione';
	@override String runRunningWithPort({required Object port}) => 'in esecuzione :${port}';
	@override String get scripts => 'Script';
	@override String get scriptsSaved => 'Configurazione degli script salvata';
	@override String get serverLabel => 'Server: ';
	@override String get setupHint => 'Comando di configurazione (es. npm install)';
	@override String get setupLabel => 'Configurazione: ';
	@override String get squashDescription => 'Combina tutti i commit in un unico commit';
	@override String get stopButton => 'Interrompi';
}

// Path: quota
class Translations$quota$it extends Translations$quota$en {
	Translations$quota$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$agents$it agents = Translations$quota$agents$it._(_root);
	@override late final Translations$quota$chart$it chart = Translations$quota$chart$it._(_root);
	@override late final Translations$quota$config$it config = Translations$quota$config$it._(_root);
	@override late final Translations$quota$overview$it overview = Translations$quota$overview$it._(_root);
	@override late final Translations$quota$section$it section = Translations$quota$section$it._(_root);
}

// Path: scheduler
class Translations$scheduler$it extends Translations$scheduler$en {
	Translations$scheduler$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Verifica…';
	@override String get cronHint => 'Cron (min ora giorno mese giorno della settimana) — es. 0 9 * * *';
	@override String deleteMessage({required Object id}) => 'Rimuove il job ricorrente ${id}. Le sessioni esistenti vengono conservate.';
	@override String get deleteTitle => 'Eliminare la pianificazione?';
	@override String get editTitle => 'Modifica pianificazione';
	@override String get newLabel => 'Nuova';
	@override String nextIn({required Object time}) => 'prossimo tra ${time}';
	@override String get promptHint => 'Prompt per l\'agente';
	@override String get runs => 'Esecuzioni';
	@override String session({required Object id}) => 'sessione ${id}';
	@override String get worktree => 'worktree';
}

// Path: notifications
class Translations$notifications$it extends Translations$notifications$en {
	Translations$notifications$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$it errors = Translations$notifications$errors$it._(_root);
}

// Path: serverConnect
class Translations$serverConnect$it extends Translations$serverConnect$en {
	Translations$serverConnect$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get connect => 'Connetti';
	@override String get connecting => 'Connessione…';
	@override String get changeServer => 'Cambia server';
	@override String connectionFailed({required Object error}) => 'Connessione non riuscita (${error})';
	@override String get enterUrl => 'Inserisci l\'URL del server';
	@override late final Translations$serverConnect$local$it local = Translations$serverConnect$local$it._(_root);
	@override String get subtitle => 'Connettiti al tuo server DDAgent';
}

// Path: voice
class Translations$voice$it extends Translations$voice$en {
	Translations$voice$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get apiKeySaved => 'Chiave API (salvata, inserisci per sostituire)';
	@override String get preview => 'Anteprima';
	@override String get saveFailed => 'Impossibile salvare la configurazione STT';
	@override String get settingsSaved => 'Impostazioni di input vocale salvate';
}

// Path: sharedContext
class Translations$sharedContext$it extends Translations$sharedContext$en {
	Translations$sharedContext$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Note condivise';
}

// Path: collab
class Translations$collab$it extends Translations$collab$en {
	Translations$collab$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get copyToken => 'Copia token';
	@override String get createInvite => 'Crea invito';
	@override String get invite => 'Invito';
	@override String get inviteTeammate => 'Invita un collega';
	@override late final Translations$collab$roles$it roles = Translations$collab$roles$it._(_root);
	@override String get shareTokenHint => 'Condividi questo token di invito — viene mostrato una sola volta e scade in 72h:';
	@override String get team => 'Team';
}

// Path: browser
class Translations$browser$it extends Translations$browser$en {
	Translations$browser$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Browser dell\'agente';
	@override String get viewError => 'Errore della vista browser';
	@override String get web => 'Web';
}

// Path: projects
class Translations$projects$it extends Translations$projects$en {
	Translations$projects$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get archive => 'Archivia';
	@override String archivedSection({required Object count}) => 'Archiviati (${count})';
	@override String get clone => 'Clona';
	@override String get cloneFailed => 'Clonazione non riuscita';
	@override String get cloneFinished => 'Clonazione completata. Aggiornamento dell\'elenco dei progetti…';
	@override String get cloneRepository => 'Clona repository';
	@override String get deletePermanently => 'Elimina definitivamente';
	@override String deleteProjectMessage({required Object name}) => 'Rimuove definitivamente "${name}", incluse tutte le sessioni e la cronologia memorizzata (cancellazione JSONL). L\'azione è irreversibile.';
	@override String get deleteProjectTitle => 'Eliminare il progetto?';
	@override String get destinationPath => 'Percorso di destinazione';
	@override String get destinationPathRequired => 'Il percorso di destinazione è obbligatorio';
	@override String get displayNameOptional => 'Nome visualizzato (opzionale)';
	@override String get failedToLoadTokens => 'Impossibile caricare i token GitHub';
	@override String get githubTokenOptional => 'Token GitHub (opzionale)';
	@override String get newer => 'Più recenti';
	@override String get older => 'Meno recenti';
	@override String get projectArchived => 'Progetto archiviato';
	@override String get projectDeleted => 'Progetto eliminato';
	@override String get projectRenamed => 'Progetto rinominato';
	@override String get projectRestored => 'Progetto ripristinato';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get repositoryCloned => 'Repository clonato';
	@override String get repositoryUrlRequired => 'L\'URL del repository è obbligatorio';
	@override String get restore => 'Ripristina';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} sessione',
		other: '${count} sessioni',
	);
	@override String get unknown => 'Sconosciuto';
	@override String usingStoredToken({required Object name}) => 'Usando token salvato: ${name}';
}

// Path: sessions
class Translations$sessions$it extends Translations$sessions$en {
	Translations$sessions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$sessions$activity$it activity = Translations$sessions$activity$it._(_root);
	@override late final Translations$sessions$age$it age = Translations$sessions$age$it._(_root);
	@override String get archive => 'Archivia';
	@override String get archivedSessions => 'Sessioni archiviate';
	@override String get autoOrchestrator => 'Auto (orchestratore)';
	@override String get compareWith => 'Confronta con…';
	@override String createFailed({required Object error}) => 'Creazione della sessione non riuscita: ${error}';
	@override String deleteSessionMessage({required Object name}) => 'Rimuove "${name}" e la sua trascrizione. L\'azione è irreversibile.';
	@override String get newSessionProvider => 'Nuova sessione — provider';
	@override String get noRecentSessions => 'Nessuna sessione recente';
	@override String get noSessions => 'Nessuna sessione';
	@override String get projectPath => 'Percorso del progetto';
	@override String get rename => 'Rinomina';
	@override late final Translations$sessions$toasts$it toasts = Translations$sessions$toasts$it._(_root);
}

// Path: git
class Translations$git$it extends Translations$git$en {
	Translations$git$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get aiButton => '✦ AI';
	@override late final Translations$git$checkpoints$it checkpoints = Translations$git$checkpoints$it._(_root);
	@override String get commitCreated => 'Commit creato';
	@override String get commitMessage => 'Messaggio di commit';
	@override String get deleteFile => 'Elimina file';
	@override String get hunkStage => '+ Sezione';
	@override String get hunkUnstage => '− Sezione';
	@override String get largeDiff => 'Anteprima diff di grandi dimensioni: il rendering è limitato per mantenere la scheda reattiva.';
	@override String loadDiffFailed({required Object error}) => 'Impossibile caricare il diff: ${error}';
	@override String get noBranch => 'nessun branch';
	@override String get noDiff => 'Nessun diff disponibile';
	@override String get selectProject => 'Seleziona un progetto';
	@override String get splitDiff => 'Diff affiancato';
	@override String get stageHunk => 'Metti in stage la sezione';
	@override String get stagedChanges => 'Modifiche in stage';
	@override String get statusStaged => 'In stage';
	@override String get switchBranch => 'Cambia branch';
	@override String get unifiedDiff => 'Diff unificato';
	@override String get unstageHunk => 'Togli la sezione dallo stage';
}

// Path: kanban
class Translations$kanban$it extends Translations$kanban$en {
	Translations$kanban$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$it card = Translations$kanban$card$it._(_root);
	@override late final Translations$kanban$comments$it comments = Translations$kanban$comments$it._(_root);
	@override late final Translations$kanban$details$it details = Translations$kanban$details$it._(_root);
	@override late final Translations$kanban$dialog$it dialog = Translations$kanban$dialog$it._(_root);
	@override late final Translations$kanban$empty$it empty = Translations$kanban$empty$it._(_root);
	@override String get saveFailed => 'Impossibile salvare la scheda';
	@override late final Translations$kanban$time$it time = Translations$kanban$time$it._(_root);
}

// Path: onboarding
class Translations$onboarding$it extends Translations$onboarding$en {
	Translations$onboarding$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$onboarding$agents$it agents = Translations$onboarding$agents$it._(_root);
	@override String get completeSetup => 'Completa configurazione';
	@override late final Translations$onboarding$errors$it errors = Translations$onboarding$errors$it._(_root);
	@override String get gitHint => 'Usato per i commit creati dalle sessioni DDAgent.';
	@override late final Translations$onboarding$mcp$it mcp = Translations$onboarding$mcp$it._(_root);
}

// Path: fileTree
class Translations$fileTree$it extends Translations$fileTree$en {
	Translations$fileTree$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get browseServerFilesystem => 'Sfoglia il filesystem del server';
	@override String get chooseFolder => 'Scegli cartella';
	@override String get copyContents => 'Copia contenuto';
	@override String get noFiles => 'Nessun file';
	@override late final Translations$fileTree$search$it search = Translations$fileTree$search$it._(_root);
	@override late final Translations$fileTree$titles$it titles = Translations$fileTree$titles$it._(_root);
	@override String get uploadHere => 'Carica qui';
	@override String get uploadTo => 'Carica in';
	@override String uploadedCount({required Object count}) => 'Caricati ${count} file';
	@override String get newName => 'Nuovo nome';
	@override String notRegisteredProject({required Object path}) => 'Progetto non registrato: ${path}';
	@override String get showGitignoredFiles => 'Mostra i file ignorati da git';
	@override String get hideGitignoredFiles => 'Nascondi i file ignorati da git';
	@override String get downloadUnsupportedOnWeb => 'Download non supportato sul web';
	@override String get saveToPath => 'Salva nel percorso';
	@override String savedTo({required Object path}) => 'Salvato in ${path}';
}

// Path: workspace
class Translations$workspace$it extends Translations$workspace$en {
	Translations$workspace$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get archivedWorkspaceName => 'Archiviati';
	@override String get closePane => 'Chiudi riquadro';
	@override String get closeSearch => 'Chiudi ricerca';
	@override String get deleteSessionNotice => 'Rimuove la sessione e la sua trascrizione. L\'azione è irreversibile.';
	@override String get exportChat => 'Esporta chat';
	@override String get jumpToSession => 'Vai alla sessione…';
	@override String get newChatProvider => 'Nuova chat — provider';
	@override String get nextMatch => 'Corrispondenza successiva';
	@override String get previousMatch => 'Corrispondenza precedente';
	@override String get searchTranscript => 'Cerca nella trascrizione';
	@override String sendTo({required Object count}) => 'Invia a ${count}';
	@override String accountWithLabel({required Object label}) => 'Predefinito · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Termina l\'esecuzione prima di cambiare spazio di lavoro';
	@override String get restored => 'Spazio di lavoro ripristinato';
	@override String get maximizePane => 'Ingrandisci riquadro';
	@override String get restorePanes => 'Ripristina riquadri';
	@override String get reviewChangedFiles => 'Esamina i file modificati';
}

// Path: auth.login
class Translations$auth$login$it extends Translations$auth$login$en {
	Translations$auth$login$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bentornato';
	@override String get description => 'Accedi al tuo account DDAgent self-hosted';
	@override String get username => 'Nome utente';
	@override String get password => 'Password';
	@override String get submit => 'Accedi';
	@override String get loading => 'Accesso in corso...';
	@override late final Translations$auth$login$errors$it errors = Translations$auth$login$errors$it._(_root);
	@override late final Translations$auth$login$placeholders$it placeholders = Translations$auth$login$placeholders$it._(_root);
}

// Path: auth.register
class Translations$auth$register$it extends Translations$auth$register$en {
	Translations$auth$register$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crea account';
	@override String get username => 'Nome utente';
	@override String get password => 'Password';
	@override String get confirmPassword => 'Conferma password';
	@override String get submit => 'Crea account';
	@override String get loading => 'Creazione account...';
	@override late final Translations$auth$register$errors$it errors = Translations$auth$register$errors$it._(_root);
}

// Path: auth.logout
class Translations$auth$logout$it extends Translations$auth$logout$en {
	Translations$auth$logout$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Disconnetti';
	@override String get confirm => 'Sei sicuro di volerti disconnettere?';
	@override String get button => 'Disconnetti';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$it extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copia';
	@override String get copied => 'Copiato';
	@override String get copyCode => 'Copia codice';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$it extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copia messaggio';
	@override String get copied => 'Messaggio copiato';
	@override String get failed => 'Copia non riuscita';
	@override String get selectFormat => 'Seleziona formato copia';
	@override String get copyAsMarkdown => 'Copia come markdown';
	@override String get copyAsText => 'Copia come testo';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$it extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => 'Errore';
	@override String get tool => 'Strumento';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
}

// Path: chat.tools
class Translations$chat$tools$it extends Translations$chat$tools$en {
	Translations$chat$tools$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Impostazioni strumento';
	@override String get error => 'Errore strumento';
	@override String get result => 'Risultato strumento';
	@override String get viewParams => 'Vedi parametri input';
	@override String get viewRawParams => 'Vedi parametri grezzi';
	@override String get viewDiff => 'Vedi differenze per';
	@override String get creatingFile => 'Creazione nuovo file:';
	@override String get updatingTodo => 'Aggiornamento lista attività';
	@override String get read => 'Leggi';
	@override String get readFile => 'Leggi file';
	@override String get updateTodo => 'Aggiorna lista attività';
	@override String get readTodo => 'Leggi lista attività';
	@override String get searchResults => 'risultati';
	@override String get todoReadLabel => 'Lista attività di TodoRead';
}

// Path: chat.search
class Translations$chat$search$it extends Translations$chat$search$en {
	Translations$chat$search$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => 'Trovati ${count} ${type}';
	@override String get file => 'file';
	@override String get files => 'file';
	@override String get pattern => 'pattern:';
	@override String get kIn => 'in:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$it extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get updated => 'File aggiornato con successo';
	@override String get created => 'File creato con successo';
	@override String get written => 'File scritto con successo';
	@override String get diff => 'Differenze';
	@override String get newFile => 'Nuovo file';
	@override String get viewContent => 'Vedi contenuto file';
	@override String viewFullOutput({required Object count}) => 'Vedi output completo (${count} caratteri)';
	@override String get contentDisplayed => 'Il contenuto del file è visualizzato nella vista differenze sopra';
}

// Path: chat.interactive
class Translations$chat$interactive$it extends Translations$chat$interactive$en {
	Translations$chat$interactive$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Prompt interattivo';
	@override String get waiting => 'In attesa della tua risposta nella CLI';
	@override String get instruction => 'Seleziona un\'opzione nel terminale dove Claude è in esecuzione.';
	@override String selectedOption({required Object number}) => '✓ Claude ha selezionato l\'opzione ${number}';
	@override String get instructionDetail => 'Nella CLI, selezioneresti questa opzione interattivamente usando i tasti freccia o digitando il numero.';
}

// Path: chat.thinking
class Translations$chat$thinking$it extends Translations$chat$thinking$en {
	Translations$chat$thinking$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sto pensando...';
	@override String get emoji => '💭 Sto pensando...';
}

// Path: chat.json
class Translations$chat$json$it extends Translations$chat$json$en {
	Translations$chat$json$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get response => 'Risposta JSON';
}

// Path: chat.permissions
class Translations$chat$permissions$it extends Translations$chat$permissions$en {
	Translations$chat$permissions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => 'Concedi permesso per ${tool}';
	@override String get added => 'Permesso aggiunto';
	@override String addTo({required Object entry}) => 'Aggiunge ${entry} agli strumenti consentiti.';
	@override String get retry => 'Permesso salvato. Riprova la richiesta per usare lo strumento.';
	@override String get error => 'Impossibile aggiornare i permessi. Riprova.';
	@override String get openSettings => 'Apri impostazioni';
	@override String get allow => 'Consenti';
	@override String allowAll({required Object count}) => 'Consenti tutto (${count})';
	@override String get allowWithChanges => 'Consenti con modifiche';
	@override String get always => 'Sempre';
	@override String get deny => 'Nega';
	@override String get editAndAllow => 'Modifica e consenti';
	@override String get editInput => 'Modifica input';
	@override String get invalidJson => 'JSON non valido';
	@override String get reject => 'Rifiuta';
}

// Path: chat.todo
class Translations$chat$todo$it extends Translations$chat$todo$en {
	Translations$chat$todo$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Lista attività aggiornata con successo';
	@override String get current => 'Lista attività corrente';
}

// Path: chat.plan
class Translations$chat$plan$it extends Translations$chat$plan$en {
	Translations$chat$plan$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Vedi piano di implementazione';
	@override String get title => 'Piano di implementazione';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$it extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Limite di utilizzo Claude raggiunto. Il tuo limite verrà ripristinato alle **${time} ${timezone}** - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$it extends Translations$chat$codex$en {
	Translations$chat$codex$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Modalità permessi';
	@override late final Translations$chat$codex$modes$it modes = Translations$chat$codex$modes$it._(_root);
	@override late final Translations$chat$codex$descriptions$it descriptions = Translations$chat$codex$descriptions$it._(_root);
	@override String get technicalDetails => 'Dettagli tecnici';
}

// Path: chat.input
class Translations$chat$input$it extends Translations$chat$input$en {
	Translations$chat$input$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Digita / per i comandi, @ per i file, o chiedi qualcosa a ${provider}...';
	@override String get placeholderDefault => 'Scrivi il tuo messaggio...';
	@override String get disabled => 'Input disabilitato';
	@override String get attachFiles => 'Allega file';
	@override String get attachImages => 'Allega immagini';
	@override String get send => 'Invia';
	@override String get stop => 'Ferma';
	@override late final Translations$chat$input$hintText$it hintText = Translations$chat$input$hintText$it._(_root);
	@override String get clickToChangeMode => 'Clicca per cambiare la modalità permessi';
	@override String get showAllCommands => 'Mostra tutti i comandi';
	@override String get clearInput => 'Cancella input';
	@override String get scrollToBottom => 'Scorri in basso';
	@override String get attachFilesDesc => 'Carica foto, file o documenti';
	@override String get takePhoto => 'Scatta foto';
	@override String get takePhotoDesc => 'Usa la fotocamera per scattare una foto';
	@override String get moreTools => 'Altri strumenti';
	@override String get commandsDesc => 'Esplora scorciatoie e comandi';
	@override String get clearInputDesc => 'Scarta il testo corrente';
	@override String get newMessage => 'Nuovo messaggio';
	@override String get newMessages => 'Nuovi messaggi';
	@override late final Translations$chat$input$queue$it queue = Translations$chat$input$queue$it._(_root);
	@override String get autoContinueTasks => 'Continuazione automatica';
	@override String get autoContinueTasksTooltip => 'Attiva per lasciare che Devin passi automaticamente all’attività Task Master successiva';
	@override late final Translations$chat$input$offlineQueue$it offlineQueue = Translations$chat$input$offlineQueue$it._(_root);
	@override String cameraUnavailable({required Object error}) => 'Fotocamera non disponibile: ${error}';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$it extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Scegli il tuo assistente AI';
	@override String get description => 'Seleziona un provider per iniziare una nuova conversazione';
	@override String get selectModel => 'Seleziona modello';
	@override late final Translations$chat$providerSelection$providerInfo$it providerInfo = Translations$chat$providerSelection$providerInfo$it._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$it readyPrompt = Translations$chat$providerSelection$readyPrompt$it._(_root);
	@override String pressToSearch({required Object shortcut}) => 'Premi <kbd>${shortcut}</kbd> per cercare sessioni, file e commit';
	@override String get workspace => 'Spazio di lavoro';
	@override String get noWorkspace => 'Nessuno';
	@override String get clickToChangeWorkspace => 'Clicca per cambiare spazio di lavoro';
	@override String get chooseWorkspace => 'Scegli uno spazio di lavoro';
	@override String get searchWorkspaces => 'Cerca spazi di lavoro...';
	@override String get noWorkspacesFound => 'Nessuno spazio di lavoro trovato.';
	@override String get all => 'Tutti';
	@override String get free => 'Gratuiti';
	@override String get noModelsFound => 'Nessun modello trovato.';
	@override String get paid => 'A pagamento';
	@override String get searchModels => 'Cerca modelli...';
	@override String get addModel => 'Aggiungi modello';
	@override String get chooseModel => 'Scegli un modello';
	@override String get chooseModelDescription => 'Modelli integrati e personalizzati in un’unica lista';
	@override String get clickToChange => 'Clicca per cambiare modello';
	@override String get favorites => 'Preferiti';
	@override String get loadingModels => 'Caricamento modelli…';
	@override String get manageModels => 'Gestisci modelli';
	@override String get refresh => 'Aggiorna modelli';
}

// Path: chat.session
class Translations$chat$session$it extends Translations$chat$session$en {
	Translations$chat$session$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$it kContinue = Translations$chat$session$kContinue$it._(_root);
	@override late final Translations$chat$session$loading$it loading = Translations$chat$session$loading$it._(_root);
	@override late final Translations$chat$session$messages$it messages = Translations$chat$session$messages$it._(_root);
	@override String get deleteConfirm => 'Rimuove la sessione e la sua trascrizione. L\'azione è irreversibile.';
	@override String get finishRunBeforeWorkspaceChange => 'Termina l\'esecuzione prima di cambiare spazio di lavoro';
}

// Path: chat.shell
class Translations$chat$shell$it extends Translations$chat$shell$en {
	Translations$chat$shell$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$it selectProject = Translations$chat$shell$selectProject$it._(_root);
	@override late final Translations$chat$shell$status$it status = Translations$chat$shell$status$it._(_root);
	@override late final Translations$chat$shell$actions$it actions = Translations$chat$shell$actions$it._(_root);
	@override String get loading => 'Caricamento terminale...';
	@override String get connecting => 'Connessione alla shell...';
	@override String get startSession => 'Avvia una nuova sessione Claude';
	@override String resumeSession({required Object displayName}) => 'Riprendi sessione: ${displayName}...';
	@override String runCommand({required Object command, required Object projectName}) => 'Esegui ${command} in ${projectName}';
	@override String startCli({required Object projectName}) => 'Avvio Claude CLI in ${projectName}';
	@override String get defaultCommand => 'comando';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$it extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$it actions = Translations$chat$claudeStatus$actions$it._(_root);
	@override late final Translations$chat$claudeStatus$state$it state = Translations$chat$claudeStatus$state$it._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$it elapsed = Translations$chat$claudeStatus$elapsed$it._(_root);
	@override late final Translations$chat$claudeStatus$controls$it controls = Translations$chat$claudeStatus$controls$it._(_root);
	@override late final Translations$chat$claudeStatus$providers$it providers = Translations$chat$claudeStatus$providers$it._(_root);
	@override String get stop => 'Ferma';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} attività in background in corso',
		other: '${count} attività in background in corso',
	);
	@override String get backgroundTasksTitle => 'In esecuzione in background';
	@override String get backgroundTaskUnnamed => 'Attività senza nome';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$it extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'Seleziona un progetto per iniziare a chattare con ${provider}';
}

// Path: chat.tasks
class Translations$chat$tasks$it extends Translations$chat$tasks$en {
	Translations$chat$tasks$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Inizia l\'attività successiva';
}

// Path: chat.voice
class Translations$chat$voice$it extends Translations$chat$voice$en {
	Translations$chat$voice$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Leggi le risposte ad alta voce';
	@override String get autoReadOn => 'Lettura risposte: attivata';
	@override String get autoReadOff => 'Lettura risposte: disattivata';
	@override String get autoReadVoice => 'Voce di lettura';
	@override String get autoReadVoiceAuto => 'Voce automatica';
	@override String get autoReadPreview => 'Ecco come suoneranno le risposte.';
	@override String get speakMessage => 'Leggi ad alta voce';
	@override String get stopSpeaking => 'Interrompi lettura';
}

// Path: chat.composer
class Translations$chat$composer$it extends Translations$chat$composer$en {
	Translations$chat$composer$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Strumenti e azioni';
	@override String get toolsAndActionsDesc => 'Strumenti e controlli per l’editor di chat';
	@override String get reasoning => 'Ragionamento';
	@override String get model => 'Modello';
	@override String get effortDefault => 'Predefinito';
	@override String get loadingModels => 'Caricamento modelli…';
	@override String get modelMenu => 'Seleziona modello e sforzo di ragionamento';
	@override String permissionHeading({required Object provider}) => 'Come devono essere approvate le azioni di ${provider}?';
	@override String get favorites => 'Preferiti';
}

// Path: chat.splitSession
class Translations$chat$splitSession$it extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Dividi sessione';
	@override String get close => 'Chiudi sessione divisa';
	@override String get selectSession => 'Seleziona sessione da confrontare';
	@override String get noOtherSessions => 'Nessun’altra sessione disponibile';
	@override String get newSessionOption => '+ Nuova sessione in vista divisa';
	@override String currentProjectGroup({required Object name}) => 'Progetto corrente (${name})';
	@override String get otherProjectsGroup => 'Altri progetti';
	@override String get recentSessionsGroup => 'Sessioni recenti';
	@override String get startNewSession => 'Avvia nuova sessione in vista divisa';
	@override String get selectFromList => 'Seleziona una sessione dall’elenco delle sessioni esistenti';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$it extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleziona sessione';
	@override String get searchPlaceholder => 'Cerca sessioni...';
	@override String get clearSearch => 'Cancella ricerca';
	@override String get newChat => '+ Nuova chat';
	@override String get archivedToggle => 'Archiviate';
	@override String get changeSession => 'Cambia sessione';
	@override String get archivedLoading => 'Caricamento sessioni archiviate...';
	@override String get archivedError => 'Impossibile caricare le sessioni archiviate';
	@override String get archivedEmpty => 'Nessuna sessione archiviata';
	@override String get archivedProjectOnly => 'Spazio di lavoro archiviato — ripristinalo per vedere le sue sessioni.';
	@override String get emptySearch => 'Nessuna sessione corrisponde alla ricerca';
	@override String get restore => 'Ripristina';
	@override String get restoreSession => 'Ripristina sessione';
	@override String get restoreProject => 'Ripristina spazio di lavoro';
	@override String get restoreSessionFailed => 'Ripristino della sessione non riuscito. Riprova.';
	@override String get restoreProjectFailed => 'Ripristino dello spazio di lavoro non riuscito. Riprova.';
	@override String get archiveFailed => 'Archiviazione della sessione non riuscita. Riprova.';
	@override String get deleteFailed => 'Eliminazione della sessione non riuscita. Riprova.';
	@override String get running => 'Sessione in esecuzione';
	@override String get unread => 'Non letta — terminata con nuovo output';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$it extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Aggiungi riquadro chat';
	@override String get addBrowser => 'Aggiungi riquadro browser';
	@override String get addTerminal => 'Aggiungi riquadro terminale';
	@override String get overview => 'Mostra tutti i riquadri';
	@override String get exitFocusMode => 'Esci dalla modalità focus (Ctrl+Maiusc+F)';
	@override String get focusMode => 'Modalità focus (Ctrl+Maiusc+F)';
	@override String get browseSessions => 'Apri l\'elenco delle sessioni';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$it extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Panoramica dei riquadri divisi';
	@override String count({required Object count}) => '${count} riquadri';
	@override String get close => 'Chiudi panoramica';
	@override String get question => 'DOMANDA — input richiesto';
	@override String get processing => 'ELABORAZIONE';
	@override String get idle => 'Inattivo';
	@override String get active => 'Attiva';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$it extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} ha bisogno del tuo input';
	@override String get answerHint => 'Digita la tua risposta…';
	@override String get other => 'Altro…';
	@override String get skip => 'Salta';
}

// Path: chat.attachments
class Translations$chat$attachments$it extends Translations$chat$attachments$en {
	Translations$chat$attachments$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Download non riuscito — clicca per riprovare';
	@override String get fileAttachment => 'Allegato file';
	@override String download({required Object name}) => 'Scarica ${name}';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$it extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Creazione snapshot…';
	@override String get revertChanges => 'Ripristina i file all’ultimo checkpoint';
	@override String get undo => 'Annulla checkpoint';
	@override String get beforeAiTurn => 'prima del turno AI';
}

// Path: chat.common
class Translations$chat$common$it extends Translations$chat$common$en {
	Translations$chat$common$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get close => 'Chiudi';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$it extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Attività';
	@override String get saved => 'Salvato';
	@override String get saving => 'Salvataggio...';
	@override String get taskShort => 'TASK';
	@override String get addToTask => 'Aggiungi a TaskMaster';
	@override String get added => 'Aggiunto a TaskMaster';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$it extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Vedi il consumo di token della sessione';
	@override String get title => 'Utilizzo dei token';
}

// Path: chat.tool
class Translations$chat$tool$it extends Translations$chat$tool$en {
	Translations$chat$tool$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(nessun output per ora — lo strumento ha restituito un risultato vuoto)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$it extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Limiti dell\'abbonamento';
	@override String get noData => 'Nessun dato sull’abbonamento per questo modello';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$it extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Elaborazione…';
	@override String get switchSession => 'Cambia sessione';
}

// Path: chat.broadcast
class Translations$chat$broadcast$it extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => 'Seleziona orchestratori';
	@override String get orchestratorsOnly => 'Solo orchestratori';
	@override String get noOrchestrators => 'Nessuna sessione di orchestrazione disponibile';
}

// Path: chat.changes
class Translations$chat$changes$it extends Translations$chat$changes$en {
	Translations$chat$changes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Nessuna modifica ai file';
	@override String get failedToLoad => 'Impossibile caricare le modifiche';
}

// Path: chat.commandResult
class Translations$chat$commandResult$it extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$it fallback = Translations$chat$commandResult$fallback$it._(_root);
	@override String get filterCommands => 'Filtra comandi...';
	@override String searchModels({required Object provider}) => 'Cerca modelli ${provider}...';
}

// Path: chat.commands
class Translations$chat$commands$it extends Translations$chat$commands$en {
	Translations$chat$commands$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'Eseguire il comando?';
	@override String get executionCancelled => 'Esecuzione del comando annullata';
}

// Path: chat.export
class Translations$chat$export$it extends Translations$chat$export$en {
	Translations$chat$export$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Sessione ${id}';
	@override String get pdfFailed => 'Esportazione PDF non riuscita';
	@override String get transcriptDownloaded => 'Trascrizione scaricata';
	@override String savedTo({required Object path}) => 'Salvato ${path}';
}

// Path: chat.message
class Translations$chat$message$it extends Translations$chat$message$en {
	Translations$chat$message$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Riepilogo compattato';
	@override String get rawView => 'Vista grezza';
	@override String get resendHint => 'Reinvia dal compositore';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$it extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String deleteTooltip({required Object name}) => 'Elimina ${name}';
	@override String editTooltip({required Object name}) => 'Modifica ${name}';
	@override String get enterNameAndId => 'Inserisci sia il nome del modello sia l\'ID del modello.';
	@override String get idNoSpaces => 'Gli ID dei modelli non possono contenere spazi.';
	@override String get setAsDefault => 'Imposta come predefinito';
	@override String get defaultModel => 'Modello predefinito';
}

// Path: chat.pinFile
class Translations$chat$pinFile$it extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get action => 'Fissa';
	@override String get pathHint => 'path/to/file.ext';
	@override String get title => 'Fissa file';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$it extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'Richiesta di permesso · ${tool}';
	@override String get question => 'Domanda';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$it extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get changes => 'modifiche';
	@override String get previousChange => 'Modifica precedente';
	@override String get nextChange => 'Modifica successiva';
	@override String get hideDiff => 'Nascondi evidenziazione differenze';
	@override String get showDiff => 'Mostra evidenziazione differenze';
	@override String get settings => 'Impostazioni editor';
	@override String get collapse => 'Comprimi editor';
	@override String get expand => 'Espandi editor a larghezza piena';
	@override String get diffMerge => 'Diff / merge';
	@override String get previewInBrowser => 'Anteprima nel browser';
	@override String get reload => 'Ricarica dal disco';
	@override String get toggleDock => 'Attiva/disattiva dock file';
}

// Path: codeEditor.header
class Translations$codeEditor$header$it extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Visualizzazione modifiche';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$it extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Copia percorso file';
	@override String get pathCopied => 'Percorso file copiato';
	@override String get download => 'Scarica file';
	@override String get save => 'Salva';
	@override String get saving => 'Salvataggio...';
	@override String get saved => 'Salvato!';
	@override String get exitFullscreen => 'Esci dalla modalità schermo intero';
	@override String get fullscreen => 'Schermo intero';
	@override String get close => 'Chiudi';
	@override String get previewMarkdown => 'Anteprima markdown';
	@override String get editMarkdown => 'Modifica markdown';
	@override String get pinFile => 'Fissa file al contesto';
	@override String get unpinFile => 'Rimuovi file dal contesto';
	@override String get previewHtml => 'Apri anteprima HTML in una nuova scheda';
	@override String get retry => 'Riprova';
	@override String get saveAll => 'Salva tutto';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$it extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Righe:';
	@override String get characters => 'Caratteri:';
	@override String get shortcuts => 'Premi Ctrl+S per salvare • Esc per chiudere';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$it extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'File binario';
	@override String message({required Object fileName}) => 'Il file "${fileName}" non può essere visualizzato nell\'editor di testo perché è un file binario.';
	@override String get cannotDisplayAsText => 'Impossibile visualizzare come testo';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$it extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Caricamento anteprima...';
	@override String get error => 'Impossibile visualizzare questo file.';
	@override String get openInNewTab => 'Apri in una nuova scheda';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$it extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get applyMerge => 'Applica merge';
	@override String get base => 'Base';
	@override String get close => 'Chiudi diff';
	@override String get current => 'Corrente';
	@override String hunk({required Object number}) => 'Sezione ${number}';
	@override String get noChanges => 'Nessuna modifica';
	@override String get deletedOnDisk => 'eliminato dal disco';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$it extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nessun file aperto';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$it extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… altri ${size}';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$it extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'L\'anteprima audio/video non è ancora supportata';
	@override String get title => 'File multimediale';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$it extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String fontSizeDecrease({required Object size}) => 'Dimensione carattere −  (ora ${size})';
	@override String get fontSizeIncrease => 'Dimensione carattere +';
	@override String get minimap => 'Minimappa';
	@override String tabSize({required Object size}) => 'Dimensione tabulazione: ${size}';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$it extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => 'Salvato ${name}';
	@override String get saveFailed => 'Salvataggio non riuscito';
	@override String get allSaved => 'Tutto salvato';
	@override String get someSavesFailed => 'Alcuni salvataggi non riusciti';
	@override String savedTo({required Object path}) => 'Salvato in ${path}';
	@override String get mergeApplied => 'Merge applicato — salva per conservare le modifiche';
}

// Path: common.buttons
class Translations$common$buttons$it extends Translations$common$buttons$en {
	Translations$common$buttons$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get save => 'Salva';
	@override String get cancel => 'Annulla';
	@override String get delete => 'Elimina';
	@override String get create => 'Crea';
	@override String get edit => 'Modifica';
	@override String get close => 'Chiudi';
	@override String get confirm => 'Conferma';
	@override String get submit => 'Invia';
	@override String get retry => 'Riprova';
	@override String get refresh => 'Aggiorna';
	@override String get search => 'Cerca';
	@override String get clear => 'Cancella';
	@override String get copy => 'Copia';
	@override String get download => 'Scarica';
	@override String get upload => 'Carica';
	@override String get browse => 'Sfoglia';
	@override String get openDiagram => 'Apri diagramma';
	@override String get update => 'Aggiorna';
}

// Path: common.tabs
class Translations$common$tabs$it extends Translations$common$tabs$en {
	Translations$common$tabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get shell => 'Terminale';
	@override String get files => 'File';
	@override String get git => 'Controllo Versione';
	@override String get tasks => 'Attività';
	@override String get browser => 'Browser';
	@override String get computer => 'Computer';
	@override String get board => 'Bacheca';
	@override String get usage => 'AI Control';
}

// Path: common.status
class Translations$common$status$it extends Translations$common$status$en {
	Translations$common$status$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Caricamento...';
	@override String get success => 'Completato';
	@override String get error => 'Errore';
	@override String get failed => 'Fallito';
	@override String get pending => 'In attesa';
	@override String get completed => 'Completato';
	@override String get inProgress => 'In corso';
}

// Path: common.messages
class Translations$common$messages$it extends Translations$common$messages$en {
	Translations$common$messages$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Salvato con successo';
	@override String get deletedSuccessfully => 'Eliminato con successo';
	@override String get updatedSuccessfully => 'Aggiornato con successo';
	@override String get operationFailed => 'Operazione fallita';
	@override String get networkError => 'Errore di rete. Controlla la tua connessione.';
	@override String get unauthorized => 'Non autorizzato. Effettua l\'accesso.';
	@override String get notFound => 'Non trovato';
	@override String get invalidInput => 'Input non valido';
	@override String get requiredField => 'Questo campo è obbligatorio';
	@override String get unknownError => 'Si è verificato un errore sconosciuto';
	@override String get renameSessionFailed => 'Impossibile rinominare la sessione. Riprova.';
}

// Path: common.navigation
class Translations$common$navigation$it extends Translations$common$navigation$en {
	Translations$common$navigation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Impostazioni';
	@override String get home => 'Home';
	@override String get back => 'Indietro';
	@override String get next => 'Avanti';
	@override String get previous => 'Precedente';
	@override String get logout => 'Esci';
}

// Path: common.common
class Translations$common$common$it extends Translations$common$common$en {
	Translations$common$common$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get language => 'Lingua';
	@override String get theme => 'Tema';
	@override String get darkMode => 'Modalità scura';
	@override String get lightMode => 'Modalità chiara';
	@override String get name => 'Nome';
	@override String get description => 'Descrizione';
	@override String get enabled => 'Abilitato';
	@override String get disabled => 'Disabilitato';
	@override String get optional => 'Opzionale';
	@override String get version => 'Versione';
	@override String get select => 'Seleziona';
	@override String get selectAll => 'Seleziona tutto';
	@override String get deselectAll => 'Deseleziona tutto';
	@override String get done => 'Fatto';
	@override String get failed => 'Non riuscito';
}

// Path: common.time
class Translations$common$time$it extends Translations$common$time$en {
	Translations$common$time$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Adesso';
	@override String minutesAgo({required Object count}) => '${count} min fa';
	@override String hoursAgo({required Object count}) => '${count} ore fa';
	@override String daysAgo({required Object count}) => '${count} giorni fa';
	@override String get yesterday => 'Ieri';
}

// Path: common.fileOperations
class Translations$common$fileOperations$it extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Nuovo file';
	@override String get newFolder => 'Nuova cartella';
	@override String get rename => 'Rinomina';
	@override String get move => 'Sposta';
	@override String get copyPath => 'Copia percorso';
	@override String get openInEditor => 'Apri nell\'editor';
}

// Path: common.mainContent
class Translations$common$mainContent$it extends Translations$common$mainContent$en {
	Translations$common$mainContent$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Caricamento DDAgent';
	@override String get settingUpWorkspace => 'Preparazione dell\'area di lavoro...';
	@override String get chooseProject => 'Scegli il tuo progetto';
	@override String get selectProjectDescription => 'Seleziona un progetto dalla barra laterale per iniziare a programmare con Claude. Ogni progetto contiene le tue sessioni di chat e la cronologia dei file.';
	@override String get tip => 'Suggerimento';
	@override String get createProjectMobile => 'Tocca il pulsante menu in alto per accedere ai progetti';
	@override String get createProjectDesktop => 'Crea un nuovo progetto cliccando l\'icona cartella nella barra laterale';
	@override String get newSession => 'Nuova sessione';
	@override String get untitledSession => 'Sessione senza titolo';
	@override String get projectFiles => 'File del progetto';
	@override String get focusMode => 'Modalità concentrazione (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Esci dalla modalità concentrazione (Ctrl+Shift+F)';
	@override String get splitSession => 'Dividi sessione';
	@override String get closeSplitSession => 'Chiudi sessione divisa';
	@override String get chooseWorkspace => 'Scegli un workspace';
	@override String get chooseWorkspaceDescription => 'Scegli un workspace per questa chat o creane uno nuovo nelle Impostazioni.';
	@override String get createWorkspace => 'Crea workspace nelle Impostazioni';
	@override String get recentProjects => 'Progetti recenti';
}

// Path: common.fileTree
class Translations$common$fileTree$it extends Translations$common$fileTree$en {
	Translations$common$fileTree$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Caricamento file...';
	@override String get files => 'File';
	@override String get simpleView => 'Vista semplice';
	@override String get compactView => 'Vista compatta';
	@override String get detailedView => 'Vista dettagliata';
	@override String get searchPlaceholder => 'Cerca file e cartelle...';
	@override String get clearSearch => 'Cancella ricerca';
	@override String get name => 'Nome';
	@override String get size => 'Dimensione';
	@override String get modified => 'Modificato';
	@override String get permissions => 'Permessi';
	@override String get noFilesFound => 'Nessun file trovato';
	@override String get checkProjectPath => 'Verifica che il percorso del progetto sia accessibile';
	@override String get noMatchesFound => 'Nessuna corrispondenza trovata';
	@override String get tryDifferentSearch => 'Prova con un termine di ricerca diverso o cancella la ricerca';
	@override String get justNow => 'adesso';
	@override String minAgo({required Object count}) => '${count} min fa';
	@override String hoursAgo({required Object count}) => '${count} ore fa';
	@override String daysAgo({required Object count}) => '${count} giorni fa';
	@override String get newFile => 'Nuovo file (Cmd+N)';
	@override String get newFolder => 'Nuova cartella (Cmd+Shift+N)';
	@override String get refresh => 'Aggiorna';
	@override String get collapseAll => 'Comprimi tutto';
	@override late final Translations$common$fileTree$context$it context = Translations$common$fileTree$context$it._(_root);
	@override String get searchContentPlaceholder => 'Cerca nei file...';
	@override String get searchInFiles => 'Cerca nei file';
	@override String get searchByName => 'Cerca per nome';
	@override String get loadFailed => 'Impossibile caricare i file';
	@override String get noSearchResults => 'Nessuna corrispondenza trovata';
	@override String get searchError => 'Ricerca non riuscita';
	@override String get searching => 'Ricerca in corso...';
	@override String resultsTruncated({required Object count}) => 'Mostrati i primi ${count} risultati';
	@override String get allWorkspaces => 'Tutti i workspace';
	@override late final Translations$common$fileTree$delete$it delete = Translations$common$fileTree$delete$it._(_root);
	@override String get dropToUpload => 'Trascina i file per caricarli';
	@override String dropToUploadTo({required Object folder}) => 'Trascina i file per caricarli in «${folder}»';
	@override String get noProject => 'Aggiungi prima un progetto';
	@override String get noRecentFiles => 'Nessun file modificato negli ultimi 7 giorni';
	@override String get showAllFiles => 'Mostra tutti i file';
	@override String get showAllFilesHint => 'Disattiva il filtro recenti per vedere tutto.';
	@override String get showRecentOnly => 'Mostra i file modificati negli ultimi 7 giorni';
	@override late final Translations$common$fileTree$toast$it toast = Translations$common$fileTree$toast$it._(_root);
	@override String get uploadComplete => 'Caricamento completato';
	@override String get uploadFailed => 'Caricamento non riuscito';
	@override String uploadFiles({required Object size}) => 'Carica file (max ${size} ciascuno)';
	@override String uploadToFolder({required Object folder}) => 'Carica file in «${folder}»';
	@override String uploadedCount({required Object uploaded, required Object total, required Object label}) => 'Caricati ${uploaded} di ${total} ${label}';
	@override String get uploadingFiles => 'Caricamento file';
	@override late final Translations$common$fileTree$validation$it validation = Translations$common$fileTree$validation$it._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$it extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crea nuovo progetto';
	@override late final Translations$common$projectWizard$steps$it steps = Translations$common$projectWizard$steps$it._(_root);
	@override late final Translations$common$projectWizard$step1$it step1 = Translations$common$projectWizard$step1$it._(_root);
	@override late final Translations$common$projectWizard$step2$it step2 = Translations$common$projectWizard$step2$it._(_root);
	@override late final Translations$common$projectWizard$step3$it step3 = Translations$common$projectWizard$step3$it._(_root);
	@override late final Translations$common$projectWizard$buttons$it buttons = Translations$common$projectWizard$buttons$it._(_root);
	@override late final Translations$common$projectWizard$errors$it errors = Translations$common$projectWizard$errors$it._(_root);
}

// Path: common.notifications
class Translations$common$notifications$it extends Translations$common$notifications$en {
	Translations$common$notifications$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'uno strumento';
	@override late final Translations$common$notifications$codes$it codes = Translations$common$notifications$codes$it._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$it extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aggiornamento disponibile';
	@override String get newVersionReady => 'Una nuova versione è pronta';
	@override String get currentVersion => 'Versione attuale';
	@override String get latestVersion => 'Ultima versione';
	@override String get whatsNew => 'Novità:';
	@override String get viewFullRelease => 'Vedi release completa';
	@override String get updateProgress => 'Progresso aggiornamento:';
	@override String get manualUpgrade => 'Aggiornamento manuale:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'Oppure clicca "Aggiorna ora" per eseguire l\'aggiornamento automaticamente.';
	@override String get updateCompleted => 'Aggiornamento completato con successo!';
	@override String get restartServer => 'Riavvia il server per applicare le modifiche.';
	@override String get updateFailed => 'Aggiornamento fallito';
	@override late final Translations$common$versionUpdate$buttons$it buttons = Translations$common$versionUpdate$buttons$it._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$it ariaLabels = Translations$common$versionUpdate$ariaLabels$it._(_root);
}

// Path: common.quota
class Translations$common$quota$it extends Translations$common$quota$en {
	Translations$common$quota$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$it section = Translations$common$quota$section$it._(_root);
	@override late final Translations$common$quota$filter$it filter = Translations$common$quota$filter$it._(_root);
	@override late final Translations$common$quota$period$it period = Translations$common$quota$period$it._(_root);
	@override late final Translations$common$quota$group$it group = Translations$common$quota$group$it._(_root);
	@override late final Translations$common$quota$metric$it metric = Translations$common$quota$metric$it._(_root);
	@override late final Translations$common$quota$cost$it cost = Translations$common$quota$cost$it._(_root);
	@override late final Translations$common$quota$cost3$it cost3 = Translations$common$quota$cost3$it._(_root);
	@override late final Translations$common$quota$overview$it overview = Translations$common$quota$overview$it._(_root);
	@override late final Translations$common$quota$usage$it usage = Translations$common$quota$usage$it._(_root);
	@override late final Translations$common$quota$agents$it agents = Translations$common$quota$agents$it._(_root);
	@override late final Translations$common$quota$agentStatus$it agentStatus = Translations$common$quota$agentStatus$it._(_root);
	@override late final Translations$common$quota$alert$it alert = Translations$common$quota$alert$it._(_root);
	@override String get backToChat => 'Torna alla chat';
	@override String get syncNow => 'Sincronizza ora';
	@override String generatedAt({required Object value}) => 'Aggiornato ${value}';
	@override String get loading => 'Caricamento limiti account…';
	@override String remaining({required Object value}) => '${value}% rimasto';
	@override String resetsIn({required Object value}) => 'reset tra ${value}';
	@override String projected({required Object value}) => 'al ritmo attuale questo limite si esaurisce in ${value}';
	@override String syncedAgo({required Object value}) => 'sincronizzato ${value} fa';
	@override String get refreshAccount => 'Aggiorna account';
	@override String get syncFailed => 'Sincronizzazione non riuscita';
	@override String get history => 'Cronologia';
	@override String historyPoints({required Object value}) => '${value} letture registrate';
	@override String get historyEmpty => 'Nessuna cronologia registrata';
	@override String get noAgents => 'Nessun agente assegnato';
	@override String get noSubscription => 'Nessun abbonamento';
	@override String get noSubscriptionHint => 'Il provider non segnala alcun piano attivo per questo account.';
	@override late final Translations$common$quota$quality$it quality = Translations$common$quota$quality$it._(_root);
	@override late final Translations$common$quota$kpi$it kpi = Translations$common$quota$kpi$it._(_root);
	@override late final Translations$common$quota$empty$it empty = Translations$common$quota$empty$it._(_root);
	@override late final Translations$common$quota$settings$it settings = Translations$common$quota$settings$it._(_root);
	@override late final Translations$common$quota$range$it range = Translations$common$quota$range$it._(_root);
}

// Path: common.actions
class Translations$common$actions$it extends Translations$common$actions$en {
	Translations$common$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annulla';
	@override String get retry => 'Riprova';
	@override String get save => 'Salva';
}

// Path: common.browserPane
class Translations$common$browserPane$it extends Translations$common$browserPane$en {
	Translations$common$browserPane$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get address => 'Indirizzo';
	@override String get back => 'Indietro';
	@override String get connecting => 'Connessione al browser…';
	@override String get connectionFailed => 'Connessione al browser non riuscita.';
	@override String couldNotLoad({required Object url}) => 'Impossibile caricare ${url}';
	@override String get disconnected => 'Vista browser disconnessa';
	@override String get enterUrl => 'Inserisci URL';
	@override String get forward => 'Avanti';
	@override String get invalidUrl => 'Inserisci un URL http(s) valido';
	@override String get noAuthToken => 'Nessun token di autenticazione disponibile.';
	@override String get openExternal => 'Apri nel browser di sistema';
	@override String get reload => 'Ricarica';
	@override String get retry => 'Riprova';
	@override String get stop => 'Interrompi';
}

// Path: common.browserUse
class Translations$common$browserUse$it extends Translations$common$browserUse$en {
	Translations$common$browserUse$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} attive';
	@override String get cancel => 'Annulla';
	@override String get close => 'Chiudi';
	@override String get delete => 'Elimina';
	@override String deleteDesc({required Object name}) => '${name} verrà eliminata definitivamente.';
	@override String get deleteSession => 'Elimina sessione';
	@override String get deleteTitle => 'Eliminare la sessione del browser?';
	@override late final Translations$common$browserUse$empty$it empty = Translations$common$browserUse$empty$it._(_root);
	@override String get emptyStatus => 'vuota';
	@override late final Translations$common$browserUse$errors$it errors = Translations$common$browserUse$errors$it._(_root);
	@override String get fullscreen => 'Schermo intero';
	@override String get installRuntime => 'Installa runtime';
	@override String get installing => 'Installazione...';
	@override String get lastAction => 'Ultima azione';
	@override String get nextSnapshot => 'Il prossimo snapshot del browser dell’agente apparirà qui.';
	@override String get noPageLoaded => 'Nessuna pagina caricata';
	@override String get noSessions => 'Nessuna sessione browser degli agenti.';
	@override String get none => 'Nessuno';
	@override String get openSettings => 'Apri impostazioni Browser';
	@override String get profile => 'Profilo';
	@override String get promptLabel => 'Prompt';
	@override late final Translations$common$browserUse$prompts$it prompts = Translations$common$browserUse$prompts$it._(_root);
	@override String get refresh => 'Aggiorna sessioni browser';
	@override late final Translations$common$browserUse$relative$it relative = Translations$common$browserUse$relative$it._(_root);
	@override late final Translations$common$browserUse$runtime$it runtime = Translations$common$browserUse$runtime$it._(_root);
	@override String get runtimeSetup => 'Configurazione del runtime richiesta';
	@override String get selected => 'Selezionata';
	@override String get sessionFallback => 'Sessione browser';
	@override String get sessionScreenshot => 'Screenshot della sessione browser';
	@override String get sessions => 'Sessioni';
	@override String get status => 'Stato';
	@override String get stop => 'Interrompi';
	@override String get stopSession => 'Interrompi sessione';
	@override String get subtitle => 'Monitora le sessioni browser aperte dagli agenti AI.';
	@override String get temporary => 'Temporaneo';
	@override String get thisSession => 'Questa sessione';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '${count} totali';
	@override String updated({required Object time}) => 'Aggiornato ${time}';
	@override String get waiting => 'In attesa';
	@override String get waitingForScreenshot => 'In attesa dello screenshot';
}

// Path: common.commandPalette
class Translations$common$commandPalette$it extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Torna a tutto';
	@override String get backspaceHint => 'Backspace per tornare indietro';
	@override late final Translations$common$commandPalette$browseAll$it browseAll = Translations$common$commandPalette$browseAll$it._(_root);
	@override late final Translations$common$commandPalette$compare$it compare = Translations$common$commandPalette$compare$it._(_root);
	@override late final Translations$common$commandPalette$groups$it groups = Translations$common$commandPalette$groups$it._(_root);
	@override late final Translations$common$commandPalette$hints$it hints = Translations$common$commandPalette$hints$it._(_root);
	@override late final Translations$common$commandPalette$items$it items = Translations$common$commandPalette$items$it._(_root);
	@override late final Translations$common$commandPalette$nav$it nav = Translations$common$commandPalette$nav$it._(_root);
	@override String get noResults => 'Nessun risultato.';
	@override late final Translations$common$commandPalette$pages$it pages = Translations$common$commandPalette$pages$it._(_root);
	@override String get placeholder => 'Digita per cercare…';
	@override String searchPagePlaceholder({required Object page}) => 'Cerca in ${page}…';
	@override String get title => 'Palette dei comandi';
}

// Path: common.gitPanel
class Translations$common$gitPanel$it extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} avanti';
	@override String get aheadLabel => 'avanti';
	@override String get aiSuggest => 'Suggerimento AI';
	@override String get aiSuggestTitle => 'Genera un messaggio di commit con l’AI';
	@override String get all => 'Tutti';
	@override String get allStaged => 'Tutte le modifiche in stage';
	@override String behind({required Object count}) => '${count} indietro';
	@override String get behindLabel => 'indietro';
	@override late final Translations$common$gitPanel$branches$it branches = Translations$common$gitPanel$branches$it._(_root);
	@override String get cancel => 'Annulla';
	@override String changesCount({required Object count}) => 'Modifiche (${count})';
	@override String get clearSearch => 'Cancella ricerca';
	@override String get collapseDiff => 'Comprimi diff';
	@override String get commit => 'Commit';
	@override String get commitChanges => 'Committa modifiche';
	@override String commitFiles({required Object count}) => 'Committa ${count} file';
	@override String get committing => 'Commit in corso...';
	@override late final Translations$common$gitPanel$confirmActions$it confirmActions = Translations$common$gitPanel$confirmActions$it._(_root);
	@override String confirmCommit({required Object count, required Object message}) => 'Committare ${count} file con il messaggio: «${message}»?';
	@override String confirmDeleteFile({required Object file}) => 'Eliminare il file non tracciato «${file}»? Azione irreversibile.';
	@override String confirmDiscardFile({required Object file}) => 'Scartare tutte le modifiche a «${file}»? Azione irreversibile.';
	@override String confirmPublish({required Object branch, required Object remote}) => 'Pubblicare il branch «${branch}» su ${remote}?';
	@override String confirmPull({required Object count, required Object remote}) => 'Scaricare ${count} commit da ${remote}?';
	@override String confirmPush({required Object count, required Object remote}) => 'Inviare ${count} commit a ${remote}?';
	@override String get confirmRevert => 'Annullare l’ultimo commit locale? Rimuove il commit ma mantiene le modifiche in stage.';
	@override late final Translations$common$gitPanel$confirmTitles$it confirmTitles = Translations$common$gitPanel$confirmTitles$it._(_root);
	@override String get createBranch => 'Crea nuovo branch';
	@override String get creating => 'Creazione...';
	@override String get delete => 'Elimina';
	@override String get deleteUntracked => 'Elimina file non tracciato';
	@override String get deselectAll => 'Deseleziona tutto';
	@override String get discard => 'Scarta';
	@override String get discardChanges => 'Scarta modifiche';
	@override String get dismiss => 'Chiudi';
	@override String get dismissError => 'Chiudi errore';
	@override late final Translations$common$gitPanel$errors$it errors = Translations$common$gitPanel$errors$it._(_root);
	@override String get expandDiff => 'Espandi diff';
	@override String get fetch => 'Fetch';
	@override String fetchTitle({required Object remote}) => 'Fetch da ${remote}';
	@override String get fetching => 'Fetch…';
	@override String filesSelected({required Object count}) => '${count} file selezionati';
	@override String get generating => 'Generazione...';
	@override late final Translations$common$gitPanel$history$it history = Translations$common$gitPanel$history$it._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$it mergeWorktree = Translations$common$gitPanel$mergeWorktree$it._(_root);
	@override String get merging => 'Fusione...';
	@override String get messagePlaceholder => 'Messaggio (Ctrl+Invio per committare)';
	@override late final Translations$common$gitPanel$newBranch$it newBranch = Translations$common$gitPanel$newBranch$it._(_root);
	@override late final Translations$common$gitPanel$newWorktree$it newWorktree = Translations$common$gitPanel$newWorktree$it._(_root);
	@override String get noChanges => 'Nessuna modifica rilevata';
	@override String get noChangesToCommit => 'Nessuna modifica da committare';
	@override late final Translations$common$gitPanel$noCommits$it noCommits = Translations$common$gitPanel$noCommits$it._(_root);
	@override String get noMatchingBranches => 'Nessun branch corrispondente';
	@override late final Translations$common$gitPanel$noRepo$it noRepo = Translations$common$gitPanel$noRepo$it._(_root);
	@override String get noStagedFiles => 'Nessun file in stage';
	@override String get none => 'Nessuno';
	@override String nothingToPush({required Object remote}) => 'Niente da inviare a ${remote}';
	@override String get openFile => 'Clicca per aprire il file';
	@override String get publish => 'Pubblica';
	@override String publishTitle({required Object branch, required Object remote}) => 'Pubblica «${branch}» su ${remote}';
	@override String get publishing => 'Pubblicazione…';
	@override String get pull => 'Pull';
	@override String pullCount({required Object count}) => 'Pull ${count}';
	@override String pullTitle({required Object count, required Object remote}) => 'Scarica ${count} da ${remote}';
	@override String get pulling => 'Pull…';
	@override String get push => 'Push';
	@override String pushCount({required Object count}) => 'Push ${count}';
	@override String pushTitle({required Object count, required Object remote}) => 'Invia ${count} a ${remote}';
	@override String get pushing => 'Push…';
	@override String get recentCommits => 'Commit recenti';
	@override String get refresh => 'Aggiorna stato git';
	@override String get remove => 'Rimuovi';
	@override late final Translations$common$gitPanel$removeWorktree$it removeWorktree = Translations$common$gitPanel$removeWorktree$it._(_root);
	@override String get removing => 'Rimozione...';
	@override String get revertLatest => 'Annulla ultimo commit locale';
	@override String get scroll => 'Scorrimento';
	@override String get searchBranches => 'Cerca branch...';
	@override String get selectAll => 'Seleziona tutto';
	@override String get selectProject => 'Seleziona un progetto per vedere il controllo del codice';
	@override String selectedOf({required Object selected, required Object total}) => '${selected} di ${total} file selezionati';
	@override String selectedOfMobile({required Object selected, required Object total}) => '${selected} di ${total} selezionati';
	@override String get sideBySide => 'Affiancato';
	@override String get stageAll => 'Metti tutto in stage';
	@override String get stageHunk => 'Metti in stage questa sezione';
	@override String staged({required Object count}) => 'In stage (${count})';
	@override late final Translations$common$gitPanel$status$it status = Translations$common$gitPanel$status$it._(_root);
	@override String get statusGuide => 'Guida agli stati dei file';
	@override String get switchScroll => 'Passa allo scorrimento orizzontale';
	@override String get switchSplit => 'Passa alla vista affiancata';
	@override String get switchUnified => 'Passa alla vista unificata';
	@override String get switchWrap => 'Passa all’a capo automatico';
	@override String get unified => 'Unificato';
	@override String get unstageAll => 'Togli tutto dallo stage';
	@override String get unstageHunk => 'Togli questa sezione dallo stage';
	@override String get upToDate => 'Aggiornato';
	@override String upToDateWith({required Object remote}) => 'Aggiornato con ${remote}';
	@override String get viewAll => 'Vedi tutto';
	@override String get viewsAria => 'Viste del controllo del codice';
	@override late final Translations$common$gitPanel$worktrees$it worktrees = Translations$common$gitPanel$worktrees$it._(_root);
	@override String get wrap => 'A capo';
	@override late final Translations$common$gitPanel$tabs$it tabs = Translations$common$gitPanel$tabs$it._(_root);
}

// Path: common.sessions
class Translations$common$sessions$it extends Translations$common$sessions$en {
	Translations$common$sessions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Rinomina sessione';
}

// Path: common.projects
class Translations$common$projects$it extends Translations$common$projects$en {
	Translations$common$projects$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nuova sessione';
}

// Path: common.codeBlock
class Translations$common$codeBlock$it extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'A capo automatico';
	@override String get noWrap => 'Nessun a capo';
}

// Path: common.update
class Translations$common$update$it extends Translations$common$update$en {
	Translations$common$update$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Aggiornamento disponibile · v${version}';
	@override String confirm({required Object version}) => 'Aggiornare alla v${version}? Il server si aggiorna e si riavvia da solo — le sessioni attive verranno interrotte.';
	@override String get downloading => 'Download e applicazione dell\'aggiornamento in corso…';
	@override String get restarting => 'Riavvio del server — ci vorrà un momento…';
	@override String done({required Object version}) => 'Aggiornato alla v${version}. Ricarica l\'app per applicare il nuovo bundle.';
	@override String get manualRestart => 'L\'aggiornamento è stato applicato, ma il server non si è riavviato da solo — riavvialo manualmente per completare.';
	@override String get failed => 'Aggiornamento non riuscito.';
	@override String get failedTitle => 'Aggiornamento non riuscito';
	@override String appConfirm({required Object version}) => 'Installare DDAgent v${version} su questo dispositivo? Android chiederà il permesso di installare app da DDAgent la prima volta.';
	@override String get appPermission => 'Consenti «Installa app sconosciute» per DDAgent, poi tocca di nuovo Aggiorna.';
	@override String get chooseTitle => 'Aggiornamenti disponibili';
	@override String get targetApp => 'Questa app';
	@override String get targetWeb => 'Interfaccia web';
	@override String get targetServer => 'Server';
	@override String get updateApp => 'Aggiorna app';
	@override String get updateWeb => 'Aggiorna interfaccia web';
	@override String get updateServer => 'Aggiorna server';
	@override String webConfirm({required Object version}) => 'Aggiornare l\'interfaccia web a v${version}? La pagina verrà ricaricata.';
	@override String webDone({required Object version}) => 'Interfaccia web aggiornata a v${version} — ricaricamento…';
	@override String localServerConfirm({required Object version}) => 'Aggiornare il server locale di questo dispositivo a v${version}? Le sessioni attive verranno interrotte.';
	@override String get localServerUpdating => 'Download e avvio del server locale…';
	@override String serverDone({required Object version}) => 'Il server esegue v${version}.';
	@override String staged({required Object version}) => 'Aggiornamento v${version} scaricato — riavvia il server per installarlo.';
	@override String get upToDate => 'Il server ha già l\'ultima release.';
	@override String webHostFailed({required Object message}) => 'Il server è stato aggiornato, ma la sua interfaccia web no: ${message}';
}

// Path: settings.changelog
class Translations$settings$changelog$it extends Translations$settings$changelog$en {
	Translations$settings$changelog$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Registro delle modifiche';
	@override String get loading => 'Caricamento…';
	@override String get empty => 'Nessuna versione da mostrare';
	@override String get current => 'attuale';
	@override String get kNew => 'nuova';
}

// Path: settings.server
class Translations$settings$server$it extends Translations$settings$server$en {
	Translations$settings$server$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Server';
	@override String get description => 'Riavvia il processo DDAgent — utile dopo un aggiornamento o in caso di blocco.';
	@override String get restart => 'Riavvia';
	@override String get restartConfirm => 'Riavviare il server DDAgent? Le sessioni attive verranno interrotte.';
	@override String get restarting => 'Riavvio in corso… la pagina si ricaricherà quando il server torna.';
	@override String get restartFailed => 'Riavvio non riuscito';
	@override String get unsupported => 'Il riavvio è disponibile solo quando il server è gestito dal service manager.';
	@override String get ok => 'OK';
	@override String get restartTitle => 'Riavvio del server';
	@override String get restartRequesting => 'Richiesta di riavvio inviata al server…';
	@override String restartWaiting({required Object seconds}) => 'In attesa che il server torni disponibile… (${seconds} s)';
	@override String restartBack({required Object version}) => 'Il server è di nuovo attivo — versione ${version}.';
	@override String get restartReloading => 'Ricaricamento della pagina…';
	@override String restartTimeout({required Object seconds}) => 'Il server non è tornato entro ${seconds} s. Controlla il log del servizio (/tmp/ddagent.log) o riavvialo manualmente.';
}

// Path: settings.updates
class Translations$settings$updates$it extends Translations$settings$updates$en {
	Translations$settings$updates$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aggiornamenti';
	@override String get description => 'Controlla su GitHub una build desktop più recente. Le nuove versioni si scaricano automaticamente e si installano all\'uscita.';
	@override String get check => 'Controlla aggiornamenti';
	@override String get checking => 'Controllo in corso…';
	@override String upToDate({required Object version}) => 'Hai la versione più recente (v${version}).';
	@override String available({required Object version}) => 'Trovato aggiornamento v${version} — download in background; si installerà alla chiusura di DDAgent.';
	@override String downloaded({required Object version}) => 'Aggiornamento v${version} scaricato — chiudi e riavvia DDAgent per installarlo.';
	@override String get unavailable => 'Il controllo degli aggiornamenti è disponibile solo nelle build desktop pacchettizzate.';
	@override String error({required Object message}) => 'Controllo aggiornamenti non riuscito: ${message}';
	@override String get errorGeneric => 'Controllo aggiornamenti non riuscito.';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · ultima v${latest}';
	@override String current({required Object version}) => 'v${version} — aggiornata';
	@override String webNotHosted({required Object version}) => 'Questa interfaccia web è ospitata separatamente: sostituisci i suoi file con ddagent-flutter-web-v${version}.zip della release.';
	@override String get serverCannotUpdate => 'Questo server non può aggiornarsi da qui: reinstallalo con install.sh o con un tarball della release.';
}

// Path: settings.tabs
class Translations$settings$tabs$it extends Translations$settings$tabs$en {
	Translations$settings$tabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get account => 'Account';
	@override String get permissions => 'Permessi';
	@override String get mcpServers => 'Server MCP';
	@override String get appearance => 'Aspetto';
	@override String get skills => 'Skill';
}

// Path: settings.account
class Translations$settings$account$it extends Translations$settings$account$en {
	Translations$settings$account$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Account';
	@override String get language => 'Lingua';
	@override String get languageLabel => 'Lingua dell\'interfaccia';
	@override String get languageDescription => 'Scegli la lingua preferita per l\'interfaccia';
	@override String get username => 'Nome utente';
	@override String get email => 'Email';
	@override String get profile => 'Profilo';
	@override String get changePassword => 'Cambia password';
}

// Path: settings.mcp
class Translations$settings$mcp$it extends Translations$settings$mcp$en {
	Translations$settings$mcp$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Server MCP';
	@override String get addServer => 'Aggiungi server';
	@override String get editServer => 'Modifica server';
	@override String get deleteServer => 'Elimina server';
	@override String get serverName => 'Nome server';
	@override String get serverType => 'Tipo server';
	@override String get config => 'Configurazione';
	@override String get testConnection => 'Testa connessione';
	@override String get status => 'Stato';
	@override String get connected => 'Connesso';
	@override String get disconnected => 'Disconnesso';
	@override late final Translations$settings$mcp$scope$it scope = Translations$settings$mcp$scope$it._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$it extends Translations$settings$appearance$en {
	Translations$settings$appearance$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aspetto';
	@override String get theme => 'Tema';
	@override String get codeEditor => 'Editor codice';
	@override String get editorTheme => 'Tema editor';
	@override String get wordWrap => 'A capo automatico';
	@override String get showMinimap => 'Mostra minimappa';
	@override String get lineNumbers => 'Numeri di riga';
	@override String get fontSize => 'Dimensione carattere';
	@override late final Translations$settings$appearance$themeModes$it themeModes = Translations$settings$appearance$themeModes$it._(_root);
}

// Path: settings.actions
class Translations$settings$actions$it extends Translations$settings$actions$en {
	Translations$settings$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Salva modifiche';
	@override String get resetToDefaults => 'Ripristina predefiniti';
	@override String get cancelChanges => 'Annulla modifiche';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$it extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Impostazioni rapide';
	@override late final Translations$settings$quickSettings$sections$it sections = Translations$settings$quickSettings$sections$it._(_root);
	@override String get darkMode => 'Modalità scura';
	@override String get showRawParameters => 'Mostra parametri grezzi';
	@override String get showThinking => 'Mostra ragionamento';
	@override String get sendByCtrlEnter => 'Invia con Ctrl+Invio';
	@override String get sendByCtrlEnterDescription => 'Se abilitato, premere Ctrl+Invio invierà il messaggio invece di Invio. Utile per gli utenti IME per evitare invii accidentali.';
	@override late final Translations$settings$quickSettings$dragHandle$it dragHandle = Translations$settings$quickSettings$dragHandle$it._(_root);
	@override String get sendWithCtrlEnter => 'Invia con Ctrl+Invio';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$it extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Scorciatoie terminale';
	@override String get sectionKeys => 'Tasti';
	@override String get sectionNavigation => 'Navigazione';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => 'Freccia su';
	@override String get arrowDown => 'Freccia giù';
	@override String get scrollDown => 'Scorri giù';
	@override late final Translations$settings$terminalShortcuts$handle$it handle = Translations$settings$terminalShortcuts$handle$it._(_root);
	@override String get killTitle => 'Termina processo in esecuzione (Ctrl+C)';
	@override String get paste => 'Incolla';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$it extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Impostazioni';
	@override String get agents => 'Agenti';
	@override String get orchestration => 'Orchestrazione';
	@override String get appearance => 'Aspetto';
	@override String get git => 'Git';
	@override String get apiTokens => 'API e Token';
	@override String get models => 'Modelli';
	@override String get tasks => 'Attività';
	@override String get notifications => 'Notifiche';
	@override String get about => 'Informazioni';
	@override String get workspaces => 'Workspace';
	@override String get browser => 'Browser';
	@override String get tools => 'Strumenti';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$it extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$it enable = Translations$settings$orchestration$enable$it._(_root);
	@override late final Translations$settings$orchestration$pool$it pool = Translations$settings$orchestration$pool$it._(_root);
	@override late final Translations$settings$orchestration$tiers$it tiers = Translations$settings$orchestration$tiers$it._(_root);
	@override late final Translations$settings$orchestration$rules$it rules = Translations$settings$orchestration$rules$it._(_root);
	@override late final Translations$settings$orchestration$planner$it planner = Translations$settings$orchestration$planner$it._(_root);
	@override late final Translations$settings$orchestration$execution$it execution = Translations$settings$orchestration$execution$it._(_root);
	@override late final Translations$settings$orchestration$save$it save = Translations$settings$orchestration$save$it._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$it extends Translations$settings$notifications$en {
	Translations$settings$notifications$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifiche';
	@override String get description => 'Controlla quali notifiche ricevere.';
	@override late final Translations$settings$notifications$webPush$it webPush = Translations$settings$notifications$webPush$it._(_root);
	@override late final Translations$settings$notifications$device$it device = Translations$settings$notifications$device$it._(_root);
	@override late final Translations$settings$notifications$sound$it sound = Translations$settings$notifications$sound$it._(_root);
	@override late final Translations$settings$notifications$events$it events = Translations$settings$notifications$events$it._(_root);
	@override late final Translations$settings$notifications$desktop$it desktop = Translations$settings$notifications$desktop$it._(_root);
	@override late final Translations$settings$notifications$channels$it channels = Translations$settings$notifications$channels$it._(_root);
	@override String get unpair => 'Dissocia';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$it extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$it darkMode = Translations$settings$appearanceSettings$darkMode$it._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$it codeEditor = Translations$settings$appearanceSettings$codeEditor$it._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$it terminal = Translations$settings$appearanceSettings$terminal$it._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$it extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$it title = Translations$settings$mcpForm$title$it._(_root);
	@override late final Translations$settings$mcpForm$importMode$it importMode = Translations$settings$mcpForm$importMode$it._(_root);
	@override late final Translations$settings$mcpForm$scope$it scope = Translations$settings$mcpForm$scope$it._(_root);
	@override late final Translations$settings$mcpForm$fields$it fields = Translations$settings$mcpForm$fields$it._(_root);
	@override late final Translations$settings$mcpForm$placeholders$it placeholders = Translations$settings$mcpForm$placeholders$it._(_root);
	@override late final Translations$settings$mcpForm$validation$it validation = Translations$settings$mcpForm$validation$it._(_root);
	@override String configDetails({required Object configFile}) => 'Dettagli configurazione (da ${configFile})';
	@override String projectPath({required Object path}) => 'Percorso: ${path}';
	@override late final Translations$settings$mcpForm$actions$it actions = Translations$settings$mcpForm$actions$it._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$it extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get success => 'Impostazioni salvate con successo!';
	@override String get error => 'Impossibile salvare le impostazioni';
	@override String get saving => 'Salvataggio...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$it extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get save => 'Salva impostazioni';
	@override String get cancel => 'Annulla';
}

// Path: settings.git
class Translations$settings$git$it extends Translations$settings$git$en {
	Translations$settings$git$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configurazione Git';
	@override String get description => 'Configura la tua identità git per i commit. Queste impostazioni verranno applicate globalmente tramite git config --global';
	@override late final Translations$settings$git$name$it name = Translations$settings$git$name$it._(_root);
	@override late final Translations$settings$git$email$it email = Translations$settings$git$email$it._(_root);
	@override late final Translations$settings$git$actions$it actions = Translations$settings$git$actions$it._(_root);
	@override late final Translations$settings$git$status$it status = Translations$settings$git$status$it._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$it extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Chiavi API';
	@override String get description => 'Genera chiavi API per accedere all\'API esterna da altre applicazioni.';
	@override late final Translations$settings$apiKeys$newKey$it newKey = Translations$settings$apiKeys$newKey$it._(_root);
	@override late final Translations$settings$apiKeys$form$it form = Translations$settings$apiKeys$form$it._(_root);
	@override String get newButton => 'Nuova chiave API';
	@override String get empty => 'Nessuna chiave API creata.';
	@override late final Translations$settings$apiKeys$list$it list = Translations$settings$apiKeys$list$it._(_root);
	@override String get confirmDelete => 'Sei sicuro di voler eliminare questa chiave API?';
	@override late final Translations$settings$apiKeys$status$it status = Translations$settings$apiKeys$status$it._(_root);
	@override late final Translations$settings$apiKeys$github$it github = Translations$settings$apiKeys$github$it._(_root);
	@override String get apiDocsLink => 'Documentazione API';
	@override late final Translations$settings$apiKeys$documentation$it documentation = Translations$settings$apiKeys$documentation$it._(_root);
	@override String get loading => 'Caricamento...';
	@override late final Translations$settings$apiKeys$version$it version = Translations$settings$apiKeys$version$it._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$it extends Translations$settings$tasks$en {
	Translations$settings$tasks$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Verifica installazione TaskMaster...';
	@override late final Translations$settings$tasks$notInstalled$it notInstalled = Translations$settings$tasks$notInstalled$it._(_root);
	@override late final Translations$settings$tasks$settings$it settings = Translations$settings$tasks$settings$it._(_root);
}

// Path: settings.agents
class Translations$settings$agents$it extends Translations$settings$agents$en {
	Translations$settings$agents$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$it authStatus = Translations$settings$agents$authStatus$it._(_root);
	@override late final Translations$settings$agents$install$it install = Translations$settings$agents$install$it._(_root);
	@override late final Translations$settings$agents$update$it update = Translations$settings$agents$update$it._(_root);
	@override late final Translations$settings$agents$account$it account = Translations$settings$agents$account$it._(_root);
	@override String get connectionStatus => 'Stato connessione';
	@override late final Translations$settings$agents$login$it login = Translations$settings$agents$login$it._(_root);
	@override late final Translations$settings$agents$logout$it logout = Translations$settings$agents$logout$it._(_root);
	@override String error({required Object error}) => 'Errore: ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$it extends Translations$settings$permissions$en {
	Translations$settings$permissions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Impostazioni permessi';
	@override late final Translations$settings$permissions$permissionMode$it permissionMode = Translations$settings$permissions$permissionMode$it._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$it extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Server MCP';
	@override late final Translations$settings$mcpServers$description$it description = Translations$settings$mcpServers$description$it._(_root);
	@override String get addButton => 'Aggiungi server MCP';
	@override String get empty => 'Nessun server MCP configurato';
	@override String get serverType => 'Tipo';
	@override late final Translations$settings$mcpServers$scope$it scope = Translations$settings$mcpServers$scope$it._(_root);
	@override late final Translations$settings$mcpServers$config$it config = Translations$settings$mcpServers$config$it._(_root);
	@override late final Translations$settings$mcpServers$tools$it tools = Translations$settings$mcpServers$tools$it._(_root);
	@override late final Translations$settings$mcpServers$actions$it actions = Translations$settings$mcpServers$actions$it._(_root);
	@override late final Translations$settings$mcpServers$help$it help = Translations$settings$mcpServers$help$it._(_root);
	@override late final Translations$settings$mcpServers$managed$it managed = Translations$settings$mcpServers$managed$it._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$it deleteConfirm = Translations$settings$mcpServers$deleteConfirm$it._(_root);
}

// Path: settings.quota
class Translations$settings$quota$it extends Translations$settings$quota$en {
	Translations$settings$quota$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$it settings = Translations$settings$quota$settings$it._(_root);
	@override late final Translations$settings$quota$empty$it empty = Translations$settings$quota$empty$it._(_root);
	@override late final Translations$settings$quota$quality$it quality = Translations$settings$quota$quality$it._(_root);
	@override String get syncFailed => 'Sincronizzazione non riuscita';
	@override String get syncNow => 'Sincronizza ora';
}

// Path: settings.browser
class Translations$settings$browser$it extends Translations$settings$browser$en {
	Translations$settings$browser$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get checking => 'controllo...';
	@override String get description => 'Consenti agli agenti di creare sessioni browser Playwright monitorate, visibili nella scheda Browser.';
	@override String get enableDescription => 'Registra Browser per gli agenti supportati. Gli agenti possono creare sessioni browser; puoi guardarle, interromperle ed eliminarle.';
	@override String get enableLabel => 'Abilita Browser';
	@override late final Translations$settings$browser$errors$it errors = Translations$settings$browser$errors$it._(_root);
	@override String get installHint => 'Installa il runtime del browser prima che gli agenti possano creare sessioni Browser.';
	@override String get installRuntime => 'Installa runtime';
	@override String get installed => 'installato';
	@override String get installing => 'Installazione...';
	@override String get missing => 'mancante';
	@override String get runtimeRequired => 'Runtime del browser richiesto';
	@override String get statusDisabled => 'disabilitato';
	@override String get statusLabel => 'Stato';
	@override String get statusReady => 'pronto';
	@override String get statusSetupRequired => 'configurazione richiesta';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$it extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annulla';
	@override String get create => 'Aggiungi workspace';
	@override String get deleteConfirm => 'Rimuovere questo workspace da DDAgent? I suoi file restano sul disco.';
	@override String get deleteFailed => 'Impossibile rimuovere il workspace.';
	@override String get deleteTitle => 'Rimuovi workspace';
	@override String get description => 'I workspace sono directory in cui DDAgent può chattare, eseguire codice e navigare.';
	@override String get remove => 'Rimuovi workspace';
	@override String get title => 'Workspace';
	@override String get pathRequired => 'Il percorso è obbligatorio';
}

// Path: settings.about
class Translations$settings$about$it extends Translations$settings$about$en {
	Translations$settings$about$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Sostieni il progetto';
	@override String get buyMeACoffee => 'Offrimi un caffè';
	@override String get learnMore => 'Scopri di più';
	@override late final Translations$settings$about$pro$it pro = Translations$settings$about$pro$it._(_root);
	@override String get proFeatures => 'Funzionalità DDAgent Pro';
	@override String get tryHosted => 'Prova DDAgent Hosted';
	@override String get versionInfo => 'Informazioni sulla versione';
	@override String get client => 'App';
	@override String get server => 'Server';
	@override String get platformMobile => 'Mobile';
	@override String get platformDesktop => 'Desktop';
	@override String get platformWeb => 'Web';
	@override String get unknown => 'sconosciuta';
}

// Path: sidebar.projects
class Translations$sidebar$projects$it extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Progetti';
	@override String get newProject => 'Nuovo progetto';
	@override String get deleteProject => 'Rimuovi progetto';
	@override String get renameProject => 'Rinomina progetto';
	@override String get noProjects => 'Nessun progetto trovato';
	@override String get loadingProjects => 'Caricamento progetti...';
	@override String get searchPlaceholder => 'Cerca progetti...';
	@override String get projectNamePlaceholder => 'Nome progetto';
	@override String get starred => 'Preferiti';
	@override String get all => 'Tutti';
	@override String get untitledSession => 'Sessione senza titolo';
	@override String get newSession => 'Nuova sessione';
	@override String get codexSession => 'Sessione Codex';
	@override String get fetchingProjects => 'Recupero dei tuoi progetti e sessioni Claude';
	@override String get projects => 'progetti';
	@override String get noMatchingProjects => 'Nessun progetto corrispondente';
	@override String get tryDifferentSearch => 'Prova a modificare il termine di ricerca';
	@override String get runClaudeCli => 'Esegui Claude CLI in una directory di progetto per iniziare';
}

// Path: sidebar.app
class Translations$sidebar$app$it extends Translations$sidebar$app$en {
	Translations$sidebar$app$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'Interfaccia assistente di programmazione AI';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$it extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sessioni';
	@override String get newSession => 'Nuova sessione';
	@override String get deleteSession => 'Elimina sessione';
	@override String get renameSession => 'Rinomina sessione';
	@override String get noSessions => 'Nessuna sessione';
	@override String get loadingSessions => 'Caricamento sessioni...';
	@override String get unnamed => 'Senza nome';
	@override String get loading => 'Caricamento...';
	@override String get showMore => 'Mostra più sessioni';
	@override String get selectMode => 'Seleziona';
	@override String get selectAll => 'Seleziona tutto';
	@override String archiveSelected({required Object count}) => 'Archivia (${count})';
	@override String deleteSelected({required Object count}) => 'Elimina (${count})';
	@override String get cancelSelection => 'Annulla selezione';
	@override String get toggleSelection => 'Attiva/disattiva selezione sessioni';
	@override String get selectionToolbar => 'Azioni di selezione sessioni';
	@override String get options => 'Opzioni sessione';
	@override String get pinSession => 'Fissa sessione';
	@override String get unpinSession => 'Rimuovi fissa sessione';
	@override String get pinned => 'Sessione fissata';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} selezionata',
		other: '${count} selezionate',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$it extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Visualizza ambienti';
	@override String get hideSidebar => 'Nascondi barra laterale';
	@override String get createProject => 'Crea nuovo progetto';
	@override String get refresh => 'Aggiorna progetti e sessioni (Ctrl+R)';
	@override String get renameProject => 'Rinomina progetto (F2)';
	@override String get deleteProject => 'Rimuovi progetto dalla barra laterale (Canc)';
	@override String get addToFavorites => 'Aggiungi ai preferiti';
	@override String get removeFromFavorites => 'Rimuovi dai preferiti';
	@override String get editSessionName => 'Modifica manualmente il nome della sessione';
	@override String get deleteSession => 'Elimina questa sessione permanentemente';
	@override String get activeSessionIndicator => 'Sessione attiva di recente (ultimi 10 minuti)';
	@override String get save => 'Salva';
	@override String get cancel => 'Annulla';
	@override String get clearSearch => 'Cancella ricerca';
	@override String get openCommandPalette => 'Apri tavolozza comandi';
	@override String get attentionRequiredIndicator => 'La sessione richiede attenzione';
	@override String get openSessions => 'Sfoglia le sessioni';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$it extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get files => 'File';
	@override String get git => 'Git';
	@override String get terminal => 'Terminale';
	@override String get tasks => 'Attività';
}

// Path: sidebar.actions
class Translations$sidebar$actions$it extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Aggiorna';
	@override String get settings => 'Impostazioni';
	@override String get collapseAll => 'Comprimi tutto';
	@override String get expandAll => 'Espandi tutto';
	@override String get cancel => 'Annulla';
	@override String get save => 'Salva';
	@override String get delete => 'Elimina';
	@override String get rename => 'Rinomina';
	@override String get joinCommunity => 'Unisciti alla community';
	@override String get reportIssue => 'Segnala problema';
	@override String get starOnGithub => 'Metti stella su GitHub';
	@override String get buyMeACoffee => 'Offrimi un caffè';
}

// Path: sidebar.branding
class Translations$sidebar$branding$it extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Open Source';
}

// Path: sidebar.status
class Translations$sidebar$status$it extends Translations$sidebar$status$en {
	Translations$sidebar$status$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get active => 'Attivo';
	@override String get inactive => 'Inattivo';
	@override String get thinking => 'Sto pensando...';
	@override String get error => 'Errore';
	@override String get aborted => 'Interrotto';
	@override String get unknown => 'Sconosciuto';
}

// Path: sidebar.time
class Translations$sidebar$time$it extends Translations$sidebar$time$en {
	Translations$sidebar$time$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Adesso';
	@override String get oneMinuteAgo => '1 min fa';
	@override String minutesAgo({required Object count}) => '${count} min fa';
	@override String get oneHourAgo => '1 ora fa';
	@override String hoursAgo({required Object count}) => '${count} ore fa';
	@override String get oneDayAgo => '1 giorno fa';
	@override String daysAgo({required Object count}) => '${count} giorni fa';
}

// Path: sidebar.messages
class Translations$sidebar$messages$it extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => 'Sei sicuro di voler eliminare questo elemento?';
	@override String get renameSuccess => 'Rinominato con successo';
	@override String get deleteSuccess => 'Eliminato con successo';
	@override String get errorOccurred => 'Si è verificato un errore';
	@override String get deleteSessionConfirm => 'Sei sicuro di voler eliminare questa sessione? Questa azione non può essere annullata.';
	@override String get deleteProjectConfirm => 'Rimuovere questo progetto dalla barra laterale? I file del progetto, le memorie e i dati delle sessioni non verranno eliminati.';
	@override String get enterProjectPath => 'Inserisci un percorso di progetto';
	@override String get deleteSessionFailed => 'Impossibile eliminare la sessione. Riprova.';
	@override String get deleteSessionError => 'Errore durante l\'eliminazione della sessione. Riprova.';
	@override String get renameSessionFailed => 'Impossibile rinominare la sessione. Riprova.';
	@override String get renameSessionError => 'Errore durante la rinomina della sessione. Riprova.';
	@override String get deleteProjectFailed => 'Impossibile rimuovere il progetto. Riprova.';
	@override String get deleteProjectError => 'Errore durante la rimozione del progetto. Riprova.';
	@override String get createProjectFailed => 'Impossibile creare il progetto. Riprova.';
	@override String get createProjectError => 'Errore durante la creazione del progetto. Riprova.';
	@override String get updateProjectError => 'Errore durante l\'aggiornamento del progetto. Riprova.';
	@override String get refreshError => 'Aggiornamento non riuscito. Riprova.';
	@override String get restoreProjectFailed => 'Impossibile ripristinare il progetto. Riprova.';
	@override String get restoreProjectError => 'Errore durante il ripristino del progetto. Riprova.';
	@override String get restoreSessionFailed => 'Impossibile ripristinare la sessione. Riprova.';
	@override String get restoreSessionError => 'Errore durante il ripristino della sessione. Riprova.';
	@override String get changeWorkspaceFailed => 'Cambio di spazio di lavoro non riuscito. Riprova.';
	@override String get changeWorkspaceError => 'Errore nel cambio di spazio di lavoro. Riprova.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Eliminazione di ${count} sessione non riuscita. Riprova.',
		other: 'Eliminazione di ${count} sessioni non riuscita. Riprova.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$it extends Translations$sidebar$version$en {
	Translations$sidebar$version$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Aggiornamento disponibile';
	@override String get restartRequired => 'Aggiornamento installato — riavvia il server per applicarlo';
	@override String get updateNow => 'Aggiorna ora';
	@override String updateConfirm({required Object version}) => 'Aggiornare DDAgent a v${version}? Verrà scaricato e compilato il codice più recente e il server verrà riavviato — le sessioni attive saranno interrotte.';
	@override String get updating => 'Aggiornamento in corso… può richiedere alcuni minuti';
	@override String get restarting => 'Aggiornamento installato — riavvio…';
	@override String get updateFailed => 'Aggiornamento non riuscito';
	@override String get releaseNotes => 'Note di rilascio';
}

// Path: sidebar.search
class Translations$sidebar$search$it extends Translations$sidebar$search$en {
	Translations$sidebar$search$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Progetti';
	@override String get modeConversations => 'Conversazioni';
	@override String get conversationsPlaceholder => 'Cerca nelle conversazioni...';
	@override String get searching => 'Ricerca in corso...';
	@override String get sessionTitles => 'Titoli delle sessioni';
	@override String get conversationContents => 'Contenuto delle conversazioni';
	@override String get noResults => 'Nessun risultato trovato';
	@override String get tryDifferentQuery => 'Prova con una ricerca diversa';
	@override String get modeRunning => 'In esecuzione';
	@override String get archiveOnly => 'Archivio';
	@override String get runningTooltip => 'Sessioni in esecuzione';
	@override String get archiveOnlyTooltip => 'Solo archivio';
	@override String runningCount({required Object count}) => '${count} attive';
	@override String get viewMenu => 'Vista';
	@override String get backToProjects => 'Torna ai progetti';
	@override String get archivedPlaceholder => 'Cerca sessioni archiviate...';
	@override String get runningPlaceholder => 'Cerca sessioni in esecuzione...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} corrispondenza',
		other: '${count} corrispondenze',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} progetto analizzato',
		other: '${count} progetti analizzati',
	);
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$it extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Rimuovi progetto';
	@override String get deleteSession => 'Elimina sessione';
	@override String get confirmDelete => 'Cosa vuoi fare con';
	@override String get removeFromSidebar => 'Rimuovi solo dalla barra laterale';
	@override String get deleteAllData => 'Elimina tutti i dati permanentemente';
	@override String get allConversationsDeleted => 'Il progetto verrà rimosso dalla barra laterale. I tuoi file, memorie e dati delle sessioni verranno preservati.';
	@override String get cannotUndo => 'Puoi riaggiungerlo in seguito.';
	@override String get bulkDeleteSessionsDescription => 'L’archiviazione nasconde le sessioni selezionate dall’elenco attivo preservandone le cronologie.';
	@override String get archiveSession => 'Archivia sessione';
	@override String get archiveSessionNotice => 'L’archiviazione tiene la sessione fuori dall’elenco attivo preservandone la cronologia.';
	@override String get archivedSessionNotice => 'Questa sessione è già archiviata. Puoi tenerla nascosta o eliminarla definitivamente.';
	@override String get deleteSessionNotice => 'Questo rimuove definitivamente la sessione e la sua trascrizione. L’azione è irreversibile.';
	@override String get deleteSessionPermanently => 'Elimina definitivamente';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Questo progetto contiene ${count} conversazione.',
		other: 'Questo progetto contiene ${count} conversazioni.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Gestisci sessione selezionata',
		other: 'Gestisci ${count} sessioni selezionate',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Archivia sessione',
		other: 'Archivia ${count} sessioni',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$it extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Attivi ora';
	@override String get recent => 'Usati di recente';
	@override String get today => 'Oggi';
	@override String get yesterday => 'Ieri';
	@override String get thisWeek => 'Questa settimana';
	@override String showMore({required Object count}) => 'Mostra altri ${count}';
	@override String get showLess => 'Mostra meno';
}

// Path: sidebar.panel
class Translations$sidebar$panel$it extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get open => 'Pannello';
	@override String get newChat => 'Nuova chat';
	@override String get navigation => 'Navigazione';
	@override String get sessions => 'Sessioni';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$it extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cambia spazio di lavoro della sessione';
	@override String get description => 'L’agente esegue i suoi prossimi turni in questa directory. La cronologia della sessione esistente è preservata.';
	@override String get pathLabel => 'Percorso dello spazio di lavoro';
	@override String get pathRequired => 'Il percorso dello spazio di lavoro è obbligatorio.';
	@override String get submit => 'Cambia spazio di lavoro';
	@override String get saving => 'Cambio in corso…';
	@override String get changeAction => 'Cambia spazio di lavoro';
}

// Path: sidebar.recent
class Translations$sidebar$recent$it extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conversazioni recenti';
	@override String get emptyTitle => 'Ancora nessuna conversazione';
	@override String get emptyDescription => 'Le tue conversazioni aggiornate più di recente appariranno qui.';
	@override String get loadFailed => 'Impossibile caricare le conversazioni recenti';
	@override String get loadMore => 'Carica conversazioni precedenti';
	@override String get loadingMore => 'Caricamento...';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$it extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get board => 'Bacheca agenti';
	@override String get files => 'File';
	@override String get git => 'Controllo del codice';
	@override String get tasks => 'Attività';
	@override String get usage => 'Quota e utilizzo';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$it extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI non è configurato';
	@override String get description => 'TaskMaster aiuta a suddividere progetti complessi in attività gestibili con assistenza AI';
	@override String get whatIsTitle => '🎯 Cos\'è TaskMaster?';
	@override late final Translations$tasks$notConfigured$features$it features = Translations$tasks$notConfigured$features$it._(_root);
	@override String get initializeButton => 'Inizializza TaskMaster AI';
	@override String get writePrdFirst => 'Scrivi prima il PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$it extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inizia con TaskMaster';
	@override String get subtitle => 'TaskMaster è inizializzato! Ecco cosa fare dopo:';
	@override late final Translations$tasks$gettingStarted$steps$it steps = Translations$tasks$gettingStarted$steps$it._(_root);
	@override String get tip => '💡 Suggerimento: inizia con un PRD per ottenere il massimo dalla generazione di attività AI di TaskMaster';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$it extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configurazione TaskMaster';
	@override String subtitle({required Object projectName}) => 'CLI interattiva per ${projectName}';
	@override String get willStart => 'L\'inizializzazione di TaskMaster partirà automaticamente';
	@override String get completed => 'Configurazione TaskMaster completata! Ora puoi chiudere questa finestra.';
	@override String get closeButton => 'Chiudi';
	@override String get closeContinueButton => 'Chiudi e continua';
	@override String get closeTitle => 'Chiudi';
	@override String get description => 'Crea una cartella .taskmaster in questo progetto. Nessuno strumento esterno o chiave API richiesta — le attività sono salvate in locale.';
	@override String get initializeButton => 'Inizializza';
	@override String get initializing => 'Inizializzazione...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$it extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inizia con TaskMaster';
	@override String get subtitle => 'La tua guida per una gestione produttiva delle attività';
	@override late final Translations$tasks$helpGuide$examples$it examples = Translations$tasks$helpGuide$examples$it._(_root);
	@override String get moreExamples => 'Vedi altri esempi e pattern di utilizzo →';
	@override late final Translations$tasks$helpGuide$proTips$it proTips = Translations$tasks$helpGuide$proTips$it._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$it learnMore = Translations$tasks$helpGuide$learnMore$it._(_root);
	@override String get closeTitle => 'Chiudi';
}

// Path: tasks.search
class Translations$tasks$search$it extends Translations$tasks$search$en {
	Translations$tasks$search$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Cerca attività...';
}

// Path: tasks.filters
class Translations$tasks$filters$it extends Translations$tasks$filters$en {
	Translations$tasks$filters$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get button => 'Filtri';
	@override String get status => 'Stato';
	@override String get priority => 'Priorità';
	@override String get sortBy => 'Ordina per';
	@override String get allStatuses => 'Tutti gli stati';
	@override String get allPriorities => 'Tutte le priorità';
	@override String showing({required Object filtered, required Object total}) => 'Visualizzate ${filtered} di ${total} attività';
	@override String get clearFilters => 'Cancella filtri';
}

// Path: tasks.sort
class Translations$tasks$sort$it extends Translations$tasks$sort$en {
	Translations$tasks$sort$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Stato';
	@override String get priority => 'Priorità';
	@override String get idAsc => 'ID (crescente)';
	@override String get idDesc => 'ID (decrescente)';
	@override String get titleAsc => 'Titolo (A-Z)';
	@override String get titleDesc => 'Titolo (Z-A)';
	@override String get statusAsc => 'Stato (in attesa prima)';
	@override String get statusDesc => 'Stato (completati prima)';
	@override String get priorityAsc => 'Priorità (alta prima)';
	@override String get priorityDesc => 'Priorità (bassa prima)';
}

// Path: tasks.views
class Translations$tasks$views$it extends Translations$tasks$views$en {
	Translations$tasks$views$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Vista Kanban';
	@override String get list => 'Vista lista';
	@override String get grid => 'Vista griglia';
}

// Path: tasks.kanban
class Translations$tasks$kanban$it extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 Da fare';
	@override String get inProgress => '🚀 In corso';
	@override String get review => '👀 Revisione';
	@override String get done => '✅ Completate';
	@override String get blocked => '🚫 Bloccate';
	@override String get deferred => '⏳ Rimandate';
	@override String get cancelled => '❌ Annullate';
	@override String get noTasksYet => 'Nessuna attività';
	@override String get tasksWillAppear => 'Le attività appariranno qui';
	@override String get moveTasksHere => 'Sposta le attività qui quando iniziate';
	@override String get completedTasksHere => 'Le attività completate appariranno qui';
	@override String get statusTasksHere => 'Le attività con questo stato appariranno qui';
}

// Path: tasks.buttons
class Translations$tasks$buttons$it extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get help => 'Guida introduttiva TaskMaster';
	@override String get prds => 'PRD';
	@override String get addPRD => 'Aggiungi PRD';
	@override String get addTask => 'Aggiungi attività';
	@override String get createNewPRD => 'Crea nuovo PRD';
	@override String prdsAvailable({required Object count}) => '${count} PRD disponibili';
}

// Path: tasks.prd
class Translations$tasks$prd$it extends Translations$tasks$prd$en {
	Translations$tasks$prd$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Modificato: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String fileExistsMessage({required Object name}) => 'Esiste già un PRD chiamato "${name}". Vuoi sovrascriverlo?';
	@override String get fileExistsTitle => 'Il file esiste già';
	@override String get newFile => 'nuovo file';
	@override String get parse => 'Analizza PRD';
	@override String get template => 'Template';
	@override String get fileNameHint => 'nome file (es. prd.txt)';
	@override String get saved => 'PRD salvato';
	@override String get tasksGenerated => 'Attività generate dal PRD';
}

// Path: tasks.statuses
class Translations$tasks$statuses$it extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get pending => 'In attesa';
	@override String get inProgress => 'In corso';
	@override String get done => 'Completata';
	@override String get blocked => 'Bloccata';
	@override String get deferred => 'Rimandata';
	@override String get cancelled => 'Annullata';
	@override String get review => 'Revisione';
}

// Path: tasks.priorities
class Translations$tasks$priorities$it extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get high => 'Alta';
	@override String get medium => 'Media';
	@override String get low => 'Bassa';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$it extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nessuna attività corrisponde ai filtri';
	@override String get description => 'Prova a modificare la ricerca o i criteri di filtro.';
}

// Path: tasks.board
class Translations$tasks$board$it extends Translations$tasks$board$en {
	Translations$tasks$board$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bacheca agenti';
	@override String get subtitle => 'Sposta una scheda in Pronta e l’agente la prende in carico. Clicca una scheda per aprire la sua sessione.';
	@override String get newCard => 'Nuova scheda';
	@override String get addCard => 'Aggiungi scheda';
	@override String get refresh => 'Aggiorna';
	@override late final Translations$tasks$board$empty$it empty = Translations$tasks$board$empty$it._(_root);
	@override late final Translations$tasks$board$columns$it columns = Translations$tasks$board$columns$it._(_root);
	@override late final Translations$tasks$board$card$it card = Translations$tasks$board$card$it._(_root);
	@override late final Translations$tasks$board$dialog$it dialog = Translations$tasks$board$dialog$it._(_root);
	@override String get noProject => 'Aggiungi prima un progetto, poi crea le schede per esso.';
	@override String get projectLabel => 'Progetto';
	@override String get backToChat => 'Torna alla chat';
	@override late final Translations$tasks$board$agent$it agent = Translations$tasks$board$agent$it._(_root);
	@override late final Translations$tasks$board$deleteConfirm$it deleteConfirm = Translations$tasks$board$deleteConfirm$it._(_root);
	@override String get project => 'Progetto';
}

// Path: tasks.card
class Translations$tasks$card$it extends Translations$tasks$card$en {
	Translations$tasks$card$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Dipende da: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Attività ${id}';
	@override String get highPriority => 'Priorità alta';
	@override String get lowPriority => 'Priorità bassa';
	@override String get mediumPriority => 'Priorità media';
	@override String get noPriority => 'Nessuna priorità impostata';
	@override String parentTask({required Object id}) => 'Attività ${id}';
	@override String get progressLabel => 'Avanzamento:';
	@override String progressTooltip({required Object completed, required Object total}) => '${completed} di ${total} sottoattività completate';
	@override String get runTask => 'Esegui attività';
	@override String runTaskAria({required Object id}) => 'Esegui attività ${id}';
	@override String statusTooltip({required Object status}) => 'Stato: ${status}';
	@override String taskIdTitle({required Object id}) => 'ID attività: ${id}';
	@override String get taskInProgress => 'Attività in corso';
}

// Path: tasks.createTask
class Translations$tasks$createTask$it extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annulla';
	@override String get descriptionLabel => 'Descrizione';
	@override String get descriptionPlaceholder => 'Dettagli opzionali';
	@override String get error => 'Impossibile aggiungere l’attività';
	@override String get priorityLabel => 'Priorità';
	@override String get submit => 'Aggiungi attività';
	@override String get submitting => 'Aggiunta...';
	@override String get title => 'Aggiungi attività';
	@override String get titleLabel => 'Titolo';
	@override String get titlePlaceholder => 'Cosa va fatto?';
}

// Path: tasks.list
class Translations$tasks$list$it extends Translations$tasks$list$en {
	Translations$tasks$list$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Completata (clicca per riaprire)';
	@override String get inProgressComplete => 'In corso (clicca per completare)';
	@override String get markCompleted => 'Segna come completata';
	@override String toggleStatusAria({required Object id}) => 'Cambia stato dell’attività ${id}';
	@override String get markDone => 'Segna come completata';
	@override String get reopen => 'Riapri';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$it extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Tutte le attività completate';
	@override String get feature1 => '- Gestione attività con AI, dipendenze e sottoattività.';
	@override String get feature2 => '- Generazione attività da PRD per un avvio più rapido.';
	@override String get feature3 => '- Viste kanban e lista per il lavoro quotidiano.';
	@override String get hideDetails => 'Nascondi dettagli';
	@override String get initialize => 'Inizializza';
	@override String get noPending => 'Nessuna attività in sospeso';
	@override String get notConfigured => 'TaskMaster AI non è configurato';
	@override String get review => 'Revisiona';
	@override String get startTask => 'Avvia attività';
	@override String taskId({required Object id}) => 'Attività ${id}';
	@override String get viewAll => 'Vedi tutte le attività';
	@override String get viewDetails => 'Vedi dettagli attività';
	@override String get whatIs => 'Cos’è TaskMaster?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$it extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Annulla modifica';
	@override String get close => 'Chiudi';
	@override String get copyTaskId => 'Copia ID attività';
	@override String get delete => 'Elimina attività';
	@override String deleteConfirmDescription({required Object title}) => '"${title}" verrà eliminata definitivamente.';
	@override String get deleteConfirmTitle => 'Eliminare l\'attività?';
	@override String get deleteFailed => 'Impossibile eliminare l\'attività';
	@override String get dependencies => 'Dipendenze';
	@override String get dependenciesPlaceholder => 'es. 1, 2, 3';
	@override String get description => 'Descrizione';
	@override String get edit => 'Modifica attività';
	@override String get implDetails => 'Dettagli di implementazione';
	@override String get noDependencies => 'Nessuna dipendenza';
	@override String get noDescription => 'Nessuna descrizione fornita';
	@override String get priority => 'Priorità';
	@override String get priorityNotSet => 'Non impostata';
	@override String get save => 'Salva';
	@override String get status => 'Stato';
	@override String get statusFailed => 'Impossibile aggiornare lo stato dell’attività';
	@override String taskId({required Object id}) => 'Attività ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Attività ${id}: ${title}';
	@override String get testStrategy => 'Strategia di test';
	@override String get titleRequired => 'Il titolo è obbligatorio';
	@override String get updateFailed => 'Impossibile aggiornare l’attività';
	@override String deleteConfirmMessage({required Object id}) => 'L\'attività #${id} verrà rimossa. L\'azione è irreversibile.';
	@override String get notFound => 'Attività non trovata';
	@override String get subtasks => 'Sottoattività';
	@override String get idCopied => 'ID attività copiato';
}

// Path: tasks.toasts
class Translations$tasks$toasts$it extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Attività ${id} impostata su in corso';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$it extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Dashboard';
	@override String get memories => 'Ricordi';
	@override String get rules => 'Regole';
	@override String get skills => 'Competenze';
	@override String get personal => 'Personale';
	@override String get graph => 'Grafo';
}

// Path: knowledge.common
class Translations$knowledge$common$it extends Translations$knowledge$common$en {
	Translations$knowledge$common$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get add => 'Aggiungi';
	@override String get save => 'Salva';
	@override String get cancel => 'Annulla';
	@override String get delete => 'Elimina';
	@override String get edit => 'Modifica';
	@override String get close => 'Chiudi';
	@override String get restore => 'Ripristina';
	@override String get refresh => 'Aggiorna';
	@override String get allProjects => 'Tutti i progetti';
	@override String get global => 'Globale';
}

// Path: knowledge.actions
class Translations$knowledge$actions$it extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Scansiona i file del progetto';
	@override String get export => 'Esporta JSON';
	@override String get import => 'Importa JSON';
	@override String get scanComplete => 'Scansione completata';
	@override String get importComplete => 'Importazione completata';
	@override String get importFailed => 'Importazione non riuscita';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$it extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Nuova voce';
	@override String get editEntity => 'Modifica voce';
	@override String get deleteTitle => 'Elimina';
	@override String get deleteMessage => 'Eliminare questa voce? Non è reversibile (la cronologia viene conservata).';
	@override String get pickIcon => 'Scegli icona';
	@override String get removeIcon => 'Rimuovi icona';
	@override String get iconTooLarge => 'L\'icona è troppo grande (max 40 KB).';
	@override String get importTitle => 'Importa conoscenza';
	@override String get importHint => 'Incolla qui il JSON esportato';
	@override String get exportTitle => 'Esporta conoscenza';
	@override String get import => 'Importa';
}

// Path: knowledge.fields
class Translations$knowledge$fields$it extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get key => 'Chiave';
	@override String get title => 'Titolo';
	@override String get name => 'Nome';
	@override String get description => 'Descrizione';
	@override String get category => 'Categoria';
	@override String get content => 'Contenuto';
	@override String get priority => 'Priorità';
	@override String get tags => 'Tag';
	@override String get enabled => 'Attivo';
	@override String get projectScope => 'Ambito del progetto';
	@override String get tagsHint => 'separate da virgole';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$it extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Ricordi';
	@override String get rules => 'Regole';
	@override String get skills => 'Competenze';
	@override String get personal => 'Personale';
	@override String get connections => 'Connessioni';
	@override String get recent => 'Ricordi recenti';
	@override String get noMemories => 'Nessun ricordo. Aggiungine uno nella scheda Ricordi.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$it extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Nessun ricordo.';
	@override String get rules => 'Nessuna regola.';
	@override String get skills => 'Nessuna competenza.';
	@override String get personal => 'Nessuna informazione personale.';
	@override String get graph => 'Nessuna entità da mostrare.';
}

// Path: knowledge.history
class Translations$knowledge$history$it extends Translations$knowledge$history$en {
	Translations$knowledge$history$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cronologia';
	@override String get none => 'Nessuna cronologia.';
	@override String get untitled => '(senza titolo)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$it extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Critica';
	@override String get high => 'Alta';
	@override String get normal => 'Normale';
	@override String get low => 'Bassa';
}

// Path: knowledge.search
class Translations$knowledge$search$it extends Translations$knowledge$search$en {
	Translations$knowledge$search$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cerca nella conoscenza';
	@override String get hint => 'Cerca ricordi, regole, competenze…';
	@override String get noResults => 'Nessun risultato.';
}

// Path: knowledge.links
class Translations$knowledge$links$it extends Translations$knowledge$links$en {
	Translations$knowledge$links$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Collega entità';
	@override String get source => 'Origine';
	@override String get target => 'Destinazione';
	@override String get relationship => 'Relazione';
	@override String get add => 'Crea collegamento';
}

// Path: knowledge.tags
class Translations$knowledge$tags$it extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get all => 'Tutti i tag';
	@override String get manage => 'Gestisci tag';
	@override String get none => 'Nessun tag.';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$it extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
}

// Path: knowledge.critical
class Translations$knowledge$critical$it extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get make => 'Rendi critica';
	@override String get makeAll => 'Rendi tutte le regole critiche';
	@override String get makeAllHint => 'Le aggiunge al budget di contesto iniettato';
}

// Path: knowledge.errors
class Translations$knowledge$errors$it extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'Importazione non riuscita: ${error}';
	@override String migrationFailed({required Object error}) => 'Migrazione non riuscita: ${error}';
}

// Path: knowledge.graph
class Translations$knowledge$graph$it extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'troncato';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$it extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get action => 'Importa tutto';
	@override String get mergeDuplicates => 'Unisci le voci duplicate';
	@override String get mergeDuplicatesHint => 'Unisce le righe duplicate in DDAgent (non i file)';
	@override String projectsScanned({required Object count}) => 'Progetti analizzati: ${count}';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Regole: ${total} · gruppi duplicati: ${duplicates}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Skill degli agenti trovate: ${found} (nuove: ${newSkills})';
	@override String get title => 'Importa tutto in DDAgent';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$it extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String found({required Object count}) => 'Trovate ${count} skill nei tuoi agenti.';
	@override String summary({required Object imported, required Object skipped}) => 'Nuove: ${imported} · saltate: ${skipped}';
	@override String get title => 'Importa le skill degli agenti';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$it extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Memoria: ${title}';
	@override String personal({required Object title}) => 'Personale: ${title}';
	@override String rule({required Object title}) => 'Regola: ${title}';
	@override String skill({required Object name}) => 'Skill: ${name}';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$it extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String duplicates({required Object count}) => 'Gruppi duplicati tra i progetti: ${count}';
	@override String get mergeDuplicates => 'Unisci i duplicati';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Rimosse: ${removed}, promosse: ${promoted}';
	@override String rulesSummary({required Object total, required Object critical}) => 'Regole: ${total} in totale, ${critical} critiche.';
	@override String scanned({required Object count}) => 'Analizzati ${count} progetti.';
	@override String get title => 'Migra le regole esistenti';
}

// Path: skills.addDialog
class Translations$skills$addDialog$it extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => 'Scegli SKILL.md';
	@override String get chooseFiles => 'Scegli file';
	@override String get chooseFolder => 'Scegli cartella';
	@override String get chooseFolderTitle => 'Scegli una cartella di skill';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} file · ${size}',
		other: '${count} file · ${size}',
	);
	@override String get folderUploadsNote => 'I caricamenti delle cartelle mantengono il nome della cartella selezionata; i file singoli usano il `name` in `SKILL.md`.';
	@override String get hideInstallLocation => 'Nascondi posizione di installazione';
	@override String get installSkill => 'Installa Skill';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Installa ${count} Skill',
		other: 'Installa ${count} Skill',
	);
	@override String markdownFileMeta({required Object size}) => 'File Markdown · ${size}';
	@override String get pickHint => 'Le cartelle possono includere script, riferimenti e asset.';
	@override String get pickTitle => 'Seleziona una cartella di skill o SKILL.md';
	@override String get readyToInstall => 'Pronto per l\'installazione';
	@override String removeQueued({required Object name}) => 'Rimuovi ${name}';
	@override String title({required Object provider}) => 'Aggiungi Skill di ${provider}';
	@override String get uploadHint => 'Carica un file SKILL.md o una cartella di skill completa.';
	@override String get whereWillThisInstall => 'Dove verrà installato?';
}

// Path: skills.empty
class Translations$skills$empty$it extends Translations$skills$empty$en {
	Translations$skills$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get noGlobalSkills => 'Nessuna skill globale ancora rilevata';
	@override String get noGlobalSkillsDescription => 'Aggiungi una skill globale qui sopra per renderla disponibile in ogni progetto.';
	@override String get noMatchingSkills => 'Nessuna skill corrispondente';
	@override String get noMatchingSkillsDescription => 'Prova con un comando, nome, ambito, progetto o percorso di origine diverso.';
	@override String get noProjects => 'Nessun progetto disponibile';
	@override String get noProjectsDescription => 'Aggiungi un progetto o workspace per sfogliarne le skill.';
	@override String get noSkillsInProject => 'Nessuna skill in questo progetto';
	@override String get noSkillsInProjectDescription => 'Crea una cartella .claude/skills, .cursor/skills o .agents/skills nel progetto selezionato.';
}

// Path: skills.errors
class Translations$skills$errors$it extends Translations$skills$errors$en {
	Translations$skills$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get addMarkdownFirst => 'Aggiungi prima uno o più file markdown.';
	@override String couldNotReadSkillFile({required Object name}) => 'Impossibile leggere SKILL.md da ${name}.';
	@override String get dropMarkdownOrFolder => 'Trascina uno o più file markdown o una cartella contenente SKILL.md.';
	@override String folderFileLimit({required Object count}) => 'Una cartella di skill può contenere fino a ${count} file.';
	@override String get folderReadFailed => 'Impossibile leggere la cartella di skill';
	@override String get folderSizeLimit => 'Le cartelle di skill selezionate devono essere più piccole di 30 MB in totale.';
	@override String get importFailed => 'Importazione delle skill non riuscita';
	@override String get missingSkillFile => 'La cartella selezionata non contiene un file SKILL.md.';
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$it extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get moveToGlobal => 'Sposta in globale';
	@override String get moveToProject => 'Sposta nel progetto';
	@override String get toGlobalHint => 'Sposta questa skill nella cartella delle skill globali così ogni progetto può usarla.';
	@override String get toProjectHint => 'Scegli il progetto a cui assegnare questa skill. Verrà rimossa dalla cartella delle skill globali del provider.';
}

// Path: skills.scopes
class Translations$skills$scopes$it extends Translations$skills$scopes$en {
	Translations$skills$scopes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get admin => 'Admin';
	@override String get plugin => 'Plugin';
	@override String get project => 'Progetto';
	@override String get repo => 'Repository';
	@override String get system => 'Sistema';
	@override String get user => 'Utente';
}

// Path: skills.screen
class Translations$skills$screen$it extends Translations$skills$screen$en {
	Translations$skills$screen$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get addSkill => 'Aggiungi Skill';
	@override String get clearSearch => 'Cancella ricerca skill';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Rimuove la cartella ${directory} dalla cartella delle skill gestite di ${provider}. L\'azione è irreversibile.';
	@override String deleteTitle({required Object name}) => 'Eliminare ${name}?';
	@override String loadingSkills({required Object provider}) => 'Caricamento delle skill di ${provider}…';
	@override String manageDescription({required Object provider}) => 'Gestisci le skill di ${provider} da file locali, cartelle complete e percorsi legati al progetto.';
	@override String get noDescription => 'Nessuna descrizione fornita nel front matter della skill.';
	@override String pluginBadge({required Object name}) => 'Plugin: ${name}';
	@override String projectBadge({required Object name}) => 'Progetto: ${name}';
	@override String get savedSuccessfully => 'Skill salvate correttamente.';
	@override String get scanningProjectSkills => 'Scansione delle skill del progetto…';
	@override String get searchHint => 'Cerca skill…';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '${count} SKILL',
		other: '${count} SKILL',
	);
	@override String get sourceLabel => 'ORIGINE';
}

// Path: mcp.form
class Translations$mcp$form$it extends Translations$mcp$form$en {
	Translations$mcp$form$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$fields$it fields = Translations$mcp$form$fields$it._(_root);
	@override late final Translations$mcp$form$scope$it scope = Translations$mcp$form$scope$it._(_root);
	@override String submitTo({required Object provider}) => 'Aggiungi server a ${provider}';
	@override late final Translations$mcp$form$validation$it validation = Translations$mcp$form$validation$it._(_root);
}

// Path: mcp.install
class Translations$mcp$install$it extends Translations$mcp$install$en {
	Translations$mcp$install$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get button => 'Installa';
	@override String get cardDescription => 'Dai ai tuoi agenti la base di conoscenza e gli strumenti DDAgent tramite MCP — scegli gli agenti o installa per tutti.';
	@override String get description => 'Consente agli agenti selezionati di usare la base di conoscenza e gli strumenti DDAgent tramite MCP.';
	@override String get errorFallback => 'errore';
	@override String failed({required Object error}) => 'Installazione non riuscita: ${error}';
	@override String get installForAll => 'Installa per tutti';
	@override String get installSelected => 'Installa selezionati';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Installato su ${count} agente.',
		other: 'Installato su ${count} agenti.',
	);
	@override String partialFailure({required Object count, required Object failed}) => 'Installato su ${count}; non riuscito: ${failed}';
	@override String get title => 'Installa il server MCP DDAgent';
}

// Path: mcp.servers
class Translations$mcp$servers$it extends Translations$mcp$servers$en {
	Translations$mcp$servers$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get addGlobalDescription => 'Aggiunge questo server MCP a ogni provider: Claude, Cursor, Codex, OpenCode e Devin. Sono supportati solo i trasporti stdio e HTTP perché la stessa configurazione deve funzionare su tutti i provider.';
	@override String get addGlobalMenuDescription => 'Aggiungi server MCP globale scrive un unico server stdio o HTTP comune in Claude, Cursor, Codex, OpenCode e Devin.';
	@override String get addGlobalTitle => 'Aggiungi server MCP globale';
	@override String addProviderDescription({required Object provider}) => 'Aggiungi server MCP di ${provider} modifica solo ${provider}.';
	@override String addProviderTitle({required Object provider}) => 'Aggiungi server MCP di ${provider}';
	@override late final Translations$mcp$servers$config$it config = Translations$mcp$servers$config$it._(_root);
	@override String descriptionGeneric({required Object provider}) => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a ${provider}';
	@override String get loading => 'Caricamento server MCP…';
	@override String get refreshingScopes => 'Aggiornamento degli ambiti del progetto…';
}

// Path: mcp.team
class Translations$mcp$team$it extends Translations$mcp$team$en {
	Translations$mcp$team$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cta => 'Disponibile con DDAgent Pro';
	@override String get description => 'Condividi le configurazioni dei server MCP con il tuo team. Tutti restano sincronizzati automaticamente.';
	@override String get title => 'Configurazioni MCP del team';
}

// Path: mcp.tokens
class Translations$mcp$tokens$it extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Scrittura';
}

// Path: terminal.actions
class Translations$terminal$actions$it extends Translations$terminal$actions$en {
	Translations$terminal$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get clearOutput => 'Cancella output';
	@override String get connect => 'Connetti';
	@override String get newShell => 'Nuova shell';
	@override String get newTab => 'Nuova scheda terminale';
	@override String get providerLogin => 'Accesso provider';
	@override String get restartSession => 'Riavvia sessione';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$it extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Apri nel browser';
}

// Path: terminal.errors
class Translations$terminal$errors$it extends Translations$terminal$errors$en {
	Translations$terminal$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'Impossibile aprire il link: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$it extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'File rilevato: ${path}';
}

// Path: terminal.paste
class Translations$terminal$paste$it extends Translations$terminal$paste$en {
	Translations$terminal$paste$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Ctrl+V / clic destro → Incolla';
	@override String get title => 'Incolla nel terminale';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$it extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get eof => 'EOF';
	@override String get hide => 'Nascondi barra scorciatoie';
	@override String get interrupt => 'Interrompi (SIGINT)';
	@override String get suspend => 'Sospendi (SIGTSTP)';
	@override String get showTooltip => 'Mostra scorciatoie';
	@override String get hideTooltip => 'Nascondi scorciatoie';
}

// Path: terminal.tabs
class Translations$terminal$tabs$it extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get claudeCli => 'Claude CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'Accesso: ${provider}';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get plainShell => 'Shell semplice';
	@override String shellName({required Object index}) => 'Shell ${index}';
}

// Path: quota.agents
class Translations$quota$agents$it extends Translations$quota$agents$en {
	Translations$quota$agents$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.chart
class Translations$quota$chart$it extends Translations$quota$chart$en {
	Translations$quota$chart$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get hide => 'Nascondi';
	@override String get noData => 'Dati insufficienti per una tendenza.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} token · ${cost}';
	@override String get show => 'Mostra';
}

// Path: quota.config
class Translations$quota$config$it extends Translations$quota$config$en {
	Translations$quota$config$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get accountRouting => 'Routing account';
	@override String get pollerTitle => 'Polling e avvisi';
	@override String get save => 'Salva configurazione';
}

// Path: quota.overview
class Translations$quota$overview$it extends Translations$quota$overview$en {
	Translations$quota$overview$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Token e costo';
}

// Path: quota.section
class Translations$quota$section$it extends Translations$quota$section$en {
	Translations$quota$section$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get config => 'Configurazione';
}

// Path: notifications.errors
class Translations$notifications$errors$it extends Translations$notifications$errors$en {
	Translations$notifications$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get noResponse => 'Nessuna risposta dal server';
	@override String get registrationRejected => 'Registrazione rifiutata dal server';
}

// Path: serverConnect.local
class Translations$serverConnect$local$it extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Questo dispositivo';
	@override String get subtitle => 'Esegui il server DDAgent su questa macchina';
	@override String get install => 'Installa il server locale';
	@override String get start => 'Avvia il server locale';
	@override String get stop => 'Arresta';
	@override String get starting => 'Avvio del server locale…';
	@override String downloading({required Object percent}) => 'Download del server… ${percent}%';
	@override String get installing => 'Installazione…';
	@override String running({required Object url}) => 'In esecuzione su ${url}';
	@override String installed({required Object version}) => 'Installato (v${version})';
	@override String get connect => 'Usa questo server';
	@override String error({required Object error}) => 'Errore del server locale: ${error}';
	@override String get or => 'oppure connettiti a un server remoto';
}

// Path: collab.roles
class Translations$collab$roles$it extends Translations$collab$roles$en {
	Translations$collab$roles$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get member => 'Membro';
	@override String get viewer => 'Visualizzatore';
}

// Path: sessions.activity
class Translations$sessions$activity$it extends Translations$sessions$activity$en {
	Translations$sessions$activity$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get committingChanges => 'Commit delle modifiche';
	@override String editingFile({required Object file}) => 'Modifica di ${file}';
	@override String get editingFileGeneric => 'Modifica di un file';
	@override String fetchingUrl({required Object url}) => 'Recupero di ${url}';
	@override String get pushingBranch => 'Push del branch';
	@override String readingFile({required Object file}) => 'Lettura di ${file}';
	@override String runningCommand({required Object command}) => 'Esecuzione di `${command}`';
	@override String get runningShellCommand => 'Esecuzione di un comando shell';
	@override String runningTool({required Object name}) => 'Esecuzione di ${name}';
	@override String searching({required Object query}) => 'Ricerca di “${query}”';
	@override String get subagentRunning => 'Subagent in esecuzione';
}

// Path: sessions.age
class Translations$sessions$age$it extends Translations$sessions$age$en {
	Translations$sessions$age$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String days({required Object days}) => '${days}g';
	@override String hours({required Object hours}) => '${hours}h';
	@override String get lessThanMinute => '<1m';
	@override String minutes({required Object count}) => '${count}m';
}

// Path: sessions.toasts
class Translations$sessions$toasts$it extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Sessione archiviata';
	@override String get deleted => 'Sessione eliminata';
	@override String get pinned => 'Sessione fissata';
	@override String get renamed => 'Sessione rinominata';
	@override String get restored => 'Sessione ripristinata';
	@override String get unpinned => 'Sessione non fissata';
	@override String get workspaceChanged => 'Workspace modificato';
}

// Path: git.checkpoints
class Translations$git$checkpoints$it extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get create => 'Nuovo';
	@override String get empty => 'Nessun checkpoint ancora';
	@override String get labelHint => 'Etichetta del checkpoint (opzionale)';
	@override String get restoreMessage => 'Ripristinare l\'albero di lavoro a questo checkpoint? Le modifiche attuali verranno sostituite.';
	@override String get restoreTitle => 'Ripristina checkpoint';
	@override String get restored => 'Checkpoint ripristinato';
	@override String get title => 'Checkpoint';
}

// Path: kanban.card
class Translations$kanban$card$it extends Translations$kanban$card$en {
	Translations$kanban$card$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Senza titolo';
}

// Path: kanban.comments
class Translations$kanban$comments$it extends Translations$kanban$comments$en {
	Translations$kanban$comments$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get add => 'Aggiungi commento';
	@override String get empty => 'Nessun commento ancora';
}

// Path: kanban.details
class Translations$kanban$details$it extends Translations$kanban$details$en {
	Translations$kanban$details$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String status({required Object status}) => 'Stato: ${status}';
	@override String get title => 'Dettagli della scheda';
}

// Path: kanban.dialog
class Translations$kanban$dialog$it extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Salvataggio…';
}

// Path: kanban.empty
class Translations$kanban$empty$it extends Translations$kanban$empty$en {
	Translations$kanban$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Nessun progetto selezionato';
}

// Path: kanban.time
class Translations$kanban$time$it extends Translations$kanban$time$en {
	Translations$kanban$time$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '1 giorno fa',
		other: '${count} giorni fa',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '1 ora fa',
		other: '${count} ore fa',
	);
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: '1 minuto fa',
		other: '${count} minuti fa',
	);
	@override String get now => 'adesso';
}

// Path: onboarding.agents
class Translations$onboarding$agents$it extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Accedi a uno o più assistenti di programmazione AI. Tutti sono opzionali.';
	@override String get laterHint => 'Puoi configurarli in seguito nelle Impostazioni.';
	@override String get title => 'Connetti i tuoi agenti AI';
}

// Path: onboarding.errors
class Translations$onboarding$errors$it extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get invalidEmail => 'Inserisci un indirizzo email valido.';
	@override String get nameAndEmailRequired => 'Sono richiesti sia il nome git sia l\'email.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$it extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Installa il server MCP DDAgent così i tuoi agenti possono usare la base di conoscenza e gli strumenti DDAgent. Scegli gli agenti o installa per tutti.';
	@override String get installForAll => 'Installa per tutti';
	@override String get installSelected => 'Installa selezionati';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count,
		one: 'Installato su ${count} agente.',
		other: 'Installato su ${count} agenti.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => 'Installato su ${installedCount}; non riuscito: ${failed}';
	@override String get laterHint => 'Opzionale — puoi installarlo anche in seguito in Impostazioni → MCP.';
	@override String get title => 'Connetti gli agenti a DDAgent';
}

// Path: fileTree.search
class Translations$fileTree$search$it extends Translations$fileTree$search$en {
	Translations$fileTree$search$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Filtra i nomi / Invio per cercare nei contenuti';
	@override String get noMatches => 'Nessuna corrispondenza';
	@override String get prompt => 'Digita una query e premi Invio';
	@override String get resultsTruncated => 'Risultati troncati';
}

// Path: fileTree.titles
class Translations$fileTree$titles$it extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String delete({required Object name}) => 'Elimina ${name}';
	@override String download({required Object name}) => 'Scarica ${name}';
	@override String rename({required Object name}) => 'Rinomina ${name}';
}

// Path: auth.login.errors
class Translations$auth$login$errors$it extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Nome utente o password non validi';
	@override String get requiredFields => 'Compila tutti i campi';
	@override String get networkError => 'Errore di rete. Riprova.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$it extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get username => 'Inserisci il tuo nome utente';
	@override String get password => 'Inserisci la tua password';
}

// Path: auth.register.errors
class Translations$auth$register$errors$it extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Le password non corrispondono';
	@override String get usernameTaken => 'Nome utente già in uso';
	@override String get weakPassword => 'La password è troppo debole';
	@override String get usernameTooShort => 'Il nome utente deve contenere almeno 3 caratteri';
	@override String get passwordTooShort => 'La password deve contenere almeno 6 caratteri';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$it extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Modalità predefinita';
	@override String get auto => 'Modalità automatica';
	@override String get acceptEdits => 'Accetta modifiche';
	@override String get bypassPermissions => 'Ignora permessi';
	@override String get plan => 'Modalità piano';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$it extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Solo i comandi attendibili (ls, cat, grep, git status, ecc.) vengono eseguiti automaticamente. Gli altri comandi vengono saltati. Può scrivere nell\'area di lavoro.';
	@override String get auto => 'Un classificatore di modello decide per ogni chiamata se approvare o negare. Alta autonomia.';
	@override String get acceptEdits => 'Tutti i comandi vengono eseguiti automaticamente nell\'area di lavoro. Modalità completamente automatica con esecuzione sandboxed.';
	@override String get bypassPermissions => 'Accesso completo al sistema senza restrizioni. Tutti i comandi vengono eseguiti automaticamente con accesso completo a disco e rete. Usa con cautela.';
	@override String get plan => 'Modalità pianificazione - nessun comando viene eseguito';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$it extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Invio per inviare • / comandi • @ file';
	@override String get enter => 'Invio per inviare • Shift+Invio nuova riga • / comandi • @ file';
	@override String get queue => 'Invio per accodare il prossimo messaggio';
	@override String get updateQueued => 'Invio per aggiornare il messaggio in coda';
}

// Path: chat.input.queue
class Translations$chat$input$queue$it extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Accoda prossimo messaggio';
	@override String get update => 'Aggiorna messaggio in coda';
	@override String get label => 'In coda';
	@override String get willSend => 'Sarà inviato al termine';
	@override String get edit => 'Modifica messaggio in coda';
	@override String get delete => 'Elimina messaggio in coda';
	@override String get failed => 'Invio non riuscito';
	@override String get sendNow => 'Invia ora';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$it extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Annulla e svuota la coda offline';
	@override String get clearBtn => 'Annulla';
	@override String multiple({required Object count}) => '${count} messaggi in coda offline — verranno inviati automaticamente alla riconnessione';
	@override String get single => '1 messaggio in coda offline — verrà inviato automaticamente alla riconnessione';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$it extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'di Anthropic';
	@override String get openai => 'di OpenAI';
	@override String get cursorEditor => 'Editor codice AI';
	@override String get google => 'di Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$it extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Pronto a usare Claude con ${model}. Inizia a digitare il tuo messaggio qui sotto.';
	@override String cursor({required Object model}) => 'Pronto a usare Cursor con ${model}. Inizia a digitare il tuo messaggio qui sotto.';
	@override String codex({required Object model}) => 'Pronto a usare Codex con ${model}. Inizia a digitare il tuo messaggio qui sotto.';
	@override String get kDefault => 'Seleziona un provider sopra per iniziare';
	@override String opencode({required Object model}) => 'Pronto a usare OpenCode con ${model}. Inizia a scrivere il tuo messaggio qui sotto.';
	@override String devin({required Object model}) => 'Pronto con Devin ${model}';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$it extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Continua la tua conversazione';
	@override String get description => 'Fai domande sul tuo codice, richiedi modifiche o chiedi aiuto con le attività di sviluppo';
	@override String get action => 'Continua a scrivere';
}

// Path: chat.session.loading
class Translations$chat$session$loading$it extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Caricamento messaggi precedenti...';
	@override String get sessionMessages => 'Caricamento messaggi della sessione...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$it extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => 'Visualizzati ${shown} di ${total} messaggi';
	@override String get scrollToLoad => 'Scorri in alto per caricare altri';
	@override String showingLast({required Object count, required Object total}) => 'Visualizzati ultimi ${count} messaggi (${total} totali)';
	@override String get loadEarlier => 'Carica messaggi precedenti';
	@override String get loadAll => 'Carica tutti i messaggi';
	@override String get loadingAll => 'Caricamento di tutti i messaggi...';
	@override String get allLoaded => 'Tutti i messaggi caricati';
	@override String get perfWarning => 'Tutti i messaggi caricati — lo scorrimento potrebbe essere più lento. Clicca "Scorri in basso" per ripristinare le prestazioni.';
	@override String get loadOlderFailed => 'Impossibile caricare i messaggi precedenti.';
	@override String get retry => 'Riprova';
	@override String get noSearchMatches => 'Nessun messaggio corrisponde alla ricerca.';
	@override String loadAllCount({required Object count}) => 'Carica tutti (${count})';
	@override String get loadOlder => 'Carica messaggi precedenti';
	@override String retryLoadOlder({required Object error}) => 'Riprova a caricare i precedenti — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$it extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleziona un progetto';
	@override String get description => 'Scegli un progetto per aprire una shell interattiva in quella directory';
}

// Path: chat.shell.status
class Translations$chat$shell$status$it extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nuova sessione';
	@override String get initializing => 'Inizializzazione...';
	@override String get restarting => 'Riavvio...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$it extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Disconnetti';
	@override String get disconnectTitle => 'Disconnetti dalla shell';
	@override String get restart => 'Riavvia';
	@override String get restartTitle => 'Riavvia shell (disconnetti prima)';
	@override String get connect => 'Continua nella shell';
	@override String get connectTitle => 'Connetti alla shell';
	@override String get kill => 'Termina (SIGINT)';
	@override String get killTitle => 'Termina processo in esecuzione (Ctrl+C)';
	@override String get copyOutput => 'Copia output';
	@override String get copyOutputTitle => 'Copia output del terminale';
	@override String get copied => 'Copiato!';
	@override String get zoomInTitle => 'Ingrandisci';
	@override String get zoomOutTitle => 'Riduci';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$it extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Ragionamento';
	@override String get processing => 'Elaborazione';
	@override String get analyzing => 'Analisi';
	@override String get working => 'In lavorazione';
	@override String get computing => 'Calcolo';
	@override String get reasoning => 'Ragionamento';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$it extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get live => 'Attivo';
	@override String get paused => 'In pausa';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$it extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}s';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '${time} trascorsi';
	@override String get startingNow => 'Avvio in corso';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$it extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Interrompi generazione';
	@override String get pressEscToStop => 'Premi Esc in qualsiasi momento per interrompere';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$it extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Assistente';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$it extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get config => 'Apri impostazioni e configurazione.';
	@override String get cost => 'Esamina l\'utilizzo dei token per la sessione attiva.';
	@override String get help => 'Mostra la documentazione e la sintassi dei comandi.';
	@override String get memory => 'Apri il file di memoria CLAUDE.md del progetto.';
	@override String get models => 'Sfoglia i modelli disponibili per il provider attivo.';
	@override String get status => 'Controlla lo stato di runtime, versione, provider e ambiente.';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$it extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Rinomina';
	@override String get delete => 'Elimina';
	@override String get copyPath => 'Copia percorso';
	@override String get download => 'Scarica';
	@override String get newFile => 'Nuovo file';
	@override String get newFolder => 'Nuova cartella';
	@override String get upload => 'Carica file';
	@override String get refresh => 'Aggiorna';
	@override String get menuLabel => 'Menu contestuale file';
	@override String get loading => 'Caricamento...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$it extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Elimina';
	@override String get fileWarning => 'Questo file verrà eliminato definitivamente.';
	@override String get folderWarning => 'Questa cartella e tutto il suo contenuto verranno eliminati definitivamente.';
	@override String title({required Object type}) => 'Elimina ${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$it extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'Impossibile copiare il percorso';
	@override String get fileCreated => 'File creato con successo';
	@override String get fileDeleted => 'File eliminato';
	@override String get folderCreated => 'Cartella creata con successo';
	@override String get folderDeleted => 'Cartella eliminata';
	@override String get folderDownloaded => 'Cartella scaricata come ZIP';
	@override String get pathCopied => 'Percorso copiato negli appunti';
	@override String get renamed => 'Rinominato con successo';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$it extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'Il nome del file non può essere solo punti';
	@override String get emptyName => 'Il nome del file non può essere vuoto';
	@override String get invalidChars => 'Il nome del file contiene caratteri non validi';
	@override String get reserved => 'Il nome del file è un nome riservato';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$it extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get type => 'Tipo';
	@override String get configure => 'Configura';
	@override String get confirm => 'Conferma';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$it extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get question => 'Hai già un\'area di lavoro o vuoi crearne una nuova?';
	@override late final Translations$common$projectWizard$step1$existing$it existing = Translations$common$projectWizard$step1$existing$it._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$it kNew = Translations$common$projectWizard$step1$kNew$it._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$it extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Percorso area di lavoro';
	@override String get newPath => 'Percorso area di lavoro';
	@override String get existingPlaceholder => '/percorso/area-di-lavoro/esistente';
	@override String get newPlaceholder => '/percorso/nuova/area-di-lavoro';
	@override String get existingHelp => 'Percorso completo della directory dell\'area di lavoro esistente';
	@override String get newHelp => 'Percorso completo della directory dell\'area di lavoro';
	@override String get githubUrl => 'URL GitHub (opzionale)';
	@override String get githubPlaceholder => 'https://github.com/utente/repository';
	@override String get githubHelp => 'Opzionale: fornisci un URL GitHub per clonare un repository';
	@override String get githubAuth => 'Autenticazione GitHub (opzionale)';
	@override String get githubAuthHelp => 'Richiesta solo per repository privati. I repository pubblici possono essere clonati senza autenticazione.';
	@override String get loadingTokens => 'Caricamento token salvati...';
	@override String get storedToken => 'Token salvato';
	@override String get newToken => 'Nuovo token';
	@override String get nonePublic => 'Nessuno (pubblico)';
	@override String get selectToken => 'Seleziona token';
	@override String get selectTokenPlaceholder => '-- Seleziona un token --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Questo token verrà utilizzato solo per questa operazione';
	@override String get publicRepoInfo => 'I repository pubblici non richiedono autenticazione. Puoi saltare il token se stai clonando un repository pubblico.';
	@override String get noTokensHelp => 'Nessun token salvato disponibile. Puoi aggiungere token in Impostazioni → Chiavi API per un riutilizzo più semplice.';
	@override String get optionalTokenPublic => 'Token GitHub (opzionale per repository pubblici)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (lascia vuoto per repository pubblici)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$it extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Rivedi la tua configurazione';
	@override String get existingWorkspace => 'Area di lavoro esistente';
	@override String get newWorkspace => 'Nuova area di lavoro';
	@override String get path => 'Percorso:';
	@override String get cloneFrom => 'Clona da:';
	@override String get authentication => 'Autenticazione:';
	@override String get usingStoredToken => 'Usando token salvato:';
	@override String get usingProvidedToken => 'Usando token fornito';
	@override String get noAuthentication => 'Nessuna autenticazione';
	@override String get sshKey => 'Chiave SSH';
	@override String get existingInfo => 'L\'area di lavoro verrà aggiunta alla lista dei progetti e sarà disponibile per le sessioni Claude/Cursor.';
	@override String get newWithClone => 'Il repository verrà clonato da questa cartella.';
	@override String get newEmpty => 'L\'area di lavoro verrà aggiunta alla lista dei progetti e sarà disponibile per le sessioni Claude/Cursor.';
	@override String get cloningRepository => 'Clonazione repository...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$it extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annulla';
	@override String get back => 'Indietro';
	@override String get next => 'Avanti';
	@override String get createProject => 'Crea progetto';
	@override String get creating => 'Creazione...';
	@override String get cloning => 'Clonazione...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$it extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Seleziona se hai un\'area di lavoro esistente o vuoi crearne una nuova';
	@override String get providePath => 'Fornisci un percorso per l\'area di lavoro';
	@override String get failedToCreate => 'Impossibile creare l\'area di lavoro';
	@override String get failedToCreateFolder => 'Impossibile creare la cartella';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$it extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$it generic = Translations$common$notifications$codes$generic$it._(_root);
	@override late final Translations$common$notifications$codes$permission$it permission = Translations$common$notifications$codes$permission$it._(_root);
	@override late final Translations$common$notifications$codes$run$it run = Translations$common$notifications$codes$run$it._(_root);
	@override late final Translations$common$notifications$codes$agent$it agent = Translations$common$notifications$codes$agent$it._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$it extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get close => 'Chiudi';
	@override String get later => 'Più tardi';
	@override String get copyCommand => 'Copia comando';
	@override String get updateNow => 'Aggiorna ora';
	@override String get updating => 'Aggiornamento...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$it extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Chiudi finestra aggiornamento versione';
	@override String get showSidebar => 'Mostra barra laterale';
	@override String get settings => 'Impostazioni';
	@override String get updateAvailable => 'Aggiornamento disponibile';
	@override String get closeSidebar => 'Chiudi barra laterale';
}

// Path: common.quota.section
class Translations$common$quota$section$it extends Translations$common$quota$section$en {
	Translations$common$quota$section$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Panoramica';
	@override String get quotas => 'Quote';
	@override String get usage => 'Utilizzo';
	@override String get agents => 'Agenti';
}

// Path: common.quota.filter
class Translations$common$quota$filter$it extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get all => 'Tutti';
}

// Path: common.quota.period
class Translations$common$quota$period$it extends Translations$common$quota$period$en {
	Translations$common$quota$period$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 giorni';
	@override String get k30d => '30 giorni';
	@override String get all => 'Tutti';
}

// Path: common.quota.group
class Translations$common$quota$group$it extends Translations$common$quota$group$en {
	Translations$common$quota$group$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Provider';
	@override String get model => 'Modello';
	@override String get agent => 'Agente';
	@override String get tool => 'Strumento';
}

// Path: common.quota.metric
class Translations$common$quota$metric$it extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Token';
	@override String get input => 'Input';
	@override String get output => 'Output';
	@override String get cache => 'Letture cache';
	@override String get calls => 'Chiamate API';
	@override String get cost => 'Costo';
	@override String get sessions => 'Sessioni';
}

// Path: common.quota.cost
class Translations$common$quota$cost$it extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Fatturato (API + eccedenza)';
	@override String get listPrice => 'Prezzo di listino dei token usati';
	@override String get subscriptionValue => 'Coperto dagli abbonamenti';
	@override String get cacheSavings => 'Risparmio cache';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$it extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Fatturato (API + eccedenza)';
	@override String get listPrice => 'Prezzo di listino dei token usati';
	@override String get subscriptionValue => 'Coperto dagli abbonamenti';
}

// Path: common.quota.overview
class Translations$common$quota$overview$it extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Token e costo — ultimi 7 giorni';
	@override String get effectiveCost => 'Costo effettivo (7 giorni)';
	@override String get alertsTitle => 'Avvisi';
	@override String get noAlerts => 'Nulla richiede attenzione al momento.';
	@override String get limitsTitle => 'Utilizzo e limiti';
	@override String get activeTasks => 'Attività attive';
	@override String get viewAccounts => 'Tutti gli account';
	@override String get viewAgents => 'Tutti gli agenti';
	@override String get noTasks => 'Nessun agente in esecuzione al momento.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$it extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tendenza giornaliera';
	@override String breakdownTitle({required Object group}) => 'Ripartizione per ${group}';
	@override String get colName => 'Nome';
	@override String get sourceUnavailable => 'Archivio analitica non disponibile; nessun dato mostrato.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$it extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} in esecuzione';
	@override String get colAgent => 'Agente';
	@override String get colStatus => 'Stato';
	@override String get colTask => 'Attività';
	@override String get colModel => 'Account / modello';
	@override String get colTime => 'Ora';
	@override String get empty => 'Nessun agente corrisponde a questo filtro.';
	@override String get detailSession => 'Sessione';
	@override String get detailStarted => 'Avviato';
	@override String get detailRetries => 'Tentativi';
	@override String get detailResult => 'Risultato';
	@override String get notTracked => 'non tracciato';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$it extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get running => 'In esecuzione';
	@override String get waiting => 'In attesa';
	@override String get failed => 'Fallito';
	@override String get finished => 'Completato';
	@override String get queued => 'In coda';
}

// Path: common.quota.alert
class Translations$common$quota$alert$it extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: al ritmo attuale il limite si esaurisce in ${value}';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% usato (soglia ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$it extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get live => 'Live';
	@override String get cached => 'In cache';
	@override String get estimate => 'Stima';
	@override String get unknown => 'Sconosciuto';
	@override String get error => 'Errore';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$it extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Limiti a rischio';
	@override String atRiskHint({required Object value}) => 'account oltre il ${value}%';
	@override String get windowsAtRisk => 'Finestre in esaurimento';
	@override String get errored => 'Errori di sincronizzazione';
	@override String get activeAgents => 'Agenti attivi';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} in attesa · ${queued} in coda';
	@override String get nextReset => 'Prossimo reset';
	@override String get tokens => 'Token';
	@override String sessionsHint({required Object value}) => '${value} sessioni';
	@override String get cost => 'Costo stimato';
	@override String costHint({required Object value}) => '${value} coperto dai piani';
}

// Path: common.quota.empty
class Translations$common$quota$empty$it extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nessun account collegato';
	@override String get description => 'Accedi a Claude, Codex, Gemini o CommandCode per tracciare le quote qui.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$it extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Avvisi e routing';
	@override String get description => 'Controlla quando la dashboard ti avvisa e come vengono suggeriti gli account per il nuovo lavoro.';
	@override String get alertsEnabled => 'Avvisi predittivi e di soglia';
	@override String get alertsEnabledHint => 'Avvisa prima che un limite si esaurisca al ritmo attuale, non solo al 90%.';
	@override String get watchThreshold => 'Soglia di osservazione (%)';
	@override String get dangerThreshold => 'Soglia di pericolo (%)';
	@override String get routingMode => 'Routing';
	@override late final Translations$common$quota$settings$routing$it routing = Translations$common$quota$settings$routing$it._(_root);
	@override String get logSources => 'Fonti di log';
	@override String get logSourcesHint => 'Le schermate di utilizzo e agenti leggono queste fonti in sola lettura.';
	@override String get quotaConsent => 'Consenti polling delle quote';
	@override String get quotaConsentHint => 'Interroga gli endpoint dei provider con le tue credenziali salvate per leggere i limiti live.';
	@override String get perAccount => 'Override per account';
	@override String get tab => 'Impostazioni del Control Center';
}

// Path: common.quota.range
class Translations$common$quota$range$it extends Translations$common$quota$range$en {
	Translations$common$quota$range$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Tutti';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$it extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Abilita Browser nelle impostazioni per consentire agli agenti di aprire sessioni browser monitorate.';
	@override String get descEnabled => 'Le sessioni browser degli agenti appaiono qui mentre un task AI usa Browser.';
	@override String get titleDisabled => 'Browser è disabilitato';
	@override String get titleEnabled => 'Nessuna sessione browser ancora';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$it extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'Azione del browser non riuscita';
	@override String get loadFailed => 'Impossibile caricare Browser';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$it extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Usa Browser per ispezionare il flusso di checkout e segnalare stati UI non funzionanti.';
	@override String get prompt2 => 'Apri <url> con Browser, interagisci con la pagina e riassumi cosa è cambiato dopo ogni passo.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$it extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' g fa';
	@override String get hoursAgo => ' h fa';
	@override String get justNow => 'Adesso';
	@override String get minutesAgo => ' min fa';
	@override String get never => 'Mai';
	@override String get secondsAgo => ' s fa';
	@override String get unknown => 'Sconosciuto';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$it extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Disabilitato';
	@override String get installing => 'Installazione';
	@override String get ready => 'Pronto';
	@override String get setupRequired => 'Configurazione richiesta';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$it extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Sfoglia tutti i branch (${count})';
	@override String commits({required Object count}) => 'Sfoglia tutti i commit (${count})';
	@override String files({required Object count}) => 'Sfoglia tutti i file (${count})';
	@override String sessions({required Object count}) => 'Sfoglia tutte le sessioni (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$it extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'Il costo è una stima lato client basata sulle tariffe per token pubblicate; i modelli sconosciuti mostrano «—».';
	@override String get estCost => 'Costo stim.';
	@override String get inputOutput => 'Input / Output';
	@override String get model => 'Modello';
	@override String get na => 'N/D';
	@override String get openSplit => 'Apri in vista divisa';
	@override String get provider => 'Provider';
	@override String get selectSession => 'Seleziona una sessione…';
	@override String get tokensUsed => 'Token usati';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$it extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Azioni';
	@override String get branches => 'Branch';
	@override String get commits => 'Commit';
	@override String get files => 'File';
	@override String get git => 'Git';
	@override String get navigate => 'Naviga';
	@override String get sessions => 'Sessioni';
	@override String get settings => 'Impostazioni';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$it extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get close => 'Chiudi';
	@override String get navigate => 'Naviga';
	@override String get select => 'Seleziona';
	@override String get togglePalette => 'Attiva/disattiva palette';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$it extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Confronta sessioni';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => 'Apri impostazioni';
	@override String get selectProjectFirst => 'Seleziona prima un progetto';
	@override String settingsEntry({required Object label}) => 'Impostazioni: ${label}';
	@override String get startNewChat => 'Avvia nuova chat';
	@override String switchTo({required Object name}) => 'Passa a: ${name}';
	@override String get toggleTheme => 'Cambia tema';
	@override String get tokensAndCost => 'token e costo';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$it extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get board => 'Vai alla Bacheca agenti';
	@override String get chat => 'Vai alla Chat';
	@override String get files => 'Vai ai File';
	@override String get git => 'Vai a Git';
	@override String get sourceControl => 'Vai al Controllo del codice';
	@override String get tasks => 'Vai alle Attività';
	@override String get usage => 'Vai a Quota e utilizzo';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$it extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Azioni';
	@override String get branches => 'Branch';
	@override String get commits => 'Commit';
	@override String get compare => 'Confronta';
	@override String get files => 'File';
	@override String get sessions => 'Sessioni';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$it extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => 'Eliminare il branch «${branch}»? L’eliminazione normale riesce solo se il branch è completamente fuso. Azione irreversibile.';
	@override String confirmSwitch({required Object branch}) => 'Passare al branch «${branch}»? Assicurati di non avere modifiche non committate.';
	@override String countBoth({required Object local, required Object remote}) => '${local} locali, ${remote} remoti';
	@override String countLocal({required Object count}) => '${count} locali';
	@override String get current => 'attuale';
	@override String deleteTitle({required Object branch}) => 'Elimina ${branch}';
	@override String get emptyDesc => 'Crea un branch per iniziare lavoro parallelo.';
	@override String get forceDelete => 'Forza eliminazione';
	@override String get forceDeleteDesc => 'Rimuove definitivamente il branch anche se contiene commit non fusi altrove.';
	@override String get forceDeleteLabel => 'Forza l’eliminazione di questo branch non fuso';
	@override String get local => 'Locali';
	@override String get kNew => 'Nuovo branch';
	@override String get noMatch => 'Nessun branch corrisponde alla ricerca';
	@override String get none => 'Nessun branch trovato';
	@override String get remote => 'remoti';
	@override String get kSwitch => 'Cambia';
	@override String switchTo({required Object branch}) => 'Passa a ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$it extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Conferma';
	@override String get delete => 'Elimina';
	@override String get deleteBranch => 'Elimina';
	@override String get discard => 'Scarta';
	@override String get publish => 'Pubblica';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get revertLocalCommit => 'Annulla commit';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$it extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Conferma azione';
	@override String get delete => 'Elimina file';
	@override String get deleteBranch => 'Elimina branch';
	@override String get discard => 'Scarta modifiche';
	@override String get publish => 'Pubblica branch';
	@override String get pull => 'Conferma pull';
	@override String get push => 'Conferma push';
	@override String get revertLocalCommit => 'Annulla commit locale';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$it extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Creazione branch non riuscita';
	@override String get createWorktreeFailed => 'Impossibile creare il worktree';
	@override String get deleteBranchFailed => 'Eliminazione branch non riuscita';
	@override String get fetchFailed => 'Fetch non riuscito';
	@override String get initFailed => 'Impossibile inizializzare il repository';
	@override String get initialCommitFailed => 'Impossibile creare il commit iniziale';
	@override String get mergeFailed => 'Merge non riuscito';
	@override String get openWorktreeFailed => 'Impossibile aprire il worktree';
	@override String get operationFailed => 'Operazione git non riuscita';
	@override String get publishFailed => 'Pubblicazione non riuscita';
	@override String get pullFailed => 'Pull non riuscito';
	@override String get pushFailed => 'Push non riuscito';
	@override String get removeWorktreeFailed => 'Impossibile rimuovere il worktree';
	@override String get stageFailed => 'Stage non riuscito';
	@override String get stageHunksFailed => 'Stage delle sezioni non riuscito';
	@override String get switchFailed => 'Cambio di branch non riuscito';
	@override String get unstageFailed => 'Unstage non riuscito';
	@override String get unstageHunksFailed => 'Unstage delle sezioni non riuscito';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$it extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get added => 'Aggiunte';
	@override String get author => 'Autore';
	@override String get changedFiles => 'File modificati';
	@override String get date => 'Data';
	@override String get empty => 'Nessun commit trovato';
	@override String get files => 'File';
	@override String get removed => 'Rimosse';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$it extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Rimuovi il worktree ed elimina il suo branch una volta fuso';
	@override String get cleanupLabel => 'Pulisci dopo il merge';
	@override String commitCount({required Object count}) => '${count} commit';
	@override String get merge => 'Fondi';
	@override String mergeMessage({required Object branch}) => 'Fondi il branch \'${branch}\'';
	@override String get messageLabel => 'Messaggio di commit';
	@override String squashDesc({required Object commits, required Object branch}) => 'Combina tutti i ${commits} in un singolo commit su ${branch}';
	@override String get squashLabel => 'Schiaccia i commit';
	@override String get squashMerge => 'Squash e fondi';
	@override String squashMessage({required Object branch}) => 'Squash-merge del branch \'${branch}\'';
	@override String get title => 'Fondi worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$it extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Questo creerà un nuovo branch dal branch attuale (${branch})';
	@override String get nameLabel => 'Nome del branch';
	@override String get submit => 'Crea branch';
	@override String get title => 'Crea nuovo branch';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$it extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Branch';
	@override String get createFrom => 'Crea da';
	@override String get description => 'Estrai un branch nella sua cartella e lavoraci in parallelo.';
	@override String get existingBranch => 'Branch esistente — verrà estratto così com’è.';
	@override String get submit => 'Crea worktree';
	@override String get switchAfter => 'Passa al worktree dopo averlo creato';
	@override String get title => 'Nuovo worktree';
	@override String get willCreateIn => 'Verrà creato in';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$it extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get create => 'Crea commit iniziale';
	@override String get creating => 'Creazione commit iniziale...';
	@override String get description => 'Questo repository non ha ancora commit. Crea il primo commit per iniziare a tracciare le modifiche.';
	@override String get title => 'Ancora nessun commit';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$it extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Questo progetto non è ancora un repository git. Inizializzane uno per tracciare le modifiche e usare il controllo del codice.';
	@override String get init => 'Esegui git init';
	@override String get initializing => 'Inizializzazione repository...';
	@override String get title => 'Nessun repository git';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$it extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Elimina anche il branch';
	@override String description({required Object branch}) => 'Rimuovere il worktree di ${branch}? La sua cartella viene eliminata e il progetto collegato archiviato — le sessioni chat restano recuperabili.';
	@override String dirtyWarning({required Object count}) => 'Questo worktree ha ${count} modifiche non committate che andranno perse.';
	@override String get discardChanges => 'Scarta modifiche non committate';
	@override String get title => 'Rimuovi worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$it extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get added => 'Aggiunto';
	@override String get deleted => 'Eliminato';
	@override String get modified => 'Modificato';
	@override String get untracked => 'Non tracciato';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$it extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} modifiche';
	@override String count({required Object count}) => '${count} worktree';
	@override String get createFirst => 'Crea il tuo primo worktree';
	@override String get detached => 'distaccato';
	@override String detachedAt({required Object sha}) => 'distaccato @ ${sha}';
	@override String get detachedHead => 'HEAD detached';
	@override String get emptyDesc => 'Un worktree estrae un branch nella sua cartella, così puoi avere sessioni chat parallele e fondere i risultati quando sono pronti.';
	@override String get emptyTitle => 'Lavora su branch in parallelo';
	@override String get locked => 'bloccato';
	@override String get mainWorktree => 'worktree principale';
	@override String mergeTitle({required Object branch}) => 'Fondi ${branch} nel branch base';
	@override String get kNew => 'Nuovo worktree';
	@override String get none => 'Nessun worktree';
	@override String get nothingToMerge => 'Niente da fondere — nessun commit avanti al branch base';
	@override String get open => 'Apri';
	@override String get refresh => 'Aggiorna worktree';
	@override String removeTitle({required Object branch}) => 'Rimuovi worktree di ${branch}';
	@override String switchTo({required Object branch}) => 'Passa a ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$it extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Modifiche';
	@override String get history => 'Commit';
	@override String get branches => 'Branch';
	@override String get worktrees => 'Worktree';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$it extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ambito';
	@override String get user => 'Utente';
	@override String get project => 'Progetto';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$it extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get dark => 'Scuro';
	@override String get light => 'Chiaro';
	@override String get system => 'Sistema';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$it extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Aspetto';
	@override String get toolDisplay => 'Visualizzazione strumenti';
	@override String get inputSettings => 'Impostazioni input';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$it extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Trascinamento maniglia';
	@override String get closePanel => 'Chiudi pannello impostazioni';
	@override String get openPanel => 'Apri pannello impostazioni';
	@override String get draggingStatus => 'Trascinamento...';
	@override String get toggleAndMove => 'Clicca per attivare/disattivare, trascina per spostare';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$it extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Chiudi pannello scorciatoie';
	@override String get openPanel => 'Apri pannello scorciatoie';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$it extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$it extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
	@override late final Translations$settings$orchestration$pool$fields$it fields = Translations$settings$orchestration$pool$fields$it._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$it extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$it extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$it taskTypes = Translations$settings$orchestration$rules$taskTypes$it._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$it extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$it modes = Translations$settings$orchestration$planner$modes$it._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$it modeHints = Translations$settings$orchestration$planner$modeHints$it._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$it templates = Translations$settings$orchestration$planner$templates$it._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$it extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$it onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$it._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$it extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

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
class Translations$settings$notifications$webPush$it extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifiche push web';
	@override String get enable => 'Abilita notifiche push';
	@override String get disable => 'Disabilita notifiche push';
	@override String get enabled => 'Le notifiche push sono abilitate';
	@override String get loading => 'Aggiornamento...';
	@override String get unsupported => 'Le notifiche push non sono supportate in questo browser.';
	@override String get denied => 'Le notifiche push sono bloccate. Abilitale nelle impostazioni del browser.';
	@override String get iosHint => 'Su iPhone/iPad le notifiche funzionano solo dopo aver aggiunto DDAgent alla schermata Home (Condividi → Aggiungi a Home) e averle attivate dall’app installata.';
	@override String get test => 'Invia notifica di prova';
	@override String get testNoSubscription => 'Nessun dispositivo iscritto. Tocca prima «Abilita» sul telefono.';
	@override String testSuccess({required Object count}) => 'Inviato a ${count} dispositivi. Se non appare nulla sul telefono, aggiungi DDAgent alla schermata Home (richiesto da iOS).';
	@override String get testNotDelivered => 'Nessun dispositivo era raggiungibile. Assicurati che l\'app sia in esecuzione e che le notifiche siano attive.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$it extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifica questo dispositivo';
	@override String get enabled => 'Le notifiche sono attive per questo dispositivo';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$it extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Suono';
	@override String get description => 'Riproduci un breve tono quando termina un\'esecuzione della chat.';
	@override String get enabled => 'Attivato';
	@override String get test => 'Prova suono';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$it extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tipi di evento';
	@override String get actionRequired => 'Azione richiesta';
	@override String get stop => 'Esecuzione interrotta';
	@override String get error => 'Esecuzione fallita';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$it extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifica questa app desktop';
	@override String get enable => 'Abilita notifiche push';
	@override String get disable => 'Disabilita notifiche push';
	@override String get enabled => 'Le notifiche sono attivate per questa app desktop';
	@override String get unsupported => 'Le notifiche desktop non sono supportate su questo sistema.';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$it extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get discord => 'Discord';
	@override String get telegram => 'Telegram';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$it extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Modalità scura';
	@override String get description => 'Alterna tra tema chiaro e scuro';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$it extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Editor codice';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$it theme = Translations$settings$appearanceSettings$codeEditor$theme$it._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$it wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$it._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$it showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$it._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$it lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$it._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$it fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$it._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$it extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminale';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$it focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$it._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$it extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get add => 'Aggiungi server MCP';
	@override String get edit => 'Modifica server MCP';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$it extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get form => 'Input modulo';
	@override String get json => 'Importa JSON';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$it extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ambito';
	@override String get userGlobal => 'Utente (globale)';
	@override String get projectLocal => 'Progetto (locale)';
	@override String get userDescription => 'Ambito utente: disponibile in tutti i progetti sulla tua macchina';
	@override String get projectDescription => 'Ambito locale: disponibile solo nel progetto selezionato';
	@override String get cannotChange => 'L\'ambito non può essere modificato quando si modifica un server esistente';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$it extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Nome server';
	@override String get transportType => 'Tipo di trasporto';
	@override String get command => 'Comando';
	@override String get arguments => 'Argomenti (uno per riga)';
	@override String get jsonConfig => 'Configurazione JSON';
	@override String get url => 'URL';
	@override String get envVars => 'Variabili d\'ambiente (CHIAVE=valore, una per riga)';
	@override String get headers => 'Header (CHIAVE=valore, uno per riga)';
	@override String get selectProject => 'Seleziona un progetto...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$it extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'mio-server';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$it extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Campo obbligatorio mancante: type';
	@override String get stdioRequiresCommand => 'Il tipo stdio richiede un campo command';
	@override String httpRequiresUrl({required Object type}) => 'Il tipo ${type} richiede un campo url';
	@override String get invalidJson => 'Formato JSON non valido';
	@override String get jsonHelp => 'Incolla la configurazione del server MCP in formato JSON. Esempi di formato:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$it extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annulla';
	@override String get saving => 'Salvataggio...';
	@override String get addServer => 'Aggiungi server';
	@override String get updateServer => 'Aggiorna server';
}

// Path: settings.git.name
class Translations$settings$git$name$it extends Translations$settings$git$name$en {
	Translations$settings$git$name$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Nome Git';
	@override String get help => 'Il tuo nome per i commit git';
	@override String get placeholder => 'Mario Rossi';
}

// Path: settings.git.email
class Translations$settings$git$email$it extends Translations$settings$git$email$en {
	Translations$settings$git$email$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Email Git';
	@override String get help => 'La tua email per i commit git';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$it extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get save => 'Salva configurazione';
	@override String get saving => 'Salvataggio...';
}

// Path: settings.git.status
class Translations$settings$git$status$it extends Translations$settings$git$status$en {
	Translations$settings$git$status$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get success => 'Salvato con successo';
	@override String get error => 'Salvataggio non riuscito';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$it extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ Salva la tua chiave API';
	@override String get alertMessage => 'Questa è l\'unica volta che vedrai questa chiave. Conservala in modo sicuro.';
	@override String get iveSavedIt => 'L\'ho salvata';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$it extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Nome chiave API (es. Server produzione)';
	@override String get createButton => 'Crea';
	@override String get cancelButton => 'Annulla';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$it extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get created => 'Creata:';
	@override String get lastUsed => 'Ultimo utilizzo:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$it extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get active => 'Attiva';
	@override String get inactive => 'Inattiva';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$it extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Token GitHub';
	@override String get description => 'Aggiungi token di accesso personale GitHub per clonare repository privati tramite l\'API esterna.';
	@override String get descriptionAlt => 'Aggiungi token di accesso personale GitHub per clonare repository privati. Puoi anche passare i token direttamente nelle richieste API senza salvarli.';
	@override String get addButton => 'Aggiungi token';
	@override late final Translations$settings$apiKeys$github$form$it form = Translations$settings$apiKeys$github$form$it._(_root);
	@override String get empty => 'Nessun token GitHub aggiunto.';
	@override String get added => 'Aggiunto:';
	@override String get confirmDelete => 'Sei sicuro di voler eliminare questo token GitHub?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$it extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Documentazione API esterna';
	@override String get description => 'Scopri come usare l\'API esterna per avviare sessioni Claude/Cursor dalle tue applicazioni.';
	@override String get viewLink => 'Vedi documentazione API →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$it extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Aggiornamento disponibile: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$it extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLI non installato';
	@override String get description => 'TaskMaster CLI è necessario per usare le funzionalità di gestione attività. Installalo per iniziare:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'Vedi su GitHub';
	@override String get afterInstallation => 'Dopo l\'installazione:';
	@override late final Translations$settings$tasks$notInstalled$steps$it steps = Translations$settings$tasks$notInstalled$steps$it._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$it extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'Abilita integrazione TaskMaster';
	@override String get enableDescription => 'Mostra attività TaskMaster, banner e indicatori nella barra laterale nell\'interfaccia';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$it extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Verifica...';
	@override String get connected => 'Connesso';
	@override String get notConnected => 'Non connesso';
	@override String get disconnected => 'Disconnesso';
	@override String get checkingAuth => 'Verifica stato autenticazione...';
	@override String loggedInAs({required Object email}) => 'Connesso come ${email}';
	@override String providerAccount({required Object provider}) => 'Account ${provider}';
	@override String get authenticatedUser => 'utente autenticato';
}

// Path: settings.agents.install
class Translations$settings$agents$install$it extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => 'La CLI ${agent} non è installata';
	@override String description({required Object agent}) => 'Installa la CLI ${agent} per accedere ed eseguire sessioni.';
	@override String get button => 'Installa';
	@override String get installing => 'Installazione…';
	@override String get copyCommand => 'Copia comando';
	@override String get docs => 'Documentazione';
	@override String success({required Object agent}) => 'CLI ${agent} installata';
	@override String get failed => 'Installazione non riuscita — controlla l\'output del terminale';
}

// Path: settings.agents.update
class Translations$settings$agents$update$it extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aggiorna CLI';
	@override String description({required Object agent}) => 'Installa l\'ultima versione della CLI ${agent} sull\'host del server.';
	@override String get button => 'Aggiorna';
	@override String get updating => 'Aggiornamento…';
	@override String success({required Object agent}) => 'CLI ${agent} aggiornata';
	@override String get failed => 'Aggiornamento non riuscito — controlla l\'output del terminale';
}

// Path: settings.agents.account
class Translations$settings$agents$account$it extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$it claude = Translations$settings$agents$account$claude$it._(_root);
	@override late final Translations$settings$agents$account$cursor$it cursor = Translations$settings$agents$account$cursor$it._(_root);
	@override late final Translations$settings$agents$account$codex$it codex = Translations$settings$agents$account$codex$it._(_root);
	@override late final Translations$settings$agents$account$opencode$it opencode = Translations$settings$agents$account$opencode$it._(_root);
	@override late final Translations$settings$agents$account$commandcode$it commandcode = Translations$settings$agents$account$commandcode$it._(_root);
	@override late final Translations$settings$agents$account$antigravity$it antigravity = Translations$settings$agents$account$antigravity$it._(_root);
	@override late final Translations$settings$agents$account$devin$it devin = Translations$settings$agents$account$devin$it._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$it extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Accedi';
	@override String get reAuthenticate => 'Ri-autenticati';
	@override String description({required Object agent}) => 'Accedi al tuo account ${agent} per abilitare le funzionalità AI';
	@override String get reAuthDescription => 'Accedi con un account diverso o aggiorna le credenziali';
	@override String get button => 'Accedi';
	@override String get reLoginButton => 'Ri-accedi';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$it extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Disconnetti';
	@override String get description => 'Disconnetti da questo provider e cancella le credenziali salvate';
	@override String get button => 'Disconnetti';
	@override String confirmTitle({required Object agent}) => 'Disconnettersi da ${agent}?';
	@override String confirmDescription({required Object agent}) => 'Questa operazione rimuove le credenziali ${agent} salvate sul server. Accedi di nuovo per continuare a usare ${agent}.';
	@override String get success => 'Disconnesso';
	@override String get failed => 'Disconnessione non riuscita';
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$it extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Modalità permessi';
	@override String description({required Object provider}) => 'Modalità di permesso predefinita per le nuove sessioni ${provider}. Puoi comunque sovrascriverla per una singola sessione.';
	@override late final Translations$settings$permissions$permissionMode$modes$it modes = Translations$settings$permissions$permissionMode$modes$it._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$it extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get claude => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a Claude';
	@override String get cursor => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a Cursor';
	@override String get codex => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a Codex';
	@override String get opencode => 'I server Model Context Protocol forniscono a OpenCode strumenti e fonti dati aggiuntivi';
	@override String get commandcode => 'I server Model Context Protocol forniscono a Command Code strumenti e fonti dati aggiuntivi';
	@override String get antigravity => 'I server Model Context Protocol forniscono a Antigravity strumenti e fonti dati aggiuntivi';
	@override String get devin => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntivi a Devin';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$it extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get local => 'locale';
	@override String get user => 'utente';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$it extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get command => 'Comando';
	@override String get url => 'URL';
	@override String get args => 'Argomenti';
	@override String get environment => 'Ambiente';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$it extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Strumenti';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count} altri';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$it extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Modifica server';
	@override String get delete => 'Elimina server';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$it extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Informazioni su Codex MCP';
	@override String get description => 'Codex supporta server MCP basati su stdio. Puoi aggiungere server che estendono le capacità di Codex con strumenti e risorse aggiuntive.';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$it extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Gestito';
	@override String get hint => 'Gestito da DDAgent.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$it extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '«${serverName}» verrà rimosso dalla configurazione del provider.';
	@override String get title => 'Eliminare il server MCP?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$it extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => 'Soglie di avviso, politica di routing e account interrogati per le quote.';
	@override String get saved => 'Salvato';
	@override String get alertsSection => 'Avvisi';
	@override String get alertsSectionHint => 'Avvisa prima che un limite sia effettivamente esaurito, non solo al 100%.';
	@override String get alertsEnabled => 'Avvisi di limite previsto';
	@override String get alertsEnabledHint => 'Mostra proiezioni basate sul ritmo nella panoramica e nelle schede account.';
	@override String get watchThreshold => 'Soglia di osservazione (%)';
	@override String get watchThresholdHint => 'Gli account pari o superiori a questa lettura sono contati come a rischio.';
	@override String get dangerThreshold => 'Soglia di pericolo (%)';
	@override String get dangerThresholdHint => 'Le letture pari o superiori a questo valore sono mostrate in rosso.';
	@override String get routingSection => 'Routing';
	@override String get routingSectionHint => 'Come il pannello può spostare il lavoro sull’account con più margine.';
	@override late final Translations$settings$quota$settings$routing$it routing = Translations$settings$quota$settings$routing$it._(_root);
	@override String get routingNote => 'Cambiare account altera costo e qualità del modello, quindi richiede sempre una decisione esplicita.';
	@override String get accountsSection => 'Account interrogati';
	@override String get accountsSectionHint => 'Le credenziali sono lette da ogni strumento; il pannello non le invia da nessun’altra parte.';
	@override String get sourcesSection => 'Fonti di dati';
	@override String get sourcesSectionHint => 'Da dove provengono le cifre di utilizzo e costo.';
	@override String get logSources => 'Archivio log di token e costi';
	@override String get logSourcesHint => 'Archivio aggregato in sola lettura condiviso con il collector tokboard.';
	@override String get readOnly => 'Sola lettura';
	@override String get quotaConsent => 'Polling delle quote';
	@override String get quotaConsentHint => 'Legge gli endpoint di quota dei provider con credenziali salvate localmente.';
	@override String get localOnly => 'Solo locale';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$it extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Nessun account rilevato ancora.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$it extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cached => 'in cache';
	@override String get error => 'errore';
	@override String get estimate => 'stima';
	@override String get live => 'live';
	@override String get unknown => 'sconosciuto';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$it extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'Impossibile installare il runtime del browser';
	@override String get loadSettings => 'Impossibile caricare le impostazioni di Browser';
	@override String get loadStatus => 'Impossibile caricare lo stato di Browser';
	@override String get saveSettings => 'Impossibile salvare le impostazioni di Browser';
}

// Path: settings.about.pro
class Translations$settings$about$pro$it extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Sincronizza impostazioni';
	@override String get teamManagement => 'Gestione del team';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$it extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'Gestione attività AI: suddividi progetti complessi in sotto-attività gestibili';
	@override String get prdTemplates => 'Template PRD: genera attività da documenti di requisiti del prodotto';
	@override String get dependencyTracking => 'Tracciamento dipendenze: comprendi le relazioni tra attività e l\'ordine di esecuzione';
	@override String get progressVisualization => 'Visualizzazione progresso: board Kanban e analisi dettagliata delle attività';
	@override String get cliIntegration => 'Integrazione CLI: usa i comandi taskmaster per flussi di lavoro avanzati';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$it extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$it createPRD = Translations$tasks$gettingStarted$steps$createPRD$it._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$it generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$it._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$it analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$it._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$it startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$it._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$it extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Esempio:\n"Ho appena inizializzato un nuovo progetto con Claude Task Master. Ho un PRD in .taskmaster/docs/prd.txt. Puoi aiutarmi ad analizzarlo e configurare le attività iniziali?"';
	@override String get expandTask => '💬 Esempio:\n"L\'attività 5 sembra complessa. Puoi suddividerla in sotto-attività?"';
	@override String get addTask => '💬 Esempio:\n"Per favore aggiungi una nuova attività per implementare il caricamento delle immagini profilo utente usando Cloudinary, ricerca l\'approccio migliore."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$it extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Suggerimenti pro';
	@override String get search => 'Usa la barra di ricerca per trovare rapidamente attività specifiche';
	@override String get views => 'Passa tra le viste Kanban, Lista e Griglia usando i selettori di vista';
	@override String get filters => 'Usa i filtri per concentrarti su stati o priorità specifiche delle attività';
	@override String get details => 'Clicca su qualsiasi attività per vedere informazioni dettagliate e gestire le sotto-attività';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$it extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 Per saperne di più';
	@override String get description => 'TaskMaster AI è un sistema avanzato di gestione attività pensato per sviluppatori. Trova documentazione, esempi e contribuisci al progetto.';
	@override String get githubButton => 'Vedi su GitHub';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$it extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ancora nessuna scheda';
	@override String get description => 'Aggiungi una scheda, descrivi l’attività, poi trascinala in Pronta per far iniziare un agente.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$it extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Backlog';
	@override String get ready => 'Pronta per iniziare';
	@override String get working => 'In lavorazione';
	@override String get needsDecision => 'Richiede la tua decisione';
	@override String get done => 'Completata';
	@override String get archived => 'Archiviate';
}

// Path: tasks.board.card
class Translations$tasks$board$card$it extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get running => 'In esecuzione';
	@override String get abort => 'Interrompi';
	@override String get delete => 'Elimina';
	@override String get openSession => 'Apri sessione';
	@override String get pullRequest => 'Pull request';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$it extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Nuova scheda';
	@override String get editTitle => 'Modifica scheda';
	@override String get titleLabel => 'Titolo';
	@override String get titlePlaceholder => 'Cosa deve fare l’agente?';
	@override String get descriptionLabel => 'Descrizione';
	@override String get descriptionPlaceholder => 'Aggiungi contesto, criteri di accettazione, link...';
	@override String get cancel => 'Annulla';
	@override String get save => 'Salva';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$it extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Agente';
	@override String get anyProvider => 'Qualsiasi agente';
	@override String get model => 'Modello';
	@override String get defaultModel => 'Modello predefinito';
	@override String get effort => 'Ragionamento';
	@override String get defaultEffort => 'Predefinito';
	@override String get searchModel => 'Cerca modelli…';
	@override String get noModels => 'Nessun modello corrispondente';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$it extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '«${cardTitle}» verrà eliminata definitivamente.';
	@override String get title => 'Eliminare la scheda?';
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$it extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get bearerTokenEnvVar => 'Variabile d\'ambiente del token Bearer';
	@override String get envVarNames => 'Nomi delle variabili d\'ambiente';
	@override String get workingDirectory => 'Directory di lavoro';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$it extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get claudeLocal => 'Claude locale';
	@override late final Translations$mcp$form$scope$description$it description = Translations$mcp$form$scope$description$it._(_root);
	@override String get projectAllProviders => 'Progetto (tutti i provider)';
	@override String get userAllProviders => 'Utente (tutti i provider)';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$it extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => 'Aggiungi server MCP supporta solo stdio e http su tutti i provider, non ${type}.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} non supporta server MCP di tipo ${type}';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$it extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Cwd';
	@override String get envVars => 'Variabili d\'ambiente';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$it extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Area di lavoro esistente';
	@override String get description => 'Ho già un\'area di lavoro sul mio server e devo solo aggiungerla alla lista dei progetti';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$it extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nuova area di lavoro';
	@override String get description => 'Crea una nuova area di lavoro, opzionalmente clonando da un repository GitHub';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$it extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$it info = Translations$common$notifications$codes$generic$info$it._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$it extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$it required = Translations$common$notifications$codes$permission$required$it._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$it extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$it stopped = Translations$common$notifications$codes$run$stopped$it._(_root);
	@override late final Translations$common$notifications$codes$run$failed$it failed = Translations$common$notifications$codes$run$failed$it._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$it extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$it notification = Translations$common$notifications$codes$agent$notification$it._(_root);
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$it extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuale — solo raccomandazione';
	@override String get ask => 'Chiedi prima di cambiare account';
	@override String get autoLowRisk => 'Cambio automatico per attività a basso rischio';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$it extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

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
	@override String get redundantAccounts => 'Account ridondanti';
	@override String get redundantAccountsNone => 'Nessun altro account per questo provider';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$it extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

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
class Translations$settings$orchestration$planner$modes$it extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$it extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$it extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$it extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$it extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Tema editor';
	@override String get description => 'Tema predefinito per l\'editor di codice';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$it extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'A capo automatico';
	@override String get description => 'Abilita il ritorno a capo automatico nell\'editor';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$it extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Mostra minimappa';
	@override String get description => 'Visualizza una minimappa per facilitare la navigazione nella vista differenze';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$it extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Mostra numeri di riga';
	@override String get description => 'Visualizza i numeri di riga nell\'editor';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$it extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Dimensione carattere';
	@override String get description => 'Dimensione del carattere dell\'editor in pixel';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$it extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get label => 'Il focus segue il puntatore';
	@override String get description => 'Dai il focus al terminale per la digitazione quando muovi il mouse sopra di esso';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$it extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Nome token (es. Repository personali)';
	@override String get tokenPlaceholder => 'Token di accesso personale GitHub (ghp_...)';
	@override String get descriptionPlaceholder => 'Descrizione (opzionale)';
	@override String get addButton => 'Aggiungi token';
	@override String get cancelButton => 'Annulla';
	@override String get howToCreate => 'Come creare un token di accesso personale GitHub →';
	@override String get showToken => 'Mostra token';
	@override String get hideToken => 'Nascondi token';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$it extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Riavvia questa applicazione';
	@override String get autoAvailable => 'Le funzionalità TaskMaster saranno automaticamente disponibili';
	@override String get initCommand => 'Usa task-master init nella directory del tuo progetto';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$it extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistente AI Anthropic Claude';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$it extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Editor di codice potenziato da AI Cursor';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$it extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistente AI OpenAI Codex';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$it extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistente CLI OpenCode';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$it extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistente CLI Command Code';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$it extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistente CLI Antigravity';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$it extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistente CLI Devin';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$it extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$it kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$it._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$it auto = Translations$settings$permissions$permissionMode$modes$auto$it._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$it acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$it._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$it bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$it._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$it plan = Translations$settings$permissions$permissionMode$modes$plan$it._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$it extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuale';
	@override String get manualHint => 'Mostra solo una raccomandazione; non cambiare mai account automaticamente.';
	@override String get ask => 'Chiedi prima di cambiare';
	@override String get askHint => 'Un cambio viene proposto e attende la tua approvazione.';
	@override String get autoLowRisk => 'Automatico per attività a basso rischio';
	@override String get autoLowRiskHint => 'Solo le attività marcate a basso rischio possono essere spostate automaticamente.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$it extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crea un documento di requisiti del prodotto (PRD)';
	@override String get description => 'Discuti la tua idea di progetto e crea un PRD che descriva cosa vuoi costruire.';
	@override String get addButton => 'Aggiungi PRD';
	@override String get existingPRDs => 'PRD esistenti:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$it extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Genera attività dal PRD';
	@override String get description => 'Una volta che hai un PRD, chiedi al tuo assistente AI di analizzarlo e TaskMaster lo suddividerà automaticamente in attività gestibili con dettagli di implementazione.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$it extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analizza ed espandi le attività';
	@override String get description => 'Chiedi al tuo assistente AI di analizzare la complessità delle attività ed espanderle in sotto-attività dettagliate per un\'implementazione più semplice.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$it extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inizia a costruire';
	@override String get description => 'Chiedi al tuo assistente AI di iniziare a lavorare sulle attività, aggiornare il loro stato e aggiungere nuove attività man mano che il tuo progetto evolve.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$it extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get local => 'Salvato nelle impostazioni utente di Claude per il progetto selezionato';
	@override String get project => 'Salvato nel workspace del progetto selezionato';
	@override String get projectGlobal => 'Scrive nel workspace del progetto selezionato per ogni provider';
	@override String get user => 'Disponibile in tutti i progetti sulla tua macchina';
	@override String get userGlobal => 'Scrive nella configurazione utente di ogni provider ed è disponibile in tutti i progetti su questa macchina';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$it extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifica';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$it extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Azione richiesta';
	@override String body({required Object toolName}) => '${toolName} è in attesa della tua decisione.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$it extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Esecuzione interrotta';
	@override String body({required Object reason}) => 'Motivo: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$it extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Esecuzione fallita';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$it extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifica agente';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$it extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Predefinito';
	@override String get description => 'Le azioni che richiedono un permesso ti vengono mostrate per approvazione nella chat.';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$it extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Modalità automatica';
	@override String get description => 'Un classificatore di modello decide per ogni chiamata se approvare o negare. Alta autonomia.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$it extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Accetta modifiche';
	@override String get description => 'Le modifiche ai file sono approvate automaticamente; le altre azioni chiedono ancora la tua approvazione.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$it extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ignora permessi';
	@override String get description => 'Ogni azione è approvata automaticamente — accesso completo senza richieste. Usa con cautela.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$it extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$it._(TranslationsIt root) : this._root = root, super.internal(root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Piano';
	@override String get description => 'Modalità pianificazione: l’agente esplora e pianifica senza eseguire comandi.';
}

/// The flat map containing all translations for locale <it>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsIt {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'La sessione è scaduta. Accedi di nuovo.',
			'auth.login.title' => 'Bentornato',
			'auth.login.description' => 'Accedi al tuo account DDAgent self-hosted',
			'auth.login.username' => 'Nome utente',
			'auth.login.password' => 'Password',
			'auth.login.submit' => 'Accedi',
			'auth.login.loading' => 'Accesso in corso...',
			'auth.login.errors.invalidCredentials' => 'Nome utente o password non validi',
			'auth.login.errors.requiredFields' => 'Compila tutti i campi',
			'auth.login.errors.networkError' => 'Errore di rete. Riprova.',
			'auth.login.placeholders.username' => 'Inserisci il tuo nome utente',
			'auth.login.placeholders.password' => 'Inserisci la tua password',
			'auth.register.title' => 'Crea account',
			'auth.register.username' => 'Nome utente',
			'auth.register.password' => 'Password',
			'auth.register.confirmPassword' => 'Conferma password',
			'auth.register.submit' => 'Crea account',
			'auth.register.loading' => 'Creazione account...',
			'auth.register.errors.passwordMismatch' => 'Le password non corrispondono',
			'auth.register.errors.usernameTaken' => 'Nome utente già in uso',
			'auth.register.errors.weakPassword' => 'La password è troppo debole',
			'auth.register.errors.usernameTooShort' => 'Il nome utente deve contenere almeno 3 caratteri',
			'auth.register.errors.passwordTooShort' => 'La password deve contenere almeno 6 caratteri',
			'auth.logout.title' => 'Disconnetti',
			'auth.logout.confirm' => 'Sei sicuro di volerti disconnettere?',
			'auth.logout.button' => 'Disconnetti',
			'chat.codeBlock.copy' => 'Copia',
			'chat.codeBlock.copied' => 'Copiato',
			'chat.codeBlock.copyCode' => 'Copia codice',
			'chat.copyMessage.copy' => 'Copia messaggio',
			'chat.copyMessage.copied' => 'Messaggio copiato',
			'chat.copyMessage.failed' => 'Copia non riuscita',
			'chat.copyMessage.selectFormat' => 'Seleziona formato copia',
			'chat.copyMessage.copyAsMarkdown' => 'Copia come markdown',
			'chat.copyMessage.copyAsText' => 'Copia come testo',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => 'Errore',
			'chat.messageTypes.tool' => 'Strumento',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.tools.settings' => 'Impostazioni strumento',
			'chat.tools.error' => 'Errore strumento',
			'chat.tools.result' => 'Risultato strumento',
			'chat.tools.viewParams' => 'Vedi parametri input',
			'chat.tools.viewRawParams' => 'Vedi parametri grezzi',
			'chat.tools.viewDiff' => 'Vedi differenze per',
			'chat.tools.creatingFile' => 'Creazione nuovo file:',
			'chat.tools.updatingTodo' => 'Aggiornamento lista attività',
			'chat.tools.read' => 'Leggi',
			'chat.tools.readFile' => 'Leggi file',
			'chat.tools.updateTodo' => 'Aggiorna lista attività',
			'chat.tools.readTodo' => 'Leggi lista attività',
			'chat.tools.searchResults' => 'risultati',
			'chat.tools.todoReadLabel' => 'Lista attività di TodoRead',
			'chat.search.found' => ({required Object count, required Object type}) => 'Trovati ${count} ${type}',
			'chat.search.file' => 'file',
			'chat.search.files' => 'file',
			'chat.search.pattern' => 'pattern:',
			'chat.search.kIn' => 'in:',
			'chat.fileOperations.updated' => 'File aggiornato con successo',
			'chat.fileOperations.created' => 'File creato con successo',
			'chat.fileOperations.written' => 'File scritto con successo',
			'chat.fileOperations.diff' => 'Differenze',
			'chat.fileOperations.newFile' => 'Nuovo file',
			'chat.fileOperations.viewContent' => 'Vedi contenuto file',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Vedi output completo (${count} caratteri)',
			'chat.fileOperations.contentDisplayed' => 'Il contenuto del file è visualizzato nella vista differenze sopra',
			'chat.interactive.title' => 'Prompt interattivo',
			'chat.interactive.waiting' => 'In attesa della tua risposta nella CLI',
			'chat.interactive.instruction' => 'Seleziona un\'opzione nel terminale dove Claude è in esecuzione.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude ha selezionato l\'opzione ${number}',
			'chat.interactive.instructionDetail' => 'Nella CLI, selezioneresti questa opzione interattivamente usando i tasti freccia o digitando il numero.',
			'chat.thinking.title' => 'Sto pensando...',
			'chat.thinking.emoji' => '💭 Sto pensando...',
			'chat.json.response' => 'Risposta JSON',
			'chat.permissions.grant' => ({required Object tool}) => 'Concedi permesso per ${tool}',
			'chat.permissions.added' => 'Permesso aggiunto',
			'chat.permissions.addTo' => ({required Object entry}) => 'Aggiunge ${entry} agli strumenti consentiti.',
			'chat.permissions.retry' => 'Permesso salvato. Riprova la richiesta per usare lo strumento.',
			'chat.permissions.error' => 'Impossibile aggiornare i permessi. Riprova.',
			'chat.permissions.openSettings' => 'Apri impostazioni',
			'chat.permissions.allow' => 'Consenti',
			'chat.permissions.allowAll' => ({required Object count}) => 'Consenti tutto (${count})',
			'chat.permissions.allowWithChanges' => 'Consenti con modifiche',
			'chat.permissions.always' => 'Sempre',
			'chat.permissions.deny' => 'Nega',
			'chat.permissions.editAndAllow' => 'Modifica e consenti',
			'chat.permissions.editInput' => 'Modifica input',
			'chat.permissions.invalidJson' => 'JSON non valido',
			'chat.permissions.reject' => 'Rifiuta',
			'chat.todo.updated' => 'Lista attività aggiornata con successo',
			'chat.todo.current' => 'Lista attività corrente',
			'chat.plan.viewPlan' => '📋 Vedi piano di implementazione',
			'chat.plan.title' => 'Piano di implementazione',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Limite di utilizzo Claude raggiunto. Il tuo limite verrà ripristinato alle **${time} ${timezone}** - ${date}',
			'chat.codex.permissionMode' => 'Modalità permessi',
			'chat.codex.modes.kDefault' => 'Modalità predefinita',
			'chat.codex.modes.auto' => 'Modalità automatica',
			'chat.codex.modes.acceptEdits' => 'Accetta modifiche',
			'chat.codex.modes.bypassPermissions' => 'Ignora permessi',
			'chat.codex.modes.plan' => 'Modalità piano',
			'chat.codex.descriptions.kDefault' => 'Solo i comandi attendibili (ls, cat, grep, git status, ecc.) vengono eseguiti automaticamente. Gli altri comandi vengono saltati. Può scrivere nell\'area di lavoro.',
			'chat.codex.descriptions.auto' => 'Un classificatore di modello decide per ogni chiamata se approvare o negare. Alta autonomia.',
			'chat.codex.descriptions.acceptEdits' => 'Tutti i comandi vengono eseguiti automaticamente nell\'area di lavoro. Modalità completamente automatica con esecuzione sandboxed.',
			'chat.codex.descriptions.bypassPermissions' => 'Accesso completo al sistema senza restrizioni. Tutti i comandi vengono eseguiti automaticamente con accesso completo a disco e rete. Usa con cautela.',
			'chat.codex.descriptions.plan' => 'Modalità pianificazione - nessun comando viene eseguito',
			'chat.codex.technicalDetails' => 'Dettagli tecnici',
			'chat.input.placeholder' => ({required Object provider}) => 'Digita / per i comandi, @ per i file, o chiedi qualcosa a ${provider}...',
			'chat.input.placeholderDefault' => 'Scrivi il tuo messaggio...',
			'chat.input.disabled' => 'Input disabilitato',
			'chat.input.attachFiles' => 'Allega file',
			'chat.input.attachImages' => 'Allega immagini',
			'chat.input.send' => 'Invia',
			'chat.input.stop' => 'Ferma',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Invio per inviare • / comandi • @ file',
			'chat.input.hintText.enter' => 'Invio per inviare • Shift+Invio nuova riga • / comandi • @ file',
			'chat.input.hintText.queue' => 'Invio per accodare il prossimo messaggio',
			'chat.input.hintText.updateQueued' => 'Invio per aggiornare il messaggio in coda',
			'chat.input.clickToChangeMode' => 'Clicca per cambiare la modalità permessi',
			'chat.input.showAllCommands' => 'Mostra tutti i comandi',
			'chat.input.clearInput' => 'Cancella input',
			'chat.input.scrollToBottom' => 'Scorri in basso',
			'chat.input.attachFilesDesc' => 'Carica foto, file o documenti',
			'chat.input.takePhoto' => 'Scatta foto',
			'chat.input.takePhotoDesc' => 'Usa la fotocamera per scattare una foto',
			'chat.input.moreTools' => 'Altri strumenti',
			'chat.input.commandsDesc' => 'Esplora scorciatoie e comandi',
			'chat.input.clearInputDesc' => 'Scarta il testo corrente',
			'chat.input.newMessage' => 'Nuovo messaggio',
			'chat.input.newMessages' => 'Nuovi messaggi',
			'chat.input.queue.sendNext' => 'Accoda prossimo messaggio',
			'chat.input.queue.update' => 'Aggiorna messaggio in coda',
			'chat.input.queue.label' => 'In coda',
			'chat.input.queue.willSend' => 'Sarà inviato al termine',
			'chat.input.queue.edit' => 'Modifica messaggio in coda',
			'chat.input.queue.delete' => 'Elimina messaggio in coda',
			'chat.input.queue.failed' => 'Invio non riuscito',
			'chat.input.queue.sendNow' => 'Invia ora',
			'chat.input.autoContinueTasks' => 'Continuazione automatica',
			'chat.input.autoContinueTasksTooltip' => 'Attiva per lasciare che Devin passi automaticamente all’attività Task Master successiva',
			'chat.input.offlineQueue.clear' => 'Annulla e svuota la coda offline',
			'chat.input.offlineQueue.clearBtn' => 'Annulla',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} messaggi in coda offline — verranno inviati automaticamente alla riconnessione',
			'chat.input.offlineQueue.single' => '1 messaggio in coda offline — verrà inviato automaticamente alla riconnessione',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Fotocamera non disponibile: ${error}',
			'chat.providerSelection.title' => 'Scegli il tuo assistente AI',
			'chat.providerSelection.description' => 'Seleziona un provider per iniziare una nuova conversazione',
			'chat.providerSelection.selectModel' => 'Seleziona modello',
			'chat.providerSelection.providerInfo.anthropic' => 'di Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'di OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'Editor codice AI',
			'chat.providerSelection.providerInfo.google' => 'di Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Pronto a usare Claude con ${model}. Inizia a digitare il tuo messaggio qui sotto.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Pronto a usare Cursor con ${model}. Inizia a digitare il tuo messaggio qui sotto.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Pronto a usare Codex con ${model}. Inizia a digitare il tuo messaggio qui sotto.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Seleziona un provider sopra per iniziare',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'Pronto a usare OpenCode con ${model}. Inizia a scrivere il tuo messaggio qui sotto.',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Pronto con Devin ${model}',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Premi <kbd>${shortcut}</kbd> per cercare sessioni, file e commit',
			'chat.providerSelection.workspace' => 'Spazio di lavoro',
			'chat.providerSelection.noWorkspace' => 'Nessuno',
			'chat.providerSelection.clickToChangeWorkspace' => 'Clicca per cambiare spazio di lavoro',
			'chat.providerSelection.chooseWorkspace' => 'Scegli uno spazio di lavoro',
			'chat.providerSelection.searchWorkspaces' => 'Cerca spazi di lavoro...',
			'chat.providerSelection.noWorkspacesFound' => 'Nessuno spazio di lavoro trovato.',
			'chat.providerSelection.all' => 'Tutti',
			'chat.providerSelection.free' => 'Gratuiti',
			'chat.providerSelection.noModelsFound' => 'Nessun modello trovato.',
			'chat.providerSelection.paid' => 'A pagamento',
			'chat.providerSelection.searchModels' => 'Cerca modelli...',
			'chat.providerSelection.addModel' => 'Aggiungi modello',
			'chat.providerSelection.chooseModel' => 'Scegli un modello',
			'chat.providerSelection.chooseModelDescription' => 'Modelli integrati e personalizzati in un’unica lista',
			'chat.providerSelection.clickToChange' => 'Clicca per cambiare modello',
			'chat.providerSelection.favorites' => 'Preferiti',
			'chat.providerSelection.loadingModels' => 'Caricamento modelli…',
			'chat.providerSelection.manageModels' => 'Gestisci modelli',
			'chat.providerSelection.refresh' => 'Aggiorna modelli',
			'chat.session.kContinue.title' => 'Continua la tua conversazione',
			'chat.session.kContinue.description' => 'Fai domande sul tuo codice, richiedi modifiche o chiedi aiuto con le attività di sviluppo',
			'chat.session.kContinue.action' => 'Continua a scrivere',
			'chat.session.loading.olderMessages' => 'Caricamento messaggi precedenti...',
			'chat.session.loading.sessionMessages' => 'Caricamento messaggi della sessione...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => 'Visualizzati ${shown} di ${total} messaggi',
			'chat.session.messages.scrollToLoad' => 'Scorri in alto per caricare altri',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Visualizzati ultimi ${count} messaggi (${total} totali)',
			'chat.session.messages.loadEarlier' => 'Carica messaggi precedenti',
			'chat.session.messages.loadAll' => 'Carica tutti i messaggi',
			'chat.session.messages.loadingAll' => 'Caricamento di tutti i messaggi...',
			'chat.session.messages.allLoaded' => 'Tutti i messaggi caricati',
			'chat.session.messages.perfWarning' => 'Tutti i messaggi caricati — lo scorrimento potrebbe essere più lento. Clicca "Scorri in basso" per ripristinare le prestazioni.',
			'chat.session.messages.loadOlderFailed' => 'Impossibile caricare i messaggi precedenti.',
			'chat.session.messages.retry' => 'Riprova',
			'chat.session.messages.noSearchMatches' => 'Nessun messaggio corrisponde alla ricerca.',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Carica tutti (${count})',
			'chat.session.messages.loadOlder' => 'Carica messaggi precedenti',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Riprova a caricare i precedenti — ${error}',
			'chat.session.deleteConfirm' => 'Rimuove la sessione e la sua trascrizione. L\'azione è irreversibile.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Termina l\'esecuzione prima di cambiare spazio di lavoro',
			'chat.shell.selectProject.title' => 'Seleziona un progetto',
			'chat.shell.selectProject.description' => 'Scegli un progetto per aprire una shell interattiva in quella directory',
			'chat.shell.status.newSession' => 'Nuova sessione',
			'chat.shell.status.initializing' => 'Inizializzazione...',
			'chat.shell.status.restarting' => 'Riavvio...',
			'chat.shell.actions.disconnect' => 'Disconnetti',
			'chat.shell.actions.disconnectTitle' => 'Disconnetti dalla shell',
			'chat.shell.actions.restart' => 'Riavvia',
			'chat.shell.actions.restartTitle' => 'Riavvia shell (disconnetti prima)',
			'chat.shell.actions.connect' => 'Continua nella shell',
			'chat.shell.actions.connectTitle' => 'Connetti alla shell',
			'chat.shell.actions.kill' => 'Termina (SIGINT)',
			'chat.shell.actions.killTitle' => 'Termina processo in esecuzione (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Copia output',
			'chat.shell.actions.copyOutputTitle' => 'Copia output del terminale',
			'chat.shell.actions.copied' => 'Copiato!',
			'chat.shell.actions.zoomInTitle' => 'Ingrandisci',
			'chat.shell.actions.zoomOutTitle' => 'Riduci',
			'chat.shell.loading' => 'Caricamento terminale...',
			'chat.shell.connecting' => 'Connessione alla shell...',
			'chat.shell.startSession' => 'Avvia una nuova sessione Claude',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Riprendi sessione: ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => 'Esegui ${command} in ${projectName}',
			'chat.shell.startCli' => ({required Object projectName}) => 'Avvio Claude CLI in ${projectName}',
			'chat.shell.defaultCommand' => 'comando',
			'chat.claudeStatus.actions.thinking' => 'Ragionamento',
			'chat.claudeStatus.actions.processing' => 'Elaborazione',
			'chat.claudeStatus.actions.analyzing' => 'Analisi',
			'chat.claudeStatus.actions.working' => 'In lavorazione',
			'chat.claudeStatus.actions.computing' => 'Calcolo',
			'chat.claudeStatus.actions.reasoning' => 'Ragionamento',
			'chat.claudeStatus.state.live' => 'Attivo',
			'chat.claudeStatus.state.paused' => 'In pausa',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}s',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} trascorsi',
			'chat.claudeStatus.elapsed.startingNow' => 'Avvio in corso',
			'chat.claudeStatus.controls.stopGeneration' => 'Interrompi generazione',
			'chat.claudeStatus.controls.pressEscToStop' => 'Premi Esc in qualsiasi momento per interrompere',
			'chat.claudeStatus.providers.assistant' => 'Assistente',
			'chat.claudeStatus.stop' => 'Ferma',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} attività in background in corso', other: '${count} attività in background in corso', ), 
			'chat.claudeStatus.backgroundTasksTitle' => 'In esecuzione in background',
			'chat.claudeStatus.backgroundTaskUnnamed' => 'Attività senza nome',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Seleziona un progetto per iniziare a chattare con ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Inizia l\'attività successiva',
			'chat.voice.autoRead' => 'Leggi le risposte ad alta voce',
			'chat.voice.autoReadOn' => 'Lettura risposte: attivata',
			'chat.voice.autoReadOff' => 'Lettura risposte: disattivata',
			'chat.voice.autoReadVoice' => 'Voce di lettura',
			'chat.voice.autoReadVoiceAuto' => 'Voce automatica',
			'chat.voice.autoReadPreview' => 'Ecco come suoneranno le risposte.',
			'chat.voice.speakMessage' => 'Leggi ad alta voce',
			'chat.voice.stopSpeaking' => 'Interrompi lettura',
			'chat.composer.toolsAndActions' => 'Strumenti e azioni',
			'chat.composer.toolsAndActionsDesc' => 'Strumenti e controlli per l’editor di chat',
			'chat.composer.reasoning' => 'Ragionamento',
			'chat.composer.model' => 'Modello',
			'chat.composer.effortDefault' => 'Predefinito',
			'chat.composer.loadingModels' => 'Caricamento modelli…',
			'chat.composer.modelMenu' => 'Seleziona modello e sforzo di ragionamento',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'Come devono essere approvate le azioni di ${provider}?',
			'chat.composer.favorites' => 'Preferiti',
			'chat.splitSession.toggle' => 'Dividi sessione',
			'chat.splitSession.close' => 'Chiudi sessione divisa',
			'chat.splitSession.selectSession' => 'Seleziona sessione da confrontare',
			'chat.splitSession.noOtherSessions' => 'Nessun’altra sessione disponibile',
			'chat.splitSession.newSessionOption' => '+ Nuova sessione in vista divisa',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Progetto corrente (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Altri progetti',
			'chat.splitSession.recentSessionsGroup' => 'Sessioni recenti',
			'chat.splitSession.startNewSession' => 'Avvia nuova sessione in vista divisa',
			'chat.splitSession.selectFromList' => 'Seleziona una sessione dall’elenco delle sessioni esistenti',
			'chat.sessionPicker.title' => 'Seleziona sessione',
			'chat.sessionPicker.searchPlaceholder' => 'Cerca sessioni...',
			'chat.sessionPicker.clearSearch' => 'Cancella ricerca',
			'chat.sessionPicker.newChat' => '+ Nuova chat',
			'chat.sessionPicker.archivedToggle' => 'Archiviate',
			'chat.sessionPicker.changeSession' => 'Cambia sessione',
			'chat.sessionPicker.archivedLoading' => 'Caricamento sessioni archiviate...',
			'chat.sessionPicker.archivedError' => 'Impossibile caricare le sessioni archiviate',
			'chat.sessionPicker.archivedEmpty' => 'Nessuna sessione archiviata',
			'chat.sessionPicker.archivedProjectOnly' => 'Spazio di lavoro archiviato — ripristinalo per vedere le sue sessioni.',
			'chat.sessionPicker.emptySearch' => 'Nessuna sessione corrisponde alla ricerca',
			'chat.sessionPicker.restore' => 'Ripristina',
			'chat.sessionPicker.restoreSession' => 'Ripristina sessione',
			'chat.sessionPicker.restoreProject' => 'Ripristina spazio di lavoro',
			'chat.sessionPicker.restoreSessionFailed' => 'Ripristino della sessione non riuscito. Riprova.',
			'chat.sessionPicker.restoreProjectFailed' => 'Ripristino dello spazio di lavoro non riuscito. Riprova.',
			'chat.sessionPicker.archiveFailed' => 'Archiviazione della sessione non riuscita. Riprova.',
			'chat.sessionPicker.deleteFailed' => 'Eliminazione della sessione non riuscita. Riprova.',
			'chat.sessionPicker.running' => 'Sessione in esecuzione',
			'chat.sessionPicker.unread' => 'Non letta — terminata con nuovo output',
			'chat.splitWorkspace.addChat' => 'Aggiungi riquadro chat',
			'chat.splitWorkspace.addBrowser' => 'Aggiungi riquadro browser',
			'chat.splitWorkspace.addTerminal' => 'Aggiungi riquadro terminale',
			'chat.splitWorkspace.overview' => 'Mostra tutti i riquadri',
			'chat.splitWorkspace.exitFocusMode' => 'Esci dalla modalità focus (Ctrl+Maiusc+F)',
			'chat.splitWorkspace.focusMode' => 'Modalità focus (Ctrl+Maiusc+F)',
			'chat.splitWorkspace.browseSessions' => 'Apri l\'elenco delle sessioni',
			'chat.splitOverview.title' => 'Panoramica dei riquadri divisi',
			'chat.splitOverview.count' => ({required Object count}) => '${count} riquadri',
			'chat.splitOverview.close' => 'Chiudi panoramica',
			'chat.splitOverview.question' => 'DOMANDA — input richiesto',
			'chat.splitOverview.processing' => 'ELABORAZIONE',
			'chat.splitOverview.idle' => 'Inattivo',
			'chat.splitOverview.active' => 'Attiva',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} ha bisogno del tuo input',
			'chat.askUserQuestion.answerHint' => 'Digita la tua risposta…',
			'chat.askUserQuestion.other' => 'Altro…',
			'chat.askUserQuestion.skip' => 'Salta',
			'chat.attachments.downloadFailedRetry' => 'Download non riuscito — clicca per riprovare',
			'chat.attachments.fileAttachment' => 'Allegato file',
			'chat.attachments.download' => ({required Object name}) => 'Scarica ${name}',
			'chat.checkpoint.creating' => 'Creazione snapshot…',
			'chat.checkpoint.revertChanges' => 'Ripristina i file all’ultimo checkpoint',
			'chat.checkpoint.undo' => 'Annulla checkpoint',
			'chat.checkpoint.beforeAiTurn' => 'prima del turno AI',
			'chat.common.close' => 'Chiudi',
			'chat.taskMaster.saveToTask' => 'Attività',
			'chat.taskMaster.saved' => 'Salvato',
			'chat.taskMaster.saving' => 'Salvataggio...',
			'chat.taskMaster.taskShort' => 'TASK',
			'chat.taskMaster.addToTask' => 'Aggiungi a TaskMaster',
			'chat.taskMaster.added' => 'Aggiunto a TaskMaster',
			'chat.tokenUsage.desc' => 'Vedi il consumo di token della sessione',
			'chat.tokenUsage.title' => 'Utilizzo dei token',
			'chat.tool.emptyResult' => '(nessun output per ora — lo strumento ha restituito un risultato vuoto)',
			'chat.quotaBadge.ariaLabel' => 'Limiti dell\'abbonamento',
			'chat.quotaBadge.noData' => 'Nessun dato sull’abbonamento per questo modello',
			'chat.paneHeader.processing' => 'Elaborazione…',
			'chat.paneHeader.switchSession' => 'Cambia sessione',
			'chat.broadcast.selectOrchestrators' => 'Seleziona orchestratori',
			'chat.broadcast.orchestratorsOnly' => 'Solo orchestratori',
			'chat.broadcast.noOrchestrators' => 'Nessuna sessione di orchestrazione disponibile',
			'chat.changes.empty' => 'Nessuna modifica ai file',
			'chat.changes.failedToLoad' => 'Impossibile caricare le modifiche',
			'chat.commandResult.fallback.config' => 'Apri impostazioni e configurazione.',
			'chat.commandResult.fallback.cost' => 'Esamina l\'utilizzo dei token per la sessione attiva.',
			'chat.commandResult.fallback.help' => 'Mostra la documentazione e la sintassi dei comandi.',
			'chat.commandResult.fallback.memory' => 'Apri il file di memoria CLAUDE.md del progetto.',
			'chat.commandResult.fallback.models' => 'Sfoglia i modelli disponibili per il provider attivo.',
			'chat.commandResult.fallback.status' => 'Controlla lo stato di runtime, versione, provider e ambiente.',
			'chat.commandResult.filterCommands' => 'Filtra comandi...',
			'chat.commandResult.searchModels' => ({required Object provider}) => 'Cerca modelli ${provider}...',
			'chat.commands.runConfirmTitle' => 'Eseguire il comando?',
			'chat.commands.executionCancelled' => 'Esecuzione del comando annullata',
			'chat.export.sessionTitle' => ({required Object id}) => 'Sessione ${id}',
			'chat.export.pdfFailed' => 'Esportazione PDF non riuscita',
			'chat.export.transcriptDownloaded' => 'Trascrizione scaricata',
			'chat.export.savedTo' => ({required Object path}) => 'Salvato ${path}',
			'chat.message.compactedSummary' => 'Riepilogo compattato',
			'chat.message.rawView' => 'Vista grezza',
			'chat.message.resendHint' => 'Reinvia dal compositore',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => 'Elimina ${name}',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => 'Modifica ${name}',
			'chat.modelLibrary.enterNameAndId' => 'Inserisci sia il nome del modello sia l\'ID del modello.',
			'chat.modelLibrary.idNoSpaces' => 'Gli ID dei modelli non possono contenere spazi.',
			'chat.modelLibrary.setAsDefault' => 'Imposta come predefinito',
			'chat.modelLibrary.defaultModel' => 'Modello predefinito',
			'chat.pinFile.action' => 'Fissa',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.title' => 'Fissa file',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Richiesta di permesso · ${tool}',
			'chat.permissionRequest.question' => 'Domanda',
			'codeEditor.toolbar.changes' => 'modifiche',
			'codeEditor.toolbar.previousChange' => 'Modifica precedente',
			'codeEditor.toolbar.nextChange' => 'Modifica successiva',
			'codeEditor.toolbar.hideDiff' => 'Nascondi evidenziazione differenze',
			'codeEditor.toolbar.showDiff' => 'Mostra evidenziazione differenze',
			'codeEditor.toolbar.settings' => 'Impostazioni editor',
			'codeEditor.toolbar.collapse' => 'Comprimi editor',
			'codeEditor.toolbar.expand' => 'Espandi editor a larghezza piena',
			'codeEditor.toolbar.diffMerge' => 'Diff / merge',
			'codeEditor.toolbar.previewInBrowser' => 'Anteprima nel browser',
			'codeEditor.toolbar.reload' => 'Ricarica dal disco',
			'codeEditor.toolbar.toggleDock' => 'Attiva/disattiva dock file',
			'codeEditor.loading' => ({required Object fileName}) => 'Caricamento ${fileName}...',
			'codeEditor.header.showingChanges' => 'Visualizzazione modifiche',
			'codeEditor.actions.copyPath' => 'Copia percorso file',
			'codeEditor.actions.pathCopied' => 'Percorso file copiato',
			'codeEditor.actions.download' => 'Scarica file',
			'codeEditor.actions.save' => 'Salva',
			'codeEditor.actions.saving' => 'Salvataggio...',
			'codeEditor.actions.saved' => 'Salvato!',
			'codeEditor.actions.exitFullscreen' => 'Esci dalla modalità schermo intero',
			'codeEditor.actions.fullscreen' => 'Schermo intero',
			'codeEditor.actions.close' => 'Chiudi',
			'codeEditor.actions.previewMarkdown' => 'Anteprima markdown',
			'codeEditor.actions.editMarkdown' => 'Modifica markdown',
			'codeEditor.actions.pinFile' => 'Fissa file al contesto',
			'codeEditor.actions.unpinFile' => 'Rimuovi file dal contesto',
			'codeEditor.actions.previewHtml' => 'Apri anteprima HTML in una nuova scheda',
			'codeEditor.actions.retry' => 'Riprova',
			'codeEditor.actions.saveAll' => 'Salva tutto',
			'codeEditor.footer.lines' => 'Righe:',
			'codeEditor.footer.characters' => 'Caratteri:',
			'codeEditor.footer.shortcuts' => 'Premi Ctrl+S per salvare • Esc per chiudere',
			'codeEditor.binaryFile.title' => 'File binario',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Il file "${fileName}" non può essere visualizzato nell\'editor di testo perché è un file binario.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Impossibile visualizzare come testo',
			'codeEditor.filePreview.loading' => 'Caricamento anteprima...',
			'codeEditor.filePreview.error' => 'Impossibile visualizzare questo file.',
			'codeEditor.filePreview.openInNewTab' => 'Apri in una nuova scheda',
			'codeEditor.diff.applyMerge' => 'Applica merge',
			'codeEditor.diff.base' => 'Base',
			'codeEditor.diff.close' => 'Chiudi diff',
			'codeEditor.diff.current' => 'Corrente',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Sezione ${number}',
			'codeEditor.diff.noChanges' => 'Nessuna modifica',
			'codeEditor.diff.deletedOnDisk' => 'eliminato dal disco',
			'codeEditor.discardUnsavedChanges' => 'Scartare le modifiche non salvate?',
			'codeEditor.emptyState.title' => 'Nessun file aperto',
			'codeEditor.failedToLoad' => 'Impossibile caricare il file',
			'codeEditor.hexDump.more' => ({required Object size}) => '… altri ${size}',
			'codeEditor.mediaFile.subtitle' => 'L\'anteprima audio/video non è ancora supportata',
			'codeEditor.mediaFile.title' => 'File multimediale',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Dimensione carattere −  (ora ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Dimensione carattere +',
			'codeEditor.settings.minimap' => 'Minimappa',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Dimensione tabulazione: ${size}',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Modifiche non salvate in ${name}',
			'codeEditor.toasts.savedFile' => ({required Object name}) => 'Salvato ${name}',
			'codeEditor.toasts.saveFailed' => 'Salvataggio non riuscito',
			'codeEditor.toasts.allSaved' => 'Tutto salvato',
			'codeEditor.toasts.someSavesFailed' => 'Alcuni salvataggi non riusciti',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Salvato in ${path}',
			'codeEditor.toasts.mergeApplied' => 'Merge applicato — salva per conservare le modifiche',
			'common.buttons.save' => 'Salva',
			'common.buttons.cancel' => 'Annulla',
			'common.buttons.delete' => 'Elimina',
			'common.buttons.create' => 'Crea',
			'common.buttons.edit' => 'Modifica',
			'common.buttons.close' => 'Chiudi',
			'common.buttons.confirm' => 'Conferma',
			'common.buttons.submit' => 'Invia',
			'common.buttons.retry' => 'Riprova',
			'common.buttons.refresh' => 'Aggiorna',
			'common.buttons.search' => 'Cerca',
			'common.buttons.clear' => 'Cancella',
			'common.buttons.copy' => 'Copia',
			'common.buttons.download' => 'Scarica',
			'common.buttons.upload' => 'Carica',
			'common.buttons.browse' => 'Sfoglia',
			'common.buttons.openDiagram' => 'Apri diagramma',
			'common.buttons.update' => 'Aggiorna',
			'common.tabs.chat' => 'Chat',
			'common.tabs.shell' => 'Terminale',
			'common.tabs.files' => 'File',
			'common.tabs.git' => 'Controllo Versione',
			'common.tabs.tasks' => 'Attività',
			'common.tabs.browser' => 'Browser',
			'common.tabs.computer' => 'Computer',
			'common.tabs.board' => 'Bacheca',
			'common.tabs.usage' => 'AI Control',
			'common.status.loading' => 'Caricamento...',
			'common.status.success' => 'Completato',
			'common.status.error' => 'Errore',
			'common.status.failed' => 'Fallito',
			'common.status.pending' => 'In attesa',
			'common.status.completed' => 'Completato',
			'common.status.inProgress' => 'In corso',
			'common.messages.savedSuccessfully' => 'Salvato con successo',
			'common.messages.deletedSuccessfully' => 'Eliminato con successo',
			'common.messages.updatedSuccessfully' => 'Aggiornato con successo',
			'common.messages.operationFailed' => 'Operazione fallita',
			'common.messages.networkError' => 'Errore di rete. Controlla la tua connessione.',
			'common.messages.unauthorized' => 'Non autorizzato. Effettua l\'accesso.',
			'common.messages.notFound' => 'Non trovato',
			'common.messages.invalidInput' => 'Input non valido',
			'common.messages.requiredField' => 'Questo campo è obbligatorio',
			'common.messages.unknownError' => 'Si è verificato un errore sconosciuto',
			'common.messages.renameSessionFailed' => 'Impossibile rinominare la sessione. Riprova.',
			'common.navigation.settings' => 'Impostazioni',
			'common.navigation.home' => 'Home',
			'common.navigation.back' => 'Indietro',
			'common.navigation.next' => 'Avanti',
			'common.navigation.previous' => 'Precedente',
			'common.navigation.logout' => 'Esci',
			'common.common.language' => 'Lingua',
			'common.common.theme' => 'Tema',
			'common.common.darkMode' => 'Modalità scura',
			'common.common.lightMode' => 'Modalità chiara',
			'common.common.name' => 'Nome',
			'common.common.description' => 'Descrizione',
			'common.common.enabled' => 'Abilitato',
			'common.common.disabled' => 'Disabilitato',
			'common.common.optional' => 'Opzionale',
			'common.common.version' => 'Versione',
			'common.common.select' => 'Seleziona',
			'common.common.selectAll' => 'Seleziona tutto',
			'common.common.deselectAll' => 'Deseleziona tutto',
			'common.common.done' => 'Fatto',
			'common.common.failed' => 'Non riuscito',
			'common.time.justNow' => 'Adesso',
			'common.time.minutesAgo' => ({required Object count}) => '${count} min fa',
			'common.time.hoursAgo' => ({required Object count}) => '${count} ore fa',
			'common.time.daysAgo' => ({required Object count}) => '${count} giorni fa',
			'common.time.yesterday' => 'Ieri',
			'common.fileOperations.newFile' => 'Nuovo file',
			'common.fileOperations.newFolder' => 'Nuova cartella',
			'common.fileOperations.rename' => 'Rinomina',
			'common.fileOperations.move' => 'Sposta',
			'common.fileOperations.copyPath' => 'Copia percorso',
			'common.fileOperations.openInEditor' => 'Apri nell\'editor',
			'common.mainContent.loading' => 'Caricamento DDAgent',
			'common.mainContent.settingUpWorkspace' => 'Preparazione dell\'area di lavoro...',
			'common.mainContent.chooseProject' => 'Scegli il tuo progetto',
			_ => null,
		} ?? switch (path) {
			'common.mainContent.selectProjectDescription' => 'Seleziona un progetto dalla barra laterale per iniziare a programmare con Claude. Ogni progetto contiene le tue sessioni di chat e la cronologia dei file.',
			'common.mainContent.tip' => 'Suggerimento',
			'common.mainContent.createProjectMobile' => 'Tocca il pulsante menu in alto per accedere ai progetti',
			'common.mainContent.createProjectDesktop' => 'Crea un nuovo progetto cliccando l\'icona cartella nella barra laterale',
			'common.mainContent.newSession' => 'Nuova sessione',
			'common.mainContent.untitledSession' => 'Sessione senza titolo',
			'common.mainContent.projectFiles' => 'File del progetto',
			'common.mainContent.focusMode' => 'Modalità concentrazione (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Esci dalla modalità concentrazione (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Dividi sessione',
			'common.mainContent.closeSplitSession' => 'Chiudi sessione divisa',
			'common.mainContent.chooseWorkspace' => 'Scegli un workspace',
			'common.mainContent.chooseWorkspaceDescription' => 'Scegli un workspace per questa chat o creane uno nuovo nelle Impostazioni.',
			'common.mainContent.createWorkspace' => 'Crea workspace nelle Impostazioni',
			'common.mainContent.recentProjects' => 'Progetti recenti',
			'common.fileTree.loading' => 'Caricamento file...',
			'common.fileTree.files' => 'File',
			'common.fileTree.simpleView' => 'Vista semplice',
			'common.fileTree.compactView' => 'Vista compatta',
			'common.fileTree.detailedView' => 'Vista dettagliata',
			'common.fileTree.searchPlaceholder' => 'Cerca file e cartelle...',
			'common.fileTree.clearSearch' => 'Cancella ricerca',
			'common.fileTree.name' => 'Nome',
			'common.fileTree.size' => 'Dimensione',
			'common.fileTree.modified' => 'Modificato',
			'common.fileTree.permissions' => 'Permessi',
			'common.fileTree.noFilesFound' => 'Nessun file trovato',
			'common.fileTree.checkProjectPath' => 'Verifica che il percorso del progetto sia accessibile',
			'common.fileTree.noMatchesFound' => 'Nessuna corrispondenza trovata',
			'common.fileTree.tryDifferentSearch' => 'Prova con un termine di ricerca diverso o cancella la ricerca',
			'common.fileTree.justNow' => 'adesso',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} min fa',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} ore fa',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} giorni fa',
			'common.fileTree.newFile' => 'Nuovo file (Cmd+N)',
			'common.fileTree.newFolder' => 'Nuova cartella (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Aggiorna',
			'common.fileTree.collapseAll' => 'Comprimi tutto',
			'common.fileTree.context.rename' => 'Rinomina',
			'common.fileTree.context.delete' => 'Elimina',
			'common.fileTree.context.copyPath' => 'Copia percorso',
			'common.fileTree.context.download' => 'Scarica',
			'common.fileTree.context.newFile' => 'Nuovo file',
			'common.fileTree.context.newFolder' => 'Nuova cartella',
			'common.fileTree.context.upload' => 'Carica file',
			'common.fileTree.context.refresh' => 'Aggiorna',
			'common.fileTree.context.menuLabel' => 'Menu contestuale file',
			'common.fileTree.context.loading' => 'Caricamento...',
			'common.fileTree.searchContentPlaceholder' => 'Cerca nei file...',
			'common.fileTree.searchInFiles' => 'Cerca nei file',
			'common.fileTree.searchByName' => 'Cerca per nome',
			'common.fileTree.loadFailed' => 'Impossibile caricare i file',
			'common.fileTree.noSearchResults' => 'Nessuna corrispondenza trovata',
			'common.fileTree.searchError' => 'Ricerca non riuscita',
			'common.fileTree.searching' => 'Ricerca in corso...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Mostrati i primi ${count} risultati',
			'common.fileTree.allWorkspaces' => 'Tutti i workspace',
			'common.fileTree.delete.confirm' => 'Elimina',
			'common.fileTree.delete.fileWarning' => 'Questo file verrà eliminato definitivamente.',
			'common.fileTree.delete.folderWarning' => 'Questa cartella e tutto il suo contenuto verranno eliminati definitivamente.',
			'common.fileTree.delete.title' => ({required Object type}) => 'Elimina ${type}',
			'common.fileTree.dropToUpload' => 'Trascina i file per caricarli',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Trascina i file per caricarli in «${folder}»',
			'common.fileTree.noProject' => 'Aggiungi prima un progetto',
			'common.fileTree.noRecentFiles' => 'Nessun file modificato negli ultimi 7 giorni',
			'common.fileTree.showAllFiles' => 'Mostra tutti i file',
			'common.fileTree.showAllFilesHint' => 'Disattiva il filtro recenti per vedere tutto.',
			'common.fileTree.showRecentOnly' => 'Mostra i file modificati negli ultimi 7 giorni',
			'common.fileTree.toast.copyFailed' => 'Impossibile copiare il percorso',
			'common.fileTree.toast.fileCreated' => 'File creato con successo',
			'common.fileTree.toast.fileDeleted' => 'File eliminato',
			'common.fileTree.toast.folderCreated' => 'Cartella creata con successo',
			'common.fileTree.toast.folderDeleted' => 'Cartella eliminata',
			'common.fileTree.toast.folderDownloaded' => 'Cartella scaricata come ZIP',
			'common.fileTree.toast.pathCopied' => 'Percorso copiato negli appunti',
			'common.fileTree.toast.renamed' => 'Rinominato con successo',
			'common.fileTree.uploadComplete' => 'Caricamento completato',
			'common.fileTree.uploadFailed' => 'Caricamento non riuscito',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Carica file (max ${size} ciascuno)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Carica file in «${folder}»',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => 'Caricati ${uploaded} di ${total} ${label}',
			'common.fileTree.uploadingFiles' => 'Caricamento file',
			'common.fileTree.validation.dotsOnly' => 'Il nome del file non può essere solo punti',
			'common.fileTree.validation.emptyName' => 'Il nome del file non può essere vuoto',
			'common.fileTree.validation.invalidChars' => 'Il nome del file contiene caratteri non validi',
			'common.fileTree.validation.reserved' => 'Il nome del file è un nome riservato',
			'common.projectWizard.title' => 'Crea nuovo progetto',
			'common.projectWizard.steps.type' => 'Tipo',
			'common.projectWizard.steps.configure' => 'Configura',
			'common.projectWizard.steps.confirm' => 'Conferma',
			'common.projectWizard.step1.question' => 'Hai già un\'area di lavoro o vuoi crearne una nuova?',
			'common.projectWizard.step1.existing.title' => 'Area di lavoro esistente',
			'common.projectWizard.step1.existing.description' => 'Ho già un\'area di lavoro sul mio server e devo solo aggiungerla alla lista dei progetti',
			'common.projectWizard.step1.kNew.title' => 'Nuova area di lavoro',
			'common.projectWizard.step1.kNew.description' => 'Crea una nuova area di lavoro, opzionalmente clonando da un repository GitHub',
			'common.projectWizard.step2.existingPath' => 'Percorso area di lavoro',
			'common.projectWizard.step2.newPath' => 'Percorso area di lavoro',
			'common.projectWizard.step2.existingPlaceholder' => '/percorso/area-di-lavoro/esistente',
			'common.projectWizard.step2.newPlaceholder' => '/percorso/nuova/area-di-lavoro',
			'common.projectWizard.step2.existingHelp' => 'Percorso completo della directory dell\'area di lavoro esistente',
			'common.projectWizard.step2.newHelp' => 'Percorso completo della directory dell\'area di lavoro',
			'common.projectWizard.step2.githubUrl' => 'URL GitHub (opzionale)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/utente/repository',
			'common.projectWizard.step2.githubHelp' => 'Opzionale: fornisci un URL GitHub per clonare un repository',
			'common.projectWizard.step2.githubAuth' => 'Autenticazione GitHub (opzionale)',
			'common.projectWizard.step2.githubAuthHelp' => 'Richiesta solo per repository privati. I repository pubblici possono essere clonati senza autenticazione.',
			'common.projectWizard.step2.loadingTokens' => 'Caricamento token salvati...',
			'common.projectWizard.step2.storedToken' => 'Token salvato',
			'common.projectWizard.step2.newToken' => 'Nuovo token',
			'common.projectWizard.step2.nonePublic' => 'Nessuno (pubblico)',
			'common.projectWizard.step2.selectToken' => 'Seleziona token',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Seleziona un token --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Questo token verrà utilizzato solo per questa operazione',
			'common.projectWizard.step2.publicRepoInfo' => 'I repository pubblici non richiedono autenticazione. Puoi saltare il token se stai clonando un repository pubblico.',
			'common.projectWizard.step2.noTokensHelp' => 'Nessun token salvato disponibile. Puoi aggiungere token in Impostazioni → Chiavi API per un riutilizzo più semplice.',
			'common.projectWizard.step2.optionalTokenPublic' => 'Token GitHub (opzionale per repository pubblici)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (lascia vuoto per repository pubblici)',
			'common.projectWizard.step3.reviewConfig' => 'Rivedi la tua configurazione',
			'common.projectWizard.step3.existingWorkspace' => 'Area di lavoro esistente',
			'common.projectWizard.step3.newWorkspace' => 'Nuova area di lavoro',
			'common.projectWizard.step3.path' => 'Percorso:',
			'common.projectWizard.step3.cloneFrom' => 'Clona da:',
			'common.projectWizard.step3.authentication' => 'Autenticazione:',
			'common.projectWizard.step3.usingStoredToken' => 'Usando token salvato:',
			'common.projectWizard.step3.usingProvidedToken' => 'Usando token fornito',
			'common.projectWizard.step3.noAuthentication' => 'Nessuna autenticazione',
			'common.projectWizard.step3.sshKey' => 'Chiave SSH',
			'common.projectWizard.step3.existingInfo' => 'L\'area di lavoro verrà aggiunta alla lista dei progetti e sarà disponibile per le sessioni Claude/Cursor.',
			'common.projectWizard.step3.newWithClone' => 'Il repository verrà clonato da questa cartella.',
			'common.projectWizard.step3.newEmpty' => 'L\'area di lavoro verrà aggiunta alla lista dei progetti e sarà disponibile per le sessioni Claude/Cursor.',
			'common.projectWizard.step3.cloningRepository' => 'Clonazione repository...',
			'common.projectWizard.buttons.cancel' => 'Annulla',
			'common.projectWizard.buttons.back' => 'Indietro',
			'common.projectWizard.buttons.next' => 'Avanti',
			'common.projectWizard.buttons.createProject' => 'Crea progetto',
			'common.projectWizard.buttons.creating' => 'Creazione...',
			'common.projectWizard.buttons.cloning' => 'Clonazione...',
			'common.projectWizard.errors.selectType' => 'Seleziona se hai un\'area di lavoro esistente o vuoi crearne una nuova',
			'common.projectWizard.errors.providePath' => 'Fornisci un percorso per l\'area di lavoro',
			'common.projectWizard.errors.failedToCreate' => 'Impossibile creare l\'area di lavoro',
			'common.projectWizard.errors.failedToCreateFolder' => 'Impossibile creare la cartella',
			'common.notifications.genericTool' => 'uno strumento',
			'common.notifications.codes.generic.info.title' => 'Notifica',
			'common.notifications.codes.permission.required.title' => 'Azione richiesta',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} è in attesa della tua decisione.',
			'common.notifications.codes.run.stopped.title' => 'Esecuzione interrotta',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Motivo: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Esecuzione fallita',
			'common.notifications.codes.agent.notification.title' => 'Notifica agente',
			'common.versionUpdate.title' => 'Aggiornamento disponibile',
			'common.versionUpdate.newVersionReady' => 'Una nuova versione è pronta',
			'common.versionUpdate.currentVersion' => 'Versione attuale',
			'common.versionUpdate.latestVersion' => 'Ultima versione',
			'common.versionUpdate.whatsNew' => 'Novità:',
			'common.versionUpdate.viewFullRelease' => 'Vedi release completa',
			'common.versionUpdate.updateProgress' => 'Progresso aggiornamento:',
			'common.versionUpdate.manualUpgrade' => 'Aggiornamento manuale:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Oppure clicca "Aggiorna ora" per eseguire l\'aggiornamento automaticamente.',
			'common.versionUpdate.updateCompleted' => 'Aggiornamento completato con successo!',
			'common.versionUpdate.restartServer' => 'Riavvia il server per applicare le modifiche.',
			'common.versionUpdate.updateFailed' => 'Aggiornamento fallito',
			'common.versionUpdate.buttons.close' => 'Chiudi',
			'common.versionUpdate.buttons.later' => 'Più tardi',
			'common.versionUpdate.buttons.copyCommand' => 'Copia comando',
			'common.versionUpdate.buttons.updateNow' => 'Aggiorna ora',
			'common.versionUpdate.buttons.updating' => 'Aggiornamento...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Chiudi finestra aggiornamento versione',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Mostra barra laterale',
			'common.versionUpdate.ariaLabels.settings' => 'Impostazioni',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Aggiornamento disponibile',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Chiudi barra laterale',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => 'Panoramica',
			'common.quota.section.quotas' => 'Quote',
			'common.quota.section.usage' => 'Utilizzo',
			'common.quota.section.agents' => 'Agenti',
			'common.quota.filter.all' => 'Tutti',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 giorni',
			'common.quota.period.k30d' => '30 giorni',
			'common.quota.period.all' => 'Tutti',
			'common.quota.group.provider' => 'Provider',
			'common.quota.group.model' => 'Modello',
			'common.quota.group.agent' => 'Agente',
			'common.quota.group.tool' => 'Strumento',
			'common.quota.metric.tokens' => 'Token',
			'common.quota.metric.input' => 'Input',
			'common.quota.metric.output' => 'Output',
			'common.quota.metric.cache' => 'Letture cache',
			'common.quota.metric.calls' => 'Chiamate API',
			'common.quota.metric.cost' => 'Costo',
			'common.quota.metric.sessions' => 'Sessioni',
			'common.quota.cost.billed' => 'Fatturato (API + eccedenza)',
			'common.quota.cost.listPrice' => 'Prezzo di listino dei token usati',
			'common.quota.cost.subscriptionValue' => 'Coperto dagli abbonamenti',
			'common.quota.cost.cacheSavings' => 'Risparmio cache',
			'common.quota.cost3.billed' => 'Fatturato (API + eccedenza)',
			'common.quota.cost3.listPrice' => 'Prezzo di listino dei token usati',
			'common.quota.cost3.subscriptionValue' => 'Coperto dagli abbonamenti',
			'common.quota.overview.trendTitle' => 'Token e costo — ultimi 7 giorni',
			'common.quota.overview.effectiveCost' => 'Costo effettivo (7 giorni)',
			'common.quota.overview.alertsTitle' => 'Avvisi',
			'common.quota.overview.noAlerts' => 'Nulla richiede attenzione al momento.',
			'common.quota.overview.limitsTitle' => 'Utilizzo e limiti',
			'common.quota.overview.activeTasks' => 'Attività attive',
			'common.quota.overview.viewAccounts' => 'Tutti gli account',
			'common.quota.overview.viewAgents' => 'Tutti gli agenti',
			'common.quota.overview.noTasks' => 'Nessun agente in esecuzione al momento.',
			'common.quota.usage.trendTitle' => 'Tendenza giornaliera',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Ripartizione per ${group}',
			'common.quota.usage.colName' => 'Nome',
			'common.quota.usage.sourceUnavailable' => 'Archivio analitica non disponibile; nessun dato mostrato.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} in esecuzione',
			'common.quota.agents.colAgent' => 'Agente',
			'common.quota.agents.colStatus' => 'Stato',
			'common.quota.agents.colTask' => 'Attività',
			'common.quota.agents.colModel' => 'Account / modello',
			'common.quota.agents.colTime' => 'Ora',
			'common.quota.agents.empty' => 'Nessun agente corrisponde a questo filtro.',
			'common.quota.agents.detailSession' => 'Sessione',
			'common.quota.agents.detailStarted' => 'Avviato',
			'common.quota.agents.detailRetries' => 'Tentativi',
			'common.quota.agents.detailResult' => 'Risultato',
			'common.quota.agents.notTracked' => 'non tracciato',
			'common.quota.agentStatus.running' => 'In esecuzione',
			'common.quota.agentStatus.waiting' => 'In attesa',
			'common.quota.agentStatus.failed' => 'Fallito',
			'common.quota.agentStatus.finished' => 'Completato',
			'common.quota.agentStatus.queued' => 'In coda',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: al ritmo attuale il limite si esaurisce in ${value}',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% usato (soglia ${watch}%)',
			'common.quota.backToChat' => 'Torna alla chat',
			'common.quota.syncNow' => 'Sincronizza ora',
			'common.quota.generatedAt' => ({required Object value}) => 'Aggiornato ${value}',
			'common.quota.loading' => 'Caricamento limiti account…',
			'common.quota.remaining' => ({required Object value}) => '${value}% rimasto',
			'common.quota.resetsIn' => ({required Object value}) => 'reset tra ${value}',
			'common.quota.projected' => ({required Object value}) => 'al ritmo attuale questo limite si esaurisce in ${value}',
			'common.quota.syncedAgo' => ({required Object value}) => 'sincronizzato ${value} fa',
			'common.quota.refreshAccount' => 'Aggiorna account',
			'common.quota.syncFailed' => 'Sincronizzazione non riuscita',
			'common.quota.history' => 'Cronologia',
			'common.quota.historyPoints' => ({required Object value}) => '${value} letture registrate',
			'common.quota.historyEmpty' => 'Nessuna cronologia registrata',
			'common.quota.noAgents' => 'Nessun agente assegnato',
			'common.quota.noSubscription' => 'Nessun abbonamento',
			'common.quota.noSubscriptionHint' => 'Il provider non segnala alcun piano attivo per questo account.',
			'common.quota.quality.live' => 'Live',
			'common.quota.quality.cached' => 'In cache',
			'common.quota.quality.estimate' => 'Stima',
			'common.quota.quality.unknown' => 'Sconosciuto',
			'common.quota.quality.error' => 'Errore',
			'common.quota.kpi.atRisk' => 'Limiti a rischio',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'account oltre il ${value}%',
			'common.quota.kpi.windowsAtRisk' => 'Finestre in esaurimento',
			'common.quota.kpi.errored' => 'Errori di sincronizzazione',
			'common.quota.kpi.activeAgents' => 'Agenti attivi',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} in attesa · ${queued} in coda',
			'common.quota.kpi.nextReset' => 'Prossimo reset',
			'common.quota.kpi.tokens' => 'Token',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} sessioni',
			'common.quota.kpi.cost' => 'Costo stimato',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} coperto dai piani',
			'common.quota.empty.title' => 'Nessun account collegato',
			'common.quota.empty.description' => 'Accedi a Claude, Codex, Gemini o CommandCode per tracciare le quote qui.',
			'common.quota.settings.title' => 'Avvisi e routing',
			'common.quota.settings.description' => 'Controlla quando la dashboard ti avvisa e come vengono suggeriti gli account per il nuovo lavoro.',
			'common.quota.settings.alertsEnabled' => 'Avvisi predittivi e di soglia',
			'common.quota.settings.alertsEnabledHint' => 'Avvisa prima che un limite si esaurisca al ritmo attuale, non solo al 90%.',
			'common.quota.settings.watchThreshold' => 'Soglia di osservazione (%)',
			'common.quota.settings.dangerThreshold' => 'Soglia di pericolo (%)',
			'common.quota.settings.routingMode' => 'Routing',
			'common.quota.settings.routing.manual' => 'Manuale — solo raccomandazione',
			'common.quota.settings.routing.ask' => 'Chiedi prima di cambiare account',
			'common.quota.settings.routing.autoLowRisk' => 'Cambio automatico per attività a basso rischio',
			'common.quota.settings.logSources' => 'Fonti di log',
			'common.quota.settings.logSourcesHint' => 'Le schermate di utilizzo e agenti leggono queste fonti in sola lettura.',
			'common.quota.settings.quotaConsent' => 'Consenti polling delle quote',
			'common.quota.settings.quotaConsentHint' => 'Interroga gli endpoint dei provider con le tue credenziali salvate per leggere i limiti live.',
			'common.quota.settings.perAccount' => 'Override per account',
			'common.quota.settings.tab' => 'Impostazioni del Control Center',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Tutti',
			'common.actions.cancel' => 'Annulla',
			'common.actions.retry' => 'Riprova',
			'common.actions.save' => 'Salva',
			'common.browserPane.address' => 'Indirizzo',
			'common.browserPane.back' => 'Indietro',
			'common.browserPane.connecting' => 'Connessione al browser…',
			'common.browserPane.connectionFailed' => 'Connessione al browser non riuscita.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => 'Impossibile caricare ${url}',
			'common.browserPane.disconnected' => 'Vista browser disconnessa',
			'common.browserPane.enterUrl' => 'Inserisci URL',
			'common.browserPane.forward' => 'Avanti',
			'common.browserPane.invalidUrl' => 'Inserisci un URL http(s) valido',
			'common.browserPane.noAuthToken' => 'Nessun token di autenticazione disponibile.',
			'common.browserPane.openExternal' => 'Apri nel browser di sistema',
			'common.browserPane.reload' => 'Ricarica',
			'common.browserPane.retry' => 'Riprova',
			'common.browserPane.stop' => 'Interrompi',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} attive',
			'common.browserUse.cancel' => 'Annulla',
			'common.browserUse.close' => 'Chiudi',
			'common.browserUse.delete' => 'Elimina',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} verrà eliminata definitivamente.',
			'common.browserUse.deleteSession' => 'Elimina sessione',
			'common.browserUse.deleteTitle' => 'Eliminare la sessione del browser?',
			'common.browserUse.empty.descDisabled' => 'Abilita Browser nelle impostazioni per consentire agli agenti di aprire sessioni browser monitorate.',
			'common.browserUse.empty.descEnabled' => 'Le sessioni browser degli agenti appaiono qui mentre un task AI usa Browser.',
			'common.browserUse.empty.titleDisabled' => 'Browser è disabilitato',
			'common.browserUse.empty.titleEnabled' => 'Nessuna sessione browser ancora',
			'common.browserUse.emptyStatus' => 'vuota',
			'common.browserUse.errors.actionFailed' => 'Azione del browser non riuscita',
			'common.browserUse.errors.loadFailed' => 'Impossibile caricare Browser',
			'common.browserUse.fullscreen' => 'Schermo intero',
			'common.browserUse.installRuntime' => 'Installa runtime',
			'common.browserUse.installing' => 'Installazione...',
			'common.browserUse.lastAction' => 'Ultima azione',
			'common.browserUse.nextSnapshot' => 'Il prossimo snapshot del browser dell’agente apparirà qui.',
			'common.browserUse.noPageLoaded' => 'Nessuna pagina caricata',
			'common.browserUse.noSessions' => 'Nessuna sessione browser degli agenti.',
			'common.browserUse.none' => 'Nessuno',
			'common.browserUse.openSettings' => 'Apri impostazioni Browser',
			'common.browserUse.profile' => 'Profilo',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Usa Browser per ispezionare il flusso di checkout e segnalare stati UI non funzionanti.',
			'common.browserUse.prompts.prompt2' => 'Apri <url> con Browser, interagisci con la pagina e riassumi cosa è cambiato dopo ogni passo.',
			'common.browserUse.refresh' => 'Aggiorna sessioni browser',
			'common.browserUse.relative.daysAgo' => ' g fa',
			'common.browserUse.relative.hoursAgo' => ' h fa',
			'common.browserUse.relative.justNow' => 'Adesso',
			'common.browserUse.relative.minutesAgo' => ' min fa',
			'common.browserUse.relative.never' => 'Mai',
			'common.browserUse.relative.secondsAgo' => ' s fa',
			'common.browserUse.relative.unknown' => 'Sconosciuto',
			'common.browserUse.runtime.disabled' => 'Disabilitato',
			'common.browserUse.runtime.installing' => 'Installazione',
			'common.browserUse.runtime.ready' => 'Pronto',
			'common.browserUse.runtime.setupRequired' => 'Configurazione richiesta',
			'common.browserUse.runtimeSetup' => 'Configurazione del runtime richiesta',
			'common.browserUse.selected' => 'Selezionata',
			'common.browserUse.sessionFallback' => 'Sessione browser',
			'common.browserUse.sessionScreenshot' => 'Screenshot della sessione browser',
			'common.browserUse.sessions' => 'Sessioni',
			'common.browserUse.status' => 'Stato',
			'common.browserUse.stop' => 'Interrompi',
			'common.browserUse.stopSession' => 'Interrompi sessione',
			'common.browserUse.subtitle' => 'Monitora le sessioni browser aperte dagli agenti AI.',
			'common.browserUse.temporary' => 'Temporaneo',
			'common.browserUse.thisSession' => 'Questa sessione',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '${count} totali',
			'common.browserUse.updated' => ({required Object time}) => 'Aggiornato ${time}',
			'common.browserUse.waiting' => 'In attesa',
			'common.browserUse.waitingForScreenshot' => 'In attesa dello screenshot',
			'common.commandPalette.backToAll' => 'Torna a tutto',
			'common.commandPalette.backspaceHint' => 'Backspace per tornare indietro',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Sfoglia tutti i branch (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Sfoglia tutti i commit (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Sfoglia tutti i file (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Sfoglia tutte le sessioni (${count})',
			'common.commandPalette.compare.costNote' => 'Il costo è una stima lato client basata sulle tariffe per token pubblicate; i modelli sconosciuti mostrano «—».',
			'common.commandPalette.compare.estCost' => 'Costo stim.',
			'common.commandPalette.compare.inputOutput' => 'Input / Output',
			'common.commandPalette.compare.model' => 'Modello',
			'common.commandPalette.compare.na' => 'N/D',
			'common.commandPalette.compare.openSplit' => 'Apri in vista divisa',
			'common.commandPalette.compare.provider' => 'Provider',
			'common.commandPalette.compare.selectSession' => 'Seleziona una sessione…',
			'common.commandPalette.compare.tokensUsed' => 'Token usati',
			'common.commandPalette.groups.actions' => 'Azioni',
			'common.commandPalette.groups.branches' => 'Branch',
			'common.commandPalette.groups.commits' => 'Commit',
			'common.commandPalette.groups.files' => 'File',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Naviga',
			'common.commandPalette.groups.sessions' => 'Sessioni',
			'common.commandPalette.groups.settings' => 'Impostazioni',
			'common.commandPalette.hints.close' => 'Chiudi',
			'common.commandPalette.hints.navigate' => 'Naviga',
			'common.commandPalette.hints.select' => 'Seleziona',
			'common.commandPalette.hints.togglePalette' => 'Attiva/disattiva palette',
			'common.commandPalette.items.compareSessions' => 'Confronta sessioni',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Apri impostazioni',
			'common.commandPalette.items.selectProjectFirst' => 'Seleziona prima un progetto',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Impostazioni: ${label}',
			'common.commandPalette.items.startNewChat' => 'Avvia nuova chat',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Passa a: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Cambia tema',
			'common.commandPalette.items.tokensAndCost' => 'token e costo',
			'common.commandPalette.nav.board' => 'Vai alla Bacheca agenti',
			'common.commandPalette.nav.chat' => 'Vai alla Chat',
			'common.commandPalette.nav.files' => 'Vai ai File',
			'common.commandPalette.nav.git' => 'Vai a Git',
			'common.commandPalette.nav.sourceControl' => 'Vai al Controllo del codice',
			'common.commandPalette.nav.tasks' => 'Vai alle Attività',
			'common.commandPalette.nav.usage' => 'Vai a Quota e utilizzo',
			'common.commandPalette.noResults' => 'Nessun risultato.',
			'common.commandPalette.pages.actions' => 'Azioni',
			'common.commandPalette.pages.branches' => 'Branch',
			'common.commandPalette.pages.commits' => 'Commit',
			'common.commandPalette.pages.compare' => 'Confronta',
			'common.commandPalette.pages.files' => 'File',
			'common.commandPalette.pages.sessions' => 'Sessioni',
			'common.commandPalette.placeholder' => 'Digita per cercare…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => 'Cerca in ${page}…',
			'common.commandPalette.title' => 'Palette dei comandi',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} avanti',
			'common.gitPanel.aheadLabel' => 'avanti',
			'common.gitPanel.aiSuggest' => 'Suggerimento AI',
			'common.gitPanel.aiSuggestTitle' => 'Genera un messaggio di commit con l’AI',
			'common.gitPanel.all' => 'Tutti',
			'common.gitPanel.allStaged' => 'Tutte le modifiche in stage',
			'common.gitPanel.behind' => ({required Object count}) => '${count} indietro',
			'common.gitPanel.behindLabel' => 'indietro',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'Eliminare il branch «${branch}»? L’eliminazione normale riesce solo se il branch è completamente fuso. Azione irreversibile.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'Passare al branch «${branch}»? Assicurati di non avere modifiche non committate.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} locali, ${remote} remoti',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} locali',
			'common.gitPanel.branches.current' => 'attuale',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => 'Elimina ${branch}',
			'common.gitPanel.branches.emptyDesc' => 'Crea un branch per iniziare lavoro parallelo.',
			'common.gitPanel.branches.forceDelete' => 'Forza eliminazione',
			'common.gitPanel.branches.forceDeleteDesc' => 'Rimuove definitivamente il branch anche se contiene commit non fusi altrove.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Forza l’eliminazione di questo branch non fuso',
			'common.gitPanel.branches.local' => 'Locali',
			'common.gitPanel.branches.kNew' => 'Nuovo branch',
			'common.gitPanel.branches.noMatch' => 'Nessun branch corrisponde alla ricerca',
			'common.gitPanel.branches.none' => 'Nessun branch trovato',
			'common.gitPanel.branches.remote' => 'remoti',
			'common.gitPanel.branches.kSwitch' => 'Cambia',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Passa a ${branch}',
			'common.gitPanel.cancel' => 'Annulla',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Modifiche (${count})',
			'common.gitPanel.clearSearch' => 'Cancella ricerca',
			'common.gitPanel.collapseDiff' => 'Comprimi diff',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Committa modifiche',
			'common.gitPanel.commitFiles' => ({required Object count}) => 'Committa ${count} file',
			'common.gitPanel.committing' => 'Commit in corso...',
			'common.gitPanel.confirmActions.commit' => 'Conferma',
			'common.gitPanel.confirmActions.delete' => 'Elimina',
			'common.gitPanel.confirmActions.deleteBranch' => 'Elimina',
			'common.gitPanel.confirmActions.discard' => 'Scarta',
			'common.gitPanel.confirmActions.publish' => 'Pubblica',
			'common.gitPanel.confirmActions.pull' => 'Pull',
			'common.gitPanel.confirmActions.push' => 'Push',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Annulla commit',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => 'Committare ${count} file con il messaggio: «${message}»?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'Eliminare il file non tracciato «${file}»? Azione irreversibile.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => 'Scartare tutte le modifiche a «${file}»? Azione irreversibile.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'Pubblicare il branch «${branch}» su ${remote}?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => 'Scaricare ${count} commit da ${remote}?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => 'Inviare ${count} commit a ${remote}?',
			'common.gitPanel.confirmRevert' => 'Annullare l’ultimo commit locale? Rimuove il commit ma mantiene le modifiche in stage.',
			'common.gitPanel.confirmTitles.commit' => 'Conferma azione',
			'common.gitPanel.confirmTitles.delete' => 'Elimina file',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Elimina branch',
			'common.gitPanel.confirmTitles.discard' => 'Scarta modifiche',
			'common.gitPanel.confirmTitles.publish' => 'Pubblica branch',
			'common.gitPanel.confirmTitles.pull' => 'Conferma pull',
			'common.gitPanel.confirmTitles.push' => 'Conferma push',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Annulla commit locale',
			'common.gitPanel.createBranch' => 'Crea nuovo branch',
			'common.gitPanel.creating' => 'Creazione...',
			'common.gitPanel.delete' => 'Elimina',
			'common.gitPanel.deleteUntracked' => 'Elimina file non tracciato',
			'common.gitPanel.deselectAll' => 'Deseleziona tutto',
			'common.gitPanel.discard' => 'Scarta',
			'common.gitPanel.discardChanges' => 'Scarta modifiche',
			'common.gitPanel.dismiss' => 'Chiudi',
			'common.gitPanel.dismissError' => 'Chiudi errore',
			'common.gitPanel.errors.createBranchFailed' => 'Creazione branch non riuscita',
			'common.gitPanel.errors.createWorktreeFailed' => 'Impossibile creare il worktree',
			'common.gitPanel.errors.deleteBranchFailed' => 'Eliminazione branch non riuscita',
			'common.gitPanel.errors.fetchFailed' => 'Fetch non riuscito',
			'common.gitPanel.errors.initFailed' => 'Impossibile inizializzare il repository',
			'common.gitPanel.errors.initialCommitFailed' => 'Impossibile creare il commit iniziale',
			'common.gitPanel.errors.mergeFailed' => 'Merge non riuscito',
			'common.gitPanel.errors.openWorktreeFailed' => 'Impossibile aprire il worktree',
			'common.gitPanel.errors.operationFailed' => 'Operazione git non riuscita',
			'common.gitPanel.errors.publishFailed' => 'Pubblicazione non riuscita',
			'common.gitPanel.errors.pullFailed' => 'Pull non riuscito',
			'common.gitPanel.errors.pushFailed' => 'Push non riuscito',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Impossibile rimuovere il worktree',
			'common.gitPanel.errors.stageFailed' => 'Stage non riuscito',
			'common.gitPanel.errors.stageHunksFailed' => 'Stage delle sezioni non riuscito',
			'common.gitPanel.errors.switchFailed' => 'Cambio di branch non riuscito',
			'common.gitPanel.errors.unstageFailed' => 'Unstage non riuscito',
			'common.gitPanel.errors.unstageHunksFailed' => 'Unstage delle sezioni non riuscito',
			'common.gitPanel.expandDiff' => 'Espandi diff',
			'common.gitPanel.fetch' => 'Fetch',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Fetch da ${remote}',
			'common.gitPanel.fetching' => 'Fetch…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} file selezionati',
			'common.gitPanel.generating' => 'Generazione...',
			'common.gitPanel.history.added' => 'Aggiunte',
			'common.gitPanel.history.author' => 'Autore',
			'common.gitPanel.history.changedFiles' => 'File modificati',
			'common.gitPanel.history.date' => 'Data',
			'common.gitPanel.history.empty' => 'Nessun commit trovato',
			'common.gitPanel.history.files' => 'File',
			'common.gitPanel.history.removed' => 'Rimosse',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Rimuovi il worktree ed elimina il suo branch una volta fuso',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Pulisci dopo il merge',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} commit',
			'common.gitPanel.mergeWorktree.merge' => 'Fondi',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Fondi il branch \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Messaggio di commit',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Combina tutti i ${commits} in un singolo commit su ${branch}',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Schiaccia i commit',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squash e fondi',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Squash-merge del branch \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => 'Fondi worktree',
			'common.gitPanel.merging' => 'Fusione...',
			'common.gitPanel.messagePlaceholder' => 'Messaggio (Ctrl+Invio per committare)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Questo creerà un nuovo branch dal branch attuale (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Nome del branch',
			'common.gitPanel.newBranch.submit' => 'Crea branch',
			'common.gitPanel.newBranch.title' => 'Crea nuovo branch',
			'common.gitPanel.newWorktree.branchLabel' => 'Branch',
			'common.gitPanel.newWorktree.createFrom' => 'Crea da',
			'common.gitPanel.newWorktree.description' => 'Estrai un branch nella sua cartella e lavoraci in parallelo.',
			'common.gitPanel.newWorktree.existingBranch' => 'Branch esistente — verrà estratto così com’è.',
			'common.gitPanel.newWorktree.submit' => 'Crea worktree',
			'common.gitPanel.newWorktree.switchAfter' => 'Passa al worktree dopo averlo creato',
			'common.gitPanel.newWorktree.title' => 'Nuovo worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Verrà creato in',
			'common.gitPanel.noChanges' => 'Nessuna modifica rilevata',
			'common.gitPanel.noChangesToCommit' => 'Nessuna modifica da committare',
			'common.gitPanel.noCommits.create' => 'Crea commit iniziale',
			'common.gitPanel.noCommits.creating' => 'Creazione commit iniziale...',
			'common.gitPanel.noCommits.description' => 'Questo repository non ha ancora commit. Crea il primo commit per iniziare a tracciare le modifiche.',
			'common.gitPanel.noCommits.title' => 'Ancora nessun commit',
			'common.gitPanel.noMatchingBranches' => 'Nessun branch corrispondente',
			'common.gitPanel.noRepo.description' => 'Questo progetto non è ancora un repository git. Inizializzane uno per tracciare le modifiche e usare il controllo del codice.',
			'common.gitPanel.noRepo.init' => 'Esegui git init',
			'common.gitPanel.noRepo.initializing' => 'Inizializzazione repository...',
			'common.gitPanel.noRepo.title' => 'Nessun repository git',
			'common.gitPanel.noStagedFiles' => 'Nessun file in stage',
			'common.gitPanel.none' => 'Nessuno',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Niente da inviare a ${remote}',
			'common.gitPanel.openFile' => 'Clicca per aprire il file',
			'common.gitPanel.publish' => 'Pubblica',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => 'Pubblica «${branch}» su ${remote}',
			'common.gitPanel.publishing' => 'Pubblicazione…',
			'common.gitPanel.pull' => 'Pull',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Pull ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => 'Scarica ${count} da ${remote}',
			'common.gitPanel.pulling' => 'Pull…',
			'common.gitPanel.push' => 'Push',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Push ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => 'Invia ${count} a ${remote}',
			'common.gitPanel.pushing' => 'Push…',
			'common.gitPanel.recentCommits' => 'Commit recenti',
			'common.gitPanel.refresh' => 'Aggiorna stato git',
			'common.gitPanel.remove' => 'Rimuovi',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Elimina anche il branch',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => 'Rimuovere il worktree di ${branch}? La sua cartella viene eliminata e il progetto collegato archiviato — le sessioni chat restano recuperabili.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'Questo worktree ha ${count} modifiche non committate che andranno perse.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Scarta modifiche non committate',
			'common.gitPanel.removeWorktree.title' => 'Rimuovi worktree',
			'common.gitPanel.removing' => 'Rimozione...',
			'common.gitPanel.revertLatest' => 'Annulla ultimo commit locale',
			'common.gitPanel.scroll' => 'Scorrimento',
			'common.gitPanel.searchBranches' => 'Cerca branch...',
			'common.gitPanel.selectAll' => 'Seleziona tutto',
			'common.gitPanel.selectProject' => 'Seleziona un progetto per vedere il controllo del codice',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => '${selected} di ${total} file selezionati',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => '${selected} di ${total} selezionati',
			'common.gitPanel.sideBySide' => 'Affiancato',
			'common.gitPanel.stageAll' => 'Metti tutto in stage',
			'common.gitPanel.stageHunk' => 'Metti in stage questa sezione',
			'common.gitPanel.staged' => ({required Object count}) => 'In stage (${count})',
			'common.gitPanel.status.added' => 'Aggiunto',
			'common.gitPanel.status.deleted' => 'Eliminato',
			'common.gitPanel.status.modified' => 'Modificato',
			'common.gitPanel.status.untracked' => 'Non tracciato',
			'common.gitPanel.statusGuide' => 'Guida agli stati dei file',
			'common.gitPanel.switchScroll' => 'Passa allo scorrimento orizzontale',
			'common.gitPanel.switchSplit' => 'Passa alla vista affiancata',
			'common.gitPanel.switchUnified' => 'Passa alla vista unificata',
			'common.gitPanel.switchWrap' => 'Passa all’a capo automatico',
			'common.gitPanel.unified' => 'Unificato',
			'common.gitPanel.unstageAll' => 'Togli tutto dallo stage',
			'common.gitPanel.unstageHunk' => 'Togli questa sezione dallo stage',
			'common.gitPanel.upToDate' => 'Aggiornato',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'Aggiornato con ${remote}',
			'common.gitPanel.viewAll' => 'Vedi tutto',
			'common.gitPanel.viewsAria' => 'Viste del controllo del codice',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} modifiche',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree',
			'common.gitPanel.worktrees.createFirst' => 'Crea il tuo primo worktree',
			'common.gitPanel.worktrees.detached' => 'distaccato',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'distaccato @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'HEAD detached',
			'common.gitPanel.worktrees.emptyDesc' => 'Un worktree estrae un branch nella sua cartella, così puoi avere sessioni chat parallele e fondere i risultati quando sono pronti.',
			'common.gitPanel.worktrees.emptyTitle' => 'Lavora su branch in parallelo',
			'common.gitPanel.worktrees.locked' => 'bloccato',
			'common.gitPanel.worktrees.mainWorktree' => 'worktree principale',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => 'Fondi ${branch} nel branch base',
			'common.gitPanel.worktrees.kNew' => 'Nuovo worktree',
			'common.gitPanel.worktrees.none' => 'Nessun worktree',
			'common.gitPanel.worktrees.nothingToMerge' => 'Niente da fondere — nessun commit avanti al branch base',
			'common.gitPanel.worktrees.open' => 'Apri',
			'common.gitPanel.worktrees.refresh' => 'Aggiorna worktree',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Rimuovi worktree di ${branch}',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Passa a ${branch}',
			'common.gitPanel.wrap' => 'A capo',
			'common.gitPanel.tabs.changes' => 'Modifiche',
			'common.gitPanel.tabs.history' => 'Commit',
			'common.gitPanel.tabs.branches' => 'Branch',
			'common.gitPanel.tabs.worktrees' => 'Worktree',
			'common.sessions.renameSession' => 'Rinomina sessione',
			'common.projects.newSession' => 'Nuova sessione',
			'common.codeBlock.wrapLines' => 'A capo automatico',
			'common.codeBlock.noWrap' => 'Nessun a capo',
			'common.update.available' => ({required Object version}) => 'Aggiornamento disponibile · v${version}',
			'common.update.confirm' => ({required Object version}) => 'Aggiornare alla v${version}? Il server si aggiorna e si riavvia da solo — le sessioni attive verranno interrotte.',
			'common.update.downloading' => 'Download e applicazione dell\'aggiornamento in corso…',
			'common.update.restarting' => 'Riavvio del server — ci vorrà un momento…',
			'common.update.done' => ({required Object version}) => 'Aggiornato alla v${version}. Ricarica l\'app per applicare il nuovo bundle.',
			'common.update.manualRestart' => 'L\'aggiornamento è stato applicato, ma il server non si è riavviato da solo — riavvialo manualmente per completare.',
			'common.update.failed' => 'Aggiornamento non riuscito.',
			'common.update.failedTitle' => 'Aggiornamento non riuscito',
			'common.update.appConfirm' => ({required Object version}) => 'Installare DDAgent v${version} su questo dispositivo? Android chiederà il permesso di installare app da DDAgent la prima volta.',
			'common.update.appPermission' => 'Consenti «Installa app sconosciute» per DDAgent, poi tocca di nuovo Aggiorna.',
			'common.update.chooseTitle' => 'Aggiornamenti disponibili',
			'common.update.targetApp' => 'Questa app',
			'common.update.targetWeb' => 'Interfaccia web',
			'common.update.targetServer' => 'Server',
			'common.update.updateApp' => 'Aggiorna app',
			'common.update.updateWeb' => 'Aggiorna interfaccia web',
			'common.update.updateServer' => 'Aggiorna server',
			'common.update.webConfirm' => ({required Object version}) => 'Aggiornare l\'interfaccia web a v${version}? La pagina verrà ricaricata.',
			'common.update.webDone' => ({required Object version}) => 'Interfaccia web aggiornata a v${version} — ricaricamento…',
			'common.update.localServerConfirm' => ({required Object version}) => 'Aggiornare il server locale di questo dispositivo a v${version}? Le sessioni attive verranno interrotte.',
			'common.update.localServerUpdating' => 'Download e avvio del server locale…',
			'common.update.serverDone' => ({required Object version}) => 'Il server esegue v${version}.',
			'common.update.staged' => ({required Object version}) => 'Aggiornamento v${version} scaricato — riavvia il server per installarlo.',
			'common.update.upToDate' => 'Il server ha già l\'ultima release.',
			'common.update.webHostFailed' => ({required Object message}) => 'Il server è stato aggiornato, ma la sua interfaccia web no: ${message}',
			'settings.title' => 'Impostazioni',
			'settings.changelog.title' => 'Registro delle modifiche',
			'settings.changelog.loading' => 'Caricamento…',
			'settings.changelog.empty' => 'Nessuna versione da mostrare',
			'settings.changelog.current' => 'attuale',
			'settings.changelog.kNew' => 'nuova',
			'settings.server.title' => 'Server',
			'settings.server.description' => 'Riavvia il processo DDAgent — utile dopo un aggiornamento o in caso di blocco.',
			'settings.server.restart' => 'Riavvia',
			'settings.server.restartConfirm' => 'Riavviare il server DDAgent? Le sessioni attive verranno interrotte.',
			'settings.server.restarting' => 'Riavvio in corso… la pagina si ricaricherà quando il server torna.',
			'settings.server.restartFailed' => 'Riavvio non riuscito',
			'settings.server.unsupported' => 'Il riavvio è disponibile solo quando il server è gestito dal service manager.',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'Riavvio del server',
			'settings.server.restartRequesting' => 'Richiesta di riavvio inviata al server…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'In attesa che il server torni disponibile… (${seconds} s)',
			'settings.server.restartBack' => ({required Object version}) => 'Il server è di nuovo attivo — versione ${version}.',
			'settings.server.restartReloading' => 'Ricaricamento della pagina…',
			'settings.server.restartTimeout' => ({required Object seconds}) => 'Il server non è tornato entro ${seconds} s. Controlla il log del servizio (/tmp/ddagent.log) o riavvialo manualmente.',
			'settings.updates.title' => 'Aggiornamenti',
			'settings.updates.description' => 'Controlla su GitHub una build desktop più recente. Le nuove versioni si scaricano automaticamente e si installano all\'uscita.',
			'settings.updates.check' => 'Controlla aggiornamenti',
			'settings.updates.checking' => 'Controllo in corso…',
			'settings.updates.upToDate' => ({required Object version}) => 'Hai la versione più recente (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Trovato aggiornamento v${version} — download in background; si installerà alla chiusura di DDAgent.',
			'settings.updates.downloaded' => ({required Object version}) => 'Aggiornamento v${version} scaricato — chiudi e riavvia DDAgent per installarlo.',
			'settings.updates.unavailable' => 'Il controllo degli aggiornamenti è disponibile solo nelle build desktop pacchettizzate.',
			'settings.updates.error' => ({required Object message}) => 'Controllo aggiornamenti non riuscito: ${message}',
			'settings.updates.errorGeneric' => 'Controllo aggiornamenti non riuscito.',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · ultima v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — aggiornata',
			'settings.updates.webNotHosted' => ({required Object version}) => 'Questa interfaccia web è ospitata separatamente: sostituisci i suoi file con ddagent-flutter-web-v${version}.zip della release.',
			'settings.updates.serverCannotUpdate' => 'Questo server non può aggiornarsi da qui: reinstallalo con install.sh o con un tarball della release.',
			'settings.tabs.account' => 'Account',
			'settings.tabs.permissions' => 'Permessi',
			'settings.tabs.mcpServers' => 'Server MCP',
			'settings.tabs.appearance' => 'Aspetto',
			'settings.tabs.skills' => 'Skill',
			'settings.account.title' => 'Account',
			'settings.account.language' => 'Lingua',
			'settings.account.languageLabel' => 'Lingua dell\'interfaccia',
			'settings.account.languageDescription' => 'Scegli la lingua preferita per l\'interfaccia',
			'settings.account.username' => 'Nome utente',
			'settings.account.email' => 'Email',
			'settings.account.profile' => 'Profilo',
			'settings.account.changePassword' => 'Cambia password',
			'settings.mcp.title' => 'Server MCP',
			'settings.mcp.addServer' => 'Aggiungi server',
			'settings.mcp.editServer' => 'Modifica server',
			'settings.mcp.deleteServer' => 'Elimina server',
			'settings.mcp.serverName' => 'Nome server',
			'settings.mcp.serverType' => 'Tipo server',
			'settings.mcp.config' => 'Configurazione',
			'settings.mcp.testConnection' => 'Testa connessione',
			'settings.mcp.status' => 'Stato',
			'settings.mcp.connected' => 'Connesso',
			'settings.mcp.disconnected' => 'Disconnesso',
			'settings.mcp.scope.label' => 'Ambito',
			'settings.mcp.scope.user' => 'Utente',
			'settings.mcp.scope.project' => 'Progetto',
			'settings.appearance.title' => 'Aspetto',
			'settings.appearance.theme' => 'Tema',
			'settings.appearance.codeEditor' => 'Editor codice',
			'settings.appearance.editorTheme' => 'Tema editor',
			'settings.appearance.wordWrap' => 'A capo automatico',
			'settings.appearance.showMinimap' => 'Mostra minimappa',
			'settings.appearance.lineNumbers' => 'Numeri di riga',
			'settings.appearance.fontSize' => 'Dimensione carattere',
			'settings.appearance.themeModes.dark' => 'Scuro',
			'settings.appearance.themeModes.light' => 'Chiaro',
			'settings.appearance.themeModes.system' => 'Sistema',
			'settings.actions.saveChanges' => 'Salva modifiche',
			'settings.actions.resetToDefaults' => 'Ripristina predefiniti',
			'settings.actions.cancelChanges' => 'Annulla modifiche',
			'settings.quickSettings.title' => 'Impostazioni rapide',
			'settings.quickSettings.sections.appearance' => 'Aspetto',
			'settings.quickSettings.sections.toolDisplay' => 'Visualizzazione strumenti',
			'settings.quickSettings.sections.inputSettings' => 'Impostazioni input',
			'settings.quickSettings.darkMode' => 'Modalità scura',
			'settings.quickSettings.showRawParameters' => 'Mostra parametri grezzi',
			'settings.quickSettings.showThinking' => 'Mostra ragionamento',
			'settings.quickSettings.sendByCtrlEnter' => 'Invia con Ctrl+Invio',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Se abilitato, premere Ctrl+Invio invierà il messaggio invece di Invio. Utile per gli utenti IME per evitare invii accidentali.',
			'settings.quickSettings.dragHandle.dragging' => 'Trascinamento maniglia',
			'settings.quickSettings.dragHandle.closePanel' => 'Chiudi pannello impostazioni',
			'settings.quickSettings.dragHandle.openPanel' => 'Apri pannello impostazioni',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Trascinamento...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Clicca per attivare/disattivare, trascina per spostare',
			'settings.quickSettings.sendWithCtrlEnter' => 'Invia con Ctrl+Invio',
			'settings.terminalShortcuts.title' => 'Scorciatoie terminale',
			'settings.terminalShortcuts.sectionKeys' => 'Tasti',
			'settings.terminalShortcuts.sectionNavigation' => 'Navigazione',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Freccia su',
			'settings.terminalShortcuts.arrowDown' => 'Freccia giù',
			'settings.terminalShortcuts.scrollDown' => 'Scorri giù',
			'settings.terminalShortcuts.handle.closePanel' => 'Chiudi pannello scorciatoie',
			'settings.terminalShortcuts.handle.openPanel' => 'Apri pannello scorciatoie',
			'settings.terminalShortcuts.killTitle' => 'Termina processo in esecuzione (Ctrl+C)',
			'settings.terminalShortcuts.paste' => 'Incolla',
			'settings.mainTabs.label' => 'Impostazioni',
			'settings.mainTabs.agents' => 'Agenti',
			'settings.mainTabs.orchestration' => 'Orchestrazione',
			'settings.mainTabs.appearance' => 'Aspetto',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API e Token',
			'settings.mainTabs.models' => 'Modelli',
			'settings.mainTabs.tasks' => 'Attività',
			'settings.mainTabs.notifications' => 'Notifiche',
			'settings.mainTabs.about' => 'Informazioni',
			'settings.mainTabs.workspaces' => 'Workspace',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Strumenti',
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
			'settings.orchestration.pool.fields.redundantAccounts' => 'Account ridondanti',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Nessun altro account per questo provider',
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
			'settings.notifications.title' => 'Notifiche',
			'settings.notifications.description' => 'Controlla quali notifiche ricevere.',
			'settings.notifications.webPush.title' => 'Notifiche push web',
			'settings.notifications.webPush.enable' => 'Abilita notifiche push',
			'settings.notifications.webPush.disable' => 'Disabilita notifiche push',
			'settings.notifications.webPush.enabled' => 'Le notifiche push sono abilitate',
			'settings.notifications.webPush.loading' => 'Aggiornamento...',
			'settings.notifications.webPush.unsupported' => 'Le notifiche push non sono supportate in questo browser.',
			'settings.notifications.webPush.denied' => 'Le notifiche push sono bloccate. Abilitale nelle impostazioni del browser.',
			'settings.notifications.webPush.iosHint' => 'Su iPhone/iPad le notifiche funzionano solo dopo aver aggiunto DDAgent alla schermata Home (Condividi → Aggiungi a Home) e averle attivate dall’app installata.',
			'settings.notifications.webPush.test' => 'Invia notifica di prova',
			'settings.notifications.webPush.testNoSubscription' => 'Nessun dispositivo iscritto. Tocca prima «Abilita» sul telefono.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Inviato a ${count} dispositivi. Se non appare nulla sul telefono, aggiungi DDAgent alla schermata Home (richiesto da iOS).',
			'settings.notifications.webPush.testNotDelivered' => 'Nessun dispositivo era raggiungibile. Assicurati che l\'app sia in esecuzione e che le notifiche siano attive.',
			'settings.notifications.device.title' => 'Notifica questo dispositivo',
			'settings.notifications.device.enabled' => 'Le notifiche sono attive per questo dispositivo',
			'settings.notifications.sound.title' => 'Suono',
			'settings.notifications.sound.description' => 'Riproduci un breve tono quando termina un\'esecuzione della chat.',
			'settings.notifications.sound.enabled' => 'Attivato',
			'settings.notifications.sound.test' => 'Prova suono',
			'settings.notifications.events.title' => 'Tipi di evento',
			'settings.notifications.events.actionRequired' => 'Azione richiesta',
			'settings.notifications.events.stop' => 'Esecuzione interrotta',
			'settings.notifications.events.error' => 'Esecuzione fallita',
			'settings.notifications.desktop.title' => 'Notifica questa app desktop',
			'settings.notifications.desktop.enable' => 'Abilita notifiche push',
			'settings.notifications.desktop.disable' => 'Disabilita notifiche push',
			'settings.notifications.desktop.enabled' => 'Le notifiche sono attivate per questa app desktop',
			'settings.notifications.desktop.unsupported' => 'Le notifiche desktop non sono supportate su questo sistema.',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.unpair' => 'Dissocia',
			'settings.appearanceSettings.darkMode.label' => 'Modalità scura',
			'settings.appearanceSettings.darkMode.description' => 'Alterna tra tema chiaro e scuro',
			'settings.appearanceSettings.codeEditor.title' => 'Editor codice',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Tema editor',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Tema predefinito per l\'editor di codice',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'A capo automatico',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Abilita il ritorno a capo automatico nell\'editor',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Mostra minimappa',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Visualizza una minimappa per facilitare la navigazione nella vista differenze',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Mostra numeri di riga',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Visualizza i numeri di riga nell\'editor',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Dimensione carattere',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Dimensione del carattere dell\'editor in pixel',
			'settings.appearanceSettings.terminal.title' => 'Terminale',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Il focus segue il puntatore',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Dai il focus al terminale per la digitazione quando muovi il mouse sopra di esso',
			'settings.mcpForm.title.add' => 'Aggiungi server MCP',
			'settings.mcpForm.title.edit' => 'Modifica server MCP',
			'settings.mcpForm.importMode.form' => 'Input modulo',
			'settings.mcpForm.importMode.json' => 'Importa JSON',
			'settings.mcpForm.scope.label' => 'Ambito',
			'settings.mcpForm.scope.userGlobal' => 'Utente (globale)',
			'settings.mcpForm.scope.projectLocal' => 'Progetto (locale)',
			'settings.mcpForm.scope.userDescription' => 'Ambito utente: disponibile in tutti i progetti sulla tua macchina',
			'settings.mcpForm.scope.projectDescription' => 'Ambito locale: disponibile solo nel progetto selezionato',
			'settings.mcpForm.scope.cannotChange' => 'L\'ambito non può essere modificato quando si modifica un server esistente',
			'settings.mcpForm.fields.serverName' => 'Nome server',
			'settings.mcpForm.fields.transportType' => 'Tipo di trasporto',
			'settings.mcpForm.fields.command' => 'Comando',
			'settings.mcpForm.fields.arguments' => 'Argomenti (uno per riga)',
			'settings.mcpForm.fields.jsonConfig' => 'Configurazione JSON',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Variabili d\'ambiente (CHIAVE=valore, una per riga)',
			'settings.mcpForm.fields.headers' => 'Header (CHIAVE=valore, uno per riga)',
			'settings.mcpForm.fields.selectProject' => 'Seleziona un progetto...',
			'settings.mcpForm.placeholders.serverName' => 'mio-server',
			'settings.mcpForm.validation.missingType' => 'Campo obbligatorio mancante: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'Il tipo stdio richiede un campo command',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => 'Il tipo ${type} richiede un campo url',
			'settings.mcpForm.validation.invalidJson' => 'Formato JSON non valido',
			'settings.mcpForm.validation.jsonHelp' => 'Incolla la configurazione del server MCP in formato JSON. Esempi di formato:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Dettagli configurazione (da ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Percorso: ${path}',
			'settings.mcpForm.actions.cancel' => 'Annulla',
			'settings.mcpForm.actions.saving' => 'Salvataggio...',
			'settings.mcpForm.actions.addServer' => 'Aggiungi server',
			'settings.mcpForm.actions.updateServer' => 'Aggiorna server',
			'settings.saveStatus.success' => 'Impostazioni salvate con successo!',
			'settings.saveStatus.error' => 'Impossibile salvare le impostazioni',
			'settings.saveStatus.saving' => 'Salvataggio...',
			'settings.footerActions.save' => 'Salva impostazioni',
			'settings.footerActions.cancel' => 'Annulla',
			'settings.git.title' => 'Configurazione Git',
			'settings.git.description' => 'Configura la tua identità git per i commit. Queste impostazioni verranno applicate globalmente tramite git config --global',
			'settings.git.name.label' => 'Nome Git',
			'settings.git.name.help' => 'Il tuo nome per i commit git',
			'settings.git.name.placeholder' => 'Mario Rossi',
			'settings.git.email.label' => 'Email Git',
			'settings.git.email.help' => 'La tua email per i commit git',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Salva configurazione',
			'settings.git.actions.saving' => 'Salvataggio...',
			'settings.git.status.success' => 'Salvato con successo',
			'settings.git.status.error' => 'Salvataggio non riuscito',
			'settings.apiKeys.title' => 'Chiavi API',
			'settings.apiKeys.description' => 'Genera chiavi API per accedere all\'API esterna da altre applicazioni.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ Salva la tua chiave API',
			'settings.apiKeys.newKey.alertMessage' => 'Questa è l\'unica volta che vedrai questa chiave. Conservala in modo sicuro.',
			'settings.apiKeys.newKey.iveSavedIt' => 'L\'ho salvata',
			'settings.apiKeys.form.placeholder' => 'Nome chiave API (es. Server produzione)',
			'settings.apiKeys.form.createButton' => 'Crea',
			'settings.apiKeys.form.cancelButton' => 'Annulla',
			'settings.apiKeys.newButton' => 'Nuova chiave API',
			'settings.apiKeys.empty' => 'Nessuna chiave API creata.',
			'settings.apiKeys.list.created' => 'Creata:',
			'settings.apiKeys.list.lastUsed' => 'Ultimo utilizzo:',
			'settings.apiKeys.confirmDelete' => 'Sei sicuro di voler eliminare questa chiave API?',
			'settings.apiKeys.status.active' => 'Attiva',
			'settings.apiKeys.status.inactive' => 'Inattiva',
			'settings.apiKeys.github.title' => 'Token GitHub',
			'settings.apiKeys.github.description' => 'Aggiungi token di accesso personale GitHub per clonare repository privati tramite l\'API esterna.',
			'settings.apiKeys.github.descriptionAlt' => 'Aggiungi token di accesso personale GitHub per clonare repository privati. Puoi anche passare i token direttamente nelle richieste API senza salvarli.',
			'settings.apiKeys.github.addButton' => 'Aggiungi token',
			'settings.apiKeys.github.form.namePlaceholder' => 'Nome token (es. Repository personali)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'Token di accesso personale GitHub (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Descrizione (opzionale)',
			'settings.apiKeys.github.form.addButton' => 'Aggiungi token',
			'settings.apiKeys.github.form.cancelButton' => 'Annulla',
			'settings.apiKeys.github.form.howToCreate' => 'Come creare un token di accesso personale GitHub →',
			'settings.apiKeys.github.form.showToken' => 'Mostra token',
			'settings.apiKeys.github.form.hideToken' => 'Nascondi token',
			'settings.apiKeys.github.empty' => 'Nessun token GitHub aggiunto.',
			'settings.apiKeys.github.added' => 'Aggiunto:',
			'settings.apiKeys.github.confirmDelete' => 'Sei sicuro di voler eliminare questo token GitHub?',
			'settings.apiKeys.apiDocsLink' => 'Documentazione API',
			'settings.apiKeys.documentation.title' => 'Documentazione API esterna',
			'settings.apiKeys.documentation.description' => 'Scopri come usare l\'API esterna per avviare sessioni Claude/Cursor dalle tue applicazioni.',
			'settings.apiKeys.documentation.viewLink' => 'Vedi documentazione API →',
			'settings.apiKeys.loading' => 'Caricamento...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Aggiornamento disponibile: v${version}',
			'settings.tasks.checking' => 'Verifica installazione TaskMaster...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI non installato',
			'settings.tasks.notInstalled.description' => 'TaskMaster CLI è necessario per usare le funzionalità di gestione attività. Installalo per iniziare:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'Vedi su GitHub',
			'settings.tasks.notInstalled.afterInstallation' => 'Dopo l\'installazione:',
			'settings.tasks.notInstalled.steps.restart' => 'Riavvia questa applicazione',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'Le funzionalità TaskMaster saranno automaticamente disponibili',
			'settings.tasks.notInstalled.steps.initCommand' => 'Usa task-master init nella directory del tuo progetto',
			'settings.tasks.settings.enableLabel' => 'Abilita integrazione TaskMaster',
			'settings.tasks.settings.enableDescription' => 'Mostra attività TaskMaster, banner e indicatori nella barra laterale nell\'interfaccia',
			'settings.agents.authStatus.checking' => 'Verifica...',
			'settings.agents.authStatus.connected' => 'Connesso',
			'settings.agents.authStatus.notConnected' => 'Non connesso',
			'settings.agents.authStatus.disconnected' => 'Disconnesso',
			'settings.agents.authStatus.checkingAuth' => 'Verifica stato autenticazione...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Connesso come ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => 'Account ${provider}',
			'settings.agents.authStatus.authenticatedUser' => 'utente autenticato',
			'settings.agents.install.title' => ({required Object agent}) => 'La CLI ${agent} non è installata',
			'settings.agents.install.description' => ({required Object agent}) => 'Installa la CLI ${agent} per accedere ed eseguire sessioni.',
			'settings.agents.install.button' => 'Installa',
			'settings.agents.install.installing' => 'Installazione…',
			'settings.agents.install.copyCommand' => 'Copia comando',
			'settings.agents.install.docs' => 'Documentazione',
			'settings.agents.install.success' => ({required Object agent}) => 'CLI ${agent} installata',
			'settings.agents.install.failed' => 'Installazione non riuscita — controlla l\'output del terminale',
			'settings.agents.update.title' => 'Aggiorna CLI',
			'settings.agents.update.description' => ({required Object agent}) => 'Installa l\'ultima versione della CLI ${agent} sull\'host del server.',
			'settings.agents.update.button' => 'Aggiorna',
			'settings.agents.update.updating' => 'Aggiornamento…',
			'settings.agents.update.success' => ({required Object agent}) => 'CLI ${agent} aggiornata',
			'settings.agents.update.failed' => 'Aggiornamento non riuscito — controlla l\'output del terminale',
			'settings.agents.account.claude.description' => 'Assistente AI Anthropic Claude',
			'settings.agents.account.cursor.description' => 'Editor di codice potenziato da AI Cursor',
			'settings.agents.account.codex.description' => 'Assistente AI OpenAI Codex',
			'settings.agents.account.opencode.description' => 'Assistente CLI OpenCode',
			'settings.agents.account.commandcode.description' => 'Assistente CLI Command Code',
			_ => null,
		} ?? switch (path) {
			'settings.agents.account.antigravity.description' => 'Assistente CLI Antigravity',
			'settings.agents.account.devin.description' => 'Assistente CLI Devin',
			'settings.agents.connectionStatus' => 'Stato connessione',
			'settings.agents.login.title' => 'Accedi',
			'settings.agents.login.reAuthenticate' => 'Ri-autenticati',
			'settings.agents.login.description' => ({required Object agent}) => 'Accedi al tuo account ${agent} per abilitare le funzionalità AI',
			'settings.agents.login.reAuthDescription' => 'Accedi con un account diverso o aggiorna le credenziali',
			'settings.agents.login.button' => 'Accedi',
			'settings.agents.login.reLoginButton' => 'Ri-accedi',
			'settings.agents.logout.title' => 'Disconnetti',
			'settings.agents.logout.description' => 'Disconnetti da questo provider e cancella le credenziali salvate',
			'settings.agents.logout.button' => 'Disconnetti',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => 'Disconnettersi da ${agent}?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Questa operazione rimuove le credenziali ${agent} salvate sul server. Accedi di nuovo per continuare a usare ${agent}.',
			'settings.agents.logout.success' => 'Disconnesso',
			'settings.agents.logout.failed' => 'Disconnessione non riuscita',
			'settings.agents.error' => ({required Object error}) => 'Errore: ${error}',
			'settings.permissions.title' => 'Impostazioni permessi',
			'settings.permissions.permissionMode.title' => 'Modalità permessi',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Modalità di permesso predefinita per le nuove sessioni ${provider}. Puoi comunque sovrascriverla per una singola sessione.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Predefinito',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Le azioni che richiedono un permesso ti vengono mostrate per approvazione nella chat.',
			'settings.permissions.permissionMode.modes.auto.title' => 'Modalità automatica',
			'settings.permissions.permissionMode.modes.auto.description' => 'Un classificatore di modello decide per ogni chiamata se approvare o negare. Alta autonomia.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Accetta modifiche',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Le modifiche ai file sono approvate automaticamente; le altre azioni chiedono ancora la tua approvazione.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Ignora permessi',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Ogni azione è approvata automaticamente — accesso completo senza richieste. Usa con cautela.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Piano',
			'settings.permissions.permissionMode.modes.plan.description' => 'Modalità pianificazione: l’agente esplora e pianifica senza eseguire comandi.',
			'settings.mcpServers.title' => 'Server MCP',
			'settings.mcpServers.description.claude' => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a Claude',
			'settings.mcpServers.description.cursor' => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a Cursor',
			'settings.mcpServers.description.codex' => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a Codex',
			'settings.mcpServers.description.opencode' => 'I server Model Context Protocol forniscono a OpenCode strumenti e fonti dati aggiuntivi',
			'settings.mcpServers.description.commandcode' => 'I server Model Context Protocol forniscono a Command Code strumenti e fonti dati aggiuntivi',
			'settings.mcpServers.description.antigravity' => 'I server Model Context Protocol forniscono a Antigravity strumenti e fonti dati aggiuntivi',
			'settings.mcpServers.description.devin' => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntivi a Devin',
			'settings.mcpServers.addButton' => 'Aggiungi server MCP',
			'settings.mcpServers.empty' => 'Nessun server MCP configurato',
			'settings.mcpServers.serverType' => 'Tipo',
			'settings.mcpServers.scope.local' => 'locale',
			'settings.mcpServers.scope.user' => 'utente',
			'settings.mcpServers.config.command' => 'Comando',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Argomenti',
			'settings.mcpServers.config.environment' => 'Ambiente',
			'settings.mcpServers.tools.title' => 'Strumenti',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} altri',
			'settings.mcpServers.actions.edit' => 'Modifica server',
			'settings.mcpServers.actions.delete' => 'Elimina server',
			'settings.mcpServers.help.title' => 'Informazioni su Codex MCP',
			'settings.mcpServers.help.description' => 'Codex supporta server MCP basati su stdio. Puoi aggiungere server che estendono le capacità di Codex con strumenti e risorse aggiuntive.',
			'settings.mcpServers.managed.badge' => 'Gestito',
			'settings.mcpServers.managed.hint' => 'Gestito da DDAgent.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '«${serverName}» verrà rimosso dalla configurazione del provider.',
			'settings.mcpServers.deleteConfirm.title' => 'Eliminare il server MCP?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => 'Soglie di avviso, politica di routing e account interrogati per le quote.',
			'settings.quota.settings.saved' => 'Salvato',
			'settings.quota.settings.alertsSection' => 'Avvisi',
			'settings.quota.settings.alertsSectionHint' => 'Avvisa prima che un limite sia effettivamente esaurito, non solo al 100%.',
			'settings.quota.settings.alertsEnabled' => 'Avvisi di limite previsto',
			'settings.quota.settings.alertsEnabledHint' => 'Mostra proiezioni basate sul ritmo nella panoramica e nelle schede account.',
			'settings.quota.settings.watchThreshold' => 'Soglia di osservazione (%)',
			'settings.quota.settings.watchThresholdHint' => 'Gli account pari o superiori a questa lettura sono contati come a rischio.',
			'settings.quota.settings.dangerThreshold' => 'Soglia di pericolo (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Le letture pari o superiori a questo valore sono mostrate in rosso.',
			'settings.quota.settings.routingSection' => 'Routing',
			'settings.quota.settings.routingSectionHint' => 'Come il pannello può spostare il lavoro sull’account con più margine.',
			'settings.quota.settings.routing.manual' => 'Manuale',
			'settings.quota.settings.routing.manualHint' => 'Mostra solo una raccomandazione; non cambiare mai account automaticamente.',
			'settings.quota.settings.routing.ask' => 'Chiedi prima di cambiare',
			'settings.quota.settings.routing.askHint' => 'Un cambio viene proposto e attende la tua approvazione.',
			'settings.quota.settings.routing.autoLowRisk' => 'Automatico per attività a basso rischio',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Solo le attività marcate a basso rischio possono essere spostate automaticamente.',
			'settings.quota.settings.routingNote' => 'Cambiare account altera costo e qualità del modello, quindi richiede sempre una decisione esplicita.',
			'settings.quota.settings.accountsSection' => 'Account interrogati',
			'settings.quota.settings.accountsSectionHint' => 'Le credenziali sono lette da ogni strumento; il pannello non le invia da nessun’altra parte.',
			'settings.quota.settings.sourcesSection' => 'Fonti di dati',
			'settings.quota.settings.sourcesSectionHint' => 'Da dove provengono le cifre di utilizzo e costo.',
			'settings.quota.settings.logSources' => 'Archivio log di token e costi',
			'settings.quota.settings.logSourcesHint' => 'Archivio aggregato in sola lettura condiviso con il collector tokboard.',
			'settings.quota.settings.readOnly' => 'Sola lettura',
			'settings.quota.settings.quotaConsent' => 'Polling delle quote',
			'settings.quota.settings.quotaConsentHint' => 'Legge gli endpoint di quota dei provider con credenziali salvate localmente.',
			'settings.quota.settings.localOnly' => 'Solo locale',
			'settings.quota.empty.description' => 'Nessun account rilevato ancora.',
			'settings.quota.quality.cached' => 'in cache',
			'settings.quota.quality.error' => 'errore',
			'settings.quota.quality.estimate' => 'stima',
			'settings.quota.quality.live' => 'live',
			'settings.quota.quality.unknown' => 'sconosciuto',
			'settings.quota.syncFailed' => 'Sincronizzazione non riuscita',
			'settings.quota.syncNow' => 'Sincronizza ora',
			'settings.browser.checking' => 'controllo...',
			'settings.browser.description' => 'Consenti agli agenti di creare sessioni browser Playwright monitorate, visibili nella scheda Browser.',
			'settings.browser.enableDescription' => 'Registra Browser per gli agenti supportati. Gli agenti possono creare sessioni browser; puoi guardarle, interromperle ed eliminarle.',
			'settings.browser.enableLabel' => 'Abilita Browser',
			'settings.browser.errors.installRuntime' => 'Impossibile installare il runtime del browser',
			'settings.browser.errors.loadSettings' => 'Impossibile caricare le impostazioni di Browser',
			'settings.browser.errors.loadStatus' => 'Impossibile caricare lo stato di Browser',
			'settings.browser.errors.saveSettings' => 'Impossibile salvare le impostazioni di Browser',
			'settings.browser.installHint' => 'Installa il runtime del browser prima che gli agenti possano creare sessioni Browser.',
			'settings.browser.installRuntime' => 'Installa runtime',
			'settings.browser.installed' => 'installato',
			'settings.browser.installing' => 'Installazione...',
			'settings.browser.missing' => 'mancante',
			'settings.browser.runtimeRequired' => 'Runtime del browser richiesto',
			'settings.browser.statusDisabled' => 'disabilitato',
			'settings.browser.statusLabel' => 'Stato',
			'settings.browser.statusReady' => 'pronto',
			'settings.browser.statusSetupRequired' => 'configurazione richiesta',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Annulla',
			'settings.workspaces.create' => 'Aggiungi workspace',
			'settings.workspaces.deleteConfirm' => 'Rimuovere questo workspace da DDAgent? I suoi file restano sul disco.',
			'settings.workspaces.deleteFailed' => 'Impossibile rimuovere il workspace.',
			'settings.workspaces.deleteTitle' => 'Rimuovi workspace',
			'settings.workspaces.description' => 'I workspace sono directory in cui DDAgent può chattare, eseguire codice e navigare.',
			'settings.workspaces.remove' => 'Rimuovi workspace',
			'settings.workspaces.title' => 'Workspace',
			'settings.workspaces.pathRequired' => 'Il percorso è obbligatorio',
			'settings.about.supportTitle' => 'Sostieni il progetto',
			'settings.about.buyMeACoffee' => 'Offrimi un caffè',
			'settings.about.learnMore' => 'Scopri di più',
			'settings.about.pro.syncSettings' => 'Sincronizza impostazioni',
			'settings.about.pro.teamManagement' => 'Gestione del team',
			'settings.about.proFeatures' => 'Funzionalità DDAgent Pro',
			'settings.about.tryHosted' => 'Prova DDAgent Hosted',
			'settings.about.versionInfo' => 'Informazioni sulla versione',
			'settings.about.client' => 'App',
			'settings.about.server' => 'Server',
			'settings.about.platformMobile' => 'Mobile',
			'settings.about.platformDesktop' => 'Desktop',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'sconosciuta',
			'sidebar.projects.title' => 'Progetti',
			'sidebar.projects.newProject' => 'Nuovo progetto',
			'sidebar.projects.deleteProject' => 'Rimuovi progetto',
			'sidebar.projects.renameProject' => 'Rinomina progetto',
			'sidebar.projects.noProjects' => 'Nessun progetto trovato',
			'sidebar.projects.loadingProjects' => 'Caricamento progetti...',
			'sidebar.projects.searchPlaceholder' => 'Cerca progetti...',
			'sidebar.projects.projectNamePlaceholder' => 'Nome progetto',
			'sidebar.projects.starred' => 'Preferiti',
			'sidebar.projects.all' => 'Tutti',
			'sidebar.projects.untitledSession' => 'Sessione senza titolo',
			'sidebar.projects.newSession' => 'Nuova sessione',
			'sidebar.projects.codexSession' => 'Sessione Codex',
			'sidebar.projects.fetchingProjects' => 'Recupero dei tuoi progetti e sessioni Claude',
			'sidebar.projects.projects' => 'progetti',
			'sidebar.projects.noMatchingProjects' => 'Nessun progetto corrispondente',
			'sidebar.projects.tryDifferentSearch' => 'Prova a modificare il termine di ricerca',
			'sidebar.projects.runClaudeCli' => 'Esegui Claude CLI in una directory di progetto per iniziare',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'Interfaccia assistente di programmazione AI',
			'sidebar.sessions.title' => 'Sessioni',
			'sidebar.sessions.newSession' => 'Nuova sessione',
			'sidebar.sessions.deleteSession' => 'Elimina sessione',
			'sidebar.sessions.renameSession' => 'Rinomina sessione',
			'sidebar.sessions.noSessions' => 'Nessuna sessione',
			'sidebar.sessions.loadingSessions' => 'Caricamento sessioni...',
			'sidebar.sessions.unnamed' => 'Senza nome',
			'sidebar.sessions.loading' => 'Caricamento...',
			'sidebar.sessions.showMore' => 'Mostra più sessioni',
			'sidebar.sessions.selectMode' => 'Seleziona',
			'sidebar.sessions.selectAll' => 'Seleziona tutto',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Archivia (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Elimina (${count})',
			'sidebar.sessions.cancelSelection' => 'Annulla selezione',
			'sidebar.sessions.toggleSelection' => 'Attiva/disattiva selezione sessioni',
			'sidebar.sessions.selectionToolbar' => 'Azioni di selezione sessioni',
			'sidebar.sessions.options' => 'Opzioni sessione',
			'sidebar.sessions.pinSession' => 'Fissa sessione',
			'sidebar.sessions.unpinSession' => 'Rimuovi fissa sessione',
			'sidebar.sessions.pinned' => 'Sessione fissata',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} selezionata', other: '${count} selezionate', ), 
			'sidebar.tooltips.viewEnvironments' => 'Visualizza ambienti',
			'sidebar.tooltips.hideSidebar' => 'Nascondi barra laterale',
			'sidebar.tooltips.createProject' => 'Crea nuovo progetto',
			'sidebar.tooltips.refresh' => 'Aggiorna progetti e sessioni (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Rinomina progetto (F2)',
			'sidebar.tooltips.deleteProject' => 'Rimuovi progetto dalla barra laterale (Canc)',
			'sidebar.tooltips.addToFavorites' => 'Aggiungi ai preferiti',
			'sidebar.tooltips.removeFromFavorites' => 'Rimuovi dai preferiti',
			'sidebar.tooltips.editSessionName' => 'Modifica manualmente il nome della sessione',
			'sidebar.tooltips.deleteSession' => 'Elimina questa sessione permanentemente',
			'sidebar.tooltips.activeSessionIndicator' => 'Sessione attiva di recente (ultimi 10 minuti)',
			'sidebar.tooltips.save' => 'Salva',
			'sidebar.tooltips.cancel' => 'Annulla',
			'sidebar.tooltips.clearSearch' => 'Cancella ricerca',
			'sidebar.tooltips.openCommandPalette' => 'Apri tavolozza comandi',
			'sidebar.tooltips.attentionRequiredIndicator' => 'La sessione richiede attenzione',
			'sidebar.tooltips.openSessions' => 'Sfoglia le sessioni',
			'sidebar.navigation.chat' => 'Chat',
			'sidebar.navigation.files' => 'File',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminale',
			'sidebar.navigation.tasks' => 'Attività',
			'sidebar.actions.refresh' => 'Aggiorna',
			'sidebar.actions.settings' => 'Impostazioni',
			'sidebar.actions.collapseAll' => 'Comprimi tutto',
			'sidebar.actions.expandAll' => 'Espandi tutto',
			'sidebar.actions.cancel' => 'Annulla',
			'sidebar.actions.save' => 'Salva',
			'sidebar.actions.delete' => 'Elimina',
			'sidebar.actions.rename' => 'Rinomina',
			'sidebar.actions.joinCommunity' => 'Unisciti alla community',
			'sidebar.actions.reportIssue' => 'Segnala problema',
			'sidebar.actions.starOnGithub' => 'Metti stella su GitHub',
			'sidebar.actions.buyMeACoffee' => 'Offrimi un caffè',
			'sidebar.branding.openSource' => 'Open Source',
			'sidebar.status.active' => 'Attivo',
			'sidebar.status.inactive' => 'Inattivo',
			'sidebar.status.thinking' => 'Sto pensando...',
			'sidebar.status.error' => 'Errore',
			'sidebar.status.aborted' => 'Interrotto',
			'sidebar.status.unknown' => 'Sconosciuto',
			'sidebar.time.justNow' => 'Adesso',
			'sidebar.time.oneMinuteAgo' => '1 min fa',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} min fa',
			'sidebar.time.oneHourAgo' => '1 ora fa',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} ore fa',
			'sidebar.time.oneDayAgo' => '1 giorno fa',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} giorni fa',
			'sidebar.messages.deleteConfirm' => 'Sei sicuro di voler eliminare questo elemento?',
			'sidebar.messages.renameSuccess' => 'Rinominato con successo',
			'sidebar.messages.deleteSuccess' => 'Eliminato con successo',
			'sidebar.messages.errorOccurred' => 'Si è verificato un errore',
			'sidebar.messages.deleteSessionConfirm' => 'Sei sicuro di voler eliminare questa sessione? Questa azione non può essere annullata.',
			'sidebar.messages.deleteProjectConfirm' => 'Rimuovere questo progetto dalla barra laterale? I file del progetto, le memorie e i dati delle sessioni non verranno eliminati.',
			'sidebar.messages.enterProjectPath' => 'Inserisci un percorso di progetto',
			'sidebar.messages.deleteSessionFailed' => 'Impossibile eliminare la sessione. Riprova.',
			'sidebar.messages.deleteSessionError' => 'Errore durante l\'eliminazione della sessione. Riprova.',
			'sidebar.messages.renameSessionFailed' => 'Impossibile rinominare la sessione. Riprova.',
			'sidebar.messages.renameSessionError' => 'Errore durante la rinomina della sessione. Riprova.',
			'sidebar.messages.deleteProjectFailed' => 'Impossibile rimuovere il progetto. Riprova.',
			'sidebar.messages.deleteProjectError' => 'Errore durante la rimozione del progetto. Riprova.',
			'sidebar.messages.createProjectFailed' => 'Impossibile creare il progetto. Riprova.',
			'sidebar.messages.createProjectError' => 'Errore durante la creazione del progetto. Riprova.',
			'sidebar.messages.updateProjectError' => 'Errore durante l\'aggiornamento del progetto. Riprova.',
			'sidebar.messages.refreshError' => 'Aggiornamento non riuscito. Riprova.',
			'sidebar.messages.restoreProjectFailed' => 'Impossibile ripristinare il progetto. Riprova.',
			'sidebar.messages.restoreProjectError' => 'Errore durante il ripristino del progetto. Riprova.',
			'sidebar.messages.restoreSessionFailed' => 'Impossibile ripristinare la sessione. Riprova.',
			'sidebar.messages.restoreSessionError' => 'Errore durante il ripristino della sessione. Riprova.',
			'sidebar.messages.changeWorkspaceFailed' => 'Cambio di spazio di lavoro non riuscito. Riprova.',
			'sidebar.messages.changeWorkspaceError' => 'Errore nel cambio di spazio di lavoro. Riprova.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Eliminazione di ${count} sessione non riuscita. Riprova.', other: 'Eliminazione di ${count} sessioni non riuscita. Riprova.', ), 
			'sidebar.version.updateAvailable' => 'Aggiornamento disponibile',
			'sidebar.version.restartRequired' => 'Aggiornamento installato — riavvia il server per applicarlo',
			'sidebar.version.updateNow' => 'Aggiorna ora',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Aggiornare DDAgent a v${version}? Verrà scaricato e compilato il codice più recente e il server verrà riavviato — le sessioni attive saranno interrotte.',
			'sidebar.version.updating' => 'Aggiornamento in corso… può richiedere alcuni minuti',
			'sidebar.version.restarting' => 'Aggiornamento installato — riavvio…',
			'sidebar.version.updateFailed' => 'Aggiornamento non riuscito',
			'sidebar.version.releaseNotes' => 'Note di rilascio',
			'sidebar.search.modeProjects' => 'Progetti',
			'sidebar.search.modeConversations' => 'Conversazioni',
			'sidebar.search.conversationsPlaceholder' => 'Cerca nelle conversazioni...',
			'sidebar.search.searching' => 'Ricerca in corso...',
			'sidebar.search.sessionTitles' => 'Titoli delle sessioni',
			'sidebar.search.conversationContents' => 'Contenuto delle conversazioni',
			'sidebar.search.noResults' => 'Nessun risultato trovato',
			'sidebar.search.tryDifferentQuery' => 'Prova con una ricerca diversa',
			'sidebar.search.modeRunning' => 'In esecuzione',
			'sidebar.search.archiveOnly' => 'Archivio',
			'sidebar.search.runningTooltip' => 'Sessioni in esecuzione',
			'sidebar.search.archiveOnlyTooltip' => 'Solo archivio',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} attive',
			'sidebar.search.viewMenu' => 'Vista',
			'sidebar.search.backToProjects' => 'Torna ai progetti',
			'sidebar.search.archivedPlaceholder' => 'Cerca sessioni archiviate...',
			'sidebar.search.runningPlaceholder' => 'Cerca sessioni in esecuzione...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} corrispondenza', other: '${count} corrispondenze', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} progetto analizzato', other: '${count} progetti analizzati', ), 
			'sidebar.deleteConfirmation.deleteProject' => 'Rimuovi progetto',
			'sidebar.deleteConfirmation.deleteSession' => 'Elimina sessione',
			'sidebar.deleteConfirmation.confirmDelete' => 'Cosa vuoi fare con',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Rimuovi solo dalla barra laterale',
			'sidebar.deleteConfirmation.deleteAllData' => 'Elimina tutti i dati permanentemente',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'Il progetto verrà rimosso dalla barra laterale. I tuoi file, memorie e dati delle sessioni verranno preservati.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Puoi riaggiungerlo in seguito.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'L’archiviazione nasconde le sessioni selezionate dall’elenco attivo preservandone le cronologie.',
			'sidebar.deleteConfirmation.archiveSession' => 'Archivia sessione',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'L’archiviazione tiene la sessione fuori dall’elenco attivo preservandone la cronologia.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Questa sessione è già archiviata. Puoi tenerla nascosta o eliminarla definitivamente.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'Questo rimuove definitivamente la sessione e la sua trascrizione. L’azione è irreversibile.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Elimina definitivamente',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Questo progetto contiene ${count} conversazione.', other: 'Questo progetto contiene ${count} conversazioni.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Gestisci sessione selezionata', other: 'Gestisci ${count} sessioni selezionate', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Archivia sessione', other: 'Archivia ${count} sessioni', ), 
			'sidebar.zones.activeNow' => 'Attivi ora',
			'sidebar.zones.recent' => 'Usati di recente',
			'sidebar.zones.today' => 'Oggi',
			'sidebar.zones.yesterday' => 'Ieri',
			'sidebar.zones.thisWeek' => 'Questa settimana',
			'sidebar.zones.showMore' => ({required Object count}) => 'Mostra altri ${count}',
			'sidebar.zones.showLess' => 'Mostra meno',
			'sidebar.panel.open' => 'Pannello',
			'sidebar.panel.newChat' => 'Nuova chat',
			'sidebar.panel.navigation' => 'Navigazione',
			'sidebar.panel.sessions' => 'Sessioni',
			'sidebar.workspace.title' => 'Cambia spazio di lavoro della sessione',
			'sidebar.workspace.description' => 'L’agente esegue i suoi prossimi turni in questa directory. La cronologia della sessione esistente è preservata.',
			'sidebar.workspace.pathLabel' => 'Percorso dello spazio di lavoro',
			'sidebar.workspace.pathRequired' => 'Il percorso dello spazio di lavoro è obbligatorio.',
			'sidebar.workspace.submit' => 'Cambia spazio di lavoro',
			'sidebar.workspace.saving' => 'Cambio in corso…',
			'sidebar.workspace.changeAction' => 'Cambia spazio di lavoro',
			'sidebar.recent.title' => 'Conversazioni recenti',
			'sidebar.recent.emptyTitle' => 'Ancora nessuna conversazione',
			'sidebar.recent.emptyDescription' => 'Le tue conversazioni aggiornate più di recente appariranno qui.',
			'sidebar.recent.loadFailed' => 'Impossibile caricare le conversazioni recenti',
			'sidebar.recent.loadMore' => 'Carica conversazioni precedenti',
			'sidebar.recent.loadingMore' => 'Caricamento...',
			'sidebar.tabs.board' => 'Bacheca agenti',
			'sidebar.tabs.files' => 'File',
			'sidebar.tabs.git' => 'Controllo del codice',
			'sidebar.tabs.tasks' => 'Attività',
			'sidebar.tabs.usage' => 'Quota e utilizzo',
			'tasks.notConfigured.title' => 'TaskMaster AI non è configurato',
			'tasks.notConfigured.description' => 'TaskMaster aiuta a suddividere progetti complessi in attività gestibili con assistenza AI',
			'tasks.notConfigured.whatIsTitle' => '🎯 Cos\'è TaskMaster?',
			'tasks.notConfigured.features.aiPowered' => 'Gestione attività AI: suddividi progetti complessi in sotto-attività gestibili',
			'tasks.notConfigured.features.prdTemplates' => 'Template PRD: genera attività da documenti di requisiti del prodotto',
			'tasks.notConfigured.features.dependencyTracking' => 'Tracciamento dipendenze: comprendi le relazioni tra attività e l\'ordine di esecuzione',
			'tasks.notConfigured.features.progressVisualization' => 'Visualizzazione progresso: board Kanban e analisi dettagliata delle attività',
			'tasks.notConfigured.features.cliIntegration' => 'Integrazione CLI: usa i comandi taskmaster per flussi di lavoro avanzati',
			'tasks.notConfigured.initializeButton' => 'Inizializza TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => 'Scrivi prima il PRD',
			'tasks.gettingStarted.title' => 'Inizia con TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster è inizializzato! Ecco cosa fare dopo:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Crea un documento di requisiti del prodotto (PRD)',
			'tasks.gettingStarted.steps.createPRD.description' => 'Discuti la tua idea di progetto e crea un PRD che descriva cosa vuoi costruire.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'Aggiungi PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'PRD esistenti:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Genera attività dal PRD',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Una volta che hai un PRD, chiedi al tuo assistente AI di analizzarlo e TaskMaster lo suddividerà automaticamente in attività gestibili con dettagli di implementazione.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Analizza ed espandi le attività',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Chiedi al tuo assistente AI di analizzare la complessità delle attività ed espanderle in sotto-attività dettagliate per un\'implementazione più semplice.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Inizia a costruire',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Chiedi al tuo assistente AI di iniziare a lavorare sulle attività, aggiornare il loro stato e aggiungere nuove attività man mano che il tuo progetto evolve.',
			'tasks.gettingStarted.tip' => '💡 Suggerimento: inizia con un PRD per ottenere il massimo dalla generazione di attività AI di TaskMaster',
			'tasks.setupModal.title' => 'Configurazione TaskMaster',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'CLI interattiva per ${projectName}',
			'tasks.setupModal.willStart' => 'L\'inizializzazione di TaskMaster partirà automaticamente',
			'tasks.setupModal.completed' => 'Configurazione TaskMaster completata! Ora puoi chiudere questa finestra.',
			'tasks.setupModal.closeButton' => 'Chiudi',
			'tasks.setupModal.closeContinueButton' => 'Chiudi e continua',
			'tasks.setupModal.closeTitle' => 'Chiudi',
			'tasks.setupModal.description' => 'Crea una cartella .taskmaster in questo progetto. Nessuno strumento esterno o chiave API richiesta — le attività sono salvate in locale.',
			'tasks.setupModal.initializeButton' => 'Inizializza',
			'tasks.setupModal.initializing' => 'Inizializzazione...',
			'tasks.helpGuide.title' => 'Inizia con TaskMaster',
			'tasks.helpGuide.subtitle' => 'La tua guida per una gestione produttiva delle attività',
			'tasks.helpGuide.examples.parsePRD' => '💬 Esempio:\n"Ho appena inizializzato un nuovo progetto con Claude Task Master. Ho un PRD in .taskmaster/docs/prd.txt. Puoi aiutarmi ad analizzarlo e configurare le attività iniziali?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Esempio:\n"L\'attività 5 sembra complessa. Puoi suddividerla in sotto-attività?"',
			'tasks.helpGuide.examples.addTask' => '💬 Esempio:\n"Per favore aggiungi una nuova attività per implementare il caricamento delle immagini profilo utente usando Cloudinary, ricerca l\'approccio migliore."',
			'tasks.helpGuide.moreExamples' => 'Vedi altri esempi e pattern di utilizzo →',
			'tasks.helpGuide.proTips.title' => '💡 Suggerimenti pro',
			'tasks.helpGuide.proTips.search' => 'Usa la barra di ricerca per trovare rapidamente attività specifiche',
			'tasks.helpGuide.proTips.views' => 'Passa tra le viste Kanban, Lista e Griglia usando i selettori di vista',
			'tasks.helpGuide.proTips.filters' => 'Usa i filtri per concentrarti su stati o priorità specifiche delle attività',
			'tasks.helpGuide.proTips.details' => 'Clicca su qualsiasi attività per vedere informazioni dettagliate e gestire le sotto-attività',
			'tasks.helpGuide.learnMore.title' => '📚 Per saperne di più',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI è un sistema avanzato di gestione attività pensato per sviluppatori. Trova documentazione, esempi e contribuisci al progetto.',
			'tasks.helpGuide.learnMore.githubButton' => 'Vedi su GitHub',
			'tasks.helpGuide.closeTitle' => 'Chiudi',
			'tasks.search.placeholder' => 'Cerca attività...',
			'tasks.filters.button' => 'Filtri',
			'tasks.filters.status' => 'Stato',
			'tasks.filters.priority' => 'Priorità',
			'tasks.filters.sortBy' => 'Ordina per',
			'tasks.filters.allStatuses' => 'Tutti gli stati',
			'tasks.filters.allPriorities' => 'Tutte le priorità',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => 'Visualizzate ${filtered} di ${total} attività',
			'tasks.filters.clearFilters' => 'Cancella filtri',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Stato',
			'tasks.sort.priority' => 'Priorità',
			'tasks.sort.idAsc' => 'ID (crescente)',
			'tasks.sort.idDesc' => 'ID (decrescente)',
			'tasks.sort.titleAsc' => 'Titolo (A-Z)',
			'tasks.sort.titleDesc' => 'Titolo (Z-A)',
			'tasks.sort.statusAsc' => 'Stato (in attesa prima)',
			'tasks.sort.statusDesc' => 'Stato (completati prima)',
			'tasks.sort.priorityAsc' => 'Priorità (alta prima)',
			'tasks.sort.priorityDesc' => 'Priorità (bassa prima)',
			'tasks.views.kanban' => 'Vista Kanban',
			'tasks.views.list' => 'Vista lista',
			'tasks.views.grid' => 'Vista griglia',
			'tasks.kanban.pending' => '📋 Da fare',
			'tasks.kanban.inProgress' => '🚀 In corso',
			'tasks.kanban.review' => '👀 Revisione',
			'tasks.kanban.done' => '✅ Completate',
			'tasks.kanban.blocked' => '🚫 Bloccate',
			'tasks.kanban.deferred' => '⏳ Rimandate',
			'tasks.kanban.cancelled' => '❌ Annullate',
			'tasks.kanban.noTasksYet' => 'Nessuna attività',
			'tasks.kanban.tasksWillAppear' => 'Le attività appariranno qui',
			'tasks.kanban.moveTasksHere' => 'Sposta le attività qui quando iniziate',
			'tasks.kanban.completedTasksHere' => 'Le attività completate appariranno qui',
			'tasks.kanban.statusTasksHere' => 'Le attività con questo stato appariranno qui',
			'tasks.buttons.help' => 'Guida introduttiva TaskMaster',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => 'Aggiungi PRD',
			'tasks.buttons.addTask' => 'Aggiungi attività',
			'tasks.buttons.createNewPRD' => 'Crea nuovo PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} PRD disponibili',
			'tasks.prd.modified' => ({required Object date}) => 'Modificato: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'Esiste già un PRD chiamato "${name}". Vuoi sovrascriverlo?',
			'tasks.prd.fileExistsTitle' => 'Il file esiste già',
			'tasks.prd.newFile' => 'nuovo file',
			'tasks.prd.parse' => 'Analizza PRD',
			'tasks.prd.template' => 'Template',
			'tasks.prd.fileNameHint' => 'nome file (es. prd.txt)',
			'tasks.prd.saved' => 'PRD salvato',
			'tasks.prd.tasksGenerated' => 'Attività generate dal PRD',
			'tasks.statuses.pending' => 'In attesa',
			'tasks.statuses.inProgress' => 'In corso',
			'tasks.statuses.done' => 'Completata',
			'tasks.statuses.blocked' => 'Bloccata',
			'tasks.statuses.deferred' => 'Rimandata',
			'tasks.statuses.cancelled' => 'Annullata',
			'tasks.statuses.review' => 'Revisione',
			'tasks.priorities.high' => 'Alta',
			'tasks.priorities.medium' => 'Media',
			'tasks.priorities.low' => 'Bassa',
			'tasks.noMatchingTasks.title' => 'Nessuna attività corrisponde ai filtri',
			'tasks.noMatchingTasks.description' => 'Prova a modificare la ricerca o i criteri di filtro.',
			'tasks.board.title' => 'Bacheca agenti',
			'tasks.board.subtitle' => 'Sposta una scheda in Pronta e l’agente la prende in carico. Clicca una scheda per aprire la sua sessione.',
			'tasks.board.newCard' => 'Nuova scheda',
			'tasks.board.addCard' => 'Aggiungi scheda',
			'tasks.board.refresh' => 'Aggiorna',
			'tasks.board.empty.title' => 'Ancora nessuna scheda',
			'tasks.board.empty.description' => 'Aggiungi una scheda, descrivi l’attività, poi trascinala in Pronta per far iniziare un agente.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Pronta per iniziare',
			'tasks.board.columns.working' => 'In lavorazione',
			'tasks.board.columns.needsDecision' => 'Richiede la tua decisione',
			'tasks.board.columns.done' => 'Completata',
			'tasks.board.columns.archived' => 'Archiviate',
			'tasks.board.card.running' => 'In esecuzione',
			'tasks.board.card.abort' => 'Interrompi',
			'tasks.board.card.delete' => 'Elimina',
			'tasks.board.card.openSession' => 'Apri sessione',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.dialog.createTitle' => 'Nuova scheda',
			'tasks.board.dialog.editTitle' => 'Modifica scheda',
			'tasks.board.dialog.titleLabel' => 'Titolo',
			'tasks.board.dialog.titlePlaceholder' => 'Cosa deve fare l’agente?',
			'tasks.board.dialog.descriptionLabel' => 'Descrizione',
			'tasks.board.dialog.descriptionPlaceholder' => 'Aggiungi contesto, criteri di accettazione, link...',
			'tasks.board.dialog.cancel' => 'Annulla',
			'tasks.board.dialog.save' => 'Salva',
			'tasks.board.noProject' => 'Aggiungi prima un progetto, poi crea le schede per esso.',
			'tasks.board.projectLabel' => 'Progetto',
			'tasks.board.backToChat' => 'Torna alla chat',
			'tasks.board.agent.provider' => 'Agente',
			'tasks.board.agent.anyProvider' => 'Qualsiasi agente',
			'tasks.board.agent.model' => 'Modello',
			'tasks.board.agent.defaultModel' => 'Modello predefinito',
			'tasks.board.agent.effort' => 'Ragionamento',
			'tasks.board.agent.defaultEffort' => 'Predefinito',
			'tasks.board.agent.searchModel' => 'Cerca modelli…',
			'tasks.board.agent.noModels' => 'Nessun modello corrispondente',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '«${cardTitle}» verrà eliminata definitivamente.',
			'tasks.board.deleteConfirm.title' => 'Eliminare la scheda?',
			'tasks.board.project' => 'Progetto',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Dipende da: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Attività ${id}',
			'tasks.card.highPriority' => 'Priorità alta',
			'tasks.card.lowPriority' => 'Priorità bassa',
			'tasks.card.mediumPriority' => 'Priorità media',
			'tasks.card.noPriority' => 'Nessuna priorità impostata',
			'tasks.card.parentTask' => ({required Object id}) => 'Attività ${id}',
			'tasks.card.progressLabel' => 'Avanzamento:',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => '${completed} di ${total} sottoattività completate',
			'tasks.card.runTask' => 'Esegui attività',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Esegui attività ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Stato: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'ID attività: ${id}',
			'tasks.card.taskInProgress' => 'Attività in corso',
			'tasks.createTask.cancel' => 'Annulla',
			'tasks.createTask.descriptionLabel' => 'Descrizione',
			'tasks.createTask.descriptionPlaceholder' => 'Dettagli opzionali',
			'tasks.createTask.error' => 'Impossibile aggiungere l’attività',
			'tasks.createTask.priorityLabel' => 'Priorità',
			'tasks.createTask.submit' => 'Aggiungi attività',
			'tasks.createTask.submitting' => 'Aggiunta...',
			'tasks.createTask.title' => 'Aggiungi attività',
			'tasks.createTask.titleLabel' => 'Titolo',
			'tasks.createTask.titlePlaceholder' => 'Cosa va fatto?',
			'tasks.list.completedReopen' => 'Completata (clicca per riaprire)',
			'tasks.list.inProgressComplete' => 'In corso (clicca per completare)',
			'tasks.list.markCompleted' => 'Segna come completata',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Cambia stato dell’attività ${id}',
			'tasks.list.markDone' => 'Segna come completata',
			'tasks.list.reopen' => 'Riapri',
			'tasks.nextTask.allComplete' => 'Tutte le attività completate',
			'tasks.nextTask.feature1' => '- Gestione attività con AI, dipendenze e sottoattività.',
			'tasks.nextTask.feature2' => '- Generazione attività da PRD per un avvio più rapido.',
			'tasks.nextTask.feature3' => '- Viste kanban e lista per il lavoro quotidiano.',
			'tasks.nextTask.hideDetails' => 'Nascondi dettagli',
			'tasks.nextTask.initialize' => 'Inizializza',
			'tasks.nextTask.noPending' => 'Nessuna attività in sospeso',
			_ => null,
		} ?? switch (path) {
			'tasks.nextTask.notConfigured' => 'TaskMaster AI non è configurato',
			'tasks.nextTask.review' => 'Revisiona',
			'tasks.nextTask.startTask' => 'Avvia attività',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Attività ${id}',
			'tasks.nextTask.viewAll' => 'Vedi tutte le attività',
			'tasks.nextTask.viewDetails' => 'Vedi dettagli attività',
			'tasks.nextTask.whatIs' => 'Cos’è TaskMaster?',
			'tasks.taskDetail.cancelEdit' => 'Annulla modifica',
			'tasks.taskDetail.close' => 'Chiudi',
			'tasks.taskDetail.copyTaskId' => 'Copia ID attività',
			'tasks.taskDetail.delete' => 'Elimina attività',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '"${title}" verrà eliminata definitivamente.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Eliminare l\'attività?',
			'tasks.taskDetail.deleteFailed' => 'Impossibile eliminare l\'attività',
			'tasks.taskDetail.dependencies' => 'Dipendenze',
			'tasks.taskDetail.dependenciesPlaceholder' => 'es. 1, 2, 3',
			'tasks.taskDetail.description' => 'Descrizione',
			'tasks.taskDetail.edit' => 'Modifica attività',
			'tasks.taskDetail.implDetails' => 'Dettagli di implementazione',
			'tasks.taskDetail.noDependencies' => 'Nessuna dipendenza',
			'tasks.taskDetail.noDescription' => 'Nessuna descrizione fornita',
			'tasks.taskDetail.priority' => 'Priorità',
			'tasks.taskDetail.priorityNotSet' => 'Non impostata',
			'tasks.taskDetail.save' => 'Salva',
			'tasks.taskDetail.status' => 'Stato',
			'tasks.taskDetail.statusFailed' => 'Impossibile aggiornare lo stato dell’attività',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Attività ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Attività ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Strategia di test',
			'tasks.taskDetail.titleRequired' => 'Il titolo è obbligatorio',
			'tasks.taskDetail.updateFailed' => 'Impossibile aggiornare l’attività',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'L\'attività #${id} verrà rimossa. L\'azione è irreversibile.',
			'tasks.taskDetail.notFound' => 'Attività non trovata',
			'tasks.taskDetail.subtasks' => 'Sottoattività',
			'tasks.taskDetail.idCopied' => 'ID attività copiato',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Attività ${id} impostata su in corso',
			'knowledge.title' => 'Conoscenza',
			'knowledge.tabs.dashboard' => 'Dashboard',
			'knowledge.tabs.memories' => 'Ricordi',
			'knowledge.tabs.rules' => 'Regole',
			'knowledge.tabs.skills' => 'Competenze',
			'knowledge.tabs.personal' => 'Personale',
			'knowledge.tabs.graph' => 'Grafo',
			'knowledge.common.add' => 'Aggiungi',
			'knowledge.common.save' => 'Salva',
			'knowledge.common.cancel' => 'Annulla',
			'knowledge.common.delete' => 'Elimina',
			'knowledge.common.edit' => 'Modifica',
			'knowledge.common.close' => 'Chiudi',
			'knowledge.common.restore' => 'Ripristina',
			'knowledge.common.refresh' => 'Aggiorna',
			'knowledge.common.allProjects' => 'Tutti i progetti',
			'knowledge.common.global' => 'Globale',
			'knowledge.actions.scan' => 'Scansiona i file del progetto',
			'knowledge.actions.export' => 'Esporta JSON',
			'knowledge.actions.import' => 'Importa JSON',
			'knowledge.actions.scanComplete' => 'Scansione completata',
			'knowledge.actions.importComplete' => 'Importazione completata',
			'knowledge.actions.importFailed' => 'Importazione non riuscita',
			'knowledge.dialog.newEntity' => 'Nuova voce',
			'knowledge.dialog.editEntity' => 'Modifica voce',
			'knowledge.dialog.deleteTitle' => 'Elimina',
			'knowledge.dialog.deleteMessage' => 'Eliminare questa voce? Non è reversibile (la cronologia viene conservata).',
			'knowledge.dialog.pickIcon' => 'Scegli icona',
			'knowledge.dialog.removeIcon' => 'Rimuovi icona',
			'knowledge.dialog.iconTooLarge' => 'L\'icona è troppo grande (max 40 KB).',
			'knowledge.dialog.importTitle' => 'Importa conoscenza',
			'knowledge.dialog.importHint' => 'Incolla qui il JSON esportato',
			'knowledge.dialog.exportTitle' => 'Esporta conoscenza',
			'knowledge.dialog.import' => 'Importa',
			'knowledge.fields.key' => 'Chiave',
			'knowledge.fields.title' => 'Titolo',
			'knowledge.fields.name' => 'Nome',
			'knowledge.fields.description' => 'Descrizione',
			'knowledge.fields.category' => 'Categoria',
			'knowledge.fields.content' => 'Contenuto',
			'knowledge.fields.priority' => 'Priorità',
			'knowledge.fields.tags' => 'Tag',
			'knowledge.fields.enabled' => 'Attivo',
			'knowledge.fields.projectScope' => 'Ambito del progetto',
			'knowledge.fields.tagsHint' => 'separate da virgole',
			'knowledge.dashboard.memories' => 'Ricordi',
			'knowledge.dashboard.rules' => 'Regole',
			'knowledge.dashboard.skills' => 'Competenze',
			'knowledge.dashboard.personal' => 'Personale',
			'knowledge.dashboard.connections' => 'Connessioni',
			'knowledge.dashboard.recent' => 'Ricordi recenti',
			'knowledge.dashboard.noMemories' => 'Nessun ricordo. Aggiungine uno nella scheda Ricordi.',
			'knowledge.empty.memories' => 'Nessun ricordo.',
			'knowledge.empty.rules' => 'Nessuna regola.',
			'knowledge.empty.skills' => 'Nessuna competenza.',
			'knowledge.empty.personal' => 'Nessuna informazione personale.',
			'knowledge.empty.graph' => 'Nessuna entità da mostrare.',
			'knowledge.history.title' => 'Cronologia',
			'knowledge.history.none' => 'Nessuna cronologia.',
			'knowledge.history.untitled' => '(senza titolo)',
			'knowledge.priorities.critical' => 'Critica',
			'knowledge.priorities.high' => 'Alta',
			'knowledge.priorities.normal' => 'Normale',
			'knowledge.priorities.low' => 'Bassa',
			'knowledge.search.title' => 'Cerca nella conoscenza',
			'knowledge.search.hint' => 'Cerca ricordi, regole, competenze…',
			'knowledge.search.noResults' => 'Nessun risultato.',
			'knowledge.links.title' => 'Collega entità',
			'knowledge.links.source' => 'Origine',
			'knowledge.links.target' => 'Destinazione',
			'knowledge.links.relationship' => 'Relazione',
			'knowledge.links.add' => 'Crea collegamento',
			'knowledge.tags.all' => 'Tutti i tag',
			'knowledge.tags.manage' => 'Gestisci tag',
			'knowledge.tags.none' => 'Nessun tag.',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.critical.make' => 'Rendi critica',
			'knowledge.critical.makeAll' => 'Rendi tutte le regole critiche',
			'knowledge.critical.makeAllHint' => 'Le aggiunge al budget di contesto iniettato',
			'knowledge.errors.importFailed' => ({required Object error}) => 'Importazione non riuscita: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Migrazione non riuscita: ${error}',
			'knowledge.graph.truncated' => 'troncato',
			'knowledge.importAll.action' => 'Importa tutto',
			'knowledge.importAll.mergeDuplicates' => 'Unisci le voci duplicate',
			'knowledge.importAll.mergeDuplicatesHint' => 'Unisce le righe duplicate in DDAgent (non i file)',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Progetti analizzati: ${count}',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Regole: ${total} · gruppi duplicati: ${duplicates}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Skill degli agenti trovate: ${found} (nuove: ${newSkills})',
			'knowledge.importAll.title' => 'Importa tutto in DDAgent',
			'knowledge.importSkills.found' => ({required Object count}) => 'Trovate ${count} skill nei tuoi agenti.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Nuove: ${imported} · saltate: ${skipped}',
			'knowledge.importSkills.title' => 'Importa le skill degli agenti',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Memoria: ${title}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Personale: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Regola: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Skill: ${name}',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Gruppi duplicati tra i progetti: ${count}',
			'knowledge.migrate.mergeDuplicates' => 'Unisci i duplicati',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Rimosse: ${removed}, promosse: ${promoted}',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Regole: ${total} in totale, ${critical} critiche.',
			'knowledge.migrate.scanned' => ({required Object count}) => 'Analizzati ${count} progetti.',
			'knowledge.migrate.title' => 'Migra le regole esistenti',
			'skills.addDialog.chooseFileTitle' => 'Scegli SKILL.md',
			'skills.addDialog.chooseFiles' => 'Scegli file',
			'skills.addDialog.chooseFolder' => 'Scegli cartella',
			'skills.addDialog.chooseFolderTitle' => 'Scegli una cartella di skill',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} file · ${size}', other: '${count} file · ${size}', ), 
			'skills.addDialog.folderUploadsNote' => 'I caricamenti delle cartelle mantengono il nome della cartella selezionata; i file singoli usano il `name` in `SKILL.md`.',
			'skills.addDialog.hideInstallLocation' => 'Nascondi posizione di installazione',
			'skills.addDialog.installSkill' => 'Installa Skill',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Installa ${count} Skill', other: 'Installa ${count} Skill', ), 
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'File Markdown · ${size}',
			'skills.addDialog.pickHint' => 'Le cartelle possono includere script, riferimenti e asset.',
			'skills.addDialog.pickTitle' => 'Seleziona una cartella di skill o SKILL.md',
			'skills.addDialog.readyToInstall' => 'Pronto per l\'installazione',
			'skills.addDialog.removeQueued' => ({required Object name}) => 'Rimuovi ${name}',
			'skills.addDialog.title' => ({required Object provider}) => 'Aggiungi Skill di ${provider}',
			'skills.addDialog.uploadHint' => 'Carica un file SKILL.md o una cartella di skill completa.',
			'skills.addDialog.whereWillThisInstall' => 'Dove verrà installato?',
			'skills.deleteSkill' => ({required Object name}) => 'Elimina ${name}',
			'skills.empty.noGlobalSkills' => 'Nessuna skill globale ancora rilevata',
			'skills.empty.noGlobalSkillsDescription' => 'Aggiungi una skill globale qui sopra per renderla disponibile in ogni progetto.',
			'skills.empty.noMatchingSkills' => 'Nessuna skill corrispondente',
			'skills.empty.noMatchingSkillsDescription' => 'Prova con un comando, nome, ambito, progetto o percorso di origine diverso.',
			'skills.empty.noProjects' => 'Nessun progetto disponibile',
			'skills.empty.noProjectsDescription' => 'Aggiungi un progetto o workspace per sfogliarne le skill.',
			'skills.empty.noSkillsInProject' => 'Nessuna skill in questo progetto',
			'skills.empty.noSkillsInProjectDescription' => 'Crea una cartella .claude/skills, .cursor/skills o .agents/skills nel progetto selezionato.',
			'skills.errors.addMarkdownFirst' => 'Aggiungi prima uno o più file markdown.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'Impossibile leggere SKILL.md da ${name}.',
			'skills.errors.dropMarkdownOrFolder' => 'Trascina uno o più file markdown o una cartella contenente SKILL.md.',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Una cartella di skill può contenere fino a ${count} file.',
			'skills.errors.folderReadFailed' => 'Impossibile leggere la cartella di skill',
			'skills.errors.folderSizeLimit' => 'Le cartelle di skill selezionate devono essere più piccole di 30 MB in totale.',
			'skills.errors.importFailed' => 'Importazione delle skill non riuscita',
			'skills.errors.missingSkillFile' => 'La cartella selezionata non contiene un file SKILL.md.',
			'skills.moveDialog.moveToGlobal' => 'Sposta in globale',
			'skills.moveDialog.moveToProject' => 'Sposta nel progetto',
			'skills.moveDialog.toGlobalHint' => 'Sposta questa skill nella cartella delle skill globali così ogni progetto può usarla.',
			'skills.moveDialog.toProjectHint' => 'Scegli il progetto a cui assegnare questa skill. Verrà rimossa dalla cartella delle skill globali del provider.',
			'skills.moveSkill' => ({required Object name}) => 'Sposta ${name}',
			'skills.projectLabel' => 'Progetto',
			'skills.scopes.admin' => 'Admin',
			'skills.scopes.plugin' => 'Plugin',
			'skills.scopes.project' => 'Progetto',
			'skills.scopes.repo' => 'Repository',
			'skills.scopes.system' => 'Sistema',
			'skills.scopes.user' => 'Utente',
			'skills.screen.addSkill' => 'Aggiungi Skill',
			'skills.screen.clearSearch' => 'Cancella ricerca skill',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Rimuove la cartella ${directory} dalla cartella delle skill gestite di ${provider}. L\'azione è irreversibile.',
			'skills.screen.deleteTitle' => ({required Object name}) => 'Eliminare ${name}?',
			'skills.screen.loadingSkills' => ({required Object provider}) => 'Caricamento delle skill di ${provider}…',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Gestisci le skill di ${provider} da file locali, cartelle complete e percorsi legati al progetto.',
			'skills.screen.noDescription' => 'Nessuna descrizione fornita nel front matter della skill.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Plugin: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Progetto: ${name}',
			'skills.screen.savedSuccessfully' => 'Skill salvate correttamente.',
			'skills.screen.scanningProjectSkills' => 'Scansione delle skill del progetto…',
			'skills.screen.searchHint' => 'Cerca skill…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} SKILL', other: '${count} SKILL', ), 
			'skills.screen.sourceLabel' => 'ORIGINE',
			'mcp.form.fields.bearerTokenEnvVar' => 'Variabile d\'ambiente del token Bearer',
			'mcp.form.fields.envVarNames' => 'Nomi delle variabili d\'ambiente',
			'mcp.form.fields.workingDirectory' => 'Directory di lavoro',
			'mcp.form.scope.claudeLocal' => 'Claude locale',
			'mcp.form.scope.description.local' => 'Salvato nelle impostazioni utente di Claude per il progetto selezionato',
			'mcp.form.scope.description.project' => 'Salvato nel workspace del progetto selezionato',
			'mcp.form.scope.description.projectGlobal' => 'Scrive nel workspace del progetto selezionato per ogni provider',
			'mcp.form.scope.description.user' => 'Disponibile in tutti i progetti sulla tua macchina',
			'mcp.form.scope.description.userGlobal' => 'Scrive nella configurazione utente di ogni provider ed è disponibile in tutti i progetti su questa macchina',
			'mcp.form.scope.projectAllProviders' => 'Progetto (tutti i provider)',
			'mcp.form.scope.userAllProviders' => 'Utente (tutti i provider)',
			'mcp.form.submitTo' => ({required Object provider}) => 'Aggiungi server a ${provider}',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'Aggiungi server MCP supporta solo stdio e http su tutti i provider, non ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} non supporta server MCP di tipo ${type}',
			'mcp.install.button' => 'Installa',
			'mcp.install.cardDescription' => 'Dai ai tuoi agenti la base di conoscenza e gli strumenti DDAgent tramite MCP — scegli gli agenti o installa per tutti.',
			'mcp.install.description' => 'Consente agli agenti selezionati di usare la base di conoscenza e gli strumenti DDAgent tramite MCP.',
			'mcp.install.errorFallback' => 'errore',
			'mcp.install.failed' => ({required Object error}) => 'Installazione non riuscita: ${error}',
			'mcp.install.installForAll' => 'Installa per tutti',
			'mcp.install.installSelected' => 'Installa selezionati',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Installato su ${count} agente.', other: 'Installato su ${count} agenti.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Installato su ${count}; non riuscito: ${failed}',
			'mcp.install.title' => 'Installa il server MCP DDAgent',
			'mcp.servers.addGlobalDescription' => 'Aggiunge questo server MCP a ogni provider: Claude, Cursor, Codex, OpenCode e Devin. Sono supportati solo i trasporti stdio e HTTP perché la stessa configurazione deve funzionare su tutti i provider.',
			'mcp.servers.addGlobalMenuDescription' => 'Aggiungi server MCP globale scrive un unico server stdio o HTTP comune in Claude, Cursor, Codex, OpenCode e Devin.',
			'mcp.servers.addGlobalTitle' => 'Aggiungi server MCP globale',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => 'Aggiungi server MCP di ${provider} modifica solo ${provider}.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => 'Aggiungi server MCP di ${provider}',
			'mcp.servers.config.cwd' => 'Cwd',
			'mcp.servers.config.envVars' => 'Variabili d\'ambiente',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'I server Model Context Protocol forniscono strumenti e fonti dati aggiuntive a ${provider}',
			'mcp.servers.loading' => 'Caricamento server MCP…',
			'mcp.servers.refreshingScopes' => 'Aggiornamento degli ambiti del progetto…',
			'mcp.team.cta' => 'Disponibile con DDAgent Pro',
			'mcp.team.description' => 'Condividi le configurazioni dei server MCP con il tuo team. Tutti restano sincronizzati automaticamente.',
			'mcp.team.title' => 'Configurazioni MCP del team',
			'mcp.tokens.scopeWrite' => 'Scrittura',
			'terminal.actions.clearOutput' => 'Cancella output',
			'terminal.actions.connect' => 'Connetti',
			'terminal.actions.newShell' => 'Nuova shell',
			'terminal.actions.newTab' => 'Nuova scheda terminale',
			'terminal.actions.providerLogin' => 'Accesso provider',
			'terminal.actions.restartSession' => 'Riavvia sessione',
			'terminal.authUrl.openInBrowser' => 'Apri nel browser',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Impossibile aprire il link: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'File rilevato: ${path}',
			'terminal.paste.hint' => 'Ctrl+V / clic destro → Incolla',
			'terminal.paste.title' => 'Incolla nel terminale',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.hide' => 'Nascondi barra scorciatoie',
			'terminal.shortcuts.interrupt' => 'Interrompi (SIGINT)',
			'terminal.shortcuts.suspend' => 'Sospendi (SIGTSTP)',
			'terminal.shortcuts.showTooltip' => 'Mostra scorciatoie',
			'terminal.shortcuts.hideTooltip' => 'Nascondi scorciatoie',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Accesso: ${provider}',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.plainShell' => 'Shell semplice',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'worktrees.branchHint' => 'Nome del nuovo branch (es. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Diramazione da ${branch}',
			'worktrees.cleanupDescription' => 'Rimuovi il worktree ed elimina il branch una volta fuso',
			'worktrees.created' => 'Worktree creato',
			'worktrees.deleteBranchLabel' => 'Elimina anche il branch',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Attenzione: questo worktree ha ${count} modifiche non committate che andranno perse.',
			'worktrees.emptyDescription' => 'Crea un worktree per isolare il lavoro sulle funzionalità o le esecuzioni degli agenti.',
			'worktrees.emptyTitle' => 'Nessun worktree trovato',
			'worktrees.forceRemoveLabel' => 'Forza rimozione (scarta le modifiche)',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD distaccato su ${sha}',
			'worktrees.mainBadge' => 'main',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Fondi le modifiche in ${branch}.',
			'worktrees.mergeTitle' => ({required Object branch}) => 'Fondi ${branch}',
			'worktrees.merged' => ({required Object branch}) => 'Worktree fuso in ${branch}',
			'worktrees.opened' => ({required Object branch}) => 'Worktree aperto: ${branch}',
			'worktrees.portHint' => 'Porta di esecuzione (opzionale, es. 3000)',
			'worktrees.removeDescription' => 'Elimina la cartella del worktree. I progetti collegati verranno archiviati.',
			'worktrees.removeTitle' => ({required Object branch}) => 'Rimuovere il worktree ${branch}?',
			'worktrees.removed' => 'Worktree rimosso',
			'worktrees.runButton' => 'Esegui',
			'worktrees.runHint' => 'Comando di esecuzione (es. npm run dev)',
			'worktrees.runRunning' => 'in esecuzione',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'in esecuzione :${port}',
			'worktrees.scripts' => 'Script',
			'worktrees.scriptsSaved' => 'Configurazione degli script salvata',
			'worktrees.serverLabel' => 'Server: ',
			'worktrees.setupHint' => 'Comando di configurazione (es. npm install)',
			'worktrees.setupLabel' => 'Configurazione: ',
			'worktrees.squashDescription' => 'Combina tutti i commit in un unico commit',
			'worktrees.stopButton' => 'Interrompi',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.chart.hide' => 'Nascondi',
			'quota.chart.noData' => 'Dati insufficienti per una tendenza.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} token · ${cost}',
			'quota.chart.show' => 'Mostra',
			'quota.config.accountRouting' => 'Routing account',
			'quota.config.pollerTitle' => 'Polling e avvisi',
			'quota.config.save' => 'Salva configurazione',
			'quota.overview.tokensAndCost' => 'Token e costo',
			'quota.section.config' => 'Configurazione',
			'scheduler.checking' => 'Verifica…',
			'scheduler.cronHint' => 'Cron (min ora giorno mese giorno della settimana) — es. 0 9 * * *',
			'scheduler.deleteMessage' => ({required Object id}) => 'Rimuove il job ricorrente ${id}. Le sessioni esistenti vengono conservate.',
			'scheduler.deleteTitle' => 'Eliminare la pianificazione?',
			'scheduler.editTitle' => 'Modifica pianificazione',
			'scheduler.newLabel' => 'Nuova',
			'scheduler.nextIn' => ({required Object time}) => 'prossimo tra ${time}',
			'scheduler.promptHint' => 'Prompt per l\'agente',
			'scheduler.runs' => 'Esecuzioni',
			'scheduler.session' => ({required Object id}) => 'sessione ${id}',
			'scheduler.worktree' => 'worktree',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.noResponse' => 'Nessuna risposta dal server',
			'notifications.errors.registrationRejected' => 'Registrazione rifiutata dal server',
			'serverConnect.connect' => 'Connetti',
			'serverConnect.connecting' => 'Connessione…',
			'serverConnect.changeServer' => 'Cambia server',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Connessione non riuscita (${error})',
			'serverConnect.enterUrl' => 'Inserisci l\'URL del server',
			'serverConnect.local.title' => 'Questo dispositivo',
			'serverConnect.local.subtitle' => 'Esegui il server DDAgent su questa macchina',
			'serverConnect.local.install' => 'Installa il server locale',
			'serverConnect.local.start' => 'Avvia il server locale',
			'serverConnect.local.stop' => 'Arresta',
			'serverConnect.local.starting' => 'Avvio del server locale…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Download del server… ${percent}%',
			'serverConnect.local.installing' => 'Installazione…',
			'serverConnect.local.running' => ({required Object url}) => 'In esecuzione su ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Installato (v${version})',
			'serverConnect.local.connect' => 'Usa questo server',
			'serverConnect.local.error' => ({required Object error}) => 'Errore del server locale: ${error}',
			'serverConnect.local.or' => 'oppure connettiti a un server remoto',
			'serverConnect.subtitle' => 'Connettiti al tuo server DDAgent',
			'voice.apiKeySaved' => 'Chiave API (salvata, inserisci per sostituire)',
			'voice.preview' => 'Anteprima',
			'voice.saveFailed' => 'Impossibile salvare la configurazione STT',
			'voice.settingsSaved' => 'Impostazioni di input vocale salvate',
			'sharedContext.title' => 'Note condivise',
			'collab.copyToken' => 'Copia token',
			'collab.createInvite' => 'Crea invito',
			'collab.invite' => 'Invito',
			'collab.inviteTeammate' => 'Invita un collega',
			'collab.roles.member' => 'Membro',
			'collab.roles.viewer' => 'Visualizzatore',
			'collab.shareTokenHint' => 'Condividi questo token di invito — viene mostrato una sola volta e scade in 72h:',
			'collab.team' => 'Team',
			'browser.dialogTitle' => 'Browser dell\'agente',
			'browser.viewError' => 'Errore della vista browser',
			'browser.web' => 'Web',
			'projects.archive' => 'Archivia',
			'projects.archivedSection' => ({required Object count}) => 'Archiviati (${count})',
			'projects.clone' => 'Clona',
			'projects.cloneFailed' => 'Clonazione non riuscita',
			'projects.cloneFinished' => 'Clonazione completata. Aggiornamento dell\'elenco dei progetti…',
			'projects.cloneRepository' => 'Clona repository',
			'projects.deletePermanently' => 'Elimina definitivamente',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Rimuove definitivamente "${name}", incluse tutte le sessioni e la cronologia memorizzata (cancellazione JSONL). L\'azione è irreversibile.',
			'projects.deleteProjectTitle' => 'Eliminare il progetto?',
			'projects.destinationPath' => 'Percorso di destinazione',
			'projects.destinationPathRequired' => 'Il percorso di destinazione è obbligatorio',
			'projects.displayNameOptional' => 'Nome visualizzato (opzionale)',
			'projects.failedToLoadTokens' => 'Impossibile caricare i token GitHub',
			'projects.githubTokenOptional' => 'Token GitHub (opzionale)',
			'projects.newer' => 'Più recenti',
			'projects.older' => 'Meno recenti',
			'projects.projectArchived' => 'Progetto archiviato',
			'projects.projectDeleted' => 'Progetto eliminato',
			'projects.projectRenamed' => 'Progetto rinominato',
			'projects.projectRestored' => 'Progetto ripristinato',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.repositoryCloned' => 'Repository clonato',
			'projects.repositoryUrlRequired' => 'L\'URL del repository è obbligatorio',
			'projects.restore' => 'Ripristina',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '${count} sessione', other: '${count} sessioni', ), 
			'projects.unknown' => 'Sconosciuto',
			'projects.usingStoredToken' => ({required Object name}) => 'Usando token salvato: ${name}',
			'sessions.activity.committingChanges' => 'Commit delle modifiche',
			'sessions.activity.editingFile' => ({required Object file}) => 'Modifica di ${file}',
			'sessions.activity.editingFileGeneric' => 'Modifica di un file',
			'sessions.activity.fetchingUrl' => ({required Object url}) => 'Recupero di ${url}',
			'sessions.activity.pushingBranch' => 'Push del branch',
			'sessions.activity.readingFile' => ({required Object file}) => 'Lettura di ${file}',
			'sessions.activity.runningCommand' => ({required Object command}) => 'Esecuzione di `${command}`',
			'sessions.activity.runningShellCommand' => 'Esecuzione di un comando shell',
			'sessions.activity.runningTool' => ({required Object name}) => 'Esecuzione di ${name}',
			'sessions.activity.searching' => ({required Object query}) => 'Ricerca di “${query}”',
			'sessions.activity.subagentRunning' => 'Subagent in esecuzione',
			'sessions.age.days' => ({required Object days}) => '${days}g',
			'sessions.age.hours' => ({required Object hours}) => '${hours}h',
			'sessions.age.lessThanMinute' => '<1m',
			'sessions.age.minutes' => ({required Object count}) => '${count}m',
			'sessions.archive' => 'Archivia',
			'sessions.archivedSessions' => 'Sessioni archiviate',
			'sessions.autoOrchestrator' => 'Auto (orchestratore)',
			'sessions.compareWith' => 'Confronta con…',
			'sessions.createFailed' => ({required Object error}) => 'Creazione della sessione non riuscita: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Rimuove "${name}" e la sua trascrizione. L\'azione è irreversibile.',
			'sessions.newSessionProvider' => 'Nuova sessione — provider',
			'sessions.noRecentSessions' => 'Nessuna sessione recente',
			'sessions.noSessions' => 'Nessuna sessione',
			'sessions.projectPath' => 'Percorso del progetto',
			'sessions.rename' => 'Rinomina',
			'sessions.toasts.archived' => 'Sessione archiviata',
			'sessions.toasts.deleted' => 'Sessione eliminata',
			'sessions.toasts.pinned' => 'Sessione fissata',
			'sessions.toasts.renamed' => 'Sessione rinominata',
			'sessions.toasts.restored' => 'Sessione ripristinata',
			'sessions.toasts.unpinned' => 'Sessione non fissata',
			'sessions.toasts.workspaceChanged' => 'Workspace modificato',
			'git.aiButton' => '✦ AI',
			'git.checkpoints.create' => 'Nuovo',
			'git.checkpoints.empty' => 'Nessun checkpoint ancora',
			'git.checkpoints.labelHint' => 'Etichetta del checkpoint (opzionale)',
			'git.checkpoints.restoreMessage' => 'Ripristinare l\'albero di lavoro a questo checkpoint? Le modifiche attuali verranno sostituite.',
			'git.checkpoints.restoreTitle' => 'Ripristina checkpoint',
			'git.checkpoints.restored' => 'Checkpoint ripristinato',
			'git.checkpoints.title' => 'Checkpoint',
			'git.commitCreated' => 'Commit creato',
			'git.commitMessage' => 'Messaggio di commit',
			'git.deleteFile' => 'Elimina file',
			'git.hunkStage' => '+ Sezione',
			'git.hunkUnstage' => '− Sezione',
			'git.largeDiff' => 'Anteprima diff di grandi dimensioni: il rendering è limitato per mantenere la scheda reattiva.',
			'git.loadDiffFailed' => ({required Object error}) => 'Impossibile caricare il diff: ${error}',
			'git.noBranch' => 'nessun branch',
			'git.noDiff' => 'Nessun diff disponibile',
			'git.selectProject' => 'Seleziona un progetto',
			'git.splitDiff' => 'Diff affiancato',
			'git.stageHunk' => 'Metti in stage la sezione',
			'git.stagedChanges' => 'Modifiche in stage',
			'git.statusStaged' => 'In stage',
			'git.switchBranch' => 'Cambia branch',
			'git.unifiedDiff' => 'Diff unificato',
			'git.unstageHunk' => 'Togli la sezione dallo stage',
			'kanban.card.untitled' => 'Senza titolo',
			'kanban.comments.add' => 'Aggiungi commento',
			'kanban.comments.empty' => 'Nessun commento ancora',
			'kanban.details.status' => ({required Object status}) => 'Stato: ${status}',
			'kanban.details.title' => 'Dettagli della scheda',
			'kanban.dialog.saving' => 'Salvataggio…',
			'kanban.empty.noProject' => 'Nessun progetto selezionato',
			'kanban.saveFailed' => 'Impossibile salvare la scheda',
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '1 giorno fa', other: '${count} giorni fa', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '1 ora fa', other: '${count} ore fa', ), 
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: '1 minuto fa', other: '${count} minuti fa', ), 
			'kanban.time.now' => 'adesso',
			'onboarding.agents.description' => 'Accedi a uno o più assistenti di programmazione AI. Tutti sono opzionali.',
			'onboarding.agents.laterHint' => 'Puoi configurarli in seguito nelle Impostazioni.',
			'onboarding.agents.title' => 'Connetti i tuoi agenti AI',
			'onboarding.completeSetup' => 'Completa configurazione',
			'onboarding.errors.invalidEmail' => 'Inserisci un indirizzo email valido.',
			'onboarding.errors.nameAndEmailRequired' => 'Sono richiesti sia il nome git sia l\'email.',
			'onboarding.gitHint' => 'Usato per i commit creati dalle sessioni DDAgent.',
			'onboarding.mcp.description' => 'Installa il server MCP DDAgent così i tuoi agenti possono usare la base di conoscenza e gli strumenti DDAgent. Scegli gli agenti o installa per tutti.',
			'onboarding.mcp.installForAll' => 'Installa per tutti',
			'onboarding.mcp.installSelected' => 'Installa selezionati',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('it'))(count, one: 'Installato su ${count} agente.', other: 'Installato su ${count} agenti.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Installato su ${installedCount}; non riuscito: ${failed}',
			'onboarding.mcp.laterHint' => 'Opzionale — puoi installarlo anche in seguito in Impostazioni → MCP.',
			'onboarding.mcp.title' => 'Connetti gli agenti a DDAgent',
			'fileTree.browseServerFilesystem' => 'Sfoglia il filesystem del server',
			'fileTree.chooseFolder' => 'Scegli cartella',
			'fileTree.copyContents' => 'Copia contenuto',
			'fileTree.noFiles' => 'Nessun file',
			'fileTree.search.hint' => 'Filtra i nomi / Invio per cercare nei contenuti',
			'fileTree.search.noMatches' => 'Nessuna corrispondenza',
			'fileTree.search.prompt' => 'Digita una query e premi Invio',
			'fileTree.search.resultsTruncated' => 'Risultati troncati',
			'fileTree.titles.delete' => ({required Object name}) => 'Elimina ${name}',
			'fileTree.titles.download' => ({required Object name}) => 'Scarica ${name}',
			'fileTree.titles.rename' => ({required Object name}) => 'Rinomina ${name}',
			'fileTree.uploadHere' => 'Carica qui',
			'fileTree.uploadTo' => 'Carica in',
			'fileTree.uploadedCount' => ({required Object count}) => 'Caricati ${count} file',
			'fileTree.newName' => 'Nuovo nome',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Progetto non registrato: ${path}',
			'fileTree.showGitignoredFiles' => 'Mostra i file ignorati da git',
			'fileTree.hideGitignoredFiles' => 'Nascondi i file ignorati da git',
			'fileTree.downloadUnsupportedOnWeb' => 'Download non supportato sul web',
			'fileTree.saveToPath' => 'Salva nel percorso',
			'fileTree.savedTo' => ({required Object path}) => 'Salvato in ${path}',
			'workspace.archivedWorkspaceName' => 'Archiviati',
			'workspace.closePane' => 'Chiudi riquadro',
			'workspace.closeSearch' => 'Chiudi ricerca',
			'workspace.deleteSessionNotice' => 'Rimuove la sessione e la sua trascrizione. L\'azione è irreversibile.',
			'workspace.exportChat' => 'Esporta chat',
			'workspace.jumpToSession' => 'Vai alla sessione…',
			'workspace.newChatProvider' => 'Nuova chat — provider',
			'workspace.nextMatch' => 'Corrispondenza successiva',
			'workspace.previousMatch' => 'Corrispondenza precedente',
			'workspace.searchTranscript' => 'Cerca nella trascrizione',
			'workspace.sendTo' => ({required Object count}) => 'Invia a ${count}',
			'workspace.accountWithLabel' => ({required Object label}) => 'Predefinito · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Termina l\'esecuzione prima di cambiare spazio di lavoro',
			'workspace.restored' => 'Spazio di lavoro ripristinato',
			'workspace.maximizePane' => 'Ingrandisci riquadro',
			'workspace.restorePanes' => 'Ripristina riquadri',
			'workspace.reviewChangedFiles' => 'Esamina i file modificati',
			_ => null,
		};
	}
}
