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
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$es auth = Translations$auth$es._(_root);
	@override late final Translations$chat$es chat = Translations$chat$es._(_root);
	@override late final Translations$codeEditor$es codeEditor = Translations$codeEditor$es._(_root);
	@override late final Translations$common$es common = Translations$common$es._(_root);
	@override late final Translations$settings$es settings = Translations$settings$es._(_root);
	@override late final Translations$sidebar$es sidebar = Translations$sidebar$es._(_root);
	@override late final Translations$tasks$es tasks = Translations$tasks$es._(_root);
	@override late final Translations$knowledge$es knowledge = Translations$knowledge$es._(_root);
	@override late final Translations$browser$es browser = Translations$browser$es._(_root);
	@override late final Translations$collab$es collab = Translations$collab$es._(_root);
	@override late final Translations$fileTree$es fileTree = Translations$fileTree$es._(_root);
	@override late final Translations$git$es git = Translations$git$es._(_root);
	@override late final Translations$kanban$es kanban = Translations$kanban$es._(_root);
	@override late final Translations$mcp$es mcp = Translations$mcp$es._(_root);
	@override late final Translations$notifications$es notifications = Translations$notifications$es._(_root);
	@override late final Translations$onboarding$es onboarding = Translations$onboarding$es._(_root);
	@override late final Translations$projects$es projects = Translations$projects$es._(_root);
	@override late final Translations$quota$es quota = Translations$quota$es._(_root);
	@override late final Translations$scheduler$es scheduler = Translations$scheduler$es._(_root);
	@override late final Translations$serverConnect$es serverConnect = Translations$serverConnect$es._(_root);
	@override late final Translations$sessions$es sessions = Translations$sessions$es._(_root);
	@override late final Translations$sharedContext$es sharedContext = Translations$sharedContext$es._(_root);
	@override late final Translations$skills$es skills = Translations$skills$es._(_root);
	@override late final Translations$terminal$es terminal = Translations$terminal$es._(_root);
	@override late final Translations$voice$es voice = Translations$voice$es._(_root);
	@override late final Translations$workspace$es workspace = Translations$workspace$es._(_root);
	@override late final Translations$worktrees$es worktrees = Translations$worktrees$es._(_root);
	@override late final Translations$browserUse$es browserUse = Translations$browserUse$es._(_root);
	@override late final Translations$orchestrator$es orchestrator = Translations$orchestrator$es._(_root);
	@override late final Translations$miniOrchestrator$es miniOrchestrator = Translations$miniOrchestrator$es._(_root);
}

// Path: auth
class Translations$auth$es extends Translations$auth$en {
	Translations$auth$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'Tu sesión ha caducado. Inicia sesión de nuevo.';
	@override late final Translations$auth$login$es login = Translations$auth$login$es._(_root);
	@override late final Translations$auth$register$es register = Translations$auth$register$es._(_root);
	@override late final Translations$auth$logout$es logout = Translations$auth$logout$es._(_root);
}

// Path: chat
class Translations$chat$es extends Translations$chat$en {
	Translations$chat$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$es codeBlock = Translations$chat$codeBlock$es._(_root);
	@override late final Translations$chat$copyMessage$es copyMessage = Translations$chat$copyMessage$es._(_root);
	@override late final Translations$chat$messageTypes$es messageTypes = Translations$chat$messageTypes$es._(_root);
	@override late final Translations$chat$orchestrator$es orchestrator = Translations$chat$orchestrator$es._(_root);
	@override late final Translations$chat$tools$es tools = Translations$chat$tools$es._(_root);
	@override late final Translations$chat$search$es search = Translations$chat$search$es._(_root);
	@override late final Translations$chat$fileOperations$es fileOperations = Translations$chat$fileOperations$es._(_root);
	@override late final Translations$chat$interactive$es interactive = Translations$chat$interactive$es._(_root);
	@override late final Translations$chat$thinking$es thinking = Translations$chat$thinking$es._(_root);
	@override late final Translations$chat$json$es json = Translations$chat$json$es._(_root);
	@override late final Translations$chat$permissions$es permissions = Translations$chat$permissions$es._(_root);
	@override late final Translations$chat$todo$es todo = Translations$chat$todo$es._(_root);
	@override late final Translations$chat$plan$es plan = Translations$chat$plan$es._(_root);
	@override late final Translations$chat$usageLimit$es usageLimit = Translations$chat$usageLimit$es._(_root);
	@override late final Translations$chat$codex$es codex = Translations$chat$codex$es._(_root);
	@override late final Translations$chat$voice$es voice = Translations$chat$voice$es._(_root);
	@override late final Translations$chat$input$es input = Translations$chat$input$es._(_root);
	@override late final Translations$chat$composer$es composer = Translations$chat$composer$es._(_root);
	@override late final Translations$chat$providerSelection$es providerSelection = Translations$chat$providerSelection$es._(_root);
	@override late final Translations$chat$session$es session = Translations$chat$session$es._(_root);
	@override late final Translations$chat$shell$es shell = Translations$chat$shell$es._(_root);
	@override late final Translations$chat$claudeStatus$es claudeStatus = Translations$chat$claudeStatus$es._(_root);
	@override late final Translations$chat$projectSelection$es projectSelection = Translations$chat$projectSelection$es._(_root);
	@override late final Translations$chat$tasks$es tasks = Translations$chat$tasks$es._(_root);
	@override late final Translations$chat$splitSession$es splitSession = Translations$chat$splitSession$es._(_root);
	@override late final Translations$chat$sessionPicker$es sessionPicker = Translations$chat$sessionPicker$es._(_root);
	@override late final Translations$chat$splitWorkspace$es splitWorkspace = Translations$chat$splitWorkspace$es._(_root);
	@override late final Translations$chat$splitOverview$es splitOverview = Translations$chat$splitOverview$es._(_root);
	@override late final Translations$chat$askUserQuestion$es askUserQuestion = Translations$chat$askUserQuestion$es._(_root);
	@override late final Translations$chat$attachments$es attachments = Translations$chat$attachments$es._(_root);
	@override late final Translations$chat$checkpoint$es checkpoint = Translations$chat$checkpoint$es._(_root);
	@override late final Translations$chat$common$es common = Translations$chat$common$es._(_root);
	@override late final Translations$chat$taskMaster$es taskMaster = Translations$chat$taskMaster$es._(_root);
	@override late final Translations$chat$tokenUsage$es tokenUsage = Translations$chat$tokenUsage$es._(_root);
	@override late final Translations$chat$tool$es tool = Translations$chat$tool$es._(_root);
	@override late final Translations$chat$quotaBadge$es quotaBadge = Translations$chat$quotaBadge$es._(_root);
	@override late final Translations$chat$broadcast$es broadcast = Translations$chat$broadcast$es._(_root);
	@override late final Translations$chat$paneHeader$es paneHeader = Translations$chat$paneHeader$es._(_root);
	@override late final Translations$chat$export$es export = Translations$chat$export$es._(_root);
	@override late final Translations$chat$commandResult$es commandResult = Translations$chat$commandResult$es._(_root);
	@override late final Translations$chat$commands$es commands = Translations$chat$commands$es._(_root);
	@override late final Translations$chat$pinFile$es pinFile = Translations$chat$pinFile$es._(_root);
	@override late final Translations$chat$modelLibrary$es modelLibrary = Translations$chat$modelLibrary$es._(_root);
	@override late final Translations$chat$changes$es changes = Translations$chat$changes$es._(_root);
	@override late final Translations$chat$message$es message = Translations$chat$message$es._(_root);
	@override late final Translations$chat$permissionRequest$es permissionRequest = Translations$chat$permissionRequest$es._(_root);
	@override late final Translations$chat$commandDialog$es commandDialog = Translations$chat$commandDialog$es._(_root);
	@override late final Translations$chat$utilities$es utilities = Translations$chat$utilities$es._(_root);
	@override late final Translations$chat$toolBlocks$es toolBlocks = Translations$chat$toolBlocks$es._(_root);
	@override late final Translations$chat$commandMenu$es commandMenu = Translations$chat$commandMenu$es._(_root);
	@override late final Translations$chat$mentionMenu$es mentionMenu = Translations$chat$mentionMenu$es._(_root);
	@override late final Translations$chat$subheader$es subheader = Translations$chat$subheader$es._(_root);
	@override late final Translations$chat$transcript$es transcript = Translations$chat$transcript$es._(_root);
	@override late final Translations$chat$review$es review = Translations$chat$review$es._(_root);
}

// Path: codeEditor
class Translations$codeEditor$es extends Translations$codeEditor$en {
	Translations$codeEditor$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$es toolbar = Translations$codeEditor$toolbar$es._(_root);
	@override String loading({required Object fileName}) => 'Cargando ${fileName}...';
	@override late final Translations$codeEditor$header$es header = Translations$codeEditor$header$es._(_root);
	@override late final Translations$codeEditor$actions$es actions = Translations$codeEditor$actions$es._(_root);
	@override late final Translations$codeEditor$footer$es footer = Translations$codeEditor$footer$es._(_root);
	@override late final Translations$codeEditor$binaryFile$es binaryFile = Translations$codeEditor$binaryFile$es._(_root);
	@override late final Translations$codeEditor$filePreview$es filePreview = Translations$codeEditor$filePreview$es._(_root);
	@override String unsavedChanges({required Object name}) => 'Cambios sin guardar en ${name}';
	@override String get discardUnsavedChanges => '¿Descartar los cambios sin guardar?';
	@override late final Translations$codeEditor$mediaFile$es mediaFile = Translations$codeEditor$mediaFile$es._(_root);
	@override String get failedToLoad => 'No se pudo cargar el archivo';
	@override late final Translations$codeEditor$hexDump$es hexDump = Translations$codeEditor$hexDump$es._(_root);
	@override late final Translations$codeEditor$settings$es settings = Translations$codeEditor$settings$es._(_root);
	@override late final Translations$codeEditor$diff$es diff = Translations$codeEditor$diff$es._(_root);
	@override late final Translations$codeEditor$emptyState$es emptyState = Translations$codeEditor$emptyState$es._(_root);
	@override late final Translations$codeEditor$toasts$es toasts = Translations$codeEditor$toasts$es._(_root);
}

// Path: common
class Translations$common$es extends Translations$common$en {
	Translations$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$es buttons = Translations$common$buttons$es._(_root);
	@override late final Translations$common$tabs$es tabs = Translations$common$tabs$es._(_root);
	@override late final Translations$common$quota$es quota = Translations$common$quota$es._(_root);
	@override late final Translations$common$status$es status = Translations$common$status$es._(_root);
	@override late final Translations$common$messages$es messages = Translations$common$messages$es._(_root);
	@override late final Translations$common$navigation$es navigation = Translations$common$navigation$es._(_root);
	@override late final Translations$common$common$es common = Translations$common$common$es._(_root);
	@override late final Translations$common$time$es time = Translations$common$time$es._(_root);
	@override late final Translations$common$fileOperations$es fileOperations = Translations$common$fileOperations$es._(_root);
	@override late final Translations$common$mainContent$es mainContent = Translations$common$mainContent$es._(_root);
	@override late final Translations$common$fileTree$es fileTree = Translations$common$fileTree$es._(_root);
	@override late final Translations$common$projectWizard$es projectWizard = Translations$common$projectWizard$es._(_root);
	@override late final Translations$common$notifications$es notifications = Translations$common$notifications$es._(_root);
	@override late final Translations$common$versionUpdate$es versionUpdate = Translations$common$versionUpdate$es._(_root);
	@override late final Translations$common$actions$es actions = Translations$common$actions$es._(_root);
	@override late final Translations$common$browserPane$es browserPane = Translations$common$browserPane$es._(_root);
	@override late final Translations$common$browserUse$es browserUse = Translations$common$browserUse$es._(_root);
	@override late final Translations$common$commandPalette$es commandPalette = Translations$common$commandPalette$es._(_root);
	@override late final Translations$common$gitPanel$es gitPanel = Translations$common$gitPanel$es._(_root);
	@override late final Translations$common$sessions$es sessions = Translations$common$sessions$es._(_root);
	@override late final Translations$common$projects$es projects = Translations$common$projects$es._(_root);
	@override late final Translations$common$sharedNotes$es sharedNotes = Translations$common$sharedNotes$es._(_root);
	@override late final Translations$common$codeBlock$es codeBlock = Translations$common$codeBlock$es._(_root);
	@override late final Translations$common$update$es update = Translations$common$update$es._(_root);
	@override late final Translations$common$appShell$es appShell = Translations$common$appShell$es._(_root);
	@override late final Translations$common$errors$es errors = Translations$common$errors$es._(_root);
}

// Path: settings
class Translations$settings$es extends Translations$settings$en {
	Translations$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes';
	@override late final Translations$settings$changelog$es changelog = Translations$settings$changelog$es._(_root);
	@override late final Translations$settings$server$es server = Translations$settings$server$es._(_root);
	@override late final Translations$settings$updates$es updates = Translations$settings$updates$es._(_root);
	@override late final Translations$settings$tabs$es tabs = Translations$settings$tabs$es._(_root);
	@override late final Translations$settings$account$es account = Translations$settings$account$es._(_root);
	@override late final Translations$settings$mcp$es mcp = Translations$settings$mcp$es._(_root);
	@override late final Translations$settings$appearance$es appearance = Translations$settings$appearance$es._(_root);
	@override late final Translations$settings$actions$es actions = Translations$settings$actions$es._(_root);
	@override late final Translations$settings$quickSettings$es quickSettings = Translations$settings$quickSettings$es._(_root);
	@override late final Translations$settings$terminalShortcuts$es terminalShortcuts = Translations$settings$terminalShortcuts$es._(_root);
	@override late final Translations$settings$mainTabs$es mainTabs = Translations$settings$mainTabs$es._(_root);
	@override late final Translations$settings$miniOrchestration$es miniOrchestration = Translations$settings$miniOrchestration$es._(_root);
	@override late final Translations$settings$orchestration$es orchestration = Translations$settings$orchestration$es._(_root);
	@override late final Translations$settings$notifications$es notifications = Translations$settings$notifications$es._(_root);
	@override late final Translations$settings$appearanceSettings$es appearanceSettings = Translations$settings$appearanceSettings$es._(_root);
	@override late final Translations$settings$mcpForm$es mcpForm = Translations$settings$mcpForm$es._(_root);
	@override late final Translations$settings$saveStatus$es saveStatus = Translations$settings$saveStatus$es._(_root);
	@override late final Translations$settings$footerActions$es footerActions = Translations$settings$footerActions$es._(_root);
	@override late final Translations$settings$git$es git = Translations$settings$git$es._(_root);
	@override late final Translations$settings$apiKeys$es apiKeys = Translations$settings$apiKeys$es._(_root);
	@override late final Translations$settings$tasks$es tasks = Translations$settings$tasks$es._(_root);
	@override late final Translations$settings$agents$es agents = Translations$settings$agents$es._(_root);
	@override late final Translations$settings$permissions$es permissions = Translations$settings$permissions$es._(_root);
	@override late final Translations$settings$mcpServers$es mcpServers = Translations$settings$mcpServers$es._(_root);
	@override late final Translations$settings$quota$es quota = Translations$settings$quota$es._(_root);
	@override late final Translations$settings$browser$es browser = Translations$settings$browser$es._(_root);
	@override late final Translations$settings$workspaces$es workspaces = Translations$settings$workspaces$es._(_root);
	@override late final Translations$settings$stt$es stt = Translations$settings$stt$es._(_root);
	@override late final Translations$settings$schedules$es schedules = Translations$settings$schedules$es._(_root);
	@override late final Translations$settings$mcpTokens$es mcpTokens = Translations$settings$mcpTokens$es._(_root);
	@override late final Translations$settings$about$es about = Translations$settings$about$es._(_root);
	@override late final Translations$settings$shortcuts$es shortcuts = Translations$settings$shortcuts$es._(_root);
}

// Path: sidebar
class Translations$sidebar$es extends Translations$sidebar$en {
	Translations$sidebar$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$es projects = Translations$sidebar$projects$es._(_root);
	@override late final Translations$sidebar$app$es app = Translations$sidebar$app$es._(_root);
	@override late final Translations$sidebar$panel$es panel = Translations$sidebar$panel$es._(_root);
	@override late final Translations$sidebar$sessions$es sessions = Translations$sidebar$sessions$es._(_root);
	@override late final Translations$sidebar$tooltips$es tooltips = Translations$sidebar$tooltips$es._(_root);
	@override late final Translations$sidebar$navigation$es navigation = Translations$sidebar$navigation$es._(_root);
	@override late final Translations$sidebar$actions$es actions = Translations$sidebar$actions$es._(_root);
	@override late final Translations$sidebar$workspace$es workspace = Translations$sidebar$workspace$es._(_root);
	@override late final Translations$sidebar$branding$es branding = Translations$sidebar$branding$es._(_root);
	@override late final Translations$sidebar$status$es status = Translations$sidebar$status$es._(_root);
	@override late final Translations$sidebar$time$es time = Translations$sidebar$time$es._(_root);
	@override late final Translations$sidebar$messages$es messages = Translations$sidebar$messages$es._(_root);
	@override late final Translations$sidebar$version$es version = Translations$sidebar$version$es._(_root);
	@override late final Translations$sidebar$search$es search = Translations$sidebar$search$es._(_root);
	@override late final Translations$sidebar$recent$es recent = Translations$sidebar$recent$es._(_root);
	@override late final Translations$sidebar$deleteConfirmation$es deleteConfirmation = Translations$sidebar$deleteConfirmation$es._(_root);
	@override late final Translations$sidebar$zones$es zones = Translations$sidebar$zones$es._(_root);
	@override late final Translations$sidebar$tabs$es tabs = Translations$sidebar$tabs$es._(_root);
}

// Path: tasks
class Translations$tasks$es extends Translations$tasks$en {
	Translations$tasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$es notConfigured = Translations$tasks$notConfigured$es._(_root);
	@override late final Translations$tasks$gettingStarted$es gettingStarted = Translations$tasks$gettingStarted$es._(_root);
	@override late final Translations$tasks$setupModal$es setupModal = Translations$tasks$setupModal$es._(_root);
	@override late final Translations$tasks$helpGuide$es helpGuide = Translations$tasks$helpGuide$es._(_root);
	@override late final Translations$tasks$search$es search = Translations$tasks$search$es._(_root);
	@override late final Translations$tasks$filters$es filters = Translations$tasks$filters$es._(_root);
	@override late final Translations$tasks$sort$es sort = Translations$tasks$sort$es._(_root);
	@override late final Translations$tasks$views$es views = Translations$tasks$views$es._(_root);
	@override late final Translations$tasks$kanban$es kanban = Translations$tasks$kanban$es._(_root);
	@override late final Translations$tasks$buttons$es buttons = Translations$tasks$buttons$es._(_root);
	@override late final Translations$tasks$prd$es prd = Translations$tasks$prd$es._(_root);
	@override late final Translations$tasks$statuses$es statuses = Translations$tasks$statuses$es._(_root);
	@override late final Translations$tasks$priorities$es priorities = Translations$tasks$priorities$es._(_root);
	@override late final Translations$tasks$noMatchingTasks$es noMatchingTasks = Translations$tasks$noMatchingTasks$es._(_root);
	@override late final Translations$tasks$board$es board = Translations$tasks$board$es._(_root);
	@override late final Translations$tasks$card$es card = Translations$tasks$card$es._(_root);
	@override late final Translations$tasks$createTask$es createTask = Translations$tasks$createTask$es._(_root);
	@override late final Translations$tasks$list$es list = Translations$tasks$list$es._(_root);
	@override late final Translations$tasks$nextTask$es nextTask = Translations$tasks$nextTask$es._(_root);
	@override late final Translations$tasks$taskDetail$es taskDetail = Translations$tasks$taskDetail$es._(_root);
	@override late final Translations$tasks$toasts$es toasts = Translations$tasks$toasts$es._(_root);
	@override late final Translations$tasks$taskmaster$es taskmaster = Translations$tasks$taskmaster$es._(_root);
}

// Path: knowledge
class Translations$knowledge$es extends Translations$knowledge$en {
	Translations$knowledge$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conocimiento';
	@override late final Translations$knowledge$tabs$es tabs = Translations$knowledge$tabs$es._(_root);
	@override late final Translations$knowledge$common$es common = Translations$knowledge$common$es._(_root);
	@override late final Translations$knowledge$actions$es actions = Translations$knowledge$actions$es._(_root);
	@override late final Translations$knowledge$dialog$es dialog = Translations$knowledge$dialog$es._(_root);
	@override late final Translations$knowledge$fields$es fields = Translations$knowledge$fields$es._(_root);
	@override late final Translations$knowledge$dashboard$es dashboard = Translations$knowledge$dashboard$es._(_root);
	@override late final Translations$knowledge$empty$es empty = Translations$knowledge$empty$es._(_root);
	@override late final Translations$knowledge$history$es history = Translations$knowledge$history$es._(_root);
	@override late final Translations$knowledge$priorities$es priorities = Translations$knowledge$priorities$es._(_root);
	@override late final Translations$knowledge$search$es search = Translations$knowledge$search$es._(_root);
	@override late final Translations$knowledge$links$es links = Translations$knowledge$links$es._(_root);
	@override late final Translations$knowledge$tags$es tags = Translations$knowledge$tags$es._(_root);
	@override late final Translations$knowledge$graph$es graph = Translations$knowledge$graph$es._(_root);
	@override late final Translations$knowledge$importAll$es importAll = Translations$knowledge$importAll$es._(_root);
	@override late final Translations$knowledge$migrate$es migrate = Translations$knowledge$migrate$es._(_root);
	@override late final Translations$knowledge$importSkills$es importSkills = Translations$knowledge$importSkills$es._(_root);
	@override late final Translations$knowledge$critical$es critical = Translations$knowledge$critical$es._(_root);
	@override late final Translations$knowledge$contextBudget$es contextBudget = Translations$knowledge$contextBudget$es._(_root);
	@override late final Translations$knowledge$linkOptions$es linkOptions = Translations$knowledge$linkOptions$es._(_root);
	@override late final Translations$knowledge$errors$es errors = Translations$knowledge$errors$es._(_root);
	@override late final Translations$knowledge$entityTypes$es entityTypes = Translations$knowledge$entityTypes$es._(_root);
}

// Path: browser
class Translations$browser$es extends Translations$browser$en {
	Translations$browser$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Navegador del agente';
	@override String get viewError => 'Error en la vista del navegador';
	@override String get web => 'Web';
}

// Path: collab
class Translations$collab$es extends Translations$collab$en {
	Translations$collab$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get team => 'Equipo';
	@override String get invite => 'Invitación';
	@override String get inviteTeammate => 'Invitar a un compañero';
	@override String get shareTokenHint => 'Comparte este token de invitación — se muestra una sola vez y caduca en 72 h:';
	@override String get createInvite => 'Crear invitación';
	@override String get copyToken => 'Copiar token';
	@override late final Translations$collab$roles$es roles = Translations$collab$roles$es._(_root);
	@override late final Translations$collab$viewing$es viewing = Translations$collab$viewing$es._(_root);
}

// Path: fileTree
class Translations$fileTree$es extends Translations$fileTree$en {
	Translations$fileTree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get uploadTo => 'Subir a';
	@override String get uploadHere => 'Subir aquí';
	@override String get browseServerFilesystem => 'Explorar el sistema de archivos del servidor';
	@override String get noFiles => 'Sin archivos';
	@override String get copyContents => 'Copiar contenido';
	@override String get chooseFolder => 'Elegir carpeta';
	@override late final Translations$fileTree$search$es search = Translations$fileTree$search$es._(_root);
	@override late final Translations$fileTree$titles$es titles = Translations$fileTree$titles$es._(_root);
	@override String uploadedCount({required Object count}) => 'Subidos ${count} archivo(s)';
	@override String get newName => 'Nombre nuevo';
	@override String notRegisteredProject({required Object path}) => 'No es un proyecto registrado: ${path}';
	@override String get showGitignoredFiles => 'Mostrar archivos ignorados por git';
	@override String get hideGitignoredFiles => 'Ocultar archivos ignorados por git';
	@override String get downloadUnsupportedOnWeb => 'Descarga no compatible en la web';
	@override String get saveToPath => 'Guardar en ruta';
	@override String savedTo({required Object path}) => 'Guardado en ${path}';
	@override late final Translations$fileTree$relative$es relative = Translations$fileTree$relative$es._(_root);
	@override String get projectRoot => '(raíz del proyecto)';
	@override String uploadLimitCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Puedes subir como máximo ${count} archivo a la vez.',
		other: 'Puedes subir como máximo ${count} archivos a la vez.',
	);
	@override String fileTooLarge({required Object name}) => '${name} supera los 200 MB.';
	@override String deleteFolderConfirm({required Object path}) => '¿Eliminar la carpeta "${path}"? Esta acción no se puede deshacer.';
	@override String deleteFileConfirm({required Object path}) => '¿Eliminar el archivo "${path}"? Esta acción no se puede deshacer.';
}

// Path: git
class Translations$git$es extends Translations$git$en {
	Translations$git$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$git$checkpoints$es checkpoints = Translations$git$checkpoints$es._(_root);
	@override String get stagedChanges => 'Cambios preparados';
	@override String get statusStaged => 'Preparado';
	@override String get switchBranch => 'Cambiar de rama';
	@override String get unifiedDiff => 'Diff unificado';
	@override String get splitDiff => 'Diff lado a lado';
	@override String get noDiff => 'No hay diff disponible';
	@override String get largeDiff => 'Vista previa de diff grande: la representación está limitada para mantener la pestaña ágil.';
	@override String loadDiffFailed({required Object error}) => 'No se pudo cargar el diff: ${error}';
	@override String get hunkStage => '+ Sección';
	@override String get hunkUnstage => '− Sección';
	@override String get stageHunk => 'Preparar sección';
	@override String get unstageHunk => 'Quitar preparación de la sección';
	@override String get deleteFile => 'Eliminar archivo';
	@override String get commitMessage => 'Mensaje del commit';
	@override String get aiButton => '✦ IA';
	@override String get commitCreated => 'Commit creado';
	@override String get noBranch => 'sin rama';
	@override String get selectProject => 'Selecciona un proyecto';
	@override late final Translations$git$branchSections$es branchSections = Translations$git$branchSections$es._(_root);
}

// Path: kanban
class Translations$kanban$es extends Translations$kanban$en {
	Translations$kanban$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$es card = Translations$kanban$card$es._(_root);
	@override late final Translations$kanban$comments$es comments = Translations$kanban$comments$es._(_root);
	@override late final Translations$kanban$dialog$es dialog = Translations$kanban$dialog$es._(_root);
	@override late final Translations$kanban$details$es details = Translations$kanban$details$es._(_root);
	@override late final Translations$kanban$empty$es empty = Translations$kanban$empty$es._(_root);
	@override String get saveFailed => 'No se pudo guardar la tarjeta';
	@override late final Translations$kanban$time$es time = Translations$kanban$time$es._(_root);
}

// Path: mcp
class Translations$mcp$es extends Translations$mcp$en {
	Translations$mcp$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$install$es install = Translations$mcp$install$es._(_root);
	@override late final Translations$mcp$servers$es servers = Translations$mcp$servers$es._(_root);
	@override late final Translations$mcp$team$es team = Translations$mcp$team$es._(_root);
	@override late final Translations$mcp$tokens$es tokens = Translations$mcp$tokens$es._(_root);
	@override late final Translations$mcp$form$es form = Translations$mcp$form$es._(_root);
}

// Path: notifications
class Translations$notifications$es extends Translations$notifications$en {
	Translations$notifications$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$es errors = Translations$notifications$errors$es._(_root);
	@override late final Translations$notifications$androidChannel$es androidChannel = Translations$notifications$androidChannel$es._(_root);
}

// Path: onboarding
class Translations$onboarding$es extends Translations$onboarding$en {
	Translations$onboarding$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get gitHint => 'Se usa para los commits creados por sesiones de DDAgent.';
	@override String get completeSetup => 'Completar configuración';
	@override late final Translations$onboarding$errors$es errors = Translations$onboarding$errors$es._(_root);
	@override late final Translations$onboarding$agents$es agents = Translations$onboarding$agents$es._(_root);
	@override late final Translations$onboarding$mcp$es mcp = Translations$onboarding$mcp$es._(_root);
}

// Path: projects
class Translations$projects$es extends Translations$projects$en {
	Translations$projects$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cloneRepository => 'Clonar repositorio';
	@override String get repositoryCloned => 'Repositorio clonado';
	@override String get clone => 'Clonar';
	@override String get cloneFinished => 'Clonación completada. Actualizando la lista de proyectos…';
	@override String get cloneFailed => 'La clonación falló';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get destinationPath => 'Ruta de destino';
	@override String get destinationPathRequired => 'La ruta de destino es obligatoria';
	@override String get repositoryUrlRequired => 'La URL del repositorio es obligatoria';
	@override String get githubTokenOptional => 'Token de GitHub (opcional)';
	@override String get archive => 'Archivar';
	@override String get restore => 'Restaurar';
	@override String get deletePermanently => 'Eliminar permanentemente';
	@override String get deleteProjectTitle => '¿Eliminar el proyecto?';
	@override String deleteProjectMessage({required Object name}) => 'Elimina permanentemente «${name}», incluidas todas las sesiones y el historial almacenado (borrado de JSONL). Esta acción no se puede deshacer.';
	@override String archivedSection({required Object count}) => 'Archivados (${count})';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} sesión',
		other: '${count} sesiones',
	);
	@override String get newer => 'Más reciente';
	@override String get older => 'Más antiguo';
	@override String get projectArchived => 'Proyecto archivado';
	@override String get projectRestored => 'Proyecto restaurado';
	@override String get projectRenamed => 'Proyecto renombrado';
	@override String get projectDeleted => 'Proyecto eliminado';
	@override String get failedToLoadTokens => 'No se pudieron cargar los tokens de GitHub';
	@override String get displayNameOptional => 'Nombre para mostrar (opcional)';
	@override String usingStoredToken({required Object name}) => 'Usando el token guardado: ${name}';
	@override String get unknown => 'Desconocido';
	@override String get project => 'Proyecto';
}

// Path: quota
class Translations$quota$es extends Translations$quota$en {
	Translations$quota$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$section$es section = Translations$quota$section$es._(_root);
	@override late final Translations$quota$overview$es overview = Translations$quota$overview$es._(_root);
	@override late final Translations$quota$agents$es agents = Translations$quota$agents$es._(_root);
	@override late final Translations$quota$config$es config = Translations$quota$config$es._(_root);
	@override late final Translations$quota$chart$es chart = Translations$quota$chart$es._(_root);
	@override late final Translations$quota$duration$es duration = Translations$quota$duration$es._(_root);
}

// Path: scheduler
class Translations$scheduler$es extends Translations$scheduler$en {
	Translations$scheduler$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newLabel => 'Nueva';
	@override String get runs => 'Ejecuciones';
	@override String get editTitle => 'Editar programación';
	@override String get deleteTitle => '¿Eliminar la programación?';
	@override String deleteMessage({required Object id}) => 'Esto elimina el trabajo recurrente ${id}. Las sesiones existentes se conservan.';
	@override String get checking => 'Comprobando…';
	@override String nextIn({required Object time}) => 'próximo en ${time}';
	@override String get worktree => 'worktree';
	@override String session({required Object id}) => 'sesión ${id}';
	@override String get cronHint => 'Cron (min hora día mes día de la semana) — p. ej. 0 9 * * *';
	@override String get promptHint => 'Prompt para el agente';
	@override late final Translations$scheduler$runStatus$es runStatus = Translations$scheduler$runStatus$es._(_root);
	@override late final Translations$scheduler$cronErrors$es cronErrors = Translations$scheduler$cronErrors$es._(_root);
}

// Path: serverConnect
class Translations$serverConnect$es extends Translations$serverConnect$en {
	Translations$serverConnect$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Conéctate a tu servidor de DDAgent';
	@override String get enterUrl => 'Introduce una URL de servidor';
	@override String connectionFailed({required Object error}) => 'Falló la conexión (${error})';
	@override String get connect => 'Conectar';
	@override String get connecting => 'Conectando…';
	@override String get changeServer => 'Cambiar servidor';
	@override late final Translations$serverConnect$local$es local = Translations$serverConnect$local$es._(_root);
	@override String httpStatus({required Object code}) => 'HTTP ${code}';
	@override String get networkError => 'Error de red';
}

// Path: sessions
class Translations$sessions$es extends Translations$sessions$en {
	Translations$sessions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get noSessions => 'No hay sesiones';
	@override String get noRecentSessions => 'No hay sesiones recientes';
	@override String get archivedSessions => 'Sesiones archivadas';
	@override String get rename => 'Renombrar';
	@override String get archive => 'Archivar';
	@override String get compareWith => 'Comparar con…';
	@override String get projectPath => 'Ruta del proyecto';
	@override String get newSessionProvider => 'Nueva sesión — proveedor';
	@override String get autoOrchestrator => 'Automático (orquestador)';
	@override String createFailed({required Object error}) => 'No se pudo crear la sesión: ${error}';
	@override String deleteSessionMessage({required Object name}) => 'Elimina «${name}» y su transcripción. Esta acción no se puede deshacer.';
	@override late final Translations$sessions$toasts$es toasts = Translations$sessions$toasts$es._(_root);
	@override late final Translations$sessions$age$es age = Translations$sessions$age$es._(_root);
	@override late final Translations$sessions$activity$es activity = Translations$sessions$activity$es._(_root);
	@override String get autoMini => 'Automático (mini)';
}

// Path: sharedContext
class Translations$sharedContext$es extends Translations$sharedContext$en {
	Translations$sharedContext$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notas compartidas';
}

// Path: skills
class Translations$skills$es extends Translations$skills$en {
	Translations$skills$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String moveSkill({required Object name}) => 'Mover ${name}';
	@override String deleteSkill({required Object name}) => 'Eliminar ${name}';
	@override String get projectLabel => 'Proyecto';
	@override late final Translations$skills$addDialog$es addDialog = Translations$skills$addDialog$es._(_root);
	@override late final Translations$skills$moveDialog$es moveDialog = Translations$skills$moveDialog$es._(_root);
	@override late final Translations$skills$screen$es screen = Translations$skills$screen$es._(_root);
	@override late final Translations$skills$empty$es empty = Translations$skills$empty$es._(_root);
	@override late final Translations$skills$scopes$es scopes = Translations$skills$scopes$es._(_root);
	@override late final Translations$skills$errors$es errors = Translations$skills$errors$es._(_root);
	@override String get providerShared => 'Compartidas';
}

// Path: terminal
class Translations$terminal$es extends Translations$terminal$en {
	Translations$terminal$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$tabs$es tabs = Translations$terminal$tabs$es._(_root);
	@override late final Translations$terminal$actions$es actions = Translations$terminal$actions$es._(_root);
	@override late final Translations$terminal$authUrl$es authUrl = Translations$terminal$authUrl$es._(_root);
	@override late final Translations$terminal$fileLink$es fileLink = Translations$terminal$fileLink$es._(_root);
	@override late final Translations$terminal$shortcuts$es shortcuts = Translations$terminal$shortcuts$es._(_root);
	@override late final Translations$terminal$paste$es paste = Translations$terminal$paste$es._(_root);
	@override late final Translations$terminal$errors$es errors = Translations$terminal$errors$es._(_root);
	@override late final Translations$terminal$loginDialog$es loginDialog = Translations$terminal$loginDialog$es._(_root);
	@override late final Translations$terminal$empty$es empty = Translations$terminal$empty$es._(_root);
	@override late final Translations$terminal$overlay$es overlay = Translations$terminal$overlay$es._(_root);
}

// Path: voice
class Translations$voice$es extends Translations$voice$en {
	Translations$voice$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get preview => 'Vista previa';
	@override String get settingsSaved => 'Ajustes de entrada de voz guardados';
	@override String get saveFailed => 'No se pudo guardar la configuración de STT';
	@override String get apiKeySaved => 'Clave API (guardada; escribe para reemplazar)';
}

// Path: workspace
class Translations$workspace$es extends Translations$workspace$en {
	Translations$workspace$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get exportChat => 'Exportar chat';
	@override String get searchTranscript => 'Buscar en la transcripción';
	@override String get previousMatch => 'Coincidencia anterior';
	@override String get nextMatch => 'Coincidencia siguiente';
	@override String get closeSearch => 'Cerrar búsqueda';
	@override String get newChatProvider => 'Nuevo chat — proveedor';
	@override String get closePane => 'Cerrar panel';
	@override String get jumpToSession => 'Ir a la sesión…';
	@override String get archivedWorkspaceName => 'Archivado';
	@override String sendTo({required Object count}) => 'Enviar a ${count}';
	@override String get deleteSessionNotice => 'Elimina la sesión y su transcripción. No se puede deshacer.';
	@override String accountWithLabel({required Object label}) => 'Predeterminado · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Finaliza la ejecución antes de cambiar de espacio de trabajo';
	@override String get restored => 'Espacio de trabajo restaurado';
	@override String get maximizePane => 'Maximizar panel';
	@override String get restorePanes => 'Restaurar paneles';
	@override String get reviewChangedFiles => 'Revisar archivos modificados';
	@override late final Translations$workspace$paneTitle$es paneTitle = Translations$workspace$paneTitle$es._(_root);
	@override String get addEditorPane => 'Añadir panel de editor';
	@override String get addGitPane => 'Añadir panel de Git';
	@override String get unknownProjectPath => 'Ruta del proyecto desconocida';
	@override String get autoMini => 'Auto (mini)';
	@override String get exportAs => 'Exportar como:';
	@override String get exportMarkdown => 'Markdown (.md)';
	@override String get exportHtml => 'Página web (.html)';
	@override String get exportPdf => 'PDF (Imprimir en archivo)';
	@override String matchPosition({required Object current, required Object total}) => '${current} de ${total}';
	@override String get launcherDescription => 'Elige un espacio de trabajo para este panel o crea uno nuevo.';
	@override String get createWorkspace => 'Crear espacio de trabajo';
}

// Path: worktrees
class Translations$worktrees$es extends Translations$worktrees$en {
	Translations$worktrees$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get scripts => 'Scripts';
	@override String get emptyTitle => 'No se encontraron worktrees';
	@override String get emptyDescription => 'Crea un worktree para aislar el trabajo de una funcionalidad o las ejecuciones de agentes.';
	@override String opened({required Object branch}) => 'Worktree abierto: ${branch}';
	@override String get created => 'Worktree creado';
	@override String get removed => 'Worktree eliminado';
	@override String merged({required Object branch}) => 'Worktree fusionado en ${branch}';
	@override String get scriptsSaved => 'Configuración de scripts guardada';
	@override String get setupLabel => 'Configuración: ';
	@override String get serverLabel => 'Servidor: ';
	@override String get runRunning => 'en ejecución';
	@override String runRunningWithPort({required Object port}) => 'en ejecución :${port}';
	@override String get runButton => 'Ejecutar';
	@override String get stopButton => 'Detener';
	@override String get mainBadge => 'main';
	@override String headDetachedAt({required Object sha}) => 'HEAD separado en ${sha}';
	@override String get branchHint => 'Nombre de la nueva rama (p. ej. feature/login)';
	@override String branchingOff({required Object branch}) => 'Ramificando desde ${branch}';
	@override String mergeTitle({required Object branch}) => 'Fusionar ${branch}';
	@override String mergeDescription({required Object branch}) => 'Fusionar los cambios en ${branch}.';
	@override String get squashDescription => 'Combinar todos los commits en un solo commit';
	@override String get cleanupDescription => 'Eliminar el worktree y borrar la rama una vez fusionada';
	@override String removeTitle({required Object branch}) => '¿Eliminar el worktree ${branch}?';
	@override String get removeDescription => 'Esto elimina la carpeta del worktree. Los proyectos vinculados se archivarán.';
	@override String dirtyWarning({required Object count}) => 'Advertencia: este worktree tiene ${count} cambios sin confirmar que se perderán.';
	@override String get forceRemoveLabel => 'Forzar eliminación (descartar cambios)';
	@override String get deleteBranchLabel => 'Eliminar también la rama';
	@override String get setupHint => 'Comando de configuración (p. ej. npm install)';
	@override String get runHint => 'Comando de ejecución (p. ej. npm run dev)';
	@override String get portHint => 'Puerto de ejecución (opcional, p. ej. 3000)';
	@override String get unknownSha => 'desconocido';
	@override String get baseBranchFallback => 'rama base';
	@override late final Translations$worktrees$runtimeStatus$es runtimeStatus = Translations$worktrees$runtimeStatus$es._(_root);
}

// Path: browserUse
class Translations$browserUse$es extends Translations$browserUse$en {
	Translations$browserUse$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$browserUse$sessionStatus$es sessionStatus = Translations$browserUse$sessionStatus$es._(_root);
}

// Path: orchestrator
class Translations$orchestrator$es extends Translations$orchestrator$en {
	Translations$orchestrator$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String stepFallback({required Object n}) => 'Paso ${n}';
}

// Path: miniOrchestrator
class Translations$miniOrchestrator$es extends Translations$miniOrchestrator$en {
	Translations$miniOrchestrator$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$miniOrchestrator$taskTypes$es taskTypes = Translations$miniOrchestrator$taskTypes$es._(_root);
	@override late final Translations$miniOrchestrator$roles$es roles = Translations$miniOrchestrator$roles$es._(_root);
}

// Path: auth.login
class Translations$auth$login$es extends Translations$auth$login$en {
	Translations$auth$login$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bienvenido de nuevo';
	@override String get description => 'Inicia sesión en tu cuenta autoalojada de DDAgent';
	@override String get username => 'Usuario';
	@override String get password => 'Contraseña';
	@override String get submit => 'Iniciar sesión';
	@override String get loading => 'Iniciando sesión...';
	@override late final Translations$auth$login$errors$es errors = Translations$auth$login$errors$es._(_root);
	@override late final Translations$auth$login$placeholders$es placeholders = Translations$auth$login$placeholders$es._(_root);
}

// Path: auth.register
class Translations$auth$register$es extends Translations$auth$register$en {
	Translations$auth$register$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crear cuenta';
	@override String get username => 'Usuario';
	@override String get password => 'Contraseña';
	@override String get confirmPassword => 'Confirmar contraseña';
	@override String get submit => 'Crear cuenta';
	@override String get loading => 'Creando cuenta...';
	@override late final Translations$auth$register$errors$es errors = Translations$auth$register$errors$es._(_root);
}

// Path: auth.logout
class Translations$auth$logout$es extends Translations$auth$logout$en {
	Translations$auth$logout$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cerrar sesión';
	@override String get confirm => '¿Seguro que quieres cerrar sesión?';
	@override String get button => 'Cerrar sesión';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$es extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copiar';
	@override String get copied => 'Copiado';
	@override String get copyCode => 'Copiar código';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$es extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copiar mensaje';
	@override String get copied => 'Mensaje copiado';
	@override String get failed => 'No se pudo copiar';
	@override String get selectFormat => 'Selecciona el formato de copia';
	@override String get copyAsMarkdown => 'Copiar como markdown';
	@override String get copyAsText => 'Copiar como texto';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$es extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => 'Error';
	@override String get tool => 'Herramienta';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
	@override String get orchestrator => 'Auto';
}

// Path: chat.orchestrator
class Translations$chat$orchestrator$es extends Translations$chat$orchestrator$en {
	Translations$chat$orchestrator$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$orchestrator$routing$es routing = Translations$chat$orchestrator$routing$es._(_root);
	@override late final Translations$chat$orchestrator$plan$es plan = Translations$chat$orchestrator$plan$es._(_root);
	@override late final Translations$chat$orchestrator$decision$es decision = Translations$chat$orchestrator$decision$es._(_root);
	@override late final Translations$chat$orchestrator$delegation$es delegation = Translations$chat$orchestrator$delegation$es._(_root);
	@override late final Translations$chat$orchestrator$summary$es summary = Translations$chat$orchestrator$summary$es._(_root);
	@override String get backToParent => 'Volver a la orquestación';
	@override late final Translations$chat$orchestrator$taskmaster$es taskmaster = Translations$chat$orchestrator$taskmaster$es._(_root);
	@override late final Translations$chat$orchestrator$gate$es gate = Translations$chat$orchestrator$gate$es._(_root);
}

// Path: chat.tools
class Translations$chat$tools$es extends Translations$chat$tools$en {
	Translations$chat$tools$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Ajustes de herramientas';
	@override String get error => 'Error de herramienta';
	@override String get result => 'Resultado de herramienta';
	@override String get viewParams => 'Ver parámetros de entrada';
	@override String get viewRawParams => 'Ver parámetros sin procesar';
	@override String get viewDiff => 'Ver diff de edición de';
	@override String get creatingFile => 'Creando archivo nuevo:';
	@override String get updatingTodo => 'Actualizando lista de pendientes';
	@override String get read => 'Leer';
	@override String get readFile => 'Leer archivo';
	@override String get updateTodo => 'Actualizar lista de pendientes';
	@override String get readTodo => 'Leer lista de pendientes';
	@override String get searchResults => 'resultados';
	@override String get todoReadLabel => 'Lista de pendientes de TodoRead';
}

// Path: chat.search
class Translations$chat$search$es extends Translations$chat$search$en {
	Translations$chat$search$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => 'Se encontraron ${count} ${type}';
	@override String get file => 'archivo';
	@override String get files => 'archivos';
	@override String get pattern => 'patrón:';
	@override String get kIn => 'en:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$es extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Archivo actualizado correctamente';
	@override String get created => 'Archivo creado correctamente';
	@override String get written => 'Archivo escrito correctamente';
	@override String get diff => 'Diff';
	@override String get newFile => 'Archivo nuevo';
	@override String get viewContent => 'Ver contenido del archivo';
	@override String viewFullOutput({required Object count}) => 'Ver salida completa (${count} caracteres)';
	@override String get contentDisplayed => 'El contenido del archivo se muestra en la vista de diff de arriba';
}

// Path: chat.interactive
class Translations$chat$interactive$es extends Translations$chat$interactive$en {
	Translations$chat$interactive$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Prompt interactivo';
	@override String get waiting => 'Esperando tu respuesta en la CLI';
	@override String get instruction => 'Selecciona una opción en la terminal donde está corriendo Claude.';
	@override String selectedOption({required Object number}) => '✓ Claude seleccionó la opción ${number}';
	@override String get instructionDetail => 'En la CLI seleccionarías esta opción de forma interactiva con las flechas o escribiendo el número.';
}

// Path: chat.thinking
class Translations$chat$thinking$es extends Translations$chat$thinking$en {
	Translations$chat$thinking$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pensando...';
	@override String get emoji => '💭 Pensando...';
	@override String get thoughtFewSeconds => 'Pensó durante unos segundos';
}

// Path: chat.json
class Translations$chat$json$es extends Translations$chat$json$en {
	Translations$chat$json$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get response => 'Respuesta JSON';
}

// Path: chat.permissions
class Translations$chat$permissions$es extends Translations$chat$permissions$en {
	Translations$chat$permissions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => 'Conceder permiso para ${tool}';
	@override String get added => 'Permiso añadido';
	@override String addTo({required Object entry}) => 'Añade ${entry} a las herramientas permitidas.';
	@override String get retry => 'Permiso guardado. Reintenta la solicitud para usar la herramienta.';
	@override String get error => 'No se pudieron actualizar los permisos. Inténtalo de nuevo.';
	@override String get openSettings => 'Abrir ajustes';
	@override String get allow => 'Permitir';
	@override String get always => 'Siempre';
	@override String get editAndAllow => 'Editar y permitir';
	@override String get deny => 'Denegar';
	@override String get reject => 'Rechazar';
	@override String allowAll({required Object count}) => 'Permitir todo (${count})';
	@override String get editInput => 'Editar entrada';
	@override String get invalidJson => 'JSON no válido';
	@override String get allowWithChanges => 'Permitir con cambios';
	@override String get alwaysDeny => 'Denegar siempre';
	@override String get denyFeedbackTitle => 'Rechazar el plan';
	@override String get denyFeedbackHint => '¿Qué debería cambiar el agente? (opcional)';
	@override String get modeAppliesNextMessage => 'El nuevo modo de permisos se aplica a partir del siguiente mensaje.';
}

// Path: chat.todo
class Translations$chat$todo$es extends Translations$chat$todo$en {
	Translations$chat$todo$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get updated => 'La lista de pendientes se actualizó correctamente';
	@override String get current => 'Lista de pendientes actual';
}

// Path: chat.plan
class Translations$chat$plan$es extends Translations$chat$plan$en {
	Translations$chat$plan$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Ver plan de implementación';
	@override String get title => 'Plan de implementación';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$es extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Se alcanzó el límite de uso de Claude. Tu límite se restablecerá a las **${time} ${timezone}** - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$es extends Translations$chat$codex$en {
	Translations$chat$codex$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Modo de permisos';
	@override late final Translations$chat$codex$modes$es modes = Translations$chat$codex$modes$es._(_root);
	@override late final Translations$chat$codex$descriptions$es descriptions = Translations$chat$codex$descriptions$es._(_root);
	@override String get technicalDetails => 'Detalles técnicos';
}

// Path: chat.voice
class Translations$chat$voice$es extends Translations$chat$voice$en {
	Translations$chat$voice$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Leer respuestas en voz alta';
	@override String get autoReadOn => 'Lectura de respuestas: activada';
	@override String get autoReadOff => 'Lectura de respuestas: desactivada';
	@override String get autoReadVoice => 'Voz de lectura';
	@override String get autoReadVoiceAuto => 'Voz automática';
	@override String get autoReadPreview => 'Así sonarán las respuestas.';
	@override String get speakMessage => 'Leer en voz alta';
	@override String get stopSpeaking => 'Detener lectura';
}

// Path: chat.input
class Translations$chat$input$es extends Translations$chat$input$en {
	Translations$chat$input$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Escribe / para comandos, @ para archivos, o pregúntale lo que quieras a ${provider}...';
	@override String get placeholderDefault => 'Escribe tu mensaje...';
	@override String get disabled => 'Entrada deshabilitada';
	@override String get attachFiles => 'Adjuntar archivos';
	@override String get attachFilesDesc => 'Subir fotos, archivos o documentos';
	@override String get takePhoto => 'Tomar foto';
	@override String get takePhotoDesc => 'Usar la cámara para capturar una foto';
	@override String get moreTools => 'Más herramientas';
	@override String get commandsDesc => 'Explorar atajos y comandos';
	@override String get clearInputDesc => 'Descartar el texto actual';
	@override String get attachImages => 'Adjuntar imágenes';
	@override String get send => 'Enviar';
	@override String get stop => 'Detener';
	@override late final Translations$chat$input$hintText$es hintText = Translations$chat$input$hintText$es._(_root);
	@override String get clickToChangeMode => 'Haz clic para cambiar el modo de permisos';
	@override String get showAllCommands => 'Mostrar todos los comandos';
	@override String get clearInput => 'Limpiar entrada';
	@override String get scrollToBottom => 'Ir al final';
	@override String get newMessage => 'Nuevo mensaje';
	@override String get newMessages => 'Nuevos mensajes';
	@override late final Translations$chat$input$queue$es queue = Translations$chat$input$queue$es._(_root);
	@override String get autoContinueTasks => 'Continuación automática';
	@override String get autoContinueTasksTooltip => 'Activa para que Devin continúe automáticamente con la siguiente tarea de Task Master';
	@override late final Translations$chat$input$offlineQueue$es offlineQueue = Translations$chat$input$offlineQueue$es._(_root);
	@override String get voice => 'Entrada de voz';
	@override String get voiceStart => 'Dictar un mensaje';
	@override String get voiceStop => 'Detener el dictado';
	@override String get pinFile => 'Fijar archivo al contexto';
	@override String get voiceSettings => 'Ajustes de voz (STT)';
	@override String cameraUnavailable({required Object error}) => 'Cámara no disponible: ${error}';
}

// Path: chat.composer
class Translations$chat$composer$es extends Translations$chat$composer$en {
	Translations$chat$composer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Herramientas y acciones';
	@override String get toolsAndActionsDesc => 'Herramientas y controles del editor de chat';
	@override String get reasoning => 'Razonamiento';
	@override String get model => 'Modelo';
	@override String get effortDefault => 'Predeterminado';
	@override String get loadingModels => 'Cargando modelos…';
	@override String get modelMenu => 'Seleccionar modelo y esfuerzo de razonamiento';
	@override String permissionHeading({required Object provider}) => '¿Cómo deben aprobarse las acciones de ${provider}?';
	@override String get favorites => 'Favoritos';
	@override String get account => 'Cuenta';
	@override String get accountMenu => 'Seleccionar cuenta';
	@override String get accountDefault => 'Cuenta predeterminada';
	@override String get accountAuto => 'Auto (predeterminada)';
	@override String get accountIsDefault => 'Predeterminada';
	@override late final Translations$chat$composer$effortLevels$es effortLevels = Translations$chat$composer$effortLevels$es._(_root);
	@override String contextWindow({required Object size}) => 'contexto de ${size}';
	@override String get accountAutoShort => 'Automático';
	@override String get uploadNoRecords => 'La subida no devolvió ningún registro';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$es extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Elige tu asistente de IA';
	@override String get description => 'Selecciona un proveedor para iniciar una conversación nueva';
	@override String get selectModel => 'Seleccionar modelo';
	@override String get workspace => 'Espacio de trabajo';
	@override String get noWorkspace => 'Ninguno';
	@override String get clickToChangeWorkspace => 'Haz clic para cambiar de espacio de trabajo';
	@override String get chooseWorkspace => 'Elegir un espacio de trabajo';
	@override String get searchWorkspaces => 'Buscar espacios de trabajo...';
	@override String get noWorkspacesFound => 'No se encontraron espacios de trabajo.';
	@override late final Translations$chat$providerSelection$providerInfo$es providerInfo = Translations$chat$providerSelection$providerInfo$es._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$es readyPrompt = Translations$chat$providerSelection$readyPrompt$es._(_root);
	@override String get autoGroup => 'Auto';
	@override String get autoLabel => 'Auto (orquestado)';
	@override String get autoDescription => 'Envía cada paso al mejor proveedor y modelo disponibles';
	@override String get orchestrated => 'orquestado';
	@override String pressToSearch({required Object shortcut}) => 'Pulsa <kbd>${shortcut}</kbd> para buscar sesiones, archivos y commits';
	@override String get all => 'Todos';
	@override String get free => 'Gratis';
	@override String get noModelsFound => 'No se encontraron modelos.';
	@override String get paid => 'De pago';
	@override String get searchModels => 'Buscar modelos...';
	@override String get addModel => 'Añadir modelo';
	@override String get chooseModel => 'Elegir un modelo';
	@override String get chooseModelDescription => 'Modelos integrados y personalizados en una lista';
	@override String get clickToChange => 'Haz clic para cambiar de modelo';
	@override String get favorites => 'Favoritos';
	@override String get loadingModels => 'Cargando modelos…';
	@override String get manageModels => 'Gestionar modelos';
	@override String get refresh => 'Actualizar modelos';
}

// Path: chat.session
class Translations$chat$session$es extends Translations$chat$session$en {
	Translations$chat$session$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$es kContinue = Translations$chat$session$kContinue$es._(_root);
	@override late final Translations$chat$session$loading$es loading = Translations$chat$session$loading$es._(_root);
	@override late final Translations$chat$session$messages$es messages = Translations$chat$session$messages$es._(_root);
	@override String get deleteConfirm => 'Elimina la sesión y su transcripción. No se puede deshacer.';
	@override String get finishRunBeforeWorkspaceChange => 'Finaliza la ejecución antes de cambiar de espacio de trabajo';
	@override String get fallbackTitle => 'Sesión';
}

// Path: chat.shell
class Translations$chat$shell$es extends Translations$chat$shell$en {
	Translations$chat$shell$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$es selectProject = Translations$chat$shell$selectProject$es._(_root);
	@override late final Translations$chat$shell$status$es status = Translations$chat$shell$status$es._(_root);
	@override late final Translations$chat$shell$actions$es actions = Translations$chat$shell$actions$es._(_root);
	@override String get loading => 'Cargando terminal...';
	@override String get connecting => 'Conectando a la shell...';
	@override String get startSession => 'Iniciar una sesión nueva de Claude';
	@override String resumeSession({required Object displayName}) => 'Reanudar sesión: ${displayName}...';
	@override String runCommand({required Object command, required Object projectName}) => 'Ejecutar ${command} en ${projectName}';
	@override String startCli({required Object projectName}) => 'Iniciando Claude CLI en ${projectName}';
	@override String get defaultCommand => 'comando';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$es extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$es actions = Translations$chat$claudeStatus$actions$es._(_root);
	@override late final Translations$chat$claudeStatus$state$es state = Translations$chat$claudeStatus$state$es._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$es elapsed = Translations$chat$claudeStatus$elapsed$es._(_root);
	@override String get stop => 'Detener';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} tarea en segundo plano en curso',
		other: '${count} tareas en segundo plano en curso',
	);
	@override late final Translations$chat$claudeStatus$controls$es controls = Translations$chat$claudeStatus$controls$es._(_root);
	@override late final Translations$chat$claudeStatus$providers$es providers = Translations$chat$claudeStatus$providers$es._(_root);
	@override String get backgroundTasksTitle => 'En segundo plano';
	@override String get backgroundTaskUnnamed => 'Tarea sin nombre';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$es extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'Selecciona un proyecto para empezar a chatear con ${provider}';
}

// Path: chat.tasks
class Translations$chat$tasks$es extends Translations$chat$tasks$en {
	Translations$chat$tasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Empezar la siguiente tarea';
}

// Path: chat.splitSession
class Translations$chat$splitSession$es extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Dividir sesión';
	@override String get close => 'Cerrar sesión dividida';
	@override String get selectSession => 'Seleccionar sesión para comparar';
	@override String get noOtherSessions => 'No hay otras sesiones disponibles';
	@override String get newSessionOption => '+ Nueva sesión en vista dividida';
	@override String currentProjectGroup({required Object name}) => 'Proyecto actual (${name})';
	@override String get otherProjectsGroup => 'Otros proyectos';
	@override String get recentSessionsGroup => 'Sesiones recientes';
	@override String get startNewSession => 'Iniciar nueva sesión en vista dividida';
	@override String get selectFromList => 'Seleccionar sesión de la lista de sesiones existentes';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$es extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleccionar sesión';
	@override String get searchPlaceholder => 'Buscar sesiones...';
	@override String get clearSearch => 'Borrar búsqueda';
	@override String get newChat => '+ Nuevo chat';
	@override String get archivedToggle => 'Archivadas';
	@override String get changeSession => 'Cambiar sesión';
	@override String get archivedLoading => 'Cargando sesiones archivadas...';
	@override String get archivedError => 'No se pudieron cargar las sesiones archivadas';
	@override String get archivedEmpty => 'No hay sesiones archivadas';
	@override String get archivedProjectOnly => 'Espacio de trabajo archivado — restáuralo para ver sus sesiones.';
	@override String get emptySearch => 'Ninguna sesión coincide con tu búsqueda';
	@override String get restore => 'Restaurar';
	@override String get restoreSession => 'Restaurar sesión';
	@override String get restoreProject => 'Restaurar espacio de trabajo';
	@override String get restoreSessionFailed => 'Error al restaurar la sesión. Inténtalo de nuevo.';
	@override String get restoreProjectFailed => 'Error al restaurar el espacio de trabajo. Inténtalo de nuevo.';
	@override String get archiveFailed => 'Error al archivar la sesión. Inténtalo de nuevo.';
	@override String get deleteFailed => 'Error al eliminar la sesión. Inténtalo de nuevo.';
	@override String get running => 'La sesión está en ejecución';
	@override String get unread => 'Sin leer — finalizada con nueva salida';
	@override String get account => 'Cuenta';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$es extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Añadir panel de chat';
	@override String get addBrowser => 'Añadir panel de navegador';
	@override String get addTerminal => 'Añadir panel de terminal';
	@override String get addPreview => 'Añadir panel de vista previa';
	@override String get overview => 'Mostrar todos los paneles';
	@override String get exitFocusMode => 'Salir del modo enfoque (Ctrl+Mayús+F)';
	@override String get focusMode => 'Modo enfoque (Ctrl+Mayús+F)';
	@override String get broadcast => 'Difundir a sesiones';
	@override String get addNotes => 'Añadir panel de notas compartidas';
	@override String get browseSessions => 'Abrir lista de sesiones';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$es extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vista general de paneles divididos';
	@override String count({required Object count}) => '${count} paneles';
	@override String get close => 'Cerrar vista general';
	@override String get question => 'PREGUNTA — se requiere entrada';
	@override String get processing => 'PROCESANDO';
	@override String get idle => 'Inactivo';
	@override String get active => 'Activa';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$es extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} necesita tu respuesta';
	@override String get skip => 'Omitir';
	@override String get other => 'Otro…';
	@override String get answerHint => 'Escribe tu respuesta…';
}

// Path: chat.attachments
class Translations$chat$attachments$es extends Translations$chat$attachments$en {
	Translations$chat$attachments$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Descarga fallida — clic para reintentar';
	@override String get fileAttachment => 'Archivo adjunto';
	@override String download({required Object name}) => 'Descargar ${name}';
	@override String get attachedFile => 'Archivo adjunto';
	@override String downloaded({required Object name}) => '${name} descargado';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$es extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Creando instantánea…';
	@override String get revertChanges => 'Revertir archivos al último checkpoint';
	@override String get undo => 'Deshacer checkpoint';
	@override String get undoAiRun => 'Deshacer ejecución de la IA';
	@override String get undoing => 'Deshaciendo…';
	@override String get undone => 'Deshecho';
	@override String get beforeAiTurn => 'antes del turno de la IA';
}

// Path: chat.common
class Translations$chat$common$es extends Translations$chat$common$en {
	Translations$chat$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get close => 'Cerrar';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$es extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Tarea';
	@override String get saved => 'Guardado';
	@override String get saving => 'Guardando...';
	@override String get taskShort => 'TAREA';
	@override String get addToTask => 'Añadir a TaskMaster';
	@override String get added => 'Añadido a TaskMaster';
	@override String get defaultTaskTitle => 'Tarea del chat';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$es extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Ver el consumo de tokens de la sesión';
	@override String get title => 'Uso de tokens';
	@override String get notAvailable => 'N/D';
	@override String tokensBadge({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} token',
		other: '${count} tokens',
	);
}

// Path: chat.tool
class Translations$chat$tool$es extends Translations$chat$tool$en {
	Translations$chat$tool$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(sin salida aún — la herramienta devolvió un resultado vacío)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$es extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Límites de suscripción';
	@override String get noData => 'No hay datos de suscripción para este modelo';
	@override String get noSubscription => 'sin suscripción';
	@override String windowLineReset({required Object label, required Object percent, required Object time}) => '${label}: ${percent} % · se restablece ${time}';
	@override String windowRemaining({required Object percent}) => 'Queda el ${percent} % de la ventana antes del restablecimiento';
}

// Path: chat.broadcast
class Translations$chat$broadcast$es extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Difundir a sesiones';
	@override String get noSessions => 'No hay sesiones disponibles';
	@override String get placeholder => 'Mensaje para enviar a cada sesión seleccionada…';
	@override String partial({required Object count}) => '${count} sesión(es) rechazaron el mensaje';
	@override String sent({required Object count}) => 'En cola para ${count} sesión(es)';
	@override String get selectAll => 'Seleccionar todo';
	@override String get selectOrchestrators => 'Seleccionar orquestadores';
	@override String get orchestratorsOnly => 'Solo orquestadores';
	@override String get noOrchestrators => 'No hay sesiones de orquestador disponibles';
	@override String get sending => 'Enviando…';
	@override String send({required Object count}) => 'Enviar a ${count}';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$es extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Procesando…';
	@override String get switchSession => 'Cambiar sesión';
}

// Path: chat.export
class Translations$chat$export$es extends Translations$chat$export$en {
	Translations$chat$export$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Sesión ${id}';
	@override String get pdfFailed => 'Falló la exportación a PDF';
	@override String get transcriptDownloaded => 'Transcripción descargada';
	@override String savedTo({required Object path}) => 'Guardado en ${path}';
}

// Path: chat.commandResult
class Translations$chat$commandResult$es extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$es fallback = Translations$chat$commandResult$fallback$es._(_root);
	@override String get filterCommands => 'Filtrar comandos...';
	@override String searchModels({required Object provider}) => 'Buscar modelos de ${provider}...';
}

// Path: chat.commands
class Translations$chat$commands$es extends Translations$chat$commands$en {
	Translations$chat$commands$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => '¿Ejecutar comando?';
	@override String get executionCancelled => 'Ejecución del comando cancelada';
	@override String get bashConfirmMessage => 'Este comando contiene comandos de bash que se ejecutarán. ¿Quieres continuar?';
	@override String get proceed => 'Continuar';
}

// Path: chat.pinFile
class Translations$chat$pinFile$es extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Fijar archivo';
	@override String get pathHint => 'path/to/file.ext';
	@override String get action => 'Fijar';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$es extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String editTooltip({required Object name}) => 'Editar ${name}';
	@override String deleteTooltip({required Object name}) => 'Eliminar ${name}';
	@override String get enterNameAndId => 'Introduce tanto un nombre de modelo como un ID de modelo.';
	@override String get idNoSpaces => 'Los ID de modelo no pueden contener espacios.';
	@override String get setAsDefault => 'Establecer como predeterminado';
	@override String get defaultModel => 'Modelo predeterminado';
	@override String get title => 'Biblioteca de modelos';
	@override String get subtitle => 'Añade los ID de modelo que admite tu proveedor. Los modelos integrados permanecen bloqueados. El círculo marca el modelo predeterminado.';
	@override String get yourModels => 'Tus modelos';
	@override String get yourModelsHint => 'Editables y guardados en auth.db';
	@override String get emptyTitle => 'Aún no hay modelos personalizados';
	@override String get emptyHint => 'Añade uno con el formulario y aparecerá en todos los selectores de modelo.';
	@override String get builtInModels => 'Modelos integrados';
	@override String get builtInModelsHint => 'Mantenidos por DDAgent y de solo lectura';
	@override String get editTitle => 'Editar modelo personalizado';
	@override String get addTitle => 'Añadir un modelo personalizado';
	@override String idSentAsWritten({required Object provider}) => 'El ID se envía a ${provider} exactamente como está escrito.';
	@override String get nameLabel => 'Nombre del modelo';
	@override String get nameHint => 'p. ej., GPT-5.5 Pro';
	@override String get idLabel => 'ID del modelo';
	@override String get idHint => 'p. ej., gpt-5.5-pro';
	@override String get idHelp => 'Usa el identificador exacto que acepta la CLI del proveedor. Los ID no pueden contener espacios.';
	@override String updatedNotice({required Object name}) => '${name} se ha actualizado.';
	@override String addedNotice({required Object name}) => '${name} se ha añadido.';
	@override String deletedNotice({required Object name}) => '${name} se ha eliminado.';
	@override String get saving => 'Guardando…';
	@override String get saveChanges => 'Guardar cambios';
	@override String get deleteConfirm => '¿Eliminar este modelo de todos los selectores?';
	@override String get customBadge => 'Personalizado';
}

// Path: chat.changes
class Translations$chat$changes$es extends Translations$chat$changes$en {
	Translations$chat$changes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get failedToLoad => 'No se pudieron cargar los cambios';
	@override String get empty => 'Sin cambios en archivos';
}

// Path: chat.message
class Translations$chat$message$es extends Translations$chat$message$en {
	Translations$chat$message$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Resumen compactado';
	@override String get resendHint => 'Vuelve a enviar desde el compositor';
	@override String get rawView => 'Vista sin procesar';
	@override String get runComplete => 'Ejecución completada';
	@override String get runStopped => 'Detenido';
	@override String runFailed({required Object code}) => 'La ejecución falló (salida ${code})';
	@override String get taskKilled => 'Terminada';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$es extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'Solicitud de permiso · ${tool}';
	@override String get question => 'Pregunta';
	@override String get subagent => 'Subagente';
	@override String get viewersCannotApprove => 'Los observadores no pueden aprobar';
	@override late final Translations$chat$permissionRequest$recap$es recap = Translations$chat$permissionRequest$recap$es._(_root);
	@override String needsApproval({required Object tool}) => '${tool} necesita aprobación';
	@override String subagentNeedsApproval({required Object tool}) => 'Subagente: ${tool} necesita aprobación';
	@override String moreQuestions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} pregunta más en espera',
		other: '${count} preguntas más en espera',
	);
}

// Path: chat.commandDialog
class Translations$chat$commandDialog$es extends Translations$chat$commandDialog$en {
	Translations$chat$commandDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandDialog$help$es help = Translations$chat$commandDialog$help$es._(_root);
	@override late final Translations$chat$commandDialog$models$es models = Translations$chat$commandDialog$models$es._(_root);
	@override late final Translations$chat$commandDialog$cost$es cost = Translations$chat$commandDialog$cost$es._(_root);
	@override late final Translations$chat$commandDialog$status$es status = Translations$chat$commandDialog$status$es._(_root);
	@override String get defaultEyebrow => 'Comando';
	@override String get defaultTitle => 'Resultado del comando';
	@override String get escHint => 'Esc cierra la ventana.';
	@override String get unknown => 'Desconocido';
	@override String get noDescription => 'No hay descripción disponible.';
	@override String get noCommandsMatch => 'Ningún comando coincide con ese filtro.';
	@override late final Translations$chat$commandDialog$syntax$es syntax = Translations$chat$commandDialog$syntax$es._(_root);
	@override String get commandFinished => 'Comando finalizado.';
}

// Path: chat.utilities
class Translations$chat$utilities$es extends Translations$chat$utilities$en {
	Translations$chat$utilities$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tokenUsageUnavailable => 'Uso de tokens no disponible';
	@override late final Translations$chat$utilities$tooltip$es tooltip = Translations$chat$utilities$tooltip$es._(_root);
	@override String get used => 'Usados';
	@override String get cacheWrite => 'Escritura en caché';
	@override String get contextLabel => 'Contexto';
	@override String get usageUnsupported => 'uso no admitido';
	@override String get chatTranscript => 'Transcripción del chat';
	@override String get you => 'Tú:';
	@override String get providerAutoMini => 'Auto (mini)';
}

// Path: chat.toolBlocks
class Translations$chat$toolBlocks$es extends Translations$chat$toolBlocks$en {
	Translations$chat$toolBlocks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String moreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '… ${count} línea más',
		other: '… ${count} líneas más',
	);
	@override late final Translations$chat$toolBlocks$status$es status = Translations$chat$toolBlocks$status$es._(_root);
	@override String get showLess => 'Mostrar menos';
	@override String get showMore => 'Mostrar más';
	@override String showMoreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Mostrar ${count} línea más',
		other: 'Mostrar ${count} líneas más',
	);
	@override String get tools => 'Herramientas';
	@override String get planReview => 'Revisión del plan';
	@override String get planUpdate => 'Actualización del plan';
	@override String get todoListUpdated => 'Lista de tareas actualizada';
	@override String get creatingTask => 'Creando tarea';
	@override String get updatingTask => 'actualizando';
	@override String get fetchingTask => 'obteniendo';
	@override String get listingTasks => 'listando tareas';
	@override String get search => 'Buscar';
	@override late final Translations$chat$toolBlocks$verbs$es verbs = Translations$chat$toolBlocks$verbs$es._(_root);
	@override String get subagent => 'Subagente';
	@override String toolCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} herramienta',
		other: '${count} herramientas',
	);
	@override String get result => 'resultado';
	@override String plusMore({required Object count}) => '+${count} más';
	@override String get plan => 'Plan';
	@override String questionProgress({required Object current, required Object total}) => 'Pregunta ${current}/${total}';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} línea',
		other: '${count} líneas',
	);
	@override String todoListItems({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Lista de tareas (${count} elemento)',
		other: 'Lista de tareas (${count} elementos)',
	);
	@override String tasksCompleted({required Object done, required Object total}) => '${done}/${total} completadas';
}

// Path: chat.commandMenu
class Translations$chat$commandMenu$es extends Translations$chat$commandMenu$en {
	Translations$chat$commandMenu$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get empty => 'No hay comandos disponibles';
	@override late final Translations$chat$commandMenu$namespaces$es namespaces = Translations$chat$commandMenu$namespaces$es._(_root);
}

// Path: chat.mentionMenu
class Translations$chat$mentionMenu$es extends Translations$chat$mentionMenu$en {
	Translations$chat$mentionMenu$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$mentionMenu$kinds$es kinds = Translations$chat$mentionMenu$kinds$es._(_root);
	@override String taskTitle({required Object id}) => 'Tarea ${id}';
}

// Path: chat.subheader
class Translations$chat$subheader$es extends Translations$chat$subheader$en {
	Translations$chat$subheader$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String contextTooltip({required Object used, required Object total, required Object percent}) => 'Contexto: ${used} / ${total} tokens · ${percent} % usado';
}

// Path: chat.transcript
class Translations$chat$transcript$es extends Translations$chat$transcript$en {
	Translations$chat$transcript$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get requestFailed => 'La solicitud falló';
}

// Path: chat.review
class Translations$chat$review$es extends Translations$chat$review$en {
	Translations$chat$review$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get changedFiles => 'Archivos modificados';
	@override String changedFilesCount({required Object count}) => 'Archivos modificados (${count})';
	@override String get subagent => 'subagente';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$es extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get changes => 'cambios';
	@override String get previousChange => 'Cambio anterior';
	@override String get nextChange => 'Cambio siguiente';
	@override String get hideDiff => 'Ocultar resaltado de diferencias';
	@override String get showDiff => 'Mostrar resaltado de diferencias';
	@override String get settings => 'Ajustes del editor';
	@override String get collapse => 'Contraer editor';
	@override String get expand => 'Expandir editor a ancho completo';
	@override String get toggleDock => 'Alternar panel de archivos';
	@override String get diffMerge => 'Diff / fusión';
	@override String get previewInBrowser => 'Vista previa en el navegador';
	@override String get reload => 'Recargar desde el disco';
}

// Path: codeEditor.header
class Translations$codeEditor$header$es extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Mostrando cambios';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$es extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Copiar ruta del archivo';
	@override String get pathCopied => 'Ruta del archivo copiada';
	@override String get download => 'Descargar archivo';
	@override String get save => 'Guardar';
	@override String get saving => 'Guardando...';
	@override String get saved => '¡Guardado!';
	@override String get exitFullscreen => 'Salir de pantalla completa';
	@override String get fullscreen => 'Pantalla completa';
	@override String get close => 'Cerrar';
	@override String get previewMarkdown => 'Vista previa de markdown';
	@override String get editMarkdown => 'Editar markdown';
	@override String get pinFile => 'Fijar archivo al contexto';
	@override String get unpinFile => 'Quitar archivo del contexto';
	@override String get previewHtml => 'Abrir vista previa HTML en nueva pestaña';
	@override String get retry => 'Reintentar';
	@override String get saveAll => 'Guardar todo';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$es extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Líneas:';
	@override String get characters => 'Caracteres:';
	@override String get shortcuts => 'Ctrl+S para guardar • Esc para cerrar';
	@override String get plainText => 'texto sin formato';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} línea',
		other: '${count} líneas',
	);
	@override String get modified => 'modificado';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$es extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Archivo binario';
	@override String message({required Object fileName}) => 'El archivo "${fileName}" no se puede mostrar en el editor de texto porque es un archivo binario.';
	@override String get cannotDisplayAsText => 'No se puede mostrar como texto';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$es extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando vista previa...';
	@override String get error => 'No se puede mostrar este archivo.';
	@override String get openInNewTab => 'Abrir en una pestaña nueva';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$es extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Archivo multimedia';
	@override String get subtitle => 'La vista previa de audio y vídeo aún no es compatible';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$es extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… ${size} más';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$es extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get minimap => 'Minimapa';
	@override String tabSize({required Object size}) => 'Tamaño de tabulación: ${size}';
	@override String fontSizeDecrease({required Object size}) => 'Tamaño de fuente −  (ahora ${size})';
	@override String get fontSizeIncrease => 'Tamaño de fuente +';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$es extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get noChanges => 'Sin cambios';
	@override String hunk({required Object number}) => 'Sección ${number}';
	@override String get close => 'Cerrar diff';
	@override String get base => 'Base';
	@override String get current => 'Actual';
	@override String get applyMerge => 'Aplicar fusión';
	@override String get deletedOnDisk => 'eliminado en el disco';
	@override String get untrackedWillBeDeleted => 'Este archivo sin seguimiento se eliminará.';
	@override String restoreConfirm({required Object name}) => '¿Restaurar ${name} a su estado confirmado?';
	@override String get headVsWorkingCopy => 'HEAD frente a copia de trabajo';
	@override String get savedVsBuffer => 'Último guardado frente a búfer (sin git)';
	@override String unchangedLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} línea sin cambios',
		other: '${count} líneas sin cambios',
	);
	@override String get revertToSaved => 'Revertir a lo guardado';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$es extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ningún archivo abierto';
	@override String get hint => 'Abre archivos desde la pestaña Archivos';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$es extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => '${name} guardado';
	@override String get saveFailed => 'Falló el guardado';
	@override String get allSaved => 'Todo guardado';
	@override String get someSavesFailed => 'Algunos guardados fallaron';
	@override String savedTo({required Object path}) => 'Guardado en ${path}';
	@override String get mergeApplied => 'Fusión aplicada — guarda para conservar los cambios';
}

// Path: common.buttons
class Translations$common$buttons$es extends Translations$common$buttons$en {
	Translations$common$buttons$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get save => 'Guardar';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get create => 'Crear';
	@override String get edit => 'Editar';
	@override String get close => 'Cerrar';
	@override String get confirm => 'Confirmar';
	@override String get submit => 'Enviar';
	@override String get retry => 'Reintentar';
	@override String get refresh => 'Actualizar';
	@override String get search => 'Buscar';
	@override String get clear => 'Limpiar';
	@override String get copy => 'Copiar';
	@override String get download => 'Descargar';
	@override String get upload => 'Subir';
	@override String get browse => 'Explorar';
	@override String get update => 'Actualizar';
	@override String get openDiagram => 'Abrir diagrama';
}

// Path: common.tabs
class Translations$common$tabs$es extends Translations$common$tabs$en {
	Translations$common$tabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get shell => 'Shell';
	@override String get files => 'Archivos';
	@override String get git => 'Control de versiones';
	@override String get tasks => 'Tareas';
	@override String get board => 'Tablero';
	@override String get browser => 'Navegador';
	@override String get computer => 'Equipo';
	@override String get usage => 'AI Control';
}

// Path: common.quota
class Translations$common$quota$es extends Translations$common$quota$en {
	Translations$common$quota$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'Centro de control de IA';
	@override late final Translations$common$quota$section$es section = Translations$common$quota$section$es._(_root);
	@override late final Translations$common$quota$filter$es filter = Translations$common$quota$filter$es._(_root);
	@override late final Translations$common$quota$period$es period = Translations$common$quota$period$es._(_root);
	@override late final Translations$common$quota$group$es group = Translations$common$quota$group$es._(_root);
	@override late final Translations$common$quota$metric$es metric = Translations$common$quota$metric$es._(_root);
	@override late final Translations$common$quota$cost$es cost = Translations$common$quota$cost$es._(_root);
	@override late final Translations$common$quota$cost3$es cost3 = Translations$common$quota$cost3$es._(_root);
	@override late final Translations$common$quota$overview$es overview = Translations$common$quota$overview$es._(_root);
	@override late final Translations$common$quota$usage$es usage = Translations$common$quota$usage$es._(_root);
	@override late final Translations$common$quota$agents$es agents = Translations$common$quota$agents$es._(_root);
	@override late final Translations$common$quota$agentStatus$es agentStatus = Translations$common$quota$agentStatus$es._(_root);
	@override late final Translations$common$quota$alert$es alert = Translations$common$quota$alert$es._(_root);
	@override String get backToChat => 'Volver al chat';
	@override String get syncNow => 'Sincronizar ahora';
	@override String generatedAt({required Object value}) => 'Actualizado ${value}';
	@override String get loading => 'Cargando límites de cuenta…';
	@override String remaining({required Object value}) => '${value}% restante';
	@override String resetsIn({required Object value}) => 'se reinicia en ${value}';
	@override String projected({required Object value}) => 'al ritmo actual, este límite se agota en ${value}';
	@override String syncedAgo({required Object value}) => 'sincronizado hace ${value}';
	@override String get refreshAccount => 'Actualizar cuenta';
	@override String get syncFailed => 'Error de sincronización';
	@override String get history => 'Historial';
	@override String historyPoints({required Object value}) => '${value} lecturas registradas';
	@override String get historyEmpty => 'Aún no hay historial registrado';
	@override String get noAgents => 'No hay agentes asignados';
	@override String get noSubscription => 'Sin suscripción';
	@override String get noSubscriptionHint => 'El proveedor no reporta ningún plan activo para esta cuenta.';
	@override late final Translations$common$quota$quality$es quality = Translations$common$quota$quality$es._(_root);
	@override late final Translations$common$quota$kpi$es kpi = Translations$common$quota$kpi$es._(_root);
	@override late final Translations$common$quota$empty$es empty = Translations$common$quota$empty$es._(_root);
	@override late final Translations$common$quota$settings$es settings = Translations$common$quota$settings$es._(_root);
	@override late final Translations$common$quota$range$es range = Translations$common$quota$range$es._(_root);
}

// Path: common.status
class Translations$common$status$es extends Translations$common$status$en {
	Translations$common$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando...';
	@override String get success => 'Éxito';
	@override String get error => 'Error';
	@override String get failed => 'Falló';
	@override String get pending => 'Pendiente';
	@override String get completed => 'Completado';
	@override String get inProgress => 'En curso';
}

// Path: common.messages
class Translations$common$messages$es extends Translations$common$messages$en {
	Translations$common$messages$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Guardado correctamente';
	@override String get deletedSuccessfully => 'Eliminado correctamente';
	@override String get updatedSuccessfully => 'Actualizado correctamente';
	@override String get operationFailed => 'La operación falló';
	@override String get networkError => 'Error de red. Comprueba tu conexión.';
	@override String get unauthorized => 'No autorizado. Inicia sesión.';
	@override String get notFound => 'No encontrado';
	@override String get invalidInput => 'Entrada no válida';
	@override String get requiredField => 'Este campo es obligatorio';
	@override String get unknownError => 'Ocurrió un error desconocido';
	@override String get renameSessionFailed => 'No se pudo renombrar la sesión. Inténtalo de nuevo.';
}

// Path: common.navigation
class Translations$common$navigation$es extends Translations$common$navigation$en {
	Translations$common$navigation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Ajustes';
	@override String get home => 'Inicio';
	@override String get back => 'Atrás';
	@override String get next => 'Siguiente';
	@override String get previous => 'Anterior';
	@override String get logout => 'Cerrar sesión';
	@override String get backToChat => 'Volver al chat';
}

// Path: common.common
class Translations$common$common$es extends Translations$common$common$en {
	Translations$common$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get language => 'Idioma';
	@override String get theme => 'Tema';
	@override String get darkMode => 'Modo oscuro';
	@override String get lightMode => 'Modo claro';
	@override String get name => 'Nombre';
	@override String get description => 'Descripción';
	@override String get enabled => 'Activado';
	@override String get disabled => 'Desactivado';
	@override String get optional => 'Opcional';
	@override String get version => 'Versión';
	@override String get select => 'Seleccionar';
	@override String get selectAll => 'Seleccionar todo';
	@override String get deselectAll => 'Deseleccionar todo';
	@override String get done => 'Hecho';
	@override String get failed => 'Falló';
}

// Path: common.time
class Translations$common$time$es extends Translations$common$time$en {
	Translations$common$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Justo ahora';
	@override String minutesAgo({required Object count}) => 'hace ${count} min';
	@override String hoursAgo({required Object count}) => 'hace ${count} horas';
	@override String daysAgo({required Object count}) => 'hace ${count} días';
	@override String get yesterday => 'Ayer';
}

// Path: common.fileOperations
class Translations$common$fileOperations$es extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Archivo nuevo';
	@override String get newFolder => 'Carpeta nueva';
	@override String get rename => 'Renombrar';
	@override String get move => 'Mover';
	@override String get copyPath => 'Copiar ruta';
	@override String get openInEditor => 'Abrir en el editor';
}

// Path: common.mainContent
class Translations$common$mainContent$es extends Translations$common$mainContent$en {
	Translations$common$mainContent$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando DDAgent';
	@override String get settingUpWorkspace => 'Preparando tu espacio de trabajo...';
	@override String get chooseProject => 'Elige tu proyecto';
	@override String get selectProjectDescription => 'Selecciona un proyecto en la barra lateral para empezar a programar con Claude. Cada proyecto contiene tus sesiones de chat e historial de archivos.';
	@override String get tip => 'Consejo';
	@override String get createProjectMobile => 'Toca el botón de menú de arriba para acceder a los proyectos';
	@override String get createProjectDesktop => 'Crea un proyecto nuevo haciendo clic en el icono de carpeta de la barra lateral';
	@override String get newSession => 'Nueva sesión';
	@override String get untitledSession => 'Sesión sin título';
	@override String get projectFiles => 'Archivos del proyecto';
	@override String get focusMode => 'Modo concentración (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Salir del modo concentración (Ctrl+Shift+F)';
	@override String get splitSession => 'Dividir sesión';
	@override String get closeSplitSession => 'Cerrar sesión dividida';
	@override String get chooseWorkspace => 'Elige un espacio de trabajo';
	@override String get chooseWorkspaceDescription => 'Elige un espacio de trabajo para este chat o crea uno nuevo en Ajustes.';
	@override String get createWorkspace => 'Crear espacio de trabajo en Ajustes';
	@override String get recentProjects => 'Proyectos recientes';
}

// Path: common.fileTree
class Translations$common$fileTree$es extends Translations$common$fileTree$en {
	Translations$common$fileTree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando archivos...';
	@override String get files => 'Archivos';
	@override String get simpleView => 'Vista simple';
	@override String get compactView => 'Vista compacta';
	@override String get detailedView => 'Vista detallada';
	@override String get searchPlaceholder => 'Buscar archivos y carpetas...';
	@override String get searchContentPlaceholder => 'Buscar en archivos...';
	@override String get searchInFiles => 'Buscar en archivos';
	@override String get searchByName => 'Buscar por nombre';
	@override String get clearSearch => 'Limpiar búsqueda';
	@override String get name => 'Nombre';
	@override String get size => 'Tamaño';
	@override String get modified => 'Modificado';
	@override String get permissions => 'Permisos';
	@override String get noFilesFound => 'No se encontraron archivos';
	@override String get checkProjectPath => 'Comprueba si la ruta del proyecto es accesible';
	@override String get loadFailed => 'No se pudieron cargar los archivos';
	@override String get noMatchesFound => 'No se encontraron coincidencias';
	@override String get noSearchResults => 'No se encontraron coincidencias';
	@override String get tryDifferentSearch => 'Prueba con otro término o limpia la búsqueda';
	@override String get searchError => 'Error en la búsqueda';
	@override String get searching => 'Buscando...';
	@override String resultsTruncated({required Object count}) => 'Mostrando los primeros ${count} resultados';
	@override String get justNow => 'justo ahora';
	@override String minAgo({required Object count}) => 'hace ${count} min';
	@override String hoursAgo({required Object count}) => 'hace ${count} horas';
	@override String daysAgo({required Object count}) => 'hace ${count} días';
	@override String get newFile => 'Archivo nuevo (Cmd+N)';
	@override String get newFolder => 'Carpeta nueva (Cmd+Shift+N)';
	@override String get refresh => 'Actualizar';
	@override String get collapseAll => 'Contraer todo';
	@override late final Translations$common$fileTree$context$es context = Translations$common$fileTree$context$es._(_root);
	@override String get allWorkspaces => 'Todos los espacios de trabajo';
	@override late final Translations$common$fileTree$delete$es delete = Translations$common$fileTree$delete$es._(_root);
	@override String get dropToUpload => 'Suelta archivos para subirlos';
	@override String dropToUploadTo({required Object folder}) => 'Suelta archivos para subirlos a «${folder}»';
	@override String get noProject => 'Añade primero un proyecto';
	@override String get noRecentFiles => 'Ningún archivo modificado en los últimos 7 días';
	@override String get showAllFiles => 'Mostrar todos los archivos';
	@override String get showAllFilesHint => 'Desactiva el filtro de recientes para ver todo.';
	@override String get showRecentOnly => 'Mostrar archivos modificados en los últimos 7 días';
	@override late final Translations$common$fileTree$toast$es toast = Translations$common$fileTree$toast$es._(_root);
	@override String get uploadComplete => 'Subida completada';
	@override String get uploadFailed => 'Falló la subida';
	@override String uploadFiles({required Object size}) => 'Subir archivos (máx. ${size} cada uno)';
	@override String uploadToFolder({required Object folder}) => 'Subir archivos a «${folder}»';
	@override String uploadedCount({required Object uploaded, required Object total, required Object label}) => 'Subidos ${uploaded} de ${total} ${label}';
	@override String get uploadingFiles => 'Subiendo archivos';
	@override late final Translations$common$fileTree$validation$es validation = Translations$common$fileTree$validation$es._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$es extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crear proyecto nuevo';
	@override late final Translations$common$projectWizard$steps$es steps = Translations$common$projectWizard$steps$es._(_root);
	@override late final Translations$common$projectWizard$step1$es step1 = Translations$common$projectWizard$step1$es._(_root);
	@override late final Translations$common$projectWizard$step2$es step2 = Translations$common$projectWizard$step2$es._(_root);
	@override late final Translations$common$projectWizard$step3$es step3 = Translations$common$projectWizard$step3$es._(_root);
	@override late final Translations$common$projectWizard$buttons$es buttons = Translations$common$projectWizard$buttons$es._(_root);
	@override late final Translations$common$projectWizard$errors$es errors = Translations$common$projectWizard$errors$es._(_root);
}

// Path: common.notifications
class Translations$common$notifications$es extends Translations$common$notifications$en {
	Translations$common$notifications$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'una herramienta';
	@override late final Translations$common$notifications$codes$es codes = Translations$common$notifications$codes$es._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$es extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Actualización disponible';
	@override String get newVersionReady => 'Hay una versión nueva lista';
	@override String get currentVersion => 'Versión actual';
	@override String get latestVersion => 'Última versión';
	@override String get whatsNew => 'Novedades:';
	@override String get viewFullRelease => 'Ver la publicación completa';
	@override String get updateProgress => 'Progreso de la actualización:';
	@override String get manualUpgrade => 'Actualización manual:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'O haz clic en "Actualizar ahora" para ejecutar la actualización automáticamente.';
	@override String get updateCompleted => '¡Actualización completada correctamente!';
	@override String get restartServer => 'Reinicia el servidor para aplicar los cambios.';
	@override String get updateFailed => 'La actualización falló';
	@override late final Translations$common$versionUpdate$buttons$es buttons = Translations$common$versionUpdate$buttons$es._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$es ariaLabels = Translations$common$versionUpdate$ariaLabels$es._(_root);
}

// Path: common.actions
class Translations$common$actions$es extends Translations$common$actions$en {
	Translations$common$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get retry => 'Reintentar';
	@override String get save => 'Guardar';
}

// Path: common.browserPane
class Translations$common$browserPane$es extends Translations$common$browserPane$en {
	Translations$common$browserPane$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get address => 'Dirección';
	@override String get back => 'Atrás';
	@override String get connecting => 'Conectando al navegador…';
	@override String get connectionFailed => 'Falló la conexión con el navegador.';
	@override String couldNotLoad({required Object url}) => 'No se pudo cargar ${url}';
	@override String get disconnected => 'Vista del navegador desconectada';
	@override String get enterUrl => 'Introduce una URL';
	@override String get forward => 'Adelante';
	@override String get invalidUrl => 'Introduce una URL http(s) válida';
	@override String get noAuthToken => 'No hay token de autenticación disponible.';
	@override String get openExternal => 'Abrir en el navegador del sistema';
	@override String get reload => 'Recargar';
	@override String get retry => 'Reintentar';
	@override String get stop => 'Detener';
}

// Path: common.browserUse
class Translations$common$browserUse$es extends Translations$common$browserUse$en {
	Translations$common$browserUse$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} activas';
	@override String get cancel => 'Cancelar';
	@override String get close => 'Cerrar';
	@override String get delete => 'Eliminar';
	@override String deleteDesc({required Object name}) => '${name} se eliminará permanentemente.';
	@override String get deleteSession => 'Eliminar sesión';
	@override String get deleteTitle => '¿Eliminar la sesión del navegador?';
	@override late final Translations$common$browserUse$empty$es empty = Translations$common$browserUse$empty$es._(_root);
	@override String get emptyStatus => 'vacía';
	@override late final Translations$common$browserUse$errors$es errors = Translations$common$browserUse$errors$es._(_root);
	@override String get fullscreen => 'Pantalla completa';
	@override String get installRuntime => 'Instalar runtime';
	@override String get installing => 'Instalando...';
	@override String get lastAction => 'Última acción';
	@override String get nextSnapshot => 'La próxima captura del navegador del agente aparecerá aquí.';
	@override String get noPageLoaded => 'Ninguna página cargada';
	@override String get noSessions => 'Sin sesiones de navegador de agentes.';
	@override String get none => 'Ninguno';
	@override String get openSettings => 'Abrir ajustes de Browser';
	@override String get profile => 'Perfil';
	@override String get promptLabel => 'Prompt';
	@override late final Translations$common$browserUse$prompts$es prompts = Translations$common$browserUse$prompts$es._(_root);
	@override String get refresh => 'Actualizar sesiones de navegador';
	@override late final Translations$common$browserUse$relative$es relative = Translations$common$browserUse$relative$es._(_root);
	@override late final Translations$common$browserUse$runtime$es runtime = Translations$common$browserUse$runtime$es._(_root);
	@override String get runtimeSetup => 'Se requiere configurar el runtime';
	@override String get selected => 'Seleccionada';
	@override String get sessionFallback => 'Sesión de navegador';
	@override String get sessionScreenshot => 'Captura de la sesión de navegador';
	@override String get sessions => 'Sesiones';
	@override String get status => 'Estado';
	@override String get stop => 'Detener';
	@override String get stopSession => 'Detener sesión';
	@override String get subtitle => 'Supervisa las sesiones de navegador abiertas por agentes de IA.';
	@override String get temporary => 'Temporal';
	@override String get thisSession => 'Esta sesión';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '${count} en total';
	@override String updated({required Object time}) => 'Actualizado ${time}';
	@override String get waiting => 'Esperando';
	@override String get waitingForScreenshot => 'Esperando captura de pantalla';
}

// Path: common.commandPalette
class Translations$common$commandPalette$es extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Volver a todo';
	@override String get backspaceHint => 'Retroceso para volver';
	@override late final Translations$common$commandPalette$browseAll$es browseAll = Translations$common$commandPalette$browseAll$es._(_root);
	@override late final Translations$common$commandPalette$compare$es compare = Translations$common$commandPalette$compare$es._(_root);
	@override late final Translations$common$commandPalette$groups$es groups = Translations$common$commandPalette$groups$es._(_root);
	@override late final Translations$common$commandPalette$hints$es hints = Translations$common$commandPalette$hints$es._(_root);
	@override late final Translations$common$commandPalette$items$es items = Translations$common$commandPalette$items$es._(_root);
	@override late final Translations$common$commandPalette$nav$es nav = Translations$common$commandPalette$nav$es._(_root);
	@override String get noResults => 'Sin resultados.';
	@override late final Translations$common$commandPalette$pages$es pages = Translations$common$commandPalette$pages$es._(_root);
	@override String get placeholder => 'Escribe para buscar…';
	@override String searchPagePlaceholder({required Object page}) => 'Buscar en ${page}…';
	@override String get title => 'Paleta de comandos';
}

// Path: common.gitPanel
class Translations$common$gitPanel$es extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} por delante';
	@override String get aheadLabel => 'por delante';
	@override String get aiSuggest => 'Sugerencia IA';
	@override String get aiSuggestTitle => 'Generar un mensaje de commit con IA';
	@override String get all => 'Todos';
	@override String get allStaged => 'Todos los cambios preparados';
	@override String behind({required Object count}) => '${count} por detrás';
	@override String get behindLabel => 'por detrás';
	@override late final Translations$common$gitPanel$branches$es branches = Translations$common$gitPanel$branches$es._(_root);
	@override String get cancel => 'Cancelar';
	@override String changesCount({required Object count}) => 'Cambios (${count})';
	@override String get clearSearch => 'Limpiar búsqueda';
	@override String get collapseDiff => 'Contraer diff';
	@override String get commit => 'Commit';
	@override String get commitChanges => 'Confirmar cambios';
	@override String commitFiles({required Object count}) => 'Confirmar ${count} archivo(s)';
	@override String get committing => 'Confirmando...';
	@override late final Translations$common$gitPanel$confirmActions$es confirmActions = Translations$common$gitPanel$confirmActions$es._(_root);
	@override String confirmCommit({required Object count, required Object message}) => '¿Confirmar ${count} archivo(s) con el mensaje: «${message}»?';
	@override String confirmDeleteFile({required Object file}) => '¿Eliminar el archivo sin seguimiento «${file}»? No se puede deshacer.';
	@override String confirmDiscardFile({required Object file}) => '¿Descartar todos los cambios en «${file}»? No se puede deshacer.';
	@override String confirmPublish({required Object branch, required Object remote}) => '¿Publicar la rama «${branch}» en ${remote}?';
	@override String confirmPull({required Object count, required Object remote}) => '¿Traer ${count} commit(s) desde ${remote}?';
	@override String confirmPush({required Object count, required Object remote}) => '¿Enviar ${count} commit(s) a ${remote}?';
	@override String get confirmRevert => '¿Revertir el último commit local? Elimina el commit pero mantiene sus cambios preparados.';
	@override late final Translations$common$gitPanel$confirmTitles$es confirmTitles = Translations$common$gitPanel$confirmTitles$es._(_root);
	@override String get createBranch => 'Crear nueva rama';
	@override String get creating => 'Creando...';
	@override String get delete => 'Eliminar';
	@override String get deleteUntracked => 'Eliminar archivo sin seguimiento';
	@override String get deselectAll => 'Deseleccionar todo';
	@override String get discard => 'Descartar';
	@override String get discardChanges => 'Descartar cambios';
	@override String get dismiss => 'Descartar';
	@override String get dismissError => 'Descartar error';
	@override late final Translations$common$gitPanel$errors$es errors = Translations$common$gitPanel$errors$es._(_root);
	@override String get expandDiff => 'Expandir diff';
	@override String get fetch => 'Fetch';
	@override String fetchTitle({required Object remote}) => 'Fetch desde ${remote}';
	@override String get fetching => 'Obteniendo…';
	@override String filesSelected({required Object count}) => '${count} archivo(s) seleccionado(s)';
	@override String get generating => 'Generando...';
	@override late final Translations$common$gitPanel$history$es history = Translations$common$gitPanel$history$es._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$es mergeWorktree = Translations$common$gitPanel$mergeWorktree$es._(_root);
	@override String get merging => 'Fusionando...';
	@override String get messagePlaceholder => 'Mensaje (Ctrl+Intro para confirmar)';
	@override late final Translations$common$gitPanel$newBranch$es newBranch = Translations$common$gitPanel$newBranch$es._(_root);
	@override late final Translations$common$gitPanel$newWorktree$es newWorktree = Translations$common$gitPanel$newWorktree$es._(_root);
	@override String get noChanges => 'No se detectaron cambios';
	@override String get noChangesToCommit => 'No hay cambios que confirmar';
	@override late final Translations$common$gitPanel$noCommits$es noCommits = Translations$common$gitPanel$noCommits$es._(_root);
	@override String get noMatchingBranches => 'No hay ramas coincidentes';
	@override late final Translations$common$gitPanel$noRepo$es noRepo = Translations$common$gitPanel$noRepo$es._(_root);
	@override String get noStagedFiles => 'No hay archivos preparados';
	@override String get none => 'Ninguno';
	@override String nothingToPush({required Object remote}) => 'Nada que enviar a ${remote}';
	@override String get openFile => 'Clic para abrir el archivo';
	@override String get publish => 'Publicar';
	@override String publishTitle({required Object branch, required Object remote}) => 'Publicar «${branch}» en ${remote}';
	@override String get publishing => 'Publicando…';
	@override String get pull => 'Pull';
	@override String pullCount({required Object count}) => 'Pull ${count}';
	@override String pullTitle({required Object count, required Object remote}) => 'Traer ${count} desde ${remote}';
	@override String get pulling => 'Trayendo…';
	@override String get push => 'Push';
	@override String pushCount({required Object count}) => 'Push ${count}';
	@override String pushTitle({required Object count, required Object remote}) => 'Enviar ${count} a ${remote}';
	@override String get pushing => 'Enviando…';
	@override String get recentCommits => 'Commits recientes';
	@override String get refresh => 'Actualizar estado git';
	@override String get remove => 'Eliminar';
	@override late final Translations$common$gitPanel$removeWorktree$es removeWorktree = Translations$common$gitPanel$removeWorktree$es._(_root);
	@override String get removing => 'Eliminando...';
	@override String get revertLatest => 'Revertir último commit local';
	@override String get scroll => 'Desplazamiento';
	@override String get searchBranches => 'Buscar ramas...';
	@override String get selectAll => 'Seleccionar todo';
	@override String get selectProject => 'Selecciona un proyecto para ver el control de código';
	@override String selectedOf({required Object selected, required Object total}) => '${selected} de ${total} archivos seleccionados';
	@override String selectedOfMobile({required Object selected, required Object total}) => '${selected} de ${total} seleccionados';
	@override String get sideBySide => 'Lado a lado';
	@override String get stageAll => 'Preparar todo';
	@override String get stageHunk => 'Preparar esta sección';
	@override String staged({required Object count}) => 'Preparados (${count})';
	@override late final Translations$common$gitPanel$status$es status = Translations$common$gitPanel$status$es._(_root);
	@override String get statusGuide => 'Guía de estados de archivo';
	@override String get switchScroll => 'Cambiar a desplazamiento horizontal';
	@override String get switchSplit => 'Cambiar a vista lado a lado';
	@override String get switchUnified => 'Cambiar a vista unificada';
	@override String get switchWrap => 'Cambiar a ajuste de texto';
	@override String get unified => 'Unificado';
	@override String get unstageAll => 'Quitar preparación de todo';
	@override String get unstageHunk => 'Quitar preparación de esta sección';
	@override String get upToDate => 'Al día';
	@override String upToDateWith({required Object remote}) => 'Al día con ${remote}';
	@override String get viewAll => 'Ver todo';
	@override String get viewsAria => 'Vistas de control de código';
	@override late final Translations$common$gitPanel$worktrees$es worktrees = Translations$common$gitPanel$worktrees$es._(_root);
	@override String get wrap => 'Ajuste';
	@override late final Translations$common$gitPanel$tabs$es tabs = Translations$common$gitPanel$tabs$es._(_root);
	@override String get save => 'Guardar';
	@override late final Translations$common$gitPanel$worktreeScripts$es worktreeScripts = Translations$common$gitPanel$worktreeScripts$es._(_root);
}

// Path: common.sessions
class Translations$common$sessions$es extends Translations$common$sessions$en {
	Translations$common$sessions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Renombrar sesión';
}

// Path: common.projects
class Translations$common$projects$es extends Translations$common$projects$en {
	Translations$common$projects$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Nueva sesión';
}

// Path: common.sharedNotes
class Translations$common$sharedNotes$es extends Translations$common$sharedNotes$en {
	Translations$common$sharedNotes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Memoria compartida — se inyecta en cada sesión de este proyecto';
	@override String get save => 'Guardar';
	@override String get saving => 'Guardando…';
	@override String get noProject => 'Selecciona un espacio de trabajo para editar su contexto compartido';
	@override String get placeholder => '# Contexto compartido\nConvenciones, decisiones y referencias que todo agente debería conocer…';
}

// Path: common.codeBlock
class Translations$common$codeBlock$es extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'Ajustar líneas';
	@override String get noWrap => 'Sin ajuste';
}

// Path: common.update
class Translations$common$update$es extends Translations$common$update$en {
	Translations$common$update$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Actualización disponible · v${version}';
	@override String confirm({required Object version}) => '¿Actualizar a la v${version}? El servidor se actualiza y se reinicia solo — las sesiones activas se interrumpirán.';
	@override String get downloading => 'Descargando y aplicando la actualización…';
	@override String get restarting => 'Reiniciando el servidor — esto tarda un momento…';
	@override String done({required Object version}) => 'Actualizado a la v${version}. Recarga la app para cargar el nuevo paquete.';
	@override String get manualRestart => 'La actualización se aplicó, pero el servidor no se reinició solo — reinícialo manualmente para terminar.';
	@override String get failed => 'La actualización falló.';
	@override String get failedTitle => 'La actualización falló';
	@override String appConfirm({required Object version}) => '¿Instalar DDAgent v${version} en este dispositivo? Android te pedirá permiso para instalar apps desde DDAgent la primera vez.';
	@override String get appPermission => 'Permite «Instalar apps desconocidas» para DDAgent y vuelve a pulsar Actualizar.';
	@override String get chooseTitle => 'Actualizaciones disponibles';
	@override String get targetApp => 'Esta app';
	@override String get targetWeb => 'Interfaz web';
	@override String get targetServer => 'Servidor';
	@override String get updateApp => 'Actualizar app';
	@override String get updateWeb => 'Actualizar interfaz web';
	@override String get updateServer => 'Actualizar servidor';
	@override String webConfirm({required Object version}) => '¿Actualizar la interfaz web a v${version}? La página se recargará después.';
	@override String webDone({required Object version}) => 'Interfaz web actualizada a v${version} — recargando…';
	@override String localServerConfirm({required Object version}) => '¿Actualizar el servidor local de este dispositivo a v${version}? Las sesiones activas se interrumpirán.';
	@override String get localServerUpdating => 'Descargando e iniciando el servidor local…';
	@override String serverDone({required Object version}) => 'El servidor ejecuta v${version}.';
	@override String staged({required Object version}) => 'Actualización v${version} descargada — reinicia el servidor para instalarla.';
	@override String get upToDate => 'El servidor ya tiene la última versión.';
	@override String webHostFailed({required Object message}) => 'El servidor se actualizó, pero su interfaz web no: ${message}';
}

// Path: common.appShell
class Translations$common$appShell$es extends Translations$common$appShell$en {
	Translations$common$appShell$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String panelActive({required Object count}) => 'Panel · ${count} activas';
}

// Path: common.errors
class Translations$common$errors$es extends Translations$common$errors$en {
	Translations$common$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get forbidden => 'Acceso denegado';
}

// Path: settings.changelog
class Translations$settings$changelog$es extends Translations$settings$changelog$en {
	Translations$settings$changelog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Registro de cambios';
	@override String get loading => 'Cargando…';
	@override String get empty => 'No hay versiones para mostrar';
	@override String get current => 'actual';
	@override String get kNew => 'nueva';
}

// Path: settings.server
class Translations$settings$server$es extends Translations$settings$server$en {
	Translations$settings$server$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Servidor';
	@override String get description => 'Reinicia el proceso de DDAgent — útil tras una actualización o si algo se bloquea.';
	@override String get restart => 'Reiniciar';
	@override String get restartConfirm => '¿Reiniciar el servidor DDAgent? Las sesiones activas se interrumpirán.';
	@override String get restarting => 'Reiniciando… la página se recargará cuando el servidor vuelva.';
	@override String get restartFailed => 'El reinicio falló';
	@override String get unsupported => 'El reinicio solo está disponible cuando el servidor se ejecuta bajo el gestor de servicios.';
	@override String get ok => 'OK';
	@override String get restartTitle => 'Reiniciando el servidor';
	@override String get restartRequesting => 'Pidiendo al servidor que se reinicie…';
	@override String restartWaiting({required Object seconds}) => 'Esperando a que el servidor vuelva… (${seconds} s)';
	@override String restartBack({required Object version}) => 'El servidor ha vuelto — versión ${version}.';
	@override String get restartReloading => 'Recargando la página…';
	@override String restartTimeout({required Object seconds}) => 'El servidor no ha vuelto en ${seconds} s. Revisa el registro del servicio (/tmp/ddagent.log) o reinícialo manualmente.';
}

// Path: settings.updates
class Translations$settings$updates$es extends Translations$settings$updates$en {
	Translations$settings$updates$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Actualizaciones';
	@override String get description => 'Busca en GitHub una versión de escritorio más reciente. Las nuevas versiones se descargan automáticamente y se instalan al salir.';
	@override String get descriptionMobile => 'Busca en GitHub una versión más reciente de esta app. Las actualizaciones las instala el instalador del sistema de tu dispositivo.';
	@override String get descriptionServer => 'Busca en GitHub una versión más reciente de DDAgent. El servidor conectado puede actualizarse solo — las sesiones activas se interrumpen mientras se reinicia.';
	@override String get check => 'Buscar actualizaciones';
	@override String get checking => 'Buscando…';
	@override String upToDate({required Object version}) => 'Tienes la última versión (v${version}).';
	@override String available({required Object version}) => 'Actualización v${version} encontrada — descargando en segundo plano; se instalará al cerrar DDAgent.';
	@override String appAvailable({required Object version}) => 'Actualización de la app v${version} disponible — toca Actualizar para instalarla en este dispositivo.';
	@override String downloaded({required Object version}) => 'Actualización v${version} descargada — cierra y reinicia DDAgent para instalarla.';
	@override String get unavailable => 'La búsqueda de actualizaciones solo está disponible en builds de escritorio empaquetados.';
	@override String error({required Object message}) => 'Error al buscar actualizaciones: ${message}';
	@override String get errorGeneric => 'Error al buscar actualizaciones.';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · última v${latest}';
	@override String current({required Object version}) => 'v${version} — actualizada';
	@override String webNotHosted({required Object version}) => 'Esta interfaz web se aloja por separado: sustituye sus archivos por ddagent-flutter-web-v${version}.zip de la versión.';
	@override String get serverCannotUpdate => 'Este servidor no puede actualizarse desde aquí: reinstálalo con install.sh o con un tarball de la versión.';
}

// Path: settings.tabs
class Translations$settings$tabs$es extends Translations$settings$tabs$en {
	Translations$settings$tabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get account => 'Cuenta';
	@override String get permissions => 'Permisos';
	@override String get mcpServers => 'Servidores MCP';
	@override String get skills => 'Skills';
	@override String get appearance => 'Apariencia';
}

// Path: settings.account
class Translations$settings$account$es extends Translations$settings$account$en {
	Translations$settings$account$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cuenta';
	@override String get language => 'Idioma';
	@override String get languageLabel => 'Idioma de la interfaz';
	@override String get languageDescription => 'Elige tu idioma preferido para la interfaz';
	@override String get username => 'Usuario';
	@override String get email => 'Correo electrónico';
	@override String get profile => 'Perfil';
	@override String get changePassword => 'Cambiar contraseña';
}

// Path: settings.mcp
class Translations$settings$mcp$es extends Translations$settings$mcp$en {
	Translations$settings$mcp$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Servidores MCP';
	@override String get addServer => 'Añadir servidor';
	@override String get editServer => 'Editar servidor';
	@override String get deleteServer => 'Eliminar servidor';
	@override String get serverName => 'Nombre del servidor';
	@override String get serverType => 'Tipo de servidor';
	@override String get config => 'Configuración';
	@override String get testConnection => 'Probar conexión';
	@override String get status => 'Estado';
	@override String get connected => 'Conectado';
	@override String get disconnected => 'Desconectado';
	@override late final Translations$settings$mcp$scope$es scope = Translations$settings$mcp$scope$es._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$es extends Translations$settings$appearance$en {
	Translations$settings$appearance$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Apariencia';
	@override String get theme => 'Tema';
	@override String get codeEditor => 'Editor de código';
	@override String get editorTheme => 'Tema del editor';
	@override String get wordWrap => 'Ajuste de línea';
	@override String get showMinimap => 'Mostrar minimapa';
	@override String get lineNumbers => 'Números de línea';
	@override String get fontSize => 'Tamaño de fuente';
	@override late final Translations$settings$appearance$themeModes$es themeModes = Translations$settings$appearance$themeModes$es._(_root);
}

// Path: settings.actions
class Translations$settings$actions$es extends Translations$settings$actions$en {
	Translations$settings$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Guardar cambios';
	@override String get resetToDefaults => 'Restablecer valores por defecto';
	@override String get cancelChanges => 'Cancelar cambios';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$es extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes rápidos';
	@override late final Translations$settings$quickSettings$sections$es sections = Translations$settings$quickSettings$sections$es._(_root);
	@override String get darkMode => 'Modo oscuro';
	@override String get showRawParameters => 'Mostrar parámetros sin procesar';
	@override String get showThinking => 'Mostrar razonamiento';
	@override String get sendByCtrlEnter => 'Enviar con Ctrl+Enter';
	@override String get sendByCtrlEnterDescription => 'Si está activado, Ctrl+Enter envía el mensaje en lugar de solo Enter. Útil para usuarios de IME y evitar envíos accidentales.';
	@override late final Translations$settings$quickSettings$dragHandle$es dragHandle = Translations$settings$quickSettings$dragHandle$es._(_root);
	@override String get sendWithCtrlEnter => 'Enviar con Ctrl+Enter';
	@override String get enterSendsHint => 'Si está desactivado, Enter envía y Shift+Enter inserta un salto de línea.';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$es extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Atajos de terminal';
	@override String get sectionKeys => 'Teclas';
	@override String get sectionNavigation => 'Navegación';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => 'Flecha arriba';
	@override String get arrowDown => 'Flecha abajo';
	@override String get scrollDown => 'Desplazar hacia abajo';
	@override String get killTitle => 'Terminar proceso en ejecución (Ctrl+C)';
	@override late final Translations$settings$terminalShortcuts$handle$es handle = Translations$settings$terminalShortcuts$handle$es._(_root);
	@override String get paste => 'Pegar';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$es extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ajustes';
	@override String get agents => 'Agentes';
	@override String get orchestration => 'Orquestación';
	@override String get miniOrchestration => 'Miniorquestación';
	@override String get appearance => 'Apariencia';
	@override String get workspaces => 'Espacios de trabajo';
	@override String get git => 'Git';
	@override String get apiTokens => 'API y tokens';
	@override String get models => 'Modelos';
	@override String get tasks => 'Tareas';
	@override String get browser => 'Navegador';
	@override String get tools => 'Herramientas';
	@override String get notifications => 'Notificaciones';
	@override String get about => 'Acerca de';
	@override String get quota => 'Centro de control';
	@override String get shortcuts => 'Atajos de teclado';
}

// Path: settings.miniOrchestration
class Translations$settings$miniOrchestration$es extends Translations$settings$miniOrchestration$en {
	Translations$settings$miniOrchestration$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Miniorquestación';
	@override String get description => 'Un pipeline de dos modelos: un pensador no flash planifica y un ejecutor flash ejecuta.';
	@override String get loading => 'Cargando los ajustes de miniorquestación…';
	@override String get loadError => 'No se pudieron cargar los ajustes de miniorquestación.';
	@override late final Translations$settings$miniOrchestration$enable$es enable = Translations$settings$miniOrchestration$enable$es._(_root);
	@override late final Translations$settings$miniOrchestration$thinker$es thinker = Translations$settings$miniOrchestration$thinker$es._(_root);
	@override late final Translations$settings$miniOrchestration$worker$es worker = Translations$settings$miniOrchestration$worker$es._(_root);
	@override late final Translations$settings$miniOrchestration$fields$es fields = Translations$settings$miniOrchestration$fields$es._(_root);
	@override late final Translations$settings$miniOrchestration$roles$es roles = Translations$settings$miniOrchestration$roles$es._(_root);
	@override late final Translations$settings$miniOrchestration$planner$es planner = Translations$settings$miniOrchestration$planner$es._(_root);
}

// Path: settings.orchestration
class Translations$settings$orchestration$es extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Reparte las tareas del chat entre tus proveedores y modelos.';
	@override String get loading => 'Cargando los ajustes de orquestación…';
	@override String get loadError => 'No se pudieron cargar los ajustes de orquestación.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$es enable = Translations$settings$orchestration$enable$es._(_root);
	@override late final Translations$settings$orchestration$pool$es pool = Translations$settings$orchestration$pool$es._(_root);
	@override late final Translations$settings$orchestration$tiers$es tiers = Translations$settings$orchestration$tiers$es._(_root);
	@override late final Translations$settings$orchestration$rules$es rules = Translations$settings$orchestration$rules$es._(_root);
	@override late final Translations$settings$orchestration$planner$es planner = Translations$settings$orchestration$planner$es._(_root);
	@override late final Translations$settings$orchestration$execution$es execution = Translations$settings$orchestration$execution$es._(_root);
	@override late final Translations$settings$orchestration$save$es save = Translations$settings$orchestration$save$es._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$es extends Translations$settings$notifications$en {
	Translations$settings$notifications$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificaciones';
	@override String get description => 'Controla qué eventos de notificación recibes.';
	@override late final Translations$settings$notifications$webPush$es webPush = Translations$settings$notifications$webPush$es._(_root);
	@override late final Translations$settings$notifications$device$es device = Translations$settings$notifications$device$es._(_root);
	@override late final Translations$settings$notifications$desktop$es desktop = Translations$settings$notifications$desktop$es._(_root);
	@override late final Translations$settings$notifications$sound$es sound = Translations$settings$notifications$sound$es._(_root);
	@override late final Translations$settings$notifications$events$es events = Translations$settings$notifications$events$es._(_root);
	@override late final Translations$settings$notifications$messaging$es messaging = Translations$settings$notifications$messaging$es._(_root);
	@override late final Translations$settings$notifications$channels$es channels = Translations$settings$notifications$channels$es._(_root);
	@override String get unpair => 'Desvincular';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$es extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$es darkMode = Translations$settings$appearanceSettings$darkMode$es._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$es codeEditor = Translations$settings$appearanceSettings$codeEditor$es._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$es terminal = Translations$settings$appearanceSettings$terminal$es._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$es extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$es title = Translations$settings$mcpForm$title$es._(_root);
	@override late final Translations$settings$mcpForm$importMode$es importMode = Translations$settings$mcpForm$importMode$es._(_root);
	@override late final Translations$settings$mcpForm$scope$es scope = Translations$settings$mcpForm$scope$es._(_root);
	@override late final Translations$settings$mcpForm$fields$es fields = Translations$settings$mcpForm$fields$es._(_root);
	@override late final Translations$settings$mcpForm$placeholders$es placeholders = Translations$settings$mcpForm$placeholders$es._(_root);
	@override late final Translations$settings$mcpForm$validation$es validation = Translations$settings$mcpForm$validation$es._(_root);
	@override String configDetails({required Object configFile}) => 'Detalles de configuración (de ${configFile})';
	@override String projectPath({required Object path}) => 'Ruta: ${path}';
	@override late final Translations$settings$mcpForm$actions$es actions = Translations$settings$mcpForm$actions$es._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$es extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get success => '¡Ajustes guardados correctamente!';
	@override String get error => 'No se pudieron guardar los ajustes';
	@override String get saving => 'Guardando...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$es extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get save => 'Guardar ajustes';
	@override String get cancel => 'Cancelar';
}

// Path: settings.git
class Translations$settings$git$es extends Translations$settings$git$en {
	Translations$settings$git$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuración de Git';
	@override String get description => 'Configura tu identidad de git para los commits. Estos ajustes se aplicarán globalmente mediante git config --global';
	@override late final Translations$settings$git$name$es name = Translations$settings$git$name$es._(_root);
	@override late final Translations$settings$git$email$es email = Translations$settings$git$email$es._(_root);
	@override late final Translations$settings$git$actions$es actions = Translations$settings$git$actions$es._(_root);
	@override late final Translations$settings$git$status$es status = Translations$settings$git$status$es._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$es extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Claves API';
	@override String get description => 'Genera claves API para acceder a la API externa desde otras aplicaciones.';
	@override late final Translations$settings$apiKeys$newKey$es newKey = Translations$settings$apiKeys$newKey$es._(_root);
	@override late final Translations$settings$apiKeys$form$es form = Translations$settings$apiKeys$form$es._(_root);
	@override String get newButton => 'Nueva clave API';
	@override String get empty => 'Aún no se han creado claves API.';
	@override late final Translations$settings$apiKeys$list$es list = Translations$settings$apiKeys$list$es._(_root);
	@override String get confirmDelete => '¿Seguro que quieres eliminar esta clave API?';
	@override late final Translations$settings$apiKeys$status$es status = Translations$settings$apiKeys$status$es._(_root);
	@override late final Translations$settings$apiKeys$github$es github = Translations$settings$apiKeys$github$es._(_root);
	@override String get apiDocsLink => 'Documentación de la API';
	@override late final Translations$settings$apiKeys$documentation$es documentation = Translations$settings$apiKeys$documentation$es._(_root);
	@override String get loading => 'Cargando...';
	@override late final Translations$settings$apiKeys$version$es version = Translations$settings$apiKeys$version$es._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$es extends Translations$settings$tasks$en {
	Translations$settings$tasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Comprobando la instalación de TaskMaster...';
	@override late final Translations$settings$tasks$notInstalled$es notInstalled = Translations$settings$tasks$notInstalled$es._(_root);
	@override late final Translations$settings$tasks$settings$es settings = Translations$settings$tasks$settings$es._(_root);
}

// Path: settings.agents
class Translations$settings$agents$es extends Translations$settings$agents$en {
	Translations$settings$agents$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$es authStatus = Translations$settings$agents$authStatus$es._(_root);
	@override late final Translations$settings$agents$install$es install = Translations$settings$agents$install$es._(_root);
	@override late final Translations$settings$agents$update$es update = Translations$settings$agents$update$es._(_root);
	@override late final Translations$settings$agents$account$es account = Translations$settings$agents$account$es._(_root);
	@override String get connectionStatus => 'Estado de la conexión';
	@override late final Translations$settings$agents$login$es login = Translations$settings$agents$login$es._(_root);
	@override late final Translations$settings$agents$logout$es logout = Translations$settings$agents$logout$es._(_root);
	@override String error({required Object error}) => 'Error: ${error}';
	@override late final Translations$settings$agents$accounts$es accounts = Translations$settings$agents$accounts$es._(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$es extends Translations$settings$permissions$en {
	Translations$settings$permissions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes de permisos';
	@override late final Translations$settings$permissions$permissionMode$es permissionMode = Translations$settings$permissions$permissionMode$es._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$es extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Servidores MCP';
	@override late final Translations$settings$mcpServers$description$es description = Translations$settings$mcpServers$description$es._(_root);
	@override String get addButton => 'Añadir servidor MCP';
	@override String get empty => 'No hay servidores MCP configurados';
	@override String get serverType => 'Tipo';
	@override late final Translations$settings$mcpServers$scope$es scope = Translations$settings$mcpServers$scope$es._(_root);
	@override late final Translations$settings$mcpServers$config$es config = Translations$settings$mcpServers$config$es._(_root);
	@override late final Translations$settings$mcpServers$tools$es tools = Translations$settings$mcpServers$tools$es._(_root);
	@override late final Translations$settings$mcpServers$actions$es actions = Translations$settings$mcpServers$actions$es._(_root);
	@override late final Translations$settings$mcpServers$managed$es managed = Translations$settings$mcpServers$managed$es._(_root);
	@override late final Translations$settings$mcpServers$help$es help = Translations$settings$mcpServers$help$es._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$es deleteConfirm = Translations$settings$mcpServers$deleteConfirm$es._(_root);
}

// Path: settings.quota
class Translations$settings$quota$es extends Translations$settings$quota$en {
	Translations$settings$quota$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$es settings = Translations$settings$quota$settings$es._(_root);
	@override late final Translations$settings$quota$empty$es empty = Translations$settings$quota$empty$es._(_root);
	@override late final Translations$settings$quota$quality$es quality = Translations$settings$quota$quality$es._(_root);
	@override String get syncFailed => 'Falló la sincronización';
	@override String get syncNow => 'Sincronizar ahora';
}

// Path: settings.browser
class Translations$settings$browser$es extends Translations$settings$browser$en {
	Translations$settings$browser$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get checking => 'comprobando...';
	@override String get description => 'Permite a los agentes crear sesiones de navegador Playwright supervisadas que puedes monitorizar en la pestaña Browser.';
	@override String get enableDescription => 'Registra Browser para los agentes compatibles. Los agentes pueden crear sesiones de navegador; puedes verlas, detenerlas y eliminarlas.';
	@override String get enableLabel => 'Activar Browser';
	@override late final Translations$settings$browser$errors$es errors = Translations$settings$browser$errors$es._(_root);
	@override String get installHint => 'Instala el runtime del navegador antes de que los agentes puedan crear sesiones de Browser.';
	@override String get installRuntime => 'Instalar runtime';
	@override String get installed => 'instalado';
	@override String get installing => 'Instalando...';
	@override String get missing => 'faltante';
	@override String get runtimeRequired => 'Se requiere el runtime del navegador';
	@override String get statusDisabled => 'desactivado';
	@override String get statusLabel => 'Estado';
	@override String get statusReady => 'listo';
	@override String get statusSetupRequired => 'configuración requerida';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$es extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get create => 'Añadir espacio de trabajo';
	@override String get deleteConfirm => '¿Quitar este espacio de trabajo de DDAgent? Sus archivos permanecen en el disco.';
	@override String get deleteFailed => 'No se pudo quitar el espacio de trabajo.';
	@override String get deleteTitle => 'Quitar espacio de trabajo';
	@override String get description => 'Los espacios de trabajo son directorios donde DDAgent puede chatear, ejecutar código y navegar.';
	@override String get remove => 'Quitar espacio de trabajo';
	@override String get title => 'Espacios de trabajo';
	@override String get pathRequired => 'La ruta es obligatoria';
}

// Path: settings.stt
class Translations$settings$stt$es extends Translations$settings$stt$en {
	Translations$settings$stt$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Entrada de voz (voz a texto)';
	@override String get description => 'Endpoint /audio/transcriptions compatible con Whisper (OpenAI, whisper.cpp, faster-whisper, Speaches). Activa el botón de micrófono en el editor.';
	@override String get configured => 'configurado';
	@override String get endpoint => 'URL del endpoint (p. ej. https://api.openai.com/v1)';
	@override String get apiKey => 'Clave de API';
	@override String get model => 'Modelo (predeterminado: whisper-1)';
	@override String get save => 'Guardar';
}

// Path: settings.schedules
class Translations$settings$schedules$es extends Translations$settings$schedules$en {
	Translations$settings$schedules$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Programaciones';
	@override String get description => 'Ejecuciones recurrentes de agentes según un calendario cron. Se lanzan sin supervisión y con los permisos omitidos.';
	@override String get preventSleep => 'Evitar la suspensión mientras se ejecutan agentes';
	@override String get preventSleepHint => 'En escritorio la pantalla se mantiene encendida; en el navegador se usa un bloqueo de activación de pantalla.';
	@override String get kNew => 'Nueva programación';
	@override String get loading => 'Cargando…';
	@override String get empty => 'Aún no hay programaciones.';
	@override String get project => 'Proyecto';
	@override String get provider => 'Proveedor';
	@override String get cron => 'Cron (min hora día mes día de la semana)';
	@override String nextRun({required Object time}) => 'Próxima ejecución: ${time}';
	@override String get cronInvalid => 'No hay próximas ejecuciones para esta expresión';
	@override String get prompt => 'Prompt';
	@override String get useWorktree => 'Ejecutar en un worktree nuevo';
	@override String get catchUp => 'Recuperar ejecuciones perdidas';
	@override String failures({required Object count}) => '${count} fallos';
	@override String get disabled => 'desactivada';
	@override String get history => 'Historial';
	@override String get runNow => 'Ejecutar ahora';
	@override String get delete => 'Eliminar';
	@override String get noRuns => 'Aún no hay ejecuciones.';
	@override String get next => 'próxima';
	@override String get create => 'Crear';
	@override String get toggleSchedule => 'Activar programación';
}

// Path: settings.mcpTokens
class Translations$settings$mcpTokens$es extends Translations$settings$mcpTokens$en {
	Translations$settings$mcpTokens$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tokens del servidor MCP de DDAgent';
	@override String get description => 'Las herramientas externas (Claude Desktop, OpenClaw) llaman a las herramientas de DDAgent mediante POST /mcp con uno de estos tokens bearer.';
	@override String get dismiss => 'Descartar';
	@override String get labelPlaceholder => 'Nombre del token (p. ej. Claude Desktop)';
	@override String get create => 'Crear';
	@override String get empty => 'Aún no hay tokens MCP.';
	@override String lastUsed({required Object time}) => 'usado ${time}';
	@override String get neverUsed => 'nunca usado';
}

// Path: settings.about
class Translations$settings$about$es extends Translations$settings$about$en {
	Translations$settings$about$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Apoya el proyecto';
	@override String get buyMeACoffee => 'Invítame a un café';
	@override String get tryHosted => 'Prueba DDAgent Hosted';
	@override String get learnMore => 'Más información';
	@override String get proFeatures => 'Funciones de DDAgent Pro';
	@override late final Translations$settings$about$pro$es pro = Translations$settings$about$pro$es._(_root);
	@override String get versionInfo => 'Información de versión';
	@override String get client => 'Aplicación';
	@override String get server => 'Servidor';
	@override String get platformMobile => 'Móvil';
	@override String get platformDesktop => 'Escritorio';
	@override String get platformWeb => 'Web';
	@override String get unknown => 'desconocida';
	@override String get copyright => '© 2026 DDAgent — todos los derechos reservados';
	@override String get tagline => 'Interfaz de código abierto para asistentes de programación con IA';
	@override String get docs => 'Documentación';
	@override String get hostedDescription => 'Colaboración en equipo, configuraciones MCP compartidas, sincronización de ajustes entre entornos e infraestructura gestionada.';
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$es extends Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Todos los atajos de teclado de DDAgent, separados por plataforma.';
	@override String get action => 'Acción';
	@override String get winLinux => 'Windows / Linux';
	@override String get mac => 'macOS';
	@override String get navigation => 'Navegación';
	@override String get navWorkspace => 'Ir al espacio de trabajo';
	@override String get navTasks => 'Ir a Tareas / Git';
	@override String get navGit => 'Ir a Git';
	@override String get navFocus => 'Alternar modo enfoque (barra lateral)';
	@override String get navSwitcher => 'Selector rápido de sesiones';
	@override String get navPalette => 'Paleta de comandos';
	@override String get navSettings => 'Abrir ajustes';
	@override String get navClose => 'Cerrar diálogo / restaurar paneles divididos';
	@override String get composer => 'Editor';
	@override String get compSend => 'Enviar mensaje';
	@override String get compNewline => 'Nueva línea';
	@override String get compNav => 'Navegar por las sugerencias';
	@override String get compAccept => 'Aceptar sugerencia';
	@override String get compCloseSuggest => 'Cerrar sugerencias';
	@override String get transcript => 'Transcripción';
	@override String get trCopy => 'Copiar texto seleccionado';
	@override String get trClose => 'Cerrar búsqueda / panel de revisión';
	@override String get terminal => 'Terminal';
	@override String get termCopy => 'Copiar selección';
	@override String get termInterrupt => 'Interrumpir proceso (sin selección)';
	@override String get termPaste => 'Pegar';
	@override String get termSelectAll => 'Seleccionar todo';
	@override String get editor => 'Editor';
	@override String get edSave => 'Guardar archivo';
	@override String get edSaveAll => 'Guardar todos los archivos';
	@override String get edClose => 'Cerrar pestaña';
	@override String get edNextTab => 'Pestaña siguiente';
	@override String get edPrevTab => 'Pestaña anterior';
	@override String get edIndent => 'Aumentar / reducir sangría';
	@override String get palette => 'Paleta de comandos';
	@override String get palNav => 'Navegar por los elementos';
	@override String get palRun => 'Ejecutar / abrir';
	@override String get palBack => 'Atrás (búsqueda vacía)';
	@override String get palClose => 'Cerrar';
}

// Path: sidebar.projects
class Translations$sidebar$projects$es extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Proyectos';
	@override String get newProject => 'Nuevo proyecto';
	@override String get deleteProject => 'Quitar proyecto';
	@override String get renameProject => 'Renombrar proyecto';
	@override String get noProjects => 'No se encontraron proyectos';
	@override String get loadingProjects => 'Cargando proyectos...';
	@override String get searchPlaceholder => 'Buscar proyectos...';
	@override String get projectNamePlaceholder => 'Nombre del proyecto';
	@override String get starred => 'Favoritos';
	@override String get all => 'Todos';
	@override String get untitledSession => 'Sesión sin título';
	@override String get newSession => 'Nueva sesión';
	@override String get codexSession => 'Sesión de Codex';
	@override String get fetchingProjects => 'Obteniendo tus proyectos y sesiones de Claude';
	@override String get projects => 'proyectos';
	@override String get noMatchingProjects => 'No hay proyectos que coincidan';
	@override String get tryDifferentSearch => 'Prueba con otro término de búsqueda';
	@override String get runClaudeCli => 'Ejecuta Claude CLI en el directorio de un proyecto para empezar';
}

// Path: sidebar.app
class Translations$sidebar$app$es extends Translations$sidebar$app$en {
	Translations$sidebar$app$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'Interfaz de asistente de programación con IA';
}

// Path: sidebar.panel
class Translations$sidebar$panel$es extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get open => 'Panel';
	@override String get newChat => 'Nuevo chat';
	@override String get navigation => 'Navegación';
	@override String get sessions => 'Sesiones';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$es extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sesiones';
	@override String get newSession => 'Nueva sesión';
	@override String get deleteSession => 'Eliminar sesión';
	@override String get renameSession => 'Renombrar sesión';
	@override String get noSessions => 'Aún no hay sesiones';
	@override String get loadingSessions => 'Cargando sesiones...';
	@override String get unnamed => 'Sin nombre';
	@override String get loading => 'Cargando...';
	@override String get showMore => 'Mostrar más sesiones';
	@override String get selectMode => 'Seleccionar';
	@override String get selectAll => 'Seleccionar todo';
	@override String archiveSelected({required Object count}) => 'Archivar (${count})';
	@override String deleteSelected({required Object count}) => 'Eliminar (${count})';
	@override String get cancelSelection => 'Cancelar selección';
	@override String get toggleSelection => 'Alternar selección de sesiones';
	@override String get selectionToolbar => 'Acciones de selección de sesiones';
	@override String get options => 'Opciones de sesión';
	@override String get pinSession => 'Fijar sesión';
	@override String get unpinSession => 'Desfijar sesión';
	@override String get pinned => 'Sesión fijada';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} seleccionada',
		other: '${count} seleccionadas',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$es extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Ver entornos';
	@override String get hideSidebar => 'Ocultar barra lateral';
	@override String get createProject => 'Crear proyecto nuevo';
	@override String get refresh => 'Actualizar proyectos y sesiones (Ctrl+R)';
	@override String get renameProject => 'Renombrar proyecto (F2)';
	@override String get deleteProject => 'Quitar proyecto de la barra lateral (Supr)';
	@override String get addToFavorites => 'Añadir a favoritos';
	@override String get removeFromFavorites => 'Quitar de favoritos';
	@override String get editSessionName => 'Editar manualmente el nombre de la sesión';
	@override String get deleteSession => 'Eliminar esta sesión de forma permanente';
	@override String get activeSessionIndicator => 'Sesión activa recientemente (últimos 10 minutos)';
	@override String get save => 'Guardar';
	@override String get cancel => 'Cancelar';
	@override String get clearSearch => 'Limpiar búsqueda';
	@override String get openCommandPalette => 'Abrir paleta de comandos';
	@override String get attentionRequiredIndicator => 'La sesión requiere atención';
	@override String get openSessions => 'Explorar sesiones';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$es extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get files => 'Archivos';
	@override String get git => 'Git';
	@override String get terminal => 'Terminal';
	@override String get tasks => 'Tareas';
}

// Path: sidebar.actions
class Translations$sidebar$actions$es extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Actualizar';
	@override String get settings => 'Ajustes';
	@override String get collapseAll => 'Contraer todo';
	@override String get expandAll => 'Expandir todo';
	@override String get cancel => 'Cancelar';
	@override String get save => 'Guardar';
	@override String get delete => 'Eliminar';
	@override String get rename => 'Renombrar';
	@override String get joinCommunity => 'Unirse a la comunidad';
	@override String get reportIssue => 'Informar de un problema';
	@override String get starOnGithub => 'Dar estrella en GitHub';
	@override String get buyMeACoffee => 'Invítame a un café';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$es extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cambiar el espacio de trabajo de la sesión';
	@override String get description => 'El agente ejecuta sus próximos turnos en este directorio. El historial de sesión existente se conserva.';
	@override String get pathLabel => 'Ruta del espacio de trabajo';
	@override String get pathRequired => 'La ruta del espacio de trabajo es obligatoria.';
	@override String get submit => 'Cambiar espacio de trabajo';
	@override String get saving => 'Cambiando…';
	@override String get changeAction => 'Cambiar espacio de trabajo';
}

// Path: sidebar.branding
class Translations$sidebar$branding$es extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Código abierto';
}

// Path: sidebar.status
class Translations$sidebar$status$es extends Translations$sidebar$status$en {
	Translations$sidebar$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get active => 'Activa';
	@override String get inactive => 'Inactiva';
	@override String get thinking => 'Pensando...';
	@override String get error => 'Error';
	@override String get aborted => 'Cancelada';
	@override String get unknown => 'Desconocido';
}

// Path: sidebar.time
class Translations$sidebar$time$es extends Translations$sidebar$time$en {
	Translations$sidebar$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Justo ahora';
	@override String get oneMinuteAgo => 'hace 1 min';
	@override String minutesAgo({required Object count}) => 'hace ${count} min';
	@override String get oneHourAgo => 'hace 1 hora';
	@override String hoursAgo({required Object count}) => 'hace ${count} horas';
	@override String get oneDayAgo => 'hace 1 día';
	@override String daysAgo({required Object count}) => 'hace ${count} días';
}

// Path: sidebar.messages
class Translations$sidebar$messages$es extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => '¿Seguro que quieres eliminar esto?';
	@override String get renameSuccess => 'Renombrado correctamente';
	@override String get deleteSuccess => 'Eliminado correctamente';
	@override String get errorOccurred => 'Ocurrió un error';
	@override String get deleteSessionConfirm => '¿Seguro que quieres eliminar esta sesión? Esta acción no se puede deshacer.';
	@override String get deleteProjectConfirm => '¿Quitar este proyecto de la barra lateral? Tus archivos, memorias y datos de sesión no se eliminarán.';
	@override String get enterProjectPath => 'Introduce la ruta del proyecto';
	@override String get deleteSessionFailed => 'No se pudo eliminar la sesión. Inténtalo de nuevo.';
	@override String get deleteSessionError => 'Error al eliminar la sesión. Inténtalo de nuevo.';
	@override String get renameSessionFailed => 'No se pudo renombrar la sesión. Inténtalo de nuevo.';
	@override String get renameSessionError => 'Error al renombrar la sesión. Inténtalo de nuevo.';
	@override String get changeWorkspaceFailed => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.';
	@override String get changeWorkspaceError => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.';
	@override String get deleteProjectFailed => 'No se pudo quitar el proyecto. Inténtalo de nuevo.';
	@override String get deleteProjectError => 'Error al quitar el proyecto. Inténtalo de nuevo.';
	@override String get createProjectFailed => 'No se pudo crear el proyecto. Inténtalo de nuevo.';
	@override String get createProjectError => 'Error al crear el proyecto. Inténtalo de nuevo.';
	@override String get updateProjectError => 'Error al actualizar el proyecto. Inténtalo de nuevo.';
	@override String get refreshError => 'No se pudo actualizar. Inténtalo de nuevo.';
	@override String get restoreProjectFailed => 'No se pudo restaurar el proyecto. Inténtalo de nuevo.';
	@override String get restoreProjectError => 'Error al restaurar el proyecto. Inténtalo de nuevo.';
	@override String get restoreSessionFailed => 'No se pudo restaurar la sesión. Inténtalo de nuevo.';
	@override String get restoreSessionError => 'Error al restaurar la sesión. Inténtalo de nuevo.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Error al eliminar ${count} sesión. Inténtalo de nuevo.',
		other: 'Error al eliminar ${count} sesiones. Inténtalo de nuevo.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$es extends Translations$sidebar$version$en {
	Translations$sidebar$version$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Actualización disponible';
	@override String get restartRequired => 'Actualización instalada — reinicia el servidor para aplicarla';
	@override String get updateNow => 'Actualizar ahora';
	@override String updateConfirm({required Object version}) => '¿Actualizar DDAgent a v${version}? Se descargará y compilará el código más reciente y el servidor se reiniciará — las sesiones activas se interrumpirán.';
	@override String get updating => 'Actualizando… puede tardar unos minutos';
	@override String get restarting => 'Actualización instalada — reiniciando…';
	@override String get updateFailed => 'La actualización falló';
	@override String get releaseNotes => 'Notas de la versión';
}

// Path: sidebar.search
class Translations$sidebar$search$es extends Translations$sidebar$search$en {
	Translations$sidebar$search$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Proyectos';
	@override String get modeConversations => 'Conversaciones';
	@override String get conversationsPlaceholder => 'Buscar en conversaciones...';
	@override String get searching => 'Buscando...';
	@override String get sessionTitles => 'Títulos de sesiones';
	@override String get conversationContents => 'Contenido de conversaciones';
	@override String get noResults => 'No se encontraron resultados';
	@override String get tryDifferentQuery => 'Prueba con otra búsqueda';
	@override String get modeRunning => 'En curso';
	@override String get archiveOnly => 'Archivo';
	@override String get runningTooltip => 'Sesiones activas';
	@override String get archiveOnlyTooltip => 'Solo archivadas';
	@override String runningCount({required Object count}) => '${count} activas';
	@override String get viewMenu => 'Vista';
	@override String get backToProjects => 'Volver a proyectos';
	@override String get archivedPlaceholder => 'Buscar sesiones archivadas...';
	@override String get runningPlaceholder => 'Buscar sesiones activas...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} coincidencia',
		other: '${count} coincidencias',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} proyecto examinado',
		other: '${count} proyectos examinados',
	);
}

// Path: sidebar.recent
class Translations$sidebar$recent$es extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conversaciones recientes';
	@override String get emptyTitle => 'Aún no hay conversaciones';
	@override String get emptyDescription => 'Tus conversaciones actualizadas más recientemente aparecerán aquí.';
	@override String get loadFailed => 'No se pudieron cargar las conversaciones recientes';
	@override String get loadMore => 'Cargar conversaciones anteriores';
	@override String get loadingMore => 'Cargando más...';
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$es extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Quitar proyecto';
	@override String get deleteSession => 'Eliminar sesión';
	@override String get confirmDelete => '¿Qué quieres hacer con';
	@override String get removeFromSidebar => 'Solo quitar de la barra lateral';
	@override String get deleteAllData => 'Eliminar todos los datos permanentemente';
	@override String get allConversationsDeleted => 'El proyecto se quitará de la barra lateral. Tus archivos, memorias y datos de sesión se conservarán.';
	@override String get cannotUndo => 'Puedes volver a añadir el proyecto más tarde.';
	@override String get bulkDeleteSessionsDescription => 'Archivar oculta las sesiones seleccionadas de la lista activa conservando sus historiales.';
	@override String get archiveSession => 'Archivar sesión';
	@override String get archiveSessionNotice => 'Archivar mantiene la sesión fuera de la lista activa conservando su historial.';
	@override String get archivedSessionNotice => 'Esta sesión ya está archivada. Puedes mantenerla oculta o eliminarla permanentemente.';
	@override String get deleteSessionNotice => 'Esto elimina permanentemente la sesión y su transcripción. Esta acción no se puede deshacer.';
	@override String get deleteSessionPermanently => 'Eliminar permanentemente';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Este proyecto contiene ${count} conversación.',
		other: 'Este proyecto contiene ${count} conversaciones.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Gestionar sesión seleccionada',
		other: 'Gestionar ${count} sesiones seleccionadas',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Archivar sesión',
		other: 'Archivar ${count} sesiones',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$es extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Activos ahora';
	@override String get recent => 'Usados recientemente';
	@override String get today => 'Hoy';
	@override String get yesterday => 'Ayer';
	@override String get thisWeek => 'Esta semana';
	@override String showMore({required Object count}) => 'Mostrar ${count} más';
	@override String get showLess => 'Mostrar menos';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$es extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get board => 'Panel de agentes';
	@override String get files => 'Archivos';
	@override String get git => 'Control de código';
	@override String get tasks => 'Tareas';
	@override String get usage => 'Cuota y uso';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$es extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI no está configurado';
	@override String get description => 'TaskMaster ayuda a descomponer proyectos complejos en tareas manejables con asistencia de IA';
	@override String get whatIsTitle => '🎯 ¿Qué es TaskMaster?';
	@override late final Translations$tasks$notConfigured$features$es features = Translations$tasks$notConfigured$features$es._(_root);
	@override String get initializeButton => 'Inicializar TaskMaster AI';
	@override String get writePrdFirst => 'Escribe primero un PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$es extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Primeros pasos con TaskMaster';
	@override String get subtitle => '¡TaskMaster está inicializado! Esto es lo que puedes hacer ahora:';
	@override late final Translations$tasks$gettingStarted$steps$es steps = Translations$tasks$gettingStarted$steps$es._(_root);
	@override String get tip => '💡 Consejo: empieza con un PRD para sacar el máximo partido a la generación de tareas con IA de TaskMaster';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$es extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuración de TaskMaster';
	@override String subtitle({required Object projectName}) => 'CLI interactiva para ${projectName}';
	@override String get willStart => 'La inicialización de TaskMaster comenzará automáticamente';
	@override String get completed => '¡Configuración de TaskMaster completada! Ya puedes cerrar esta ventana.';
	@override String get closeButton => 'Cerrar';
	@override String get closeContinueButton => 'Cerrar y continuar';
	@override String get closeTitle => 'Cerrar';
	@override String get description => 'Crea una carpeta .taskmaster en este proyecto. No requiere herramientas externas ni claves API — las tareas se guardan localmente.';
	@override String get initializeButton => 'Inicializar';
	@override String get initializing => 'Inicializando...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$es extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Primeros pasos con TaskMaster';
	@override String get subtitle => 'Tu guía para una gestión de tareas productiva';
	@override late final Translations$tasks$helpGuide$examples$es examples = Translations$tasks$helpGuide$examples$es._(_root);
	@override String get moreExamples => 'Ver más ejemplos y patrones de uso →';
	@override late final Translations$tasks$helpGuide$proTips$es proTips = Translations$tasks$helpGuide$proTips$es._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$es learnMore = Translations$tasks$helpGuide$learnMore$es._(_root);
	@override String get closeTitle => 'Cerrar';
}

// Path: tasks.search
class Translations$tasks$search$es extends Translations$tasks$search$en {
	Translations$tasks$search$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Buscar tareas...';
}

// Path: tasks.filters
class Translations$tasks$filters$es extends Translations$tasks$filters$en {
	Translations$tasks$filters$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get button => 'Filtros';
	@override String get status => 'Estado';
	@override String get priority => 'Prioridad';
	@override String get sortBy => 'Ordenar por';
	@override String get allStatuses => 'Todos los estados';
	@override String get allPriorities => 'Todas las prioridades';
	@override String showing({required Object filtered, required Object total}) => 'Mostrando ${filtered} de ${total} tareas';
	@override String get clearFilters => 'Limpiar filtros';
}

// Path: tasks.sort
class Translations$tasks$sort$es extends Translations$tasks$sort$en {
	Translations$tasks$sort$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Estado';
	@override String get priority => 'Prioridad';
	@override String get idAsc => 'ID (ascendente)';
	@override String get idDesc => 'ID (descendente)';
	@override String get titleAsc => 'Título (A-Z)';
	@override String get titleDesc => 'Título (Z-A)';
	@override String get statusAsc => 'Estado (pendientes primero)';
	@override String get statusDesc => 'Estado (completadas primero)';
	@override String get priorityAsc => 'Prioridad (alta primero)';
	@override String get priorityDesc => 'Prioridad (baja primero)';
}

// Path: tasks.views
class Translations$tasks$views$es extends Translations$tasks$views$en {
	Translations$tasks$views$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Vista Kanban';
	@override String get list => 'Vista de lista';
	@override String get grid => 'Vista de cuadrícula';
}

// Path: tasks.kanban
class Translations$tasks$kanban$es extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 Por hacer';
	@override String get inProgress => '🚀 En curso';
	@override String get review => '👀 Revisión';
	@override String get done => '✅ Hechas';
	@override String get blocked => '🚫 Bloqueadas';
	@override String get deferred => '⏳ Aplazadas';
	@override String get cancelled => '❌ Canceladas';
	@override String get noTasksYet => 'Aún no hay tareas';
	@override String get tasksWillAppear => 'Las tareas aparecerán aquí';
	@override String get moveTasksHere => 'Mueve las tareas aquí cuando empiecen';
	@override String get completedTasksHere => 'Las tareas completadas aparecen aquí';
	@override String get statusTasksHere => 'Las tareas con este estado aparecerán aquí';
}

// Path: tasks.buttons
class Translations$tasks$buttons$es extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get help => 'Guía de primeros pasos de TaskMaster';
	@override String get prds => 'PRDs';
	@override String get addPRD => 'Añadir PRD';
	@override String get addTask => 'Añadir tarea';
	@override String get createNewPRD => 'Crear PRD nuevo';
	@override String prdsAvailable({required Object count}) => '${count} PRD(s) disponibles';
}

// Path: tasks.prd
class Translations$tasks$prd$es extends Translations$tasks$prd$en {
	Translations$tasks$prd$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Modificado: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String get newFile => 'archivo nuevo';
	@override String get template => 'Plantilla';
	@override String get parse => 'Analizar PRD';
	@override String get fileExistsTitle => 'El archivo ya existe';
	@override String fileExistsMessage({required Object name}) => 'Ya existe un PRD llamado «${name}». ¿Quieres sobrescribirlo?';
	@override String get fileNameHint => 'nombre de archivo (p. ej., prd.txt)';
	@override String get saved => 'PRD guardado';
	@override String get tasksGenerated => 'Tareas generadas desde el PRD';
}

// Path: tasks.statuses
class Translations$tasks$statuses$es extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Pendiente';
	@override String get inProgress => 'En curso';
	@override String get done => 'Hecha';
	@override String get blocked => 'Bloqueada';
	@override String get deferred => 'Aplazada';
	@override String get cancelled => 'Cancelada';
	@override String get review => 'Revisión';
}

// Path: tasks.priorities
class Translations$tasks$priorities$es extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get high => 'Alta';
	@override String get medium => 'Media';
	@override String get low => 'Baja';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$es extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ninguna tarea coincide con tus filtros';
	@override String get description => 'Prueba a ajustar la búsqueda o los criterios de filtrado.';
}

// Path: tasks.board
class Translations$tasks$board$es extends Translations$tasks$board$en {
	Translations$tasks$board$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tablero de agentes';
	@override String get subtitle => 'Mueve una tarjeta a Lista y el agente la toma. Haz clic en una tarjeta para abrir su sesión.';
	@override String get newCard => 'Nueva tarjeta';
	@override String get addCard => 'Añadir tarjeta';
	@override String get refresh => 'Actualizar';
	@override late final Translations$tasks$board$empty$es empty = Translations$tasks$board$empty$es._(_root);
	@override late final Translations$tasks$board$columns$es columns = Translations$tasks$board$columns$es._(_root);
	@override late final Translations$tasks$board$card$es card = Translations$tasks$board$card$es._(_root);
	@override late final Translations$tasks$board$dialog$es dialog = Translations$tasks$board$dialog$es._(_root);
	@override String get noProject => 'Añade primero un proyecto y luego crea tarjetas para él.';
	@override String get projectLabel => 'Proyecto';
	@override String get backToChat => 'Volver al chat';
	@override late final Translations$tasks$board$agent$es agent = Translations$tasks$board$agent$es._(_root);
	@override late final Translations$tasks$board$deleteConfirm$es deleteConfirm = Translations$tasks$board$deleteConfirm$es._(_root);
	@override String get project => 'Proyecto';
	@override late final Translations$tasks$board$assignee$es assignee = Translations$tasks$board$assignee$es._(_root);
	@override late final Translations$tasks$board$presence$es presence = Translations$tasks$board$presence$es._(_root);
	@override late final Translations$tasks$board$activity$es activity = Translations$tasks$board$activity$es._(_root);
	@override late final Translations$tasks$board$comments$es comments = Translations$tasks$board$comments$es._(_root);
}

// Path: tasks.card
class Translations$tasks$card$es extends Translations$tasks$card$en {
	Translations$tasks$card$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Depende de: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Tarea ${id}';
	@override String get highPriority => 'Prioridad alta';
	@override String get lowPriority => 'Prioridad baja';
	@override String get mediumPriority => 'Prioridad media';
	@override String get noPriority => 'Sin prioridad definida';
	@override String parentTask({required Object id}) => 'Tarea ${id}';
	@override String get progressLabel => 'Progreso:';
	@override String progressTooltip({required Object completed, required Object total}) => '${completed} de ${total} subtareas completadas';
	@override String get runTask => 'Ejecutar tarea';
	@override String runTaskAria({required Object id}) => 'Ejecutar tarea ${id}';
	@override String statusTooltip({required Object status}) => 'Estado: ${status}';
	@override String taskIdTitle({required Object id}) => 'ID de tarea: ${id}';
	@override String get taskInProgress => 'Tarea en curso';
}

// Path: tasks.createTask
class Translations$tasks$createTask$es extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get descriptionLabel => 'Descripción';
	@override String get descriptionPlaceholder => 'Detalles opcionales';
	@override String get error => 'No se pudo añadir la tarea';
	@override String get priorityLabel => 'Prioridad';
	@override String get submit => 'Añadir tarea';
	@override String get submitting => 'Añadiendo...';
	@override String get title => 'Añadir tarea';
	@override String get titleLabel => 'Título';
	@override String get titlePlaceholder => '¿Qué hay que hacer?';
}

// Path: tasks.list
class Translations$tasks$list$es extends Translations$tasks$list$en {
	Translations$tasks$list$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Completada (clic para reabrir)';
	@override String get inProgressComplete => 'En curso (clic para completar)';
	@override String get markCompleted => 'Marcar como completada';
	@override String toggleStatusAria({required Object id}) => 'Alternar estado de la tarea ${id}';
	@override String get markDone => 'Marcar como completada';
	@override String get reopen => 'Reabrir';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$es extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Todas las tareas completadas';
	@override String get feature1 => '- Gestión de tareas con IA, dependencias y subtareas.';
	@override String get feature2 => '- Generación de tareas desde PRD para un arranque más rápido.';
	@override String get feature3 => '- Vistas kanban y lista para el día a día.';
	@override String get hideDetails => 'Ocultar detalles';
	@override String get initialize => 'Inicializar';
	@override String get noPending => 'No hay tareas pendientes';
	@override String get notConfigured => 'TaskMaster AI no está configurado';
	@override String get review => 'Revisar';
	@override String get startTask => 'Iniciar tarea';
	@override String taskId({required Object id}) => 'Tarea ${id}';
	@override String get viewAll => 'Ver todas las tareas';
	@override String get viewDetails => 'Ver detalles de la tarea';
	@override String get whatIs => '¿Qué es TaskMaster?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$es extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Cancelar edición';
	@override String get close => 'Cerrar';
	@override String get copyTaskId => 'Copiar ID de tarea';
	@override String get delete => 'Eliminar tarea';
	@override String deleteConfirmDescription({required Object title}) => '"${title}" se eliminará permanentemente.';
	@override String get deleteConfirmTitle => '¿Eliminar tarea?';
	@override String get deleteFailed => 'No se pudo eliminar la tarea';
	@override String get dependencies => 'Dependencias';
	@override String get dependenciesPlaceholder => 'p. ej. 1, 2, 3';
	@override String get description => 'Descripción';
	@override String get edit => 'Editar tarea';
	@override String get implDetails => 'Detalles de implementación';
	@override String get noDependencies => 'Sin dependencias';
	@override String get noDescription => 'Sin descripción';
	@override String get priority => 'Prioridad';
	@override String get priorityNotSet => 'No definida';
	@override String get save => 'Guardar';
	@override String get status => 'Estado';
	@override String get statusFailed => 'No se pudo actualizar el estado de la tarea';
	@override String taskId({required Object id}) => 'Tarea ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Tarea ${id}: ${title}';
	@override String get testStrategy => 'Estrategia de pruebas';
	@override String get titleRequired => 'El título es obligatorio';
	@override String get updateFailed => 'No se pudo actualizar la tarea';
	@override String get notFound => 'Tarea no encontrada';
	@override String get subtasks => 'Subtareas';
	@override String deleteConfirmMessage({required Object id}) => 'Se eliminará la tarea n.º ${id}. Esta acción no se puede deshacer.';
	@override String get idCopied => 'ID de tarea copiado';
}

// Path: tasks.toasts
class Translations$tasks$toasts$es extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Tarea ${id} marcada como en curso';
}

// Path: tasks.taskmaster
class Translations$tasks$taskmaster$es extends Translations$tasks$taskmaster$en {
	Translations$tasks$taskmaster$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get noProjectHint => 'Primero añade un proyecto y luego crea tareas para él.';
	@override late final Translations$tasks$taskmaster$sort$es sort = Translations$tasks$taskmaster$sort$es._(_root);
	@override String installedVersion({required Object version}) => 'Instalado: ${version}';
	@override String get initFailed => 'No se pudo inicializar TaskMaster';
	@override late final Translations$tasks$taskmaster$prd$es prd = Translations$tasks$taskmaster$prd$es._(_root);
	@override late final Translations$tasks$taskmaster$detail$es detail = Translations$tasks$taskmaster$detail$es._(_root);
	@override String get untitledTask => 'Tarea sin título';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$es extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Panel';
	@override String get memories => 'Recuerdos';
	@override String get rules => 'Reglas';
	@override String get skills => 'Habilidades';
	@override String get personal => 'Personal';
	@override String get graph => 'Grafo';
}

// Path: knowledge.common
class Translations$knowledge$common$es extends Translations$knowledge$common$en {
	Translations$knowledge$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get add => 'Añadir';
	@override String get save => 'Guardar';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get edit => 'Editar';
	@override String get close => 'Cerrar';
	@override String get restore => 'Restaurar';
	@override String get refresh => 'Actualizar';
	@override String get allProjects => 'Todos los proyectos';
	@override String get global => 'Global';
}

// Path: knowledge.actions
class Translations$knowledge$actions$es extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Escanear archivos del proyecto';
	@override String get export => 'Exportar JSON';
	@override String get import => 'Importar JSON';
	@override String get scanComplete => 'Escaneo completado';
	@override String get importComplete => 'Importación completada';
	@override String get importFailed => 'La importación falló';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$es extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Nueva entrada';
	@override String get editEntity => 'Editar entrada';
	@override String get deleteTitle => 'Eliminar';
	@override String get deleteMessage => '¿Eliminar esta entrada? No se puede deshacer (se conserva el historial).';
	@override String get pickIcon => 'Elegir icono';
	@override String get removeIcon => 'Quitar icono';
	@override String get iconTooLarge => 'El icono es demasiado grande (máx. 40 KB).';
	@override String get importTitle => 'Importar conocimiento';
	@override String get importHint => 'Pega aquí el JSON exportado';
	@override String get exportTitle => 'Exportar conocimiento';
	@override String get import => 'Importar';
}

// Path: knowledge.fields
class Translations$knowledge$fields$es extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get key => 'Clave';
	@override String get title => 'Título';
	@override String get name => 'Nombre';
	@override String get description => 'Descripción';
	@override String get category => 'Categoría';
	@override String get content => 'Contenido';
	@override String get priority => 'Prioridad';
	@override String get tags => 'Etiquetas';
	@override String get enabled => 'Activado';
	@override String get projectScope => 'Ámbito del proyecto';
	@override String get tagsHint => 'separadas por comas';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$es extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Recuerdos';
	@override String get rules => 'Reglas';
	@override String get skills => 'Habilidades';
	@override String get personal => 'Personal';
	@override String get connections => 'Conexiones';
	@override String get recent => 'Recuerdos recientes';
	@override String get noMemories => 'Aún no hay recuerdos. Añade uno en la pestaña Recuerdos.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$es extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Aún no hay recuerdos.';
	@override String get rules => 'Aún no hay reglas.';
	@override String get skills => 'Aún no hay habilidades.';
	@override String get personal => 'Aún no hay información personal.';
	@override String get graph => 'Aún no hay entidades para el grafo.';
}

// Path: knowledge.history
class Translations$knowledge$history$es extends Translations$knowledge$history$en {
	Translations$knowledge$history$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Historial';
	@override String get none => 'Aún no hay historial.';
	@override String get untitled => '(sin título)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$es extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Crítica';
	@override String get high => 'Alta';
	@override String get normal => 'Normal';
	@override String get low => 'Baja';
}

// Path: knowledge.search
class Translations$knowledge$search$es extends Translations$knowledge$search$en {
	Translations$knowledge$search$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Buscar en conocimiento';
	@override String get hint => 'Buscar recuerdos, reglas, habilidades…';
	@override String get noResults => 'Sin resultados.';
}

// Path: knowledge.links
class Translations$knowledge$links$es extends Translations$knowledge$links$en {
	Translations$knowledge$links$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vincular entidades';
	@override String get source => 'Origen';
	@override String get target => 'Destino';
	@override String get relationship => 'Relación';
	@override String get add => 'Crear vínculo';
}

// Path: knowledge.tags
class Translations$knowledge$tags$es extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get all => 'Todas las etiquetas';
	@override String get manage => 'Gestionar etiquetas';
	@override String get none => 'Aún no hay etiquetas.';
}

// Path: knowledge.graph
class Translations$knowledge$graph$es extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'truncado';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$es extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Importar todo a DDAgent';
	@override String projectsScanned({required Object count}) => 'Proyectos examinados: ${count}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Skills de agentes encontradas: ${found} (nuevas: ${newSkills})';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Reglas: ${total} · grupos duplicados: ${duplicates}';
	@override String get mergeDuplicates => 'Fusionar entradas duplicadas';
	@override String get mergeDuplicatesHint => 'Combina las filas duplicadas en DDAgent (no los archivos)';
	@override String get action => 'Importar todo';
	@override String get readOnlyNotice => 'Solo lectura para tus agentes: esto importa en la base de datos propia de DDAgent y NO modifica ni elimina ningún archivo ni configuración de las CLI. Las opciones de abajo solo cambian datos de DDAgent.';
	@override String get dryRunNote => 'Simulación: aún no se ha escrito nada.';
	@override String get importedNote => 'Importado.';
	@override String result({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'Importado: reglas: ${rules}, habilidades nuevas: ${newSkills}, eliminadas: ${removed}, promovidas: ${promoted}';
	@override String get description => 'Analiza todos los proyectos e importa las habilidades de tus agentes a la base de conocimiento. Solo lectura para tus agentes: no se cambia nada en las CLI.';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$es extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Migrar reglas existentes';
	@override String scanned({required Object count}) => 'Se examinaron ${count} proyectos.';
	@override String rulesSummary({required Object total, required Object critical}) => 'Reglas: ${total} en total, ${critical} críticas.';
	@override String duplicates({required Object count}) => 'Grupos duplicados entre proyectos: ${count}';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Eliminadas: ${removed}, promovidas: ${promoted}';
	@override String get mergeDuplicates => 'Fusionar duplicados';
	@override String get dryRunNote => 'Simulación: aún no se ha cambiado nada.';
	@override String get applied => 'Aplicado.';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$es extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Importar skills de agentes';
	@override String found({required Object count}) => 'Se encontraron ${count} skills en tus agentes.';
	@override String summary({required Object imported, required Object skipped}) => 'Nuevas: ${imported} · omitidas: ${skipped}';
	@override String get dryRunHint => 'Importa las habilidades globales/predeterminadas de tus agentes (usuario, sistema, plugin) como habilidades de conocimiento. Simulación: aún no se ha importado nada.';
	@override String get importedNote => 'Importado a la base de conocimiento.';
}

// Path: knowledge.critical
class Translations$knowledge$critical$es extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get make => 'Marcar como crítica';
	@override String get makeAll => 'Marcar todas las reglas como críticas';
	@override String get makeAllHint => 'Las añade al presupuesto de contexto inyectado';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$es extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
	@override String get title => 'Contexto de reglas (siempre incluido)';
	@override String get selectProject => 'Selecciona un proyecto para ver el tamaño de su contexto crítico.';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$es extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Memoria: ${title}';
	@override String rule({required Object title}) => 'Regla: ${title}';
	@override String skill({required Object name}) => 'Skill: ${name}';
	@override String personal({required Object title}) => 'Personal: ${title}';
}

// Path: knowledge.errors
class Translations$knowledge$errors$es extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'La importación falló: ${error}';
	@override String migrationFailed({required Object error}) => 'La migración falló: ${error}';
}

// Path: knowledge.entityTypes
class Translations$knowledge$entityTypes$es extends Translations$knowledge$entityTypes$en {
	Translations$knowledge$entityTypes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get memory => 'Memoria';
	@override String get rule => 'Regla';
	@override String get skill => 'Habilidad';
	@override String get personal => 'Personal';
	@override String get project => 'Proyecto';
	@override String get tag => 'Etiqueta';
}

// Path: collab.roles
class Translations$collab$roles$es extends Translations$collab$roles$en {
	Translations$collab$roles$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get member => 'Miembro';
	@override String get viewer => 'Lector';
}

// Path: collab.viewing
class Translations$collab$viewing$es extends Translations$collab$viewing$en {
	Translations$collab$viewing$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get session => 'sesión';
	@override String get card => 'tarjeta';
	@override String get board => 'tablero';
}

// Path: fileTree.search
class Translations$fileTree$search$es extends Translations$fileTree$search$en {
	Translations$fileTree$search$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Filtra nombres / Enter para buscar en el contenido';
	@override String get prompt => 'Escribe una consulta y pulsa Enter';
	@override String get noMatches => 'Sin coincidencias';
	@override String get resultsTruncated => 'Resultados truncados';
}

// Path: fileTree.titles
class Translations$fileTree$titles$es extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String rename({required Object name}) => 'Renombrar ${name}';
	@override String delete({required Object name}) => 'Eliminar ${name}';
	@override String download({required Object name}) => 'Descargar ${name}';
}

// Path: fileTree.relative
class Translations$fileTree$relative$es extends Translations$fileTree$relative$en {
	Translations$fileTree$relative$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get now => 'ahora';
	@override String minutes({required Object n}) => '${n} min';
	@override String hours({required Object n}) => '${n} h';
	@override String days({required Object n}) => '${n} d';
}

// Path: git.checkpoints
class Translations$git$checkpoints$es extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Checkpoints';
	@override String get restoreTitle => 'Restaurar checkpoint';
	@override String get restoreMessage => '¿Restablecer el árbol de trabajo a este checkpoint? Los cambios actuales se reemplazarán.';
	@override String get restored => 'Checkpoint restaurado';
	@override String get labelHint => 'Etiqueta del checkpoint (opcional)';
	@override String get empty => 'Aún no hay checkpoints';
	@override String get create => 'Nuevo';
}

// Path: git.branchSections
class Translations$git$branchSections$es extends Translations$git$branchSections$en {
	Translations$git$branchSections$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get local => 'LOCALES';
	@override String get remote => 'REMOTAS';
}

// Path: kanban.card
class Translations$kanban$card$es extends Translations$kanban$card$en {
	Translations$kanban$card$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Sin título';
}

// Path: kanban.comments
class Translations$kanban$comments$es extends Translations$kanban$comments$en {
	Translations$kanban$comments$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Aún no hay comentarios';
	@override String get add => 'Añadir comentario';
}

// Path: kanban.dialog
class Translations$kanban$dialog$es extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Guardando…';
}

// Path: kanban.details
class Translations$kanban$details$es extends Translations$kanban$details$en {
	Translations$kanban$details$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Detalles de la tarjeta';
	@override String status({required Object status}) => 'Estado: ${status}';
}

// Path: kanban.empty
class Translations$kanban$empty$es extends Translations$kanban$empty$en {
	Translations$kanban$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Ningún proyecto seleccionado';
}

// Path: kanban.time
class Translations$kanban$time$es extends Translations$kanban$time$en {
	Translations$kanban$time$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get now => 'ahora';
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'hace 1 min',
		other: 'hace ${count} min',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'hace 1 hora',
		other: 'hace ${count} horas',
	);
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'hace 1 día',
		other: 'hace ${count} días',
	);
}

// Path: mcp.install
class Translations$mcp$install$es extends Translations$mcp$install$en {
	Translations$mcp$install$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Instalar el servidor MCP de DDAgent';
	@override String get description => 'Permite que los agentes seleccionados usen la base de conocimiento y las herramientas de DDAgent mediante MCP.';
	@override String get cardDescription => 'Da a tus agentes la base de conocimiento y las herramientas de DDAgent mediante MCP: elige agentes o instala para todos.';
	@override String get installSelected => 'Instalar seleccionados';
	@override String get installForAll => 'Instalar para todos';
	@override String get button => 'Instalar';
	@override String failed({required Object error}) => 'La instalación falló: ${error}';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Instalado en ${count} agente.',
		other: 'Instalado en ${count} agentes.',
	);
	@override String partialFailure({required Object count, required Object failed}) => 'Instalado en ${count}; falló: ${failed}';
	@override String get errorFallback => 'error';
}

// Path: mcp.servers
class Translations$mcp$servers$es extends Translations$mcp$servers$en {
	Translations$mcp$servers$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Cargando servidores MCP…';
	@override String get refreshingScopes => 'Actualizando ámbitos de proyecto…';
	@override String descriptionGeneric({required Object provider}) => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a ${provider}';
	@override String get addGlobalTitle => 'Añadir servidor MCP global';
	@override String get addGlobalDescription => 'Añade este servidor MCP a todos los proveedores: Claude, Cursor, Codex, OpenCode y Devin. Solo se admiten los transportes stdio y HTTP porque la misma configuración debe funcionar en todos los proveedores.';
	@override String get addGlobalMenuDescription => 'Añadir servidor MCP global escribe un servidor stdio o HTTP común en Claude, Cursor, Codex, OpenCode y Devin.';
	@override String addProviderTitle({required Object provider}) => 'Añadir servidor MCP de ${provider}';
	@override String addProviderDescription({required Object provider}) => 'Añadir servidor MCP de ${provider} solo modifica ${provider}.';
	@override late final Translations$mcp$servers$config$es config = Translations$mcp$servers$config$es._(_root);
	@override String get selectProjectRequired => 'Selecciona un proyecto para los servidores MCP con ámbito de proyecto';
	@override String get globalScopeUnsupported => 'Añadir servidor MCP solo admite el ámbito de usuario o de proyecto en todos los proveedores.';
	@override String globalAddFailed({required Object details}) => 'No se pudo añadir el servidor MCP a todos los proveedores. ${details}';
	@override String get scopeProject => 'proyecto';
}

// Path: mcp.team
class Translations$mcp$team$es extends Translations$mcp$team$en {
	Translations$mcp$team$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuraciones MCP del equipo';
	@override String get description => 'Comparte configuraciones de servidores MCP con tu equipo. Todos se mantienen sincronizados automáticamente.';
	@override String get cta => 'Disponible con DDAgent Pro';
}

// Path: mcp.tokens
class Translations$mcp$tokens$es extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Escritura';
	@override String get scopeRead => 'Lectura';
}

// Path: mcp.form
class Translations$mcp$form$es extends Translations$mcp$form$en {
	Translations$mcp$form$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String submitTo({required Object provider}) => 'Añadir servidor a ${provider}';
	@override late final Translations$mcp$form$scope$es scope = Translations$mcp$form$scope$es._(_root);
	@override late final Translations$mcp$form$fields$es fields = Translations$mcp$form$fields$es._(_root);
	@override late final Translations$mcp$form$validation$es validation = Translations$mcp$form$validation$es._(_root);
}

// Path: notifications.errors
class Translations$notifications$errors$es extends Translations$notifications$errors$en {
	Translations$notifications$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get registrationRejected => 'El servidor rechazó el registro';
	@override String get noResponse => 'Sin respuesta del servidor';
}

// Path: notifications.androidChannel
class Translations$notifications$androidChannel$es extends Translations$notifications$androidChannel$en {
	Translations$notifications$androidChannel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get name => 'Alertas de DDAgent';
	@override String get description => 'Notificaciones de ejecuciones de agentes, aprobaciones y errores';
}

// Path: onboarding.errors
class Translations$onboarding$errors$es extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get nameAndEmailRequired => 'Se requieren tanto el nombre como el correo de git.';
	@override String get invalidEmail => 'Introduce una dirección de correo electrónico válida.';
}

// Path: onboarding.agents
class Translations$onboarding$agents$es extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conecta tus agentes de IA';
	@override String get description => 'Inicia sesión en uno o más asistentes de programación con IA. Todos son opcionales.';
	@override String get laterHint => 'Puedes configurarlos más tarde en Ajustes.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$es extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conecta los agentes con DDAgent';
	@override String get description => 'Instala el servidor MCP de DDAgent para que tus agentes puedan usar la base de conocimiento y las herramientas de DDAgent. Elige agentes o instala para todos.';
	@override String get installSelected => 'Instalar seleccionados';
	@override String get installForAll => 'Instalar para todos';
	@override String get laterHint => 'Opcional: también puedes instalarlo más tarde en Ajustes → MCP.';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Instalado en ${count} agente.',
		other: 'Instalado en ${count} agentes.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => 'Instalado en ${installedCount}; falló: ${failed}';
}

// Path: quota.section
class Translations$quota$section$es extends Translations$quota$section$en {
	Translations$quota$section$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get config => 'Configuración';
}

// Path: quota.overview
class Translations$quota$overview$es extends Translations$quota$overview$en {
	Translations$quota$overview$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Tokens y costo';
}

// Path: quota.agents
class Translations$quota$agents$es extends Translations$quota$agents$en {
	Translations$quota$agents$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.config
class Translations$quota$config$es extends Translations$quota$config$en {
	Translations$quota$config$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get pollerTitle => 'Sondeo y alertas';
	@override String get accountRouting => 'Enrutamiento de cuentas';
	@override String get save => 'Guardar configuración';
}

// Path: quota.chart
class Translations$quota$chart$es extends Translations$quota$chart$en {
	Translations$quota$chart$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get show => 'Mostrar';
	@override String get hide => 'Ocultar';
	@override String get noData => 'No hay datos suficientes para una tendencia.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokens · ${cost}';
}

// Path: quota.duration
class Translations$quota$duration$es extends Translations$quota$duration$en {
	Translations$quota$duration$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String minutes({required Object minutes}) => '${minutes} min';
	@override String hoursMinutes({required Object hours, required Object minutes}) => '${hours} h ${minutes} min';
	@override String daysHours({required Object days, required Object hours}) => '${days} d ${hours} h';
	@override String get now => 'ahora';
}

// Path: scheduler.runStatus
class Translations$scheduler$runStatus$es extends Translations$scheduler$runStatus$en {
	Translations$scheduler$runStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get fired => 'lanzada';
	@override String get skipped => 'omitida';
	@override String get failed => 'fallida';
	@override String get completed => 'completada';
}

// Path: scheduler.cronErrors
class Translations$scheduler$cronErrors$es extends Translations$scheduler$cronErrors$en {
	Translations$scheduler$cronErrors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String fieldCount({required Object got}) => 'Se esperaban 5 campos, se recibieron ${got}';
	@override String fieldError({required Object index, required Object error}) => 'Campo ${index}: ${error}';
	@override String get empty => 'vacío';
	@override String invalidPart({required Object part}) => '«${part}» no válido';
	@override String invalidValue({required Object value}) => 'valor no válido «${value}»';
}

// Path: serverConnect.local
class Translations$serverConnect$local$es extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Este dispositivo';
	@override String get subtitle => 'Ejecuta el servidor DDAgent en esta máquina';
	@override String get install => 'Instalar servidor local';
	@override String get start => 'Iniciar servidor local';
	@override String get stop => 'Detener';
	@override String get starting => 'Iniciando el servidor local…';
	@override String downloading({required Object percent}) => 'Descargando el servidor… ${percent}%';
	@override String get installing => 'Instalando…';
	@override String running({required Object url}) => 'En ejecución en ${url}';
	@override String installed({required Object version}) => 'Instalado (v${version})';
	@override String get connect => 'Usar este servidor';
	@override String error({required Object error}) => 'Error del servidor local: ${error}';
	@override String get or => 'o conecta un servidor remoto';
	@override late final Translations$serverConnect$local$errors$es errors = Translations$serverConnect$local$errors$es._(_root);
}

// Path: sessions.toasts
class Translations$sessions$toasts$es extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Sesión archivada';
	@override String get restored => 'Sesión restaurada';
	@override String get deleted => 'Sesión eliminada';
	@override String get renamed => 'Sesión renombrada';
	@override String get pinned => 'Sesión fijada';
	@override String get unpinned => 'Sesión desfijada';
	@override String get workspaceChanged => 'Espacio de trabajo cambiado';
}

// Path: sessions.age
class Translations$sessions$age$es extends Translations$sessions$age$en {
	Translations$sessions$age$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get lessThanMinute => '<1 min';
	@override String minutes({required Object count}) => '${count} min';
	@override String hours({required Object hours}) => '${hours} h';
	@override String days({required Object days}) => '${days} d';
}

// Path: sessions.activity
class Translations$sessions$activity$es extends Translations$sessions$activity$en {
	Translations$sessions$activity$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get subagentRunning => 'Subagente en ejecución';
	@override String readingFile({required Object file}) => 'Leyendo ${file}';
	@override String runningTool({required Object name}) => 'Ejecutando ${name}';
	@override String editingFile({required Object file}) => 'Editando ${file}';
	@override String get editingFileGeneric => 'Editando un archivo';
	@override String get runningShellCommand => 'Ejecutando un comando de shell';
	@override String runningCommand({required Object command}) => 'Ejecutando `${command}`';
	@override String get committingChanges => 'Confirmando cambios';
	@override String get pushingBranch => 'Enviando la rama';
	@override String fetchingUrl({required Object url}) => 'Obteniendo ${url}';
	@override String searching({required Object query}) => 'Buscando «${query}»';
}

// Path: skills.addDialog
class Translations$skills$addDialog$es extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => 'Añadir Skill de ${provider}';
	@override String get chooseFileTitle => 'Elegir SKILL.md';
	@override String get chooseFolderTitle => 'Elegir una carpeta de skills';
	@override String get uploadHint => 'Sube un archivo SKILL.md o una carpeta de skills completa.';
	@override String get pickTitle => 'Elige una carpeta de skills o SKILL.md';
	@override String get pickHint => 'Las carpetas pueden incluir scripts, referencias y recursos.';
	@override String get chooseFiles => 'Elegir archivos';
	@override String get chooseFolder => 'Elegir carpeta';
	@override String get readyToInstall => 'Listo para instalar';
	@override String markdownFileMeta({required Object size}) => 'Archivo Markdown · ${size}';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} archivo · ${size}',
		other: '${count} archivos · ${size}',
	);
	@override String removeQueued({required Object name}) => 'Quitar ${name}';
	@override String get whereWillThisInstall => '¿Dónde se instalará esto?';
	@override String get hideInstallLocation => 'Ocultar ubicación de instalación';
	@override String get folderUploadsNote => 'Las carpetas subidas conservan el nombre de la carpeta seleccionada; los archivos sueltos usan el `name` de `SKILL.md`.';
	@override String get installSkill => 'Instalar Skill';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'Instalar ${count} Skill',
		other: 'Instalar ${count} Skills',
	);
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$es extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get toProjectHint => 'Elige el proyecto al que debe pertenecer esta skill. Saldrá del directorio global de skills del proveedor.';
	@override String get toGlobalHint => 'Mueve esta skill al directorio global de skills para que todos los proyectos puedan usarla.';
	@override String get moveToProject => 'Mover a proyecto';
	@override String get moveToGlobal => 'Mover a global';
}

// Path: skills.screen
class Translations$skills$screen$es extends Translations$skills$screen$en {
	Translations$skills$screen$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String manageDescription({required Object provider}) => 'Gestiona las skills de ${provider} desde archivos locales, carpetas completas y ubicaciones por proyecto.';
	@override String get searchHint => 'Buscar skills…';
	@override String get clearSearch => 'Limpiar búsqueda de skills';
	@override String get addSkill => 'Añadir Skill';
	@override String get scanningProjectSkills => 'Escaneando skills del proyecto…';
	@override String get savedSuccessfully => 'Skills guardadas correctamente.';
	@override String loadingSkills({required Object provider}) => 'Cargando skills de ${provider}…';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} SKILL',
		other: '${count} SKILLS',
	);
	@override String deleteTitle({required Object name}) => '¿Eliminar ${name}?';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Esto elimina el directorio ${directory} del directorio de skills gestionadas de ${provider}. Esta acción no se puede deshacer.';
	@override String get noDescription => 'No se ha proporcionado descripción en el front matter de la skill.';
	@override String pluginBadge({required Object name}) => 'Plugin: ${name}';
	@override String projectBadge({required Object name}) => 'Proyecto: ${name}';
	@override String get sourceLabel => 'ORIGEN';
}

// Path: skills.empty
class Translations$skills$empty$es extends Translations$skills$empty$en {
	Translations$skills$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get noProjects => 'No hay proyectos disponibles';
	@override String get noProjectsDescription => 'Añade un proyecto o espacio de trabajo para explorar sus skills.';
	@override String get noSkillsInProject => 'No hay skills en este proyecto';
	@override String get noSkillsInProjectDescription => 'Crea una carpeta .claude/skills, .cursor/skills o .agents/skills en el proyecto seleccionado.';
	@override String get noGlobalSkills => 'Aún no se han detectado skills globales';
	@override String get noGlobalSkillsDescription => 'Añade una skill global arriba para que esté disponible en todos los proyectos.';
	@override String get noMatchingSkills => 'No hay skills coincidentes';
	@override String get noMatchingSkillsDescription => 'Prueba con otro comando, nombre, ámbito, proyecto o ruta de origen.';
}

// Path: skills.scopes
class Translations$skills$scopes$es extends Translations$skills$scopes$en {
	Translations$skills$scopes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get user => 'Usuario';
	@override String get plugin => 'Plugin';
	@override String get repo => 'Repositorio';
	@override String get project => 'Proyecto';
	@override String get admin => 'Admin';
	@override String get system => 'Sistema';
}

// Path: skills.errors
class Translations$skills$errors$es extends Translations$skills$errors$en {
	Translations$skills$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get dropMarkdownOrFolder => 'Suelta uno o más archivos markdown o una carpeta que contenga SKILL.md.';
	@override String get addMarkdownFirst => 'Añade primero uno o más archivos markdown.';
	@override String get importFailed => 'No se pudieron importar las skills';
	@override String get folderReadFailed => 'No se pudo leer la carpeta de skills';
	@override String folderFileLimit({required Object count}) => 'Una carpeta de skills puede contener hasta ${count} archivos.';
	@override String get folderSizeLimit => 'Las carpetas de skills seleccionadas deben ocupar menos de 30 MB en total.';
	@override String get missingSkillFile => 'La carpeta seleccionada no contiene un archivo SKILL.md.';
	@override String couldNotReadSkillFile({required Object name}) => 'No se pudo leer SKILL.md desde ${name}.';
}

// Path: terminal.tabs
class Translations$terminal$tabs$es extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String shellName({required Object index}) => 'Shell ${index}';
	@override String get plainShell => 'Shell simple';
	@override String get claudeCli => 'Claude CLI';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'Inicio de sesión: ${provider}';
	@override String runTitle({required Object command}) => 'Ejecutar: ${command}';
}

// Path: terminal.actions
class Translations$terminal$actions$es extends Translations$terminal$actions$en {
	Translations$terminal$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newTab => 'Nueva pestaña de terminal';
	@override String get providerLogin => 'Inicio de sesión del proveedor';
	@override String get restartSession => 'Reiniciar sesión';
	@override String get clearOutput => 'Limpiar salida';
	@override String get newShell => 'Shell nueva';
	@override String get connect => 'Conectar';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$es extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Abrir en el navegador';
	@override String linkLabel({required Object url}) => 'Enlace de autenticación: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$es extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'Archivo detectado: ${path}';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$es extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get interrupt => 'Interrumpir (SIGINT)';
	@override String get eof => 'EOF';
	@override String get suspend => 'Suspender (SIGTSTP)';
	@override String get hide => 'Ocultar barra de atajos';
	@override String get showTooltip => 'Mostrar atajos';
	@override String get hideTooltip => 'Ocultar atajos';
}

// Path: terminal.paste
class Translations$terminal$paste$es extends Translations$terminal$paste$en {
	Translations$terminal$paste$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pegar en la terminal';
	@override String get hint => 'Ctrl+V / clic derecho → Pegar';
}

// Path: terminal.errors
class Translations$terminal$errors$es extends Translations$terminal$errors$en {
	Translations$terminal$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'No se pudo abrir el enlace: ${url}';
	@override String frameError({required Object message}) => '[Error] ${message}';
	@override String connectionError({required Object message}) => '[Error de conexión] ${message}';
}

// Path: terminal.loginDialog
class Translations$terminal$loginDialog$es extends Translations$terminal$loginDialog$en {
	Translations$terminal$loginDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => 'Inicio de sesión en ${provider} CLI';
	@override String exited({required Object code}) => 'Finalizado (${code})';
	@override String get authLinkDetected => 'Enlace de autenticación detectado';
}

// Path: terminal.empty
class Translations$terminal$empty$es extends Translations$terminal$empty$en {
	Translations$terminal$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'No hay terminal activa';
	@override String get description => 'Crea una pestaña nueva para empezar';
}

// Path: terminal.overlay
class Translations$terminal$overlay$es extends Translations$terminal$overlay$en {
	Translations$terminal$overlay$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get processExited => 'El proceso ha finalizado: conéctate para iniciarlo de nuevo';
	@override String processExitedWithCode({required Object code}) => 'El proceso ha finalizado (código ${code}): conéctate para iniciarlo de nuevo';
	@override String resumeSession({required Object title}) => 'Reanudar la sesión ${title}';
	@override String startSession({required Object path}) => 'Iniciar una sesión nueva en ${path}';
}

// Path: workspace.paneTitle
class Translations$workspace$paneTitle$es extends Translations$workspace$paneTitle$en {
	Translations$workspace$paneTitle$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Chat';
	@override String get browser => 'Navegador';
	@override String get terminal => 'Terminal';
	@override String get notes => 'Notas compartidas';
	@override String get editor => 'Editor';
	@override String get git => 'Git';
}

// Path: worktrees.runtimeStatus
class Translations$worktrees$runtimeStatus$es extends Translations$worktrees$runtimeStatus$en {
	Translations$worktrees$runtimeStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get idle => 'inactivo';
	@override String get running => 'en ejecución';
	@override String get done => 'listo';
	@override String get failed => 'fallido';
	@override String get exited => 'finalizado';
}

// Path: browserUse.sessionStatus
class Translations$browserUse$sessionStatus$es extends Translations$browserUse$sessionStatus$en {
	Translations$browserUse$sessionStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ready => 'Lista';
	@override String get stopped => 'Detenida';
	@override String get unavailable => 'No disponible';
}

// Path: miniOrchestrator.taskTypes
class Translations$miniOrchestrator$taskTypes$es extends Translations$miniOrchestrator$taskTypes$en {
	Translations$miniOrchestrator$taskTypes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get gate => 'Puerta';
}

// Path: miniOrchestrator.roles
class Translations$miniOrchestrator$roles$es extends Translations$miniOrchestrator$roles$en {
	Translations$miniOrchestrator$roles$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get thinker => 'Pensador';
	@override String get worker => 'Ejecutor';
}

// Path: auth.login.errors
class Translations$auth$login$errors$es extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Usuario o contraseña incorrectos';
	@override String get requiredFields => 'Completa todos los campos';
	@override String get networkError => 'Error de red. Inténtalo de nuevo.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$es extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get username => 'Escribe tu usuario';
	@override String get password => 'Escribe tu contraseña';
}

// Path: auth.register.errors
class Translations$auth$register$errors$es extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Las contraseñas no coinciden';
	@override String get usernameTaken => 'El nombre de usuario ya está en uso';
	@override String get weakPassword => 'La contraseña es demasiado débil';
	@override String get usernameTooShort => 'El nombre de usuario debe tener al menos 3 caracteres';
	@override String get passwordTooShort => 'La contraseña debe tener al menos 6 caracteres';
}

// Path: chat.orchestrator.routing
class Translations$chat$orchestrator$routing$es extends Translations$chat$orchestrator$routing$en {
	Translations$chat$orchestrator$routing$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Enrutamiento';
	@override String alternatives({required Object list}) => 'Alternativas: ${list}';
	@override String first({required Object label, required Object task}) => '${label} — primer candidato para ${task}';
	@override String skipped({required Object label, required Object list}) => '${label} — candidatos anteriores omitidos (${list})';
}

// Path: chat.orchestrator.plan
class Translations$chat$orchestrator$plan$es extends Translations$chat$orchestrator$plan$en {
	Translations$chat$orchestrator$plan$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get disabled => 'desactivado';
	@override String get awaitingConfirm => 'Esperando la confirmación del plan.';
	@override String get run => 'Ejecutar plan';
	@override String get toggleStep => 'Activar paso';
	@override String get confirmFailed => 'No se pudo iniciar — inténtalo de nuevo.';
	@override String get fallback => 'planificador no disponible — alternativa de un solo paso';
	@override String get templateSource => 'desde plantilla de pipeline';
	@override String get offSource => 'planificador desactivado';
	@override String stepCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} paso',
		other: '${count} pasos',
	);
	@override String get supervisedSource => 'bucle supervisado';
}

// Path: chat.orchestrator.decision
class Translations$chat$orchestrator$decision$es extends Translations$chat$orchestrator$decision$en {
	Translations$chat$orchestrator$decision$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Decisión del supervisor';
	@override String iteration({required Object n}) => 'iteración ${n}';
	@override String get rationaleLabel => 'Motivo';
	@override String get awaitingConfirm => 'Esperando tu aprobación antes de ejecutar estos pasos.';
	@override String get proposedSteps => 'Pasos propuestos';
	@override late final Translations$chat$orchestrator$decision$action$es action = Translations$chat$orchestrator$decision$action$es._(_root);
	@override late final Translations$chat$orchestrator$decision$outcome$es outcome = Translations$chat$orchestrator$decision$outcome$es._(_root);
}

// Path: chat.orchestrator.delegation
class Translations$chat$orchestrator$delegation$es extends Translations$chat$orchestrator$delegation$en {
	Translations$chat$orchestrator$delegation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paso delegado';
	@override String get openSession => 'Abrir sesión completa';
	@override String attempt({required Object n}) => 'intento ${n}';
	@override String get retryStep => 'Reintentar / Corregir';
	@override String get continueStep => 'Continuar / Corregir';
	@override String get continueFailed => 'Error — inténtalo de nuevo.';
	@override late final Translations$chat$orchestrator$delegation$status$es status = Translations$chat$orchestrator$delegation$status$es._(_root);
	@override String attempts({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} intento',
		other: '${count} intentos',
	);
	@override String candidates({required Object list}) => 'candidatos: ${list}';
	@override String candidateCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} candidato',
		other: '${count} candidatos',
	);
}

// Path: chat.orchestrator.summary
class Translations$chat$orchestrator$summary$es extends Translations$chat$orchestrator$summary$en {
	Translations$chat$orchestrator$summary$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Resumen';
	@override String progress({required Object done, required Object total}) => 'Pasos completados: ${done}/${total}';
	@override String get aborted => 'abortado';
	@override String get timedOut => 'tiempo agotado';
	@override String get capped => 'límite de iteraciones';
	@override String failed({required Object list}) => 'Pasos fallidos: ${list}';
	@override String get kContinue => 'Continuar';
	@override String get continueWork => 'Continuar el trabajo';
	@override String get resumeFailed => 'No se pudo reanudar — inténtalo de nuevo.';
	@override String get runNextTask => 'Ejecutar la siguiente tarea';
	@override String get endAllTasks => 'Finalizar todas las tareas';
	@override String get tasksRunning => 'Trabajando en las tareas…';
	@override String get cancelTasks => 'Cancelar';
}

// Path: chat.orchestrator.taskmaster
class Translations$chat$orchestrator$taskmaster$es extends Translations$chat$orchestrator$taskmaster$en {
	Translations$chat$orchestrator$taskmaster$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cola de tareas';
	@override String remaining({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: 'queda ${count}',
		other: 'quedan ${count}',
	);
	@override late final Translations$chat$orchestrator$taskmaster$status$es status = Translations$chat$orchestrator$taskmaster$status$es._(_root);
}

// Path: chat.orchestrator.gate
class Translations$chat$orchestrator$gate$es extends Translations$chat$orchestrator$gate$en {
	Translations$chat$orchestrator$gate$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'tiempo agotado';
	@override String exit({required Object code}) => 'salida ${code}';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$es extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Modo por defecto';
	@override String get auto => 'Modo automático';
	@override String get acceptEdits => 'Aceptar ediciones';
	@override String get bypassPermissions => 'Omitir permisos';
	@override String get plan => 'Modo de planificación';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$es extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Solo los comandos de confianza (ls, cat, grep, git status, etc.) se ejecutan automáticamente. Los demás comandos se omiten. Puede escribir en el espacio de trabajo.';
	@override String get auto => 'Un clasificador del modelo decide en cada llamada si aprobar o denegar. Sin intervención, pero más seguro que Omitir — las denegaciones siguen ocurriendo.';
	@override String get acceptEdits => 'Todos los comandos se ejecutan automáticamente dentro del espacio de trabajo. Modo automático completo con ejecución en sandbox.';
	@override String get bypassPermissions => 'Acceso completo al sistema sin restricciones. Todos los comandos se ejecutan automáticamente con acceso total a disco y red. Úsalo con precaución.';
	@override String get plan => 'Modo de planificación: no se ejecutan comandos';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$es extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter para enviar • / comandos • @ archivos';
	@override String get enter => 'Enter para enviar • Shift+Enter nueva línea • / comandos • @ archivos';
	@override String get queue => 'Enter para poner en cola tu siguiente mensaje';
	@override String get updateQueued => 'Enter para actualizar el mensaje en cola';
}

// Path: chat.input.queue
class Translations$chat$input$queue$es extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Poner en cola el siguiente mensaje';
	@override String get update => 'Actualizar mensaje en cola';
	@override String get label => 'En cola';
	@override String get willSend => 'Se enviará cuando esto termine';
	@override String get edit => 'Editar mensaje en cola';
	@override String get delete => 'Eliminar mensaje en cola';
	@override String get failed => 'Falló el envío';
	@override String get sendNow => 'Enviar ahora';
	@override String get sendNowAfterTurn => 'Este agente no acepta mensajes durante un turno: se enviará cuando termine el actual';
	@override String filesAttached({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count,
		one: '${count} archivo adjunto',
		other: '${count} archivos adjuntos',
	);
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$es extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Cancelar y vaciar la cola sin conexión';
	@override String get clearBtn => 'Cancelar';
	@override String multiple({required Object count}) => '${count} mensajes en cola sin conexión — se enviarán automáticamente al reconectar';
	@override String get single => '1 mensaje en cola sin conexión — se enviará automáticamente al reconectar';
}

// Path: chat.composer.effortLevels
class Translations$chat$composer$effortLevels$es extends Translations$chat$composer$effortLevels$en {
	Translations$chat$composer$effortLevels$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get off => 'Desactivado';
	@override String get none => 'Ninguno';
	@override String get minimal => 'Mínimo';
	@override String get low => 'Bajo';
	@override String get medium => 'Medio';
	@override String get high => 'Alto';
	@override String get xhigh => 'Muy alto';
	@override String get max => 'Máximo';
	@override String get ultra => 'Ultra';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$es extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'de Anthropic';
	@override String get openai => 'de OpenAI';
	@override String get cursorEditor => 'Editor de código con IA';
	@override String get google => 'de Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$es extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Listo para usar Claude con ${model}. Escribe tu mensaje abajo.';
	@override String cursor({required Object model}) => 'Listo para usar Cursor con ${model}. Escribe tu mensaje abajo.';
	@override String codex({required Object model}) => 'Listo para usar Codex con ${model}. Escribe tu mensaje abajo.';
	@override String opencode({required Object model}) => 'Listo para usar OpenCode con ${model}. Escribe tu mensaje abajo.';
	@override String get kDefault => 'Selecciona un proveedor arriba para empezar';
	@override String devin({required Object model}) => 'Listo con Devin ${model}';
	@override String get orchestrator => 'Listo con Auto — el enrutador elige el mejor modelo para cada paso';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$es extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Continúa tu conversación';
	@override String get description => 'Haz preguntas sobre tu código, pide cambios u obtén ayuda con tareas de desarrollo';
	@override String get action => 'Seguir escribiendo';
}

// Path: chat.session.loading
class Translations$chat$session$loading$es extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Cargando mensajes anteriores...';
	@override String get sessionMessages => 'Cargando mensajes de la sesión...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$es extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => 'Mostrando ${shown} de ${total} mensajes';
	@override String get scrollToLoad => 'Desplázate hacia arriba para cargar más';
	@override String showingLast({required Object count, required Object total}) => 'Mostrando los últimos ${count} mensajes (${total} en total)';
	@override String get loadEarlier => 'Cargar mensajes anteriores';
	@override String get loadOlderFailed => 'No se pudieron cargar mensajes anteriores.';
	@override String get retry => 'Reintentar';
	@override String get loadAll => 'Cargar todos los mensajes';
	@override String get loadingAll => 'Cargando todos los mensajes...';
	@override String get allLoaded => 'Todos los mensajes cargados';
	@override String get perfWarning => 'Todos los mensajes cargados — el desplazamiento puede ser más lento. Haz clic en "Ir al final" para recuperar el rendimiento.';
	@override String get noSearchMatches => 'Ningún mensaje coincide con la búsqueda.';
	@override String get loadOlder => 'Cargar mensajes anteriores';
	@override String loadAllCount({required Object count}) => 'Cargar todos (${count})';
	@override String retryLoadOlder({required Object error}) => 'Reintentar cargar los anteriores — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$es extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Selecciona un proyecto';
	@override String get description => 'Elige un proyecto para abrir una shell interactiva en ese directorio';
}

// Path: chat.shell.status
class Translations$chat$shell$status$es extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Sesión nueva';
	@override String get initializing => 'Inicializando...';
	@override String get restarting => 'Reiniciando...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$es extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Desconectar';
	@override String get disconnectTitle => 'Desconectar de la shell';
	@override String get restart => 'Reiniciar';
	@override String get restartTitle => 'Reiniciar shell';
	@override String get kill => 'Terminar (SIGINT)';
	@override String get killTitle => 'Terminar proceso en ejecución (Ctrl+C)';
	@override String get copyOutput => 'Copiar salida';
	@override String get copyOutputTitle => 'Copiar salida del terminal';
	@override String get copied => '¡Copiado!';
	@override String get zoomInTitle => 'Acercar';
	@override String get zoomOutTitle => 'Alejar';
	@override String get connect => 'Continuar en la shell';
	@override String get connectTitle => 'Conectar a la shell';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$es extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Pensando';
	@override String get processing => 'Procesando';
	@override String get analyzing => 'Analizando';
	@override String get working => 'Trabajando';
	@override String get computing => 'Calculando';
	@override String get reasoning => 'Razonando';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$es extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get live => 'En vivo';
	@override String get paused => 'En pausa';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$es extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}s';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '${time} transcurridos';
	@override String get startingNow => 'Empezando ahora';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$es extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Detener generación';
	@override String get pressEscToStop => 'Pulsa Esc en cualquier momento para detener';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$es extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Asistente';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$es extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get models => 'Explora los modelos disponibles para el proveedor activo.';
	@override String get cost => 'Revisa el uso de tokens de la sesión activa.';
	@override String get status => 'Inspecciona el estado del runtime, la versión, el proveedor y el entorno.';
	@override String get memory => 'Abre el archivo de memoria CLAUDE.md del proyecto.';
	@override String get config => 'Abre los ajustes y la configuración.';
	@override String get help => 'Muestra la documentación y la sintaxis de los comandos.';
}

// Path: chat.permissionRequest.recap
class Translations$chat$permissionRequest$recap$es extends Translations$chat$permissionRequest$recap$en {
	Translations$chat$permissionRequest$recap$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'Tiempo agotado: denegado automáticamente';
	@override String get cancelled => 'Cancelado: se detuvo el turno';
	@override String get autoApproved => 'Aprobado automáticamente';
	@override String get expired => 'La solicitud caducó: el agente ya no la espera';
	@override String get answered => 'Respondida';
	@override String get skipped => 'Omitida';
	@override String get decided => 'Decidido';
}

// Path: chat.commandDialog.help
class Translations$chat$commandDialog$help$es extends Translations$chat$commandDialog$help$en {
	Translations$chat$commandDialog$help$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Centro de comandos';
	@override String get title => 'Ayuda y atajos';
	@override String get subtitle => 'Busca comandos integrados, patrones de sintaxis y uso de comandos.';
}

// Path: chat.commandDialog.models
class Translations$chat$commandDialog$models$es extends Translations$chat$commandDialog$models$en {
	Translations$chat$commandDialog$models$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Selección de modelo';
	@override String get title => 'Elige un modelo';
	@override String get subtitle => 'Elige el modelo que debe usar este proveedor.';
	@override String modelSetTo({required Object model}) => 'Modelo establecido en ${model}.';
	@override String get activeModel => 'Modelo activo';
	@override String get noModelsMatch => 'Ningún modelo coincide con ese filtro.';
	@override String get choiceSavedForSession => 'Tu elección se guarda para esta sesión y pasa a ser la predeterminada para los chats nuevos.';
	@override String get choiceDefault => 'Tu elección pasa a ser el modelo predeterminado para los chats nuevos.';
	@override String get custom => 'Personalizado';
	@override String get currentSelection => 'Selección actual';
}

// Path: chat.commandDialog.cost
class Translations$chat$commandDialog$cost$es extends Translations$chat$commandDialog$cost$en {
	Translations$chat$commandDialog$cost$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Telemetría de la sesión';
	@override String get title => 'Uso de tokens';
	@override String get subtitle => 'Recuento de tokens de entrada, salida y total de esta sesión.';
	@override String get totalTokensUsed => 'Total de tokens usados';
	@override String get inputTokens => 'Tokens de entrada';
	@override String get cacheReadTokens => 'Tokens leídos de caché';
	@override String get cacheWriteTokens => 'Tokens escritos en caché';
	@override String get outputTokens => 'Tokens de salida';
	@override String get breakdown => 'Desglose';
	@override String get unavailable => 'No disponible';
	@override String get contextWindow => 'Ventana de contexto';
	@override String get estimatedCost => 'Coste estimado';
}

// Path: chat.commandDialog.status
class Translations$chat$commandDialog$status$es extends Translations$chat$commandDialog$status$en {
	Translations$chat$commandDialog$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'Estado del entorno';
	@override String get title => 'Estado del sistema';
	@override String get subtitle => 'Versión, proveedor, entorno de ejecución y detalles del entorno.';
	@override String get package => 'Paquete';
	@override String get uptime => 'Tiempo activo';
	@override String get platform => 'Plataforma';
	@override String get memory => 'Memoria';
	@override String memoryRss({required Object mb}) => '${mb} MB RSS';
	@override String get runtimeOnline => 'Entorno en línea';
	@override String processResponding({required Object pid}) => 'El proceso #${pid} responde.';
	@override String get processStatusResponding => 'El proceso responde.';
	@override String get healthy => 'En buen estado';
}

// Path: chat.commandDialog.syntax
class Translations$chat$commandDialog$syntax$es extends Translations$chat$commandDialog$syntax$en {
	Translations$chat$commandDialog$syntax$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sintaxis';
	@override String arguments({required Object arguments, required Object first, required Object second}) => '${arguments} pasa todos los argumentos; ${first}, ${second} posicionales.';
	@override String file({required Object token}) => '${token} incluye el contenido del archivo.';
	@override String bash({required Object token}) => '${token} ejecuta bash.';
}

// Path: chat.utilities.tooltip
class Translations$chat$utilities$tooltip$es extends Translations$chat$utilities$tooltip$en {
	Translations$chat$utilities$tooltip$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String tokensUsed({required Object tokens}) => '${tokens} tokens usados';
	@override String contextOf({required Object percent, required Object total}) => 'contexto ${percent} % de ${total}';
	@override String input({required Object value}) => 'entrada ${value}';
	@override String cache({required Object read, required Object write}) => 'caché leída ${read} · escrita ${write}';
	@override String output({required Object value}) => 'salida ${value}';
}

// Path: chat.toolBlocks.status
class Translations$chat$toolBlocks$status$es extends Translations$chat$toolBlocks$status$en {
	Translations$chat$toolBlocks$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get running => 'En ejecución';
	@override String get denied => 'Denegado';
}

// Path: chat.toolBlocks.verbs
class Translations$chat$toolBlocks$verbs$es extends Translations$chat$toolBlocks$verbs$en {
	Translations$chat$toolBlocks$verbs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get read => 'leer';
	@override String get write => 'escribir';
	@override String get edit => 'editar';
	@override String get delete => 'eliminar';
	@override String get move => 'mover';
}

// Path: chat.commandMenu.namespaces
class Translations$chat$commandMenu$namespaces$es extends Translations$chat$commandMenu$namespaces$en {
	Translations$chat$commandMenu$namespaces$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get frequent => 'Usados con frecuencia';
	@override String get builtin => 'Comandos integrados';
	@override String get skill => 'Habilidades';
	@override String get project => 'Comandos del proyecto';
	@override String get user => 'Comandos del usuario';
	@override String get other => 'Otros comandos';
}

// Path: chat.mentionMenu.kinds
class Translations$chat$mentionMenu$kinds$es extends Translations$chat$mentionMenu$kinds$en {
	Translations$chat$mentionMenu$kinds$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get file => 'archivo';
	@override String get session => 'sesión';
	@override String get task => 'tarea';
}

// Path: common.quota.section
class Translations$common$quota$section$es extends Translations$common$quota$section$en {
	Translations$common$quota$section$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Resumen';
	@override String get quotas => 'Cuotas';
	@override String get usage => 'Uso';
	@override String get agents => 'Agentes';
}

// Path: common.quota.filter
class Translations$common$quota$filter$es extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get all => 'Todos';
}

// Path: common.quota.period
class Translations$common$quota$period$es extends Translations$common$quota$period$en {
	Translations$common$quota$period$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 días';
	@override String get k30d => '30 días';
	@override String get all => 'Todos';
}

// Path: common.quota.group
class Translations$common$quota$group$es extends Translations$common$quota$group$en {
	Translations$common$quota$group$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Proveedor';
	@override String get model => 'Modelo';
	@override String get agent => 'Agente';
	@override String get tool => 'Herramienta';
}

// Path: common.quota.metric
class Translations$common$quota$metric$es extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Tokens';
	@override String get input => 'Entrada';
	@override String get output => 'Salida';
	@override String get cache => 'Lecturas de caché';
	@override String get calls => 'Llamadas API';
	@override String get cost => 'Costo';
	@override String get sessions => 'Sesiones';
}

// Path: common.quota.cost
class Translations$common$quota$cost$es extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Facturado (API + exceso)';
	@override String get listPrice => 'Precio de lista de tokens usados';
	@override String get subscriptionValue => 'Cubierto por suscripciones';
	@override String get cacheSavings => 'Ahorro de caché';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$es extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Facturado (API + exceso)';
	@override String get listPrice => 'Precio de lista de tokens usados';
	@override String get subscriptionValue => 'Cubierto por suscripciones';
}

// Path: common.quota.overview
class Translations$common$quota$overview$es extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tokens y costo — últimos 7 días';
	@override String get effectiveCost => 'Costo efectivo (7 días)';
	@override String get alertsTitle => 'Alertas';
	@override String get noAlerts => 'Nada requiere atención ahora mismo.';
	@override String get limitsTitle => 'Uso y límites';
	@override String get activeTasks => 'Tareas activas';
	@override String get viewAccounts => 'Todas las cuentas';
	@override String get viewAgents => 'Todos los agentes';
	@override String get noTasks => 'No hay agentes en ejecución ahora mismo.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$es extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tendencia diaria';
	@override String breakdownTitle({required Object group}) => 'Desglose por ${group}';
	@override String get colName => 'Nombre';
	@override String get sourceUnavailable => 'Almacén de analítica no disponible; sin datos.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$es extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} en ejecución';
	@override String get colAgent => 'Agente';
	@override String get colStatus => 'Estado';
	@override String get colTask => 'Tarea';
	@override String get colModel => 'Cuenta / modelo';
	@override String get colTime => 'Hora';
	@override String get empty => 'Ningún agente coincide con este filtro.';
	@override String get detailSession => 'Sesión';
	@override String get detailStarted => 'Iniciado';
	@override String get detailRetries => 'Reintentos';
	@override String get detailResult => 'Resultado';
	@override String get notTracked => 'no rastreado';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$es extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get running => 'En ejecución';
	@override String get waiting => 'Esperando';
	@override String get failed => 'Fallido';
	@override String get finished => 'Finalizado';
	@override String get queued => 'En cola';
}

// Path: common.quota.alert
class Translations$common$quota$alert$es extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: al ritmo actual, el límite se agota en ${value}';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% usado (umbral ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$es extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get live => 'En vivo';
	@override String get cached => 'En caché';
	@override String get estimate => 'Estimación';
	@override String get unknown => 'Desconocido';
	@override String get error => 'Error';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$es extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Límites en riesgo';
	@override String atRiskHint({required Object value}) => 'cuentas por encima del ${value}%';
	@override String get windowsAtRisk => 'Ventanas agotándose';
	@override String get errored => 'Fallos de sincronización';
	@override String get activeAgents => 'Agentes activos';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} esperando · ${queued} en cola';
	@override String get nextReset => 'Próximo reinicio';
	@override String get tokens => 'Tokens';
	@override String sessionsHint({required Object value}) => '${value} sesiones';
	@override String get cost => 'Costo estimado';
	@override String costHint({required Object value}) => '${value} cubierto por planes';
}

// Path: common.quota.empty
class Translations$common$quota$empty$es extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'No hay cuentas conectadas';
	@override String get description => 'Inicia sesión en Claude, Codex, Gemini o CommandCode para rastrear las cuotas aquí.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$es extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Alertas y enrutamiento';
	@override String get description => 'Controla cuándo te avisa el panel y cómo se sugieren las cuentas para el trabajo nuevo.';
	@override String get alertsEnabled => 'Alertas predictivas y de umbral';
	@override String get alertsEnabledHint => 'Avisar antes de que un límite se agote al ritmo actual, no solo al 90%.';
	@override String get watchThreshold => 'Umbral de observación (%)';
	@override String get dangerThreshold => 'Umbral de peligro (%)';
	@override String get routingMode => 'Enrutamiento';
	@override late final Translations$common$quota$settings$routing$es routing = Translations$common$quota$settings$routing$es._(_root);
	@override String get logSources => 'Fuentes de registro';
	@override String get logSourcesHint => 'Las pantallas de uso y agentes leen estas fuentes de solo lectura.';
	@override String get quotaConsent => 'Permitir consulta de cuotas';
	@override String get quotaConsentHint => 'Consulta los endpoints de los proveedores con tus credenciales guardadas para leer los límites en vivo.';
	@override String get perAccount => 'Sustituciones por cuenta';
	@override String get tab => 'Ajustes del Control Center';
}

// Path: common.quota.range
class Translations$common$quota$range$es extends Translations$common$quota$range$en {
	Translations$common$quota$range$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Todos';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$es extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Renombrar';
	@override String get delete => 'Eliminar';
	@override String get copyPath => 'Copiar ruta';
	@override String get download => 'Descargar';
	@override String get newFile => 'Archivo nuevo';
	@override String get newFolder => 'Carpeta nueva';
	@override String get upload => 'Subir archivos';
	@override String get refresh => 'Actualizar';
	@override String get menuLabel => 'Menú contextual de archivo';
	@override String get loading => 'Cargando...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$es extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Eliminar';
	@override String get fileWarning => 'Este archivo se eliminará permanentemente.';
	@override String get folderWarning => 'Esta carpeta y todo su contenido se eliminarán permanentemente.';
	@override String title({required Object type}) => 'Eliminar ${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$es extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'No se pudo copiar la ruta';
	@override String get fileCreated => 'Archivo creado correctamente';
	@override String get fileDeleted => 'Archivo eliminado';
	@override String get folderCreated => 'Carpeta creada correctamente';
	@override String get folderDeleted => 'Carpeta eliminada';
	@override String get folderDownloaded => 'Carpeta descargada como ZIP';
	@override String get pathCopied => 'Ruta copiada al portapapeles';
	@override String get renamed => 'Renombrado correctamente';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$es extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'El nombre de archivo no puede ser solo puntos';
	@override String get emptyName => 'El nombre de archivo no puede estar vacío';
	@override String get invalidChars => 'El nombre de archivo contiene caracteres no válidos';
	@override String get reserved => 'El nombre de archivo es un nombre reservado';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$es extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get type => 'Tipo';
	@override String get configure => 'Configurar';
	@override String get confirm => 'Confirmar';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$es extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get question => '¿Ya tienes un espacio de trabajo o quieres crear uno nuevo?';
	@override late final Translations$common$projectWizard$step1$existing$es existing = Translations$common$projectWizard$step1$existing$es._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$es kNew = Translations$common$projectWizard$step1$kNew$es._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$es extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Ruta del espacio de trabajo';
	@override String get newPath => 'Ruta del espacio de trabajo';
	@override String get existingPlaceholder => '/ruta/al/espacio/existente';
	@override String get newPlaceholder => '/ruta/al/espacio/nuevo';
	@override String get existingHelp => 'Ruta completa al directorio de tu espacio de trabajo existente';
	@override String get newHelp => 'Ruta completa al directorio de tu espacio de trabajo';
	@override String get githubUrl => 'URL de GitHub (opcional)';
	@override String get githubPlaceholder => 'https://github.com/usuario/repositorio';
	@override String get githubHelp => 'Opcional: proporciona una URL de GitHub para clonar un repositorio';
	@override String get githubAuth => 'Autenticación de GitHub (opcional)';
	@override String get githubAuthHelp => 'Solo se requiere para repositorios privados. Los repos públicos se pueden clonar sin autenticación.';
	@override String get loadingTokens => 'Cargando tokens guardados...';
	@override String get storedToken => 'Token guardado';
	@override String get newToken => 'Token nuevo';
	@override String get nonePublic => 'Ninguno (público)';
	@override String get selectToken => 'Seleccionar token';
	@override String get selectTokenPlaceholder => '-- Selecciona un token --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Este token se usará solo para esta operación';
	@override String get publicRepoInfo => 'Los repositorios públicos no requieren autenticación. Puedes omitir el token si clonas un repo público.';
	@override String get noTokensHelp => 'No hay tokens guardados disponibles. Puedes añadir tokens en Ajustes → Claves API para reutilizarlos fácilmente.';
	@override String get optionalTokenPublic => 'Token de GitHub (opcional para repos públicos)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (déjalo vacío para repos públicos)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$es extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Revisa tu configuración';
	@override String get existingWorkspace => 'Espacio de trabajo existente';
	@override String get newWorkspace => 'Espacio de trabajo nuevo';
	@override String get path => 'Ruta:';
	@override String get cloneFrom => 'Clonar desde:';
	@override String get authentication => 'Autenticación:';
	@override String get usingStoredToken => 'Usando token guardado:';
	@override String get usingProvidedToken => 'Usando token proporcionado';
	@override String get noAuthentication => 'Sin autenticación';
	@override String get sshKey => 'Clave SSH';
	@override String get existingInfo => 'El espacio de trabajo se añadirá a tu lista de proyectos y estará disponible para sesiones de Claude/Cursor.';
	@override String get newWithClone => 'El repositorio se clonará desde esta carpeta.';
	@override String get newEmpty => 'El espacio de trabajo se añadirá a tu lista de proyectos y estará disponible para sesiones de Claude/Cursor.';
	@override String get cloningRepository => 'Clonando repositorio...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$es extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get back => 'Atrás';
	@override String get next => 'Siguiente';
	@override String get createProject => 'Crear proyecto';
	@override String get creating => 'Creando...';
	@override String get cloning => 'Clonando...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$es extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Selecciona si tienes un espacio de trabajo existente o quieres crear uno nuevo';
	@override String get providePath => 'Proporciona la ruta del espacio de trabajo';
	@override String get failedToCreate => 'No se pudo crear el espacio de trabajo';
	@override String get failedToCreateFolder => 'No se pudo crear la carpeta';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$es extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$es generic = Translations$common$notifications$codes$generic$es._(_root);
	@override late final Translations$common$notifications$codes$permission$es permission = Translations$common$notifications$codes$permission$es._(_root);
	@override late final Translations$common$notifications$codes$run$es run = Translations$common$notifications$codes$run$es._(_root);
	@override late final Translations$common$notifications$codes$agent$es agent = Translations$common$notifications$codes$agent$es._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$es extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get close => 'Cerrar';
	@override String get later => 'Más tarde';
	@override String get copyCommand => 'Copiar comando';
	@override String get updateNow => 'Actualizar ahora';
	@override String get updating => 'Actualizando...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$es extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Cerrar el modal de actualización de versión';
	@override String get showSidebar => 'Mostrar barra lateral';
	@override String get settings => 'Ajustes';
	@override String get updateAvailable => 'Actualización disponible';
	@override String get closeSidebar => 'Cerrar barra lateral';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$es extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Activa Browser en ajustes para que los agentes abran sesiones de navegador supervisadas.';
	@override String get descEnabled => 'Las sesiones de navegador del agente aparecen aquí mientras una tarea de IA usa Browser.';
	@override String get titleDisabled => 'Browser está desactivado';
	@override String get titleEnabled => 'Aún no hay sesiones de navegador';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$es extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'Falló la acción del navegador';
	@override String get loadFailed => 'No se pudo cargar Browser';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$es extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Usa Browser para inspeccionar el flujo de pago e informar de estados de UI rotos.';
	@override String get prompt2 => 'Abre <url> con Browser, interactúa con la página y resume qué cambió tras cada paso.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$es extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' d';
	@override String get hoursAgo => ' h';
	@override String get justNow => 'Ahora mismo';
	@override String get minutesAgo => ' min';
	@override String get never => 'Nunca';
	@override String get secondsAgo => ' s';
	@override String get unknown => 'Desconocido';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$es extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Desactivado';
	@override String get installing => 'Instalando';
	@override String get ready => 'Listo';
	@override String get setupRequired => 'Configuración requerida';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$es extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Ver todas las ramas (${count})';
	@override String commits({required Object count}) => 'Ver todos los commits (${count})';
	@override String files({required Object count}) => 'Ver todos los archivos (${count})';
	@override String sessions({required Object count}) => 'Ver todas las sesiones (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$es extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'El coste es una estimación del cliente según las tarifas por token publicadas; los modelos desconocidos muestran «—».';
	@override String get estCost => 'Coste est.';
	@override String get inputOutput => 'Entrada / Salida';
	@override String get model => 'Modelo';
	@override String get na => 'N/D';
	@override String get openSplit => 'Abrir en vista dividida';
	@override String get provider => 'Proveedor';
	@override String get selectSession => 'Selecciona una sesión…';
	@override String get tokensUsed => 'Tokens usados';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$es extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Acciones';
	@override String get branches => 'Ramas';
	@override String get commits => 'Commits';
	@override String get files => 'Archivos';
	@override String get git => 'Git';
	@override String get navigate => 'Navegar';
	@override String get sessions => 'Sesiones';
	@override String get settings => 'Ajustes';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$es extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get close => 'Cerrar';
	@override String get navigate => 'Navegar';
	@override String get select => 'Seleccionar';
	@override String get togglePalette => 'Alternar paleta';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$es extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Comparar sesiones';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => 'Abrir ajustes';
	@override String get selectProjectFirst => 'Selecciona primero un proyecto';
	@override String settingsEntry({required Object label}) => 'Ajustes: ${label}';
	@override String get startNewChat => 'Iniciar nuevo chat';
	@override String switchTo({required Object name}) => 'Cambiar a: ${name}';
	@override String get toggleTheme => 'Cambiar tema';
	@override String get tokensAndCost => 'tokens y coste';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$es extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get board => 'Ir al Panel de agentes';
	@override String get chat => 'Ir al Chat';
	@override String get files => 'Ir a Archivos';
	@override String get git => 'Ir a Git';
	@override String get sourceControl => 'Ir a Control de código';
	@override String get tasks => 'Ir a Tareas';
	@override String get usage => 'Ir a Cuota y uso';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$es extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Acciones';
	@override String get branches => 'Ramas';
	@override String get commits => 'Commits';
	@override String get compare => 'Comparar';
	@override String get files => 'Archivos';
	@override String get sessions => 'Sesiones';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$es extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => '¿Eliminar la rama «${branch}»? Una eliminación normal solo funciona si la rama está totalmente fusionada. No se puede deshacer.';
	@override String confirmSwitch({required Object branch}) => '¿Cambiar a la rama «${branch}»? Asegúrate de no tener cambios sin confirmar.';
	@override String countBoth({required Object local, required Object remote}) => '${local} locales, ${remote} remotas';
	@override String countLocal({required Object count}) => '${count} locales';
	@override String get current => 'actual';
	@override String deleteTitle({required Object branch}) => 'Eliminar ${branch}';
	@override String get emptyDesc => 'Crea una rama para empezar trabajo en paralelo.';
	@override String get forceDelete => 'Forzar eliminación';
	@override String get forceDeleteDesc => 'Elimina permanentemente la rama aunque contenga commits no fusionados en otro lugar.';
	@override String get forceDeleteLabel => 'Forzar la eliminación de esta rama sin fusionar';
	@override String get local => 'Locales';
	@override String get kNew => 'Nueva rama';
	@override String get noMatch => 'Ninguna rama coincide con la búsqueda';
	@override String get none => 'No se encontraron ramas';
	@override String get remote => 'remotas';
	@override String get kSwitch => 'Cambiar';
	@override String switchTo({required Object branch}) => 'Cambiar a ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$es extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Confirmar';
	@override String get delete => 'Eliminar';
	@override String get deleteBranch => 'Eliminar';
	@override String get discard => 'Descartar';
	@override String get publish => 'Publicar';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get revertLocalCommit => 'Revertir commit';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$es extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Confirmar acción';
	@override String get delete => 'Eliminar archivo';
	@override String get deleteBranch => 'Eliminar rama';
	@override String get discard => 'Descartar cambios';
	@override String get publish => 'Publicar rama';
	@override String get pull => 'Confirmar pull';
	@override String get push => 'Confirmar push';
	@override String get revertLocalCommit => 'Revertir commit local';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$es extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Falló la creación de la rama';
	@override String get createWorktreeFailed => 'No se pudo crear el worktree';
	@override String get deleteBranchFailed => 'Falló la eliminación de la rama';
	@override String get fetchFailed => 'Falló el fetch';
	@override String get initFailed => 'No se pudo inicializar el repositorio';
	@override String get initialCommitFailed => 'No se pudo crear el commit inicial';
	@override String get mergeFailed => 'Falló la fusión';
	@override String get openWorktreeFailed => 'No se pudo abrir el worktree';
	@override String get operationFailed => 'Falló la operación git';
	@override String get publishFailed => 'Falló la publicación';
	@override String get pullFailed => 'Falló el pull';
	@override String get pushFailed => 'Falló el push';
	@override String get removeWorktreeFailed => 'No se pudo eliminar el worktree';
	@override String get stageFailed => 'Falló la preparación';
	@override String get stageHunksFailed => 'Falló la preparación de secciones';
	@override String get switchFailed => 'Falló el cambio de rama';
	@override String get unstageFailed => 'Falló la quita de preparación';
	@override String get unstageHunksFailed => 'Falló la quita de preparación de secciones';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$es extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get added => 'Añadidas';
	@override String get author => 'Autor';
	@override String get changedFiles => 'Archivos modificados';
	@override String get date => 'Fecha';
	@override String get empty => 'No se encontraron commits';
	@override String get files => 'Archivos';
	@override String get removed => 'Eliminadas';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$es extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Eliminar el worktree y borrar su rama una vez fusionada';
	@override String get cleanupLabel => 'Limpiar tras la fusión';
	@override String commitCount({required Object count}) => '${count} commit(s)';
	@override String get merge => 'Fusionar';
	@override String mergeMessage({required Object branch}) => 'Fusionar la rama \'${branch}\'';
	@override String get messageLabel => 'Mensaje de commit';
	@override String squashDesc({required Object commits, required Object branch}) => 'Combinar los ${commits} en un solo commit en ${branch}';
	@override String get squashLabel => 'Compactar commits';
	@override String get squashMerge => 'Compactar y fusionar';
	@override String squashMessage({required Object branch}) => 'Compactar y fusionar la rama \'${branch}\'';
	@override String get title => 'Fusionar worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$es extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Esto creará una nueva rama desde la rama actual (${branch})';
	@override String get nameLabel => 'Nombre de la rama';
	@override String get submit => 'Crear rama';
	@override String get title => 'Crear nueva rama';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$es extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Rama';
	@override String get createFrom => 'Crear desde';
	@override String get description => 'Extrae una rama en su propia carpeta y trabaja en ella en paralelo.';
	@override String get existingBranch => 'Rama existente — se extraerá tal cual.';
	@override String get submit => 'Crear worktree';
	@override String get switchAfter => 'Cambiar al worktree tras crearlo';
	@override String get title => 'Nuevo worktree';
	@override String get willCreateIn => 'Se creará en';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$es extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get create => 'Crear commit inicial';
	@override String get creating => 'Creando commit inicial...';
	@override String get description => 'Este repositorio aún no tiene commits. Crea tu primer commit para empezar a rastrear cambios.';
	@override String get title => 'Aún no hay commits';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$es extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Este proyecto aún no es un repositorio git. Inicializa uno para rastrear cambios y usar el control de código.';
	@override String get init => 'Ejecutar git init';
	@override String get initializing => 'Inicializando repositorio...';
	@override String get title => 'Sin repositorio git';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$es extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Eliminar también la rama';
	@override String description({required Object branch}) => '¿Eliminar el worktree de ${branch}? Su carpeta se borra y el proyecto vinculado se archiva — las sesiones de chat siguen siendo recuperables.';
	@override String dirtyWarning({required Object count}) => 'Este worktree tiene ${count} cambio(s) sin confirmar que se perderán.';
	@override String get discardChanges => 'Descartar cambios sin confirmar';
	@override String get title => 'Eliminar worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$es extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get added => 'Añadido';
	@override String get deleted => 'Eliminado';
	@override String get modified => 'Modificado';
	@override String get untracked => 'Sin seguimiento';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$es extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} cambio(s)';
	@override String count({required Object count}) => '${count} worktree(s)';
	@override String get createFirst => 'Crea tu primer worktree';
	@override String get detached => 'separado';
	@override String detachedAt({required Object sha}) => 'separado @ ${sha}';
	@override String get detachedHead => 'HEAD detached';
	@override String get emptyDesc => 'Un worktree extrae una rama en su propia carpeta, así puedes tener sesiones de chat paralelas y fusionar los resultados cuando estén listos.';
	@override String get emptyTitle => 'Trabaja en ramas en paralelo';
	@override String get locked => 'bloqueado';
	@override String get mainWorktree => 'worktree principal';
	@override String mergeTitle({required Object branch}) => 'Fusionar ${branch} en la rama base';
	@override String get kNew => 'Nuevo worktree';
	@override String get none => 'Sin worktrees';
	@override String get nothingToMerge => 'Nada que fusionar — no hay commits por delante de la rama base';
	@override String get open => 'Abrir';
	@override String get refresh => 'Actualizar worktrees';
	@override String removeTitle({required Object branch}) => 'Eliminar worktree de ${branch}';
	@override String switchTo({required Object branch}) => 'Cambiar a ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$es extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Cambios';
	@override String get history => 'Commits';
	@override String get branches => 'Ramas';
	@override String get worktrees => 'Worktrees';
}

// Path: common.gitPanel.worktreeScripts
class Translations$common$gitPanel$worktreeScripts$es extends Translations$common$gitPanel$worktreeScripts$en {
	Translations$common$gitPanel$worktreeScripts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Scripts del worktree';
	@override String get setup => 'Script de configuración (se ejecuta tras crear/abrir)';
	@override String get run => 'Iniciar servidor de desarrollo';
	@override String get stop => 'Detener servidor de desarrollo';
	@override String get runScript => 'Script de ejecución (servidor de desarrollo, bajo demanda)';
	@override String get runPort => 'Puerto de vista previa (opcional — se detecta automáticamente si está vacío)';
	@override String get invalidPort => 'El puerto debe estar entre 1 y 65535';
	@override String get sourceProject => 'Guardado como configuración específica del proyecto';
	@override String get sourceFile => 'Desde .ddagent/worktree.json — al guardar se crea una configuración específica del proyecto';
	@override String get sourceNone => 'Aún no hay nada configurado';
	@override String get saving => 'Guardando…';
	@override String get setupRunning => 'configuración en curso';
	@override String get setupFailed => 'la configuración falló';
	@override String get running => 'en ejecución';
	@override String get openPreview => 'Abrir vista previa';
	@override String runExited({required Object code}) => 'la ejecución terminó (${code})';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$es extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ámbito';
	@override String get user => 'Usuario';
	@override String get project => 'Proyecto';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$es extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get system => 'Sistema';
	@override String get light => 'Claro';
	@override String get dark => 'Oscuro';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$es extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Apariencia';
	@override String get toolDisplay => 'Visualización de herramientas';
	@override String get inputSettings => 'Ajustes de entrada';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$es extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Arrastrando el control';
	@override String get closePanel => 'Cerrar panel de ajustes';
	@override String get openPanel => 'Abrir panel de ajustes';
	@override String get draggingStatus => 'Arrastrando...';
	@override String get toggleAndMove => 'Clic para alternar, arrastra para mover';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$es extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Cerrar panel de atajos';
	@override String get openPanel => 'Abrir panel de atajos';
}

// Path: settings.miniOrchestration.enable
class Translations$settings$miniOrchestration$enable$es extends Translations$settings$miniOrchestration$enable$en {
	Translations$settings$miniOrchestration$enable$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Activar miniorquestación';
	@override String get description => 'Envía las sesiones Auto (mini) a través del motor de dos roles en lugar del orquestador completo.';
}

// Path: settings.miniOrchestration.thinker
class Translations$settings$miniOrchestration$thinker$es extends Translations$settings$miniOrchestration$thinker$en {
	Translations$settings$miniOrchestration$thinker$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pensador (no flash)';
	@override String get description => 'Planifica, decide, revisa y redacta el informe final.';
}

// Path: settings.miniOrchestration.worker
class Translations$settings$miniOrchestration$worker$es extends Translations$settings$miniOrchestration$worker$en {
	Translations$settings$miniOrchestration$worker$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ejecutor (flash)';
	@override String get description => 'Ejecuta cada paso planificado.';
}

// Path: settings.miniOrchestration.fields
class Translations$settings$miniOrchestration$fields$es extends Translations$settings$miniOrchestration$fields$en {
	Translations$settings$miniOrchestration$fields$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Proveedor';
	@override String get model => 'Modelo';
	@override String get modelPlaceholder => 'Selecciona un modelo';
	@override String get tier => 'Nivel';
}

// Path: settings.miniOrchestration.roles
class Translations$settings$miniOrchestration$roles$es extends Translations$settings$miniOrchestration$roles$en {
	Translations$settings$miniOrchestration$roles$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Modelo por tarea';
	@override String get description => 'Qué modelo (rol) se encarga de cada tipo de tarea.';
}

// Path: settings.miniOrchestration.planner
class Translations$settings$miniOrchestration$planner$es extends Translations$settings$miniOrchestration$planner$en {
	Translations$settings$miniOrchestration$planner$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planificador';
	@override String get mode => 'Modo';
	@override late final Translations$settings$miniOrchestration$planner$modes$es modes = Translations$settings$miniOrchestration$planner$modes$es._(_root);
	@override String get requireConfirmLabel => 'Confirmar el plan antes de ejecutarlo';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$es extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Activar orquestación';
	@override String get description => 'Deja que el orquestador elija un modelo por paso en lugar de ejecutarlo todo en un único proveedor.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$es extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Grupo de candidatos';
	@override String get description => 'Modelos entre los que puede elegir el enrutador, cada uno asignado a un nivel de coste.';
	@override String get add => 'Añadir candidato';
	@override String get empty => 'Aún no hay candidatos — añade uno para empezar a enrutar.';
	@override late final Translations$settings$orchestration$pool$fields$es fields = Translations$settings$orchestration$pool$fields$es._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$es extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$es extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reglas de enrutamiento';
	@override String get description => 'Candidatos ordenados por tipo de tarea — gana el primero disponible.';
	@override String get addCandidate => 'Añadir candidato…';
	@override String get empty => 'Sin candidatos — no hay adónde enrutar este tipo de tarea.';
	@override String get missing => '(removed)';
	@override String get remove => 'Eliminar candidato';
	@override late final Translations$settings$orchestration$rules$taskTypes$es taskTypes = Translations$settings$orchestration$rules$taskTypes$es._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$es extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'Cómo se divide una solicitud en pasos enrutados.';
	@override String get modeLabel => 'Modo de planificación';
	@override late final Translations$settings$orchestration$planner$modes$es modes = Translations$settings$orchestration$planner$modes$es._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$es modeHints = Translations$settings$orchestration$planner$modeHints$es._(_root);
	@override String get candidateLabel => 'Modelo planificador';
	@override String get candidateDescription => 'Candidato del grupo usado para generar planes y para las llamadas de clasificación.';
	@override String get candidatePlaceholder => 'Selecciona un candidato del grupo';
	@override late final Translations$settings$orchestration$planner$templates$es templates = Translations$settings$orchestration$planner$templates$es._(_root);
	@override String get requireConfirm => 'Confirmar el plan antes de ejecutarlo';
	@override String get requireConfirmDescription => 'Pausar tras planificar para que puedas editar o desactivar pasos en la tarjeta del plan.';
	@override String get checkpointLabel => 'Autonomía';
	@override late final Translations$settings$orchestration$planner$checkpointModes$es checkpointModes = Translations$settings$orchestration$planner$checkpointModes$es._(_root);
	@override late final Translations$settings$orchestration$planner$checkpointHints$es checkpointHints = Translations$settings$orchestration$planner$checkpointHints$es._(_root);
	@override String get checkpointIntervalLabel => 'Pasos entre puntos de control (1–50)';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$es extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Límites de ejecución';
	@override String get description => 'Salvaguardas para ejecuciones en paralelo y bucles de corrección.';
	@override String get maxParallel => 'Máx. pasos en paralelo';
	@override String get maxParallelDescription => 'Cuántas subtareas pueden ejecutarse a la vez (1–8).';
	@override String get maxFixLoops => 'Máx. bucles de corrección';
	@override String get maxFixLoopsDescription => 'Reintentos cuando un paso no supera la verificación (0–5).';
	@override String get onNoCandidate => 'Cuando no hay ningún candidato disponible';
	@override String get onNoCandidateDescription => 'Preguntar antes de recurrir a una alternativa u omitir el paso.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$es onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$es._(_root);
	@override String get useWorktree => 'Worktree aislado';
	@override String get useWorktreeDescription => 'Ejecuta todos los pasos delegados en un único worktree de git compartido en lugar del directorio del proyecto.';
	@override String get maxSupervisorIterations => 'Máx. iteraciones del supervisor';
	@override String get maxSupervisorIterationsDescription => 'Límite de rondas de decisión del supervisor en modo automático (1–100); al alcanzarlo, la ejecución termina con un informe parcial.';
	@override String get maxAttempts => 'Máx. intentos por paso';
	@override String get maxAttemptsDescription => 'Presupuesto total de intentos para un paso entre carriles y reintentos (1–50).';
	@override String get stepTimeoutMs => 'Tiempo límite por paso (ms)';
	@override String get stepTimeoutMsDescription => 'Tiempo límite por intento de la ejecución secundaria en milisegundos; 0 lo desactiva.';
	@override String get runTimeoutMs => 'Tiempo límite de ejecución (ms)';
	@override String get runTimeoutMsDescription => 'Tiempo límite global de ejecución del plan en milisegundos; 0 lo desactiva.';
	@override String get retryBackoffBaseMs => 'Base del backoff de reintentos (ms)';
	@override String get retryBackoffBaseMsDescription => 'Base del backoff exponencial entre reintentos en el mismo carril (jitter completo).';
	@override String get retryBudgetTitle => 'Presupuesto de reintentos por tipo de fallo';
	@override String get retryBudgetDescription => 'Reintentos en el mismo carril antes de conmutar o enfriar (0–5).';
	@override late final Translations$settings$orchestration$execution$retryClasses$es retryClasses = Translations$settings$orchestration$execution$retryClasses$es._(_root);
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$es extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unsaved => 'Cambios sin guardar';
	@override String get save => 'Save';
	@override String get saving => 'Saving…';
	@override String get saved => 'Saved';
	@override String get discard => 'Discard';
	@override String get error => 'Save failed';
	@override String get emptyPool => 'Añade al menos un candidato antes de guardar.';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$es extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificar en este navegador';
	@override String get enable => 'Activar notificaciones';
	@override String get disable => 'Desactivar notificaciones';
	@override String get enabled => 'Las notificaciones están activadas en este navegador';
	@override String get loading => 'Actualizando...';
	@override String get unsupported => 'Las notificaciones push no son compatibles con este navegador.';
	@override String get denied => 'Las notificaciones push están bloqueadas. Permítelas en los ajustes de tu navegador.';
	@override String get iosHint => 'En iPhone/iPad, las notificaciones solo funcionan tras añadir DDAgent a la pantalla de inicio (Compartir → Añadir a pantalla de inicio) y activarlas desde la app instalada.';
	@override String get test => 'Enviar notificación de prueba';
	@override String get testNoSubscription => 'Ningún dispositivo está suscrito. Toca «Activar» en el teléfono primero.';
	@override String testSuccess({required Object count}) => 'Enviado a ${count} dispositivo(s). Si no aparece nada en el teléfono, añade DDAgent a la pantalla de inicio (iOS lo requiere).';
	@override String get testNotDelivered => 'Ningún dispositivo estaba disponible. Asegúrate de que la app esté en ejecución y las notificaciones activadas.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$es extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificar a este dispositivo';
	@override String get enabled => 'Las notificaciones están activadas para este dispositivo';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$es extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificar en esta app de escritorio';
	@override String get enable => 'Activar notificaciones';
	@override String get disable => 'Desactivar notificaciones';
	@override String get enabled => 'Las notificaciones están activadas en esta app de escritorio';
	@override String get unsupported => 'Las notificaciones de escritorio no son compatibles con este sistema.';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$es extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sonido';
	@override String get description => 'Reproduce un tono corto cuando una ejecución del chat termina o necesita aprobación de una herramienta.';
	@override String get enabled => 'Activado';
	@override String get test => 'Probar sonido';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$es extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tipos de evento';
	@override String get actionRequired => 'Acción requerida';
	@override String get stop => 'Ejecución detenida';
	@override String get error => 'Ejecución fallida';
}

// Path: settings.notifications.messaging
class Translations$settings$notifications$messaging$es extends Translations$settings$notifications$messaging$en {
	Translations$settings$notifications$messaging$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aprobaciones por mensajería';
	@override String get description => 'Aprueba o deniega las solicitudes de permisos de los agentes desde Telegram y recibe notificaciones de ejecución en Discord.';
	@override String get enabled => 'Activado';
	@override String get save => 'Guardar';
	@override String get test => 'Probar';
	@override String get pair => 'Vincular';
	@override String get telegramToken => 'Token del bot de @BotFather (123456:ABC…)';
	@override String get telegramHint => 'Envía cualquier mensaje a tu bot y luego vincula el chat abajo.';
	@override String get discordWebhook => 'https://discord.com/api/webhooks/…';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$es extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get telegram => 'Telegram';
	@override String get discord => 'Discord';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$es extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Modo oscuro';
	@override String get description => 'Alterna entre el tema claro y el oscuro';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$es extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Editor de código';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$es theme = Translations$settings$appearanceSettings$codeEditor$theme$es._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$es wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$es._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$es showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$es._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$es lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$es._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$es fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$es._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$es extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$es focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$es._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$es extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get add => 'Añadir servidor MCP';
	@override String get edit => 'Editar servidor MCP';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$es extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get form => 'Formulario';
	@override String get json => 'Importar JSON';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$es extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ámbito';
	@override String get userGlobal => 'Usuario (global)';
	@override String get projectLocal => 'Proyecto (local)';
	@override String get userDescription => 'Ámbito de usuario: disponible en todos los proyectos de tu máquina';
	@override String get projectDescription => 'Ámbito local: solo disponible en el proyecto seleccionado';
	@override String get cannotChange => 'El ámbito no se puede cambiar al editar un servidor existente';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$es extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Nombre del servidor';
	@override String get transportType => 'Tipo de transporte';
	@override String get command => 'Comando';
	@override String get arguments => 'Argumentos (uno por línea)';
	@override String get jsonConfig => 'Configuración JSON';
	@override String get url => 'URL';
	@override String get envVars => 'Variables de entorno (CLAVE=valor, una por línea)';
	@override String get headers => 'Cabeceras (CLAVE=valor, una por línea)';
	@override String get selectProject => 'Selecciona un proyecto...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$es extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'mi-servidor';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$es extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Falta el campo obligatorio: type';
	@override String get stdioRequiresCommand => 'El tipo stdio requiere un campo command';
	@override String httpRequiresUrl({required Object type}) => 'El tipo ${type} requiere un campo url';
	@override String get invalidJson => 'Formato JSON no válido';
	@override String get jsonHelp => 'Pega la configuración de tu servidor MCP en formato JSON. Formatos de ejemplo:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$es extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get saving => 'Guardando...';
	@override String get addServer => 'Añadir servidor';
	@override String get updateServer => 'Actualizar servidor';
}

// Path: settings.git.name
class Translations$settings$git$name$es extends Translations$settings$git$name$en {
	Translations$settings$git$name$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Nombre para Git';
	@override String get help => 'Tu nombre para los commits de git';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$es extends Translations$settings$git$email$en {
	Translations$settings$git$email$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Correo para Git';
	@override String get help => 'Tu correo para los commits de git';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$es extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get save => 'Guardar configuración';
	@override String get saving => 'Guardando...';
}

// Path: settings.git.status
class Translations$settings$git$status$es extends Translations$settings$git$status$en {
	Translations$settings$git$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get success => 'Guardado correctamente';
	@override String get error => 'Error al guardar';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$es extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ Guarda tu clave API';
	@override String get alertMessage => 'Esta es la única vez que verás esta clave. Guárdala en un lugar seguro.';
	@override String get iveSavedIt => 'Ya la guardé';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$es extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Nombre de la clave API (p. ej., Servidor de producción)';
	@override String get createButton => 'Crear';
	@override String get cancelButton => 'Cancelar';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$es extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get created => 'Creada:';
	@override String get lastUsed => 'Último uso:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$es extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get active => 'Activa';
	@override String get inactive => 'Inactiva';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$es extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tokens de GitHub';
	@override String get description => 'Añade tokens de acceso personal de GitHub para clonar repositorios privados mediante la API externa.';
	@override String get descriptionAlt => 'Añade tokens de acceso personal de GitHub para clonar repositorios privados. También puedes pasar tokens directamente en las solicitudes de API sin guardarlos.';
	@override String get addButton => 'Añadir token';
	@override late final Translations$settings$apiKeys$github$form$es form = Translations$settings$apiKeys$github$form$es._(_root);
	@override String get empty => 'Aún no se han añadido tokens de GitHub.';
	@override String get added => 'Añadido:';
	@override String get confirmDelete => '¿Seguro que quieres eliminar este token de GitHub?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$es extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Documentación de la API externa';
	@override String get description => 'Aprende a usar la API externa para lanzar sesiones de Claude/Cursor desde tus aplicaciones.';
	@override String get viewLink => 'Ver documentación de la API →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$es extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Actualización disponible: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$es extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'La CLI de TaskMaster AI no está instalada';
	@override String get description => 'La CLI de TaskMaster es necesaria para usar las funciones de gestión de tareas. Instálala para empezar:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'Ver en GitHub';
	@override String get afterInstallation => 'Después de la instalación:';
	@override late final Translations$settings$tasks$notInstalled$steps$es steps = Translations$settings$tasks$notInstalled$steps$es._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$es extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'Activar integración con TaskMaster';
	@override String get enableDescription => 'Muestra tareas, banners e indicadores de TaskMaster en la barra lateral y el resto de la interfaz';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$es extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Comprobando...';
	@override String get connected => 'Conectado';
	@override String get notConnected => 'No conectado';
	@override String get disconnected => 'Desconectado';
	@override String get checkingAuth => 'Comprobando el estado de autenticación...';
	@override String loggedInAs({required Object email}) => 'Sesión iniciada como ${email}';
	@override String providerAccount({required Object provider}) => 'Cuenta de ${provider}';
	@override String get authenticatedUser => 'usuario autenticado';
}

// Path: settings.agents.install
class Translations$settings$agents$install$es extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => 'La CLI de ${agent} no está instalada';
	@override String description({required Object agent}) => 'Instala la CLI de ${agent} para iniciar sesión y ejecutar sesiones.';
	@override String get button => 'Instalar';
	@override String get installing => 'Instalando…';
	@override String get copyCommand => 'Copiar comando';
	@override String get docs => 'Documentación';
	@override String success({required Object agent}) => 'CLI de ${agent} instalada';
	@override String get failed => 'La instalación falló — revisa la salida de la terminal';
}

// Path: settings.agents.update
class Translations$settings$agents$update$es extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Actualizar CLI';
	@override String description({required Object agent}) => 'Instala la versión más reciente del CLI de ${agent} en el host del servidor.';
	@override String get button => 'Actualizar';
	@override String get updating => 'Actualizando…';
	@override String success({required Object agent}) => 'CLI de ${agent} actualizado';
	@override String get failed => 'La actualización falló — revisa la salida del terminal';
}

// Path: settings.agents.account
class Translations$settings$agents$account$es extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$es claude = Translations$settings$agents$account$claude$es._(_root);
	@override late final Translations$settings$agents$account$cursor$es cursor = Translations$settings$agents$account$cursor$es._(_root);
	@override late final Translations$settings$agents$account$codex$es codex = Translations$settings$agents$account$codex$es._(_root);
	@override late final Translations$settings$agents$account$opencode$es opencode = Translations$settings$agents$account$opencode$es._(_root);
	@override late final Translations$settings$agents$account$commandcode$es commandcode = Translations$settings$agents$account$commandcode$es._(_root);
	@override late final Translations$settings$agents$account$antigravity$es antigravity = Translations$settings$agents$account$antigravity$es._(_root);
	@override late final Translations$settings$agents$account$devin$es devin = Translations$settings$agents$account$devin$es._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$es extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Iniciar sesión';
	@override String get reAuthenticate => 'Volver a autenticar';
	@override String description({required Object agent}) => 'Inicia sesión en tu cuenta de ${agent} para activar las funciones de IA';
	@override String get reAuthDescription => 'Inicia sesión con otra cuenta o actualiza las credenciales';
	@override String get button => 'Iniciar sesión';
	@override String get reLoginButton => 'Volver a iniciar sesión';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$es extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cerrar sesión';
	@override String get description => 'Cierra la sesión de este proveedor y borra sus credenciales guardadas';
	@override String get button => 'Cerrar sesión';
	@override String confirmTitle({required Object agent}) => '¿Cerrar sesión de ${agent}?';
	@override String confirmDescription({required Object agent}) => 'Esto elimina las credenciales guardadas de ${agent} en el servidor. Vuelve a iniciar sesión para seguir usando ${agent}.';
	@override String get success => 'Sesión cerrada';
	@override String get failed => 'No se pudo cerrar la sesión';
}

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$es extends Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cuentas con nombre';
	@override String get description => 'Conjuntos de credenciales adicionales. Una sesión asociada a una cuenta inicia la CLI con su directorio de configuración aislado. Inicia sesión ejecutando una vez la CLI del proveedor con las variables de entorno mostradas.';
	@override String get sharedCli => 'Todas las cuentas comparten una instalación de la CLI — actualízala en la tarjeta de conexión de arriba.';
	@override String get loading => 'Cargando cuentas…';
	@override String get kDefault => 'Predeterminada';
	@override String usage({required Object tokens}) => '${tokens} tokens';
	@override String get usageButton => 'Uso';
	@override String get showUsage => 'Mostrar uso de tokens';
	@override String get makeDefault => 'Establecer como predeterminada';
	@override String get remove => 'Eliminar cuenta';
	@override String get newLabel => 'Nombre de la cuenta (p. ej. Trabajo)';
	@override String get add => 'Añadir cuenta';
	@override late final Translations$settings$agents$accounts$autoSwitch$es autoSwitch = Translations$settings$agents$accounts$autoSwitch$es._(_root);
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$es extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Modo de permisos';
	@override String description({required Object provider}) => 'Modo de permiso predeterminado para nuevas sesiones de ${provider}. Aún puedes anularlo para una sesión individual.';
	@override late final Translations$settings$permissions$permissionMode$modes$es modes = Translations$settings$permissions$permissionMode$modes$es._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$es extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Claude';
	@override String get cursor => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Cursor';
	@override String get codex => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Codex';
	@override String get opencode => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a OpenCode';
	@override String get commandcode => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Command Code';
	@override String get antigravity => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Antigravity';
	@override String get devin => 'Los servidores Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Devin';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$es extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get local => 'local';
	@override String get user => 'usuario';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$es extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get command => 'Comando';
	@override String get url => 'URL';
	@override String get args => 'Argumentos';
	@override String get environment => 'Entorno';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$es extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Herramientas';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count} más';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$es extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Editar servidor';
	@override String get delete => 'Eliminar servidor';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$es extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Gestionado';
	@override String get hint => 'Gestionado por DDAgent.';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$es extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Acerca de MCP en Codex';
	@override String get description => 'Codex admite servidores MCP basados en stdio. Puedes añadir servidores que amplíen las capacidades de Codex con herramientas y recursos adicionales.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$es extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '«${serverName}» se eliminará de la configuración del proveedor.';
	@override String get title => '¿Eliminar el servidor MCP?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$es extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Centro de control';
	@override String get title => 'Centro de control';
	@override String get description => 'Umbrales de alerta, política de enrutamiento y cuentas consultadas para cuotas.';
	@override String get saved => 'Guardado';
	@override String get alertsSection => 'Alertas';
	@override String get alertsSectionHint => 'Avisar antes de que un límite se agote de verdad, no solo al 100%.';
	@override String get alertsEnabled => 'Alertas de límite previsto';
	@override String get alertsEnabledHint => 'Mostrar proyecciones basadas en el ritmo en el resumen y las tarjetas de cuenta.';
	@override String get watchThreshold => 'Umbral de observación (%)';
	@override String get watchThresholdHint => 'Las cuentas en o por encima de esta lectura cuentan como en riesgo.';
	@override String get dangerThreshold => 'Umbral de peligro (%)';
	@override String get dangerThresholdHint => 'Las lecturas en o por encima de este valor se muestran en rojo.';
	@override String get routingSection => 'Enrutamiento';
	@override String get routingSectionHint => 'Cómo puede el panel mover trabajo a la cuenta con más margen.';
	@override late final Translations$settings$quota$settings$routing$es routing = Translations$settings$quota$settings$routing$es._(_root);
	@override String get routingNote => 'Cambiar de cuenta altera el costo y la calidad del modelo, por lo que siempre requiere una decisión explícita.';
	@override String get accountsSection => 'Cuentas consultadas';
	@override String get accountsSectionHint => 'Las credenciales se leen de cada herramienta; el panel nunca las envía a otro lugar.';
	@override String get sourcesSection => 'Fuentes de datos';
	@override String get sourcesSectionHint => 'De dónde provienen las cifras de uso y costo.';
	@override String get logSources => 'Almacén de registros de tokens y costos';
	@override String get logSourcesHint => 'Almacén de agregados de solo lectura compartido con el colector tokboard.';
	@override String get readOnly => 'Solo lectura';
	@override String get quotaConsent => 'Consulta de cuotas';
	@override String get quotaConsentHint => 'Lee los endpoints de cuota de los proveedores con credenciales guardadas localmente.';
	@override String get localOnly => 'Solo local';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$es extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Aún no se detectaron cuentas.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$es extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cached => 'en caché';
	@override String get error => 'error';
	@override String get estimate => 'estimación';
	@override String get live => 'en vivo';
	@override String get unknown => 'desconocido';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$es extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'No se pudo instalar el runtime del navegador';
	@override String get loadSettings => 'No se pudieron cargar los ajustes de Browser';
	@override String get loadStatus => 'No se pudo cargar el estado de Browser';
	@override String get saveSettings => 'No se pudieron guardar los ajustes de Browser';
}

// Path: settings.about.pro
class Translations$settings$about$pro$es extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Sincronizar ajustes';
	@override String get teamManagement => 'Gestión de equipo';
	@override String get syncSettingsDescription => 'Mantén tus preferencias, configuraciones MCP y tema sincronizados en todos tus entornos.';
	@override String get teamManagementDescription => 'Varios usuarios, acceso basado en roles y proyectos compartidos para tu equipo.';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$es extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'Gestión de tareas con IA: descompone proyectos complejos en subtareas manejables';
	@override String get prdTemplates => 'Plantillas PRD: genera tareas a partir de Documentos de Requisitos de Producto';
	@override String get dependencyTracking => 'Seguimiento de dependencias: entiende las relaciones entre tareas y el orden de ejecución';
	@override String get progressVisualization => 'Visualización del progreso: tableros Kanban y analíticas detalladas de tareas';
	@override String get cliIntegration => 'Integración CLI: usa comandos de taskmaster para flujos de trabajo avanzados';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$es extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$es createPRD = Translations$tasks$gettingStarted$steps$createPRD$es._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$es generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$es._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$es analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$es._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$es startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$es._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$es extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Ejemplo:\n"Acabo de inicializar un proyecto nuevo con Claude Task Master. Tengo un PRD en .taskmaster/docs/prd.txt. ¿Me ayudas a analizarlo y configurar las tareas iniciales?"';
	@override String get expandTask => '💬 Ejemplo:\n"La tarea 5 parece compleja. ¿Puedes descomponerla en subtareas?"';
	@override String get addTask => '💬 Ejemplo:\n"Añade una tarea nueva para implementar la subida de imágenes de perfil de usuario con Cloudinary, e investiga el mejor enfoque."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$es extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Consejos pro';
	@override String get search => 'Usa la barra de búsqueda para encontrar tareas específicas rápidamente';
	@override String get views => 'Cambia entre las vistas Kanban, Lista y Cuadrícula con los selectores de vista';
	@override String get filters => 'Usa los filtros para centrarte en estados o prioridades específicas';
	@override String get details => 'Haz clic en cualquier tarea para ver información detallada y gestionar subtareas';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$es extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 Más información';
	@override String get description => 'TaskMaster AI es un sistema avanzado de gestión de tareas creado para desarrolladores. Consulta la documentación, ejemplos y contribuye al proyecto.';
	@override String get githubButton => 'Ver en GitHub';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$es extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aún no hay tarjetas';
	@override String get description => 'Añade una tarjeta, describe la tarea y arrástrala a Lista para que un agente empiece a trabajar.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$es extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Backlog';
	@override String get ready => 'Lista para empezar';
	@override String get working => 'Trabajando';
	@override String get needsDecision => 'Necesita tu decisión';
	@override String get done => 'Hecha';
	@override String get archived => 'Archivadas';
}

// Path: tasks.board.card
class Translations$tasks$board$card$es extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get running => 'En ejecución';
	@override String get abort => 'Abortar';
	@override String get delete => 'Eliminar';
	@override String get openSession => 'Abrir sesión';
	@override String get pullRequest => 'Pull request';
	@override String get edit => 'Editar';
	@override String get moveTo => 'Mover a';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$es extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Nueva tarjeta';
	@override String get editTitle => 'Editar tarjeta';
	@override String get titleLabel => 'Título';
	@override String get titlePlaceholder => '¿Qué debe hacer el agente?';
	@override String get descriptionLabel => 'Descripción';
	@override String get descriptionPlaceholder => 'Añade contexto, criterios de aceptación, enlaces...';
	@override String get cancel => 'Cancelar';
	@override String get save => 'Guardar';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$es extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Agente';
	@override String get anyProvider => 'Cualquier agente';
	@override String get model => 'Modelo';
	@override String get defaultModel => 'Modelo predeterminado';
	@override String get effort => 'Razonamiento';
	@override String get defaultEffort => 'Predeterminado';
	@override String get searchModel => 'Buscar modelos…';
	@override String get noModels => 'Sin modelos coincidentes';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$es extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '«${cardTitle}» se eliminará permanentemente.';
	@override String get title => '¿Eliminar la tarjeta?';
}

// Path: tasks.board.assignee
class Translations$tasks$board$assignee$es extends Translations$tasks$board$assignee$en {
	Translations$tasks$board$assignee$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Responsable';
	@override String get all => 'Todos los responsables';
	@override String get unassigned => 'Sin asignar';
}

// Path: tasks.board.presence
class Translations$tasks$board$presence$es extends Translations$tasks$board$presence$en {
	Translations$tasks$board$presence$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String online({required Object count}) => '${count} en línea';
}

// Path: tasks.board.activity
class Translations$tasks$board$activity$es extends Translations$tasks$board$activity$en {
	Translations$tasks$board$activity$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Actividad';
	@override String get empty => 'Aún no hay actividad';
}

// Path: tasks.board.comments
class Translations$tasks$board$comments$es extends Translations$tasks$board$comments$en {
	Translations$tasks$board$comments$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Comentarios';
	@override String get placeholder => 'Escribe un comentario…';
	@override String get send => 'Enviar';
	@override String get unknownAuthor => 'Alguien';
}

// Path: tasks.taskmaster.sort
class Translations$tasks$taskmaster$sort$es extends Translations$tasks$taskmaster$sort$en {
	Translations$tasks$taskmaster$sort$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get statusAz => 'Estado (A-Z)';
	@override String get statusZa => 'Estado (Z-A)';
}

// Path: tasks.taskmaster.prd
class Translations$tasks$taskmaster$prd$es extends Translations$tasks$taskmaster$prd$en {
	Translations$tasks$taskmaster$prd$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get fileNameRequired => 'Indica un nombre de archivo para el PRD.';
	@override String get contentRequired => 'Añade contenido antes de guardar.';
	@override String get overwrite => 'Sobrescribir';
	@override String get contentHint => '# Documento de requisitos del producto…';
}

// Path: tasks.taskmaster.detail
class Translations$tasks$taskmaster$detail$es extends Translations$tasks$taskmaster$detail$en {
	Translations$tasks$taskmaster$detail$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get dependenciesLabel => 'Dependencias (ID separados por comas)';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$es extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Cwd';
	@override String get envVars => 'Variables de entorno';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$es extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get userAllProviders => 'Usuario (todos los proveedores)';
	@override String get claudeLocal => 'Claude local';
	@override String get projectAllProviders => 'Proyecto (todos los proveedores)';
	@override late final Translations$mcp$form$scope$description$es description = Translations$mcp$form$scope$description$es._(_root);
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$es extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get workingDirectory => 'Directorio de trabajo';
	@override String get envVarNames => 'Nombres de variables de entorno';
	@override String get bearerTokenEnvVar => 'Variable de entorno del token Bearer';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$es extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => 'Añadir servidor MCP solo admite stdio y http en todos los proveedores, no ${type}.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} no admite servidores MCP de tipo ${type}';
	@override String get jsonMustBeObject => 'La configuración JSON debe ser un objeto';
}

// Path: serverConnect.local.errors
class Translations$serverConnect$local$errors$es extends Translations$serverConnect$local$errors$en {
	Translations$serverConnect$local$errors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get releaseTagUnresolved => 'No se pudo determinar la etiqueta de la última versión de DDAgent.';
	@override String get unsupportedPlatform => 'El servidor local no es compatible con esta plataforma.';
	@override String unsupportedPlatformDetail({required Object platform}) => 'El servidor local no es compatible con esta plataforma (${platform}).';
	@override String nodeExtractionFailed({required Object path}) => 'La extracción de Node.js no generó ${path}';
	@override String downloadFailed({required Object error}) => 'Error al descargar el servidor: ${error}';
	@override String installFailed({required Object error}) => 'Error al instalar el servidor: ${error}';
	@override String get bundleNotInstalled => 'El paquete del servidor no está instalado.';
	@override String spawnFailed({required Object error}) => 'No se pudo iniciar el servidor local: ${error}';
	@override String portInUse({required Object port}) => 'El puerto ${port} ya está en uso por otra aplicación.';
	@override String get exitedDuringStartup => 'El servidor local se cerró durante el inicio.';
	@override String exitedDuringStartupWithOutput({required Object output}) => 'El servidor local se cerró durante el inicio: ${output}';
	@override String get startTimeout => 'Se agotó el tiempo de espera para iniciar el servidor local.';
	@override String tarFailed({required Object command, required Object code, required Object output}) => '${command} falló (código ${code}): ${output}';
}

// Path: chat.orchestrator.decision.action
class Translations$chat$orchestrator$decision$action$es extends Translations$chat$orchestrator$decision$action$en {
	Translations$chat$orchestrator$decision$action$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'delegando';
	@override String get done => 'finalizado';
	@override String get invalid => 'sin decisión';
}

// Path: chat.orchestrator.decision.outcome
class Translations$chat$orchestrator$decision$outcome$es extends Translations$chat$orchestrator$decision$outcome$en {
	Translations$chat$orchestrator$decision$outcome$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get success => 'éxito';
	@override String get partial => 'parcial';
	@override String get failed => 'fallido';
}

// Path: chat.orchestrator.delegation.status
class Translations$chat$orchestrator$delegation$status$es extends Translations$chat$orchestrator$delegation$status$en {
	Translations$chat$orchestrator$delegation$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get queued => 'en cola';
	@override String get running => 'en ejecución';
	@override String get done => 'hecho';
	@override String get failed => 'fallido';
	@override String get aborted => 'abortado';
	@override String get skipped => 'omitido';
	@override String get awaitingDecision => 'esperando decisión';
}

// Path: chat.orchestrator.taskmaster.status
class Translations$chat$orchestrator$taskmaster$status$es extends Translations$chat$orchestrator$taskmaster$status$en {
	Translations$chat$orchestrator$taskmaster$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get started => 'en ejecución';
	@override String get done => 'hecho';
	@override String get complete => 'completado';
	@override String get failed => 'fallido';
	@override String get paused => 'en pausa';
	@override String get blocked => 'bloqueado';
	@override String get aborted => 'abortado';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$es extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manual — solo recomendación';
	@override String get ask => 'Preguntar antes de cambiar de cuenta';
	@override String get autoLowRisk => 'Cambio automático para tareas de bajo riesgo';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$es extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Espacio de trabajo existente';
	@override String get description => 'Ya tengo un espacio de trabajo en mi servidor y solo necesito añadirlo a la lista de proyectos';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$es extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Espacio de trabajo nuevo';
	@override String get description => 'Crea un espacio de trabajo nuevo, opcionalmente clonando un repositorio de GitHub';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$es extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$es info = Translations$common$notifications$codes$generic$info$es._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$es extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$es required = Translations$common$notifications$codes$permission$required$es._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$es extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$es stopped = Translations$common$notifications$codes$run$stopped$es._(_root);
	@override late final Translations$common$notifications$codes$run$failed$es failed = Translations$common$notifications$codes$run$failed$es._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$es extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$es notification = Translations$common$notifications$codes$agent$notification$es._(_root);
}

// Path: settings.miniOrchestration.planner.modes
class Translations$settings$miniOrchestration$planner$modes$es extends Translations$settings$miniOrchestration$planner$modes$en {
	Translations$settings$miniOrchestration$planner$modes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Planificar con el pensador';
	@override String get off => 'Un solo paso';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$es extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Label';
	@override String get labelPlaceholder => 'p. ej. SWE-2 Medium';
	@override String get provider => 'Provider';
	@override String get model => 'Model';
	@override String get modelPlaceholder => 'Selecciona un modelo';
	@override String get effort => 'Effort';
	@override String get effortDefault => 'Predeterminado del proveedor';
	@override String get effortPlaceholder => 'default';
	@override String get account => 'Account';
	@override String get accountDefault => 'Predeterminada del proveedor';
	@override String get redundantAccounts => 'Cuentas redundantes';
	@override String get redundantAccountsNone => 'No hay otras cuentas para este proveedor';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Eliminar candidato';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$es extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get plan => 'Planning';
	@override String get quick => 'Respuestas rápidas';
	@override String get research => 'Research';
	@override String get docs => 'Documentation';
	@override String get code => 'Coding';
	@override String get codeHard => 'Programación compleja';
	@override String get test => 'Testing';
	@override String get review => 'Review';
	@override String get report => 'Informe';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$es extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$es extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get auto => 'El modelo planificador descompone cada solicitud en pasos tipificados.';
	@override String get template => 'Las solicitudes pasan por un pipeline fijo que eliges abajo.';
	@override String get off => 'Sin planificación — toda la solicitud se enruta como un único paso.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$es extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plantillas de pipeline';
	@override String get add => 'Add template';
	@override String get namePlaceholder => 'Nombre de la plantilla';
	@override String get addStep => 'Add step…';
	@override String get remove => 'Eliminar plantilla';
	@override String get removeStep => 'Remove step';
	@override String get empty => 'Aún no hay plantillas.';
	@override String get emptySteps => 'Aún no hay pasos — añade uno abajo.';
}

// Path: settings.orchestration.planner.checkpointModes
class Translations$settings$orchestration$planner$checkpointModes$es extends Translations$settings$orchestration$planner$checkpointModes$en {
	Translations$settings$orchestration$planner$checkpointModes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get off => 'Autónomo';
	@override String get perStep => 'Por paso';
	@override String get everyN => 'Cada N';
}

// Path: settings.orchestration.planner.checkpointHints
class Translations$settings$orchestration$planner$checkpointHints$es extends Translations$settings$orchestration$planner$checkpointHints$en {
	Translations$settings$orchestration$planner$checkpointHints$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get off => 'Las decisiones del supervisor se ejecutan sin preguntar (modo automático).';
	@override String get perStep => 'Pedir aprobación antes de cada lote de pasos propuesto.';
	@override String get everyN => 'Pedir aprobación cada N pasos completados.';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$es extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.orchestration.execution.retryClasses
class Translations$settings$orchestration$execution$retryClasses$es extends Translations$settings$orchestration$execution$retryClasses$en {
	Translations$settings$orchestration$execution$retryClasses$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get rateLimit => 'Límite de tasa';
	@override String get quota => 'Cuota';
	@override String get auth => 'Autenticación';
	@override String get timeout => 'Tiempo agotado';
	@override String get transient => 'Transitorio';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$es extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Tema del editor';
	@override String get description => 'Tema por defecto del editor de código';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$es extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ajuste de línea';
	@override String get description => 'Activa el ajuste de línea por defecto en el editor';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$es extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Mostrar minimapa';
	@override String get description => 'Muestra un minimapa para navegar más fácil en la vista de diff';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$es extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Mostrar números de línea';
	@override String get description => 'Muestra los números de línea en el editor';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$es extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Tamaño de fuente';
	@override String get description => 'Tamaño de fuente del editor en píxeles';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$es extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'El foco sigue al puntero';
	@override String get description => 'Enfocar el terminal para escribir al mover el ratón sobre él';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$es extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Nombre del token (p. ej., Repos personales)';
	@override String get tokenPlaceholder => 'Token de acceso personal de GitHub (ghp_...)';
	@override String get descriptionPlaceholder => 'Descripción (opcional)';
	@override String get addButton => 'Añadir token';
	@override String get cancelButton => 'Cancelar';
	@override String get howToCreate => 'Cómo crear un token de acceso personal de GitHub →';
	@override String get showToken => 'Mostrar token';
	@override String get hideToken => 'Ocultar token';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$es extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Reinicia esta aplicación';
	@override String get autoAvailable => 'Las funciones de TaskMaster estarán disponibles automáticamente';
	@override String get initCommand => 'Usa task-master init en el directorio de tu proyecto';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$es extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asistente de IA Claude de Anthropic';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$es extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Editor de código con IA Cursor';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$es extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asistente de IA Codex de OpenAI';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$es extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asistente CLI OpenCode';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$es extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asistente CLI Command Code';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$es extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asistente CLI Antigravity';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$es extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'Asistente CLI Devin';
}

// Path: settings.agents.accounts.autoSwitch
class Translations$settings$agents$accounts$autoSwitch$es extends Translations$settings$agents$accounts$autoSwitch$en {
	Translations$settings$agents$accounts$autoSwitch$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Cambiar de cuenta automáticamente al alcanzar el límite';
	@override String get description => 'Cuando una cuenta alcanza su límite de uso, la sesión pasa a otra cuenta del mismo agente que aún tenga cuota, incluso si elegiste manualmente la agotada. Nunca cambia a otro agente. Claude y Codex conservan la conversación; los demás agentes solo cambian en chats nuevos.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$es extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$es kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$es._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$es auto = Translations$settings$permissions$permissionMode$modes$auto$es._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$es acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$es._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$es bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$es._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$es plan = Translations$settings$permissions$permissionMode$modes$plan$es._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$es extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manual';
	@override String get manualHint => 'Mostrar solo una recomendación; nunca cambiar de cuenta automáticamente.';
	@override String get ask => 'Preguntar antes de cambiar';
	@override String get askHint => 'Se propone un cambio y espera tu aprobación.';
	@override String get autoLowRisk => 'Automático para tareas de bajo riesgo';
	@override String get autoLowRiskHint => 'Solo las tareas marcadas como de bajo riesgo pueden moverse automáticamente.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$es extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crea un Documento de Requisitos de Producto (PRD)';
	@override String get description => 'Conversa sobre la idea de tu proyecto y crea un PRD que describa lo que quieres construir.';
	@override String get addButton => 'Añadir PRD';
	@override String get existingPRDs => 'PRDs existentes:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$es extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Genera tareas desde el PRD';
	@override String get description => 'Cuando tengas un PRD, pídele a tu asistente de IA que lo analice y TaskMaster lo descompondrá automáticamente en tareas manejables con detalles de implementación.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$es extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analiza y expande tareas';
	@override String get description => 'Pídele a tu asistente de IA que analice la complejidad de las tareas y las expanda en subtareas detalladas para facilitar la implementación.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$es extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Empieza a construir';
	@override String get description => 'Pídele a tu asistente de IA que empiece a trabajar en las tareas, actualice su estado y añada tareas nuevas a medida que tu proyecto evoluciona.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$es extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get userGlobal => 'Escribe en la configuración de usuario de cada proveedor y está disponible en todos los proyectos de esta máquina';
	@override String get user => 'Disponible en todos los proyectos de tu máquina';
	@override String get local => 'Se guarda en los ajustes de usuario de Claude para el proyecto seleccionado';
	@override String get projectGlobal => 'Escribe en el espacio de trabajo del proyecto seleccionado para todos los proveedores';
	@override String get project => 'Se guarda en el espacio de trabajo del proyecto seleccionado';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$es extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificación';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$es extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Acción requerida';
	@override String body({required Object toolName}) => '${toolName} está esperando tu decisión.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$es extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ejecución detenida';
	@override String body({required Object reason}) => 'Motivo: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$es extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'La ejecución falló';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$es extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificación del agente';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$es extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Por defecto';
	@override String get description => 'Las acciones que necesitan permiso se te muestran para aprobación en el chat.';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$es extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Modo automático';
	@override String get description => 'Un clasificador del modelo decide en cada llamada si aprobar o denegar. Sin intervención, pero más seguro que Omitir — las denegaciones siguen ocurriendo.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$es extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aceptar ediciones';
	@override String get description => 'Las ediciones de archivos se aprueban automáticamente; otras acciones siguen pidiendo tu aprobación.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$es extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Omitir permisos';
	@override String get description => 'Cada acción se aprueba automáticamente — acceso total sin avisos. Úsalo con precaución.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$es extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get description => 'Modo planificación: el agente explora y planifica sin ejecutar comandos.';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Tu sesión ha caducado. Inicia sesión de nuevo.',
			'auth.login.title' => 'Bienvenido de nuevo',
			'auth.login.description' => 'Inicia sesión en tu cuenta autoalojada de DDAgent',
			'auth.login.username' => 'Usuario',
			'auth.login.password' => 'Contraseña',
			'auth.login.submit' => 'Iniciar sesión',
			'auth.login.loading' => 'Iniciando sesión...',
			'auth.login.errors.invalidCredentials' => 'Usuario o contraseña incorrectos',
			'auth.login.errors.requiredFields' => 'Completa todos los campos',
			'auth.login.errors.networkError' => 'Error de red. Inténtalo de nuevo.',
			'auth.login.placeholders.username' => 'Escribe tu usuario',
			'auth.login.placeholders.password' => 'Escribe tu contraseña',
			'auth.register.title' => 'Crear cuenta',
			'auth.register.username' => 'Usuario',
			'auth.register.password' => 'Contraseña',
			'auth.register.confirmPassword' => 'Confirmar contraseña',
			'auth.register.submit' => 'Crear cuenta',
			'auth.register.loading' => 'Creando cuenta...',
			'auth.register.errors.passwordMismatch' => 'Las contraseñas no coinciden',
			'auth.register.errors.usernameTaken' => 'El nombre de usuario ya está en uso',
			'auth.register.errors.weakPassword' => 'La contraseña es demasiado débil',
			'auth.register.errors.usernameTooShort' => 'El nombre de usuario debe tener al menos 3 caracteres',
			'auth.register.errors.passwordTooShort' => 'La contraseña debe tener al menos 6 caracteres',
			'auth.logout.title' => 'Cerrar sesión',
			'auth.logout.confirm' => '¿Seguro que quieres cerrar sesión?',
			'auth.logout.button' => 'Cerrar sesión',
			'chat.codeBlock.copy' => 'Copiar',
			'chat.codeBlock.copied' => 'Copiado',
			'chat.codeBlock.copyCode' => 'Copiar código',
			'chat.copyMessage.copy' => 'Copiar mensaje',
			'chat.copyMessage.copied' => 'Mensaje copiado',
			'chat.copyMessage.failed' => 'No se pudo copiar',
			'chat.copyMessage.selectFormat' => 'Selecciona el formato de copia',
			'chat.copyMessage.copyAsMarkdown' => 'Copiar como markdown',
			'chat.copyMessage.copyAsText' => 'Copiar como texto',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => 'Error',
			'chat.messageTypes.tool' => 'Herramienta',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.messageTypes.orchestrator' => 'Auto',
			'chat.orchestrator.routing.title' => 'Enrutamiento',
			'chat.orchestrator.routing.alternatives' => ({required Object list}) => 'Alternativas: ${list}',
			'chat.orchestrator.routing.first' => ({required Object label, required Object task}) => '${label} — primer candidato para ${task}',
			'chat.orchestrator.routing.skipped' => ({required Object label, required Object list}) => '${label} — candidatos anteriores omitidos (${list})',
			'chat.orchestrator.plan.title' => 'Plan',
			'chat.orchestrator.plan.disabled' => 'desactivado',
			'chat.orchestrator.plan.awaitingConfirm' => 'Esperando la confirmación del plan.',
			'chat.orchestrator.plan.run' => 'Ejecutar plan',
			'chat.orchestrator.plan.toggleStep' => 'Activar paso',
			'chat.orchestrator.plan.confirmFailed' => 'No se pudo iniciar — inténtalo de nuevo.',
			'chat.orchestrator.plan.fallback' => 'planificador no disponible — alternativa de un solo paso',
			'chat.orchestrator.plan.templateSource' => 'desde plantilla de pipeline',
			'chat.orchestrator.plan.offSource' => 'planificador desactivado',
			'chat.orchestrator.plan.stepCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} paso', other: '${count} pasos', ), 
			'chat.orchestrator.plan.supervisedSource' => 'bucle supervisado',
			'chat.orchestrator.decision.title' => 'Decisión del supervisor',
			'chat.orchestrator.decision.iteration' => ({required Object n}) => 'iteración ${n}',
			'chat.orchestrator.decision.rationaleLabel' => 'Motivo',
			'chat.orchestrator.decision.awaitingConfirm' => 'Esperando tu aprobación antes de ejecutar estos pasos.',
			'chat.orchestrator.decision.proposedSteps' => 'Pasos propuestos',
			'chat.orchestrator.decision.action.kContinue' => 'delegando',
			'chat.orchestrator.decision.action.done' => 'finalizado',
			'chat.orchestrator.decision.action.invalid' => 'sin decisión',
			'chat.orchestrator.decision.outcome.success' => 'éxito',
			'chat.orchestrator.decision.outcome.partial' => 'parcial',
			'chat.orchestrator.decision.outcome.failed' => 'fallido',
			'chat.orchestrator.delegation.title' => 'Paso delegado',
			'chat.orchestrator.delegation.openSession' => 'Abrir sesión completa',
			'chat.orchestrator.delegation.attempt' => ({required Object n}) => 'intento ${n}',
			'chat.orchestrator.delegation.retryStep' => 'Reintentar / Corregir',
			'chat.orchestrator.delegation.continueStep' => 'Continuar / Corregir',
			'chat.orchestrator.delegation.continueFailed' => 'Error — inténtalo de nuevo.',
			'chat.orchestrator.delegation.status.queued' => 'en cola',
			'chat.orchestrator.delegation.status.running' => 'en ejecución',
			'chat.orchestrator.delegation.status.done' => 'hecho',
			'chat.orchestrator.delegation.status.failed' => 'fallido',
			'chat.orchestrator.delegation.status.aborted' => 'abortado',
			'chat.orchestrator.delegation.status.skipped' => 'omitido',
			'chat.orchestrator.delegation.status.awaitingDecision' => 'esperando decisión',
			'chat.orchestrator.delegation.attempts' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} intento', other: '${count} intentos', ), 
			'chat.orchestrator.delegation.candidates' => ({required Object list}) => 'candidatos: ${list}',
			'chat.orchestrator.delegation.candidateCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} candidato', other: '${count} candidatos', ), 
			'chat.orchestrator.summary.title' => 'Resumen',
			'chat.orchestrator.summary.progress' => ({required Object done, required Object total}) => 'Pasos completados: ${done}/${total}',
			'chat.orchestrator.summary.aborted' => 'abortado',
			'chat.orchestrator.summary.timedOut' => 'tiempo agotado',
			'chat.orchestrator.summary.capped' => 'límite de iteraciones',
			'chat.orchestrator.summary.failed' => ({required Object list}) => 'Pasos fallidos: ${list}',
			'chat.orchestrator.summary.kContinue' => 'Continuar',
			'chat.orchestrator.summary.continueWork' => 'Continuar el trabajo',
			'chat.orchestrator.summary.resumeFailed' => 'No se pudo reanudar — inténtalo de nuevo.',
			'chat.orchestrator.summary.runNextTask' => 'Ejecutar la siguiente tarea',
			'chat.orchestrator.summary.endAllTasks' => 'Finalizar todas las tareas',
			'chat.orchestrator.summary.tasksRunning' => 'Trabajando en las tareas…',
			'chat.orchestrator.summary.cancelTasks' => 'Cancelar',
			'chat.orchestrator.backToParent' => 'Volver a la orquestación',
			'chat.orchestrator.taskmaster.title' => 'Cola de tareas',
			'chat.orchestrator.taskmaster.remaining' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'queda ${count}', other: 'quedan ${count}', ), 
			'chat.orchestrator.taskmaster.status.started' => 'en ejecución',
			'chat.orchestrator.taskmaster.status.done' => 'hecho',
			'chat.orchestrator.taskmaster.status.complete' => 'completado',
			'chat.orchestrator.taskmaster.status.failed' => 'fallido',
			'chat.orchestrator.taskmaster.status.paused' => 'en pausa',
			'chat.orchestrator.taskmaster.status.blocked' => 'bloqueado',
			'chat.orchestrator.taskmaster.status.aborted' => 'abortado',
			'chat.orchestrator.gate.timedOut' => 'tiempo agotado',
			'chat.orchestrator.gate.exit' => ({required Object code}) => 'salida ${code}',
			'chat.tools.settings' => 'Ajustes de herramientas',
			'chat.tools.error' => 'Error de herramienta',
			'chat.tools.result' => 'Resultado de herramienta',
			'chat.tools.viewParams' => 'Ver parámetros de entrada',
			'chat.tools.viewRawParams' => 'Ver parámetros sin procesar',
			'chat.tools.viewDiff' => 'Ver diff de edición de',
			'chat.tools.creatingFile' => 'Creando archivo nuevo:',
			'chat.tools.updatingTodo' => 'Actualizando lista de pendientes',
			'chat.tools.read' => 'Leer',
			'chat.tools.readFile' => 'Leer archivo',
			'chat.tools.updateTodo' => 'Actualizar lista de pendientes',
			'chat.tools.readTodo' => 'Leer lista de pendientes',
			'chat.tools.searchResults' => 'resultados',
			'chat.tools.todoReadLabel' => 'Lista de pendientes de TodoRead',
			'chat.search.found' => ({required Object count, required Object type}) => 'Se encontraron ${count} ${type}',
			'chat.search.file' => 'archivo',
			'chat.search.files' => 'archivos',
			'chat.search.pattern' => 'patrón:',
			'chat.search.kIn' => 'en:',
			'chat.fileOperations.updated' => 'Archivo actualizado correctamente',
			'chat.fileOperations.created' => 'Archivo creado correctamente',
			'chat.fileOperations.written' => 'Archivo escrito correctamente',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => 'Archivo nuevo',
			'chat.fileOperations.viewContent' => 'Ver contenido del archivo',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Ver salida completa (${count} caracteres)',
			'chat.fileOperations.contentDisplayed' => 'El contenido del archivo se muestra en la vista de diff de arriba',
			'chat.interactive.title' => 'Prompt interactivo',
			'chat.interactive.waiting' => 'Esperando tu respuesta en la CLI',
			'chat.interactive.instruction' => 'Selecciona una opción en la terminal donde está corriendo Claude.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude seleccionó la opción ${number}',
			'chat.interactive.instructionDetail' => 'En la CLI seleccionarías esta opción de forma interactiva con las flechas o escribiendo el número.',
			'chat.thinking.title' => 'Pensando...',
			'chat.thinking.emoji' => '💭 Pensando...',
			'chat.thinking.thoughtFewSeconds' => 'Pensó durante unos segundos',
			'chat.json.response' => 'Respuesta JSON',
			'chat.permissions.grant' => ({required Object tool}) => 'Conceder permiso para ${tool}',
			'chat.permissions.added' => 'Permiso añadido',
			'chat.permissions.addTo' => ({required Object entry}) => 'Añade ${entry} a las herramientas permitidas.',
			'chat.permissions.retry' => 'Permiso guardado. Reintenta la solicitud para usar la herramienta.',
			'chat.permissions.error' => 'No se pudieron actualizar los permisos. Inténtalo de nuevo.',
			'chat.permissions.openSettings' => 'Abrir ajustes',
			'chat.permissions.allow' => 'Permitir',
			'chat.permissions.always' => 'Siempre',
			'chat.permissions.editAndAllow' => 'Editar y permitir',
			'chat.permissions.deny' => 'Denegar',
			'chat.permissions.reject' => 'Rechazar',
			'chat.permissions.allowAll' => ({required Object count}) => 'Permitir todo (${count})',
			'chat.permissions.editInput' => 'Editar entrada',
			'chat.permissions.invalidJson' => 'JSON no válido',
			'chat.permissions.allowWithChanges' => 'Permitir con cambios',
			'chat.permissions.alwaysDeny' => 'Denegar siempre',
			'chat.permissions.denyFeedbackTitle' => 'Rechazar el plan',
			'chat.permissions.denyFeedbackHint' => '¿Qué debería cambiar el agente? (opcional)',
			'chat.permissions.modeAppliesNextMessage' => 'El nuevo modo de permisos se aplica a partir del siguiente mensaje.',
			'chat.todo.updated' => 'La lista de pendientes se actualizó correctamente',
			'chat.todo.current' => 'Lista de pendientes actual',
			'chat.plan.viewPlan' => '📋 Ver plan de implementación',
			'chat.plan.title' => 'Plan de implementación',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Se alcanzó el límite de uso de Claude. Tu límite se restablecerá a las **${time} ${timezone}** - ${date}',
			'chat.codex.permissionMode' => 'Modo de permisos',
			'chat.codex.modes.kDefault' => 'Modo por defecto',
			'chat.codex.modes.auto' => 'Modo automático',
			'chat.codex.modes.acceptEdits' => 'Aceptar ediciones',
			'chat.codex.modes.bypassPermissions' => 'Omitir permisos',
			'chat.codex.modes.plan' => 'Modo de planificación',
			'chat.codex.descriptions.kDefault' => 'Solo los comandos de confianza (ls, cat, grep, git status, etc.) se ejecutan automáticamente. Los demás comandos se omiten. Puede escribir en el espacio de trabajo.',
			'chat.codex.descriptions.auto' => 'Un clasificador del modelo decide en cada llamada si aprobar o denegar. Sin intervención, pero más seguro que Omitir — las denegaciones siguen ocurriendo.',
			'chat.codex.descriptions.acceptEdits' => 'Todos los comandos se ejecutan automáticamente dentro del espacio de trabajo. Modo automático completo con ejecución en sandbox.',
			'chat.codex.descriptions.bypassPermissions' => 'Acceso completo al sistema sin restricciones. Todos los comandos se ejecutan automáticamente con acceso total a disco y red. Úsalo con precaución.',
			'chat.codex.descriptions.plan' => 'Modo de planificación: no se ejecutan comandos',
			'chat.codex.technicalDetails' => 'Detalles técnicos',
			'chat.voice.autoRead' => 'Leer respuestas en voz alta',
			'chat.voice.autoReadOn' => 'Lectura de respuestas: activada',
			'chat.voice.autoReadOff' => 'Lectura de respuestas: desactivada',
			'chat.voice.autoReadVoice' => 'Voz de lectura',
			'chat.voice.autoReadVoiceAuto' => 'Voz automática',
			'chat.voice.autoReadPreview' => 'Así sonarán las respuestas.',
			'chat.voice.speakMessage' => 'Leer en voz alta',
			'chat.voice.stopSpeaking' => 'Detener lectura',
			'chat.input.placeholder' => ({required Object provider}) => 'Escribe / para comandos, @ para archivos, o pregúntale lo que quieras a ${provider}...',
			'chat.input.placeholderDefault' => 'Escribe tu mensaje...',
			'chat.input.disabled' => 'Entrada deshabilitada',
			'chat.input.attachFiles' => 'Adjuntar archivos',
			'chat.input.attachFilesDesc' => 'Subir fotos, archivos o documentos',
			'chat.input.takePhoto' => 'Tomar foto',
			'chat.input.takePhotoDesc' => 'Usar la cámara para capturar una foto',
			'chat.input.moreTools' => 'Más herramientas',
			'chat.input.commandsDesc' => 'Explorar atajos y comandos',
			'chat.input.clearInputDesc' => 'Descartar el texto actual',
			'chat.input.attachImages' => 'Adjuntar imágenes',
			'chat.input.send' => 'Enviar',
			'chat.input.stop' => 'Detener',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter para enviar • / comandos • @ archivos',
			'chat.input.hintText.enter' => 'Enter para enviar • Shift+Enter nueva línea • / comandos • @ archivos',
			'chat.input.hintText.queue' => 'Enter para poner en cola tu siguiente mensaje',
			'chat.input.hintText.updateQueued' => 'Enter para actualizar el mensaje en cola',
			'chat.input.clickToChangeMode' => 'Haz clic para cambiar el modo de permisos',
			'chat.input.showAllCommands' => 'Mostrar todos los comandos',
			'chat.input.clearInput' => 'Limpiar entrada',
			'chat.input.scrollToBottom' => 'Ir al final',
			'chat.input.newMessage' => 'Nuevo mensaje',
			'chat.input.newMessages' => 'Nuevos mensajes',
			'chat.input.queue.sendNext' => 'Poner en cola el siguiente mensaje',
			'chat.input.queue.update' => 'Actualizar mensaje en cola',
			'chat.input.queue.label' => 'En cola',
			'chat.input.queue.willSend' => 'Se enviará cuando esto termine',
			'chat.input.queue.edit' => 'Editar mensaje en cola',
			'chat.input.queue.delete' => 'Eliminar mensaje en cola',
			'chat.input.queue.failed' => 'Falló el envío',
			'chat.input.queue.sendNow' => 'Enviar ahora',
			'chat.input.queue.sendNowAfterTurn' => 'Este agente no acepta mensajes durante un turno: se enviará cuando termine el actual',
			'chat.input.queue.filesAttached' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} archivo adjunto', other: '${count} archivos adjuntos', ), 
			'chat.input.autoContinueTasks' => 'Continuación automática',
			'chat.input.autoContinueTasksTooltip' => 'Activa para que Devin continúe automáticamente con la siguiente tarea de Task Master',
			'chat.input.offlineQueue.clear' => 'Cancelar y vaciar la cola sin conexión',
			'chat.input.offlineQueue.clearBtn' => 'Cancelar',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} mensajes en cola sin conexión — se enviarán automáticamente al reconectar',
			'chat.input.offlineQueue.single' => '1 mensaje en cola sin conexión — se enviará automáticamente al reconectar',
			'chat.input.voice' => 'Entrada de voz',
			'chat.input.voiceStart' => 'Dictar un mensaje',
			'chat.input.voiceStop' => 'Detener el dictado',
			'chat.input.pinFile' => 'Fijar archivo al contexto',
			'chat.input.voiceSettings' => 'Ajustes de voz (STT)',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Cámara no disponible: ${error}',
			'chat.composer.toolsAndActions' => 'Herramientas y acciones',
			'chat.composer.toolsAndActionsDesc' => 'Herramientas y controles del editor de chat',
			'chat.composer.reasoning' => 'Razonamiento',
			'chat.composer.model' => 'Modelo',
			'chat.composer.effortDefault' => 'Predeterminado',
			'chat.composer.loadingModels' => 'Cargando modelos…',
			'chat.composer.modelMenu' => 'Seleccionar modelo y esfuerzo de razonamiento',
			'chat.composer.permissionHeading' => ({required Object provider}) => '¿Cómo deben aprobarse las acciones de ${provider}?',
			'chat.composer.favorites' => 'Favoritos',
			'chat.composer.account' => 'Cuenta',
			'chat.composer.accountMenu' => 'Seleccionar cuenta',
			'chat.composer.accountDefault' => 'Cuenta predeterminada',
			'chat.composer.accountAuto' => 'Auto (predeterminada)',
			'chat.composer.accountIsDefault' => 'Predeterminada',
			'chat.composer.effortLevels.off' => 'Desactivado',
			'chat.composer.effortLevels.none' => 'Ninguno',
			'chat.composer.effortLevels.minimal' => 'Mínimo',
			'chat.composer.effortLevels.low' => 'Bajo',
			'chat.composer.effortLevels.medium' => 'Medio',
			'chat.composer.effortLevels.high' => 'Alto',
			'chat.composer.effortLevels.xhigh' => 'Muy alto',
			'chat.composer.effortLevels.max' => 'Máximo',
			'chat.composer.effortLevels.ultra' => 'Ultra',
			'chat.composer.contextWindow' => ({required Object size}) => 'contexto de ${size}',
			'chat.composer.accountAutoShort' => 'Automático',
			'chat.composer.uploadNoRecords' => 'La subida no devolvió ningún registro',
			'chat.providerSelection.title' => 'Elige tu asistente de IA',
			'chat.providerSelection.description' => 'Selecciona un proveedor para iniciar una conversación nueva',
			'chat.providerSelection.selectModel' => 'Seleccionar modelo',
			'chat.providerSelection.workspace' => 'Espacio de trabajo',
			'chat.providerSelection.noWorkspace' => 'Ninguno',
			'chat.providerSelection.clickToChangeWorkspace' => 'Haz clic para cambiar de espacio de trabajo',
			'chat.providerSelection.chooseWorkspace' => 'Elegir un espacio de trabajo',
			'chat.providerSelection.searchWorkspaces' => 'Buscar espacios de trabajo...',
			'chat.providerSelection.noWorkspacesFound' => 'No se encontraron espacios de trabajo.',
			'chat.providerSelection.providerInfo.anthropic' => 'de Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'de OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'Editor de código con IA',
			'chat.providerSelection.providerInfo.google' => 'de Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Listo para usar Claude con ${model}. Escribe tu mensaje abajo.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Listo para usar Cursor con ${model}. Escribe tu mensaje abajo.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Listo para usar Codex con ${model}. Escribe tu mensaje abajo.',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'Listo para usar OpenCode con ${model}. Escribe tu mensaje abajo.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Selecciona un proveedor arriba para empezar',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Listo con Devin ${model}',
			'chat.providerSelection.readyPrompt.orchestrator' => 'Listo con Auto — el enrutador elige el mejor modelo para cada paso',
			'chat.providerSelection.autoGroup' => 'Auto',
			'chat.providerSelection.autoLabel' => 'Auto (orquestado)',
			'chat.providerSelection.autoDescription' => 'Envía cada paso al mejor proveedor y modelo disponibles',
			'chat.providerSelection.orchestrated' => 'orquestado',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Pulsa <kbd>${shortcut}</kbd> para buscar sesiones, archivos y commits',
			'chat.providerSelection.all' => 'Todos',
			'chat.providerSelection.free' => 'Gratis',
			'chat.providerSelection.noModelsFound' => 'No se encontraron modelos.',
			'chat.providerSelection.paid' => 'De pago',
			'chat.providerSelection.searchModels' => 'Buscar modelos...',
			'chat.providerSelection.addModel' => 'Añadir modelo',
			'chat.providerSelection.chooseModel' => 'Elegir un modelo',
			'chat.providerSelection.chooseModelDescription' => 'Modelos integrados y personalizados en una lista',
			'chat.providerSelection.clickToChange' => 'Haz clic para cambiar de modelo',
			'chat.providerSelection.favorites' => 'Favoritos',
			'chat.providerSelection.loadingModels' => 'Cargando modelos…',
			'chat.providerSelection.manageModels' => 'Gestionar modelos',
			'chat.providerSelection.refresh' => 'Actualizar modelos',
			'chat.session.kContinue.title' => 'Continúa tu conversación',
			'chat.session.kContinue.description' => 'Haz preguntas sobre tu código, pide cambios u obtén ayuda con tareas de desarrollo',
			'chat.session.kContinue.action' => 'Seguir escribiendo',
			'chat.session.loading.olderMessages' => 'Cargando mensajes anteriores...',
			'chat.session.loading.sessionMessages' => 'Cargando mensajes de la sesión...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => 'Mostrando ${shown} de ${total} mensajes',
			'chat.session.messages.scrollToLoad' => 'Desplázate hacia arriba para cargar más',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Mostrando los últimos ${count} mensajes (${total} en total)',
			'chat.session.messages.loadEarlier' => 'Cargar mensajes anteriores',
			'chat.session.messages.loadOlderFailed' => 'No se pudieron cargar mensajes anteriores.',
			'chat.session.messages.retry' => 'Reintentar',
			'chat.session.messages.loadAll' => 'Cargar todos los mensajes',
			'chat.session.messages.loadingAll' => 'Cargando todos los mensajes...',
			'chat.session.messages.allLoaded' => 'Todos los mensajes cargados',
			'chat.session.messages.perfWarning' => 'Todos los mensajes cargados — el desplazamiento puede ser más lento. Haz clic en "Ir al final" para recuperar el rendimiento.',
			'chat.session.messages.noSearchMatches' => 'Ningún mensaje coincide con la búsqueda.',
			'chat.session.messages.loadOlder' => 'Cargar mensajes anteriores',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Cargar todos (${count})',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Reintentar cargar los anteriores — ${error}',
			'chat.session.deleteConfirm' => 'Elimina la sesión y su transcripción. No se puede deshacer.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Finaliza la ejecución antes de cambiar de espacio de trabajo',
			'chat.session.fallbackTitle' => 'Sesión',
			'chat.shell.selectProject.title' => 'Selecciona un proyecto',
			'chat.shell.selectProject.description' => 'Elige un proyecto para abrir una shell interactiva en ese directorio',
			'chat.shell.status.newSession' => 'Sesión nueva',
			'chat.shell.status.initializing' => 'Inicializando...',
			'chat.shell.status.restarting' => 'Reiniciando...',
			'chat.shell.actions.disconnect' => 'Desconectar',
			'chat.shell.actions.disconnectTitle' => 'Desconectar de la shell',
			'chat.shell.actions.restart' => 'Reiniciar',
			'chat.shell.actions.restartTitle' => 'Reiniciar shell',
			'chat.shell.actions.kill' => 'Terminar (SIGINT)',
			'chat.shell.actions.killTitle' => 'Terminar proceso en ejecución (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Copiar salida',
			'chat.shell.actions.copyOutputTitle' => 'Copiar salida del terminal',
			'chat.shell.actions.copied' => '¡Copiado!',
			'chat.shell.actions.zoomInTitle' => 'Acercar',
			'chat.shell.actions.zoomOutTitle' => 'Alejar',
			'chat.shell.actions.connect' => 'Continuar en la shell',
			'chat.shell.actions.connectTitle' => 'Conectar a la shell',
			'chat.shell.loading' => 'Cargando terminal...',
			'chat.shell.connecting' => 'Conectando a la shell...',
			'chat.shell.startSession' => 'Iniciar una sesión nueva de Claude',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Reanudar sesión: ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => 'Ejecutar ${command} en ${projectName}',
			'chat.shell.startCli' => ({required Object projectName}) => 'Iniciando Claude CLI en ${projectName}',
			'chat.shell.defaultCommand' => 'comando',
			'chat.claudeStatus.actions.thinking' => 'Pensando',
			'chat.claudeStatus.actions.processing' => 'Procesando',
			'chat.claudeStatus.actions.analyzing' => 'Analizando',
			'chat.claudeStatus.actions.working' => 'Trabajando',
			'chat.claudeStatus.actions.computing' => 'Calculando',
			'chat.claudeStatus.actions.reasoning' => 'Razonando',
			'chat.claudeStatus.state.live' => 'En vivo',
			'chat.claudeStatus.state.paused' => 'En pausa',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}s',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} transcurridos',
			'chat.claudeStatus.elapsed.startingNow' => 'Empezando ahora',
			'chat.claudeStatus.stop' => 'Detener',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} tarea en segundo plano en curso', other: '${count} tareas en segundo plano en curso', ), 
			'chat.claudeStatus.controls.stopGeneration' => 'Detener generación',
			'chat.claudeStatus.controls.pressEscToStop' => 'Pulsa Esc en cualquier momento para detener',
			'chat.claudeStatus.providers.assistant' => 'Asistente',
			'chat.claudeStatus.backgroundTasksTitle' => 'En segundo plano',
			'chat.claudeStatus.backgroundTaskUnnamed' => 'Tarea sin nombre',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Selecciona un proyecto para empezar a chatear con ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Empezar la siguiente tarea',
			'chat.splitSession.toggle' => 'Dividir sesión',
			'chat.splitSession.close' => 'Cerrar sesión dividida',
			'chat.splitSession.selectSession' => 'Seleccionar sesión para comparar',
			'chat.splitSession.noOtherSessions' => 'No hay otras sesiones disponibles',
			'chat.splitSession.newSessionOption' => '+ Nueva sesión en vista dividida',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Proyecto actual (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Otros proyectos',
			'chat.splitSession.recentSessionsGroup' => 'Sesiones recientes',
			'chat.splitSession.startNewSession' => 'Iniciar nueva sesión en vista dividida',
			'chat.splitSession.selectFromList' => 'Seleccionar sesión de la lista de sesiones existentes',
			'chat.sessionPicker.title' => 'Seleccionar sesión',
			'chat.sessionPicker.searchPlaceholder' => 'Buscar sesiones...',
			'chat.sessionPicker.clearSearch' => 'Borrar búsqueda',
			'chat.sessionPicker.newChat' => '+ Nuevo chat',
			'chat.sessionPicker.archivedToggle' => 'Archivadas',
			'chat.sessionPicker.changeSession' => 'Cambiar sesión',
			'chat.sessionPicker.archivedLoading' => 'Cargando sesiones archivadas...',
			'chat.sessionPicker.archivedError' => 'No se pudieron cargar las sesiones archivadas',
			'chat.sessionPicker.archivedEmpty' => 'No hay sesiones archivadas',
			'chat.sessionPicker.archivedProjectOnly' => 'Espacio de trabajo archivado — restáuralo para ver sus sesiones.',
			'chat.sessionPicker.emptySearch' => 'Ninguna sesión coincide con tu búsqueda',
			'chat.sessionPicker.restore' => 'Restaurar',
			'chat.sessionPicker.restoreSession' => 'Restaurar sesión',
			'chat.sessionPicker.restoreProject' => 'Restaurar espacio de trabajo',
			'chat.sessionPicker.restoreSessionFailed' => 'Error al restaurar la sesión. Inténtalo de nuevo.',
			'chat.sessionPicker.restoreProjectFailed' => 'Error al restaurar el espacio de trabajo. Inténtalo de nuevo.',
			'chat.sessionPicker.archiveFailed' => 'Error al archivar la sesión. Inténtalo de nuevo.',
			'chat.sessionPicker.deleteFailed' => 'Error al eliminar la sesión. Inténtalo de nuevo.',
			'chat.sessionPicker.running' => 'La sesión está en ejecución',
			'chat.sessionPicker.unread' => 'Sin leer — finalizada con nueva salida',
			'chat.sessionPicker.account' => 'Cuenta',
			'chat.splitWorkspace.addChat' => 'Añadir panel de chat',
			'chat.splitWorkspace.addBrowser' => 'Añadir panel de navegador',
			'chat.splitWorkspace.addTerminal' => 'Añadir panel de terminal',
			'chat.splitWorkspace.addPreview' => 'Añadir panel de vista previa',
			'chat.splitWorkspace.overview' => 'Mostrar todos los paneles',
			'chat.splitWorkspace.exitFocusMode' => 'Salir del modo enfoque (Ctrl+Mayús+F)',
			'chat.splitWorkspace.focusMode' => 'Modo enfoque (Ctrl+Mayús+F)',
			'chat.splitWorkspace.broadcast' => 'Difundir a sesiones',
			'chat.splitWorkspace.addNotes' => 'Añadir panel de notas compartidas',
			'chat.splitWorkspace.browseSessions' => 'Abrir lista de sesiones',
			'chat.splitOverview.title' => 'Vista general de paneles divididos',
			'chat.splitOverview.count' => ({required Object count}) => '${count} paneles',
			'chat.splitOverview.close' => 'Cerrar vista general',
			'chat.splitOverview.question' => 'PREGUNTA — se requiere entrada',
			'chat.splitOverview.processing' => 'PROCESANDO',
			'chat.splitOverview.idle' => 'Inactivo',
			'chat.splitOverview.active' => 'Activa',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} necesita tu respuesta',
			'chat.askUserQuestion.skip' => 'Omitir',
			'chat.askUserQuestion.other' => 'Otro…',
			'chat.askUserQuestion.answerHint' => 'Escribe tu respuesta…',
			'chat.attachments.downloadFailedRetry' => 'Descarga fallida — clic para reintentar',
			'chat.attachments.fileAttachment' => 'Archivo adjunto',
			'chat.attachments.download' => ({required Object name}) => 'Descargar ${name}',
			'chat.attachments.attachedFile' => 'Archivo adjunto',
			'chat.attachments.downloaded' => ({required Object name}) => '${name} descargado',
			'chat.checkpoint.creating' => 'Creando instantánea…',
			'chat.checkpoint.revertChanges' => 'Revertir archivos al último checkpoint',
			'chat.checkpoint.undo' => 'Deshacer checkpoint',
			'chat.checkpoint.undoAiRun' => 'Deshacer ejecución de la IA',
			'chat.checkpoint.undoing' => 'Deshaciendo…',
			'chat.checkpoint.undone' => 'Deshecho',
			'chat.checkpoint.beforeAiTurn' => 'antes del turno de la IA',
			'chat.common.close' => 'Cerrar',
			'chat.taskMaster.saveToTask' => 'Tarea',
			'chat.taskMaster.saved' => 'Guardado',
			'chat.taskMaster.saving' => 'Guardando...',
			'chat.taskMaster.taskShort' => 'TAREA',
			'chat.taskMaster.addToTask' => 'Añadir a TaskMaster',
			'chat.taskMaster.added' => 'Añadido a TaskMaster',
			'chat.taskMaster.defaultTaskTitle' => 'Tarea del chat',
			'chat.tokenUsage.desc' => 'Ver el consumo de tokens de la sesión',
			'chat.tokenUsage.title' => 'Uso de tokens',
			'chat.tokenUsage.notAvailable' => 'N/D',
			'chat.tokenUsage.tokensBadge' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} token', other: '${count} tokens', ), 
			'chat.tool.emptyResult' => '(sin salida aún — la herramienta devolvió un resultado vacío)',
			'chat.quotaBadge.ariaLabel' => 'Límites de suscripción',
			'chat.quotaBadge.noData' => 'No hay datos de suscripción para este modelo',
			'chat.quotaBadge.noSubscription' => 'sin suscripción',
			'chat.quotaBadge.windowLineReset' => ({required Object label, required Object percent, required Object time}) => '${label}: ${percent} % · se restablece ${time}',
			'chat.quotaBadge.windowRemaining' => ({required Object percent}) => 'Queda el ${percent} % de la ventana antes del restablecimiento',
			'chat.broadcast.title' => 'Difundir a sesiones',
			'chat.broadcast.noSessions' => 'No hay sesiones disponibles',
			'chat.broadcast.placeholder' => 'Mensaje para enviar a cada sesión seleccionada…',
			'chat.broadcast.partial' => ({required Object count}) => '${count} sesión(es) rechazaron el mensaje',
			'chat.broadcast.sent' => ({required Object count}) => 'En cola para ${count} sesión(es)',
			'chat.broadcast.selectAll' => 'Seleccionar todo',
			'chat.broadcast.selectOrchestrators' => 'Seleccionar orquestadores',
			'chat.broadcast.orchestratorsOnly' => 'Solo orquestadores',
			'chat.broadcast.noOrchestrators' => 'No hay sesiones de orquestador disponibles',
			'chat.broadcast.sending' => 'Enviando…',
			'chat.broadcast.send' => ({required Object count}) => 'Enviar a ${count}',
			'chat.paneHeader.processing' => 'Procesando…',
			'chat.paneHeader.switchSession' => 'Cambiar sesión',
			'chat.export.sessionTitle' => ({required Object id}) => 'Sesión ${id}',
			'chat.export.pdfFailed' => 'Falló la exportación a PDF',
			'chat.export.transcriptDownloaded' => 'Transcripción descargada',
			'chat.export.savedTo' => ({required Object path}) => 'Guardado en ${path}',
			'chat.commandResult.fallback.models' => 'Explora los modelos disponibles para el proveedor activo.',
			'chat.commandResult.fallback.cost' => 'Revisa el uso de tokens de la sesión activa.',
			'chat.commandResult.fallback.status' => 'Inspecciona el estado del runtime, la versión, el proveedor y el entorno.',
			'chat.commandResult.fallback.memory' => 'Abre el archivo de memoria CLAUDE.md del proyecto.',
			'chat.commandResult.fallback.config' => 'Abre los ajustes y la configuración.',
			'chat.commandResult.fallback.help' => 'Muestra la documentación y la sintaxis de los comandos.',
			'chat.commandResult.filterCommands' => 'Filtrar comandos...',
			'chat.commandResult.searchModels' => ({required Object provider}) => 'Buscar modelos de ${provider}...',
			'chat.commands.runConfirmTitle' => '¿Ejecutar comando?',
			'chat.commands.executionCancelled' => 'Ejecución del comando cancelada',
			'chat.commands.bashConfirmMessage' => 'Este comando contiene comandos de bash que se ejecutarán. ¿Quieres continuar?',
			'chat.commands.proceed' => 'Continuar',
			'chat.pinFile.title' => 'Fijar archivo',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.action' => 'Fijar',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => 'Editar ${name}',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => 'Eliminar ${name}',
			'chat.modelLibrary.enterNameAndId' => 'Introduce tanto un nombre de modelo como un ID de modelo.',
			'chat.modelLibrary.idNoSpaces' => 'Los ID de modelo no pueden contener espacios.',
			'chat.modelLibrary.setAsDefault' => 'Establecer como predeterminado',
			'chat.modelLibrary.defaultModel' => 'Modelo predeterminado',
			'chat.modelLibrary.title' => 'Biblioteca de modelos',
			'chat.modelLibrary.subtitle' => 'Añade los ID de modelo que admite tu proveedor. Los modelos integrados permanecen bloqueados. El círculo marca el modelo predeterminado.',
			'chat.modelLibrary.yourModels' => 'Tus modelos',
			'chat.modelLibrary.yourModelsHint' => 'Editables y guardados en auth.db',
			'chat.modelLibrary.emptyTitle' => 'Aún no hay modelos personalizados',
			'chat.modelLibrary.emptyHint' => 'Añade uno con el formulario y aparecerá en todos los selectores de modelo.',
			'chat.modelLibrary.builtInModels' => 'Modelos integrados',
			'chat.modelLibrary.builtInModelsHint' => 'Mantenidos por DDAgent y de solo lectura',
			'chat.modelLibrary.editTitle' => 'Editar modelo personalizado',
			'chat.modelLibrary.addTitle' => 'Añadir un modelo personalizado',
			'chat.modelLibrary.idSentAsWritten' => ({required Object provider}) => 'El ID se envía a ${provider} exactamente como está escrito.',
			'chat.modelLibrary.nameLabel' => 'Nombre del modelo',
			'chat.modelLibrary.nameHint' => 'p. ej., GPT-5.5 Pro',
			'chat.modelLibrary.idLabel' => 'ID del modelo',
			'chat.modelLibrary.idHint' => 'p. ej., gpt-5.5-pro',
			'chat.modelLibrary.idHelp' => 'Usa el identificador exacto que acepta la CLI del proveedor. Los ID no pueden contener espacios.',
			'chat.modelLibrary.updatedNotice' => ({required Object name}) => '${name} se ha actualizado.',
			'chat.modelLibrary.addedNotice' => ({required Object name}) => '${name} se ha añadido.',
			'chat.modelLibrary.deletedNotice' => ({required Object name}) => '${name} se ha eliminado.',
			'chat.modelLibrary.saving' => 'Guardando…',
			'chat.modelLibrary.saveChanges' => 'Guardar cambios',
			'chat.modelLibrary.deleteConfirm' => '¿Eliminar este modelo de todos los selectores?',
			_ => null,
		} ?? switch (path) {
			'chat.modelLibrary.customBadge' => 'Personalizado',
			'chat.changes.failedToLoad' => 'No se pudieron cargar los cambios',
			'chat.changes.empty' => 'Sin cambios en archivos',
			'chat.message.compactedSummary' => 'Resumen compactado',
			'chat.message.resendHint' => 'Vuelve a enviar desde el compositor',
			'chat.message.rawView' => 'Vista sin procesar',
			'chat.message.runComplete' => 'Ejecución completada',
			'chat.message.runStopped' => 'Detenido',
			'chat.message.runFailed' => ({required Object code}) => 'La ejecución falló (salida ${code})',
			'chat.message.taskKilled' => 'Terminada',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Solicitud de permiso · ${tool}',
			'chat.permissionRequest.question' => 'Pregunta',
			'chat.permissionRequest.subagent' => 'Subagente',
			'chat.permissionRequest.viewersCannotApprove' => 'Los observadores no pueden aprobar',
			'chat.permissionRequest.recap.timedOut' => 'Tiempo agotado: denegado automáticamente',
			'chat.permissionRequest.recap.cancelled' => 'Cancelado: se detuvo el turno',
			'chat.permissionRequest.recap.autoApproved' => 'Aprobado automáticamente',
			'chat.permissionRequest.recap.expired' => 'La solicitud caducó: el agente ya no la espera',
			'chat.permissionRequest.recap.answered' => 'Respondida',
			'chat.permissionRequest.recap.skipped' => 'Omitida',
			'chat.permissionRequest.recap.decided' => 'Decidido',
			'chat.permissionRequest.needsApproval' => ({required Object tool}) => '${tool} necesita aprobación',
			'chat.permissionRequest.subagentNeedsApproval' => ({required Object tool}) => 'Subagente: ${tool} necesita aprobación',
			'chat.permissionRequest.moreQuestions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} pregunta más en espera', other: '${count} preguntas más en espera', ), 
			'chat.commandDialog.help.eyebrow' => 'Centro de comandos',
			'chat.commandDialog.help.title' => 'Ayuda y atajos',
			'chat.commandDialog.help.subtitle' => 'Busca comandos integrados, patrones de sintaxis y uso de comandos.',
			'chat.commandDialog.models.eyebrow' => 'Selección de modelo',
			'chat.commandDialog.models.title' => 'Elige un modelo',
			'chat.commandDialog.models.subtitle' => 'Elige el modelo que debe usar este proveedor.',
			'chat.commandDialog.models.modelSetTo' => ({required Object model}) => 'Modelo establecido en ${model}.',
			'chat.commandDialog.models.activeModel' => 'Modelo activo',
			'chat.commandDialog.models.noModelsMatch' => 'Ningún modelo coincide con ese filtro.',
			'chat.commandDialog.models.choiceSavedForSession' => 'Tu elección se guarda para esta sesión y pasa a ser la predeterminada para los chats nuevos.',
			'chat.commandDialog.models.choiceDefault' => 'Tu elección pasa a ser el modelo predeterminado para los chats nuevos.',
			'chat.commandDialog.models.custom' => 'Personalizado',
			'chat.commandDialog.models.currentSelection' => 'Selección actual',
			'chat.commandDialog.cost.eyebrow' => 'Telemetría de la sesión',
			'chat.commandDialog.cost.title' => 'Uso de tokens',
			'chat.commandDialog.cost.subtitle' => 'Recuento de tokens de entrada, salida y total de esta sesión.',
			'chat.commandDialog.cost.totalTokensUsed' => 'Total de tokens usados',
			'chat.commandDialog.cost.inputTokens' => 'Tokens de entrada',
			'chat.commandDialog.cost.cacheReadTokens' => 'Tokens leídos de caché',
			'chat.commandDialog.cost.cacheWriteTokens' => 'Tokens escritos en caché',
			'chat.commandDialog.cost.outputTokens' => 'Tokens de salida',
			'chat.commandDialog.cost.breakdown' => 'Desglose',
			'chat.commandDialog.cost.unavailable' => 'No disponible',
			'chat.commandDialog.cost.contextWindow' => 'Ventana de contexto',
			'chat.commandDialog.cost.estimatedCost' => 'Coste estimado',
			'chat.commandDialog.status.eyebrow' => 'Estado del entorno',
			'chat.commandDialog.status.title' => 'Estado del sistema',
			'chat.commandDialog.status.subtitle' => 'Versión, proveedor, entorno de ejecución y detalles del entorno.',
			'chat.commandDialog.status.package' => 'Paquete',
			'chat.commandDialog.status.uptime' => 'Tiempo activo',
			'chat.commandDialog.status.platform' => 'Plataforma',
			'chat.commandDialog.status.memory' => 'Memoria',
			'chat.commandDialog.status.memoryRss' => ({required Object mb}) => '${mb} MB RSS',
			'chat.commandDialog.status.runtimeOnline' => 'Entorno en línea',
			'chat.commandDialog.status.processResponding' => ({required Object pid}) => 'El proceso #${pid} responde.',
			'chat.commandDialog.status.processStatusResponding' => 'El proceso responde.',
			'chat.commandDialog.status.healthy' => 'En buen estado',
			'chat.commandDialog.defaultEyebrow' => 'Comando',
			'chat.commandDialog.defaultTitle' => 'Resultado del comando',
			'chat.commandDialog.escHint' => 'Esc cierra la ventana.',
			'chat.commandDialog.unknown' => 'Desconocido',
			'chat.commandDialog.noDescription' => 'No hay descripción disponible.',
			'chat.commandDialog.noCommandsMatch' => 'Ningún comando coincide con ese filtro.',
			'chat.commandDialog.syntax.title' => 'Sintaxis',
			'chat.commandDialog.syntax.arguments' => ({required Object arguments, required Object first, required Object second}) => '${arguments} pasa todos los argumentos; ${first}, ${second} posicionales.',
			'chat.commandDialog.syntax.file' => ({required Object token}) => '${token} incluye el contenido del archivo.',
			'chat.commandDialog.syntax.bash' => ({required Object token}) => '${token} ejecuta bash.',
			'chat.commandDialog.commandFinished' => 'Comando finalizado.',
			'chat.utilities.tokenUsageUnavailable' => 'Uso de tokens no disponible',
			'chat.utilities.tooltip.tokensUsed' => ({required Object tokens}) => '${tokens} tokens usados',
			'chat.utilities.tooltip.contextOf' => ({required Object percent, required Object total}) => 'contexto ${percent} % de ${total}',
			'chat.utilities.tooltip.input' => ({required Object value}) => 'entrada ${value}',
			'chat.utilities.tooltip.cache' => ({required Object read, required Object write}) => 'caché leída ${read} · escrita ${write}',
			'chat.utilities.tooltip.output' => ({required Object value}) => 'salida ${value}',
			'chat.utilities.used' => 'Usados',
			'chat.utilities.cacheWrite' => 'Escritura en caché',
			'chat.utilities.contextLabel' => 'Contexto',
			'chat.utilities.usageUnsupported' => 'uso no admitido',
			'chat.utilities.chatTranscript' => 'Transcripción del chat',
			'chat.utilities.you' => 'Tú:',
			'chat.utilities.providerAutoMini' => 'Auto (mini)',
			'chat.toolBlocks.moreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '… ${count} línea más', other: '… ${count} líneas más', ), 
			'chat.toolBlocks.status.running' => 'En ejecución',
			'chat.toolBlocks.status.denied' => 'Denegado',
			'chat.toolBlocks.showLess' => 'Mostrar menos',
			'chat.toolBlocks.showMore' => 'Mostrar más',
			'chat.toolBlocks.showMoreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Mostrar ${count} línea más', other: 'Mostrar ${count} líneas más', ), 
			'chat.toolBlocks.tools' => 'Herramientas',
			'chat.toolBlocks.planReview' => 'Revisión del plan',
			'chat.toolBlocks.planUpdate' => 'Actualización del plan',
			'chat.toolBlocks.todoListUpdated' => 'Lista de tareas actualizada',
			'chat.toolBlocks.creatingTask' => 'Creando tarea',
			'chat.toolBlocks.updatingTask' => 'actualizando',
			'chat.toolBlocks.fetchingTask' => 'obteniendo',
			'chat.toolBlocks.listingTasks' => 'listando tareas',
			'chat.toolBlocks.search' => 'Buscar',
			'chat.toolBlocks.verbs.read' => 'leer',
			'chat.toolBlocks.verbs.write' => 'escribir',
			'chat.toolBlocks.verbs.edit' => 'editar',
			'chat.toolBlocks.verbs.delete' => 'eliminar',
			'chat.toolBlocks.verbs.move' => 'mover',
			'chat.toolBlocks.subagent' => 'Subagente',
			'chat.toolBlocks.toolCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} herramienta', other: '${count} herramientas', ), 
			'chat.toolBlocks.result' => 'resultado',
			'chat.toolBlocks.plusMore' => ({required Object count}) => '+${count} más',
			'chat.toolBlocks.plan' => 'Plan',
			'chat.toolBlocks.questionProgress' => ({required Object current, required Object total}) => 'Pregunta ${current}/${total}',
			'chat.toolBlocks.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} línea', other: '${count} líneas', ), 
			'chat.toolBlocks.todoListItems' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Lista de tareas (${count} elemento)', other: 'Lista de tareas (${count} elementos)', ), 
			'chat.toolBlocks.tasksCompleted' => ({required Object done, required Object total}) => '${done}/${total} completadas',
			'chat.commandMenu.empty' => 'No hay comandos disponibles',
			'chat.commandMenu.namespaces.frequent' => 'Usados con frecuencia',
			'chat.commandMenu.namespaces.builtin' => 'Comandos integrados',
			'chat.commandMenu.namespaces.skill' => 'Habilidades',
			'chat.commandMenu.namespaces.project' => 'Comandos del proyecto',
			'chat.commandMenu.namespaces.user' => 'Comandos del usuario',
			'chat.commandMenu.namespaces.other' => 'Otros comandos',
			'chat.mentionMenu.kinds.file' => 'archivo',
			'chat.mentionMenu.kinds.session' => 'sesión',
			'chat.mentionMenu.kinds.task' => 'tarea',
			'chat.mentionMenu.taskTitle' => ({required Object id}) => 'Tarea ${id}',
			'chat.subheader.contextTooltip' => ({required Object used, required Object total, required Object percent}) => 'Contexto: ${used} / ${total} tokens · ${percent} % usado',
			'chat.transcript.requestFailed' => 'La solicitud falló',
			'chat.review.changedFiles' => 'Archivos modificados',
			'chat.review.changedFilesCount' => ({required Object count}) => 'Archivos modificados (${count})',
			'chat.review.subagent' => 'subagente',
			'codeEditor.toolbar.changes' => 'cambios',
			'codeEditor.toolbar.previousChange' => 'Cambio anterior',
			'codeEditor.toolbar.nextChange' => 'Cambio siguiente',
			'codeEditor.toolbar.hideDiff' => 'Ocultar resaltado de diferencias',
			'codeEditor.toolbar.showDiff' => 'Mostrar resaltado de diferencias',
			'codeEditor.toolbar.settings' => 'Ajustes del editor',
			'codeEditor.toolbar.collapse' => 'Contraer editor',
			'codeEditor.toolbar.expand' => 'Expandir editor a ancho completo',
			'codeEditor.toolbar.toggleDock' => 'Alternar panel de archivos',
			'codeEditor.toolbar.diffMerge' => 'Diff / fusión',
			'codeEditor.toolbar.previewInBrowser' => 'Vista previa en el navegador',
			'codeEditor.toolbar.reload' => 'Recargar desde el disco',
			'codeEditor.loading' => ({required Object fileName}) => 'Cargando ${fileName}...',
			'codeEditor.header.showingChanges' => 'Mostrando cambios',
			'codeEditor.actions.copyPath' => 'Copiar ruta del archivo',
			'codeEditor.actions.pathCopied' => 'Ruta del archivo copiada',
			'codeEditor.actions.download' => 'Descargar archivo',
			'codeEditor.actions.save' => 'Guardar',
			'codeEditor.actions.saving' => 'Guardando...',
			'codeEditor.actions.saved' => '¡Guardado!',
			'codeEditor.actions.exitFullscreen' => 'Salir de pantalla completa',
			'codeEditor.actions.fullscreen' => 'Pantalla completa',
			'codeEditor.actions.close' => 'Cerrar',
			'codeEditor.actions.previewMarkdown' => 'Vista previa de markdown',
			'codeEditor.actions.editMarkdown' => 'Editar markdown',
			'codeEditor.actions.pinFile' => 'Fijar archivo al contexto',
			'codeEditor.actions.unpinFile' => 'Quitar archivo del contexto',
			'codeEditor.actions.previewHtml' => 'Abrir vista previa HTML en nueva pestaña',
			'codeEditor.actions.retry' => 'Reintentar',
			'codeEditor.actions.saveAll' => 'Guardar todo',
			'codeEditor.footer.lines' => 'Líneas:',
			'codeEditor.footer.characters' => 'Caracteres:',
			'codeEditor.footer.shortcuts' => 'Ctrl+S para guardar • Esc para cerrar',
			'codeEditor.footer.plainText' => 'texto sin formato',
			'codeEditor.footer.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} línea', other: '${count} líneas', ), 
			'codeEditor.footer.modified' => 'modificado',
			'codeEditor.binaryFile.title' => 'Archivo binario',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'El archivo "${fileName}" no se puede mostrar en el editor de texto porque es un archivo binario.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'No se puede mostrar como texto',
			'codeEditor.filePreview.loading' => 'Cargando vista previa...',
			'codeEditor.filePreview.error' => 'No se puede mostrar este archivo.',
			'codeEditor.filePreview.openInNewTab' => 'Abrir en una pestaña nueva',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Cambios sin guardar en ${name}',
			'codeEditor.discardUnsavedChanges' => '¿Descartar los cambios sin guardar?',
			'codeEditor.mediaFile.title' => 'Archivo multimedia',
			'codeEditor.mediaFile.subtitle' => 'La vista previa de audio y vídeo aún no es compatible',
			'codeEditor.failedToLoad' => 'No se pudo cargar el archivo',
			'codeEditor.hexDump.more' => ({required Object size}) => '… ${size} más',
			'codeEditor.settings.minimap' => 'Minimapa',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Tamaño de tabulación: ${size}',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Tamaño de fuente −  (ahora ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Tamaño de fuente +',
			'codeEditor.diff.noChanges' => 'Sin cambios',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Sección ${number}',
			'codeEditor.diff.close' => 'Cerrar diff',
			'codeEditor.diff.base' => 'Base',
			'codeEditor.diff.current' => 'Actual',
			'codeEditor.diff.applyMerge' => 'Aplicar fusión',
			'codeEditor.diff.deletedOnDisk' => 'eliminado en el disco',
			'codeEditor.diff.untrackedWillBeDeleted' => 'Este archivo sin seguimiento se eliminará.',
			'codeEditor.diff.restoreConfirm' => ({required Object name}) => '¿Restaurar ${name} a su estado confirmado?',
			'codeEditor.diff.headVsWorkingCopy' => 'HEAD frente a copia de trabajo',
			'codeEditor.diff.savedVsBuffer' => 'Último guardado frente a búfer (sin git)',
			'codeEditor.diff.unchangedLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} línea sin cambios', other: '${count} líneas sin cambios', ), 
			'codeEditor.diff.revertToSaved' => 'Revertir a lo guardado',
			'codeEditor.emptyState.title' => 'Ningún archivo abierto',
			'codeEditor.emptyState.hint' => 'Abre archivos desde la pestaña Archivos',
			'codeEditor.toasts.savedFile' => ({required Object name}) => '${name} guardado',
			'codeEditor.toasts.saveFailed' => 'Falló el guardado',
			'codeEditor.toasts.allSaved' => 'Todo guardado',
			'codeEditor.toasts.someSavesFailed' => 'Algunos guardados fallaron',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Guardado en ${path}',
			'codeEditor.toasts.mergeApplied' => 'Fusión aplicada — guarda para conservar los cambios',
			'common.buttons.save' => 'Guardar',
			'common.buttons.cancel' => 'Cancelar',
			'common.buttons.delete' => 'Eliminar',
			'common.buttons.create' => 'Crear',
			'common.buttons.edit' => 'Editar',
			'common.buttons.close' => 'Cerrar',
			'common.buttons.confirm' => 'Confirmar',
			'common.buttons.submit' => 'Enviar',
			'common.buttons.retry' => 'Reintentar',
			'common.buttons.refresh' => 'Actualizar',
			'common.buttons.search' => 'Buscar',
			'common.buttons.clear' => 'Limpiar',
			'common.buttons.copy' => 'Copiar',
			'common.buttons.download' => 'Descargar',
			'common.buttons.upload' => 'Subir',
			'common.buttons.browse' => 'Explorar',
			'common.buttons.update' => 'Actualizar',
			'common.buttons.openDiagram' => 'Abrir diagrama',
			'common.tabs.chat' => 'Chat',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => 'Archivos',
			'common.tabs.git' => 'Control de versiones',
			'common.tabs.tasks' => 'Tareas',
			'common.tabs.board' => 'Tablero',
			'common.tabs.browser' => 'Navegador',
			'common.tabs.computer' => 'Equipo',
			'common.tabs.usage' => 'AI Control',
			'common.quota.controlCenter' => 'Centro de control de IA',
			'common.quota.section.overview' => 'Resumen',
			'common.quota.section.quotas' => 'Cuotas',
			'common.quota.section.usage' => 'Uso',
			'common.quota.section.agents' => 'Agentes',
			'common.quota.filter.all' => 'Todos',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 días',
			'common.quota.period.k30d' => '30 días',
			'common.quota.period.all' => 'Todos',
			'common.quota.group.provider' => 'Proveedor',
			'common.quota.group.model' => 'Modelo',
			'common.quota.group.agent' => 'Agente',
			'common.quota.group.tool' => 'Herramienta',
			'common.quota.metric.tokens' => 'Tokens',
			'common.quota.metric.input' => 'Entrada',
			'common.quota.metric.output' => 'Salida',
			'common.quota.metric.cache' => 'Lecturas de caché',
			'common.quota.metric.calls' => 'Llamadas API',
			'common.quota.metric.cost' => 'Costo',
			'common.quota.metric.sessions' => 'Sesiones',
			'common.quota.cost.billed' => 'Facturado (API + exceso)',
			'common.quota.cost.listPrice' => 'Precio de lista de tokens usados',
			'common.quota.cost.subscriptionValue' => 'Cubierto por suscripciones',
			'common.quota.cost.cacheSavings' => 'Ahorro de caché',
			'common.quota.cost3.billed' => 'Facturado (API + exceso)',
			'common.quota.cost3.listPrice' => 'Precio de lista de tokens usados',
			'common.quota.cost3.subscriptionValue' => 'Cubierto por suscripciones',
			'common.quota.overview.trendTitle' => 'Tokens y costo — últimos 7 días',
			'common.quota.overview.effectiveCost' => 'Costo efectivo (7 días)',
			'common.quota.overview.alertsTitle' => 'Alertas',
			'common.quota.overview.noAlerts' => 'Nada requiere atención ahora mismo.',
			'common.quota.overview.limitsTitle' => 'Uso y límites',
			'common.quota.overview.activeTasks' => 'Tareas activas',
			'common.quota.overview.viewAccounts' => 'Todas las cuentas',
			'common.quota.overview.viewAgents' => 'Todos los agentes',
			'common.quota.overview.noTasks' => 'No hay agentes en ejecución ahora mismo.',
			'common.quota.usage.trendTitle' => 'Tendencia diaria',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Desglose por ${group}',
			'common.quota.usage.colName' => 'Nombre',
			'common.quota.usage.sourceUnavailable' => 'Almacén de analítica no disponible; sin datos.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} en ejecución',
			'common.quota.agents.colAgent' => 'Agente',
			'common.quota.agents.colStatus' => 'Estado',
			'common.quota.agents.colTask' => 'Tarea',
			'common.quota.agents.colModel' => 'Cuenta / modelo',
			'common.quota.agents.colTime' => 'Hora',
			'common.quota.agents.empty' => 'Ningún agente coincide con este filtro.',
			'common.quota.agents.detailSession' => 'Sesión',
			'common.quota.agents.detailStarted' => 'Iniciado',
			'common.quota.agents.detailRetries' => 'Reintentos',
			'common.quota.agents.detailResult' => 'Resultado',
			'common.quota.agents.notTracked' => 'no rastreado',
			'common.quota.agentStatus.running' => 'En ejecución',
			'common.quota.agentStatus.waiting' => 'Esperando',
			'common.quota.agentStatus.failed' => 'Fallido',
			'common.quota.agentStatus.finished' => 'Finalizado',
			'common.quota.agentStatus.queued' => 'En cola',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: al ritmo actual, el límite se agota en ${value}',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% usado (umbral ${watch}%)',
			'common.quota.backToChat' => 'Volver al chat',
			'common.quota.syncNow' => 'Sincronizar ahora',
			'common.quota.generatedAt' => ({required Object value}) => 'Actualizado ${value}',
			'common.quota.loading' => 'Cargando límites de cuenta…',
			'common.quota.remaining' => ({required Object value}) => '${value}% restante',
			'common.quota.resetsIn' => ({required Object value}) => 'se reinicia en ${value}',
			'common.quota.projected' => ({required Object value}) => 'al ritmo actual, este límite se agota en ${value}',
			'common.quota.syncedAgo' => ({required Object value}) => 'sincronizado hace ${value}',
			'common.quota.refreshAccount' => 'Actualizar cuenta',
			'common.quota.syncFailed' => 'Error de sincronización',
			'common.quota.history' => 'Historial',
			'common.quota.historyPoints' => ({required Object value}) => '${value} lecturas registradas',
			'common.quota.historyEmpty' => 'Aún no hay historial registrado',
			'common.quota.noAgents' => 'No hay agentes asignados',
			'common.quota.noSubscription' => 'Sin suscripción',
			'common.quota.noSubscriptionHint' => 'El proveedor no reporta ningún plan activo para esta cuenta.',
			'common.quota.quality.live' => 'En vivo',
			'common.quota.quality.cached' => 'En caché',
			'common.quota.quality.estimate' => 'Estimación',
			'common.quota.quality.unknown' => 'Desconocido',
			'common.quota.quality.error' => 'Error',
			'common.quota.kpi.atRisk' => 'Límites en riesgo',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'cuentas por encima del ${value}%',
			'common.quota.kpi.windowsAtRisk' => 'Ventanas agotándose',
			'common.quota.kpi.errored' => 'Fallos de sincronización',
			'common.quota.kpi.activeAgents' => 'Agentes activos',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} esperando · ${queued} en cola',
			'common.quota.kpi.nextReset' => 'Próximo reinicio',
			'common.quota.kpi.tokens' => 'Tokens',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} sesiones',
			'common.quota.kpi.cost' => 'Costo estimado',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} cubierto por planes',
			'common.quota.empty.title' => 'No hay cuentas conectadas',
			'common.quota.empty.description' => 'Inicia sesión en Claude, Codex, Gemini o CommandCode para rastrear las cuotas aquí.',
			'common.quota.settings.title' => 'Alertas y enrutamiento',
			'common.quota.settings.description' => 'Controla cuándo te avisa el panel y cómo se sugieren las cuentas para el trabajo nuevo.',
			'common.quota.settings.alertsEnabled' => 'Alertas predictivas y de umbral',
			'common.quota.settings.alertsEnabledHint' => 'Avisar antes de que un límite se agote al ritmo actual, no solo al 90%.',
			'common.quota.settings.watchThreshold' => 'Umbral de observación (%)',
			'common.quota.settings.dangerThreshold' => 'Umbral de peligro (%)',
			'common.quota.settings.routingMode' => 'Enrutamiento',
			'common.quota.settings.routing.manual' => 'Manual — solo recomendación',
			'common.quota.settings.routing.ask' => 'Preguntar antes de cambiar de cuenta',
			'common.quota.settings.routing.autoLowRisk' => 'Cambio automático para tareas de bajo riesgo',
			'common.quota.settings.logSources' => 'Fuentes de registro',
			'common.quota.settings.logSourcesHint' => 'Las pantallas de uso y agentes leen estas fuentes de solo lectura.',
			'common.quota.settings.quotaConsent' => 'Permitir consulta de cuotas',
			'common.quota.settings.quotaConsentHint' => 'Consulta los endpoints de los proveedores con tus credenciales guardadas para leer los límites en vivo.',
			'common.quota.settings.perAccount' => 'Sustituciones por cuenta',
			'common.quota.settings.tab' => 'Ajustes del Control Center',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Todos',
			'common.status.loading' => 'Cargando...',
			'common.status.success' => 'Éxito',
			'common.status.error' => 'Error',
			'common.status.failed' => 'Falló',
			'common.status.pending' => 'Pendiente',
			'common.status.completed' => 'Completado',
			'common.status.inProgress' => 'En curso',
			'common.messages.savedSuccessfully' => 'Guardado correctamente',
			'common.messages.deletedSuccessfully' => 'Eliminado correctamente',
			'common.messages.updatedSuccessfully' => 'Actualizado correctamente',
			'common.messages.operationFailed' => 'La operación falló',
			'common.messages.networkError' => 'Error de red. Comprueba tu conexión.',
			'common.messages.unauthorized' => 'No autorizado. Inicia sesión.',
			'common.messages.notFound' => 'No encontrado',
			'common.messages.invalidInput' => 'Entrada no válida',
			'common.messages.requiredField' => 'Este campo es obligatorio',
			'common.messages.unknownError' => 'Ocurrió un error desconocido',
			'common.messages.renameSessionFailed' => 'No se pudo renombrar la sesión. Inténtalo de nuevo.',
			'common.navigation.settings' => 'Ajustes',
			'common.navigation.home' => 'Inicio',
			'common.navigation.back' => 'Atrás',
			'common.navigation.next' => 'Siguiente',
			'common.navigation.previous' => 'Anterior',
			'common.navigation.logout' => 'Cerrar sesión',
			'common.navigation.backToChat' => 'Volver al chat',
			'common.common.language' => 'Idioma',
			'common.common.theme' => 'Tema',
			'common.common.darkMode' => 'Modo oscuro',
			'common.common.lightMode' => 'Modo claro',
			'common.common.name' => 'Nombre',
			'common.common.description' => 'Descripción',
			'common.common.enabled' => 'Activado',
			'common.common.disabled' => 'Desactivado',
			'common.common.optional' => 'Opcional',
			'common.common.version' => 'Versión',
			'common.common.select' => 'Seleccionar',
			'common.common.selectAll' => 'Seleccionar todo',
			'common.common.deselectAll' => 'Deseleccionar todo',
			'common.common.done' => 'Hecho',
			'common.common.failed' => 'Falló',
			'common.time.justNow' => 'Justo ahora',
			'common.time.minutesAgo' => ({required Object count}) => 'hace ${count} min',
			'common.time.hoursAgo' => ({required Object count}) => 'hace ${count} horas',
			'common.time.daysAgo' => ({required Object count}) => 'hace ${count} días',
			'common.time.yesterday' => 'Ayer',
			'common.fileOperations.newFile' => 'Archivo nuevo',
			'common.fileOperations.newFolder' => 'Carpeta nueva',
			'common.fileOperations.rename' => 'Renombrar',
			'common.fileOperations.move' => 'Mover',
			'common.fileOperations.copyPath' => 'Copiar ruta',
			'common.fileOperations.openInEditor' => 'Abrir en el editor',
			'common.mainContent.loading' => 'Cargando DDAgent',
			'common.mainContent.settingUpWorkspace' => 'Preparando tu espacio de trabajo...',
			'common.mainContent.chooseProject' => 'Elige tu proyecto',
			'common.mainContent.selectProjectDescription' => 'Selecciona un proyecto en la barra lateral para empezar a programar con Claude. Cada proyecto contiene tus sesiones de chat e historial de archivos.',
			'common.mainContent.tip' => 'Consejo',
			'common.mainContent.createProjectMobile' => 'Toca el botón de menú de arriba para acceder a los proyectos',
			'common.mainContent.createProjectDesktop' => 'Crea un proyecto nuevo haciendo clic en el icono de carpeta de la barra lateral',
			'common.mainContent.newSession' => 'Nueva sesión',
			'common.mainContent.untitledSession' => 'Sesión sin título',
			'common.mainContent.projectFiles' => 'Archivos del proyecto',
			'common.mainContent.focusMode' => 'Modo concentración (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Salir del modo concentración (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Dividir sesión',
			'common.mainContent.closeSplitSession' => 'Cerrar sesión dividida',
			'common.mainContent.chooseWorkspace' => 'Elige un espacio de trabajo',
			'common.mainContent.chooseWorkspaceDescription' => 'Elige un espacio de trabajo para este chat o crea uno nuevo en Ajustes.',
			'common.mainContent.createWorkspace' => 'Crear espacio de trabajo en Ajustes',
			'common.mainContent.recentProjects' => 'Proyectos recientes',
			'common.fileTree.loading' => 'Cargando archivos...',
			'common.fileTree.files' => 'Archivos',
			'common.fileTree.simpleView' => 'Vista simple',
			'common.fileTree.compactView' => 'Vista compacta',
			'common.fileTree.detailedView' => 'Vista detallada',
			'common.fileTree.searchPlaceholder' => 'Buscar archivos y carpetas...',
			'common.fileTree.searchContentPlaceholder' => 'Buscar en archivos...',
			'common.fileTree.searchInFiles' => 'Buscar en archivos',
			'common.fileTree.searchByName' => 'Buscar por nombre',
			'common.fileTree.clearSearch' => 'Limpiar búsqueda',
			'common.fileTree.name' => 'Nombre',
			'common.fileTree.size' => 'Tamaño',
			'common.fileTree.modified' => 'Modificado',
			'common.fileTree.permissions' => 'Permisos',
			'common.fileTree.noFilesFound' => 'No se encontraron archivos',
			'common.fileTree.checkProjectPath' => 'Comprueba si la ruta del proyecto es accesible',
			'common.fileTree.loadFailed' => 'No se pudieron cargar los archivos',
			'common.fileTree.noMatchesFound' => 'No se encontraron coincidencias',
			'common.fileTree.noSearchResults' => 'No se encontraron coincidencias',
			'common.fileTree.tryDifferentSearch' => 'Prueba con otro término o limpia la búsqueda',
			'common.fileTree.searchError' => 'Error en la búsqueda',
			'common.fileTree.searching' => 'Buscando...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Mostrando los primeros ${count} resultados',
			'common.fileTree.justNow' => 'justo ahora',
			'common.fileTree.minAgo' => ({required Object count}) => 'hace ${count} min',
			'common.fileTree.hoursAgo' => ({required Object count}) => 'hace ${count} horas',
			'common.fileTree.daysAgo' => ({required Object count}) => 'hace ${count} días',
			'common.fileTree.newFile' => 'Archivo nuevo (Cmd+N)',
			'common.fileTree.newFolder' => 'Carpeta nueva (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Actualizar',
			'common.fileTree.collapseAll' => 'Contraer todo',
			'common.fileTree.context.rename' => 'Renombrar',
			'common.fileTree.context.delete' => 'Eliminar',
			'common.fileTree.context.copyPath' => 'Copiar ruta',
			'common.fileTree.context.download' => 'Descargar',
			'common.fileTree.context.newFile' => 'Archivo nuevo',
			'common.fileTree.context.newFolder' => 'Carpeta nueva',
			'common.fileTree.context.upload' => 'Subir archivos',
			'common.fileTree.context.refresh' => 'Actualizar',
			'common.fileTree.context.menuLabel' => 'Menú contextual de archivo',
			'common.fileTree.context.loading' => 'Cargando...',
			'common.fileTree.allWorkspaces' => 'Todos los espacios de trabajo',
			'common.fileTree.delete.confirm' => 'Eliminar',
			'common.fileTree.delete.fileWarning' => 'Este archivo se eliminará permanentemente.',
			'common.fileTree.delete.folderWarning' => 'Esta carpeta y todo su contenido se eliminarán permanentemente.',
			'common.fileTree.delete.title' => ({required Object type}) => 'Eliminar ${type}',
			'common.fileTree.dropToUpload' => 'Suelta archivos para subirlos',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Suelta archivos para subirlos a «${folder}»',
			'common.fileTree.noProject' => 'Añade primero un proyecto',
			'common.fileTree.noRecentFiles' => 'Ningún archivo modificado en los últimos 7 días',
			'common.fileTree.showAllFiles' => 'Mostrar todos los archivos',
			'common.fileTree.showAllFilesHint' => 'Desactiva el filtro de recientes para ver todo.',
			'common.fileTree.showRecentOnly' => 'Mostrar archivos modificados en los últimos 7 días',
			'common.fileTree.toast.copyFailed' => 'No se pudo copiar la ruta',
			'common.fileTree.toast.fileCreated' => 'Archivo creado correctamente',
			'common.fileTree.toast.fileDeleted' => 'Archivo eliminado',
			'common.fileTree.toast.folderCreated' => 'Carpeta creada correctamente',
			'common.fileTree.toast.folderDeleted' => 'Carpeta eliminada',
			'common.fileTree.toast.folderDownloaded' => 'Carpeta descargada como ZIP',
			'common.fileTree.toast.pathCopied' => 'Ruta copiada al portapapeles',
			'common.fileTree.toast.renamed' => 'Renombrado correctamente',
			'common.fileTree.uploadComplete' => 'Subida completada',
			'common.fileTree.uploadFailed' => 'Falló la subida',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Subir archivos (máx. ${size} cada uno)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Subir archivos a «${folder}»',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => 'Subidos ${uploaded} de ${total} ${label}',
			'common.fileTree.uploadingFiles' => 'Subiendo archivos',
			'common.fileTree.validation.dotsOnly' => 'El nombre de archivo no puede ser solo puntos',
			'common.fileTree.validation.emptyName' => 'El nombre de archivo no puede estar vacío',
			'common.fileTree.validation.invalidChars' => 'El nombre de archivo contiene caracteres no válidos',
			'common.fileTree.validation.reserved' => 'El nombre de archivo es un nombre reservado',
			'common.projectWizard.title' => 'Crear proyecto nuevo',
			'common.projectWizard.steps.type' => 'Tipo',
			'common.projectWizard.steps.configure' => 'Configurar',
			'common.projectWizard.steps.confirm' => 'Confirmar',
			'common.projectWizard.step1.question' => '¿Ya tienes un espacio de trabajo o quieres crear uno nuevo?',
			'common.projectWizard.step1.existing.title' => 'Espacio de trabajo existente',
			'common.projectWizard.step1.existing.description' => 'Ya tengo un espacio de trabajo en mi servidor y solo necesito añadirlo a la lista de proyectos',
			'common.projectWizard.step1.kNew.title' => 'Espacio de trabajo nuevo',
			'common.projectWizard.step1.kNew.description' => 'Crea un espacio de trabajo nuevo, opcionalmente clonando un repositorio de GitHub',
			'common.projectWizard.step2.existingPath' => 'Ruta del espacio de trabajo',
			'common.projectWizard.step2.newPath' => 'Ruta del espacio de trabajo',
			'common.projectWizard.step2.existingPlaceholder' => '/ruta/al/espacio/existente',
			'common.projectWizard.step2.newPlaceholder' => '/ruta/al/espacio/nuevo',
			'common.projectWizard.step2.existingHelp' => 'Ruta completa al directorio de tu espacio de trabajo existente',
			'common.projectWizard.step2.newHelp' => 'Ruta completa al directorio de tu espacio de trabajo',
			'common.projectWizard.step2.githubUrl' => 'URL de GitHub (opcional)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/usuario/repositorio',
			'common.projectWizard.step2.githubHelp' => 'Opcional: proporciona una URL de GitHub para clonar un repositorio',
			'common.projectWizard.step2.githubAuth' => 'Autenticación de GitHub (opcional)',
			'common.projectWizard.step2.githubAuthHelp' => 'Solo se requiere para repositorios privados. Los repos públicos se pueden clonar sin autenticación.',
			'common.projectWizard.step2.loadingTokens' => 'Cargando tokens guardados...',
			'common.projectWizard.step2.storedToken' => 'Token guardado',
			'common.projectWizard.step2.newToken' => 'Token nuevo',
			'common.projectWizard.step2.nonePublic' => 'Ninguno (público)',
			'common.projectWizard.step2.selectToken' => 'Seleccionar token',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Selecciona un token --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Este token se usará solo para esta operación',
			_ => null,
		} ?? switch (path) {
			'common.projectWizard.step2.publicRepoInfo' => 'Los repositorios públicos no requieren autenticación. Puedes omitir el token si clonas un repo público.',
			'common.projectWizard.step2.noTokensHelp' => 'No hay tokens guardados disponibles. Puedes añadir tokens en Ajustes → Claves API para reutilizarlos fácilmente.',
			'common.projectWizard.step2.optionalTokenPublic' => 'Token de GitHub (opcional para repos públicos)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (déjalo vacío para repos públicos)',
			'common.projectWizard.step3.reviewConfig' => 'Revisa tu configuración',
			'common.projectWizard.step3.existingWorkspace' => 'Espacio de trabajo existente',
			'common.projectWizard.step3.newWorkspace' => 'Espacio de trabajo nuevo',
			'common.projectWizard.step3.path' => 'Ruta:',
			'common.projectWizard.step3.cloneFrom' => 'Clonar desde:',
			'common.projectWizard.step3.authentication' => 'Autenticación:',
			'common.projectWizard.step3.usingStoredToken' => 'Usando token guardado:',
			'common.projectWizard.step3.usingProvidedToken' => 'Usando token proporcionado',
			'common.projectWizard.step3.noAuthentication' => 'Sin autenticación',
			'common.projectWizard.step3.sshKey' => 'Clave SSH',
			'common.projectWizard.step3.existingInfo' => 'El espacio de trabajo se añadirá a tu lista de proyectos y estará disponible para sesiones de Claude/Cursor.',
			'common.projectWizard.step3.newWithClone' => 'El repositorio se clonará desde esta carpeta.',
			'common.projectWizard.step3.newEmpty' => 'El espacio de trabajo se añadirá a tu lista de proyectos y estará disponible para sesiones de Claude/Cursor.',
			'common.projectWizard.step3.cloningRepository' => 'Clonando repositorio...',
			'common.projectWizard.buttons.cancel' => 'Cancelar',
			'common.projectWizard.buttons.back' => 'Atrás',
			'common.projectWizard.buttons.next' => 'Siguiente',
			'common.projectWizard.buttons.createProject' => 'Crear proyecto',
			'common.projectWizard.buttons.creating' => 'Creando...',
			'common.projectWizard.buttons.cloning' => 'Clonando...',
			'common.projectWizard.errors.selectType' => 'Selecciona si tienes un espacio de trabajo existente o quieres crear uno nuevo',
			'common.projectWizard.errors.providePath' => 'Proporciona la ruta del espacio de trabajo',
			'common.projectWizard.errors.failedToCreate' => 'No se pudo crear el espacio de trabajo',
			'common.projectWizard.errors.failedToCreateFolder' => 'No se pudo crear la carpeta',
			'common.notifications.genericTool' => 'una herramienta',
			'common.notifications.codes.generic.info.title' => 'Notificación',
			'common.notifications.codes.permission.required.title' => 'Acción requerida',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} está esperando tu decisión.',
			'common.notifications.codes.run.stopped.title' => 'Ejecución detenida',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Motivo: ${reason}',
			'common.notifications.codes.run.failed.title' => 'La ejecución falló',
			'common.notifications.codes.agent.notification.title' => 'Notificación del agente',
			'common.versionUpdate.title' => 'Actualización disponible',
			'common.versionUpdate.newVersionReady' => 'Hay una versión nueva lista',
			'common.versionUpdate.currentVersion' => 'Versión actual',
			'common.versionUpdate.latestVersion' => 'Última versión',
			'common.versionUpdate.whatsNew' => 'Novedades:',
			'common.versionUpdate.viewFullRelease' => 'Ver la publicación completa',
			'common.versionUpdate.updateProgress' => 'Progreso de la actualización:',
			'common.versionUpdate.manualUpgrade' => 'Actualización manual:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'O haz clic en "Actualizar ahora" para ejecutar la actualización automáticamente.',
			'common.versionUpdate.updateCompleted' => '¡Actualización completada correctamente!',
			'common.versionUpdate.restartServer' => 'Reinicia el servidor para aplicar los cambios.',
			'common.versionUpdate.updateFailed' => 'La actualización falló',
			'common.versionUpdate.buttons.close' => 'Cerrar',
			'common.versionUpdate.buttons.later' => 'Más tarde',
			'common.versionUpdate.buttons.copyCommand' => 'Copiar comando',
			'common.versionUpdate.buttons.updateNow' => 'Actualizar ahora',
			'common.versionUpdate.buttons.updating' => 'Actualizando...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Cerrar el modal de actualización de versión',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Mostrar barra lateral',
			'common.versionUpdate.ariaLabels.settings' => 'Ajustes',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Actualización disponible',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Cerrar barra lateral',
			'common.actions.cancel' => 'Cancelar',
			'common.actions.retry' => 'Reintentar',
			'common.actions.save' => 'Guardar',
			'common.browserPane.address' => 'Dirección',
			'common.browserPane.back' => 'Atrás',
			'common.browserPane.connecting' => 'Conectando al navegador…',
			'common.browserPane.connectionFailed' => 'Falló la conexión con el navegador.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => 'No se pudo cargar ${url}',
			'common.browserPane.disconnected' => 'Vista del navegador desconectada',
			'common.browserPane.enterUrl' => 'Introduce una URL',
			'common.browserPane.forward' => 'Adelante',
			'common.browserPane.invalidUrl' => 'Introduce una URL http(s) válida',
			'common.browserPane.noAuthToken' => 'No hay token de autenticación disponible.',
			'common.browserPane.openExternal' => 'Abrir en el navegador del sistema',
			'common.browserPane.reload' => 'Recargar',
			'common.browserPane.retry' => 'Reintentar',
			'common.browserPane.stop' => 'Detener',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} activas',
			'common.browserUse.cancel' => 'Cancelar',
			'common.browserUse.close' => 'Cerrar',
			'common.browserUse.delete' => 'Eliminar',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} se eliminará permanentemente.',
			'common.browserUse.deleteSession' => 'Eliminar sesión',
			'common.browserUse.deleteTitle' => '¿Eliminar la sesión del navegador?',
			'common.browserUse.empty.descDisabled' => 'Activa Browser en ajustes para que los agentes abran sesiones de navegador supervisadas.',
			'common.browserUse.empty.descEnabled' => 'Las sesiones de navegador del agente aparecen aquí mientras una tarea de IA usa Browser.',
			'common.browserUse.empty.titleDisabled' => 'Browser está desactivado',
			'common.browserUse.empty.titleEnabled' => 'Aún no hay sesiones de navegador',
			'common.browserUse.emptyStatus' => 'vacía',
			'common.browserUse.errors.actionFailed' => 'Falló la acción del navegador',
			'common.browserUse.errors.loadFailed' => 'No se pudo cargar Browser',
			'common.browserUse.fullscreen' => 'Pantalla completa',
			'common.browserUse.installRuntime' => 'Instalar runtime',
			'common.browserUse.installing' => 'Instalando...',
			'common.browserUse.lastAction' => 'Última acción',
			'common.browserUse.nextSnapshot' => 'La próxima captura del navegador del agente aparecerá aquí.',
			'common.browserUse.noPageLoaded' => 'Ninguna página cargada',
			'common.browserUse.noSessions' => 'Sin sesiones de navegador de agentes.',
			'common.browserUse.none' => 'Ninguno',
			'common.browserUse.openSettings' => 'Abrir ajustes de Browser',
			'common.browserUse.profile' => 'Perfil',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Usa Browser para inspeccionar el flujo de pago e informar de estados de UI rotos.',
			'common.browserUse.prompts.prompt2' => 'Abre <url> con Browser, interactúa con la página y resume qué cambió tras cada paso.',
			'common.browserUse.refresh' => 'Actualizar sesiones de navegador',
			'common.browserUse.relative.daysAgo' => ' d',
			'common.browserUse.relative.hoursAgo' => ' h',
			'common.browserUse.relative.justNow' => 'Ahora mismo',
			'common.browserUse.relative.minutesAgo' => ' min',
			'common.browserUse.relative.never' => 'Nunca',
			'common.browserUse.relative.secondsAgo' => ' s',
			'common.browserUse.relative.unknown' => 'Desconocido',
			'common.browserUse.runtime.disabled' => 'Desactivado',
			'common.browserUse.runtime.installing' => 'Instalando',
			'common.browserUse.runtime.ready' => 'Listo',
			'common.browserUse.runtime.setupRequired' => 'Configuración requerida',
			'common.browserUse.runtimeSetup' => 'Se requiere configurar el runtime',
			'common.browserUse.selected' => 'Seleccionada',
			'common.browserUse.sessionFallback' => 'Sesión de navegador',
			'common.browserUse.sessionScreenshot' => 'Captura de la sesión de navegador',
			'common.browserUse.sessions' => 'Sesiones',
			'common.browserUse.status' => 'Estado',
			'common.browserUse.stop' => 'Detener',
			'common.browserUse.stopSession' => 'Detener sesión',
			'common.browserUse.subtitle' => 'Supervisa las sesiones de navegador abiertas por agentes de IA.',
			'common.browserUse.temporary' => 'Temporal',
			'common.browserUse.thisSession' => 'Esta sesión',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '${count} en total',
			'common.browserUse.updated' => ({required Object time}) => 'Actualizado ${time}',
			'common.browserUse.waiting' => 'Esperando',
			'common.browserUse.waitingForScreenshot' => 'Esperando captura de pantalla',
			'common.commandPalette.backToAll' => 'Volver a todo',
			'common.commandPalette.backspaceHint' => 'Retroceso para volver',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Ver todas las ramas (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Ver todos los commits (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Ver todos los archivos (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Ver todas las sesiones (${count})',
			'common.commandPalette.compare.costNote' => 'El coste es una estimación del cliente según las tarifas por token publicadas; los modelos desconocidos muestran «—».',
			'common.commandPalette.compare.estCost' => 'Coste est.',
			'common.commandPalette.compare.inputOutput' => 'Entrada / Salida',
			'common.commandPalette.compare.model' => 'Modelo',
			'common.commandPalette.compare.na' => 'N/D',
			'common.commandPalette.compare.openSplit' => 'Abrir en vista dividida',
			'common.commandPalette.compare.provider' => 'Proveedor',
			'common.commandPalette.compare.selectSession' => 'Selecciona una sesión…',
			'common.commandPalette.compare.tokensUsed' => 'Tokens usados',
			'common.commandPalette.groups.actions' => 'Acciones',
			'common.commandPalette.groups.branches' => 'Ramas',
			'common.commandPalette.groups.commits' => 'Commits',
			'common.commandPalette.groups.files' => 'Archivos',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Navegar',
			'common.commandPalette.groups.sessions' => 'Sesiones',
			'common.commandPalette.groups.settings' => 'Ajustes',
			'common.commandPalette.hints.close' => 'Cerrar',
			'common.commandPalette.hints.navigate' => 'Navegar',
			'common.commandPalette.hints.select' => 'Seleccionar',
			'common.commandPalette.hints.togglePalette' => 'Alternar paleta',
			'common.commandPalette.items.compareSessions' => 'Comparar sesiones',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Abrir ajustes',
			'common.commandPalette.items.selectProjectFirst' => 'Selecciona primero un proyecto',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Ajustes: ${label}',
			'common.commandPalette.items.startNewChat' => 'Iniciar nuevo chat',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Cambiar a: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Cambiar tema',
			'common.commandPalette.items.tokensAndCost' => 'tokens y coste',
			'common.commandPalette.nav.board' => 'Ir al Panel de agentes',
			'common.commandPalette.nav.chat' => 'Ir al Chat',
			'common.commandPalette.nav.files' => 'Ir a Archivos',
			'common.commandPalette.nav.git' => 'Ir a Git',
			'common.commandPalette.nav.sourceControl' => 'Ir a Control de código',
			'common.commandPalette.nav.tasks' => 'Ir a Tareas',
			'common.commandPalette.nav.usage' => 'Ir a Cuota y uso',
			'common.commandPalette.noResults' => 'Sin resultados.',
			'common.commandPalette.pages.actions' => 'Acciones',
			'common.commandPalette.pages.branches' => 'Ramas',
			'common.commandPalette.pages.commits' => 'Commits',
			'common.commandPalette.pages.compare' => 'Comparar',
			'common.commandPalette.pages.files' => 'Archivos',
			'common.commandPalette.pages.sessions' => 'Sesiones',
			'common.commandPalette.placeholder' => 'Escribe para buscar…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => 'Buscar en ${page}…',
			'common.commandPalette.title' => 'Paleta de comandos',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} por delante',
			'common.gitPanel.aheadLabel' => 'por delante',
			'common.gitPanel.aiSuggest' => 'Sugerencia IA',
			'common.gitPanel.aiSuggestTitle' => 'Generar un mensaje de commit con IA',
			'common.gitPanel.all' => 'Todos',
			'common.gitPanel.allStaged' => 'Todos los cambios preparados',
			'common.gitPanel.behind' => ({required Object count}) => '${count} por detrás',
			'common.gitPanel.behindLabel' => 'por detrás',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => '¿Eliminar la rama «${branch}»? Una eliminación normal solo funciona si la rama está totalmente fusionada. No se puede deshacer.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => '¿Cambiar a la rama «${branch}»? Asegúrate de no tener cambios sin confirmar.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} locales, ${remote} remotas',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} locales',
			'common.gitPanel.branches.current' => 'actual',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => 'Eliminar ${branch}',
			'common.gitPanel.branches.emptyDesc' => 'Crea una rama para empezar trabajo en paralelo.',
			'common.gitPanel.branches.forceDelete' => 'Forzar eliminación',
			'common.gitPanel.branches.forceDeleteDesc' => 'Elimina permanentemente la rama aunque contenga commits no fusionados en otro lugar.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Forzar la eliminación de esta rama sin fusionar',
			'common.gitPanel.branches.local' => 'Locales',
			'common.gitPanel.branches.kNew' => 'Nueva rama',
			'common.gitPanel.branches.noMatch' => 'Ninguna rama coincide con la búsqueda',
			'common.gitPanel.branches.none' => 'No se encontraron ramas',
			'common.gitPanel.branches.remote' => 'remotas',
			'common.gitPanel.branches.kSwitch' => 'Cambiar',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Cambiar a ${branch}',
			'common.gitPanel.cancel' => 'Cancelar',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Cambios (${count})',
			'common.gitPanel.clearSearch' => 'Limpiar búsqueda',
			'common.gitPanel.collapseDiff' => 'Contraer diff',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Confirmar cambios',
			'common.gitPanel.commitFiles' => ({required Object count}) => 'Confirmar ${count} archivo(s)',
			'common.gitPanel.committing' => 'Confirmando...',
			'common.gitPanel.confirmActions.commit' => 'Confirmar',
			'common.gitPanel.confirmActions.delete' => 'Eliminar',
			'common.gitPanel.confirmActions.deleteBranch' => 'Eliminar',
			'common.gitPanel.confirmActions.discard' => 'Descartar',
			'common.gitPanel.confirmActions.publish' => 'Publicar',
			'common.gitPanel.confirmActions.pull' => 'Pull',
			'common.gitPanel.confirmActions.push' => 'Push',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Revertir commit',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => '¿Confirmar ${count} archivo(s) con el mensaje: «${message}»?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => '¿Eliminar el archivo sin seguimiento «${file}»? No se puede deshacer.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => '¿Descartar todos los cambios en «${file}»? No se puede deshacer.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => '¿Publicar la rama «${branch}» en ${remote}?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => '¿Traer ${count} commit(s) desde ${remote}?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => '¿Enviar ${count} commit(s) a ${remote}?',
			'common.gitPanel.confirmRevert' => '¿Revertir el último commit local? Elimina el commit pero mantiene sus cambios preparados.',
			'common.gitPanel.confirmTitles.commit' => 'Confirmar acción',
			'common.gitPanel.confirmTitles.delete' => 'Eliminar archivo',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Eliminar rama',
			'common.gitPanel.confirmTitles.discard' => 'Descartar cambios',
			'common.gitPanel.confirmTitles.publish' => 'Publicar rama',
			'common.gitPanel.confirmTitles.pull' => 'Confirmar pull',
			'common.gitPanel.confirmTitles.push' => 'Confirmar push',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Revertir commit local',
			'common.gitPanel.createBranch' => 'Crear nueva rama',
			'common.gitPanel.creating' => 'Creando...',
			'common.gitPanel.delete' => 'Eliminar',
			'common.gitPanel.deleteUntracked' => 'Eliminar archivo sin seguimiento',
			'common.gitPanel.deselectAll' => 'Deseleccionar todo',
			'common.gitPanel.discard' => 'Descartar',
			'common.gitPanel.discardChanges' => 'Descartar cambios',
			'common.gitPanel.dismiss' => 'Descartar',
			'common.gitPanel.dismissError' => 'Descartar error',
			'common.gitPanel.errors.createBranchFailed' => 'Falló la creación de la rama',
			'common.gitPanel.errors.createWorktreeFailed' => 'No se pudo crear el worktree',
			'common.gitPanel.errors.deleteBranchFailed' => 'Falló la eliminación de la rama',
			'common.gitPanel.errors.fetchFailed' => 'Falló el fetch',
			'common.gitPanel.errors.initFailed' => 'No se pudo inicializar el repositorio',
			'common.gitPanel.errors.initialCommitFailed' => 'No se pudo crear el commit inicial',
			'common.gitPanel.errors.mergeFailed' => 'Falló la fusión',
			'common.gitPanel.errors.openWorktreeFailed' => 'No se pudo abrir el worktree',
			'common.gitPanel.errors.operationFailed' => 'Falló la operación git',
			'common.gitPanel.errors.publishFailed' => 'Falló la publicación',
			'common.gitPanel.errors.pullFailed' => 'Falló el pull',
			'common.gitPanel.errors.pushFailed' => 'Falló el push',
			'common.gitPanel.errors.removeWorktreeFailed' => 'No se pudo eliminar el worktree',
			'common.gitPanel.errors.stageFailed' => 'Falló la preparación',
			'common.gitPanel.errors.stageHunksFailed' => 'Falló la preparación de secciones',
			'common.gitPanel.errors.switchFailed' => 'Falló el cambio de rama',
			'common.gitPanel.errors.unstageFailed' => 'Falló la quita de preparación',
			'common.gitPanel.errors.unstageHunksFailed' => 'Falló la quita de preparación de secciones',
			'common.gitPanel.expandDiff' => 'Expandir diff',
			'common.gitPanel.fetch' => 'Fetch',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Fetch desde ${remote}',
			'common.gitPanel.fetching' => 'Obteniendo…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} archivo(s) seleccionado(s)',
			'common.gitPanel.generating' => 'Generando...',
			'common.gitPanel.history.added' => 'Añadidas',
			'common.gitPanel.history.author' => 'Autor',
			'common.gitPanel.history.changedFiles' => 'Archivos modificados',
			'common.gitPanel.history.date' => 'Fecha',
			'common.gitPanel.history.empty' => 'No se encontraron commits',
			'common.gitPanel.history.files' => 'Archivos',
			'common.gitPanel.history.removed' => 'Eliminadas',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Eliminar el worktree y borrar su rama una vez fusionada',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Limpiar tras la fusión',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} commit(s)',
			'common.gitPanel.mergeWorktree.merge' => 'Fusionar',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Fusionar la rama \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Mensaje de commit',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Combinar los ${commits} en un solo commit en ${branch}',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Compactar commits',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Compactar y fusionar',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Compactar y fusionar la rama \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => 'Fusionar worktree',
			'common.gitPanel.merging' => 'Fusionando...',
			'common.gitPanel.messagePlaceholder' => 'Mensaje (Ctrl+Intro para confirmar)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Esto creará una nueva rama desde la rama actual (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Nombre de la rama',
			'common.gitPanel.newBranch.submit' => 'Crear rama',
			'common.gitPanel.newBranch.title' => 'Crear nueva rama',
			'common.gitPanel.newWorktree.branchLabel' => 'Rama',
			'common.gitPanel.newWorktree.createFrom' => 'Crear desde',
			'common.gitPanel.newWorktree.description' => 'Extrae una rama en su propia carpeta y trabaja en ella en paralelo.',
			'common.gitPanel.newWorktree.existingBranch' => 'Rama existente — se extraerá tal cual.',
			'common.gitPanel.newWorktree.submit' => 'Crear worktree',
			'common.gitPanel.newWorktree.switchAfter' => 'Cambiar al worktree tras crearlo',
			'common.gitPanel.newWorktree.title' => 'Nuevo worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Se creará en',
			'common.gitPanel.noChanges' => 'No se detectaron cambios',
			'common.gitPanel.noChangesToCommit' => 'No hay cambios que confirmar',
			'common.gitPanel.noCommits.create' => 'Crear commit inicial',
			'common.gitPanel.noCommits.creating' => 'Creando commit inicial...',
			'common.gitPanel.noCommits.description' => 'Este repositorio aún no tiene commits. Crea tu primer commit para empezar a rastrear cambios.',
			'common.gitPanel.noCommits.title' => 'Aún no hay commits',
			'common.gitPanel.noMatchingBranches' => 'No hay ramas coincidentes',
			'common.gitPanel.noRepo.description' => 'Este proyecto aún no es un repositorio git. Inicializa uno para rastrear cambios y usar el control de código.',
			'common.gitPanel.noRepo.init' => 'Ejecutar git init',
			'common.gitPanel.noRepo.initializing' => 'Inicializando repositorio...',
			'common.gitPanel.noRepo.title' => 'Sin repositorio git',
			'common.gitPanel.noStagedFiles' => 'No hay archivos preparados',
			'common.gitPanel.none' => 'Ninguno',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Nada que enviar a ${remote}',
			'common.gitPanel.openFile' => 'Clic para abrir el archivo',
			'common.gitPanel.publish' => 'Publicar',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => 'Publicar «${branch}» en ${remote}',
			'common.gitPanel.publishing' => 'Publicando…',
			'common.gitPanel.pull' => 'Pull',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Pull ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => 'Traer ${count} desde ${remote}',
			'common.gitPanel.pulling' => 'Trayendo…',
			'common.gitPanel.push' => 'Push',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Push ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => 'Enviar ${count} a ${remote}',
			'common.gitPanel.pushing' => 'Enviando…',
			'common.gitPanel.recentCommits' => 'Commits recientes',
			'common.gitPanel.refresh' => 'Actualizar estado git',
			'common.gitPanel.remove' => 'Eliminar',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Eliminar también la rama',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => '¿Eliminar el worktree de ${branch}? Su carpeta se borra y el proyecto vinculado se archiva — las sesiones de chat siguen siendo recuperables.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'Este worktree tiene ${count} cambio(s) sin confirmar que se perderán.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Descartar cambios sin confirmar',
			'common.gitPanel.removeWorktree.title' => 'Eliminar worktree',
			'common.gitPanel.removing' => 'Eliminando...',
			'common.gitPanel.revertLatest' => 'Revertir último commit local',
			'common.gitPanel.scroll' => 'Desplazamiento',
			'common.gitPanel.searchBranches' => 'Buscar ramas...',
			'common.gitPanel.selectAll' => 'Seleccionar todo',
			'common.gitPanel.selectProject' => 'Selecciona un proyecto para ver el control de código',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => '${selected} de ${total} archivos seleccionados',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => '${selected} de ${total} seleccionados',
			'common.gitPanel.sideBySide' => 'Lado a lado',
			'common.gitPanel.stageAll' => 'Preparar todo',
			'common.gitPanel.stageHunk' => 'Preparar esta sección',
			'common.gitPanel.staged' => ({required Object count}) => 'Preparados (${count})',
			'common.gitPanel.status.added' => 'Añadido',
			'common.gitPanel.status.deleted' => 'Eliminado',
			'common.gitPanel.status.modified' => 'Modificado',
			'common.gitPanel.status.untracked' => 'Sin seguimiento',
			'common.gitPanel.statusGuide' => 'Guía de estados de archivo',
			'common.gitPanel.switchScroll' => 'Cambiar a desplazamiento horizontal',
			'common.gitPanel.switchSplit' => 'Cambiar a vista lado a lado',
			'common.gitPanel.switchUnified' => 'Cambiar a vista unificada',
			'common.gitPanel.switchWrap' => 'Cambiar a ajuste de texto',
			'common.gitPanel.unified' => 'Unificado',
			'common.gitPanel.unstageAll' => 'Quitar preparación de todo',
			'common.gitPanel.unstageHunk' => 'Quitar preparación de esta sección',
			'common.gitPanel.upToDate' => 'Al día',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'Al día con ${remote}',
			'common.gitPanel.viewAll' => 'Ver todo',
			'common.gitPanel.viewsAria' => 'Vistas de control de código',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} cambio(s)',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree(s)',
			'common.gitPanel.worktrees.createFirst' => 'Crea tu primer worktree',
			'common.gitPanel.worktrees.detached' => 'separado',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'separado @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'HEAD detached',
			'common.gitPanel.worktrees.emptyDesc' => 'Un worktree extrae una rama en su propia carpeta, así puedes tener sesiones de chat paralelas y fusionar los resultados cuando estén listos.',
			'common.gitPanel.worktrees.emptyTitle' => 'Trabaja en ramas en paralelo',
			'common.gitPanel.worktrees.locked' => 'bloqueado',
			'common.gitPanel.worktrees.mainWorktree' => 'worktree principal',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => 'Fusionar ${branch} en la rama base',
			'common.gitPanel.worktrees.kNew' => 'Nuevo worktree',
			'common.gitPanel.worktrees.none' => 'Sin worktrees',
			'common.gitPanel.worktrees.nothingToMerge' => 'Nada que fusionar — no hay commits por delante de la rama base',
			'common.gitPanel.worktrees.open' => 'Abrir',
			'common.gitPanel.worktrees.refresh' => 'Actualizar worktrees',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Eliminar worktree de ${branch}',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Cambiar a ${branch}',
			'common.gitPanel.wrap' => 'Ajuste',
			'common.gitPanel.tabs.changes' => 'Cambios',
			'common.gitPanel.tabs.history' => 'Commits',
			'common.gitPanel.tabs.branches' => 'Ramas',
			'common.gitPanel.tabs.worktrees' => 'Worktrees',
			'common.gitPanel.save' => 'Guardar',
			'common.gitPanel.worktreeScripts.title' => 'Scripts del worktree',
			'common.gitPanel.worktreeScripts.setup' => 'Script de configuración (se ejecuta tras crear/abrir)',
			'common.gitPanel.worktreeScripts.run' => 'Iniciar servidor de desarrollo',
			'common.gitPanel.worktreeScripts.stop' => 'Detener servidor de desarrollo',
			'common.gitPanel.worktreeScripts.runScript' => 'Script de ejecución (servidor de desarrollo, bajo demanda)',
			'common.gitPanel.worktreeScripts.runPort' => 'Puerto de vista previa (opcional — se detecta automáticamente si está vacío)',
			'common.gitPanel.worktreeScripts.invalidPort' => 'El puerto debe estar entre 1 y 65535',
			'common.gitPanel.worktreeScripts.sourceProject' => 'Guardado como configuración específica del proyecto',
			'common.gitPanel.worktreeScripts.sourceFile' => 'Desde .ddagent/worktree.json — al guardar se crea una configuración específica del proyecto',
			'common.gitPanel.worktreeScripts.sourceNone' => 'Aún no hay nada configurado',
			'common.gitPanel.worktreeScripts.saving' => 'Guardando…',
			'common.gitPanel.worktreeScripts.setupRunning' => 'configuración en curso',
			'common.gitPanel.worktreeScripts.setupFailed' => 'la configuración falló',
			'common.gitPanel.worktreeScripts.running' => 'en ejecución',
			'common.gitPanel.worktreeScripts.openPreview' => 'Abrir vista previa',
			'common.gitPanel.worktreeScripts.runExited' => ({required Object code}) => 'la ejecución terminó (${code})',
			'common.sessions.renameSession' => 'Renombrar sesión',
			'common.projects.newSession' => 'Nueva sesión',
			'common.sharedNotes.subtitle' => 'Memoria compartida — se inyecta en cada sesión de este proyecto',
			'common.sharedNotes.save' => 'Guardar',
			'common.sharedNotes.saving' => 'Guardando…',
			'common.sharedNotes.noProject' => 'Selecciona un espacio de trabajo para editar su contexto compartido',
			'common.sharedNotes.placeholder' => '# Contexto compartido\nConvenciones, decisiones y referencias que todo agente debería conocer…',
			'common.codeBlock.wrapLines' => 'Ajustar líneas',
			'common.codeBlock.noWrap' => 'Sin ajuste',
			'common.update.available' => ({required Object version}) => 'Actualización disponible · v${version}',
			'common.update.confirm' => ({required Object version}) => '¿Actualizar a la v${version}? El servidor se actualiza y se reinicia solo — las sesiones activas se interrumpirán.',
			'common.update.downloading' => 'Descargando y aplicando la actualización…',
			'common.update.restarting' => 'Reiniciando el servidor — esto tarda un momento…',
			'common.update.done' => ({required Object version}) => 'Actualizado a la v${version}. Recarga la app para cargar el nuevo paquete.',
			'common.update.manualRestart' => 'La actualización se aplicó, pero el servidor no se reinició solo — reinícialo manualmente para terminar.',
			'common.update.failed' => 'La actualización falló.',
			'common.update.failedTitle' => 'La actualización falló',
			'common.update.appConfirm' => ({required Object version}) => '¿Instalar DDAgent v${version} en este dispositivo? Android te pedirá permiso para instalar apps desde DDAgent la primera vez.',
			'common.update.appPermission' => 'Permite «Instalar apps desconocidas» para DDAgent y vuelve a pulsar Actualizar.',
			'common.update.chooseTitle' => 'Actualizaciones disponibles',
			'common.update.targetApp' => 'Esta app',
			'common.update.targetWeb' => 'Interfaz web',
			'common.update.targetServer' => 'Servidor',
			'common.update.updateApp' => 'Actualizar app',
			'common.update.updateWeb' => 'Actualizar interfaz web',
			'common.update.updateServer' => 'Actualizar servidor',
			'common.update.webConfirm' => ({required Object version}) => '¿Actualizar la interfaz web a v${version}? La página se recargará después.',
			'common.update.webDone' => ({required Object version}) => 'Interfaz web actualizada a v${version} — recargando…',
			'common.update.localServerConfirm' => ({required Object version}) => '¿Actualizar el servidor local de este dispositivo a v${version}? Las sesiones activas se interrumpirán.',
			'common.update.localServerUpdating' => 'Descargando e iniciando el servidor local…',
			'common.update.serverDone' => ({required Object version}) => 'El servidor ejecuta v${version}.',
			'common.update.staged' => ({required Object version}) => 'Actualización v${version} descargada — reinicia el servidor para instalarla.',
			'common.update.upToDate' => 'El servidor ya tiene la última versión.',
			'common.update.webHostFailed' => ({required Object message}) => 'El servidor se actualizó, pero su interfaz web no: ${message}',
			'common.appShell.panelActive' => ({required Object count}) => 'Panel · ${count} activas',
			'common.errors.forbidden' => 'Acceso denegado',
			'settings.title' => 'Ajustes',
			'settings.changelog.title' => 'Registro de cambios',
			'settings.changelog.loading' => 'Cargando…',
			'settings.changelog.empty' => 'No hay versiones para mostrar',
			'settings.changelog.current' => 'actual',
			'settings.changelog.kNew' => 'nueva',
			'settings.server.title' => 'Servidor',
			'settings.server.description' => 'Reinicia el proceso de DDAgent — útil tras una actualización o si algo se bloquea.',
			'settings.server.restart' => 'Reiniciar',
			'settings.server.restartConfirm' => '¿Reiniciar el servidor DDAgent? Las sesiones activas se interrumpirán.',
			'settings.server.restarting' => 'Reiniciando… la página se recargará cuando el servidor vuelva.',
			'settings.server.restartFailed' => 'El reinicio falló',
			'settings.server.unsupported' => 'El reinicio solo está disponible cuando el servidor se ejecuta bajo el gestor de servicios.',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'Reiniciando el servidor',
			'settings.server.restartRequesting' => 'Pidiendo al servidor que se reinicie…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'Esperando a que el servidor vuelva… (${seconds} s)',
			'settings.server.restartBack' => ({required Object version}) => 'El servidor ha vuelto — versión ${version}.',
			'settings.server.restartReloading' => 'Recargando la página…',
			'settings.server.restartTimeout' => ({required Object seconds}) => 'El servidor no ha vuelto en ${seconds} s. Revisa el registro del servicio (/tmp/ddagent.log) o reinícialo manualmente.',
			'settings.updates.title' => 'Actualizaciones',
			'settings.updates.description' => 'Busca en GitHub una versión de escritorio más reciente. Las nuevas versiones se descargan automáticamente y se instalan al salir.',
			'settings.updates.descriptionMobile' => 'Busca en GitHub una versión más reciente de esta app. Las actualizaciones las instala el instalador del sistema de tu dispositivo.',
			'settings.updates.descriptionServer' => 'Busca en GitHub una versión más reciente de DDAgent. El servidor conectado puede actualizarse solo — las sesiones activas se interrumpen mientras se reinicia.',
			'settings.updates.check' => 'Buscar actualizaciones',
			'settings.updates.checking' => 'Buscando…',
			'settings.updates.upToDate' => ({required Object version}) => 'Tienes la última versión (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Actualización v${version} encontrada — descargando en segundo plano; se instalará al cerrar DDAgent.',
			'settings.updates.appAvailable' => ({required Object version}) => 'Actualización de la app v${version} disponible — toca Actualizar para instalarla en este dispositivo.',
			'settings.updates.downloaded' => ({required Object version}) => 'Actualización v${version} descargada — cierra y reinicia DDAgent para instalarla.',
			'settings.updates.unavailable' => 'La búsqueda de actualizaciones solo está disponible en builds de escritorio empaquetados.',
			'settings.updates.error' => ({required Object message}) => 'Error al buscar actualizaciones: ${message}',
			'settings.updates.errorGeneric' => 'Error al buscar actualizaciones.',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · última v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — actualizada',
			'settings.updates.webNotHosted' => ({required Object version}) => 'Esta interfaz web se aloja por separado: sustituye sus archivos por ddagent-flutter-web-v${version}.zip de la versión.',
			'settings.updates.serverCannotUpdate' => 'Este servidor no puede actualizarse desde aquí: reinstálalo con install.sh o con un tarball de la versión.',
			'settings.tabs.account' => 'Cuenta',
			'settings.tabs.permissions' => 'Permisos',
			'settings.tabs.mcpServers' => 'Servidores MCP',
			'settings.tabs.skills' => 'Skills',
			'settings.tabs.appearance' => 'Apariencia',
			'settings.account.title' => 'Cuenta',
			'settings.account.language' => 'Idioma',
			'settings.account.languageLabel' => 'Idioma de la interfaz',
			'settings.account.languageDescription' => 'Elige tu idioma preferido para la interfaz',
			'settings.account.username' => 'Usuario',
			'settings.account.email' => 'Correo electrónico',
			'settings.account.profile' => 'Perfil',
			'settings.account.changePassword' => 'Cambiar contraseña',
			'settings.mcp.title' => 'Servidores MCP',
			'settings.mcp.addServer' => 'Añadir servidor',
			'settings.mcp.editServer' => 'Editar servidor',
			'settings.mcp.deleteServer' => 'Eliminar servidor',
			'settings.mcp.serverName' => 'Nombre del servidor',
			'settings.mcp.serverType' => 'Tipo de servidor',
			'settings.mcp.config' => 'Configuración',
			'settings.mcp.testConnection' => 'Probar conexión',
			'settings.mcp.status' => 'Estado',
			'settings.mcp.connected' => 'Conectado',
			'settings.mcp.disconnected' => 'Desconectado',
			'settings.mcp.scope.label' => 'Ámbito',
			'settings.mcp.scope.user' => 'Usuario',
			'settings.mcp.scope.project' => 'Proyecto',
			'settings.appearance.title' => 'Apariencia',
			'settings.appearance.theme' => 'Tema',
			'settings.appearance.codeEditor' => 'Editor de código',
			_ => null,
		} ?? switch (path) {
			'settings.appearance.editorTheme' => 'Tema del editor',
			'settings.appearance.wordWrap' => 'Ajuste de línea',
			'settings.appearance.showMinimap' => 'Mostrar minimapa',
			'settings.appearance.lineNumbers' => 'Números de línea',
			'settings.appearance.fontSize' => 'Tamaño de fuente',
			'settings.appearance.themeModes.system' => 'Sistema',
			'settings.appearance.themeModes.light' => 'Claro',
			'settings.appearance.themeModes.dark' => 'Oscuro',
			'settings.actions.saveChanges' => 'Guardar cambios',
			'settings.actions.resetToDefaults' => 'Restablecer valores por defecto',
			'settings.actions.cancelChanges' => 'Cancelar cambios',
			'settings.quickSettings.title' => 'Ajustes rápidos',
			'settings.quickSettings.sections.appearance' => 'Apariencia',
			'settings.quickSettings.sections.toolDisplay' => 'Visualización de herramientas',
			'settings.quickSettings.sections.inputSettings' => 'Ajustes de entrada',
			'settings.quickSettings.darkMode' => 'Modo oscuro',
			'settings.quickSettings.showRawParameters' => 'Mostrar parámetros sin procesar',
			'settings.quickSettings.showThinking' => 'Mostrar razonamiento',
			'settings.quickSettings.sendByCtrlEnter' => 'Enviar con Ctrl+Enter',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Si está activado, Ctrl+Enter envía el mensaje en lugar de solo Enter. Útil para usuarios de IME y evitar envíos accidentales.',
			'settings.quickSettings.dragHandle.dragging' => 'Arrastrando el control',
			'settings.quickSettings.dragHandle.closePanel' => 'Cerrar panel de ajustes',
			'settings.quickSettings.dragHandle.openPanel' => 'Abrir panel de ajustes',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Arrastrando...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Clic para alternar, arrastra para mover',
			'settings.quickSettings.sendWithCtrlEnter' => 'Enviar con Ctrl+Enter',
			'settings.quickSettings.enterSendsHint' => 'Si está desactivado, Enter envía y Shift+Enter inserta un salto de línea.',
			'settings.terminalShortcuts.title' => 'Atajos de terminal',
			'settings.terminalShortcuts.sectionKeys' => 'Teclas',
			'settings.terminalShortcuts.sectionNavigation' => 'Navegación',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Flecha arriba',
			'settings.terminalShortcuts.arrowDown' => 'Flecha abajo',
			'settings.terminalShortcuts.scrollDown' => 'Desplazar hacia abajo',
			'settings.terminalShortcuts.killTitle' => 'Terminar proceso en ejecución (Ctrl+C)',
			'settings.terminalShortcuts.handle.closePanel' => 'Cerrar panel de atajos',
			'settings.terminalShortcuts.handle.openPanel' => 'Abrir panel de atajos',
			'settings.terminalShortcuts.paste' => 'Pegar',
			'settings.mainTabs.label' => 'Ajustes',
			'settings.mainTabs.agents' => 'Agentes',
			'settings.mainTabs.orchestration' => 'Orquestación',
			'settings.mainTabs.miniOrchestration' => 'Miniorquestación',
			'settings.mainTabs.appearance' => 'Apariencia',
			'settings.mainTabs.workspaces' => 'Espacios de trabajo',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API y tokens',
			'settings.mainTabs.models' => 'Modelos',
			'settings.mainTabs.tasks' => 'Tareas',
			'settings.mainTabs.browser' => 'Navegador',
			'settings.mainTabs.tools' => 'Herramientas',
			'settings.mainTabs.notifications' => 'Notificaciones',
			'settings.mainTabs.about' => 'Acerca de',
			'settings.mainTabs.quota' => 'Centro de control',
			'settings.mainTabs.shortcuts' => 'Atajos de teclado',
			'settings.miniOrchestration.title' => 'Miniorquestación',
			'settings.miniOrchestration.description' => 'Un pipeline de dos modelos: un pensador no flash planifica y un ejecutor flash ejecuta.',
			'settings.miniOrchestration.loading' => 'Cargando los ajustes de miniorquestación…',
			'settings.miniOrchestration.loadError' => 'No se pudieron cargar los ajustes de miniorquestación.',
			'settings.miniOrchestration.enable.label' => 'Activar miniorquestación',
			'settings.miniOrchestration.enable.description' => 'Envía las sesiones Auto (mini) a través del motor de dos roles en lugar del orquestador completo.',
			'settings.miniOrchestration.thinker.title' => 'Pensador (no flash)',
			'settings.miniOrchestration.thinker.description' => 'Planifica, decide, revisa y redacta el informe final.',
			'settings.miniOrchestration.worker.title' => 'Ejecutor (flash)',
			'settings.miniOrchestration.worker.description' => 'Ejecuta cada paso planificado.',
			'settings.miniOrchestration.fields.provider' => 'Proveedor',
			'settings.miniOrchestration.fields.model' => 'Modelo',
			'settings.miniOrchestration.fields.modelPlaceholder' => 'Selecciona un modelo',
			'settings.miniOrchestration.fields.tier' => 'Nivel',
			'settings.miniOrchestration.roles.title' => 'Modelo por tarea',
			'settings.miniOrchestration.roles.description' => 'Qué modelo (rol) se encarga de cada tipo de tarea.',
			'settings.miniOrchestration.planner.title' => 'Planificador',
			'settings.miniOrchestration.planner.mode' => 'Modo',
			'settings.miniOrchestration.planner.modes.auto' => 'Planificar con el pensador',
			'settings.miniOrchestration.planner.modes.off' => 'Un solo paso',
			'settings.miniOrchestration.planner.requireConfirmLabel' => 'Confirmar el plan antes de ejecutarlo',
			'settings.orchestration.title' => 'Orchestration',
			'settings.orchestration.description' => 'Reparte las tareas del chat entre tus proveedores y modelos.',
			'settings.orchestration.loading' => 'Cargando los ajustes de orquestación…',
			'settings.orchestration.loadError' => 'No se pudieron cargar los ajustes de orquestación.',
			'settings.orchestration.retry' => 'Retry',
			'settings.orchestration.enable.label' => 'Activar orquestación',
			'settings.orchestration.enable.description' => 'Deja que el orquestador elija un modelo por paso en lugar de ejecutarlo todo en un único proveedor.',
			'settings.orchestration.pool.title' => 'Grupo de candidatos',
			'settings.orchestration.pool.description' => 'Modelos entre los que puede elegir el enrutador, cada uno asignado a un nivel de coste.',
			'settings.orchestration.pool.add' => 'Añadir candidato',
			'settings.orchestration.pool.empty' => 'Aún no hay candidatos — añade uno para empezar a enrutar.',
			'settings.orchestration.pool.fields.label' => 'Label',
			'settings.orchestration.pool.fields.labelPlaceholder' => 'p. ej. SWE-2 Medium',
			'settings.orchestration.pool.fields.provider' => 'Provider',
			'settings.orchestration.pool.fields.model' => 'Model',
			'settings.orchestration.pool.fields.modelPlaceholder' => 'Selecciona un modelo',
			'settings.orchestration.pool.fields.effort' => 'Effort',
			'settings.orchestration.pool.fields.effortDefault' => 'Predeterminado del proveedor',
			'settings.orchestration.pool.fields.effortPlaceholder' => 'default',
			'settings.orchestration.pool.fields.account' => 'Account',
			'settings.orchestration.pool.fields.accountDefault' => 'Predeterminada del proveedor',
			'settings.orchestration.pool.fields.redundantAccounts' => 'Cuentas redundantes',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'No hay otras cuentas para este proveedor',
			'settings.orchestration.pool.fields.tier' => 'Cost tier',
			'settings.orchestration.pool.fields.remove' => 'Eliminar candidato',
			'settings.orchestration.pool.fields.moveUp' => 'Move up',
			'settings.orchestration.pool.fields.moveDown' => 'Move down',
			'settings.orchestration.tiers.free' => 'Free',
			'settings.orchestration.tiers.cheap' => 'Cheap',
			'settings.orchestration.tiers.mid' => 'Mid',
			'settings.orchestration.tiers.premium' => 'Premium',
			'settings.orchestration.rules.title' => 'Reglas de enrutamiento',
			'settings.orchestration.rules.description' => 'Candidatos ordenados por tipo de tarea — gana el primero disponible.',
			'settings.orchestration.rules.addCandidate' => 'Añadir candidato…',
			'settings.orchestration.rules.empty' => 'Sin candidatos — no hay adónde enrutar este tipo de tarea.',
			'settings.orchestration.rules.missing' => '(removed)',
			'settings.orchestration.rules.remove' => 'Eliminar candidato',
			'settings.orchestration.rules.taskTypes.plan' => 'Planning',
			'settings.orchestration.rules.taskTypes.quick' => 'Respuestas rápidas',
			'settings.orchestration.rules.taskTypes.research' => 'Research',
			'settings.orchestration.rules.taskTypes.docs' => 'Documentation',
			'settings.orchestration.rules.taskTypes.code' => 'Coding',
			'settings.orchestration.rules.taskTypes.codeHard' => 'Programación compleja',
			'settings.orchestration.rules.taskTypes.test' => 'Testing',
			'settings.orchestration.rules.taskTypes.review' => 'Review',
			'settings.orchestration.rules.taskTypes.report' => 'Informe',
			'settings.orchestration.planner.title' => 'Planner',
			'settings.orchestration.planner.description' => 'Cómo se divide una solicitud en pasos enrutados.',
			'settings.orchestration.planner.modeLabel' => 'Modo de planificación',
			'settings.orchestration.planner.modes.auto' => 'Auto (LLM)',
			'settings.orchestration.planner.modes.template' => 'Templates',
			'settings.orchestration.planner.modes.off' => 'Off',
			'settings.orchestration.planner.modeHints.auto' => 'El modelo planificador descompone cada solicitud en pasos tipificados.',
			'settings.orchestration.planner.modeHints.template' => 'Las solicitudes pasan por un pipeline fijo que eliges abajo.',
			'settings.orchestration.planner.modeHints.off' => 'Sin planificación — toda la solicitud se enruta como un único paso.',
			'settings.orchestration.planner.candidateLabel' => 'Modelo planificador',
			'settings.orchestration.planner.candidateDescription' => 'Candidato del grupo usado para generar planes y para las llamadas de clasificación.',
			'settings.orchestration.planner.candidatePlaceholder' => 'Selecciona un candidato del grupo',
			'settings.orchestration.planner.templates.title' => 'Plantillas de pipeline',
			'settings.orchestration.planner.templates.add' => 'Add template',
			'settings.orchestration.planner.templates.namePlaceholder' => 'Nombre de la plantilla',
			'settings.orchestration.planner.templates.addStep' => 'Add step…',
			'settings.orchestration.planner.templates.remove' => 'Eliminar plantilla',
			'settings.orchestration.planner.templates.removeStep' => 'Remove step',
			'settings.orchestration.planner.templates.empty' => 'Aún no hay plantillas.',
			'settings.orchestration.planner.templates.emptySteps' => 'Aún no hay pasos — añade uno abajo.',
			'settings.orchestration.planner.requireConfirm' => 'Confirmar el plan antes de ejecutarlo',
			'settings.orchestration.planner.requireConfirmDescription' => 'Pausar tras planificar para que puedas editar o desactivar pasos en la tarjeta del plan.',
			'settings.orchestration.planner.checkpointLabel' => 'Autonomía',
			'settings.orchestration.planner.checkpointModes.off' => 'Autónomo',
			'settings.orchestration.planner.checkpointModes.perStep' => 'Por paso',
			'settings.orchestration.planner.checkpointModes.everyN' => 'Cada N',
			'settings.orchestration.planner.checkpointHints.off' => 'Las decisiones del supervisor se ejecutan sin preguntar (modo automático).',
			'settings.orchestration.planner.checkpointHints.perStep' => 'Pedir aprobación antes de cada lote de pasos propuesto.',
			'settings.orchestration.planner.checkpointHints.everyN' => 'Pedir aprobación cada N pasos completados.',
			'settings.orchestration.planner.checkpointIntervalLabel' => 'Pasos entre puntos de control (1–50)',
			'settings.orchestration.execution.title' => 'Límites de ejecución',
			'settings.orchestration.execution.description' => 'Salvaguardas para ejecuciones en paralelo y bucles de corrección.',
			'settings.orchestration.execution.maxParallel' => 'Máx. pasos en paralelo',
			'settings.orchestration.execution.maxParallelDescription' => 'Cuántas subtareas pueden ejecutarse a la vez (1–8).',
			'settings.orchestration.execution.maxFixLoops' => 'Máx. bucles de corrección',
			'settings.orchestration.execution.maxFixLoopsDescription' => 'Reintentos cuando un paso no supera la verificación (0–5).',
			'settings.orchestration.execution.onNoCandidate' => 'Cuando no hay ningún candidato disponible',
			'settings.orchestration.execution.onNoCandidateDescription' => 'Preguntar antes de recurrir a una alternativa u omitir el paso.',
			'settings.orchestration.execution.onNoCandidateOptions.ask' => 'Ask',
			'settings.orchestration.execution.onNoCandidateOptions.skip' => 'Skip step',
			'settings.orchestration.execution.useWorktree' => 'Worktree aislado',
			'settings.orchestration.execution.useWorktreeDescription' => 'Ejecuta todos los pasos delegados en un único worktree de git compartido en lugar del directorio del proyecto.',
			'settings.orchestration.execution.maxSupervisorIterations' => 'Máx. iteraciones del supervisor',
			'settings.orchestration.execution.maxSupervisorIterationsDescription' => 'Límite de rondas de decisión del supervisor en modo automático (1–100); al alcanzarlo, la ejecución termina con un informe parcial.',
			'settings.orchestration.execution.maxAttempts' => 'Máx. intentos por paso',
			'settings.orchestration.execution.maxAttemptsDescription' => 'Presupuesto total de intentos para un paso entre carriles y reintentos (1–50).',
			'settings.orchestration.execution.stepTimeoutMs' => 'Tiempo límite por paso (ms)',
			'settings.orchestration.execution.stepTimeoutMsDescription' => 'Tiempo límite por intento de la ejecución secundaria en milisegundos; 0 lo desactiva.',
			'settings.orchestration.execution.runTimeoutMs' => 'Tiempo límite de ejecución (ms)',
			'settings.orchestration.execution.runTimeoutMsDescription' => 'Tiempo límite global de ejecución del plan en milisegundos; 0 lo desactiva.',
			'settings.orchestration.execution.retryBackoffBaseMs' => 'Base del backoff de reintentos (ms)',
			'settings.orchestration.execution.retryBackoffBaseMsDescription' => 'Base del backoff exponencial entre reintentos en el mismo carril (jitter completo).',
			'settings.orchestration.execution.retryBudgetTitle' => 'Presupuesto de reintentos por tipo de fallo',
			'settings.orchestration.execution.retryBudgetDescription' => 'Reintentos en el mismo carril antes de conmutar o enfriar (0–5).',
			'settings.orchestration.execution.retryClasses.rateLimit' => 'Límite de tasa',
			'settings.orchestration.execution.retryClasses.quota' => 'Cuota',
			'settings.orchestration.execution.retryClasses.auth' => 'Autenticación',
			'settings.orchestration.execution.retryClasses.timeout' => 'Tiempo agotado',
			'settings.orchestration.execution.retryClasses.transient' => 'Transitorio',
			'settings.orchestration.save.unsaved' => 'Cambios sin guardar',
			'settings.orchestration.save.save' => 'Save',
			'settings.orchestration.save.saving' => 'Saving…',
			'settings.orchestration.save.saved' => 'Saved',
			'settings.orchestration.save.discard' => 'Discard',
			'settings.orchestration.save.error' => 'Save failed',
			'settings.orchestration.save.emptyPool' => 'Añade al menos un candidato antes de guardar.',
			'settings.notifications.title' => 'Notificaciones',
			'settings.notifications.description' => 'Controla qué eventos de notificación recibes.',
			'settings.notifications.webPush.title' => 'Notificar en este navegador',
			'settings.notifications.webPush.enable' => 'Activar notificaciones',
			'settings.notifications.webPush.disable' => 'Desactivar notificaciones',
			'settings.notifications.webPush.enabled' => 'Las notificaciones están activadas en este navegador',
			'settings.notifications.webPush.loading' => 'Actualizando...',
			'settings.notifications.webPush.unsupported' => 'Las notificaciones push no son compatibles con este navegador.',
			'settings.notifications.webPush.denied' => 'Las notificaciones push están bloqueadas. Permítelas en los ajustes de tu navegador.',
			'settings.notifications.webPush.iosHint' => 'En iPhone/iPad, las notificaciones solo funcionan tras añadir DDAgent a la pantalla de inicio (Compartir → Añadir a pantalla de inicio) y activarlas desde la app instalada.',
			'settings.notifications.webPush.test' => 'Enviar notificación de prueba',
			'settings.notifications.webPush.testNoSubscription' => 'Ningún dispositivo está suscrito. Toca «Activar» en el teléfono primero.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Enviado a ${count} dispositivo(s). Si no aparece nada en el teléfono, añade DDAgent a la pantalla de inicio (iOS lo requiere).',
			'settings.notifications.webPush.testNotDelivered' => 'Ningún dispositivo estaba disponible. Asegúrate de que la app esté en ejecución y las notificaciones activadas.',
			'settings.notifications.device.title' => 'Notificar a este dispositivo',
			'settings.notifications.device.enabled' => 'Las notificaciones están activadas para este dispositivo',
			'settings.notifications.desktop.title' => 'Notificar en esta app de escritorio',
			'settings.notifications.desktop.enable' => 'Activar notificaciones',
			'settings.notifications.desktop.disable' => 'Desactivar notificaciones',
			'settings.notifications.desktop.enabled' => 'Las notificaciones están activadas en esta app de escritorio',
			'settings.notifications.desktop.unsupported' => 'Las notificaciones de escritorio no son compatibles con este sistema.',
			'settings.notifications.sound.title' => 'Sonido',
			'settings.notifications.sound.description' => 'Reproduce un tono corto cuando una ejecución del chat termina o necesita aprobación de una herramienta.',
			'settings.notifications.sound.enabled' => 'Activado',
			'settings.notifications.sound.test' => 'Probar sonido',
			'settings.notifications.events.title' => 'Tipos de evento',
			'settings.notifications.events.actionRequired' => 'Acción requerida',
			'settings.notifications.events.stop' => 'Ejecución detenida',
			'settings.notifications.events.error' => 'Ejecución fallida',
			'settings.notifications.messaging.title' => 'Aprobaciones por mensajería',
			'settings.notifications.messaging.description' => 'Aprueba o deniega las solicitudes de permisos de los agentes desde Telegram y recibe notificaciones de ejecución en Discord.',
			'settings.notifications.messaging.enabled' => 'Activado',
			'settings.notifications.messaging.save' => 'Guardar',
			'settings.notifications.messaging.test' => 'Probar',
			'settings.notifications.messaging.pair' => 'Vincular',
			'settings.notifications.messaging.telegramToken' => 'Token del bot de @BotFather (123456:ABC…)',
			'settings.notifications.messaging.telegramHint' => 'Envía cualquier mensaje a tu bot y luego vincula el chat abajo.',
			'settings.notifications.messaging.discordWebhook' => 'https://discord.com/api/webhooks/…',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.unpair' => 'Desvincular',
			'settings.appearanceSettings.darkMode.label' => 'Modo oscuro',
			'settings.appearanceSettings.darkMode.description' => 'Alterna entre el tema claro y el oscuro',
			'settings.appearanceSettings.codeEditor.title' => 'Editor de código',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Tema del editor',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Tema por defecto del editor de código',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Ajuste de línea',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Activa el ajuste de línea por defecto en el editor',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Mostrar minimapa',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Muestra un minimapa para navegar más fácil en la vista de diff',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Mostrar números de línea',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Muestra los números de línea en el editor',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Tamaño de fuente',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Tamaño de fuente del editor en píxeles',
			'settings.appearanceSettings.terminal.title' => 'Terminal',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'El foco sigue al puntero',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Enfocar el terminal para escribir al mover el ratón sobre él',
			'settings.mcpForm.title.add' => 'Añadir servidor MCP',
			'settings.mcpForm.title.edit' => 'Editar servidor MCP',
			'settings.mcpForm.importMode.form' => 'Formulario',
			'settings.mcpForm.importMode.json' => 'Importar JSON',
			'settings.mcpForm.scope.label' => 'Ámbito',
			'settings.mcpForm.scope.userGlobal' => 'Usuario (global)',
			'settings.mcpForm.scope.projectLocal' => 'Proyecto (local)',
			'settings.mcpForm.scope.userDescription' => 'Ámbito de usuario: disponible en todos los proyectos de tu máquina',
			'settings.mcpForm.scope.projectDescription' => 'Ámbito local: solo disponible en el proyecto seleccionado',
			'settings.mcpForm.scope.cannotChange' => 'El ámbito no se puede cambiar al editar un servidor existente',
			'settings.mcpForm.fields.serverName' => 'Nombre del servidor',
			'settings.mcpForm.fields.transportType' => 'Tipo de transporte',
			'settings.mcpForm.fields.command' => 'Comando',
			'settings.mcpForm.fields.arguments' => 'Argumentos (uno por línea)',
			'settings.mcpForm.fields.jsonConfig' => 'Configuración JSON',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Variables de entorno (CLAVE=valor, una por línea)',
			'settings.mcpForm.fields.headers' => 'Cabeceras (CLAVE=valor, una por línea)',
			'settings.mcpForm.fields.selectProject' => 'Selecciona un proyecto...',
			'settings.mcpForm.placeholders.serverName' => 'mi-servidor',
			'settings.mcpForm.validation.missingType' => 'Falta el campo obligatorio: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'El tipo stdio requiere un campo command',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => 'El tipo ${type} requiere un campo url',
			'settings.mcpForm.validation.invalidJson' => 'Formato JSON no válido',
			'settings.mcpForm.validation.jsonHelp' => 'Pega la configuración de tu servidor MCP en formato JSON. Formatos de ejemplo:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Detalles de configuración (de ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Ruta: ${path}',
			'settings.mcpForm.actions.cancel' => 'Cancelar',
			'settings.mcpForm.actions.saving' => 'Guardando...',
			'settings.mcpForm.actions.addServer' => 'Añadir servidor',
			'settings.mcpForm.actions.updateServer' => 'Actualizar servidor',
			'settings.saveStatus.success' => '¡Ajustes guardados correctamente!',
			'settings.saveStatus.error' => 'No se pudieron guardar los ajustes',
			'settings.saveStatus.saving' => 'Guardando...',
			'settings.footerActions.save' => 'Guardar ajustes',
			'settings.footerActions.cancel' => 'Cancelar',
			'settings.git.title' => 'Configuración de Git',
			'settings.git.description' => 'Configura tu identidad de git para los commits. Estos ajustes se aplicarán globalmente mediante git config --global',
			'settings.git.name.label' => 'Nombre para Git',
			'settings.git.name.help' => 'Tu nombre para los commits de git',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'Correo para Git',
			'settings.git.email.help' => 'Tu correo para los commits de git',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Guardar configuración',
			'settings.git.actions.saving' => 'Guardando...',
			'settings.git.status.success' => 'Guardado correctamente',
			'settings.git.status.error' => 'Error al guardar',
			'settings.apiKeys.title' => 'Claves API',
			'settings.apiKeys.description' => 'Genera claves API para acceder a la API externa desde otras aplicaciones.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ Guarda tu clave API',
			'settings.apiKeys.newKey.alertMessage' => 'Esta es la única vez que verás esta clave. Guárdala en un lugar seguro.',
			'settings.apiKeys.newKey.iveSavedIt' => 'Ya la guardé',
			'settings.apiKeys.form.placeholder' => 'Nombre de la clave API (p. ej., Servidor de producción)',
			'settings.apiKeys.form.createButton' => 'Crear',
			'settings.apiKeys.form.cancelButton' => 'Cancelar',
			'settings.apiKeys.newButton' => 'Nueva clave API',
			'settings.apiKeys.empty' => 'Aún no se han creado claves API.',
			'settings.apiKeys.list.created' => 'Creada:',
			'settings.apiKeys.list.lastUsed' => 'Último uso:',
			'settings.apiKeys.confirmDelete' => '¿Seguro que quieres eliminar esta clave API?',
			'settings.apiKeys.status.active' => 'Activa',
			'settings.apiKeys.status.inactive' => 'Inactiva',
			'settings.apiKeys.github.title' => 'Tokens de GitHub',
			'settings.apiKeys.github.description' => 'Añade tokens de acceso personal de GitHub para clonar repositorios privados mediante la API externa.',
			'settings.apiKeys.github.descriptionAlt' => 'Añade tokens de acceso personal de GitHub para clonar repositorios privados. También puedes pasar tokens directamente en las solicitudes de API sin guardarlos.',
			'settings.apiKeys.github.addButton' => 'Añadir token',
			'settings.apiKeys.github.form.namePlaceholder' => 'Nombre del token (p. ej., Repos personales)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'Token de acceso personal de GitHub (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Descripción (opcional)',
			'settings.apiKeys.github.form.addButton' => 'Añadir token',
			'settings.apiKeys.github.form.cancelButton' => 'Cancelar',
			'settings.apiKeys.github.form.howToCreate' => 'Cómo crear un token de acceso personal de GitHub →',
			'settings.apiKeys.github.form.showToken' => 'Mostrar token',
			'settings.apiKeys.github.form.hideToken' => 'Ocultar token',
			'settings.apiKeys.github.empty' => 'Aún no se han añadido tokens de GitHub.',
			'settings.apiKeys.github.added' => 'Añadido:',
			'settings.apiKeys.github.confirmDelete' => '¿Seguro que quieres eliminar este token de GitHub?',
			'settings.apiKeys.apiDocsLink' => 'Documentación de la API',
			'settings.apiKeys.documentation.title' => 'Documentación de la API externa',
			'settings.apiKeys.documentation.description' => 'Aprende a usar la API externa para lanzar sesiones de Claude/Cursor desde tus aplicaciones.',
			'settings.apiKeys.documentation.viewLink' => 'Ver documentación de la API →',
			'settings.apiKeys.loading' => 'Cargando...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Actualización disponible: v${version}',
			'settings.tasks.checking' => 'Comprobando la instalación de TaskMaster...',
			'settings.tasks.notInstalled.title' => 'La CLI de TaskMaster AI no está instalada',
			'settings.tasks.notInstalled.description' => 'La CLI de TaskMaster es necesaria para usar las funciones de gestión de tareas. Instálala para empezar:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'Ver en GitHub',
			'settings.tasks.notInstalled.afterInstallation' => 'Después de la instalación:',
			'settings.tasks.notInstalled.steps.restart' => 'Reinicia esta aplicación',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'Las funciones de TaskMaster estarán disponibles automáticamente',
			'settings.tasks.notInstalled.steps.initCommand' => 'Usa task-master init en el directorio de tu proyecto',
			'settings.tasks.settings.enableLabel' => 'Activar integración con TaskMaster',
			'settings.tasks.settings.enableDescription' => 'Muestra tareas, banners e indicadores de TaskMaster en la barra lateral y el resto de la interfaz',
			'settings.agents.authStatus.checking' => 'Comprobando...',
			'settings.agents.authStatus.connected' => 'Conectado',
			'settings.agents.authStatus.notConnected' => 'No conectado',
			'settings.agents.authStatus.disconnected' => 'Desconectado',
			'settings.agents.authStatus.checkingAuth' => 'Comprobando el estado de autenticación...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Sesión iniciada como ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => 'Cuenta de ${provider}',
			'settings.agents.authStatus.authenticatedUser' => 'usuario autenticado',
			'settings.agents.install.title' => ({required Object agent}) => 'La CLI de ${agent} no está instalada',
			'settings.agents.install.description' => ({required Object agent}) => 'Instala la CLI de ${agent} para iniciar sesión y ejecutar sesiones.',
			'settings.agents.install.button' => 'Instalar',
			'settings.agents.install.installing' => 'Instalando…',
			'settings.agents.install.copyCommand' => 'Copiar comando',
			'settings.agents.install.docs' => 'Documentación',
			'settings.agents.install.success' => ({required Object agent}) => 'CLI de ${agent} instalada',
			'settings.agents.install.failed' => 'La instalación falló — revisa la salida de la terminal',
			'settings.agents.update.title' => 'Actualizar CLI',
			'settings.agents.update.description' => ({required Object agent}) => 'Instala la versión más reciente del CLI de ${agent} en el host del servidor.',
			'settings.agents.update.button' => 'Actualizar',
			'settings.agents.update.updating' => 'Actualizando…',
			'settings.agents.update.success' => ({required Object agent}) => 'CLI de ${agent} actualizado',
			'settings.agents.update.failed' => 'La actualización falló — revisa la salida del terminal',
			'settings.agents.account.claude.description' => 'Asistente de IA Claude de Anthropic',
			'settings.agents.account.cursor.description' => 'Editor de código con IA Cursor',
			'settings.agents.account.codex.description' => 'Asistente de IA Codex de OpenAI',
			'settings.agents.account.opencode.description' => 'Asistente CLI OpenCode',
			'settings.agents.account.commandcode.description' => 'Asistente CLI Command Code',
			'settings.agents.account.antigravity.description' => 'Asistente CLI Antigravity',
			'settings.agents.account.devin.description' => 'Asistente CLI Devin',
			'settings.agents.connectionStatus' => 'Estado de la conexión',
			'settings.agents.login.title' => 'Iniciar sesión',
			'settings.agents.login.reAuthenticate' => 'Volver a autenticar',
			'settings.agents.login.description' => ({required Object agent}) => 'Inicia sesión en tu cuenta de ${agent} para activar las funciones de IA',
			'settings.agents.login.reAuthDescription' => 'Inicia sesión con otra cuenta o actualiza las credenciales',
			'settings.agents.login.button' => 'Iniciar sesión',
			'settings.agents.login.reLoginButton' => 'Volver a iniciar sesión',
			'settings.agents.logout.title' => 'Cerrar sesión',
			'settings.agents.logout.description' => 'Cierra la sesión de este proveedor y borra sus credenciales guardadas',
			'settings.agents.logout.button' => 'Cerrar sesión',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => '¿Cerrar sesión de ${agent}?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Esto elimina las credenciales guardadas de ${agent} en el servidor. Vuelve a iniciar sesión para seguir usando ${agent}.',
			'settings.agents.logout.success' => 'Sesión cerrada',
			'settings.agents.logout.failed' => 'No se pudo cerrar la sesión',
			'settings.agents.error' => ({required Object error}) => 'Error: ${error}',
			'settings.agents.accounts.title' => 'Cuentas con nombre',
			'settings.agents.accounts.description' => 'Conjuntos de credenciales adicionales. Una sesión asociada a una cuenta inicia la CLI con su directorio de configuración aislado. Inicia sesión ejecutando una vez la CLI del proveedor con las variables de entorno mostradas.',
			'settings.agents.accounts.sharedCli' => 'Todas las cuentas comparten una instalación de la CLI — actualízala en la tarjeta de conexión de arriba.',
			'settings.agents.accounts.loading' => 'Cargando cuentas…',
			'settings.agents.accounts.kDefault' => 'Predeterminada',
			'settings.agents.accounts.usage' => ({required Object tokens}) => '${tokens} tokens',
			'settings.agents.accounts.usageButton' => 'Uso',
			'settings.agents.accounts.showUsage' => 'Mostrar uso de tokens',
			'settings.agents.accounts.makeDefault' => 'Establecer como predeterminada',
			'settings.agents.accounts.remove' => 'Eliminar cuenta',
			'settings.agents.accounts.newLabel' => 'Nombre de la cuenta (p. ej. Trabajo)',
			'settings.agents.accounts.add' => 'Añadir cuenta',
			'settings.agents.accounts.autoSwitch.label' => 'Cambiar de cuenta automáticamente al alcanzar el límite',
			'settings.agents.accounts.autoSwitch.description' => 'Cuando una cuenta alcanza su límite de uso, la sesión pasa a otra cuenta del mismo agente que aún tenga cuota, incluso si elegiste manualmente la agotada. Nunca cambia a otro agente. Claude y Codex conservan la conversación; los demás agentes solo cambian en chats nuevos.',
			'settings.permissions.title' => 'Ajustes de permisos',
			'settings.permissions.permissionMode.title' => 'Modo de permisos',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Modo de permiso predeterminado para nuevas sesiones de ${provider}. Aún puedes anularlo para una sesión individual.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Por defecto',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Las acciones que necesitan permiso se te muestran para aprobación en el chat.',
			'settings.permissions.permissionMode.modes.auto.title' => 'Modo automático',
			'settings.permissions.permissionMode.modes.auto.description' => 'Un clasificador del modelo decide en cada llamada si aprobar o denegar. Sin intervención, pero más seguro que Omitir — las denegaciones siguen ocurriendo.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Aceptar ediciones',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Las ediciones de archivos se aprueban automáticamente; otras acciones siguen pidiendo tu aprobación.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Omitir permisos',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Cada acción se aprueba automáticamente — acceso total sin avisos. Úsalo con precaución.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Modo planificación: el agente explora y planifica sin ejecutar comandos.',
			'settings.mcpServers.title' => 'Servidores MCP',
			'settings.mcpServers.description.claude' => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Claude',
			'settings.mcpServers.description.cursor' => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Cursor',
			'settings.mcpServers.description.codex' => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Codex',
			'settings.mcpServers.description.opencode' => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a OpenCode',
			'settings.mcpServers.description.commandcode' => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Command Code',
			'settings.mcpServers.description.antigravity' => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Antigravity',
			'settings.mcpServers.description.devin' => 'Los servidores Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a Devin',
			'settings.mcpServers.addButton' => 'Añadir servidor MCP',
			'settings.mcpServers.empty' => 'No hay servidores MCP configurados',
			'settings.mcpServers.serverType' => 'Tipo',
			'settings.mcpServers.scope.local' => 'local',
			'settings.mcpServers.scope.user' => 'usuario',
			'settings.mcpServers.config.command' => 'Comando',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Argumentos',
			'settings.mcpServers.config.environment' => 'Entorno',
			'settings.mcpServers.tools.title' => 'Herramientas',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} más',
			'settings.mcpServers.actions.edit' => 'Editar servidor',
			'settings.mcpServers.actions.delete' => 'Eliminar servidor',
			'settings.mcpServers.managed.badge' => 'Gestionado',
			'settings.mcpServers.managed.hint' => 'Gestionado por DDAgent.',
			'settings.mcpServers.help.title' => 'Acerca de MCP en Codex',
			'settings.mcpServers.help.description' => 'Codex admite servidores MCP basados en stdio. Puedes añadir servidores que amplíen las capacidades de Codex con herramientas y recursos adicionales.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '«${serverName}» se eliminará de la configuración del proveedor.',
			'settings.mcpServers.deleteConfirm.title' => '¿Eliminar el servidor MCP?',
			'settings.quota.settings.tab' => 'Centro de control',
			'settings.quota.settings.title' => 'Centro de control',
			'settings.quota.settings.description' => 'Umbrales de alerta, política de enrutamiento y cuentas consultadas para cuotas.',
			'settings.quota.settings.saved' => 'Guardado',
			'settings.quota.settings.alertsSection' => 'Alertas',
			'settings.quota.settings.alertsSectionHint' => 'Avisar antes de que un límite se agote de verdad, no solo al 100%.',
			'settings.quota.settings.alertsEnabled' => 'Alertas de límite previsto',
			'settings.quota.settings.alertsEnabledHint' => 'Mostrar proyecciones basadas en el ritmo en el resumen y las tarjetas de cuenta.',
			'settings.quota.settings.watchThreshold' => 'Umbral de observación (%)',
			'settings.quota.settings.watchThresholdHint' => 'Las cuentas en o por encima de esta lectura cuentan como en riesgo.',
			'settings.quota.settings.dangerThreshold' => 'Umbral de peligro (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Las lecturas en o por encima de este valor se muestran en rojo.',
			'settings.quota.settings.routingSection' => 'Enrutamiento',
			'settings.quota.settings.routingSectionHint' => 'Cómo puede el panel mover trabajo a la cuenta con más margen.',
			'settings.quota.settings.routing.manual' => 'Manual',
			'settings.quota.settings.routing.manualHint' => 'Mostrar solo una recomendación; nunca cambiar de cuenta automáticamente.',
			'settings.quota.settings.routing.ask' => 'Preguntar antes de cambiar',
			'settings.quota.settings.routing.askHint' => 'Se propone un cambio y espera tu aprobación.',
			'settings.quota.settings.routing.autoLowRisk' => 'Automático para tareas de bajo riesgo',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Solo las tareas marcadas como de bajo riesgo pueden moverse automáticamente.',
			'settings.quota.settings.routingNote' => 'Cambiar de cuenta altera el costo y la calidad del modelo, por lo que siempre requiere una decisión explícita.',
			'settings.quota.settings.accountsSection' => 'Cuentas consultadas',
			'settings.quota.settings.accountsSectionHint' => 'Las credenciales se leen de cada herramienta; el panel nunca las envía a otro lugar.',
			'settings.quota.settings.sourcesSection' => 'Fuentes de datos',
			'settings.quota.settings.sourcesSectionHint' => 'De dónde provienen las cifras de uso y costo.',
			'settings.quota.settings.logSources' => 'Almacén de registros de tokens y costos',
			'settings.quota.settings.logSourcesHint' => 'Almacén de agregados de solo lectura compartido con el colector tokboard.',
			'settings.quota.settings.readOnly' => 'Solo lectura',
			'settings.quota.settings.quotaConsent' => 'Consulta de cuotas',
			'settings.quota.settings.quotaConsentHint' => 'Lee los endpoints de cuota de los proveedores con credenciales guardadas localmente.',
			'settings.quota.settings.localOnly' => 'Solo local',
			'settings.quota.empty.description' => 'Aún no se detectaron cuentas.',
			'settings.quota.quality.cached' => 'en caché',
			'settings.quota.quality.error' => 'error',
			'settings.quota.quality.estimate' => 'estimación',
			'settings.quota.quality.live' => 'en vivo',
			'settings.quota.quality.unknown' => 'desconocido',
			'settings.quota.syncFailed' => 'Falló la sincronización',
			'settings.quota.syncNow' => 'Sincronizar ahora',
			'settings.browser.checking' => 'comprobando...',
			'settings.browser.description' => 'Permite a los agentes crear sesiones de navegador Playwright supervisadas que puedes monitorizar en la pestaña Browser.',
			'settings.browser.enableDescription' => 'Registra Browser para los agentes compatibles. Los agentes pueden crear sesiones de navegador; puedes verlas, detenerlas y eliminarlas.',
			'settings.browser.enableLabel' => 'Activar Browser',
			'settings.browser.errors.installRuntime' => 'No se pudo instalar el runtime del navegador',
			'settings.browser.errors.loadSettings' => 'No se pudieron cargar los ajustes de Browser',
			'settings.browser.errors.loadStatus' => 'No se pudo cargar el estado de Browser',
			'settings.browser.errors.saveSettings' => 'No se pudieron guardar los ajustes de Browser',
			'settings.browser.installHint' => 'Instala el runtime del navegador antes de que los agentes puedan crear sesiones de Browser.',
			'settings.browser.installRuntime' => 'Instalar runtime',
			'settings.browser.installed' => 'instalado',
			'settings.browser.installing' => 'Instalando...',
			'settings.browser.missing' => 'faltante',
			'settings.browser.runtimeRequired' => 'Se requiere el runtime del navegador',
			'settings.browser.statusDisabled' => 'desactivado',
			'settings.browser.statusLabel' => 'Estado',
			'settings.browser.statusReady' => 'listo',
			'settings.browser.statusSetupRequired' => 'configuración requerida',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Cancelar',
			'settings.workspaces.create' => 'Añadir espacio de trabajo',
			'settings.workspaces.deleteConfirm' => '¿Quitar este espacio de trabajo de DDAgent? Sus archivos permanecen en el disco.',
			'settings.workspaces.deleteFailed' => 'No se pudo quitar el espacio de trabajo.',
			'settings.workspaces.deleteTitle' => 'Quitar espacio de trabajo',
			'settings.workspaces.description' => 'Los espacios de trabajo son directorios donde DDAgent puede chatear, ejecutar código y navegar.',
			'settings.workspaces.remove' => 'Quitar espacio de trabajo',
			'settings.workspaces.title' => 'Espacios de trabajo',
			'settings.workspaces.pathRequired' => 'La ruta es obligatoria',
			'settings.stt.title' => 'Entrada de voz (voz a texto)',
			'settings.stt.description' => 'Endpoint /audio/transcriptions compatible con Whisper (OpenAI, whisper.cpp, faster-whisper, Speaches). Activa el botón de micrófono en el editor.',
			'settings.stt.configured' => 'configurado',
			_ => null,
		} ?? switch (path) {
			'settings.stt.endpoint' => 'URL del endpoint (p. ej. https://api.openai.com/v1)',
			'settings.stt.apiKey' => 'Clave de API',
			'settings.stt.model' => 'Modelo (predeterminado: whisper-1)',
			'settings.stt.save' => 'Guardar',
			'settings.schedules.title' => 'Programaciones',
			'settings.schedules.description' => 'Ejecuciones recurrentes de agentes según un calendario cron. Se lanzan sin supervisión y con los permisos omitidos.',
			'settings.schedules.preventSleep' => 'Evitar la suspensión mientras se ejecutan agentes',
			'settings.schedules.preventSleepHint' => 'En escritorio la pantalla se mantiene encendida; en el navegador se usa un bloqueo de activación de pantalla.',
			'settings.schedules.kNew' => 'Nueva programación',
			'settings.schedules.loading' => 'Cargando…',
			'settings.schedules.empty' => 'Aún no hay programaciones.',
			'settings.schedules.project' => 'Proyecto',
			'settings.schedules.provider' => 'Proveedor',
			'settings.schedules.cron' => 'Cron (min hora día mes día de la semana)',
			'settings.schedules.nextRun' => ({required Object time}) => 'Próxima ejecución: ${time}',
			'settings.schedules.cronInvalid' => 'No hay próximas ejecuciones para esta expresión',
			'settings.schedules.prompt' => 'Prompt',
			'settings.schedules.useWorktree' => 'Ejecutar en un worktree nuevo',
			'settings.schedules.catchUp' => 'Recuperar ejecuciones perdidas',
			'settings.schedules.failures' => ({required Object count}) => '${count} fallos',
			'settings.schedules.disabled' => 'desactivada',
			'settings.schedules.history' => 'Historial',
			'settings.schedules.runNow' => 'Ejecutar ahora',
			'settings.schedules.delete' => 'Eliminar',
			'settings.schedules.noRuns' => 'Aún no hay ejecuciones.',
			'settings.schedules.next' => 'próxima',
			'settings.schedules.create' => 'Crear',
			'settings.schedules.toggleSchedule' => 'Activar programación',
			'settings.mcpTokens.title' => 'Tokens del servidor MCP de DDAgent',
			'settings.mcpTokens.description' => 'Las herramientas externas (Claude Desktop, OpenClaw) llaman a las herramientas de DDAgent mediante POST /mcp con uno de estos tokens bearer.',
			'settings.mcpTokens.dismiss' => 'Descartar',
			'settings.mcpTokens.labelPlaceholder' => 'Nombre del token (p. ej. Claude Desktop)',
			'settings.mcpTokens.create' => 'Crear',
			'settings.mcpTokens.empty' => 'Aún no hay tokens MCP.',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => 'usado ${time}',
			'settings.mcpTokens.neverUsed' => 'nunca usado',
			'settings.about.supportTitle' => 'Apoya el proyecto',
			'settings.about.buyMeACoffee' => 'Invítame a un café',
			'settings.about.tryHosted' => 'Prueba DDAgent Hosted',
			'settings.about.learnMore' => 'Más información',
			'settings.about.proFeatures' => 'Funciones de DDAgent Pro',
			'settings.about.pro.syncSettings' => 'Sincronizar ajustes',
			'settings.about.pro.teamManagement' => 'Gestión de equipo',
			'settings.about.pro.syncSettingsDescription' => 'Mantén tus preferencias, configuraciones MCP y tema sincronizados en todos tus entornos.',
			'settings.about.pro.teamManagementDescription' => 'Varios usuarios, acceso basado en roles y proyectos compartidos para tu equipo.',
			'settings.about.versionInfo' => 'Información de versión',
			'settings.about.client' => 'Aplicación',
			'settings.about.server' => 'Servidor',
			'settings.about.platformMobile' => 'Móvil',
			'settings.about.platformDesktop' => 'Escritorio',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'desconocida',
			'settings.about.copyright' => '© 2026 DDAgent — todos los derechos reservados',
			'settings.about.tagline' => 'Interfaz de código abierto para asistentes de programación con IA',
			'settings.about.docs' => 'Documentación',
			'settings.about.hostedDescription' => 'Colaboración en equipo, configuraciones MCP compartidas, sincronización de ajustes entre entornos e infraestructura gestionada.',
			'settings.shortcuts.description' => 'Todos los atajos de teclado de DDAgent, separados por plataforma.',
			'settings.shortcuts.action' => 'Acción',
			'settings.shortcuts.winLinux' => 'Windows / Linux',
			'settings.shortcuts.mac' => 'macOS',
			'settings.shortcuts.navigation' => 'Navegación',
			'settings.shortcuts.navWorkspace' => 'Ir al espacio de trabajo',
			'settings.shortcuts.navTasks' => 'Ir a Tareas / Git',
			'settings.shortcuts.navGit' => 'Ir a Git',
			'settings.shortcuts.navFocus' => 'Alternar modo enfoque (barra lateral)',
			'settings.shortcuts.navSwitcher' => 'Selector rápido de sesiones',
			'settings.shortcuts.navPalette' => 'Paleta de comandos',
			'settings.shortcuts.navSettings' => 'Abrir ajustes',
			'settings.shortcuts.navClose' => 'Cerrar diálogo / restaurar paneles divididos',
			'settings.shortcuts.composer' => 'Editor',
			'settings.shortcuts.compSend' => 'Enviar mensaje',
			'settings.shortcuts.compNewline' => 'Nueva línea',
			'settings.shortcuts.compNav' => 'Navegar por las sugerencias',
			'settings.shortcuts.compAccept' => 'Aceptar sugerencia',
			'settings.shortcuts.compCloseSuggest' => 'Cerrar sugerencias',
			'settings.shortcuts.transcript' => 'Transcripción',
			'settings.shortcuts.trCopy' => 'Copiar texto seleccionado',
			'settings.shortcuts.trClose' => 'Cerrar búsqueda / panel de revisión',
			'settings.shortcuts.terminal' => 'Terminal',
			'settings.shortcuts.termCopy' => 'Copiar selección',
			'settings.shortcuts.termInterrupt' => 'Interrumpir proceso (sin selección)',
			'settings.shortcuts.termPaste' => 'Pegar',
			'settings.shortcuts.termSelectAll' => 'Seleccionar todo',
			'settings.shortcuts.editor' => 'Editor',
			'settings.shortcuts.edSave' => 'Guardar archivo',
			'settings.shortcuts.edSaveAll' => 'Guardar todos los archivos',
			'settings.shortcuts.edClose' => 'Cerrar pestaña',
			'settings.shortcuts.edNextTab' => 'Pestaña siguiente',
			'settings.shortcuts.edPrevTab' => 'Pestaña anterior',
			'settings.shortcuts.edIndent' => 'Aumentar / reducir sangría',
			'settings.shortcuts.palette' => 'Paleta de comandos',
			'settings.shortcuts.palNav' => 'Navegar por los elementos',
			'settings.shortcuts.palRun' => 'Ejecutar / abrir',
			'settings.shortcuts.palBack' => 'Atrás (búsqueda vacía)',
			'settings.shortcuts.palClose' => 'Cerrar',
			'sidebar.projects.title' => 'Proyectos',
			'sidebar.projects.newProject' => 'Nuevo proyecto',
			'sidebar.projects.deleteProject' => 'Quitar proyecto',
			'sidebar.projects.renameProject' => 'Renombrar proyecto',
			'sidebar.projects.noProjects' => 'No se encontraron proyectos',
			'sidebar.projects.loadingProjects' => 'Cargando proyectos...',
			'sidebar.projects.searchPlaceholder' => 'Buscar proyectos...',
			'sidebar.projects.projectNamePlaceholder' => 'Nombre del proyecto',
			'sidebar.projects.starred' => 'Favoritos',
			'sidebar.projects.all' => 'Todos',
			'sidebar.projects.untitledSession' => 'Sesión sin título',
			'sidebar.projects.newSession' => 'Nueva sesión',
			'sidebar.projects.codexSession' => 'Sesión de Codex',
			'sidebar.projects.fetchingProjects' => 'Obteniendo tus proyectos y sesiones de Claude',
			'sidebar.projects.projects' => 'proyectos',
			'sidebar.projects.noMatchingProjects' => 'No hay proyectos que coincidan',
			'sidebar.projects.tryDifferentSearch' => 'Prueba con otro término de búsqueda',
			'sidebar.projects.runClaudeCli' => 'Ejecuta Claude CLI en el directorio de un proyecto para empezar',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'Interfaz de asistente de programación con IA',
			'sidebar.panel.open' => 'Panel',
			'sidebar.panel.newChat' => 'Nuevo chat',
			'sidebar.panel.navigation' => 'Navegación',
			'sidebar.panel.sessions' => 'Sesiones',
			'sidebar.sessions.title' => 'Sesiones',
			'sidebar.sessions.newSession' => 'Nueva sesión',
			'sidebar.sessions.deleteSession' => 'Eliminar sesión',
			'sidebar.sessions.renameSession' => 'Renombrar sesión',
			'sidebar.sessions.noSessions' => 'Aún no hay sesiones',
			'sidebar.sessions.loadingSessions' => 'Cargando sesiones...',
			'sidebar.sessions.unnamed' => 'Sin nombre',
			'sidebar.sessions.loading' => 'Cargando...',
			'sidebar.sessions.showMore' => 'Mostrar más sesiones',
			'sidebar.sessions.selectMode' => 'Seleccionar',
			'sidebar.sessions.selectAll' => 'Seleccionar todo',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Archivar (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Eliminar (${count})',
			'sidebar.sessions.cancelSelection' => 'Cancelar selección',
			'sidebar.sessions.toggleSelection' => 'Alternar selección de sesiones',
			'sidebar.sessions.selectionToolbar' => 'Acciones de selección de sesiones',
			'sidebar.sessions.options' => 'Opciones de sesión',
			'sidebar.sessions.pinSession' => 'Fijar sesión',
			'sidebar.sessions.unpinSession' => 'Desfijar sesión',
			'sidebar.sessions.pinned' => 'Sesión fijada',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} seleccionada', other: '${count} seleccionadas', ), 
			'sidebar.tooltips.viewEnvironments' => 'Ver entornos',
			'sidebar.tooltips.hideSidebar' => 'Ocultar barra lateral',
			'sidebar.tooltips.createProject' => 'Crear proyecto nuevo',
			'sidebar.tooltips.refresh' => 'Actualizar proyectos y sesiones (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Renombrar proyecto (F2)',
			'sidebar.tooltips.deleteProject' => 'Quitar proyecto de la barra lateral (Supr)',
			'sidebar.tooltips.addToFavorites' => 'Añadir a favoritos',
			'sidebar.tooltips.removeFromFavorites' => 'Quitar de favoritos',
			'sidebar.tooltips.editSessionName' => 'Editar manualmente el nombre de la sesión',
			'sidebar.tooltips.deleteSession' => 'Eliminar esta sesión de forma permanente',
			'sidebar.tooltips.activeSessionIndicator' => 'Sesión activa recientemente (últimos 10 minutos)',
			'sidebar.tooltips.save' => 'Guardar',
			'sidebar.tooltips.cancel' => 'Cancelar',
			'sidebar.tooltips.clearSearch' => 'Limpiar búsqueda',
			'sidebar.tooltips.openCommandPalette' => 'Abrir paleta de comandos',
			'sidebar.tooltips.attentionRequiredIndicator' => 'La sesión requiere atención',
			'sidebar.tooltips.openSessions' => 'Explorar sesiones',
			'sidebar.navigation.chat' => 'Chat',
			'sidebar.navigation.files' => 'Archivos',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminal',
			'sidebar.navigation.tasks' => 'Tareas',
			'sidebar.actions.refresh' => 'Actualizar',
			'sidebar.actions.settings' => 'Ajustes',
			'sidebar.actions.collapseAll' => 'Contraer todo',
			'sidebar.actions.expandAll' => 'Expandir todo',
			'sidebar.actions.cancel' => 'Cancelar',
			'sidebar.actions.save' => 'Guardar',
			'sidebar.actions.delete' => 'Eliminar',
			'sidebar.actions.rename' => 'Renombrar',
			'sidebar.actions.joinCommunity' => 'Unirse a la comunidad',
			'sidebar.actions.reportIssue' => 'Informar de un problema',
			'sidebar.actions.starOnGithub' => 'Dar estrella en GitHub',
			'sidebar.actions.buyMeACoffee' => 'Invítame a un café',
			'sidebar.workspace.title' => 'Cambiar el espacio de trabajo de la sesión',
			'sidebar.workspace.description' => 'El agente ejecuta sus próximos turnos en este directorio. El historial de sesión existente se conserva.',
			'sidebar.workspace.pathLabel' => 'Ruta del espacio de trabajo',
			'sidebar.workspace.pathRequired' => 'La ruta del espacio de trabajo es obligatoria.',
			'sidebar.workspace.submit' => 'Cambiar espacio de trabajo',
			'sidebar.workspace.saving' => 'Cambiando…',
			'sidebar.workspace.changeAction' => 'Cambiar espacio de trabajo',
			'sidebar.branding.openSource' => 'Código abierto',
			'sidebar.status.active' => 'Activa',
			'sidebar.status.inactive' => 'Inactiva',
			'sidebar.status.thinking' => 'Pensando...',
			'sidebar.status.error' => 'Error',
			'sidebar.status.aborted' => 'Cancelada',
			'sidebar.status.unknown' => 'Desconocido',
			'sidebar.time.justNow' => 'Justo ahora',
			'sidebar.time.oneMinuteAgo' => 'hace 1 min',
			'sidebar.time.minutesAgo' => ({required Object count}) => 'hace ${count} min',
			'sidebar.time.oneHourAgo' => 'hace 1 hora',
			'sidebar.time.hoursAgo' => ({required Object count}) => 'hace ${count} horas',
			'sidebar.time.oneDayAgo' => 'hace 1 día',
			'sidebar.time.daysAgo' => ({required Object count}) => 'hace ${count} días',
			'sidebar.messages.deleteConfirm' => '¿Seguro que quieres eliminar esto?',
			'sidebar.messages.renameSuccess' => 'Renombrado correctamente',
			'sidebar.messages.deleteSuccess' => 'Eliminado correctamente',
			'sidebar.messages.errorOccurred' => 'Ocurrió un error',
			'sidebar.messages.deleteSessionConfirm' => '¿Seguro que quieres eliminar esta sesión? Esta acción no se puede deshacer.',
			'sidebar.messages.deleteProjectConfirm' => '¿Quitar este proyecto de la barra lateral? Tus archivos, memorias y datos de sesión no se eliminarán.',
			'sidebar.messages.enterProjectPath' => 'Introduce la ruta del proyecto',
			'sidebar.messages.deleteSessionFailed' => 'No se pudo eliminar la sesión. Inténtalo de nuevo.',
			'sidebar.messages.deleteSessionError' => 'Error al eliminar la sesión. Inténtalo de nuevo.',
			'sidebar.messages.renameSessionFailed' => 'No se pudo renombrar la sesión. Inténtalo de nuevo.',
			'sidebar.messages.renameSessionError' => 'Error al renombrar la sesión. Inténtalo de nuevo.',
			'sidebar.messages.changeWorkspaceFailed' => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.',
			'sidebar.messages.changeWorkspaceError' => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.',
			'sidebar.messages.deleteProjectFailed' => 'No se pudo quitar el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.deleteProjectError' => 'Error al quitar el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.createProjectFailed' => 'No se pudo crear el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.createProjectError' => 'Error al crear el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.updateProjectError' => 'Error al actualizar el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.refreshError' => 'No se pudo actualizar. Inténtalo de nuevo.',
			'sidebar.messages.restoreProjectFailed' => 'No se pudo restaurar el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.restoreProjectError' => 'Error al restaurar el proyecto. Inténtalo de nuevo.',
			'sidebar.messages.restoreSessionFailed' => 'No se pudo restaurar la sesión. Inténtalo de nuevo.',
			'sidebar.messages.restoreSessionError' => 'Error al restaurar la sesión. Inténtalo de nuevo.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Error al eliminar ${count} sesión. Inténtalo de nuevo.', other: 'Error al eliminar ${count} sesiones. Inténtalo de nuevo.', ), 
			'sidebar.version.updateAvailable' => 'Actualización disponible',
			'sidebar.version.restartRequired' => 'Actualización instalada — reinicia el servidor para aplicarla',
			'sidebar.version.updateNow' => 'Actualizar ahora',
			'sidebar.version.updateConfirm' => ({required Object version}) => '¿Actualizar DDAgent a v${version}? Se descargará y compilará el código más reciente y el servidor se reiniciará — las sesiones activas se interrumpirán.',
			'sidebar.version.updating' => 'Actualizando… puede tardar unos minutos',
			'sidebar.version.restarting' => 'Actualización instalada — reiniciando…',
			'sidebar.version.updateFailed' => 'La actualización falló',
			'sidebar.version.releaseNotes' => 'Notas de la versión',
			'sidebar.search.modeProjects' => 'Proyectos',
			'sidebar.search.modeConversations' => 'Conversaciones',
			'sidebar.search.conversationsPlaceholder' => 'Buscar en conversaciones...',
			'sidebar.search.searching' => 'Buscando...',
			'sidebar.search.sessionTitles' => 'Títulos de sesiones',
			'sidebar.search.conversationContents' => 'Contenido de conversaciones',
			'sidebar.search.noResults' => 'No se encontraron resultados',
			'sidebar.search.tryDifferentQuery' => 'Prueba con otra búsqueda',
			'sidebar.search.modeRunning' => 'En curso',
			'sidebar.search.archiveOnly' => 'Archivo',
			'sidebar.search.runningTooltip' => 'Sesiones activas',
			'sidebar.search.archiveOnlyTooltip' => 'Solo archivadas',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} activas',
			'sidebar.search.viewMenu' => 'Vista',
			'sidebar.search.backToProjects' => 'Volver a proyectos',
			'sidebar.search.archivedPlaceholder' => 'Buscar sesiones archivadas...',
			'sidebar.search.runningPlaceholder' => 'Buscar sesiones activas...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} coincidencia', other: '${count} coincidencias', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} proyecto examinado', other: '${count} proyectos examinados', ), 
			'sidebar.recent.title' => 'Conversaciones recientes',
			'sidebar.recent.emptyTitle' => 'Aún no hay conversaciones',
			'sidebar.recent.emptyDescription' => 'Tus conversaciones actualizadas más recientemente aparecerán aquí.',
			'sidebar.recent.loadFailed' => 'No se pudieron cargar las conversaciones recientes',
			'sidebar.recent.loadMore' => 'Cargar conversaciones anteriores',
			'sidebar.recent.loadingMore' => 'Cargando más...',
			'sidebar.deleteConfirmation.deleteProject' => 'Quitar proyecto',
			'sidebar.deleteConfirmation.deleteSession' => 'Eliminar sesión',
			'sidebar.deleteConfirmation.confirmDelete' => '¿Qué quieres hacer con',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Solo quitar de la barra lateral',
			'sidebar.deleteConfirmation.deleteAllData' => 'Eliminar todos los datos permanentemente',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'El proyecto se quitará de la barra lateral. Tus archivos, memorias y datos de sesión se conservarán.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Puedes volver a añadir el proyecto más tarde.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'Archivar oculta las sesiones seleccionadas de la lista activa conservando sus historiales.',
			'sidebar.deleteConfirmation.archiveSession' => 'Archivar sesión',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'Archivar mantiene la sesión fuera de la lista activa conservando su historial.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Esta sesión ya está archivada. Puedes mantenerla oculta o eliminarla permanentemente.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'Esto elimina permanentemente la sesión y su transcripción. Esta acción no se puede deshacer.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Eliminar permanentemente',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Este proyecto contiene ${count} conversación.', other: 'Este proyecto contiene ${count} conversaciones.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Gestionar sesión seleccionada', other: 'Gestionar ${count} sesiones seleccionadas', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Archivar sesión', other: 'Archivar ${count} sesiones', ), 
			'sidebar.zones.activeNow' => 'Activos ahora',
			'sidebar.zones.recent' => 'Usados recientemente',
			'sidebar.zones.today' => 'Hoy',
			'sidebar.zones.yesterday' => 'Ayer',
			'sidebar.zones.thisWeek' => 'Esta semana',
			'sidebar.zones.showMore' => ({required Object count}) => 'Mostrar ${count} más',
			'sidebar.zones.showLess' => 'Mostrar menos',
			'sidebar.tabs.board' => 'Panel de agentes',
			'sidebar.tabs.files' => 'Archivos',
			'sidebar.tabs.git' => 'Control de código',
			'sidebar.tabs.tasks' => 'Tareas',
			'sidebar.tabs.usage' => 'Cuota y uso',
			'tasks.notConfigured.title' => 'TaskMaster AI no está configurado',
			'tasks.notConfigured.description' => 'TaskMaster ayuda a descomponer proyectos complejos en tareas manejables con asistencia de IA',
			'tasks.notConfigured.whatIsTitle' => '🎯 ¿Qué es TaskMaster?',
			'tasks.notConfigured.features.aiPowered' => 'Gestión de tareas con IA: descompone proyectos complejos en subtareas manejables',
			'tasks.notConfigured.features.prdTemplates' => 'Plantillas PRD: genera tareas a partir de Documentos de Requisitos de Producto',
			'tasks.notConfigured.features.dependencyTracking' => 'Seguimiento de dependencias: entiende las relaciones entre tareas y el orden de ejecución',
			'tasks.notConfigured.features.progressVisualization' => 'Visualización del progreso: tableros Kanban y analíticas detalladas de tareas',
			'tasks.notConfigured.features.cliIntegration' => 'Integración CLI: usa comandos de taskmaster para flujos de trabajo avanzados',
			'tasks.notConfigured.initializeButton' => 'Inicializar TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => 'Escribe primero un PRD',
			'tasks.gettingStarted.title' => 'Primeros pasos con TaskMaster',
			'tasks.gettingStarted.subtitle' => '¡TaskMaster está inicializado! Esto es lo que puedes hacer ahora:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Crea un Documento de Requisitos de Producto (PRD)',
			'tasks.gettingStarted.steps.createPRD.description' => 'Conversa sobre la idea de tu proyecto y crea un PRD que describa lo que quieres construir.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'Añadir PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'PRDs existentes:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Genera tareas desde el PRD',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Cuando tengas un PRD, pídele a tu asistente de IA que lo analice y TaskMaster lo descompondrá automáticamente en tareas manejables con detalles de implementación.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Analiza y expande tareas',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Pídele a tu asistente de IA que analice la complejidad de las tareas y las expanda en subtareas detalladas para facilitar la implementación.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Empieza a construir',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Pídele a tu asistente de IA que empiece a trabajar en las tareas, actualice su estado y añada tareas nuevas a medida que tu proyecto evoluciona.',
			'tasks.gettingStarted.tip' => '💡 Consejo: empieza con un PRD para sacar el máximo partido a la generación de tareas con IA de TaskMaster',
			'tasks.setupModal.title' => 'Configuración de TaskMaster',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'CLI interactiva para ${projectName}',
			'tasks.setupModal.willStart' => 'La inicialización de TaskMaster comenzará automáticamente',
			'tasks.setupModal.completed' => '¡Configuración de TaskMaster completada! Ya puedes cerrar esta ventana.',
			'tasks.setupModal.closeButton' => 'Cerrar',
			'tasks.setupModal.closeContinueButton' => 'Cerrar y continuar',
			'tasks.setupModal.closeTitle' => 'Cerrar',
			'tasks.setupModal.description' => 'Crea una carpeta .taskmaster en este proyecto. No requiere herramientas externas ni claves API — las tareas se guardan localmente.',
			'tasks.setupModal.initializeButton' => 'Inicializar',
			'tasks.setupModal.initializing' => 'Inicializando...',
			'tasks.helpGuide.title' => 'Primeros pasos con TaskMaster',
			'tasks.helpGuide.subtitle' => 'Tu guía para una gestión de tareas productiva',
			'tasks.helpGuide.examples.parsePRD' => '💬 Ejemplo:\n"Acabo de inicializar un proyecto nuevo con Claude Task Master. Tengo un PRD en .taskmaster/docs/prd.txt. ¿Me ayudas a analizarlo y configurar las tareas iniciales?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Ejemplo:\n"La tarea 5 parece compleja. ¿Puedes descomponerla en subtareas?"',
			'tasks.helpGuide.examples.addTask' => '💬 Ejemplo:\n"Añade una tarea nueva para implementar la subida de imágenes de perfil de usuario con Cloudinary, e investiga el mejor enfoque."',
			'tasks.helpGuide.moreExamples' => 'Ver más ejemplos y patrones de uso →',
			'tasks.helpGuide.proTips.title' => '💡 Consejos pro',
			'tasks.helpGuide.proTips.search' => 'Usa la barra de búsqueda para encontrar tareas específicas rápidamente',
			'tasks.helpGuide.proTips.views' => 'Cambia entre las vistas Kanban, Lista y Cuadrícula con los selectores de vista',
			'tasks.helpGuide.proTips.filters' => 'Usa los filtros para centrarte en estados o prioridades específicas',
			'tasks.helpGuide.proTips.details' => 'Haz clic en cualquier tarea para ver información detallada y gestionar subtareas',
			'tasks.helpGuide.learnMore.title' => '📚 Más información',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI es un sistema avanzado de gestión de tareas creado para desarrolladores. Consulta la documentación, ejemplos y contribuye al proyecto.',
			'tasks.helpGuide.learnMore.githubButton' => 'Ver en GitHub',
			'tasks.helpGuide.closeTitle' => 'Cerrar',
			'tasks.search.placeholder' => 'Buscar tareas...',
			'tasks.filters.button' => 'Filtros',
			'tasks.filters.status' => 'Estado',
			'tasks.filters.priority' => 'Prioridad',
			'tasks.filters.sortBy' => 'Ordenar por',
			'tasks.filters.allStatuses' => 'Todos los estados',
			'tasks.filters.allPriorities' => 'Todas las prioridades',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => 'Mostrando ${filtered} de ${total} tareas',
			'tasks.filters.clearFilters' => 'Limpiar filtros',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Estado',
			'tasks.sort.priority' => 'Prioridad',
			'tasks.sort.idAsc' => 'ID (ascendente)',
			'tasks.sort.idDesc' => 'ID (descendente)',
			'tasks.sort.titleAsc' => 'Título (A-Z)',
			'tasks.sort.titleDesc' => 'Título (Z-A)',
			'tasks.sort.statusAsc' => 'Estado (pendientes primero)',
			'tasks.sort.statusDesc' => 'Estado (completadas primero)',
			'tasks.sort.priorityAsc' => 'Prioridad (alta primero)',
			'tasks.sort.priorityDesc' => 'Prioridad (baja primero)',
			'tasks.views.kanban' => 'Vista Kanban',
			'tasks.views.list' => 'Vista de lista',
			'tasks.views.grid' => 'Vista de cuadrícula',
			'tasks.kanban.pending' => '📋 Por hacer',
			'tasks.kanban.inProgress' => '🚀 En curso',
			'tasks.kanban.review' => '👀 Revisión',
			'tasks.kanban.done' => '✅ Hechas',
			'tasks.kanban.blocked' => '🚫 Bloqueadas',
			'tasks.kanban.deferred' => '⏳ Aplazadas',
			'tasks.kanban.cancelled' => '❌ Canceladas',
			'tasks.kanban.noTasksYet' => 'Aún no hay tareas',
			'tasks.kanban.tasksWillAppear' => 'Las tareas aparecerán aquí',
			'tasks.kanban.moveTasksHere' => 'Mueve las tareas aquí cuando empiecen',
			'tasks.kanban.completedTasksHere' => 'Las tareas completadas aparecen aquí',
			'tasks.kanban.statusTasksHere' => 'Las tareas con este estado aparecerán aquí',
			'tasks.buttons.help' => 'Guía de primeros pasos de TaskMaster',
			'tasks.buttons.prds' => 'PRDs',
			'tasks.buttons.addPRD' => 'Añadir PRD',
			'tasks.buttons.addTask' => 'Añadir tarea',
			'tasks.buttons.createNewPRD' => 'Crear PRD nuevo',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} PRD(s) disponibles',
			'tasks.prd.modified' => ({required Object date}) => 'Modificado: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.newFile' => 'archivo nuevo',
			'tasks.prd.template' => 'Plantilla',
			'tasks.prd.parse' => 'Analizar PRD',
			'tasks.prd.fileExistsTitle' => 'El archivo ya existe',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'Ya existe un PRD llamado «${name}». ¿Quieres sobrescribirlo?',
			'tasks.prd.fileNameHint' => 'nombre de archivo (p. ej., prd.txt)',
			'tasks.prd.saved' => 'PRD guardado',
			'tasks.prd.tasksGenerated' => 'Tareas generadas desde el PRD',
			'tasks.statuses.pending' => 'Pendiente',
			'tasks.statuses.inProgress' => 'En curso',
			'tasks.statuses.done' => 'Hecha',
			'tasks.statuses.blocked' => 'Bloqueada',
			'tasks.statuses.deferred' => 'Aplazada',
			'tasks.statuses.cancelled' => 'Cancelada',
			'tasks.statuses.review' => 'Revisión',
			'tasks.priorities.high' => 'Alta',
			'tasks.priorities.medium' => 'Media',
			'tasks.priorities.low' => 'Baja',
			'tasks.noMatchingTasks.title' => 'Ninguna tarea coincide con tus filtros',
			'tasks.noMatchingTasks.description' => 'Prueba a ajustar la búsqueda o los criterios de filtrado.',
			'tasks.board.title' => 'Tablero de agentes',
			'tasks.board.subtitle' => 'Mueve una tarjeta a Lista y el agente la toma. Haz clic en una tarjeta para abrir su sesión.',
			'tasks.board.newCard' => 'Nueva tarjeta',
			'tasks.board.addCard' => 'Añadir tarjeta',
			'tasks.board.refresh' => 'Actualizar',
			'tasks.board.empty.title' => 'Aún no hay tarjetas',
			'tasks.board.empty.description' => 'Añade una tarjeta, describe la tarea y arrástrala a Lista para que un agente empiece a trabajar.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Lista para empezar',
			'tasks.board.columns.working' => 'Trabajando',
			'tasks.board.columns.needsDecision' => 'Necesita tu decisión',
			'tasks.board.columns.done' => 'Hecha',
			'tasks.board.columns.archived' => 'Archivadas',
			'tasks.board.card.running' => 'En ejecución',
			'tasks.board.card.abort' => 'Abortar',
			'tasks.board.card.delete' => 'Eliminar',
			'tasks.board.card.openSession' => 'Abrir sesión',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.card.edit' => 'Editar',
			'tasks.board.card.moveTo' => 'Mover a',
			'tasks.board.dialog.createTitle' => 'Nueva tarjeta',
			'tasks.board.dialog.editTitle' => 'Editar tarjeta',
			'tasks.board.dialog.titleLabel' => 'Título',
			'tasks.board.dialog.titlePlaceholder' => '¿Qué debe hacer el agente?',
			'tasks.board.dialog.descriptionLabel' => 'Descripción',
			'tasks.board.dialog.descriptionPlaceholder' => 'Añade contexto, criterios de aceptación, enlaces...',
			'tasks.board.dialog.cancel' => 'Cancelar',
			'tasks.board.dialog.save' => 'Guardar',
			'tasks.board.noProject' => 'Añade primero un proyecto y luego crea tarjetas para él.',
			'tasks.board.projectLabel' => 'Proyecto',
			'tasks.board.backToChat' => 'Volver al chat',
			'tasks.board.agent.provider' => 'Agente',
			'tasks.board.agent.anyProvider' => 'Cualquier agente',
			'tasks.board.agent.model' => 'Modelo',
			'tasks.board.agent.defaultModel' => 'Modelo predeterminado',
			'tasks.board.agent.effort' => 'Razonamiento',
			'tasks.board.agent.defaultEffort' => 'Predeterminado',
			'tasks.board.agent.searchModel' => 'Buscar modelos…',
			'tasks.board.agent.noModels' => 'Sin modelos coincidentes',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '«${cardTitle}» se eliminará permanentemente.',
			'tasks.board.deleteConfirm.title' => '¿Eliminar la tarjeta?',
			'tasks.board.project' => 'Proyecto',
			'tasks.board.assignee.label' => 'Responsable',
			'tasks.board.assignee.all' => 'Todos los responsables',
			'tasks.board.assignee.unassigned' => 'Sin asignar',
			'tasks.board.presence.online' => ({required Object count}) => '${count} en línea',
			'tasks.board.activity.title' => 'Actividad',
			'tasks.board.activity.empty' => 'Aún no hay actividad',
			'tasks.board.comments.label' => 'Comentarios',
			'tasks.board.comments.placeholder' => 'Escribe un comentario…',
			'tasks.board.comments.send' => 'Enviar',
			'tasks.board.comments.unknownAuthor' => 'Alguien',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Depende de: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Tarea ${id}',
			'tasks.card.highPriority' => 'Prioridad alta',
			'tasks.card.lowPriority' => 'Prioridad baja',
			'tasks.card.mediumPriority' => 'Prioridad media',
			'tasks.card.noPriority' => 'Sin prioridad definida',
			'tasks.card.parentTask' => ({required Object id}) => 'Tarea ${id}',
			'tasks.card.progressLabel' => 'Progreso:',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => '${completed} de ${total} subtareas completadas',
			'tasks.card.runTask' => 'Ejecutar tarea',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Ejecutar tarea ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Estado: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'ID de tarea: ${id}',
			'tasks.card.taskInProgress' => 'Tarea en curso',
			'tasks.createTask.cancel' => 'Cancelar',
			'tasks.createTask.descriptionLabel' => 'Descripción',
			'tasks.createTask.descriptionPlaceholder' => 'Detalles opcionales',
			'tasks.createTask.error' => 'No se pudo añadir la tarea',
			'tasks.createTask.priorityLabel' => 'Prioridad',
			'tasks.createTask.submit' => 'Añadir tarea',
			'tasks.createTask.submitting' => 'Añadiendo...',
			'tasks.createTask.title' => 'Añadir tarea',
			'tasks.createTask.titleLabel' => 'Título',
			'tasks.createTask.titlePlaceholder' => '¿Qué hay que hacer?',
			'tasks.list.completedReopen' => 'Completada (clic para reabrir)',
			'tasks.list.inProgressComplete' => 'En curso (clic para completar)',
			'tasks.list.markCompleted' => 'Marcar como completada',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Alternar estado de la tarea ${id}',
			'tasks.list.markDone' => 'Marcar como completada',
			'tasks.list.reopen' => 'Reabrir',
			'tasks.nextTask.allComplete' => 'Todas las tareas completadas',
			'tasks.nextTask.feature1' => '- Gestión de tareas con IA, dependencias y subtareas.',
			'tasks.nextTask.feature2' => '- Generación de tareas desde PRD para un arranque más rápido.',
			'tasks.nextTask.feature3' => '- Vistas kanban y lista para el día a día.',
			'tasks.nextTask.hideDetails' => 'Ocultar detalles',
			'tasks.nextTask.initialize' => 'Inicializar',
			'tasks.nextTask.noPending' => 'No hay tareas pendientes',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI no está configurado',
			'tasks.nextTask.review' => 'Revisar',
			'tasks.nextTask.startTask' => 'Iniciar tarea',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Tarea ${id}',
			'tasks.nextTask.viewAll' => 'Ver todas las tareas',
			'tasks.nextTask.viewDetails' => 'Ver detalles de la tarea',
			'tasks.nextTask.whatIs' => '¿Qué es TaskMaster?',
			'tasks.taskDetail.cancelEdit' => 'Cancelar edición',
			'tasks.taskDetail.close' => 'Cerrar',
			'tasks.taskDetail.copyTaskId' => 'Copiar ID de tarea',
			'tasks.taskDetail.delete' => 'Eliminar tarea',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '"${title}" se eliminará permanentemente.',
			'tasks.taskDetail.deleteConfirmTitle' => '¿Eliminar tarea?',
			'tasks.taskDetail.deleteFailed' => 'No se pudo eliminar la tarea',
			'tasks.taskDetail.dependencies' => 'Dependencias',
			'tasks.taskDetail.dependenciesPlaceholder' => 'p. ej. 1, 2, 3',
			'tasks.taskDetail.description' => 'Descripción',
			'tasks.taskDetail.edit' => 'Editar tarea',
			'tasks.taskDetail.implDetails' => 'Detalles de implementación',
			'tasks.taskDetail.noDependencies' => 'Sin dependencias',
			'tasks.taskDetail.noDescription' => 'Sin descripción',
			'tasks.taskDetail.priority' => 'Prioridad',
			'tasks.taskDetail.priorityNotSet' => 'No definida',
			'tasks.taskDetail.save' => 'Guardar',
			'tasks.taskDetail.status' => 'Estado',
			'tasks.taskDetail.statusFailed' => 'No se pudo actualizar el estado de la tarea',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Tarea ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Tarea ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Estrategia de pruebas',
			'tasks.taskDetail.titleRequired' => 'El título es obligatorio',
			'tasks.taskDetail.updateFailed' => 'No se pudo actualizar la tarea',
			'tasks.taskDetail.notFound' => 'Tarea no encontrada',
			_ => null,
		} ?? switch (path) {
			'tasks.taskDetail.subtasks' => 'Subtareas',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'Se eliminará la tarea n.º ${id}. Esta acción no se puede deshacer.',
			'tasks.taskDetail.idCopied' => 'ID de tarea copiado',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Tarea ${id} marcada como en curso',
			'tasks.taskmaster.noProjectHint' => 'Primero añade un proyecto y luego crea tareas para él.',
			'tasks.taskmaster.sort.statusAz' => 'Estado (A-Z)',
			'tasks.taskmaster.sort.statusZa' => 'Estado (Z-A)',
			'tasks.taskmaster.installedVersion' => ({required Object version}) => 'Instalado: ${version}',
			'tasks.taskmaster.initFailed' => 'No se pudo inicializar TaskMaster',
			'tasks.taskmaster.prd.fileNameRequired' => 'Indica un nombre de archivo para el PRD.',
			'tasks.taskmaster.prd.contentRequired' => 'Añade contenido antes de guardar.',
			'tasks.taskmaster.prd.overwrite' => 'Sobrescribir',
			'tasks.taskmaster.prd.contentHint' => '# Documento de requisitos del producto…',
			'tasks.taskmaster.detail.dependenciesLabel' => 'Dependencias (ID separados por comas)',
			'tasks.taskmaster.untitledTask' => 'Tarea sin título',
			'knowledge.title' => 'Conocimiento',
			'knowledge.tabs.dashboard' => 'Panel',
			'knowledge.tabs.memories' => 'Recuerdos',
			'knowledge.tabs.rules' => 'Reglas',
			'knowledge.tabs.skills' => 'Habilidades',
			'knowledge.tabs.personal' => 'Personal',
			'knowledge.tabs.graph' => 'Grafo',
			'knowledge.common.add' => 'Añadir',
			'knowledge.common.save' => 'Guardar',
			'knowledge.common.cancel' => 'Cancelar',
			'knowledge.common.delete' => 'Eliminar',
			'knowledge.common.edit' => 'Editar',
			'knowledge.common.close' => 'Cerrar',
			'knowledge.common.restore' => 'Restaurar',
			'knowledge.common.refresh' => 'Actualizar',
			'knowledge.common.allProjects' => 'Todos los proyectos',
			'knowledge.common.global' => 'Global',
			'knowledge.actions.scan' => 'Escanear archivos del proyecto',
			'knowledge.actions.export' => 'Exportar JSON',
			'knowledge.actions.import' => 'Importar JSON',
			'knowledge.actions.scanComplete' => 'Escaneo completado',
			'knowledge.actions.importComplete' => 'Importación completada',
			'knowledge.actions.importFailed' => 'La importación falló',
			'knowledge.dialog.newEntity' => 'Nueva entrada',
			'knowledge.dialog.editEntity' => 'Editar entrada',
			'knowledge.dialog.deleteTitle' => 'Eliminar',
			'knowledge.dialog.deleteMessage' => '¿Eliminar esta entrada? No se puede deshacer (se conserva el historial).',
			'knowledge.dialog.pickIcon' => 'Elegir icono',
			'knowledge.dialog.removeIcon' => 'Quitar icono',
			'knowledge.dialog.iconTooLarge' => 'El icono es demasiado grande (máx. 40 KB).',
			'knowledge.dialog.importTitle' => 'Importar conocimiento',
			'knowledge.dialog.importHint' => 'Pega aquí el JSON exportado',
			'knowledge.dialog.exportTitle' => 'Exportar conocimiento',
			'knowledge.dialog.import' => 'Importar',
			'knowledge.fields.key' => 'Clave',
			'knowledge.fields.title' => 'Título',
			'knowledge.fields.name' => 'Nombre',
			'knowledge.fields.description' => 'Descripción',
			'knowledge.fields.category' => 'Categoría',
			'knowledge.fields.content' => 'Contenido',
			'knowledge.fields.priority' => 'Prioridad',
			'knowledge.fields.tags' => 'Etiquetas',
			'knowledge.fields.enabled' => 'Activado',
			'knowledge.fields.projectScope' => 'Ámbito del proyecto',
			'knowledge.fields.tagsHint' => 'separadas por comas',
			'knowledge.dashboard.memories' => 'Recuerdos',
			'knowledge.dashboard.rules' => 'Reglas',
			'knowledge.dashboard.skills' => 'Habilidades',
			'knowledge.dashboard.personal' => 'Personal',
			'knowledge.dashboard.connections' => 'Conexiones',
			'knowledge.dashboard.recent' => 'Recuerdos recientes',
			'knowledge.dashboard.noMemories' => 'Aún no hay recuerdos. Añade uno en la pestaña Recuerdos.',
			'knowledge.empty.memories' => 'Aún no hay recuerdos.',
			'knowledge.empty.rules' => 'Aún no hay reglas.',
			'knowledge.empty.skills' => 'Aún no hay habilidades.',
			'knowledge.empty.personal' => 'Aún no hay información personal.',
			'knowledge.empty.graph' => 'Aún no hay entidades para el grafo.',
			'knowledge.history.title' => 'Historial',
			'knowledge.history.none' => 'Aún no hay historial.',
			'knowledge.history.untitled' => '(sin título)',
			'knowledge.priorities.critical' => 'Crítica',
			'knowledge.priorities.high' => 'Alta',
			'knowledge.priorities.normal' => 'Normal',
			'knowledge.priorities.low' => 'Baja',
			'knowledge.search.title' => 'Buscar en conocimiento',
			'knowledge.search.hint' => 'Buscar recuerdos, reglas, habilidades…',
			'knowledge.search.noResults' => 'Sin resultados.',
			'knowledge.links.title' => 'Vincular entidades',
			'knowledge.links.source' => 'Origen',
			'knowledge.links.target' => 'Destino',
			'knowledge.links.relationship' => 'Relación',
			'knowledge.links.add' => 'Crear vínculo',
			'knowledge.tags.all' => 'Todas las etiquetas',
			'knowledge.tags.manage' => 'Gestionar etiquetas',
			'knowledge.tags.none' => 'Aún no hay etiquetas.',
			'knowledge.graph.truncated' => 'truncado',
			'knowledge.importAll.title' => 'Importar todo a DDAgent',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Proyectos examinados: ${count}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Skills de agentes encontradas: ${found} (nuevas: ${newSkills})',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Reglas: ${total} · grupos duplicados: ${duplicates}',
			'knowledge.importAll.mergeDuplicates' => 'Fusionar entradas duplicadas',
			'knowledge.importAll.mergeDuplicatesHint' => 'Combina las filas duplicadas en DDAgent (no los archivos)',
			'knowledge.importAll.action' => 'Importar todo',
			'knowledge.importAll.readOnlyNotice' => 'Solo lectura para tus agentes: esto importa en la base de datos propia de DDAgent y NO modifica ni elimina ningún archivo ni configuración de las CLI. Las opciones de abajo solo cambian datos de DDAgent.',
			'knowledge.importAll.dryRunNote' => 'Simulación: aún no se ha escrito nada.',
			'knowledge.importAll.importedNote' => 'Importado.',
			'knowledge.importAll.result' => ({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'Importado: reglas: ${rules}, habilidades nuevas: ${newSkills}, eliminadas: ${removed}, promovidas: ${promoted}',
			'knowledge.importAll.description' => 'Analiza todos los proyectos e importa las habilidades de tus agentes a la base de conocimiento. Solo lectura para tus agentes: no se cambia nada en las CLI.',
			'knowledge.migrate.title' => 'Migrar reglas existentes',
			'knowledge.migrate.scanned' => ({required Object count}) => 'Se examinaron ${count} proyectos.',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Reglas: ${total} en total, ${critical} críticas.',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Grupos duplicados entre proyectos: ${count}',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Eliminadas: ${removed}, promovidas: ${promoted}',
			'knowledge.migrate.mergeDuplicates' => 'Fusionar duplicados',
			'knowledge.migrate.dryRunNote' => 'Simulación: aún no se ha cambiado nada.',
			'knowledge.migrate.applied' => 'Aplicado.',
			'knowledge.importSkills.title' => 'Importar skills de agentes',
			'knowledge.importSkills.found' => ({required Object count}) => 'Se encontraron ${count} skills en tus agentes.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Nuevas: ${imported} · omitidas: ${skipped}',
			'knowledge.importSkills.dryRunHint' => 'Importa las habilidades globales/predeterminadas de tus agentes (usuario, sistema, plugin) como habilidades de conocimiento. Simulación: aún no se ha importado nada.',
			'knowledge.importSkills.importedNote' => 'Importado a la base de conocimiento.',
			'knowledge.critical.make' => 'Marcar como crítica',
			'knowledge.critical.makeAll' => 'Marcar todas las reglas como críticas',
			'knowledge.critical.makeAllHint' => 'Las añade al presupuesto de contexto inyectado',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.contextBudget.title' => 'Contexto de reglas (siempre incluido)',
			'knowledge.contextBudget.selectProject' => 'Selecciona un proyecto para ver el tamaño de su contexto crítico.',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Memoria: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Regla: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Skill: ${name}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Personal: ${title}',
			'knowledge.errors.importFailed' => ({required Object error}) => 'La importación falló: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'La migración falló: ${error}',
			'knowledge.entityTypes.memory' => 'Memoria',
			'knowledge.entityTypes.rule' => 'Regla',
			'knowledge.entityTypes.skill' => 'Habilidad',
			'knowledge.entityTypes.personal' => 'Personal',
			'knowledge.entityTypes.project' => 'Proyecto',
			'knowledge.entityTypes.tag' => 'Etiqueta',
			'browser.dialogTitle' => 'Navegador del agente',
			'browser.viewError' => 'Error en la vista del navegador',
			'browser.web' => 'Web',
			'collab.team' => 'Equipo',
			'collab.invite' => 'Invitación',
			'collab.inviteTeammate' => 'Invitar a un compañero',
			'collab.shareTokenHint' => 'Comparte este token de invitación — se muestra una sola vez y caduca en 72 h:',
			'collab.createInvite' => 'Crear invitación',
			'collab.copyToken' => 'Copiar token',
			'collab.roles.member' => 'Miembro',
			'collab.roles.viewer' => 'Lector',
			'collab.viewing.session' => 'sesión',
			'collab.viewing.card' => 'tarjeta',
			'collab.viewing.board' => 'tablero',
			'fileTree.uploadTo' => 'Subir a',
			'fileTree.uploadHere' => 'Subir aquí',
			'fileTree.browseServerFilesystem' => 'Explorar el sistema de archivos del servidor',
			'fileTree.noFiles' => 'Sin archivos',
			'fileTree.copyContents' => 'Copiar contenido',
			'fileTree.chooseFolder' => 'Elegir carpeta',
			'fileTree.search.hint' => 'Filtra nombres / Enter para buscar en el contenido',
			'fileTree.search.prompt' => 'Escribe una consulta y pulsa Enter',
			'fileTree.search.noMatches' => 'Sin coincidencias',
			'fileTree.search.resultsTruncated' => 'Resultados truncados',
			'fileTree.titles.rename' => ({required Object name}) => 'Renombrar ${name}',
			'fileTree.titles.delete' => ({required Object name}) => 'Eliminar ${name}',
			'fileTree.titles.download' => ({required Object name}) => 'Descargar ${name}',
			'fileTree.uploadedCount' => ({required Object count}) => 'Subidos ${count} archivo(s)',
			'fileTree.newName' => 'Nombre nuevo',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'No es un proyecto registrado: ${path}',
			'fileTree.showGitignoredFiles' => 'Mostrar archivos ignorados por git',
			'fileTree.hideGitignoredFiles' => 'Ocultar archivos ignorados por git',
			'fileTree.downloadUnsupportedOnWeb' => 'Descarga no compatible en la web',
			'fileTree.saveToPath' => 'Guardar en ruta',
			'fileTree.savedTo' => ({required Object path}) => 'Guardado en ${path}',
			'fileTree.relative.now' => 'ahora',
			'fileTree.relative.minutes' => ({required Object n}) => '${n} min',
			'fileTree.relative.hours' => ({required Object n}) => '${n} h',
			'fileTree.relative.days' => ({required Object n}) => '${n} d',
			'fileTree.projectRoot' => '(raíz del proyecto)',
			'fileTree.uploadLimitCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Puedes subir como máximo ${count} archivo a la vez.', other: 'Puedes subir como máximo ${count} archivos a la vez.', ), 
			'fileTree.fileTooLarge' => ({required Object name}) => '${name} supera los 200 MB.',
			'fileTree.deleteFolderConfirm' => ({required Object path}) => '¿Eliminar la carpeta "${path}"? Esta acción no se puede deshacer.',
			'fileTree.deleteFileConfirm' => ({required Object path}) => '¿Eliminar el archivo "${path}"? Esta acción no se puede deshacer.',
			'git.checkpoints.title' => 'Checkpoints',
			'git.checkpoints.restoreTitle' => 'Restaurar checkpoint',
			'git.checkpoints.restoreMessage' => '¿Restablecer el árbol de trabajo a este checkpoint? Los cambios actuales se reemplazarán.',
			'git.checkpoints.restored' => 'Checkpoint restaurado',
			'git.checkpoints.labelHint' => 'Etiqueta del checkpoint (opcional)',
			'git.checkpoints.empty' => 'Aún no hay checkpoints',
			'git.checkpoints.create' => 'Nuevo',
			'git.stagedChanges' => 'Cambios preparados',
			'git.statusStaged' => 'Preparado',
			'git.switchBranch' => 'Cambiar de rama',
			'git.unifiedDiff' => 'Diff unificado',
			'git.splitDiff' => 'Diff lado a lado',
			'git.noDiff' => 'No hay diff disponible',
			'git.largeDiff' => 'Vista previa de diff grande: la representación está limitada para mantener la pestaña ágil.',
			'git.loadDiffFailed' => ({required Object error}) => 'No se pudo cargar el diff: ${error}',
			'git.hunkStage' => '+ Sección',
			'git.hunkUnstage' => '− Sección',
			'git.stageHunk' => 'Preparar sección',
			'git.unstageHunk' => 'Quitar preparación de la sección',
			'git.deleteFile' => 'Eliminar archivo',
			'git.commitMessage' => 'Mensaje del commit',
			'git.aiButton' => '✦ IA',
			'git.commitCreated' => 'Commit creado',
			'git.noBranch' => 'sin rama',
			'git.selectProject' => 'Selecciona un proyecto',
			'git.branchSections.local' => 'LOCALES',
			'git.branchSections.remote' => 'REMOTAS',
			'kanban.card.untitled' => 'Sin título',
			'kanban.comments.empty' => 'Aún no hay comentarios',
			'kanban.comments.add' => 'Añadir comentario',
			'kanban.dialog.saving' => 'Guardando…',
			'kanban.details.title' => 'Detalles de la tarjeta',
			'kanban.details.status' => ({required Object status}) => 'Estado: ${status}',
			'kanban.empty.noProject' => 'Ningún proyecto seleccionado',
			'kanban.saveFailed' => 'No se pudo guardar la tarjeta',
			'kanban.time.now' => 'ahora',
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'hace 1 min', other: 'hace ${count} min', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'hace 1 hora', other: 'hace ${count} horas', ), 
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'hace 1 día', other: 'hace ${count} días', ), 
			'mcp.install.title' => 'Instalar el servidor MCP de DDAgent',
			'mcp.install.description' => 'Permite que los agentes seleccionados usen la base de conocimiento y las herramientas de DDAgent mediante MCP.',
			'mcp.install.cardDescription' => 'Da a tus agentes la base de conocimiento y las herramientas de DDAgent mediante MCP: elige agentes o instala para todos.',
			'mcp.install.installSelected' => 'Instalar seleccionados',
			'mcp.install.installForAll' => 'Instalar para todos',
			'mcp.install.button' => 'Instalar',
			'mcp.install.failed' => ({required Object error}) => 'La instalación falló: ${error}',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Instalado en ${count} agente.', other: 'Instalado en ${count} agentes.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Instalado en ${count}; falló: ${failed}',
			'mcp.install.errorFallback' => 'error',
			'mcp.servers.loading' => 'Cargando servidores MCP…',
			'mcp.servers.refreshingScopes' => 'Actualizando ámbitos de proyecto…',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Los servidores del Model Context Protocol proporcionan herramientas y fuentes de datos adicionales a ${provider}',
			'mcp.servers.addGlobalTitle' => 'Añadir servidor MCP global',
			'mcp.servers.addGlobalDescription' => 'Añade este servidor MCP a todos los proveedores: Claude, Cursor, Codex, OpenCode y Devin. Solo se admiten los transportes stdio y HTTP porque la misma configuración debe funcionar en todos los proveedores.',
			'mcp.servers.addGlobalMenuDescription' => 'Añadir servidor MCP global escribe un servidor stdio o HTTP común en Claude, Cursor, Codex, OpenCode y Devin.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => 'Añadir servidor MCP de ${provider}',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => 'Añadir servidor MCP de ${provider} solo modifica ${provider}.',
			'mcp.servers.config.cwd' => 'Cwd',
			'mcp.servers.config.envVars' => 'Variables de entorno',
			'mcp.servers.selectProjectRequired' => 'Selecciona un proyecto para los servidores MCP con ámbito de proyecto',
			'mcp.servers.globalScopeUnsupported' => 'Añadir servidor MCP solo admite el ámbito de usuario o de proyecto en todos los proveedores.',
			'mcp.servers.globalAddFailed' => ({required Object details}) => 'No se pudo añadir el servidor MCP a todos los proveedores. ${details}',
			'mcp.servers.scopeProject' => 'proyecto',
			'mcp.team.title' => 'Configuraciones MCP del equipo',
			'mcp.team.description' => 'Comparte configuraciones de servidores MCP con tu equipo. Todos se mantienen sincronizados automáticamente.',
			'mcp.team.cta' => 'Disponible con DDAgent Pro',
			'mcp.tokens.scopeWrite' => 'Escritura',
			'mcp.tokens.scopeRead' => 'Lectura',
			'mcp.form.submitTo' => ({required Object provider}) => 'Añadir servidor a ${provider}',
			'mcp.form.scope.userAllProviders' => 'Usuario (todos los proveedores)',
			'mcp.form.scope.claudeLocal' => 'Claude local',
			'mcp.form.scope.projectAllProviders' => 'Proyecto (todos los proveedores)',
			'mcp.form.scope.description.userGlobal' => 'Escribe en la configuración de usuario de cada proveedor y está disponible en todos los proyectos de esta máquina',
			'mcp.form.scope.description.user' => 'Disponible en todos los proyectos de tu máquina',
			'mcp.form.scope.description.local' => 'Se guarda en los ajustes de usuario de Claude para el proyecto seleccionado',
			'mcp.form.scope.description.projectGlobal' => 'Escribe en el espacio de trabajo del proyecto seleccionado para todos los proveedores',
			'mcp.form.scope.description.project' => 'Se guarda en el espacio de trabajo del proyecto seleccionado',
			'mcp.form.fields.workingDirectory' => 'Directorio de trabajo',
			'mcp.form.fields.envVarNames' => 'Nombres de variables de entorno',
			'mcp.form.fields.bearerTokenEnvVar' => 'Variable de entorno del token Bearer',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'Añadir servidor MCP solo admite stdio y http en todos los proveedores, no ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} no admite servidores MCP de tipo ${type}',
			'mcp.form.validation.jsonMustBeObject' => 'La configuración JSON debe ser un objeto',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.registrationRejected' => 'El servidor rechazó el registro',
			'notifications.errors.noResponse' => 'Sin respuesta del servidor',
			'notifications.androidChannel.name' => 'Alertas de DDAgent',
			'notifications.androidChannel.description' => 'Notificaciones de ejecuciones de agentes, aprobaciones y errores',
			'onboarding.gitHint' => 'Se usa para los commits creados por sesiones de DDAgent.',
			'onboarding.completeSetup' => 'Completar configuración',
			'onboarding.errors.nameAndEmailRequired' => 'Se requieren tanto el nombre como el correo de git.',
			'onboarding.errors.invalidEmail' => 'Introduce una dirección de correo electrónico válida.',
			'onboarding.agents.title' => 'Conecta tus agentes de IA',
			'onboarding.agents.description' => 'Inicia sesión en uno o más asistentes de programación con IA. Todos son opcionales.',
			'onboarding.agents.laterHint' => 'Puedes configurarlos más tarde en Ajustes.',
			'onboarding.mcp.title' => 'Conecta los agentes con DDAgent',
			'onboarding.mcp.description' => 'Instala el servidor MCP de DDAgent para que tus agentes puedan usar la base de conocimiento y las herramientas de DDAgent. Elige agentes o instala para todos.',
			'onboarding.mcp.installSelected' => 'Instalar seleccionados',
			'onboarding.mcp.installForAll' => 'Instalar para todos',
			'onboarding.mcp.laterHint' => 'Opcional: también puedes instalarlo más tarde en Ajustes → MCP.',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Instalado en ${count} agente.', other: 'Instalado en ${count} agentes.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Instalado en ${installedCount}; falló: ${failed}',
			'projects.cloneRepository' => 'Clonar repositorio',
			'projects.repositoryCloned' => 'Repositorio clonado',
			'projects.clone' => 'Clonar',
			'projects.cloneFinished' => 'Clonación completada. Actualizando la lista de proyectos…',
			'projects.cloneFailed' => 'La clonación falló',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.destinationPath' => 'Ruta de destino',
			'projects.destinationPathRequired' => 'La ruta de destino es obligatoria',
			'projects.repositoryUrlRequired' => 'La URL del repositorio es obligatoria',
			'projects.githubTokenOptional' => 'Token de GitHub (opcional)',
			'projects.archive' => 'Archivar',
			'projects.restore' => 'Restaurar',
			'projects.deletePermanently' => 'Eliminar permanentemente',
			'projects.deleteProjectTitle' => '¿Eliminar el proyecto?',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Elimina permanentemente «${name}», incluidas todas las sesiones y el historial almacenado (borrado de JSONL). Esta acción no se puede deshacer.',
			'projects.archivedSection' => ({required Object count}) => 'Archivados (${count})',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} sesión', other: '${count} sesiones', ), 
			'projects.newer' => 'Más reciente',
			'projects.older' => 'Más antiguo',
			'projects.projectArchived' => 'Proyecto archivado',
			'projects.projectRestored' => 'Proyecto restaurado',
			'projects.projectRenamed' => 'Proyecto renombrado',
			'projects.projectDeleted' => 'Proyecto eliminado',
			'projects.failedToLoadTokens' => 'No se pudieron cargar los tokens de GitHub',
			'projects.displayNameOptional' => 'Nombre para mostrar (opcional)',
			'projects.usingStoredToken' => ({required Object name}) => 'Usando el token guardado: ${name}',
			'projects.unknown' => 'Desconocido',
			'projects.project' => 'Proyecto',
			'quota.section.config' => 'Configuración',
			'quota.overview.tokensAndCost' => 'Tokens y costo',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.config.pollerTitle' => 'Sondeo y alertas',
			'quota.config.accountRouting' => 'Enrutamiento de cuentas',
			'quota.config.save' => 'Guardar configuración',
			'quota.chart.show' => 'Mostrar',
			'quota.chart.hide' => 'Ocultar',
			'quota.chart.noData' => 'No hay datos suficientes para una tendencia.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokens · ${cost}',
			'quota.duration.minutes' => ({required Object minutes}) => '${minutes} min',
			'quota.duration.hoursMinutes' => ({required Object hours, required Object minutes}) => '${hours} h ${minutes} min',
			'quota.duration.daysHours' => ({required Object days, required Object hours}) => '${days} d ${hours} h',
			'quota.duration.now' => 'ahora',
			'scheduler.newLabel' => 'Nueva',
			'scheduler.runs' => 'Ejecuciones',
			'scheduler.editTitle' => 'Editar programación',
			'scheduler.deleteTitle' => '¿Eliminar la programación?',
			'scheduler.deleteMessage' => ({required Object id}) => 'Esto elimina el trabajo recurrente ${id}. Las sesiones existentes se conservan.',
			'scheduler.checking' => 'Comprobando…',
			'scheduler.nextIn' => ({required Object time}) => 'próximo en ${time}',
			'scheduler.worktree' => 'worktree',
			'scheduler.session' => ({required Object id}) => 'sesión ${id}',
			'scheduler.cronHint' => 'Cron (min hora día mes día de la semana) — p. ej. 0 9 * * *',
			'scheduler.promptHint' => 'Prompt para el agente',
			'scheduler.runStatus.fired' => 'lanzada',
			'scheduler.runStatus.skipped' => 'omitida',
			'scheduler.runStatus.failed' => 'fallida',
			'scheduler.runStatus.completed' => 'completada',
			'scheduler.cronErrors.fieldCount' => ({required Object got}) => 'Se esperaban 5 campos, se recibieron ${got}',
			'scheduler.cronErrors.fieldError' => ({required Object index, required Object error}) => 'Campo ${index}: ${error}',
			'scheduler.cronErrors.empty' => 'vacío',
			'scheduler.cronErrors.invalidPart' => ({required Object part}) => '«${part}» no válido',
			'scheduler.cronErrors.invalidValue' => ({required Object value}) => 'valor no válido «${value}»',
			'serverConnect.subtitle' => 'Conéctate a tu servidor de DDAgent',
			'serverConnect.enterUrl' => 'Introduce una URL de servidor',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Falló la conexión (${error})',
			'serverConnect.connect' => 'Conectar',
			'serverConnect.connecting' => 'Conectando…',
			'serverConnect.changeServer' => 'Cambiar servidor',
			'serverConnect.local.title' => 'Este dispositivo',
			'serverConnect.local.subtitle' => 'Ejecuta el servidor DDAgent en esta máquina',
			'serverConnect.local.install' => 'Instalar servidor local',
			'serverConnect.local.start' => 'Iniciar servidor local',
			'serverConnect.local.stop' => 'Detener',
			'serverConnect.local.starting' => 'Iniciando el servidor local…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Descargando el servidor… ${percent}%',
			'serverConnect.local.installing' => 'Instalando…',
			'serverConnect.local.running' => ({required Object url}) => 'En ejecución en ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Instalado (v${version})',
			'serverConnect.local.connect' => 'Usar este servidor',
			'serverConnect.local.error' => ({required Object error}) => 'Error del servidor local: ${error}',
			'serverConnect.local.or' => 'o conecta un servidor remoto',
			'serverConnect.local.errors.releaseTagUnresolved' => 'No se pudo determinar la etiqueta de la última versión de DDAgent.',
			'serverConnect.local.errors.unsupportedPlatform' => 'El servidor local no es compatible con esta plataforma.',
			'serverConnect.local.errors.unsupportedPlatformDetail' => ({required Object platform}) => 'El servidor local no es compatible con esta plataforma (${platform}).',
			'serverConnect.local.errors.nodeExtractionFailed' => ({required Object path}) => 'La extracción de Node.js no generó ${path}',
			'serverConnect.local.errors.downloadFailed' => ({required Object error}) => 'Error al descargar el servidor: ${error}',
			'serverConnect.local.errors.installFailed' => ({required Object error}) => 'Error al instalar el servidor: ${error}',
			'serverConnect.local.errors.bundleNotInstalled' => 'El paquete del servidor no está instalado.',
			'serverConnect.local.errors.spawnFailed' => ({required Object error}) => 'No se pudo iniciar el servidor local: ${error}',
			'serverConnect.local.errors.portInUse' => ({required Object port}) => 'El puerto ${port} ya está en uso por otra aplicación.',
			'serverConnect.local.errors.exitedDuringStartup' => 'El servidor local se cerró durante el inicio.',
			'serverConnect.local.errors.exitedDuringStartupWithOutput' => ({required Object output}) => 'El servidor local se cerró durante el inicio: ${output}',
			'serverConnect.local.errors.startTimeout' => 'Se agotó el tiempo de espera para iniciar el servidor local.',
			'serverConnect.local.errors.tarFailed' => ({required Object command, required Object code, required Object output}) => '${command} falló (código ${code}): ${output}',
			'serverConnect.httpStatus' => ({required Object code}) => 'HTTP ${code}',
			'serverConnect.networkError' => 'Error de red',
			'sessions.noSessions' => 'No hay sesiones',
			'sessions.noRecentSessions' => 'No hay sesiones recientes',
			'sessions.archivedSessions' => 'Sesiones archivadas',
			'sessions.rename' => 'Renombrar',
			'sessions.archive' => 'Archivar',
			'sessions.compareWith' => 'Comparar con…',
			'sessions.projectPath' => 'Ruta del proyecto',
			'sessions.newSessionProvider' => 'Nueva sesión — proveedor',
			'sessions.autoOrchestrator' => 'Automático (orquestador)',
			'sessions.createFailed' => ({required Object error}) => 'No se pudo crear la sesión: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Elimina «${name}» y su transcripción. Esta acción no se puede deshacer.',
			'sessions.toasts.archived' => 'Sesión archivada',
			'sessions.toasts.restored' => 'Sesión restaurada',
			'sessions.toasts.deleted' => 'Sesión eliminada',
			'sessions.toasts.renamed' => 'Sesión renombrada',
			'sessions.toasts.pinned' => 'Sesión fijada',
			'sessions.toasts.unpinned' => 'Sesión desfijada',
			'sessions.toasts.workspaceChanged' => 'Espacio de trabajo cambiado',
			'sessions.age.lessThanMinute' => '<1 min',
			'sessions.age.minutes' => ({required Object count}) => '${count} min',
			'sessions.age.hours' => ({required Object hours}) => '${hours} h',
			'sessions.age.days' => ({required Object days}) => '${days} d',
			'sessions.activity.subagentRunning' => 'Subagente en ejecución',
			'sessions.activity.readingFile' => ({required Object file}) => 'Leyendo ${file}',
			'sessions.activity.runningTool' => ({required Object name}) => 'Ejecutando ${name}',
			'sessions.activity.editingFile' => ({required Object file}) => 'Editando ${file}',
			'sessions.activity.editingFileGeneric' => 'Editando un archivo',
			'sessions.activity.runningShellCommand' => 'Ejecutando un comando de shell',
			'sessions.activity.runningCommand' => ({required Object command}) => 'Ejecutando `${command}`',
			'sessions.activity.committingChanges' => 'Confirmando cambios',
			'sessions.activity.pushingBranch' => 'Enviando la rama',
			'sessions.activity.fetchingUrl' => ({required Object url}) => 'Obteniendo ${url}',
			'sessions.activity.searching' => ({required Object query}) => 'Buscando «${query}»',
			'sessions.autoMini' => 'Automático (mini)',
			'sharedContext.title' => 'Notas compartidas',
			'skills.moveSkill' => ({required Object name}) => 'Mover ${name}',
			'skills.deleteSkill' => ({required Object name}) => 'Eliminar ${name}',
			'skills.projectLabel' => 'Proyecto',
			'skills.addDialog.title' => ({required Object provider}) => 'Añadir Skill de ${provider}',
			'skills.addDialog.chooseFileTitle' => 'Elegir SKILL.md',
			'skills.addDialog.chooseFolderTitle' => 'Elegir una carpeta de skills',
			'skills.addDialog.uploadHint' => 'Sube un archivo SKILL.md o una carpeta de skills completa.',
			'skills.addDialog.pickTitle' => 'Elige una carpeta de skills o SKILL.md',
			'skills.addDialog.pickHint' => 'Las carpetas pueden incluir scripts, referencias y recursos.',
			'skills.addDialog.chooseFiles' => 'Elegir archivos',
			'skills.addDialog.chooseFolder' => 'Elegir carpeta',
			'skills.addDialog.readyToInstall' => 'Listo para instalar',
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Archivo Markdown · ${size}',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} archivo · ${size}', other: '${count} archivos · ${size}', ), 
			'skills.addDialog.removeQueued' => ({required Object name}) => 'Quitar ${name}',
			'skills.addDialog.whereWillThisInstall' => '¿Dónde se instalará esto?',
			'skills.addDialog.hideInstallLocation' => 'Ocultar ubicación de instalación',
			'skills.addDialog.folderUploadsNote' => 'Las carpetas subidas conservan el nombre de la carpeta seleccionada; los archivos sueltos usan el `name` de `SKILL.md`.',
			'skills.addDialog.installSkill' => 'Instalar Skill',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Instalar ${count} Skill', other: 'Instalar ${count} Skills', ), 
			'skills.moveDialog.toProjectHint' => 'Elige el proyecto al que debe pertenecer esta skill. Saldrá del directorio global de skills del proveedor.',
			'skills.moveDialog.toGlobalHint' => 'Mueve esta skill al directorio global de skills para que todos los proyectos puedan usarla.',
			'skills.moveDialog.moveToProject' => 'Mover a proyecto',
			'skills.moveDialog.moveToGlobal' => 'Mover a global',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Gestiona las skills de ${provider} desde archivos locales, carpetas completas y ubicaciones por proyecto.',
			'skills.screen.searchHint' => 'Buscar skills…',
			'skills.screen.clearSearch' => 'Limpiar búsqueda de skills',
			'skills.screen.addSkill' => 'Añadir Skill',
			'skills.screen.scanningProjectSkills' => 'Escaneando skills del proyecto…',
			'skills.screen.savedSuccessfully' => 'Skills guardadas correctamente.',
			'skills.screen.loadingSkills' => ({required Object provider}) => 'Cargando skills de ${provider}…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: '${count} SKILL', other: '${count} SKILLS', ), 
			'skills.screen.deleteTitle' => ({required Object name}) => '¿Eliminar ${name}?',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Esto elimina el directorio ${directory} del directorio de skills gestionadas de ${provider}. Esta acción no se puede deshacer.',
			'skills.screen.noDescription' => 'No se ha proporcionado descripción en el front matter de la skill.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Plugin: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Proyecto: ${name}',
			'skills.screen.sourceLabel' => 'ORIGEN',
			'skills.empty.noProjects' => 'No hay proyectos disponibles',
			'skills.empty.noProjectsDescription' => 'Añade un proyecto o espacio de trabajo para explorar sus skills.',
			'skills.empty.noSkillsInProject' => 'No hay skills en este proyecto',
			'skills.empty.noSkillsInProjectDescription' => 'Crea una carpeta .claude/skills, .cursor/skills o .agents/skills en el proyecto seleccionado.',
			'skills.empty.noGlobalSkills' => 'Aún no se han detectado skills globales',
			'skills.empty.noGlobalSkillsDescription' => 'Añade una skill global arriba para que esté disponible en todos los proyectos.',
			'skills.empty.noMatchingSkills' => 'No hay skills coincidentes',
			'skills.empty.noMatchingSkillsDescription' => 'Prueba con otro comando, nombre, ámbito, proyecto o ruta de origen.',
			'skills.scopes.user' => 'Usuario',
			'skills.scopes.plugin' => 'Plugin',
			'skills.scopes.repo' => 'Repositorio',
			'skills.scopes.project' => 'Proyecto',
			'skills.scopes.admin' => 'Admin',
			'skills.scopes.system' => 'Sistema',
			'skills.errors.dropMarkdownOrFolder' => 'Suelta uno o más archivos markdown o una carpeta que contenga SKILL.md.',
			'skills.errors.addMarkdownFirst' => 'Añade primero uno o más archivos markdown.',
			'skills.errors.importFailed' => 'No se pudieron importar las skills',
			'skills.errors.folderReadFailed' => 'No se pudo leer la carpeta de skills',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Una carpeta de skills puede contener hasta ${count} archivos.',
			'skills.errors.folderSizeLimit' => 'Las carpetas de skills seleccionadas deben ocupar menos de 30 MB en total.',
			'skills.errors.missingSkillFile' => 'La carpeta seleccionada no contiene un archivo SKILL.md.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'No se pudo leer SKILL.md desde ${name}.',
			'skills.providerShared' => 'Compartidas',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'terminal.tabs.plainShell' => 'Shell simple',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Inicio de sesión: ${provider}',
			'terminal.tabs.runTitle' => ({required Object command}) => 'Ejecutar: ${command}',
			'terminal.actions.newTab' => 'Nueva pestaña de terminal',
			'terminal.actions.providerLogin' => 'Inicio de sesión del proveedor',
			'terminal.actions.restartSession' => 'Reiniciar sesión',
			'terminal.actions.clearOutput' => 'Limpiar salida',
			'terminal.actions.newShell' => 'Shell nueva',
			'terminal.actions.connect' => 'Conectar',
			'terminal.authUrl.openInBrowser' => 'Abrir en el navegador',
			'terminal.authUrl.linkLabel' => ({required Object url}) => 'Enlace de autenticación: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'Archivo detectado: ${path}',
			'terminal.shortcuts.interrupt' => 'Interrumpir (SIGINT)',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.suspend' => 'Suspender (SIGTSTP)',
			'terminal.shortcuts.hide' => 'Ocultar barra de atajos',
			'terminal.shortcuts.showTooltip' => 'Mostrar atajos',
			'terminal.shortcuts.hideTooltip' => 'Ocultar atajos',
			'terminal.paste.title' => 'Pegar en la terminal',
			'terminal.paste.hint' => 'Ctrl+V / clic derecho → Pegar',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'No se pudo abrir el enlace: ${url}',
			'terminal.errors.frameError' => ({required Object message}) => '[Error] ${message}',
			'terminal.errors.connectionError' => ({required Object message}) => '[Error de conexión] ${message}',
			'terminal.loginDialog.title' => ({required Object provider}) => 'Inicio de sesión en ${provider} CLI',
			'terminal.loginDialog.exited' => ({required Object code}) => 'Finalizado (${code})',
			'terminal.loginDialog.authLinkDetected' => 'Enlace de autenticación detectado',
			'terminal.empty.title' => 'No hay terminal activa',
			'terminal.empty.description' => 'Crea una pestaña nueva para empezar',
			'terminal.overlay.processExited' => 'El proceso ha finalizado: conéctate para iniciarlo de nuevo',
			'terminal.overlay.processExitedWithCode' => ({required Object code}) => 'El proceso ha finalizado (código ${code}): conéctate para iniciarlo de nuevo',
			'terminal.overlay.resumeSession' => ({required Object title}) => 'Reanudar la sesión ${title}',
			'terminal.overlay.startSession' => ({required Object path}) => 'Iniciar una sesión nueva en ${path}',
			'voice.preview' => 'Vista previa',
			_ => null,
		} ?? switch (path) {
			'voice.settingsSaved' => 'Ajustes de entrada de voz guardados',
			'voice.saveFailed' => 'No se pudo guardar la configuración de STT',
			'voice.apiKeySaved' => 'Clave API (guardada; escribe para reemplazar)',
			'workspace.exportChat' => 'Exportar chat',
			'workspace.searchTranscript' => 'Buscar en la transcripción',
			'workspace.previousMatch' => 'Coincidencia anterior',
			'workspace.nextMatch' => 'Coincidencia siguiente',
			'workspace.closeSearch' => 'Cerrar búsqueda',
			'workspace.newChatProvider' => 'Nuevo chat — proveedor',
			'workspace.closePane' => 'Cerrar panel',
			'workspace.jumpToSession' => 'Ir a la sesión…',
			'workspace.archivedWorkspaceName' => 'Archivado',
			'workspace.sendTo' => ({required Object count}) => 'Enviar a ${count}',
			'workspace.deleteSessionNotice' => 'Elimina la sesión y su transcripción. No se puede deshacer.',
			'workspace.accountWithLabel' => ({required Object label}) => 'Predeterminado · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Finaliza la ejecución antes de cambiar de espacio de trabajo',
			'workspace.restored' => 'Espacio de trabajo restaurado',
			'workspace.maximizePane' => 'Maximizar panel',
			'workspace.restorePanes' => 'Restaurar paneles',
			'workspace.reviewChangedFiles' => 'Revisar archivos modificados',
			'workspace.paneTitle.chat' => 'Chat',
			'workspace.paneTitle.browser' => 'Navegador',
			'workspace.paneTitle.terminal' => 'Terminal',
			'workspace.paneTitle.notes' => 'Notas compartidas',
			'workspace.paneTitle.editor' => 'Editor',
			'workspace.paneTitle.git' => 'Git',
			'workspace.addEditorPane' => 'Añadir panel de editor',
			'workspace.addGitPane' => 'Añadir panel de Git',
			'workspace.unknownProjectPath' => 'Ruta del proyecto desconocida',
			'workspace.autoMini' => 'Auto (mini)',
			'workspace.exportAs' => 'Exportar como:',
			'workspace.exportMarkdown' => 'Markdown (.md)',
			'workspace.exportHtml' => 'Página web (.html)',
			'workspace.exportPdf' => 'PDF (Imprimir en archivo)',
			'workspace.matchPosition' => ({required Object current, required Object total}) => '${current} de ${total}',
			'workspace.launcherDescription' => 'Elige un espacio de trabajo para este panel o crea uno nuevo.',
			'workspace.createWorkspace' => 'Crear espacio de trabajo',
			'worktrees.scripts' => 'Scripts',
			'worktrees.emptyTitle' => 'No se encontraron worktrees',
			'worktrees.emptyDescription' => 'Crea un worktree para aislar el trabajo de una funcionalidad o las ejecuciones de agentes.',
			'worktrees.opened' => ({required Object branch}) => 'Worktree abierto: ${branch}',
			'worktrees.created' => 'Worktree creado',
			'worktrees.removed' => 'Worktree eliminado',
			'worktrees.merged' => ({required Object branch}) => 'Worktree fusionado en ${branch}',
			'worktrees.scriptsSaved' => 'Configuración de scripts guardada',
			'worktrees.setupLabel' => 'Configuración: ',
			'worktrees.serverLabel' => 'Servidor: ',
			'worktrees.runRunning' => 'en ejecución',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'en ejecución :${port}',
			'worktrees.runButton' => 'Ejecutar',
			'worktrees.stopButton' => 'Detener',
			'worktrees.mainBadge' => 'main',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD separado en ${sha}',
			'worktrees.branchHint' => 'Nombre de la nueva rama (p. ej. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Ramificando desde ${branch}',
			'worktrees.mergeTitle' => ({required Object branch}) => 'Fusionar ${branch}',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Fusionar los cambios en ${branch}.',
			'worktrees.squashDescription' => 'Combinar todos los commits en un solo commit',
			'worktrees.cleanupDescription' => 'Eliminar el worktree y borrar la rama una vez fusionada',
			'worktrees.removeTitle' => ({required Object branch}) => '¿Eliminar el worktree ${branch}?',
			'worktrees.removeDescription' => 'Esto elimina la carpeta del worktree. Los proyectos vinculados se archivarán.',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Advertencia: este worktree tiene ${count} cambios sin confirmar que se perderán.',
			'worktrees.forceRemoveLabel' => 'Forzar eliminación (descartar cambios)',
			'worktrees.deleteBranchLabel' => 'Eliminar también la rama',
			'worktrees.setupHint' => 'Comando de configuración (p. ej. npm install)',
			'worktrees.runHint' => 'Comando de ejecución (p. ej. npm run dev)',
			'worktrees.portHint' => 'Puerto de ejecución (opcional, p. ej. 3000)',
			'worktrees.unknownSha' => 'desconocido',
			'worktrees.baseBranchFallback' => 'rama base',
			'worktrees.runtimeStatus.idle' => 'inactivo',
			'worktrees.runtimeStatus.running' => 'en ejecución',
			'worktrees.runtimeStatus.done' => 'listo',
			'worktrees.runtimeStatus.failed' => 'fallido',
			'worktrees.runtimeStatus.exited' => 'finalizado',
			'browserUse.sessionStatus.ready' => 'Lista',
			'browserUse.sessionStatus.stopped' => 'Detenida',
			'browserUse.sessionStatus.unavailable' => 'No disponible',
			'orchestrator.stepFallback' => ({required Object n}) => 'Paso ${n}',
			'miniOrchestrator.taskTypes.gate' => 'Puerta',
			'miniOrchestrator.roles.thinker' => 'Pensador',
			'miniOrchestrator.roles.worker' => 'Ejecutor',
			_ => null,
		};
	}
}
