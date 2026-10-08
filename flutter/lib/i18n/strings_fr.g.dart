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
class TranslationsFr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$fr auth = Translations$auth$fr._(_root);
	@override late final Translations$chat$fr chat = Translations$chat$fr._(_root);
	@override late final Translations$codeEditor$fr codeEditor = Translations$codeEditor$fr._(_root);
	@override late final Translations$common$fr common = Translations$common$fr._(_root);
	@override late final Translations$settings$fr settings = Translations$settings$fr._(_root);
	@override late final Translations$sidebar$fr sidebar = Translations$sidebar$fr._(_root);
	@override late final Translations$tasks$fr tasks = Translations$tasks$fr._(_root);
	@override late final Translations$knowledge$fr knowledge = Translations$knowledge$fr._(_root);
	@override late final Translations$skills$fr skills = Translations$skills$fr._(_root);
	@override late final Translations$mcp$fr mcp = Translations$mcp$fr._(_root);
	@override late final Translations$terminal$fr terminal = Translations$terminal$fr._(_root);
	@override late final Translations$worktrees$fr worktrees = Translations$worktrees$fr._(_root);
	@override late final Translations$quota$fr quota = Translations$quota$fr._(_root);
	@override late final Translations$scheduler$fr scheduler = Translations$scheduler$fr._(_root);
	@override late final Translations$notifications$fr notifications = Translations$notifications$fr._(_root);
	@override late final Translations$serverConnect$fr serverConnect = Translations$serverConnect$fr._(_root);
	@override late final Translations$voice$fr voice = Translations$voice$fr._(_root);
	@override late final Translations$sharedContext$fr sharedContext = Translations$sharedContext$fr._(_root);
	@override late final Translations$collab$fr collab = Translations$collab$fr._(_root);
	@override late final Translations$browser$fr browser = Translations$browser$fr._(_root);
	@override late final Translations$projects$fr projects = Translations$projects$fr._(_root);
	@override late final Translations$sessions$fr sessions = Translations$sessions$fr._(_root);
	@override late final Translations$git$fr git = Translations$git$fr._(_root);
	@override late final Translations$kanban$fr kanban = Translations$kanban$fr._(_root);
	@override late final Translations$onboarding$fr onboarding = Translations$onboarding$fr._(_root);
	@override late final Translations$fileTree$fr fileTree = Translations$fileTree$fr._(_root);
	@override late final Translations$workspace$fr workspace = Translations$workspace$fr._(_root);
}

// Path: auth
class Translations$auth$fr extends Translations$auth$en {
	Translations$auth$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'Votre session a expiré. Veuillez vous reconnecter.';
	@override late final Translations$auth$login$fr login = Translations$auth$login$fr._(_root);
	@override late final Translations$auth$register$fr register = Translations$auth$register$fr._(_root);
	@override late final Translations$auth$logout$fr logout = Translations$auth$logout$fr._(_root);
}

// Path: chat
class Translations$chat$fr extends Translations$chat$en {
	Translations$chat$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$fr codeBlock = Translations$chat$codeBlock$fr._(_root);
	@override late final Translations$chat$copyMessage$fr copyMessage = Translations$chat$copyMessage$fr._(_root);
	@override late final Translations$chat$messageTypes$fr messageTypes = Translations$chat$messageTypes$fr._(_root);
	@override late final Translations$chat$tools$fr tools = Translations$chat$tools$fr._(_root);
	@override late final Translations$chat$search$fr search = Translations$chat$search$fr._(_root);
	@override late final Translations$chat$fileOperations$fr fileOperations = Translations$chat$fileOperations$fr._(_root);
	@override late final Translations$chat$interactive$fr interactive = Translations$chat$interactive$fr._(_root);
	@override late final Translations$chat$thinking$fr thinking = Translations$chat$thinking$fr._(_root);
	@override late final Translations$chat$json$fr json = Translations$chat$json$fr._(_root);
	@override late final Translations$chat$permissions$fr permissions = Translations$chat$permissions$fr._(_root);
	@override late final Translations$chat$todo$fr todo = Translations$chat$todo$fr._(_root);
	@override late final Translations$chat$plan$fr plan = Translations$chat$plan$fr._(_root);
	@override late final Translations$chat$usageLimit$fr usageLimit = Translations$chat$usageLimit$fr._(_root);
	@override late final Translations$chat$codex$fr codex = Translations$chat$codex$fr._(_root);
	@override late final Translations$chat$input$fr input = Translations$chat$input$fr._(_root);
	@override late final Translations$chat$providerSelection$fr providerSelection = Translations$chat$providerSelection$fr._(_root);
	@override late final Translations$chat$session$fr session = Translations$chat$session$fr._(_root);
	@override late final Translations$chat$shell$fr shell = Translations$chat$shell$fr._(_root);
	@override late final Translations$chat$claudeStatus$fr claudeStatus = Translations$chat$claudeStatus$fr._(_root);
	@override late final Translations$chat$projectSelection$fr projectSelection = Translations$chat$projectSelection$fr._(_root);
	@override late final Translations$chat$tasks$fr tasks = Translations$chat$tasks$fr._(_root);
	@override late final Translations$chat$voice$fr voice = Translations$chat$voice$fr._(_root);
	@override late final Translations$chat$composer$fr composer = Translations$chat$composer$fr._(_root);
	@override late final Translations$chat$splitSession$fr splitSession = Translations$chat$splitSession$fr._(_root);
	@override late final Translations$chat$sessionPicker$fr sessionPicker = Translations$chat$sessionPicker$fr._(_root);
	@override late final Translations$chat$splitWorkspace$fr splitWorkspace = Translations$chat$splitWorkspace$fr._(_root);
	@override late final Translations$chat$splitOverview$fr splitOverview = Translations$chat$splitOverview$fr._(_root);
	@override late final Translations$chat$askUserQuestion$fr askUserQuestion = Translations$chat$askUserQuestion$fr._(_root);
	@override late final Translations$chat$attachments$fr attachments = Translations$chat$attachments$fr._(_root);
	@override late final Translations$chat$checkpoint$fr checkpoint = Translations$chat$checkpoint$fr._(_root);
	@override late final Translations$chat$common$fr common = Translations$chat$common$fr._(_root);
	@override late final Translations$chat$taskMaster$fr taskMaster = Translations$chat$taskMaster$fr._(_root);
	@override late final Translations$chat$tokenUsage$fr tokenUsage = Translations$chat$tokenUsage$fr._(_root);
	@override late final Translations$chat$tool$fr tool = Translations$chat$tool$fr._(_root);
	@override late final Translations$chat$quotaBadge$fr quotaBadge = Translations$chat$quotaBadge$fr._(_root);
	@override late final Translations$chat$paneHeader$fr paneHeader = Translations$chat$paneHeader$fr._(_root);
	@override late final Translations$chat$broadcast$fr broadcast = Translations$chat$broadcast$fr._(_root);
	@override late final Translations$chat$changes$fr changes = Translations$chat$changes$fr._(_root);
	@override late final Translations$chat$commandResult$fr commandResult = Translations$chat$commandResult$fr._(_root);
	@override late final Translations$chat$commands$fr commands = Translations$chat$commands$fr._(_root);
	@override late final Translations$chat$export$fr export = Translations$chat$export$fr._(_root);
	@override late final Translations$chat$message$fr message = Translations$chat$message$fr._(_root);
	@override late final Translations$chat$modelLibrary$fr modelLibrary = Translations$chat$modelLibrary$fr._(_root);
	@override late final Translations$chat$pinFile$fr pinFile = Translations$chat$pinFile$fr._(_root);
	@override late final Translations$chat$permissionRequest$fr permissionRequest = Translations$chat$permissionRequest$fr._(_root);
}

// Path: codeEditor
class Translations$codeEditor$fr extends Translations$codeEditor$en {
	Translations$codeEditor$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$fr toolbar = Translations$codeEditor$toolbar$fr._(_root);
	@override String loading({required Object fileName}) => 'Chargement de ${fileName}...';
	@override late final Translations$codeEditor$header$fr header = Translations$codeEditor$header$fr._(_root);
	@override late final Translations$codeEditor$actions$fr actions = Translations$codeEditor$actions$fr._(_root);
	@override late final Translations$codeEditor$footer$fr footer = Translations$codeEditor$footer$fr._(_root);
	@override late final Translations$codeEditor$binaryFile$fr binaryFile = Translations$codeEditor$binaryFile$fr._(_root);
	@override late final Translations$codeEditor$filePreview$fr filePreview = Translations$codeEditor$filePreview$fr._(_root);
	@override late final Translations$codeEditor$diff$fr diff = Translations$codeEditor$diff$fr._(_root);
	@override String get discardUnsavedChanges => 'Ignorer les modifications non enregistrées ?';
	@override late final Translations$codeEditor$emptyState$fr emptyState = Translations$codeEditor$emptyState$fr._(_root);
	@override String get failedToLoad => 'Échec du chargement du fichier';
	@override late final Translations$codeEditor$hexDump$fr hexDump = Translations$codeEditor$hexDump$fr._(_root);
	@override late final Translations$codeEditor$mediaFile$fr mediaFile = Translations$codeEditor$mediaFile$fr._(_root);
	@override late final Translations$codeEditor$settings$fr settings = Translations$codeEditor$settings$fr._(_root);
	@override String unsavedChanges({required Object name}) => 'Modifications non enregistrées dans ${name}';
	@override late final Translations$codeEditor$toasts$fr toasts = Translations$codeEditor$toasts$fr._(_root);
}

// Path: common
class Translations$common$fr extends Translations$common$en {
	Translations$common$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$fr buttons = Translations$common$buttons$fr._(_root);
	@override late final Translations$common$tabs$fr tabs = Translations$common$tabs$fr._(_root);
	@override late final Translations$common$status$fr status = Translations$common$status$fr._(_root);
	@override late final Translations$common$messages$fr messages = Translations$common$messages$fr._(_root);
	@override late final Translations$common$navigation$fr navigation = Translations$common$navigation$fr._(_root);
	@override late final Translations$common$common$fr common = Translations$common$common$fr._(_root);
	@override late final Translations$common$time$fr time = Translations$common$time$fr._(_root);
	@override late final Translations$common$fileOperations$fr fileOperations = Translations$common$fileOperations$fr._(_root);
	@override late final Translations$common$mainContent$fr mainContent = Translations$common$mainContent$fr._(_root);
	@override late final Translations$common$fileTree$fr fileTree = Translations$common$fileTree$fr._(_root);
	@override late final Translations$common$projectWizard$fr projectWizard = Translations$common$projectWizard$fr._(_root);
	@override late final Translations$common$notifications$fr notifications = Translations$common$notifications$fr._(_root);
	@override late final Translations$common$versionUpdate$fr versionUpdate = Translations$common$versionUpdate$fr._(_root);
	@override late final Translations$common$quota$fr quota = Translations$common$quota$fr._(_root);
	@override late final Translations$common$actions$fr actions = Translations$common$actions$fr._(_root);
	@override late final Translations$common$browserPane$fr browserPane = Translations$common$browserPane$fr._(_root);
	@override late final Translations$common$browserUse$fr browserUse = Translations$common$browserUse$fr._(_root);
	@override late final Translations$common$commandPalette$fr commandPalette = Translations$common$commandPalette$fr._(_root);
	@override late final Translations$common$gitPanel$fr gitPanel = Translations$common$gitPanel$fr._(_root);
	@override late final Translations$common$sessions$fr sessions = Translations$common$sessions$fr._(_root);
	@override late final Translations$common$projects$fr projects = Translations$common$projects$fr._(_root);
	@override late final Translations$common$codeBlock$fr codeBlock = Translations$common$codeBlock$fr._(_root);
	@override late final Translations$common$update$fr update = Translations$common$update$fr._(_root);
}

// Path: settings
class Translations$settings$fr extends Translations$settings$en {
	Translations$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paramètres';
	@override late final Translations$settings$changelog$fr changelog = Translations$settings$changelog$fr._(_root);
	@override late final Translations$settings$server$fr server = Translations$settings$server$fr._(_root);
	@override late final Translations$settings$updates$fr updates = Translations$settings$updates$fr._(_root);
	@override late final Translations$settings$tabs$fr tabs = Translations$settings$tabs$fr._(_root);
	@override late final Translations$settings$account$fr account = Translations$settings$account$fr._(_root);
	@override late final Translations$settings$mcp$fr mcp = Translations$settings$mcp$fr._(_root);
	@override late final Translations$settings$appearance$fr appearance = Translations$settings$appearance$fr._(_root);
	@override late final Translations$settings$actions$fr actions = Translations$settings$actions$fr._(_root);
	@override late final Translations$settings$quickSettings$fr quickSettings = Translations$settings$quickSettings$fr._(_root);
	@override late final Translations$settings$terminalShortcuts$fr terminalShortcuts = Translations$settings$terminalShortcuts$fr._(_root);
	@override late final Translations$settings$mainTabs$fr mainTabs = Translations$settings$mainTabs$fr._(_root);
	@override late final Translations$settings$orchestration$fr orchestration = Translations$settings$orchestration$fr._(_root);
	@override late final Translations$settings$notifications$fr notifications = Translations$settings$notifications$fr._(_root);
	@override late final Translations$settings$appearanceSettings$fr appearanceSettings = Translations$settings$appearanceSettings$fr._(_root);
	@override late final Translations$settings$mcpForm$fr mcpForm = Translations$settings$mcpForm$fr._(_root);
	@override late final Translations$settings$saveStatus$fr saveStatus = Translations$settings$saveStatus$fr._(_root);
	@override late final Translations$settings$footerActions$fr footerActions = Translations$settings$footerActions$fr._(_root);
	@override late final Translations$settings$git$fr git = Translations$settings$git$fr._(_root);
	@override late final Translations$settings$apiKeys$fr apiKeys = Translations$settings$apiKeys$fr._(_root);
	@override late final Translations$settings$tasks$fr tasks = Translations$settings$tasks$fr._(_root);
	@override late final Translations$settings$agents$fr agents = Translations$settings$agents$fr._(_root);
	@override late final Translations$settings$permissions$fr permissions = Translations$settings$permissions$fr._(_root);
	@override late final Translations$settings$mcpServers$fr mcpServers = Translations$settings$mcpServers$fr._(_root);
	@override late final Translations$settings$quota$fr quota = Translations$settings$quota$fr._(_root);
	@override late final Translations$settings$browser$fr browser = Translations$settings$browser$fr._(_root);
	@override late final Translations$settings$workspaces$fr workspaces = Translations$settings$workspaces$fr._(_root);
	@override late final Translations$settings$about$fr about = Translations$settings$about$fr._(_root);
}

// Path: sidebar
class Translations$sidebar$fr extends Translations$sidebar$en {
	Translations$sidebar$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$fr projects = Translations$sidebar$projects$fr._(_root);
	@override late final Translations$sidebar$app$fr app = Translations$sidebar$app$fr._(_root);
	@override late final Translations$sidebar$sessions$fr sessions = Translations$sidebar$sessions$fr._(_root);
	@override late final Translations$sidebar$tooltips$fr tooltips = Translations$sidebar$tooltips$fr._(_root);
	@override late final Translations$sidebar$navigation$fr navigation = Translations$sidebar$navigation$fr._(_root);
	@override late final Translations$sidebar$actions$fr actions = Translations$sidebar$actions$fr._(_root);
	@override late final Translations$sidebar$branding$fr branding = Translations$sidebar$branding$fr._(_root);
	@override late final Translations$sidebar$status$fr status = Translations$sidebar$status$fr._(_root);
	@override late final Translations$sidebar$time$fr time = Translations$sidebar$time$fr._(_root);
	@override late final Translations$sidebar$messages$fr messages = Translations$sidebar$messages$fr._(_root);
	@override late final Translations$sidebar$version$fr version = Translations$sidebar$version$fr._(_root);
	@override late final Translations$sidebar$search$fr search = Translations$sidebar$search$fr._(_root);
	@override late final Translations$sidebar$deleteConfirmation$fr deleteConfirmation = Translations$sidebar$deleteConfirmation$fr._(_root);
	@override late final Translations$sidebar$zones$fr zones = Translations$sidebar$zones$fr._(_root);
	@override late final Translations$sidebar$panel$fr panel = Translations$sidebar$panel$fr._(_root);
	@override late final Translations$sidebar$workspace$fr workspace = Translations$sidebar$workspace$fr._(_root);
	@override late final Translations$sidebar$recent$fr recent = Translations$sidebar$recent$fr._(_root);
	@override late final Translations$sidebar$tabs$fr tabs = Translations$sidebar$tabs$fr._(_root);
}

// Path: tasks
class Translations$tasks$fr extends Translations$tasks$en {
	Translations$tasks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$fr notConfigured = Translations$tasks$notConfigured$fr._(_root);
	@override late final Translations$tasks$gettingStarted$fr gettingStarted = Translations$tasks$gettingStarted$fr._(_root);
	@override late final Translations$tasks$setupModal$fr setupModal = Translations$tasks$setupModal$fr._(_root);
	@override late final Translations$tasks$helpGuide$fr helpGuide = Translations$tasks$helpGuide$fr._(_root);
	@override late final Translations$tasks$search$fr search = Translations$tasks$search$fr._(_root);
	@override late final Translations$tasks$filters$fr filters = Translations$tasks$filters$fr._(_root);
	@override late final Translations$tasks$sort$fr sort = Translations$tasks$sort$fr._(_root);
	@override late final Translations$tasks$views$fr views = Translations$tasks$views$fr._(_root);
	@override late final Translations$tasks$kanban$fr kanban = Translations$tasks$kanban$fr._(_root);
	@override late final Translations$tasks$buttons$fr buttons = Translations$tasks$buttons$fr._(_root);
	@override late final Translations$tasks$prd$fr prd = Translations$tasks$prd$fr._(_root);
	@override late final Translations$tasks$statuses$fr statuses = Translations$tasks$statuses$fr._(_root);
	@override late final Translations$tasks$priorities$fr priorities = Translations$tasks$priorities$fr._(_root);
	@override late final Translations$tasks$noMatchingTasks$fr noMatchingTasks = Translations$tasks$noMatchingTasks$fr._(_root);
	@override late final Translations$tasks$board$fr board = Translations$tasks$board$fr._(_root);
	@override late final Translations$tasks$card$fr card = Translations$tasks$card$fr._(_root);
	@override late final Translations$tasks$createTask$fr createTask = Translations$tasks$createTask$fr._(_root);
	@override late final Translations$tasks$list$fr list = Translations$tasks$list$fr._(_root);
	@override late final Translations$tasks$nextTask$fr nextTask = Translations$tasks$nextTask$fr._(_root);
	@override late final Translations$tasks$taskDetail$fr taskDetail = Translations$tasks$taskDetail$fr._(_root);
	@override late final Translations$tasks$toasts$fr toasts = Translations$tasks$toasts$fr._(_root);
}

// Path: knowledge
class Translations$knowledge$fr extends Translations$knowledge$en {
	Translations$knowledge$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Connaissances';
	@override late final Translations$knowledge$tabs$fr tabs = Translations$knowledge$tabs$fr._(_root);
	@override late final Translations$knowledge$common$fr common = Translations$knowledge$common$fr._(_root);
	@override late final Translations$knowledge$actions$fr actions = Translations$knowledge$actions$fr._(_root);
	@override late final Translations$knowledge$dialog$fr dialog = Translations$knowledge$dialog$fr._(_root);
	@override late final Translations$knowledge$fields$fr fields = Translations$knowledge$fields$fr._(_root);
	@override late final Translations$knowledge$dashboard$fr dashboard = Translations$knowledge$dashboard$fr._(_root);
	@override late final Translations$knowledge$empty$fr empty = Translations$knowledge$empty$fr._(_root);
	@override late final Translations$knowledge$history$fr history = Translations$knowledge$history$fr._(_root);
	@override late final Translations$knowledge$priorities$fr priorities = Translations$knowledge$priorities$fr._(_root);
	@override late final Translations$knowledge$search$fr search = Translations$knowledge$search$fr._(_root);
	@override late final Translations$knowledge$links$fr links = Translations$knowledge$links$fr._(_root);
	@override late final Translations$knowledge$tags$fr tags = Translations$knowledge$tags$fr._(_root);
	@override late final Translations$knowledge$contextBudget$fr contextBudget = Translations$knowledge$contextBudget$fr._(_root);
	@override late final Translations$knowledge$critical$fr critical = Translations$knowledge$critical$fr._(_root);
	@override late final Translations$knowledge$errors$fr errors = Translations$knowledge$errors$fr._(_root);
	@override late final Translations$knowledge$graph$fr graph = Translations$knowledge$graph$fr._(_root);
	@override late final Translations$knowledge$importAll$fr importAll = Translations$knowledge$importAll$fr._(_root);
	@override late final Translations$knowledge$importSkills$fr importSkills = Translations$knowledge$importSkills$fr._(_root);
	@override late final Translations$knowledge$linkOptions$fr linkOptions = Translations$knowledge$linkOptions$fr._(_root);
	@override late final Translations$knowledge$migrate$fr migrate = Translations$knowledge$migrate$fr._(_root);
}

// Path: skills
class Translations$skills$fr extends Translations$skills$en {
	Translations$skills$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$skills$addDialog$fr addDialog = Translations$skills$addDialog$fr._(_root);
	@override String deleteSkill({required Object name}) => 'Supprimer ${name}';
	@override late final Translations$skills$empty$fr empty = Translations$skills$empty$fr._(_root);
	@override late final Translations$skills$errors$fr errors = Translations$skills$errors$fr._(_root);
	@override late final Translations$skills$moveDialog$fr moveDialog = Translations$skills$moveDialog$fr._(_root);
	@override String moveSkill({required Object name}) => 'Déplacer ${name}';
	@override String get projectLabel => 'Projet';
	@override late final Translations$skills$scopes$fr scopes = Translations$skills$scopes$fr._(_root);
	@override late final Translations$skills$screen$fr screen = Translations$skills$screen$fr._(_root);
}

// Path: mcp
class Translations$mcp$fr extends Translations$mcp$en {
	Translations$mcp$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$fr form = Translations$mcp$form$fr._(_root);
	@override late final Translations$mcp$install$fr install = Translations$mcp$install$fr._(_root);
	@override late final Translations$mcp$servers$fr servers = Translations$mcp$servers$fr._(_root);
	@override late final Translations$mcp$team$fr team = Translations$mcp$team$fr._(_root);
	@override late final Translations$mcp$tokens$fr tokens = Translations$mcp$tokens$fr._(_root);
}

// Path: terminal
class Translations$terminal$fr extends Translations$terminal$en {
	Translations$terminal$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$actions$fr actions = Translations$terminal$actions$fr._(_root);
	@override late final Translations$terminal$authUrl$fr authUrl = Translations$terminal$authUrl$fr._(_root);
	@override late final Translations$terminal$errors$fr errors = Translations$terminal$errors$fr._(_root);
	@override late final Translations$terminal$fileLink$fr fileLink = Translations$terminal$fileLink$fr._(_root);
	@override late final Translations$terminal$paste$fr paste = Translations$terminal$paste$fr._(_root);
	@override late final Translations$terminal$shortcuts$fr shortcuts = Translations$terminal$shortcuts$fr._(_root);
	@override late final Translations$terminal$tabs$fr tabs = Translations$terminal$tabs$fr._(_root);
}

// Path: worktrees
class Translations$worktrees$fr extends Translations$worktrees$en {
	Translations$worktrees$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get branchHint => 'Nom de la nouvelle branche (ex. : feature/login)';
	@override String branchingOff({required Object branch}) => 'Création depuis ${branch}';
	@override String get cleanupDescription => 'Supprimer le worktree et sa branche une fois fusionnée';
	@override String get created => 'Worktree créé';
	@override String get deleteBranchLabel => 'Supprimer aussi la branche';
	@override String dirtyWarning({required Object count}) => 'Attention : ce worktree a ${count} modification(s) non validée(s) qui seront perdues.';
	@override String get emptyDescription => 'Créez un worktree pour isoler le travail sur une fonctionnalité ou l’exécution des agents.';
	@override String get emptyTitle => 'Aucun worktree trouvé';
	@override String get forceRemoveLabel => 'Forcer la suppression (ignorer les modifications)';
	@override String headDetachedAt({required Object sha}) => 'HEAD détaché sur ${sha}';
	@override String get mainBadge => 'main';
	@override String mergeDescription({required Object branch}) => 'Fusionner les modifications dans ${branch}.';
	@override String mergeTitle({required Object branch}) => 'Fusionner ${branch}';
	@override String merged({required Object branch}) => 'Worktree fusionné dans ${branch}';
	@override String opened({required Object branch}) => 'Worktree ouvert : ${branch}';
	@override String get portHint => 'Port d’exécution (optionnel, ex. : 3000)';
	@override String get removeDescription => 'Cela supprime le dossier du worktree. Les projets liés seront archivés.';
	@override String removeTitle({required Object branch}) => 'Supprimer le worktree ${branch} ?';
	@override String get removed => 'Worktree supprimé';
	@override String get runButton => 'Exécuter';
	@override String get runHint => 'Commande d’exécution (ex. : npm run dev)';
	@override String get runRunning => 'en cours';
	@override String runRunningWithPort({required Object port}) => 'en cours :${port}';
	@override String get scripts => 'Scripts';
	@override String get scriptsSaved => 'Configuration des scripts enregistrée';
	@override String get serverLabel => 'Serveur : ';
	@override String get setupHint => 'Commande de configuration (ex. : npm install)';
	@override String get setupLabel => 'Configuration : ';
	@override String get squashDescription => 'Combiner tous les commits en un seul commit';
	@override String get stopButton => 'Arrêter';
}

// Path: quota
class Translations$quota$fr extends Translations$quota$en {
	Translations$quota$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$agents$fr agents = Translations$quota$agents$fr._(_root);
	@override late final Translations$quota$chart$fr chart = Translations$quota$chart$fr._(_root);
	@override late final Translations$quota$config$fr config = Translations$quota$config$fr._(_root);
	@override late final Translations$quota$overview$fr overview = Translations$quota$overview$fr._(_root);
	@override late final Translations$quota$section$fr section = Translations$quota$section$fr._(_root);
}

// Path: scheduler
class Translations$scheduler$fr extends Translations$scheduler$en {
	Translations$scheduler$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Vérification…';
	@override String get cronHint => 'Cron (min heure jour mois jour de la semaine) — ex. : 0 9 * * *';
	@override String deleteMessage({required Object id}) => 'Cela supprime la tâche récurrente ${id}. Les sessions existantes sont conservées.';
	@override String get deleteTitle => 'Supprimer la planification ?';
	@override String get editTitle => 'Modifier la planification';
	@override String get newLabel => 'Nouveau';
	@override String nextIn({required Object time}) => 'prochaine dans ${time}';
	@override String get promptHint => 'Invite pour l’agent';
	@override String get runs => 'Exécutions';
	@override String session({required Object id}) => 'session ${id}';
	@override String get worktree => 'worktree';
}

// Path: notifications
class Translations$notifications$fr extends Translations$notifications$en {
	Translations$notifications$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$fr errors = Translations$notifications$errors$fr._(_root);
}

// Path: serverConnect
class Translations$serverConnect$fr extends Translations$serverConnect$en {
	Translations$serverConnect$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get connect => 'Se connecter';
	@override String get connecting => 'Connexion…';
	@override String get changeServer => 'Changer de serveur';
	@override String connectionFailed({required Object error}) => 'Échec de la connexion (${error})';
	@override String get enterUrl => 'Saisir une URL de serveur';
	@override late final Translations$serverConnect$local$fr local = Translations$serverConnect$local$fr._(_root);
	@override String get subtitle => 'Connectez-vous à votre serveur DDAgent';
}

// Path: voice
class Translations$voice$fr extends Translations$voice$en {
	Translations$voice$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get apiKeySaved => 'Clé API (enregistrée, saisissez pour remplacer)';
	@override String get preview => 'Aperçu';
	@override String get saveFailed => 'Échec de l’enregistrement de la configuration STT';
	@override String get settingsSaved => 'Paramètres de saisie vocale enregistrés';
}

// Path: sharedContext
class Translations$sharedContext$fr extends Translations$sharedContext$en {
	Translations$sharedContext$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notes partagées';
}

// Path: collab
class Translations$collab$fr extends Translations$collab$en {
	Translations$collab$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get copyToken => 'Copier le token';
	@override String get createInvite => 'Créer une invitation';
	@override String get invite => 'Inviter';
	@override String get inviteTeammate => 'Inviter un coéquipier';
	@override late final Translations$collab$roles$fr roles = Translations$collab$roles$fr._(_root);
	@override String get shareTokenHint => 'Partagez ce token d’invitation — il n’est affiché qu’une fois et expire dans 72 h :';
	@override String get team => 'Équipe';
}

// Path: browser
class Translations$browser$fr extends Translations$browser$en {
	Translations$browser$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Navigateur de l’agent';
	@override String get viewError => 'Erreur d’affichage du navigateur';
	@override String get web => 'Web';
}

// Path: projects
class Translations$projects$fr extends Translations$projects$en {
	Translations$projects$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get archive => 'Archiver';
	@override String archivedSection({required Object count}) => 'Archivés (${count})';
	@override String get clone => 'Cloner';
	@override String get cloneFailed => 'Échec du clonage';
	@override String get cloneFinished => 'Clonage terminé. Actualisation de la liste des projets…';
	@override String get cloneRepository => 'Cloner le dépôt';
	@override String get deletePermanently => 'Supprimer définitivement';
	@override String deleteProjectMessage({required Object name}) => 'Supprime définitivement « ${name} », y compris toutes les sessions et l’historique stocké (effacement JSONL). Cette action est irréversible.';
	@override String get deleteProjectTitle => 'Supprimer le projet ?';
	@override String get destinationPath => 'Chemin de destination';
	@override String get destinationPathRequired => 'Le chemin de destination est requis';
	@override String get displayNameOptional => 'Nom d’affichage (optionnel)';
	@override String get failedToLoadTokens => 'Échec du chargement des tokens GitHub';
	@override String get githubTokenOptional => 'Token GitHub (optionnel)';
	@override String get newer => 'Plus récent';
	@override String get older => 'Plus ancien';
	@override String get projectArchived => 'Projet archivé';
	@override String get projectDeleted => 'Projet supprimé';
	@override String get projectRenamed => 'Projet renommé';
	@override String get projectRestored => 'Projet restauré';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get repositoryCloned => 'Dépôt cloné';
	@override String get repositoryUrlRequired => 'L’URL du dépôt est requise';
	@override String get restore => 'Restaurer';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} session',
		other: '${count} sessions',
	);
	@override String get unknown => 'Inconnu';
	@override String usingStoredToken({required Object name}) => 'Utilisation du token enregistré : ${name}';
}

// Path: sessions
class Translations$sessions$fr extends Translations$sessions$en {
	Translations$sessions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$sessions$activity$fr activity = Translations$sessions$activity$fr._(_root);
	@override late final Translations$sessions$age$fr age = Translations$sessions$age$fr._(_root);
	@override String get archive => 'Archiver';
	@override String get archivedSessions => 'Sessions archivées';
	@override String get autoOrchestrator => 'Auto (orchestrateur)';
	@override String get compareWith => 'Comparer avec…';
	@override String createFailed({required Object error}) => 'Échec de la création de la session : ${error}';
	@override String deleteSessionMessage({required Object name}) => 'Supprime « ${name} » et sa transcription. Cette action est irréversible.';
	@override String get newSessionProvider => 'Nouvelle session — fournisseur';
	@override String get noRecentSessions => 'Aucune session récente';
	@override String get noSessions => 'Aucune session';
	@override String get projectPath => 'Chemin du projet';
	@override String get rename => 'Renommer';
	@override late final Translations$sessions$toasts$fr toasts = Translations$sessions$toasts$fr._(_root);
}

// Path: git
class Translations$git$fr extends Translations$git$en {
	Translations$git$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get aiButton => '✦ IA';
	@override late final Translations$git$checkpoints$fr checkpoints = Translations$git$checkpoints$fr._(_root);
	@override String get commitCreated => 'Commit créé';
	@override String get commitMessage => 'Message de commit';
	@override String get deleteFile => 'Supprimer le fichier';
	@override String get hunkStage => '+ Section';
	@override String get hunkUnstage => '− Section';
	@override String get largeDiff => 'Aperçu de diff volumineux : le rendu est limité pour garder l’onglet réactif.';
	@override String loadDiffFailed({required Object error}) => 'Échec du chargement du diff : ${error}';
	@override String get noBranch => 'aucune branche';
	@override String get noDiff => 'Aucun diff disponible';
	@override String get selectProject => 'Sélectionnez un projet';
	@override String get splitDiff => 'Diff côte à côte';
	@override String get stageHunk => 'Indexer cette section';
	@override String get stagedChanges => 'Modifications indexées';
	@override String get statusStaged => 'Indexé';
	@override String get switchBranch => 'Changer de branche';
	@override String get unifiedDiff => 'Diff unifié';
	@override String get unstageHunk => 'Retirer cette section de l’index';
}

// Path: kanban
class Translations$kanban$fr extends Translations$kanban$en {
	Translations$kanban$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$fr card = Translations$kanban$card$fr._(_root);
	@override late final Translations$kanban$comments$fr comments = Translations$kanban$comments$fr._(_root);
	@override late final Translations$kanban$details$fr details = Translations$kanban$details$fr._(_root);
	@override late final Translations$kanban$dialog$fr dialog = Translations$kanban$dialog$fr._(_root);
	@override late final Translations$kanban$empty$fr empty = Translations$kanban$empty$fr._(_root);
	@override String get saveFailed => 'Échec de l’enregistrement de la carte';
	@override late final Translations$kanban$time$fr time = Translations$kanban$time$fr._(_root);
}

// Path: onboarding
class Translations$onboarding$fr extends Translations$onboarding$en {
	Translations$onboarding$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$onboarding$agents$fr agents = Translations$onboarding$agents$fr._(_root);
	@override String get completeSetup => 'Terminer la configuration';
	@override late final Translations$onboarding$errors$fr errors = Translations$onboarding$errors$fr._(_root);
	@override String get gitHint => 'Utilisé pour les commits créés par les sessions DDAgent.';
	@override late final Translations$onboarding$mcp$fr mcp = Translations$onboarding$mcp$fr._(_root);
}

// Path: fileTree
class Translations$fileTree$fr extends Translations$fileTree$en {
	Translations$fileTree$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get browseServerFilesystem => 'Parcourir le système de fichiers du serveur';
	@override String get chooseFolder => 'Choisir un dossier';
	@override String get copyContents => 'Copier le contenu';
	@override String get noFiles => 'Aucun fichier';
	@override late final Translations$fileTree$search$fr search = Translations$fileTree$search$fr._(_root);
	@override late final Translations$fileTree$titles$fr titles = Translations$fileTree$titles$fr._(_root);
	@override String get uploadHere => 'Téléverser ici';
	@override String get uploadTo => 'Téléverser vers';
	@override String uploadedCount({required Object count}) => '${count} fichier(s) téléversé(s)';
	@override String get newName => 'Nouveau nom';
	@override String notRegisteredProject({required Object path}) => 'Projet non enregistré : ${path}';
	@override String get showGitignoredFiles => 'Afficher les fichiers ignorés par git';
	@override String get hideGitignoredFiles => 'Masquer les fichiers ignorés par git';
	@override String get downloadUnsupportedOnWeb => 'Téléchargement non pris en charge sur le web';
	@override String get saveToPath => 'Enregistrer vers un chemin';
	@override String savedTo({required Object path}) => 'Enregistré dans ${path}';
}

// Path: workspace
class Translations$workspace$fr extends Translations$workspace$en {
	Translations$workspace$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get archivedWorkspaceName => 'Archivé';
	@override String get closePane => 'Fermer le volet';
	@override String get closeSearch => 'Fermer la recherche';
	@override String get deleteSessionNotice => 'Cela supprime définitivement la session et sa transcription. Cette action est irréversible.';
	@override String get exportChat => 'Exporter la discussion';
	@override String get jumpToSession => 'Aller à la session…';
	@override String get newChatProvider => 'Nouvelle discussion — fournisseur';
	@override String get nextMatch => 'Résultat suivant';
	@override String get previousMatch => 'Résultat précédent';
	@override String get searchTranscript => 'Rechercher dans la transcription';
	@override String sendTo({required Object count}) => 'Envoyer à ${count}';
	@override String accountWithLabel({required Object label}) => 'Par défaut · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Terminez l\'exécution avant de changer d\'espace de travail';
	@override String get restored => 'Espace de travail restauré';
	@override String get maximizePane => 'Agrandir le volet';
	@override String get restorePanes => 'Restaurer les volets';
	@override String get reviewChangedFiles => 'Examiner les fichiers modifiés';
}

// Path: auth.login
class Translations$auth$login$fr extends Translations$auth$login$en {
	Translations$auth$login$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bon retour';
	@override String get description => 'Connectez-vous à votre compte DDAgent auto-hébergé';
	@override String get username => 'Nom d\'utilisateur';
	@override String get password => 'Mot de passe';
	@override String get submit => 'Se connecter';
	@override String get loading => 'Connexion en cours...';
	@override late final Translations$auth$login$errors$fr errors = Translations$auth$login$errors$fr._(_root);
	@override late final Translations$auth$login$placeholders$fr placeholders = Translations$auth$login$placeholders$fr._(_root);
}

// Path: auth.register
class Translations$auth$register$fr extends Translations$auth$register$en {
	Translations$auth$register$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Créer un compte';
	@override String get username => 'Nom d\'utilisateur';
	@override String get password => 'Mot de passe';
	@override String get confirmPassword => 'Confirmer le mot de passe';
	@override String get submit => 'Créer le compte';
	@override String get loading => 'Création du compte...';
	@override late final Translations$auth$register$errors$fr errors = Translations$auth$register$errors$fr._(_root);
}

// Path: auth.logout
class Translations$auth$logout$fr extends Translations$auth$logout$en {
	Translations$auth$logout$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Se déconnecter';
	@override String get confirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';
	@override String get button => 'Se déconnecter';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$fr extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copier';
	@override String get copied => 'Copié';
	@override String get copyCode => 'Copier le code';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$fr extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copier le message';
	@override String get copied => 'Message copié';
	@override String get failed => 'Échec de la copie';
	@override String get selectFormat => 'Sélectionner le format de copie';
	@override String get copyAsMarkdown => 'Copier en markdown';
	@override String get copyAsText => 'Copier en texte brut';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$fr extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => 'Erreur';
	@override String get tool => 'Outil';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
}

// Path: chat.tools
class Translations$chat$tools$fr extends Translations$chat$tools$en {
	Translations$chat$tools$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Paramètres de l\'outil';
	@override String get error => 'Erreur de l\'outil';
	@override String get result => 'Résultat de l\'outil';
	@override String get viewParams => 'Voir les paramètres d\'entrée';
	@override String get viewRawParams => 'Voir les paramètres bruts';
	@override String get viewDiff => 'Voir les différences pour';
	@override String get creatingFile => 'Création du fichier :';
	@override String get updatingTodo => 'Mise à jour de la liste de tâches';
	@override String get read => 'Lire';
	@override String get readFile => 'Lire le fichier';
	@override String get updateTodo => 'Mettre à jour la liste de tâches';
	@override String get readTodo => 'Lire la liste de tâches';
	@override String get searchResults => 'résultats';
	@override String get todoReadLabel => 'TodoRead : lecture de la liste de tâches';
}

// Path: chat.search
class Translations$chat$search$fr extends Translations$chat$search$en {
	Translations$chat$search$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '${count} ${type} trouvé(s)';
	@override String get file => 'fichier';
	@override String get files => 'fichiers';
	@override String get pattern => 'motif :';
	@override String get kIn => 'dans :';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$fr extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Fichier mis à jour avec succès';
	@override String get created => 'Fichier créé avec succès';
	@override String get written => 'Fichier écrit avec succès';
	@override String get diff => 'Diff';
	@override String get newFile => 'Nouveau fichier';
	@override String get viewContent => 'Voir le contenu du fichier';
	@override String viewFullOutput({required Object count}) => 'Voir la sortie complète (${count} caractères)';
	@override String get contentDisplayed => 'Le contenu du fichier est affiché dans la vue diff ci-dessus';
}

// Path: chat.interactive
class Translations$chat$interactive$fr extends Translations$chat$interactive$en {
	Translations$chat$interactive$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite interactive';
	@override String get waiting => 'En attente de votre réponse dans le CLI';
	@override String get instruction => 'Veuillez sélectionner une option dans votre terminal où Claude s\'exécute.';
	@override String selectedOption({required Object number}) => '✓ Claude a sélectionné l\'option ${number}';
	@override String get instructionDetail => 'Dans le CLI, vous sélectionneriez cette option de manière interactive avec les touches fléchées ou en tapant le numéro.';
}

// Path: chat.thinking
class Translations$chat$thinking$fr extends Translations$chat$thinking$en {
	Translations$chat$thinking$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Réflexion...';
	@override String get emoji => '💭 Réflexion...';
}

// Path: chat.json
class Translations$chat$json$fr extends Translations$chat$json$en {
	Translations$chat$json$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get response => 'Réponse JSON';
}

// Path: chat.permissions
class Translations$chat$permissions$fr extends Translations$chat$permissions$en {
	Translations$chat$permissions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => 'Autoriser ${tool}';
	@override String get added => 'Permission ajoutée';
	@override String addTo({required Object entry}) => 'Ajoute ${entry} aux outils autorisés.';
	@override String get retry => 'Permission enregistrée. Relancez la requête pour utiliser l\'outil.';
	@override String get error => 'Impossible de mettre à jour les permissions. Veuillez réessayer.';
	@override String get openSettings => 'Ouvrir les paramètres';
	@override String get allow => 'Autoriser';
	@override String allowAll({required Object count}) => 'Tout autoriser (${count})';
	@override String get allowWithChanges => 'Autoriser avec modifications';
	@override String get always => 'Toujours';
	@override String get deny => 'Refuser';
	@override String get editAndAllow => 'Modifier et autoriser';
	@override String get editInput => 'Modifier l’entrée';
	@override String get invalidJson => 'JSON invalide';
	@override String get reject => 'Rejeter';
}

// Path: chat.todo
class Translations$chat$todo$fr extends Translations$chat$todo$en {
	Translations$chat$todo$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get updated => 'La liste de tâches a été mise à jour avec succès';
	@override String get current => 'Liste de tâches actuelle';
}

// Path: chat.plan
class Translations$chat$plan$fr extends Translations$chat$plan$en {
	Translations$chat$plan$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Voir le plan d\'implémentation';
	@override String get title => 'Plan d\'implémentation';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$fr extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Limite d\'utilisation Claude atteinte. Votre limite sera réinitialisée à **${time} ${timezone}** - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$fr extends Translations$chat$codex$en {
	Translations$chat$codex$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Mode de permission';
	@override late final Translations$chat$codex$modes$fr modes = Translations$chat$codex$modes$fr._(_root);
	@override late final Translations$chat$codex$descriptions$fr descriptions = Translations$chat$codex$descriptions$fr._(_root);
	@override String get technicalDetails => 'Détails techniques';
}

// Path: chat.input
class Translations$chat$input$fr extends Translations$chat$input$en {
	Translations$chat$input$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Tapez / pour les commandes, @ pour les fichiers, ou posez une question à ${provider}...';
	@override String get placeholderDefault => 'Tapez votre message...';
	@override String get disabled => 'Saisie désactivée';
	@override String get attachFiles => 'Joindre des fichiers';
	@override String get attachImages => 'Joindre des images';
	@override String get send => 'Envoyer';
	@override String get stop => 'Arrêter';
	@override late final Translations$chat$input$hintText$fr hintText = Translations$chat$input$hintText$fr._(_root);
	@override String get clickToChangeMode => 'Cliquez pour changer le mode de permission';
	@override String get showAllCommands => 'Afficher toutes les commandes';
	@override String get clearInput => 'Effacer la saisie';
	@override String get scrollToBottom => 'Défiler vers le bas';
	@override String get attachFilesDesc => 'Téléverser des photos, fichiers ou documents';
	@override String get takePhoto => 'Prendre une photo';
	@override String get takePhotoDesc => 'Utiliser l’appareil photo pour capturer une photo';
	@override String get moreTools => 'Plus d’outils';
	@override String get commandsDesc => 'Explorer les raccourcis et commandes';
	@override String get clearInputDesc => 'Ignorer le texte actuel';
	@override String get newMessage => 'Nouveau message';
	@override String get newMessages => 'Nouveaux messages';
	@override late final Translations$chat$input$queue$fr queue = Translations$chat$input$queue$fr._(_root);
	@override String get autoContinueTasks => 'Continuité auto';
	@override String get autoContinueTasksTooltip => 'Activer pour laisser Devin passer automatiquement à la tâche Task Master suivante';
	@override late final Translations$chat$input$offlineQueue$fr offlineQueue = Translations$chat$input$offlineQueue$fr._(_root);
	@override String cameraUnavailable({required Object error}) => 'Appareil photo indisponible : ${error}';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$fr extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Choisissez votre assistant IA';
	@override String get description => 'Sélectionnez un fournisseur pour démarrer une nouvelle conversation';
	@override String get selectModel => 'Sélectionner un modèle';
	@override late final Translations$chat$providerSelection$providerInfo$fr providerInfo = Translations$chat$providerSelection$providerInfo$fr._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$fr readyPrompt = Translations$chat$providerSelection$readyPrompt$fr._(_root);
	@override String pressToSearch({required Object shortcut}) => 'Appuyez sur <kbd>${shortcut}</kbd> pour rechercher sessions, fichiers et commits';
	@override String get workspace => 'Espace de travail';
	@override String get noWorkspace => 'Aucun';
	@override String get clickToChangeWorkspace => 'Cliquer pour changer d’espace de travail';
	@override String get chooseWorkspace => 'Choisir un espace de travail';
	@override String get searchWorkspaces => 'Rechercher des espaces de travail...';
	@override String get noWorkspacesFound => 'Aucun espace de travail trouvé.';
	@override String get all => 'Tous';
	@override String get free => 'Gratuit';
	@override String get noModelsFound => 'Aucun modèle trouvé.';
	@override String get paid => 'Payant';
	@override String get searchModels => 'Rechercher des modèles...';
	@override String get addModel => 'Ajouter un modèle';
	@override String get chooseModel => 'Choisir un modèle';
	@override String get chooseModelDescription => 'Modèles intégrés et personnalisés dans une seule liste';
	@override String get clickToChange => 'Cliquer pour changer de modèle';
	@override String get favorites => 'Favoris';
	@override String get loadingModels => 'Chargement des modèles…';
	@override String get manageModels => 'Gérer les modèles';
	@override String get refresh => 'Actualiser les modèles';
}

// Path: chat.session
class Translations$chat$session$fr extends Translations$chat$session$en {
	Translations$chat$session$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$fr kContinue = Translations$chat$session$kContinue$fr._(_root);
	@override late final Translations$chat$session$loading$fr loading = Translations$chat$session$loading$fr._(_root);
	@override late final Translations$chat$session$messages$fr messages = Translations$chat$session$messages$fr._(_root);
	@override String get deleteConfirm => 'Cela supprime définitivement la session et sa transcription. Cette action est irréversible.';
	@override String get finishRunBeforeWorkspaceChange => 'Terminez l\'exécution avant de changer d\'espace de travail';
}

// Path: chat.shell
class Translations$chat$shell$fr extends Translations$chat$shell$en {
	Translations$chat$shell$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$fr selectProject = Translations$chat$shell$selectProject$fr._(_root);
	@override late final Translations$chat$shell$status$fr status = Translations$chat$shell$status$fr._(_root);
	@override late final Translations$chat$shell$actions$fr actions = Translations$chat$shell$actions$fr._(_root);
	@override String get loading => 'Chargement du terminal...';
	@override String get connecting => 'Connexion au shell...';
	@override String get startSession => 'Démarrer une nouvelle session Claude';
	@override String resumeSession({required Object displayName}) => 'Reprendre la session : ${displayName}...';
	@override String runCommand({required Object command, required Object projectName}) => 'Exécuter ${command} dans ${projectName}';
	@override String startCli({required Object projectName}) => 'Démarrage du CLI Claude dans ${projectName}';
	@override String get defaultCommand => 'commande';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$fr extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$fr actions = Translations$chat$claudeStatus$actions$fr._(_root);
	@override late final Translations$chat$claudeStatus$state$fr state = Translations$chat$claudeStatus$state$fr._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$fr elapsed = Translations$chat$claudeStatus$elapsed$fr._(_root);
	@override late final Translations$chat$claudeStatus$controls$fr controls = Translations$chat$claudeStatus$controls$fr._(_root);
	@override late final Translations$chat$claudeStatus$providers$fr providers = Translations$chat$claudeStatus$providers$fr._(_root);
	@override String get stop => 'Arrêter';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} tâche en arrière-plan en cours',
		other: '${count} tâches en arrière-plan en cours',
	);
	@override String get backgroundTasksTitle => 'En arrière-plan';
	@override String get backgroundTaskUnnamed => 'Tâche sans nom';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$fr extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'Sélectionnez un projet pour commencer à chatter avec ${provider}';
}

// Path: chat.tasks
class Translations$chat$tasks$fr extends Translations$chat$tasks$en {
	Translations$chat$tasks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Commencer la prochaine tâche';
}

// Path: chat.voice
class Translations$chat$voice$fr extends Translations$chat$voice$en {
	Translations$chat$voice$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Lire les réponses à voix haute';
	@override String get autoReadOn => 'Lecture des réponses : activée';
	@override String get autoReadOff => 'Lecture des réponses : désactivée';
	@override String get autoReadVoice => 'Voix de lecture';
	@override String get autoReadVoiceAuto => 'Voix automatique';
	@override String get autoReadPreview => 'Voici comment les réponses seront lues.';
	@override String get speakMessage => 'Lire à voix haute';
	@override String get stopSpeaking => 'Arrêter la lecture';
}

// Path: chat.composer
class Translations$chat$composer$fr extends Translations$chat$composer$en {
	Translations$chat$composer$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Outils et actions';
	@override String get toolsAndActionsDesc => 'Outils et contrôles du composeur de chat';
	@override String get reasoning => 'Raisonnement';
	@override String get model => 'Modèle';
	@override String get effortDefault => 'Par défaut';
	@override String get loadingModels => 'Chargement des modèles…';
	@override String get modelMenu => 'Choisir le modèle et l’effort de raisonnement';
	@override String permissionHeading({required Object provider}) => 'Comment les actions de ${provider} doivent-elles être approuvées ?';
	@override String get favorites => 'Favoris';
}

// Path: chat.splitSession
class Translations$chat$splitSession$fr extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Fractionner la session';
	@override String get close => 'Fermer la session fractionnée';
	@override String get selectSession => 'Sélectionner une session à comparer';
	@override String get noOtherSessions => 'Aucune autre session disponible';
	@override String get newSessionOption => '+ Nouvelle session en vue fractionnée';
	@override String currentProjectGroup({required Object name}) => 'Projet actuel (${name})';
	@override String get otherProjectsGroup => 'Autres projets';
	@override String get recentSessionsGroup => 'Sessions récentes';
	@override String get startNewSession => 'Démarrer une nouvelle session en vue fractionnée';
	@override String get selectFromList => 'Sélectionner une session dans la liste des sessions existantes';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$fr extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sélectionner une session';
	@override String get searchPlaceholder => 'Rechercher des sessions...';
	@override String get clearSearch => 'Effacer la recherche';
	@override String get newChat => '+ Nouvelle discussion';
	@override String get archivedToggle => 'Archivées';
	@override String get changeSession => 'Changer de session';
	@override String get archivedLoading => 'Chargement des sessions archivées...';
	@override String get archivedError => 'Impossible de charger les sessions archivées';
	@override String get archivedEmpty => 'Aucune session archivée';
	@override String get archivedProjectOnly => 'Espace de travail archivé — restaurez-le pour voir ses sessions.';
	@override String get emptySearch => 'Aucune session ne correspond à votre recherche';
	@override String get restore => 'Restaurer';
	@override String get restoreSession => 'Restaurer la session';
	@override String get restoreProject => 'Restaurer l’espace de travail';
	@override String get restoreSessionFailed => 'Échec de la restauration de la session. Veuillez réessayer.';
	@override String get restoreProjectFailed => 'Échec de la restauration de l’espace de travail. Veuillez réessayer.';
	@override String get archiveFailed => 'Échec de l’archivage de la session. Veuillez réessayer.';
	@override String get deleteFailed => 'Échec de la suppression de la session. Veuillez réessayer.';
	@override String get running => 'Session en cours';
	@override String get unread => 'Non lu — terminé avec une nouvelle sortie';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$fr extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Ajouter un volet de discussion';
	@override String get addBrowser => 'Ajouter un volet navigateur';
	@override String get addTerminal => 'Ajouter un volet terminal';
	@override String get overview => 'Afficher tous les volets';
	@override String get exitFocusMode => 'Quitter le mode focus (Ctrl+Maj+F)';
	@override String get focusMode => 'Mode focus (Ctrl+Maj+F)';
	@override String get browseSessions => 'Ouvrir la liste des sessions';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$fr extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aperçu des volets fractionnés';
	@override String count({required Object count}) => '${count} volets';
	@override String get close => 'Fermer l’aperçu';
	@override String get question => 'QUESTION — saisie requise';
	@override String get processing => 'TRAITEMENT';
	@override String get idle => 'Inactif';
	@override String get active => 'Actif';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$fr extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} a besoin de votre réponse';
	@override String get answerHint => 'Tapez votre réponse…';
	@override String get other => 'Autre…';
	@override String get skip => 'Ignorer';
}

// Path: chat.attachments
class Translations$chat$attachments$fr extends Translations$chat$attachments$en {
	Translations$chat$attachments$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Échec du téléchargement — cliquer pour réessayer';
	@override String get fileAttachment => 'Pièce jointe';
	@override String download({required Object name}) => 'Télécharger ${name}';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$fr extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Création de l’instantané…';
	@override String get revertChanges => 'Restaurer les fichiers au dernier checkpoint';
	@override String get undo => 'Annuler le checkpoint';
	@override String get beforeAiTurn => 'avant le tour de l’IA';
}

// Path: chat.common
class Translations$chat$common$fr extends Translations$chat$common$en {
	Translations$chat$common$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get close => 'Fermer';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$fr extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Tâche';
	@override String get saved => 'Enregistré';
	@override String get saving => 'Enregistrement...';
	@override String get taskShort => 'TÂCHE';
	@override String get addToTask => 'Ajouter à TaskMaster';
	@override String get added => 'Ajouté à TaskMaster';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$fr extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Voir la consommation de tokens de la session';
	@override String get title => 'Utilisation des tokens';
}

// Path: chat.tool
class Translations$chat$tool$fr extends Translations$chat$tool$en {
	Translations$chat$tool$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(pas encore de sortie — l’outil a renvoyé un résultat vide)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$fr extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Limites d\'abonnement';
	@override String get noData => 'Aucune donnée d\'abonnement pour ce modèle';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$fr extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get processing => 'En cours…';
	@override String get switchSession => 'Changer de session';
}

// Path: chat.broadcast
class Translations$chat$broadcast$fr extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => 'Sélectionner les orchestrateurs';
	@override String get orchestratorsOnly => 'Orchestrateurs uniquement';
	@override String get noOrchestrators => 'Aucune session d\'orchestrateur disponible';
}

// Path: chat.changes
class Translations$chat$changes$fr extends Translations$chat$changes$en {
	Translations$chat$changes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Aucune modification de fichier';
	@override String get failedToLoad => 'Échec du chargement des modifications';
}

// Path: chat.commandResult
class Translations$chat$commandResult$fr extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$fr fallback = Translations$chat$commandResult$fallback$fr._(_root);
	@override String get filterCommands => 'Filtrer les commandes...';
	@override String searchModels({required Object provider}) => 'Rechercher les modèles ${provider}...';
}

// Path: chat.commands
class Translations$chat$commands$fr extends Translations$chat$commands$en {
	Translations$chat$commands$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'Exécuter la commande ?';
	@override String get executionCancelled => 'Exécution de la commande annulée';
}

// Path: chat.export
class Translations$chat$export$fr extends Translations$chat$export$en {
	Translations$chat$export$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Session ${id}';
	@override String get pdfFailed => 'Échec de l\'export PDF';
	@override String get transcriptDownloaded => 'Transcription téléchargée';
	@override String savedTo({required Object path}) => 'Enregistré ${path}';
}

// Path: chat.message
class Translations$chat$message$fr extends Translations$chat$message$en {
	Translations$chat$message$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Résumé compacté';
	@override String get rawView => 'Vue brute';
	@override String get resendHint => 'Renvoyer depuis le composeur';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$fr extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String deleteTooltip({required Object name}) => 'Supprimer ${name}';
	@override String editTooltip({required Object name}) => 'Modifier ${name}';
	@override String get enterNameAndId => 'Saisissez à la fois un nom de modèle et un ID de modèle.';
	@override String get idNoSpaces => 'Les ID de modèle ne peuvent pas contenir d\'espaces.';
	@override String get setAsDefault => 'Définir par défaut';
	@override String get defaultModel => 'Modèle par défaut';
}

// Path: chat.pinFile
class Translations$chat$pinFile$fr extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get action => 'Épingler';
	@override String get pathHint => 'path/to/file.ext';
	@override String get title => 'Épingler le fichier';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$fr extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'Demande de permission · ${tool}';
	@override String get question => 'Question';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$fr extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get changes => 'modifications';
	@override String get previousChange => 'Modification précédente';
	@override String get nextChange => 'Modification suivante';
	@override String get hideDiff => 'Masquer la mise en évidence des différences';
	@override String get showDiff => 'Afficher la mise en évidence des différences';
	@override String get settings => 'Paramètres de l\'éditeur';
	@override String get collapse => 'Réduire l\'éditeur';
	@override String get expand => 'Étendre l\'éditeur en pleine largeur';
	@override String get diffMerge => 'Diff / fusion';
	@override String get previewInBrowser => 'Aperçu dans le navigateur';
	@override String get reload => 'Recharger depuis le disque';
	@override String get toggleDock => 'Basculer le dock de fichiers';
}

// Path: codeEditor.header
class Translations$codeEditor$header$fr extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Affichage des modifications';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$fr extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Copier le chemin du fichier';
	@override String get pathCopied => 'Chemin du fichier copié';
	@override String get download => 'Télécharger le fichier';
	@override String get save => 'Enregistrer';
	@override String get saving => 'Enregistrement...';
	@override String get saved => 'Enregistré !';
	@override String get exitFullscreen => 'Quitter le plein écran';
	@override String get fullscreen => 'Plein écran';
	@override String get close => 'Fermer';
	@override String get previewMarkdown => 'Aperçu markdown';
	@override String get editMarkdown => 'Modifier le markdown';
	@override String get pinFile => 'Épingler le fichier au contexte';
	@override String get unpinFile => 'Détacher le fichier du contexte';
	@override String get previewHtml => 'Ouvrir l’aperçu HTML dans un nouvel onglet';
	@override String get retry => 'Réessayer';
	@override String get saveAll => 'Tout enregistrer';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$fr extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Lignes :';
	@override String get characters => 'Caractères :';
	@override String get shortcuts => 'Ctrl+S pour enregistrer • Échap pour fermer';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$fr extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Fichier binaire';
	@override String message({required Object fileName}) => 'Le fichier "${fileName}" ne peut pas être affiché dans l\'éditeur de texte car c\'est un fichier binaire.';
	@override String get cannotDisplayAsText => 'Impossible d’afficher en tant que texte';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$fr extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Chargement de l’aperçu...';
	@override String get error => 'Impossible d’afficher ce fichier.';
	@override String get openInNewTab => 'Ouvrir dans un nouvel onglet';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$fr extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get applyMerge => 'Appliquer la fusion';
	@override String get base => 'Base';
	@override String get close => 'Fermer le diff';
	@override String get current => 'Actuel';
	@override String hunk({required Object number}) => 'Section ${number}';
	@override String get noChanges => 'Aucune modification';
	@override String get deletedOnDisk => 'supprimé sur le disque';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$fr extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aucun fichier ouvert';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$fr extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… ${size} de plus';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$fr extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'L’aperçu audio/vidéo n’est pas encore pris en charge';
	@override String get title => 'Fichier média';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$fr extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String fontSizeDecrease({required Object size}) => 'Taille de police −  (actuelle : ${size})';
	@override String get fontSizeIncrease => 'Taille de police +';
	@override String get minimap => 'Minimap';
	@override String tabSize({required Object size}) => 'Taille de tabulation : ${size}';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$fr extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => 'Enregistré ${name}';
	@override String get saveFailed => 'Échec de l\'enregistrement';
	@override String get allSaved => 'Tout est enregistré';
	@override String get someSavesFailed => 'Certains enregistrements ont échoué';
	@override String savedTo({required Object path}) => 'Enregistré dans ${path}';
	@override String get mergeApplied => 'Fusion appliquée — enregistrez pour conserver';
}

// Path: common.buttons
class Translations$common$buttons$fr extends Translations$common$buttons$en {
	Translations$common$buttons$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get save => 'Enregistrer';
	@override String get cancel => 'Annuler';
	@override String get delete => 'Supprimer';
	@override String get create => 'Créer';
	@override String get edit => 'Modifier';
	@override String get close => 'Fermer';
	@override String get confirm => 'Confirmer';
	@override String get submit => 'Soumettre';
	@override String get retry => 'Réessayer';
	@override String get refresh => 'Actualiser';
	@override String get search => 'Rechercher';
	@override String get clear => 'Effacer';
	@override String get copy => 'Copier';
	@override String get download => 'Télécharger';
	@override String get upload => 'Envoyer';
	@override String get browse => 'Parcourir';
	@override String get openDiagram => 'Ouvrir le diagramme';
	@override String get update => 'Mettre à jour';
}

// Path: common.tabs
class Translations$common$tabs$fr extends Translations$common$tabs$en {
	Translations$common$tabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Discussion';
	@override String get shell => 'Terminal';
	@override String get files => 'Fichiers';
	@override String get git => 'Contrôle de source';
	@override String get tasks => 'Tâches';
	@override String get browser => 'Navigateur';
	@override String get computer => 'Ordinateur';
	@override String get board => 'Tableau';
	@override String get usage => 'AI Control';
}

// Path: common.status
class Translations$common$status$fr extends Translations$common$status$en {
	Translations$common$status$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Chargement...';
	@override String get success => 'Succès';
	@override String get error => 'Erreur';
	@override String get failed => 'Échec';
	@override String get pending => 'En attente';
	@override String get completed => 'Terminé';
	@override String get inProgress => 'En cours';
}

// Path: common.messages
class Translations$common$messages$fr extends Translations$common$messages$en {
	Translations$common$messages$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Enregistré avec succès';
	@override String get deletedSuccessfully => 'Supprimé avec succès';
	@override String get updatedSuccessfully => 'Mis à jour avec succès';
	@override String get operationFailed => 'Opération échouée';
	@override String get networkError => 'Erreur réseau. Vérifiez votre connexion.';
	@override String get unauthorized => 'Non autorisé. Veuillez vous connecter.';
	@override String get notFound => 'Introuvable';
	@override String get invalidInput => 'Entrée invalide';
	@override String get requiredField => 'Ce champ est obligatoire';
	@override String get unknownError => 'Une erreur inconnue s\'est produite';
	@override String get renameSessionFailed => 'Échec du renommage de la session. Veuillez réessayer.';
}

// Path: common.navigation
class Translations$common$navigation$fr extends Translations$common$navigation$en {
	Translations$common$navigation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Paramètres';
	@override String get home => 'Accueil';
	@override String get back => 'Retour';
	@override String get next => 'Suivant';
	@override String get previous => 'Précédent';
	@override String get logout => 'Déconnexion';
}

// Path: common.common
class Translations$common$common$fr extends Translations$common$common$en {
	Translations$common$common$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get language => 'Langue';
	@override String get theme => 'Thème';
	@override String get darkMode => 'Mode sombre';
	@override String get lightMode => 'Mode clair';
	@override String get name => 'Nom';
	@override String get description => 'Description';
	@override String get enabled => 'Activé';
	@override String get disabled => 'Désactivé';
	@override String get optional => 'Optionnel';
	@override String get version => 'Version';
	@override String get select => 'Sélectionner';
	@override String get selectAll => 'Tout sélectionner';
	@override String get deselectAll => 'Tout désélectionner';
	@override String get done => 'Terminé';
	@override String get failed => 'Échoué';
}

// Path: common.time
class Translations$common$time$fr extends Translations$common$time$en {
	Translations$common$time$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'À l\'instant';
	@override String minutesAgo({required Object count}) => 'Il y a ${count} min';
	@override String hoursAgo({required Object count}) => 'Il y a ${count} h';
	@override String daysAgo({required Object count}) => 'Il y a ${count} j';
	@override String get yesterday => 'Hier';
}

// Path: common.fileOperations
class Translations$common$fileOperations$fr extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Nouveau fichier';
	@override String get newFolder => 'Nouveau dossier';
	@override String get rename => 'Renommer';
	@override String get move => 'Déplacer';
	@override String get copyPath => 'Copier le chemin';
	@override String get openInEditor => 'Ouvrir dans l\'éditeur';
}

// Path: common.mainContent
class Translations$common$mainContent$fr extends Translations$common$mainContent$en {
	Translations$common$mainContent$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Chargement de DDAgent';
	@override String get settingUpWorkspace => 'Préparation de votre espace de travail...';
	@override String get chooseProject => 'Choisissez votre projet';
	@override String get selectProjectDescription => 'Sélectionnez un projet dans la barre latérale pour commencer à coder avec Claude. Chaque projet contient vos sessions de chat et l\'historique des fichiers.';
	@override String get tip => 'Astuce';
	@override String get createProjectMobile => 'Appuyez sur le bouton menu ci-dessus pour accéder aux projets';
	@override String get createProjectDesktop => 'Créez un nouveau projet en cliquant sur l\'icône de dossier dans la barre latérale';
	@override String get newSession => 'Nouvelle session';
	@override String get untitledSession => 'Session sans titre';
	@override String get projectFiles => 'Fichiers du projet';
	@override String get focusMode => 'Mode concentration (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Quitter le mode concentration (Ctrl+Shift+F)';
	@override String get splitSession => 'Fractionner la session';
	@override String get closeSplitSession => 'Fermer la session fractionnée';
	@override String get chooseWorkspace => 'Choisir un espace de travail';
	@override String get chooseWorkspaceDescription => 'Choisissez un espace de travail pour ce chat, ou créez-en un dans les Paramètres.';
	@override String get createWorkspace => 'Créer un espace de travail dans les Paramètres';
	@override String get recentProjects => 'Projets récents';
}

// Path: common.fileTree
class Translations$common$fileTree$fr extends Translations$common$fileTree$en {
	Translations$common$fileTree$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Chargement des fichiers...';
	@override String get files => 'Fichiers';
	@override String get simpleView => 'Vue simple';
	@override String get compactView => 'Vue compacte';
	@override String get detailedView => 'Vue détaillée';
	@override String get searchPlaceholder => 'Rechercher fichiers et dossiers...';
	@override String get clearSearch => 'Effacer la recherche';
	@override String get name => 'Nom';
	@override String get size => 'Taille';
	@override String get modified => 'Modifié';
	@override String get permissions => 'Permissions';
	@override String get noFilesFound => 'Aucun fichier trouvé';
	@override String get checkProjectPath => 'Vérifiez si le chemin du projet est accessible';
	@override String get noMatchesFound => 'Aucun résultat';
	@override String get tryDifferentSearch => 'Essayez un autre terme ou effacez la recherche';
	@override String get justNow => 'à l\'instant';
	@override String minAgo({required Object count}) => 'il y a ${count} min';
	@override String hoursAgo({required Object count}) => 'il y a ${count} h';
	@override String daysAgo({required Object count}) => 'il y a ${count} j';
	@override String get newFile => 'Nouveau fichier (Cmd+N)';
	@override String get newFolder => 'Nouveau dossier (Cmd+Maj+N)';
	@override String get refresh => 'Actualiser';
	@override String get collapseAll => 'Tout réduire';
	@override late final Translations$common$fileTree$context$fr context = Translations$common$fileTree$context$fr._(_root);
	@override String get searchContentPlaceholder => 'Rechercher dans les fichiers...';
	@override String get searchInFiles => 'Rechercher dans les fichiers';
	@override String get searchByName => 'Rechercher par nom';
	@override String get loadFailed => 'Impossible de charger les fichiers';
	@override String get noSearchResults => 'Aucun résultat';
	@override String get searchError => 'Échec de la recherche';
	@override String get searching => 'Recherche en cours...';
	@override String resultsTruncated({required Object count}) => 'Affichage des ${count} premiers résultats';
	@override String get allWorkspaces => 'Tous les espaces de travail';
	@override late final Translations$common$fileTree$delete$fr delete = Translations$common$fileTree$delete$fr._(_root);
	@override String get dropToUpload => 'Déposez des fichiers pour les téléverser';
	@override String dropToUploadTo({required Object folder}) => 'Déposez des fichiers pour les téléverser vers « ${folder} »';
	@override String get noProject => 'Ajoutez d’abord un projet';
	@override String get noRecentFiles => 'Aucun fichier modifié au cours des 7 derniers jours';
	@override String get showAllFiles => 'Afficher tous les fichiers';
	@override String get showAllFilesHint => 'Désactivez le filtre récent pour tout voir.';
	@override String get showRecentOnly => 'Afficher les fichiers modifiés au cours des 7 derniers jours';
	@override late final Translations$common$fileTree$toast$fr toast = Translations$common$fileTree$toast$fr._(_root);
	@override String get uploadComplete => 'Téléversement terminé';
	@override String get uploadFailed => 'Échec du téléversement';
	@override String uploadFiles({required Object size}) => 'Téléverser des fichiers (max ${size} chacun)';
	@override String uploadToFolder({required Object folder}) => 'Téléverser des fichiers vers « ${folder} »';
	@override String uploadedCount({required Object uploaded, required Object total, required Object label}) => '${uploaded} sur ${total} ${label} téléversés';
	@override String get uploadingFiles => 'Téléversement des fichiers';
	@override late final Translations$common$fileTree$validation$fr validation = Translations$common$fileTree$validation$fr._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$fr extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Créer un nouveau projet';
	@override late final Translations$common$projectWizard$steps$fr steps = Translations$common$projectWizard$steps$fr._(_root);
	@override late final Translations$common$projectWizard$step1$fr step1 = Translations$common$projectWizard$step1$fr._(_root);
	@override late final Translations$common$projectWizard$step2$fr step2 = Translations$common$projectWizard$step2$fr._(_root);
	@override late final Translations$common$projectWizard$step3$fr step3 = Translations$common$projectWizard$step3$fr._(_root);
	@override late final Translations$common$projectWizard$buttons$fr buttons = Translations$common$projectWizard$buttons$fr._(_root);
	@override late final Translations$common$projectWizard$errors$fr errors = Translations$common$projectWizard$errors$fr._(_root);
}

// Path: common.notifications
class Translations$common$notifications$fr extends Translations$common$notifications$en {
	Translations$common$notifications$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'un outil';
	@override late final Translations$common$notifications$codes$fr codes = Translations$common$notifications$codes$fr._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$fr extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mise à jour disponible';
	@override String get newVersionReady => 'Une nouvelle version est prête';
	@override String get currentVersion => 'Version actuelle';
	@override String get latestVersion => 'Dernière version';
	@override String get whatsNew => 'Nouveautés :';
	@override String get viewFullRelease => 'Voir les notes de version complètes';
	@override String get updateProgress => 'Progression de la mise à jour :';
	@override String get manualUpgrade => 'Mise à jour manuelle :';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'Ou cliquez sur « Mettre à jour maintenant » pour lancer la mise à jour automatiquement.';
	@override String get updateCompleted => 'Mise à jour effectuée avec succès !';
	@override String get restartServer => 'Veuillez redémarrer le serveur pour appliquer les modifications.';
	@override String get updateFailed => 'Échec de la mise à jour';
	@override late final Translations$common$versionUpdate$buttons$fr buttons = Translations$common$versionUpdate$buttons$fr._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$fr ariaLabels = Translations$common$versionUpdate$ariaLabels$fr._(_root);
}

// Path: common.quota
class Translations$common$quota$fr extends Translations$common$quota$en {
	Translations$common$quota$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$fr section = Translations$common$quota$section$fr._(_root);
	@override late final Translations$common$quota$filter$fr filter = Translations$common$quota$filter$fr._(_root);
	@override late final Translations$common$quota$period$fr period = Translations$common$quota$period$fr._(_root);
	@override late final Translations$common$quota$group$fr group = Translations$common$quota$group$fr._(_root);
	@override late final Translations$common$quota$metric$fr metric = Translations$common$quota$metric$fr._(_root);
	@override late final Translations$common$quota$cost$fr cost = Translations$common$quota$cost$fr._(_root);
	@override late final Translations$common$quota$cost3$fr cost3 = Translations$common$quota$cost3$fr._(_root);
	@override late final Translations$common$quota$overview$fr overview = Translations$common$quota$overview$fr._(_root);
	@override late final Translations$common$quota$usage$fr usage = Translations$common$quota$usage$fr._(_root);
	@override late final Translations$common$quota$agents$fr agents = Translations$common$quota$agents$fr._(_root);
	@override late final Translations$common$quota$agentStatus$fr agentStatus = Translations$common$quota$agentStatus$fr._(_root);
	@override late final Translations$common$quota$alert$fr alert = Translations$common$quota$alert$fr._(_root);
	@override String get backToChat => 'Retour à la discussion';
	@override String get syncNow => 'Synchroniser maintenant';
	@override String generatedAt({required Object value}) => 'Mis à jour ${value}';
	@override String get loading => 'Chargement des limites de compte…';
	@override String remaining({required Object value}) => '${value} % restant';
	@override String resetsIn({required Object value}) => 'réinitialisation dans ${value}';
	@override String projected({required Object value}) => 'au rythme actuel, cette limite sera atteinte dans ${value}';
	@override String syncedAgo({required Object value}) => 'synchronisé il y a ${value}';
	@override String get refreshAccount => 'Actualiser le compte';
	@override String get syncFailed => 'Échec de la synchronisation';
	@override String get history => 'Historique';
	@override String historyPoints({required Object value}) => '${value} relevés enregistrés';
	@override String get historyEmpty => 'Aucun historique enregistré';
	@override String get noAgents => 'Aucun agent assigné';
	@override String get noSubscription => 'Aucun abonnement';
	@override String get noSubscriptionHint => 'Le fournisseur ne signale aucun forfait actif pour ce compte.';
	@override late final Translations$common$quota$quality$fr quality = Translations$common$quota$quality$fr._(_root);
	@override late final Translations$common$quota$kpi$fr kpi = Translations$common$quota$kpi$fr._(_root);
	@override late final Translations$common$quota$empty$fr empty = Translations$common$quota$empty$fr._(_root);
	@override late final Translations$common$quota$settings$fr settings = Translations$common$quota$settings$fr._(_root);
	@override late final Translations$common$quota$range$fr range = Translations$common$quota$range$fr._(_root);
}

// Path: common.actions
class Translations$common$actions$fr extends Translations$common$actions$en {
	Translations$common$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annuler';
	@override String get retry => 'Réessayer';
	@override String get save => 'Enregistrer';
}

// Path: common.browserPane
class Translations$common$browserPane$fr extends Translations$common$browserPane$en {
	Translations$common$browserPane$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get address => 'Adresse';
	@override String get back => 'Retour';
	@override String get connecting => 'Connexion au navigateur…';
	@override String get connectionFailed => 'Échec de la connexion au navigateur.';
	@override String couldNotLoad({required Object url}) => 'Impossible de charger ${url}';
	@override String get disconnected => 'Vue du navigateur déconnectée';
	@override String get enterUrl => 'Saisir une URL';
	@override String get forward => 'Suivant';
	@override String get invalidUrl => 'Saisissez une URL http(s) valide';
	@override String get noAuthToken => 'Aucun jeton d’authentification disponible.';
	@override String get openExternal => 'Ouvrir dans le navigateur système';
	@override String get reload => 'Recharger';
	@override String get retry => 'Réessayer';
	@override String get stop => 'Arrêter';
}

// Path: common.browserUse
class Translations$common$browserUse$fr extends Translations$common$browserUse$en {
	Translations$common$browserUse$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} actives';
	@override String get cancel => 'Annuler';
	@override String get close => 'Fermer';
	@override String get delete => 'Supprimer';
	@override String deleteDesc({required Object name}) => '${name} sera supprimée définitivement.';
	@override String get deleteSession => 'Supprimer la session';
	@override String get deleteTitle => 'Supprimer la session de navigateur ?';
	@override late final Translations$common$browserUse$empty$fr empty = Translations$common$browserUse$empty$fr._(_root);
	@override String get emptyStatus => 'vide';
	@override late final Translations$common$browserUse$errors$fr errors = Translations$common$browserUse$errors$fr._(_root);
	@override String get fullscreen => 'Plein écran';
	@override String get installRuntime => 'Installer le runtime';
	@override String get installing => 'Installation...';
	@override String get lastAction => 'Dernière action';
	@override String get nextSnapshot => 'La prochaine capture du navigateur de l’agent s’affichera ici.';
	@override String get noPageLoaded => 'Aucune page chargée';
	@override String get noSessions => 'Aucune session de navigateur d’agent.';
	@override String get none => 'Aucun';
	@override String get openSettings => 'Ouvrir les paramètres Browser';
	@override String get profile => 'Profil';
	@override String get promptLabel => 'Prompt';
	@override late final Translations$common$browserUse$prompts$fr prompts = Translations$common$browserUse$prompts$fr._(_root);
	@override String get refresh => 'Actualiser les sessions de navigateur';
	@override late final Translations$common$browserUse$relative$fr relative = Translations$common$browserUse$relative$fr._(_root);
	@override late final Translations$common$browserUse$runtime$fr runtime = Translations$common$browserUse$runtime$fr._(_root);
	@override String get runtimeSetup => 'Configuration du runtime requise';
	@override String get selected => 'Sélectionnée';
	@override String get sessionFallback => 'Session de navigateur';
	@override String get sessionScreenshot => 'Capture d’écran de la session de navigateur';
	@override String get sessions => 'Sessions';
	@override String get status => 'Statut';
	@override String get stop => 'Arrêter';
	@override String get stopSession => 'Arrêter la session';
	@override String get subtitle => 'Surveillez les sessions de navigateur ouvertes par les agents IA.';
	@override String get temporary => 'Temporaire';
	@override String get thisSession => 'Cette session';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '${count} au total';
	@override String updated({required Object time}) => 'Mis à jour ${time}';
	@override String get waiting => 'En attente';
	@override String get waitingForScreenshot => 'En attente de la capture d’écran';
}

// Path: common.commandPalette
class Translations$common$commandPalette$fr extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Retour à tout';
	@override String get backspaceHint => 'Retour arrière pour revenir';
	@override late final Translations$common$commandPalette$browseAll$fr browseAll = Translations$common$commandPalette$browseAll$fr._(_root);
	@override late final Translations$common$commandPalette$compare$fr compare = Translations$common$commandPalette$compare$fr._(_root);
	@override late final Translations$common$commandPalette$groups$fr groups = Translations$common$commandPalette$groups$fr._(_root);
	@override late final Translations$common$commandPalette$hints$fr hints = Translations$common$commandPalette$hints$fr._(_root);
	@override late final Translations$common$commandPalette$items$fr items = Translations$common$commandPalette$items$fr._(_root);
	@override late final Translations$common$commandPalette$nav$fr nav = Translations$common$commandPalette$nav$fr._(_root);
	@override String get noResults => 'Aucun résultat.';
	@override late final Translations$common$commandPalette$pages$fr pages = Translations$common$commandPalette$pages$fr._(_root);
	@override String get placeholder => 'Tapez pour rechercher…';
	@override String searchPagePlaceholder({required Object page}) => 'Rechercher dans ${page}…';
	@override String get title => 'Palette de commandes';
}

// Path: common.gitPanel
class Translations$common$gitPanel$fr extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} en avance';
	@override String get aheadLabel => 'en avance';
	@override String get aiSuggest => 'Suggestion IA';
	@override String get aiSuggestTitle => 'Générer un message de commit avec l’IA';
	@override String get all => 'Tous';
	@override String get allStaged => 'Toutes les modifications indexées';
	@override String behind({required Object count}) => '${count} en retard';
	@override String get behindLabel => 'en retard';
	@override late final Translations$common$gitPanel$branches$fr branches = Translations$common$gitPanel$branches$fr._(_root);
	@override String get cancel => 'Annuler';
	@override String changesCount({required Object count}) => 'Modifications (${count})';
	@override String get clearSearch => 'Effacer la recherche';
	@override String get collapseDiff => 'Réduire le diff';
	@override String get commit => 'Commit';
	@override String get commitChanges => 'Valider les modifications';
	@override String commitFiles({required Object count}) => 'Valider ${count} fichier(s)';
	@override String get committing => 'Validation...';
	@override late final Translations$common$gitPanel$confirmActions$fr confirmActions = Translations$common$gitPanel$confirmActions$fr._(_root);
	@override String confirmCommit({required Object count, required Object message}) => 'Valider ${count} fichier(s) avec le message : « ${message} » ?';
	@override String confirmDeleteFile({required Object file}) => 'Supprimer le fichier non suivi « ${file} » ? Cette action est irréversible.';
	@override String confirmDiscardFile({required Object file}) => 'Ignorer toutes les modifications de « ${file} » ? Cette action est irréversible.';
	@override String confirmPublish({required Object branch, required Object remote}) => 'Publier la branche « ${branch} » vers ${remote} ?';
	@override String confirmPull({required Object count, required Object remote}) => 'Récupérer ${count} commit(s) depuis ${remote} ?';
	@override String confirmPush({required Object count, required Object remote}) => 'Envoyer ${count} commit(s) vers ${remote} ?';
	@override String get confirmRevert => 'Annuler le dernier commit local ? Supprime le commit mais conserve ses modifications indexées.';
	@override late final Translations$common$gitPanel$confirmTitles$fr confirmTitles = Translations$common$gitPanel$confirmTitles$fr._(_root);
	@override String get createBranch => 'Créer une nouvelle branche';
	@override String get creating => 'Création...';
	@override String get delete => 'Supprimer';
	@override String get deleteUntracked => 'Supprimer le fichier non suivi';
	@override String get deselectAll => 'Tout désélectionner';
	@override String get discard => 'Ignorer';
	@override String get discardChanges => 'Ignorer les modifications';
	@override String get dismiss => 'Fermer';
	@override String get dismissError => 'Fermer l’erreur';
	@override late final Translations$common$gitPanel$errors$fr errors = Translations$common$gitPanel$errors$fr._(_root);
	@override String get expandDiff => 'Développer le diff';
	@override String get fetch => 'Récupérer';
	@override String fetchTitle({required Object remote}) => 'Fetch depuis ${remote}';
	@override String get fetching => 'Fetch…';
	@override String filesSelected({required Object count}) => '${count} fichier(s) sélectionné(s)';
	@override String get generating => 'Génération...';
	@override late final Translations$common$gitPanel$history$fr history = Translations$common$gitPanel$history$fr._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$fr mergeWorktree = Translations$common$gitPanel$mergeWorktree$fr._(_root);
	@override String get merging => 'Fusion...';
	@override String get messagePlaceholder => 'Message (Ctrl+Entrée pour valider)';
	@override late final Translations$common$gitPanel$newBranch$fr newBranch = Translations$common$gitPanel$newBranch$fr._(_root);
	@override late final Translations$common$gitPanel$newWorktree$fr newWorktree = Translations$common$gitPanel$newWorktree$fr._(_root);
	@override String get noChanges => 'Aucune modification détectée';
	@override String get noChangesToCommit => 'Aucune modification à valider';
	@override late final Translations$common$gitPanel$noCommits$fr noCommits = Translations$common$gitPanel$noCommits$fr._(_root);
	@override String get noMatchingBranches => 'Aucune branche correspondante';
	@override late final Translations$common$gitPanel$noRepo$fr noRepo = Translations$common$gitPanel$noRepo$fr._(_root);
	@override String get noStagedFiles => 'Aucun fichier indexé';
	@override String get none => 'Aucun';
	@override String nothingToPush({required Object remote}) => 'Rien à envoyer vers ${remote}';
	@override String get openFile => 'Cliquer pour ouvrir le fichier';
	@override String get publish => 'Publier';
	@override String publishTitle({required Object branch, required Object remote}) => 'Publier « ${branch} » vers ${remote}';
	@override String get publishing => 'Publication…';
	@override String get pull => 'Tirer';
	@override String pullCount({required Object count}) => 'Tirer ${count}';
	@override String pullTitle({required Object count, required Object remote}) => 'Récupérer ${count} depuis ${remote}';
	@override String get pulling => 'Pull…';
	@override String get push => 'Pousser';
	@override String pushCount({required Object count}) => 'Pousser ${count}';
	@override String pushTitle({required Object count, required Object remote}) => 'Envoyer ${count} vers ${remote}';
	@override String get pushing => 'Push…';
	@override String get recentCommits => 'Commits récents';
	@override String get refresh => 'Actualiser le statut git';
	@override String get remove => 'Supprimer';
	@override late final Translations$common$gitPanel$removeWorktree$fr removeWorktree = Translations$common$gitPanel$removeWorktree$fr._(_root);
	@override String get removing => 'Suppression...';
	@override String get revertLatest => 'Annuler le dernier commit local';
	@override String get scroll => 'Défiler';
	@override String get searchBranches => 'Rechercher des branches...';
	@override String get selectAll => 'Tout sélectionner';
	@override String get selectProject => 'Sélectionnez un projet pour voir le contrôle de source';
	@override String selectedOf({required Object selected, required Object total}) => '${selected} sur ${total} fichiers sélectionnés';
	@override String selectedOfMobile({required Object selected, required Object total}) => '${selected} sur ${total} sélectionnés';
	@override String get sideBySide => 'Côte à côte';
	@override String get stageAll => 'Tout indexer';
	@override String get stageHunk => 'Indexer cette section';
	@override String staged({required Object count}) => 'Indexés (${count})';
	@override late final Translations$common$gitPanel$status$fr status = Translations$common$gitPanel$status$fr._(_root);
	@override String get statusGuide => 'Guide des statuts de fichiers';
	@override String get switchScroll => 'Passer au défilement horizontal';
	@override String get switchSplit => 'Passer à la vue côte à côte';
	@override String get switchUnified => 'Passer à la vue unifiée';
	@override String get switchWrap => 'Passer au retour à la ligne';
	@override String get unified => 'Unifié';
	@override String get unstageAll => 'Tout retirer de l’index';
	@override String get unstageHunk => 'Retirer cette section de l’index';
	@override String get upToDate => 'À jour';
	@override String upToDateWith({required Object remote}) => 'À jour avec ${remote}';
	@override String get viewAll => 'Tout voir';
	@override String get viewsAria => 'Vues du contrôle de source';
	@override late final Translations$common$gitPanel$worktrees$fr worktrees = Translations$common$gitPanel$worktrees$fr._(_root);
	@override String get wrap => 'Retour à la ligne';
	@override late final Translations$common$gitPanel$tabs$fr tabs = Translations$common$gitPanel$tabs$fr._(_root);
}

// Path: common.sessions
class Translations$common$sessions$fr extends Translations$common$sessions$en {
	Translations$common$sessions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Renommer la session';
}

// Path: common.projects
class Translations$common$projects$fr extends Translations$common$projects$en {
	Translations$common$projects$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nouvelle session';
}

// Path: common.codeBlock
class Translations$common$codeBlock$fr extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'Retour à la ligne';
	@override String get noWrap => 'Aucun retour à la ligne';
}

// Path: common.update
class Translations$common$update$fr extends Translations$common$update$en {
	Translations$common$update$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Mise à jour disponible · v${version}';
	@override String confirm({required Object version}) => 'Mettre à jour vers v${version} ? Le serveur se met à jour et redémarre automatiquement — les sessions actives seront interrompues.';
	@override String get downloading => 'Téléchargement et application de la mise à jour…';
	@override String get restarting => 'Redémarrage du serveur — cela prend un instant…';
	@override String done({required Object version}) => 'Mis à jour vers v${version}. Rechargez l\'application pour charger le nouveau bundle.';
	@override String get manualRestart => 'La mise à jour a été appliquée mais le serveur ne s\'est pas redémarré tout seul — redémarrez-le manuellement pour terminer.';
	@override String get failed => 'Échec de la mise à jour.';
	@override String get failedTitle => 'Échec de la mise à jour';
	@override String appConfirm({required Object version}) => 'Installer DDAgent v${version} sur cet appareil ? Android demandera l\'autorisation d\'installer des applications depuis DDAgent la première fois.';
	@override String get appPermission => 'Autorisez « Installer des applications inconnues » pour DDAgent, puis appuyez à nouveau sur Mettre à jour.';
	@override String get chooseTitle => 'Mises à jour disponibles';
	@override String get targetApp => 'Cette application';
	@override String get targetWeb => 'Interface web';
	@override String get targetServer => 'Serveur';
	@override String get updateApp => 'Mettre à jour l\'application';
	@override String get updateWeb => 'Mettre à jour l\'interface web';
	@override String get updateServer => 'Mettre à jour le serveur';
	@override String webConfirm({required Object version}) => 'Mettre à jour l\'interface web vers v${version} ? La page sera rechargée ensuite.';
	@override String webDone({required Object version}) => 'Interface web mise à jour vers v${version} — rechargement…';
	@override String localServerConfirm({required Object version}) => 'Mettre à jour le serveur local de cet appareil vers v${version} ? Les sessions actives seront interrompues.';
	@override String get localServerUpdating => 'Téléchargement et démarrage du serveur local…';
	@override String serverDone({required Object version}) => 'Le serveur exécute v${version}.';
	@override String staged({required Object version}) => 'Mise à jour v${version} téléchargée — redémarrez le serveur pour l\'installer.';
	@override String get upToDate => 'Le serveur est déjà sur la dernière version.';
	@override String webHostFailed({required Object message}) => 'Le serveur a été mis à jour, mais pas son interface web : ${message}';
}

// Path: settings.changelog
class Translations$settings$changelog$fr extends Translations$settings$changelog$en {
	Translations$settings$changelog$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Journal des modifications';
	@override String get loading => 'Chargement…';
	@override String get empty => 'Aucune version à afficher';
	@override String get current => 'actuelle';
	@override String get kNew => 'nouvelle';
}

// Path: settings.server
class Translations$settings$server$fr extends Translations$settings$server$en {
	Translations$settings$server$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Serveur';
	@override String get description => 'Redémarre le processus DDAgent — utile après une mise à jour ou en cas de blocage.';
	@override String get restart => 'Redémarrer';
	@override String get restartConfirm => 'Redémarrer le serveur DDAgent ? Les sessions actives seront interrompues.';
	@override String get restarting => 'Redémarrage… la page se rechargera quand le serveur sera de retour.';
	@override String get restartFailed => 'Le redémarrage a échoué';
	@override String get unsupported => 'Le redémarrage n\'est disponible que lorsque le serveur tourne sous le gestionnaire de services.';
	@override String get ok => 'OK';
	@override String get restartTitle => 'Redémarrage du serveur';
	@override String get restartRequesting => 'Demande de redémarrage envoyée au serveur…';
	@override String restartWaiting({required Object seconds}) => 'En attente du retour du serveur… (${seconds} s)';
	@override String restartBack({required Object version}) => 'Le serveur est de retour — version ${version}.';
	@override String get restartReloading => 'Rechargement de la page…';
	@override String restartTimeout({required Object seconds}) => 'Le serveur n\'est pas revenu en ${seconds} s. Consultez le journal du service (/tmp/ddagent.log) ou redémarrez-le manuellement.';
}

// Path: settings.updates
class Translations$settings$updates$fr extends Translations$settings$updates$en {
	Translations$settings$updates$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mises à jour';
	@override String get description => 'Rechercher une build de bureau plus récente sur GitHub. Les nouvelles versions se téléchargent automatiquement et s\'installent à la fermeture.';
	@override String get check => 'Rechercher des mises à jour';
	@override String get checking => 'Recherche…';
	@override String upToDate({required Object version}) => 'Vous avez la dernière version (v${version}).';
	@override String available({required Object version}) => 'Mise à jour v${version} trouvée — téléchargement en arrière-plan ; elle s\'installera à la fermeture de DDAgent.';
	@override String downloaded({required Object version}) => 'Mise à jour v${version} téléchargée — quittez et relancez DDAgent pour l\'installer.';
	@override String get unavailable => 'La recherche de mises à jour n\'est disponible que dans les builds de bureau empaquetées.';
	@override String error({required Object message}) => 'Échec de la recherche de mises à jour : ${message}';
	@override String get errorGeneric => 'Échec de la recherche de mises à jour.';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · dernière v${latest}';
	@override String current({required Object version}) => 'v${version} — à jour';
	@override String webNotHosted({required Object version}) => 'Cette interface web est hébergée séparément — remplacez ses fichiers par ddagent-flutter-web-v${version}.zip de la version.';
	@override String get serverCannotUpdate => 'Ce serveur ne peut pas se mettre à jour d\'ici — réinstallez-le avec install.sh ou une archive de la version.';
}

// Path: settings.tabs
class Translations$settings$tabs$fr extends Translations$settings$tabs$en {
	Translations$settings$tabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get account => 'Compte';
	@override String get permissions => 'Permissions';
	@override String get mcpServers => 'Serveurs MCP';
	@override String get appearance => 'Apparence';
	@override String get skills => 'Skills';
}

// Path: settings.account
class Translations$settings$account$fr extends Translations$settings$account$en {
	Translations$settings$account$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Compte';
	@override String get language => 'Langue';
	@override String get languageLabel => 'Langue d\'affichage';
	@override String get languageDescription => 'Choisissez votre langue préférée pour l\'interface';
	@override String get username => 'Nom d\'utilisateur';
	@override String get email => 'E-mail';
	@override String get profile => 'Profil';
	@override String get changePassword => 'Changer le mot de passe';
}

// Path: settings.mcp
class Translations$settings$mcp$fr extends Translations$settings$mcp$en {
	Translations$settings$mcp$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Serveurs MCP';
	@override String get addServer => 'Ajouter un serveur';
	@override String get editServer => 'Modifier le serveur';
	@override String get deleteServer => 'Supprimer le serveur';
	@override String get serverName => 'Nom du serveur';
	@override String get serverType => 'Type de serveur';
	@override String get config => 'Configuration';
	@override String get testConnection => 'Tester la connexion';
	@override String get status => 'Statut';
	@override String get connected => 'Connecté';
	@override String get disconnected => 'Déconnecté';
	@override late final Translations$settings$mcp$scope$fr scope = Translations$settings$mcp$scope$fr._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$fr extends Translations$settings$appearance$en {
	Translations$settings$appearance$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Apparence';
	@override String get theme => 'Thème';
	@override String get codeEditor => 'Éditeur de code';
	@override String get editorTheme => 'Thème de l\'éditeur';
	@override String get wordWrap => 'Retour à la ligne';
	@override String get showMinimap => 'Afficher la minimap';
	@override String get lineNumbers => 'Numéros de ligne';
	@override String get fontSize => 'Taille de police';
	@override late final Translations$settings$appearance$themeModes$fr themeModes = Translations$settings$appearance$themeModes$fr._(_root);
}

// Path: settings.actions
class Translations$settings$actions$fr extends Translations$settings$actions$en {
	Translations$settings$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Enregistrer les modifications';
	@override String get resetToDefaults => 'Rétablir les valeurs par défaut';
	@override String get cancelChanges => 'Annuler les modifications';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$fr extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paramètres rapides';
	@override late final Translations$settings$quickSettings$sections$fr sections = Translations$settings$quickSettings$sections$fr._(_root);
	@override String get darkMode => 'Mode sombre';
	@override String get showRawParameters => 'Afficher les paramètres bruts';
	@override String get showThinking => 'Afficher la réflexion';
	@override String get sendByCtrlEnter => 'Envoyer avec Ctrl+Entrée';
	@override String get sendByCtrlEnterDescription => 'Lorsqu\'activé, appuyer sur Ctrl+Entrée envoie le message au lieu de simplement Entrée. Utile pour les utilisateurs IME pour éviter les envois accidentels.';
	@override late final Translations$settings$quickSettings$dragHandle$fr dragHandle = Translations$settings$quickSettings$dragHandle$fr._(_root);
	@override String get sendWithCtrlEnter => 'Envoyer avec Ctrl+Entrée';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$fr extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Raccourcis terminal';
	@override String get sectionKeys => 'Touches';
	@override String get sectionNavigation => 'Navigation';
	@override String get escape => 'Échap';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Maj+Tab';
	@override String get arrowUp => 'Flèche haut';
	@override String get arrowDown => 'Flèche bas';
	@override String get scrollDown => 'Défiler vers le bas';
	@override late final Translations$settings$terminalShortcuts$handle$fr handle = Translations$settings$terminalShortcuts$handle$fr._(_root);
	@override String get killTitle => 'Tuer le processus en cours (Ctrl+C)';
	@override String get paste => 'Coller';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$fr extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Paramètres';
	@override String get agents => 'Agents';
	@override String get orchestration => 'Orchestration';
	@override String get appearance => 'Apparence';
	@override String get git => 'Git';
	@override String get apiTokens => 'API et jetons';
	@override String get models => 'Modèles';
	@override String get tasks => 'Tâches';
	@override String get notifications => 'Notifications';
	@override String get about => 'À propos';
	@override String get workspaces => 'Espaces de travail';
	@override String get browser => 'Browser';
	@override String get tools => 'Outils';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$fr extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$fr enable = Translations$settings$orchestration$enable$fr._(_root);
	@override late final Translations$settings$orchestration$pool$fr pool = Translations$settings$orchestration$pool$fr._(_root);
	@override late final Translations$settings$orchestration$tiers$fr tiers = Translations$settings$orchestration$tiers$fr._(_root);
	@override late final Translations$settings$orchestration$rules$fr rules = Translations$settings$orchestration$rules$fr._(_root);
	@override late final Translations$settings$orchestration$planner$fr planner = Translations$settings$orchestration$planner$fr._(_root);
	@override late final Translations$settings$orchestration$execution$fr execution = Translations$settings$orchestration$execution$fr._(_root);
	@override late final Translations$settings$orchestration$save$fr save = Translations$settings$orchestration$save$fr._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$fr extends Translations$settings$notifications$en {
	Translations$settings$notifications$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifications';
	@override String get description => 'Contrôlez les événements de notification que vous recevez.';
	@override late final Translations$settings$notifications$webPush$fr webPush = Translations$settings$notifications$webPush$fr._(_root);
	@override late final Translations$settings$notifications$device$fr device = Translations$settings$notifications$device$fr._(_root);
	@override late final Translations$settings$notifications$sound$fr sound = Translations$settings$notifications$sound$fr._(_root);
	@override late final Translations$settings$notifications$events$fr events = Translations$settings$notifications$events$fr._(_root);
	@override late final Translations$settings$notifications$desktop$fr desktop = Translations$settings$notifications$desktop$fr._(_root);
	@override late final Translations$settings$notifications$channels$fr channels = Translations$settings$notifications$channels$fr._(_root);
	@override String get unpair => 'Dissocier';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$fr extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$fr darkMode = Translations$settings$appearanceSettings$darkMode$fr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fr codeEditor = Translations$settings$appearanceSettings$codeEditor$fr._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$fr terminal = Translations$settings$appearanceSettings$terminal$fr._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$fr extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$fr title = Translations$settings$mcpForm$title$fr._(_root);
	@override late final Translations$settings$mcpForm$importMode$fr importMode = Translations$settings$mcpForm$importMode$fr._(_root);
	@override late final Translations$settings$mcpForm$scope$fr scope = Translations$settings$mcpForm$scope$fr._(_root);
	@override late final Translations$settings$mcpForm$fields$fr fields = Translations$settings$mcpForm$fields$fr._(_root);
	@override late final Translations$settings$mcpForm$placeholders$fr placeholders = Translations$settings$mcpForm$placeholders$fr._(_root);
	@override late final Translations$settings$mcpForm$validation$fr validation = Translations$settings$mcpForm$validation$fr._(_root);
	@override String configDetails({required Object configFile}) => 'Détails de configuration (depuis ${configFile})';
	@override String projectPath({required Object path}) => 'Chemin : ${path}';
	@override late final Translations$settings$mcpForm$actions$fr actions = Translations$settings$mcpForm$actions$fr._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$fr extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get success => 'Paramètres enregistrés avec succès !';
	@override String get error => 'Échec de l\'enregistrement des paramètres';
	@override String get saving => 'Enregistrement...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$fr extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get save => 'Enregistrer les paramètres';
	@override String get cancel => 'Annuler';
}

// Path: settings.git
class Translations$settings$git$fr extends Translations$settings$git$en {
	Translations$settings$git$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuration Git';
	@override String get description => 'Configurez votre identité git pour les commits. Ces paramètres seront appliqués globalement via git config --global';
	@override late final Translations$settings$git$name$fr name = Translations$settings$git$name$fr._(_root);
	@override late final Translations$settings$git$email$fr email = Translations$settings$git$email$fr._(_root);
	@override late final Translations$settings$git$actions$fr actions = Translations$settings$git$actions$fr._(_root);
	@override late final Translations$settings$git$status$fr status = Translations$settings$git$status$fr._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$fr extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Clés API';
	@override String get description => 'Générez des clés API pour accéder à l\'API externe depuis d\'autres applications.';
	@override late final Translations$settings$apiKeys$newKey$fr newKey = Translations$settings$apiKeys$newKey$fr._(_root);
	@override late final Translations$settings$apiKeys$form$fr form = Translations$settings$apiKeys$form$fr._(_root);
	@override String get newButton => 'Nouvelle clé API';
	@override String get empty => 'Aucune clé API créée pour l\'instant.';
	@override late final Translations$settings$apiKeys$list$fr list = Translations$settings$apiKeys$list$fr._(_root);
	@override String get confirmDelete => 'Êtes-vous sûr de vouloir supprimer cette clé API ?';
	@override late final Translations$settings$apiKeys$status$fr status = Translations$settings$apiKeys$status$fr._(_root);
	@override late final Translations$settings$apiKeys$github$fr github = Translations$settings$apiKeys$github$fr._(_root);
	@override String get apiDocsLink => 'Documentation API';
	@override late final Translations$settings$apiKeys$documentation$fr documentation = Translations$settings$apiKeys$documentation$fr._(_root);
	@override String get loading => 'Chargement...';
	@override late final Translations$settings$apiKeys$version$fr version = Translations$settings$apiKeys$version$fr._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$fr extends Translations$settings$tasks$en {
	Translations$settings$tasks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Vérification de l\'installation TaskMaster...';
	@override late final Translations$settings$tasks$notInstalled$fr notInstalled = Translations$settings$tasks$notInstalled$fr._(_root);
	@override late final Translations$settings$tasks$settings$fr settings = Translations$settings$tasks$settings$fr._(_root);
}

// Path: settings.agents
class Translations$settings$agents$fr extends Translations$settings$agents$en {
	Translations$settings$agents$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$fr authStatus = Translations$settings$agents$authStatus$fr._(_root);
	@override late final Translations$settings$agents$install$fr install = Translations$settings$agents$install$fr._(_root);
	@override late final Translations$settings$agents$update$fr update = Translations$settings$agents$update$fr._(_root);
	@override late final Translations$settings$agents$account$fr account = Translations$settings$agents$account$fr._(_root);
	@override String get connectionStatus => 'Statut de la connexion';
	@override late final Translations$settings$agents$login$fr login = Translations$settings$agents$login$fr._(_root);
	@override late final Translations$settings$agents$logout$fr logout = Translations$settings$agents$logout$fr._(_root);
	@override String error({required Object error}) => 'Erreur : ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$fr extends Translations$settings$permissions$en {
	Translations$settings$permissions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paramètres de permission';
	@override late final Translations$settings$permissions$permissionMode$fr permissionMode = Translations$settings$permissions$permissionMode$fr._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$fr extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Serveurs MCP';
	@override late final Translations$settings$mcpServers$description$fr description = Translations$settings$mcpServers$description$fr._(_root);
	@override String get addButton => 'Ajouter un serveur MCP';
	@override String get empty => 'Aucun serveur MCP configuré';
	@override String get serverType => 'Type';
	@override late final Translations$settings$mcpServers$scope$fr scope = Translations$settings$mcpServers$scope$fr._(_root);
	@override late final Translations$settings$mcpServers$config$fr config = Translations$settings$mcpServers$config$fr._(_root);
	@override late final Translations$settings$mcpServers$tools$fr tools = Translations$settings$mcpServers$tools$fr._(_root);
	@override late final Translations$settings$mcpServers$actions$fr actions = Translations$settings$mcpServers$actions$fr._(_root);
	@override late final Translations$settings$mcpServers$help$fr help = Translations$settings$mcpServers$help$fr._(_root);
	@override late final Translations$settings$mcpServers$managed$fr managed = Translations$settings$mcpServers$managed$fr._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$fr deleteConfirm = Translations$settings$mcpServers$deleteConfirm$fr._(_root);
}

// Path: settings.quota
class Translations$settings$quota$fr extends Translations$settings$quota$en {
	Translations$settings$quota$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$fr settings = Translations$settings$quota$settings$fr._(_root);
	@override late final Translations$settings$quota$empty$fr empty = Translations$settings$quota$empty$fr._(_root);
	@override late final Translations$settings$quota$quality$fr quality = Translations$settings$quota$quality$fr._(_root);
	@override String get syncFailed => 'Échec de la synchronisation';
	@override String get syncNow => 'Synchroniser maintenant';
}

// Path: settings.browser
class Translations$settings$browser$fr extends Translations$settings$browser$en {
	Translations$settings$browser$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'vérification...';
	@override String get description => 'Permet aux agents de créer des sessions de navigateur Playwright surveillées, visibles dans l’onglet Browser.';
	@override String get enableDescription => 'Enregistre Browser pour les agents pris en charge. Les agents peuvent créer des sessions de navigateur ; vous pouvez les regarder, les arrêter et les supprimer.';
	@override String get enableLabel => 'Activer Browser';
	@override late final Translations$settings$browser$errors$fr errors = Translations$settings$browser$errors$fr._(_root);
	@override String get installHint => 'Installez le runtime du navigateur avant que les agents puissent créer des sessions Browser.';
	@override String get installRuntime => 'Installer le runtime';
	@override String get installed => 'installé';
	@override String get installing => 'Installation...';
	@override String get missing => 'manquant';
	@override String get runtimeRequired => 'Runtime du navigateur requis';
	@override String get statusDisabled => 'désactivé';
	@override String get statusLabel => 'Statut';
	@override String get statusReady => 'prêt';
	@override String get statusSetupRequired => 'configuration requise';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$fr extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annuler';
	@override String get create => 'Ajouter un espace de travail';
	@override String get deleteConfirm => 'Retirer cet espace de travail de DDAgent ? Ses fichiers restent sur le disque.';
	@override String get deleteFailed => 'Échec de la suppression de l’espace de travail.';
	@override String get deleteTitle => 'Retirer l’espace de travail';
	@override String get description => 'Les espaces de travail sont des répertoires dans lesquels DDAgent peut discuter, exécuter du code et naviguer.';
	@override String get remove => 'Retirer l’espace de travail';
	@override String get title => 'Espaces de travail';
	@override String get pathRequired => 'Le chemin est requis';
}

// Path: settings.about
class Translations$settings$about$fr extends Translations$settings$about$en {
	Translations$settings$about$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Soutenir le projet';
	@override String get buyMeACoffee => 'Offrez-moi un café';
	@override String get learnMore => 'En savoir plus';
	@override late final Translations$settings$about$pro$fr pro = Translations$settings$about$pro$fr._(_root);
	@override String get proFeatures => 'Fonctionnalités de DDAgent Pro';
	@override String get tryHosted => 'Essayer DDAgent Hosted';
	@override String get versionInfo => 'Informations de version';
	@override String get client => 'Application';
	@override String get server => 'Serveur';
	@override String get platformMobile => 'Mobile';
	@override String get platformDesktop => 'Bureau';
	@override String get platformWeb => 'Web';
	@override String get unknown => 'inconnue';
}

// Path: sidebar.projects
class Translations$sidebar$projects$fr extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Projets';
	@override String get newProject => 'Nouveau projet';
	@override String get deleteProject => 'Supprimer le projet';
	@override String get renameProject => 'Renommer le projet';
	@override String get noProjects => 'Aucun projet trouvé';
	@override String get loadingProjects => 'Chargement des projets...';
	@override String get searchPlaceholder => 'Rechercher des projets...';
	@override String get projectNamePlaceholder => 'Nom du projet';
	@override String get starred => 'Favoris';
	@override String get all => 'Tous';
	@override String get untitledSession => 'Session sans titre';
	@override String get newSession => 'Nouvelle session';
	@override String get codexSession => 'Session Codex';
	@override String get fetchingProjects => 'Récupération de vos projets et sessions Claude';
	@override String get projects => 'projets';
	@override String get noMatchingProjects => 'Aucun projet correspondant';
	@override String get tryDifferentSearch => 'Essayez d\'ajuster votre terme de recherche';
	@override String get runClaudeCli => 'Exécutez le CLI Claude dans un répertoire de projet pour commencer';
}

// Path: sidebar.app
class Translations$sidebar$app$fr extends Translations$sidebar$app$en {
	Translations$sidebar$app$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'Interface d\'assistant de codage IA';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$fr extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sessions';
	@override String get newSession => 'Nouvelle session';
	@override String get deleteSession => 'Supprimer la session';
	@override String get renameSession => 'Renommer la session';
	@override String get noSessions => 'Aucune session pour l\'instant';
	@override String get loadingSessions => 'Chargement des sessions...';
	@override String get unnamed => 'Sans nom';
	@override String get loading => 'Chargement...';
	@override String get showMore => 'Afficher plus de sessions';
	@override String get selectMode => 'Sélectionner';
	@override String get selectAll => 'Tout sélectionner';
	@override String archiveSelected({required Object count}) => 'Archiver (${count})';
	@override String deleteSelected({required Object count}) => 'Supprimer (${count})';
	@override String get cancelSelection => 'Annuler la sélection';
	@override String get toggleSelection => 'Basculer la sélection de sessions';
	@override String get selectionToolbar => 'Actions de sélection de sessions';
	@override String get options => 'Options de session';
	@override String get pinSession => 'Épingler la session';
	@override String get unpinSession => 'Désépingler la session';
	@override String get pinned => 'Session épinglée';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} sélectionnée',
		other: '${count} sélectionnées',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$fr extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Voir les environnements';
	@override String get hideSidebar => 'Masquer la barre latérale';
	@override String get createProject => 'Créer un nouveau projet';
	@override String get refresh => 'Actualiser les projets et sessions (Ctrl+R)';
	@override String get renameProject => 'Renommer le projet (F2)';
	@override String get deleteProject => 'Retirer le projet de la barre latérale (Suppr)';
	@override String get addToFavorites => 'Ajouter aux favoris';
	@override String get removeFromFavorites => 'Retirer des favoris';
	@override String get editSessionName => 'Modifier manuellement le nom de la session';
	@override String get deleteSession => 'Supprimer définitivement cette session';
	@override String get activeSessionIndicator => 'Session récemment active (10 dernières minutes)';
	@override String get save => 'Enregistrer';
	@override String get cancel => 'Annuler';
	@override String get clearSearch => 'Effacer la recherche';
	@override String get openCommandPalette => 'Ouvrir la palette de commandes';
	@override String get attentionRequiredIndicator => 'La session nécessite votre attention';
	@override String get openSessions => 'Parcourir les sessions';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$fr extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Discussion';
	@override String get files => 'Fichiers';
	@override String get git => 'Git';
	@override String get terminal => 'Terminal';
	@override String get tasks => 'Tâches';
}

// Path: sidebar.actions
class Translations$sidebar$actions$fr extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Actualiser';
	@override String get settings => 'Paramètres';
	@override String get collapseAll => 'Tout réduire';
	@override String get expandAll => 'Tout développer';
	@override String get cancel => 'Annuler';
	@override String get save => 'Enregistrer';
	@override String get delete => 'Supprimer';
	@override String get rename => 'Renommer';
	@override String get joinCommunity => 'Rejoindre la communauté';
	@override String get reportIssue => 'Signaler un problème';
	@override String get starOnGithub => 'Étoile sur GitHub';
	@override String get buyMeACoffee => 'Offrez-moi un café';
}

// Path: sidebar.branding
class Translations$sidebar$branding$fr extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Open Source';
}

// Path: sidebar.status
class Translations$sidebar$status$fr extends Translations$sidebar$status$en {
	Translations$sidebar$status$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get active => 'Actif';
	@override String get inactive => 'Inactif';
	@override String get thinking => 'Réflexion...';
	@override String get error => 'Erreur';
	@override String get aborted => 'Annulé';
	@override String get unknown => 'Inconnu';
}

// Path: sidebar.time
class Translations$sidebar$time$fr extends Translations$sidebar$time$en {
	Translations$sidebar$time$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'À l\'instant';
	@override String get oneMinuteAgo => 'Il y a 1 min';
	@override String minutesAgo({required Object count}) => 'Il y a ${count} min';
	@override String get oneHourAgo => 'Il y a 1 heure';
	@override String hoursAgo({required Object count}) => 'Il y a ${count} heures';
	@override String get oneDayAgo => 'Il y a 1 jour';
	@override String daysAgo({required Object count}) => 'Il y a ${count} jours';
}

// Path: sidebar.messages
class Translations$sidebar$messages$fr extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => 'Êtes-vous sûr de vouloir supprimer ceci ?';
	@override String get renameSuccess => 'Renommé avec succès';
	@override String get deleteSuccess => 'Supprimé avec succès';
	@override String get errorOccurred => 'Une erreur s\'est produite';
	@override String get deleteSessionConfirm => 'Êtes-vous sûr de vouloir supprimer cette session ? Cette action est irréversible.';
	@override String get deleteProjectConfirm => 'Retirer ce projet de la barre latérale ? Vos fichiers, mémoires et données de session ne seront pas supprimés.';
	@override String get enterProjectPath => 'Veuillez entrer un chemin de projet';
	@override String get deleteSessionFailed => 'Échec de la suppression de la session. Veuillez réessayer.';
	@override String get deleteSessionError => 'Erreur lors de la suppression de la session. Veuillez réessayer.';
	@override String get renameSessionFailed => 'Échec du renommage de la session. Veuillez réessayer.';
	@override String get renameSessionError => 'Erreur lors du renommage de la session. Veuillez réessayer.';
	@override String get deleteProjectFailed => 'Échec de la suppression du projet. Veuillez réessayer.';
	@override String get deleteProjectError => 'Erreur lors de la suppression du projet. Veuillez réessayer.';
	@override String get createProjectFailed => 'Échec de la création du projet. Veuillez réessayer.';
	@override String get createProjectError => 'Erreur lors de la création du projet. Veuillez réessayer.';
	@override String get updateProjectError => 'Erreur lors de la mise à jour du projet. Veuillez réessayer.';
	@override String get refreshError => 'Échec de l\'actualisation. Veuillez réessayer.';
	@override String get restoreProjectFailed => 'Échec de la restauration du projet. Veuillez réessayer.';
	@override String get restoreProjectError => 'Erreur lors de la restauration du projet. Veuillez réessayer.';
	@override String get restoreSessionFailed => 'Échec de la restauration de la session. Veuillez réessayer.';
	@override String get restoreSessionError => 'Erreur lors de la restauration de la session. Veuillez réessayer.';
	@override String get changeWorkspaceFailed => 'Échec du changement d’espace de travail. Veuillez réessayer.';
	@override String get changeWorkspaceError => 'Erreur lors du changement d’espace de travail. Veuillez réessayer.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Échec de la suppression de ${count} session. Veuillez réessayer.',
		other: 'Échec de la suppression de ${count} sessions. Veuillez réessayer.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$fr extends Translations$sidebar$version$en {
	Translations$sidebar$version$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Mise à jour disponible';
	@override String get restartRequired => 'Mise à jour installée — redémarrez le serveur pour l\'appliquer';
	@override String get updateNow => 'Mettre à jour';
	@override String updateConfirm({required Object version}) => 'Mettre à jour DDAgent vers v${version} ? Le dernier code sera récupéré et compilé, puis le serveur redémarrera — les sessions actives seront interrompues.';
	@override String get updating => 'Mise à jour… cela peut prendre quelques minutes';
	@override String get restarting => 'Mise à jour installée — redémarrage…';
	@override String get updateFailed => 'Échec de la mise à jour';
	@override String get releaseNotes => 'Notes de version';
}

// Path: sidebar.search
class Translations$sidebar$search$fr extends Translations$sidebar$search$en {
	Translations$sidebar$search$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Projets';
	@override String get modeConversations => 'Conversations';
	@override String get conversationsPlaceholder => 'Rechercher dans les conversations...';
	@override String get searching => 'Recherche en cours...';
	@override String get sessionTitles => 'Titres des sessions';
	@override String get conversationContents => 'Contenu des conversations';
	@override String get noResults => 'Aucun résultat trouvé';
	@override String get tryDifferentQuery => 'Essayez une autre requête de recherche';
	@override String get modeRunning => 'En cours';
	@override String get archiveOnly => 'Archives';
	@override String get runningTooltip => 'Sessions en cours';
	@override String get archiveOnlyTooltip => 'Archives uniquement';
	@override String runningCount({required Object count}) => '${count} actives';
	@override String get viewMenu => 'Affichage';
	@override String get backToProjects => 'Retour aux projets';
	@override String get archivedPlaceholder => 'Rechercher dans les archives...';
	@override String get runningPlaceholder => 'Rechercher les sessions en cours...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} résultat',
		other: '${count} résultats',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} projet analysé',
		other: '${count} projets analysés',
	);
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$fr extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Supprimer le projet';
	@override String get deleteSession => 'Supprimer la session';
	@override String get confirmDelete => 'Que souhaitez-vous faire avec';
	@override String get removeFromSidebar => 'Retirer de la barre latérale uniquement';
	@override String get deleteAllData => 'Supprimer toutes les données définitivement';
	@override String get allConversationsDeleted => 'Le projet sera retiré de la barre latérale. Vos fichiers, mémoires et données de session seront conservés.';
	@override String get cannotUndo => 'Vous pourrez rajouter le projet ultérieurement.';
	@override String get bulkDeleteSessionsDescription => 'L’archivage masque les sessions sélectionnées de la liste active tout en préservant leurs historiques.';
	@override String get archiveSession => 'Archiver la session';
	@override String get archiveSessionNotice => 'L’archivage retire la session de la liste active tout en préservant son historique.';
	@override String get archivedSessionNotice => 'Cette session est déjà archivée. Vous pouvez la garder masquée ou la supprimer définitivement.';
	@override String get deleteSessionNotice => 'Cela supprime définitivement la session et sa transcription. Cette action est irréversible.';
	@override String get deleteSessionPermanently => 'Supprimer définitivement';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Ce projet contient ${count} conversation.',
		other: 'Ce projet contient ${count} conversations.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Gérer la session sélectionnée',
		other: 'Gérer ${count} sessions sélectionnées',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Archiver la session',
		other: 'Archiver ${count} sessions',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$fr extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Actifs maintenant';
	@override String get recent => 'Récemment utilisés';
	@override String get today => 'Aujourd\'hui';
	@override String get yesterday => 'Hier';
	@override String get thisWeek => 'Cette semaine';
	@override String showMore({required Object count}) => 'Afficher ${count} de plus';
	@override String get showLess => 'Afficher moins';
}

// Path: sidebar.panel
class Translations$sidebar$panel$fr extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get open => 'Panneau';
	@override String get newChat => 'Nouvelle discussion';
	@override String get navigation => 'Navigation';
	@override String get sessions => 'Sessions';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$fr extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Changer l’espace de travail de la session';
	@override String get description => 'L’agent exécute ses prochaines étapes dans ce répertoire. L’historique de session existant est préservé.';
	@override String get pathLabel => 'Chemin de l’espace de travail';
	@override String get pathRequired => 'Le chemin de l’espace de travail est requis.';
	@override String get submit => 'Changer d’espace de travail';
	@override String get saving => 'Changement…';
	@override String get changeAction => 'Changer d’espace de travail';
}

// Path: sidebar.recent
class Translations$sidebar$recent$fr extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conversations récentes';
	@override String get emptyTitle => 'Aucune conversation pour le moment';
	@override String get emptyDescription => 'Vos conversations les plus récemment mises à jour apparaîtront ici.';
	@override String get loadFailed => 'Impossible de charger les conversations récentes';
	@override String get loadMore => 'Charger des conversations plus anciennes';
	@override String get loadingMore => 'Chargement...';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$fr extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get board => 'Tableau des agents';
	@override String get files => 'Fichiers';
	@override String get git => 'Contrôle de source';
	@override String get tasks => 'Tâches';
	@override String get usage => 'Quota et utilisation';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$fr extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI n\'est pas configuré';
	@override String get description => 'TaskMaster aide à décomposer des projets complexes en tâches gérables avec une assistance IA';
	@override String get whatIsTitle => '🎯 Qu\'est-ce que TaskMaster ?';
	@override late final Translations$tasks$notConfigured$features$fr features = Translations$tasks$notConfigured$features$fr._(_root);
	@override String get initializeButton => 'Initialiser TaskMaster AI';
	@override String get writePrdFirst => 'Rédigez d’abord un PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$fr extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Démarrer avec TaskMaster';
	@override String get subtitle => 'TaskMaster est initialisé ! Voici la suite :';
	@override late final Translations$tasks$gettingStarted$steps$fr steps = Translations$tasks$gettingStarted$steps$fr._(_root);
	@override String get tip => '💡 Astuce : Commencez par un PRD pour tirer le meilleur parti de la génération de tâches IA de TaskMaster';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$fr extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuration TaskMaster';
	@override String subtitle({required Object projectName}) => 'CLI interactif pour ${projectName}';
	@override String get willStart => 'L\'initialisation de TaskMaster démarrera automatiquement';
	@override String get completed => 'Configuration TaskMaster terminée ! Vous pouvez fermer cette fenêtre.';
	@override String get closeButton => 'Fermer';
	@override String get closeContinueButton => 'Fermer et continuer';
	@override String get closeTitle => 'Fermer';
	@override String get description => 'Crée un dossier .taskmaster dans ce projet. Aucun outil externe ni clé API requis — les tâches sont stockées localement.';
	@override String get initializeButton => 'Initialiser';
	@override String get initializing => 'Initialisation...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$fr extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Démarrer avec TaskMaster';
	@override String get subtitle => 'Votre guide pour une gestion productive des tâches';
	@override late final Translations$tasks$helpGuide$examples$fr examples = Translations$tasks$helpGuide$examples$fr._(_root);
	@override String get moreExamples => 'Voir plus d\'exemples et de patterns d\'utilisation →';
	@override late final Translations$tasks$helpGuide$proTips$fr proTips = Translations$tasks$helpGuide$proTips$fr._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$fr learnMore = Translations$tasks$helpGuide$learnMore$fr._(_root);
	@override String get closeTitle => 'Fermer';
}

// Path: tasks.search
class Translations$tasks$search$fr extends Translations$tasks$search$en {
	Translations$tasks$search$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Rechercher des tâches...';
}

// Path: tasks.filters
class Translations$tasks$filters$fr extends Translations$tasks$filters$en {
	Translations$tasks$filters$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get button => 'Filtres';
	@override String get status => 'Statut';
	@override String get priority => 'Priorité';
	@override String get sortBy => 'Trier par';
	@override String get allStatuses => 'Tous les statuts';
	@override String get allPriorities => 'Toutes les priorités';
	@override String showing({required Object filtered, required Object total}) => 'Affichage de ${filtered} sur ${total} tâches';
	@override String get clearFilters => 'Effacer les filtres';
}

// Path: tasks.sort
class Translations$tasks$sort$fr extends Translations$tasks$sort$en {
	Translations$tasks$sort$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Statut';
	@override String get priority => 'Priorité';
	@override String get idAsc => 'ID (croissant)';
	@override String get idDesc => 'ID (décroissant)';
	@override String get titleAsc => 'Titre (A-Z)';
	@override String get titleDesc => 'Titre (Z-A)';
	@override String get statusAsc => 'Statut (en attente en premier)';
	@override String get statusDesc => 'Statut (terminé en premier)';
	@override String get priorityAsc => 'Priorité (haute en premier)';
	@override String get priorityDesc => 'Priorité (basse en premier)';
}

// Path: tasks.views
class Translations$tasks$views$fr extends Translations$tasks$views$en {
	Translations$tasks$views$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Vue Kanban';
	@override String get list => 'Vue liste';
	@override String get grid => 'Vue grille';
}

// Path: tasks.kanban
class Translations$tasks$kanban$fr extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 À faire';
	@override String get inProgress => '🚀 En cours';
	@override String get review => '👀 Révision';
	@override String get done => '✅ Terminé';
	@override String get blocked => '🚫 Bloqué';
	@override String get deferred => '⏳ Différé';
	@override String get cancelled => '❌ Annulé';
	@override String get noTasksYet => 'Aucune tâche pour l\'instant';
	@override String get tasksWillAppear => 'Les tâches apparaîtront ici';
	@override String get moveTasksHere => 'Déplacez les tâches ici au démarrage';
	@override String get completedTasksHere => 'Les tâches terminées apparaissent ici';
	@override String get statusTasksHere => 'Les tâches avec ce statut apparaîtront ici';
}

// Path: tasks.buttons
class Translations$tasks$buttons$fr extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get help => 'Guide de démarrage TaskMaster';
	@override String get prds => 'PRD';
	@override String get addPRD => 'Ajouter un PRD';
	@override String get addTask => 'Ajouter une tâche';
	@override String get createNewPRD => 'Créer un nouveau PRD';
	@override String prdsAvailable({required Object count}) => '${count} PRD(s) disponible(s)';
}

// Path: tasks.prd
class Translations$tasks$prd$fr extends Translations$tasks$prd$en {
	Translations$tasks$prd$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Modifié : ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String fileExistsMessage({required Object name}) => 'Un PRD nommé « ${name} » existe déjà. Voulez-vous le remplacer ?';
	@override String get fileExistsTitle => 'Le fichier existe déjà';
	@override String get newFile => 'nouveau fichier';
	@override String get parse => 'Analyser le PRD';
	@override String get template => 'Modèle';
	@override String get fileNameHint => 'nom de fichier (ex. : prd.txt)';
	@override String get saved => 'PRD enregistré';
	@override String get tasksGenerated => 'Tâches générées à partir du PRD';
}

// Path: tasks.statuses
class Translations$tasks$statuses$fr extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get pending => 'En attente';
	@override String get inProgress => 'En cours';
	@override String get done => 'Terminé';
	@override String get blocked => 'Bloqué';
	@override String get deferred => 'Différé';
	@override String get cancelled => 'Annulé';
	@override String get review => 'Révision';
}

// Path: tasks.priorities
class Translations$tasks$priorities$fr extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get high => 'Haute';
	@override String get medium => 'Moyenne';
	@override String get low => 'Basse';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$fr extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aucune tâche ne correspond à vos filtres';
	@override String get description => 'Essayez d\'ajuster votre recherche ou vos critères de filtre.';
}

// Path: tasks.board
class Translations$tasks$board$fr extends Translations$tasks$board$en {
	Translations$tasks$board$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tableau d’agents';
	@override String get subtitle => 'Déplacez une carte vers Prêt et l’agent la prend en charge. Cliquez sur une carte pour ouvrir sa session.';
	@override String get newCard => 'Nouvelle carte';
	@override String get addCard => 'Ajouter une carte';
	@override String get refresh => 'Actualiser';
	@override late final Translations$tasks$board$empty$fr empty = Translations$tasks$board$empty$fr._(_root);
	@override late final Translations$tasks$board$columns$fr columns = Translations$tasks$board$columns$fr._(_root);
	@override late final Translations$tasks$board$card$fr card = Translations$tasks$board$card$fr._(_root);
	@override late final Translations$tasks$board$dialog$fr dialog = Translations$tasks$board$dialog$fr._(_root);
	@override String get noProject => 'Ajoutez d’abord un projet, puis créez des cartes pour celui-ci.';
	@override String get projectLabel => 'Projet';
	@override String get backToChat => 'Retour à la discussion';
	@override late final Translations$tasks$board$agent$fr agent = Translations$tasks$board$agent$fr._(_root);
	@override late final Translations$tasks$board$deleteConfirm$fr deleteConfirm = Translations$tasks$board$deleteConfirm$fr._(_root);
	@override String get project => 'Projet';
}

// Path: tasks.card
class Translations$tasks$card$fr extends Translations$tasks$card$en {
	Translations$tasks$card$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Dépend de : ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Tâche ${id}';
	@override String get highPriority => 'Priorité haute';
	@override String get lowPriority => 'Priorité basse';
	@override String get mediumPriority => 'Priorité moyenne';
	@override String get noPriority => 'Aucune priorité définie';
	@override String parentTask({required Object id}) => 'Tâche ${id}';
	@override String get progressLabel => 'Progression :';
	@override String progressTooltip({required Object completed, required Object total}) => '${completed} sous-tâches sur ${total} terminées';
	@override String get runTask => 'Exécuter la tâche';
	@override String runTaskAria({required Object id}) => 'Exécuter la tâche ${id}';
	@override String statusTooltip({required Object status}) => 'Statut : ${status}';
	@override String taskIdTitle({required Object id}) => 'ID de tâche : ${id}';
	@override String get taskInProgress => 'Tâche en cours';
}

// Path: tasks.createTask
class Translations$tasks$createTask$fr extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annuler';
	@override String get descriptionLabel => 'Description';
	@override String get descriptionPlaceholder => 'Détails optionnels';
	@override String get error => 'Échec de l’ajout de la tâche';
	@override String get priorityLabel => 'Priorité';
	@override String get submit => 'Ajouter la tâche';
	@override String get submitting => 'Ajout...';
	@override String get title => 'Ajouter une tâche';
	@override String get titleLabel => 'Titre';
	@override String get titlePlaceholder => 'Que faut-il faire ?';
}

// Path: tasks.list
class Translations$tasks$list$fr extends Translations$tasks$list$en {
	Translations$tasks$list$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Terminée (cliquer pour rouvrir)';
	@override String get inProgressComplete => 'En cours (cliquer pour terminer)';
	@override String get markCompleted => 'Marquer comme terminée';
	@override String toggleStatusAria({required Object id}) => 'Basculer le statut de la tâche ${id}';
	@override String get markDone => 'Marquer comme terminé';
	@override String get reopen => 'Rouvrir';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$fr extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Toutes les tâches sont terminées';
	@override String get feature1 => '- Gestion des tâches par IA avec dépendances et sous-tâches.';
	@override String get feature2 => '- Génération de tâches à partir de PRD pour un démarrage rapide.';
	@override String get feature3 => '- Vues kanban et liste pour l’exécution quotidienne.';
	@override String get hideDetails => 'Masquer les détails';
	@override String get initialize => 'Initialiser';
	@override String get noPending => 'Aucune tâche en attente';
	@override String get notConfigured => 'TaskMaster AI n’est pas configuré';
	@override String get review => 'Vérifier';
	@override String get startTask => 'Démarrer la tâche';
	@override String taskId({required Object id}) => 'Tâche ${id}';
	@override String get viewAll => 'Voir toutes les tâches';
	@override String get viewDetails => 'Voir les détails de la tâche';
	@override String get whatIs => 'Qu’est-ce que TaskMaster ?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$fr extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Annuler la modification';
	@override String get close => 'Fermer';
	@override String get copyTaskId => 'Copier l’ID de la tâche';
	@override String get delete => 'Supprimer la tâche';
	@override String deleteConfirmDescription({required Object title}) => '« ${title} » sera définitivement supprimée.';
	@override String get deleteConfirmTitle => 'Supprimer la tâche ?';
	@override String get deleteFailed => 'Échec de la suppression de la tâche';
	@override String get dependencies => 'Dépendances';
	@override String get dependenciesPlaceholder => 'ex. 1, 2, 3';
	@override String get description => 'Description';
	@override String get edit => 'Modifier la tâche';
	@override String get implDetails => 'Détails d’implémentation';
	@override String get noDependencies => 'Aucune dépendance';
	@override String get noDescription => 'Aucune description fournie';
	@override String get priority => 'Priorité';
	@override String get priorityNotSet => 'Non définie';
	@override String get save => 'Enregistrer';
	@override String get status => 'Statut';
	@override String get statusFailed => 'Échec de la mise à jour du statut de la tâche';
	@override String taskId({required Object id}) => 'Tâche ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Tâche ${id} : ${title}';
	@override String get testStrategy => 'Stratégie de test';
	@override String get titleRequired => 'Le titre est requis';
	@override String get updateFailed => 'Échec de la mise à jour de la tâche';
	@override String deleteConfirmMessage({required Object id}) => 'La tâche #${id} sera supprimée. Cette action est irréversible.';
	@override String get notFound => 'Tâche introuvable';
	@override String get subtasks => 'Sous-tâches';
	@override String get idCopied => 'ID de la tâche copié';
}

// Path: tasks.toasts
class Translations$tasks$toasts$fr extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Tâche ${id} définie comme en cours';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$fr extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Tableau';
	@override String get memories => 'Souvenirs';
	@override String get rules => 'Règles';
	@override String get skills => 'Compétences';
	@override String get personal => 'Personnel';
	@override String get graph => 'Graphe';
}

// Path: knowledge.common
class Translations$knowledge$common$fr extends Translations$knowledge$common$en {
	Translations$knowledge$common$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get add => 'Ajouter';
	@override String get save => 'Enregistrer';
	@override String get cancel => 'Annuler';
	@override String get delete => 'Supprimer';
	@override String get edit => 'Modifier';
	@override String get close => 'Fermer';
	@override String get restore => 'Restaurer';
	@override String get refresh => 'Actualiser';
	@override String get allProjects => 'Tous les projets';
	@override String get global => 'Global';
}

// Path: knowledge.actions
class Translations$knowledge$actions$fr extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Analyser les fichiers du projet';
	@override String get export => 'Exporter JSON';
	@override String get import => 'Importer JSON';
	@override String get scanComplete => 'Analyse terminée';
	@override String get importComplete => 'Import terminé';
	@override String get importFailed => 'Échec de l\'import';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$fr extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Nouvelle entrée';
	@override String get editEntity => 'Modifier l\'entrée';
	@override String get deleteTitle => 'Supprimer';
	@override String get deleteMessage => 'Supprimer cette entrée ? Action irréversible (l\'historique est conservé).';
	@override String get pickIcon => 'Choisir une icône';
	@override String get removeIcon => 'Retirer l\'icône';
	@override String get iconTooLarge => 'L\'icône est trop volumineuse (max 40 Ko).';
	@override String get importTitle => 'Importer des connaissances';
	@override String get importHint => 'Collez ici le JSON exporté';
	@override String get exportTitle => 'Exporter les connaissances';
	@override String get import => 'Importer';
}

// Path: knowledge.fields
class Translations$knowledge$fields$fr extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get key => 'Clé';
	@override String get title => 'Titre';
	@override String get name => 'Nom';
	@override String get description => 'Description';
	@override String get category => 'Catégorie';
	@override String get content => 'Contenu';
	@override String get priority => 'Priorité';
	@override String get tags => 'Étiquettes';
	@override String get enabled => 'Activé';
	@override String get projectScope => 'Portée du projet';
	@override String get tagsHint => 'séparées par des virgules';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$fr extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Souvenirs';
	@override String get rules => 'Règles';
	@override String get skills => 'Compétences';
	@override String get personal => 'Personnel';
	@override String get connections => 'Connexions';
	@override String get recent => 'Souvenirs récents';
	@override String get noMemories => 'Aucun souvenir. Ajoutez-en un dans l’onglet Souvenirs.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$fr extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Aucun souvenir.';
	@override String get rules => 'Aucune règle.';
	@override String get skills => 'Aucune compétence.';
	@override String get personal => 'Aucune information personnelle.';
	@override String get graph => 'Aucune entité à afficher.';
}

// Path: knowledge.history
class Translations$knowledge$history$fr extends Translations$knowledge$history$en {
	Translations$knowledge$history$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Historique';
	@override String get none => 'Aucun historique.';
	@override String get untitled => '(sans titre)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$fr extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Critique';
	@override String get high => 'Haute';
	@override String get normal => 'Normale';
	@override String get low => 'Basse';
}

// Path: knowledge.search
class Translations$knowledge$search$fr extends Translations$knowledge$search$en {
	Translations$knowledge$search$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Rechercher dans les connaissances';
	@override String get hint => 'Rechercher souvenirs, règles, compétences…';
	@override String get noResults => 'Aucun résultat.';
}

// Path: knowledge.links
class Translations$knowledge$links$fr extends Translations$knowledge$links$en {
	Translations$knowledge$links$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Lier des entités';
	@override String get source => 'Source';
	@override String get target => 'Cible';
	@override String get relationship => 'Relation';
	@override String get add => 'Créer un lien';
}

// Path: knowledge.tags
class Translations$knowledge$tags$fr extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get all => 'Toutes les étiquettes';
	@override String get manage => 'Gérer les étiquettes';
	@override String get none => 'Aucune étiquette.';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$fr extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
}

// Path: knowledge.critical
class Translations$knowledge$critical$fr extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get make => 'Marquer comme critique';
	@override String get makeAll => 'Marquer toutes les règles comme critiques';
	@override String get makeAllHint => 'Les ajoute au budget de contexte injecté';
}

// Path: knowledge.errors
class Translations$knowledge$errors$fr extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'Échec de l’import : ${error}';
	@override String migrationFailed({required Object error}) => 'Échec de la migration : ${error}';
}

// Path: knowledge.graph
class Translations$knowledge$graph$fr extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'tronqué';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$fr extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get action => 'Tout importer';
	@override String get mergeDuplicates => 'Fusionner les entrées en double';
	@override String get mergeDuplicatesHint => 'Regroupe les lignes en double dans DDAgent (pas les fichiers)';
	@override String projectsScanned({required Object count}) => 'Projets analysés : ${count}';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Règles : ${total} · groupes de doublons : ${duplicates}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Compétences d’agent trouvées : ${found} (nouvelles : ${newSkills})';
	@override String get title => 'Tout importer dans DDAgent';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$fr extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String found({required Object count}) => '${count} compétence(s) trouvée(s) dans vos agents.';
	@override String summary({required Object imported, required Object skipped}) => 'Nouvelles : ${imported} · ignorées : ${skipped}';
	@override String get title => 'Importer les compétences d’agent';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$fr extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Souvenir : ${title}';
	@override String personal({required Object title}) => 'Personnel : ${title}';
	@override String rule({required Object title}) => 'Règle : ${title}';
	@override String skill({required Object name}) => 'Compétence : ${name}';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$fr extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String duplicates({required Object count}) => 'Groupes de doublons entre projets : ${count}';
	@override String get mergeDuplicates => 'Fusionner les doublons';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Supprimés : ${removed}, promus : ${promoted}';
	@override String rulesSummary({required Object total, required Object critical}) => 'Règles : ${total} au total, ${critical} critiques.';
	@override String scanned({required Object count}) => '${count} projet(s) analysé(s).';
	@override String get title => 'Migrer les règles existantes';
}

// Path: skills.addDialog
class Translations$skills$addDialog$fr extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => 'Choisir SKILL.md';
	@override String get chooseFiles => 'Choisir des fichiers';
	@override String get chooseFolder => 'Choisir un dossier';
	@override String get chooseFolderTitle => 'Choisir un dossier de compétences';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} fichier · ${size}',
		other: '${count} fichiers · ${size}',
	);
	@override String get folderUploadsNote => 'Les téléversements de dossiers conservent le nom du dossier sélectionné ; les fichiers isolés utilisent le `name` de `SKILL.md`.';
	@override String get hideInstallLocation => 'Masquer l’emplacement d’installation';
	@override String get installSkill => 'Installer la compétence';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Installer ${count} compétence',
		other: 'Installer ${count} compétences',
	);
	@override String markdownFileMeta({required Object size}) => 'Fichier Markdown · ${size}';
	@override String get pickHint => 'Les dossiers peuvent inclure des scripts, des références et des ressources.';
	@override String get pickTitle => 'Choisissez un dossier de compétences ou un SKILL.md';
	@override String get readyToInstall => 'Prêt à installer';
	@override String removeQueued({required Object name}) => 'Retirer ${name}';
	@override String title({required Object provider}) => 'Ajouter une compétence ${provider}';
	@override String get uploadHint => 'Téléversez un fichier SKILL.md ou un dossier de compétences complet.';
	@override String get whereWillThisInstall => 'Où cela sera-t-il installé ?';
}

// Path: skills.empty
class Translations$skills$empty$fr extends Translations$skills$empty$en {
	Translations$skills$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get noGlobalSkills => 'Aucune compétence globale détectée pour l’instant';
	@override String get noGlobalSkillsDescription => 'Ajoutez une compétence globale ci-dessus pour la rendre disponible dans tous les projets.';
	@override String get noMatchingSkills => 'Aucune compétence correspondante';
	@override String get noMatchingSkillsDescription => 'Essayez une autre commande, un autre nom, une autre portée, un autre projet ou un autre chemin source.';
	@override String get noProjects => 'Aucun projet disponible';
	@override String get noProjectsDescription => 'Ajoutez un projet ou un espace de travail pour parcourir ses compétences.';
	@override String get noSkillsInProject => 'Aucune compétence dans ce projet';
	@override String get noSkillsInProjectDescription => 'Créez un dossier .claude/skills, .cursor/skills ou .agents/skills dans le projet sélectionné.';
}

// Path: skills.errors
class Translations$skills$errors$fr extends Translations$skills$errors$en {
	Translations$skills$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get addMarkdownFirst => 'Ajoutez d’abord un ou plusieurs fichiers markdown.';
	@override String couldNotReadSkillFile({required Object name}) => 'Impossible de lire SKILL.md depuis ${name}.';
	@override String get dropMarkdownOrFolder => 'Déposez un ou plusieurs fichiers markdown ou un dossier contenant SKILL.md.';
	@override String folderFileLimit({required Object count}) => 'Un dossier de compétences peut contenir jusqu’à ${count} fichiers.';
	@override String get folderReadFailed => 'Échec de la lecture du dossier de compétences';
	@override String get folderSizeLimit => 'Les dossiers de compétences sélectionnés doivent totaliser moins de 30 Mo.';
	@override String get importFailed => 'Échec de l’import des compétences';
	@override String get missingSkillFile => 'Le dossier sélectionné ne contient pas de fichier SKILL.md.';
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$fr extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get moveToGlobal => 'Déplacer vers global';
	@override String get moveToProject => 'Déplacer vers le projet';
	@override String get toGlobalHint => 'Déplacez cette compétence dans le répertoire de compétences global pour que tous les projets puissent l’utiliser.';
	@override String get toProjectHint => 'Choisissez le projet auquel cette compétence doit appartenir. Elle quitte le répertoire de compétences global du fournisseur.';
}

// Path: skills.scopes
class Translations$skills$scopes$fr extends Translations$skills$scopes$en {
	Translations$skills$scopes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get admin => 'Admin';
	@override String get plugin => 'Plugin';
	@override String get project => 'Projet';
	@override String get repo => 'Repo';
	@override String get system => 'Système';
	@override String get user => 'Utilisateur';
}

// Path: skills.screen
class Translations$skills$screen$fr extends Translations$skills$screen$en {
	Translations$skills$screen$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get addSkill => 'Ajouter une compétence';
	@override String get clearSearch => 'Effacer la recherche de compétences';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Cela supprime le répertoire ${directory} du répertoire de compétences géré par ${provider}. Cette action est irréversible.';
	@override String deleteTitle({required Object name}) => 'Supprimer ${name} ?';
	@override String loadingSkills({required Object provider}) => 'Chargement des compétences de ${provider}…';
	@override String manageDescription({required Object provider}) => 'Gérez les compétences de ${provider} à partir de fichiers locaux, de dossiers complets et d’emplacements liés au projet.';
	@override String get noDescription => 'Aucune description fournie dans le front matter de la compétence.';
	@override String pluginBadge({required Object name}) => 'Plugin : ${name}';
	@override String projectBadge({required Object name}) => 'Projet : ${name}';
	@override String get savedSuccessfully => 'Compétences enregistrées avec succès.';
	@override String get scanningProjectSkills => 'Analyse des compétences du projet...';
	@override String get searchHint => 'Rechercher des compétences...';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} COMPÉTENCE',
		other: '${count} COMPÉTENCES',
	);
	@override String get sourceLabel => 'SOURCE';
}

// Path: mcp.form
class Translations$mcp$form$fr extends Translations$mcp$form$en {
	Translations$mcp$form$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$fields$fr fields = Translations$mcp$form$fields$fr._(_root);
	@override late final Translations$mcp$form$scope$fr scope = Translations$mcp$form$scope$fr._(_root);
	@override String submitTo({required Object provider}) => 'Ajouter le serveur à ${provider}';
	@override late final Translations$mcp$form$validation$fr validation = Translations$mcp$form$validation$fr._(_root);
}

// Path: mcp.install
class Translations$mcp$install$fr extends Translations$mcp$install$en {
	Translations$mcp$install$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get button => 'Installer';
	@override String get cardDescription => 'Donnez à vos agents la base de connaissances et les outils DDAgent via MCP — choisissez des agents ou installez pour tous.';
	@override String get description => 'Permet aux agents sélectionnés d’utiliser la base de connaissances et les outils DDAgent via MCP.';
	@override String get errorFallback => 'erreur';
	@override String failed({required Object error}) => 'Échec de l’installation : ${error}';
	@override String get installForAll => 'Installer pour tous';
	@override String get installSelected => 'Installer la sélection';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Installé sur ${count} agent.',
		other: 'Installé sur ${count} agents.',
	);
	@override String partialFailure({required Object count, required Object failed}) => 'Installé sur ${count} ; échec : ${failed}';
	@override String get title => 'Installer le serveur MCP DDAgent';
}

// Path: mcp.servers
class Translations$mcp$servers$fr extends Translations$mcp$servers$en {
	Translations$mcp$servers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get addGlobalDescription => 'Ajoute ce serveur MCP à tous les fournisseurs : Claude, Cursor, Codex, OpenCode et Devin. Seuls les transports stdio et HTTP sont pris en charge, car la même configuration doit fonctionner pour tous les fournisseurs.';
	@override String get addGlobalMenuDescription => 'Ajouter un serveur MCP global écrit un serveur stdio ou HTTP commun pour Claude, Cursor, Codex, OpenCode et Devin.';
	@override String get addGlobalTitle => 'Ajouter un serveur MCP global';
	@override String addProviderDescription({required Object provider}) => 'Ajouter un serveur MCP ${provider} ne modifie que ${provider}.';
	@override String addProviderTitle({required Object provider}) => 'Ajouter un serveur MCP ${provider}';
	@override late final Translations$mcp$servers$config$fr config = Translations$mcp$servers$config$fr._(_root);
	@override String descriptionGeneric({required Object provider}) => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à ${provider}';
	@override String get loading => 'Chargement des serveurs MCP...';
	@override String get refreshingScopes => 'Actualisation des portées du projet...';
}

// Path: mcp.team
class Translations$mcp$team$fr extends Translations$mcp$team$en {
	Translations$mcp$team$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cta => 'Disponible avec DDAgent Pro';
	@override String get description => 'Partagez les configurations de serveurs MCP avec votre équipe. Tout le monde reste synchronisé automatiquement.';
	@override String get title => 'Configurations MCP d’équipe';
}

// Path: mcp.tokens
class Translations$mcp$tokens$fr extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Écriture';
}

// Path: terminal.actions
class Translations$terminal$actions$fr extends Translations$terminal$actions$en {
	Translations$terminal$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get clearOutput => 'Effacer la sortie';
	@override String get connect => 'Connecter';
	@override String get newShell => 'Nouveau shell';
	@override String get newTab => 'Nouvel onglet de terminal';
	@override String get providerLogin => 'Connexion au fournisseur';
	@override String get restartSession => 'Redémarrer la session';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$fr extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Ouvrir dans le navigateur';
}

// Path: terminal.errors
class Translations$terminal$errors$fr extends Translations$terminal$errors$en {
	Translations$terminal$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'Impossible d’ouvrir le lien : ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$fr extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'Fichier détecté : ${path}';
}

// Path: terminal.paste
class Translations$terminal$paste$fr extends Translations$terminal$paste$en {
	Translations$terminal$paste$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Ctrl+V / clic droit → Coller';
	@override String get title => 'Coller dans le terminal';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$fr extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get eof => 'EOF';
	@override String get hide => 'Masquer la barre de raccourcis';
	@override String get interrupt => 'Interrompre (SIGINT)';
	@override String get suspend => 'Suspendre (SIGTSTP)';
	@override String get showTooltip => 'Afficher les raccourcis';
	@override String get hideTooltip => 'Masquer les raccourcis';
}

// Path: terminal.tabs
class Translations$terminal$tabs$fr extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get antigravityCli => 'CLI Antigravity';
	@override String get claudeCli => 'CLI Claude';
	@override String get commandCodeCli => 'CLI Command Code';
	@override String get cursorCli => 'CLI Cursor';
	@override String get devinCli => 'CLI Devin';
	@override String loginTitle({required Object provider}) => 'Connexion : ${provider}';
	@override String get opencodeCli => 'CLI OpenCode';
	@override String get plainShell => 'Shell simple';
	@override String shellName({required Object index}) => 'Shell ${index}';
}

// Path: quota.agents
class Translations$quota$agents$fr extends Translations$quota$agents$en {
	Translations$quota$agents$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.chart
class Translations$quota$chart$fr extends Translations$quota$chart$en {
	Translations$quota$chart$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get hide => 'Masquer';
	@override String get noData => 'Données insuffisantes pour une tendance.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokens · ${cost}';
	@override String get show => 'Afficher';
}

// Path: quota.config
class Translations$quota$config$fr extends Translations$quota$config$en {
	Translations$quota$config$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get accountRouting => 'Routage des comptes';
	@override String get pollerTitle => 'Interrogation et alertes';
	@override String get save => 'Enregistrer la configuration';
}

// Path: quota.overview
class Translations$quota$overview$fr extends Translations$quota$overview$en {
	Translations$quota$overview$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Tokens et coût';
}

// Path: quota.section
class Translations$quota$section$fr extends Translations$quota$section$en {
	Translations$quota$section$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get config => 'Configuration';
}

// Path: notifications.errors
class Translations$notifications$errors$fr extends Translations$notifications$errors$en {
	Translations$notifications$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get noResponse => 'Aucune réponse du serveur';
	@override String get registrationRejected => 'Inscription refusée par le serveur';
}

// Path: serverConnect.local
class Translations$serverConnect$local$fr extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cet appareil';
	@override String get subtitle => 'Exécuter le serveur DDAgent sur cette machine';
	@override String get install => 'Installer le serveur local';
	@override String get start => 'Démarrer le serveur local';
	@override String get stop => 'Arrêter';
	@override String get starting => 'Démarrage du serveur local…';
	@override String downloading({required Object percent}) => 'Téléchargement du serveur… ${percent} %';
	@override String get installing => 'Installation…';
	@override String running({required Object url}) => 'En cours d\'exécution sur ${url}';
	@override String installed({required Object version}) => 'Installé (v${version})';
	@override String get connect => 'Utiliser ce serveur';
	@override String error({required Object error}) => 'Erreur du serveur local : ${error}';
	@override String get or => 'ou connectez-vous à un serveur distant';
}

// Path: collab.roles
class Translations$collab$roles$fr extends Translations$collab$roles$en {
	Translations$collab$roles$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get member => 'Membre';
	@override String get viewer => 'Lecteur';
}

// Path: sessions.activity
class Translations$sessions$activity$fr extends Translations$sessions$activity$en {
	Translations$sessions$activity$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get committingChanges => 'Validation des modifications';
	@override String editingFile({required Object file}) => 'Modification de ${file}';
	@override String get editingFileGeneric => 'Modification d’un fichier';
	@override String fetchingUrl({required Object url}) => 'Récupération de ${url}';
	@override String get pushingBranch => 'Envoi de la branche';
	@override String readingFile({required Object file}) => 'Lecture de ${file}';
	@override String runningCommand({required Object command}) => 'Exécution de `${command}`';
	@override String get runningShellCommand => 'Exécution d’une commande shell';
	@override String runningTool({required Object name}) => 'Exécution de ${name}';
	@override String searching({required Object query}) => 'Recherche de « ${query} »';
	@override String get subagentRunning => 'Sous-agent en cours d’exécution';
}

// Path: sessions.age
class Translations$sessions$age$fr extends Translations$sessions$age$en {
	Translations$sessions$age$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String days({required Object days}) => '${days} j';
	@override String hours({required Object hours}) => '${hours} h';
	@override String get lessThanMinute => '<1 min';
	@override String minutes({required Object count}) => '${count} min';
}

// Path: sessions.toasts
class Translations$sessions$toasts$fr extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Session archivée';
	@override String get deleted => 'Session supprimée';
	@override String get pinned => 'Session épinglée';
	@override String get renamed => 'Session renommée';
	@override String get restored => 'Session restaurée';
	@override String get unpinned => 'Session désépinglée';
	@override String get workspaceChanged => 'Espace de travail modifié';
}

// Path: git.checkpoints
class Translations$git$checkpoints$fr extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get create => 'Nouveau';
	@override String get empty => 'Aucun checkpoint pour l’instant';
	@override String get labelHint => 'Libellé du checkpoint (optionnel)';
	@override String get restoreMessage => 'Réinitialiser l’arbre de travail sur ce checkpoint ? Les modifications actuelles seront remplacées.';
	@override String get restoreTitle => 'Restaurer le checkpoint';
	@override String get restored => 'Checkpoint restauré';
	@override String get title => 'Checkpoints';
}

// Path: kanban.card
class Translations$kanban$card$fr extends Translations$kanban$card$en {
	Translations$kanban$card$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Sans titre';
}

// Path: kanban.comments
class Translations$kanban$comments$fr extends Translations$kanban$comments$en {
	Translations$kanban$comments$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get add => 'Ajouter un commentaire';
	@override String get empty => 'Aucun commentaire pour l’instant';
}

// Path: kanban.details
class Translations$kanban$details$fr extends Translations$kanban$details$en {
	Translations$kanban$details$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String status({required Object status}) => 'Statut : ${status}';
	@override String get title => 'Détails de la carte';
}

// Path: kanban.dialog
class Translations$kanban$dialog$fr extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Enregistrement…';
}

// Path: kanban.empty
class Translations$kanban$empty$fr extends Translations$kanban$empty$en {
	Translations$kanban$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Aucun projet sélectionné';
}

// Path: kanban.time
class Translations$kanban$time$fr extends Translations$kanban$time$en {
	Translations$kanban$time$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Il y a 1 jour',
		other: 'Il y a ${count} jours',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Il y a 1 heure',
		other: 'Il y a ${count} heures',
	);
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Il y a 1 minute',
		other: 'Il y a ${count} minutes',
	);
	@override String get now => 'à l’instant';
}

// Path: onboarding.agents
class Translations$onboarding$agents$fr extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Connectez-vous à un ou plusieurs assistants de codage IA. Tous sont optionnels.';
	@override String get laterHint => 'Vous pourrez les configurer plus tard dans les Paramètres.';
	@override String get title => 'Connectez vos agents IA';
}

// Path: onboarding.errors
class Translations$onboarding$errors$fr extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get invalidEmail => 'Veuillez saisir une adresse e-mail valide.';
	@override String get nameAndEmailRequired => 'Le nom et l’e-mail git sont tous deux requis.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$fr extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Installez le serveur MCP DDAgent pour que vos agents puissent utiliser la base de connaissances et les outils DDAgent. Choisissez des agents ou installez pour tous.';
	@override String get installForAll => 'Installer pour tous';
	@override String get installSelected => 'Installer la sélection';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Installé sur ${count} agent.',
		other: 'Installé sur ${count} agents.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => 'Installé sur ${installedCount} ; échec : ${failed}';
	@override String get laterHint => 'Optionnel — vous pouvez aussi l’installer plus tard dans Paramètres → MCP.';
	@override String get title => 'Connecter les agents à DDAgent';
}

// Path: fileTree.search
class Translations$fileTree$search$fr extends Translations$fileTree$search$en {
	Translations$fileTree$search$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Filtrer les noms / Entrée pour rechercher dans le contenu';
	@override String get noMatches => 'Aucun résultat';
	@override String get prompt => 'Saisissez une requête et appuyez sur Entrée';
	@override String get resultsTruncated => 'Résultats tronqués';
}

// Path: fileTree.titles
class Translations$fileTree$titles$fr extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String delete({required Object name}) => 'Supprimer ${name}';
	@override String download({required Object name}) => 'Télécharger ${name}';
	@override String rename({required Object name}) => 'Renommer ${name}';
}

// Path: auth.login.errors
class Translations$auth$login$errors$fr extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Nom d\'utilisateur ou mot de passe incorrect';
	@override String get requiredFields => 'Veuillez remplir tous les champs';
	@override String get networkError => 'Erreur réseau. Veuillez réessayer.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$fr extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get username => 'Entrez votre nom d\'utilisateur';
	@override String get password => 'Entrez votre mot de passe';
}

// Path: auth.register.errors
class Translations$auth$register$errors$fr extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Les mots de passe ne correspondent pas';
	@override String get usernameTaken => 'Ce nom d\'utilisateur est déjà pris';
	@override String get weakPassword => 'Le mot de passe est trop faible';
	@override String get usernameTooShort => 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
	@override String get passwordTooShort => 'Le mot de passe doit contenir au moins 6 caractères';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$fr extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Mode par défaut';
	@override String get auto => 'Mode automatique';
	@override String get acceptEdits => 'Accepter les modifications';
	@override String get bypassPermissions => 'Contourner les permissions';
	@override String get plan => 'Mode planification';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$fr extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Seules les commandes de confiance (ls, cat, grep, git status, etc.) s\'exécutent automatiquement. Les autres commandes sont ignorées. Peut écrire dans l\'espace de travail.';
	@override String get auto => 'Un classifieur de modèle décide pour chaque appel d\'outil d\'approuver ou refuser. Mode mains libres, mais plus sûr que le contournement — des refus peuvent toujours se produire.';
	@override String get acceptEdits => 'Toutes les commandes s\'exécutent automatiquement dans l\'espace de travail. Mode entièrement automatique avec exécution sandboxée.';
	@override String get bypassPermissions => 'Accès système complet sans restrictions. Toutes les commandes s\'exécutent automatiquement avec accès disque et réseau complet. À utiliser avec précaution.';
	@override String get plan => 'Mode planification - aucune commande n\'est exécutée';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$fr extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Entrée pour envoyer • / commandes • @ fichiers';
	@override String get enter => 'Entrée pour envoyer • Maj+Entrée nouvelle ligne • / commandes • @ fichiers';
	@override String get queue => 'Entrée pour mettre en file votre prochain message';
	@override String get updateQueued => 'Entrée pour mettre à jour le message en file';
}

// Path: chat.input.queue
class Translations$chat$input$queue$fr extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Mettre le message suivant en file';
	@override String get update => 'Mettre à jour le message en file';
	@override String get label => 'En file';
	@override String get willSend => 'Sera envoyé une fois terminé';
	@override String get edit => 'Modifier le message en file';
	@override String get delete => 'Supprimer le message en file';
	@override String get failed => 'Échec de l’envoi';
	@override String get sendNow => 'Envoyer maintenant';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$fr extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Annuler et vider la file hors ligne';
	@override String get clearBtn => 'Annuler';
	@override String multiple({required Object count}) => '${count} messages en file hors ligne — seront envoyés automatiquement à la reconnexion';
	@override String get single => '1 message en file hors ligne — sera envoyé automatiquement à la reconnexion';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$fr extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'par Anthropic';
	@override String get openai => 'par OpenAI';
	@override String get cursorEditor => 'Éditeur de code IA';
	@override String get google => 'par Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$fr extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Prêt à utiliser Claude avec ${model}. Commencez à taper votre message ci-dessous.';
	@override String cursor({required Object model}) => 'Prêt à utiliser Cursor avec ${model}. Commencez à taper votre message ci-dessous.';
	@override String codex({required Object model}) => 'Prêt à utiliser Codex avec ${model}. Commencez à taper votre message ci-dessous.';
	@override String opencode({required Object model}) => 'Prêt à utiliser OpenCode avec ${model}. Commencez à taper votre message ci-dessous.';
	@override String get kDefault => 'Sélectionnez un fournisseur ci-dessus pour commencer';
	@override String devin({required Object model}) => 'Prêt avec Devin ${model}';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$fr extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Continuer votre conversation';
	@override String get description => 'Posez des questions sur votre code, demandez des modifications ou obtenez de l\'aide pour vos tâches de développement';
	@override String get action => 'Continuer à écrire';
}

// Path: chat.session.loading
class Translations$chat$session$loading$fr extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Chargement des messages précédents...';
	@override String get sessionMessages => 'Chargement des messages de la session...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$fr extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => 'Affichage de ${shown} sur ${total} messages';
	@override String get scrollToLoad => 'Faites défiler vers le haut pour charger plus';
	@override String showingLast({required Object count, required Object total}) => 'Affichage des ${count} derniers messages (${total} au total)';
	@override String get loadEarlier => 'Charger les messages précédents';
	@override String get loadAll => 'Charger tous les messages';
	@override String get loadingAll => 'Chargement de tous les messages...';
	@override String get allLoaded => 'Tous les messages chargés';
	@override String get perfWarning => 'Tous les messages chargés — le défilement peut être plus lent. Cliquez sur « Défiler vers le bas » pour rétablir les performances.';
	@override String get loadOlderFailed => 'Échec du chargement des anciens messages.';
	@override String get retry => 'Réessayer';
	@override String get noSearchMatches => 'Aucun message ne correspond à votre recherche.';
	@override String loadAllCount({required Object count}) => 'Tout charger (${count})';
	@override String get loadOlder => 'Charger les anciens messages';
	@override String retryLoadOlder({required Object error}) => 'Réessayer de charger les anciens messages — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$fr extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sélectionner un projet';
	@override String get description => 'Choisissez un projet pour ouvrir un shell interactif dans ce répertoire';
}

// Path: chat.shell.status
class Translations$chat$shell$status$fr extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nouvelle session';
	@override String get initializing => 'Initialisation...';
	@override String get restarting => 'Redémarrage...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$fr extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Déconnecter';
	@override String get disconnectTitle => 'Se déconnecter du shell';
	@override String get restart => 'Redémarrer';
	@override String get restartTitle => 'Redémarrer le shell';
	@override String get connect => 'Continuer dans le shell';
	@override String get connectTitle => 'Se connecter au shell';
	@override String get kill => 'Tuer (SIGINT)';
	@override String get killTitle => 'Tuer le processus en cours (Ctrl+C)';
	@override String get copyOutput => 'Copier la sortie';
	@override String get copyOutputTitle => 'Copier la sortie du terminal';
	@override String get copied => 'Copié !';
	@override String get zoomInTitle => 'Zoom avant';
	@override String get zoomOutTitle => 'Zoom arrière';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$fr extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Réflexion';
	@override String get processing => 'Traitement';
	@override String get analyzing => 'Analyse';
	@override String get working => 'Travail';
	@override String get computing => 'Calcul';
	@override String get reasoning => 'Raisonnement';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$fr extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get live => 'En direct';
	@override String get paused => 'En pause';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$fr extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}s';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '${time} écoulé';
	@override String get startingNow => 'Démarrage';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$fr extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Arrêter la génération';
	@override String get pressEscToStop => 'Appuyez sur Échap à tout moment pour arrêter';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$fr extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Assistant';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$fr extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get config => 'Ouvrir les paramètres et la configuration.';
	@override String get cost => 'Consulter la consommation de tokens de la session active.';
	@override String get help => 'Afficher la documentation et la syntaxe des commandes.';
	@override String get memory => 'Ouvrir le fichier de mémoire CLAUDE.md du projet.';
	@override String get models => 'Parcourir les modèles disponibles pour le fournisseur actif.';
	@override String get status => 'Inspecter le runtime, la version, le fournisseur et l’état de l’environnement.';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$fr extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Renommer';
	@override String get delete => 'Supprimer';
	@override String get copyPath => 'Copier le chemin';
	@override String get download => 'Télécharger';
	@override String get newFile => 'Nouveau fichier';
	@override String get newFolder => 'Nouveau dossier';
	@override String get upload => 'Téléverser des fichiers';
	@override String get refresh => 'Actualiser';
	@override String get menuLabel => 'Menu contextuel du fichier';
	@override String get loading => 'Chargement...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$fr extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Supprimer';
	@override String get fileWarning => 'Ce fichier sera définitivement supprimé.';
	@override String get folderWarning => 'Ce dossier et tout son contenu seront définitivement supprimés.';
	@override String title({required Object type}) => 'Supprimer ${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$fr extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'Échec de la copie du chemin';
	@override String get fileCreated => 'Fichier créé avec succès';
	@override String get fileDeleted => 'Fichier supprimé';
	@override String get folderCreated => 'Dossier créé avec succès';
	@override String get folderDeleted => 'Dossier supprimé';
	@override String get folderDownloaded => 'Dossier téléchargé en ZIP';
	@override String get pathCopied => 'Chemin copié dans le presse-papiers';
	@override String get renamed => 'Renommé avec succès';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$fr extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'Le nom de fichier ne peut pas contenir uniquement des points';
	@override String get emptyName => 'Le nom de fichier ne peut pas être vide';
	@override String get invalidChars => 'Le nom de fichier contient des caractères invalides';
	@override String get reserved => 'Le nom de fichier est un nom réservé';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$fr extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get type => 'Type';
	@override String get configure => 'Configurer';
	@override String get confirm => 'Confirmer';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$fr extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get question => 'Avez-vous déjà un espace de travail, ou souhaitez-vous en créer un nouveau ?';
	@override late final Translations$common$projectWizard$step1$existing$fr existing = Translations$common$projectWizard$step1$existing$fr._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$fr kNew = Translations$common$projectWizard$step1$kNew$fr._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$fr extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Chemin de l\'espace de travail';
	@override String get newPath => 'Chemin de l\'espace de travail';
	@override String get existingPlaceholder => '/chemin/vers/espace-de-travail';
	@override String get newPlaceholder => '/chemin/vers/nouvel-espace';
	@override String get existingHelp => 'Chemin complet vers votre répertoire d\'espace de travail existant';
	@override String get newHelp => 'Chemin complet vers votre répertoire d\'espace de travail';
	@override String get githubUrl => 'URL GitHub (optionnel)';
	@override String get githubPlaceholder => 'https://github.com/utilisateur/depot';
	@override String get githubHelp => 'Optionnel : fournissez une URL GitHub pour cloner un dépôt';
	@override String get githubAuth => 'Authentification GitHub (optionnel)';
	@override String get githubAuthHelp => 'Uniquement requis pour les dépôts privés. Les dépôts publics peuvent être clonés sans authentification.';
	@override String get loadingTokens => 'Chargement des tokens enregistrés...';
	@override String get storedToken => 'Token enregistré';
	@override String get newToken => 'Nouveau token';
	@override String get nonePublic => 'Aucun (Public)';
	@override String get selectToken => 'Sélectionner un token';
	@override String get selectTokenPlaceholder => '-- Sélectionner un token --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Ce token sera utilisé uniquement pour cette opération';
	@override String get publicRepoInfo => 'Les dépôts publics ne nécessitent pas d\'authentification. Vous pouvez ignorer le token pour cloner un dépôt public.';
	@override String get noTokensHelp => 'Aucun token enregistré. Vous pouvez en ajouter dans Paramètres → Clés API.';
	@override String get optionalTokenPublic => 'Token GitHub (optionnel pour les dépôts publics)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (laisser vide pour les dépôts publics)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$fr extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Vérifiez votre configuration';
	@override String get existingWorkspace => 'Espace de travail existant';
	@override String get newWorkspace => 'Nouvel espace de travail';
	@override String get path => 'Chemin :';
	@override String get cloneFrom => 'Cloner depuis :';
	@override String get authentication => 'Authentification :';
	@override String get usingStoredToken => 'Utilisation du token enregistré :';
	@override String get usingProvidedToken => 'Utilisation du token fourni';
	@override String get noAuthentication => 'Sans authentification';
	@override String get sshKey => 'Clé SSH';
	@override String get existingInfo => 'L\'espace de travail sera ajouté à votre liste de projets et disponible pour les sessions Claude/Cursor.';
	@override String get newWithClone => 'Le dépôt sera cloné depuis ce dossier.';
	@override String get newEmpty => 'L\'espace de travail sera ajouté à votre liste de projets et disponible pour les sessions Claude/Cursor.';
	@override String get cloningRepository => 'Clonage du dépôt...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$fr extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annuler';
	@override String get back => 'Retour';
	@override String get next => 'Suivant';
	@override String get createProject => 'Créer le projet';
	@override String get creating => 'Création...';
	@override String get cloning => 'Clonage...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$fr extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Veuillez indiquer si vous avez un espace de travail existant ou si vous souhaitez en créer un nouveau';
	@override String get providePath => 'Veuillez fournir un chemin d\'espace de travail';
	@override String get failedToCreate => 'Échec de la création de l\'espace de travail';
	@override String get failedToCreateFolder => 'Échec de la création du dossier';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$fr extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$fr generic = Translations$common$notifications$codes$generic$fr._(_root);
	@override late final Translations$common$notifications$codes$permission$fr permission = Translations$common$notifications$codes$permission$fr._(_root);
	@override late final Translations$common$notifications$codes$run$fr run = Translations$common$notifications$codes$run$fr._(_root);
	@override late final Translations$common$notifications$codes$agent$fr agent = Translations$common$notifications$codes$agent$fr._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$fr extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get close => 'Fermer';
	@override String get later => 'Plus tard';
	@override String get copyCommand => 'Copier la commande';
	@override String get updateNow => 'Mettre à jour maintenant';
	@override String get updating => 'Mise à jour...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$fr extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Fermer la fenêtre de mise à jour';
	@override String get showSidebar => 'Afficher la barre latérale';
	@override String get settings => 'Paramètres';
	@override String get updateAvailable => 'Mise à jour disponible';
	@override String get closeSidebar => 'Masquer la barre latérale';
}

// Path: common.quota.section
class Translations$common$quota$section$fr extends Translations$common$quota$section$en {
	Translations$common$quota$section$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Aperçu';
	@override String get quotas => 'Quotas';
	@override String get usage => 'Utilisation';
	@override String get agents => 'Agents';
}

// Path: common.quota.filter
class Translations$common$quota$filter$fr extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get all => 'Tous';
}

// Path: common.quota.period
class Translations$common$quota$period$fr extends Translations$common$quota$period$en {
	Translations$common$quota$period$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 jours';
	@override String get k30d => '30 jours';
	@override String get all => 'Tous';
}

// Path: common.quota.group
class Translations$common$quota$group$fr extends Translations$common$quota$group$en {
	Translations$common$quota$group$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Fournisseur';
	@override String get model => 'Modèle';
	@override String get agent => 'Agent';
	@override String get tool => 'Outil';
}

// Path: common.quota.metric
class Translations$common$quota$metric$fr extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Tokens';
	@override String get input => 'Entrée';
	@override String get output => 'Sortie';
	@override String get cache => 'Lectures cache';
	@override String get calls => 'Appels API';
	@override String get cost => 'Coût';
	@override String get sessions => 'Sessions';
}

// Path: common.quota.cost
class Translations$common$quota$cost$fr extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Facturé (API + dépassement)';
	@override String get listPrice => 'Prix catalogue des tokens utilisés';
	@override String get subscriptionValue => 'Couvert par les abonnements';
	@override String get cacheSavings => 'Économies de cache';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$fr extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Facturé (API + dépassement)';
	@override String get listPrice => 'Prix catalogue des tokens utilisés';
	@override String get subscriptionValue => 'Couvert par les abonnements';
}

// Path: common.quota.overview
class Translations$common$quota$overview$fr extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tokens et coût — 7 derniers jours';
	@override String get effectiveCost => 'Coût effectif (7 jours)';
	@override String get alertsTitle => 'Alertes';
	@override String get noAlerts => 'Rien ne requiert votre attention pour le moment.';
	@override String get limitsTitle => 'Utilisation et limites';
	@override String get activeTasks => 'Tâches actives';
	@override String get viewAccounts => 'Tous les comptes';
	@override String get viewAgents => 'Tous les agents';
	@override String get noTasks => 'Aucun agent en cours d’exécution.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$fr extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tendance quotidienne';
	@override String breakdownTitle({required Object group}) => 'Répartition par ${group}';
	@override String get colName => 'Nom';
	@override String get sourceUnavailable => 'Magasin d’analytique indisponible ; aucune donnée affichée.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$fr extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} en cours';
	@override String get colAgent => 'Agent';
	@override String get colStatus => 'Statut';
	@override String get colTask => 'Tâche';
	@override String get colModel => 'Compte / modèle';
	@override String get colTime => 'Heure';
	@override String get empty => 'Aucun agent ne correspond à ce filtre.';
	@override String get detailSession => 'Session';
	@override String get detailStarted => 'Démarré';
	@override String get detailRetries => 'Réessais';
	@override String get detailResult => 'Résultat';
	@override String get notTracked => 'non suivi';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$fr extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get running => 'En cours';
	@override String get waiting => 'En attente';
	@override String get failed => 'Échoué';
	@override String get finished => 'Terminé';
	@override String get queued => 'En file';
}

// Path: common.quota.alert
class Translations$common$quota$alert$fr extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window} : au rythme actuel, la limite sera atteinte dans ${value}';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window} : ${value} % utilisé (seuil ${watch} %)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$fr extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get live => 'En direct';
	@override String get cached => 'En cache';
	@override String get estimate => 'Estimation';
	@override String get unknown => 'Inconnu';
	@override String get error => 'Erreur';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$fr extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Limites à risque';
	@override String atRiskHint({required Object value}) => 'comptes au-dessus de ${value} %';
	@override String get windowsAtRisk => 'Fenêtres en épuisement';
	@override String get errored => 'Échecs de synchronisation';
	@override String get activeAgents => 'Agents actifs';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} en attente · ${queued} en file';
	@override String get nextReset => 'Prochaine réinitialisation';
	@override String get tokens => 'Tokens';
	@override String sessionsHint({required Object value}) => '${value} sessions';
	@override String get cost => 'Coût estimé';
	@override String costHint({required Object value}) => '${value} couvert par les abonnements';
}

// Path: common.quota.empty
class Translations$common$quota$empty$fr extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aucun compte connecté';
	@override String get description => 'Connectez-vous à Claude, Codex, Gemini ou CommandCode pour suivre les quotas ici.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$fr extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Alertes et routage';
	@override String get description => 'Contrôlez quand le tableau de bord vous avertit et comment les comptes sont suggérés pour le nouveau travail.';
	@override String get alertsEnabled => 'Alertes prédictives et de seuil';
	@override String get alertsEnabledHint => 'Avertir avant qu’une limite ne s’épuise au rythme actuel, pas seulement à 90 %.';
	@override String get watchThreshold => 'Seuil de surveillance (%)';
	@override String get dangerThreshold => 'Seuil de danger (%)';
	@override String get routingMode => 'Routage';
	@override late final Translations$common$quota$settings$routing$fr routing = Translations$common$quota$settings$routing$fr._(_root);
	@override String get logSources => 'Sources de journaux';
	@override String get logSourcesHint => 'Les écrans d’utilisation et d’agents lisent ces sources en lecture seule.';
	@override String get quotaConsent => 'Autoriser l’interrogation des quotas';
	@override String get quotaConsentHint => 'Interroge les points de terminaison des fournisseurs avec vos identifiants stockés pour lire les limites en direct.';
	@override String get perAccount => 'Remplacements par compte';
	@override String get tab => 'Paramètres du Control Center';
}

// Path: common.quota.range
class Translations$common$quota$range$fr extends Translations$common$quota$range$en {
	Translations$common$quota$range$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Tous';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$fr extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Activez Browser dans les paramètres pour permettre aux agents d’ouvrir des sessions de navigateur surveillées.';
	@override String get descEnabled => 'Les sessions de navigateur des agents apparaissent ici lorsqu’une tâche IA utilise Browser.';
	@override String get titleDisabled => 'Browser est désactivé';
	@override String get titleEnabled => 'Aucune session de navigateur pour le moment';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$fr extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'L’action du navigateur a échoué';
	@override String get loadFailed => 'Échec du chargement de Browser';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$fr extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Utilisez Browser pour inspecter le parcours de paiement et signaler les états d’UI défectueux.';
	@override String get prompt2 => 'Ouvrez <url> avec Browser, interagissez avec la page et résumez ce qui a changé après chaque étape.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$fr extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' j';
	@override String get hoursAgo => ' h';
	@override String get justNow => 'À l’instant';
	@override String get minutesAgo => ' min';
	@override String get never => 'Jamais';
	@override String get secondsAgo => ' s';
	@override String get unknown => 'Inconnu';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$fr extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Désactivé';
	@override String get installing => 'Installation';
	@override String get ready => 'Prêt';
	@override String get setupRequired => 'Configuration requise';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$fr extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Parcourir toutes les branches (${count})';
	@override String commits({required Object count}) => 'Parcourir tous les commits (${count})';
	@override String files({required Object count}) => 'Parcourir tous les fichiers (${count})';
	@override String sessions({required Object count}) => 'Parcourir toutes les sessions (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$fr extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'Le coût est une estimation côté client basée sur les tarifs par token publiés ; les modèles inconnus affichent « — ».';
	@override String get estCost => 'Coût est.';
	@override String get inputOutput => 'Entrée / Sortie';
	@override String get model => 'Modèle';
	@override String get na => 'N/D';
	@override String get openSplit => 'Ouvrir en vue divisée';
	@override String get provider => 'Fournisseur';
	@override String get selectSession => 'Sélectionner une session…';
	@override String get tokensUsed => 'Tokens utilisés';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$fr extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Actions';
	@override String get branches => 'Branches';
	@override String get commits => 'Commits';
	@override String get files => 'Fichiers';
	@override String get git => 'Git';
	@override String get navigate => 'Naviguer';
	@override String get sessions => 'Sessions';
	@override String get settings => 'Paramètres';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$fr extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get close => 'Fermer';
	@override String get navigate => 'Naviguer';
	@override String get select => 'Sélectionner';
	@override String get togglePalette => 'Basculer la palette';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$fr extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Comparer les sessions';
	@override String get gitFetch => 'Git : Fetch';
	@override String get gitPull => 'Git : Pull';
	@override String get gitPush => 'Git : Push';
	@override String get openSettings => 'Ouvrir les paramètres';
	@override String get selectProjectFirst => 'Sélectionnez d’abord un projet';
	@override String settingsEntry({required Object label}) => 'Paramètres : ${label}';
	@override String get startNewChat => 'Démarrer une nouvelle conversation';
	@override String switchTo({required Object name}) => 'Basculer vers : ${name}';
	@override String get toggleTheme => 'Basculer le thème';
	@override String get tokensAndCost => 'tokens et coût';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$fr extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get board => 'Aller au tableau des agents';
	@override String get chat => 'Aller au chat';
	@override String get files => 'Aller aux fichiers';
	@override String get git => 'Aller à Git';
	@override String get sourceControl => 'Aller au contrôle de source';
	@override String get tasks => 'Aller aux tâches';
	@override String get usage => 'Aller à Quota et utilisation';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$fr extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Actions';
	@override String get branches => 'Branches';
	@override String get commits => 'Commits';
	@override String get compare => 'Comparer';
	@override String get files => 'Fichiers';
	@override String get sessions => 'Sessions';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$fr extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => 'Supprimer la branche « ${branch} » ? Une suppression normale ne réussit que si la branche est entièrement fusionnée. Cette action est irréversible.';
	@override String confirmSwitch({required Object branch}) => 'Basculer vers la branche « ${branch} » ? Assurez-vous de n’avoir aucune modification non validée.';
	@override String countBoth({required Object local, required Object remote}) => '${local} locales, ${remote} distantes';
	@override String countLocal({required Object count}) => '${count} locales';
	@override String get current => 'actuelle';
	@override String deleteTitle({required Object branch}) => 'Supprimer ${branch}';
	@override String get emptyDesc => 'Créez une branche pour commencer un travail parallèle.';
	@override String get forceDelete => 'Forcer la suppression';
	@override String get forceDeleteDesc => 'Supprime définitivement la branche même si elle contient des commits non fusionnés ailleurs.';
	@override String get forceDeleteLabel => 'Forcer la suppression de cette branche non fusionnée';
	@override String get local => 'Locales';
	@override String get kNew => 'Nouvelle branche';
	@override String get noMatch => 'Aucune branche ne correspond à votre recherche';
	@override String get none => 'Aucune branche trouvée';
	@override String get remote => 'distantes';
	@override String get kSwitch => 'Basculer';
	@override String switchTo({required Object branch}) => 'Basculer vers ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$fr extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Confirmer';
	@override String get delete => 'Supprimer';
	@override String get deleteBranch => 'Supprimer';
	@override String get discard => 'Ignorer';
	@override String get publish => 'Publier';
	@override String get pull => 'Tirer';
	@override String get push => 'Pousser';
	@override String get revertLocalCommit => 'Annuler le commit';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$fr extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Confirmer l’action';
	@override String get delete => 'Supprimer le fichier';
	@override String get deleteBranch => 'Supprimer la branche';
	@override String get discard => 'Ignorer les modifications';
	@override String get publish => 'Publier la branche';
	@override String get pull => 'Confirmer le pull';
	@override String get push => 'Confirmer le push';
	@override String get revertLocalCommit => 'Annuler le commit local';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$fr extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Échec de la création de la branche';
	@override String get createWorktreeFailed => 'Échec de la création du worktree';
	@override String get deleteBranchFailed => 'Échec de la suppression de la branche';
	@override String get fetchFailed => 'Échec du fetch';
	@override String get initFailed => 'Échec de l’initialisation du dépôt';
	@override String get initialCommitFailed => 'Échec de la création du commit initial';
	@override String get mergeFailed => 'Échec de la fusion';
	@override String get openWorktreeFailed => 'Échec de l’ouverture du worktree';
	@override String get operationFailed => 'L’opération git a échoué';
	@override String get publishFailed => 'Échec de la publication';
	@override String get pullFailed => 'Échec du pull';
	@override String get pushFailed => 'Échec du push';
	@override String get removeWorktreeFailed => 'Échec de la suppression du worktree';
	@override String get stageFailed => 'Échec de l’indexation';
	@override String get stageHunksFailed => 'Échec de l’indexation des sections';
	@override String get switchFailed => 'Échec du changement de branche';
	@override String get unstageFailed => 'Échec du retrait de l’index';
	@override String get unstageHunksFailed => 'Échec du retrait des sections de l’index';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$fr extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get added => 'Ajouté';
	@override String get author => 'Auteur';
	@override String get changedFiles => 'Fichiers modifiés';
	@override String get date => 'Date';
	@override String get empty => 'Aucun commit trouvé';
	@override String get files => 'Fichiers';
	@override String get removed => 'Supprimé';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$fr extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Supprimer le worktree et sa branche une fois fusionnée';
	@override String get cleanupLabel => 'Nettoyer après la fusion';
	@override String commitCount({required Object count}) => '${count} commit(s)';
	@override String get merge => 'Fusionner';
	@override String mergeMessage({required Object branch}) => 'Fusionner la branche \'${branch}\'';
	@override String get messageLabel => 'Message de commit';
	@override String squashDesc({required Object commits, required Object branch}) => 'Combiner tous les ${commits} en un seul commit sur ${branch}';
	@override String get squashLabel => 'Squasher les commits';
	@override String get squashMerge => 'Squash et fusion';
	@override String squashMessage({required Object branch}) => 'Squash-fusionner la branche \'${branch}\'';
	@override String get title => 'Fusionner le worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$fr extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Cela créera une nouvelle branche depuis la branche actuelle (${branch})';
	@override String get nameLabel => 'Nom de la branche';
	@override String get submit => 'Créer la branche';
	@override String get title => 'Créer une nouvelle branche';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$fr extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Branche';
	@override String get createFrom => 'Créer depuis';
	@override String get description => 'Extrayez une branche dans son propre dossier et travaillez dessus en parallèle.';
	@override String get existingBranch => 'Branche existante — elle sera extraite telle quelle.';
	@override String get submit => 'Créer le worktree';
	@override String get switchAfter => 'Basculer vers le worktree après sa création';
	@override String get title => 'Nouveau worktree';
	@override String get willCreateIn => 'Sera créé dans';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$fr extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get create => 'Créer le commit initial';
	@override String get creating => 'Création du commit initial...';
	@override String get description => 'Ce dépôt n’a pas encore de commits. Créez votre premier commit pour commencer à suivre les modifications.';
	@override String get title => 'Pas encore de commits';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$fr extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Ce projet n’est pas encore un dépôt git. Initialisez-en un pour suivre les modifications et utiliser le contrôle de source.';
	@override String get init => 'Exécuter git init';
	@override String get initializing => 'Initialisation du dépôt...';
	@override String get title => 'Pas de dépôt git';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$fr extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Supprimer aussi la branche';
	@override String description({required Object branch}) => 'Supprimer le worktree de ${branch} ? Son dossier est supprimé et le projet lié archivé — les sessions de chat restent récupérables.';
	@override String dirtyWarning({required Object count}) => 'Ce worktree a ${count} modification(s) non validée(s) qui seront perdues.';
	@override String get discardChanges => 'Ignorer les modifications non validées';
	@override String get title => 'Supprimer le worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$fr extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get added => 'Ajouté';
	@override String get deleted => 'Supprimé';
	@override String get modified => 'Modifié';
	@override String get untracked => 'Non suivi';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$fr extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} modification(s)';
	@override String count({required Object count}) => '${count} worktree(s)';
	@override String get createFirst => 'Créez votre premier worktree';
	@override String get detached => 'détaché';
	@override String detachedAt({required Object sha}) => 'détaché @ ${sha}';
	@override String get detachedHead => 'HEAD détaché';
	@override String get emptyDesc => 'Un worktree extrait une branche dans son propre dossier, vous permettant de mener des sessions de chat parallèles et de fusionner les résultats une fois prêts.';
	@override String get emptyTitle => 'Travaillez sur des branches en parallèle';
	@override String get locked => 'verrouillé';
	@override String get mainWorktree => 'worktree principal';
	@override String mergeTitle({required Object branch}) => 'Fusionner ${branch} dans la branche de base';
	@override String get kNew => 'Nouveau worktree';
	@override String get none => 'Aucun worktree';
	@override String get nothingToMerge => 'Rien à fusionner — aucun commit en avance sur la branche de base';
	@override String get open => 'Ouvrir';
	@override String get refresh => 'Actualiser les worktrees';
	@override String removeTitle({required Object branch}) => 'Supprimer le worktree de ${branch}';
	@override String switchTo({required Object branch}) => 'Basculer vers ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$fr extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Modifications';
	@override String get history => 'Commits';
	@override String get branches => 'Branches';
	@override String get worktrees => 'Worktrees';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$fr extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Portée';
	@override String get user => 'Utilisateur';
	@override String get project => 'Projet';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$fr extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get dark => 'Sombre';
	@override String get light => 'Clair';
	@override String get system => 'Système';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$fr extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Apparence';
	@override String get toolDisplay => 'Affichage des outils';
	@override String get inputSettings => 'Paramètres de saisie';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$fr extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Glissement en cours';
	@override String get closePanel => 'Fermer le panneau de paramètres';
	@override String get openPanel => 'Ouvrir le panneau de paramètres';
	@override String get draggingStatus => 'Glissement...';
	@override String get toggleAndMove => 'Cliquer pour basculer, glisser pour déplacer';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$fr extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Fermer le panneau de raccourcis';
	@override String get openPanel => 'Ouvrir le panneau de raccourcis';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$fr extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$fr extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
	@override late final Translations$settings$orchestration$pool$fields$fr fields = Translations$settings$orchestration$pool$fields$fr._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$fr extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$fr extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$fr taskTypes = Translations$settings$orchestration$rules$taskTypes$fr._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$fr extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$fr modes = Translations$settings$orchestration$planner$modes$fr._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$fr modeHints = Translations$settings$orchestration$planner$modeHints$fr._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$fr templates = Translations$settings$orchestration$planner$templates$fr._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$fr extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$fr onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$fr._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$fr extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

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
class Translations$settings$notifications$webPush$fr extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifications push web';
	@override String get enable => 'Activer les notifications push';
	@override String get disable => 'Désactiver les notifications push';
	@override String get enabled => 'Les notifications push sont activées';
	@override String get loading => 'Mise à jour...';
	@override String get unsupported => 'Les notifications push ne sont pas prises en charge dans ce navigateur.';
	@override String get denied => 'Les notifications push sont bloquées. Veuillez les autoriser dans les paramètres de votre navigateur.';
	@override String get iosHint => 'Sur iPhone/iPad, les notifications ne fonctionnent qu’après avoir ajouté DDAgent à l’écran d’accueil (Partager → Ajouter à l’écran d’accueil) et les avoir activées depuis l’app installée.';
	@override String get test => 'Envoyer une notification de test';
	@override String get testNoSubscription => 'Aucun appareil n’est abonné. Touchez d’abord « Activer » sur le téléphone.';
	@override String testSuccess({required Object count}) => 'Envoyé à ${count} appareil(s). Si rien n’apparaît sur le téléphone, ajoutez DDAgent à l’écran d’accueil (requis par iOS).';
	@override String get testNotDelivered => 'Aucun appareil n\'était joignable. Vérifiez que l\'application est en cours d\'exécution et que les notifications sont activées.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$fr extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifier cet appareil';
	@override String get enabled => 'Les notifications sont activées pour cet appareil';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$fr extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Son';
	@override String get description => 'Jouer un court son lorsqu\'une exécution de chat se termine.';
	@override String get enabled => 'Activé';
	@override String get test => 'Tester le son';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$fr extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Types d\'événements';
	@override String get actionRequired => 'Action requise';
	@override String get stop => 'Exécution arrêtée';
	@override String get error => 'Exécution échouée';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$fr extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifier cette application de bureau';
	@override String get enable => 'Activer les notifications push';
	@override String get disable => 'Désactiver les notifications push';
	@override String get enabled => 'Les notifications sont activées pour cette application de bureau';
	@override String get unsupported => 'Les notifications de bureau ne sont pas prises en charge sur ce système.';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$fr extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get discord => 'Discord';
	@override String get telegram => 'Telegram';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$fr extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Mode sombre';
	@override String get description => 'Basculer entre les thèmes clair et sombre';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$fr extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Éditeur de code';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$fr theme = Translations$settings$appearanceSettings$codeEditor$theme$fr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$fr wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$fr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$fr showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$fr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$fr lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$fr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$fr fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$fr._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$fr extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$fr focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$fr._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$fr extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get add => 'Ajouter un serveur MCP';
	@override String get edit => 'Modifier le serveur MCP';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$fr extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get form => 'Saisie via formulaire';
	@override String get json => 'Import JSON';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$fr extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Portée';
	@override String get userGlobal => 'Utilisateur (global)';
	@override String get projectLocal => 'Projet (local)';
	@override String get userDescription => 'Portée utilisateur : Disponible dans tous les projets sur votre machine';
	@override String get projectDescription => 'Portée locale : Disponible uniquement dans le projet sélectionné';
	@override String get cannotChange => 'La portée ne peut pas être modifiée lors de la modification d\'un serveur existant';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$fr extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Nom du serveur';
	@override String get transportType => 'Type de transport';
	@override String get command => 'Commande';
	@override String get arguments => 'Arguments (un par ligne)';
	@override String get jsonConfig => 'Configuration JSON';
	@override String get url => 'URL';
	@override String get envVars => 'Variables d\'environnement (CLÉ=valeur, une par ligne)';
	@override String get headers => 'En-têtes (CLÉ=valeur, un par ligne)';
	@override String get selectProject => 'Sélectionner un projet...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$fr extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'mon-serveur';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$fr extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Champ requis manquant : type';
	@override String get stdioRequiresCommand => 'Le type stdio nécessite un champ command';
	@override String httpRequiresUrl({required Object type}) => 'Le type ${type} nécessite un champ url';
	@override String get invalidJson => 'Format JSON invalide';
	@override String get jsonHelp => 'Collez la configuration de votre serveur MCP en format JSON. Exemples :';
	@override String get jsonExampleStdio => '• stdio : {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse : {"type":"http","url":"https://api.exemple.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$fr extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Annuler';
	@override String get saving => 'Enregistrement...';
	@override String get addServer => 'Ajouter le serveur';
	@override String get updateServer => 'Mettre à jour le serveur';
}

// Path: settings.git.name
class Translations$settings$git$name$fr extends Translations$settings$git$name$en {
	Translations$settings$git$name$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Nom Git';
	@override String get help => 'Votre nom pour les commits git';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$fr extends Translations$settings$git$email$en {
	Translations$settings$git$email$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'E-mail Git';
	@override String get help => 'Votre e-mail pour les commits git';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$fr extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get save => 'Enregistrer la configuration';
	@override String get saving => 'Enregistrement...';
}

// Path: settings.git.status
class Translations$settings$git$status$fr extends Translations$settings$git$status$en {
	Translations$settings$git$status$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get success => 'Enregistré avec succès';
	@override String get error => 'Échec de l’enregistrement';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$fr extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ Sauvegardez votre clé API';
	@override String get alertMessage => 'C\'est la seule fois que vous verrez cette clé. Stockez-la en lieu sûr.';
	@override String get iveSavedIt => 'Je l\'ai sauvegardée';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$fr extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Nom de la clé API (ex. : Serveur de production)';
	@override String get createButton => 'Créer';
	@override String get cancelButton => 'Annuler';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$fr extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get created => 'Créée :';
	@override String get lastUsed => 'Dernière utilisation :';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$fr extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get active => 'Actif';
	@override String get inactive => 'Inactif';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$fr extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tokens GitHub';
	@override String get description => 'Ajoutez des tokens d\'accès personnel GitHub pour cloner des dépôts privés via l\'API externe.';
	@override String get descriptionAlt => 'Ajoutez des tokens d\'accès personnel GitHub pour cloner des dépôts privés. Vous pouvez aussi passer des tokens directement dans les requêtes API sans les stocker.';
	@override String get addButton => 'Ajouter un token';
	@override late final Translations$settings$apiKeys$github$form$fr form = Translations$settings$apiKeys$github$form$fr._(_root);
	@override String get empty => 'Aucun token GitHub ajouté pour l\'instant.';
	@override String get added => 'Ajouté :';
	@override String get confirmDelete => 'Êtes-vous sûr de vouloir supprimer ce token GitHub ?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$fr extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Documentation de l\'API externe';
	@override String get description => 'Apprenez à utiliser l\'API externe pour déclencher des sessions Claude/Cursor depuis vos applications.';
	@override String get viewLink => 'Voir la documentation API →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$fr extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Mise à jour disponible : v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$fr extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'CLI TaskMaster AI non installé';
	@override String get description => 'Le CLI TaskMaster est requis pour utiliser les fonctionnalités de gestion des tâches. Installez-le pour commencer :';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'Voir sur GitHub';
	@override String get afterInstallation => 'Après l\'installation :';
	@override late final Translations$settings$tasks$notInstalled$steps$fr steps = Translations$settings$tasks$notInstalled$steps$fr._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$fr extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'Activer l\'intégration TaskMaster';
	@override String get enableDescription => 'Afficher les tâches TaskMaster, les bannières et les indicateurs dans la barre latérale';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$fr extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Vérification...';
	@override String get connected => 'Connecté';
	@override String get notConnected => 'Non connecté';
	@override String get disconnected => 'Déconnecté';
	@override String get checkingAuth => 'Vérification du statut d\'authentification...';
	@override String loggedInAs({required Object email}) => 'Connecté en tant que ${email}';
	@override String providerAccount({required Object provider}) => 'Compte ${provider}';
	@override String get authenticatedUser => 'utilisateur authentifié';
}

// Path: settings.agents.install
class Translations$settings$agents$install$fr extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => 'La CLI ${agent} n\'est pas installée';
	@override String description({required Object agent}) => 'Installez la CLI ${agent} pour vous connecter et lancer des sessions.';
	@override String get button => 'Installer';
	@override String get installing => 'Installation…';
	@override String get copyCommand => 'Copier la commande';
	@override String get docs => 'Documentation';
	@override String success({required Object agent}) => 'CLI ${agent} installée';
	@override String get failed => 'Échec de l\'installation — vérifiez la sortie du terminal';
}

// Path: settings.agents.update
class Translations$settings$agents$update$fr extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mettre à jour le CLI';
	@override String description({required Object agent}) => 'Installe la dernière version du CLI ${agent} sur l\'hôte du serveur.';
	@override String get button => 'Mettre à jour';
	@override String get updating => 'Mise à jour…';
	@override String success({required Object agent}) => 'CLI ${agent} mis à jour';
	@override String get failed => 'Échec de la mise à jour — consultez la sortie du terminal';
}

// Path: settings.agents.account
class Translations$settings$agents$account$fr extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$fr claude = Translations$settings$agents$account$claude$fr._(_root);
	@override late final Translations$settings$agents$account$cursor$fr cursor = Translations$settings$agents$account$cursor$fr._(_root);
	@override late final Translations$settings$agents$account$codex$fr codex = Translations$settings$agents$account$codex$fr._(_root);
	@override late final Translations$settings$agents$account$opencode$fr opencode = Translations$settings$agents$account$opencode$fr._(_root);
	@override late final Translations$settings$agents$account$commandcode$fr commandcode = Translations$settings$agents$account$commandcode$fr._(_root);
	@override late final Translations$settings$agents$account$antigravity$fr antigravity = Translations$settings$agents$account$antigravity$fr._(_root);
	@override late final Translations$settings$agents$account$devin$fr devin = Translations$settings$agents$account$devin$fr._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$fr extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Connexion';
	@override String get reAuthenticate => 'Se ré-authentifier';
	@override String description({required Object agent}) => 'Connectez-vous à votre compte ${agent} pour activer les fonctionnalités IA';
	@override String get reAuthDescription => 'Connectez-vous avec un autre compte ou actualisez les identifiants';
	@override String get button => 'Se connecter';
	@override String get reLoginButton => 'Se reconnecter';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$fr extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Se déconnecter';
	@override String get description => 'Se déconnecter de ce fournisseur et effacer ses identifiants enregistrés';
	@override String get button => 'Se déconnecter';
	@override String confirmTitle({required Object agent}) => 'Se déconnecter de ${agent} ?';
	@override String confirmDescription({required Object agent}) => 'Cela supprime les identifiants ${agent} enregistrés sur le serveur. Reconnectez-vous pour continuer à utiliser ${agent}.';
	@override String get success => 'Déconnecté';
	@override String get failed => 'Échec de la déconnexion';
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$fr extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mode de permission';
	@override String description({required Object provider}) => 'Mode de permission par défaut pour les nouvelles sessions ${provider}. Vous pouvez toujours le remplacer pour une session individuelle.';
	@override late final Translations$settings$permissions$permissionMode$modes$fr modes = Translations$settings$permissions$permissionMode$modes$fr._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$fr extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Claude';
	@override String get cursor => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Cursor';
	@override String get codex => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Codex';
	@override String get opencode => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à OpenCode';
	@override String get commandcode => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Command Code';
	@override String get antigravity => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Antigravity';
	@override String get devin => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Devin';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$fr extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get local => 'local';
	@override String get user => 'utilisateur';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$fr extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get command => 'Commande';
	@override String get url => 'URL';
	@override String get args => 'Arguments';
	@override String get environment => 'Environnement';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$fr extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Outils';
	@override String count({required Object count}) => '(${count}) :';
	@override String more({required Object count}) => '+${count} de plus';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$fr extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Modifier le serveur';
	@override String get delete => 'Supprimer le serveur';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$fr extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'À propos de Codex MCP';
	@override String get description => 'Codex prend en charge les serveurs MCP basés sur stdio. Vous pouvez ajouter des serveurs qui étendent les capacités de Codex avec des outils et ressources supplémentaires.';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$fr extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Géré';
	@override String get hint => 'Géré par DDAgent.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$fr extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '« ${serverName} » sera supprimé de la configuration du fournisseur.';
	@override String get title => 'Supprimer le serveur MCP ?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$fr extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => 'Seuils d’alerte, politique de routage et comptes interrogés pour les quotas.';
	@override String get saved => 'Enregistré';
	@override String get alertsSection => 'Alertes';
	@override String get alertsSectionHint => 'Avertir avant qu’une limite soit réellement épuisée, pas seulement à 100 %.';
	@override String get alertsEnabled => 'Alertes de limite prévues';
	@override String get alertsEnabledHint => 'Afficher des projections basées sur le rythme dans l’aperçu et les cartes de compte.';
	@override String get watchThreshold => 'Seuil de surveillance (%)';
	@override String get watchThresholdHint => 'Les comptes à ce relevé ou au-dessus sont comptés comme à risque.';
	@override String get dangerThreshold => 'Seuil de danger (%)';
	@override String get dangerThresholdHint => 'Les relevés à cette valeur ou au-dessus sont affichés en rouge.';
	@override String get routingSection => 'Routage';
	@override String get routingSectionHint => 'Comment le panneau peut déplacer le travail vers le compte avec le plus de marge.';
	@override late final Translations$settings$quota$settings$routing$fr routing = Translations$settings$quota$settings$routing$fr._(_root);
	@override String get routingNote => 'Changer de compte modifie le coût et la qualité du modèle, donc cela requiert toujours une décision explicite.';
	@override String get accountsSection => 'Comptes interrogés';
	@override String get accountsSectionHint => 'Les identifiants sont lus depuis chaque outil ; le panneau ne les envoie nulle part ailleurs.';
	@override String get sourcesSection => 'Sources de données';
	@override String get sourcesSectionHint => 'D’où proviennent les chiffres d’utilisation et de coût.';
	@override String get logSources => 'Magasin de journaux de tokens et coûts';
	@override String get logSourcesHint => 'Magasin d’agrégats en lecture seule partagé avec le collecteur tokboard.';
	@override String get readOnly => 'Lecture seule';
	@override String get quotaConsent => 'Interrogation des quotas';
	@override String get quotaConsentHint => 'Lit les points de terminaison de quota des fournisseurs avec les identifiants stockés localement.';
	@override String get localOnly => 'Local uniquement';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$fr extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Aucun compte détecté pour le moment.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$fr extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cached => 'en cache';
	@override String get error => 'erreur';
	@override String get estimate => 'estimation';
	@override String get live => 'en direct';
	@override String get unknown => 'inconnu';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$fr extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'Échec de l’installation du runtime du navigateur';
	@override String get loadSettings => 'Échec du chargement des paramètres Browser';
	@override String get loadStatus => 'Échec du chargement du statut Browser';
	@override String get saveSettings => 'Échec de l’enregistrement des paramètres Browser';
}

// Path: settings.about.pro
class Translations$settings$about$pro$fr extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Synchroniser les paramètres';
	@override String get teamManagement => 'Gestion d’équipe';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$fr extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'Gestion des tâches assistée par IA : Décomposez des projets complexes en sous-tâches gérables';
	@override String get prdTemplates => 'Modèles PRD : Générez des tâches à partir de documents d\'exigences produit';
	@override String get dependencyTracking => 'Suivi des dépendances : Comprenez les relations entre tâches et l\'ordre d\'exécution';
	@override String get progressVisualization => 'Visualisation de l\'avancement : Tableaux Kanban et analyses détaillées des tâches';
	@override String get cliIntegration => 'Intégration CLI : Utilisez les commandes taskmaster pour des flux de travail avancés';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$fr extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$fr createPRD = Translations$tasks$gettingStarted$steps$createPRD$fr._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$fr generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$fr._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$fr analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$fr._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$fr startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$fr._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$fr extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Exemple :\n« Je viens d\'initialiser un nouveau projet avec Claude Task Master. J\'ai un PRD dans .taskmaster/docs/prd.txt. Pouvez-vous m\'aider à l\'analyser et configurer les tâches initiales ? »';
	@override String get expandTask => '💬 Exemple :\n« La tâche 5 semble complexe. Pouvez-vous la décomposer en sous-tâches ? »';
	@override String get addTask => '💬 Exemple :\n« Veuillez ajouter une nouvelle tâche pour implémenter le téléchargement d\'images de profil utilisateur avec Cloudinary, recherchez la meilleure approche. »';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$fr extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Conseils pro';
	@override String get search => 'Utilisez la barre de recherche pour trouver rapidement des tâches spécifiques';
	@override String get views => 'Basculez entre les vues Kanban, Liste et Grille via les boutons de vue';
	@override String get filters => 'Utilisez les filtres pour vous concentrer sur des statuts ou priorités de tâches spécifiques';
	@override String get details => 'Cliquez sur une tâche pour voir les détails et gérer les sous-tâches';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$fr extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 En savoir plus';
	@override String get description => 'TaskMaster AI est un système avancé de gestion des tâches conçu pour les développeurs. Documentation, exemples et contributions au projet.';
	@override String get githubButton => 'Voir sur GitHub';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$fr extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aucune carte pour le moment';
	@override String get description => 'Ajoutez une carte, décrivez la tâche, puis faites-la glisser vers Prêt pour qu’un agent commence à travailler.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$fr extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Backlog';
	@override String get ready => 'Prêt à démarrer';
	@override String get working => 'En cours';
	@override String get needsDecision => 'Nécessite votre décision';
	@override String get done => 'Terminé';
	@override String get archived => 'Archivées';
}

// Path: tasks.board.card
class Translations$tasks$board$card$fr extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get running => 'En cours';
	@override String get abort => 'Abandonner';
	@override String get delete => 'Supprimer';
	@override String get openSession => 'Ouvrir la session';
	@override String get pullRequest => 'Pull request';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$fr extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Nouvelle carte';
	@override String get editTitle => 'Modifier la carte';
	@override String get titleLabel => 'Titre';
	@override String get titlePlaceholder => 'Que doit faire l’agent ?';
	@override String get descriptionLabel => 'Description';
	@override String get descriptionPlaceholder => 'Ajouter du contexte, des critères d’acceptation, des liens...';
	@override String get cancel => 'Annuler';
	@override String get save => 'Enregistrer';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$fr extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Agent';
	@override String get anyProvider => 'N’importe quel agent';
	@override String get model => 'Modèle';
	@override String get defaultModel => 'Modèle par défaut';
	@override String get effort => 'Raisonnement';
	@override String get defaultEffort => 'Par défaut';
	@override String get searchModel => 'Rechercher des modèles…';
	@override String get noModels => 'Aucun modèle correspondant';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$fr extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '« ${cardTitle} » sera définitivement supprimée.';
	@override String get title => 'Supprimer la carte ?';
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$fr extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get bearerTokenEnvVar => 'Variable d’environnement du token Bearer';
	@override String get envVarNames => 'Noms des variables d’environnement';
	@override String get workingDirectory => 'Répertoire de travail';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$fr extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get claudeLocal => 'Claude local';
	@override late final Translations$mcp$form$scope$description$fr description = Translations$mcp$form$scope$description$fr._(_root);
	@override String get projectAllProviders => 'Projet (tous les fournisseurs)';
	@override String get userAllProviders => 'Utilisateur (tous les fournisseurs)';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$fr extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => 'L’ajout d’un serveur MCP ne prend en charge que stdio et http pour tous les fournisseurs, pas ${type}.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} ne prend pas en charge les serveurs MCP ${type}';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$fr extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Répertoire de travail';
	@override String get envVars => 'Variables d’environnement';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$fr extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Espace de travail existant';
	@override String get description => 'J\'ai déjà un espace de travail sur mon serveur et je veux juste l\'ajouter à la liste des projets';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$fr extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nouvel espace de travail';
	@override String get description => 'Créer un nouvel espace de travail, éventuellement cloné depuis un dépôt GitHub';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$fr extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$fr info = Translations$common$notifications$codes$generic$info$fr._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$fr extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$fr required = Translations$common$notifications$codes$permission$required$fr._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$fr extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$fr stopped = Translations$common$notifications$codes$run$stopped$fr._(_root);
	@override late final Translations$common$notifications$codes$run$failed$fr failed = Translations$common$notifications$codes$run$failed$fr._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$fr extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$fr notification = Translations$common$notifications$codes$agent$notification$fr._(_root);
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$fr extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuel — recommandation uniquement';
	@override String get ask => 'Demander avant de changer de compte';
	@override String get autoLowRisk => 'Changement auto pour les tâches à faible risque';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$fr extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

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
	@override String get redundantAccounts => 'Comptes redondants';
	@override String get redundantAccountsNone => 'Aucun autre compte pour ce fournisseur';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$fr extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

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
class Translations$settings$orchestration$planner$modes$fr extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$fr extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$fr extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$fr extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$fr extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Thème de l\'éditeur';
	@override String get description => 'Thème par défaut pour l\'éditeur de code';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$fr extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Retour à la ligne';
	@override String get description => 'Activer le retour à la ligne par défaut dans l\'éditeur';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$fr extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Afficher la minimap';
	@override String get description => 'Afficher une minimap pour une navigation plus facile en vue diff';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$fr extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Afficher les numéros de ligne';
	@override String get description => 'Afficher les numéros de ligne dans l\'éditeur';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$fr extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Taille de police';
	@override String get description => 'Taille de police de l\'éditeur en pixels';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$fr extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Le focus suit le pointeur';
	@override String get description => 'Donner le focus au terminal pour la saisie lorsque vous déplacez la souris dessus';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$fr extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Nom du token (ex. : Dépôts personnels)';
	@override String get tokenPlaceholder => 'Token d\'accès personnel GitHub (ghp_...)';
	@override String get descriptionPlaceholder => 'Description (optionnel)';
	@override String get addButton => 'Ajouter le token';
	@override String get cancelButton => 'Annuler';
	@override String get howToCreate => 'Comment créer un token d\'accès personnel GitHub →';
	@override String get showToken => 'Afficher le token';
	@override String get hideToken => 'Masquer le token';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$fr extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Redémarrez cette application';
	@override String get autoAvailable => 'Les fonctionnalités TaskMaster deviendront automatiquement disponibles';
	@override String get initCommand => 'Utilisez task-master init dans votre répertoire de projet';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$fr extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistant IA Claude d\'Anthropic';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$fr extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Éditeur de code IA Cursor';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$fr extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistant IA Codex d\'OpenAI';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$fr extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistant CLI OpenCode';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$fr extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistant CLI Command Code';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$fr extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistant CLI Antigravity';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$fr extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Assistant CLI Devin';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$fr extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$fr kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$fr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$fr auto = Translations$settings$permissions$permissionMode$modes$auto$fr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$fr acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$fr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$fr bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$fr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$fr plan = Translations$settings$permissions$permissionMode$modes$plan$fr._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$fr extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuel';
	@override String get manualHint => 'Afficher uniquement une recommandation ; ne jamais changer de compte automatiquement.';
	@override String get ask => 'Demander avant de changer';
	@override String get askHint => 'Un changement est proposé et attend votre approbation.';
	@override String get autoLowRisk => 'Auto pour les tâches à faible risque';
	@override String get autoLowRiskHint => 'Seules les tâches marquées à faible risque peuvent être déplacées automatiquement.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$fr extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Créer un document d\'exigences produit (PRD)';
	@override String get description => 'Discutez de votre idée de projet et créez un PRD décrivant ce que vous voulez construire.';
	@override String get addButton => 'Ajouter un PRD';
	@override String get existingPRDs => 'PRDs existants :';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$fr extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Générer des tâches à partir du PRD';
	@override String get description => 'Une fois votre PRD prêt, demandez à votre assistant IA de l\'analyser et TaskMaster le décomposera automatiquement en tâches gérables avec des détails d\'implémentation.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$fr extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analyser et développer les tâches';
	@override String get description => 'Demandez à votre assistant IA d\'analyser la complexité des tâches et de les développer en sous-tâches détaillées pour une implémentation plus facile.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$fr extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Commencer à construire';
	@override String get description => 'Demandez à votre assistant IA de commencer à travailler sur les tâches, mettre à jour leur statut et ajouter de nouvelles tâches au fur et à mesure.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$fr extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get local => 'Stocké dans les paramètres utilisateur de Claude pour le projet sélectionné';
	@override String get project => 'Stocké dans l’espace de travail du projet sélectionné';
	@override String get projectGlobal => 'Écrit dans l’espace de travail du projet sélectionné pour chaque fournisseur';
	@override String get user => 'Disponible dans tous les projets sur votre machine';
	@override String get userGlobal => 'Écrit dans la configuration utilisateur de chaque fournisseur et est disponible dans tous les projets sur cette machine';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$fr extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notification';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$fr extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Action requise';
	@override String body({required Object toolName}) => '${toolName} attend votre décision.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$fr extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Exécution arrêtée';
	@override String body({required Object reason}) => 'Raison : ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$fr extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Exécution échouée';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$fr extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notification de l\'agent';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$fr extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Par défaut';
	@override String get description => 'Les actions nécessitant une permission vous sont présentées pour approbation dans la discussion.';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$fr extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mode automatique';
	@override String get description => 'Un classifieur de modèle décide pour chaque appel d\'outil d\'approuver ou refuser. Mode mains libres, mais plus sûr que le contournement — des refus peuvent toujours se produire.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$fr extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Accepter les modifications';
	@override String get description => 'Les modifications de fichiers sont approuvées automatiquement ; les autres actions demandent toujours votre approbation.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$fr extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Contourner les permissions';
	@override String get description => 'Chaque action est approuvée automatiquement — accès complet sans invites. À utiliser avec prudence.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$fr extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get description => 'Mode planification : l’agent explore et planifie sans exécuter de commandes.';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Votre session a expiré. Veuillez vous reconnecter.',
			'auth.login.title' => 'Bon retour',
			'auth.login.description' => 'Connectez-vous à votre compte DDAgent auto-hébergé',
			'auth.login.username' => 'Nom d\'utilisateur',
			'auth.login.password' => 'Mot de passe',
			'auth.login.submit' => 'Se connecter',
			'auth.login.loading' => 'Connexion en cours...',
			'auth.login.errors.invalidCredentials' => 'Nom d\'utilisateur ou mot de passe incorrect',
			'auth.login.errors.requiredFields' => 'Veuillez remplir tous les champs',
			'auth.login.errors.networkError' => 'Erreur réseau. Veuillez réessayer.',
			'auth.login.placeholders.username' => 'Entrez votre nom d\'utilisateur',
			'auth.login.placeholders.password' => 'Entrez votre mot de passe',
			'auth.register.title' => 'Créer un compte',
			'auth.register.username' => 'Nom d\'utilisateur',
			'auth.register.password' => 'Mot de passe',
			'auth.register.confirmPassword' => 'Confirmer le mot de passe',
			'auth.register.submit' => 'Créer le compte',
			'auth.register.loading' => 'Création du compte...',
			'auth.register.errors.passwordMismatch' => 'Les mots de passe ne correspondent pas',
			'auth.register.errors.usernameTaken' => 'Ce nom d\'utilisateur est déjà pris',
			'auth.register.errors.weakPassword' => 'Le mot de passe est trop faible',
			'auth.register.errors.usernameTooShort' => 'Le nom d\'utilisateur doit contenir au moins 3 caractères',
			'auth.register.errors.passwordTooShort' => 'Le mot de passe doit contenir au moins 6 caractères',
			'auth.logout.title' => 'Se déconnecter',
			'auth.logout.confirm' => 'Êtes-vous sûr de vouloir vous déconnecter ?',
			'auth.logout.button' => 'Se déconnecter',
			'chat.codeBlock.copy' => 'Copier',
			'chat.codeBlock.copied' => 'Copié',
			'chat.codeBlock.copyCode' => 'Copier le code',
			'chat.copyMessage.copy' => 'Copier le message',
			'chat.copyMessage.copied' => 'Message copié',
			'chat.copyMessage.failed' => 'Échec de la copie',
			'chat.copyMessage.selectFormat' => 'Sélectionner le format de copie',
			'chat.copyMessage.copyAsMarkdown' => 'Copier en markdown',
			'chat.copyMessage.copyAsText' => 'Copier en texte brut',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => 'Erreur',
			'chat.messageTypes.tool' => 'Outil',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.tools.settings' => 'Paramètres de l\'outil',
			'chat.tools.error' => 'Erreur de l\'outil',
			'chat.tools.result' => 'Résultat de l\'outil',
			'chat.tools.viewParams' => 'Voir les paramètres d\'entrée',
			'chat.tools.viewRawParams' => 'Voir les paramètres bruts',
			'chat.tools.viewDiff' => 'Voir les différences pour',
			'chat.tools.creatingFile' => 'Création du fichier :',
			'chat.tools.updatingTodo' => 'Mise à jour de la liste de tâches',
			'chat.tools.read' => 'Lire',
			'chat.tools.readFile' => 'Lire le fichier',
			'chat.tools.updateTodo' => 'Mettre à jour la liste de tâches',
			'chat.tools.readTodo' => 'Lire la liste de tâches',
			'chat.tools.searchResults' => 'résultats',
			'chat.tools.todoReadLabel' => 'TodoRead : lecture de la liste de tâches',
			'chat.search.found' => ({required Object count, required Object type}) => '${count} ${type} trouvé(s)',
			'chat.search.file' => 'fichier',
			'chat.search.files' => 'fichiers',
			'chat.search.pattern' => 'motif :',
			'chat.search.kIn' => 'dans :',
			'chat.fileOperations.updated' => 'Fichier mis à jour avec succès',
			'chat.fileOperations.created' => 'Fichier créé avec succès',
			'chat.fileOperations.written' => 'Fichier écrit avec succès',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => 'Nouveau fichier',
			'chat.fileOperations.viewContent' => 'Voir le contenu du fichier',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Voir la sortie complète (${count} caractères)',
			'chat.fileOperations.contentDisplayed' => 'Le contenu du fichier est affiché dans la vue diff ci-dessus',
			'chat.interactive.title' => 'Invite interactive',
			'chat.interactive.waiting' => 'En attente de votre réponse dans le CLI',
			'chat.interactive.instruction' => 'Veuillez sélectionner une option dans votre terminal où Claude s\'exécute.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude a sélectionné l\'option ${number}',
			'chat.interactive.instructionDetail' => 'Dans le CLI, vous sélectionneriez cette option de manière interactive avec les touches fléchées ou en tapant le numéro.',
			'chat.thinking.title' => 'Réflexion...',
			'chat.thinking.emoji' => '💭 Réflexion...',
			'chat.json.response' => 'Réponse JSON',
			'chat.permissions.grant' => ({required Object tool}) => 'Autoriser ${tool}',
			'chat.permissions.added' => 'Permission ajoutée',
			'chat.permissions.addTo' => ({required Object entry}) => 'Ajoute ${entry} aux outils autorisés.',
			'chat.permissions.retry' => 'Permission enregistrée. Relancez la requête pour utiliser l\'outil.',
			'chat.permissions.error' => 'Impossible de mettre à jour les permissions. Veuillez réessayer.',
			'chat.permissions.openSettings' => 'Ouvrir les paramètres',
			'chat.permissions.allow' => 'Autoriser',
			'chat.permissions.allowAll' => ({required Object count}) => 'Tout autoriser (${count})',
			'chat.permissions.allowWithChanges' => 'Autoriser avec modifications',
			'chat.permissions.always' => 'Toujours',
			'chat.permissions.deny' => 'Refuser',
			'chat.permissions.editAndAllow' => 'Modifier et autoriser',
			'chat.permissions.editInput' => 'Modifier l’entrée',
			'chat.permissions.invalidJson' => 'JSON invalide',
			'chat.permissions.reject' => 'Rejeter',
			'chat.todo.updated' => 'La liste de tâches a été mise à jour avec succès',
			'chat.todo.current' => 'Liste de tâches actuelle',
			'chat.plan.viewPlan' => '📋 Voir le plan d\'implémentation',
			'chat.plan.title' => 'Plan d\'implémentation',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Limite d\'utilisation Claude atteinte. Votre limite sera réinitialisée à **${time} ${timezone}** - ${date}',
			'chat.codex.permissionMode' => 'Mode de permission',
			'chat.codex.modes.kDefault' => 'Mode par défaut',
			'chat.codex.modes.auto' => 'Mode automatique',
			'chat.codex.modes.acceptEdits' => 'Accepter les modifications',
			'chat.codex.modes.bypassPermissions' => 'Contourner les permissions',
			'chat.codex.modes.plan' => 'Mode planification',
			'chat.codex.descriptions.kDefault' => 'Seules les commandes de confiance (ls, cat, grep, git status, etc.) s\'exécutent automatiquement. Les autres commandes sont ignorées. Peut écrire dans l\'espace de travail.',
			'chat.codex.descriptions.auto' => 'Un classifieur de modèle décide pour chaque appel d\'outil d\'approuver ou refuser. Mode mains libres, mais plus sûr que le contournement — des refus peuvent toujours se produire.',
			'chat.codex.descriptions.acceptEdits' => 'Toutes les commandes s\'exécutent automatiquement dans l\'espace de travail. Mode entièrement automatique avec exécution sandboxée.',
			'chat.codex.descriptions.bypassPermissions' => 'Accès système complet sans restrictions. Toutes les commandes s\'exécutent automatiquement avec accès disque et réseau complet. À utiliser avec précaution.',
			'chat.codex.descriptions.plan' => 'Mode planification - aucune commande n\'est exécutée',
			'chat.codex.technicalDetails' => 'Détails techniques',
			'chat.input.placeholder' => ({required Object provider}) => 'Tapez / pour les commandes, @ pour les fichiers, ou posez une question à ${provider}...',
			'chat.input.placeholderDefault' => 'Tapez votre message...',
			'chat.input.disabled' => 'Saisie désactivée',
			'chat.input.attachFiles' => 'Joindre des fichiers',
			'chat.input.attachImages' => 'Joindre des images',
			'chat.input.send' => 'Envoyer',
			'chat.input.stop' => 'Arrêter',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Entrée pour envoyer • / commandes • @ fichiers',
			'chat.input.hintText.enter' => 'Entrée pour envoyer • Maj+Entrée nouvelle ligne • / commandes • @ fichiers',
			'chat.input.hintText.queue' => 'Entrée pour mettre en file votre prochain message',
			'chat.input.hintText.updateQueued' => 'Entrée pour mettre à jour le message en file',
			'chat.input.clickToChangeMode' => 'Cliquez pour changer le mode de permission',
			'chat.input.showAllCommands' => 'Afficher toutes les commandes',
			'chat.input.clearInput' => 'Effacer la saisie',
			'chat.input.scrollToBottom' => 'Défiler vers le bas',
			'chat.input.attachFilesDesc' => 'Téléverser des photos, fichiers ou documents',
			'chat.input.takePhoto' => 'Prendre une photo',
			'chat.input.takePhotoDesc' => 'Utiliser l’appareil photo pour capturer une photo',
			'chat.input.moreTools' => 'Plus d’outils',
			'chat.input.commandsDesc' => 'Explorer les raccourcis et commandes',
			'chat.input.clearInputDesc' => 'Ignorer le texte actuel',
			'chat.input.newMessage' => 'Nouveau message',
			'chat.input.newMessages' => 'Nouveaux messages',
			'chat.input.queue.sendNext' => 'Mettre le message suivant en file',
			'chat.input.queue.update' => 'Mettre à jour le message en file',
			'chat.input.queue.label' => 'En file',
			'chat.input.queue.willSend' => 'Sera envoyé une fois terminé',
			'chat.input.queue.edit' => 'Modifier le message en file',
			'chat.input.queue.delete' => 'Supprimer le message en file',
			'chat.input.queue.failed' => 'Échec de l’envoi',
			'chat.input.queue.sendNow' => 'Envoyer maintenant',
			'chat.input.autoContinueTasks' => 'Continuité auto',
			'chat.input.autoContinueTasksTooltip' => 'Activer pour laisser Devin passer automatiquement à la tâche Task Master suivante',
			'chat.input.offlineQueue.clear' => 'Annuler et vider la file hors ligne',
			'chat.input.offlineQueue.clearBtn' => 'Annuler',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} messages en file hors ligne — seront envoyés automatiquement à la reconnexion',
			'chat.input.offlineQueue.single' => '1 message en file hors ligne — sera envoyé automatiquement à la reconnexion',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Appareil photo indisponible : ${error}',
			'chat.providerSelection.title' => 'Choisissez votre assistant IA',
			'chat.providerSelection.description' => 'Sélectionnez un fournisseur pour démarrer une nouvelle conversation',
			'chat.providerSelection.selectModel' => 'Sélectionner un modèle',
			'chat.providerSelection.providerInfo.anthropic' => 'par Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'par OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'Éditeur de code IA',
			'chat.providerSelection.providerInfo.google' => 'par Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Prêt à utiliser Claude avec ${model}. Commencez à taper votre message ci-dessous.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Prêt à utiliser Cursor avec ${model}. Commencez à taper votre message ci-dessous.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Prêt à utiliser Codex avec ${model}. Commencez à taper votre message ci-dessous.',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'Prêt à utiliser OpenCode avec ${model}. Commencez à taper votre message ci-dessous.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Sélectionnez un fournisseur ci-dessus pour commencer',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Prêt avec Devin ${model}',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Appuyez sur <kbd>${shortcut}</kbd> pour rechercher sessions, fichiers et commits',
			'chat.providerSelection.workspace' => 'Espace de travail',
			'chat.providerSelection.noWorkspace' => 'Aucun',
			'chat.providerSelection.clickToChangeWorkspace' => 'Cliquer pour changer d’espace de travail',
			'chat.providerSelection.chooseWorkspace' => 'Choisir un espace de travail',
			'chat.providerSelection.searchWorkspaces' => 'Rechercher des espaces de travail...',
			'chat.providerSelection.noWorkspacesFound' => 'Aucun espace de travail trouvé.',
			'chat.providerSelection.all' => 'Tous',
			'chat.providerSelection.free' => 'Gratuit',
			'chat.providerSelection.noModelsFound' => 'Aucun modèle trouvé.',
			'chat.providerSelection.paid' => 'Payant',
			'chat.providerSelection.searchModels' => 'Rechercher des modèles...',
			'chat.providerSelection.addModel' => 'Ajouter un modèle',
			'chat.providerSelection.chooseModel' => 'Choisir un modèle',
			'chat.providerSelection.chooseModelDescription' => 'Modèles intégrés et personnalisés dans une seule liste',
			'chat.providerSelection.clickToChange' => 'Cliquer pour changer de modèle',
			'chat.providerSelection.favorites' => 'Favoris',
			'chat.providerSelection.loadingModels' => 'Chargement des modèles…',
			'chat.providerSelection.manageModels' => 'Gérer les modèles',
			'chat.providerSelection.refresh' => 'Actualiser les modèles',
			'chat.session.kContinue.title' => 'Continuer votre conversation',
			'chat.session.kContinue.description' => 'Posez des questions sur votre code, demandez des modifications ou obtenez de l\'aide pour vos tâches de développement',
			'chat.session.kContinue.action' => 'Continuer à écrire',
			'chat.session.loading.olderMessages' => 'Chargement des messages précédents...',
			'chat.session.loading.sessionMessages' => 'Chargement des messages de la session...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => 'Affichage de ${shown} sur ${total} messages',
			'chat.session.messages.scrollToLoad' => 'Faites défiler vers le haut pour charger plus',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Affichage des ${count} derniers messages (${total} au total)',
			'chat.session.messages.loadEarlier' => 'Charger les messages précédents',
			'chat.session.messages.loadAll' => 'Charger tous les messages',
			'chat.session.messages.loadingAll' => 'Chargement de tous les messages...',
			'chat.session.messages.allLoaded' => 'Tous les messages chargés',
			'chat.session.messages.perfWarning' => 'Tous les messages chargés — le défilement peut être plus lent. Cliquez sur « Défiler vers le bas » pour rétablir les performances.',
			'chat.session.messages.loadOlderFailed' => 'Échec du chargement des anciens messages.',
			'chat.session.messages.retry' => 'Réessayer',
			'chat.session.messages.noSearchMatches' => 'Aucun message ne correspond à votre recherche.',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Tout charger (${count})',
			'chat.session.messages.loadOlder' => 'Charger les anciens messages',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Réessayer de charger les anciens messages — ${error}',
			'chat.session.deleteConfirm' => 'Cela supprime définitivement la session et sa transcription. Cette action est irréversible.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Terminez l\'exécution avant de changer d\'espace de travail',
			'chat.shell.selectProject.title' => 'Sélectionner un projet',
			'chat.shell.selectProject.description' => 'Choisissez un projet pour ouvrir un shell interactif dans ce répertoire',
			'chat.shell.status.newSession' => 'Nouvelle session',
			'chat.shell.status.initializing' => 'Initialisation...',
			'chat.shell.status.restarting' => 'Redémarrage...',
			'chat.shell.actions.disconnect' => 'Déconnecter',
			'chat.shell.actions.disconnectTitle' => 'Se déconnecter du shell',
			'chat.shell.actions.restart' => 'Redémarrer',
			'chat.shell.actions.restartTitle' => 'Redémarrer le shell',
			'chat.shell.actions.connect' => 'Continuer dans le shell',
			'chat.shell.actions.connectTitle' => 'Se connecter au shell',
			'chat.shell.actions.kill' => 'Tuer (SIGINT)',
			'chat.shell.actions.killTitle' => 'Tuer le processus en cours (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Copier la sortie',
			'chat.shell.actions.copyOutputTitle' => 'Copier la sortie du terminal',
			'chat.shell.actions.copied' => 'Copié !',
			'chat.shell.actions.zoomInTitle' => 'Zoom avant',
			'chat.shell.actions.zoomOutTitle' => 'Zoom arrière',
			'chat.shell.loading' => 'Chargement du terminal...',
			'chat.shell.connecting' => 'Connexion au shell...',
			'chat.shell.startSession' => 'Démarrer une nouvelle session Claude',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Reprendre la session : ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => 'Exécuter ${command} dans ${projectName}',
			'chat.shell.startCli' => ({required Object projectName}) => 'Démarrage du CLI Claude dans ${projectName}',
			'chat.shell.defaultCommand' => 'commande',
			'chat.claudeStatus.actions.thinking' => 'Réflexion',
			'chat.claudeStatus.actions.processing' => 'Traitement',
			'chat.claudeStatus.actions.analyzing' => 'Analyse',
			'chat.claudeStatus.actions.working' => 'Travail',
			'chat.claudeStatus.actions.computing' => 'Calcul',
			'chat.claudeStatus.actions.reasoning' => 'Raisonnement',
			'chat.claudeStatus.state.live' => 'En direct',
			'chat.claudeStatus.state.paused' => 'En pause',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}s',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} écoulé',
			'chat.claudeStatus.elapsed.startingNow' => 'Démarrage',
			'chat.claudeStatus.controls.stopGeneration' => 'Arrêter la génération',
			'chat.claudeStatus.controls.pressEscToStop' => 'Appuyez sur Échap à tout moment pour arrêter',
			'chat.claudeStatus.providers.assistant' => 'Assistant',
			'chat.claudeStatus.stop' => 'Arrêter',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} tâche en arrière-plan en cours', other: '${count} tâches en arrière-plan en cours', ), 
			'chat.claudeStatus.backgroundTasksTitle' => 'En arrière-plan',
			'chat.claudeStatus.backgroundTaskUnnamed' => 'Tâche sans nom',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Sélectionnez un projet pour commencer à chatter avec ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Commencer la prochaine tâche',
			'chat.voice.autoRead' => 'Lire les réponses à voix haute',
			'chat.voice.autoReadOn' => 'Lecture des réponses : activée',
			'chat.voice.autoReadOff' => 'Lecture des réponses : désactivée',
			'chat.voice.autoReadVoice' => 'Voix de lecture',
			'chat.voice.autoReadVoiceAuto' => 'Voix automatique',
			'chat.voice.autoReadPreview' => 'Voici comment les réponses seront lues.',
			'chat.voice.speakMessage' => 'Lire à voix haute',
			'chat.voice.stopSpeaking' => 'Arrêter la lecture',
			'chat.composer.toolsAndActions' => 'Outils et actions',
			'chat.composer.toolsAndActionsDesc' => 'Outils et contrôles du composeur de chat',
			'chat.composer.reasoning' => 'Raisonnement',
			'chat.composer.model' => 'Modèle',
			'chat.composer.effortDefault' => 'Par défaut',
			'chat.composer.loadingModels' => 'Chargement des modèles…',
			'chat.composer.modelMenu' => 'Choisir le modèle et l’effort de raisonnement',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'Comment les actions de ${provider} doivent-elles être approuvées ?',
			'chat.composer.favorites' => 'Favoris',
			'chat.splitSession.toggle' => 'Fractionner la session',
			'chat.splitSession.close' => 'Fermer la session fractionnée',
			'chat.splitSession.selectSession' => 'Sélectionner une session à comparer',
			'chat.splitSession.noOtherSessions' => 'Aucune autre session disponible',
			'chat.splitSession.newSessionOption' => '+ Nouvelle session en vue fractionnée',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Projet actuel (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Autres projets',
			'chat.splitSession.recentSessionsGroup' => 'Sessions récentes',
			'chat.splitSession.startNewSession' => 'Démarrer une nouvelle session en vue fractionnée',
			'chat.splitSession.selectFromList' => 'Sélectionner une session dans la liste des sessions existantes',
			'chat.sessionPicker.title' => 'Sélectionner une session',
			'chat.sessionPicker.searchPlaceholder' => 'Rechercher des sessions...',
			'chat.sessionPicker.clearSearch' => 'Effacer la recherche',
			'chat.sessionPicker.newChat' => '+ Nouvelle discussion',
			'chat.sessionPicker.archivedToggle' => 'Archivées',
			'chat.sessionPicker.changeSession' => 'Changer de session',
			'chat.sessionPicker.archivedLoading' => 'Chargement des sessions archivées...',
			'chat.sessionPicker.archivedError' => 'Impossible de charger les sessions archivées',
			'chat.sessionPicker.archivedEmpty' => 'Aucune session archivée',
			'chat.sessionPicker.archivedProjectOnly' => 'Espace de travail archivé — restaurez-le pour voir ses sessions.',
			'chat.sessionPicker.emptySearch' => 'Aucune session ne correspond à votre recherche',
			'chat.sessionPicker.restore' => 'Restaurer',
			'chat.sessionPicker.restoreSession' => 'Restaurer la session',
			'chat.sessionPicker.restoreProject' => 'Restaurer l’espace de travail',
			'chat.sessionPicker.restoreSessionFailed' => 'Échec de la restauration de la session. Veuillez réessayer.',
			'chat.sessionPicker.restoreProjectFailed' => 'Échec de la restauration de l’espace de travail. Veuillez réessayer.',
			'chat.sessionPicker.archiveFailed' => 'Échec de l’archivage de la session. Veuillez réessayer.',
			'chat.sessionPicker.deleteFailed' => 'Échec de la suppression de la session. Veuillez réessayer.',
			'chat.sessionPicker.running' => 'Session en cours',
			'chat.sessionPicker.unread' => 'Non lu — terminé avec une nouvelle sortie',
			'chat.splitWorkspace.addChat' => 'Ajouter un volet de discussion',
			'chat.splitWorkspace.addBrowser' => 'Ajouter un volet navigateur',
			'chat.splitWorkspace.addTerminal' => 'Ajouter un volet terminal',
			'chat.splitWorkspace.overview' => 'Afficher tous les volets',
			'chat.splitWorkspace.exitFocusMode' => 'Quitter le mode focus (Ctrl+Maj+F)',
			'chat.splitWorkspace.focusMode' => 'Mode focus (Ctrl+Maj+F)',
			'chat.splitWorkspace.browseSessions' => 'Ouvrir la liste des sessions',
			'chat.splitOverview.title' => 'Aperçu des volets fractionnés',
			'chat.splitOverview.count' => ({required Object count}) => '${count} volets',
			'chat.splitOverview.close' => 'Fermer l’aperçu',
			'chat.splitOverview.question' => 'QUESTION — saisie requise',
			'chat.splitOverview.processing' => 'TRAITEMENT',
			'chat.splitOverview.idle' => 'Inactif',
			'chat.splitOverview.active' => 'Actif',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} a besoin de votre réponse',
			'chat.askUserQuestion.answerHint' => 'Tapez votre réponse…',
			'chat.askUserQuestion.other' => 'Autre…',
			'chat.askUserQuestion.skip' => 'Ignorer',
			'chat.attachments.downloadFailedRetry' => 'Échec du téléchargement — cliquer pour réessayer',
			'chat.attachments.fileAttachment' => 'Pièce jointe',
			'chat.attachments.download' => ({required Object name}) => 'Télécharger ${name}',
			'chat.checkpoint.creating' => 'Création de l’instantané…',
			'chat.checkpoint.revertChanges' => 'Restaurer les fichiers au dernier checkpoint',
			'chat.checkpoint.undo' => 'Annuler le checkpoint',
			'chat.checkpoint.beforeAiTurn' => 'avant le tour de l’IA',
			'chat.common.close' => 'Fermer',
			'chat.taskMaster.saveToTask' => 'Tâche',
			'chat.taskMaster.saved' => 'Enregistré',
			'chat.taskMaster.saving' => 'Enregistrement...',
			'chat.taskMaster.taskShort' => 'TÂCHE',
			'chat.taskMaster.addToTask' => 'Ajouter à TaskMaster',
			'chat.taskMaster.added' => 'Ajouté à TaskMaster',
			'chat.tokenUsage.desc' => 'Voir la consommation de tokens de la session',
			'chat.tokenUsage.title' => 'Utilisation des tokens',
			'chat.tool.emptyResult' => '(pas encore de sortie — l’outil a renvoyé un résultat vide)',
			'chat.quotaBadge.ariaLabel' => 'Limites d\'abonnement',
			'chat.quotaBadge.noData' => 'Aucune donnée d\'abonnement pour ce modèle',
			'chat.paneHeader.processing' => 'En cours…',
			'chat.paneHeader.switchSession' => 'Changer de session',
			'chat.broadcast.selectOrchestrators' => 'Sélectionner les orchestrateurs',
			'chat.broadcast.orchestratorsOnly' => 'Orchestrateurs uniquement',
			'chat.broadcast.noOrchestrators' => 'Aucune session d\'orchestrateur disponible',
			'chat.changes.empty' => 'Aucune modification de fichier',
			'chat.changes.failedToLoad' => 'Échec du chargement des modifications',
			'chat.commandResult.fallback.config' => 'Ouvrir les paramètres et la configuration.',
			'chat.commandResult.fallback.cost' => 'Consulter la consommation de tokens de la session active.',
			'chat.commandResult.fallback.help' => 'Afficher la documentation et la syntaxe des commandes.',
			'chat.commandResult.fallback.memory' => 'Ouvrir le fichier de mémoire CLAUDE.md du projet.',
			'chat.commandResult.fallback.models' => 'Parcourir les modèles disponibles pour le fournisseur actif.',
			'chat.commandResult.fallback.status' => 'Inspecter le runtime, la version, le fournisseur et l’état de l’environnement.',
			'chat.commandResult.filterCommands' => 'Filtrer les commandes...',
			'chat.commandResult.searchModels' => ({required Object provider}) => 'Rechercher les modèles ${provider}...',
			'chat.commands.runConfirmTitle' => 'Exécuter la commande ?',
			'chat.commands.executionCancelled' => 'Exécution de la commande annulée',
			'chat.export.sessionTitle' => ({required Object id}) => 'Session ${id}',
			'chat.export.pdfFailed' => 'Échec de l\'export PDF',
			'chat.export.transcriptDownloaded' => 'Transcription téléchargée',
			'chat.export.savedTo' => ({required Object path}) => 'Enregistré ${path}',
			'chat.message.compactedSummary' => 'Résumé compacté',
			'chat.message.rawView' => 'Vue brute',
			'chat.message.resendHint' => 'Renvoyer depuis le composeur',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => 'Supprimer ${name}',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => 'Modifier ${name}',
			'chat.modelLibrary.enterNameAndId' => 'Saisissez à la fois un nom de modèle et un ID de modèle.',
			'chat.modelLibrary.idNoSpaces' => 'Les ID de modèle ne peuvent pas contenir d\'espaces.',
			'chat.modelLibrary.setAsDefault' => 'Définir par défaut',
			'chat.modelLibrary.defaultModel' => 'Modèle par défaut',
			'chat.pinFile.action' => 'Épingler',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.title' => 'Épingler le fichier',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Demande de permission · ${tool}',
			'chat.permissionRequest.question' => 'Question',
			'codeEditor.toolbar.changes' => 'modifications',
			'codeEditor.toolbar.previousChange' => 'Modification précédente',
			'codeEditor.toolbar.nextChange' => 'Modification suivante',
			'codeEditor.toolbar.hideDiff' => 'Masquer la mise en évidence des différences',
			'codeEditor.toolbar.showDiff' => 'Afficher la mise en évidence des différences',
			'codeEditor.toolbar.settings' => 'Paramètres de l\'éditeur',
			'codeEditor.toolbar.collapse' => 'Réduire l\'éditeur',
			'codeEditor.toolbar.expand' => 'Étendre l\'éditeur en pleine largeur',
			'codeEditor.toolbar.diffMerge' => 'Diff / fusion',
			'codeEditor.toolbar.previewInBrowser' => 'Aperçu dans le navigateur',
			'codeEditor.toolbar.reload' => 'Recharger depuis le disque',
			'codeEditor.toolbar.toggleDock' => 'Basculer le dock de fichiers',
			'codeEditor.loading' => ({required Object fileName}) => 'Chargement de ${fileName}...',
			'codeEditor.header.showingChanges' => 'Affichage des modifications',
			'codeEditor.actions.copyPath' => 'Copier le chemin du fichier',
			'codeEditor.actions.pathCopied' => 'Chemin du fichier copié',
			'codeEditor.actions.download' => 'Télécharger le fichier',
			'codeEditor.actions.save' => 'Enregistrer',
			'codeEditor.actions.saving' => 'Enregistrement...',
			'codeEditor.actions.saved' => 'Enregistré !',
			'codeEditor.actions.exitFullscreen' => 'Quitter le plein écran',
			'codeEditor.actions.fullscreen' => 'Plein écran',
			'codeEditor.actions.close' => 'Fermer',
			'codeEditor.actions.previewMarkdown' => 'Aperçu markdown',
			'codeEditor.actions.editMarkdown' => 'Modifier le markdown',
			'codeEditor.actions.pinFile' => 'Épingler le fichier au contexte',
			'codeEditor.actions.unpinFile' => 'Détacher le fichier du contexte',
			'codeEditor.actions.previewHtml' => 'Ouvrir l’aperçu HTML dans un nouvel onglet',
			'codeEditor.actions.retry' => 'Réessayer',
			'codeEditor.actions.saveAll' => 'Tout enregistrer',
			'codeEditor.footer.lines' => 'Lignes :',
			'codeEditor.footer.characters' => 'Caractères :',
			'codeEditor.footer.shortcuts' => 'Ctrl+S pour enregistrer • Échap pour fermer',
			'codeEditor.binaryFile.title' => 'Fichier binaire',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Le fichier "${fileName}" ne peut pas être affiché dans l\'éditeur de texte car c\'est un fichier binaire.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Impossible d’afficher en tant que texte',
			'codeEditor.filePreview.loading' => 'Chargement de l’aperçu...',
			'codeEditor.filePreview.error' => 'Impossible d’afficher ce fichier.',
			'codeEditor.filePreview.openInNewTab' => 'Ouvrir dans un nouvel onglet',
			'codeEditor.diff.applyMerge' => 'Appliquer la fusion',
			'codeEditor.diff.base' => 'Base',
			'codeEditor.diff.close' => 'Fermer le diff',
			'codeEditor.diff.current' => 'Actuel',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Section ${number}',
			'codeEditor.diff.noChanges' => 'Aucune modification',
			'codeEditor.diff.deletedOnDisk' => 'supprimé sur le disque',
			'codeEditor.discardUnsavedChanges' => 'Ignorer les modifications non enregistrées ?',
			'codeEditor.emptyState.title' => 'Aucun fichier ouvert',
			'codeEditor.failedToLoad' => 'Échec du chargement du fichier',
			'codeEditor.hexDump.more' => ({required Object size}) => '… ${size} de plus',
			'codeEditor.mediaFile.subtitle' => 'L’aperçu audio/vidéo n’est pas encore pris en charge',
			'codeEditor.mediaFile.title' => 'Fichier média',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Taille de police −  (actuelle : ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Taille de police +',
			'codeEditor.settings.minimap' => 'Minimap',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Taille de tabulation : ${size}',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Modifications non enregistrées dans ${name}',
			'codeEditor.toasts.savedFile' => ({required Object name}) => 'Enregistré ${name}',
			'codeEditor.toasts.saveFailed' => 'Échec de l\'enregistrement',
			'codeEditor.toasts.allSaved' => 'Tout est enregistré',
			'codeEditor.toasts.someSavesFailed' => 'Certains enregistrements ont échoué',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Enregistré dans ${path}',
			'codeEditor.toasts.mergeApplied' => 'Fusion appliquée — enregistrez pour conserver',
			'common.buttons.save' => 'Enregistrer',
			'common.buttons.cancel' => 'Annuler',
			'common.buttons.delete' => 'Supprimer',
			'common.buttons.create' => 'Créer',
			'common.buttons.edit' => 'Modifier',
			'common.buttons.close' => 'Fermer',
			'common.buttons.confirm' => 'Confirmer',
			'common.buttons.submit' => 'Soumettre',
			'common.buttons.retry' => 'Réessayer',
			'common.buttons.refresh' => 'Actualiser',
			'common.buttons.search' => 'Rechercher',
			'common.buttons.clear' => 'Effacer',
			'common.buttons.copy' => 'Copier',
			'common.buttons.download' => 'Télécharger',
			'common.buttons.upload' => 'Envoyer',
			'common.buttons.browse' => 'Parcourir',
			'common.buttons.openDiagram' => 'Ouvrir le diagramme',
			'common.buttons.update' => 'Mettre à jour',
			'common.tabs.chat' => 'Discussion',
			'common.tabs.shell' => 'Terminal',
			'common.tabs.files' => 'Fichiers',
			'common.tabs.git' => 'Contrôle de source',
			'common.tabs.tasks' => 'Tâches',
			'common.tabs.browser' => 'Navigateur',
			'common.tabs.computer' => 'Ordinateur',
			'common.tabs.board' => 'Tableau',
			'common.tabs.usage' => 'AI Control',
			'common.status.loading' => 'Chargement...',
			'common.status.success' => 'Succès',
			'common.status.error' => 'Erreur',
			'common.status.failed' => 'Échec',
			'common.status.pending' => 'En attente',
			'common.status.completed' => 'Terminé',
			'common.status.inProgress' => 'En cours',
			'common.messages.savedSuccessfully' => 'Enregistré avec succès',
			'common.messages.deletedSuccessfully' => 'Supprimé avec succès',
			'common.messages.updatedSuccessfully' => 'Mis à jour avec succès',
			'common.messages.operationFailed' => 'Opération échouée',
			'common.messages.networkError' => 'Erreur réseau. Vérifiez votre connexion.',
			'common.messages.unauthorized' => 'Non autorisé. Veuillez vous connecter.',
			'common.messages.notFound' => 'Introuvable',
			'common.messages.invalidInput' => 'Entrée invalide',
			'common.messages.requiredField' => 'Ce champ est obligatoire',
			'common.messages.unknownError' => 'Une erreur inconnue s\'est produite',
			'common.messages.renameSessionFailed' => 'Échec du renommage de la session. Veuillez réessayer.',
			'common.navigation.settings' => 'Paramètres',
			'common.navigation.home' => 'Accueil',
			'common.navigation.back' => 'Retour',
			'common.navigation.next' => 'Suivant',
			'common.navigation.previous' => 'Précédent',
			'common.navigation.logout' => 'Déconnexion',
			'common.common.language' => 'Langue',
			'common.common.theme' => 'Thème',
			'common.common.darkMode' => 'Mode sombre',
			'common.common.lightMode' => 'Mode clair',
			'common.common.name' => 'Nom',
			'common.common.description' => 'Description',
			'common.common.enabled' => 'Activé',
			'common.common.disabled' => 'Désactivé',
			'common.common.optional' => 'Optionnel',
			'common.common.version' => 'Version',
			'common.common.select' => 'Sélectionner',
			'common.common.selectAll' => 'Tout sélectionner',
			'common.common.deselectAll' => 'Tout désélectionner',
			'common.common.done' => 'Terminé',
			'common.common.failed' => 'Échoué',
			'common.time.justNow' => 'À l\'instant',
			'common.time.minutesAgo' => ({required Object count}) => 'Il y a ${count} min',
			'common.time.hoursAgo' => ({required Object count}) => 'Il y a ${count} h',
			'common.time.daysAgo' => ({required Object count}) => 'Il y a ${count} j',
			'common.time.yesterday' => 'Hier',
			'common.fileOperations.newFile' => 'Nouveau fichier',
			'common.fileOperations.newFolder' => 'Nouveau dossier',
			'common.fileOperations.rename' => 'Renommer',
			'common.fileOperations.move' => 'Déplacer',
			'common.fileOperations.copyPath' => 'Copier le chemin',
			'common.fileOperations.openInEditor' => 'Ouvrir dans l\'éditeur',
			'common.mainContent.loading' => 'Chargement de DDAgent',
			'common.mainContent.settingUpWorkspace' => 'Préparation de votre espace de travail...',
			'common.mainContent.chooseProject' => 'Choisissez votre projet',
			_ => null,
		} ?? switch (path) {
			'common.mainContent.selectProjectDescription' => 'Sélectionnez un projet dans la barre latérale pour commencer à coder avec Claude. Chaque projet contient vos sessions de chat et l\'historique des fichiers.',
			'common.mainContent.tip' => 'Astuce',
			'common.mainContent.createProjectMobile' => 'Appuyez sur le bouton menu ci-dessus pour accéder aux projets',
			'common.mainContent.createProjectDesktop' => 'Créez un nouveau projet en cliquant sur l\'icône de dossier dans la barre latérale',
			'common.mainContent.newSession' => 'Nouvelle session',
			'common.mainContent.untitledSession' => 'Session sans titre',
			'common.mainContent.projectFiles' => 'Fichiers du projet',
			'common.mainContent.focusMode' => 'Mode concentration (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Quitter le mode concentration (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Fractionner la session',
			'common.mainContent.closeSplitSession' => 'Fermer la session fractionnée',
			'common.mainContent.chooseWorkspace' => 'Choisir un espace de travail',
			'common.mainContent.chooseWorkspaceDescription' => 'Choisissez un espace de travail pour ce chat, ou créez-en un dans les Paramètres.',
			'common.mainContent.createWorkspace' => 'Créer un espace de travail dans les Paramètres',
			'common.mainContent.recentProjects' => 'Projets récents',
			'common.fileTree.loading' => 'Chargement des fichiers...',
			'common.fileTree.files' => 'Fichiers',
			'common.fileTree.simpleView' => 'Vue simple',
			'common.fileTree.compactView' => 'Vue compacte',
			'common.fileTree.detailedView' => 'Vue détaillée',
			'common.fileTree.searchPlaceholder' => 'Rechercher fichiers et dossiers...',
			'common.fileTree.clearSearch' => 'Effacer la recherche',
			'common.fileTree.name' => 'Nom',
			'common.fileTree.size' => 'Taille',
			'common.fileTree.modified' => 'Modifié',
			'common.fileTree.permissions' => 'Permissions',
			'common.fileTree.noFilesFound' => 'Aucun fichier trouvé',
			'common.fileTree.checkProjectPath' => 'Vérifiez si le chemin du projet est accessible',
			'common.fileTree.noMatchesFound' => 'Aucun résultat',
			'common.fileTree.tryDifferentSearch' => 'Essayez un autre terme ou effacez la recherche',
			'common.fileTree.justNow' => 'à l\'instant',
			'common.fileTree.minAgo' => ({required Object count}) => 'il y a ${count} min',
			'common.fileTree.hoursAgo' => ({required Object count}) => 'il y a ${count} h',
			'common.fileTree.daysAgo' => ({required Object count}) => 'il y a ${count} j',
			'common.fileTree.newFile' => 'Nouveau fichier (Cmd+N)',
			'common.fileTree.newFolder' => 'Nouveau dossier (Cmd+Maj+N)',
			'common.fileTree.refresh' => 'Actualiser',
			'common.fileTree.collapseAll' => 'Tout réduire',
			'common.fileTree.context.rename' => 'Renommer',
			'common.fileTree.context.delete' => 'Supprimer',
			'common.fileTree.context.copyPath' => 'Copier le chemin',
			'common.fileTree.context.download' => 'Télécharger',
			'common.fileTree.context.newFile' => 'Nouveau fichier',
			'common.fileTree.context.newFolder' => 'Nouveau dossier',
			'common.fileTree.context.upload' => 'Téléverser des fichiers',
			'common.fileTree.context.refresh' => 'Actualiser',
			'common.fileTree.context.menuLabel' => 'Menu contextuel du fichier',
			'common.fileTree.context.loading' => 'Chargement...',
			'common.fileTree.searchContentPlaceholder' => 'Rechercher dans les fichiers...',
			'common.fileTree.searchInFiles' => 'Rechercher dans les fichiers',
			'common.fileTree.searchByName' => 'Rechercher par nom',
			'common.fileTree.loadFailed' => 'Impossible de charger les fichiers',
			'common.fileTree.noSearchResults' => 'Aucun résultat',
			'common.fileTree.searchError' => 'Échec de la recherche',
			'common.fileTree.searching' => 'Recherche en cours...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Affichage des ${count} premiers résultats',
			'common.fileTree.allWorkspaces' => 'Tous les espaces de travail',
			'common.fileTree.delete.confirm' => 'Supprimer',
			'common.fileTree.delete.fileWarning' => 'Ce fichier sera définitivement supprimé.',
			'common.fileTree.delete.folderWarning' => 'Ce dossier et tout son contenu seront définitivement supprimés.',
			'common.fileTree.delete.title' => ({required Object type}) => 'Supprimer ${type}',
			'common.fileTree.dropToUpload' => 'Déposez des fichiers pour les téléverser',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Déposez des fichiers pour les téléverser vers « ${folder} »',
			'common.fileTree.noProject' => 'Ajoutez d’abord un projet',
			'common.fileTree.noRecentFiles' => 'Aucun fichier modifié au cours des 7 derniers jours',
			'common.fileTree.showAllFiles' => 'Afficher tous les fichiers',
			'common.fileTree.showAllFilesHint' => 'Désactivez le filtre récent pour tout voir.',
			'common.fileTree.showRecentOnly' => 'Afficher les fichiers modifiés au cours des 7 derniers jours',
			'common.fileTree.toast.copyFailed' => 'Échec de la copie du chemin',
			'common.fileTree.toast.fileCreated' => 'Fichier créé avec succès',
			'common.fileTree.toast.fileDeleted' => 'Fichier supprimé',
			'common.fileTree.toast.folderCreated' => 'Dossier créé avec succès',
			'common.fileTree.toast.folderDeleted' => 'Dossier supprimé',
			'common.fileTree.toast.folderDownloaded' => 'Dossier téléchargé en ZIP',
			'common.fileTree.toast.pathCopied' => 'Chemin copié dans le presse-papiers',
			'common.fileTree.toast.renamed' => 'Renommé avec succès',
			'common.fileTree.uploadComplete' => 'Téléversement terminé',
			'common.fileTree.uploadFailed' => 'Échec du téléversement',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Téléverser des fichiers (max ${size} chacun)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Téléverser des fichiers vers « ${folder} »',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => '${uploaded} sur ${total} ${label} téléversés',
			'common.fileTree.uploadingFiles' => 'Téléversement des fichiers',
			'common.fileTree.validation.dotsOnly' => 'Le nom de fichier ne peut pas contenir uniquement des points',
			'common.fileTree.validation.emptyName' => 'Le nom de fichier ne peut pas être vide',
			'common.fileTree.validation.invalidChars' => 'Le nom de fichier contient des caractères invalides',
			'common.fileTree.validation.reserved' => 'Le nom de fichier est un nom réservé',
			'common.projectWizard.title' => 'Créer un nouveau projet',
			'common.projectWizard.steps.type' => 'Type',
			'common.projectWizard.steps.configure' => 'Configurer',
			'common.projectWizard.steps.confirm' => 'Confirmer',
			'common.projectWizard.step1.question' => 'Avez-vous déjà un espace de travail, ou souhaitez-vous en créer un nouveau ?',
			'common.projectWizard.step1.existing.title' => 'Espace de travail existant',
			'common.projectWizard.step1.existing.description' => 'J\'ai déjà un espace de travail sur mon serveur et je veux juste l\'ajouter à la liste des projets',
			'common.projectWizard.step1.kNew.title' => 'Nouvel espace de travail',
			'common.projectWizard.step1.kNew.description' => 'Créer un nouvel espace de travail, éventuellement cloné depuis un dépôt GitHub',
			'common.projectWizard.step2.existingPath' => 'Chemin de l\'espace de travail',
			'common.projectWizard.step2.newPath' => 'Chemin de l\'espace de travail',
			'common.projectWizard.step2.existingPlaceholder' => '/chemin/vers/espace-de-travail',
			'common.projectWizard.step2.newPlaceholder' => '/chemin/vers/nouvel-espace',
			'common.projectWizard.step2.existingHelp' => 'Chemin complet vers votre répertoire d\'espace de travail existant',
			'common.projectWizard.step2.newHelp' => 'Chemin complet vers votre répertoire d\'espace de travail',
			'common.projectWizard.step2.githubUrl' => 'URL GitHub (optionnel)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/utilisateur/depot',
			'common.projectWizard.step2.githubHelp' => 'Optionnel : fournissez une URL GitHub pour cloner un dépôt',
			'common.projectWizard.step2.githubAuth' => 'Authentification GitHub (optionnel)',
			'common.projectWizard.step2.githubAuthHelp' => 'Uniquement requis pour les dépôts privés. Les dépôts publics peuvent être clonés sans authentification.',
			'common.projectWizard.step2.loadingTokens' => 'Chargement des tokens enregistrés...',
			'common.projectWizard.step2.storedToken' => 'Token enregistré',
			'common.projectWizard.step2.newToken' => 'Nouveau token',
			'common.projectWizard.step2.nonePublic' => 'Aucun (Public)',
			'common.projectWizard.step2.selectToken' => 'Sélectionner un token',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Sélectionner un token --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Ce token sera utilisé uniquement pour cette opération',
			'common.projectWizard.step2.publicRepoInfo' => 'Les dépôts publics ne nécessitent pas d\'authentification. Vous pouvez ignorer le token pour cloner un dépôt public.',
			'common.projectWizard.step2.noTokensHelp' => 'Aucun token enregistré. Vous pouvez en ajouter dans Paramètres → Clés API.',
			'common.projectWizard.step2.optionalTokenPublic' => 'Token GitHub (optionnel pour les dépôts publics)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (laisser vide pour les dépôts publics)',
			'common.projectWizard.step3.reviewConfig' => 'Vérifiez votre configuration',
			'common.projectWizard.step3.existingWorkspace' => 'Espace de travail existant',
			'common.projectWizard.step3.newWorkspace' => 'Nouvel espace de travail',
			'common.projectWizard.step3.path' => 'Chemin :',
			'common.projectWizard.step3.cloneFrom' => 'Cloner depuis :',
			'common.projectWizard.step3.authentication' => 'Authentification :',
			'common.projectWizard.step3.usingStoredToken' => 'Utilisation du token enregistré :',
			'common.projectWizard.step3.usingProvidedToken' => 'Utilisation du token fourni',
			'common.projectWizard.step3.noAuthentication' => 'Sans authentification',
			'common.projectWizard.step3.sshKey' => 'Clé SSH',
			'common.projectWizard.step3.existingInfo' => 'L\'espace de travail sera ajouté à votre liste de projets et disponible pour les sessions Claude/Cursor.',
			'common.projectWizard.step3.newWithClone' => 'Le dépôt sera cloné depuis ce dossier.',
			'common.projectWizard.step3.newEmpty' => 'L\'espace de travail sera ajouté à votre liste de projets et disponible pour les sessions Claude/Cursor.',
			'common.projectWizard.step3.cloningRepository' => 'Clonage du dépôt...',
			'common.projectWizard.buttons.cancel' => 'Annuler',
			'common.projectWizard.buttons.back' => 'Retour',
			'common.projectWizard.buttons.next' => 'Suivant',
			'common.projectWizard.buttons.createProject' => 'Créer le projet',
			'common.projectWizard.buttons.creating' => 'Création...',
			'common.projectWizard.buttons.cloning' => 'Clonage...',
			'common.projectWizard.errors.selectType' => 'Veuillez indiquer si vous avez un espace de travail existant ou si vous souhaitez en créer un nouveau',
			'common.projectWizard.errors.providePath' => 'Veuillez fournir un chemin d\'espace de travail',
			'common.projectWizard.errors.failedToCreate' => 'Échec de la création de l\'espace de travail',
			'common.projectWizard.errors.failedToCreateFolder' => 'Échec de la création du dossier',
			'common.notifications.genericTool' => 'un outil',
			'common.notifications.codes.generic.info.title' => 'Notification',
			'common.notifications.codes.permission.required.title' => 'Action requise',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} attend votre décision.',
			'common.notifications.codes.run.stopped.title' => 'Exécution arrêtée',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Raison : ${reason}',
			'common.notifications.codes.run.failed.title' => 'Exécution échouée',
			'common.notifications.codes.agent.notification.title' => 'Notification de l\'agent',
			'common.versionUpdate.title' => 'Mise à jour disponible',
			'common.versionUpdate.newVersionReady' => 'Une nouvelle version est prête',
			'common.versionUpdate.currentVersion' => 'Version actuelle',
			'common.versionUpdate.latestVersion' => 'Dernière version',
			'common.versionUpdate.whatsNew' => 'Nouveautés :',
			'common.versionUpdate.viewFullRelease' => 'Voir les notes de version complètes',
			'common.versionUpdate.updateProgress' => 'Progression de la mise à jour :',
			'common.versionUpdate.manualUpgrade' => 'Mise à jour manuelle :',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Ou cliquez sur « Mettre à jour maintenant » pour lancer la mise à jour automatiquement.',
			'common.versionUpdate.updateCompleted' => 'Mise à jour effectuée avec succès !',
			'common.versionUpdate.restartServer' => 'Veuillez redémarrer le serveur pour appliquer les modifications.',
			'common.versionUpdate.updateFailed' => 'Échec de la mise à jour',
			'common.versionUpdate.buttons.close' => 'Fermer',
			'common.versionUpdate.buttons.later' => 'Plus tard',
			'common.versionUpdate.buttons.copyCommand' => 'Copier la commande',
			'common.versionUpdate.buttons.updateNow' => 'Mettre à jour maintenant',
			'common.versionUpdate.buttons.updating' => 'Mise à jour...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Fermer la fenêtre de mise à jour',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Afficher la barre latérale',
			'common.versionUpdate.ariaLabels.settings' => 'Paramètres',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Mise à jour disponible',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Masquer la barre latérale',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => 'Aperçu',
			'common.quota.section.quotas' => 'Quotas',
			'common.quota.section.usage' => 'Utilisation',
			'common.quota.section.agents' => 'Agents',
			'common.quota.filter.all' => 'Tous',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 jours',
			'common.quota.period.k30d' => '30 jours',
			'common.quota.period.all' => 'Tous',
			'common.quota.group.provider' => 'Fournisseur',
			'common.quota.group.model' => 'Modèle',
			'common.quota.group.agent' => 'Agent',
			'common.quota.group.tool' => 'Outil',
			'common.quota.metric.tokens' => 'Tokens',
			'common.quota.metric.input' => 'Entrée',
			'common.quota.metric.output' => 'Sortie',
			'common.quota.metric.cache' => 'Lectures cache',
			'common.quota.metric.calls' => 'Appels API',
			'common.quota.metric.cost' => 'Coût',
			'common.quota.metric.sessions' => 'Sessions',
			'common.quota.cost.billed' => 'Facturé (API + dépassement)',
			'common.quota.cost.listPrice' => 'Prix catalogue des tokens utilisés',
			'common.quota.cost.subscriptionValue' => 'Couvert par les abonnements',
			'common.quota.cost.cacheSavings' => 'Économies de cache',
			'common.quota.cost3.billed' => 'Facturé (API + dépassement)',
			'common.quota.cost3.listPrice' => 'Prix catalogue des tokens utilisés',
			'common.quota.cost3.subscriptionValue' => 'Couvert par les abonnements',
			'common.quota.overview.trendTitle' => 'Tokens et coût — 7 derniers jours',
			'common.quota.overview.effectiveCost' => 'Coût effectif (7 jours)',
			'common.quota.overview.alertsTitle' => 'Alertes',
			'common.quota.overview.noAlerts' => 'Rien ne requiert votre attention pour le moment.',
			'common.quota.overview.limitsTitle' => 'Utilisation et limites',
			'common.quota.overview.activeTasks' => 'Tâches actives',
			'common.quota.overview.viewAccounts' => 'Tous les comptes',
			'common.quota.overview.viewAgents' => 'Tous les agents',
			'common.quota.overview.noTasks' => 'Aucun agent en cours d’exécution.',
			'common.quota.usage.trendTitle' => 'Tendance quotidienne',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Répartition par ${group}',
			'common.quota.usage.colName' => 'Nom',
			'common.quota.usage.sourceUnavailable' => 'Magasin d’analytique indisponible ; aucune donnée affichée.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} en cours',
			'common.quota.agents.colAgent' => 'Agent',
			'common.quota.agents.colStatus' => 'Statut',
			'common.quota.agents.colTask' => 'Tâche',
			'common.quota.agents.colModel' => 'Compte / modèle',
			'common.quota.agents.colTime' => 'Heure',
			'common.quota.agents.empty' => 'Aucun agent ne correspond à ce filtre.',
			'common.quota.agents.detailSession' => 'Session',
			'common.quota.agents.detailStarted' => 'Démarré',
			'common.quota.agents.detailRetries' => 'Réessais',
			'common.quota.agents.detailResult' => 'Résultat',
			'common.quota.agents.notTracked' => 'non suivi',
			'common.quota.agentStatus.running' => 'En cours',
			'common.quota.agentStatus.waiting' => 'En attente',
			'common.quota.agentStatus.failed' => 'Échoué',
			'common.quota.agentStatus.finished' => 'Terminé',
			'common.quota.agentStatus.queued' => 'En file',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window} : au rythme actuel, la limite sera atteinte dans ${value}',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window} : ${value} % utilisé (seuil ${watch} %)',
			'common.quota.backToChat' => 'Retour à la discussion',
			'common.quota.syncNow' => 'Synchroniser maintenant',
			'common.quota.generatedAt' => ({required Object value}) => 'Mis à jour ${value}',
			'common.quota.loading' => 'Chargement des limites de compte…',
			'common.quota.remaining' => ({required Object value}) => '${value} % restant',
			'common.quota.resetsIn' => ({required Object value}) => 'réinitialisation dans ${value}',
			'common.quota.projected' => ({required Object value}) => 'au rythme actuel, cette limite sera atteinte dans ${value}',
			'common.quota.syncedAgo' => ({required Object value}) => 'synchronisé il y a ${value}',
			'common.quota.refreshAccount' => 'Actualiser le compte',
			'common.quota.syncFailed' => 'Échec de la synchronisation',
			'common.quota.history' => 'Historique',
			'common.quota.historyPoints' => ({required Object value}) => '${value} relevés enregistrés',
			'common.quota.historyEmpty' => 'Aucun historique enregistré',
			'common.quota.noAgents' => 'Aucun agent assigné',
			'common.quota.noSubscription' => 'Aucun abonnement',
			'common.quota.noSubscriptionHint' => 'Le fournisseur ne signale aucun forfait actif pour ce compte.',
			'common.quota.quality.live' => 'En direct',
			'common.quota.quality.cached' => 'En cache',
			'common.quota.quality.estimate' => 'Estimation',
			'common.quota.quality.unknown' => 'Inconnu',
			'common.quota.quality.error' => 'Erreur',
			'common.quota.kpi.atRisk' => 'Limites à risque',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'comptes au-dessus de ${value} %',
			'common.quota.kpi.windowsAtRisk' => 'Fenêtres en épuisement',
			'common.quota.kpi.errored' => 'Échecs de synchronisation',
			'common.quota.kpi.activeAgents' => 'Agents actifs',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} en attente · ${queued} en file',
			'common.quota.kpi.nextReset' => 'Prochaine réinitialisation',
			'common.quota.kpi.tokens' => 'Tokens',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} sessions',
			'common.quota.kpi.cost' => 'Coût estimé',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} couvert par les abonnements',
			'common.quota.empty.title' => 'Aucun compte connecté',
			'common.quota.empty.description' => 'Connectez-vous à Claude, Codex, Gemini ou CommandCode pour suivre les quotas ici.',
			'common.quota.settings.title' => 'Alertes et routage',
			'common.quota.settings.description' => 'Contrôlez quand le tableau de bord vous avertit et comment les comptes sont suggérés pour le nouveau travail.',
			'common.quota.settings.alertsEnabled' => 'Alertes prédictives et de seuil',
			'common.quota.settings.alertsEnabledHint' => 'Avertir avant qu’une limite ne s’épuise au rythme actuel, pas seulement à 90 %.',
			'common.quota.settings.watchThreshold' => 'Seuil de surveillance (%)',
			'common.quota.settings.dangerThreshold' => 'Seuil de danger (%)',
			'common.quota.settings.routingMode' => 'Routage',
			'common.quota.settings.routing.manual' => 'Manuel — recommandation uniquement',
			'common.quota.settings.routing.ask' => 'Demander avant de changer de compte',
			'common.quota.settings.routing.autoLowRisk' => 'Changement auto pour les tâches à faible risque',
			'common.quota.settings.logSources' => 'Sources de journaux',
			'common.quota.settings.logSourcesHint' => 'Les écrans d’utilisation et d’agents lisent ces sources en lecture seule.',
			'common.quota.settings.quotaConsent' => 'Autoriser l’interrogation des quotas',
			'common.quota.settings.quotaConsentHint' => 'Interroge les points de terminaison des fournisseurs avec vos identifiants stockés pour lire les limites en direct.',
			'common.quota.settings.perAccount' => 'Remplacements par compte',
			'common.quota.settings.tab' => 'Paramètres du Control Center',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Tous',
			'common.actions.cancel' => 'Annuler',
			'common.actions.retry' => 'Réessayer',
			'common.actions.save' => 'Enregistrer',
			'common.browserPane.address' => 'Adresse',
			'common.browserPane.back' => 'Retour',
			'common.browserPane.connecting' => 'Connexion au navigateur…',
			'common.browserPane.connectionFailed' => 'Échec de la connexion au navigateur.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => 'Impossible de charger ${url}',
			'common.browserPane.disconnected' => 'Vue du navigateur déconnectée',
			'common.browserPane.enterUrl' => 'Saisir une URL',
			'common.browserPane.forward' => 'Suivant',
			'common.browserPane.invalidUrl' => 'Saisissez une URL http(s) valide',
			'common.browserPane.noAuthToken' => 'Aucun jeton d’authentification disponible.',
			'common.browserPane.openExternal' => 'Ouvrir dans le navigateur système',
			'common.browserPane.reload' => 'Recharger',
			'common.browserPane.retry' => 'Réessayer',
			'common.browserPane.stop' => 'Arrêter',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} actives',
			'common.browserUse.cancel' => 'Annuler',
			'common.browserUse.close' => 'Fermer',
			'common.browserUse.delete' => 'Supprimer',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} sera supprimée définitivement.',
			'common.browserUse.deleteSession' => 'Supprimer la session',
			'common.browserUse.deleteTitle' => 'Supprimer la session de navigateur ?',
			'common.browserUse.empty.descDisabled' => 'Activez Browser dans les paramètres pour permettre aux agents d’ouvrir des sessions de navigateur surveillées.',
			'common.browserUse.empty.descEnabled' => 'Les sessions de navigateur des agents apparaissent ici lorsqu’une tâche IA utilise Browser.',
			'common.browserUse.empty.titleDisabled' => 'Browser est désactivé',
			'common.browserUse.empty.titleEnabled' => 'Aucune session de navigateur pour le moment',
			'common.browserUse.emptyStatus' => 'vide',
			'common.browserUse.errors.actionFailed' => 'L’action du navigateur a échoué',
			'common.browserUse.errors.loadFailed' => 'Échec du chargement de Browser',
			'common.browserUse.fullscreen' => 'Plein écran',
			'common.browserUse.installRuntime' => 'Installer le runtime',
			'common.browserUse.installing' => 'Installation...',
			'common.browserUse.lastAction' => 'Dernière action',
			'common.browserUse.nextSnapshot' => 'La prochaine capture du navigateur de l’agent s’affichera ici.',
			'common.browserUse.noPageLoaded' => 'Aucune page chargée',
			'common.browserUse.noSessions' => 'Aucune session de navigateur d’agent.',
			'common.browserUse.none' => 'Aucun',
			'common.browserUse.openSettings' => 'Ouvrir les paramètres Browser',
			'common.browserUse.profile' => 'Profil',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Utilisez Browser pour inspecter le parcours de paiement et signaler les états d’UI défectueux.',
			'common.browserUse.prompts.prompt2' => 'Ouvrez <url> avec Browser, interagissez avec la page et résumez ce qui a changé après chaque étape.',
			'common.browserUse.refresh' => 'Actualiser les sessions de navigateur',
			'common.browserUse.relative.daysAgo' => ' j',
			'common.browserUse.relative.hoursAgo' => ' h',
			'common.browserUse.relative.justNow' => 'À l’instant',
			'common.browserUse.relative.minutesAgo' => ' min',
			'common.browserUse.relative.never' => 'Jamais',
			'common.browserUse.relative.secondsAgo' => ' s',
			'common.browserUse.relative.unknown' => 'Inconnu',
			'common.browserUse.runtime.disabled' => 'Désactivé',
			'common.browserUse.runtime.installing' => 'Installation',
			'common.browserUse.runtime.ready' => 'Prêt',
			'common.browserUse.runtime.setupRequired' => 'Configuration requise',
			'common.browserUse.runtimeSetup' => 'Configuration du runtime requise',
			'common.browserUse.selected' => 'Sélectionnée',
			'common.browserUse.sessionFallback' => 'Session de navigateur',
			'common.browserUse.sessionScreenshot' => 'Capture d’écran de la session de navigateur',
			'common.browserUse.sessions' => 'Sessions',
			'common.browserUse.status' => 'Statut',
			'common.browserUse.stop' => 'Arrêter',
			'common.browserUse.stopSession' => 'Arrêter la session',
			'common.browserUse.subtitle' => 'Surveillez les sessions de navigateur ouvertes par les agents IA.',
			'common.browserUse.temporary' => 'Temporaire',
			'common.browserUse.thisSession' => 'Cette session',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '${count} au total',
			'common.browserUse.updated' => ({required Object time}) => 'Mis à jour ${time}',
			'common.browserUse.waiting' => 'En attente',
			'common.browserUse.waitingForScreenshot' => 'En attente de la capture d’écran',
			'common.commandPalette.backToAll' => 'Retour à tout',
			'common.commandPalette.backspaceHint' => 'Retour arrière pour revenir',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Parcourir toutes les branches (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Parcourir tous les commits (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Parcourir tous les fichiers (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Parcourir toutes les sessions (${count})',
			'common.commandPalette.compare.costNote' => 'Le coût est une estimation côté client basée sur les tarifs par token publiés ; les modèles inconnus affichent « — ».',
			'common.commandPalette.compare.estCost' => 'Coût est.',
			'common.commandPalette.compare.inputOutput' => 'Entrée / Sortie',
			'common.commandPalette.compare.model' => 'Modèle',
			'common.commandPalette.compare.na' => 'N/D',
			'common.commandPalette.compare.openSplit' => 'Ouvrir en vue divisée',
			'common.commandPalette.compare.provider' => 'Fournisseur',
			'common.commandPalette.compare.selectSession' => 'Sélectionner une session…',
			'common.commandPalette.compare.tokensUsed' => 'Tokens utilisés',
			'common.commandPalette.groups.actions' => 'Actions',
			'common.commandPalette.groups.branches' => 'Branches',
			'common.commandPalette.groups.commits' => 'Commits',
			'common.commandPalette.groups.files' => 'Fichiers',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Naviguer',
			'common.commandPalette.groups.sessions' => 'Sessions',
			'common.commandPalette.groups.settings' => 'Paramètres',
			'common.commandPalette.hints.close' => 'Fermer',
			'common.commandPalette.hints.navigate' => 'Naviguer',
			'common.commandPalette.hints.select' => 'Sélectionner',
			'common.commandPalette.hints.togglePalette' => 'Basculer la palette',
			'common.commandPalette.items.compareSessions' => 'Comparer les sessions',
			'common.commandPalette.items.gitFetch' => 'Git : Fetch',
			'common.commandPalette.items.gitPull' => 'Git : Pull',
			'common.commandPalette.items.gitPush' => 'Git : Push',
			'common.commandPalette.items.openSettings' => 'Ouvrir les paramètres',
			'common.commandPalette.items.selectProjectFirst' => 'Sélectionnez d’abord un projet',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Paramètres : ${label}',
			'common.commandPalette.items.startNewChat' => 'Démarrer une nouvelle conversation',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Basculer vers : ${name}',
			'common.commandPalette.items.toggleTheme' => 'Basculer le thème',
			'common.commandPalette.items.tokensAndCost' => 'tokens et coût',
			'common.commandPalette.nav.board' => 'Aller au tableau des agents',
			'common.commandPalette.nav.chat' => 'Aller au chat',
			'common.commandPalette.nav.files' => 'Aller aux fichiers',
			'common.commandPalette.nav.git' => 'Aller à Git',
			'common.commandPalette.nav.sourceControl' => 'Aller au contrôle de source',
			'common.commandPalette.nav.tasks' => 'Aller aux tâches',
			'common.commandPalette.nav.usage' => 'Aller à Quota et utilisation',
			'common.commandPalette.noResults' => 'Aucun résultat.',
			'common.commandPalette.pages.actions' => 'Actions',
			'common.commandPalette.pages.branches' => 'Branches',
			'common.commandPalette.pages.commits' => 'Commits',
			'common.commandPalette.pages.compare' => 'Comparer',
			'common.commandPalette.pages.files' => 'Fichiers',
			'common.commandPalette.pages.sessions' => 'Sessions',
			'common.commandPalette.placeholder' => 'Tapez pour rechercher…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => 'Rechercher dans ${page}…',
			'common.commandPalette.title' => 'Palette de commandes',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} en avance',
			'common.gitPanel.aheadLabel' => 'en avance',
			'common.gitPanel.aiSuggest' => 'Suggestion IA',
			'common.gitPanel.aiSuggestTitle' => 'Générer un message de commit avec l’IA',
			'common.gitPanel.all' => 'Tous',
			'common.gitPanel.allStaged' => 'Toutes les modifications indexées',
			'common.gitPanel.behind' => ({required Object count}) => '${count} en retard',
			'common.gitPanel.behindLabel' => 'en retard',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'Supprimer la branche « ${branch} » ? Une suppression normale ne réussit que si la branche est entièrement fusionnée. Cette action est irréversible.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'Basculer vers la branche « ${branch} » ? Assurez-vous de n’avoir aucune modification non validée.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} locales, ${remote} distantes',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} locales',
			'common.gitPanel.branches.current' => 'actuelle',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => 'Supprimer ${branch}',
			'common.gitPanel.branches.emptyDesc' => 'Créez une branche pour commencer un travail parallèle.',
			'common.gitPanel.branches.forceDelete' => 'Forcer la suppression',
			'common.gitPanel.branches.forceDeleteDesc' => 'Supprime définitivement la branche même si elle contient des commits non fusionnés ailleurs.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Forcer la suppression de cette branche non fusionnée',
			'common.gitPanel.branches.local' => 'Locales',
			'common.gitPanel.branches.kNew' => 'Nouvelle branche',
			'common.gitPanel.branches.noMatch' => 'Aucune branche ne correspond à votre recherche',
			'common.gitPanel.branches.none' => 'Aucune branche trouvée',
			'common.gitPanel.branches.remote' => 'distantes',
			'common.gitPanel.branches.kSwitch' => 'Basculer',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Basculer vers ${branch}',
			'common.gitPanel.cancel' => 'Annuler',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Modifications (${count})',
			'common.gitPanel.clearSearch' => 'Effacer la recherche',
			'common.gitPanel.collapseDiff' => 'Réduire le diff',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Valider les modifications',
			'common.gitPanel.commitFiles' => ({required Object count}) => 'Valider ${count} fichier(s)',
			'common.gitPanel.committing' => 'Validation...',
			'common.gitPanel.confirmActions.commit' => 'Confirmer',
			'common.gitPanel.confirmActions.delete' => 'Supprimer',
			'common.gitPanel.confirmActions.deleteBranch' => 'Supprimer',
			'common.gitPanel.confirmActions.discard' => 'Ignorer',
			'common.gitPanel.confirmActions.publish' => 'Publier',
			'common.gitPanel.confirmActions.pull' => 'Tirer',
			'common.gitPanel.confirmActions.push' => 'Pousser',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Annuler le commit',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => 'Valider ${count} fichier(s) avec le message : « ${message} » ?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'Supprimer le fichier non suivi « ${file} » ? Cette action est irréversible.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => 'Ignorer toutes les modifications de « ${file} » ? Cette action est irréversible.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'Publier la branche « ${branch} » vers ${remote} ?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => 'Récupérer ${count} commit(s) depuis ${remote} ?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => 'Envoyer ${count} commit(s) vers ${remote} ?',
			'common.gitPanel.confirmRevert' => 'Annuler le dernier commit local ? Supprime le commit mais conserve ses modifications indexées.',
			'common.gitPanel.confirmTitles.commit' => 'Confirmer l’action',
			'common.gitPanel.confirmTitles.delete' => 'Supprimer le fichier',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Supprimer la branche',
			'common.gitPanel.confirmTitles.discard' => 'Ignorer les modifications',
			'common.gitPanel.confirmTitles.publish' => 'Publier la branche',
			'common.gitPanel.confirmTitles.pull' => 'Confirmer le pull',
			'common.gitPanel.confirmTitles.push' => 'Confirmer le push',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Annuler le commit local',
			'common.gitPanel.createBranch' => 'Créer une nouvelle branche',
			'common.gitPanel.creating' => 'Création...',
			'common.gitPanel.delete' => 'Supprimer',
			'common.gitPanel.deleteUntracked' => 'Supprimer le fichier non suivi',
			'common.gitPanel.deselectAll' => 'Tout désélectionner',
			'common.gitPanel.discard' => 'Ignorer',
			'common.gitPanel.discardChanges' => 'Ignorer les modifications',
			'common.gitPanel.dismiss' => 'Fermer',
			'common.gitPanel.dismissError' => 'Fermer l’erreur',
			'common.gitPanel.errors.createBranchFailed' => 'Échec de la création de la branche',
			'common.gitPanel.errors.createWorktreeFailed' => 'Échec de la création du worktree',
			'common.gitPanel.errors.deleteBranchFailed' => 'Échec de la suppression de la branche',
			'common.gitPanel.errors.fetchFailed' => 'Échec du fetch',
			'common.gitPanel.errors.initFailed' => 'Échec de l’initialisation du dépôt',
			'common.gitPanel.errors.initialCommitFailed' => 'Échec de la création du commit initial',
			'common.gitPanel.errors.mergeFailed' => 'Échec de la fusion',
			'common.gitPanel.errors.openWorktreeFailed' => 'Échec de l’ouverture du worktree',
			'common.gitPanel.errors.operationFailed' => 'L’opération git a échoué',
			'common.gitPanel.errors.publishFailed' => 'Échec de la publication',
			'common.gitPanel.errors.pullFailed' => 'Échec du pull',
			'common.gitPanel.errors.pushFailed' => 'Échec du push',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Échec de la suppression du worktree',
			'common.gitPanel.errors.stageFailed' => 'Échec de l’indexation',
			'common.gitPanel.errors.stageHunksFailed' => 'Échec de l’indexation des sections',
			'common.gitPanel.errors.switchFailed' => 'Échec du changement de branche',
			'common.gitPanel.errors.unstageFailed' => 'Échec du retrait de l’index',
			'common.gitPanel.errors.unstageHunksFailed' => 'Échec du retrait des sections de l’index',
			'common.gitPanel.expandDiff' => 'Développer le diff',
			'common.gitPanel.fetch' => 'Récupérer',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Fetch depuis ${remote}',
			'common.gitPanel.fetching' => 'Fetch…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} fichier(s) sélectionné(s)',
			'common.gitPanel.generating' => 'Génération...',
			'common.gitPanel.history.added' => 'Ajouté',
			'common.gitPanel.history.author' => 'Auteur',
			'common.gitPanel.history.changedFiles' => 'Fichiers modifiés',
			'common.gitPanel.history.date' => 'Date',
			'common.gitPanel.history.empty' => 'Aucun commit trouvé',
			'common.gitPanel.history.files' => 'Fichiers',
			'common.gitPanel.history.removed' => 'Supprimé',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Supprimer le worktree et sa branche une fois fusionnée',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Nettoyer après la fusion',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} commit(s)',
			'common.gitPanel.mergeWorktree.merge' => 'Fusionner',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Fusionner la branche \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Message de commit',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Combiner tous les ${commits} en un seul commit sur ${branch}',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Squasher les commits',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squash et fusion',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Squash-fusionner la branche \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => 'Fusionner le worktree',
			'common.gitPanel.merging' => 'Fusion...',
			'common.gitPanel.messagePlaceholder' => 'Message (Ctrl+Entrée pour valider)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Cela créera une nouvelle branche depuis la branche actuelle (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Nom de la branche',
			'common.gitPanel.newBranch.submit' => 'Créer la branche',
			'common.gitPanel.newBranch.title' => 'Créer une nouvelle branche',
			'common.gitPanel.newWorktree.branchLabel' => 'Branche',
			'common.gitPanel.newWorktree.createFrom' => 'Créer depuis',
			'common.gitPanel.newWorktree.description' => 'Extrayez une branche dans son propre dossier et travaillez dessus en parallèle.',
			'common.gitPanel.newWorktree.existingBranch' => 'Branche existante — elle sera extraite telle quelle.',
			'common.gitPanel.newWorktree.submit' => 'Créer le worktree',
			'common.gitPanel.newWorktree.switchAfter' => 'Basculer vers le worktree après sa création',
			'common.gitPanel.newWorktree.title' => 'Nouveau worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Sera créé dans',
			'common.gitPanel.noChanges' => 'Aucune modification détectée',
			'common.gitPanel.noChangesToCommit' => 'Aucune modification à valider',
			'common.gitPanel.noCommits.create' => 'Créer le commit initial',
			'common.gitPanel.noCommits.creating' => 'Création du commit initial...',
			'common.gitPanel.noCommits.description' => 'Ce dépôt n’a pas encore de commits. Créez votre premier commit pour commencer à suivre les modifications.',
			'common.gitPanel.noCommits.title' => 'Pas encore de commits',
			'common.gitPanel.noMatchingBranches' => 'Aucune branche correspondante',
			'common.gitPanel.noRepo.description' => 'Ce projet n’est pas encore un dépôt git. Initialisez-en un pour suivre les modifications et utiliser le contrôle de source.',
			'common.gitPanel.noRepo.init' => 'Exécuter git init',
			'common.gitPanel.noRepo.initializing' => 'Initialisation du dépôt...',
			'common.gitPanel.noRepo.title' => 'Pas de dépôt git',
			'common.gitPanel.noStagedFiles' => 'Aucun fichier indexé',
			'common.gitPanel.none' => 'Aucun',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Rien à envoyer vers ${remote}',
			'common.gitPanel.openFile' => 'Cliquer pour ouvrir le fichier',
			'common.gitPanel.publish' => 'Publier',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => 'Publier « ${branch} » vers ${remote}',
			'common.gitPanel.publishing' => 'Publication…',
			'common.gitPanel.pull' => 'Tirer',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Tirer ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => 'Récupérer ${count} depuis ${remote}',
			'common.gitPanel.pulling' => 'Pull…',
			'common.gitPanel.push' => 'Pousser',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Pousser ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => 'Envoyer ${count} vers ${remote}',
			'common.gitPanel.pushing' => 'Push…',
			'common.gitPanel.recentCommits' => 'Commits récents',
			'common.gitPanel.refresh' => 'Actualiser le statut git',
			'common.gitPanel.remove' => 'Supprimer',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Supprimer aussi la branche',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => 'Supprimer le worktree de ${branch} ? Son dossier est supprimé et le projet lié archivé — les sessions de chat restent récupérables.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'Ce worktree a ${count} modification(s) non validée(s) qui seront perdues.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Ignorer les modifications non validées',
			'common.gitPanel.removeWorktree.title' => 'Supprimer le worktree',
			'common.gitPanel.removing' => 'Suppression...',
			'common.gitPanel.revertLatest' => 'Annuler le dernier commit local',
			'common.gitPanel.scroll' => 'Défiler',
			'common.gitPanel.searchBranches' => 'Rechercher des branches...',
			'common.gitPanel.selectAll' => 'Tout sélectionner',
			'common.gitPanel.selectProject' => 'Sélectionnez un projet pour voir le contrôle de source',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => '${selected} sur ${total} fichiers sélectionnés',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => '${selected} sur ${total} sélectionnés',
			'common.gitPanel.sideBySide' => 'Côte à côte',
			'common.gitPanel.stageAll' => 'Tout indexer',
			'common.gitPanel.stageHunk' => 'Indexer cette section',
			'common.gitPanel.staged' => ({required Object count}) => 'Indexés (${count})',
			'common.gitPanel.status.added' => 'Ajouté',
			'common.gitPanel.status.deleted' => 'Supprimé',
			'common.gitPanel.status.modified' => 'Modifié',
			'common.gitPanel.status.untracked' => 'Non suivi',
			'common.gitPanel.statusGuide' => 'Guide des statuts de fichiers',
			'common.gitPanel.switchScroll' => 'Passer au défilement horizontal',
			'common.gitPanel.switchSplit' => 'Passer à la vue côte à côte',
			'common.gitPanel.switchUnified' => 'Passer à la vue unifiée',
			'common.gitPanel.switchWrap' => 'Passer au retour à la ligne',
			'common.gitPanel.unified' => 'Unifié',
			'common.gitPanel.unstageAll' => 'Tout retirer de l’index',
			'common.gitPanel.unstageHunk' => 'Retirer cette section de l’index',
			'common.gitPanel.upToDate' => 'À jour',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'À jour avec ${remote}',
			'common.gitPanel.viewAll' => 'Tout voir',
			'common.gitPanel.viewsAria' => 'Vues du contrôle de source',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} modification(s)',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree(s)',
			'common.gitPanel.worktrees.createFirst' => 'Créez votre premier worktree',
			'common.gitPanel.worktrees.detached' => 'détaché',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'détaché @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'HEAD détaché',
			'common.gitPanel.worktrees.emptyDesc' => 'Un worktree extrait une branche dans son propre dossier, vous permettant de mener des sessions de chat parallèles et de fusionner les résultats une fois prêts.',
			'common.gitPanel.worktrees.emptyTitle' => 'Travaillez sur des branches en parallèle',
			'common.gitPanel.worktrees.locked' => 'verrouillé',
			'common.gitPanel.worktrees.mainWorktree' => 'worktree principal',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => 'Fusionner ${branch} dans la branche de base',
			'common.gitPanel.worktrees.kNew' => 'Nouveau worktree',
			'common.gitPanel.worktrees.none' => 'Aucun worktree',
			'common.gitPanel.worktrees.nothingToMerge' => 'Rien à fusionner — aucun commit en avance sur la branche de base',
			'common.gitPanel.worktrees.open' => 'Ouvrir',
			'common.gitPanel.worktrees.refresh' => 'Actualiser les worktrees',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Supprimer le worktree de ${branch}',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Basculer vers ${branch}',
			'common.gitPanel.wrap' => 'Retour à la ligne',
			'common.gitPanel.tabs.changes' => 'Modifications',
			'common.gitPanel.tabs.history' => 'Commits',
			'common.gitPanel.tabs.branches' => 'Branches',
			'common.gitPanel.tabs.worktrees' => 'Worktrees',
			'common.sessions.renameSession' => 'Renommer la session',
			'common.projects.newSession' => 'Nouvelle session',
			'common.codeBlock.wrapLines' => 'Retour à la ligne',
			'common.codeBlock.noWrap' => 'Aucun retour à la ligne',
			'common.update.available' => ({required Object version}) => 'Mise à jour disponible · v${version}',
			'common.update.confirm' => ({required Object version}) => 'Mettre à jour vers v${version} ? Le serveur se met à jour et redémarre automatiquement — les sessions actives seront interrompues.',
			'common.update.downloading' => 'Téléchargement et application de la mise à jour…',
			'common.update.restarting' => 'Redémarrage du serveur — cela prend un instant…',
			'common.update.done' => ({required Object version}) => 'Mis à jour vers v${version}. Rechargez l\'application pour charger le nouveau bundle.',
			'common.update.manualRestart' => 'La mise à jour a été appliquée mais le serveur ne s\'est pas redémarré tout seul — redémarrez-le manuellement pour terminer.',
			'common.update.failed' => 'Échec de la mise à jour.',
			'common.update.failedTitle' => 'Échec de la mise à jour',
			'common.update.appConfirm' => ({required Object version}) => 'Installer DDAgent v${version} sur cet appareil ? Android demandera l\'autorisation d\'installer des applications depuis DDAgent la première fois.',
			'common.update.appPermission' => 'Autorisez « Installer des applications inconnues » pour DDAgent, puis appuyez à nouveau sur Mettre à jour.',
			'common.update.chooseTitle' => 'Mises à jour disponibles',
			'common.update.targetApp' => 'Cette application',
			'common.update.targetWeb' => 'Interface web',
			'common.update.targetServer' => 'Serveur',
			'common.update.updateApp' => 'Mettre à jour l\'application',
			'common.update.updateWeb' => 'Mettre à jour l\'interface web',
			'common.update.updateServer' => 'Mettre à jour le serveur',
			'common.update.webConfirm' => ({required Object version}) => 'Mettre à jour l\'interface web vers v${version} ? La page sera rechargée ensuite.',
			'common.update.webDone' => ({required Object version}) => 'Interface web mise à jour vers v${version} — rechargement…',
			'common.update.localServerConfirm' => ({required Object version}) => 'Mettre à jour le serveur local de cet appareil vers v${version} ? Les sessions actives seront interrompues.',
			'common.update.localServerUpdating' => 'Téléchargement et démarrage du serveur local…',
			'common.update.serverDone' => ({required Object version}) => 'Le serveur exécute v${version}.',
			'common.update.staged' => ({required Object version}) => 'Mise à jour v${version} téléchargée — redémarrez le serveur pour l\'installer.',
			'common.update.upToDate' => 'Le serveur est déjà sur la dernière version.',
			'common.update.webHostFailed' => ({required Object message}) => 'Le serveur a été mis à jour, mais pas son interface web : ${message}',
			'settings.title' => 'Paramètres',
			'settings.changelog.title' => 'Journal des modifications',
			'settings.changelog.loading' => 'Chargement…',
			'settings.changelog.empty' => 'Aucune version à afficher',
			'settings.changelog.current' => 'actuelle',
			'settings.changelog.kNew' => 'nouvelle',
			'settings.server.title' => 'Serveur',
			'settings.server.description' => 'Redémarre le processus DDAgent — utile après une mise à jour ou en cas de blocage.',
			'settings.server.restart' => 'Redémarrer',
			'settings.server.restartConfirm' => 'Redémarrer le serveur DDAgent ? Les sessions actives seront interrompues.',
			'settings.server.restarting' => 'Redémarrage… la page se rechargera quand le serveur sera de retour.',
			'settings.server.restartFailed' => 'Le redémarrage a échoué',
			'settings.server.unsupported' => 'Le redémarrage n\'est disponible que lorsque le serveur tourne sous le gestionnaire de services.',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'Redémarrage du serveur',
			'settings.server.restartRequesting' => 'Demande de redémarrage envoyée au serveur…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'En attente du retour du serveur… (${seconds} s)',
			'settings.server.restartBack' => ({required Object version}) => 'Le serveur est de retour — version ${version}.',
			'settings.server.restartReloading' => 'Rechargement de la page…',
			'settings.server.restartTimeout' => ({required Object seconds}) => 'Le serveur n\'est pas revenu en ${seconds} s. Consultez le journal du service (/tmp/ddagent.log) ou redémarrez-le manuellement.',
			'settings.updates.title' => 'Mises à jour',
			'settings.updates.description' => 'Rechercher une build de bureau plus récente sur GitHub. Les nouvelles versions se téléchargent automatiquement et s\'installent à la fermeture.',
			'settings.updates.check' => 'Rechercher des mises à jour',
			'settings.updates.checking' => 'Recherche…',
			'settings.updates.upToDate' => ({required Object version}) => 'Vous avez la dernière version (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Mise à jour v${version} trouvée — téléchargement en arrière-plan ; elle s\'installera à la fermeture de DDAgent.',
			'settings.updates.downloaded' => ({required Object version}) => 'Mise à jour v${version} téléchargée — quittez et relancez DDAgent pour l\'installer.',
			'settings.updates.unavailable' => 'La recherche de mises à jour n\'est disponible que dans les builds de bureau empaquetées.',
			'settings.updates.error' => ({required Object message}) => 'Échec de la recherche de mises à jour : ${message}',
			'settings.updates.errorGeneric' => 'Échec de la recherche de mises à jour.',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · dernière v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — à jour',
			'settings.updates.webNotHosted' => ({required Object version}) => 'Cette interface web est hébergée séparément — remplacez ses fichiers par ddagent-flutter-web-v${version}.zip de la version.',
			'settings.updates.serverCannotUpdate' => 'Ce serveur ne peut pas se mettre à jour d\'ici — réinstallez-le avec install.sh ou une archive de la version.',
			'settings.tabs.account' => 'Compte',
			'settings.tabs.permissions' => 'Permissions',
			'settings.tabs.mcpServers' => 'Serveurs MCP',
			'settings.tabs.appearance' => 'Apparence',
			'settings.tabs.skills' => 'Skills',
			'settings.account.title' => 'Compte',
			'settings.account.language' => 'Langue',
			'settings.account.languageLabel' => 'Langue d\'affichage',
			'settings.account.languageDescription' => 'Choisissez votre langue préférée pour l\'interface',
			'settings.account.username' => 'Nom d\'utilisateur',
			'settings.account.email' => 'E-mail',
			'settings.account.profile' => 'Profil',
			'settings.account.changePassword' => 'Changer le mot de passe',
			'settings.mcp.title' => 'Serveurs MCP',
			'settings.mcp.addServer' => 'Ajouter un serveur',
			'settings.mcp.editServer' => 'Modifier le serveur',
			'settings.mcp.deleteServer' => 'Supprimer le serveur',
			'settings.mcp.serverName' => 'Nom du serveur',
			'settings.mcp.serverType' => 'Type de serveur',
			'settings.mcp.config' => 'Configuration',
			'settings.mcp.testConnection' => 'Tester la connexion',
			'settings.mcp.status' => 'Statut',
			'settings.mcp.connected' => 'Connecté',
			'settings.mcp.disconnected' => 'Déconnecté',
			'settings.mcp.scope.label' => 'Portée',
			'settings.mcp.scope.user' => 'Utilisateur',
			'settings.mcp.scope.project' => 'Projet',
			'settings.appearance.title' => 'Apparence',
			'settings.appearance.theme' => 'Thème',
			'settings.appearance.codeEditor' => 'Éditeur de code',
			'settings.appearance.editorTheme' => 'Thème de l\'éditeur',
			'settings.appearance.wordWrap' => 'Retour à la ligne',
			'settings.appearance.showMinimap' => 'Afficher la minimap',
			'settings.appearance.lineNumbers' => 'Numéros de ligne',
			'settings.appearance.fontSize' => 'Taille de police',
			'settings.appearance.themeModes.dark' => 'Sombre',
			'settings.appearance.themeModes.light' => 'Clair',
			'settings.appearance.themeModes.system' => 'Système',
			'settings.actions.saveChanges' => 'Enregistrer les modifications',
			'settings.actions.resetToDefaults' => 'Rétablir les valeurs par défaut',
			'settings.actions.cancelChanges' => 'Annuler les modifications',
			'settings.quickSettings.title' => 'Paramètres rapides',
			'settings.quickSettings.sections.appearance' => 'Apparence',
			'settings.quickSettings.sections.toolDisplay' => 'Affichage des outils',
			'settings.quickSettings.sections.inputSettings' => 'Paramètres de saisie',
			'settings.quickSettings.darkMode' => 'Mode sombre',
			'settings.quickSettings.showRawParameters' => 'Afficher les paramètres bruts',
			'settings.quickSettings.showThinking' => 'Afficher la réflexion',
			'settings.quickSettings.sendByCtrlEnter' => 'Envoyer avec Ctrl+Entrée',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Lorsqu\'activé, appuyer sur Ctrl+Entrée envoie le message au lieu de simplement Entrée. Utile pour les utilisateurs IME pour éviter les envois accidentels.',
			'settings.quickSettings.dragHandle.dragging' => 'Glissement en cours',
			'settings.quickSettings.dragHandle.closePanel' => 'Fermer le panneau de paramètres',
			'settings.quickSettings.dragHandle.openPanel' => 'Ouvrir le panneau de paramètres',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Glissement...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Cliquer pour basculer, glisser pour déplacer',
			'settings.quickSettings.sendWithCtrlEnter' => 'Envoyer avec Ctrl+Entrée',
			'settings.terminalShortcuts.title' => 'Raccourcis terminal',
			'settings.terminalShortcuts.sectionKeys' => 'Touches',
			'settings.terminalShortcuts.sectionNavigation' => 'Navigation',
			'settings.terminalShortcuts.escape' => 'Échap',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Maj+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Flèche haut',
			'settings.terminalShortcuts.arrowDown' => 'Flèche bas',
			'settings.terminalShortcuts.scrollDown' => 'Défiler vers le bas',
			'settings.terminalShortcuts.handle.closePanel' => 'Fermer le panneau de raccourcis',
			'settings.terminalShortcuts.handle.openPanel' => 'Ouvrir le panneau de raccourcis',
			'settings.terminalShortcuts.killTitle' => 'Tuer le processus en cours (Ctrl+C)',
			'settings.terminalShortcuts.paste' => 'Coller',
			'settings.mainTabs.label' => 'Paramètres',
			'settings.mainTabs.agents' => 'Agents',
			'settings.mainTabs.orchestration' => 'Orchestration',
			'settings.mainTabs.appearance' => 'Apparence',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API et jetons',
			'settings.mainTabs.models' => 'Modèles',
			'settings.mainTabs.tasks' => 'Tâches',
			'settings.mainTabs.notifications' => 'Notifications',
			'settings.mainTabs.about' => 'À propos',
			'settings.mainTabs.workspaces' => 'Espaces de travail',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Outils',
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
			'settings.orchestration.pool.fields.redundantAccounts' => 'Comptes redondants',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Aucun autre compte pour ce fournisseur',
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
			'settings.notifications.title' => 'Notifications',
			'settings.notifications.description' => 'Contrôlez les événements de notification que vous recevez.',
			'settings.notifications.webPush.title' => 'Notifications push web',
			'settings.notifications.webPush.enable' => 'Activer les notifications push',
			'settings.notifications.webPush.disable' => 'Désactiver les notifications push',
			'settings.notifications.webPush.enabled' => 'Les notifications push sont activées',
			'settings.notifications.webPush.loading' => 'Mise à jour...',
			'settings.notifications.webPush.unsupported' => 'Les notifications push ne sont pas prises en charge dans ce navigateur.',
			'settings.notifications.webPush.denied' => 'Les notifications push sont bloquées. Veuillez les autoriser dans les paramètres de votre navigateur.',
			'settings.notifications.webPush.iosHint' => 'Sur iPhone/iPad, les notifications ne fonctionnent qu’après avoir ajouté DDAgent à l’écran d’accueil (Partager → Ajouter à l’écran d’accueil) et les avoir activées depuis l’app installée.',
			'settings.notifications.webPush.test' => 'Envoyer une notification de test',
			'settings.notifications.webPush.testNoSubscription' => 'Aucun appareil n’est abonné. Touchez d’abord « Activer » sur le téléphone.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Envoyé à ${count} appareil(s). Si rien n’apparaît sur le téléphone, ajoutez DDAgent à l’écran d’accueil (requis par iOS).',
			'settings.notifications.webPush.testNotDelivered' => 'Aucun appareil n\'était joignable. Vérifiez que l\'application est en cours d\'exécution et que les notifications sont activées.',
			'settings.notifications.device.title' => 'Notifier cet appareil',
			'settings.notifications.device.enabled' => 'Les notifications sont activées pour cet appareil',
			'settings.notifications.sound.title' => 'Son',
			'settings.notifications.sound.description' => 'Jouer un court son lorsqu\'une exécution de chat se termine.',
			'settings.notifications.sound.enabled' => 'Activé',
			'settings.notifications.sound.test' => 'Tester le son',
			'settings.notifications.events.title' => 'Types d\'événements',
			'settings.notifications.events.actionRequired' => 'Action requise',
			'settings.notifications.events.stop' => 'Exécution arrêtée',
			'settings.notifications.events.error' => 'Exécution échouée',
			'settings.notifications.desktop.title' => 'Notifier cette application de bureau',
			'settings.notifications.desktop.enable' => 'Activer les notifications push',
			'settings.notifications.desktop.disable' => 'Désactiver les notifications push',
			'settings.notifications.desktop.enabled' => 'Les notifications sont activées pour cette application de bureau',
			'settings.notifications.desktop.unsupported' => 'Les notifications de bureau ne sont pas prises en charge sur ce système.',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.unpair' => 'Dissocier',
			'settings.appearanceSettings.darkMode.label' => 'Mode sombre',
			'settings.appearanceSettings.darkMode.description' => 'Basculer entre les thèmes clair et sombre',
			'settings.appearanceSettings.codeEditor.title' => 'Éditeur de code',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Thème de l\'éditeur',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Thème par défaut pour l\'éditeur de code',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Retour à la ligne',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Activer le retour à la ligne par défaut dans l\'éditeur',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Afficher la minimap',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Afficher une minimap pour une navigation plus facile en vue diff',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Afficher les numéros de ligne',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Afficher les numéros de ligne dans l\'éditeur',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Taille de police',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Taille de police de l\'éditeur en pixels',
			'settings.appearanceSettings.terminal.title' => 'Terminal',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Le focus suit le pointeur',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Donner le focus au terminal pour la saisie lorsque vous déplacez la souris dessus',
			'settings.mcpForm.title.add' => 'Ajouter un serveur MCP',
			'settings.mcpForm.title.edit' => 'Modifier le serveur MCP',
			'settings.mcpForm.importMode.form' => 'Saisie via formulaire',
			'settings.mcpForm.importMode.json' => 'Import JSON',
			'settings.mcpForm.scope.label' => 'Portée',
			'settings.mcpForm.scope.userGlobal' => 'Utilisateur (global)',
			'settings.mcpForm.scope.projectLocal' => 'Projet (local)',
			'settings.mcpForm.scope.userDescription' => 'Portée utilisateur : Disponible dans tous les projets sur votre machine',
			'settings.mcpForm.scope.projectDescription' => 'Portée locale : Disponible uniquement dans le projet sélectionné',
			'settings.mcpForm.scope.cannotChange' => 'La portée ne peut pas être modifiée lors de la modification d\'un serveur existant',
			'settings.mcpForm.fields.serverName' => 'Nom du serveur',
			'settings.mcpForm.fields.transportType' => 'Type de transport',
			'settings.mcpForm.fields.command' => 'Commande',
			'settings.mcpForm.fields.arguments' => 'Arguments (un par ligne)',
			'settings.mcpForm.fields.jsonConfig' => 'Configuration JSON',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Variables d\'environnement (CLÉ=valeur, une par ligne)',
			'settings.mcpForm.fields.headers' => 'En-têtes (CLÉ=valeur, un par ligne)',
			'settings.mcpForm.fields.selectProject' => 'Sélectionner un projet...',
			'settings.mcpForm.placeholders.serverName' => 'mon-serveur',
			'settings.mcpForm.validation.missingType' => 'Champ requis manquant : type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'Le type stdio nécessite un champ command',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => 'Le type ${type} nécessite un champ url',
			'settings.mcpForm.validation.invalidJson' => 'Format JSON invalide',
			'settings.mcpForm.validation.jsonHelp' => 'Collez la configuration de votre serveur MCP en format JSON. Exemples :',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio : {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse : {"type":"http","url":"https://api.exemple.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Détails de configuration (depuis ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Chemin : ${path}',
			'settings.mcpForm.actions.cancel' => 'Annuler',
			'settings.mcpForm.actions.saving' => 'Enregistrement...',
			'settings.mcpForm.actions.addServer' => 'Ajouter le serveur',
			'settings.mcpForm.actions.updateServer' => 'Mettre à jour le serveur',
			'settings.saveStatus.success' => 'Paramètres enregistrés avec succès !',
			'settings.saveStatus.error' => 'Échec de l\'enregistrement des paramètres',
			'settings.saveStatus.saving' => 'Enregistrement...',
			'settings.footerActions.save' => 'Enregistrer les paramètres',
			'settings.footerActions.cancel' => 'Annuler',
			'settings.git.title' => 'Configuration Git',
			'settings.git.description' => 'Configurez votre identité git pour les commits. Ces paramètres seront appliqués globalement via git config --global',
			'settings.git.name.label' => 'Nom Git',
			'settings.git.name.help' => 'Votre nom pour les commits git',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'E-mail Git',
			'settings.git.email.help' => 'Votre e-mail pour les commits git',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Enregistrer la configuration',
			'settings.git.actions.saving' => 'Enregistrement...',
			'settings.git.status.success' => 'Enregistré avec succès',
			'settings.git.status.error' => 'Échec de l’enregistrement',
			'settings.apiKeys.title' => 'Clés API',
			'settings.apiKeys.description' => 'Générez des clés API pour accéder à l\'API externe depuis d\'autres applications.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ Sauvegardez votre clé API',
			'settings.apiKeys.newKey.alertMessage' => 'C\'est la seule fois que vous verrez cette clé. Stockez-la en lieu sûr.',
			'settings.apiKeys.newKey.iveSavedIt' => 'Je l\'ai sauvegardée',
			'settings.apiKeys.form.placeholder' => 'Nom de la clé API (ex. : Serveur de production)',
			'settings.apiKeys.form.createButton' => 'Créer',
			'settings.apiKeys.form.cancelButton' => 'Annuler',
			'settings.apiKeys.newButton' => 'Nouvelle clé API',
			'settings.apiKeys.empty' => 'Aucune clé API créée pour l\'instant.',
			'settings.apiKeys.list.created' => 'Créée :',
			'settings.apiKeys.list.lastUsed' => 'Dernière utilisation :',
			'settings.apiKeys.confirmDelete' => 'Êtes-vous sûr de vouloir supprimer cette clé API ?',
			'settings.apiKeys.status.active' => 'Actif',
			'settings.apiKeys.status.inactive' => 'Inactif',
			'settings.apiKeys.github.title' => 'Tokens GitHub',
			'settings.apiKeys.github.description' => 'Ajoutez des tokens d\'accès personnel GitHub pour cloner des dépôts privés via l\'API externe.',
			'settings.apiKeys.github.descriptionAlt' => 'Ajoutez des tokens d\'accès personnel GitHub pour cloner des dépôts privés. Vous pouvez aussi passer des tokens directement dans les requêtes API sans les stocker.',
			'settings.apiKeys.github.addButton' => 'Ajouter un token',
			'settings.apiKeys.github.form.namePlaceholder' => 'Nom du token (ex. : Dépôts personnels)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'Token d\'accès personnel GitHub (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Description (optionnel)',
			'settings.apiKeys.github.form.addButton' => 'Ajouter le token',
			'settings.apiKeys.github.form.cancelButton' => 'Annuler',
			'settings.apiKeys.github.form.howToCreate' => 'Comment créer un token d\'accès personnel GitHub →',
			'settings.apiKeys.github.form.showToken' => 'Afficher le token',
			'settings.apiKeys.github.form.hideToken' => 'Masquer le token',
			'settings.apiKeys.github.empty' => 'Aucun token GitHub ajouté pour l\'instant.',
			'settings.apiKeys.github.added' => 'Ajouté :',
			'settings.apiKeys.github.confirmDelete' => 'Êtes-vous sûr de vouloir supprimer ce token GitHub ?',
			'settings.apiKeys.apiDocsLink' => 'Documentation API',
			'settings.apiKeys.documentation.title' => 'Documentation de l\'API externe',
			'settings.apiKeys.documentation.description' => 'Apprenez à utiliser l\'API externe pour déclencher des sessions Claude/Cursor depuis vos applications.',
			'settings.apiKeys.documentation.viewLink' => 'Voir la documentation API →',
			'settings.apiKeys.loading' => 'Chargement...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Mise à jour disponible : v${version}',
			'settings.tasks.checking' => 'Vérification de l\'installation TaskMaster...',
			'settings.tasks.notInstalled.title' => 'CLI TaskMaster AI non installé',
			'settings.tasks.notInstalled.description' => 'Le CLI TaskMaster est requis pour utiliser les fonctionnalités de gestion des tâches. Installez-le pour commencer :',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'Voir sur GitHub',
			'settings.tasks.notInstalled.afterInstallation' => 'Après l\'installation :',
			'settings.tasks.notInstalled.steps.restart' => 'Redémarrez cette application',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'Les fonctionnalités TaskMaster deviendront automatiquement disponibles',
			'settings.tasks.notInstalled.steps.initCommand' => 'Utilisez task-master init dans votre répertoire de projet',
			'settings.tasks.settings.enableLabel' => 'Activer l\'intégration TaskMaster',
			'settings.tasks.settings.enableDescription' => 'Afficher les tâches TaskMaster, les bannières et les indicateurs dans la barre latérale',
			'settings.agents.authStatus.checking' => 'Vérification...',
			'settings.agents.authStatus.connected' => 'Connecté',
			'settings.agents.authStatus.notConnected' => 'Non connecté',
			'settings.agents.authStatus.disconnected' => 'Déconnecté',
			'settings.agents.authStatus.checkingAuth' => 'Vérification du statut d\'authentification...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Connecté en tant que ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => 'Compte ${provider}',
			'settings.agents.authStatus.authenticatedUser' => 'utilisateur authentifié',
			'settings.agents.install.title' => ({required Object agent}) => 'La CLI ${agent} n\'est pas installée',
			'settings.agents.install.description' => ({required Object agent}) => 'Installez la CLI ${agent} pour vous connecter et lancer des sessions.',
			'settings.agents.install.button' => 'Installer',
			'settings.agents.install.installing' => 'Installation…',
			'settings.agents.install.copyCommand' => 'Copier la commande',
			'settings.agents.install.docs' => 'Documentation',
			'settings.agents.install.success' => ({required Object agent}) => 'CLI ${agent} installée',
			'settings.agents.install.failed' => 'Échec de l\'installation — vérifiez la sortie du terminal',
			'settings.agents.update.title' => 'Mettre à jour le CLI',
			'settings.agents.update.description' => ({required Object agent}) => 'Installe la dernière version du CLI ${agent} sur l\'hôte du serveur.',
			'settings.agents.update.button' => 'Mettre à jour',
			'settings.agents.update.updating' => 'Mise à jour…',
			'settings.agents.update.success' => ({required Object agent}) => 'CLI ${agent} mis à jour',
			'settings.agents.update.failed' => 'Échec de la mise à jour — consultez la sortie du terminal',
			'settings.agents.account.claude.description' => 'Assistant IA Claude d\'Anthropic',
			'settings.agents.account.cursor.description' => 'Éditeur de code IA Cursor',
			'settings.agents.account.codex.description' => 'Assistant IA Codex d\'OpenAI',
			'settings.agents.account.opencode.description' => 'Assistant CLI OpenCode',
			'settings.agents.account.commandcode.description' => 'Assistant CLI Command Code',
			_ => null,
		} ?? switch (path) {
			'settings.agents.account.antigravity.description' => 'Assistant CLI Antigravity',
			'settings.agents.account.devin.description' => 'Assistant CLI Devin',
			'settings.agents.connectionStatus' => 'Statut de la connexion',
			'settings.agents.login.title' => 'Connexion',
			'settings.agents.login.reAuthenticate' => 'Se ré-authentifier',
			'settings.agents.login.description' => ({required Object agent}) => 'Connectez-vous à votre compte ${agent} pour activer les fonctionnalités IA',
			'settings.agents.login.reAuthDescription' => 'Connectez-vous avec un autre compte ou actualisez les identifiants',
			'settings.agents.login.button' => 'Se connecter',
			'settings.agents.login.reLoginButton' => 'Se reconnecter',
			'settings.agents.logout.title' => 'Se déconnecter',
			'settings.agents.logout.description' => 'Se déconnecter de ce fournisseur et effacer ses identifiants enregistrés',
			'settings.agents.logout.button' => 'Se déconnecter',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => 'Se déconnecter de ${agent} ?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Cela supprime les identifiants ${agent} enregistrés sur le serveur. Reconnectez-vous pour continuer à utiliser ${agent}.',
			'settings.agents.logout.success' => 'Déconnecté',
			'settings.agents.logout.failed' => 'Échec de la déconnexion',
			'settings.agents.error' => ({required Object error}) => 'Erreur : ${error}',
			'settings.permissions.title' => 'Paramètres de permission',
			'settings.permissions.permissionMode.title' => 'Mode de permission',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Mode de permission par défaut pour les nouvelles sessions ${provider}. Vous pouvez toujours le remplacer pour une session individuelle.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Par défaut',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Les actions nécessitant une permission vous sont présentées pour approbation dans la discussion.',
			'settings.permissions.permissionMode.modes.auto.title' => 'Mode automatique',
			'settings.permissions.permissionMode.modes.auto.description' => 'Un classifieur de modèle décide pour chaque appel d\'outil d\'approuver ou refuser. Mode mains libres, mais plus sûr que le contournement — des refus peuvent toujours se produire.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Accepter les modifications',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Les modifications de fichiers sont approuvées automatiquement ; les autres actions demandent toujours votre approbation.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Contourner les permissions',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Chaque action est approuvée automatiquement — accès complet sans invites. À utiliser avec prudence.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Mode planification : l’agent explore et planifie sans exécuter de commandes.',
			'settings.mcpServers.title' => 'Serveurs MCP',
			'settings.mcpServers.description.claude' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Claude',
			'settings.mcpServers.description.cursor' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Cursor',
			'settings.mcpServers.description.codex' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Codex',
			'settings.mcpServers.description.opencode' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à OpenCode',
			'settings.mcpServers.description.commandcode' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Command Code',
			'settings.mcpServers.description.antigravity' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Antigravity',
			'settings.mcpServers.description.devin' => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à Devin',
			'settings.mcpServers.addButton' => 'Ajouter un serveur MCP',
			'settings.mcpServers.empty' => 'Aucun serveur MCP configuré',
			'settings.mcpServers.serverType' => 'Type',
			'settings.mcpServers.scope.local' => 'local',
			'settings.mcpServers.scope.user' => 'utilisateur',
			'settings.mcpServers.config.command' => 'Commande',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Arguments',
			'settings.mcpServers.config.environment' => 'Environnement',
			'settings.mcpServers.tools.title' => 'Outils',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}) :',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} de plus',
			'settings.mcpServers.actions.edit' => 'Modifier le serveur',
			'settings.mcpServers.actions.delete' => 'Supprimer le serveur',
			'settings.mcpServers.help.title' => 'À propos de Codex MCP',
			'settings.mcpServers.help.description' => 'Codex prend en charge les serveurs MCP basés sur stdio. Vous pouvez ajouter des serveurs qui étendent les capacités de Codex avec des outils et ressources supplémentaires.',
			'settings.mcpServers.managed.badge' => 'Géré',
			'settings.mcpServers.managed.hint' => 'Géré par DDAgent.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '« ${serverName} » sera supprimé de la configuration du fournisseur.',
			'settings.mcpServers.deleteConfirm.title' => 'Supprimer le serveur MCP ?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => 'Seuils d’alerte, politique de routage et comptes interrogés pour les quotas.',
			'settings.quota.settings.saved' => 'Enregistré',
			'settings.quota.settings.alertsSection' => 'Alertes',
			'settings.quota.settings.alertsSectionHint' => 'Avertir avant qu’une limite soit réellement épuisée, pas seulement à 100 %.',
			'settings.quota.settings.alertsEnabled' => 'Alertes de limite prévues',
			'settings.quota.settings.alertsEnabledHint' => 'Afficher des projections basées sur le rythme dans l’aperçu et les cartes de compte.',
			'settings.quota.settings.watchThreshold' => 'Seuil de surveillance (%)',
			'settings.quota.settings.watchThresholdHint' => 'Les comptes à ce relevé ou au-dessus sont comptés comme à risque.',
			'settings.quota.settings.dangerThreshold' => 'Seuil de danger (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Les relevés à cette valeur ou au-dessus sont affichés en rouge.',
			'settings.quota.settings.routingSection' => 'Routage',
			'settings.quota.settings.routingSectionHint' => 'Comment le panneau peut déplacer le travail vers le compte avec le plus de marge.',
			'settings.quota.settings.routing.manual' => 'Manuel',
			'settings.quota.settings.routing.manualHint' => 'Afficher uniquement une recommandation ; ne jamais changer de compte automatiquement.',
			'settings.quota.settings.routing.ask' => 'Demander avant de changer',
			'settings.quota.settings.routing.askHint' => 'Un changement est proposé et attend votre approbation.',
			'settings.quota.settings.routing.autoLowRisk' => 'Auto pour les tâches à faible risque',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Seules les tâches marquées à faible risque peuvent être déplacées automatiquement.',
			'settings.quota.settings.routingNote' => 'Changer de compte modifie le coût et la qualité du modèle, donc cela requiert toujours une décision explicite.',
			'settings.quota.settings.accountsSection' => 'Comptes interrogés',
			'settings.quota.settings.accountsSectionHint' => 'Les identifiants sont lus depuis chaque outil ; le panneau ne les envoie nulle part ailleurs.',
			'settings.quota.settings.sourcesSection' => 'Sources de données',
			'settings.quota.settings.sourcesSectionHint' => 'D’où proviennent les chiffres d’utilisation et de coût.',
			'settings.quota.settings.logSources' => 'Magasin de journaux de tokens et coûts',
			'settings.quota.settings.logSourcesHint' => 'Magasin d’agrégats en lecture seule partagé avec le collecteur tokboard.',
			'settings.quota.settings.readOnly' => 'Lecture seule',
			'settings.quota.settings.quotaConsent' => 'Interrogation des quotas',
			'settings.quota.settings.quotaConsentHint' => 'Lit les points de terminaison de quota des fournisseurs avec les identifiants stockés localement.',
			'settings.quota.settings.localOnly' => 'Local uniquement',
			'settings.quota.empty.description' => 'Aucun compte détecté pour le moment.',
			'settings.quota.quality.cached' => 'en cache',
			'settings.quota.quality.error' => 'erreur',
			'settings.quota.quality.estimate' => 'estimation',
			'settings.quota.quality.live' => 'en direct',
			'settings.quota.quality.unknown' => 'inconnu',
			'settings.quota.syncFailed' => 'Échec de la synchronisation',
			'settings.quota.syncNow' => 'Synchroniser maintenant',
			'settings.browser.checking' => 'vérification...',
			'settings.browser.description' => 'Permet aux agents de créer des sessions de navigateur Playwright surveillées, visibles dans l’onglet Browser.',
			'settings.browser.enableDescription' => 'Enregistre Browser pour les agents pris en charge. Les agents peuvent créer des sessions de navigateur ; vous pouvez les regarder, les arrêter et les supprimer.',
			'settings.browser.enableLabel' => 'Activer Browser',
			'settings.browser.errors.installRuntime' => 'Échec de l’installation du runtime du navigateur',
			'settings.browser.errors.loadSettings' => 'Échec du chargement des paramètres Browser',
			'settings.browser.errors.loadStatus' => 'Échec du chargement du statut Browser',
			'settings.browser.errors.saveSettings' => 'Échec de l’enregistrement des paramètres Browser',
			'settings.browser.installHint' => 'Installez le runtime du navigateur avant que les agents puissent créer des sessions Browser.',
			'settings.browser.installRuntime' => 'Installer le runtime',
			'settings.browser.installed' => 'installé',
			'settings.browser.installing' => 'Installation...',
			'settings.browser.missing' => 'manquant',
			'settings.browser.runtimeRequired' => 'Runtime du navigateur requis',
			'settings.browser.statusDisabled' => 'désactivé',
			'settings.browser.statusLabel' => 'Statut',
			'settings.browser.statusReady' => 'prêt',
			'settings.browser.statusSetupRequired' => 'configuration requise',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Annuler',
			'settings.workspaces.create' => 'Ajouter un espace de travail',
			'settings.workspaces.deleteConfirm' => 'Retirer cet espace de travail de DDAgent ? Ses fichiers restent sur le disque.',
			'settings.workspaces.deleteFailed' => 'Échec de la suppression de l’espace de travail.',
			'settings.workspaces.deleteTitle' => 'Retirer l’espace de travail',
			'settings.workspaces.description' => 'Les espaces de travail sont des répertoires dans lesquels DDAgent peut discuter, exécuter du code et naviguer.',
			'settings.workspaces.remove' => 'Retirer l’espace de travail',
			'settings.workspaces.title' => 'Espaces de travail',
			'settings.workspaces.pathRequired' => 'Le chemin est requis',
			'settings.about.supportTitle' => 'Soutenir le projet',
			'settings.about.buyMeACoffee' => 'Offrez-moi un café',
			'settings.about.learnMore' => 'En savoir plus',
			'settings.about.pro.syncSettings' => 'Synchroniser les paramètres',
			'settings.about.pro.teamManagement' => 'Gestion d’équipe',
			'settings.about.proFeatures' => 'Fonctionnalités de DDAgent Pro',
			'settings.about.tryHosted' => 'Essayer DDAgent Hosted',
			'settings.about.versionInfo' => 'Informations de version',
			'settings.about.client' => 'Application',
			'settings.about.server' => 'Serveur',
			'settings.about.platformMobile' => 'Mobile',
			'settings.about.platformDesktop' => 'Bureau',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'inconnue',
			'sidebar.projects.title' => 'Projets',
			'sidebar.projects.newProject' => 'Nouveau projet',
			'sidebar.projects.deleteProject' => 'Supprimer le projet',
			'sidebar.projects.renameProject' => 'Renommer le projet',
			'sidebar.projects.noProjects' => 'Aucun projet trouvé',
			'sidebar.projects.loadingProjects' => 'Chargement des projets...',
			'sidebar.projects.searchPlaceholder' => 'Rechercher des projets...',
			'sidebar.projects.projectNamePlaceholder' => 'Nom du projet',
			'sidebar.projects.starred' => 'Favoris',
			'sidebar.projects.all' => 'Tous',
			'sidebar.projects.untitledSession' => 'Session sans titre',
			'sidebar.projects.newSession' => 'Nouvelle session',
			'sidebar.projects.codexSession' => 'Session Codex',
			'sidebar.projects.fetchingProjects' => 'Récupération de vos projets et sessions Claude',
			'sidebar.projects.projects' => 'projets',
			'sidebar.projects.noMatchingProjects' => 'Aucun projet correspondant',
			'sidebar.projects.tryDifferentSearch' => 'Essayez d\'ajuster votre terme de recherche',
			'sidebar.projects.runClaudeCli' => 'Exécutez le CLI Claude dans un répertoire de projet pour commencer',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'Interface d\'assistant de codage IA',
			'sidebar.sessions.title' => 'Sessions',
			'sidebar.sessions.newSession' => 'Nouvelle session',
			'sidebar.sessions.deleteSession' => 'Supprimer la session',
			'sidebar.sessions.renameSession' => 'Renommer la session',
			'sidebar.sessions.noSessions' => 'Aucune session pour l\'instant',
			'sidebar.sessions.loadingSessions' => 'Chargement des sessions...',
			'sidebar.sessions.unnamed' => 'Sans nom',
			'sidebar.sessions.loading' => 'Chargement...',
			'sidebar.sessions.showMore' => 'Afficher plus de sessions',
			'sidebar.sessions.selectMode' => 'Sélectionner',
			'sidebar.sessions.selectAll' => 'Tout sélectionner',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Archiver (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Supprimer (${count})',
			'sidebar.sessions.cancelSelection' => 'Annuler la sélection',
			'sidebar.sessions.toggleSelection' => 'Basculer la sélection de sessions',
			'sidebar.sessions.selectionToolbar' => 'Actions de sélection de sessions',
			'sidebar.sessions.options' => 'Options de session',
			'sidebar.sessions.pinSession' => 'Épingler la session',
			'sidebar.sessions.unpinSession' => 'Désépingler la session',
			'sidebar.sessions.pinned' => 'Session épinglée',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} sélectionnée', other: '${count} sélectionnées', ), 
			'sidebar.tooltips.viewEnvironments' => 'Voir les environnements',
			'sidebar.tooltips.hideSidebar' => 'Masquer la barre latérale',
			'sidebar.tooltips.createProject' => 'Créer un nouveau projet',
			'sidebar.tooltips.refresh' => 'Actualiser les projets et sessions (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Renommer le projet (F2)',
			'sidebar.tooltips.deleteProject' => 'Retirer le projet de la barre latérale (Suppr)',
			'sidebar.tooltips.addToFavorites' => 'Ajouter aux favoris',
			'sidebar.tooltips.removeFromFavorites' => 'Retirer des favoris',
			'sidebar.tooltips.editSessionName' => 'Modifier manuellement le nom de la session',
			'sidebar.tooltips.deleteSession' => 'Supprimer définitivement cette session',
			'sidebar.tooltips.activeSessionIndicator' => 'Session récemment active (10 dernières minutes)',
			'sidebar.tooltips.save' => 'Enregistrer',
			'sidebar.tooltips.cancel' => 'Annuler',
			'sidebar.tooltips.clearSearch' => 'Effacer la recherche',
			'sidebar.tooltips.openCommandPalette' => 'Ouvrir la palette de commandes',
			'sidebar.tooltips.attentionRequiredIndicator' => 'La session nécessite votre attention',
			'sidebar.tooltips.openSessions' => 'Parcourir les sessions',
			'sidebar.navigation.chat' => 'Discussion',
			'sidebar.navigation.files' => 'Fichiers',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminal',
			'sidebar.navigation.tasks' => 'Tâches',
			'sidebar.actions.refresh' => 'Actualiser',
			'sidebar.actions.settings' => 'Paramètres',
			'sidebar.actions.collapseAll' => 'Tout réduire',
			'sidebar.actions.expandAll' => 'Tout développer',
			'sidebar.actions.cancel' => 'Annuler',
			'sidebar.actions.save' => 'Enregistrer',
			'sidebar.actions.delete' => 'Supprimer',
			'sidebar.actions.rename' => 'Renommer',
			'sidebar.actions.joinCommunity' => 'Rejoindre la communauté',
			'sidebar.actions.reportIssue' => 'Signaler un problème',
			'sidebar.actions.starOnGithub' => 'Étoile sur GitHub',
			'sidebar.actions.buyMeACoffee' => 'Offrez-moi un café',
			'sidebar.branding.openSource' => 'Open Source',
			'sidebar.status.active' => 'Actif',
			'sidebar.status.inactive' => 'Inactif',
			'sidebar.status.thinking' => 'Réflexion...',
			'sidebar.status.error' => 'Erreur',
			'sidebar.status.aborted' => 'Annulé',
			'sidebar.status.unknown' => 'Inconnu',
			'sidebar.time.justNow' => 'À l\'instant',
			'sidebar.time.oneMinuteAgo' => 'Il y a 1 min',
			'sidebar.time.minutesAgo' => ({required Object count}) => 'Il y a ${count} min',
			'sidebar.time.oneHourAgo' => 'Il y a 1 heure',
			'sidebar.time.hoursAgo' => ({required Object count}) => 'Il y a ${count} heures',
			'sidebar.time.oneDayAgo' => 'Il y a 1 jour',
			'sidebar.time.daysAgo' => ({required Object count}) => 'Il y a ${count} jours',
			'sidebar.messages.deleteConfirm' => 'Êtes-vous sûr de vouloir supprimer ceci ?',
			'sidebar.messages.renameSuccess' => 'Renommé avec succès',
			'sidebar.messages.deleteSuccess' => 'Supprimé avec succès',
			'sidebar.messages.errorOccurred' => 'Une erreur s\'est produite',
			'sidebar.messages.deleteSessionConfirm' => 'Êtes-vous sûr de vouloir supprimer cette session ? Cette action est irréversible.',
			'sidebar.messages.deleteProjectConfirm' => 'Retirer ce projet de la barre latérale ? Vos fichiers, mémoires et données de session ne seront pas supprimés.',
			'sidebar.messages.enterProjectPath' => 'Veuillez entrer un chemin de projet',
			'sidebar.messages.deleteSessionFailed' => 'Échec de la suppression de la session. Veuillez réessayer.',
			'sidebar.messages.deleteSessionError' => 'Erreur lors de la suppression de la session. Veuillez réessayer.',
			'sidebar.messages.renameSessionFailed' => 'Échec du renommage de la session. Veuillez réessayer.',
			'sidebar.messages.renameSessionError' => 'Erreur lors du renommage de la session. Veuillez réessayer.',
			'sidebar.messages.deleteProjectFailed' => 'Échec de la suppression du projet. Veuillez réessayer.',
			'sidebar.messages.deleteProjectError' => 'Erreur lors de la suppression du projet. Veuillez réessayer.',
			'sidebar.messages.createProjectFailed' => 'Échec de la création du projet. Veuillez réessayer.',
			'sidebar.messages.createProjectError' => 'Erreur lors de la création du projet. Veuillez réessayer.',
			'sidebar.messages.updateProjectError' => 'Erreur lors de la mise à jour du projet. Veuillez réessayer.',
			'sidebar.messages.refreshError' => 'Échec de l\'actualisation. Veuillez réessayer.',
			'sidebar.messages.restoreProjectFailed' => 'Échec de la restauration du projet. Veuillez réessayer.',
			'sidebar.messages.restoreProjectError' => 'Erreur lors de la restauration du projet. Veuillez réessayer.',
			'sidebar.messages.restoreSessionFailed' => 'Échec de la restauration de la session. Veuillez réessayer.',
			'sidebar.messages.restoreSessionError' => 'Erreur lors de la restauration de la session. Veuillez réessayer.',
			'sidebar.messages.changeWorkspaceFailed' => 'Échec du changement d’espace de travail. Veuillez réessayer.',
			'sidebar.messages.changeWorkspaceError' => 'Erreur lors du changement d’espace de travail. Veuillez réessayer.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Échec de la suppression de ${count} session. Veuillez réessayer.', other: 'Échec de la suppression de ${count} sessions. Veuillez réessayer.', ), 
			'sidebar.version.updateAvailable' => 'Mise à jour disponible',
			'sidebar.version.restartRequired' => 'Mise à jour installée — redémarrez le serveur pour l\'appliquer',
			'sidebar.version.updateNow' => 'Mettre à jour',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Mettre à jour DDAgent vers v${version} ? Le dernier code sera récupéré et compilé, puis le serveur redémarrera — les sessions actives seront interrompues.',
			'sidebar.version.updating' => 'Mise à jour… cela peut prendre quelques minutes',
			'sidebar.version.restarting' => 'Mise à jour installée — redémarrage…',
			'sidebar.version.updateFailed' => 'Échec de la mise à jour',
			'sidebar.version.releaseNotes' => 'Notes de version',
			'sidebar.search.modeProjects' => 'Projets',
			'sidebar.search.modeConversations' => 'Conversations',
			'sidebar.search.conversationsPlaceholder' => 'Rechercher dans les conversations...',
			'sidebar.search.searching' => 'Recherche en cours...',
			'sidebar.search.sessionTitles' => 'Titres des sessions',
			'sidebar.search.conversationContents' => 'Contenu des conversations',
			'sidebar.search.noResults' => 'Aucun résultat trouvé',
			'sidebar.search.tryDifferentQuery' => 'Essayez une autre requête de recherche',
			'sidebar.search.modeRunning' => 'En cours',
			'sidebar.search.archiveOnly' => 'Archives',
			'sidebar.search.runningTooltip' => 'Sessions en cours',
			'sidebar.search.archiveOnlyTooltip' => 'Archives uniquement',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} actives',
			'sidebar.search.viewMenu' => 'Affichage',
			'sidebar.search.backToProjects' => 'Retour aux projets',
			'sidebar.search.archivedPlaceholder' => 'Rechercher dans les archives...',
			'sidebar.search.runningPlaceholder' => 'Rechercher les sessions en cours...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} résultat', other: '${count} résultats', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} projet analysé', other: '${count} projets analysés', ), 
			'sidebar.deleteConfirmation.deleteProject' => 'Supprimer le projet',
			'sidebar.deleteConfirmation.deleteSession' => 'Supprimer la session',
			'sidebar.deleteConfirmation.confirmDelete' => 'Que souhaitez-vous faire avec',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Retirer de la barre latérale uniquement',
			'sidebar.deleteConfirmation.deleteAllData' => 'Supprimer toutes les données définitivement',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'Le projet sera retiré de la barre latérale. Vos fichiers, mémoires et données de session seront conservés.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Vous pourrez rajouter le projet ultérieurement.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'L’archivage masque les sessions sélectionnées de la liste active tout en préservant leurs historiques.',
			'sidebar.deleteConfirmation.archiveSession' => 'Archiver la session',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'L’archivage retire la session de la liste active tout en préservant son historique.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Cette session est déjà archivée. Vous pouvez la garder masquée ou la supprimer définitivement.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'Cela supprime définitivement la session et sa transcription. Cette action est irréversible.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Supprimer définitivement',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Ce projet contient ${count} conversation.', other: 'Ce projet contient ${count} conversations.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Gérer la session sélectionnée', other: 'Gérer ${count} sessions sélectionnées', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Archiver la session', other: 'Archiver ${count} sessions', ), 
			'sidebar.zones.activeNow' => 'Actifs maintenant',
			'sidebar.zones.recent' => 'Récemment utilisés',
			'sidebar.zones.today' => 'Aujourd\'hui',
			'sidebar.zones.yesterday' => 'Hier',
			'sidebar.zones.thisWeek' => 'Cette semaine',
			'sidebar.zones.showMore' => ({required Object count}) => 'Afficher ${count} de plus',
			'sidebar.zones.showLess' => 'Afficher moins',
			'sidebar.panel.open' => 'Panneau',
			'sidebar.panel.newChat' => 'Nouvelle discussion',
			'sidebar.panel.navigation' => 'Navigation',
			'sidebar.panel.sessions' => 'Sessions',
			'sidebar.workspace.title' => 'Changer l’espace de travail de la session',
			'sidebar.workspace.description' => 'L’agent exécute ses prochaines étapes dans ce répertoire. L’historique de session existant est préservé.',
			'sidebar.workspace.pathLabel' => 'Chemin de l’espace de travail',
			'sidebar.workspace.pathRequired' => 'Le chemin de l’espace de travail est requis.',
			'sidebar.workspace.submit' => 'Changer d’espace de travail',
			'sidebar.workspace.saving' => 'Changement…',
			'sidebar.workspace.changeAction' => 'Changer d’espace de travail',
			'sidebar.recent.title' => 'Conversations récentes',
			'sidebar.recent.emptyTitle' => 'Aucune conversation pour le moment',
			'sidebar.recent.emptyDescription' => 'Vos conversations les plus récemment mises à jour apparaîtront ici.',
			'sidebar.recent.loadFailed' => 'Impossible de charger les conversations récentes',
			'sidebar.recent.loadMore' => 'Charger des conversations plus anciennes',
			'sidebar.recent.loadingMore' => 'Chargement...',
			'sidebar.tabs.board' => 'Tableau des agents',
			'sidebar.tabs.files' => 'Fichiers',
			'sidebar.tabs.git' => 'Contrôle de source',
			'sidebar.tabs.tasks' => 'Tâches',
			'sidebar.tabs.usage' => 'Quota et utilisation',
			'tasks.notConfigured.title' => 'TaskMaster AI n\'est pas configuré',
			'tasks.notConfigured.description' => 'TaskMaster aide à décomposer des projets complexes en tâches gérables avec une assistance IA',
			'tasks.notConfigured.whatIsTitle' => '🎯 Qu\'est-ce que TaskMaster ?',
			'tasks.notConfigured.features.aiPowered' => 'Gestion des tâches assistée par IA : Décomposez des projets complexes en sous-tâches gérables',
			'tasks.notConfigured.features.prdTemplates' => 'Modèles PRD : Générez des tâches à partir de documents d\'exigences produit',
			'tasks.notConfigured.features.dependencyTracking' => 'Suivi des dépendances : Comprenez les relations entre tâches et l\'ordre d\'exécution',
			'tasks.notConfigured.features.progressVisualization' => 'Visualisation de l\'avancement : Tableaux Kanban et analyses détaillées des tâches',
			'tasks.notConfigured.features.cliIntegration' => 'Intégration CLI : Utilisez les commandes taskmaster pour des flux de travail avancés',
			'tasks.notConfigured.initializeButton' => 'Initialiser TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => 'Rédigez d’abord un PRD',
			'tasks.gettingStarted.title' => 'Démarrer avec TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster est initialisé ! Voici la suite :',
			'tasks.gettingStarted.steps.createPRD.title' => 'Créer un document d\'exigences produit (PRD)',
			'tasks.gettingStarted.steps.createPRD.description' => 'Discutez de votre idée de projet et créez un PRD décrivant ce que vous voulez construire.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'Ajouter un PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'PRDs existants :',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Générer des tâches à partir du PRD',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Une fois votre PRD prêt, demandez à votre assistant IA de l\'analyser et TaskMaster le décomposera automatiquement en tâches gérables avec des détails d\'implémentation.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Analyser et développer les tâches',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Demandez à votre assistant IA d\'analyser la complexité des tâches et de les développer en sous-tâches détaillées pour une implémentation plus facile.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Commencer à construire',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Demandez à votre assistant IA de commencer à travailler sur les tâches, mettre à jour leur statut et ajouter de nouvelles tâches au fur et à mesure.',
			'tasks.gettingStarted.tip' => '💡 Astuce : Commencez par un PRD pour tirer le meilleur parti de la génération de tâches IA de TaskMaster',
			'tasks.setupModal.title' => 'Configuration TaskMaster',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'CLI interactif pour ${projectName}',
			'tasks.setupModal.willStart' => 'L\'initialisation de TaskMaster démarrera automatiquement',
			'tasks.setupModal.completed' => 'Configuration TaskMaster terminée ! Vous pouvez fermer cette fenêtre.',
			'tasks.setupModal.closeButton' => 'Fermer',
			'tasks.setupModal.closeContinueButton' => 'Fermer et continuer',
			'tasks.setupModal.closeTitle' => 'Fermer',
			'tasks.setupModal.description' => 'Crée un dossier .taskmaster dans ce projet. Aucun outil externe ni clé API requis — les tâches sont stockées localement.',
			'tasks.setupModal.initializeButton' => 'Initialiser',
			'tasks.setupModal.initializing' => 'Initialisation...',
			'tasks.helpGuide.title' => 'Démarrer avec TaskMaster',
			'tasks.helpGuide.subtitle' => 'Votre guide pour une gestion productive des tâches',
			'tasks.helpGuide.examples.parsePRD' => '💬 Exemple :\n« Je viens d\'initialiser un nouveau projet avec Claude Task Master. J\'ai un PRD dans .taskmaster/docs/prd.txt. Pouvez-vous m\'aider à l\'analyser et configurer les tâches initiales ? »',
			'tasks.helpGuide.examples.expandTask' => '💬 Exemple :\n« La tâche 5 semble complexe. Pouvez-vous la décomposer en sous-tâches ? »',
			'tasks.helpGuide.examples.addTask' => '💬 Exemple :\n« Veuillez ajouter une nouvelle tâche pour implémenter le téléchargement d\'images de profil utilisateur avec Cloudinary, recherchez la meilleure approche. »',
			'tasks.helpGuide.moreExamples' => 'Voir plus d\'exemples et de patterns d\'utilisation →',
			'tasks.helpGuide.proTips.title' => '💡 Conseils pro',
			'tasks.helpGuide.proTips.search' => 'Utilisez la barre de recherche pour trouver rapidement des tâches spécifiques',
			'tasks.helpGuide.proTips.views' => 'Basculez entre les vues Kanban, Liste et Grille via les boutons de vue',
			'tasks.helpGuide.proTips.filters' => 'Utilisez les filtres pour vous concentrer sur des statuts ou priorités de tâches spécifiques',
			'tasks.helpGuide.proTips.details' => 'Cliquez sur une tâche pour voir les détails et gérer les sous-tâches',
			'tasks.helpGuide.learnMore.title' => '📚 En savoir plus',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI est un système avancé de gestion des tâches conçu pour les développeurs. Documentation, exemples et contributions au projet.',
			'tasks.helpGuide.learnMore.githubButton' => 'Voir sur GitHub',
			'tasks.helpGuide.closeTitle' => 'Fermer',
			'tasks.search.placeholder' => 'Rechercher des tâches...',
			'tasks.filters.button' => 'Filtres',
			'tasks.filters.status' => 'Statut',
			'tasks.filters.priority' => 'Priorité',
			'tasks.filters.sortBy' => 'Trier par',
			'tasks.filters.allStatuses' => 'Tous les statuts',
			'tasks.filters.allPriorities' => 'Toutes les priorités',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => 'Affichage de ${filtered} sur ${total} tâches',
			'tasks.filters.clearFilters' => 'Effacer les filtres',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Statut',
			'tasks.sort.priority' => 'Priorité',
			'tasks.sort.idAsc' => 'ID (croissant)',
			'tasks.sort.idDesc' => 'ID (décroissant)',
			'tasks.sort.titleAsc' => 'Titre (A-Z)',
			'tasks.sort.titleDesc' => 'Titre (Z-A)',
			'tasks.sort.statusAsc' => 'Statut (en attente en premier)',
			'tasks.sort.statusDesc' => 'Statut (terminé en premier)',
			'tasks.sort.priorityAsc' => 'Priorité (haute en premier)',
			'tasks.sort.priorityDesc' => 'Priorité (basse en premier)',
			'tasks.views.kanban' => 'Vue Kanban',
			'tasks.views.list' => 'Vue liste',
			'tasks.views.grid' => 'Vue grille',
			'tasks.kanban.pending' => '📋 À faire',
			'tasks.kanban.inProgress' => '🚀 En cours',
			'tasks.kanban.review' => '👀 Révision',
			'tasks.kanban.done' => '✅ Terminé',
			'tasks.kanban.blocked' => '🚫 Bloqué',
			'tasks.kanban.deferred' => '⏳ Différé',
			'tasks.kanban.cancelled' => '❌ Annulé',
			'tasks.kanban.noTasksYet' => 'Aucune tâche pour l\'instant',
			'tasks.kanban.tasksWillAppear' => 'Les tâches apparaîtront ici',
			'tasks.kanban.moveTasksHere' => 'Déplacez les tâches ici au démarrage',
			'tasks.kanban.completedTasksHere' => 'Les tâches terminées apparaissent ici',
			'tasks.kanban.statusTasksHere' => 'Les tâches avec ce statut apparaîtront ici',
			'tasks.buttons.help' => 'Guide de démarrage TaskMaster',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => 'Ajouter un PRD',
			'tasks.buttons.addTask' => 'Ajouter une tâche',
			'tasks.buttons.createNewPRD' => 'Créer un nouveau PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} PRD(s) disponible(s)',
			'tasks.prd.modified' => ({required Object date}) => 'Modifié : ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'Un PRD nommé « ${name} » existe déjà. Voulez-vous le remplacer ?',
			'tasks.prd.fileExistsTitle' => 'Le fichier existe déjà',
			'tasks.prd.newFile' => 'nouveau fichier',
			'tasks.prd.parse' => 'Analyser le PRD',
			'tasks.prd.template' => 'Modèle',
			'tasks.prd.fileNameHint' => 'nom de fichier (ex. : prd.txt)',
			'tasks.prd.saved' => 'PRD enregistré',
			'tasks.prd.tasksGenerated' => 'Tâches générées à partir du PRD',
			'tasks.statuses.pending' => 'En attente',
			'tasks.statuses.inProgress' => 'En cours',
			'tasks.statuses.done' => 'Terminé',
			'tasks.statuses.blocked' => 'Bloqué',
			'tasks.statuses.deferred' => 'Différé',
			'tasks.statuses.cancelled' => 'Annulé',
			'tasks.statuses.review' => 'Révision',
			'tasks.priorities.high' => 'Haute',
			'tasks.priorities.medium' => 'Moyenne',
			'tasks.priorities.low' => 'Basse',
			'tasks.noMatchingTasks.title' => 'Aucune tâche ne correspond à vos filtres',
			'tasks.noMatchingTasks.description' => 'Essayez d\'ajuster votre recherche ou vos critères de filtre.',
			'tasks.board.title' => 'Tableau d’agents',
			'tasks.board.subtitle' => 'Déplacez une carte vers Prêt et l’agent la prend en charge. Cliquez sur une carte pour ouvrir sa session.',
			'tasks.board.newCard' => 'Nouvelle carte',
			'tasks.board.addCard' => 'Ajouter une carte',
			'tasks.board.refresh' => 'Actualiser',
			'tasks.board.empty.title' => 'Aucune carte pour le moment',
			'tasks.board.empty.description' => 'Ajoutez une carte, décrivez la tâche, puis faites-la glisser vers Prêt pour qu’un agent commence à travailler.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Prêt à démarrer',
			'tasks.board.columns.working' => 'En cours',
			'tasks.board.columns.needsDecision' => 'Nécessite votre décision',
			'tasks.board.columns.done' => 'Terminé',
			'tasks.board.columns.archived' => 'Archivées',
			'tasks.board.card.running' => 'En cours',
			'tasks.board.card.abort' => 'Abandonner',
			'tasks.board.card.delete' => 'Supprimer',
			'tasks.board.card.openSession' => 'Ouvrir la session',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.dialog.createTitle' => 'Nouvelle carte',
			'tasks.board.dialog.editTitle' => 'Modifier la carte',
			'tasks.board.dialog.titleLabel' => 'Titre',
			'tasks.board.dialog.titlePlaceholder' => 'Que doit faire l’agent ?',
			'tasks.board.dialog.descriptionLabel' => 'Description',
			'tasks.board.dialog.descriptionPlaceholder' => 'Ajouter du contexte, des critères d’acceptation, des liens...',
			'tasks.board.dialog.cancel' => 'Annuler',
			'tasks.board.dialog.save' => 'Enregistrer',
			'tasks.board.noProject' => 'Ajoutez d’abord un projet, puis créez des cartes pour celui-ci.',
			'tasks.board.projectLabel' => 'Projet',
			'tasks.board.backToChat' => 'Retour à la discussion',
			'tasks.board.agent.provider' => 'Agent',
			'tasks.board.agent.anyProvider' => 'N’importe quel agent',
			'tasks.board.agent.model' => 'Modèle',
			'tasks.board.agent.defaultModel' => 'Modèle par défaut',
			'tasks.board.agent.effort' => 'Raisonnement',
			'tasks.board.agent.defaultEffort' => 'Par défaut',
			'tasks.board.agent.searchModel' => 'Rechercher des modèles…',
			'tasks.board.agent.noModels' => 'Aucun modèle correspondant',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '« ${cardTitle} » sera définitivement supprimée.',
			'tasks.board.deleteConfirm.title' => 'Supprimer la carte ?',
			'tasks.board.project' => 'Projet',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Dépend de : ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Tâche ${id}',
			'tasks.card.highPriority' => 'Priorité haute',
			'tasks.card.lowPriority' => 'Priorité basse',
			'tasks.card.mediumPriority' => 'Priorité moyenne',
			'tasks.card.noPriority' => 'Aucune priorité définie',
			'tasks.card.parentTask' => ({required Object id}) => 'Tâche ${id}',
			'tasks.card.progressLabel' => 'Progression :',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => '${completed} sous-tâches sur ${total} terminées',
			'tasks.card.runTask' => 'Exécuter la tâche',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Exécuter la tâche ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Statut : ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'ID de tâche : ${id}',
			'tasks.card.taskInProgress' => 'Tâche en cours',
			'tasks.createTask.cancel' => 'Annuler',
			'tasks.createTask.descriptionLabel' => 'Description',
			'tasks.createTask.descriptionPlaceholder' => 'Détails optionnels',
			'tasks.createTask.error' => 'Échec de l’ajout de la tâche',
			'tasks.createTask.priorityLabel' => 'Priorité',
			'tasks.createTask.submit' => 'Ajouter la tâche',
			'tasks.createTask.submitting' => 'Ajout...',
			'tasks.createTask.title' => 'Ajouter une tâche',
			'tasks.createTask.titleLabel' => 'Titre',
			'tasks.createTask.titlePlaceholder' => 'Que faut-il faire ?',
			'tasks.list.completedReopen' => 'Terminée (cliquer pour rouvrir)',
			'tasks.list.inProgressComplete' => 'En cours (cliquer pour terminer)',
			'tasks.list.markCompleted' => 'Marquer comme terminée',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Basculer le statut de la tâche ${id}',
			'tasks.list.markDone' => 'Marquer comme terminé',
			'tasks.list.reopen' => 'Rouvrir',
			'tasks.nextTask.allComplete' => 'Toutes les tâches sont terminées',
			'tasks.nextTask.feature1' => '- Gestion des tâches par IA avec dépendances et sous-tâches.',
			'tasks.nextTask.feature2' => '- Génération de tâches à partir de PRD pour un démarrage rapide.',
			'tasks.nextTask.feature3' => '- Vues kanban et liste pour l’exécution quotidienne.',
			'tasks.nextTask.hideDetails' => 'Masquer les détails',
			'tasks.nextTask.initialize' => 'Initialiser',
			'tasks.nextTask.noPending' => 'Aucune tâche en attente',
			_ => null,
		} ?? switch (path) {
			'tasks.nextTask.notConfigured' => 'TaskMaster AI n’est pas configuré',
			'tasks.nextTask.review' => 'Vérifier',
			'tasks.nextTask.startTask' => 'Démarrer la tâche',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Tâche ${id}',
			'tasks.nextTask.viewAll' => 'Voir toutes les tâches',
			'tasks.nextTask.viewDetails' => 'Voir les détails de la tâche',
			'tasks.nextTask.whatIs' => 'Qu’est-ce que TaskMaster ?',
			'tasks.taskDetail.cancelEdit' => 'Annuler la modification',
			'tasks.taskDetail.close' => 'Fermer',
			'tasks.taskDetail.copyTaskId' => 'Copier l’ID de la tâche',
			'tasks.taskDetail.delete' => 'Supprimer la tâche',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '« ${title} » sera définitivement supprimée.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Supprimer la tâche ?',
			'tasks.taskDetail.deleteFailed' => 'Échec de la suppression de la tâche',
			'tasks.taskDetail.dependencies' => 'Dépendances',
			'tasks.taskDetail.dependenciesPlaceholder' => 'ex. 1, 2, 3',
			'tasks.taskDetail.description' => 'Description',
			'tasks.taskDetail.edit' => 'Modifier la tâche',
			'tasks.taskDetail.implDetails' => 'Détails d’implémentation',
			'tasks.taskDetail.noDependencies' => 'Aucune dépendance',
			'tasks.taskDetail.noDescription' => 'Aucune description fournie',
			'tasks.taskDetail.priority' => 'Priorité',
			'tasks.taskDetail.priorityNotSet' => 'Non définie',
			'tasks.taskDetail.save' => 'Enregistrer',
			'tasks.taskDetail.status' => 'Statut',
			'tasks.taskDetail.statusFailed' => 'Échec de la mise à jour du statut de la tâche',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Tâche ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Tâche ${id} : ${title}',
			'tasks.taskDetail.testStrategy' => 'Stratégie de test',
			'tasks.taskDetail.titleRequired' => 'Le titre est requis',
			'tasks.taskDetail.updateFailed' => 'Échec de la mise à jour de la tâche',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'La tâche #${id} sera supprimée. Cette action est irréversible.',
			'tasks.taskDetail.notFound' => 'Tâche introuvable',
			'tasks.taskDetail.subtasks' => 'Sous-tâches',
			'tasks.taskDetail.idCopied' => 'ID de la tâche copié',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Tâche ${id} définie comme en cours',
			'knowledge.title' => 'Connaissances',
			'knowledge.tabs.dashboard' => 'Tableau',
			'knowledge.tabs.memories' => 'Souvenirs',
			'knowledge.tabs.rules' => 'Règles',
			'knowledge.tabs.skills' => 'Compétences',
			'knowledge.tabs.personal' => 'Personnel',
			'knowledge.tabs.graph' => 'Graphe',
			'knowledge.common.add' => 'Ajouter',
			'knowledge.common.save' => 'Enregistrer',
			'knowledge.common.cancel' => 'Annuler',
			'knowledge.common.delete' => 'Supprimer',
			'knowledge.common.edit' => 'Modifier',
			'knowledge.common.close' => 'Fermer',
			'knowledge.common.restore' => 'Restaurer',
			'knowledge.common.refresh' => 'Actualiser',
			'knowledge.common.allProjects' => 'Tous les projets',
			'knowledge.common.global' => 'Global',
			'knowledge.actions.scan' => 'Analyser les fichiers du projet',
			'knowledge.actions.export' => 'Exporter JSON',
			'knowledge.actions.import' => 'Importer JSON',
			'knowledge.actions.scanComplete' => 'Analyse terminée',
			'knowledge.actions.importComplete' => 'Import terminé',
			'knowledge.actions.importFailed' => 'Échec de l\'import',
			'knowledge.dialog.newEntity' => 'Nouvelle entrée',
			'knowledge.dialog.editEntity' => 'Modifier l\'entrée',
			'knowledge.dialog.deleteTitle' => 'Supprimer',
			'knowledge.dialog.deleteMessage' => 'Supprimer cette entrée ? Action irréversible (l\'historique est conservé).',
			'knowledge.dialog.pickIcon' => 'Choisir une icône',
			'knowledge.dialog.removeIcon' => 'Retirer l\'icône',
			'knowledge.dialog.iconTooLarge' => 'L\'icône est trop volumineuse (max 40 Ko).',
			'knowledge.dialog.importTitle' => 'Importer des connaissances',
			'knowledge.dialog.importHint' => 'Collez ici le JSON exporté',
			'knowledge.dialog.exportTitle' => 'Exporter les connaissances',
			'knowledge.dialog.import' => 'Importer',
			'knowledge.fields.key' => 'Clé',
			'knowledge.fields.title' => 'Titre',
			'knowledge.fields.name' => 'Nom',
			'knowledge.fields.description' => 'Description',
			'knowledge.fields.category' => 'Catégorie',
			'knowledge.fields.content' => 'Contenu',
			'knowledge.fields.priority' => 'Priorité',
			'knowledge.fields.tags' => 'Étiquettes',
			'knowledge.fields.enabled' => 'Activé',
			'knowledge.fields.projectScope' => 'Portée du projet',
			'knowledge.fields.tagsHint' => 'séparées par des virgules',
			'knowledge.dashboard.memories' => 'Souvenirs',
			'knowledge.dashboard.rules' => 'Règles',
			'knowledge.dashboard.skills' => 'Compétences',
			'knowledge.dashboard.personal' => 'Personnel',
			'knowledge.dashboard.connections' => 'Connexions',
			'knowledge.dashboard.recent' => 'Souvenirs récents',
			'knowledge.dashboard.noMemories' => 'Aucun souvenir. Ajoutez-en un dans l’onglet Souvenirs.',
			'knowledge.empty.memories' => 'Aucun souvenir.',
			'knowledge.empty.rules' => 'Aucune règle.',
			'knowledge.empty.skills' => 'Aucune compétence.',
			'knowledge.empty.personal' => 'Aucune information personnelle.',
			'knowledge.empty.graph' => 'Aucune entité à afficher.',
			'knowledge.history.title' => 'Historique',
			'knowledge.history.none' => 'Aucun historique.',
			'knowledge.history.untitled' => '(sans titre)',
			'knowledge.priorities.critical' => 'Critique',
			'knowledge.priorities.high' => 'Haute',
			'knowledge.priorities.normal' => 'Normale',
			'knowledge.priorities.low' => 'Basse',
			'knowledge.search.title' => 'Rechercher dans les connaissances',
			'knowledge.search.hint' => 'Rechercher souvenirs, règles, compétences…',
			'knowledge.search.noResults' => 'Aucun résultat.',
			'knowledge.links.title' => 'Lier des entités',
			'knowledge.links.source' => 'Source',
			'knowledge.links.target' => 'Cible',
			'knowledge.links.relationship' => 'Relation',
			'knowledge.links.add' => 'Créer un lien',
			'knowledge.tags.all' => 'Toutes les étiquettes',
			'knowledge.tags.manage' => 'Gérer les étiquettes',
			'knowledge.tags.none' => 'Aucune étiquette.',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.critical.make' => 'Marquer comme critique',
			'knowledge.critical.makeAll' => 'Marquer toutes les règles comme critiques',
			'knowledge.critical.makeAllHint' => 'Les ajoute au budget de contexte injecté',
			'knowledge.errors.importFailed' => ({required Object error}) => 'Échec de l’import : ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Échec de la migration : ${error}',
			'knowledge.graph.truncated' => 'tronqué',
			'knowledge.importAll.action' => 'Tout importer',
			'knowledge.importAll.mergeDuplicates' => 'Fusionner les entrées en double',
			'knowledge.importAll.mergeDuplicatesHint' => 'Regroupe les lignes en double dans DDAgent (pas les fichiers)',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Projets analysés : ${count}',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Règles : ${total} · groupes de doublons : ${duplicates}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Compétences d’agent trouvées : ${found} (nouvelles : ${newSkills})',
			'knowledge.importAll.title' => 'Tout importer dans DDAgent',
			'knowledge.importSkills.found' => ({required Object count}) => '${count} compétence(s) trouvée(s) dans vos agents.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Nouvelles : ${imported} · ignorées : ${skipped}',
			'knowledge.importSkills.title' => 'Importer les compétences d’agent',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Souvenir : ${title}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Personnel : ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Règle : ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Compétence : ${name}',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Groupes de doublons entre projets : ${count}',
			'knowledge.migrate.mergeDuplicates' => 'Fusionner les doublons',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Supprimés : ${removed}, promus : ${promoted}',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Règles : ${total} au total, ${critical} critiques.',
			'knowledge.migrate.scanned' => ({required Object count}) => '${count} projet(s) analysé(s).',
			'knowledge.migrate.title' => 'Migrer les règles existantes',
			'skills.addDialog.chooseFileTitle' => 'Choisir SKILL.md',
			'skills.addDialog.chooseFiles' => 'Choisir des fichiers',
			'skills.addDialog.chooseFolder' => 'Choisir un dossier',
			'skills.addDialog.chooseFolderTitle' => 'Choisir un dossier de compétences',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} fichier · ${size}', other: '${count} fichiers · ${size}', ), 
			'skills.addDialog.folderUploadsNote' => 'Les téléversements de dossiers conservent le nom du dossier sélectionné ; les fichiers isolés utilisent le `name` de `SKILL.md`.',
			'skills.addDialog.hideInstallLocation' => 'Masquer l’emplacement d’installation',
			'skills.addDialog.installSkill' => 'Installer la compétence',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Installer ${count} compétence', other: 'Installer ${count} compétences', ), 
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Fichier Markdown · ${size}',
			'skills.addDialog.pickHint' => 'Les dossiers peuvent inclure des scripts, des références et des ressources.',
			'skills.addDialog.pickTitle' => 'Choisissez un dossier de compétences ou un SKILL.md',
			'skills.addDialog.readyToInstall' => 'Prêt à installer',
			'skills.addDialog.removeQueued' => ({required Object name}) => 'Retirer ${name}',
			'skills.addDialog.title' => ({required Object provider}) => 'Ajouter une compétence ${provider}',
			'skills.addDialog.uploadHint' => 'Téléversez un fichier SKILL.md ou un dossier de compétences complet.',
			'skills.addDialog.whereWillThisInstall' => 'Où cela sera-t-il installé ?',
			'skills.deleteSkill' => ({required Object name}) => 'Supprimer ${name}',
			'skills.empty.noGlobalSkills' => 'Aucune compétence globale détectée pour l’instant',
			'skills.empty.noGlobalSkillsDescription' => 'Ajoutez une compétence globale ci-dessus pour la rendre disponible dans tous les projets.',
			'skills.empty.noMatchingSkills' => 'Aucune compétence correspondante',
			'skills.empty.noMatchingSkillsDescription' => 'Essayez une autre commande, un autre nom, une autre portée, un autre projet ou un autre chemin source.',
			'skills.empty.noProjects' => 'Aucun projet disponible',
			'skills.empty.noProjectsDescription' => 'Ajoutez un projet ou un espace de travail pour parcourir ses compétences.',
			'skills.empty.noSkillsInProject' => 'Aucune compétence dans ce projet',
			'skills.empty.noSkillsInProjectDescription' => 'Créez un dossier .claude/skills, .cursor/skills ou .agents/skills dans le projet sélectionné.',
			'skills.errors.addMarkdownFirst' => 'Ajoutez d’abord un ou plusieurs fichiers markdown.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'Impossible de lire SKILL.md depuis ${name}.',
			'skills.errors.dropMarkdownOrFolder' => 'Déposez un ou plusieurs fichiers markdown ou un dossier contenant SKILL.md.',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Un dossier de compétences peut contenir jusqu’à ${count} fichiers.',
			'skills.errors.folderReadFailed' => 'Échec de la lecture du dossier de compétences',
			'skills.errors.folderSizeLimit' => 'Les dossiers de compétences sélectionnés doivent totaliser moins de 30 Mo.',
			'skills.errors.importFailed' => 'Échec de l’import des compétences',
			'skills.errors.missingSkillFile' => 'Le dossier sélectionné ne contient pas de fichier SKILL.md.',
			'skills.moveDialog.moveToGlobal' => 'Déplacer vers global',
			'skills.moveDialog.moveToProject' => 'Déplacer vers le projet',
			'skills.moveDialog.toGlobalHint' => 'Déplacez cette compétence dans le répertoire de compétences global pour que tous les projets puissent l’utiliser.',
			'skills.moveDialog.toProjectHint' => 'Choisissez le projet auquel cette compétence doit appartenir. Elle quitte le répertoire de compétences global du fournisseur.',
			'skills.moveSkill' => ({required Object name}) => 'Déplacer ${name}',
			'skills.projectLabel' => 'Projet',
			'skills.scopes.admin' => 'Admin',
			'skills.scopes.plugin' => 'Plugin',
			'skills.scopes.project' => 'Projet',
			'skills.scopes.repo' => 'Repo',
			'skills.scopes.system' => 'Système',
			'skills.scopes.user' => 'Utilisateur',
			'skills.screen.addSkill' => 'Ajouter une compétence',
			'skills.screen.clearSearch' => 'Effacer la recherche de compétences',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Cela supprime le répertoire ${directory} du répertoire de compétences géré par ${provider}. Cette action est irréversible.',
			'skills.screen.deleteTitle' => ({required Object name}) => 'Supprimer ${name} ?',
			'skills.screen.loadingSkills' => ({required Object provider}) => 'Chargement des compétences de ${provider}…',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Gérez les compétences de ${provider} à partir de fichiers locaux, de dossiers complets et d’emplacements liés au projet.',
			'skills.screen.noDescription' => 'Aucune description fournie dans le front matter de la compétence.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Plugin : ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Projet : ${name}',
			'skills.screen.savedSuccessfully' => 'Compétences enregistrées avec succès.',
			'skills.screen.scanningProjectSkills' => 'Analyse des compétences du projet...',
			'skills.screen.searchHint' => 'Rechercher des compétences...',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} COMPÉTENCE', other: '${count} COMPÉTENCES', ), 
			'skills.screen.sourceLabel' => 'SOURCE',
			'mcp.form.fields.bearerTokenEnvVar' => 'Variable d’environnement du token Bearer',
			'mcp.form.fields.envVarNames' => 'Noms des variables d’environnement',
			'mcp.form.fields.workingDirectory' => 'Répertoire de travail',
			'mcp.form.scope.claudeLocal' => 'Claude local',
			'mcp.form.scope.description.local' => 'Stocké dans les paramètres utilisateur de Claude pour le projet sélectionné',
			'mcp.form.scope.description.project' => 'Stocké dans l’espace de travail du projet sélectionné',
			'mcp.form.scope.description.projectGlobal' => 'Écrit dans l’espace de travail du projet sélectionné pour chaque fournisseur',
			'mcp.form.scope.description.user' => 'Disponible dans tous les projets sur votre machine',
			'mcp.form.scope.description.userGlobal' => 'Écrit dans la configuration utilisateur de chaque fournisseur et est disponible dans tous les projets sur cette machine',
			'mcp.form.scope.projectAllProviders' => 'Projet (tous les fournisseurs)',
			'mcp.form.scope.userAllProviders' => 'Utilisateur (tous les fournisseurs)',
			'mcp.form.submitTo' => ({required Object provider}) => 'Ajouter le serveur à ${provider}',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'L’ajout d’un serveur MCP ne prend en charge que stdio et http pour tous les fournisseurs, pas ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} ne prend pas en charge les serveurs MCP ${type}',
			'mcp.install.button' => 'Installer',
			'mcp.install.cardDescription' => 'Donnez à vos agents la base de connaissances et les outils DDAgent via MCP — choisissez des agents ou installez pour tous.',
			'mcp.install.description' => 'Permet aux agents sélectionnés d’utiliser la base de connaissances et les outils DDAgent via MCP.',
			'mcp.install.errorFallback' => 'erreur',
			'mcp.install.failed' => ({required Object error}) => 'Échec de l’installation : ${error}',
			'mcp.install.installForAll' => 'Installer pour tous',
			'mcp.install.installSelected' => 'Installer la sélection',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Installé sur ${count} agent.', other: 'Installé sur ${count} agents.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Installé sur ${count} ; échec : ${failed}',
			'mcp.install.title' => 'Installer le serveur MCP DDAgent',
			'mcp.servers.addGlobalDescription' => 'Ajoute ce serveur MCP à tous les fournisseurs : Claude, Cursor, Codex, OpenCode et Devin. Seuls les transports stdio et HTTP sont pris en charge, car la même configuration doit fonctionner pour tous les fournisseurs.',
			'mcp.servers.addGlobalMenuDescription' => 'Ajouter un serveur MCP global écrit un serveur stdio ou HTTP commun pour Claude, Cursor, Codex, OpenCode et Devin.',
			'mcp.servers.addGlobalTitle' => 'Ajouter un serveur MCP global',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => 'Ajouter un serveur MCP ${provider} ne modifie que ${provider}.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => 'Ajouter un serveur MCP ${provider}',
			'mcp.servers.config.cwd' => 'Répertoire de travail',
			'mcp.servers.config.envVars' => 'Variables d’environnement',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Les serveurs Model Context Protocol fournissent des outils et sources de données supplémentaires à ${provider}',
			'mcp.servers.loading' => 'Chargement des serveurs MCP...',
			'mcp.servers.refreshingScopes' => 'Actualisation des portées du projet...',
			'mcp.team.cta' => 'Disponible avec DDAgent Pro',
			'mcp.team.description' => 'Partagez les configurations de serveurs MCP avec votre équipe. Tout le monde reste synchronisé automatiquement.',
			'mcp.team.title' => 'Configurations MCP d’équipe',
			'mcp.tokens.scopeWrite' => 'Écriture',
			'terminal.actions.clearOutput' => 'Effacer la sortie',
			'terminal.actions.connect' => 'Connecter',
			'terminal.actions.newShell' => 'Nouveau shell',
			'terminal.actions.newTab' => 'Nouvel onglet de terminal',
			'terminal.actions.providerLogin' => 'Connexion au fournisseur',
			'terminal.actions.restartSession' => 'Redémarrer la session',
			'terminal.authUrl.openInBrowser' => 'Ouvrir dans le navigateur',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Impossible d’ouvrir le lien : ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'Fichier détecté : ${path}',
			'terminal.paste.hint' => 'Ctrl+V / clic droit → Coller',
			'terminal.paste.title' => 'Coller dans le terminal',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.hide' => 'Masquer la barre de raccourcis',
			'terminal.shortcuts.interrupt' => 'Interrompre (SIGINT)',
			'terminal.shortcuts.suspend' => 'Suspendre (SIGTSTP)',
			'terminal.shortcuts.showTooltip' => 'Afficher les raccourcis',
			'terminal.shortcuts.hideTooltip' => 'Masquer les raccourcis',
			'terminal.tabs.antigravityCli' => 'CLI Antigravity',
			'terminal.tabs.claudeCli' => 'CLI Claude',
			'terminal.tabs.commandCodeCli' => 'CLI Command Code',
			'terminal.tabs.cursorCli' => 'CLI Cursor',
			'terminal.tabs.devinCli' => 'CLI Devin',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Connexion : ${provider}',
			'terminal.tabs.opencodeCli' => 'CLI OpenCode',
			'terminal.tabs.plainShell' => 'Shell simple',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'worktrees.branchHint' => 'Nom de la nouvelle branche (ex. : feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Création depuis ${branch}',
			'worktrees.cleanupDescription' => 'Supprimer le worktree et sa branche une fois fusionnée',
			'worktrees.created' => 'Worktree créé',
			'worktrees.deleteBranchLabel' => 'Supprimer aussi la branche',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Attention : ce worktree a ${count} modification(s) non validée(s) qui seront perdues.',
			'worktrees.emptyDescription' => 'Créez un worktree pour isoler le travail sur une fonctionnalité ou l’exécution des agents.',
			'worktrees.emptyTitle' => 'Aucun worktree trouvé',
			'worktrees.forceRemoveLabel' => 'Forcer la suppression (ignorer les modifications)',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD détaché sur ${sha}',
			'worktrees.mainBadge' => 'main',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Fusionner les modifications dans ${branch}.',
			'worktrees.mergeTitle' => ({required Object branch}) => 'Fusionner ${branch}',
			'worktrees.merged' => ({required Object branch}) => 'Worktree fusionné dans ${branch}',
			'worktrees.opened' => ({required Object branch}) => 'Worktree ouvert : ${branch}',
			'worktrees.portHint' => 'Port d’exécution (optionnel, ex. : 3000)',
			'worktrees.removeDescription' => 'Cela supprime le dossier du worktree. Les projets liés seront archivés.',
			'worktrees.removeTitle' => ({required Object branch}) => 'Supprimer le worktree ${branch} ?',
			'worktrees.removed' => 'Worktree supprimé',
			'worktrees.runButton' => 'Exécuter',
			'worktrees.runHint' => 'Commande d’exécution (ex. : npm run dev)',
			'worktrees.runRunning' => 'en cours',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'en cours :${port}',
			'worktrees.scripts' => 'Scripts',
			'worktrees.scriptsSaved' => 'Configuration des scripts enregistrée',
			'worktrees.serverLabel' => 'Serveur : ',
			'worktrees.setupHint' => 'Commande de configuration (ex. : npm install)',
			'worktrees.setupLabel' => 'Configuration : ',
			'worktrees.squashDescription' => 'Combiner tous les commits en un seul commit',
			'worktrees.stopButton' => 'Arrêter',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.chart.hide' => 'Masquer',
			'quota.chart.noData' => 'Données insuffisantes pour une tendance.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokens · ${cost}',
			'quota.chart.show' => 'Afficher',
			'quota.config.accountRouting' => 'Routage des comptes',
			'quota.config.pollerTitle' => 'Interrogation et alertes',
			'quota.config.save' => 'Enregistrer la configuration',
			'quota.overview.tokensAndCost' => 'Tokens et coût',
			'quota.section.config' => 'Configuration',
			'scheduler.checking' => 'Vérification…',
			'scheduler.cronHint' => 'Cron (min heure jour mois jour de la semaine) — ex. : 0 9 * * *',
			'scheduler.deleteMessage' => ({required Object id}) => 'Cela supprime la tâche récurrente ${id}. Les sessions existantes sont conservées.',
			'scheduler.deleteTitle' => 'Supprimer la planification ?',
			'scheduler.editTitle' => 'Modifier la planification',
			'scheduler.newLabel' => 'Nouveau',
			'scheduler.nextIn' => ({required Object time}) => 'prochaine dans ${time}',
			'scheduler.promptHint' => 'Invite pour l’agent',
			'scheduler.runs' => 'Exécutions',
			'scheduler.session' => ({required Object id}) => 'session ${id}',
			'scheduler.worktree' => 'worktree',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.noResponse' => 'Aucune réponse du serveur',
			'notifications.errors.registrationRejected' => 'Inscription refusée par le serveur',
			'serverConnect.connect' => 'Se connecter',
			'serverConnect.connecting' => 'Connexion…',
			'serverConnect.changeServer' => 'Changer de serveur',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Échec de la connexion (${error})',
			'serverConnect.enterUrl' => 'Saisir une URL de serveur',
			'serverConnect.local.title' => 'Cet appareil',
			'serverConnect.local.subtitle' => 'Exécuter le serveur DDAgent sur cette machine',
			'serverConnect.local.install' => 'Installer le serveur local',
			'serverConnect.local.start' => 'Démarrer le serveur local',
			'serverConnect.local.stop' => 'Arrêter',
			'serverConnect.local.starting' => 'Démarrage du serveur local…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Téléchargement du serveur… ${percent} %',
			'serverConnect.local.installing' => 'Installation…',
			'serverConnect.local.running' => ({required Object url}) => 'En cours d\'exécution sur ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Installé (v${version})',
			'serverConnect.local.connect' => 'Utiliser ce serveur',
			'serverConnect.local.error' => ({required Object error}) => 'Erreur du serveur local : ${error}',
			'serverConnect.local.or' => 'ou connectez-vous à un serveur distant',
			'serverConnect.subtitle' => 'Connectez-vous à votre serveur DDAgent',
			'voice.apiKeySaved' => 'Clé API (enregistrée, saisissez pour remplacer)',
			'voice.preview' => 'Aperçu',
			'voice.saveFailed' => 'Échec de l’enregistrement de la configuration STT',
			'voice.settingsSaved' => 'Paramètres de saisie vocale enregistrés',
			'sharedContext.title' => 'Notes partagées',
			'collab.copyToken' => 'Copier le token',
			'collab.createInvite' => 'Créer une invitation',
			'collab.invite' => 'Inviter',
			'collab.inviteTeammate' => 'Inviter un coéquipier',
			'collab.roles.member' => 'Membre',
			'collab.roles.viewer' => 'Lecteur',
			'collab.shareTokenHint' => 'Partagez ce token d’invitation — il n’est affiché qu’une fois et expire dans 72 h :',
			'collab.team' => 'Équipe',
			'browser.dialogTitle' => 'Navigateur de l’agent',
			'browser.viewError' => 'Erreur d’affichage du navigateur',
			'browser.web' => 'Web',
			'projects.archive' => 'Archiver',
			'projects.archivedSection' => ({required Object count}) => 'Archivés (${count})',
			'projects.clone' => 'Cloner',
			'projects.cloneFailed' => 'Échec du clonage',
			'projects.cloneFinished' => 'Clonage terminé. Actualisation de la liste des projets…',
			'projects.cloneRepository' => 'Cloner le dépôt',
			'projects.deletePermanently' => 'Supprimer définitivement',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Supprime définitivement « ${name} », y compris toutes les sessions et l’historique stocké (effacement JSONL). Cette action est irréversible.',
			'projects.deleteProjectTitle' => 'Supprimer le projet ?',
			'projects.destinationPath' => 'Chemin de destination',
			'projects.destinationPathRequired' => 'Le chemin de destination est requis',
			'projects.displayNameOptional' => 'Nom d’affichage (optionnel)',
			'projects.failedToLoadTokens' => 'Échec du chargement des tokens GitHub',
			'projects.githubTokenOptional' => 'Token GitHub (optionnel)',
			'projects.newer' => 'Plus récent',
			'projects.older' => 'Plus ancien',
			'projects.projectArchived' => 'Projet archivé',
			'projects.projectDeleted' => 'Projet supprimé',
			'projects.projectRenamed' => 'Projet renommé',
			'projects.projectRestored' => 'Projet restauré',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.repositoryCloned' => 'Dépôt cloné',
			'projects.repositoryUrlRequired' => 'L’URL du dépôt est requise',
			'projects.restore' => 'Restaurer',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} session', other: '${count} sessions', ), 
			'projects.unknown' => 'Inconnu',
			'projects.usingStoredToken' => ({required Object name}) => 'Utilisation du token enregistré : ${name}',
			'sessions.activity.committingChanges' => 'Validation des modifications',
			'sessions.activity.editingFile' => ({required Object file}) => 'Modification de ${file}',
			'sessions.activity.editingFileGeneric' => 'Modification d’un fichier',
			'sessions.activity.fetchingUrl' => ({required Object url}) => 'Récupération de ${url}',
			'sessions.activity.pushingBranch' => 'Envoi de la branche',
			'sessions.activity.readingFile' => ({required Object file}) => 'Lecture de ${file}',
			'sessions.activity.runningCommand' => ({required Object command}) => 'Exécution de `${command}`',
			'sessions.activity.runningShellCommand' => 'Exécution d’une commande shell',
			'sessions.activity.runningTool' => ({required Object name}) => 'Exécution de ${name}',
			'sessions.activity.searching' => ({required Object query}) => 'Recherche de « ${query} »',
			'sessions.activity.subagentRunning' => 'Sous-agent en cours d’exécution',
			'sessions.age.days' => ({required Object days}) => '${days} j',
			'sessions.age.hours' => ({required Object hours}) => '${hours} h',
			'sessions.age.lessThanMinute' => '<1 min',
			'sessions.age.minutes' => ({required Object count}) => '${count} min',
			'sessions.archive' => 'Archiver',
			'sessions.archivedSessions' => 'Sessions archivées',
			'sessions.autoOrchestrator' => 'Auto (orchestrateur)',
			'sessions.compareWith' => 'Comparer avec…',
			'sessions.createFailed' => ({required Object error}) => 'Échec de la création de la session : ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Supprime « ${name} » et sa transcription. Cette action est irréversible.',
			'sessions.newSessionProvider' => 'Nouvelle session — fournisseur',
			'sessions.noRecentSessions' => 'Aucune session récente',
			'sessions.noSessions' => 'Aucune session',
			'sessions.projectPath' => 'Chemin du projet',
			'sessions.rename' => 'Renommer',
			'sessions.toasts.archived' => 'Session archivée',
			'sessions.toasts.deleted' => 'Session supprimée',
			'sessions.toasts.pinned' => 'Session épinglée',
			'sessions.toasts.renamed' => 'Session renommée',
			'sessions.toasts.restored' => 'Session restaurée',
			'sessions.toasts.unpinned' => 'Session désépinglée',
			'sessions.toasts.workspaceChanged' => 'Espace de travail modifié',
			'git.aiButton' => '✦ IA',
			'git.checkpoints.create' => 'Nouveau',
			'git.checkpoints.empty' => 'Aucun checkpoint pour l’instant',
			'git.checkpoints.labelHint' => 'Libellé du checkpoint (optionnel)',
			'git.checkpoints.restoreMessage' => 'Réinitialiser l’arbre de travail sur ce checkpoint ? Les modifications actuelles seront remplacées.',
			'git.checkpoints.restoreTitle' => 'Restaurer le checkpoint',
			'git.checkpoints.restored' => 'Checkpoint restauré',
			'git.checkpoints.title' => 'Checkpoints',
			'git.commitCreated' => 'Commit créé',
			'git.commitMessage' => 'Message de commit',
			'git.deleteFile' => 'Supprimer le fichier',
			'git.hunkStage' => '+ Section',
			'git.hunkUnstage' => '− Section',
			'git.largeDiff' => 'Aperçu de diff volumineux : le rendu est limité pour garder l’onglet réactif.',
			'git.loadDiffFailed' => ({required Object error}) => 'Échec du chargement du diff : ${error}',
			'git.noBranch' => 'aucune branche',
			'git.noDiff' => 'Aucun diff disponible',
			'git.selectProject' => 'Sélectionnez un projet',
			'git.splitDiff' => 'Diff côte à côte',
			'git.stageHunk' => 'Indexer cette section',
			'git.stagedChanges' => 'Modifications indexées',
			'git.statusStaged' => 'Indexé',
			'git.switchBranch' => 'Changer de branche',
			'git.unifiedDiff' => 'Diff unifié',
			'git.unstageHunk' => 'Retirer cette section de l’index',
			'kanban.card.untitled' => 'Sans titre',
			'kanban.comments.add' => 'Ajouter un commentaire',
			'kanban.comments.empty' => 'Aucun commentaire pour l’instant',
			'kanban.details.status' => ({required Object status}) => 'Statut : ${status}',
			'kanban.details.title' => 'Détails de la carte',
			'kanban.dialog.saving' => 'Enregistrement…',
			'kanban.empty.noProject' => 'Aucun projet sélectionné',
			'kanban.saveFailed' => 'Échec de l’enregistrement de la carte',
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Il y a 1 jour', other: 'Il y a ${count} jours', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Il y a 1 heure', other: 'Il y a ${count} heures', ), 
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Il y a 1 minute', other: 'Il y a ${count} minutes', ), 
			'kanban.time.now' => 'à l’instant',
			'onboarding.agents.description' => 'Connectez-vous à un ou plusieurs assistants de codage IA. Tous sont optionnels.',
			'onboarding.agents.laterHint' => 'Vous pourrez les configurer plus tard dans les Paramètres.',
			'onboarding.agents.title' => 'Connectez vos agents IA',
			'onboarding.completeSetup' => 'Terminer la configuration',
			'onboarding.errors.invalidEmail' => 'Veuillez saisir une adresse e-mail valide.',
			'onboarding.errors.nameAndEmailRequired' => 'Le nom et l’e-mail git sont tous deux requis.',
			'onboarding.gitHint' => 'Utilisé pour les commits créés par les sessions DDAgent.',
			'onboarding.mcp.description' => 'Installez le serveur MCP DDAgent pour que vos agents puissent utiliser la base de connaissances et les outils DDAgent. Choisissez des agents ou installez pour tous.',
			'onboarding.mcp.installForAll' => 'Installer pour tous',
			'onboarding.mcp.installSelected' => 'Installer la sélection',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Installé sur ${count} agent.', other: 'Installé sur ${count} agents.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Installé sur ${installedCount} ; échec : ${failed}',
			'onboarding.mcp.laterHint' => 'Optionnel — vous pouvez aussi l’installer plus tard dans Paramètres → MCP.',
			'onboarding.mcp.title' => 'Connecter les agents à DDAgent',
			'fileTree.browseServerFilesystem' => 'Parcourir le système de fichiers du serveur',
			'fileTree.chooseFolder' => 'Choisir un dossier',
			'fileTree.copyContents' => 'Copier le contenu',
			'fileTree.noFiles' => 'Aucun fichier',
			'fileTree.search.hint' => 'Filtrer les noms / Entrée pour rechercher dans le contenu',
			'fileTree.search.noMatches' => 'Aucun résultat',
			'fileTree.search.prompt' => 'Saisissez une requête et appuyez sur Entrée',
			'fileTree.search.resultsTruncated' => 'Résultats tronqués',
			'fileTree.titles.delete' => ({required Object name}) => 'Supprimer ${name}',
			'fileTree.titles.download' => ({required Object name}) => 'Télécharger ${name}',
			'fileTree.titles.rename' => ({required Object name}) => 'Renommer ${name}',
			'fileTree.uploadHere' => 'Téléverser ici',
			'fileTree.uploadTo' => 'Téléverser vers',
			'fileTree.uploadedCount' => ({required Object count}) => '${count} fichier(s) téléversé(s)',
			'fileTree.newName' => 'Nouveau nom',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Projet non enregistré : ${path}',
			'fileTree.showGitignoredFiles' => 'Afficher les fichiers ignorés par git',
			'fileTree.hideGitignoredFiles' => 'Masquer les fichiers ignorés par git',
			'fileTree.downloadUnsupportedOnWeb' => 'Téléchargement non pris en charge sur le web',
			'fileTree.saveToPath' => 'Enregistrer vers un chemin',
			'fileTree.savedTo' => ({required Object path}) => 'Enregistré dans ${path}',
			'workspace.archivedWorkspaceName' => 'Archivé',
			'workspace.closePane' => 'Fermer le volet',
			'workspace.closeSearch' => 'Fermer la recherche',
			'workspace.deleteSessionNotice' => 'Cela supprime définitivement la session et sa transcription. Cette action est irréversible.',
			'workspace.exportChat' => 'Exporter la discussion',
			'workspace.jumpToSession' => 'Aller à la session…',
			'workspace.newChatProvider' => 'Nouvelle discussion — fournisseur',
			'workspace.nextMatch' => 'Résultat suivant',
			'workspace.previousMatch' => 'Résultat précédent',
			'workspace.searchTranscript' => 'Rechercher dans la transcription',
			'workspace.sendTo' => ({required Object count}) => 'Envoyer à ${count}',
			'workspace.accountWithLabel' => ({required Object label}) => 'Par défaut · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Terminez l\'exécution avant de changer d\'espace de travail',
			'workspace.restored' => 'Espace de travail restauré',
			'workspace.maximizePane' => 'Agrandir le volet',
			'workspace.restorePanes' => 'Restaurer les volets',
			'workspace.reviewChangedFiles' => 'Examiner les fichiers modifiés',
			_ => null,
		};
	}
}
