///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$chat$en chat = Translations$chat$en.internal(_root);
	late final Translations$codeEditor$en codeEditor = Translations$codeEditor$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$sidebar$en sidebar = Translations$sidebar$en.internal(_root);
	late final Translations$tasks$en tasks = Translations$tasks$en.internal(_root);
	late final Translations$knowledge$en knowledge = Translations$knowledge$en.internal(_root);
	late final Translations$browser$en browser = Translations$browser$en.internal(_root);
	late final Translations$collab$en collab = Translations$collab$en.internal(_root);
	late final Translations$fileTree$en fileTree = Translations$fileTree$en.internal(_root);
	late final Translations$git$en git = Translations$git$en.internal(_root);
	late final Translations$kanban$en kanban = Translations$kanban$en.internal(_root);
	late final Translations$mcp$en mcp = Translations$mcp$en.internal(_root);
	late final Translations$notifications$en notifications = Translations$notifications$en.internal(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
	late final Translations$preview$en preview = Translations$preview$en.internal(_root);
	late final Translations$projects$en projects = Translations$projects$en.internal(_root);
	late final Translations$quota$en quota = Translations$quota$en.internal(_root);
	late final Translations$scheduler$en scheduler = Translations$scheduler$en.internal(_root);
	late final Translations$serverConnect$en serverConnect = Translations$serverConnect$en.internal(_root);
	late final Translations$sessions$en sessions = Translations$sessions$en.internal(_root);
	late final Translations$sharedContext$en sharedContext = Translations$sharedContext$en.internal(_root);
	late final Translations$skills$en skills = Translations$skills$en.internal(_root);
	late final Translations$terminal$en terminal = Translations$terminal$en.internal(_root);
	late final Translations$voice$en voice = Translations$voice$en.internal(_root);
	late final Translations$workspace$en workspace = Translations$workspace$en.internal(_root);
	late final Translations$worktrees$en worktrees = Translations$worktrees$en.internal(_root);
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your session expired. Please log in again.'
	String get sessionExpired => 'Your session expired. Please log in again.';

	late final Translations$auth$login$en login = Translations$auth$login$en.internal(_root);
	late final Translations$auth$register$en register = Translations$auth$register$en.internal(_root);
	late final Translations$auth$logout$en logout = Translations$auth$logout$en.internal(_root);
}

// Path: chat
class Translations$chat$en {
	Translations$chat$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$chat$codeBlock$en codeBlock = Translations$chat$codeBlock$en.internal(_root);
	late final Translations$chat$copyMessage$en copyMessage = Translations$chat$copyMessage$en.internal(_root);
	late final Translations$chat$messageTypes$en messageTypes = Translations$chat$messageTypes$en.internal(_root);
	late final Translations$chat$orchestrator$en orchestrator = Translations$chat$orchestrator$en.internal(_root);
	late final Translations$chat$tools$en tools = Translations$chat$tools$en.internal(_root);
	late final Translations$chat$search$en search = Translations$chat$search$en.internal(_root);
	late final Translations$chat$fileOperations$en fileOperations = Translations$chat$fileOperations$en.internal(_root);
	late final Translations$chat$interactive$en interactive = Translations$chat$interactive$en.internal(_root);
	late final Translations$chat$thinking$en thinking = Translations$chat$thinking$en.internal(_root);
	late final Translations$chat$json$en json = Translations$chat$json$en.internal(_root);
	late final Translations$chat$permissions$en permissions = Translations$chat$permissions$en.internal(_root);
	late final Translations$chat$todo$en todo = Translations$chat$todo$en.internal(_root);
	late final Translations$chat$plan$en plan = Translations$chat$plan$en.internal(_root);
	late final Translations$chat$usageLimit$en usageLimit = Translations$chat$usageLimit$en.internal(_root);
	late final Translations$chat$codex$en codex = Translations$chat$codex$en.internal(_root);
	late final Translations$chat$voice$en voice = Translations$chat$voice$en.internal(_root);
	late final Translations$chat$input$en input = Translations$chat$input$en.internal(_root);
	late final Translations$chat$composer$en composer = Translations$chat$composer$en.internal(_root);
	late final Translations$chat$providerSelection$en providerSelection = Translations$chat$providerSelection$en.internal(_root);
	late final Translations$chat$session$en session = Translations$chat$session$en.internal(_root);
	late final Translations$chat$shell$en shell = Translations$chat$shell$en.internal(_root);
	late final Translations$chat$claudeStatus$en claudeStatus = Translations$chat$claudeStatus$en.internal(_root);
	late final Translations$chat$projectSelection$en projectSelection = Translations$chat$projectSelection$en.internal(_root);
	late final Translations$chat$tasks$en tasks = Translations$chat$tasks$en.internal(_root);
	late final Translations$chat$splitSession$en splitSession = Translations$chat$splitSession$en.internal(_root);
	late final Translations$chat$sessionPicker$en sessionPicker = Translations$chat$sessionPicker$en.internal(_root);
	late final Translations$chat$splitWorkspace$en splitWorkspace = Translations$chat$splitWorkspace$en.internal(_root);
	late final Translations$chat$splitOverview$en splitOverview = Translations$chat$splitOverview$en.internal(_root);
	late final Translations$chat$askUserQuestion$en askUserQuestion = Translations$chat$askUserQuestion$en.internal(_root);
	late final Translations$chat$attachments$en attachments = Translations$chat$attachments$en.internal(_root);
	late final Translations$chat$checkpoint$en checkpoint = Translations$chat$checkpoint$en.internal(_root);
	late final Translations$chat$common$en common = Translations$chat$common$en.internal(_root);
	late final Translations$chat$taskMaster$en taskMaster = Translations$chat$taskMaster$en.internal(_root);
	late final Translations$chat$tokenUsage$en tokenUsage = Translations$chat$tokenUsage$en.internal(_root);
	late final Translations$chat$tool$en tool = Translations$chat$tool$en.internal(_root);
	late final Translations$chat$quotaBadge$en quotaBadge = Translations$chat$quotaBadge$en.internal(_root);
	late final Translations$chat$broadcast$en broadcast = Translations$chat$broadcast$en.internal(_root);
	late final Translations$chat$paneHeader$en paneHeader = Translations$chat$paneHeader$en.internal(_root);
	late final Translations$chat$export$en export = Translations$chat$export$en.internal(_root);
	late final Translations$chat$commandResult$en commandResult = Translations$chat$commandResult$en.internal(_root);
	late final Translations$chat$commands$en commands = Translations$chat$commands$en.internal(_root);
	late final Translations$chat$pinFile$en pinFile = Translations$chat$pinFile$en.internal(_root);
	late final Translations$chat$modelLibrary$en modelLibrary = Translations$chat$modelLibrary$en.internal(_root);
	late final Translations$chat$changes$en changes = Translations$chat$changes$en.internal(_root);
	late final Translations$chat$message$en message = Translations$chat$message$en.internal(_root);
	late final Translations$chat$permissionRequest$en permissionRequest = Translations$chat$permissionRequest$en.internal(_root);
}

// Path: codeEditor
class Translations$codeEditor$en {
	Translations$codeEditor$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$codeEditor$toolbar$en toolbar = Translations$codeEditor$toolbar$en.internal(_root);

	/// en: 'Loading {{fileName}}...'
	String loading({required Object fileName}) => 'Loading ${fileName}...';

	late final Translations$codeEditor$header$en header = Translations$codeEditor$header$en.internal(_root);
	late final Translations$codeEditor$actions$en actions = Translations$codeEditor$actions$en.internal(_root);
	late final Translations$codeEditor$footer$en footer = Translations$codeEditor$footer$en.internal(_root);
	late final Translations$codeEditor$binaryFile$en binaryFile = Translations$codeEditor$binaryFile$en.internal(_root);
	late final Translations$codeEditor$filePreview$en filePreview = Translations$codeEditor$filePreview$en.internal(_root);

	/// en: 'Unsaved changes in {{name}}'
	String unsavedChanges({required Object name}) => 'Unsaved changes in ${name}';

	/// en: 'Discard unsaved changes?'
	String get discardUnsavedChanges => 'Discard unsaved changes?';

	late final Translations$codeEditor$mediaFile$en mediaFile = Translations$codeEditor$mediaFile$en.internal(_root);

	/// en: 'Failed to load file'
	String get failedToLoad => 'Failed to load file';

	late final Translations$codeEditor$hexDump$en hexDump = Translations$codeEditor$hexDump$en.internal(_root);
	late final Translations$codeEditor$settings$en settings = Translations$codeEditor$settings$en.internal(_root);
	late final Translations$codeEditor$diff$en diff = Translations$codeEditor$diff$en.internal(_root);
	late final Translations$codeEditor$emptyState$en emptyState = Translations$codeEditor$emptyState$en.internal(_root);
	late final Translations$codeEditor$toasts$en toasts = Translations$codeEditor$toasts$en.internal(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$common$buttons$en buttons = Translations$common$buttons$en.internal(_root);
	late final Translations$common$tabs$en tabs = Translations$common$tabs$en.internal(_root);
	late final Translations$common$quota$en quota = Translations$common$quota$en.internal(_root);
	late final Translations$common$status$en status = Translations$common$status$en.internal(_root);
	late final Translations$common$messages$en messages = Translations$common$messages$en.internal(_root);
	late final Translations$common$navigation$en navigation = Translations$common$navigation$en.internal(_root);
	late final Translations$common$common$en common = Translations$common$common$en.internal(_root);
	late final Translations$common$time$en time = Translations$common$time$en.internal(_root);
	late final Translations$common$fileOperations$en fileOperations = Translations$common$fileOperations$en.internal(_root);
	late final Translations$common$mainContent$en mainContent = Translations$common$mainContent$en.internal(_root);
	late final Translations$common$fileTree$en fileTree = Translations$common$fileTree$en.internal(_root);
	late final Translations$common$projectWizard$en projectWizard = Translations$common$projectWizard$en.internal(_root);
	late final Translations$common$notifications$en notifications = Translations$common$notifications$en.internal(_root);
	late final Translations$common$versionUpdate$en versionUpdate = Translations$common$versionUpdate$en.internal(_root);
	late final Translations$common$actions$en actions = Translations$common$actions$en.internal(_root);
	late final Translations$common$browserPane$en browserPane = Translations$common$browserPane$en.internal(_root);
	late final Translations$common$browserUse$en browserUse = Translations$common$browserUse$en.internal(_root);
	late final Translations$common$commandPalette$en commandPalette = Translations$common$commandPalette$en.internal(_root);
	late final Translations$common$gitPanel$en gitPanel = Translations$common$gitPanel$en.internal(_root);
	late final Translations$common$sessions$en sessions = Translations$common$sessions$en.internal(_root);
	late final Translations$common$projects$en projects = Translations$common$projects$en.internal(_root);
	late final Translations$common$previewPane$en previewPane = Translations$common$previewPane$en.internal(_root);
	late final Translations$common$sharedNotes$en sharedNotes = Translations$common$sharedNotes$en.internal(_root);
	late final Translations$common$codeBlock$en codeBlock = Translations$common$codeBlock$en.internal(_root);
	late final Translations$common$update$en update = Translations$common$update$en.internal(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	late final Translations$settings$changelog$en changelog = Translations$settings$changelog$en.internal(_root);
	late final Translations$settings$server$en server = Translations$settings$server$en.internal(_root);
	late final Translations$settings$updates$en updates = Translations$settings$updates$en.internal(_root);
	late final Translations$settings$tabs$en tabs = Translations$settings$tabs$en.internal(_root);
	late final Translations$settings$account$en account = Translations$settings$account$en.internal(_root);
	late final Translations$settings$mcp$en mcp = Translations$settings$mcp$en.internal(_root);
	late final Translations$settings$appearance$en appearance = Translations$settings$appearance$en.internal(_root);
	late final Translations$settings$actions$en actions = Translations$settings$actions$en.internal(_root);
	late final Translations$settings$quickSettings$en quickSettings = Translations$settings$quickSettings$en.internal(_root);
	late final Translations$settings$terminalShortcuts$en terminalShortcuts = Translations$settings$terminalShortcuts$en.internal(_root);
	late final Translations$settings$mainTabs$en mainTabs = Translations$settings$mainTabs$en.internal(_root);
	late final Translations$settings$miniOrchestration$en miniOrchestration = Translations$settings$miniOrchestration$en.internal(_root);
	late final Translations$settings$orchestration$en orchestration = Translations$settings$orchestration$en.internal(_root);
	late final Translations$settings$notifications$en notifications = Translations$settings$notifications$en.internal(_root);
	late final Translations$settings$appearanceSettings$en appearanceSettings = Translations$settings$appearanceSettings$en.internal(_root);
	late final Translations$settings$mcpForm$en mcpForm = Translations$settings$mcpForm$en.internal(_root);
	late final Translations$settings$saveStatus$en saveStatus = Translations$settings$saveStatus$en.internal(_root);
	late final Translations$settings$footerActions$en footerActions = Translations$settings$footerActions$en.internal(_root);
	late final Translations$settings$git$en git = Translations$settings$git$en.internal(_root);
	late final Translations$settings$apiKeys$en apiKeys = Translations$settings$apiKeys$en.internal(_root);
	late final Translations$settings$tasks$en tasks = Translations$settings$tasks$en.internal(_root);
	late final Translations$settings$agents$en agents = Translations$settings$agents$en.internal(_root);
	late final Translations$settings$permissions$en permissions = Translations$settings$permissions$en.internal(_root);
	late final Translations$settings$mcpServers$en mcpServers = Translations$settings$mcpServers$en.internal(_root);
	late final Translations$settings$quota$en quota = Translations$settings$quota$en.internal(_root);
	late final Translations$settings$browser$en browser = Translations$settings$browser$en.internal(_root);
	late final Translations$settings$workspaces$en workspaces = Translations$settings$workspaces$en.internal(_root);
	late final Translations$settings$stt$en stt = Translations$settings$stt$en.internal(_root);
	late final Translations$settings$schedules$en schedules = Translations$settings$schedules$en.internal(_root);
	late final Translations$settings$mcpTokens$en mcpTokens = Translations$settings$mcpTokens$en.internal(_root);
	late final Translations$settings$about$en about = Translations$settings$about$en.internal(_root);
	late final Translations$settings$shortcuts$en shortcuts = Translations$settings$shortcuts$en.internal(_root);
}

// Path: sidebar
class Translations$sidebar$en {
	Translations$sidebar$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$sidebar$projects$en projects = Translations$sidebar$projects$en.internal(_root);
	late final Translations$sidebar$app$en app = Translations$sidebar$app$en.internal(_root);
	late final Translations$sidebar$panel$en panel = Translations$sidebar$panel$en.internal(_root);
	late final Translations$sidebar$sessions$en sessions = Translations$sidebar$sessions$en.internal(_root);
	late final Translations$sidebar$tooltips$en tooltips = Translations$sidebar$tooltips$en.internal(_root);
	late final Translations$sidebar$navigation$en navigation = Translations$sidebar$navigation$en.internal(_root);
	late final Translations$sidebar$actions$en actions = Translations$sidebar$actions$en.internal(_root);
	late final Translations$sidebar$workspace$en workspace = Translations$sidebar$workspace$en.internal(_root);
	late final Translations$sidebar$branding$en branding = Translations$sidebar$branding$en.internal(_root);
	late final Translations$sidebar$status$en status = Translations$sidebar$status$en.internal(_root);
	late final Translations$sidebar$time$en time = Translations$sidebar$time$en.internal(_root);
	late final Translations$sidebar$messages$en messages = Translations$sidebar$messages$en.internal(_root);
	late final Translations$sidebar$version$en version = Translations$sidebar$version$en.internal(_root);
	late final Translations$sidebar$search$en search = Translations$sidebar$search$en.internal(_root);
	late final Translations$sidebar$recent$en recent = Translations$sidebar$recent$en.internal(_root);
	late final Translations$sidebar$deleteConfirmation$en deleteConfirmation = Translations$sidebar$deleteConfirmation$en.internal(_root);
	late final Translations$sidebar$zones$en zones = Translations$sidebar$zones$en.internal(_root);
	late final Translations$sidebar$tabs$en tabs = Translations$sidebar$tabs$en.internal(_root);
}

// Path: tasks
class Translations$tasks$en {
	Translations$tasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$tasks$notConfigured$en notConfigured = Translations$tasks$notConfigured$en.internal(_root);
	late final Translations$tasks$gettingStarted$en gettingStarted = Translations$tasks$gettingStarted$en.internal(_root);
	late final Translations$tasks$setupModal$en setupModal = Translations$tasks$setupModal$en.internal(_root);
	late final Translations$tasks$helpGuide$en helpGuide = Translations$tasks$helpGuide$en.internal(_root);
	late final Translations$tasks$search$en search = Translations$tasks$search$en.internal(_root);
	late final Translations$tasks$filters$en filters = Translations$tasks$filters$en.internal(_root);
	late final Translations$tasks$sort$en sort = Translations$tasks$sort$en.internal(_root);
	late final Translations$tasks$views$en views = Translations$tasks$views$en.internal(_root);
	late final Translations$tasks$kanban$en kanban = Translations$tasks$kanban$en.internal(_root);
	late final Translations$tasks$buttons$en buttons = Translations$tasks$buttons$en.internal(_root);
	late final Translations$tasks$prd$en prd = Translations$tasks$prd$en.internal(_root);
	late final Translations$tasks$statuses$en statuses = Translations$tasks$statuses$en.internal(_root);
	late final Translations$tasks$priorities$en priorities = Translations$tasks$priorities$en.internal(_root);
	late final Translations$tasks$noMatchingTasks$en noMatchingTasks = Translations$tasks$noMatchingTasks$en.internal(_root);
	late final Translations$tasks$board$en board = Translations$tasks$board$en.internal(_root);
	late final Translations$tasks$card$en card = Translations$tasks$card$en.internal(_root);
	late final Translations$tasks$createTask$en createTask = Translations$tasks$createTask$en.internal(_root);
	late final Translations$tasks$list$en list = Translations$tasks$list$en.internal(_root);
	late final Translations$tasks$nextTask$en nextTask = Translations$tasks$nextTask$en.internal(_root);
	late final Translations$tasks$taskDetail$en taskDetail = Translations$tasks$taskDetail$en.internal(_root);
	late final Translations$tasks$toasts$en toasts = Translations$tasks$toasts$en.internal(_root);
}

// Path: knowledge
class Translations$knowledge$en {
	Translations$knowledge$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Knowledge'
	String get title => 'Knowledge';

	late final Translations$knowledge$tabs$en tabs = Translations$knowledge$tabs$en.internal(_root);
	late final Translations$knowledge$common$en common = Translations$knowledge$common$en.internal(_root);
	late final Translations$knowledge$actions$en actions = Translations$knowledge$actions$en.internal(_root);
	late final Translations$knowledge$dialog$en dialog = Translations$knowledge$dialog$en.internal(_root);
	late final Translations$knowledge$fields$en fields = Translations$knowledge$fields$en.internal(_root);
	late final Translations$knowledge$dashboard$en dashboard = Translations$knowledge$dashboard$en.internal(_root);
	late final Translations$knowledge$empty$en empty = Translations$knowledge$empty$en.internal(_root);
	late final Translations$knowledge$history$en history = Translations$knowledge$history$en.internal(_root);
	late final Translations$knowledge$priorities$en priorities = Translations$knowledge$priorities$en.internal(_root);
	late final Translations$knowledge$search$en search = Translations$knowledge$search$en.internal(_root);
	late final Translations$knowledge$links$en links = Translations$knowledge$links$en.internal(_root);
	late final Translations$knowledge$tags$en tags = Translations$knowledge$tags$en.internal(_root);
	late final Translations$knowledge$graph$en graph = Translations$knowledge$graph$en.internal(_root);
	late final Translations$knowledge$importAll$en importAll = Translations$knowledge$importAll$en.internal(_root);
	late final Translations$knowledge$migrate$en migrate = Translations$knowledge$migrate$en.internal(_root);
	late final Translations$knowledge$importSkills$en importSkills = Translations$knowledge$importSkills$en.internal(_root);
	late final Translations$knowledge$critical$en critical = Translations$knowledge$critical$en.internal(_root);
	late final Translations$knowledge$contextBudget$en contextBudget = Translations$knowledge$contextBudget$en.internal(_root);
	late final Translations$knowledge$linkOptions$en linkOptions = Translations$knowledge$linkOptions$en.internal(_root);
	late final Translations$knowledge$errors$en errors = Translations$knowledge$errors$en.internal(_root);
}

// Path: browser
class Translations$browser$en {
	Translations$browser$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agent Browser'
	String get dialogTitle => 'Agent Browser';

	/// en: 'Browser view error'
	String get viewError => 'Browser view error';

	/// en: 'Web'
	String get web => 'Web';
}

// Path: collab
class Translations$collab$en {
	Translations$collab$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Team'
	String get team => 'Team';

	/// en: 'Invite'
	String get invite => 'Invite';

	/// en: 'Invite teammate'
	String get inviteTeammate => 'Invite teammate';

	/// en: 'Share this invite token — it is shown once and expires in 72h:'
	String get shareTokenHint => 'Share this invite token — it is shown once and expires in 72h:';

	/// en: 'Create invite'
	String get createInvite => 'Create invite';

	/// en: 'Copy token'
	String get copyToken => 'Copy token';

	late final Translations$collab$roles$en roles = Translations$collab$roles$en.internal(_root);
}

// Path: fileTree
class Translations$fileTree$en {
	Translations$fileTree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Upload to'
	String get uploadTo => 'Upload to';

	/// en: 'Upload here'
	String get uploadHere => 'Upload here';

	/// en: 'Browse server filesystem'
	String get browseServerFilesystem => 'Browse server filesystem';

	/// en: 'No files'
	String get noFiles => 'No files';

	/// en: 'Copy contents'
	String get copyContents => 'Copy contents';

	/// en: 'Choose folder'
	String get chooseFolder => 'Choose folder';

	late final Translations$fileTree$search$en search = Translations$fileTree$search$en.internal(_root);
	late final Translations$fileTree$titles$en titles = Translations$fileTree$titles$en.internal(_root);

	/// en: 'Uploaded {{count}} file(s)'
	String uploadedCount({required Object count}) => 'Uploaded ${count} file(s)';

	/// en: 'New name'
	String get newName => 'New name';

	/// en: 'Not a registered project: {{path}}'
	String notRegisteredProject({required Object path}) => 'Not a registered project: ${path}';

	/// en: 'Show gitignored files'
	String get showGitignoredFiles => 'Show gitignored files';

	/// en: 'Hide gitignored files'
	String get hideGitignoredFiles => 'Hide gitignored files';

	/// en: 'Download unsupported on web'
	String get downloadUnsupportedOnWeb => 'Download unsupported on web';

	/// en: 'Save to path'
	String get saveToPath => 'Save to path';

	/// en: 'Saved to {{path}}'
	String savedTo({required Object path}) => 'Saved to ${path}';
}

// Path: git
class Translations$git$en {
	Translations$git$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$git$checkpoints$en checkpoints = Translations$git$checkpoints$en.internal(_root);

	/// en: 'Staged Changes'
	String get stagedChanges => 'Staged Changes';

	/// en: 'Staged'
	String get statusStaged => 'Staged';

	/// en: 'Switch branch'
	String get switchBranch => 'Switch branch';

	/// en: 'Unified diff'
	String get unifiedDiff => 'Unified diff';

	/// en: 'Split diff'
	String get splitDiff => 'Split diff';

	/// en: 'No diff available'
	String get noDiff => 'No diff available';

	/// en: 'Large diff preview: rendering is limited to keep the tab responsive.'
	String get largeDiff => 'Large diff preview: rendering is limited to keep the tab responsive.';

	/// en: 'Failed to load diff: {{error}}'
	String loadDiffFailed({required Object error}) => 'Failed to load diff: ${error}';

	/// en: '+ Hunk'
	String get hunkStage => '+ Hunk';

	/// en: '− Hunk'
	String get hunkUnstage => '− Hunk';

	/// en: 'Stage hunk'
	String get stageHunk => 'Stage hunk';

	/// en: 'Unstage hunk'
	String get unstageHunk => 'Unstage hunk';

	/// en: 'Delete file'
	String get deleteFile => 'Delete file';

	/// en: 'Commit message'
	String get commitMessage => 'Commit message';

	/// en: '✦ AI'
	String get aiButton => '✦ AI';

	/// en: 'Commit created'
	String get commitCreated => 'Commit created';

	/// en: 'no branch'
	String get noBranch => 'no branch';

	/// en: 'Select a project'
	String get selectProject => 'Select a project';
}

// Path: kanban
class Translations$kanban$en {
	Translations$kanban$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$kanban$card$en card = Translations$kanban$card$en.internal(_root);
	late final Translations$kanban$comments$en comments = Translations$kanban$comments$en.internal(_root);
	late final Translations$kanban$dialog$en dialog = Translations$kanban$dialog$en.internal(_root);
	late final Translations$kanban$details$en details = Translations$kanban$details$en.internal(_root);
	late final Translations$kanban$empty$en empty = Translations$kanban$empty$en.internal(_root);

	/// en: 'Failed to save card'
	String get saveFailed => 'Failed to save card';

	late final Translations$kanban$time$en time = Translations$kanban$time$en.internal(_root);
}

// Path: mcp
class Translations$mcp$en {
	Translations$mcp$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$mcp$install$en install = Translations$mcp$install$en.internal(_root);
	late final Translations$mcp$servers$en servers = Translations$mcp$servers$en.internal(_root);
	late final Translations$mcp$team$en team = Translations$mcp$team$en.internal(_root);
	late final Translations$mcp$tokens$en tokens = Translations$mcp$tokens$en.internal(_root);
	late final Translations$mcp$form$en form = Translations$mcp$form$en.internal(_root);
}

// Path: notifications
class Translations$notifications$en {
	Translations$notifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ddagent Flutter'
	String get deviceLabel => 'ddagent Flutter';

	late final Translations$notifications$errors$en errors = Translations$notifications$errors$en.internal(_root);
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Used for commits created by ddagent sessions.'
	String get gitHint => 'Used for commits created by ddagent sessions.';

	/// en: 'Complete Setup'
	String get completeSetup => 'Complete Setup';

	late final Translations$onboarding$errors$en errors = Translations$onboarding$errors$en.internal(_root);
	late final Translations$onboarding$agents$en agents = Translations$onboarding$agents$en.internal(_root);
	late final Translations$onboarding$mcp$en mcp = Translations$onboarding$mcp$en.internal(_root);
}

// Path: preview
class Translations$preview$en {
	Translations$preview$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Embedded preview is available on the web build'
	String get embeddedWebOnly => 'Embedded preview is available on the web build';

	/// en: 'Start a dev server (npm run dev, flutter run -d web-server…) and its port appears here.'
	String get startDevServerHint => 'Start a dev server (npm run dev, flutter run -d web-server…)\nand its port appears here.';
}

// Path: projects
class Translations$projects$en {
	Translations$projects$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Clone repository'
	String get cloneRepository => 'Clone repository';

	/// en: 'Repository cloned'
	String get repositoryCloned => 'Repository cloned';

	/// en: 'Clone'
	String get clone => 'Clone';

	/// en: 'Clone finished. Refreshing project list…'
	String get cloneFinished => 'Clone finished. Refreshing project list…';

	/// en: 'Clone failed'
	String get cloneFailed => 'Clone failed';

	/// en: 'https://github.com/org/repo.git'
	String get repoUrlPlaceholder => 'https://github.com/org/repo.git';

	/// en: 'Destination path'
	String get destinationPath => 'Destination path';

	/// en: 'Destination path is required'
	String get destinationPathRequired => 'Destination path is required';

	/// en: 'Repository URL is required'
	String get repositoryUrlRequired => 'Repository URL is required';

	/// en: 'GitHub token (optional)'
	String get githubTokenOptional => 'GitHub token (optional)';

	/// en: 'Archive'
	String get archive => 'Archive';

	/// en: 'Restore'
	String get restore => 'Restore';

	/// en: 'Delete permanently'
	String get deletePermanently => 'Delete permanently';

	/// en: 'Delete project?'
	String get deleteProjectTitle => 'Delete project?';

	/// en: 'Permanently removes "{{name}}" including all sessions and stored history (JSONL wipe). This cannot be undone.'
	String deleteProjectMessage({required Object name}) => 'Permanently removes "${name}" including all sessions and stored history (JSONL wipe). This cannot be undone.';

	/// en: 'Archived ({{count}})'
	String archivedSection({required Object count}) => 'Archived (${count})';

	/// en: '(one) {{{count}} session} (other) {{{count}} sessions}'
	String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} session',
		other: '${count} sessions',
	);

	/// en: 'Newer'
	String get newer => 'Newer';

	/// en: 'Older'
	String get older => 'Older';

	/// en: 'Project archived'
	String get projectArchived => 'Project archived';

	/// en: 'Project restored'
	String get projectRestored => 'Project restored';

	/// en: 'Project renamed'
	String get projectRenamed => 'Project renamed';

	/// en: 'Project deleted'
	String get projectDeleted => 'Project deleted';

	/// en: 'Failed to load GitHub tokens'
	String get failedToLoadTokens => 'Failed to load GitHub tokens';

	/// en: 'Display name (optional)'
	String get displayNameOptional => 'Display name (optional)';

	/// en: 'Using stored token: {{name}}'
	String usingStoredToken({required Object name}) => 'Using stored token: ${name}';

	/// en: 'Unknown'
	String get unknown => 'Unknown';
}

// Path: quota
class Translations$quota$en {
	Translations$quota$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$quota$section$en section = Translations$quota$section$en.internal(_root);
	late final Translations$quota$overview$en overview = Translations$quota$overview$en.internal(_root);
	late final Translations$quota$agents$en agents = Translations$quota$agents$en.internal(_root);
	late final Translations$quota$config$en config = Translations$quota$config$en.internal(_root);
	late final Translations$quota$chart$en chart = Translations$quota$chart$en.internal(_root);
}

// Path: scheduler
class Translations$scheduler$en {
	Translations$scheduler$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New'
	String get newLabel => 'New';

	/// en: 'Runs'
	String get runs => 'Runs';

	/// en: 'Edit schedule'
	String get editTitle => 'Edit schedule';

	/// en: 'Delete schedule?'
	String get deleteTitle => 'Delete schedule?';

	/// en: 'This removes the recurring job {{id}}. Existing sessions are kept.'
	String deleteMessage({required Object id}) => 'This removes the recurring job ${id}. Existing sessions are kept.';

	/// en: 'Checking…'
	String get checking => 'Checking…';

	/// en: 'next in {{time}}'
	String nextIn({required Object time}) => 'next in ${time}';

	/// en: 'worktree'
	String get worktree => 'worktree';

	/// en: 'session {{id}}'
	String session({required Object id}) => 'session ${id}';

	/// en: 'Cron (min hour day month weekday) — e.g. 0 9 * * *'
	String get cronHint => 'Cron (min hour day month weekday) — e.g. 0 9 * * *';

	/// en: 'Prompt for the agent'
	String get promptHint => 'Prompt for the agent';
}

// Path: serverConnect
class Translations$serverConnect$en {
	Translations$serverConnect$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect to your ddagent server'
	String get subtitle => 'Connect to your ddagent server';

	/// en: 'Enter a server URL'
	String get enterUrl => 'Enter a server URL';

	/// en: 'Connection failed ({{error}})'
	String connectionFailed({required Object error}) => 'Connection failed (${error})';

	/// en: 'Connect'
	String get connect => 'Connect';

	/// en: 'Connecting…'
	String get connecting => 'Connecting…';

	/// en: 'Change server'
	String get changeServer => 'Change server';

	late final Translations$serverConnect$local$en local = Translations$serverConnect$local$en.internal(_root);
}

// Path: sessions
class Translations$sessions$en {
	Translations$sessions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No sessions'
	String get noSessions => 'No sessions';

	/// en: 'No recent sessions'
	String get noRecentSessions => 'No recent sessions';

	/// en: 'Archived sessions'
	String get archivedSessions => 'Archived sessions';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Archive'
	String get archive => 'Archive';

	/// en: 'Compare with…'
	String get compareWith => 'Compare with…';

	/// en: 'Project path'
	String get projectPath => 'Project path';

	/// en: 'New session — provider'
	String get newSessionProvider => 'New session — provider';

	/// en: 'Auto (orchestrator)'
	String get autoOrchestrator => 'Auto (orchestrator)';

	/// en: 'Failed to create session: {{error}}'
	String createFailed({required Object error}) => 'Failed to create session: ${error}';

	/// en: 'Removes "{{name}}" and its transcript. This cannot be undone.'
	String deleteSessionMessage({required Object name}) => 'Removes "${name}" and its transcript. This cannot be undone.';

	late final Translations$sessions$toasts$en toasts = Translations$sessions$toasts$en.internal(_root);
	late final Translations$sessions$age$en age = Translations$sessions$age$en.internal(_root);
	late final Translations$sessions$activity$en activity = Translations$sessions$activity$en.internal(_root);
}

// Path: sharedContext
class Translations$sharedContext$en {
	Translations$sharedContext$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shared Notes'
	String get title => 'Shared Notes';
}

// Path: skills
class Translations$skills$en {
	Translations$skills$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Move {{name}}'
	String moveSkill({required Object name}) => 'Move ${name}';

	/// en: 'Delete {{name}}'
	String deleteSkill({required Object name}) => 'Delete ${name}';

	/// en: 'Project'
	String get projectLabel => 'Project';

	late final Translations$skills$addDialog$en addDialog = Translations$skills$addDialog$en.internal(_root);
	late final Translations$skills$moveDialog$en moveDialog = Translations$skills$moveDialog$en.internal(_root);
	late final Translations$skills$screen$en screen = Translations$skills$screen$en.internal(_root);
	late final Translations$skills$empty$en empty = Translations$skills$empty$en.internal(_root);
	late final Translations$skills$scopes$en scopes = Translations$skills$scopes$en.internal(_root);
	late final Translations$skills$errors$en errors = Translations$skills$errors$en.internal(_root);
}

// Path: terminal
class Translations$terminal$en {
	Translations$terminal$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$terminal$tabs$en tabs = Translations$terminal$tabs$en.internal(_root);
	late final Translations$terminal$actions$en actions = Translations$terminal$actions$en.internal(_root);
	late final Translations$terminal$authUrl$en authUrl = Translations$terminal$authUrl$en.internal(_root);
	late final Translations$terminal$fileLink$en fileLink = Translations$terminal$fileLink$en.internal(_root);
	late final Translations$terminal$shortcuts$en shortcuts = Translations$terminal$shortcuts$en.internal(_root);
	late final Translations$terminal$paste$en paste = Translations$terminal$paste$en.internal(_root);
	late final Translations$terminal$errors$en errors = Translations$terminal$errors$en.internal(_root);
}

// Path: voice
class Translations$voice$en {
	Translations$voice$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Preview'
	String get preview => 'Preview';

	/// en: 'Voice input settings saved'
	String get settingsSaved => 'Voice input settings saved';

	/// en: 'Failed to save STT configuration'
	String get saveFailed => 'Failed to save STT configuration';

	/// en: 'API Key (saved, enter to replace)'
	String get apiKeySaved => 'API Key (saved, enter to replace)';
}

// Path: workspace
class Translations$workspace$en {
	Translations$workspace$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Export chat'
	String get exportChat => 'Export chat';

	/// en: 'Search transcript'
	String get searchTranscript => 'Search transcript';

	/// en: 'Previous match'
	String get previousMatch => 'Previous match';

	/// en: 'Next match'
	String get nextMatch => 'Next match';

	/// en: 'Close search'
	String get closeSearch => 'Close search';

	/// en: 'New chat — provider'
	String get newChatProvider => 'New chat — provider';

	/// en: 'Close pane'
	String get closePane => 'Close pane';

	/// en: 'Jump to session…'
	String get jumpToSession => 'Jump to session…';

	/// en: 'Archived'
	String get archivedWorkspaceName => 'Archived';

	/// en: 'Send to {{count}}'
	String sendTo({required Object count}) => 'Send to ${count}';

	/// en: 'Removes the session and its transcript. Cannot be undone.'
	String get deleteSessionNotice => 'Removes the session and its transcript. Cannot be undone.';

	/// en: 'Default · {{label}}'
	String accountWithLabel({required Object label}) => 'Default · ${label}';

	/// en: 'Finish the run before changing workspace'
	String get finishRunBeforeChangingWorkspace => 'Finish the run before changing workspace';

	/// en: 'Workspace restored'
	String get restored => 'Workspace restored';

	/// en: 'Maximize pane'
	String get maximizePane => 'Maximize pane';

	/// en: 'Restore panes'
	String get restorePanes => 'Restore panes';

	/// en: 'Review changed files'
	String get reviewChangedFiles => 'Review changed files';
}

// Path: worktrees
class Translations$worktrees$en {
	Translations$worktrees$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Scripts'
	String get scripts => 'Scripts';

	/// en: 'No worktrees found'
	String get emptyTitle => 'No worktrees found';

	/// en: 'Create a worktree to isolate feature work or agent runs.'
	String get emptyDescription => 'Create a worktree to isolate feature work or agent runs.';

	/// en: 'Opened worktree: {{branch}}'
	String opened({required Object branch}) => 'Opened worktree: ${branch}';

	/// en: 'Worktree created'
	String get created => 'Worktree created';

	/// en: 'Worktree removed'
	String get removed => 'Worktree removed';

	/// en: 'Worktree merged into {{branch}}'
	String merged({required Object branch}) => 'Worktree merged into ${branch}';

	/// en: 'Scripts configuration saved'
	String get scriptsSaved => 'Scripts configuration saved';

	/// en: 'Setup: '
	String get setupLabel => 'Setup: ';

	/// en: 'Server: '
	String get serverLabel => 'Server: ';

	/// en: 'running'
	String get runRunning => 'running';

	/// en: 'running :{{port}}'
	String runRunningWithPort({required Object port}) => 'running :${port}';

	/// en: 'Run'
	String get runButton => 'Run';

	/// en: 'Stop'
	String get stopButton => 'Stop';

	/// en: 'main'
	String get mainBadge => 'main';

	/// en: 'HEAD detached at {{sha}}'
	String headDetachedAt({required Object sha}) => 'HEAD detached at ${sha}';

	/// en: 'New branch name (e.g. feature/login)'
	String get branchHint => 'New branch name (e.g. feature/login)';

	/// en: 'Branching off {{branch}}'
	String branchingOff({required Object branch}) => 'Branching off ${branch}';

	/// en: 'Merge {{branch}}'
	String mergeTitle({required Object branch}) => 'Merge ${branch}';

	/// en: 'Merge changes into {{branch}}.'
	String mergeDescription({required Object branch}) => 'Merge changes into ${branch}.';

	/// en: 'Combine all commits into a single commit'
	String get squashDescription => 'Combine all commits into a single commit';

	/// en: 'Remove worktree and delete branch once merged'
	String get cleanupDescription => 'Remove worktree and delete branch once merged';

	/// en: 'Remove worktree {{branch}}?'
	String removeTitle({required Object branch}) => 'Remove worktree ${branch}?';

	/// en: 'This deletes the worktree folder. Linked projects will be archived.'
	String get removeDescription => 'This deletes the worktree folder. Linked projects will be archived.';

	/// en: 'Warning: This worktree has {{count}} uncommitted changes that will be lost.'
	String dirtyWarning({required Object count}) => 'Warning: This worktree has ${count} uncommitted changes that will be lost.';

	/// en: 'Force remove (discard changes)'
	String get forceRemoveLabel => 'Force remove (discard changes)';

	/// en: 'Delete branch as well'
	String get deleteBranchLabel => 'Delete branch as well';

	/// en: 'Setup command (e.g. npm install)'
	String get setupHint => 'Setup command (e.g. npm install)';

	/// en: 'Run command (e.g. npm run dev)'
	String get runHint => 'Run command (e.g. npm run dev)';

	/// en: 'Run port (optional, e.g. 3000)'
	String get portHint => 'Run port (optional, e.g. 3000)';
}

// Path: auth.login
class Translations$auth$login$en {
	Translations$auth$login$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome Back'
	String get title => 'Welcome Back';

	/// en: 'Sign in to your ddagent self-hosted account'
	String get description => 'Sign in to your ddagent self-hosted account';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Sign In'
	String get submit => 'Sign In';

	/// en: 'Signing in...'
	String get loading => 'Signing in...';

	late final Translations$auth$login$errors$en errors = Translations$auth$login$errors$en.internal(_root);
	late final Translations$auth$login$placeholders$en placeholders = Translations$auth$login$placeholders$en.internal(_root);
}

// Path: auth.register
class Translations$auth$register$en {
	Translations$auth$register$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Account'
	String get title => 'Create Account';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Create Account'
	String get submit => 'Create Account';

	/// en: 'Creating account...'
	String get loading => 'Creating account...';

	late final Translations$auth$register$errors$en errors = Translations$auth$register$errors$en.internal(_root);
}

// Path: auth.logout
class Translations$auth$logout$en {
	Translations$auth$logout$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign Out'
	String get title => 'Sign Out';

	/// en: 'Are you sure you want to sign out?'
	String get confirm => 'Are you sure you want to sign out?';

	/// en: 'Sign Out'
	String get button => 'Sign Out';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Copied'
	String get copied => 'Copied';

	/// en: 'Copy code'
	String get copyCode => 'Copy code';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Copy message'
	String get copy => 'Copy message';

	/// en: 'Message copied'
	String get copied => 'Message copied';

	/// en: 'Copy failed'
	String get failed => 'Copy failed';

	/// en: 'Select copy format'
	String get selectFormat => 'Select copy format';

	/// en: 'Copy as markdown'
	String get copyAsMarkdown => 'Copy as markdown';

	/// en: 'Copy as text'
	String get copyAsText => 'Copy as text';

	/// en: 'MD'
	String get markdownShort => 'MD';

	/// en: 'TXT'
	String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'U'
	String get user => 'U';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Tool'
	String get tool => 'Tool';

	/// en: 'Claude'
	String get claude => 'Claude';

	/// en: 'Cursor'
	String get cursor => 'Cursor';

	/// en: 'Codex'
	String get codex => 'Codex';

	/// en: 'OpenCode'
	String get opencode => 'OpenCode';

	/// en: 'Devin'
	String get devin => 'Devin';

	/// en: 'Auto'
	String get orchestrator => 'Auto';
}

// Path: chat.orchestrator
class Translations$chat$orchestrator$en {
	Translations$chat$orchestrator$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$chat$orchestrator$routing$en routing = Translations$chat$orchestrator$routing$en.internal(_root);
	late final Translations$chat$orchestrator$plan$en plan = Translations$chat$orchestrator$plan$en.internal(_root);
	late final Translations$chat$orchestrator$decision$en decision = Translations$chat$orchestrator$decision$en.internal(_root);
	late final Translations$chat$orchestrator$delegation$en delegation = Translations$chat$orchestrator$delegation$en.internal(_root);
	late final Translations$chat$orchestrator$summary$en summary = Translations$chat$orchestrator$summary$en.internal(_root);

	/// en: 'Back to orchestration'
	String get backToParent => 'Back to orchestration';

	late final Translations$chat$orchestrator$taskmaster$en taskmaster = Translations$chat$orchestrator$taskmaster$en.internal(_root);
	late final Translations$chat$orchestrator$gate$en gate = Translations$chat$orchestrator$gate$en.internal(_root);
}

// Path: chat.tools
class Translations$chat$tools$en {
	Translations$chat$tools$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tool Settings'
	String get settings => 'Tool Settings';

	/// en: 'Tool Error'
	String get error => 'Tool Error';

	/// en: 'Tool Result'
	String get result => 'Tool Result';

	/// en: 'View input parameters'
	String get viewParams => 'View input parameters';

	/// en: 'View raw parameters'
	String get viewRawParams => 'View raw parameters';

	/// en: 'View edit diff for'
	String get viewDiff => 'View edit diff for';

	/// en: 'Creating new file:'
	String get creatingFile => 'Creating new file:';

	/// en: 'Updating Todo List'
	String get updatingTodo => 'Updating Todo List';

	/// en: 'Read'
	String get read => 'Read';

	/// en: 'Read file'
	String get readFile => 'Read file';

	/// en: 'Update todo list'
	String get updateTodo => 'Update todo list';

	/// en: 'Read todo list'
	String get readTodo => 'Read todo list';

	/// en: 'results'
	String get searchResults => 'results';

	/// en: 'TodoRead reading list'
	String get todoReadLabel => 'TodoRead reading list';
}

// Path: chat.search
class Translations$chat$search$en {
	Translations$chat$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Found {{count}} {{type}}'
	String found({required Object count, required Object type}) => 'Found ${count} ${type}';

	/// en: 'file'
	String get file => 'file';

	/// en: 'files'
	String get files => 'files';

	/// en: 'pattern:'
	String get pattern => 'pattern:';

	/// en: 'in:'
	String get kIn => 'in:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'File updated successfully'
	String get updated => 'File updated successfully';

	/// en: 'File created successfully'
	String get created => 'File created successfully';

	/// en: 'File written successfully'
	String get written => 'File written successfully';

	/// en: 'Diff'
	String get diff => 'Diff';

	/// en: 'New File'
	String get newFile => 'New File';

	/// en: 'View file content'
	String get viewContent => 'View file content';

	/// en: 'View full output ({{count}} chars)'
	String viewFullOutput({required Object count}) => 'View full output (${count} chars)';

	/// en: 'The file content is displayed in the diff view above'
	String get contentDisplayed => 'The file content is displayed in the diff view above';
}

// Path: chat.interactive
class Translations$chat$interactive$en {
	Translations$chat$interactive$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Interactive Prompt'
	String get title => 'Interactive Prompt';

	/// en: 'Waiting for your response in the CLI'
	String get waiting => 'Waiting for your response in the CLI';

	/// en: 'Please select an option in your terminal where Claude is running.'
	String get instruction => 'Please select an option in your terminal where Claude is running.';

	/// en: '✓ Claude selected option {{number}}'
	String selectedOption({required Object number}) => '✓ Claude selected option ${number}';

	/// en: 'In the CLI, you would select this option interactively using arrow keys or by typing the number.'
	String get instructionDetail => 'In the CLI, you would select this option interactively using arrow keys or by typing the number.';
}

// Path: chat.thinking
class Translations$chat$thinking$en {
	Translations$chat$thinking$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Thinking...'
	String get title => 'Thinking...';

	/// en: '💭 Thinking...'
	String get emoji => '💭 Thinking...';
}

// Path: chat.json
class Translations$chat$json$en {
	Translations$chat$json$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'JSON Response'
	String get response => 'JSON Response';
}

// Path: chat.permissions
class Translations$chat$permissions$en {
	Translations$chat$permissions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Grant permission for {{tool}}'
	String grant({required Object tool}) => 'Grant permission for ${tool}';

	/// en: 'Permission added'
	String get added => 'Permission added';

	/// en: 'Adds {{entry}} to Allowed Tools.'
	String addTo({required Object entry}) => 'Adds ${entry} to Allowed Tools.';

	/// en: 'Permission saved. Retry the request to use the tool.'
	String get retry => 'Permission saved. Retry the request to use the tool.';

	/// en: 'Unable to update permissions. Please try again.'
	String get error => 'Unable to update permissions. Please try again.';

	/// en: 'Open settings'
	String get openSettings => 'Open settings';

	/// en: 'Allow'
	String get allow => 'Allow';

	/// en: 'Always'
	String get always => 'Always';

	/// en: 'Edit & allow'
	String get editAndAllow => 'Edit & allow';

	/// en: 'Deny'
	String get deny => 'Deny';

	/// en: 'Reject'
	String get reject => 'Reject';

	/// en: 'Allow all ({{count}})'
	String allowAll({required Object count}) => 'Allow all (${count})';

	/// en: 'Edit input'
	String get editInput => 'Edit input';

	/// en: 'Invalid JSON'
	String get invalidJson => 'Invalid JSON';

	/// en: 'Allow with changes'
	String get allowWithChanges => 'Allow with changes';
}

// Path: chat.todo
class Translations$chat$todo$en {
	Translations$chat$todo$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Todo list has been updated successfully'
	String get updated => 'Todo list has been updated successfully';

	/// en: 'Current Todo List'
	String get current => 'Current Todo List';
}

// Path: chat.plan
class Translations$chat$plan$en {
	Translations$chat$plan$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '📋 View implementation plan'
	String get viewPlan => '📋 View implementation plan';

	/// en: 'Implementation Plan'
	String get title => 'Implementation Plan';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Claude usage limit reached. Your limit will reset at **{{time}} {{timezone}}** - {{date}}'
	String resetAt({required Object time, required Object timezone, required Object date}) => 'Claude usage limit reached. Your limit will reset at **${time} ${timezone}** - ${date}';
}

// Path: chat.codex
class Translations$chat$codex$en {
	Translations$chat$codex$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permission Mode'
	String get permissionMode => 'Permission Mode';

	late final Translations$chat$codex$modes$en modes = Translations$chat$codex$modes$en.internal(_root);
	late final Translations$chat$codex$descriptions$en descriptions = Translations$chat$codex$descriptions$en.internal(_root);

	/// en: 'Technical details'
	String get technicalDetails => 'Technical details';
}

// Path: chat.voice
class Translations$chat$voice$en {
	Translations$chat$voice$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Read replies aloud'
	String get autoRead => 'Read replies aloud';

	/// en: 'Read replies aloud: on'
	String get autoReadOn => 'Read replies aloud: on';

	/// en: 'Read replies aloud: off'
	String get autoReadOff => 'Read replies aloud: off';

	/// en: 'Read-aloud voice'
	String get autoReadVoice => 'Read-aloud voice';

	/// en: 'Auto voice'
	String get autoReadVoiceAuto => 'Auto voice';

	/// en: 'This is how replies will sound.'
	String get autoReadPreview => 'This is how replies will sound.';

	/// en: 'Read aloud'
	String get speakMessage => 'Read aloud';

	/// en: 'Stop reading'
	String get stopSpeaking => 'Stop reading';
}

// Path: chat.input
class Translations$chat$input$en {
	Translations$chat$input$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Type / for commands, @ for files, or ask {{provider}} anything...'
	String placeholder({required Object provider}) => 'Type / for commands, @ for files, or ask ${provider} anything...';

	/// en: 'Type your message...'
	String get placeholderDefault => 'Type your message...';

	/// en: 'Input disabled'
	String get disabled => 'Input disabled';

	/// en: 'Attach files'
	String get attachFiles => 'Attach files';

	/// en: 'Upload photos, files, or documents'
	String get attachFilesDesc => 'Upload photos, files, or documents';

	/// en: 'Take photo'
	String get takePhoto => 'Take photo';

	/// en: 'Use camera to capture photo'
	String get takePhotoDesc => 'Use camera to capture photo';

	/// en: 'More tools'
	String get moreTools => 'More tools';

	/// en: 'Explore shortcuts and commands'
	String get commandsDesc => 'Explore shortcuts and commands';

	/// en: 'Discard current text'
	String get clearInputDesc => 'Discard current text';

	/// en: 'Attach images'
	String get attachImages => 'Attach images';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'Stop'
	String get stop => 'Stop';

	late final Translations$chat$input$hintText$en hintText = Translations$chat$input$hintText$en.internal(_root);

	/// en: 'Click to change permission mode'
	String get clickToChangeMode => 'Click to change permission mode';

	/// en: 'Show all commands'
	String get showAllCommands => 'Show all commands';

	/// en: 'Clear input'
	String get clearInput => 'Clear input';

	/// en: 'Scroll to bottom'
	String get scrollToBottom => 'Scroll to bottom';

	/// en: 'New message'
	String get newMessage => 'New message';

	/// en: 'New messages'
	String get newMessages => 'New messages';

	late final Translations$chat$input$queue$en queue = Translations$chat$input$queue$en.internal(_root);

	/// en: 'Auto-continue'
	String get autoContinueTasks => 'Auto-continue';

	/// en: 'Enable to let Devin automatically continue to the next Task Master task'
	String get autoContinueTasksTooltip => 'Enable to let Devin automatically continue to the next Task Master task';

	late final Translations$chat$input$offlineQueue$en offlineQueue = Translations$chat$input$offlineQueue$en.internal(_root);

	/// en: 'Voice input'
	String get voice => 'Voice input';

	/// en: 'Dictate a message'
	String get voiceStart => 'Dictate a message';

	/// en: 'Stop dictation'
	String get voiceStop => 'Stop dictation';

	/// en: 'Pin file to context'
	String get pinFile => 'Pin file to context';

	/// en: 'Voice settings (STT)'
	String get voiceSettings => 'Voice settings (STT)';

	/// en: 'Camera unavailable: {{error}}'
	String cameraUnavailable({required Object error}) => 'Camera unavailable: ${error}';
}

// Path: chat.composer
class Translations$chat$composer$en {
	Translations$chat$composer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tools & actions'
	String get toolsAndActions => 'Tools & actions';

	/// en: 'Tools and controls for chat composer'
	String get toolsAndActionsDesc => 'Tools and controls for chat composer';

	/// en: 'Reasoning'
	String get reasoning => 'Reasoning';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'Default'
	String get effortDefault => 'Default';

	/// en: 'Loading models…'
	String get loadingModels => 'Loading models…';

	/// en: 'Select model and reasoning effort'
	String get modelMenu => 'Select model and reasoning effort';

	/// en: 'How should {{provider}} actions be approved?'
	String permissionHeading({required Object provider}) => 'How should ${provider} actions be approved?';

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Select account'
	String get accountMenu => 'Select account';

	/// en: 'Default account'
	String get accountDefault => 'Default account';

	/// en: 'Auto (default)'
	String get accountAuto => 'Auto (default)';

	/// en: 'Default'
	String get accountIsDefault => 'Default';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose Your AI Assistant'
	String get title => 'Choose Your AI Assistant';

	/// en: 'Select a provider to start a new conversation'
	String get description => 'Select a provider to start a new conversation';

	/// en: 'Select Model'
	String get selectModel => 'Select Model';

	/// en: 'Workspace'
	String get workspace => 'Workspace';

	/// en: 'None'
	String get noWorkspace => 'None';

	/// en: 'Click to change workspace'
	String get clickToChangeWorkspace => 'Click to change workspace';

	/// en: 'Choose a workspace'
	String get chooseWorkspace => 'Choose a workspace';

	/// en: 'Search workspaces...'
	String get searchWorkspaces => 'Search workspaces...';

	/// en: 'No workspaces found.'
	String get noWorkspacesFound => 'No workspaces found.';

	late final Translations$chat$providerSelection$providerInfo$en providerInfo = Translations$chat$providerSelection$providerInfo$en.internal(_root);
	late final Translations$chat$providerSelection$readyPrompt$en readyPrompt = Translations$chat$providerSelection$readyPrompt$en.internal(_root);

	/// en: 'Auto'
	String get autoGroup => 'Auto';

	/// en: 'Auto (orchestrated)'
	String get autoLabel => 'Auto (orchestrated)';

	/// en: 'Routes each step to the best available provider and model'
	String get autoDescription => 'Routes each step to the best available provider and model';

	/// en: 'orchestrated'
	String get orchestrated => 'orchestrated';

	/// en: 'Press <kbd>{{shortcut}}</kbd> to search sessions, files, and commits'
	String pressToSearch({required Object shortcut}) => 'Press <kbd>${shortcut}</kbd> to search sessions, files, and commits';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'No models found.'
	String get noModelsFound => 'No models found.';

	/// en: 'Paid'
	String get paid => 'Paid';

	/// en: 'Search models...'
	String get searchModels => 'Search models...';

	/// en: 'Add model'
	String get addModel => 'Add model';

	/// en: 'Choose a model'
	String get chooseModel => 'Choose a model';

	/// en: 'Built-in and custom models in one list'
	String get chooseModelDescription => 'Built-in and custom models in one list';

	/// en: 'Click to change model'
	String get clickToChange => 'Click to change model';

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'Loading models…'
	String get loadingModels => 'Loading models…';

	/// en: 'Manage models'
	String get manageModels => 'Manage models';

	/// en: 'Refresh models'
	String get refresh => 'Refresh models';
}

// Path: chat.session
class Translations$chat$session$en {
	Translations$chat$session$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$chat$session$kContinue$en kContinue = Translations$chat$session$kContinue$en.internal(_root);
	late final Translations$chat$session$loading$en loading = Translations$chat$session$loading$en.internal(_root);
	late final Translations$chat$session$messages$en messages = Translations$chat$session$messages$en.internal(_root);

	/// en: 'Removes the session and its transcript. Cannot be undone.'
	String get deleteConfirm => 'Removes the session and its transcript. Cannot be undone.';

	/// en: 'Finish the run before changing workspace'
	String get finishRunBeforeWorkspaceChange => 'Finish the run before changing workspace';
}

// Path: chat.shell
class Translations$chat$shell$en {
	Translations$chat$shell$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$chat$shell$selectProject$en selectProject = Translations$chat$shell$selectProject$en.internal(_root);
	late final Translations$chat$shell$status$en status = Translations$chat$shell$status$en.internal(_root);
	late final Translations$chat$shell$actions$en actions = Translations$chat$shell$actions$en.internal(_root);

	/// en: 'Loading terminal...'
	String get loading => 'Loading terminal...';

	/// en: 'Connecting to shell...'
	String get connecting => 'Connecting to shell...';

	/// en: 'Start a new agent session'
	String get startSession => 'Start a new agent session';

	/// en: 'Resume session: {{displayName}}...'
	String resumeSession({required Object displayName}) => 'Resume session: ${displayName}...';

	/// en: 'Run {{command}} in {{projectName}}'
	String runCommand({required Object command, required Object projectName}) => 'Run ${command} in ${projectName}';

	/// en: 'Starting agent CLI in {{projectName}}'
	String startCli({required Object projectName}) => 'Starting agent CLI in ${projectName}';

	/// en: 'command'
	String get defaultCommand => 'command';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$chat$claudeStatus$actions$en actions = Translations$chat$claudeStatus$actions$en.internal(_root);
	late final Translations$chat$claudeStatus$state$en state = Translations$chat$claudeStatus$state$en.internal(_root);
	late final Translations$chat$claudeStatus$elapsed$en elapsed = Translations$chat$claudeStatus$elapsed$en.internal(_root);

	/// en: 'Stop'
	String get stop => 'Stop';

	late final Translations$chat$claudeStatus$controls$en controls = Translations$chat$claudeStatus$controls$en.internal(_root);
	late final Translations$chat$claudeStatus$providers$en providers = Translations$chat$claudeStatus$providers$en.internal(_root);
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select a project to start chatting with {{provider}}'
	String startChatWithProvider({required Object provider}) => 'Select a project to start chatting with ${provider}';
}

// Path: chat.tasks
class Translations$chat$tasks$en {
	Translations$chat$tasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Start the next task'
	String get nextTaskPrompt => 'Start the next task';
}

// Path: chat.splitSession
class Translations$chat$splitSession$en {
	Translations$chat$splitSession$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Split Session'
	String get toggle => 'Split Session';

	/// en: 'Close split session'
	String get close => 'Close split session';

	/// en: 'Select session to compare'
	String get selectSession => 'Select session to compare';

	/// en: 'No other sessions available'
	String get noOtherSessions => 'No other sessions available';

	/// en: '+ New session in split view'
	String get newSessionOption => '+ New session in split view';

	/// en: 'Current Project ({{name}})'
	String currentProjectGroup({required Object name}) => 'Current Project (${name})';

	/// en: 'Other Projects'
	String get otherProjectsGroup => 'Other Projects';

	/// en: 'Recent sessions'
	String get recentSessionsGroup => 'Recent sessions';

	/// en: 'Start New Session in Split View'
	String get startNewSession => 'Start New Session in Split View';

	/// en: 'Select session from list of existing sessions'
	String get selectFromList => 'Select session from list of existing sessions';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select session'
	String get title => 'Select session';

	/// en: 'Search sessions...'
	String get searchPlaceholder => 'Search sessions...';

	/// en: 'Clear search'
	String get clearSearch => 'Clear search';

	/// en: '+ New chat'
	String get newChat => '+ New chat';

	/// en: 'Archived'
	String get archivedToggle => 'Archived';

	/// en: 'Change session'
	String get changeSession => 'Change session';

	/// en: 'Loading archived sessions...'
	String get archivedLoading => 'Loading archived sessions...';

	/// en: 'Could not load archived sessions'
	String get archivedError => 'Could not load archived sessions';

	/// en: 'No archived sessions'
	String get archivedEmpty => 'No archived sessions';

	/// en: 'Workspace archived — restore it to see its sessions.'
	String get archivedProjectOnly => 'Workspace archived — restore it to see its sessions.';

	/// en: 'No sessions match your search'
	String get emptySearch => 'No sessions match your search';

	/// en: 'Restore'
	String get restore => 'Restore';

	/// en: 'Restore session'
	String get restoreSession => 'Restore session';

	/// en: 'Restore workspace'
	String get restoreProject => 'Restore workspace';

	/// en: 'Failed to restore session. Please try again.'
	String get restoreSessionFailed => 'Failed to restore session. Please try again.';

	/// en: 'Failed to restore workspace. Please try again.'
	String get restoreProjectFailed => 'Failed to restore workspace. Please try again.';

	/// en: 'Failed to archive session. Please try again.'
	String get archiveFailed => 'Failed to archive session. Please try again.';

	/// en: 'Failed to delete session. Please try again.'
	String get deleteFailed => 'Failed to delete session. Please try again.';

	/// en: 'Session is running'
	String get running => 'Session is running';

	/// en: 'Unread — finished with new output'
	String get unread => 'Unread — finished with new output';

	/// en: 'Account'
	String get account => 'Account';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add chat pane'
	String get addChat => 'Add chat pane';

	/// en: 'Add browser pane'
	String get addBrowser => 'Add browser pane';

	/// en: 'Add terminal pane'
	String get addTerminal => 'Add terminal pane';

	/// en: 'Add preview pane'
	String get addPreview => 'Add preview pane';

	/// en: 'Show all panes'
	String get overview => 'Show all panes';

	/// en: 'Exit Focus Mode (Ctrl+Shift+F)'
	String get exitFocusMode => 'Exit Focus Mode (Ctrl+Shift+F)';

	/// en: 'Focus Mode (Ctrl+Shift+F)'
	String get focusMode => 'Focus Mode (Ctrl+Shift+F)';

	/// en: 'Broadcast to sessions'
	String get broadcast => 'Broadcast to sessions';

	/// en: 'Add shared-notes pane'
	String get addNotes => 'Add shared-notes pane';

	/// en: 'Open session list'
	String get browseSessions => 'Open session list';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Split panes overview'
	String get title => 'Split panes overview';

	/// en: '{{count}} panes'
	String count({required Object count}) => '${count} panes';

	/// en: 'Close overview'
	String get close => 'Close overview';

	/// en: 'QUESTION — input required'
	String get question => 'QUESTION — input required';

	/// en: 'PROCESSING'
	String get processing => 'PROCESSING';

	/// en: 'Idle'
	String get idle => 'Idle';

	/// en: 'Active'
	String get active => 'Active';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{provider}} needs your input'
	String needsInput({required Object provider}) => '${provider} needs your input';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Other…'
	String get other => 'Other…';

	/// en: 'Type your answer…'
	String get answerHint => 'Type your answer…';
}

// Path: chat.attachments
class Translations$chat$attachments$en {
	Translations$chat$attachments$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Download failed — click to retry'
	String get downloadFailedRetry => 'Download failed — click to retry';

	/// en: 'File attachment'
	String get fileAttachment => 'File attachment';

	/// en: 'Download {{name}}'
	String download({required Object name}) => 'Download ${name}';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Creating snapshot…'
	String get creating => 'Creating snapshot…';

	/// en: 'Revert files to last checkpoint'
	String get revertChanges => 'Revert files to last checkpoint';

	/// en: 'Undo checkpoint'
	String get undo => 'Undo checkpoint';

	/// en: 'Undo AI run'
	String get undoAiRun => 'Undo AI run';

	/// en: 'Undoing…'
	String get undoing => 'Undoing…';

	/// en: 'Undone'
	String get undone => 'Undone';

	/// en: 'before AI turn'
	String get beforeAiTurn => 'before AI turn';
}

// Path: chat.common
class Translations$chat$common$en {
	Translations$chat$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close'
	String get close => 'Close';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Task'
	String get saveToTask => 'Task';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'TASK'
	String get taskShort => 'TASK';

	/// en: 'Add to TaskMaster'
	String get addToTask => 'Add to TaskMaster';

	/// en: 'Added to TaskMaster'
	String get added => 'Added to TaskMaster';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'View session token consumption'
	String get desc => 'View session token consumption';

	/// en: 'Token usage'
	String get title => 'Token usage';
}

// Path: chat.tool
class Translations$chat$tool$en {
	Translations$chat$tool$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '(no output yet — the tool returned an empty result)'
	String get emptyResult => '(no output yet — the tool returned an empty result)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Subscription limits'
	String get ariaLabel => 'Subscription limits';

	/// en: 'No subscription data for this model'
	String get noData => 'No subscription data for this model';
}

// Path: chat.broadcast
class Translations$chat$broadcast$en {
	Translations$chat$broadcast$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Broadcast to sessions'
	String get title => 'Broadcast to sessions';

	/// en: 'No sessions available'
	String get noSessions => 'No sessions available';

	/// en: 'Message to send to every selected session…'
	String get placeholder => 'Message to send to every selected session…';

	/// en: '{{count}} session(s) rejected the message'
	String partial({required Object count}) => '${count} session(s) rejected the message';

	/// en: 'Queued for {{count}} session(s)'
	String sent({required Object count}) => 'Queued for ${count} session(s)';

	/// en: 'Select all'
	String get selectAll => 'Select all';

	/// en: 'Select orchestrators'
	String get selectOrchestrators => 'Select orchestrators';

	/// en: 'Orchestrators only'
	String get orchestratorsOnly => 'Orchestrators only';

	/// en: 'No orchestrator sessions available'
	String get noOrchestrators => 'No orchestrator sessions available';

	/// en: 'Sending…'
	String get sending => 'Sending…';

	/// en: 'Send to {{count}}'
	String send({required Object count}) => 'Send to ${count}';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Processing…'
	String get processing => 'Processing…';

	/// en: 'Switch session'
	String get switchSession => 'Switch session';
}

// Path: chat.export
class Translations$chat$export$en {
	Translations$chat$export$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Session {{id}}'
	String sessionTitle({required Object id}) => 'Session ${id}';

	/// en: 'PDF export failed'
	String get pdfFailed => 'PDF export failed';

	/// en: 'Transcript downloaded'
	String get transcriptDownloaded => 'Transcript downloaded';

	/// en: 'Saved {{path}}'
	String savedTo({required Object path}) => 'Saved ${path}';
}

// Path: chat.commandResult
class Translations$chat$commandResult$en {
	Translations$chat$commandResult$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$chat$commandResult$fallback$en fallback = Translations$chat$commandResult$fallback$en.internal(_root);

	/// en: 'Filter commands...'
	String get filterCommands => 'Filter commands...';

	/// en: 'Search {{provider}} models...'
	String searchModels({required Object provider}) => 'Search ${provider} models...';
}

// Path: chat.commands
class Translations$chat$commands$en {
	Translations$chat$commands$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Run command?'
	String get runConfirmTitle => 'Run command?';

	/// en: 'Command execution cancelled'
	String get executionCancelled => 'Command execution cancelled';
}

// Path: chat.pinFile
class Translations$chat$pinFile$en {
	Translations$chat$pinFile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pin file'
	String get title => 'Pin file';

	/// en: 'path/to/file.ext'
	String get pathHint => 'path/to/file.ext';

	/// en: 'Pin'
	String get action => 'Pin';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit {{name}}'
	String editTooltip({required Object name}) => 'Edit ${name}';

	/// en: 'Delete {{name}}'
	String deleteTooltip({required Object name}) => 'Delete ${name}';

	/// en: 'Enter both a model name and model ID.'
	String get enterNameAndId => 'Enter both a model name and model ID.';

	/// en: 'Model IDs cannot contain spaces.'
	String get idNoSpaces => 'Model IDs cannot contain spaces.';

	/// en: 'Set as default'
	String get setAsDefault => 'Set as default';

	/// en: 'Default model'
	String get defaultModel => 'Default model';
}

// Path: chat.changes
class Translations$chat$changes$en {
	Translations$chat$changes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load changes'
	String get failedToLoad => 'Failed to load changes';

	/// en: 'No file changes'
	String get empty => 'No file changes';
}

// Path: chat.message
class Translations$chat$message$en {
	Translations$chat$message$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Compacted summary'
	String get compactedSummary => 'Compacted summary';

	/// en: 'Resend from the composer'
	String get resendHint => 'Resend from the composer';

	/// en: 'Raw view'
	String get rawView => 'Raw view';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permission request · {{tool}}'
	String title({required Object tool}) => 'Permission request · ${tool}';

	/// en: 'Question'
	String get question => 'Question';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'changes'
	String get changes => 'changes';

	/// en: 'Previous change'
	String get previousChange => 'Previous change';

	/// en: 'Next change'
	String get nextChange => 'Next change';

	/// en: 'Hide diff highlighting'
	String get hideDiff => 'Hide diff highlighting';

	/// en: 'Show diff highlighting'
	String get showDiff => 'Show diff highlighting';

	/// en: 'Editor Settings'
	String get settings => 'Editor Settings';

	/// en: 'Collapse editor'
	String get collapse => 'Collapse editor';

	/// en: 'Expand editor to full width'
	String get expand => 'Expand editor to full width';

	/// en: 'Toggle file dock'
	String get toggleDock => 'Toggle file dock';

	/// en: 'Diff / merge'
	String get diffMerge => 'Diff / merge';

	/// en: 'Preview in browser'
	String get previewInBrowser => 'Preview in browser';

	/// en: 'Reload from disk'
	String get reload => 'Reload from disk';
}

// Path: codeEditor.header
class Translations$codeEditor$header$en {
	Translations$codeEditor$header$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Showing changes'
	String get showingChanges => 'Showing changes';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Copy file path'
	String get copyPath => 'Copy file path';

	/// en: 'File path copied'
	String get pathCopied => 'File path copied';

	/// en: 'Download file'
	String get download => 'Download file';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'Saved!'
	String get saved => 'Saved!';

	/// en: 'Exit fullscreen'
	String get exitFullscreen => 'Exit fullscreen';

	/// en: 'Fullscreen'
	String get fullscreen => 'Fullscreen';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Preview markdown'
	String get previewMarkdown => 'Preview markdown';

	/// en: 'Edit markdown'
	String get editMarkdown => 'Edit markdown';

	/// en: 'Pin file to context'
	String get pinFile => 'Pin file to context';

	/// en: 'Unpin file from context'
	String get unpinFile => 'Unpin file from context';

	/// en: 'Open HTML preview in new tab'
	String get previewHtml => 'Open HTML preview in new tab';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Save all'
	String get saveAll => 'Save all';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Lines:'
	String get lines => 'Lines:';

	/// en: 'Characters:'
	String get characters => 'Characters:';

	/// en: 'Press Ctrl+S to save • Esc to close'
	String get shortcuts => 'Press Ctrl+S to save • Esc to close';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Binary File'
	String get title => 'Binary File';

	/// en: 'The file "{{fileName}}" cannot be displayed in the text editor because it is a binary file.'
	String message({required Object fileName}) => 'The file "${fileName}" cannot be displayed in the text editor because it is a binary file.';

	/// en: 'Cannot display as text'
	String get cannotDisplayAsText => 'Cannot display as text';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading preview...'
	String get loading => 'Loading preview...';

	/// en: 'Unable to display this file.'
	String get error => 'Unable to display this file.';

	/// en: 'Open in new tab'
	String get openInNewTab => 'Open in new tab';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Media file'
	String get title => 'Media file';

	/// en: 'Audio/video preview is not supported yet'
	String get subtitle => 'Audio/video preview is not supported yet';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '… {{size}} more'
	String more({required Object size}) => '… ${size} more';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Minimap'
	String get minimap => 'Minimap';

	/// en: 'Tab size: {{size}}'
	String tabSize({required Object size}) => 'Tab size: ${size}';

	/// en: 'Font size − (now {{size}})'
	String fontSizeDecrease({required Object size}) => 'Font size −  (now ${size})';

	/// en: 'Font size +'
	String get fontSizeIncrease => 'Font size +';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No changes'
	String get noChanges => 'No changes';

	/// en: 'Hunk {{number}}'
	String hunk({required Object number}) => 'Hunk ${number}';

	/// en: 'Close diff'
	String get close => 'Close diff';

	/// en: 'Base'
	String get base => 'Base';

	/// en: 'Current'
	String get current => 'Current';

	/// en: 'Apply merge'
	String get applyMerge => 'Apply merge';

	/// en: 'deleted on disk'
	String get deletedOnDisk => 'deleted on disk';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No file open'
	String get title => 'No file open';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Saved {{name}}'
	String savedFile({required Object name}) => 'Saved ${name}';

	/// en: 'Save failed'
	String get saveFailed => 'Save failed';

	/// en: 'All saved'
	String get allSaved => 'All saved';

	/// en: 'Some saves failed'
	String get someSavesFailed => 'Some saves failed';

	/// en: 'Saved to {{path}}'
	String savedTo({required Object path}) => 'Saved to ${path}';

	/// en: 'Merge applied — save to persist'
	String get mergeApplied => 'Merge applied — save to persist';
}

// Path: common.buttons
class Translations$common$buttons$en {
	Translations$common$buttons$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Submit'
	String get submit => 'Submit';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Upload'
	String get upload => 'Upload';

	/// en: 'Browse'
	String get browse => 'Browse';

	/// en: 'Update'
	String get update => 'Update';

	/// en: 'Open diagram'
	String get openDiagram => 'Open diagram';
}

// Path: common.tabs
class Translations$common$tabs$en {
	Translations$common$tabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chat'
	String get chat => 'Chat';

	/// en: 'Shell'
	String get shell => 'Shell';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Source Control'
	String get git => 'Source Control';

	/// en: 'Tasks'
	String get tasks => 'Tasks';

	/// en: 'Board'
	String get board => 'Board';

	/// en: 'Browser'
	String get browser => 'Browser';

	/// en: 'Computer'
	String get computer => 'Computer';

	/// en: 'AI Control'
	String get usage => 'AI Control';
}

// Path: common.quota
class Translations$common$quota$en {
	Translations$common$quota$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'AI Control Center'
	String get controlCenter => 'AI Control Center';

	late final Translations$common$quota$section$en section = Translations$common$quota$section$en.internal(_root);
	late final Translations$common$quota$filter$en filter = Translations$common$quota$filter$en.internal(_root);
	late final Translations$common$quota$period$en period = Translations$common$quota$period$en.internal(_root);
	late final Translations$common$quota$group$en group = Translations$common$quota$group$en.internal(_root);
	late final Translations$common$quota$metric$en metric = Translations$common$quota$metric$en.internal(_root);
	late final Translations$common$quota$cost$en cost = Translations$common$quota$cost$en.internal(_root);
	late final Translations$common$quota$cost3$en cost3 = Translations$common$quota$cost3$en.internal(_root);
	late final Translations$common$quota$overview$en overview = Translations$common$quota$overview$en.internal(_root);
	late final Translations$common$quota$usage$en usage = Translations$common$quota$usage$en.internal(_root);
	late final Translations$common$quota$agents$en agents = Translations$common$quota$agents$en.internal(_root);
	late final Translations$common$quota$agentStatus$en agentStatus = Translations$common$quota$agentStatus$en.internal(_root);
	late final Translations$common$quota$alert$en alert = Translations$common$quota$alert$en.internal(_root);

	/// en: 'Back to chat'
	String get backToChat => 'Back to chat';

	/// en: 'Sync now'
	String get syncNow => 'Sync now';

	/// en: 'Updated {{value}}'
	String generatedAt({required Object value}) => 'Updated ${value}';

	/// en: 'Loading account limits…'
	String get loading => 'Loading account limits…';

	/// en: '{{value}}% left'
	String remaining({required Object value}) => '${value}% left';

	/// en: 'reset in {{value}}'
	String resetsIn({required Object value}) => 'reset in ${value}';

	/// en: 'at the current pace this limit runs out in {{value}}'
	String projected({required Object value}) => 'at the current pace this limit runs out in ${value}';

	/// en: 'synced {{value}} ago'
	String syncedAgo({required Object value}) => 'synced ${value} ago';

	/// en: 'Refresh account'
	String get refreshAccount => 'Refresh account';

	/// en: 'Synchronization failed'
	String get syncFailed => 'Synchronization failed';

	/// en: 'History'
	String get history => 'History';

	/// en: '{{value}} readings recorded'
	String historyPoints({required Object value}) => '${value} readings recorded';

	/// en: 'No history recorded yet'
	String get historyEmpty => 'No history recorded yet';

	/// en: 'No agents assigned'
	String get noAgents => 'No agents assigned';

	/// en: 'No subscription'
	String get noSubscription => 'No subscription';

	/// en: 'The provider reports no active plan for this account.'
	String get noSubscriptionHint => 'The provider reports no active plan for this account.';

	late final Translations$common$quota$quality$en quality = Translations$common$quota$quality$en.internal(_root);
	late final Translations$common$quota$kpi$en kpi = Translations$common$quota$kpi$en.internal(_root);
	late final Translations$common$quota$empty$en empty = Translations$common$quota$empty$en.internal(_root);
	late final Translations$common$quota$settings$en settings = Translations$common$quota$settings$en.internal(_root);
	late final Translations$common$quota$range$en range = Translations$common$quota$range$en.internal(_root);
}

// Path: common.status
class Translations$common$status$en {
	Translations$common$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Failed'
	String get failed => 'Failed';

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Completed'
	String get completed => 'Completed';

	/// en: 'In Progress'
	String get inProgress => 'In Progress';
}

// Path: common.messages
class Translations$common$messages$en {
	Translations$common$messages$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Saved successfully'
	String get savedSuccessfully => 'Saved successfully';

	/// en: 'Deleted successfully'
	String get deletedSuccessfully => 'Deleted successfully';

	/// en: 'Updated successfully'
	String get updatedSuccessfully => 'Updated successfully';

	/// en: 'Operation failed'
	String get operationFailed => 'Operation failed';

	/// en: 'Network error. Please check your connection.'
	String get networkError => 'Network error. Please check your connection.';

	/// en: 'Unauthorized. Please log in.'
	String get unauthorized => 'Unauthorized. Please log in.';

	/// en: 'Not found'
	String get notFound => 'Not found';

	/// en: 'Invalid input'
	String get invalidInput => 'Invalid input';

	/// en: 'This field is required'
	String get requiredField => 'This field is required';

	/// en: 'An unknown error occurred'
	String get unknownError => 'An unknown error occurred';

	/// en: 'Failed to rename session. Please try again.'
	String get renameSessionFailed => 'Failed to rename session. Please try again.';
}

// Path: common.navigation
class Translations$common$navigation$en {
	Translations$common$navigation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Previous'
	String get previous => 'Previous';

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: common.common
class Translations$common$common$en {
	Translations$common$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Light Mode'
	String get lightMode => 'Light Mode';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Disabled'
	String get disabled => 'Disabled';

	/// en: 'Optional'
	String get optional => 'Optional';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Select'
	String get select => 'Select';

	/// en: 'Select All'
	String get selectAll => 'Select All';

	/// en: 'Deselect All'
	String get deselectAll => 'Deselect All';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Failed'
	String get failed => 'Failed';
}

// Path: common.time
class Translations$common$time$en {
	Translations$common$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Just now'
	String get justNow => 'Just now';

	/// en: '{{count}} mins ago'
	String minutesAgo({required Object count}) => '${count} mins ago';

	/// en: '{{count}} hours ago'
	String hoursAgo({required Object count}) => '${count} hours ago';

	/// en: '{{count}} days ago'
	String daysAgo({required Object count}) => '${count} days ago';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';
}

// Path: common.fileOperations
class Translations$common$fileOperations$en {
	Translations$common$fileOperations$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New File'
	String get newFile => 'New File';

	/// en: 'New Folder'
	String get newFolder => 'New Folder';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Move'
	String get move => 'Move';

	/// en: 'Copy Path'
	String get copyPath => 'Copy Path';

	/// en: 'Open in Editor'
	String get openInEditor => 'Open in Editor';
}

// Path: common.mainContent
class Translations$common$mainContent$en {
	Translations$common$mainContent$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading ddagent'
	String get loading => 'Loading ddagent';

	/// en: 'Setting up your workspace...'
	String get settingUpWorkspace => 'Setting up your workspace...';

	/// en: 'Choose Your Project'
	String get chooseProject => 'Choose Your Project';

	/// en: 'Pick a session in the Panel to start coding with Claude. Each project contains your chat sessions and file history.'
	String get selectProjectDescription => 'Pick a session in the Panel to start coding with Claude. Each project contains your chat sessions and file history.';

	/// en: 'Tip'
	String get tip => 'Tip';

	/// en: 'Tap the menu button above to access projects'
	String get createProjectMobile => 'Tap the menu button above to access projects';

	/// en: 'Create a new project by clicking the folder icon in the sidebar'
	String get createProjectDesktop => 'Create a new project by clicking the folder icon in the sidebar';

	/// en: 'New Session'
	String get newSession => 'New Session';

	/// en: 'Untitled Session'
	String get untitledSession => 'Untitled Session';

	/// en: 'Project Files'
	String get projectFiles => 'Project Files';

	/// en: 'Focus Mode (Ctrl+Shift+F)'
	String get focusMode => 'Focus Mode (Ctrl+Shift+F)';

	/// en: 'Exit Focus Mode (Ctrl+Shift+F)'
	String get exitFocusMode => 'Exit Focus Mode (Ctrl+Shift+F)';

	/// en: 'Split Session'
	String get splitSession => 'Split Session';

	/// en: 'Close split session'
	String get closeSplitSession => 'Close split session';

	/// en: 'Choose a workspace'
	String get chooseWorkspace => 'Choose a workspace';

	/// en: 'Pick a workspace for this chat, or create a new one in Settings.'
	String get chooseWorkspaceDescription => 'Pick a workspace for this chat, or create a new one in Settings.';

	/// en: 'Create workspace in Settings'
	String get createWorkspace => 'Create workspace in Settings';

	/// en: 'Recent projects'
	String get recentProjects => 'Recent projects';
}

// Path: common.fileTree
class Translations$common$fileTree$en {
	Translations$common$fileTree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading files...'
	String get loading => 'Loading files...';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Simple view'
	String get simpleView => 'Simple view';

	/// en: 'Compact view'
	String get compactView => 'Compact view';

	/// en: 'Detailed view'
	String get detailedView => 'Detailed view';

	/// en: 'Search files and folders...'
	String get searchPlaceholder => 'Search files and folders...';

	/// en: 'Search in files...'
	String get searchContentPlaceholder => 'Search in files...';

	/// en: 'Search in files'
	String get searchInFiles => 'Search in files';

	/// en: 'Search by name'
	String get searchByName => 'Search by name';

	/// en: 'Clear search'
	String get clearSearch => 'Clear search';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Size'
	String get size => 'Size';

	/// en: 'Modified'
	String get modified => 'Modified';

	/// en: 'Permissions'
	String get permissions => 'Permissions';

	/// en: 'No files found'
	String get noFilesFound => 'No files found';

	/// en: 'Check if the project path is accessible'
	String get checkProjectPath => 'Check if the project path is accessible';

	/// en: 'Unable to load files'
	String get loadFailed => 'Unable to load files';

	/// en: 'No matches found'
	String get noMatchesFound => 'No matches found';

	/// en: 'No matches found'
	String get noSearchResults => 'No matches found';

	/// en: 'Try a different search term or clear the search'
	String get tryDifferentSearch => 'Try a different search term or clear the search';

	/// en: 'Search failed'
	String get searchError => 'Search failed';

	/// en: 'Searching...'
	String get searching => 'Searching...';

	/// en: 'Showing first {{count}} results'
	String resultsTruncated({required Object count}) => 'Showing first ${count} results';

	/// en: 'just now'
	String get justNow => 'just now';

	/// en: '{{count}} min ago'
	String minAgo({required Object count}) => '${count} min ago';

	/// en: '{{count}} hours ago'
	String hoursAgo({required Object count}) => '${count} hours ago';

	/// en: '{{count}} days ago'
	String daysAgo({required Object count}) => '${count} days ago';

	/// en: 'New File (Cmd+N)'
	String get newFile => 'New File (Cmd+N)';

	/// en: 'New Folder (Cmd+Shift+N)'
	String get newFolder => 'New Folder (Cmd+Shift+N)';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Collapse All'
	String get collapseAll => 'Collapse All';

	late final Translations$common$fileTree$context$en context = Translations$common$fileTree$context$en.internal(_root);

	/// en: 'All workspaces'
	String get allWorkspaces => 'All workspaces';

	late final Translations$common$fileTree$delete$en delete = Translations$common$fileTree$delete$en.internal(_root);

	/// en: 'Drop files to upload'
	String get dropToUpload => 'Drop files to upload';

	/// en: 'Drop files to upload to "{{folder}}"'
	String dropToUploadTo({required Object folder}) => 'Drop files to upload to "${folder}"';

	/// en: 'Add a project first'
	String get noProject => 'Add a project first';

	/// en: 'No files changed in the last 7 days'
	String get noRecentFiles => 'No files changed in the last 7 days';

	/// en: 'Show all files'
	String get showAllFiles => 'Show all files';

	/// en: 'Turn off the recent filter to see everything.'
	String get showAllFilesHint => 'Turn off the recent filter to see everything.';

	/// en: 'Show files changed in the last 7 days'
	String get showRecentOnly => 'Show files changed in the last 7 days';

	late final Translations$common$fileTree$toast$en toast = Translations$common$fileTree$toast$en.internal(_root);

	/// en: 'Upload complete'
	String get uploadComplete => 'Upload complete';

	/// en: 'Upload failed'
	String get uploadFailed => 'Upload failed';

	/// en: 'Upload files (max {{size}} each)'
	String uploadFiles({required Object size}) => 'Upload files (max ${size} each)';

	/// en: 'Upload files to "{{folder}}"'
	String uploadToFolder({required Object folder}) => 'Upload files to "${folder}"';

	/// en: 'Uploaded {{uploaded}} of {{total}} {{label}}'
	String uploadedCount({required Object uploaded, required Object total, required Object label}) => 'Uploaded ${uploaded} of ${total} ${label}';

	/// en: 'Uploading files'
	String get uploadingFiles => 'Uploading files';

	late final Translations$common$fileTree$validation$en validation = Translations$common$fileTree$validation$en.internal(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$en {
	Translations$common$projectWizard$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create New Project'
	String get title => 'Create New Project';

	late final Translations$common$projectWizard$steps$en steps = Translations$common$projectWizard$steps$en.internal(_root);
	late final Translations$common$projectWizard$step1$en step1 = Translations$common$projectWizard$step1$en.internal(_root);
	late final Translations$common$projectWizard$step2$en step2 = Translations$common$projectWizard$step2$en.internal(_root);
	late final Translations$common$projectWizard$step3$en step3 = Translations$common$projectWizard$step3$en.internal(_root);
	late final Translations$common$projectWizard$buttons$en buttons = Translations$common$projectWizard$buttons$en.internal(_root);
	late final Translations$common$projectWizard$errors$en errors = Translations$common$projectWizard$errors$en.internal(_root);
}

// Path: common.notifications
class Translations$common$notifications$en {
	Translations$common$notifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'a tool'
	String get genericTool => 'a tool';

	late final Translations$common$notifications$codes$en codes = Translations$common$notifications$codes$en.internal(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update Available'
	String get title => 'Update Available';

	/// en: 'A new version is ready'
	String get newVersionReady => 'A new version is ready';

	/// en: 'Current Version'
	String get currentVersion => 'Current Version';

	/// en: 'Latest Version'
	String get latestVersion => 'Latest Version';

	/// en: 'What's New:'
	String get whatsNew => 'What\'s New:';

	/// en: 'View full release'
	String get viewFullRelease => 'View full release';

	/// en: 'Update Progress:'
	String get updateProgress => 'Update Progress:';

	/// en: 'Manual upgrade:'
	String get manualUpgrade => 'Manual upgrade:';

	/// en: 'npm install -g @ddagent-ai/ddagent@latest'
	String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';

	/// en: 'Or click "Update Now" to run the update automatically.'
	String get manualUpgradeHint => 'Or click "Update Now" to run the update automatically.';

	/// en: 'Update completed successfully!'
	String get updateCompleted => 'Update completed successfully!';

	/// en: 'Please restart the server to apply changes.'
	String get restartServer => 'Please restart the server to apply changes.';

	/// en: 'Update failed'
	String get updateFailed => 'Update failed';

	late final Translations$common$versionUpdate$buttons$en buttons = Translations$common$versionUpdate$buttons$en.internal(_root);
	late final Translations$common$versionUpdate$ariaLabels$en ariaLabels = Translations$common$versionUpdate$ariaLabels$en.internal(_root);
}

// Path: common.actions
class Translations$common$actions$en {
	Translations$common$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Save'
	String get save => 'Save';
}

// Path: common.browserPane
class Translations$common$browserPane$en {
	Translations$common$browserPane$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Address'
	String get address => 'Address';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Connecting to browser…'
	String get connecting => 'Connecting to browser…';

	/// en: 'Browser connection failed.'
	String get connectionFailed => 'Browser connection failed.';

	/// en: 'Could not load {{url}}'
	String couldNotLoad({required Object url}) => 'Could not load ${url}';

	/// en: 'Browser view disconnected'
	String get disconnected => 'Browser view disconnected';

	/// en: 'Enter URL'
	String get enterUrl => 'Enter URL';

	/// en: 'Forward'
	String get forward => 'Forward';

	/// en: 'Enter a valid http(s) URL'
	String get invalidUrl => 'Enter a valid http(s) URL';

	/// en: 'No authentication token available.'
	String get noAuthToken => 'No authentication token available.';

	/// en: 'Open in system browser'
	String get openExternal => 'Open in system browser';

	/// en: 'Reload'
	String get reload => 'Reload';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Stop'
	String get stop => 'Stop';
}

// Path: common.browserUse
class Translations$common$browserUse$en {
	Translations$common$browserUse$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{count}} active'
	String activeCount({required Object count}) => '${count} active';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: '{{name}} will be permanently deleted.'
	String deleteDesc({required Object name}) => '${name} will be permanently deleted.';

	/// en: 'Delete session'
	String get deleteSession => 'Delete session';

	/// en: 'Delete browser session?'
	String get deleteTitle => 'Delete browser session?';

	late final Translations$common$browserUse$empty$en empty = Translations$common$browserUse$empty$en.internal(_root);

	/// en: 'empty'
	String get emptyStatus => 'empty';

	late final Translations$common$browserUse$errors$en errors = Translations$common$browserUse$errors$en.internal(_root);

	/// en: 'Full screen'
	String get fullscreen => 'Full screen';

	/// en: 'Install Runtime'
	String get installRuntime => 'Install Runtime';

	/// en: 'Installing...'
	String get installing => 'Installing...';

	/// en: 'Last action'
	String get lastAction => 'Last action';

	/// en: 'The next agent browser snapshot will render here.'
	String get nextSnapshot => 'The next agent browser snapshot will render here.';

	/// en: 'No page loaded'
	String get noPageLoaded => 'No page loaded';

	/// en: 'No agent browser sessions.'
	String get noSessions => 'No agent browser sessions.';

	/// en: 'None'
	String get none => 'None';

	/// en: 'Open Browser settings'
	String get openSettings => 'Open Browser settings';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Prompt'
	String get promptLabel => 'Prompt';

	late final Translations$common$browserUse$prompts$en prompts = Translations$common$browserUse$prompts$en.internal(_root);

	/// en: 'Refresh browser sessions'
	String get refresh => 'Refresh browser sessions';

	late final Translations$common$browserUse$relative$en relative = Translations$common$browserUse$relative$en.internal(_root);
	late final Translations$common$browserUse$runtime$en runtime = Translations$common$browserUse$runtime$en.internal(_root);

	/// en: 'Runtime setup required'
	String get runtimeSetup => 'Runtime setup required';

	/// en: 'Selected'
	String get selected => 'Selected';

	/// en: 'Browser session'
	String get sessionFallback => 'Browser session';

	/// en: 'Browser session screenshot'
	String get sessionScreenshot => 'Browser session screenshot';

	/// en: 'Sessions'
	String get sessions => 'Sessions';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Stop'
	String get stop => 'Stop';

	/// en: 'Stop session'
	String get stopSession => 'Stop session';

	/// en: 'Monitor browser sessions opened by AI agents.'
	String get subtitle => 'Monitor browser sessions opened by AI agents.';

	/// en: 'Temporary'
	String get temporary => 'Temporary';

	/// en: 'This session'
	String get thisSession => 'This session';

	/// en: 'Browser'
	String get title => 'Browser';

	/// en: '{{count}} total'
	String totalCount({required Object count}) => '${count} total';

	/// en: 'Updated {{time}}'
	String updated({required Object time}) => 'Updated ${time}';

	/// en: 'Waiting'
	String get waiting => 'Waiting';

	/// en: 'Waiting for screenshot'
	String get waitingForScreenshot => 'Waiting for screenshot';
}

// Path: common.commandPalette
class Translations$common$commandPalette$en {
	Translations$common$commandPalette$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Back to all'
	String get backToAll => 'Back to all';

	/// en: 'Backspace to go back'
	String get backspaceHint => 'Backspace to go back';

	late final Translations$common$commandPalette$browseAll$en browseAll = Translations$common$commandPalette$browseAll$en.internal(_root);
	late final Translations$common$commandPalette$compare$en compare = Translations$common$commandPalette$compare$en.internal(_root);
	late final Translations$common$commandPalette$groups$en groups = Translations$common$commandPalette$groups$en.internal(_root);
	late final Translations$common$commandPalette$hints$en hints = Translations$common$commandPalette$hints$en.internal(_root);
	late final Translations$common$commandPalette$items$en items = Translations$common$commandPalette$items$en.internal(_root);
	late final Translations$common$commandPalette$nav$en nav = Translations$common$commandPalette$nav$en.internal(_root);

	/// en: 'No results.'
	String get noResults => 'No results.';

	late final Translations$common$commandPalette$pages$en pages = Translations$common$commandPalette$pages$en.internal(_root);

	/// en: 'Type to search anything…'
	String get placeholder => 'Type to search anything…';

	/// en: 'Search {{page}}…'
	String searchPagePlaceholder({required Object page}) => 'Search ${page}…';

	/// en: 'Command palette'
	String get title => 'Command palette';
}

// Path: common.gitPanel
class Translations$common$gitPanel$en {
	Translations$common$gitPanel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{count}} ahead'
	String ahead({required Object count}) => '${count} ahead';

	/// en: 'ahead'
	String get aheadLabel => 'ahead';

	/// en: 'AI suggest'
	String get aiSuggest => 'AI suggest';

	/// en: 'Generate a commit message with AI'
	String get aiSuggestTitle => 'Generate a commit message with AI';

	/// en: 'All'
	String get all => 'All';

	/// en: 'All changes staged'
	String get allStaged => 'All changes staged';

	/// en: '{{count}} behind'
	String behind({required Object count}) => '${count} behind';

	/// en: 'behind'
	String get behindLabel => 'behind';

	late final Translations$common$gitPanel$branches$en branches = Translations$common$gitPanel$branches$en.internal(_root);

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Changes ({{count}})'
	String changesCount({required Object count}) => 'Changes (${count})';

	/// en: 'Clear search'
	String get clearSearch => 'Clear search';

	/// en: 'Collapse diff'
	String get collapseDiff => 'Collapse diff';

	/// en: 'Commit'
	String get commit => 'Commit';

	/// en: 'Commit Changes'
	String get commitChanges => 'Commit Changes';

	/// en: 'Commit {{count}} file(s)'
	String commitFiles({required Object count}) => 'Commit ${count} file(s)';

	/// en: 'Committing...'
	String get committing => 'Committing...';

	late final Translations$common$gitPanel$confirmActions$en confirmActions = Translations$common$gitPanel$confirmActions$en.internal(_root);

	/// en: 'Commit {{count}} file(s) with message: "{{message}}"?'
	String confirmCommit({required Object count, required Object message}) => 'Commit ${count} file(s) with message: "${message}"?';

	/// en: 'Delete untracked file "{{file}}"? This action cannot be undone.'
	String confirmDeleteFile({required Object file}) => 'Delete untracked file "${file}"? This action cannot be undone.';

	/// en: 'Discard all changes to "{{file}}"? This action cannot be undone.'
	String confirmDiscardFile({required Object file}) => 'Discard all changes to "${file}"? This action cannot be undone.';

	/// en: 'Publish branch "{{branch}}" to {{remote}}?'
	String confirmPublish({required Object branch, required Object remote}) => 'Publish branch "${branch}" to ${remote}?';

	/// en: 'Pull {{count}} commit(s) from {{remote}}?'
	String confirmPull({required Object count, required Object remote}) => 'Pull ${count} commit(s) from ${remote}?';

	/// en: 'Push {{count}} commit(s) to {{remote}}?'
	String confirmPush({required Object count, required Object remote}) => 'Push ${count} commit(s) to ${remote}?';

	/// en: 'Revert the latest local commit? This removes the commit but keeps its changes staged.'
	String get confirmRevert => 'Revert the latest local commit? This removes the commit but keeps its changes staged.';

	late final Translations$common$gitPanel$confirmTitles$en confirmTitles = Translations$common$gitPanel$confirmTitles$en.internal(_root);

	/// en: 'Create new branch'
	String get createBranch => 'Create new branch';

	/// en: 'Creating...'
	String get creating => 'Creating...';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete untracked file'
	String get deleteUntracked => 'Delete untracked file';

	/// en: 'Deselect All'
	String get deselectAll => 'Deselect All';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Discard changes'
	String get discardChanges => 'Discard changes';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';

	/// en: 'Dismiss error'
	String get dismissError => 'Dismiss error';

	late final Translations$common$gitPanel$errors$en errors = Translations$common$gitPanel$errors$en.internal(_root);

	/// en: 'Expand diff'
	String get expandDiff => 'Expand diff';

	/// en: 'Fetch'
	String get fetch => 'Fetch';

	/// en: 'Fetch from {{remote}}'
	String fetchTitle({required Object remote}) => 'Fetch from ${remote}';

	/// en: 'Fetching…'
	String get fetching => 'Fetching…';

	/// en: '{{count}} file(s) selected'
	String filesSelected({required Object count}) => '${count} file(s) selected';

	/// en: 'Generating...'
	String get generating => 'Generating...';

	late final Translations$common$gitPanel$history$en history = Translations$common$gitPanel$history$en.internal(_root);
	late final Translations$common$gitPanel$mergeWorktree$en mergeWorktree = Translations$common$gitPanel$mergeWorktree$en.internal(_root);

	/// en: 'Merging...'
	String get merging => 'Merging...';

	/// en: 'Message (Ctrl+Enter to commit)'
	String get messagePlaceholder => 'Message (Ctrl+Enter to commit)';

	late final Translations$common$gitPanel$newBranch$en newBranch = Translations$common$gitPanel$newBranch$en.internal(_root);
	late final Translations$common$gitPanel$newWorktree$en newWorktree = Translations$common$gitPanel$newWorktree$en.internal(_root);

	/// en: 'No changes detected'
	String get noChanges => 'No changes detected';

	/// en: 'No changes to commit'
	String get noChangesToCommit => 'No changes to commit';

	late final Translations$common$gitPanel$noCommits$en noCommits = Translations$common$gitPanel$noCommits$en.internal(_root);

	/// en: 'No matching branches'
	String get noMatchingBranches => 'No matching branches';

	late final Translations$common$gitPanel$noRepo$en noRepo = Translations$common$gitPanel$noRepo$en.internal(_root);

	/// en: 'No staged files'
	String get noStagedFiles => 'No staged files';

	/// en: 'None'
	String get none => 'None';

	/// en: 'Nothing to push to {{remote}}'
	String nothingToPush({required Object remote}) => 'Nothing to push to ${remote}';

	/// en: 'Click to open file'
	String get openFile => 'Click to open file';

	/// en: 'Publish'
	String get publish => 'Publish';

	/// en: 'Publish "{{branch}}" to {{remote}}'
	String publishTitle({required Object branch, required Object remote}) => 'Publish "${branch}" to ${remote}';

	/// en: 'Publishing…'
	String get publishing => 'Publishing…';

	/// en: 'Pull'
	String get pull => 'Pull';

	/// en: 'Pull {{count}}'
	String pullCount({required Object count}) => 'Pull ${count}';

	/// en: 'Pull {{count}} from {{remote}}'
	String pullTitle({required Object count, required Object remote}) => 'Pull ${count} from ${remote}';

	/// en: 'Pulling…'
	String get pulling => 'Pulling…';

	/// en: 'Push'
	String get push => 'Push';

	/// en: 'Push {{count}}'
	String pushCount({required Object count}) => 'Push ${count}';

	/// en: 'Push {{count}} to {{remote}}'
	String pushTitle({required Object count, required Object remote}) => 'Push ${count} to ${remote}';

	/// en: 'Pushing…'
	String get pushing => 'Pushing…';

	/// en: 'Recent commits'
	String get recentCommits => 'Recent commits';

	/// en: 'Refresh git status'
	String get refresh => 'Refresh git status';

	/// en: 'Remove'
	String get remove => 'Remove';

	late final Translations$common$gitPanel$removeWorktree$en removeWorktree = Translations$common$gitPanel$removeWorktree$en.internal(_root);

	/// en: 'Removing...'
	String get removing => 'Removing...';

	/// en: 'Revert latest local commit'
	String get revertLatest => 'Revert latest local commit';

	/// en: 'Scroll'
	String get scroll => 'Scroll';

	/// en: 'Search branches...'
	String get searchBranches => 'Search branches...';

	/// en: 'Select All'
	String get selectAll => 'Select All';

	/// en: 'Select a project to view source control'
	String get selectProject => 'Select a project to view source control';

	/// en: '{{selected}} of {{total}} files selected'
	String selectedOf({required Object selected, required Object total}) => '${selected} of ${total} files selected';

	/// en: '{{selected}} of {{total}} selected'
	String selectedOfMobile({required Object selected, required Object total}) => '${selected} of ${total} selected';

	/// en: 'Side-by-side'
	String get sideBySide => 'Side-by-side';

	/// en: 'Stage All'
	String get stageAll => 'Stage All';

	/// en: 'Stage this hunk'
	String get stageHunk => 'Stage this hunk';

	/// en: 'Staged ({{count}})'
	String staged({required Object count}) => 'Staged (${count})';

	late final Translations$common$gitPanel$status$en status = Translations$common$gitPanel$status$en.internal(_root);

	/// en: 'File Status Guide'
	String get statusGuide => 'File Status Guide';

	/// en: 'Switch to horizontal scroll'
	String get switchScroll => 'Switch to horizontal scroll';

	/// en: 'Switch to side-by-side view'
	String get switchSplit => 'Switch to side-by-side view';

	/// en: 'Switch to unified view'
	String get switchUnified => 'Switch to unified view';

	/// en: 'Switch to text wrap'
	String get switchWrap => 'Switch to text wrap';

	/// en: 'Unified'
	String get unified => 'Unified';

	/// en: 'Unstage All'
	String get unstageAll => 'Unstage All';

	/// en: 'Unstage this hunk'
	String get unstageHunk => 'Unstage this hunk';

	/// en: 'Up to date'
	String get upToDate => 'Up to date';

	/// en: 'Up to date with {{remote}}'
	String upToDateWith({required Object remote}) => 'Up to date with ${remote}';

	/// en: 'View all'
	String get viewAll => 'View all';

	/// en: 'Source control views'
	String get viewsAria => 'Source control views';

	late final Translations$common$gitPanel$worktrees$en worktrees = Translations$common$gitPanel$worktrees$en.internal(_root);

	/// en: 'Wrap'
	String get wrap => 'Wrap';

	late final Translations$common$gitPanel$tabs$en tabs = Translations$common$gitPanel$tabs$en.internal(_root);

	/// en: 'Save'
	String get save => 'Save';

	late final Translations$common$gitPanel$worktreeScripts$en worktreeScripts = Translations$common$gitPanel$worktreeScripts$en.internal(_root);
}

// Path: common.sessions
class Translations$common$sessions$en {
	Translations$common$sessions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rename session'
	String get renameSession => 'Rename session';
}

// Path: common.projects
class Translations$common$projects$en {
	Translations$common$projects$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Session'
	String get newSession => 'New Session';
}

// Path: common.previewPane
class Translations$common$previewPane$en {
	Translations$common$previewPane$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not load ports'
	String get loadError => 'Could not load ports';

	/// en: 'No dev servers detected'
	String get noServers => 'No dev servers detected';

	/// en: 'Open in system browser'
	String get openExternal => 'Open in system browser';

	/// en: 'Reload preview'
	String get reload => 'Reload preview';

	/// en: 'Dev server port'
	String get selectPort => 'Dev server port';

	/// en: 'Dev server preview'
	String get title => 'Dev server preview';
}

// Path: common.sharedNotes
class Translations$common$sharedNotes$en {
	Translations$common$sharedNotes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shared memory — injected into every session of this project'
	String get subtitle => 'Shared memory — injected into every session of this project';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Saving…'
	String get saving => 'Saving…';

	/// en: 'Select a workspace to edit its shared context'
	String get noProject => 'Select a workspace to edit its shared context';

	/// en: '# Shared context Conventions, decisions and pointers every agent should know…'
	String get placeholder => '# Shared context\nConventions, decisions and pointers every agent should know…';
}

// Path: common.codeBlock
class Translations$common$codeBlock$en {
	Translations$common$codeBlock$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Wrap lines'
	String get wrapLines => 'Wrap lines';

	/// en: 'No wrap'
	String get noWrap => 'No wrap';
}

// Path: common.update
class Translations$common$update$en {
	Translations$common$update$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update available · v{{version}}'
	String available({required Object version}) => 'Update available · v${version}';

	/// en: 'Update to v{{version}}? The server updates itself and restarts — active sessions will be interrupted.'
	String confirm({required Object version}) => 'Update to v${version}? The server updates itself and restarts — active sessions will be interrupted.';

	/// en: 'Downloading and applying the update…'
	String get downloading => 'Downloading and applying the update…';

	/// en: 'Restarting the server — this takes a moment…'
	String get restarting => 'Restarting the server — this takes a moment…';

	/// en: 'Updated to v{{version}}. Reload the app to pick up the new bundle.'
	String done({required Object version}) => 'Updated to v${version}. Reload the app to pick up the new bundle.';

	/// en: 'The update was applied but the server did not restart on its own — restart it manually to finish.'
	String get manualRestart => 'The update was applied but the server did not restart on its own — restart it manually to finish.';

	/// en: 'Update failed.'
	String get failed => 'Update failed.';

	/// en: 'Update failed'
	String get failedTitle => 'Update failed';

	/// en: 'Install ddagent v{{version}} on this device? Android will ask you to allow installs from ddagent the first time.'
	String appConfirm({required Object version}) => 'Install ddagent v${version} on this device? Android will ask you to allow installs from ddagent the first time.';

	/// en: 'Allow “Install unknown apps” for ddagent, then tap Update again.'
	String get appPermission => 'Allow “Install unknown apps” for ddagent, then tap Update again.';
}

// Path: settings.changelog
class Translations$settings$changelog$en {
	Translations$settings$changelog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Changelog'
	String get title => 'Changelog';

	/// en: 'Loading…'
	String get loading => 'Loading…';

	/// en: 'No releases to show'
	String get empty => 'No releases to show';

	/// en: 'current'
	String get current => 'current';

	/// en: 'new'
	String get kNew => 'new';
}

// Path: settings.server
class Translations$settings$server$en {
	Translations$settings$server$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Server'
	String get title => 'Server';

	/// en: 'Restart the ddagent process to apply updates or recover from a stuck state.'
	String get description => 'Restart the ddagent process to apply updates or recover from a stuck state.';

	/// en: 'Restart'
	String get restart => 'Restart';

	/// en: 'Restart the ddagent server? Active sessions will be interrupted.'
	String get restartConfirm => 'Restart the ddagent server? Active sessions will be interrupted.';

	/// en: 'Restarting… the page will reload when the server is back.'
	String get restarting => 'Restarting… the page will reload when the server is back.';

	/// en: 'Restart failed'
	String get restartFailed => 'Restart failed';

	/// en: 'Restart is only available when the server runs under the service manager.'
	String get unsupported => 'Restart is only available when the server runs under the service manager.';

	/// en: 'OK'
	String get ok => 'OK';
}

// Path: settings.updates
class Translations$settings$updates$en {
	Translations$settings$updates$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'App updates'
	String get title => 'App updates';

	/// en: 'Check GitHub for a newer desktop build. New versions download automatically and install when you quit.'
	String get description => 'Check GitHub for a newer desktop build. New versions download automatically and install when you quit.';

	/// en: 'Check GitHub for a newer build of this app. Updates are installed by your device's system installer.'
	String get descriptionMobile => 'Check GitHub for a newer build of this app. Updates are installed by your device\'s system installer.';

	/// en: 'Check for updates'
	String get check => 'Check for updates';

	/// en: 'Checking…'
	String get checking => 'Checking…';

	/// en: 'You are on the latest version (v{{version}}).'
	String upToDate({required Object version}) => 'You are on the latest version (v${version}).';

	/// en: 'Update v{{version}} found — downloading in the background; it installs when you quit ddagent.'
	String available({required Object version}) => 'Update v${version} found — downloading in the background; it installs when you quit ddagent.';

	/// en: 'App update v{{version}} available — tap Update to install it on this device.'
	String appAvailable({required Object version}) => 'App update v${version} available — tap Update to install it on this device.';

	/// en: 'Update v{{version}} downloaded — quit and relaunch ddagent to install.'
	String downloaded({required Object version}) => 'Update v${version} downloaded — quit and relaunch ddagent to install.';

	/// en: 'Update checks are only available in packaged desktop builds.'
	String get unavailable => 'Update checks are only available in packaged desktop builds.';

	/// en: 'Update check failed: {{message}}'
	String error({required Object message}) => 'Update check failed: ${message}';

	/// en: 'Update check failed.'
	String get errorGeneric => 'Update check failed.';
}

// Path: settings.tabs
class Translations$settings$tabs$en {
	Translations$settings$tabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Permissions'
	String get permissions => 'Permissions';

	/// en: 'MCP Servers'
	String get mcpServers => 'MCP Servers';

	/// en: 'Skills'
	String get skills => 'Skills';

	/// en: 'Appearance'
	String get appearance => 'Appearance';
}

// Path: settings.account
class Translations$settings$account$en {
	Translations$settings$account$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get title => 'Account';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Display Language'
	String get languageLabel => 'Display Language';

	/// en: 'Choose your preferred language for the interface'
	String get languageDescription => 'Choose your preferred language for the interface';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Change Password'
	String get changePassword => 'Change Password';
}

// Path: settings.mcp
class Translations$settings$mcp$en {
	Translations$settings$mcp$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'MCP Servers'
	String get title => 'MCP Servers';

	/// en: 'Add Server'
	String get addServer => 'Add Server';

	/// en: 'Edit Server'
	String get editServer => 'Edit Server';

	/// en: 'Delete Server'
	String get deleteServer => 'Delete Server';

	/// en: 'Server Name'
	String get serverName => 'Server Name';

	/// en: 'Server Type'
	String get serverType => 'Server Type';

	/// en: 'Configuration'
	String get config => 'Configuration';

	/// en: 'Test Connection'
	String get testConnection => 'Test Connection';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Connected'
	String get connected => 'Connected';

	/// en: 'Disconnected'
	String get disconnected => 'Disconnected';

	late final Translations$settings$mcp$scope$en scope = Translations$settings$mcp$scope$en.internal(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$en {
	Translations$settings$appearance$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get title => 'Appearance';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Code Editor'
	String get codeEditor => 'Code Editor';

	/// en: 'Editor Theme'
	String get editorTheme => 'Editor Theme';

	/// en: 'Word Wrap'
	String get wordWrap => 'Word Wrap';

	/// en: 'Show Minimap'
	String get showMinimap => 'Show Minimap';

	/// en: 'Line Numbers'
	String get lineNumbers => 'Line Numbers';

	/// en: 'Font Size'
	String get fontSize => 'Font Size';

	late final Translations$settings$appearance$themeModes$en themeModes = Translations$settings$appearance$themeModes$en.internal(_root);
}

// Path: settings.actions
class Translations$settings$actions$en {
	Translations$settings$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Reset to Defaults'
	String get resetToDefaults => 'Reset to Defaults';

	/// en: 'Cancel Changes'
	String get cancelChanges => 'Cancel Changes';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Quick Settings'
	String get title => 'Quick Settings';

	late final Translations$settings$quickSettings$sections$en sections = Translations$settings$quickSettings$sections$en.internal(_root);

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Show raw parameters'
	String get showRawParameters => 'Show raw parameters';

	/// en: 'Show thinking'
	String get showThinking => 'Show thinking';

	/// en: 'Send by Ctrl+Enter'
	String get sendByCtrlEnter => 'Send by Ctrl+Enter';

	/// en: 'When enabled, pressing Ctrl+Enter will send the message instead of just Enter. This is useful for IME users to avoid accidental sends.'
	String get sendByCtrlEnterDescription => 'When enabled, pressing Ctrl+Enter will send the message instead of just Enter. This is useful for IME users to avoid accidental sends.';

	late final Translations$settings$quickSettings$dragHandle$en dragHandle = Translations$settings$quickSettings$dragHandle$en.internal(_root);

	/// en: 'Send with Ctrl+Enter'
	String get sendWithCtrlEnter => 'Send with Ctrl+Enter';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Terminal Shortcuts'
	String get title => 'Terminal Shortcuts';

	/// en: 'Keys'
	String get sectionKeys => 'Keys';

	/// en: 'Navigation'
	String get sectionNavigation => 'Navigation';

	/// en: 'Escape'
	String get escape => 'Escape';

	/// en: 'Tab'
	String get tab => 'Tab';

	/// en: 'Shift+Tab'
	String get shiftTab => 'Shift+Tab';

	/// en: 'Arrow Up'
	String get arrowUp => 'Arrow Up';

	/// en: 'Arrow Down'
	String get arrowDown => 'Arrow Down';

	/// en: 'Scroll Down'
	String get scrollDown => 'Scroll Down';

	/// en: 'Kill running process (Ctrl+C)'
	String get killTitle => 'Kill running process (Ctrl+C)';

	late final Translations$settings$terminalShortcuts$handle$en handle = Translations$settings$terminalShortcuts$handle$en.internal(_root);

	/// en: 'Paste'
	String get paste => 'Paste';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get label => 'Settings';

	/// en: 'Agents'
	String get agents => 'Agents';

	/// en: 'Orchestration'
	String get orchestration => 'Orchestration';

	/// en: 'Mini orchestration'
	String get miniOrchestration => 'Mini orchestration';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Workspaces'
	String get workspaces => 'Workspaces';

	/// en: 'Git'
	String get git => 'Git';

	/// en: 'API & Tokens'
	String get apiTokens => 'API & Tokens';

	/// en: 'Models'
	String get models => 'Models';

	/// en: 'Tasks'
	String get tasks => 'Tasks';

	/// en: 'Browser'
	String get browser => 'Browser';

	/// en: 'Tools'
	String get tools => 'Tools';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Control Center'
	String get quota => 'Control Center';

	/// en: 'Keyboard shortcuts'
	String get shortcuts => 'Keyboard shortcuts';
}

// Path: settings.miniOrchestration
class Translations$settings$miniOrchestration$en {
	Translations$settings$miniOrchestration$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mini orchestration'
	String get title => 'Mini orchestration';

	/// en: 'A two-model pipeline: a non-flash thinker plans, a flash worker executes.'
	String get description => 'A two-model pipeline: a non-flash thinker plans, a flash worker executes.';

	/// en: 'Loading mini orchestration settings…'
	String get loading => 'Loading mini orchestration settings…';

	/// en: 'Could not load the mini orchestration settings.'
	String get loadError => 'Could not load the mini orchestration settings.';

	late final Translations$settings$miniOrchestration$enable$en enable = Translations$settings$miniOrchestration$enable$en.internal(_root);
	late final Translations$settings$miniOrchestration$thinker$en thinker = Translations$settings$miniOrchestration$thinker$en.internal(_root);
	late final Translations$settings$miniOrchestration$worker$en worker = Translations$settings$miniOrchestration$worker$en.internal(_root);
	late final Translations$settings$miniOrchestration$fields$en fields = Translations$settings$miniOrchestration$fields$en.internal(_root);
	late final Translations$settings$miniOrchestration$roles$en roles = Translations$settings$miniOrchestration$roles$en.internal(_root);
	late final Translations$settings$miniOrchestration$planner$en planner = Translations$settings$miniOrchestration$planner$en.internal(_root);
}

// Path: settings.orchestration
class Translations$settings$orchestration$en {
	Translations$settings$orchestration$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Orchestration'
	String get title => 'Orchestration';

	/// en: 'Route chat tasks across your providers and models.'
	String get description => 'Route chat tasks across your providers and models.';

	/// en: 'Loading orchestration settings…'
	String get loading => 'Loading orchestration settings…';

	/// en: 'Could not load the orchestration settings.'
	String get loadError => 'Could not load the orchestration settings.';

	/// en: 'Retry'
	String get retry => 'Retry';

	late final Translations$settings$orchestration$enable$en enable = Translations$settings$orchestration$enable$en.internal(_root);
	late final Translations$settings$orchestration$pool$en pool = Translations$settings$orchestration$pool$en.internal(_root);
	late final Translations$settings$orchestration$tiers$en tiers = Translations$settings$orchestration$tiers$en.internal(_root);
	late final Translations$settings$orchestration$rules$en rules = Translations$settings$orchestration$rules$en.internal(_root);
	late final Translations$settings$orchestration$planner$en planner = Translations$settings$orchestration$planner$en.internal(_root);
	late final Translations$settings$orchestration$execution$en execution = Translations$settings$orchestration$execution$en.internal(_root);
	late final Translations$settings$orchestration$save$en save = Translations$settings$orchestration$save$en.internal(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$en {
	Translations$settings$notifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get title => 'Notifications';

	/// en: 'Control which notification events you receive.'
	String get description => 'Control which notification events you receive.';

	late final Translations$settings$notifications$webPush$en webPush = Translations$settings$notifications$webPush$en.internal(_root);
	late final Translations$settings$notifications$device$en device = Translations$settings$notifications$device$en.internal(_root);
	late final Translations$settings$notifications$desktop$en desktop = Translations$settings$notifications$desktop$en.internal(_root);
	late final Translations$settings$notifications$sound$en sound = Translations$settings$notifications$sound$en.internal(_root);
	late final Translations$settings$notifications$events$en events = Translations$settings$notifications$events$en.internal(_root);
	late final Translations$settings$notifications$messaging$en messaging = Translations$settings$notifications$messaging$en.internal(_root);
	late final Translations$settings$notifications$channels$en channels = Translations$settings$notifications$channels$en.internal(_root);

	/// en: 'Unpair'
	String get unpair => 'Unpair';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$appearanceSettings$darkMode$en darkMode = Translations$settings$appearanceSettings$darkMode$en.internal(_root);
	late final Translations$settings$appearanceSettings$codeEditor$en codeEditor = Translations$settings$appearanceSettings$codeEditor$en.internal(_root);
	late final Translations$settings$appearanceSettings$terminal$en terminal = Translations$settings$appearanceSettings$terminal$en.internal(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$mcpForm$title$en title = Translations$settings$mcpForm$title$en.internal(_root);
	late final Translations$settings$mcpForm$importMode$en importMode = Translations$settings$mcpForm$importMode$en.internal(_root);
	late final Translations$settings$mcpForm$scope$en scope = Translations$settings$mcpForm$scope$en.internal(_root);
	late final Translations$settings$mcpForm$fields$en fields = Translations$settings$mcpForm$fields$en.internal(_root);
	late final Translations$settings$mcpForm$placeholders$en placeholders = Translations$settings$mcpForm$placeholders$en.internal(_root);
	late final Translations$settings$mcpForm$validation$en validation = Translations$settings$mcpForm$validation$en.internal(_root);

	/// en: 'Configuration Details (from {{configFile}})'
	String configDetails({required Object configFile}) => 'Configuration Details (from ${configFile})';

	/// en: 'Path: {{path}}'
	String projectPath({required Object path}) => 'Path: ${path}';

	late final Translations$settings$mcpForm$actions$en actions = Translations$settings$mcpForm$actions$en.internal(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings saved successfully!'
	String get success => 'Settings saved successfully!';

	/// en: 'Failed to save settings'
	String get error => 'Failed to save settings';

	/// en: 'Saving...'
	String get saving => 'Saving...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$en {
	Translations$settings$footerActions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save Settings'
	String get save => 'Save Settings';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: settings.git
class Translations$settings$git$en {
	Translations$settings$git$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Git Configuration'
	String get title => 'Git Configuration';

	/// en: 'Configure your git identity for commits. These settings will be applied globally via git config --global'
	String get description => 'Configure your git identity for commits. These settings will be applied globally via git config --global';

	late final Translations$settings$git$name$en name = Translations$settings$git$name$en.internal(_root);
	late final Translations$settings$git$email$en email = Translations$settings$git$email$en.internal(_root);
	late final Translations$settings$git$actions$en actions = Translations$settings$git$actions$en.internal(_root);
	late final Translations$settings$git$status$en status = Translations$settings$git$status$en.internal(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'API Keys'
	String get title => 'API Keys';

	/// en: 'Generate API keys to access the external API from other applications.'
	String get description => 'Generate API keys to access the external API from other applications.';

	late final Translations$settings$apiKeys$newKey$en newKey = Translations$settings$apiKeys$newKey$en.internal(_root);
	late final Translations$settings$apiKeys$form$en form = Translations$settings$apiKeys$form$en.internal(_root);

	/// en: 'New API Key'
	String get newButton => 'New API Key';

	/// en: 'No API keys created yet.'
	String get empty => 'No API keys created yet.';

	late final Translations$settings$apiKeys$list$en list = Translations$settings$apiKeys$list$en.internal(_root);

	/// en: 'Are you sure you want to delete this API key?'
	String get confirmDelete => 'Are you sure you want to delete this API key?';

	late final Translations$settings$apiKeys$status$en status = Translations$settings$apiKeys$status$en.internal(_root);
	late final Translations$settings$apiKeys$github$en github = Translations$settings$apiKeys$github$en.internal(_root);

	/// en: 'API Documentation'
	String get apiDocsLink => 'API Documentation';

	late final Translations$settings$apiKeys$documentation$en documentation = Translations$settings$apiKeys$documentation$en.internal(_root);

	/// en: 'Loading...'
	String get loading => 'Loading...';

	late final Translations$settings$apiKeys$version$en version = Translations$settings$apiKeys$version$en.internal(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$en {
	Translations$settings$tasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checking TaskMaster installation...'
	String get checking => 'Checking TaskMaster installation...';

	late final Translations$settings$tasks$notInstalled$en notInstalled = Translations$settings$tasks$notInstalled$en.internal(_root);
	late final Translations$settings$tasks$settings$en settings = Translations$settings$tasks$settings$en.internal(_root);
}

// Path: settings.agents
class Translations$settings$agents$en {
	Translations$settings$agents$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$agents$authStatus$en authStatus = Translations$settings$agents$authStatus$en.internal(_root);
	late final Translations$settings$agents$install$en install = Translations$settings$agents$install$en.internal(_root);
	late final Translations$settings$agents$account$en account = Translations$settings$agents$account$en.internal(_root);

	/// en: 'Connection Status'
	String get connectionStatus => 'Connection Status';

	late final Translations$settings$agents$login$en login = Translations$settings$agents$login$en.internal(_root);

	/// en: 'Error: {{error}}'
	String error({required Object error}) => 'Error: ${error}';

	late final Translations$settings$agents$accounts$en accounts = Translations$settings$agents$accounts$en.internal(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$en {
	Translations$settings$permissions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permission Settings'
	String get title => 'Permission Settings';

	late final Translations$settings$permissions$skipPermissions$en skipPermissions = Translations$settings$permissions$skipPermissions$en.internal(_root);
	late final Translations$settings$permissions$allowedTools$en allowedTools = Translations$settings$permissions$allowedTools$en.internal(_root);
	late final Translations$settings$permissions$blockedTools$en blockedTools = Translations$settings$permissions$blockedTools$en.internal(_root);
	late final Translations$settings$permissions$allowedCommands$en allowedCommands = Translations$settings$permissions$allowedCommands$en.internal(_root);
	late final Translations$settings$permissions$blockedCommands$en blockedCommands = Translations$settings$permissions$blockedCommands$en.internal(_root);
	late final Translations$settings$permissions$toolExamples$en toolExamples = Translations$settings$permissions$toolExamples$en.internal(_root);
	late final Translations$settings$permissions$shellExamples$en shellExamples = Translations$settings$permissions$shellExamples$en.internal(_root);
	late final Translations$settings$permissions$codex$en codex = Translations$settings$permissions$codex$en.internal(_root);
	late final Translations$settings$permissions$permissionMode$en permissionMode = Translations$settings$permissions$permissionMode$en.internal(_root);
	late final Translations$settings$permissions$actions$en actions = Translations$settings$permissions$actions$en.internal(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'MCP Servers'
	String get title => 'MCP Servers';

	late final Translations$settings$mcpServers$description$en description = Translations$settings$mcpServers$description$en.internal(_root);

	/// en: 'Add MCP Server'
	String get addButton => 'Add MCP Server';

	/// en: 'No MCP servers configured'
	String get empty => 'No MCP servers configured';

	/// en: 'Type'
	String get serverType => 'Type';

	late final Translations$settings$mcpServers$scope$en scope = Translations$settings$mcpServers$scope$en.internal(_root);
	late final Translations$settings$mcpServers$config$en config = Translations$settings$mcpServers$config$en.internal(_root);
	late final Translations$settings$mcpServers$tools$en tools = Translations$settings$mcpServers$tools$en.internal(_root);
	late final Translations$settings$mcpServers$actions$en actions = Translations$settings$mcpServers$actions$en.internal(_root);
	late final Translations$settings$mcpServers$managed$en managed = Translations$settings$mcpServers$managed$en.internal(_root);
	late final Translations$settings$mcpServers$help$en help = Translations$settings$mcpServers$help$en.internal(_root);
	late final Translations$settings$mcpServers$deleteConfirm$en deleteConfirm = Translations$settings$mcpServers$deleteConfirm$en.internal(_root);
}

// Path: settings.quota
class Translations$settings$quota$en {
	Translations$settings$quota$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$quota$settings$en settings = Translations$settings$quota$settings$en.internal(_root);
	late final Translations$settings$quota$empty$en empty = Translations$settings$quota$empty$en.internal(_root);
	late final Translations$settings$quota$quality$en quality = Translations$settings$quota$quality$en.internal(_root);

	/// en: 'Sync failed'
	String get syncFailed => 'Sync failed';

	/// en: 'Sync now'
	String get syncNow => 'Sync now';
}

// Path: settings.browser
class Translations$settings$browser$en {
	Translations$settings$browser$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'checking...'
	String get checking => 'checking...';

	/// en: 'Allow agents to create guarded Playwright browser sessions that you can monitor from the Browser tab.'
	String get description => 'Allow agents to create guarded Playwright browser sessions that you can monitor from the Browser tab.';

	/// en: 'Registers Browser for supported agents. Agents can create browser sessions; you can watch, stop, and delete them.'
	String get enableDescription => 'Registers Browser for supported agents. Agents can create browser sessions; you can watch, stop, and delete them.';

	/// en: 'Enable Browser'
	String get enableLabel => 'Enable Browser';

	late final Translations$settings$browser$errors$en errors = Translations$settings$browser$errors$en.internal(_root);

	/// en: 'Install the browser runtime before agents can create Browser sessions.'
	String get installHint => 'Install the browser runtime before agents can create Browser sessions.';

	/// en: 'Install Runtime'
	String get installRuntime => 'Install Runtime';

	/// en: 'installed'
	String get installed => 'installed';

	/// en: 'Installing...'
	String get installing => 'Installing...';

	/// en: 'missing'
	String get missing => 'missing';

	/// en: 'Browser runtime required'
	String get runtimeRequired => 'Browser runtime required';

	/// en: 'disabled'
	String get statusDisabled => 'disabled';

	/// en: 'Status'
	String get statusLabel => 'Status';

	/// en: 'ready'
	String get statusReady => 'ready';

	/// en: 'setup required'
	String get statusSetupRequired => 'setup required';

	/// en: 'Browser'
	String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$en {
	Translations$settings$workspaces$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Add workspace'
	String get create => 'Add workspace';

	/// en: 'Remove this workspace from ddagent? Its files stay on disk.'
	String get deleteConfirm => 'Remove this workspace from ddagent? Its files stay on disk.';

	/// en: 'Failed to remove workspace.'
	String get deleteFailed => 'Failed to remove workspace.';

	/// en: 'Remove workspace'
	String get deleteTitle => 'Remove workspace';

	/// en: 'Workspaces are directories ddagent can chat, run code, and browse inside.'
	String get description => 'Workspaces are directories ddagent can chat, run code, and browse inside.';

	/// en: 'Remove workspace'
	String get remove => 'Remove workspace';

	/// en: 'Workspaces'
	String get title => 'Workspaces';

	/// en: 'Path is required'
	String get pathRequired => 'Path is required';
}

// Path: settings.stt
class Translations$settings$stt$en {
	Translations$settings$stt$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Voice input (speech-to-text)'
	String get title => 'Voice input (speech-to-text)';

	/// en: 'Whisper-compatible /audio/transcriptions endpoint (OpenAI, whisper.cpp, faster-whisper, Speaches). Enables the mic button in the composer.'
	String get description => 'Whisper-compatible /audio/transcriptions endpoint (OpenAI, whisper.cpp, faster-whisper, Speaches). Enables the mic button in the composer.';

	/// en: 'configured'
	String get configured => 'configured';

	/// en: 'Endpoint URL (e.g. https://api.openai.com/v1)'
	String get endpoint => 'Endpoint URL (e.g. https://api.openai.com/v1)';

	/// en: 'API key'
	String get apiKey => 'API key';

	/// en: 'Model (default: whisper-1)'
	String get model => 'Model (default: whisper-1)';

	/// en: 'Save'
	String get save => 'Save';
}

// Path: settings.schedules
class Translations$settings$schedules$en {
	Translations$settings$schedules$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Schedules'
	String get title => 'Schedules';

	/// en: 'Recurring agent runs on a cron timetable. Runs fire unattended with permissions bypassed.'
	String get description => 'Recurring agent runs on a cron timetable. Runs fire unattended with permissions bypassed.';

	/// en: 'Prevent sleep while agents run'
	String get preventSleep => 'Prevent sleep while agents run';

	/// en: 'Desktop keeps the display awake; in the browser a screen wake lock is used.'
	String get preventSleepHint => 'Desktop keeps the display awake; in the browser a screen wake lock is used.';

	/// en: 'New schedule'
	String get kNew => 'New schedule';

	/// en: 'Loading…'
	String get loading => 'Loading…';

	/// en: 'No schedules yet.'
	String get empty => 'No schedules yet.';

	/// en: 'Project'
	String get project => 'Project';

	/// en: 'Provider'
	String get provider => 'Provider';

	/// en: 'Cron (min hour day month weekday)'
	String get cron => 'Cron (min hour day month weekday)';

	/// en: 'Next run: {{time}}'
	String nextRun({required Object time}) => 'Next run: ${time}';

	/// en: 'No upcoming run for this expression'
	String get cronInvalid => 'No upcoming run for this expression';

	/// en: 'Prompt'
	String get prompt => 'Prompt';

	/// en: 'Run in a fresh worktree'
	String get useWorktree => 'Run in a fresh worktree';

	/// en: 'Catch up missed runs'
	String get catchUp => 'Catch up missed runs';

	/// en: '{{count}} failures'
	String failures({required Object count}) => '${count} failures';

	/// en: 'disabled'
	String get disabled => 'disabled';

	/// en: 'History'
	String get history => 'History';

	/// en: 'Run now'
	String get runNow => 'Run now';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'No runs yet.'
	String get noRuns => 'No runs yet.';

	/// en: 'next'
	String get next => 'next';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'Enable schedule'
	String get toggleSchedule => 'Enable schedule';
}

// Path: settings.mcpTokens
class Translations$settings$mcpTokens$en {
	Translations$settings$mcpTokens$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ddagent MCP server tokens'
	String get title => 'ddagent MCP server tokens';

	/// en: 'External tools (Claude Desktop, OpenClaw) call ddagent tools over POST /mcp with one of these bearer tokens.'
	String get description => 'External tools (Claude Desktop, OpenClaw) call ddagent tools over POST /mcp with one of these bearer tokens.';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';

	/// en: 'Token label (e.g. Claude Desktop)'
	String get labelPlaceholder => 'Token label (e.g. Claude Desktop)';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'No MCP tokens yet.'
	String get empty => 'No MCP tokens yet.';

	/// en: 'used {{time}}'
	String lastUsed({required Object time}) => 'used ${time}';

	/// en: 'never used'
	String get neverUsed => 'never used';
}

// Path: settings.about
class Translations$settings$about$en {
	Translations$settings$about$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Support the Project'
	String get supportTitle => 'Support the Project';

	/// en: 'Buy Me a Coffee'
	String get buyMeACoffee => 'Buy Me a Coffee';

	/// en: 'Try ddagent Hosted'
	String get tryHosted => 'Try ddagent Hosted';

	/// en: 'Learn more'
	String get learnMore => 'Learn more';

	/// en: 'ddagent Pro Features'
	String get proFeatures => 'ddagent Pro Features';

	late final Translations$settings$about$pro$en pro = Translations$settings$about$pro$en.internal(_root);

	/// en: 'Version info'
	String get versionInfo => 'Version info';

	/// en: 'App'
	String get client => 'App';

	/// en: 'Server'
	String get server => 'Server';

	/// en: 'Mobile'
	String get platformMobile => 'Mobile';

	/// en: 'Desktop'
	String get platformDesktop => 'Desktop';

	/// en: 'Web'
	String get platformWeb => 'Web';

	/// en: 'unknown'
	String get unknown => 'unknown';
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Every keyboard shortcut in ddagent, split by platform.'
	String get description => 'Every keyboard shortcut in ddagent, split by platform.';

	/// en: 'Action'
	String get action => 'Action';

	/// en: 'Windows / Linux'
	String get winLinux => 'Windows / Linux';

	/// en: 'macOS'
	String get mac => 'macOS';

	/// en: 'Navigation'
	String get navigation => 'Navigation';

	/// en: 'Go to Workspace'
	String get navWorkspace => 'Go to Workspace';

	/// en: 'Go to Tasks / Git'
	String get navTasks => 'Go to Tasks / Git';

	/// en: 'Go to Git'
	String get navGit => 'Go to Git';

	/// en: 'Toggle focus mode (sidebar)'
	String get navFocus => 'Toggle focus mode (sidebar)';

	/// en: 'Session quick switcher'
	String get navSwitcher => 'Session quick switcher';

	/// en: 'Command palette'
	String get navPalette => 'Command palette';

	/// en: 'Open settings'
	String get navSettings => 'Open settings';

	/// en: 'Close dialog / restore split panes'
	String get navClose => 'Close dialog / restore split panes';

	/// en: 'Composer'
	String get composer => 'Composer';

	/// en: 'Send message'
	String get compSend => 'Send message';

	/// en: 'New line'
	String get compNewline => 'New line';

	/// en: 'Navigate suggestions'
	String get compNav => 'Navigate suggestions';

	/// en: 'Accept suggestion'
	String get compAccept => 'Accept suggestion';

	/// en: 'Close suggestions'
	String get compCloseSuggest => 'Close suggestions';

	/// en: 'Transcript'
	String get transcript => 'Transcript';

	/// en: 'Copy selected text'
	String get trCopy => 'Copy selected text';

	/// en: 'Close search / review panel'
	String get trClose => 'Close search / review panel';

	/// en: 'Terminal'
	String get terminal => 'Terminal';

	/// en: 'Copy selection'
	String get termCopy => 'Copy selection';

	/// en: 'Interrupt process (no selection)'
	String get termInterrupt => 'Interrupt process (no selection)';

	/// en: 'Paste'
	String get termPaste => 'Paste';

	/// en: 'Select all'
	String get termSelectAll => 'Select all';

	/// en: 'Editor'
	String get editor => 'Editor';

	/// en: 'Save file'
	String get edSave => 'Save file';

	/// en: 'Save all files'
	String get edSaveAll => 'Save all files';

	/// en: 'Close tab'
	String get edClose => 'Close tab';

	/// en: 'Next tab'
	String get edNextTab => 'Next tab';

	/// en: 'Previous tab'
	String get edPrevTab => 'Previous tab';

	/// en: 'Indent / outdent'
	String get edIndent => 'Indent / outdent';

	/// en: 'Command palette'
	String get palette => 'Command palette';

	/// en: 'Navigate items'
	String get palNav => 'Navigate items';

	/// en: 'Run / open'
	String get palRun => 'Run / open';

	/// en: 'Back (empty search)'
	String get palBack => 'Back (empty search)';

	/// en: 'Close'
	String get palClose => 'Close';
}

// Path: sidebar.projects
class Translations$sidebar$projects$en {
	Translations$sidebar$projects$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Projects'
	String get title => 'Projects';

	/// en: 'New Project'
	String get newProject => 'New Project';

	/// en: 'Remove Project'
	String get deleteProject => 'Remove Project';

	/// en: 'Rename Project'
	String get renameProject => 'Rename Project';

	/// en: 'No projects found'
	String get noProjects => 'No projects found';

	/// en: 'Loading projects...'
	String get loadingProjects => 'Loading projects...';

	/// en: 'Search projects...'
	String get searchPlaceholder => 'Search projects...';

	/// en: 'Project name'
	String get projectNamePlaceholder => 'Project name';

	/// en: 'Starred'
	String get starred => 'Starred';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Untitled Session'
	String get untitledSession => 'Untitled Session';

	/// en: 'New Session'
	String get newSession => 'New Session';

	/// en: 'Codex Session'
	String get codexSession => 'Codex Session';

	/// en: 'Fetching your Claude projects and sessions'
	String get fetchingProjects => 'Fetching your Claude projects and sessions';

	/// en: 'projects'
	String get projects => 'projects';

	/// en: 'No matching projects'
	String get noMatchingProjects => 'No matching projects';

	/// en: 'Try adjusting your search term'
	String get tryDifferentSearch => 'Try adjusting your search term';

	/// en: 'Run Claude CLI in a project directory to get started'
	String get runClaudeCli => 'Run Claude CLI in a project directory to get started';
}

// Path: sidebar.app
class Translations$sidebar$app$en {
	Translations$sidebar$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ddagent'
	String get title => 'ddagent';

	/// en: 'AI coding assistant interface'
	String get subtitle => 'AI coding assistant interface';
}

// Path: sidebar.panel
class Translations$sidebar$panel$en {
	Translations$sidebar$panel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Panel'
	String get open => 'Panel';

	/// en: 'New chat'
	String get newChat => 'New chat';

	/// en: 'Navigation'
	String get navigation => 'Navigation';

	/// en: 'Sessions'
	String get sessions => 'Sessions';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sessions'
	String get title => 'Sessions';

	/// en: 'New Session'
	String get newSession => 'New Session';

	/// en: 'Delete Session'
	String get deleteSession => 'Delete Session';

	/// en: 'Rename Session'
	String get renameSession => 'Rename Session';

	/// en: 'No sessions yet'
	String get noSessions => 'No sessions yet';

	/// en: 'Loading sessions...'
	String get loadingSessions => 'Loading sessions...';

	/// en: 'Unnamed'
	String get unnamed => 'Unnamed';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Show more sessions'
	String get showMore => 'Show more sessions';

	/// en: 'Select'
	String get selectMode => 'Select';

	/// en: 'Select all'
	String get selectAll => 'Select all';

	/// en: 'Archive ({{count}})'
	String archiveSelected({required Object count}) => 'Archive (${count})';

	/// en: 'Delete ({{count}})'
	String deleteSelected({required Object count}) => 'Delete (${count})';

	/// en: 'Cancel selection'
	String get cancelSelection => 'Cancel selection';

	/// en: 'Toggle session selection'
	String get toggleSelection => 'Toggle session selection';

	/// en: 'Session selection actions'
	String get selectionToolbar => 'Session selection actions';

	/// en: 'Session options'
	String get options => 'Session options';

	/// en: 'Pin session'
	String get pinSession => 'Pin session';

	/// en: 'Unpin session'
	String get unpinSession => 'Unpin session';

	/// en: 'Pinned session'
	String get pinned => 'Pinned session';

	/// en: '(one) {{{count}} selected} (other) {{{count}} selected}'
	String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} selected',
		other: '${count} selected',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'View Environments'
	String get viewEnvironments => 'View Environments';

	/// en: 'Hide sidebar'
	String get hideSidebar => 'Hide sidebar';

	/// en: 'Create new project'
	String get createProject => 'Create new project';

	/// en: 'Refresh projects and sessions (Ctrl+R)'
	String get refresh => 'Refresh projects and sessions (Ctrl+R)';

	/// en: 'Rename project (F2)'
	String get renameProject => 'Rename project (F2)';

	/// en: 'Remove project from sidebar (Delete)'
	String get deleteProject => 'Remove project from sidebar (Delete)';

	/// en: 'Add to favorites'
	String get addToFavorites => 'Add to favorites';

	/// en: 'Remove from favorites'
	String get removeFromFavorites => 'Remove from favorites';

	/// en: 'Manually edit session name'
	String get editSessionName => 'Manually edit session name';

	/// en: 'Delete this session permanently'
	String get deleteSession => 'Delete this session permanently';

	/// en: 'Recently active session (last 10 minutes)'
	String get activeSessionIndicator => 'Recently active session (last 10 minutes)';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Clear search'
	String get clearSearch => 'Clear search';

	/// en: 'Open command palette'
	String get openCommandPalette => 'Open command palette';

	/// en: 'Session needs attention'
	String get attentionRequiredIndicator => 'Session needs attention';

	/// en: 'Browse sessions'
	String get openSessions => 'Browse sessions';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chat'
	String get chat => 'Chat';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Git'
	String get git => 'Git';

	/// en: 'Terminal'
	String get terminal => 'Terminal';

	/// en: 'Tasks'
	String get tasks => 'Tasks';
}

// Path: sidebar.actions
class Translations$sidebar$actions$en {
	Translations$sidebar$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Collapse All'
	String get collapseAll => 'Collapse All';

	/// en: 'Expand All'
	String get expandAll => 'Expand All';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Join Community'
	String get joinCommunity => 'Join Community';

	/// en: 'Report Issue'
	String get reportIssue => 'Report Issue';

	/// en: 'Star on GitHub'
	String get starOnGithub => 'Star on GitHub';

	/// en: 'Buy Me a Coffee'
	String get buyMeACoffee => 'Buy Me a Coffee';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Change session workspace'
	String get title => 'Change session workspace';

	/// en: 'The agent runs its next turns in this directory. Existing session history is kept.'
	String get description => 'The agent runs its next turns in this directory. Existing session history is kept.';

	/// en: 'Workspace path'
	String get pathLabel => 'Workspace path';

	/// en: 'Workspace path is required.'
	String get pathRequired => 'Workspace path is required.';

	/// en: 'Change workspace'
	String get submit => 'Change workspace';

	/// en: 'Changing…'
	String get saving => 'Changing…';

	/// en: 'Change workspace'
	String get changeAction => 'Change workspace';
}

// Path: sidebar.branding
class Translations$sidebar$branding$en {
	Translations$sidebar$branding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Open Source'
	String get openSource => 'Open Source';
}

// Path: sidebar.status
class Translations$sidebar$status$en {
	Translations$sidebar$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Inactive'
	String get inactive => 'Inactive';

	/// en: 'Thinking...'
	String get thinking => 'Thinking...';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Aborted'
	String get aborted => 'Aborted';

	/// en: 'Unknown'
	String get unknown => 'Unknown';
}

// Path: sidebar.time
class Translations$sidebar$time$en {
	Translations$sidebar$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Just now'
	String get justNow => 'Just now';

	/// en: '1 min ago'
	String get oneMinuteAgo => '1 min ago';

	/// en: '{{count}} mins ago'
	String minutesAgo({required Object count}) => '${count} mins ago';

	/// en: '1 hour ago'
	String get oneHourAgo => '1 hour ago';

	/// en: '{{count}} hours ago'
	String hoursAgo({required Object count}) => '${count} hours ago';

	/// en: '1 day ago'
	String get oneDayAgo => '1 day ago';

	/// en: '{{count}} days ago'
	String daysAgo({required Object count}) => '${count} days ago';
}

// Path: sidebar.messages
class Translations$sidebar$messages$en {
	Translations$sidebar$messages$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Are you sure you want to delete this?'
	String get deleteConfirm => 'Are you sure you want to delete this?';

	/// en: 'Renamed successfully'
	String get renameSuccess => 'Renamed successfully';

	/// en: 'Deleted successfully'
	String get deleteSuccess => 'Deleted successfully';

	/// en: 'An error occurred'
	String get errorOccurred => 'An error occurred';

	/// en: 'Are you sure you want to delete this session? This action cannot be undone.'
	String get deleteSessionConfirm => 'Are you sure you want to delete this session? This action cannot be undone.';

	/// en: 'Remove this project from the sidebar? Your project files, memories, and session data will not be deleted.'
	String get deleteProjectConfirm => 'Remove this project from the sidebar? Your project files, memories, and session data will not be deleted.';

	/// en: 'Please enter a project path'
	String get enterProjectPath => 'Please enter a project path';

	/// en: 'Failed to delete session. Please try again.'
	String get deleteSessionFailed => 'Failed to delete session. Please try again.';

	/// en: 'Error deleting session. Please try again.'
	String get deleteSessionError => 'Error deleting session. Please try again.';

	/// en: 'Failed to rename session. Please try again.'
	String get renameSessionFailed => 'Failed to rename session. Please try again.';

	/// en: 'Error renaming session. Please try again.'
	String get renameSessionError => 'Error renaming session. Please try again.';

	/// en: 'Failed to change workspace. Please try again.'
	String get changeWorkspaceFailed => 'Failed to change workspace. Please try again.';

	/// en: 'Error changing workspace. Please try again.'
	String get changeWorkspaceError => 'Error changing workspace. Please try again.';

	/// en: 'Failed to remove project. Please try again.'
	String get deleteProjectFailed => 'Failed to remove project. Please try again.';

	/// en: 'Error removing project. Please try again.'
	String get deleteProjectError => 'Error removing project. Please try again.';

	/// en: 'Failed to create project. Please try again.'
	String get createProjectFailed => 'Failed to create project. Please try again.';

	/// en: 'Error creating project. Please try again.'
	String get createProjectError => 'Error creating project. Please try again.';

	/// en: 'Error updating project. Please try again.'
	String get updateProjectError => 'Error updating project. Please try again.';

	/// en: 'Failed to refresh. Please try again.'
	String get refreshError => 'Failed to refresh. Please try again.';

	/// en: 'Failed to restore project. Please try again.'
	String get restoreProjectFailed => 'Failed to restore project. Please try again.';

	/// en: 'Error restoring project. Please try again.'
	String get restoreProjectError => 'Error restoring project. Please try again.';

	/// en: 'Failed to restore session. Please try again.'
	String get restoreSessionFailed => 'Failed to restore session. Please try again.';

	/// en: 'Error restoring session. Please try again.'
	String get restoreSessionError => 'Error restoring session. Please try again.';

	/// en: '(one) {Failed to delete {{count}} session. Please try again.} (other) {Failed to delete {{count}} sessions. Please try again.}'
	String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Failed to delete ${count} session. Please try again.',
		other: 'Failed to delete ${count} sessions. Please try again.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$en {
	Translations$sidebar$version$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update available'
	String get updateAvailable => 'Update available';

	/// en: 'Update installed — restart the server to apply'
	String get restartRequired => 'Update installed — restart the server to apply';

	/// en: 'Update now'
	String get updateNow => 'Update now';

	/// en: 'Update ddagent to v{{version}}? The latest code will be pulled, rebuilt, and the server will restart — active sessions are interrupted.'
	String updateConfirm({required Object version}) => 'Update ddagent to v${version}? The latest code will be pulled, rebuilt, and the server will restart — active sessions are interrupted.';

	/// en: 'Updating… this can take a few minutes'
	String get updating => 'Updating… this can take a few minutes';

	/// en: 'Update installed — restarting…'
	String get restarting => 'Update installed — restarting…';

	/// en: 'Update failed'
	String get updateFailed => 'Update failed';

	/// en: 'Release notes'
	String get releaseNotes => 'Release notes';
}

// Path: sidebar.search
class Translations$sidebar$search$en {
	Translations$sidebar$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Projects'
	String get modeProjects => 'Projects';

	/// en: 'Conversations'
	String get modeConversations => 'Conversations';

	/// en: 'Search in conversations...'
	String get conversationsPlaceholder => 'Search in conversations...';

	/// en: 'Searching...'
	String get searching => 'Searching...';

	/// en: 'Session'
	String get sessionTitles => 'Session';

	/// en: 'Conversation contents'
	String get conversationContents => 'Conversation contents';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'Try a different search query'
	String get tryDifferentQuery => 'Try a different search query';

	/// en: 'Running'
	String get modeRunning => 'Running';

	/// en: 'Archive'
	String get archiveOnly => 'Archive';

	/// en: 'Running sessions'
	String get runningTooltip => 'Running sessions';

	/// en: 'Archive only'
	String get archiveOnlyTooltip => 'Archive only';

	/// en: '{{count}} active'
	String runningCount({required Object count}) => '${count} active';

	/// en: 'View'
	String get viewMenu => 'View';

	/// en: 'Back to projects'
	String get backToProjects => 'Back to projects';

	/// en: 'Search archived sessions...'
	String get archivedPlaceholder => 'Search archived sessions...';

	/// en: 'Search running sessions...'
	String get runningPlaceholder => 'Search running sessions...';

	/// en: '(one) {{{count}} match} (other) {{{count}} matches}'
	String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} match',
		other: '${count} matches',
	);

	/// en: '(one) {{{count}} project scanned} (other) {{{count}} projects scanned}'
	String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} project scanned',
		other: '${count} projects scanned',
	);
}

// Path: sidebar.recent
class Translations$sidebar$recent$en {
	Translations$sidebar$recent$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recent conversations'
	String get title => 'Recent conversations';

	/// en: 'No conversations yet'
	String get emptyTitle => 'No conversations yet';

	/// en: 'Your most recently updated conversations will appear here.'
	String get emptyDescription => 'Your most recently updated conversations will appear here.';

	/// en: 'Could not load recent conversations'
	String get loadFailed => 'Could not load recent conversations';

	/// en: 'Load older conversations'
	String get loadMore => 'Load older conversations';

	/// en: 'Loading more...'
	String get loadingMore => 'Loading more...';
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove Project'
	String get deleteProject => 'Remove Project';

	/// en: 'Delete Session'
	String get deleteSession => 'Delete Session';

	/// en: 'What would you like to do with'
	String get confirmDelete => 'What would you like to do with';

	/// en: 'Remove from sidebar only'
	String get removeFromSidebar => 'Remove from sidebar only';

	/// en: 'Delete all data permanently'
	String get deleteAllData => 'Delete all data permanently';

	/// en: 'The project will be removed from the sidebar. Your files, memories, and session data will be preserved.'
	String get allConversationsDeleted => 'The project will be removed from the sidebar. Your files, memories, and session data will be preserved.';

	/// en: 'You can re-add the project later.'
	String get cannotUndo => 'You can re-add the project later.';

	/// en: 'Archive hides the selected sessions from the active list while preserving their history. Deleting permanently removes them and their transcripts.'
	String get bulkDeleteSessionsDescription => 'Archive hides the selected sessions from the active list while preserving their history. Deleting permanently removes them and their transcripts.';

	/// en: 'Archive session'
	String get archiveSession => 'Archive session';

	/// en: 'Archive keeps the session out of the active list while preserving its history.'
	String get archiveSessionNotice => 'Archive keeps the session out of the active list while preserving its history.';

	/// en: 'This session is already archived. You can keep it hidden or delete it permanently.'
	String get archivedSessionNotice => 'This session is already archived. You can keep it hidden or delete it permanently.';

	/// en: 'This permanently removes the session and its transcript. This action cannot be undone.'
	String get deleteSessionNotice => 'This permanently removes the session and its transcript. This action cannot be undone.';

	/// en: 'Delete permanently'
	String get deleteSessionPermanently => 'Delete permanently';

	/// en: '(one) {This project contains {{count}} conversation.} (other) {This project contains {{count}} conversations.}'
	String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'This project contains ${count} conversation.',
		other: 'This project contains ${count} conversations.',
	);

	/// en: '(one) {Manage selected session} (other) {Manage {{count}} selected sessions}'
	String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Manage selected session',
		other: 'Manage ${count} selected sessions',
	);

	/// en: '(one) {Archive session} (other) {Archive {{count}} sessions}'
	String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Archive session',
		other: 'Archive ${count} sessions',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$en {
	Translations$sidebar$zones$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Active now'
	String get activeNow => 'Active now';

	/// en: 'Recently worked on'
	String get recent => 'Recently worked on';

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';

	/// en: 'This week'
	String get thisWeek => 'This week';

	/// en: 'Show {{count}} more'
	String showMore({required Object count}) => 'Show ${count} more';

	/// en: 'Show less'
	String get showLess => 'Show less';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agent Board'
	String get board => 'Agent Board';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Source Control'
	String get git => 'Source Control';

	/// en: 'Tasks'
	String get tasks => 'Tasks';

	/// en: 'Quota & Usage'
	String get usage => 'Quota & Usage';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TaskMaster AI is not configured'
	String get title => 'TaskMaster AI is not configured';

	/// en: 'TaskMaster helps break down complex projects into manageable tasks with AI-powered assistance'
	String get description => 'TaskMaster helps break down complex projects into manageable tasks with AI-powered assistance';

	/// en: '🎯 What is TaskMaster?'
	String get whatIsTitle => '🎯 What is TaskMaster?';

	late final Translations$tasks$notConfigured$features$en features = Translations$tasks$notConfigured$features$en.internal(_root);

	/// en: 'Initialize TaskMaster AI'
	String get initializeButton => 'Initialize TaskMaster AI';

	/// en: 'Write PRD first'
	String get writePrdFirst => 'Write PRD first';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Getting Started with TaskMaster'
	String get title => 'Getting Started with TaskMaster';

	/// en: 'TaskMaster is initialized! Here's what to do next:'
	String get subtitle => 'TaskMaster is initialized! Here\'s what to do next:';

	late final Translations$tasks$gettingStarted$steps$en steps = Translations$tasks$gettingStarted$steps$en.internal(_root);

	/// en: '💡 Tip: Start with a PRD to get the most out of TaskMaster's AI-powered task generation'
	String get tip => '💡 Tip: Start with a PRD to get the most out of TaskMaster\'s AI-powered task generation';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TaskMaster Setup'
	String get title => 'TaskMaster Setup';

	/// en: 'Interactive CLI for {{projectName}}'
	String subtitle({required Object projectName}) => 'Interactive CLI for ${projectName}';

	/// en: 'TaskMaster initialization will start automatically'
	String get willStart => 'TaskMaster initialization will start automatically';

	/// en: 'TaskMaster setup completed! You can now close this window.'
	String get completed => 'TaskMaster setup completed! You can now close this window.';

	/// en: 'Close'
	String get closeButton => 'Close';

	/// en: 'Close & Continue'
	String get closeContinueButton => 'Close & Continue';

	/// en: 'Close'
	String get closeTitle => 'Close';

	/// en: 'Creates a .taskmaster folder in this project. No external tooling or API keys required — tasks are stored locally.'
	String get description => 'Creates a .taskmaster folder in this project. No external tooling or API keys required — tasks are stored locally.';

	/// en: 'Initialize'
	String get initializeButton => 'Initialize';

	/// en: 'Initializing...'
	String get initializing => 'Initializing...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Getting Started with TaskMaster'
	String get title => 'Getting Started with TaskMaster';

	/// en: 'Your guide to productive task management'
	String get subtitle => 'Your guide to productive task management';

	late final Translations$tasks$helpGuide$examples$en examples = Translations$tasks$helpGuide$examples$en.internal(_root);

	/// en: 'View more examples and usage patterns →'
	String get moreExamples => 'View more examples and usage patterns →';

	late final Translations$tasks$helpGuide$proTips$en proTips = Translations$tasks$helpGuide$proTips$en.internal(_root);
	late final Translations$tasks$helpGuide$learnMore$en learnMore = Translations$tasks$helpGuide$learnMore$en.internal(_root);

	/// en: 'Close'
	String get closeTitle => 'Close';
}

// Path: tasks.search
class Translations$tasks$search$en {
	Translations$tasks$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search tasks...'
	String get placeholder => 'Search tasks...';
}

// Path: tasks.filters
class Translations$tasks$filters$en {
	Translations$tasks$filters$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filters'
	String get button => 'Filters';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Priority'
	String get priority => 'Priority';

	/// en: 'Sort By'
	String get sortBy => 'Sort By';

	/// en: 'All Statuses'
	String get allStatuses => 'All Statuses';

	/// en: 'All Priorities'
	String get allPriorities => 'All Priorities';

	/// en: 'Showing {{filtered}} of {{total}} tasks'
	String showing({required Object filtered, required Object total}) => 'Showing ${filtered} of ${total} tasks';

	/// en: 'Clear Filters'
	String get clearFilters => 'Clear Filters';
}

// Path: tasks.sort
class Translations$tasks$sort$en {
	Translations$tasks$sort$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ID'
	String get id => 'ID';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Priority'
	String get priority => 'Priority';

	/// en: 'ID (Ascending)'
	String get idAsc => 'ID (Ascending)';

	/// en: 'ID (Descending)'
	String get idDesc => 'ID (Descending)';

	/// en: 'Title (A-Z)'
	String get titleAsc => 'Title (A-Z)';

	/// en: 'Title (Z-A)'
	String get titleDesc => 'Title (Z-A)';

	/// en: 'Status (Pending First)'
	String get statusAsc => 'Status (Pending First)';

	/// en: 'Status (Done First)'
	String get statusDesc => 'Status (Done First)';

	/// en: 'Priority (High First)'
	String get priorityAsc => 'Priority (High First)';

	/// en: 'Priority (Low First)'
	String get priorityDesc => 'Priority (Low First)';
}

// Path: tasks.views
class Translations$tasks$views$en {
	Translations$tasks$views$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Kanban view'
	String get kanban => 'Kanban view';

	/// en: 'List view'
	String get list => 'List view';

	/// en: 'Grid view'
	String get grid => 'Grid view';
}

// Path: tasks.kanban
class Translations$tasks$kanban$en {
	Translations$tasks$kanban$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '📋 To Do'
	String get pending => '📋 To Do';

	/// en: '🚀 In Progress'
	String get inProgress => '🚀 In Progress';

	/// en: '👀 Review'
	String get review => '👀 Review';

	/// en: '✅ Done'
	String get done => '✅ Done';

	/// en: '🚫 Blocked'
	String get blocked => '🚫 Blocked';

	/// en: '⏳ Deferred'
	String get deferred => '⏳ Deferred';

	/// en: '❌ Cancelled'
	String get cancelled => '❌ Cancelled';

	/// en: 'No tasks yet'
	String get noTasksYet => 'No tasks yet';

	/// en: 'Tasks will appear here'
	String get tasksWillAppear => 'Tasks will appear here';

	/// en: 'Move tasks here when started'
	String get moveTasksHere => 'Move tasks here when started';

	/// en: 'Completed tasks appear here'
	String get completedTasksHere => 'Completed tasks appear here';

	/// en: 'Tasks with this status will appear here'
	String get statusTasksHere => 'Tasks with this status will appear here';
}

// Path: tasks.buttons
class Translations$tasks$buttons$en {
	Translations$tasks$buttons$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TaskMaster Getting Started Guide'
	String get help => 'TaskMaster Getting Started Guide';

	/// en: 'PRDs'
	String get prds => 'PRDs';

	/// en: 'Add PRD'
	String get addPRD => 'Add PRD';

	/// en: 'Add Task'
	String get addTask => 'Add Task';

	/// en: 'Create New PRD'
	String get createNewPRD => 'Create New PRD';

	/// en: '{{count}} PRD(s) available'
	String prdsAvailable({required Object count}) => '${count} PRD(s) available';
}

// Path: tasks.prd
class Translations$tasks$prd$en {
	Translations$tasks$prd$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Modified: {{date}}'
	String modified({required Object date}) => 'Modified: ${date}';

	/// en: 'PRD — {{name}}'
	String editorTitle({required Object name}) => 'PRD — ${name}';

	/// en: 'new file'
	String get newFile => 'new file';

	/// en: 'Template'
	String get template => 'Template';

	/// en: 'Parse PRD'
	String get parse => 'Parse PRD';

	/// en: 'File already exists'
	String get fileExistsTitle => 'File already exists';

	/// en: 'A PRD named "{{name}}" already exists. Do you want to overwrite it?'
	String fileExistsMessage({required Object name}) => 'A PRD named "${name}" already exists. Do you want to overwrite it?';

	/// en: 'file name (e.g. prd.txt)'
	String get fileNameHint => 'file name (e.g. prd.txt)';

	/// en: 'PRD saved'
	String get saved => 'PRD saved';

	/// en: 'Tasks generated from PRD'
	String get tasksGenerated => 'Tasks generated from PRD';
}

// Path: tasks.statuses
class Translations$tasks$statuses$en {
	Translations$tasks$statuses$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'In Progress'
	String get inProgress => 'In Progress';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Blocked'
	String get blocked => 'Blocked';

	/// en: 'Deferred'
	String get deferred => 'Deferred';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Review'
	String get review => 'Review';
}

// Path: tasks.priorities
class Translations$tasks$priorities$en {
	Translations$tasks$priorities$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'High'
	String get high => 'High';

	/// en: 'Medium'
	String get medium => 'Medium';

	/// en: 'Low'
	String get low => 'Low';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No tasks match your filters'
	String get title => 'No tasks match your filters';

	/// en: 'Try adjusting your search or filter criteria.'
	String get description => 'Try adjusting your search or filter criteria.';
}

// Path: tasks.board
class Translations$tasks$board$en {
	Translations$tasks$board$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agent Board'
	String get title => 'Agent Board';

	/// en: 'Move a card to Ready and the agent picks it up. Click a card to open its session.'
	String get subtitle => 'Move a card to Ready and the agent picks it up. Click a card to open its session.';

	/// en: 'New card'
	String get newCard => 'New card';

	/// en: 'Add card'
	String get addCard => 'Add card';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	late final Translations$tasks$board$empty$en empty = Translations$tasks$board$empty$en.internal(_root);
	late final Translations$tasks$board$columns$en columns = Translations$tasks$board$columns$en.internal(_root);
	late final Translations$tasks$board$card$en card = Translations$tasks$board$card$en.internal(_root);
	late final Translations$tasks$board$dialog$en dialog = Translations$tasks$board$dialog$en.internal(_root);

	/// en: 'Add a project first, then create cards for it.'
	String get noProject => 'Add a project first, then create cards for it.';

	/// en: 'Project'
	String get projectLabel => 'Project';

	/// en: 'Back to chat'
	String get backToChat => 'Back to chat';

	late final Translations$tasks$board$agent$en agent = Translations$tasks$board$agent$en.internal(_root);
	late final Translations$tasks$board$deleteConfirm$en deleteConfirm = Translations$tasks$board$deleteConfirm$en.internal(_root);

	/// en: 'Project'
	String get project => 'Project';

	late final Translations$tasks$board$assignee$en assignee = Translations$tasks$board$assignee$en.internal(_root);
	late final Translations$tasks$board$presence$en presence = Translations$tasks$board$presence$en.internal(_root);
	late final Translations$tasks$board$activity$en activity = Translations$tasks$board$activity$en.internal(_root);
	late final Translations$tasks$board$comments$en comments = Translations$tasks$board$comments$en.internal(_root);
}

// Path: tasks.card
class Translations$tasks$card$en {
	Translations$tasks$card$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Depends on: {{tasks}}'
	String dependsOnList({required Object tasks}) => 'Depends on: ${tasks}';

	/// en: 'Task {{id}}'
	String dependsOnTooltip({required Object id}) => 'Task ${id}';

	/// en: 'High priority'
	String get highPriority => 'High priority';

	/// en: 'Low priority'
	String get lowPriority => 'Low priority';

	/// en: 'Medium priority'
	String get mediumPriority => 'Medium priority';

	/// en: 'No priority set'
	String get noPriority => 'No priority set';

	/// en: 'Task {{id}}'
	String parentTask({required Object id}) => 'Task ${id}';

	/// en: 'Progress:'
	String get progressLabel => 'Progress:';

	/// en: '{{completed}} of {{total}} subtasks completed'
	String progressTooltip({required Object completed, required Object total}) => '${completed} of ${total} subtasks completed';

	/// en: 'Run task'
	String get runTask => 'Run task';

	/// en: 'Run task {{id}}'
	String runTaskAria({required Object id}) => 'Run task ${id}';

	/// en: 'Status: {{status}}'
	String statusTooltip({required Object status}) => 'Status: ${status}';

	/// en: 'Task ID: {{id}}'
	String taskIdTitle({required Object id}) => 'Task ID: ${id}';

	/// en: 'Task in progress'
	String get taskInProgress => 'Task in progress';
}

// Path: tasks.createTask
class Translations$tasks$createTask$en {
	Translations$tasks$createTask$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Description'
	String get descriptionLabel => 'Description';

	/// en: 'Optional details'
	String get descriptionPlaceholder => 'Optional details';

	/// en: 'Failed to add task'
	String get error => 'Failed to add task';

	/// en: 'Priority'
	String get priorityLabel => 'Priority';

	/// en: 'Add Task'
	String get submit => 'Add Task';

	/// en: 'Adding...'
	String get submitting => 'Adding...';

	/// en: 'Add Task'
	String get title => 'Add Task';

	/// en: 'Title'
	String get titleLabel => 'Title';

	/// en: 'What needs to be done?'
	String get titlePlaceholder => 'What needs to be done?';
}

// Path: tasks.list
class Translations$tasks$list$en {
	Translations$tasks$list$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Completed (click to reopen)'
	String get completedReopen => 'Completed (click to reopen)';

	/// en: 'In progress (click to complete)'
	String get inProgressComplete => 'In progress (click to complete)';

	/// en: 'Mark completed'
	String get markCompleted => 'Mark completed';

	/// en: 'Toggle task {{id}} status'
	String toggleStatusAria({required Object id}) => 'Toggle task ${id} status';

	/// en: 'Mark done'
	String get markDone => 'Mark done';

	/// en: 'Reopen'
	String get reopen => 'Reopen';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All tasks complete'
	String get allComplete => 'All tasks complete';

	/// en: '- AI-powered task management with dependencies and subtasks.'
	String get feature1 => '- AI-powered task management with dependencies and subtasks.';

	/// en: '- PRD-driven task generation for faster project bootstrapping.'
	String get feature2 => '- PRD-driven task generation for faster project bootstrapping.';

	/// en: '- Kanban and list views for day-to-day execution.'
	String get feature3 => '- Kanban and list views for day-to-day execution.';

	/// en: 'Hide details'
	String get hideDetails => 'Hide details';

	/// en: 'Initialize'
	String get initialize => 'Initialize';

	/// en: 'No pending tasks'
	String get noPending => 'No pending tasks';

	/// en: 'TaskMaster AI is not configured'
	String get notConfigured => 'TaskMaster AI is not configured';

	/// en: 'Review'
	String get review => 'Review';

	/// en: 'Start Task'
	String get startTask => 'Start Task';

	/// en: 'Task {{id}}'
	String taskId({required Object id}) => 'Task ${id}';

	/// en: 'View all tasks'
	String get viewAll => 'View all tasks';

	/// en: 'View task details'
	String get viewDetails => 'View task details';

	/// en: 'What is TaskMaster?'
	String get whatIs => 'What is TaskMaster?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel editing'
	String get cancelEdit => 'Cancel editing';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Copy task ID'
	String get copyTaskId => 'Copy task ID';

	/// en: 'Delete task'
	String get delete => 'Delete task';

	/// en: '"{{title}}" will be permanently deleted.'
	String deleteConfirmDescription({required Object title}) => '"${title}" will be permanently deleted.';

	/// en: 'Delete task?'
	String get deleteConfirmTitle => 'Delete task?';

	/// en: 'Failed to delete task'
	String get deleteFailed => 'Failed to delete task';

	/// en: 'Dependencies'
	String get dependencies => 'Dependencies';

	/// en: 'e.g. 1, 2, 3'
	String get dependenciesPlaceholder => 'e.g. 1, 2, 3';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Edit task'
	String get edit => 'Edit task';

	/// en: 'Implementation Details'
	String get implDetails => 'Implementation Details';

	/// en: 'No dependencies'
	String get noDependencies => 'No dependencies';

	/// en: 'No description provided'
	String get noDescription => 'No description provided';

	/// en: 'Priority'
	String get priority => 'Priority';

	/// en: 'Not set'
	String get priorityNotSet => 'Not set';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Failed to update task status'
	String get statusFailed => 'Failed to update task status';

	/// en: 'Task {{id}}'
	String taskId({required Object id}) => 'Task ${id}';

	/// en: 'Task {{id}}: {{title}}'
	String taskTitle({required Object id, required Object title}) => 'Task ${id}: ${title}';

	/// en: 'Test Strategy'
	String get testStrategy => 'Test Strategy';

	/// en: 'Title is required'
	String get titleRequired => 'Title is required';

	/// en: 'Failed to update task'
	String get updateFailed => 'Failed to update task';

	/// en: 'Task not found'
	String get notFound => 'Task not found';

	/// en: 'Subtasks'
	String get subtasks => 'Subtasks';

	/// en: 'Task #{{id}} will be removed. This cannot be undone.'
	String deleteConfirmMessage({required Object id}) => 'Task #${id} will be removed. This cannot be undone.';

	/// en: 'Task ID copied'
	String get idCopied => 'Task ID copied';
}

// Path: tasks.toasts
class Translations$tasks$toasts$en {
	Translations$tasks$toasts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Task {{id}} set to in-progress'
	String statusInProgress({required Object id}) => 'Task ${id} set to in-progress';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dashboard'
	String get dashboard => 'Dashboard';

	/// en: 'Memories'
	String get memories => 'Memories';

	/// en: 'Rules'
	String get rules => 'Rules';

	/// en: 'Skills'
	String get skills => 'Skills';

	/// en: 'Personal'
	String get personal => 'Personal';

	/// en: 'Graph'
	String get graph => 'Graph';
}

// Path: knowledge.common
class Translations$knowledge$common$en {
	Translations$knowledge$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Restore'
	String get restore => 'Restore';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'All projects'
	String get allProjects => 'All projects';

	/// en: 'Global'
	String get global => 'Global';
}

// Path: knowledge.actions
class Translations$knowledge$actions$en {
	Translations$knowledge$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Scan project files'
	String get scan => 'Scan project files';

	/// en: 'Export JSON'
	String get export => 'Export JSON';

	/// en: 'Import JSON'
	String get import => 'Import JSON';

	/// en: 'Project scan complete'
	String get scanComplete => 'Project scan complete';

	/// en: 'Import complete'
	String get importComplete => 'Import complete';

	/// en: 'Import failed'
	String get importFailed => 'Import failed';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New entry'
	String get newEntity => 'New entry';

	/// en: 'Edit entry'
	String get editEntity => 'Edit entry';

	/// en: 'Delete'
	String get deleteTitle => 'Delete';

	/// en: 'Delete this entry? This cannot be undone (history is kept).'
	String get deleteMessage => 'Delete this entry? This cannot be undone (history is kept).';

	/// en: 'Pick icon'
	String get pickIcon => 'Pick icon';

	/// en: 'Remove icon'
	String get removeIcon => 'Remove icon';

	/// en: 'Icon is too large (max 40 KB).'
	String get iconTooLarge => 'Icon is too large (max 40 KB).';

	/// en: 'Import knowledge'
	String get importTitle => 'Import knowledge';

	/// en: 'Paste exported JSON here'
	String get importHint => 'Paste exported JSON here';

	/// en: 'Export knowledge'
	String get exportTitle => 'Export knowledge';

	/// en: 'Import'
	String get import => 'Import';
}

// Path: knowledge.fields
class Translations$knowledge$fields$en {
	Translations$knowledge$fields$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Key'
	String get key => 'Key';

	/// en: 'Title'
	String get title => 'Title';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Content'
	String get content => 'Content';

	/// en: 'Priority'
	String get priority => 'Priority';

	/// en: 'Tags'
	String get tags => 'Tags';

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Project scope'
	String get projectScope => 'Project scope';

	/// en: 'comma, separated'
	String get tagsHint => 'comma, separated';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memories'
	String get memories => 'Memories';

	/// en: 'Rules'
	String get rules => 'Rules';

	/// en: 'Skills'
	String get skills => 'Skills';

	/// en: 'Personal'
	String get personal => 'Personal';

	/// en: 'Connections'
	String get connections => 'Connections';

	/// en: 'Recent memories'
	String get recent => 'Recent memories';

	/// en: 'No memories yet. Add one from the Memories tab.'
	String get noMemories => 'No memories yet. Add one from the Memories tab.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$en {
	Translations$knowledge$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No memories yet.'
	String get memories => 'No memories yet.';

	/// en: 'No rules yet.'
	String get rules => 'No rules yet.';

	/// en: 'No skills yet.'
	String get skills => 'No skills yet.';

	/// en: 'No personal information yet.'
	String get personal => 'No personal information yet.';

	/// en: 'No entities to graph yet.'
	String get graph => 'No entities to graph yet.';
}

// Path: knowledge.history
class Translations$knowledge$history$en {
	Translations$knowledge$history$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'History'
	String get title => 'History';

	/// en: 'No history yet.'
	String get none => 'No history yet.';

	/// en: '(untitled)'
	String get untitled => '(untitled)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Critical'
	String get critical => 'Critical';

	/// en: 'High'
	String get high => 'High';

	/// en: 'Normal'
	String get normal => 'Normal';

	/// en: 'Low'
	String get low => 'Low';
}

// Path: knowledge.search
class Translations$knowledge$search$en {
	Translations$knowledge$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search knowledge'
	String get title => 'Search knowledge';

	/// en: 'Search memories, rules, skills…'
	String get hint => 'Search memories, rules, skills…';

	/// en: 'No results.'
	String get noResults => 'No results.';
}

// Path: knowledge.links
class Translations$knowledge$links$en {
	Translations$knowledge$links$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Link entities'
	String get title => 'Link entities';

	/// en: 'Source'
	String get source => 'Source';

	/// en: 'Target'
	String get target => 'Target';

	/// en: 'Relationship'
	String get relationship => 'Relationship';

	/// en: 'Create link'
	String get add => 'Create link';
}

// Path: knowledge.tags
class Translations$knowledge$tags$en {
	Translations$knowledge$tags$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All tags'
	String get all => 'All tags';

	/// en: 'Manage tags'
	String get manage => 'Manage tags';

	/// en: 'No tags yet.'
	String get none => 'No tags yet.';
}

// Path: knowledge.graph
class Translations$knowledge$graph$en {
	Translations$knowledge$graph$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'truncated'
	String get truncated => 'truncated';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Import everything into ddagent'
	String get title => 'Import everything into ddagent';

	/// en: 'Projects scanned: {{count}}'
	String projectsScanned({required Object count}) => 'Projects scanned: ${count}';

	/// en: 'Agent skills found: {{found}} (new: {{newSkills}})'
	String skillsFound({required Object found, required Object newSkills}) => 'Agent skills found: ${found} (new: ${newSkills})';

	/// en: 'Rules: {{total}} · duplicate groups: {{duplicates}}'
	String rulesSummary({required Object total, required Object duplicates}) => 'Rules: ${total} · duplicate groups: ${duplicates}';

	/// en: 'Merge duplicate entries'
	String get mergeDuplicates => 'Merge duplicate entries';

	/// en: 'Collapses duplicate rows in ddagent (not files)'
	String get mergeDuplicatesHint => 'Collapses duplicate rows in ddagent (not files)';

	/// en: 'Import everything'
	String get action => 'Import everything';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Migrate existing rules'
	String get title => 'Migrate existing rules';

	/// en: 'Scanned {{count}} project(s).'
	String scanned({required Object count}) => 'Scanned ${count} project(s).';

	/// en: 'Rules: {{total}} total, {{critical}} critical.'
	String rulesSummary({required Object total, required Object critical}) => 'Rules: ${total} total, ${critical} critical.';

	/// en: 'Duplicate groups across projects: {{count}}'
	String duplicates({required Object count}) => 'Duplicate groups across projects: ${count}';

	/// en: 'Removed: {{removed}}, promoted: {{promoted}}'
	String removedPromoted({required Object removed, required Object promoted}) => 'Removed: ${removed}, promoted: ${promoted}';

	/// en: 'Merge duplicates'
	String get mergeDuplicates => 'Merge duplicates';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Import agent skills'
	String get title => 'Import agent skills';

	/// en: 'Found {{count}} skill(s) across your agents.'
	String found({required Object count}) => 'Found ${count} skill(s) across your agents.';

	/// en: 'New: {{imported}} · skipped: {{skipped}}'
	String summary({required Object imported, required Object skipped}) => 'New: ${imported} · skipped: ${skipped}';
}

// Path: knowledge.critical
class Translations$knowledge$critical$en {
	Translations$knowledge$critical$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Make critical'
	String get make => 'Make critical';

	/// en: 'Make all rules critical'
	String get makeAll => 'Make all rules critical';

	/// en: 'Adds them to the injected context budget'
	String get makeAllHint => 'Adds them to the injected context budget';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '~{{tokens}} / {{budget}} tok'
	String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memory: {{title}}'
	String memory({required Object title}) => 'Memory: ${title}';

	/// en: 'Rule: {{title}}'
	String rule({required Object title}) => 'Rule: ${title}';

	/// en: 'Skill: {{name}}'
	String skill({required Object name}) => 'Skill: ${name}';

	/// en: 'Personal: {{title}}'
	String personal({required Object title}) => 'Personal: ${title}';
}

// Path: knowledge.errors
class Translations$knowledge$errors$en {
	Translations$knowledge$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Import failed: {{error}}'
	String importFailed({required Object error}) => 'Import failed: ${error}';

	/// en: 'Migration failed: {{error}}'
	String migrationFailed({required Object error}) => 'Migration failed: ${error}';
}

// Path: collab.roles
class Translations$collab$roles$en {
	Translations$collab$roles$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Member'
	String get member => 'Member';

	/// en: 'Viewer'
	String get viewer => 'Viewer';
}

// Path: fileTree.search
class Translations$fileTree$search$en {
	Translations$fileTree$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filter names / Enter to search contents'
	String get hint => 'Filter names / Enter to search contents';

	/// en: 'Type a query and press Enter'
	String get prompt => 'Type a query and press Enter';

	/// en: 'No matches'
	String get noMatches => 'No matches';

	/// en: 'Results truncated'
	String get resultsTruncated => 'Results truncated';
}

// Path: fileTree.titles
class Translations$fileTree$titles$en {
	Translations$fileTree$titles$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rename {{name}}'
	String rename({required Object name}) => 'Rename ${name}';

	/// en: 'Delete {{name}}'
	String delete({required Object name}) => 'Delete ${name}';

	/// en: 'Download {{name}}'
	String download({required Object name}) => 'Download ${name}';
}

// Path: git.checkpoints
class Translations$git$checkpoints$en {
	Translations$git$checkpoints$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checkpoints'
	String get title => 'Checkpoints';

	/// en: 'Restore checkpoint'
	String get restoreTitle => 'Restore checkpoint';

	/// en: 'Reset the working tree to this checkpoint? Current changes will be replaced.'
	String get restoreMessage => 'Reset the working tree to this checkpoint? Current changes will be replaced.';

	/// en: 'Checkpoint restored'
	String get restored => 'Checkpoint restored';

	/// en: 'Checkpoint label (optional)'
	String get labelHint => 'Checkpoint label (optional)';

	/// en: 'No checkpoints yet'
	String get empty => 'No checkpoints yet';

	/// en: 'New'
	String get create => 'New';
}

// Path: kanban.card
class Translations$kanban$card$en {
	Translations$kanban$card$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Untitled'
	String get untitled => 'Untitled';
}

// Path: kanban.comments
class Translations$kanban$comments$en {
	Translations$kanban$comments$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No comments yet'
	String get empty => 'No comments yet';

	/// en: 'Add comment'
	String get add => 'Add comment';
}

// Path: kanban.dialog
class Translations$kanban$dialog$en {
	Translations$kanban$dialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Saving…'
	String get saving => 'Saving…';
}

// Path: kanban.details
class Translations$kanban$details$en {
	Translations$kanban$details$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Card Details'
	String get title => 'Card Details';

	/// en: 'Status: {{status}}'
	String status({required Object status}) => 'Status: ${status}';
}

// Path: kanban.empty
class Translations$kanban$empty$en {
	Translations$kanban$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No project selected'
	String get noProject => 'No project selected';
}

// Path: kanban.time
class Translations$kanban$time$en {
	Translations$kanban$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'now'
	String get now => 'now';

	/// en: '(one) {1 minute ago} (other) {{{count}} minutes ago}'
	String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '1 minute ago',
		other: '${count} minutes ago',
	);

	/// en: '(one) {1 hour ago} (other) {{{count}} hours ago}'
	String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '1 hour ago',
		other: '${count} hours ago',
	);

	/// en: '(one) {1 day ago} (other) {{{count}} days ago}'
	String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '1 day ago',
		other: '${count} days ago',
	);
}

// Path: mcp.install
class Translations$mcp$install$en {
	Translations$mcp$install$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Install ddagent MCP server'
	String get title => 'Install ddagent MCP server';

	/// en: 'Lets the selected agents use the ddagent knowledge base and tools over MCP.'
	String get description => 'Lets the selected agents use the ddagent knowledge base and tools over MCP.';

	/// en: 'Give your agents the knowledge base and ddagent tools over MCP — pick agents or install for all.'
	String get cardDescription => 'Give your agents the knowledge base and ddagent tools over MCP — pick agents or install for all.';

	/// en: 'Install selected'
	String get installSelected => 'Install selected';

	/// en: 'Install for all'
	String get installForAll => 'Install for all';

	/// en: 'Install'
	String get button => 'Install';

	/// en: 'Install failed: {{error}}'
	String failed({required Object error}) => 'Install failed: ${error}';

	/// en: '(one) {Installed on {{count}} agent.} (other) {Installed on {{count}} agents.}'
	String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Installed on ${count} agent.',
		other: 'Installed on ${count} agents.',
	);

	/// en: 'Installed on {{count}}; failed: {{failed}}'
	String partialFailure({required Object count, required Object failed}) => 'Installed on ${count}; failed: ${failed}';

	/// en: 'error'
	String get errorFallback => 'error';
}

// Path: mcp.servers
class Translations$mcp$servers$en {
	Translations$mcp$servers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading MCP servers...'
	String get loading => 'Loading MCP servers...';

	/// en: 'Refreshing project scopes...'
	String get refreshingScopes => 'Refreshing project scopes...';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to {{provider}}'
	String descriptionGeneric({required Object provider}) => 'Model Context Protocol servers provide additional tools and data sources to ${provider}';

	/// en: 'Add Global MCP Server'
	String get addGlobalTitle => 'Add Global MCP Server';

	/// en: 'Adds this MCP server to every provider: Claude, Cursor, Codex, OpenCode, and Devin. Only stdio and HTTP transports are supported because the same config must work across all providers.'
	String get addGlobalDescription => 'Adds this MCP server to every provider: Claude, Cursor, Codex, OpenCode, and Devin. Only stdio and HTTP transports are supported because the same config must work across all providers.';

	/// en: 'Add Global MCP Server writes one common stdio or HTTP server to Claude, Cursor, Codex, OpenCode, and Devin.'
	String get addGlobalMenuDescription => 'Add Global MCP Server writes one common stdio or HTTP server to Claude, Cursor, Codex, OpenCode, and Devin.';

	/// en: 'Add {{provider}} MCP Server'
	String addProviderTitle({required Object provider}) => 'Add ${provider} MCP Server';

	/// en: 'Add {{provider}} MCP Server only changes {{provider}}.'
	String addProviderDescription({required Object provider}) => 'Add ${provider} MCP Server only changes ${provider}.';

	late final Translations$mcp$servers$config$en config = Translations$mcp$servers$config$en.internal(_root);
}

// Path: mcp.team
class Translations$mcp$team$en {
	Translations$mcp$team$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Team MCP Configs'
	String get title => 'Team MCP Configs';

	/// en: 'Share MCP server configurations across your team. Everyone stays in sync automatically.'
	String get description => 'Share MCP server configurations across your team. Everyone stays in sync automatically.';

	/// en: 'Available with ddagent Pro'
	String get cta => 'Available with ddagent Pro';
}

// Path: mcp.tokens
class Translations$mcp$tokens$en {
	Translations$mcp$tokens$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Write'
	String get scopeWrite => 'Write';
}

// Path: mcp.form
class Translations$mcp$form$en {
	Translations$mcp$form$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Server to {{provider}}'
	String submitTo({required Object provider}) => 'Add Server to ${provider}';

	late final Translations$mcp$form$scope$en scope = Translations$mcp$form$scope$en.internal(_root);
	late final Translations$mcp$form$fields$en fields = Translations$mcp$form$fields$en.internal(_root);
	late final Translations$mcp$form$validation$en validation = Translations$mcp$form$validation$en.internal(_root);
}

// Path: notifications.errors
class Translations$notifications$errors$en {
	Translations$notifications$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Registration rejected by server'
	String get registrationRejected => 'Registration rejected by server';

	/// en: 'No response from the server'
	String get noResponse => 'No response from the server';
}

// Path: onboarding.errors
class Translations$onboarding$errors$en {
	Translations$onboarding$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Both git name and email are required.'
	String get nameAndEmailRequired => 'Both git name and email are required.';

	/// en: 'Please enter a valid email address.'
	String get invalidEmail => 'Please enter a valid email address.';
}

// Path: onboarding.agents
class Translations$onboarding$agents$en {
	Translations$onboarding$agents$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect Your AI Agents'
	String get title => 'Connect Your AI Agents';

	/// en: 'Login to one or more AI coding assistants. All are optional.'
	String get description => 'Login to one or more AI coding assistants. All are optional.';

	/// en: 'You can configure these later in Settings.'
	String get laterHint => 'You can configure these later in Settings.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect agents to ddagent'
	String get title => 'Connect agents to ddagent';

	/// en: 'Install the ddagent MCP server so your agents can use the knowledge base and ddagent tools. Pick agents, or install for all.'
	String get description => 'Install the ddagent MCP server so your agents can use the knowledge base and ddagent tools. Pick agents, or install for all.';

	/// en: 'Install selected'
	String get installSelected => 'Install selected';

	/// en: 'Install for all'
	String get installForAll => 'Install for all';

	/// en: 'Optional — you can also install this later in Settings → MCP.'
	String get laterHint => 'Optional — you can also install this later in Settings → MCP.';

	/// en: '(one) {Installed on {{count}} agent.} (other) {Installed on {{count}} agents.}'
	String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Installed on ${count} agent.',
		other: 'Installed on ${count} agents.',
	);

	/// en: 'Installed on {{installedCount}}; failed: {{failed}}'
	String installedWithFailures({required Object installedCount, required Object failed}) => 'Installed on ${installedCount}; failed: ${failed}';
}

// Path: quota.section
class Translations$quota$section$en {
	Translations$quota$section$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Config'
	String get config => 'Config';
}

// Path: quota.overview
class Translations$quota$overview$en {
	Translations$quota$overview$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tokens and cost'
	String get tokensAndCost => 'Tokens and cost';
}

// Path: quota.agents
class Translations$quota$agents$en {
	Translations$quota$agents$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{status}} ({{count}})'
	String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.config
class Translations$quota$config$en {
	Translations$quota$config$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Poller & alerts'
	String get pollerTitle => 'Poller & alerts';

	/// en: 'Account routing'
	String get accountRouting => 'Account routing';

	/// en: 'Save config'
	String get save => 'Save config';
}

// Path: quota.chart
class Translations$quota$chart$en {
	Translations$quota$chart$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Show'
	String get show => 'Show';

	/// en: 'Hide'
	String get hide => 'Hide';

	/// en: 'Not enough data for a trend.'
	String get noData => 'Not enough data for a trend.';

	/// en: '{{date}} · {{tokens}} tokens · {{cost}}'
	String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokens · ${cost}';
}

// Path: serverConnect.local
class Translations$serverConnect$local$en {
	Translations$serverConnect$local$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This device'
	String get title => 'This device';

	/// en: 'Run the ddagent server on this machine'
	String get subtitle => 'Run the ddagent server on this machine';

	/// en: 'Install local server'
	String get install => 'Install local server';

	/// en: 'Start local server'
	String get start => 'Start local server';

	/// en: 'Stop'
	String get stop => 'Stop';

	/// en: 'Starting local server…'
	String get starting => 'Starting local server…';

	/// en: 'Downloading server… {{percent}}%'
	String downloading({required Object percent}) => 'Downloading server… ${percent}%';

	/// en: 'Installing…'
	String get installing => 'Installing…';

	/// en: 'Running at {{url}}'
	String running({required Object url}) => 'Running at ${url}';

	/// en: 'Installed (v{{version}})'
	String installed({required Object version}) => 'Installed (v${version})';

	/// en: 'Use this server'
	String get connect => 'Use this server';

	/// en: 'Local server error: {{error}}'
	String error({required Object error}) => 'Local server error: ${error}';

	/// en: 'or connect to a remote server'
	String get or => 'or connect to a remote server';
}

// Path: sessions.toasts
class Translations$sessions$toasts$en {
	Translations$sessions$toasts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Session archived'
	String get archived => 'Session archived';

	/// en: 'Session restored'
	String get restored => 'Session restored';

	/// en: 'Session deleted'
	String get deleted => 'Session deleted';

	/// en: 'Session renamed'
	String get renamed => 'Session renamed';

	/// en: 'Session pinned'
	String get pinned => 'Session pinned';

	/// en: 'Session unpinned'
	String get unpinned => 'Session unpinned';

	/// en: 'Workspace changed'
	String get workspaceChanged => 'Workspace changed';
}

// Path: sessions.age
class Translations$sessions$age$en {
	Translations$sessions$age$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '<1m'
	String get lessThanMinute => '<1m';

	/// en: '{{count}}m'
	String minutes({required Object count}) => '${count}m';

	/// en: '{{hours}}hr'
	String hours({required Object hours}) => '${hours}hr';

	/// en: '{{days}}d'
	String days({required Object days}) => '${days}d';
}

// Path: sessions.activity
class Translations$sessions$activity$en {
	Translations$sessions$activity$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Subagent running'
	String get subagentRunning => 'Subagent running';

	/// en: 'Reading {{file}}'
	String readingFile({required Object file}) => 'Reading ${file}';

	/// en: 'Running {{name}}'
	String runningTool({required Object name}) => 'Running ${name}';

	/// en: 'Editing {{file}}'
	String editingFile({required Object file}) => 'Editing ${file}';

	/// en: 'Editing a file'
	String get editingFileGeneric => 'Editing a file';

	/// en: 'Running a shell command'
	String get runningShellCommand => 'Running a shell command';

	/// en: 'Running `{{command}}`'
	String runningCommand({required Object command}) => 'Running `${command}`';

	/// en: 'Committing changes'
	String get committingChanges => 'Committing changes';

	/// en: 'Pushing branch'
	String get pushingBranch => 'Pushing branch';

	/// en: 'Fetching {{url}}'
	String fetchingUrl({required Object url}) => 'Fetching ${url}';

	/// en: 'Searching “{{query}}”'
	String searching({required Object query}) => 'Searching “${query}”';
}

// Path: skills.addDialog
class Translations$skills$addDialog$en {
	Translations$skills$addDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add {{provider}} Skill'
	String title({required Object provider}) => 'Add ${provider} Skill';

	/// en: 'Choose SKILL.md'
	String get chooseFileTitle => 'Choose SKILL.md';

	/// en: 'Choose a skill folder'
	String get chooseFolderTitle => 'Choose a skill folder';

	/// en: 'Upload a SKILL.md file or a complete skill folder.'
	String get uploadHint => 'Upload a SKILL.md file or a complete skill folder.';

	/// en: 'Pick a skill folder or SKILL.md'
	String get pickTitle => 'Pick a skill folder or SKILL.md';

	/// en: 'Folders can include scripts, references, and assets.'
	String get pickHint => 'Folders can include scripts, references, and assets.';

	/// en: 'Choose Files'
	String get chooseFiles => 'Choose Files';

	/// en: 'Choose Folder'
	String get chooseFolder => 'Choose Folder';

	/// en: 'Ready to install'
	String get readyToInstall => 'Ready to install';

	/// en: 'Markdown file · {{size}}'
	String markdownFileMeta({required Object size}) => 'Markdown file · ${size}';

	/// en: '(one) {{{count}} file · {{size}}} (other) {{{count}} files · {{size}}}'
	String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} file · ${size}',
		other: '${count} files · ${size}',
	);

	/// en: 'Remove {{name}}'
	String removeQueued({required Object name}) => 'Remove ${name}';

	/// en: 'Where will this install?'
	String get whereWillThisInstall => 'Where will this install?';

	/// en: 'Hide install location'
	String get hideInstallLocation => 'Hide install location';

	/// en: 'Folder uploads keep the selected folder name; standalone files use the `name` in `SKILL.md`.'
	String get folderUploadsNote => 'Folder uploads keep the selected folder name; standalone files use the `name` in `SKILL.md`.';

	/// en: 'Install Skill'
	String get installSkill => 'Install Skill';

	/// en: '(one) {Install {{count}} Skill} (other) {Install {{count}} Skills}'
	String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Install ${count} Skill',
		other: 'Install ${count} Skills',
	);
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose the project that should own this skill. It moves out of the provider's global skills directory.'
	String get toProjectHint => 'Choose the project that should own this skill. It moves out of the provider\'s global skills directory.';

	/// en: 'Move this skill into the global skills directory so every project can use it.'
	String get toGlobalHint => 'Move this skill into the global skills directory so every project can use it.';

	/// en: 'Move to project'
	String get moveToProject => 'Move to project';

	/// en: 'Move to global'
	String get moveToGlobal => 'Move to global';
}

// Path: skills.screen
class Translations$skills$screen$en {
	Translations$skills$screen$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Manage {{provider}} skills from local files, complete folders, and project-aware locations.'
	String manageDescription({required Object provider}) => 'Manage ${provider} skills from local files, complete folders, and project-aware locations.';

	/// en: 'Search skills...'
	String get searchHint => 'Search skills...';

	/// en: 'Clear skill search'
	String get clearSearch => 'Clear skill search';

	/// en: 'Add Skill'
	String get addSkill => 'Add Skill';

	/// en: 'Scanning project skills...'
	String get scanningProjectSkills => 'Scanning project skills...';

	/// en: 'Skills saved successfully.'
	String get savedSuccessfully => 'Skills saved successfully.';

	/// en: 'Loading {{provider}} skills…'
	String loadingSkills({required Object provider}) => 'Loading ${provider} skills…';

	/// en: '(one) {{{count}} SKILL} (other) {{{count}} SKILLS}'
	String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} SKILL',
		other: '${count} SKILLS',
	);

	/// en: 'Delete {{name}}?'
	String deleteTitle({required Object name}) => 'Delete ${name}?';

	/// en: 'This removes the {{directory}} directory from {{provider}}'s managed skills directory. This cannot be undone.'
	String deleteDescription({required Object directory, required Object provider}) => 'This removes the ${directory} directory from ${provider}\'s managed skills directory. This cannot be undone.';

	/// en: 'No description provided in the skill front matter.'
	String get noDescription => 'No description provided in the skill front matter.';

	/// en: 'Plugin: {{name}}'
	String pluginBadge({required Object name}) => 'Plugin: ${name}';

	/// en: 'Project: {{name}}'
	String projectBadge({required Object name}) => 'Project: ${name}';

	/// en: 'SOURCE'
	String get sourceLabel => 'SOURCE';
}

// Path: skills.empty
class Translations$skills$empty$en {
	Translations$skills$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No projects available'
	String get noProjects => 'No projects available';

	/// en: 'Add a project or workspace to browse its skills.'
	String get noProjectsDescription => 'Add a project or workspace to browse its skills.';

	/// en: 'No skills in this project'
	String get noSkillsInProject => 'No skills in this project';

	/// en: 'Create a .claude/skills, .cursor/skills or .agents/skills folder in the selected project.'
	String get noSkillsInProjectDescription => 'Create a .claude/skills, .cursor/skills or .agents/skills folder in the selected project.';

	/// en: 'No global skills discovered yet'
	String get noGlobalSkills => 'No global skills discovered yet';

	/// en: 'Add a global skill above to make it available across every project.'
	String get noGlobalSkillsDescription => 'Add a global skill above to make it available across every project.';

	/// en: 'No matching skills'
	String get noMatchingSkills => 'No matching skills';

	/// en: 'Try a different command, name, scope, project, or source path.'
	String get noMatchingSkillsDescription => 'Try a different command, name, scope, project, or source path.';
}

// Path: skills.scopes
class Translations$skills$scopes$en {
	Translations$skills$scopes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'User'
	String get user => 'User';

	/// en: 'Plugin'
	String get plugin => 'Plugin';

	/// en: 'Repo'
	String get repo => 'Repo';

	/// en: 'Project'
	String get project => 'Project';

	/// en: 'Admin'
	String get admin => 'Admin';

	/// en: 'System'
	String get system => 'System';
}

// Path: skills.errors
class Translations$skills$errors$en {
	Translations$skills$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Drop one or more markdown files or a folder containing SKILL.md.'
	String get dropMarkdownOrFolder => 'Drop one or more markdown files or a folder containing SKILL.md.';

	/// en: 'Add one or more markdown files first.'
	String get addMarkdownFirst => 'Add one or more markdown files first.';

	/// en: 'Failed to import skills'
	String get importFailed => 'Failed to import skills';

	/// en: 'Failed to read skill folder'
	String get folderReadFailed => 'Failed to read skill folder';

	/// en: 'A skill folder can contain up to {{count}} files.'
	String folderFileLimit({required Object count}) => 'A skill folder can contain up to ${count} files.';

	/// en: 'Selected skill folders must be smaller than 30 MB in total.'
	String get folderSizeLimit => 'Selected skill folders must be smaller than 30 MB in total.';

	/// en: 'The selected folder does not contain a SKILL.md file.'
	String get missingSkillFile => 'The selected folder does not contain a SKILL.md file.';

	/// en: 'Could not read SKILL.md from {{name}}.'
	String couldNotReadSkillFile({required Object name}) => 'Could not read SKILL.md from ${name}.';
}

// Path: terminal.tabs
class Translations$terminal$tabs$en {
	Translations$terminal$tabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shell {{index}}'
	String shellName({required Object index}) => 'Shell ${index}';

	/// en: 'Plain Shell'
	String get plainShell => 'Plain Shell';

	/// en: 'Claude CLI'
	String get claudeCli => 'Claude CLI';

	/// en: 'OpenCode CLI'
	String get opencodeCli => 'OpenCode CLI';

	/// en: 'Command Code CLI'
	String get commandCodeCli => 'Command Code CLI';

	/// en: 'Antigravity CLI'
	String get antigravityCli => 'Antigravity CLI';

	/// en: 'Cursor CLI'
	String get cursorCli => 'Cursor CLI';

	/// en: 'Devin CLI'
	String get devinCli => 'Devin CLI';

	/// en: 'Login: {{provider}}'
	String loginTitle({required Object provider}) => 'Login: ${provider}';
}

// Path: terminal.actions
class Translations$terminal$actions$en {
	Translations$terminal$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Terminal Tab'
	String get newTab => 'New Terminal Tab';

	/// en: 'Provider Login'
	String get providerLogin => 'Provider Login';

	/// en: 'Restart Session'
	String get restartSession => 'Restart Session';

	/// en: 'Clear Output'
	String get clearOutput => 'Clear Output';

	/// en: 'New Shell'
	String get newShell => 'New Shell';

	/// en: 'Connect'
	String get connect => 'Connect';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Open in browser'
	String get openInBrowser => 'Open in browser';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'File detected: {{path}}'
	String detected({required Object path}) => 'File detected: ${path}';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Interrupt (SIGINT)'
	String get interrupt => 'Interrupt (SIGINT)';

	/// en: 'EOF'
	String get eof => 'EOF';

	/// en: 'Suspend (SIGTSTP)'
	String get suspend => 'Suspend (SIGTSTP)';

	/// en: 'Hide shortcuts bar'
	String get hide => 'Hide shortcuts bar';

	/// en: 'Show Shortcuts'
	String get showTooltip => 'Show Shortcuts';

	/// en: 'Hide Shortcuts'
	String get hideTooltip => 'Hide Shortcuts';
}

// Path: terminal.paste
class Translations$terminal$paste$en {
	Translations$terminal$paste$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Paste into terminal'
	String get title => 'Paste into terminal';

	/// en: 'Ctrl+V / right-click → Paste'
	String get hint => 'Ctrl+V / right-click → Paste';
}

// Path: terminal.errors
class Translations$terminal$errors$en {
	Translations$terminal$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not open link: {{url}}'
	String couldNotOpenLink({required Object url}) => 'Could not open link: ${url}';
}

// Path: auth.login.errors
class Translations$auth$login$errors$en {
	Translations$auth$login$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Invalid username or password'
	String get invalidCredentials => 'Invalid username or password';

	/// en: 'Please fill in all fields'
	String get requiredFields => 'Please fill in all fields';

	/// en: 'Network error. Please try again.'
	String get networkError => 'Network error. Please try again.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter your username'
	String get username => 'Enter your username';

	/// en: 'Enter your password'
	String get password => 'Enter your password';
}

// Path: auth.register.errors
class Translations$auth$register$errors$en {
	Translations$auth$register$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Passwords do not match'
	String get passwordMismatch => 'Passwords do not match';

	/// en: 'Username is already taken'
	String get usernameTaken => 'Username is already taken';

	/// en: 'Password is too weak'
	String get weakPassword => 'Password is too weak';

	/// en: 'Username must be at least 3 characters'
	String get usernameTooShort => 'Username must be at least 3 characters';

	/// en: 'Password must be at least 6 characters'
	String get passwordTooShort => 'Password must be at least 6 characters';
}

// Path: chat.orchestrator.routing
class Translations$chat$orchestrator$routing$en {
	Translations$chat$orchestrator$routing$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Routing'
	String get title => 'Routing';

	/// en: 'Alternatives: {{list}}'
	String alternatives({required Object list}) => 'Alternatives: ${list}';

	/// en: '{{label}} — first candidate for {{task}}'
	String first({required Object label, required Object task}) => '${label} — first candidate for ${task}';

	/// en: '{{label}} — earlier candidates skipped ({{list}})'
	String skipped({required Object label, required Object list}) => '${label} — earlier candidates skipped (${list})';
}

// Path: chat.orchestrator.plan
class Translations$chat$orchestrator$plan$en {
	Translations$chat$orchestrator$plan$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Plan'
	String get title => 'Plan';

	/// en: 'disabled'
	String get disabled => 'disabled';

	/// en: 'Waiting for plan confirmation.'
	String get awaitingConfirm => 'Waiting for plan confirmation.';

	/// en: 'Run plan'
	String get run => 'Run plan';

	/// en: 'Enable step'
	String get toggleStep => 'Enable step';

	/// en: 'Failed to start — try again.'
	String get confirmFailed => 'Failed to start — try again.';

	/// en: 'planner unavailable — single-step fallback'
	String get fallback => 'planner unavailable — single-step fallback';

	/// en: 'from pipeline template'
	String get templateSource => 'from pipeline template';

	/// en: 'planner off'
	String get offSource => 'planner off';

	/// en: '(one) {{{count}} step} (other) {{{count}} steps}'
	String stepCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} step',
		other: '${count} steps',
	);

	/// en: 'supervised loop'
	String get supervisedSource => 'supervised loop';
}

// Path: chat.orchestrator.decision
class Translations$chat$orchestrator$decision$en {
	Translations$chat$orchestrator$decision$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Supervisor decision'
	String get title => 'Supervisor decision';

	/// en: 'iteration {{n}}'
	String iteration({required Object n}) => 'iteration ${n}';

	/// en: 'Why'
	String get rationaleLabel => 'Why';

	/// en: 'Waiting for your approval before running these steps.'
	String get awaitingConfirm => 'Waiting for your approval before running these steps.';

	/// en: 'Proposed steps'
	String get proposedSteps => 'Proposed steps';

	late final Translations$chat$orchestrator$decision$action$en action = Translations$chat$orchestrator$decision$action$en.internal(_root);
	late final Translations$chat$orchestrator$decision$outcome$en outcome = Translations$chat$orchestrator$decision$outcome$en.internal(_root);
}

// Path: chat.orchestrator.delegation
class Translations$chat$orchestrator$delegation$en {
	Translations$chat$orchestrator$delegation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delegated step'
	String get title => 'Delegated step';

	/// en: 'Open full session'
	String get openSession => 'Open full session';

	/// en: 'attempt {{n}}'
	String attempt({required Object n}) => 'attempt ${n}';

	/// en: 'Retry / Fix'
	String get retryStep => 'Retry / Fix';

	/// en: 'Continue / Fix'
	String get continueStep => 'Continue / Fix';

	/// en: 'Failed — try again.'
	String get continueFailed => 'Failed — try again.';

	late final Translations$chat$orchestrator$delegation$status$en status = Translations$chat$orchestrator$delegation$status$en.internal(_root);

	/// en: '(one) {{{count}} attempt} (other) {{{count}} attempts}'
	String attempts({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} attempt',
		other: '${count} attempts',
	);

	/// en: 'candidates: {{list}}'
	String candidates({required Object list}) => 'candidates: ${list}';

	/// en: '(one) {{{count}} candidate} (other) {{{count}} candidates}'
	String candidateCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} candidate',
		other: '${count} candidates',
	);
}

// Path: chat.orchestrator.summary
class Translations$chat$orchestrator$summary$en {
	Translations$chat$orchestrator$summary$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Summary'
	String get title => 'Summary';

	/// en: 'Steps completed: {{done}}/{{total}}'
	String progress({required Object done, required Object total}) => 'Steps completed: ${done}/${total}';

	/// en: 'aborted'
	String get aborted => 'aborted';

	/// en: 'timed out'
	String get timedOut => 'timed out';

	/// en: 'iteration cap'
	String get capped => 'iteration cap';

	/// en: 'Failed steps: {{list}}'
	String failed({required Object list}) => 'Failed steps: ${list}';

	/// en: 'Continue'
	String get kContinue => 'Continue';

	/// en: 'Continue work'
	String get continueWork => 'Continue work';

	/// en: 'Failed to resume — try again.'
	String get resumeFailed => 'Failed to resume — try again.';

	/// en: 'Run next task'
	String get runNextTask => 'Run next task';

	/// en: 'End all tasks'
	String get endAllTasks => 'End all tasks';

	/// en: 'Working on tasks…'
	String get tasksRunning => 'Working on tasks…';

	/// en: 'Cancel'
	String get cancelTasks => 'Cancel';
}

// Path: chat.orchestrator.taskmaster
class Translations$chat$orchestrator$taskmaster$en {
	Translations$chat$orchestrator$taskmaster$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Task queue'
	String get title => 'Task queue';

	/// en: '(one) {{{count}} left} (other) {{{count}} left}'
	String remaining({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} left',
		other: '${count} left',
	);

	late final Translations$chat$orchestrator$taskmaster$status$en status = Translations$chat$orchestrator$taskmaster$status$en.internal(_root);
}

// Path: chat.orchestrator.gate
class Translations$chat$orchestrator$gate$en {
	Translations$chat$orchestrator$gate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'timed out'
	String get timedOut => 'timed out';

	/// en: 'exit {{code}}'
	String exit({required Object code}) => 'exit ${code}';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Default Mode'
	String get kDefault => 'Default Mode';

	/// en: 'Auto Mode'
	String get auto => 'Auto Mode';

	/// en: 'Accept Edits'
	String get acceptEdits => 'Accept Edits';

	/// en: 'Bypass Permissions'
	String get bypassPermissions => 'Bypass Permissions';

	/// en: 'Plan Mode'
	String get plan => 'Plan Mode';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Only trusted commands (ls, cat, grep, git status, etc.) run automatically. Other commands are skipped. Can write to workspace.'
	String get kDefault => 'Only trusted commands (ls, cat, grep, git status, etc.) run automatically. Other commands are skipped. Can write to workspace.';

	/// en: 'A model classifier decides per tool call whether to approve or deny. Hands-off, but safer than Bypass — denials still happen.'
	String get auto => 'A model classifier decides per tool call whether to approve or deny. Hands-off, but safer than Bypass — denials still happen.';

	/// en: 'All commands run automatically within the workspace. Full auto mode with sandboxed execution.'
	String get acceptEdits => 'All commands run automatically within the workspace. Full auto mode with sandboxed execution.';

	/// en: 'Full system access with no restrictions. All commands run automatically with full disk and network access. Use with caution.'
	String get bypassPermissions => 'Full system access with no restrictions. All commands run automatically with full disk and network access. Use with caution.';

	/// en: 'Planning mode - no commands are executed'
	String get plan => 'Planning mode - no commands are executed';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ctrl+Enter to send • / commands • @ files'
	String get ctrlEnter => 'Ctrl+Enter to send • / commands • @ files';

	/// en: 'Enter to send • Shift+Enter newline • / commands • @ files'
	String get enter => 'Enter to send • Shift+Enter newline • / commands • @ files';

	/// en: 'Enter to queue your next message'
	String get queue => 'Enter to queue your next message';

	/// en: 'Enter to update queued message'
	String get updateQueued => 'Enter to update queued message';
}

// Path: chat.input.queue
class Translations$chat$input$queue$en {
	Translations$chat$input$queue$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Queue next message'
	String get sendNext => 'Queue next message';

	/// en: 'Update queued message'
	String get update => 'Update queued message';

	/// en: 'Queued'
	String get label => 'Queued';

	/// en: 'Will send when this finishes'
	String get willSend => 'Will send when this finishes';

	/// en: 'Edit queued message'
	String get edit => 'Edit queued message';

	/// en: 'Delete queued message'
	String get delete => 'Delete queued message';

	/// en: 'Failed to send'
	String get failed => 'Failed to send';

	/// en: 'Send now'
	String get sendNow => 'Send now';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel and clear offline queue'
	String get clear => 'Cancel and clear offline queue';

	/// en: 'Cancel'
	String get clearBtn => 'Cancel';

	/// en: '{{count}} messages queued offline — will send automatically when reconnected'
	String multiple({required Object count}) => '${count} messages queued offline — will send automatically when reconnected';

	/// en: '1 message queued offline — will send automatically when reconnected'
	String get single => '1 message queued offline — will send automatically when reconnected';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'by Anthropic'
	String get anthropic => 'by Anthropic';

	/// en: 'by OpenAI'
	String get openai => 'by OpenAI';

	/// en: 'AI Code Editor'
	String get cursorEditor => 'AI Code Editor';

	/// en: 'by Google'
	String get google => 'by Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ready to use Claude with {{model}}. Start typing your message below.'
	String claude({required Object model}) => 'Ready to use Claude with ${model}. Start typing your message below.';

	/// en: 'Ready to use Cursor with {{model}}. Start typing your message below.'
	String cursor({required Object model}) => 'Ready to use Cursor with ${model}. Start typing your message below.';

	/// en: 'Ready to use Codex with {{model}}. Start typing your message below.'
	String codex({required Object model}) => 'Ready to use Codex with ${model}. Start typing your message below.';

	/// en: 'Ready to use OpenCode with {{model}}. Start typing your message below.'
	String opencode({required Object model}) => 'Ready to use OpenCode with ${model}. Start typing your message below.';

	/// en: 'Select a provider above to begin'
	String get kDefault => 'Select a provider above to begin';

	/// en: 'Ready with Devin {{model}}'
	String devin({required Object model}) => 'Ready with Devin ${model}';

	/// en: 'Ready with Auto — the router picks the best model per step'
	String get orchestrator => 'Ready with Auto — the router picks the best model per step';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Continue your conversation'
	String get title => 'Continue your conversation';

	/// en: 'Ask questions about your code, request changes, or get help with development tasks'
	String get description => 'Ask questions about your code, request changes, or get help with development tasks';

	/// en: 'Continue typing'
	String get action => 'Continue typing';
}

// Path: chat.session.loading
class Translations$chat$session$loading$en {
	Translations$chat$session$loading$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading older messages...'
	String get olderMessages => 'Loading older messages...';

	/// en: 'Loading session messages...'
	String get sessionMessages => 'Loading session messages...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$en {
	Translations$chat$session$messages$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Showing {{shown}} of {{total}} messages'
	String showingOf({required Object shown, required Object total}) => 'Showing ${shown} of ${total} messages';

	/// en: 'Scroll up to load more'
	String get scrollToLoad => 'Scroll up to load more';

	/// en: 'Showing last {{count}} messages ({{total}} total)'
	String showingLast({required Object count, required Object total}) => 'Showing last ${count} messages (${total} total)';

	/// en: 'Load earlier messages'
	String get loadEarlier => 'Load earlier messages';

	/// en: 'Failed to load older messages.'
	String get loadOlderFailed => 'Failed to load older messages.';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Load all messages'
	String get loadAll => 'Load all messages';

	/// en: 'Loading all messages...'
	String get loadingAll => 'Loading all messages...';

	/// en: 'All messages loaded'
	String get allLoaded => 'All messages loaded';

	/// en: 'All messages loaded — scrolling may be slower. Click "Scroll to bottom" to restore performance.'
	String get perfWarning => 'All messages loaded — scrolling may be slower. Click "Scroll to bottom" to restore performance.';

	/// en: 'No messages match your search.'
	String get noSearchMatches => 'No messages match your search.';

	/// en: 'Load older messages'
	String get loadOlder => 'Load older messages';

	/// en: 'Load all ({{count}})'
	String loadAllCount({required Object count}) => 'Load all (${count})';

	/// en: 'Retry loading older — {{error}}'
	String retryLoadOlder({required Object error}) => 'Retry loading older — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select a Project'
	String get title => 'Select a Project';

	/// en: 'Choose a project to open an interactive shell in that directory'
	String get description => 'Choose a project to open an interactive shell in that directory';
}

// Path: chat.shell.status
class Translations$chat$shell$status$en {
	Translations$chat$shell$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Session'
	String get newSession => 'New Session';

	/// en: 'Initializing...'
	String get initializing => 'Initializing...';

	/// en: 'Restarting...'
	String get restarting => 'Restarting...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Disconnect'
	String get disconnect => 'Disconnect';

	/// en: 'Disconnect from shell'
	String get disconnectTitle => 'Disconnect from shell';

	/// en: 'Restart'
	String get restart => 'Restart';

	/// en: 'Restart Shell'
	String get restartTitle => 'Restart Shell';

	/// en: 'Kill (SIGINT)'
	String get kill => 'Kill (SIGINT)';

	/// en: 'Kill running process (Ctrl+C)'
	String get killTitle => 'Kill running process (Ctrl+C)';

	/// en: 'Copy output'
	String get copyOutput => 'Copy output';

	/// en: 'Copy terminal output'
	String get copyOutputTitle => 'Copy terminal output';

	/// en: 'Copied!'
	String get copied => 'Copied!';

	/// en: 'Zoom in'
	String get zoomInTitle => 'Zoom in';

	/// en: 'Zoom out'
	String get zoomOutTitle => 'Zoom out';

	/// en: 'Continue in Shell'
	String get connect => 'Continue in Shell';

	/// en: 'Connect to shell'
	String get connectTitle => 'Connect to shell';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Thinking'
	String get thinking => 'Thinking';

	/// en: 'Processing'
	String get processing => 'Processing';

	/// en: 'Analyzing'
	String get analyzing => 'Analyzing';

	/// en: 'Working'
	String get working => 'Working';

	/// en: 'Computing'
	String get computing => 'Computing';

	/// en: 'Reasoning'
	String get reasoning => 'Reasoning';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Live'
	String get live => 'Live';

	/// en: 'Paused'
	String get paused => 'Paused';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{count}}s'
	String seconds({required Object count}) => '${count}s';

	/// en: '{{minutes}}m {{seconds}}s'
	String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';

	/// en: '{{time}} elapsed'
	String label({required Object time}) => '${time} elapsed';

	/// en: 'Starting now'
	String get startingNow => 'Starting now';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Stop Generation'
	String get stopGeneration => 'Stop Generation';

	/// en: 'Press Esc anytime to stop'
	String get pressEscToStop => 'Press Esc anytime to stop';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Assistant'
	String get assistant => 'Assistant';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Browse available models for the active provider.'
	String get models => 'Browse available models for the active provider.';

	/// en: 'Review token usage for the active session.'
	String get cost => 'Review token usage for the active session.';

	/// en: 'Inspect runtime, version, provider, and environment status.'
	String get status => 'Inspect runtime, version, provider, and environment status.';

	/// en: 'Open the project CLAUDE.md memory file.'
	String get memory => 'Open the project CLAUDE.md memory file.';

	/// en: 'Open settings and configuration.'
	String get config => 'Open settings and configuration.';

	/// en: 'Show command documentation and syntax.'
	String get help => 'Show command documentation and syntax.';
}

// Path: common.quota.section
class Translations$common$quota$section$en {
	Translations$common$quota$section$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Overview'
	String get overview => 'Overview';

	/// en: 'Quotas'
	String get quotas => 'Quotas';

	/// en: 'Usage'
	String get usage => 'Usage';

	/// en: 'Agents'
	String get agents => 'Agents';
}

// Path: common.quota.filter
class Translations$common$quota$filter$en {
	Translations$common$quota$filter$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All'
	String get all => 'All';
}

// Path: common.quota.period
class Translations$common$quota$period$en {
	Translations$common$quota$period$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '24h'
	String get k24h => '24h';

	/// en: '7 days'
	String get k7d => '7 days';

	/// en: '30 days'
	String get k30d => '30 days';

	/// en: 'All'
	String get all => 'All';
}

// Path: common.quota.group
class Translations$common$quota$group$en {
	Translations$common$quota$group$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Provider'
	String get provider => 'Provider';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'Agent'
	String get agent => 'Agent';

	/// en: 'Tool'
	String get tool => 'Tool';
}

// Path: common.quota.metric
class Translations$common$quota$metric$en {
	Translations$common$quota$metric$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tokens'
	String get tokens => 'Tokens';

	/// en: 'Input'
	String get input => 'Input';

	/// en: 'Output'
	String get output => 'Output';

	/// en: 'Cache read'
	String get cache => 'Cache read';

	/// en: 'API calls'
	String get calls => 'API calls';

	/// en: 'Cost'
	String get cost => 'Cost';

	/// en: 'Sessions'
	String get sessions => 'Sessions';
}

// Path: common.quota.cost
class Translations$common$quota$cost$en {
	Translations$common$quota$cost$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Billed (API + overage)'
	String get billed => 'Billed (API + overage)';

	/// en: 'List price of tokens used'
	String get listPrice => 'List price of tokens used';

	/// en: 'Covered by subscriptions'
	String get subscriptionValue => 'Covered by subscriptions';

	/// en: 'Cache savings'
	String get cacheSavings => 'Cache savings';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Billed (API + overage)'
	String get billed => 'Billed (API + overage)';

	/// en: 'List price of tokens used'
	String get listPrice => 'List price of tokens used';

	/// en: 'Covered by subscriptions'
	String get subscriptionValue => 'Covered by subscriptions';
}

// Path: common.quota.overview
class Translations$common$quota$overview$en {
	Translations$common$quota$overview$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tokens and cost — last 7 days'
	String get trendTitle => 'Tokens and cost — last 7 days';

	/// en: 'Effective cost (7 days)'
	String get effectiveCost => 'Effective cost (7 days)';

	/// en: 'Alerts'
	String get alertsTitle => 'Alerts';

	/// en: 'Nothing needs attention right now.'
	String get noAlerts => 'Nothing needs attention right now.';

	/// en: 'Usage and limits'
	String get limitsTitle => 'Usage and limits';

	/// en: 'Active tasks'
	String get activeTasks => 'Active tasks';

	/// en: 'All accounts'
	String get viewAccounts => 'All accounts';

	/// en: 'All agents'
	String get viewAgents => 'All agents';

	/// en: 'No agents are running right now.'
	String get noTasks => 'No agents are running right now.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$en {
	Translations$common$quota$usage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Daily trend'
	String get trendTitle => 'Daily trend';

	/// en: 'Breakdown by {{group}}'
	String breakdownTitle({required Object group}) => 'Breakdown by ${group}';

	/// en: 'Name'
	String get colName => 'Name';

	/// en: 'Analytics store unavailable; showing no data.'
	String get sourceUnavailable => 'Analytics store unavailable; showing no data.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$en {
	Translations$common$quota$agents$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{value}} running'
	String runningCount({required Object value}) => '${value} running';

	/// en: 'Agent'
	String get colAgent => 'Agent';

	/// en: 'Status'
	String get colStatus => 'Status';

	/// en: 'Task'
	String get colTask => 'Task';

	/// en: 'Account / model'
	String get colModel => 'Account / model';

	/// en: 'Time'
	String get colTime => 'Time';

	/// en: 'No agents match this filter.'
	String get empty => 'No agents match this filter.';

	/// en: 'Session'
	String get detailSession => 'Session';

	/// en: 'Started'
	String get detailStarted => 'Started';

	/// en: 'Retries'
	String get detailRetries => 'Retries';

	/// en: 'Result'
	String get detailResult => 'Result';

	/// en: 'not tracked'
	String get notTracked => 'not tracked';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Running'
	String get running => 'Running';

	/// en: 'Waiting'
	String get waiting => 'Waiting';

	/// en: 'Failed'
	String get failed => 'Failed';

	/// en: 'Finished'
	String get finished => 'Finished';

	/// en: 'Queued'
	String get queued => 'Queued';
}

// Path: common.quota.alert
class Translations$common$quota$alert$en {
	Translations$common$quota$alert$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{account}} · {{window}}: at the current pace the limit runs out in {{value}}'
	String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: at the current pace the limit runs out in ${value}';

	/// en: '{{account}} · {{window}}: {{value}}% used (threshold {{watch}}%)'
	String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% used (threshold ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$en {
	Translations$common$quota$quality$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Live'
	String get live => 'Live';

	/// en: 'Cached'
	String get cached => 'Cached';

	/// en: 'Estimate'
	String get estimate => 'Estimate';

	/// en: 'Unknown'
	String get unknown => 'Unknown';

	/// en: 'Error'
	String get error => 'Error';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Limits at risk'
	String get atRisk => 'Limits at risk';

	/// en: 'accounts over {{value}}%'
	String atRiskHint({required Object value}) => 'accounts over ${value}%';

	/// en: 'Windows running out'
	String get windowsAtRisk => 'Windows running out';

	/// en: 'Sync failures'
	String get errored => 'Sync failures';

	/// en: 'Active agents'
	String get activeAgents => 'Active agents';

	/// en: '{{waiting}} waiting · {{queued}} queued'
	String agentsHint({required Object waiting, required Object queued}) => '${waiting} waiting · ${queued} queued';

	/// en: 'Next reset'
	String get nextReset => 'Next reset';

	/// en: 'Tokens'
	String get tokens => 'Tokens';

	/// en: '{{value}} sessions'
	String sessionsHint({required Object value}) => '${value} sessions';

	/// en: 'Estimated cost'
	String get cost => 'Estimated cost';

	/// en: '{{value}} covered by plans'
	String costHint({required Object value}) => '${value} covered by plans';
}

// Path: common.quota.empty
class Translations$common$quota$empty$en {
	Translations$common$quota$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No accounts connected'
	String get title => 'No accounts connected';

	/// en: 'Sign in to Claude, Codex, Gemini or CommandCode so quota can be tracked here.'
	String get description => 'Sign in to Claude, Codex, Gemini or CommandCode so quota can be tracked here.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$en {
	Translations$common$quota$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Alerting and routing'
	String get title => 'Alerting and routing';

	/// en: 'Control when the dashboard warns you and how accounts are suggested for new work.'
	String get description => 'Control when the dashboard warns you and how accounts are suggested for new work.';

	/// en: 'Predictive and threshold alerts'
	String get alertsEnabled => 'Predictive and threshold alerts';

	/// en: 'Warn before a limit runs out at the current pace, not only at 90%.'
	String get alertsEnabledHint => 'Warn before a limit runs out at the current pace, not only at 90%.';

	/// en: 'Watch threshold (%)'
	String get watchThreshold => 'Watch threshold (%)';

	/// en: 'Danger threshold (%)'
	String get dangerThreshold => 'Danger threshold (%)';

	/// en: 'Routing'
	String get routingMode => 'Routing';

	late final Translations$common$quota$settings$routing$en routing = Translations$common$quota$settings$routing$en.internal(_root);

	/// en: 'Log sources'
	String get logSources => 'Log sources';

	/// en: 'Usage and agent screens read these read-only sources.'
	String get logSourcesHint => 'Usage and agent screens read these read-only sources.';

	/// en: 'Allow quota polling'
	String get quotaConsent => 'Allow quota polling';

	/// en: 'Poll provider endpoints with your stored credentials to read live limits.'
	String get quotaConsentHint => 'Poll provider endpoints with your stored credentials to read live limits.';

	/// en: 'Per-account overrides'
	String get perAccount => 'Per-account overrides';

	/// en: 'Control Center settings'
	String get tab => 'Control Center settings';
}

// Path: common.quota.range
class Translations$common$quota$range$en {
	Translations$common$quota$range$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '24h'
	String get k24h => '24h';

	/// en: '7d'
	String get k7d => '7d';

	/// en: '30d'
	String get k30d => '30d';

	/// en: 'All'
	String get all => 'All';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Copy Path'
	String get copyPath => 'Copy Path';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'New File'
	String get newFile => 'New File';

	/// en: 'New Folder'
	String get newFolder => 'New Folder';

	/// en: 'Upload Files'
	String get upload => 'Upload Files';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'File context menu'
	String get menuLabel => 'File context menu';

	/// en: 'Loading...'
	String get loading => 'Loading...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete'
	String get confirm => 'Delete';

	/// en: 'This file will be permanently deleted.'
	String get fileWarning => 'This file will be permanently deleted.';

	/// en: 'This folder and all its contents will be permanently deleted.'
	String get folderWarning => 'This folder and all its contents will be permanently deleted.';

	/// en: 'Delete {{type}}'
	String title({required Object type}) => 'Delete ${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to copy path'
	String get copyFailed => 'Failed to copy path';

	/// en: 'File created successfully'
	String get fileCreated => 'File created successfully';

	/// en: 'File deleted'
	String get fileDeleted => 'File deleted';

	/// en: 'Folder created successfully'
	String get folderCreated => 'Folder created successfully';

	/// en: 'Folder deleted'
	String get folderDeleted => 'Folder deleted';

	/// en: 'Folder downloaded as ZIP'
	String get folderDownloaded => 'Folder downloaded as ZIP';

	/// en: 'Path copied to clipboard'
	String get pathCopied => 'Path copied to clipboard';

	/// en: 'Renamed successfully'
	String get renamed => 'Renamed successfully';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filename cannot be only dots'
	String get dotsOnly => 'Filename cannot be only dots';

	/// en: 'Filename cannot be empty'
	String get emptyName => 'Filename cannot be empty';

	/// en: 'Filename contains invalid characters'
	String get invalidChars => 'Filename contains invalid characters';

	/// en: 'Filename is a reserved name'
	String get reserved => 'Filename is a reserved name';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Configure'
	String get configure => 'Configure';

	/// en: 'Confirm'
	String get confirm => 'Confirm';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Do you already have a workspace, or would you like to create a new one?'
	String get question => 'Do you already have a workspace, or would you like to create a new one?';

	late final Translations$common$projectWizard$step1$existing$en existing = Translations$common$projectWizard$step1$existing$en.internal(_root);
	late final Translations$common$projectWizard$step1$kNew$en kNew = Translations$common$projectWizard$step1$kNew$en.internal(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Workspace Path'
	String get existingPath => 'Workspace Path';

	/// en: 'Workspace Path'
	String get newPath => 'Workspace Path';

	/// en: '/path/to/existing/workspace'
	String get existingPlaceholder => '/path/to/existing/workspace';

	/// en: '/path/to/new/workspace'
	String get newPlaceholder => '/path/to/new/workspace';

	/// en: 'Full path to your existing workspace directory'
	String get existingHelp => 'Full path to your existing workspace directory';

	/// en: 'Full path to your workspace directory'
	String get newHelp => 'Full path to your workspace directory';

	/// en: 'GitHub URL (Optional)'
	String get githubUrl => 'GitHub URL (Optional)';

	/// en: 'https://github.com/username/repository'
	String get githubPlaceholder => 'https://github.com/username/repository';

	/// en: 'Optional: provide a GitHub URL to clone a repository'
	String get githubHelp => 'Optional: provide a GitHub URL to clone a repository';

	/// en: 'GitHub Authentication (Optional)'
	String get githubAuth => 'GitHub Authentication (Optional)';

	/// en: 'Only required for private repositories. Public repos can be cloned without authentication.'
	String get githubAuthHelp => 'Only required for private repositories. Public repos can be cloned without authentication.';

	/// en: 'Loading stored tokens...'
	String get loadingTokens => 'Loading stored tokens...';

	/// en: 'Stored Token'
	String get storedToken => 'Stored Token';

	/// en: 'New Token'
	String get newToken => 'New Token';

	/// en: 'None (Public)'
	String get nonePublic => 'None (Public)';

	/// en: 'Select Token'
	String get selectToken => 'Select Token';

	/// en: '-- Select a token --'
	String get selectTokenPlaceholder => '-- Select a token --';

	/// en: 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
	String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

	/// en: 'This token will be used only for this operation'
	String get tokenHelp => 'This token will be used only for this operation';

	/// en: 'Public repositories don't require authentication. You can skip providing a token if cloning a public repo.'
	String get publicRepoInfo => 'Public repositories don\'t require authentication. You can skip providing a token if cloning a public repo.';

	/// en: 'No stored tokens available. You can add tokens in Settings → API Keys for easier reuse.'
	String get noTokensHelp => 'No stored tokens available. You can add tokens in Settings → API Keys for easier reuse.';

	/// en: 'GitHub Token (Optional for Public Repos)'
	String get optionalTokenPublic => 'GitHub Token (Optional for Public Repos)';

	/// en: 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (leave empty for public repos)'
	String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (leave empty for public repos)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Review Your Configuration'
	String get reviewConfig => 'Review Your Configuration';

	/// en: 'Existing Workspace'
	String get existingWorkspace => 'Existing Workspace';

	/// en: 'New Workspace'
	String get newWorkspace => 'New Workspace';

	/// en: 'Path:'
	String get path => 'Path:';

	/// en: 'Clone From:'
	String get cloneFrom => 'Clone From:';

	/// en: 'Authentication:'
	String get authentication => 'Authentication:';

	/// en: 'Using stored token:'
	String get usingStoredToken => 'Using stored token:';

	/// en: 'Using provided token'
	String get usingProvidedToken => 'Using provided token';

	/// en: 'No authentication'
	String get noAuthentication => 'No authentication';

	/// en: 'SSH Key'
	String get sshKey => 'SSH Key';

	/// en: 'The workspace will be added to your project list and will be available for Claude/Cursor sessions.'
	String get existingInfo => 'The workspace will be added to your project list and will be available for Claude/Cursor sessions.';

	/// en: 'The repository will be cloned from this folder.'
	String get newWithClone => 'The repository will be cloned from this folder.';

	/// en: 'The workspace will be added to your project list and will be available for Claude/Cursor sessions.'
	String get newEmpty => 'The workspace will be added to your project list and will be available for Claude/Cursor sessions.';

	/// en: 'Cloning repository...'
	String get cloningRepository => 'Cloning repository...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Create Project'
	String get createProject => 'Create Project';

	/// en: 'Creating...'
	String get creating => 'Creating...';

	/// en: 'Cloning...'
	String get cloning => 'Cloning...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please select whether you have an existing workspace or want to create a new one'
	String get selectType => 'Please select whether you have an existing workspace or want to create a new one';

	/// en: 'Please provide a workspace path'
	String get providePath => 'Please provide a workspace path';

	/// en: 'Failed to create workspace'
	String get failedToCreate => 'Failed to create workspace';

	/// en: 'Failed to create folder'
	String get failedToCreateFolder => 'Failed to create folder';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$common$notifications$codes$generic$en generic = Translations$common$notifications$codes$generic$en.internal(_root);
	late final Translations$common$notifications$codes$permission$en permission = Translations$common$notifications$codes$permission$en.internal(_root);
	late final Translations$common$notifications$codes$run$en run = Translations$common$notifications$codes$run$en.internal(_root);
	late final Translations$common$notifications$codes$agent$en agent = Translations$common$notifications$codes$agent$en.internal(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Later'
	String get later => 'Later';

	/// en: 'Copy Command'
	String get copyCommand => 'Copy Command';

	/// en: 'Update Now'
	String get updateNow => 'Update Now';

	/// en: 'Updating...'
	String get updating => 'Updating...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close version upgrade modal'
	String get closeModal => 'Close version upgrade modal';

	/// en: 'Show sidebar'
	String get showSidebar => 'Show sidebar';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Update available'
	String get updateAvailable => 'Update available';

	/// en: 'Close sidebar'
	String get closeSidebar => 'Close sidebar';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable Browser in settings to let agents open monitored browser sessions.'
	String get descDisabled => 'Enable Browser in settings to let agents open monitored browser sessions.';

	/// en: 'Agent browser sessions appear here while an AI task is using Browser.'
	String get descEnabled => 'Agent browser sessions appear here while an AI task is using Browser.';

	/// en: 'Browser is disabled'
	String get titleDisabled => 'Browser is disabled';

	/// en: 'No browser sessions yet'
	String get titleEnabled => 'No browser sessions yet';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Browser action failed'
	String get actionFailed => 'Browser action failed';

	/// en: 'Failed to load Browser'
	String get loadFailed => 'Failed to load Browser';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Use Browser to inspect the checkout flow and report any broken UI states.'
	String get prompt1 => 'Use Browser to inspect the checkout flow and report any broken UI states.';

	/// en: 'Open <url> with Browser, interact with the page, and summarize what changed after each step.'
	String get prompt2 => 'Open <url> with Browser, interact with the page, and summarize what changed after each step.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'd ago'
	String get daysAgo => 'd ago';

	/// en: 'h ago'
	String get hoursAgo => 'h ago';

	/// en: 'Just now'
	String get justNow => 'Just now';

	/// en: 'm ago'
	String get minutesAgo => 'm ago';

	/// en: 'Never'
	String get never => 'Never';

	/// en: 's ago'
	String get secondsAgo => 's ago';

	/// en: 'Unknown'
	String get unknown => 'Unknown';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Disabled'
	String get disabled => 'Disabled';

	/// en: 'Installing'
	String get installing => 'Installing';

	/// en: 'Ready'
	String get ready => 'Ready';

	/// en: 'Setup required'
	String get setupRequired => 'Setup required';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Browse all branches ({{count}})'
	String branches({required Object count}) => 'Browse all branches (${count})';

	/// en: 'Browse all commits ({{count}})'
	String commits({required Object count}) => 'Browse all commits (${count})';

	/// en: 'Browse all files ({{count}})'
	String files({required Object count}) => 'Browse all files (${count})';

	/// en: 'Browse all sessions ({{count}})'
	String sessions({required Object count}) => 'Browse all sessions (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cost is a client-side estimate from published per-token rates; unknown models show “—”.'
	String get costNote => 'Cost is a client-side estimate from published per-token rates; unknown models show “—”.';

	/// en: 'Est. cost'
	String get estCost => 'Est. cost';

	/// en: 'Input / Output'
	String get inputOutput => 'Input / Output';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'N/A'
	String get na => 'N/A';

	/// en: 'Open in split view'
	String get openSplit => 'Open in split view';

	/// en: 'Provider'
	String get provider => 'Provider';

	/// en: 'Select a session…'
	String get selectSession => 'Select a session…';

	/// en: 'Tokens used'
	String get tokensUsed => 'Tokens used';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Actions'
	String get actions => 'Actions';

	/// en: 'Branches'
	String get branches => 'Branches';

	/// en: 'Commits'
	String get commits => 'Commits';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Git'
	String get git => 'Git';

	/// en: 'Navigate'
	String get navigate => 'Navigate';

	/// en: 'Sessions'
	String get sessions => 'Sessions';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Navigate'
	String get navigate => 'Navigate';

	/// en: 'Select'
	String get select => 'Select';

	/// en: 'Toggle palette'
	String get togglePalette => 'Toggle palette';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Compare sessions'
	String get compareSessions => 'Compare sessions';

	/// en: 'Git: Fetch'
	String get gitFetch => 'Git: Fetch';

	/// en: 'Git: Pull'
	String get gitPull => 'Git: Pull';

	/// en: 'Git: Push'
	String get gitPush => 'Git: Push';

	/// en: 'Open settings'
	String get openSettings => 'Open settings';

	/// en: 'Select a project first'
	String get selectProjectFirst => 'Select a project first';

	/// en: 'Settings: {{label}}'
	String settingsEntry({required Object label}) => 'Settings: ${label}';

	/// en: 'Start new chat'
	String get startNewChat => 'Start new chat';

	/// en: 'Switch to: {{name}}'
	String switchTo({required Object name}) => 'Switch to: ${name}';

	/// en: 'Toggle theme'
	String get toggleTheme => 'Toggle theme';

	/// en: 'tokens & cost'
	String get tokensAndCost => 'tokens & cost';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Go to Agent Board'
	String get board => 'Go to Agent Board';

	/// en: 'Go to Chat'
	String get chat => 'Go to Chat';

	/// en: 'Go to Files'
	String get files => 'Go to Files';

	/// en: 'Go to Git'
	String get git => 'Go to Git';

	/// en: 'Go to Source Control'
	String get sourceControl => 'Go to Source Control';

	/// en: 'Go to Tasks'
	String get tasks => 'Go to Tasks';

	/// en: 'Go to Quota & Usage'
	String get usage => 'Go to Quota & Usage';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Actions'
	String get actions => 'Actions';

	/// en: 'Branches'
	String get branches => 'Branches';

	/// en: 'Commits'
	String get commits => 'Commits';

	/// en: 'Compare'
	String get compare => 'Compare';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Sessions'
	String get sessions => 'Sessions';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete branch "{{branch}}"? A normal delete only succeeds when the branch is fully merged. This cannot be undone.'
	String confirmDelete({required Object branch}) => 'Delete branch "${branch}"? A normal delete only succeeds when the branch is fully merged. This cannot be undone.';

	/// en: 'Switch to branch "{{branch}}"? Make sure you have no uncommitted changes.'
	String confirmSwitch({required Object branch}) => 'Switch to branch "${branch}"? Make sure you have no uncommitted changes.';

	/// en: '{{local}} local, {{remote}} remote'
	String countBoth({required Object local, required Object remote}) => '${local} local, ${remote} remote';

	/// en: '{{count}} local'
	String countLocal({required Object count}) => '${count} local';

	/// en: 'current'
	String get current => 'current';

	/// en: 'Delete {{branch}}'
	String deleteTitle({required Object branch}) => 'Delete ${branch}';

	/// en: 'Create a branch to start parallel work.'
	String get emptyDesc => 'Create a branch to start parallel work.';

	/// en: 'Force delete'
	String get forceDelete => 'Force delete';

	/// en: 'Permanently removes the branch even when it contains commits that have not been merged elsewhere.'
	String get forceDeleteDesc => 'Permanently removes the branch even when it contains commits that have not been merged elsewhere.';

	/// en: 'Force delete this unmerged branch'
	String get forceDeleteLabel => 'Force delete this unmerged branch';

	/// en: 'Local'
	String get local => 'Local';

	/// en: 'New branch'
	String get kNew => 'New branch';

	/// en: 'No branches match your search'
	String get noMatch => 'No branches match your search';

	/// en: 'No branches found'
	String get none => 'No branches found';

	/// en: 'remote'
	String get remote => 'remote';

	/// en: 'Switch'
	String get kSwitch => 'Switch';

	/// en: 'Switch to {{branch}}'
	String switchTo({required Object branch}) => 'Switch to ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Confirm'
	String get commit => 'Confirm';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete'
	String get deleteBranch => 'Delete';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Publish'
	String get publish => 'Publish';

	/// en: 'Pull'
	String get pull => 'Pull';

	/// en: 'Push'
	String get push => 'Push';

	/// en: 'Revert Commit'
	String get revertLocalCommit => 'Revert Commit';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Confirm Action'
	String get commit => 'Confirm Action';

	/// en: 'Delete File'
	String get delete => 'Delete File';

	/// en: 'Delete Branch'
	String get deleteBranch => 'Delete Branch';

	/// en: 'Discard Changes'
	String get discard => 'Discard Changes';

	/// en: 'Publish Branch'
	String get publish => 'Publish Branch';

	/// en: 'Confirm Pull'
	String get pull => 'Confirm Pull';

	/// en: 'Confirm Push'
	String get push => 'Confirm Push';

	/// en: 'Revert Local Commit'
	String get revertLocalCommit => 'Revert Local Commit';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create branch failed'
	String get createBranchFailed => 'Create branch failed';

	/// en: 'Failed to create worktree'
	String get createWorktreeFailed => 'Failed to create worktree';

	/// en: 'Delete branch failed'
	String get deleteBranchFailed => 'Delete branch failed';

	/// en: 'Fetch failed'
	String get fetchFailed => 'Fetch failed';

	/// en: 'Failed to initialize repository'
	String get initFailed => 'Failed to initialize repository';

	/// en: 'Failed to create initial commit'
	String get initialCommitFailed => 'Failed to create initial commit';

	/// en: 'Merge failed'
	String get mergeFailed => 'Merge failed';

	/// en: 'Failed to open worktree'
	String get openWorktreeFailed => 'Failed to open worktree';

	/// en: 'Git operation failed'
	String get operationFailed => 'Git operation failed';

	/// en: 'Publish failed'
	String get publishFailed => 'Publish failed';

	/// en: 'Pull failed'
	String get pullFailed => 'Pull failed';

	/// en: 'Push failed'
	String get pushFailed => 'Push failed';

	/// en: 'Failed to remove worktree'
	String get removeWorktreeFailed => 'Failed to remove worktree';

	/// en: 'Stage failed'
	String get stageFailed => 'Stage failed';

	/// en: 'Stage hunks failed'
	String get stageHunksFailed => 'Stage hunks failed';

	/// en: 'Switch branch failed'
	String get switchFailed => 'Switch branch failed';

	/// en: 'Unstage failed'
	String get unstageFailed => 'Unstage failed';

	/// en: 'Unstage hunks failed'
	String get unstageHunksFailed => 'Unstage hunks failed';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added'
	String get added => 'Added';

	/// en: 'Author'
	String get author => 'Author';

	/// en: 'Changed Files'
	String get changedFiles => 'Changed Files';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'No commits found'
	String get empty => 'No commits found';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Removed'
	String get removed => 'Removed';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove the worktree and delete its branch once merged'
	String get cleanupDesc => 'Remove the worktree and delete its branch once merged';

	/// en: 'Clean up after merge'
	String get cleanupLabel => 'Clean up after merge';

	/// en: '{{count}} commit(s)'
	String commitCount({required Object count}) => '${count} commit(s)';

	/// en: 'Merge'
	String get merge => 'Merge';

	/// en: 'Merge branch '{{branch}}''
	String mergeMessage({required Object branch}) => 'Merge branch \'${branch}\'';

	/// en: 'Commit message'
	String get messageLabel => 'Commit message';

	/// en: 'Combine all {{commits}} into a single commit on {{branch}}'
	String squashDesc({required Object commits, required Object branch}) => 'Combine all ${commits} into a single commit on ${branch}';

	/// en: 'Squash commits'
	String get squashLabel => 'Squash commits';

	/// en: 'Squash & Merge'
	String get squashMerge => 'Squash & Merge';

	/// en: 'Squash merge branch '{{branch}}''
	String squashMessage({required Object branch}) => 'Squash merge branch \'${branch}\'';

	/// en: 'Merge Worktree'
	String get title => 'Merge Worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This will create a new branch from the current branch ({{branch}})'
	String fromCurrent({required Object branch}) => 'This will create a new branch from the current branch (${branch})';

	/// en: 'Branch Name'
	String get nameLabel => 'Branch Name';

	/// en: 'Create Branch'
	String get submit => 'Create Branch';

	/// en: 'Create New Branch'
	String get title => 'Create New Branch';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Branch'
	String get branchLabel => 'Branch';

	/// en: 'Create from'
	String get createFrom => 'Create from';

	/// en: 'Check out a branch in its own folder and work on it in parallel.'
	String get description => 'Check out a branch in its own folder and work on it in parallel.';

	/// en: 'Existing branch — it will be checked out as-is.'
	String get existingBranch => 'Existing branch — it will be checked out as-is.';

	/// en: 'Create Worktree'
	String get submit => 'Create Worktree';

	/// en: 'Switch to the worktree after creating it'
	String get switchAfter => 'Switch to the worktree after creating it';

	/// en: 'New Worktree'
	String get title => 'New Worktree';

	/// en: 'Will be created in'
	String get willCreateIn => 'Will be created in';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Initial Commit'
	String get create => 'Create Initial Commit';

	/// en: 'Creating Initial Commit...'
	String get creating => 'Creating Initial Commit...';

	/// en: 'This repository doesn't have any commits yet. Create your first commit to start tracking changes.'
	String get description => 'This repository doesn\'t have any commits yet. Create your first commit to start tracking changes.';

	/// en: 'No commits yet'
	String get title => 'No commits yet';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This project is not a git repository yet. Initialize one to start tracking changes and use source control features.'
	String get description => 'This project is not a git repository yet. Initialize one to start tracking changes and use source control features.';

	/// en: 'Run git init'
	String get init => 'Run git init';

	/// en: 'Initializing repository...'
	String get initializing => 'Initializing repository...';

	/// en: 'No git repository'
	String get title => 'No git repository';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Also delete branch'
	String get alsoDelete => 'Also delete branch';

	/// en: 'Remove the worktree for {{branch}}? Its folder is deleted and the linked project is archived — chat sessions stay recoverable.'
	String description({required Object branch}) => 'Remove the worktree for ${branch}? Its folder is deleted and the linked project is archived — chat sessions stay recoverable.';

	/// en: 'This worktree has {{count}} uncommitted change(s) that will be lost.'
	String dirtyWarning({required Object count}) => 'This worktree has ${count} uncommitted change(s) that will be lost.';

	/// en: 'Discard uncommitted changes'
	String get discardChanges => 'Discard uncommitted changes';

	/// en: 'Remove Worktree'
	String get title => 'Remove Worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added'
	String get added => 'Added';

	/// en: 'Deleted'
	String get deleted => 'Deleted';

	/// en: 'Modified'
	String get modified => 'Modified';

	/// en: 'Untracked'
	String get untracked => 'Untracked';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{count}} change(s)'
	String changes({required Object count}) => '${count} change(s)';

	/// en: '{{count}} worktree(s)'
	String count({required Object count}) => '${count} worktree(s)';

	/// en: 'Create your first worktree'
	String get createFirst => 'Create your first worktree';

	/// en: 'detached'
	String get detached => 'detached';

	/// en: 'detached @ {{sha}}'
	String detachedAt({required Object sha}) => 'detached @ ${sha}';

	/// en: 'detached HEAD'
	String get detachedHead => 'detached HEAD';

	/// en: 'A worktree checks out a branch in its own folder, so you can run separate chat sessions side by side and merge the results back when they're ready.'
	String get emptyDesc => 'A worktree checks out a branch in its own folder, so you can run separate chat sessions side by side and merge the results back when they\'re ready.';

	/// en: 'Work on branches in parallel'
	String get emptyTitle => 'Work on branches in parallel';

	/// en: 'locked'
	String get locked => 'locked';

	/// en: 'main worktree'
	String get mainWorktree => 'main worktree';

	/// en: 'Merge {{branch}} into the base branch'
	String mergeTitle({required Object branch}) => 'Merge ${branch} into the base branch';

	/// en: 'New worktree'
	String get kNew => 'New worktree';

	/// en: 'No worktrees'
	String get none => 'No worktrees';

	/// en: 'Nothing to merge — no commits ahead of the base branch'
	String get nothingToMerge => 'Nothing to merge — no commits ahead of the base branch';

	/// en: 'Open'
	String get open => 'Open';

	/// en: 'Refresh worktrees'
	String get refresh => 'Refresh worktrees';

	/// en: 'Remove worktree for {{branch}}'
	String removeTitle({required Object branch}) => 'Remove worktree for ${branch}';

	/// en: 'Switch to {{branch}}'
	String switchTo({required Object branch}) => 'Switch to ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Changes'
	String get changes => 'Changes';

	/// en: 'Commits'
	String get history => 'Commits';

	/// en: 'Branches'
	String get branches => 'Branches';

	/// en: 'Worktrees'
	String get worktrees => 'Worktrees';
}

// Path: common.gitPanel.worktreeScripts
class Translations$common$gitPanel$worktreeScripts$en {
	Translations$common$gitPanel$worktreeScripts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Worktree scripts'
	String get title => 'Worktree scripts';

	/// en: 'Setup script (runs after create/open)'
	String get setup => 'Setup script (runs after create/open)';

	/// en: 'Run dev server'
	String get run => 'Run dev server';

	/// en: 'Stop dev server'
	String get stop => 'Stop dev server';

	/// en: 'Run script (dev server, on demand)'
	String get runScript => 'Run script (dev server, on demand)';

	/// en: 'Preview port (optional — auto-detected when empty)'
	String get runPort => 'Preview port (optional — auto-detected when empty)';

	/// en: 'Port must be between 1 and 65535'
	String get invalidPort => 'Port must be between 1 and 65535';

	/// en: 'Saved as a project override'
	String get sourceProject => 'Saved as a project override';

	/// en: 'From .ddagent/worktree.json — saving creates a project override'
	String get sourceFile => 'From .ddagent/worktree.json — saving creates a project override';

	/// en: 'Nothing configured yet'
	String get sourceNone => 'Nothing configured yet';

	/// en: 'Saving…'
	String get saving => 'Saving…';

	/// en: 'setup running'
	String get setupRunning => 'setup running';

	/// en: 'setup failed'
	String get setupFailed => 'setup failed';

	/// en: 'running'
	String get running => 'running';

	/// en: 'Open preview'
	String get openPreview => 'Open preview';

	/// en: 'run exited ({{code}})'
	String runExited({required Object code}) => 'run exited (${code})';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Scope'
	String get label => 'Scope';

	/// en: 'User'
	String get user => 'User';

	/// en: 'Project'
	String get project => 'Project';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'System'
	String get system => 'System';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Tool Display'
	String get toolDisplay => 'Tool Display';

	/// en: 'Input Settings'
	String get inputSettings => 'Input Settings';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dragging handle'
	String get dragging => 'Dragging handle';

	/// en: 'Close settings panel'
	String get closePanel => 'Close settings panel';

	/// en: 'Open settings panel'
	String get openPanel => 'Open settings panel';

	/// en: 'Dragging...'
	String get draggingStatus => 'Dragging...';

	/// en: 'Click to toggle, drag to move'
	String get toggleAndMove => 'Click to toggle, drag to move';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close shortcuts panel'
	String get closePanel => 'Close shortcuts panel';

	/// en: 'Open shortcuts panel'
	String get openPanel => 'Open shortcuts panel';
}

// Path: settings.miniOrchestration.enable
class Translations$settings$miniOrchestration$enable$en {
	Translations$settings$miniOrchestration$enable$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable mini orchestration'
	String get label => 'Enable mini orchestration';

	/// en: 'Route Auto (mini) sessions through the two-role engine instead of the full orchestrator.'
	String get description => 'Route Auto (mini) sessions through the two-role engine instead of the full orchestrator.';
}

// Path: settings.miniOrchestration.thinker
class Translations$settings$miniOrchestration$thinker$en {
	Translations$settings$miniOrchestration$thinker$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Thinker (non-flash)'
	String get title => 'Thinker (non-flash)';

	/// en: 'Plans, decides, reviews and writes the final report.'
	String get description => 'Plans, decides, reviews and writes the final report.';
}

// Path: settings.miniOrchestration.worker
class Translations$settings$miniOrchestration$worker$en {
	Translations$settings$miniOrchestration$worker$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Worker (flash)'
	String get title => 'Worker (flash)';

	/// en: 'Executes each planned step.'
	String get description => 'Executes each planned step.';
}

// Path: settings.miniOrchestration.fields
class Translations$settings$miniOrchestration$fields$en {
	Translations$settings$miniOrchestration$fields$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Provider'
	String get provider => 'Provider';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'Model id'
	String get modelPlaceholder => 'Model id';

	/// en: 'Tier'
	String get tier => 'Tier';
}

// Path: settings.miniOrchestration.roles
class Translations$settings$miniOrchestration$roles$en {
	Translations$settings$miniOrchestration$roles$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Per-task model'
	String get title => 'Per-task model';

	/// en: 'Which model (role) handles each task type.'
	String get description => 'Which model (role) handles each task type.';
}

// Path: settings.miniOrchestration.planner
class Translations$settings$miniOrchestration$planner$en {
	Translations$settings$miniOrchestration$planner$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Planner'
	String get title => 'Planner';

	/// en: 'Mode'
	String get mode => 'Mode';

	late final Translations$settings$miniOrchestration$planner$modes$en modes = Translations$settings$miniOrchestration$planner$modes$en.internal(_root);

	/// en: 'Confirm the plan before running'
	String get requireConfirmLabel => 'Confirm the plan before running';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable orchestration'
	String get label => 'Enable orchestration';

	/// en: 'Let the orchestrator pick a model per step instead of running everything on one provider.'
	String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Candidate pool'
	String get title => 'Candidate pool';

	/// en: 'Models the router can pick from, each pinned to a cost tier.'
	String get description => 'Models the router can pick from, each pinned to a cost tier.';

	/// en: 'Add candidate'
	String get add => 'Add candidate';

	/// en: 'No candidates yet — add one to start routing.'
	String get empty => 'No candidates yet — add one to start routing.';

	late final Translations$settings$orchestration$pool$fields$en fields = Translations$settings$orchestration$pool$fields$en.internal(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'Cheap'
	String get cheap => 'Cheap';

	/// en: 'Mid'
	String get mid => 'Mid';

	/// en: 'Premium'
	String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Routing rules'
	String get title => 'Routing rules';

	/// en: 'Ordered candidates per task type — the first available one wins.'
	String get description => 'Ordered candidates per task type — the first available one wins.';

	/// en: 'Add candidate…'
	String get addCandidate => 'Add candidate…';

	/// en: 'No candidates — nothing to route this task type to.'
	String get empty => 'No candidates — nothing to route this task type to.';

	/// en: '(removed)'
	String get missing => '(removed)';

	/// en: 'Remove candidate'
	String get remove => 'Remove candidate';

	late final Translations$settings$orchestration$rules$taskTypes$en taskTypes = Translations$settings$orchestration$rules$taskTypes$en.internal(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Planner'
	String get title => 'Planner';

	/// en: 'How a request is split into routed steps.'
	String get description => 'How a request is split into routed steps.';

	/// en: 'Planning mode'
	String get modeLabel => 'Planning mode';

	late final Translations$settings$orchestration$planner$modes$en modes = Translations$settings$orchestration$planner$modes$en.internal(_root);
	late final Translations$settings$orchestration$planner$modeHints$en modeHints = Translations$settings$orchestration$planner$modeHints$en.internal(_root);

	/// en: 'Planner model'
	String get candidateLabel => 'Planner model';

	/// en: 'Pool candidate used for plan generation and classification calls.'
	String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';

	/// en: 'Select a pool candidate'
	String get candidatePlaceholder => 'Select a pool candidate';

	late final Translations$settings$orchestration$planner$templates$en templates = Translations$settings$orchestration$planner$templates$en.internal(_root);

	/// en: 'Confirm plan before running'
	String get requireConfirm => 'Confirm plan before running';

	/// en: 'Pause after planning so you can edit or disable steps on the plan card.'
	String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';

	/// en: 'Autonomy'
	String get checkpointLabel => 'Autonomy';

	late final Translations$settings$orchestration$planner$checkpointModes$en checkpointModes = Translations$settings$orchestration$planner$checkpointModes$en.internal(_root);
	late final Translations$settings$orchestration$planner$checkpointHints$en checkpointHints = Translations$settings$orchestration$planner$checkpointHints$en.internal(_root);

	/// en: 'Steps between checkpoints (1–50)'
	String get checkpointIntervalLabel => 'Steps between checkpoints (1–50)';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Execution limits'
	String get title => 'Execution limits';

	/// en: 'Guardrails for parallel runs and fix loops.'
	String get description => 'Guardrails for parallel runs and fix loops.';

	/// en: 'Max parallel steps'
	String get maxParallel => 'Max parallel steps';

	/// en: 'How many subtasks may run at once (1–8).'
	String get maxParallelDescription => 'How many subtasks may run at once (1–8).';

	/// en: 'Max fix loops'
	String get maxFixLoops => 'Max fix loops';

	/// en: 'Retries when a step fails verification (0–5).'
	String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';

	/// en: 'When no candidate is available'
	String get onNoCandidate => 'When no candidate is available';

	/// en: 'Ask before falling back, or skip the step.'
	String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';

	late final Translations$settings$orchestration$execution$onNoCandidateOptions$en onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$en.internal(_root);

	/// en: 'Isolated worktree'
	String get useWorktree => 'Isolated worktree';

	/// en: 'Run all delegated steps in one shared git worktree instead of the project directory.'
	String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';

	/// en: 'Max supervisor iterations'
	String get maxSupervisorIterations => 'Max supervisor iterations';

	/// en: 'Cap on supervisor decision rounds in auto mode (1–100); reaching it ends the run with a partial report.'
	String get maxSupervisorIterationsDescription => 'Cap on supervisor decision rounds in auto mode (1–100); reaching it ends the run with a partial report.';

	/// en: 'Max attempts per step'
	String get maxAttempts => 'Max attempts per step';

	/// en: 'Total attempt budget for one step across lanes and retries (1–50).'
	String get maxAttemptsDescription => 'Total attempt budget for one step across lanes and retries (1–50).';

	/// en: 'Step timeout (ms)'
	String get stepTimeoutMs => 'Step timeout (ms)';

	/// en: 'Per-attempt child-run timeout in milliseconds; 0 disables.'
	String get stepTimeoutMsDescription => 'Per-attempt child-run timeout in milliseconds; 0 disables.';

	/// en: 'Run timeout (ms)'
	String get runTimeoutMs => 'Run timeout (ms)';

	/// en: 'Global plan-run timeout in milliseconds; 0 disables.'
	String get runTimeoutMsDescription => 'Global plan-run timeout in milliseconds; 0 disables.';

	/// en: 'Retry backoff base (ms)'
	String get retryBackoffBaseMs => 'Retry backoff base (ms)';

	/// en: 'Base of the exponential backoff between same-lane retries (full jitter).'
	String get retryBackoffBaseMsDescription => 'Base of the exponential backoff between same-lane retries (full jitter).';

	/// en: 'Retry budget per failure class'
	String get retryBudgetTitle => 'Retry budget per failure class';

	/// en: 'Same-lane retries before failover/cooldown (0–5).'
	String get retryBudgetDescription => 'Same-lane retries before failover/cooldown (0–5).';

	late final Translations$settings$orchestration$execution$retryClasses$en retryClasses = Translations$settings$orchestration$execution$retryClasses$en.internal(_root);
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unsaved changes'
	String get unsaved => 'Unsaved changes';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Saving…'
	String get saving => 'Saving…';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Save failed'
	String get error => 'Save failed';

	/// en: 'Add at least one candidate before saving.'
	String get emptyPool => 'Add at least one candidate before saving.';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notify this browser'
	String get title => 'Notify this browser';

	/// en: 'Enable notifications'
	String get enable => 'Enable notifications';

	/// en: 'Disable notifications'
	String get disable => 'Disable notifications';

	/// en: 'Notifications are enabled for this browser'
	String get enabled => 'Notifications are enabled for this browser';

	/// en: 'Updating...'
	String get loading => 'Updating...';

	/// en: 'Push notifications are not supported in this browser.'
	String get unsupported => 'Push notifications are not supported in this browser.';

	/// en: 'Push notifications are blocked. Please allow them in your browser settings.'
	String get denied => 'Push notifications are blocked. Please allow them in your browser settings.';

	/// en: 'On iPhone/iPad, notifications only work after adding ddagent to the home screen (Share → Add to Home Screen) and enabling them from that installed app.'
	String get iosHint => 'On iPhone/iPad, notifications only work after adding ddagent to the home screen (Share → Add to Home Screen) and enabling them from that installed app.';

	/// en: 'Send test notification'
	String get test => 'Send test notification';

	/// en: 'No device is subscribed. Tap "Enable" on the phone first.'
	String get testNoSubscription => 'No device is subscribed. Tap "Enable" on the phone first.';

	/// en: 'Sent to {{count}} device(s). If nothing appeared on the phone, add ddagent to the home screen (iOS requires this).'
	String testSuccess({required Object count}) => 'Sent to ${count} device(s). If nothing appeared on the phone, add ddagent to the home screen (iOS requires this).';

	/// en: 'No device was reachable. Make sure the app is running and notifications are enabled.'
	String get testNotDelivered => 'No device was reachable. Make sure the app is running and notifications are enabled.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notify this device'
	String get title => 'Notify this device';

	/// en: 'Notifications are enabled for this device'
	String get enabled => 'Notifications are enabled for this device';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notify this desktop app'
	String get title => 'Notify this desktop app';

	/// en: 'Enable notifications'
	String get enable => 'Enable notifications';

	/// en: 'Disable notifications'
	String get disable => 'Disable notifications';

	/// en: 'Notifications are enabled for this desktop app'
	String get enabled => 'Notifications are enabled for this desktop app';

	/// en: 'Desktop notifications are not supported on this system.'
	String get unsupported => 'Desktop notifications are not supported on this system.';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sound'
	String get title => 'Sound';

	/// en: 'Play a short tone when a chat run finishes or needs tool approval.'
	String get description => 'Play a short tone when a chat run finishes or needs tool approval.';

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Test sound'
	String get test => 'Test sound';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Event Types'
	String get title => 'Event Types';

	/// en: 'Action required'
	String get actionRequired => 'Action required';

	/// en: 'Run stopped'
	String get stop => 'Run stopped';

	/// en: 'Run failed'
	String get error => 'Run failed';
}

// Path: settings.notifications.messaging
class Translations$settings$notifications$messaging$en {
	Translations$settings$notifications$messaging$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Messenger approvals'
	String get title => 'Messenger approvals';

	/// en: 'Approve or deny agent permission requests from Telegram, and get run notifications on Discord.'
	String get description => 'Approve or deny agent permission requests from Telegram, and get run notifications on Discord.';

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Test'
	String get test => 'Test';

	/// en: 'Pair'
	String get pair => 'Pair';

	/// en: 'Bot token from @BotFather (123456:ABC…)'
	String get telegramToken => 'Bot token from @BotFather (123456:ABC…)';

	/// en: 'Send any message to your bot, then pair the chat below.'
	String get telegramHint => 'Send any message to your bot, then pair the chat below.';

	/// en: 'https://discord.com/api/webhooks/…'
	String get discordWebhook => 'https://discord.com/api/webhooks/…';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Telegram'
	String get telegram => 'Telegram';

	/// en: 'Discord'
	String get discord => 'Discord';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dark Mode'
	String get label => 'Dark Mode';

	/// en: 'Toggle between light and dark themes'
	String get description => 'Toggle between light and dark themes';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Code Editor'
	String get title => 'Code Editor';

	late final Translations$settings$appearanceSettings$codeEditor$theme$en theme = Translations$settings$appearanceSettings$codeEditor$theme$en.internal(_root);
	late final Translations$settings$appearanceSettings$codeEditor$wordWrap$en wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$en.internal(_root);
	late final Translations$settings$appearanceSettings$codeEditor$showMinimap$en showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$en.internal(_root);
	late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$en lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$en.internal(_root);
	late final Translations$settings$appearanceSettings$codeEditor$fontSize$en fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$en.internal(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Terminal'
	String get title => 'Terminal';

	late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en.internal(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add MCP Server'
	String get add => 'Add MCP Server';

	/// en: 'Edit MCP Server'
	String get edit => 'Edit MCP Server';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Form Input'
	String get form => 'Form Input';

	/// en: 'JSON Import'
	String get json => 'JSON Import';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Scope'
	String get label => 'Scope';

	/// en: 'User (Global)'
	String get userGlobal => 'User (Global)';

	/// en: 'Project (Local)'
	String get projectLocal => 'Project (Local)';

	/// en: 'User scope: Available across all projects on your machine'
	String get userDescription => 'User scope: Available across all projects on your machine';

	/// en: 'Local scope: Only available in the selected project'
	String get projectDescription => 'Local scope: Only available in the selected project';

	/// en: 'Scope cannot be changed when editing an existing server'
	String get cannotChange => 'Scope cannot be changed when editing an existing server';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Server Name'
	String get serverName => 'Server Name';

	/// en: 'Transport Type'
	String get transportType => 'Transport Type';

	/// en: 'Command'
	String get command => 'Command';

	/// en: 'Arguments (one per line)'
	String get arguments => 'Arguments (one per line)';

	/// en: 'JSON Configuration'
	String get jsonConfig => 'JSON Configuration';

	/// en: 'URL'
	String get url => 'URL';

	/// en: 'Environment Variables (KEY=value, one per line)'
	String get envVars => 'Environment Variables (KEY=value, one per line)';

	/// en: 'Headers (KEY=value, one per line)'
	String get headers => 'Headers (KEY=value, one per line)';

	/// en: 'Select a project...'
	String get selectProject => 'Select a project...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'my-server'
	String get serverName => 'my-server';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Missing required field: type'
	String get missingType => 'Missing required field: type';

	/// en: 'stdio type requires a command field'
	String get stdioRequiresCommand => 'stdio type requires a command field';

	/// en: '{{type}} type requires a url field'
	String httpRequiresUrl({required Object type}) => '${type} type requires a url field';

	/// en: 'Invalid JSON format'
	String get invalidJson => 'Invalid JSON format';

	/// en: 'Paste your MCP server configuration in JSON format. Example formats:'
	String get jsonHelp => 'Paste your MCP server configuration in JSON format. Example formats:';

	/// en: '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}'
	String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';

	/// en: '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}'
	String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'Add Server'
	String get addServer => 'Add Server';

	/// en: 'Update Server'
	String get updateServer => 'Update Server';
}

// Path: settings.git.name
class Translations$settings$git$name$en {
	Translations$settings$git$name$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Git Name'
	String get label => 'Git Name';

	/// en: 'Your name for git commits'
	String get help => 'Your name for git commits';

	/// en: 'John Doe'
	String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$en {
	Translations$settings$git$email$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Git Email'
	String get label => 'Git Email';

	/// en: 'Your email for git commits'
	String get help => 'Your email for git commits';

	/// en: 'john@example.com'
	String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$en {
	Translations$settings$git$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save Configuration'
	String get save => 'Save Configuration';

	/// en: 'Saving...'
	String get saving => 'Saving...';
}

// Path: settings.git.status
class Translations$settings$git$status$en {
	Translations$settings$git$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Saved successfully'
	String get success => 'Saved successfully';

	/// en: 'Failed to save'
	String get error => 'Failed to save';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '⚠️ Save Your API Key'
	String get alertTitle => '⚠️ Save Your API Key';

	/// en: 'This is the only time you'll see this key. Store it securely.'
	String get alertMessage => 'This is the only time you\'ll see this key. Store it securely.';

	/// en: 'I've saved it'
	String get iveSavedIt => 'I\'ve saved it';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'API Key Name (e.g., Production Server)'
	String get placeholder => 'API Key Name (e.g., Production Server)';

	/// en: 'Create'
	String get createButton => 'Create';

	/// en: 'Cancel'
	String get cancelButton => 'Cancel';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Created:'
	String get created => 'Created:';

	/// en: 'Last used:'
	String get lastUsed => 'Last used:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Inactive'
	String get inactive => 'Inactive';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'GitHub Tokens'
	String get title => 'GitHub Tokens';

	/// en: 'Add GitHub Personal Access Tokens to clone private repositories via the external API.'
	String get description => 'Add GitHub Personal Access Tokens to clone private repositories via the external API.';

	/// en: 'Add GitHub Personal Access Tokens to clone private repositories. You can also pass tokens directly in API requests without storing them.'
	String get descriptionAlt => 'Add GitHub Personal Access Tokens to clone private repositories. You can also pass tokens directly in API requests without storing them.';

	/// en: 'Add Token'
	String get addButton => 'Add Token';

	late final Translations$settings$apiKeys$github$form$en form = Translations$settings$apiKeys$github$form$en.internal(_root);

	/// en: 'No GitHub tokens added yet.'
	String get empty => 'No GitHub tokens added yet.';

	/// en: 'Added:'
	String get added => 'Added:';

	/// en: 'Are you sure you want to delete this GitHub token?'
	String get confirmDelete => 'Are you sure you want to delete this GitHub token?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'External API Documentation'
	String get title => 'External API Documentation';

	/// en: 'Learn how to use the external API to trigger Claude/Cursor sessions from your applications.'
	String get description => 'Learn how to use the external API to trigger Claude/Cursor sessions from your applications.';

	/// en: 'View API Documentation →'
	String get viewLink => 'View API Documentation →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update available: v{{version}}'
	String updateAvailable({required Object version}) => 'Update available: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TaskMaster AI CLI Not Installed'
	String get title => 'TaskMaster AI CLI Not Installed';

	/// en: 'TaskMaster CLI is required to use task management features. Install it to get started:'
	String get description => 'TaskMaster CLI is required to use task management features. Install it to get started:';

	/// en: 'npm install -g task-master-ai'
	String get installCommand => 'npm install -g task-master-ai';

	/// en: 'View on GitHub'
	String get viewOnGitHub => 'View on GitHub';

	/// en: 'After installation:'
	String get afterInstallation => 'After installation:';

	late final Translations$settings$tasks$notInstalled$steps$en steps = Translations$settings$tasks$notInstalled$steps$en.internal(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable TaskMaster Integration'
	String get enableLabel => 'Enable TaskMaster Integration';

	/// en: 'Show TaskMaster tasks, banners, and sidebar indicators across the interface'
	String get enableDescription => 'Show TaskMaster tasks, banners, and sidebar indicators across the interface';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checking...'
	String get checking => 'Checking...';

	/// en: 'Connected'
	String get connected => 'Connected';

	/// en: 'Not connected'
	String get notConnected => 'Not connected';

	/// en: 'Disconnected'
	String get disconnected => 'Disconnected';

	/// en: 'Checking authentication status...'
	String get checkingAuth => 'Checking authentication status...';

	/// en: 'Logged in as {{email}}'
	String loggedInAs({required Object email}) => 'Logged in as ${email}';

	/// en: '{{provider}} account'
	String providerAccount({required Object provider}) => '${provider} account';

	/// en: 'authenticated user'
	String get authenticatedUser => 'authenticated user';
}

// Path: settings.agents.install
class Translations$settings$agents$install$en {
	Translations$settings$agents$install$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{agent}} CLI is not installed'
	String title({required Object agent}) => '${agent} CLI is not installed';

	/// en: 'Install the {{agent}} CLI to sign in and run sessions.'
	String description({required Object agent}) => 'Install the ${agent} CLI to sign in and run sessions.';

	/// en: 'Install'
	String get button => 'Install';

	/// en: 'Installing…'
	String get installing => 'Installing…';

	/// en: 'Copy command'
	String get copyCommand => 'Copy command';

	/// en: 'Documentation'
	String get docs => 'Documentation';

	/// en: '{{agent}} CLI installed'
	String success({required Object agent}) => '${agent} CLI installed';

	/// en: 'Installation failed — check the terminal output'
	String get failed => 'Installation failed — check the terminal output';
}

// Path: settings.agents.account
class Translations$settings$agents$account$en {
	Translations$settings$agents$account$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$agents$account$claude$en claude = Translations$settings$agents$account$claude$en.internal(_root);
	late final Translations$settings$agents$account$cursor$en cursor = Translations$settings$agents$account$cursor$en.internal(_root);
	late final Translations$settings$agents$account$codex$en codex = Translations$settings$agents$account$codex$en.internal(_root);
	late final Translations$settings$agents$account$opencode$en opencode = Translations$settings$agents$account$opencode$en.internal(_root);
	late final Translations$settings$agents$account$commandcode$en commandcode = Translations$settings$agents$account$commandcode$en.internal(_root);
	late final Translations$settings$agents$account$antigravity$en antigravity = Translations$settings$agents$account$antigravity$en.internal(_root);
	late final Translations$settings$agents$account$devin$en devin = Translations$settings$agents$account$devin$en.internal(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$en {
	Translations$settings$agents$login$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get title => 'Login';

	/// en: 'Re-authenticate'
	String get reAuthenticate => 'Re-authenticate';

	/// en: 'Sign in to your {{agent}} account to enable AI features'
	String description({required Object agent}) => 'Sign in to your ${agent} account to enable AI features';

	/// en: 'Sign in with a different account or refresh credentials'
	String get reAuthDescription => 'Sign in with a different account or refresh credentials';

	/// en: 'Login'
	String get button => 'Login';

	/// en: 'Re-login'
	String get reLoginButton => 'Re-login';
}

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Named accounts'
	String get title => 'Named accounts';

	/// en: 'Additional credential sets. A session pinned to an account launches the CLI with its isolated config directory. Log in by running the provider CLI once with the shown env vars.'
	String get description => 'Additional credential sets. A session pinned to an account launches the CLI with its isolated config directory. Log in by running the provider CLI once with the shown env vars.';

	/// en: 'Loading accounts…'
	String get loading => 'Loading accounts…';

	/// en: 'Default'
	String get kDefault => 'Default';

	/// en: '{{tokens}} tokens'
	String usage({required Object tokens}) => '${tokens} tokens';

	/// en: 'Usage'
	String get usageButton => 'Usage';

	/// en: 'Show token usage'
	String get showUsage => 'Show token usage';

	/// en: 'Make default'
	String get makeDefault => 'Make default';

	/// en: 'Remove account'
	String get remove => 'Remove account';

	/// en: 'Account label (e.g. Work)'
	String get newLabel => 'Account label (e.g. Work)';

	/// en: 'Add account'
	String get add => 'Add account';
}

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip permission prompts (use with caution)'
	String get label => 'Skip permission prompts (use with caution)';

	/// en: 'Equivalent to --dangerously-skip-permissions flag'
	String get claudeDescription => 'Equivalent to --dangerously-skip-permissions flag';

	/// en: 'Equivalent to -f flag in Cursor CLI'
	String get cursorDescription => 'Equivalent to -f flag in Cursor CLI';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Allowed Tools'
	String get title => 'Allowed Tools';

	/// en: 'Tools that are automatically allowed without prompting for permission'
	String get description => 'Tools that are automatically allowed without prompting for permission';

	/// en: 'e.g., "Bash(git log:*)" or "Write"'
	String get placeholder => 'e.g., "Bash(git log:*)" or "Write"';

	/// en: 'Quick add common tools:'
	String get quickAdd => 'Quick add common tools:';

	/// en: 'No allowed tools configured'
	String get empty => 'No allowed tools configured';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Blocked Tools'
	String get title => 'Blocked Tools';

	/// en: 'Tools that are automatically blocked without prompting for permission'
	String get description => 'Tools that are automatically blocked without prompting for permission';

	/// en: 'e.g., "Bash(rm:*)"'
	String get placeholder => 'e.g., "Bash(rm:*)"';

	/// en: 'No blocked tools configured'
	String get empty => 'No blocked tools configured';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Allowed Shell Commands'
	String get title => 'Allowed Shell Commands';

	/// en: 'Shell commands that are automatically allowed without prompting'
	String get description => 'Shell commands that are automatically allowed without prompting';

	/// en: 'e.g., "Shell(ls)" or "Shell(git status)"'
	String get placeholder => 'e.g., "Shell(ls)" or "Shell(git status)"';

	/// en: 'Quick add common commands:'
	String get quickAdd => 'Quick add common commands:';

	/// en: 'No allowed commands configured'
	String get empty => 'No allowed commands configured';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Blocked Shell Commands'
	String get title => 'Blocked Shell Commands';

	/// en: 'Shell commands that are automatically blocked'
	String get description => 'Shell commands that are automatically blocked';

	/// en: 'e.g., "Shell(rm -rf)" or "Shell(sudo)"'
	String get placeholder => 'e.g., "Shell(rm -rf)" or "Shell(sudo)"';

	/// en: 'No blocked commands configured'
	String get empty => 'No blocked commands configured';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tool Pattern Examples:'
	String get title => 'Tool Pattern Examples:';

	/// en: '- Allow all git log commands'
	String get bashGitLog => '- Allow all git log commands';

	/// en: '- Allow all git diff commands'
	String get bashGitDiff => '- Allow all git diff commands';

	/// en: '- Allow all Write tool usage'
	String get write => '- Allow all Write tool usage';

	/// en: '- Block all rm commands (dangerous)'
	String get bashRm => '- Block all rm commands (dangerous)';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shell Command Examples:'
	String get title => 'Shell Command Examples:';

	/// en: '- Allow ls command'
	String get ls => '- Allow ls command';

	/// en: '- Allow git status'
	String get gitStatus => '- Allow git status';

	/// en: '- Allow npm install'
	String get npmInstall => '- Allow npm install';

	/// en: '- Block recursive delete'
	String get rmRf => '- Block recursive delete';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permission Mode'
	String get permissionMode => 'Permission Mode';

	/// en: 'Controls how Codex handles file modifications and command execution'
	String get description => 'Controls how Codex handles file modifications and command execution';

	late final Translations$settings$permissions$codex$modes$en modes = Translations$settings$permissions$codex$modes$en.internal(_root);

	/// en: 'Technical details'
	String get technicalDetails => 'Technical details';

	late final Translations$settings$permissions$codex$technicalInfo$en technicalInfo = Translations$settings$permissions$codex$technicalInfo$en.internal(_root);
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permission Mode'
	String get title => 'Permission Mode';

	/// en: 'Default permission mode for new {{provider}} sessions. You can still override it for a single session with the mode button in the chat composer.'
	String description({required Object provider}) => 'Default permission mode for new ${provider} sessions. You can still override it for a single session with the mode button in the chat composer.';

	late final Translations$settings$permissions$permissionMode$modes$en modes = Translations$settings$permissions$permissionMode$modes$en.internal(_root);
}

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add'
	String get add => 'Add';
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Model Context Protocol servers provide additional tools and data sources to Claude'
	String get claude => 'Model Context Protocol servers provide additional tools and data sources to Claude';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to Cursor'
	String get cursor => 'Model Context Protocol servers provide additional tools and data sources to Cursor';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to Codex'
	String get codex => 'Model Context Protocol servers provide additional tools and data sources to Codex';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to OpenCode'
	String get opencode => 'Model Context Protocol servers provide additional tools and data sources to OpenCode';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to Command Code'
	String get commandcode => 'Model Context Protocol servers provide additional tools and data sources to Command Code';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to Antigravity'
	String get antigravity => 'Model Context Protocol servers provide additional tools and data sources to Antigravity';

	/// en: 'Model Context Protocol servers provide additional tools and data sources to Devin'
	String get devin => 'Model Context Protocol servers provide additional tools and data sources to Devin';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'local'
	String get local => 'local';

	/// en: 'user'
	String get user => 'user';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Command'
	String get command => 'Command';

	/// en: 'URL'
	String get url => 'URL';

	/// en: 'Args'
	String get args => 'Args';

	/// en: 'Environment'
	String get environment => 'Environment';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tools'
	String get title => 'Tools';

	/// en: '({{count}}):'
	String count({required Object count}) => '(${count}):';

	/// en: '+{{count}} more'
	String more({required Object count}) => '+${count} more';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit server'
	String get edit => 'Edit server';

	/// en: 'Delete server'
	String get delete => 'Delete server';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Managed'
	String get badge => 'Managed';

	/// en: 'Managed by ddagent.'
	String get hint => 'Managed by ddagent.';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About Codex MCP'
	String get title => 'About Codex MCP';

	/// en: 'Codex supports stdio-based MCP servers. You can add servers that extend Codex's capabilities with additional tools and resources.'
	String get description => 'Codex supports stdio-based MCP servers. You can add servers that extend Codex\'s capabilities with additional tools and resources.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '"{{serverName}}" will be removed from the provider configuration.'
	String description({required Object serverName}) => '"${serverName}" will be removed from the provider configuration.';

	/// en: 'Delete MCP server?'
	String get title => 'Delete MCP server?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Control Center'
	String get tab => 'Control Center';

	/// en: 'Control Center'
	String get title => 'Control Center';

	/// en: 'Alert thresholds, routing policy and the accounts polled for quota.'
	String get description => 'Alert thresholds, routing policy and the accounts polled for quota.';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Alerts'
	String get alertsSection => 'Alerts';

	/// en: 'Warn before a limit is actually exhausted, not only at 100%.'
	String get alertsSectionHint => 'Warn before a limit is actually exhausted, not only at 100%.';

	/// en: 'Predicted limit alerts'
	String get alertsEnabled => 'Predicted limit alerts';

	/// en: 'Surface pace-based projections on the overview and account cards.'
	String get alertsEnabledHint => 'Surface pace-based projections on the overview and account cards.';

	/// en: 'Watch threshold (%)'
	String get watchThreshold => 'Watch threshold (%)';

	/// en: 'Accounts at or above this reading are counted as at risk.'
	String get watchThresholdHint => 'Accounts at or above this reading are counted as at risk.';

	/// en: 'Danger threshold (%)'
	String get dangerThreshold => 'Danger threshold (%)';

	/// en: 'Readings at or above this value are shown in red.'
	String get dangerThresholdHint => 'Readings at or above this value are shown in red.';

	/// en: 'Routing'
	String get routingSection => 'Routing';

	/// en: 'How the panel may move work to the account with the most headroom.'
	String get routingSectionHint => 'How the panel may move work to the account with the most headroom.';

	late final Translations$settings$quota$settings$routing$en routing = Translations$settings$quota$settings$routing$en.internal(_root);

	/// en: 'Switching an account changes cost and model quality, so it always requires a decision.'
	String get routingNote => 'Switching an account changes cost and model quality, so it always requires a decision.';

	/// en: 'Polled accounts'
	String get accountsSection => 'Polled accounts';

	/// en: 'Credentials are read from each tool; the panel never sends them anywhere else.'
	String get accountsSectionHint => 'Credentials are read from each tool; the panel never sends them anywhere else.';

	/// en: 'Data sources'
	String get sourcesSection => 'Data sources';

	/// en: 'Where usage and cost figures come from.'
	String get sourcesSectionHint => 'Where usage and cost figures come from.';

	/// en: 'Token and cost log store'
	String get logSources => 'Token and cost log store';

	/// en: 'Read-only aggregate store shared with the tokboard collector.'
	String get logSourcesHint => 'Read-only aggregate store shared with the tokboard collector.';

	/// en: 'Read-only'
	String get readOnly => 'Read-only';

	/// en: 'Quota polling'
	String get quotaConsent => 'Quota polling';

	/// en: 'Reads provider quota endpoints with locally stored credentials.'
	String get quotaConsentHint => 'Reads provider quota endpoints with locally stored credentials.';

	/// en: 'Local only'
	String get localOnly => 'Local only';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No accounts detected yet.'
	String get description => 'No accounts detected yet.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'cached'
	String get cached => 'cached';

	/// en: 'error'
	String get error => 'error';

	/// en: 'estimate'
	String get estimate => 'estimate';

	/// en: 'live'
	String get live => 'live';

	/// en: 'unknown'
	String get unknown => 'unknown';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to install browser runtime'
	String get installRuntime => 'Failed to install browser runtime';

	/// en: 'Failed to load Browser settings'
	String get loadSettings => 'Failed to load Browser settings';

	/// en: 'Failed to load Browser status'
	String get loadStatus => 'Failed to load Browser status';

	/// en: 'Failed to save Browser settings'
	String get saveSettings => 'Failed to save Browser settings';
}

// Path: settings.about.pro
class Translations$settings$about$pro$en {
	Translations$settings$about$pro$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sync Settings'
	String get syncSettings => 'Sync Settings';

	/// en: 'Team Management'
	String get teamManagement => 'Team Management';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'AI-Powered Task Management: Break complex projects into manageable subtasks'
	String get aiPowered => 'AI-Powered Task Management: Break complex projects into manageable subtasks';

	/// en: 'PRD Templates: Generate tasks from Product Requirements Documents'
	String get prdTemplates => 'PRD Templates: Generate tasks from Product Requirements Documents';

	/// en: 'Dependency Tracking: Understand task relationships and execution order'
	String get dependencyTracking => 'Dependency Tracking: Understand task relationships and execution order';

	/// en: 'Progress Visualization: Kanban boards and detailed task analytics'
	String get progressVisualization => 'Progress Visualization: Kanban boards and detailed task analytics';

	/// en: 'CLI Integration: Use taskmaster commands for advanced workflows'
	String get cliIntegration => 'CLI Integration: Use taskmaster commands for advanced workflows';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$tasks$gettingStarted$steps$createPRD$en createPRD = Translations$tasks$gettingStarted$steps$createPRD$en.internal(_root);
	late final Translations$tasks$gettingStarted$steps$generateTasks$en generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$en.internal(_root);
	late final Translations$tasks$gettingStarted$steps$analyzeTasks$en analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$en.internal(_root);
	late final Translations$tasks$gettingStarted$steps$startBuilding$en startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$en.internal(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '💬 Example: "I've just initialized a new project with Claude Task Master. I have a PRD at .taskmaster/docs/prd.txt. Can you help me parse it and set up the initial tasks?"'
	String get parsePRD => '💬 Example:\n"I\'ve just initialized a new project with Claude Task Master. I have a PRD at .taskmaster/docs/prd.txt. Can you help me parse it and set up the initial tasks?"';

	/// en: '💬 Example: "Task 5 seems complex. Can you break it down into subtasks?"'
	String get expandTask => '💬 Example:\n"Task 5 seems complex. Can you break it down into subtasks?"';

	/// en: '💬 Example: "Please add a new task to implement user profile image uploads using Cloudinary, research the best approach."'
	String get addTask => '💬 Example:\n"Please add a new task to implement user profile image uploads using Cloudinary, research the best approach."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '💡 Pro Tips'
	String get title => '💡 Pro Tips';

	/// en: 'Use the search bar to quickly find specific tasks'
	String get search => 'Use the search bar to quickly find specific tasks';

	/// en: 'Switch between Kanban, List, and Grid views using the view toggles'
	String get views => 'Switch between Kanban, List, and Grid views using the view toggles';

	/// en: 'Use filters to focus on specific task statuses or priorities'
	String get filters => 'Use filters to focus on specific task statuses or priorities';

	/// en: 'Click on any task to view detailed information and manage subtasks'
	String get details => 'Click on any task to view detailed information and manage subtasks';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '📚 Learn More'
	String get title => '📚 Learn More';

	/// en: 'TaskMaster AI is an advanced task management system built for developers. Get documentation, examples, and contribute to the project.'
	String get description => 'TaskMaster AI is an advanced task management system built for developers. Get documentation, examples, and contribute to the project.';

	/// en: 'View on GitHub'
	String get githubButton => 'View on GitHub';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No cards yet'
	String get title => 'No cards yet';

	/// en: 'Add a card, describe the task, then drag it to Ready to let an agent start working on it.'
	String get description => 'Add a card, describe the task, then drag it to Ready to let an agent start working on it.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Backlog'
	String get backlog => 'Backlog';

	/// en: 'Ready to start'
	String get ready => 'Ready to start';

	/// en: 'Working'
	String get working => 'Working';

	/// en: 'Needs your decision'
	String get needsDecision => 'Needs your decision';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Archived'
	String get archived => 'Archived';
}

// Path: tasks.board.card
class Translations$tasks$board$card$en {
	Translations$tasks$board$card$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Running'
	String get running => 'Running';

	/// en: 'Abort'
	String get abort => 'Abort';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Open session'
	String get openSession => 'Open session';

	/// en: 'Pull request'
	String get pullRequest => 'Pull request';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Move to'
	String get moveTo => 'Move to';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New card'
	String get createTitle => 'New card';

	/// en: 'Edit card'
	String get editTitle => 'Edit card';

	/// en: 'Title'
	String get titleLabel => 'Title';

	/// en: 'What should the agent do?'
	String get titlePlaceholder => 'What should the agent do?';

	/// en: 'Description'
	String get descriptionLabel => 'Description';

	/// en: 'Add context, acceptance criteria, links...'
	String get descriptionPlaceholder => 'Add context, acceptance criteria, links...';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agent'
	String get provider => 'Agent';

	/// en: 'Any agent'
	String get anyProvider => 'Any agent';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'Default model'
	String get defaultModel => 'Default model';

	/// en: 'Reasoning'
	String get effort => 'Reasoning';

	/// en: 'Default'
	String get defaultEffort => 'Default';

	/// en: 'Search models…'
	String get searchModel => 'Search models…';

	/// en: 'No matching models'
	String get noModels => 'No matching models';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '"{{cardTitle}}" will be permanently deleted.'
	String description({required Object cardTitle}) => '"${cardTitle}" will be permanently deleted.';

	/// en: 'Delete card?'
	String get title => 'Delete card?';
}

// Path: tasks.board.assignee
class Translations$tasks$board$assignee$en {
	Translations$tasks$board$assignee$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Assignee'
	String get label => 'Assignee';

	/// en: 'All assignees'
	String get all => 'All assignees';

	/// en: 'Unassigned'
	String get unassigned => 'Unassigned';
}

// Path: tasks.board.presence
class Translations$tasks$board$presence$en {
	Translations$tasks$board$presence$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{{count}} online'
	String online({required Object count}) => '${count} online';
}

// Path: tasks.board.activity
class Translations$tasks$board$activity$en {
	Translations$tasks$board$activity$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Activity'
	String get title => 'Activity';

	/// en: 'No activity yet'
	String get empty => 'No activity yet';
}

// Path: tasks.board.comments
class Translations$tasks$board$comments$en {
	Translations$tasks$board$comments$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Comments'
	String get label => 'Comments';

	/// en: 'Write a comment…'
	String get placeholder => 'Write a comment…';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'Someone'
	String get unknownAuthor => 'Someone';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cwd'
	String get cwd => 'Cwd';

	/// en: 'Env Vars'
	String get envVars => 'Env Vars';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'User (All Providers)'
	String get userAllProviders => 'User (All Providers)';

	/// en: 'Claude Local'
	String get claudeLocal => 'Claude Local';

	/// en: 'Project (All Providers)'
	String get projectAllProviders => 'Project (All Providers)';

	late final Translations$mcp$form$scope$description$en description = Translations$mcp$form$scope$description$en.internal(_root);
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Working Directory'
	String get workingDirectory => 'Working Directory';

	/// en: 'Environment Variable Names'
	String get envVarNames => 'Environment Variable Names';

	/// en: 'Bearer Token Environment Variable'
	String get bearerTokenEnvVar => 'Bearer Token Environment Variable';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add MCP Server supports only stdio and http across all providers, not {{type}}.'
	String unsupportedGlobal({required Object type}) => 'Add MCP Server supports only stdio and http across all providers, not ${type}.';

	/// en: '{{provider}} does not support {{type}} MCP servers'
	String unsupportedProvider({required Object provider, required Object type}) => '${provider} does not support ${type} MCP servers';
}

// Path: chat.orchestrator.decision.action
class Translations$chat$orchestrator$decision$action$en {
	Translations$chat$orchestrator$decision$action$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'delegating'
	String get kContinue => 'delegating';

	/// en: 'finished'
	String get done => 'finished';

	/// en: 'no decision'
	String get invalid => 'no decision';
}

// Path: chat.orchestrator.decision.outcome
class Translations$chat$orchestrator$decision$outcome$en {
	Translations$chat$orchestrator$decision$outcome$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'success'
	String get success => 'success';

	/// en: 'partial'
	String get partial => 'partial';

	/// en: 'failed'
	String get failed => 'failed';
}

// Path: chat.orchestrator.delegation.status
class Translations$chat$orchestrator$delegation$status$en {
	Translations$chat$orchestrator$delegation$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'queued'
	String get queued => 'queued';

	/// en: 'running'
	String get running => 'running';

	/// en: 'done'
	String get done => 'done';

	/// en: 'failed'
	String get failed => 'failed';

	/// en: 'aborted'
	String get aborted => 'aborted';

	/// en: 'skipped'
	String get skipped => 'skipped';

	/// en: 'waiting for decision'
	String get awaitingDecision => 'waiting for decision';
}

// Path: chat.orchestrator.taskmaster.status
class Translations$chat$orchestrator$taskmaster$status$en {
	Translations$chat$orchestrator$taskmaster$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'running'
	String get started => 'running';

	/// en: 'done'
	String get done => 'done';

	/// en: 'complete'
	String get complete => 'complete';

	/// en: 'failed'
	String get failed => 'failed';

	/// en: 'paused'
	String get paused => 'paused';

	/// en: 'blocked'
	String get blocked => 'blocked';

	/// en: 'aborted'
	String get aborted => 'aborted';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Manual — recommendation only'
	String get manual => 'Manual — recommendation only';

	/// en: 'Ask before switching account'
	String get ask => 'Ask before switching account';

	/// en: 'Auto-switch for low-risk tasks'
	String get autoLowRisk => 'Auto-switch for low-risk tasks';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Existing Workspace'
	String get title => 'Existing Workspace';

	/// en: 'I already have a workspace on my server and just need to add it to the project list'
	String get description => 'I already have a workspace on my server and just need to add it to the project list';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Workspace'
	String get title => 'New Workspace';

	/// en: 'Create a new workspace, optionally clone from a GitHub repository'
	String get description => 'Create a new workspace, optionally clone from a GitHub repository';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$common$notifications$codes$generic$info$en info = Translations$common$notifications$codes$generic$info$en.internal(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$common$notifications$codes$permission$required$en required = Translations$common$notifications$codes$permission$required$en.internal(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$common$notifications$codes$run$stopped$en stopped = Translations$common$notifications$codes$run$stopped$en.internal(_root);
	late final Translations$common$notifications$codes$run$failed$en failed = Translations$common$notifications$codes$run$failed$en.internal(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$common$notifications$codes$agent$notification$en notification = Translations$common$notifications$codes$agent$notification$en.internal(_root);
}

// Path: settings.miniOrchestration.planner.modes
class Translations$settings$miniOrchestration$planner$modes$en {
	Translations$settings$miniOrchestration$planner$modes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Plan with the thinker'
	String get auto => 'Plan with the thinker';

	/// en: 'Single step'
	String get off => 'Single step';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Label'
	String get label => 'Label';

	/// en: 'e.g. SWE-2 Medium'
	String get labelPlaceholder => 'e.g. SWE-2 Medium';

	/// en: 'Provider'
	String get provider => 'Provider';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'Select a model'
	String get modelPlaceholder => 'Select a model';

	/// en: 'Effort'
	String get effort => 'Effort';

	/// en: 'Provider default'
	String get effortDefault => 'Provider default';

	/// en: 'default'
	String get effortPlaceholder => 'default';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Provider default'
	String get accountDefault => 'Provider default';

	/// en: 'Redundant accounts'
	String get redundantAccounts => 'Redundant accounts';

	/// en: 'No other accounts for this provider'
	String get redundantAccountsNone => 'No other accounts for this provider';

	/// en: 'Cost tier'
	String get tier => 'Cost tier';

	/// en: 'Remove candidate'
	String get remove => 'Remove candidate';

	/// en: 'Move up'
	String get moveUp => 'Move up';

	/// en: 'Move down'
	String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Planning'
	String get plan => 'Planning';

	/// en: 'Quick answers'
	String get quick => 'Quick answers';

	/// en: 'Research'
	String get research => 'Research';

	/// en: 'Documentation'
	String get docs => 'Documentation';

	/// en: 'Coding'
	String get code => 'Coding';

	/// en: 'Complex coding'
	String get codeHard => 'Complex coding';

	/// en: 'Testing'
	String get test => 'Testing';

	/// en: 'Review'
	String get review => 'Review';

	/// en: 'Report'
	String get report => 'Report';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Auto (LLM)'
	String get auto => 'Auto (LLM)';

	/// en: 'Templates'
	String get template => 'Templates';

	/// en: 'Off'
	String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'The planner model decomposes each request into typed steps.'
	String get auto => 'The planner model decomposes each request into typed steps.';

	/// en: 'Requests run through a fixed pipeline you pick below.'
	String get template => 'Requests run through a fixed pipeline you pick below.';

	/// en: 'No planning — the whole request is routed as a single step.'
	String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pipeline templates'
	String get title => 'Pipeline templates';

	/// en: 'Add template'
	String get add => 'Add template';

	/// en: 'Template name'
	String get namePlaceholder => 'Template name';

	/// en: 'Add step…'
	String get addStep => 'Add step…';

	/// en: 'Remove template'
	String get remove => 'Remove template';

	/// en: 'Remove step'
	String get removeStep => 'Remove step';

	/// en: 'No templates yet.'
	String get empty => 'No templates yet.';

	/// en: 'No steps yet — add one below.'
	String get emptySteps => 'No steps yet — add one below.';
}

// Path: settings.orchestration.planner.checkpointModes
class Translations$settings$orchestration$planner$checkpointModes$en {
	Translations$settings$orchestration$planner$checkpointModes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Autonomous'
	String get off => 'Autonomous';

	/// en: 'Per step'
	String get perStep => 'Per step';

	/// en: 'Every N'
	String get everyN => 'Every N';
}

// Path: settings.orchestration.planner.checkpointHints
class Translations$settings$orchestration$planner$checkpointHints$en {
	Translations$settings$orchestration$planner$checkpointHints$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Supervisor decisions run without asking (auto mode).'
	String get off => 'Supervisor decisions run without asking (auto mode).';

	/// en: 'Ask for approval before every proposed step batch.'
	String get perStep => 'Ask for approval before every proposed step batch.';

	/// en: 'Ask for approval after every N completed steps.'
	String get everyN => 'Ask for approval after every N completed steps.';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ask'
	String get ask => 'Ask';

	/// en: 'Skip step'
	String get skip => 'Skip step';
}

// Path: settings.orchestration.execution.retryClasses
class Translations$settings$orchestration$execution$retryClasses$en {
	Translations$settings$orchestration$execution$retryClasses$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rate limit'
	String get rateLimit => 'Rate limit';

	/// en: 'Quota'
	String get quota => 'Quota';

	/// en: 'Auth'
	String get auth => 'Auth';

	/// en: 'Timeout'
	String get timeout => 'Timeout';

	/// en: 'Transient'
	String get transient => 'Transient';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Editor Theme'
	String get label => 'Editor Theme';

	/// en: 'Default theme for the code editor'
	String get description => 'Default theme for the code editor';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Word Wrap'
	String get label => 'Word Wrap';

	/// en: 'Enable word wrapping by default in the editor'
	String get description => 'Enable word wrapping by default in the editor';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Show Minimap'
	String get label => 'Show Minimap';

	/// en: 'Display a minimap for easier navigation in diff view'
	String get description => 'Display a minimap for easier navigation in diff view';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Show Line Numbers'
	String get label => 'Show Line Numbers';

	/// en: 'Display line numbers in the editor'
	String get description => 'Display line numbers in the editor';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Font Size'
	String get label => 'Font Size';

	/// en: 'Editor font size in pixels'
	String get description => 'Editor font size in pixels';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Focus follows pointer'
	String get label => 'Focus follows pointer';

	/// en: 'Focus the terminal for typing when you move the mouse over it'
	String get description => 'Focus the terminal for typing when you move the mouse over it';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Token Name (e.g., Personal Repos)'
	String get namePlaceholder => 'Token Name (e.g., Personal Repos)';

	/// en: 'GitHub Personal Access Token (ghp_...)'
	String get tokenPlaceholder => 'GitHub Personal Access Token (ghp_...)';

	/// en: 'Description (optional)'
	String get descriptionPlaceholder => 'Description (optional)';

	/// en: 'Add Token'
	String get addButton => 'Add Token';

	/// en: 'Cancel'
	String get cancelButton => 'Cancel';

	/// en: 'How to create a GitHub Personal Access Token →'
	String get howToCreate => 'How to create a GitHub Personal Access Token →';

	/// en: 'Show token'
	String get showToken => 'Show token';

	/// en: 'Hide token'
	String get hideToken => 'Hide token';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Restart this application'
	String get restart => 'Restart this application';

	/// en: 'TaskMaster features will automatically become available'
	String get autoAvailable => 'TaskMaster features will automatically become available';

	/// en: 'Use task-master init in your project directory'
	String get initCommand => 'Use task-master init in your project directory';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Anthropic Claude AI assistant'
	String get description => 'Anthropic Claude AI assistant';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cursor AI-powered code editor'
	String get description => 'Cursor AI-powered code editor';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OpenAI Codex AI assistant'
	String get description => 'OpenAI Codex AI assistant';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OpenCode CLI assistant'
	String get description => 'OpenCode CLI assistant';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Command Code CLI assistant'
	String get description => 'Command Code CLI assistant';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Antigravity CLI assistant'
	String get description => 'Antigravity CLI assistant';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Devin CLI assistant'
	String get description => 'Devin CLI assistant';
}

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$permissions$codex$modes$kDefault$en kDefault = Translations$settings$permissions$codex$modes$kDefault$en.internal(_root);
	late final Translations$settings$permissions$codex$modes$acceptEdits$en acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$en.internal(_root);
	late final Translations$settings$permissions$codex$modes$bypassPermissions$en bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$en.internal(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'sandboxMode=workspace-write, approvalPolicy=untrusted. Trusted commands: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (without -exec), etc.'
	String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Trusted commands: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (without -exec), etc.';

	/// en: 'sandboxMode=workspace-write, approvalPolicy=never. All commands auto-execute within project directory.'
	String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never. All commands auto-execute within project directory.';

	/// en: 'sandboxMode=danger-full-access, approvalPolicy=never. Full system access, use only in trusted environments.'
	String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never. Full system access, use only in trusted environments.';

	/// en: 'You can override this per-session using the mode button in the chat interface.'
	String get overrideNote => 'You can override this per-session using the mode button in the chat interface.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$permissions$permissionMode$modes$kDefault$en kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$en.internal(_root);
	late final Translations$settings$permissions$permissionMode$modes$acceptEdits$en acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$en.internal(_root);
	late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$en bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$en.internal(_root);
	late final Translations$settings$permissions$permissionMode$modes$plan$en plan = Translations$settings$permissions$permissionMode$modes$plan$en.internal(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Manual'
	String get manual => 'Manual';

	/// en: 'Only show a recommendation; never switch accounts automatically.'
	String get manualHint => 'Only show a recommendation; never switch accounts automatically.';

	/// en: 'Ask before switching'
	String get ask => 'Ask before switching';

	/// en: 'A switch is proposed and waits for your approval.'
	String get askHint => 'A switch is proposed and waits for your approval.';

	/// en: 'Auto for low-risk tasks'
	String get autoLowRisk => 'Auto for low-risk tasks';

	/// en: 'Only tasks marked low risk may be moved automatically.'
	String get autoLowRiskHint => 'Only tasks marked low risk may be moved automatically.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create a Product Requirements Document (PRD)'
	String get title => 'Create a Product Requirements Document (PRD)';

	/// en: 'Discuss your project idea and create a PRD that describes what you want to build.'
	String get description => 'Discuss your project idea and create a PRD that describes what you want to build.';

	/// en: 'Add PRD'
	String get addButton => 'Add PRD';

	/// en: 'Existing PRDs:'
	String get existingPRDs => 'Existing PRDs:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Generate Tasks from PRD'
	String get title => 'Generate Tasks from PRD';

	/// en: 'Once you have a PRD, ask your AI assistant to parse it and TaskMaster will automatically break it down into manageable tasks with implementation details.'
	String get description => 'Once you have a PRD, ask your AI assistant to parse it and TaskMaster will automatically break it down into manageable tasks with implementation details.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Analyze & Expand Tasks'
	String get title => 'Analyze & Expand Tasks';

	/// en: 'Ask your AI assistant to analyze task complexity and expand them into detailed subtasks for easier implementation.'
	String get description => 'Ask your AI assistant to analyze task complexity and expand them into detailed subtasks for easier implementation.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Start Building'
	String get title => 'Start Building';

	/// en: 'Ask your AI assistant to begin working on tasks, update their status, and add new tasks as your project evolves.'
	String get description => 'Ask your AI assistant to begin working on tasks, update their status, and add new tasks as your project evolves.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Writes to each provider user config and is available across projects on this machine'
	String get userGlobal => 'Writes to each provider user config and is available across projects on this machine';

	/// en: 'Available across all projects on your machine'
	String get user => 'Available across all projects on your machine';

	/// en: 'Stored in Claude user settings for the selected project'
	String get local => 'Stored in Claude user settings for the selected project';

	/// en: 'Writes to the selected project workspace for every provider'
	String get projectGlobal => 'Writes to the selected project workspace for every provider';

	/// en: 'Stored in the selected project workspace'
	String get project => 'Stored in the selected project workspace';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notification'
	String get title => 'Notification';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Action Required'
	String get title => 'Action Required';

	/// en: '{{toolName}} is waiting for your decision.'
	String body({required Object toolName}) => '${toolName} is waiting for your decision.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Run Stopped'
	String get title => 'Run Stopped';

	/// en: 'Reason: {{reason}}'
	String body({required Object reason}) => 'Reason: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Run Failed'
	String get title => 'Run Failed';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agent Notification'
	String get title => 'Agent Notification';
}

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Default'
	String get title => 'Default';

	/// en: 'Only trusted commands (ls, cat, grep, git status, etc.) run automatically. Other commands are skipped. Can write to workspace.'
	String get description => 'Only trusted commands (ls, cat, grep, git status, etc.) run automatically. Other commands are skipped. Can write to workspace.';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Accept Edits'
	String get title => 'Accept Edits';

	/// en: 'All commands run automatically within the workspace. Full auto mode with sandboxed execution.'
	String get description => 'All commands run automatically within the workspace. Full auto mode with sandboxed execution.';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bypass Permissions'
	String get title => 'Bypass Permissions';

	/// en: 'Full system access with no restrictions. All commands run automatically with full disk and network access. Use with caution.'
	String get description => 'Full system access with no restrictions. All commands run automatically with full disk and network access. Use with caution.';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Default'
	String get title => 'Default';

	/// en: 'Actions that need permission are shown to you for approval in the chat.'
	String get description => 'Actions that need permission are shown to you for approval in the chat.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Accept Edits'
	String get title => 'Accept Edits';

	/// en: 'File edits are approved automatically; other actions still ask for your approval.'
	String get description => 'File edits are approved automatically; other actions still ask for your approval.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bypass Permissions'
	String get title => 'Bypass Permissions';

	/// en: 'Every action is approved automatically — full access without prompts. Use with caution.'
	String get description => 'Every action is approved automatically — full access without prompts. Use with caution.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Plan'
	String get title => 'Plan';

	/// en: 'Planning mode: the agent explores and plans without executing commands.'
	String get description => 'Planning mode: the agent explores and plans without executing commands.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Your session expired. Please log in again.',
			'auth.login.title' => 'Welcome Back',
			'auth.login.description' => 'Sign in to your ddagent self-hosted account',
			'auth.login.username' => 'Username',
			'auth.login.password' => 'Password',
			'auth.login.submit' => 'Sign In',
			'auth.login.loading' => 'Signing in...',
			'auth.login.errors.invalidCredentials' => 'Invalid username or password',
			'auth.login.errors.requiredFields' => 'Please fill in all fields',
			'auth.login.errors.networkError' => 'Network error. Please try again.',
			'auth.login.placeholders.username' => 'Enter your username',
			'auth.login.placeholders.password' => 'Enter your password',
			'auth.register.title' => 'Create Account',
			'auth.register.username' => 'Username',
			'auth.register.password' => 'Password',
			'auth.register.confirmPassword' => 'Confirm Password',
			'auth.register.submit' => 'Create Account',
			'auth.register.loading' => 'Creating account...',
			'auth.register.errors.passwordMismatch' => 'Passwords do not match',
			'auth.register.errors.usernameTaken' => 'Username is already taken',
			'auth.register.errors.weakPassword' => 'Password is too weak',
			'auth.register.errors.usernameTooShort' => 'Username must be at least 3 characters',
			'auth.register.errors.passwordTooShort' => 'Password must be at least 6 characters',
			'auth.logout.title' => 'Sign Out',
			'auth.logout.confirm' => 'Are you sure you want to sign out?',
			'auth.logout.button' => 'Sign Out',
			'chat.codeBlock.copy' => 'Copy',
			'chat.codeBlock.copied' => 'Copied',
			'chat.codeBlock.copyCode' => 'Copy code',
			'chat.copyMessage.copy' => 'Copy message',
			'chat.copyMessage.copied' => 'Message copied',
			'chat.copyMessage.failed' => 'Copy failed',
			'chat.copyMessage.selectFormat' => 'Select copy format',
			'chat.copyMessage.copyAsMarkdown' => 'Copy as markdown',
			'chat.copyMessage.copyAsText' => 'Copy as text',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => 'Error',
			'chat.messageTypes.tool' => 'Tool',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.messageTypes.orchestrator' => 'Auto',
			'chat.orchestrator.routing.title' => 'Routing',
			'chat.orchestrator.routing.alternatives' => ({required Object list}) => 'Alternatives: ${list}',
			'chat.orchestrator.routing.first' => ({required Object label, required Object task}) => '${label} — first candidate for ${task}',
			'chat.orchestrator.routing.skipped' => ({required Object label, required Object list}) => '${label} — earlier candidates skipped (${list})',
			'chat.orchestrator.plan.title' => 'Plan',
			'chat.orchestrator.plan.disabled' => 'disabled',
			'chat.orchestrator.plan.awaitingConfirm' => 'Waiting for plan confirmation.',
			'chat.orchestrator.plan.run' => 'Run plan',
			'chat.orchestrator.plan.toggleStep' => 'Enable step',
			'chat.orchestrator.plan.confirmFailed' => 'Failed to start — try again.',
			'chat.orchestrator.plan.fallback' => 'planner unavailable — single-step fallback',
			'chat.orchestrator.plan.templateSource' => 'from pipeline template',
			'chat.orchestrator.plan.offSource' => 'planner off',
			'chat.orchestrator.plan.stepCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} step', other: '${count} steps', ), 
			'chat.orchestrator.plan.supervisedSource' => 'supervised loop',
			'chat.orchestrator.decision.title' => 'Supervisor decision',
			'chat.orchestrator.decision.iteration' => ({required Object n}) => 'iteration ${n}',
			'chat.orchestrator.decision.rationaleLabel' => 'Why',
			'chat.orchestrator.decision.awaitingConfirm' => 'Waiting for your approval before running these steps.',
			'chat.orchestrator.decision.proposedSteps' => 'Proposed steps',
			'chat.orchestrator.decision.action.kContinue' => 'delegating',
			'chat.orchestrator.decision.action.done' => 'finished',
			'chat.orchestrator.decision.action.invalid' => 'no decision',
			'chat.orchestrator.decision.outcome.success' => 'success',
			'chat.orchestrator.decision.outcome.partial' => 'partial',
			'chat.orchestrator.decision.outcome.failed' => 'failed',
			'chat.orchestrator.delegation.title' => 'Delegated step',
			'chat.orchestrator.delegation.openSession' => 'Open full session',
			'chat.orchestrator.delegation.attempt' => ({required Object n}) => 'attempt ${n}',
			'chat.orchestrator.delegation.retryStep' => 'Retry / Fix',
			'chat.orchestrator.delegation.continueStep' => 'Continue / Fix',
			'chat.orchestrator.delegation.continueFailed' => 'Failed — try again.',
			'chat.orchestrator.delegation.status.queued' => 'queued',
			'chat.orchestrator.delegation.status.running' => 'running',
			'chat.orchestrator.delegation.status.done' => 'done',
			'chat.orchestrator.delegation.status.failed' => 'failed',
			'chat.orchestrator.delegation.status.aborted' => 'aborted',
			'chat.orchestrator.delegation.status.skipped' => 'skipped',
			'chat.orchestrator.delegation.status.awaitingDecision' => 'waiting for decision',
			'chat.orchestrator.delegation.attempts' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} attempt', other: '${count} attempts', ), 
			'chat.orchestrator.delegation.candidates' => ({required Object list}) => 'candidates: ${list}',
			'chat.orchestrator.delegation.candidateCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} candidate', other: '${count} candidates', ), 
			'chat.orchestrator.summary.title' => 'Summary',
			'chat.orchestrator.summary.progress' => ({required Object done, required Object total}) => 'Steps completed: ${done}/${total}',
			'chat.orchestrator.summary.aborted' => 'aborted',
			'chat.orchestrator.summary.timedOut' => 'timed out',
			'chat.orchestrator.summary.capped' => 'iteration cap',
			'chat.orchestrator.summary.failed' => ({required Object list}) => 'Failed steps: ${list}',
			'chat.orchestrator.summary.kContinue' => 'Continue',
			'chat.orchestrator.summary.continueWork' => 'Continue work',
			'chat.orchestrator.summary.resumeFailed' => 'Failed to resume — try again.',
			'chat.orchestrator.summary.runNextTask' => 'Run next task',
			'chat.orchestrator.summary.endAllTasks' => 'End all tasks',
			'chat.orchestrator.summary.tasksRunning' => 'Working on tasks…',
			'chat.orchestrator.summary.cancelTasks' => 'Cancel',
			'chat.orchestrator.backToParent' => 'Back to orchestration',
			'chat.orchestrator.taskmaster.title' => 'Task queue',
			'chat.orchestrator.taskmaster.remaining' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} left', other: '${count} left', ), 
			'chat.orchestrator.taskmaster.status.started' => 'running',
			'chat.orchestrator.taskmaster.status.done' => 'done',
			'chat.orchestrator.taskmaster.status.complete' => 'complete',
			'chat.orchestrator.taskmaster.status.failed' => 'failed',
			'chat.orchestrator.taskmaster.status.paused' => 'paused',
			'chat.orchestrator.taskmaster.status.blocked' => 'blocked',
			'chat.orchestrator.taskmaster.status.aborted' => 'aborted',
			'chat.orchestrator.gate.timedOut' => 'timed out',
			'chat.orchestrator.gate.exit' => ({required Object code}) => 'exit ${code}',
			'chat.tools.settings' => 'Tool Settings',
			'chat.tools.error' => 'Tool Error',
			'chat.tools.result' => 'Tool Result',
			'chat.tools.viewParams' => 'View input parameters',
			'chat.tools.viewRawParams' => 'View raw parameters',
			'chat.tools.viewDiff' => 'View edit diff for',
			'chat.tools.creatingFile' => 'Creating new file:',
			'chat.tools.updatingTodo' => 'Updating Todo List',
			'chat.tools.read' => 'Read',
			'chat.tools.readFile' => 'Read file',
			'chat.tools.updateTodo' => 'Update todo list',
			'chat.tools.readTodo' => 'Read todo list',
			'chat.tools.searchResults' => 'results',
			'chat.tools.todoReadLabel' => 'TodoRead reading list',
			'chat.search.found' => ({required Object count, required Object type}) => 'Found ${count} ${type}',
			'chat.search.file' => 'file',
			'chat.search.files' => 'files',
			'chat.search.pattern' => 'pattern:',
			'chat.search.kIn' => 'in:',
			'chat.fileOperations.updated' => 'File updated successfully',
			'chat.fileOperations.created' => 'File created successfully',
			'chat.fileOperations.written' => 'File written successfully',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => 'New File',
			'chat.fileOperations.viewContent' => 'View file content',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'View full output (${count} chars)',
			'chat.fileOperations.contentDisplayed' => 'The file content is displayed in the diff view above',
			'chat.interactive.title' => 'Interactive Prompt',
			'chat.interactive.waiting' => 'Waiting for your response in the CLI',
			'chat.interactive.instruction' => 'Please select an option in your terminal where Claude is running.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude selected option ${number}',
			'chat.interactive.instructionDetail' => 'In the CLI, you would select this option interactively using arrow keys or by typing the number.',
			'chat.thinking.title' => 'Thinking...',
			'chat.thinking.emoji' => '💭 Thinking...',
			'chat.json.response' => 'JSON Response',
			'chat.permissions.grant' => ({required Object tool}) => 'Grant permission for ${tool}',
			'chat.permissions.added' => 'Permission added',
			'chat.permissions.addTo' => ({required Object entry}) => 'Adds ${entry} to Allowed Tools.',
			'chat.permissions.retry' => 'Permission saved. Retry the request to use the tool.',
			'chat.permissions.error' => 'Unable to update permissions. Please try again.',
			'chat.permissions.openSettings' => 'Open settings',
			'chat.permissions.allow' => 'Allow',
			'chat.permissions.always' => 'Always',
			'chat.permissions.editAndAllow' => 'Edit & allow',
			'chat.permissions.deny' => 'Deny',
			'chat.permissions.reject' => 'Reject',
			'chat.permissions.allowAll' => ({required Object count}) => 'Allow all (${count})',
			'chat.permissions.editInput' => 'Edit input',
			'chat.permissions.invalidJson' => 'Invalid JSON',
			'chat.permissions.allowWithChanges' => 'Allow with changes',
			'chat.todo.updated' => 'Todo list has been updated successfully',
			'chat.todo.current' => 'Current Todo List',
			'chat.plan.viewPlan' => '📋 View implementation plan',
			'chat.plan.title' => 'Implementation Plan',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claude usage limit reached. Your limit will reset at **${time} ${timezone}** - ${date}',
			'chat.codex.permissionMode' => 'Permission Mode',
			'chat.codex.modes.kDefault' => 'Default Mode',
			'chat.codex.modes.auto' => 'Auto Mode',
			'chat.codex.modes.acceptEdits' => 'Accept Edits',
			'chat.codex.modes.bypassPermissions' => 'Bypass Permissions',
			'chat.codex.modes.plan' => 'Plan Mode',
			'chat.codex.descriptions.kDefault' => 'Only trusted commands (ls, cat, grep, git status, etc.) run automatically. Other commands are skipped. Can write to workspace.',
			'chat.codex.descriptions.auto' => 'A model classifier decides per tool call whether to approve or deny. Hands-off, but safer than Bypass — denials still happen.',
			'chat.codex.descriptions.acceptEdits' => 'All commands run automatically within the workspace. Full auto mode with sandboxed execution.',
			'chat.codex.descriptions.bypassPermissions' => 'Full system access with no restrictions. All commands run automatically with full disk and network access. Use with caution.',
			'chat.codex.descriptions.plan' => 'Planning mode - no commands are executed',
			'chat.codex.technicalDetails' => 'Technical details',
			'chat.voice.autoRead' => 'Read replies aloud',
			'chat.voice.autoReadOn' => 'Read replies aloud: on',
			'chat.voice.autoReadOff' => 'Read replies aloud: off',
			'chat.voice.autoReadVoice' => 'Read-aloud voice',
			'chat.voice.autoReadVoiceAuto' => 'Auto voice',
			'chat.voice.autoReadPreview' => 'This is how replies will sound.',
			'chat.voice.speakMessage' => 'Read aloud',
			'chat.voice.stopSpeaking' => 'Stop reading',
			'chat.input.placeholder' => ({required Object provider}) => 'Type / for commands, @ for files, or ask ${provider} anything...',
			'chat.input.placeholderDefault' => 'Type your message...',
			'chat.input.disabled' => 'Input disabled',
			'chat.input.attachFiles' => 'Attach files',
			'chat.input.attachFilesDesc' => 'Upload photos, files, or documents',
			'chat.input.takePhoto' => 'Take photo',
			'chat.input.takePhotoDesc' => 'Use camera to capture photo',
			'chat.input.moreTools' => 'More tools',
			'chat.input.commandsDesc' => 'Explore shortcuts and commands',
			'chat.input.clearInputDesc' => 'Discard current text',
			'chat.input.attachImages' => 'Attach images',
			'chat.input.send' => 'Send',
			'chat.input.stop' => 'Stop',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter to send • / commands • @ files',
			'chat.input.hintText.enter' => 'Enter to send • Shift+Enter newline • / commands • @ files',
			'chat.input.hintText.queue' => 'Enter to queue your next message',
			'chat.input.hintText.updateQueued' => 'Enter to update queued message',
			'chat.input.clickToChangeMode' => 'Click to change permission mode',
			'chat.input.showAllCommands' => 'Show all commands',
			'chat.input.clearInput' => 'Clear input',
			'chat.input.scrollToBottom' => 'Scroll to bottom',
			'chat.input.newMessage' => 'New message',
			'chat.input.newMessages' => 'New messages',
			'chat.input.queue.sendNext' => 'Queue next message',
			'chat.input.queue.update' => 'Update queued message',
			'chat.input.queue.label' => 'Queued',
			'chat.input.queue.willSend' => 'Will send when this finishes',
			'chat.input.queue.edit' => 'Edit queued message',
			'chat.input.queue.delete' => 'Delete queued message',
			'chat.input.queue.failed' => 'Failed to send',
			'chat.input.queue.sendNow' => 'Send now',
			'chat.input.autoContinueTasks' => 'Auto-continue',
			'chat.input.autoContinueTasksTooltip' => 'Enable to let Devin automatically continue to the next Task Master task',
			'chat.input.offlineQueue.clear' => 'Cancel and clear offline queue',
			'chat.input.offlineQueue.clearBtn' => 'Cancel',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} messages queued offline — will send automatically when reconnected',
			'chat.input.offlineQueue.single' => '1 message queued offline — will send automatically when reconnected',
			'chat.input.voice' => 'Voice input',
			'chat.input.voiceStart' => 'Dictate a message',
			'chat.input.voiceStop' => 'Stop dictation',
			'chat.input.pinFile' => 'Pin file to context',
			'chat.input.voiceSettings' => 'Voice settings (STT)',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Camera unavailable: ${error}',
			'chat.composer.toolsAndActions' => 'Tools & actions',
			'chat.composer.toolsAndActionsDesc' => 'Tools and controls for chat composer',
			'chat.composer.reasoning' => 'Reasoning',
			'chat.composer.model' => 'Model',
			'chat.composer.effortDefault' => 'Default',
			'chat.composer.loadingModels' => 'Loading models…',
			'chat.composer.modelMenu' => 'Select model and reasoning effort',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'How should ${provider} actions be approved?',
			'chat.composer.favorites' => 'Favorites',
			'chat.composer.account' => 'Account',
			'chat.composer.accountMenu' => 'Select account',
			'chat.composer.accountDefault' => 'Default account',
			'chat.composer.accountAuto' => 'Auto (default)',
			'chat.composer.accountIsDefault' => 'Default',
			'chat.providerSelection.title' => 'Choose Your AI Assistant',
			'chat.providerSelection.description' => 'Select a provider to start a new conversation',
			'chat.providerSelection.selectModel' => 'Select Model',
			'chat.providerSelection.workspace' => 'Workspace',
			'chat.providerSelection.noWorkspace' => 'None',
			'chat.providerSelection.clickToChangeWorkspace' => 'Click to change workspace',
			'chat.providerSelection.chooseWorkspace' => 'Choose a workspace',
			'chat.providerSelection.searchWorkspaces' => 'Search workspaces...',
			'chat.providerSelection.noWorkspacesFound' => 'No workspaces found.',
			'chat.providerSelection.providerInfo.anthropic' => 'by Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'by OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI Code Editor',
			'chat.providerSelection.providerInfo.google' => 'by Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Ready to use Claude with ${model}. Start typing your message below.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Ready to use Cursor with ${model}. Start typing your message below.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Ready to use Codex with ${model}. Start typing your message below.',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'Ready to use OpenCode with ${model}. Start typing your message below.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Select a provider above to begin',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Ready with Devin ${model}',
			'chat.providerSelection.readyPrompt.orchestrator' => 'Ready with Auto — the router picks the best model per step',
			'chat.providerSelection.autoGroup' => 'Auto',
			'chat.providerSelection.autoLabel' => 'Auto (orchestrated)',
			'chat.providerSelection.autoDescription' => 'Routes each step to the best available provider and model',
			'chat.providerSelection.orchestrated' => 'orchestrated',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Press <kbd>${shortcut}</kbd> to search sessions, files, and commits',
			'chat.providerSelection.all' => 'All',
			'chat.providerSelection.free' => 'Free',
			'chat.providerSelection.noModelsFound' => 'No models found.',
			'chat.providerSelection.paid' => 'Paid',
			'chat.providerSelection.searchModels' => 'Search models...',
			'chat.providerSelection.addModel' => 'Add model',
			'chat.providerSelection.chooseModel' => 'Choose a model',
			'chat.providerSelection.chooseModelDescription' => 'Built-in and custom models in one list',
			'chat.providerSelection.clickToChange' => 'Click to change model',
			'chat.providerSelection.favorites' => 'Favorites',
			'chat.providerSelection.loadingModels' => 'Loading models…',
			'chat.providerSelection.manageModels' => 'Manage models',
			'chat.providerSelection.refresh' => 'Refresh models',
			'chat.session.kContinue.title' => 'Continue your conversation',
			'chat.session.kContinue.description' => 'Ask questions about your code, request changes, or get help with development tasks',
			'chat.session.kContinue.action' => 'Continue typing',
			'chat.session.loading.olderMessages' => 'Loading older messages...',
			'chat.session.loading.sessionMessages' => 'Loading session messages...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => 'Showing ${shown} of ${total} messages',
			'chat.session.messages.scrollToLoad' => 'Scroll up to load more',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Showing last ${count} messages (${total} total)',
			'chat.session.messages.loadEarlier' => 'Load earlier messages',
			'chat.session.messages.loadOlderFailed' => 'Failed to load older messages.',
			'chat.session.messages.retry' => 'Retry',
			'chat.session.messages.loadAll' => 'Load all messages',
			'chat.session.messages.loadingAll' => 'Loading all messages...',
			'chat.session.messages.allLoaded' => 'All messages loaded',
			'chat.session.messages.perfWarning' => 'All messages loaded — scrolling may be slower. Click "Scroll to bottom" to restore performance.',
			'chat.session.messages.noSearchMatches' => 'No messages match your search.',
			'chat.session.messages.loadOlder' => 'Load older messages',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Load all (${count})',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Retry loading older — ${error}',
			'chat.session.deleteConfirm' => 'Removes the session and its transcript. Cannot be undone.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Finish the run before changing workspace',
			'chat.shell.selectProject.title' => 'Select a Project',
			'chat.shell.selectProject.description' => 'Choose a project to open an interactive shell in that directory',
			'chat.shell.status.newSession' => 'New Session',
			'chat.shell.status.initializing' => 'Initializing...',
			'chat.shell.status.restarting' => 'Restarting...',
			'chat.shell.actions.disconnect' => 'Disconnect',
			'chat.shell.actions.disconnectTitle' => 'Disconnect from shell',
			'chat.shell.actions.restart' => 'Restart',
			'chat.shell.actions.restartTitle' => 'Restart Shell',
			'chat.shell.actions.kill' => 'Kill (SIGINT)',
			'chat.shell.actions.killTitle' => 'Kill running process (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Copy output',
			'chat.shell.actions.copyOutputTitle' => 'Copy terminal output',
			'chat.shell.actions.copied' => 'Copied!',
			'chat.shell.actions.zoomInTitle' => 'Zoom in',
			'chat.shell.actions.zoomOutTitle' => 'Zoom out',
			'chat.shell.actions.connect' => 'Continue in Shell',
			'chat.shell.actions.connectTitle' => 'Connect to shell',
			'chat.shell.loading' => 'Loading terminal...',
			'chat.shell.connecting' => 'Connecting to shell...',
			'chat.shell.startSession' => 'Start a new agent session',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Resume session: ${displayName}...',
			'chat.shell.runCommand' => ({required Object command, required Object projectName}) => 'Run ${command} in ${projectName}',
			'chat.shell.startCli' => ({required Object projectName}) => 'Starting agent CLI in ${projectName}',
			'chat.shell.defaultCommand' => 'command',
			'chat.claudeStatus.actions.thinking' => 'Thinking',
			'chat.claudeStatus.actions.processing' => 'Processing',
			'chat.claudeStatus.actions.analyzing' => 'Analyzing',
			'chat.claudeStatus.actions.working' => 'Working',
			'chat.claudeStatus.actions.computing' => 'Computing',
			'chat.claudeStatus.actions.reasoning' => 'Reasoning',
			'chat.claudeStatus.state.live' => 'Live',
			'chat.claudeStatus.state.paused' => 'Paused',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}s',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} elapsed',
			'chat.claudeStatus.elapsed.startingNow' => 'Starting now',
			'chat.claudeStatus.stop' => 'Stop',
			'chat.claudeStatus.controls.stopGeneration' => 'Stop Generation',
			'chat.claudeStatus.controls.pressEscToStop' => 'Press Esc anytime to stop',
			'chat.claudeStatus.providers.assistant' => 'Assistant',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Select a project to start chatting with ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Start the next task',
			'chat.splitSession.toggle' => 'Split Session',
			'chat.splitSession.close' => 'Close split session',
			'chat.splitSession.selectSession' => 'Select session to compare',
			'chat.splitSession.noOtherSessions' => 'No other sessions available',
			'chat.splitSession.newSessionOption' => '+ New session in split view',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Current Project (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Other Projects',
			'chat.splitSession.recentSessionsGroup' => 'Recent sessions',
			'chat.splitSession.startNewSession' => 'Start New Session in Split View',
			'chat.splitSession.selectFromList' => 'Select session from list of existing sessions',
			'chat.sessionPicker.title' => 'Select session',
			'chat.sessionPicker.searchPlaceholder' => 'Search sessions...',
			'chat.sessionPicker.clearSearch' => 'Clear search',
			'chat.sessionPicker.newChat' => '+ New chat',
			'chat.sessionPicker.archivedToggle' => 'Archived',
			'chat.sessionPicker.changeSession' => 'Change session',
			'chat.sessionPicker.archivedLoading' => 'Loading archived sessions...',
			'chat.sessionPicker.archivedError' => 'Could not load archived sessions',
			'chat.sessionPicker.archivedEmpty' => 'No archived sessions',
			'chat.sessionPicker.archivedProjectOnly' => 'Workspace archived — restore it to see its sessions.',
			'chat.sessionPicker.emptySearch' => 'No sessions match your search',
			'chat.sessionPicker.restore' => 'Restore',
			'chat.sessionPicker.restoreSession' => 'Restore session',
			'chat.sessionPicker.restoreProject' => 'Restore workspace',
			'chat.sessionPicker.restoreSessionFailed' => 'Failed to restore session. Please try again.',
			'chat.sessionPicker.restoreProjectFailed' => 'Failed to restore workspace. Please try again.',
			'chat.sessionPicker.archiveFailed' => 'Failed to archive session. Please try again.',
			'chat.sessionPicker.deleteFailed' => 'Failed to delete session. Please try again.',
			'chat.sessionPicker.running' => 'Session is running',
			'chat.sessionPicker.unread' => 'Unread — finished with new output',
			'chat.sessionPicker.account' => 'Account',
			'chat.splitWorkspace.addChat' => 'Add chat pane',
			'chat.splitWorkspace.addBrowser' => 'Add browser pane',
			'chat.splitWorkspace.addTerminal' => 'Add terminal pane',
			'chat.splitWorkspace.addPreview' => 'Add preview pane',
			'chat.splitWorkspace.overview' => 'Show all panes',
			'chat.splitWorkspace.exitFocusMode' => 'Exit Focus Mode (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => 'Focus Mode (Ctrl+Shift+F)',
			'chat.splitWorkspace.broadcast' => 'Broadcast to sessions',
			'chat.splitWorkspace.addNotes' => 'Add shared-notes pane',
			'chat.splitWorkspace.browseSessions' => 'Open session list',
			'chat.splitOverview.title' => 'Split panes overview',
			'chat.splitOverview.count' => ({required Object count}) => '${count} panes',
			'chat.splitOverview.close' => 'Close overview',
			'chat.splitOverview.question' => 'QUESTION — input required',
			'chat.splitOverview.processing' => 'PROCESSING',
			'chat.splitOverview.idle' => 'Idle',
			'chat.splitOverview.active' => 'Active',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} needs your input',
			'chat.askUserQuestion.skip' => 'Skip',
			'chat.askUserQuestion.other' => 'Other…',
			'chat.askUserQuestion.answerHint' => 'Type your answer…',
			'chat.attachments.downloadFailedRetry' => 'Download failed — click to retry',
			'chat.attachments.fileAttachment' => 'File attachment',
			'chat.attachments.download' => ({required Object name}) => 'Download ${name}',
			'chat.checkpoint.creating' => 'Creating snapshot…',
			'chat.checkpoint.revertChanges' => 'Revert files to last checkpoint',
			'chat.checkpoint.undo' => 'Undo checkpoint',
			'chat.checkpoint.undoAiRun' => 'Undo AI run',
			'chat.checkpoint.undoing' => 'Undoing…',
			'chat.checkpoint.undone' => 'Undone',
			'chat.checkpoint.beforeAiTurn' => 'before AI turn',
			'chat.common.close' => 'Close',
			'chat.taskMaster.saveToTask' => 'Task',
			'chat.taskMaster.saved' => 'Saved',
			'chat.taskMaster.saving' => 'Saving...',
			'chat.taskMaster.taskShort' => 'TASK',
			'chat.taskMaster.addToTask' => 'Add to TaskMaster',
			'chat.taskMaster.added' => 'Added to TaskMaster',
			'chat.tokenUsage.desc' => 'View session token consumption',
			'chat.tokenUsage.title' => 'Token usage',
			'chat.tool.emptyResult' => '(no output yet — the tool returned an empty result)',
			'chat.quotaBadge.ariaLabel' => 'Subscription limits',
			'chat.quotaBadge.noData' => 'No subscription data for this model',
			'chat.broadcast.title' => 'Broadcast to sessions',
			'chat.broadcast.noSessions' => 'No sessions available',
			'chat.broadcast.placeholder' => 'Message to send to every selected session…',
			'chat.broadcast.partial' => ({required Object count}) => '${count} session(s) rejected the message',
			'chat.broadcast.sent' => ({required Object count}) => 'Queued for ${count} session(s)',
			'chat.broadcast.selectAll' => 'Select all',
			'chat.broadcast.selectOrchestrators' => 'Select orchestrators',
			'chat.broadcast.orchestratorsOnly' => 'Orchestrators only',
			'chat.broadcast.noOrchestrators' => 'No orchestrator sessions available',
			'chat.broadcast.sending' => 'Sending…',
			'chat.broadcast.send' => ({required Object count}) => 'Send to ${count}',
			'chat.paneHeader.processing' => 'Processing…',
			'chat.paneHeader.switchSession' => 'Switch session',
			'chat.export.sessionTitle' => ({required Object id}) => 'Session ${id}',
			'chat.export.pdfFailed' => 'PDF export failed',
			'chat.export.transcriptDownloaded' => 'Transcript downloaded',
			'chat.export.savedTo' => ({required Object path}) => 'Saved ${path}',
			'chat.commandResult.fallback.models' => 'Browse available models for the active provider.',
			'chat.commandResult.fallback.cost' => 'Review token usage for the active session.',
			'chat.commandResult.fallback.status' => 'Inspect runtime, version, provider, and environment status.',
			'chat.commandResult.fallback.memory' => 'Open the project CLAUDE.md memory file.',
			'chat.commandResult.fallback.config' => 'Open settings and configuration.',
			'chat.commandResult.fallback.help' => 'Show command documentation and syntax.',
			'chat.commandResult.filterCommands' => 'Filter commands...',
			'chat.commandResult.searchModels' => ({required Object provider}) => 'Search ${provider} models...',
			'chat.commands.runConfirmTitle' => 'Run command?',
			'chat.commands.executionCancelled' => 'Command execution cancelled',
			'chat.pinFile.title' => 'Pin file',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.action' => 'Pin',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => 'Edit ${name}',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => 'Delete ${name}',
			'chat.modelLibrary.enterNameAndId' => 'Enter both a model name and model ID.',
			'chat.modelLibrary.idNoSpaces' => 'Model IDs cannot contain spaces.',
			'chat.modelLibrary.setAsDefault' => 'Set as default',
			'chat.modelLibrary.defaultModel' => 'Default model',
			'chat.changes.failedToLoad' => 'Failed to load changes',
			'chat.changes.empty' => 'No file changes',
			'chat.message.compactedSummary' => 'Compacted summary',
			'chat.message.resendHint' => 'Resend from the composer',
			'chat.message.rawView' => 'Raw view',
			'chat.permissionRequest.title' => ({required Object tool}) => 'Permission request · ${tool}',
			'chat.permissionRequest.question' => 'Question',
			'codeEditor.toolbar.changes' => 'changes',
			'codeEditor.toolbar.previousChange' => 'Previous change',
			'codeEditor.toolbar.nextChange' => 'Next change',
			'codeEditor.toolbar.hideDiff' => 'Hide diff highlighting',
			'codeEditor.toolbar.showDiff' => 'Show diff highlighting',
			'codeEditor.toolbar.settings' => 'Editor Settings',
			'codeEditor.toolbar.collapse' => 'Collapse editor',
			'codeEditor.toolbar.expand' => 'Expand editor to full width',
			'codeEditor.toolbar.toggleDock' => 'Toggle file dock',
			'codeEditor.toolbar.diffMerge' => 'Diff / merge',
			'codeEditor.toolbar.previewInBrowser' => 'Preview in browser',
			'codeEditor.toolbar.reload' => 'Reload from disk',
			'codeEditor.loading' => ({required Object fileName}) => 'Loading ${fileName}...',
			'codeEditor.header.showingChanges' => 'Showing changes',
			'codeEditor.actions.copyPath' => 'Copy file path',
			'codeEditor.actions.pathCopied' => 'File path copied',
			'codeEditor.actions.download' => 'Download file',
			'codeEditor.actions.save' => 'Save',
			'codeEditor.actions.saving' => 'Saving...',
			'codeEditor.actions.saved' => 'Saved!',
			'codeEditor.actions.exitFullscreen' => 'Exit fullscreen',
			'codeEditor.actions.fullscreen' => 'Fullscreen',
			'codeEditor.actions.close' => 'Close',
			'codeEditor.actions.previewMarkdown' => 'Preview markdown',
			'codeEditor.actions.editMarkdown' => 'Edit markdown',
			'codeEditor.actions.pinFile' => 'Pin file to context',
			'codeEditor.actions.unpinFile' => 'Unpin file from context',
			'codeEditor.actions.previewHtml' => 'Open HTML preview in new tab',
			'codeEditor.actions.retry' => 'Retry',
			'codeEditor.actions.saveAll' => 'Save all',
			'codeEditor.footer.lines' => 'Lines:',
			'codeEditor.footer.characters' => 'Characters:',
			'codeEditor.footer.shortcuts' => 'Press Ctrl+S to save • Esc to close',
			'codeEditor.binaryFile.title' => 'Binary File',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'The file "${fileName}" cannot be displayed in the text editor because it is a binary file.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Cannot display as text',
			'codeEditor.filePreview.loading' => 'Loading preview...',
			'codeEditor.filePreview.error' => 'Unable to display this file.',
			'codeEditor.filePreview.openInNewTab' => 'Open in new tab',
			'codeEditor.unsavedChanges' => ({required Object name}) => 'Unsaved changes in ${name}',
			'codeEditor.discardUnsavedChanges' => 'Discard unsaved changes?',
			'codeEditor.mediaFile.title' => 'Media file',
			'codeEditor.mediaFile.subtitle' => 'Audio/video preview is not supported yet',
			'codeEditor.failedToLoad' => 'Failed to load file',
			'codeEditor.hexDump.more' => ({required Object size}) => '… ${size} more',
			'codeEditor.settings.minimap' => 'Minimap',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Tab size: ${size}',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Font size −  (now ${size})',
			_ => null,
		} ?? switch (path) {
			'codeEditor.settings.fontSizeIncrease' => 'Font size +',
			'codeEditor.diff.noChanges' => 'No changes',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Hunk ${number}',
			'codeEditor.diff.close' => 'Close diff',
			'codeEditor.diff.base' => 'Base',
			'codeEditor.diff.current' => 'Current',
			'codeEditor.diff.applyMerge' => 'Apply merge',
			'codeEditor.diff.deletedOnDisk' => 'deleted on disk',
			'codeEditor.emptyState.title' => 'No file open',
			'codeEditor.toasts.savedFile' => ({required Object name}) => 'Saved ${name}',
			'codeEditor.toasts.saveFailed' => 'Save failed',
			'codeEditor.toasts.allSaved' => 'All saved',
			'codeEditor.toasts.someSavesFailed' => 'Some saves failed',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Saved to ${path}',
			'codeEditor.toasts.mergeApplied' => 'Merge applied — save to persist',
			'common.buttons.save' => 'Save',
			'common.buttons.cancel' => 'Cancel',
			'common.buttons.delete' => 'Delete',
			'common.buttons.create' => 'Create',
			'common.buttons.edit' => 'Edit',
			'common.buttons.close' => 'Close',
			'common.buttons.confirm' => 'Confirm',
			'common.buttons.submit' => 'Submit',
			'common.buttons.retry' => 'Retry',
			'common.buttons.refresh' => 'Refresh',
			'common.buttons.search' => 'Search',
			'common.buttons.clear' => 'Clear',
			'common.buttons.copy' => 'Copy',
			'common.buttons.download' => 'Download',
			'common.buttons.upload' => 'Upload',
			'common.buttons.browse' => 'Browse',
			'common.buttons.update' => 'Update',
			'common.buttons.openDiagram' => 'Open diagram',
			'common.tabs.chat' => 'Chat',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => 'Files',
			'common.tabs.git' => 'Source Control',
			'common.tabs.tasks' => 'Tasks',
			'common.tabs.board' => 'Board',
			'common.tabs.browser' => 'Browser',
			'common.tabs.computer' => 'Computer',
			'common.tabs.usage' => 'AI Control',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => 'Overview',
			'common.quota.section.quotas' => 'Quotas',
			'common.quota.section.usage' => 'Usage',
			'common.quota.section.agents' => 'Agents',
			'common.quota.filter.all' => 'All',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 days',
			'common.quota.period.k30d' => '30 days',
			'common.quota.period.all' => 'All',
			'common.quota.group.provider' => 'Provider',
			'common.quota.group.model' => 'Model',
			'common.quota.group.agent' => 'Agent',
			'common.quota.group.tool' => 'Tool',
			'common.quota.metric.tokens' => 'Tokens',
			'common.quota.metric.input' => 'Input',
			'common.quota.metric.output' => 'Output',
			'common.quota.metric.cache' => 'Cache read',
			'common.quota.metric.calls' => 'API calls',
			'common.quota.metric.cost' => 'Cost',
			'common.quota.metric.sessions' => 'Sessions',
			'common.quota.cost.billed' => 'Billed (API + overage)',
			'common.quota.cost.listPrice' => 'List price of tokens used',
			'common.quota.cost.subscriptionValue' => 'Covered by subscriptions',
			'common.quota.cost.cacheSavings' => 'Cache savings',
			'common.quota.cost3.billed' => 'Billed (API + overage)',
			'common.quota.cost3.listPrice' => 'List price of tokens used',
			'common.quota.cost3.subscriptionValue' => 'Covered by subscriptions',
			'common.quota.overview.trendTitle' => 'Tokens and cost — last 7 days',
			'common.quota.overview.effectiveCost' => 'Effective cost (7 days)',
			'common.quota.overview.alertsTitle' => 'Alerts',
			'common.quota.overview.noAlerts' => 'Nothing needs attention right now.',
			'common.quota.overview.limitsTitle' => 'Usage and limits',
			'common.quota.overview.activeTasks' => 'Active tasks',
			'common.quota.overview.viewAccounts' => 'All accounts',
			'common.quota.overview.viewAgents' => 'All agents',
			'common.quota.overview.noTasks' => 'No agents are running right now.',
			'common.quota.usage.trendTitle' => 'Daily trend',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => 'Breakdown by ${group}',
			'common.quota.usage.colName' => 'Name',
			'common.quota.usage.sourceUnavailable' => 'Analytics store unavailable; showing no data.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} running',
			'common.quota.agents.colAgent' => 'Agent',
			'common.quota.agents.colStatus' => 'Status',
			'common.quota.agents.colTask' => 'Task',
			'common.quota.agents.colModel' => 'Account / model',
			'common.quota.agents.colTime' => 'Time',
			'common.quota.agents.empty' => 'No agents match this filter.',
			'common.quota.agents.detailSession' => 'Session',
			'common.quota.agents.detailStarted' => 'Started',
			'common.quota.agents.detailRetries' => 'Retries',
			'common.quota.agents.detailResult' => 'Result',
			'common.quota.agents.notTracked' => 'not tracked',
			'common.quota.agentStatus.running' => 'Running',
			'common.quota.agentStatus.waiting' => 'Waiting',
			'common.quota.agentStatus.failed' => 'Failed',
			'common.quota.agentStatus.finished' => 'Finished',
			'common.quota.agentStatus.queued' => 'Queued',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: at the current pace the limit runs out in ${value}',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% used (threshold ${watch}%)',
			'common.quota.backToChat' => 'Back to chat',
			'common.quota.syncNow' => 'Sync now',
			'common.quota.generatedAt' => ({required Object value}) => 'Updated ${value}',
			'common.quota.loading' => 'Loading account limits…',
			'common.quota.remaining' => ({required Object value}) => '${value}% left',
			'common.quota.resetsIn' => ({required Object value}) => 'reset in ${value}',
			'common.quota.projected' => ({required Object value}) => 'at the current pace this limit runs out in ${value}',
			'common.quota.syncedAgo' => ({required Object value}) => 'synced ${value} ago',
			'common.quota.refreshAccount' => 'Refresh account',
			'common.quota.syncFailed' => 'Synchronization failed',
			'common.quota.history' => 'History',
			'common.quota.historyPoints' => ({required Object value}) => '${value} readings recorded',
			'common.quota.historyEmpty' => 'No history recorded yet',
			'common.quota.noAgents' => 'No agents assigned',
			'common.quota.noSubscription' => 'No subscription',
			'common.quota.noSubscriptionHint' => 'The provider reports no active plan for this account.',
			'common.quota.quality.live' => 'Live',
			'common.quota.quality.cached' => 'Cached',
			'common.quota.quality.estimate' => 'Estimate',
			'common.quota.quality.unknown' => 'Unknown',
			'common.quota.quality.error' => 'Error',
			'common.quota.kpi.atRisk' => 'Limits at risk',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => 'accounts over ${value}%',
			'common.quota.kpi.windowsAtRisk' => 'Windows running out',
			'common.quota.kpi.errored' => 'Sync failures',
			'common.quota.kpi.activeAgents' => 'Active agents',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} waiting · ${queued} queued',
			'common.quota.kpi.nextReset' => 'Next reset',
			'common.quota.kpi.tokens' => 'Tokens',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} sessions',
			'common.quota.kpi.cost' => 'Estimated cost',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} covered by plans',
			'common.quota.empty.title' => 'No accounts connected',
			'common.quota.empty.description' => 'Sign in to Claude, Codex, Gemini or CommandCode so quota can be tracked here.',
			'common.quota.settings.title' => 'Alerting and routing',
			'common.quota.settings.description' => 'Control when the dashboard warns you and how accounts are suggested for new work.',
			'common.quota.settings.alertsEnabled' => 'Predictive and threshold alerts',
			'common.quota.settings.alertsEnabledHint' => 'Warn before a limit runs out at the current pace, not only at 90%.',
			'common.quota.settings.watchThreshold' => 'Watch threshold (%)',
			'common.quota.settings.dangerThreshold' => 'Danger threshold (%)',
			'common.quota.settings.routingMode' => 'Routing',
			'common.quota.settings.routing.manual' => 'Manual — recommendation only',
			'common.quota.settings.routing.ask' => 'Ask before switching account',
			'common.quota.settings.routing.autoLowRisk' => 'Auto-switch for low-risk tasks',
			'common.quota.settings.logSources' => 'Log sources',
			'common.quota.settings.logSourcesHint' => 'Usage and agent screens read these read-only sources.',
			'common.quota.settings.quotaConsent' => 'Allow quota polling',
			'common.quota.settings.quotaConsentHint' => 'Poll provider endpoints with your stored credentials to read live limits.',
			'common.quota.settings.perAccount' => 'Per-account overrides',
			'common.quota.settings.tab' => 'Control Center settings',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'All',
			'common.status.loading' => 'Loading...',
			'common.status.success' => 'Success',
			'common.status.error' => 'Error',
			'common.status.failed' => 'Failed',
			'common.status.pending' => 'Pending',
			'common.status.completed' => 'Completed',
			'common.status.inProgress' => 'In Progress',
			'common.messages.savedSuccessfully' => 'Saved successfully',
			'common.messages.deletedSuccessfully' => 'Deleted successfully',
			'common.messages.updatedSuccessfully' => 'Updated successfully',
			'common.messages.operationFailed' => 'Operation failed',
			'common.messages.networkError' => 'Network error. Please check your connection.',
			'common.messages.unauthorized' => 'Unauthorized. Please log in.',
			'common.messages.notFound' => 'Not found',
			'common.messages.invalidInput' => 'Invalid input',
			'common.messages.requiredField' => 'This field is required',
			'common.messages.unknownError' => 'An unknown error occurred',
			'common.messages.renameSessionFailed' => 'Failed to rename session. Please try again.',
			'common.navigation.settings' => 'Settings',
			'common.navigation.home' => 'Home',
			'common.navigation.back' => 'Back',
			'common.navigation.next' => 'Next',
			'common.navigation.previous' => 'Previous',
			'common.navigation.logout' => 'Logout',
			'common.common.language' => 'Language',
			'common.common.theme' => 'Theme',
			'common.common.darkMode' => 'Dark Mode',
			'common.common.lightMode' => 'Light Mode',
			'common.common.name' => 'Name',
			'common.common.description' => 'Description',
			'common.common.enabled' => 'Enabled',
			'common.common.disabled' => 'Disabled',
			'common.common.optional' => 'Optional',
			'common.common.version' => 'Version',
			'common.common.select' => 'Select',
			'common.common.selectAll' => 'Select All',
			'common.common.deselectAll' => 'Deselect All',
			'common.common.done' => 'Done',
			'common.common.failed' => 'Failed',
			'common.time.justNow' => 'Just now',
			'common.time.minutesAgo' => ({required Object count}) => '${count} mins ago',
			'common.time.hoursAgo' => ({required Object count}) => '${count} hours ago',
			'common.time.daysAgo' => ({required Object count}) => '${count} days ago',
			'common.time.yesterday' => 'Yesterday',
			'common.fileOperations.newFile' => 'New File',
			'common.fileOperations.newFolder' => 'New Folder',
			'common.fileOperations.rename' => 'Rename',
			'common.fileOperations.move' => 'Move',
			'common.fileOperations.copyPath' => 'Copy Path',
			'common.fileOperations.openInEditor' => 'Open in Editor',
			'common.mainContent.loading' => 'Loading ddagent',
			'common.mainContent.settingUpWorkspace' => 'Setting up your workspace...',
			'common.mainContent.chooseProject' => 'Choose Your Project',
			'common.mainContent.selectProjectDescription' => 'Pick a session in the Panel to start coding with Claude. Each project contains your chat sessions and file history.',
			'common.mainContent.tip' => 'Tip',
			'common.mainContent.createProjectMobile' => 'Tap the menu button above to access projects',
			'common.mainContent.createProjectDesktop' => 'Create a new project by clicking the folder icon in the sidebar',
			'common.mainContent.newSession' => 'New Session',
			'common.mainContent.untitledSession' => 'Untitled Session',
			'common.mainContent.projectFiles' => 'Project Files',
			'common.mainContent.focusMode' => 'Focus Mode (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Exit Focus Mode (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Split Session',
			'common.mainContent.closeSplitSession' => 'Close split session',
			'common.mainContent.chooseWorkspace' => 'Choose a workspace',
			'common.mainContent.chooseWorkspaceDescription' => 'Pick a workspace for this chat, or create a new one in Settings.',
			'common.mainContent.createWorkspace' => 'Create workspace in Settings',
			'common.mainContent.recentProjects' => 'Recent projects',
			'common.fileTree.loading' => 'Loading files...',
			'common.fileTree.files' => 'Files',
			'common.fileTree.simpleView' => 'Simple view',
			'common.fileTree.compactView' => 'Compact view',
			'common.fileTree.detailedView' => 'Detailed view',
			'common.fileTree.searchPlaceholder' => 'Search files and folders...',
			'common.fileTree.searchContentPlaceholder' => 'Search in files...',
			'common.fileTree.searchInFiles' => 'Search in files',
			'common.fileTree.searchByName' => 'Search by name',
			'common.fileTree.clearSearch' => 'Clear search',
			'common.fileTree.name' => 'Name',
			'common.fileTree.size' => 'Size',
			'common.fileTree.modified' => 'Modified',
			'common.fileTree.permissions' => 'Permissions',
			'common.fileTree.noFilesFound' => 'No files found',
			'common.fileTree.checkProjectPath' => 'Check if the project path is accessible',
			'common.fileTree.loadFailed' => 'Unable to load files',
			'common.fileTree.noMatchesFound' => 'No matches found',
			'common.fileTree.noSearchResults' => 'No matches found',
			'common.fileTree.tryDifferentSearch' => 'Try a different search term or clear the search',
			'common.fileTree.searchError' => 'Search failed',
			'common.fileTree.searching' => 'Searching...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Showing first ${count} results',
			'common.fileTree.justNow' => 'just now',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} min ago',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} hours ago',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} days ago',
			'common.fileTree.newFile' => 'New File (Cmd+N)',
			'common.fileTree.newFolder' => 'New Folder (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Refresh',
			'common.fileTree.collapseAll' => 'Collapse All',
			'common.fileTree.context.rename' => 'Rename',
			'common.fileTree.context.delete' => 'Delete',
			'common.fileTree.context.copyPath' => 'Copy Path',
			'common.fileTree.context.download' => 'Download',
			'common.fileTree.context.newFile' => 'New File',
			'common.fileTree.context.newFolder' => 'New Folder',
			'common.fileTree.context.upload' => 'Upload Files',
			'common.fileTree.context.refresh' => 'Refresh',
			'common.fileTree.context.menuLabel' => 'File context menu',
			'common.fileTree.context.loading' => 'Loading...',
			'common.fileTree.allWorkspaces' => 'All workspaces',
			'common.fileTree.delete.confirm' => 'Delete',
			'common.fileTree.delete.fileWarning' => 'This file will be permanently deleted.',
			'common.fileTree.delete.folderWarning' => 'This folder and all its contents will be permanently deleted.',
			'common.fileTree.delete.title' => ({required Object type}) => 'Delete ${type}',
			'common.fileTree.dropToUpload' => 'Drop files to upload',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => 'Drop files to upload to "${folder}"',
			'common.fileTree.noProject' => 'Add a project first',
			'common.fileTree.noRecentFiles' => 'No files changed in the last 7 days',
			'common.fileTree.showAllFiles' => 'Show all files',
			'common.fileTree.showAllFilesHint' => 'Turn off the recent filter to see everything.',
			'common.fileTree.showRecentOnly' => 'Show files changed in the last 7 days',
			'common.fileTree.toast.copyFailed' => 'Failed to copy path',
			'common.fileTree.toast.fileCreated' => 'File created successfully',
			'common.fileTree.toast.fileDeleted' => 'File deleted',
			'common.fileTree.toast.folderCreated' => 'Folder created successfully',
			'common.fileTree.toast.folderDeleted' => 'Folder deleted',
			'common.fileTree.toast.folderDownloaded' => 'Folder downloaded as ZIP',
			'common.fileTree.toast.pathCopied' => 'Path copied to clipboard',
			'common.fileTree.toast.renamed' => 'Renamed successfully',
			'common.fileTree.uploadComplete' => 'Upload complete',
			'common.fileTree.uploadFailed' => 'Upload failed',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Upload files (max ${size} each)',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Upload files to "${folder}"',
			'common.fileTree.uploadedCount' => ({required Object uploaded, required Object total, required Object label}) => 'Uploaded ${uploaded} of ${total} ${label}',
			'common.fileTree.uploadingFiles' => 'Uploading files',
			'common.fileTree.validation.dotsOnly' => 'Filename cannot be only dots',
			'common.fileTree.validation.emptyName' => 'Filename cannot be empty',
			'common.fileTree.validation.invalidChars' => 'Filename contains invalid characters',
			'common.fileTree.validation.reserved' => 'Filename is a reserved name',
			'common.projectWizard.title' => 'Create New Project',
			'common.projectWizard.steps.type' => 'Type',
			'common.projectWizard.steps.configure' => 'Configure',
			'common.projectWizard.steps.confirm' => 'Confirm',
			'common.projectWizard.step1.question' => 'Do you already have a workspace, or would you like to create a new one?',
			'common.projectWizard.step1.existing.title' => 'Existing Workspace',
			'common.projectWizard.step1.existing.description' => 'I already have a workspace on my server and just need to add it to the project list',
			'common.projectWizard.step1.kNew.title' => 'New Workspace',
			'common.projectWizard.step1.kNew.description' => 'Create a new workspace, optionally clone from a GitHub repository',
			'common.projectWizard.step2.existingPath' => 'Workspace Path',
			'common.projectWizard.step2.newPath' => 'Workspace Path',
			'common.projectWizard.step2.existingPlaceholder' => '/path/to/existing/workspace',
			'common.projectWizard.step2.newPlaceholder' => '/path/to/new/workspace',
			'common.projectWizard.step2.existingHelp' => 'Full path to your existing workspace directory',
			'common.projectWizard.step2.newHelp' => 'Full path to your workspace directory',
			'common.projectWizard.step2.githubUrl' => 'GitHub URL (Optional)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => 'Optional: provide a GitHub URL to clone a repository',
			'common.projectWizard.step2.githubAuth' => 'GitHub Authentication (Optional)',
			'common.projectWizard.step2.githubAuthHelp' => 'Only required for private repositories. Public repos can be cloned without authentication.',
			'common.projectWizard.step2.loadingTokens' => 'Loading stored tokens...',
			'common.projectWizard.step2.storedToken' => 'Stored Token',
			'common.projectWizard.step2.newToken' => 'New Token',
			'common.projectWizard.step2.nonePublic' => 'None (Public)',
			'common.projectWizard.step2.selectToken' => 'Select Token',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Select a token --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'This token will be used only for this operation',
			'common.projectWizard.step2.publicRepoInfo' => 'Public repositories don\'t require authentication. You can skip providing a token if cloning a public repo.',
			'common.projectWizard.step2.noTokensHelp' => 'No stored tokens available. You can add tokens in Settings → API Keys for easier reuse.',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHub Token (Optional for Public Repos)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (leave empty for public repos)',
			'common.projectWizard.step3.reviewConfig' => 'Review Your Configuration',
			'common.projectWizard.step3.existingWorkspace' => 'Existing Workspace',
			'common.projectWizard.step3.newWorkspace' => 'New Workspace',
			'common.projectWizard.step3.path' => 'Path:',
			'common.projectWizard.step3.cloneFrom' => 'Clone From:',
			'common.projectWizard.step3.authentication' => 'Authentication:',
			'common.projectWizard.step3.usingStoredToken' => 'Using stored token:',
			'common.projectWizard.step3.usingProvidedToken' => 'Using provided token',
			'common.projectWizard.step3.noAuthentication' => 'No authentication',
			'common.projectWizard.step3.sshKey' => 'SSH Key',
			'common.projectWizard.step3.existingInfo' => 'The workspace will be added to your project list and will be available for Claude/Cursor sessions.',
			'common.projectWizard.step3.newWithClone' => 'The repository will be cloned from this folder.',
			'common.projectWizard.step3.newEmpty' => 'The workspace will be added to your project list and will be available for Claude/Cursor sessions.',
			'common.projectWizard.step3.cloningRepository' => 'Cloning repository...',
			'common.projectWizard.buttons.cancel' => 'Cancel',
			'common.projectWizard.buttons.back' => 'Back',
			'common.projectWizard.buttons.next' => 'Next',
			'common.projectWizard.buttons.createProject' => 'Create Project',
			'common.projectWizard.buttons.creating' => 'Creating...',
			'common.projectWizard.buttons.cloning' => 'Cloning...',
			'common.projectWizard.errors.selectType' => 'Please select whether you have an existing workspace or want to create a new one',
			'common.projectWizard.errors.providePath' => 'Please provide a workspace path',
			'common.projectWizard.errors.failedToCreate' => 'Failed to create workspace',
			'common.projectWizard.errors.failedToCreateFolder' => 'Failed to create folder',
			'common.notifications.genericTool' => 'a tool',
			'common.notifications.codes.generic.info.title' => 'Notification',
			'common.notifications.codes.permission.required.title' => 'Action Required',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} is waiting for your decision.',
			'common.notifications.codes.run.stopped.title' => 'Run Stopped',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Reason: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Run Failed',
			'common.notifications.codes.agent.notification.title' => 'Agent Notification',
			'common.versionUpdate.title' => 'Update Available',
			'common.versionUpdate.newVersionReady' => 'A new version is ready',
			'common.versionUpdate.currentVersion' => 'Current Version',
			'common.versionUpdate.latestVersion' => 'Latest Version',
			'common.versionUpdate.whatsNew' => 'What\'s New:',
			'common.versionUpdate.viewFullRelease' => 'View full release',
			'common.versionUpdate.updateProgress' => 'Update Progress:',
			'common.versionUpdate.manualUpgrade' => 'Manual upgrade:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Or click "Update Now" to run the update automatically.',
			'common.versionUpdate.updateCompleted' => 'Update completed successfully!',
			'common.versionUpdate.restartServer' => 'Please restart the server to apply changes.',
			'common.versionUpdate.updateFailed' => 'Update failed',
			'common.versionUpdate.buttons.close' => 'Close',
			'common.versionUpdate.buttons.later' => 'Later',
			'common.versionUpdate.buttons.copyCommand' => 'Copy Command',
			'common.versionUpdate.buttons.updateNow' => 'Update Now',
			'common.versionUpdate.buttons.updating' => 'Updating...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Close version upgrade modal',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Show sidebar',
			'common.versionUpdate.ariaLabels.settings' => 'Settings',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Update available',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Close sidebar',
			'common.actions.cancel' => 'Cancel',
			'common.actions.retry' => 'Retry',
			'common.actions.save' => 'Save',
			'common.browserPane.address' => 'Address',
			'common.browserPane.back' => 'Back',
			'common.browserPane.connecting' => 'Connecting to browser…',
			'common.browserPane.connectionFailed' => 'Browser connection failed.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => 'Could not load ${url}',
			'common.browserPane.disconnected' => 'Browser view disconnected',
			'common.browserPane.enterUrl' => 'Enter URL',
			'common.browserPane.forward' => 'Forward',
			'common.browserPane.invalidUrl' => 'Enter a valid http(s) URL',
			'common.browserPane.noAuthToken' => 'No authentication token available.',
			'common.browserPane.openExternal' => 'Open in system browser',
			'common.browserPane.reload' => 'Reload',
			'common.browserPane.retry' => 'Retry',
			'common.browserPane.stop' => 'Stop',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} active',
			'common.browserUse.cancel' => 'Cancel',
			'common.browserUse.close' => 'Close',
			'common.browserUse.delete' => 'Delete',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} will be permanently deleted.',
			'common.browserUse.deleteSession' => 'Delete session',
			'common.browserUse.deleteTitle' => 'Delete browser session?',
			'common.browserUse.empty.descDisabled' => 'Enable Browser in settings to let agents open monitored browser sessions.',
			'common.browserUse.empty.descEnabled' => 'Agent browser sessions appear here while an AI task is using Browser.',
			'common.browserUse.empty.titleDisabled' => 'Browser is disabled',
			'common.browserUse.empty.titleEnabled' => 'No browser sessions yet',
			'common.browserUse.emptyStatus' => 'empty',
			'common.browserUse.errors.actionFailed' => 'Browser action failed',
			'common.browserUse.errors.loadFailed' => 'Failed to load Browser',
			'common.browserUse.fullscreen' => 'Full screen',
			'common.browserUse.installRuntime' => 'Install Runtime',
			'common.browserUse.installing' => 'Installing...',
			'common.browserUse.lastAction' => 'Last action',
			'common.browserUse.nextSnapshot' => 'The next agent browser snapshot will render here.',
			'common.browserUse.noPageLoaded' => 'No page loaded',
			'common.browserUse.noSessions' => 'No agent browser sessions.',
			'common.browserUse.none' => 'None',
			'common.browserUse.openSettings' => 'Open Browser settings',
			'common.browserUse.profile' => 'Profile',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Use Browser to inspect the checkout flow and report any broken UI states.',
			'common.browserUse.prompts.prompt2' => 'Open <url> with Browser, interact with the page, and summarize what changed after each step.',
			'common.browserUse.refresh' => 'Refresh browser sessions',
			'common.browserUse.relative.daysAgo' => 'd ago',
			'common.browserUse.relative.hoursAgo' => 'h ago',
			'common.browserUse.relative.justNow' => 'Just now',
			'common.browserUse.relative.minutesAgo' => 'm ago',
			'common.browserUse.relative.never' => 'Never',
			'common.browserUse.relative.secondsAgo' => 's ago',
			'common.browserUse.relative.unknown' => 'Unknown',
			'common.browserUse.runtime.disabled' => 'Disabled',
			'common.browserUse.runtime.installing' => 'Installing',
			'common.browserUse.runtime.ready' => 'Ready',
			'common.browserUse.runtime.setupRequired' => 'Setup required',
			'common.browserUse.runtimeSetup' => 'Runtime setup required',
			'common.browserUse.selected' => 'Selected',
			'common.browserUse.sessionFallback' => 'Browser session',
			'common.browserUse.sessionScreenshot' => 'Browser session screenshot',
			'common.browserUse.sessions' => 'Sessions',
			'common.browserUse.status' => 'Status',
			'common.browserUse.stop' => 'Stop',
			'common.browserUse.stopSession' => 'Stop session',
			'common.browserUse.subtitle' => 'Monitor browser sessions opened by AI agents.',
			'common.browserUse.temporary' => 'Temporary',
			'common.browserUse.thisSession' => 'This session',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '${count} total',
			'common.browserUse.updated' => ({required Object time}) => 'Updated ${time}',
			'common.browserUse.waiting' => 'Waiting',
			'common.browserUse.waitingForScreenshot' => 'Waiting for screenshot',
			'common.commandPalette.backToAll' => 'Back to all',
			'common.commandPalette.backspaceHint' => 'Backspace to go back',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Browse all branches (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Browse all commits (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Browse all files (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Browse all sessions (${count})',
			'common.commandPalette.compare.costNote' => 'Cost is a client-side estimate from published per-token rates; unknown models show “—”.',
			'common.commandPalette.compare.estCost' => 'Est. cost',
			'common.commandPalette.compare.inputOutput' => 'Input / Output',
			'common.commandPalette.compare.model' => 'Model',
			'common.commandPalette.compare.na' => 'N/A',
			'common.commandPalette.compare.openSplit' => 'Open in split view',
			'common.commandPalette.compare.provider' => 'Provider',
			'common.commandPalette.compare.selectSession' => 'Select a session…',
			'common.commandPalette.compare.tokensUsed' => 'Tokens used',
			'common.commandPalette.groups.actions' => 'Actions',
			'common.commandPalette.groups.branches' => 'Branches',
			'common.commandPalette.groups.commits' => 'Commits',
			'common.commandPalette.groups.files' => 'Files',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Navigate',
			'common.commandPalette.groups.sessions' => 'Sessions',
			'common.commandPalette.groups.settings' => 'Settings',
			'common.commandPalette.hints.close' => 'Close',
			'common.commandPalette.hints.navigate' => 'Navigate',
			'common.commandPalette.hints.select' => 'Select',
			'common.commandPalette.hints.togglePalette' => 'Toggle palette',
			'common.commandPalette.items.compareSessions' => 'Compare sessions',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Open settings',
			'common.commandPalette.items.selectProjectFirst' => 'Select a project first',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Settings: ${label}',
			'common.commandPalette.items.startNewChat' => 'Start new chat',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Switch to: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Toggle theme',
			'common.commandPalette.items.tokensAndCost' => 'tokens & cost',
			'common.commandPalette.nav.board' => 'Go to Agent Board',
			'common.commandPalette.nav.chat' => 'Go to Chat',
			'common.commandPalette.nav.files' => 'Go to Files',
			'common.commandPalette.nav.git' => 'Go to Git',
			'common.commandPalette.nav.sourceControl' => 'Go to Source Control',
			'common.commandPalette.nav.tasks' => 'Go to Tasks',
			'common.commandPalette.nav.usage' => 'Go to Quota & Usage',
			'common.commandPalette.noResults' => 'No results.',
			'common.commandPalette.pages.actions' => 'Actions',
			'common.commandPalette.pages.branches' => 'Branches',
			'common.commandPalette.pages.commits' => 'Commits',
			'common.commandPalette.pages.compare' => 'Compare',
			'common.commandPalette.pages.files' => 'Files',
			'common.commandPalette.pages.sessions' => 'Sessions',
			'common.commandPalette.placeholder' => 'Type to search anything…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => 'Search ${page}…',
			'common.commandPalette.title' => 'Command palette',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} ahead',
			'common.gitPanel.aheadLabel' => 'ahead',
			'common.gitPanel.aiSuggest' => 'AI suggest',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.aiSuggestTitle' => 'Generate a commit message with AI',
			'common.gitPanel.all' => 'All',
			'common.gitPanel.allStaged' => 'All changes staged',
			'common.gitPanel.behind' => ({required Object count}) => '${count} behind',
			'common.gitPanel.behindLabel' => 'behind',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'Delete branch "${branch}"? A normal delete only succeeds when the branch is fully merged. This cannot be undone.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'Switch to branch "${branch}"? Make sure you have no uncommitted changes.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} local, ${remote} remote',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} local',
			'common.gitPanel.branches.current' => 'current',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => 'Delete ${branch}',
			'common.gitPanel.branches.emptyDesc' => 'Create a branch to start parallel work.',
			'common.gitPanel.branches.forceDelete' => 'Force delete',
			'common.gitPanel.branches.forceDeleteDesc' => 'Permanently removes the branch even when it contains commits that have not been merged elsewhere.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Force delete this unmerged branch',
			'common.gitPanel.branches.local' => 'Local',
			'common.gitPanel.branches.kNew' => 'New branch',
			'common.gitPanel.branches.noMatch' => 'No branches match your search',
			'common.gitPanel.branches.none' => 'No branches found',
			'common.gitPanel.branches.remote' => 'remote',
			'common.gitPanel.branches.kSwitch' => 'Switch',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => 'Switch to ${branch}',
			'common.gitPanel.cancel' => 'Cancel',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Changes (${count})',
			'common.gitPanel.clearSearch' => 'Clear search',
			'common.gitPanel.collapseDiff' => 'Collapse diff',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Commit Changes',
			'common.gitPanel.commitFiles' => ({required Object count}) => 'Commit ${count} file(s)',
			'common.gitPanel.committing' => 'Committing...',
			'common.gitPanel.confirmActions.commit' => 'Confirm',
			'common.gitPanel.confirmActions.delete' => 'Delete',
			'common.gitPanel.confirmActions.deleteBranch' => 'Delete',
			'common.gitPanel.confirmActions.discard' => 'Discard',
			'common.gitPanel.confirmActions.publish' => 'Publish',
			'common.gitPanel.confirmActions.pull' => 'Pull',
			'common.gitPanel.confirmActions.push' => 'Push',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Revert Commit',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => 'Commit ${count} file(s) with message: "${message}"?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'Delete untracked file "${file}"? This action cannot be undone.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => 'Discard all changes to "${file}"? This action cannot be undone.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'Publish branch "${branch}" to ${remote}?',
			'common.gitPanel.confirmPull' => ({required Object count, required Object remote}) => 'Pull ${count} commit(s) from ${remote}?',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => 'Push ${count} commit(s) to ${remote}?',
			'common.gitPanel.confirmRevert' => 'Revert the latest local commit? This removes the commit but keeps its changes staged.',
			'common.gitPanel.confirmTitles.commit' => 'Confirm Action',
			'common.gitPanel.confirmTitles.delete' => 'Delete File',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Delete Branch',
			'common.gitPanel.confirmTitles.discard' => 'Discard Changes',
			'common.gitPanel.confirmTitles.publish' => 'Publish Branch',
			'common.gitPanel.confirmTitles.pull' => 'Confirm Pull',
			'common.gitPanel.confirmTitles.push' => 'Confirm Push',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Revert Local Commit',
			'common.gitPanel.createBranch' => 'Create new branch',
			'common.gitPanel.creating' => 'Creating...',
			'common.gitPanel.delete' => 'Delete',
			'common.gitPanel.deleteUntracked' => 'Delete untracked file',
			'common.gitPanel.deselectAll' => 'Deselect All',
			'common.gitPanel.discard' => 'Discard',
			'common.gitPanel.discardChanges' => 'Discard changes',
			'common.gitPanel.dismiss' => 'Dismiss',
			'common.gitPanel.dismissError' => 'Dismiss error',
			'common.gitPanel.errors.createBranchFailed' => 'Create branch failed',
			'common.gitPanel.errors.createWorktreeFailed' => 'Failed to create worktree',
			'common.gitPanel.errors.deleteBranchFailed' => 'Delete branch failed',
			'common.gitPanel.errors.fetchFailed' => 'Fetch failed',
			'common.gitPanel.errors.initFailed' => 'Failed to initialize repository',
			'common.gitPanel.errors.initialCommitFailed' => 'Failed to create initial commit',
			'common.gitPanel.errors.mergeFailed' => 'Merge failed',
			'common.gitPanel.errors.openWorktreeFailed' => 'Failed to open worktree',
			'common.gitPanel.errors.operationFailed' => 'Git operation failed',
			'common.gitPanel.errors.publishFailed' => 'Publish failed',
			'common.gitPanel.errors.pullFailed' => 'Pull failed',
			'common.gitPanel.errors.pushFailed' => 'Push failed',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Failed to remove worktree',
			'common.gitPanel.errors.stageFailed' => 'Stage failed',
			'common.gitPanel.errors.stageHunksFailed' => 'Stage hunks failed',
			'common.gitPanel.errors.switchFailed' => 'Switch branch failed',
			'common.gitPanel.errors.unstageFailed' => 'Unstage failed',
			'common.gitPanel.errors.unstageHunksFailed' => 'Unstage hunks failed',
			'common.gitPanel.expandDiff' => 'Expand diff',
			'common.gitPanel.fetch' => 'Fetch',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => 'Fetch from ${remote}',
			'common.gitPanel.fetching' => 'Fetching…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} file(s) selected',
			'common.gitPanel.generating' => 'Generating...',
			'common.gitPanel.history.added' => 'Added',
			'common.gitPanel.history.author' => 'Author',
			'common.gitPanel.history.changedFiles' => 'Changed Files',
			'common.gitPanel.history.date' => 'Date',
			'common.gitPanel.history.empty' => 'No commits found',
			'common.gitPanel.history.files' => 'Files',
			'common.gitPanel.history.removed' => 'Removed',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Remove the worktree and delete its branch once merged',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Clean up after merge',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} commit(s)',
			'common.gitPanel.mergeWorktree.merge' => 'Merge',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'Merge branch \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => 'Commit message',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => 'Combine all ${commits} into a single commit on ${branch}',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Squash commits',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squash & Merge',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'Squash merge branch \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => 'Merge Worktree',
			'common.gitPanel.merging' => 'Merging...',
			'common.gitPanel.messagePlaceholder' => 'Message (Ctrl+Enter to commit)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'This will create a new branch from the current branch (${branch})',
			'common.gitPanel.newBranch.nameLabel' => 'Branch Name',
			'common.gitPanel.newBranch.submit' => 'Create Branch',
			'common.gitPanel.newBranch.title' => 'Create New Branch',
			'common.gitPanel.newWorktree.branchLabel' => 'Branch',
			'common.gitPanel.newWorktree.createFrom' => 'Create from',
			'common.gitPanel.newWorktree.description' => 'Check out a branch in its own folder and work on it in parallel.',
			'common.gitPanel.newWorktree.existingBranch' => 'Existing branch — it will be checked out as-is.',
			'common.gitPanel.newWorktree.submit' => 'Create Worktree',
			'common.gitPanel.newWorktree.switchAfter' => 'Switch to the worktree after creating it',
			'common.gitPanel.newWorktree.title' => 'New Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Will be created in',
			'common.gitPanel.noChanges' => 'No changes detected',
			'common.gitPanel.noChangesToCommit' => 'No changes to commit',
			'common.gitPanel.noCommits.create' => 'Create Initial Commit',
			'common.gitPanel.noCommits.creating' => 'Creating Initial Commit...',
			'common.gitPanel.noCommits.description' => 'This repository doesn\'t have any commits yet. Create your first commit to start tracking changes.',
			'common.gitPanel.noCommits.title' => 'No commits yet',
			'common.gitPanel.noMatchingBranches' => 'No matching branches',
			'common.gitPanel.noRepo.description' => 'This project is not a git repository yet. Initialize one to start tracking changes and use source control features.',
			'common.gitPanel.noRepo.init' => 'Run git init',
			'common.gitPanel.noRepo.initializing' => 'Initializing repository...',
			'common.gitPanel.noRepo.title' => 'No git repository',
			'common.gitPanel.noStagedFiles' => 'No staged files',
			'common.gitPanel.none' => 'None',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => 'Nothing to push to ${remote}',
			'common.gitPanel.openFile' => 'Click to open file',
			'common.gitPanel.publish' => 'Publish',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => 'Publish "${branch}" to ${remote}',
			'common.gitPanel.publishing' => 'Publishing…',
			'common.gitPanel.pull' => 'Pull',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Pull ${count}',
			'common.gitPanel.pullTitle' => ({required Object count, required Object remote}) => 'Pull ${count} from ${remote}',
			'common.gitPanel.pulling' => 'Pulling…',
			'common.gitPanel.push' => 'Push',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Push ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => 'Push ${count} to ${remote}',
			'common.gitPanel.pushing' => 'Pushing…',
			'common.gitPanel.recentCommits' => 'Recent commits',
			'common.gitPanel.refresh' => 'Refresh git status',
			'common.gitPanel.remove' => 'Remove',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Also delete branch',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => 'Remove the worktree for ${branch}? Its folder is deleted and the linked project is archived — chat sessions stay recoverable.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'This worktree has ${count} uncommitted change(s) that will be lost.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Discard uncommitted changes',
			'common.gitPanel.removeWorktree.title' => 'Remove Worktree',
			'common.gitPanel.removing' => 'Removing...',
			'common.gitPanel.revertLatest' => 'Revert latest local commit',
			'common.gitPanel.scroll' => 'Scroll',
			'common.gitPanel.searchBranches' => 'Search branches...',
			'common.gitPanel.selectAll' => 'Select All',
			'common.gitPanel.selectProject' => 'Select a project to view source control',
			'common.gitPanel.selectedOf' => ({required Object selected, required Object total}) => '${selected} of ${total} files selected',
			'common.gitPanel.selectedOfMobile' => ({required Object selected, required Object total}) => '${selected} of ${total} selected',
			'common.gitPanel.sideBySide' => 'Side-by-side',
			'common.gitPanel.stageAll' => 'Stage All',
			'common.gitPanel.stageHunk' => 'Stage this hunk',
			'common.gitPanel.staged' => ({required Object count}) => 'Staged (${count})',
			'common.gitPanel.status.added' => 'Added',
			'common.gitPanel.status.deleted' => 'Deleted',
			'common.gitPanel.status.modified' => 'Modified',
			'common.gitPanel.status.untracked' => 'Untracked',
			'common.gitPanel.statusGuide' => 'File Status Guide',
			'common.gitPanel.switchScroll' => 'Switch to horizontal scroll',
			'common.gitPanel.switchSplit' => 'Switch to side-by-side view',
			'common.gitPanel.switchUnified' => 'Switch to unified view',
			'common.gitPanel.switchWrap' => 'Switch to text wrap',
			'common.gitPanel.unified' => 'Unified',
			'common.gitPanel.unstageAll' => 'Unstage All',
			'common.gitPanel.unstageHunk' => 'Unstage this hunk',
			'common.gitPanel.upToDate' => 'Up to date',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => 'Up to date with ${remote}',
			'common.gitPanel.viewAll' => 'View all',
			'common.gitPanel.viewsAria' => 'Source control views',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} change(s)',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree(s)',
			'common.gitPanel.worktrees.createFirst' => 'Create your first worktree',
			'common.gitPanel.worktrees.detached' => 'detached',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'detached @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'detached HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'A worktree checks out a branch in its own folder, so you can run separate chat sessions side by side and merge the results back when they\'re ready.',
			'common.gitPanel.worktrees.emptyTitle' => 'Work on branches in parallel',
			'common.gitPanel.worktrees.locked' => 'locked',
			'common.gitPanel.worktrees.mainWorktree' => 'main worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => 'Merge ${branch} into the base branch',
			'common.gitPanel.worktrees.kNew' => 'New worktree',
			'common.gitPanel.worktrees.none' => 'No worktrees',
			'common.gitPanel.worktrees.nothingToMerge' => 'Nothing to merge — no commits ahead of the base branch',
			'common.gitPanel.worktrees.open' => 'Open',
			'common.gitPanel.worktrees.refresh' => 'Refresh worktrees',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => 'Remove worktree for ${branch}',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => 'Switch to ${branch}',
			'common.gitPanel.wrap' => 'Wrap',
			'common.gitPanel.tabs.changes' => 'Changes',
			'common.gitPanel.tabs.history' => 'Commits',
			'common.gitPanel.tabs.branches' => 'Branches',
			'common.gitPanel.tabs.worktrees' => 'Worktrees',
			'common.gitPanel.save' => 'Save',
			'common.gitPanel.worktreeScripts.title' => 'Worktree scripts',
			'common.gitPanel.worktreeScripts.setup' => 'Setup script (runs after create/open)',
			'common.gitPanel.worktreeScripts.run' => 'Run dev server',
			'common.gitPanel.worktreeScripts.stop' => 'Stop dev server',
			'common.gitPanel.worktreeScripts.runScript' => 'Run script (dev server, on demand)',
			'common.gitPanel.worktreeScripts.runPort' => 'Preview port (optional — auto-detected when empty)',
			'common.gitPanel.worktreeScripts.invalidPort' => 'Port must be between 1 and 65535',
			'common.gitPanel.worktreeScripts.sourceProject' => 'Saved as a project override',
			'common.gitPanel.worktreeScripts.sourceFile' => 'From .ddagent/worktree.json — saving creates a project override',
			'common.gitPanel.worktreeScripts.sourceNone' => 'Nothing configured yet',
			'common.gitPanel.worktreeScripts.saving' => 'Saving…',
			'common.gitPanel.worktreeScripts.setupRunning' => 'setup running',
			'common.gitPanel.worktreeScripts.setupFailed' => 'setup failed',
			'common.gitPanel.worktreeScripts.running' => 'running',
			'common.gitPanel.worktreeScripts.openPreview' => 'Open preview',
			'common.gitPanel.worktreeScripts.runExited' => ({required Object code}) => 'run exited (${code})',
			'common.sessions.renameSession' => 'Rename session',
			'common.projects.newSession' => 'New Session',
			'common.previewPane.loadError' => 'Could not load ports',
			'common.previewPane.noServers' => 'No dev servers detected',
			'common.previewPane.openExternal' => 'Open in system browser',
			'common.previewPane.reload' => 'Reload preview',
			'common.previewPane.selectPort' => 'Dev server port',
			'common.previewPane.title' => 'Dev server preview',
			'common.sharedNotes.subtitle' => 'Shared memory — injected into every session of this project',
			'common.sharedNotes.save' => 'Save',
			'common.sharedNotes.saving' => 'Saving…',
			'common.sharedNotes.noProject' => 'Select a workspace to edit its shared context',
			'common.sharedNotes.placeholder' => '# Shared context\nConventions, decisions and pointers every agent should know…',
			'common.codeBlock.wrapLines' => 'Wrap lines',
			'common.codeBlock.noWrap' => 'No wrap',
			'common.update.available' => ({required Object version}) => 'Update available · v${version}',
			'common.update.confirm' => ({required Object version}) => 'Update to v${version}? The server updates itself and restarts — active sessions will be interrupted.',
			'common.update.downloading' => 'Downloading and applying the update…',
			'common.update.restarting' => 'Restarting the server — this takes a moment…',
			'common.update.done' => ({required Object version}) => 'Updated to v${version}. Reload the app to pick up the new bundle.',
			'common.update.manualRestart' => 'The update was applied but the server did not restart on its own — restart it manually to finish.',
			'common.update.failed' => 'Update failed.',
			'common.update.failedTitle' => 'Update failed',
			'common.update.appConfirm' => ({required Object version}) => 'Install ddagent v${version} on this device? Android will ask you to allow installs from ddagent the first time.',
			'common.update.appPermission' => 'Allow “Install unknown apps” for ddagent, then tap Update again.',
			'settings.title' => 'Settings',
			'settings.changelog.title' => 'Changelog',
			'settings.changelog.loading' => 'Loading…',
			'settings.changelog.empty' => 'No releases to show',
			'settings.changelog.current' => 'current',
			'settings.changelog.kNew' => 'new',
			'settings.server.title' => 'Server',
			'settings.server.description' => 'Restart the ddagent process to apply updates or recover from a stuck state.',
			'settings.server.restart' => 'Restart',
			'settings.server.restartConfirm' => 'Restart the ddagent server? Active sessions will be interrupted.',
			'settings.server.restarting' => 'Restarting… the page will reload when the server is back.',
			'settings.server.restartFailed' => 'Restart failed',
			'settings.server.unsupported' => 'Restart is only available when the server runs under the service manager.',
			'settings.server.ok' => 'OK',
			'settings.updates.title' => 'App updates',
			'settings.updates.description' => 'Check GitHub for a newer desktop build. New versions download automatically and install when you quit.',
			'settings.updates.descriptionMobile' => 'Check GitHub for a newer build of this app. Updates are installed by your device\'s system installer.',
			'settings.updates.check' => 'Check for updates',
			'settings.updates.checking' => 'Checking…',
			'settings.updates.upToDate' => ({required Object version}) => 'You are on the latest version (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Update v${version} found — downloading in the background; it installs when you quit ddagent.',
			'settings.updates.appAvailable' => ({required Object version}) => 'App update v${version} available — tap Update to install it on this device.',
			'settings.updates.downloaded' => ({required Object version}) => 'Update v${version} downloaded — quit and relaunch ddagent to install.',
			'settings.updates.unavailable' => 'Update checks are only available in packaged desktop builds.',
			'settings.updates.error' => ({required Object message}) => 'Update check failed: ${message}',
			'settings.updates.errorGeneric' => 'Update check failed.',
			'settings.tabs.account' => 'Account',
			'settings.tabs.permissions' => 'Permissions',
			'settings.tabs.mcpServers' => 'MCP Servers',
			'settings.tabs.skills' => 'Skills',
			'settings.tabs.appearance' => 'Appearance',
			'settings.account.title' => 'Account',
			'settings.account.language' => 'Language',
			'settings.account.languageLabel' => 'Display Language',
			'settings.account.languageDescription' => 'Choose your preferred language for the interface',
			'settings.account.username' => 'Username',
			'settings.account.email' => 'Email',
			'settings.account.profile' => 'Profile',
			'settings.account.changePassword' => 'Change Password',
			'settings.mcp.title' => 'MCP Servers',
			'settings.mcp.addServer' => 'Add Server',
			'settings.mcp.editServer' => 'Edit Server',
			'settings.mcp.deleteServer' => 'Delete Server',
			'settings.mcp.serverName' => 'Server Name',
			'settings.mcp.serverType' => 'Server Type',
			'settings.mcp.config' => 'Configuration',
			'settings.mcp.testConnection' => 'Test Connection',
			'settings.mcp.status' => 'Status',
			'settings.mcp.connected' => 'Connected',
			'settings.mcp.disconnected' => 'Disconnected',
			'settings.mcp.scope.label' => 'Scope',
			'settings.mcp.scope.user' => 'User',
			'settings.mcp.scope.project' => 'Project',
			'settings.appearance.title' => 'Appearance',
			'settings.appearance.theme' => 'Theme',
			'settings.appearance.codeEditor' => 'Code Editor',
			'settings.appearance.editorTheme' => 'Editor Theme',
			'settings.appearance.wordWrap' => 'Word Wrap',
			'settings.appearance.showMinimap' => 'Show Minimap',
			'settings.appearance.lineNumbers' => 'Line Numbers',
			'settings.appearance.fontSize' => 'Font Size',
			'settings.appearance.themeModes.system' => 'System',
			'settings.appearance.themeModes.light' => 'Light',
			'settings.appearance.themeModes.dark' => 'Dark',
			'settings.actions.saveChanges' => 'Save Changes',
			'settings.actions.resetToDefaults' => 'Reset to Defaults',
			'settings.actions.cancelChanges' => 'Cancel Changes',
			'settings.quickSettings.title' => 'Quick Settings',
			'settings.quickSettings.sections.appearance' => 'Appearance',
			'settings.quickSettings.sections.toolDisplay' => 'Tool Display',
			'settings.quickSettings.sections.inputSettings' => 'Input Settings',
			'settings.quickSettings.darkMode' => 'Dark Mode',
			'settings.quickSettings.showRawParameters' => 'Show raw parameters',
			'settings.quickSettings.showThinking' => 'Show thinking',
			'settings.quickSettings.sendByCtrlEnter' => 'Send by Ctrl+Enter',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'When enabled, pressing Ctrl+Enter will send the message instead of just Enter. This is useful for IME users to avoid accidental sends.',
			'settings.quickSettings.dragHandle.dragging' => 'Dragging handle',
			'settings.quickSettings.dragHandle.closePanel' => 'Close settings panel',
			'settings.quickSettings.dragHandle.openPanel' => 'Open settings panel',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Dragging...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Click to toggle, drag to move',
			'settings.quickSettings.sendWithCtrlEnter' => 'Send with Ctrl+Enter',
			'settings.terminalShortcuts.title' => 'Terminal Shortcuts',
			'settings.terminalShortcuts.sectionKeys' => 'Keys',
			'settings.terminalShortcuts.sectionNavigation' => 'Navigation',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Arrow Up',
			'settings.terminalShortcuts.arrowDown' => 'Arrow Down',
			'settings.terminalShortcuts.scrollDown' => 'Scroll Down',
			'settings.terminalShortcuts.killTitle' => 'Kill running process (Ctrl+C)',
			'settings.terminalShortcuts.handle.closePanel' => 'Close shortcuts panel',
			'settings.terminalShortcuts.handle.openPanel' => 'Open shortcuts panel',
			'settings.terminalShortcuts.paste' => 'Paste',
			'settings.mainTabs.label' => 'Settings',
			'settings.mainTabs.agents' => 'Agents',
			'settings.mainTabs.orchestration' => 'Orchestration',
			'settings.mainTabs.miniOrchestration' => 'Mini orchestration',
			'settings.mainTabs.appearance' => 'Appearance',
			'settings.mainTabs.workspaces' => 'Workspaces',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API & Tokens',
			'settings.mainTabs.models' => 'Models',
			'settings.mainTabs.tasks' => 'Tasks',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Tools',
			'settings.mainTabs.notifications' => 'Notifications',
			'settings.mainTabs.about' => 'About',
			'settings.mainTabs.quota' => 'Control Center',
			'settings.mainTabs.shortcuts' => 'Keyboard shortcuts',
			'settings.miniOrchestration.title' => 'Mini orchestration',
			'settings.miniOrchestration.description' => 'A two-model pipeline: a non-flash thinker plans, a flash worker executes.',
			'settings.miniOrchestration.loading' => 'Loading mini orchestration settings…',
			'settings.miniOrchestration.loadError' => 'Could not load the mini orchestration settings.',
			'settings.miniOrchestration.enable.label' => 'Enable mini orchestration',
			'settings.miniOrchestration.enable.description' => 'Route Auto (mini) sessions through the two-role engine instead of the full orchestrator.',
			'settings.miniOrchestration.thinker.title' => 'Thinker (non-flash)',
			'settings.miniOrchestration.thinker.description' => 'Plans, decides, reviews and writes the final report.',
			'settings.miniOrchestration.worker.title' => 'Worker (flash)',
			'settings.miniOrchestration.worker.description' => 'Executes each planned step.',
			'settings.miniOrchestration.fields.provider' => 'Provider',
			'settings.miniOrchestration.fields.model' => 'Model',
			'settings.miniOrchestration.fields.modelPlaceholder' => 'Model id',
			'settings.miniOrchestration.fields.tier' => 'Tier',
			'settings.miniOrchestration.roles.title' => 'Per-task model',
			'settings.miniOrchestration.roles.description' => 'Which model (role) handles each task type.',
			'settings.miniOrchestration.planner.title' => 'Planner',
			'settings.miniOrchestration.planner.mode' => 'Mode',
			'settings.miniOrchestration.planner.modes.auto' => 'Plan with the thinker',
			'settings.miniOrchestration.planner.modes.off' => 'Single step',
			'settings.miniOrchestration.planner.requireConfirmLabel' => 'Confirm the plan before running',
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
			'settings.orchestration.pool.fields.redundantAccounts' => 'Redundant accounts',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'No other accounts for this provider',
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
			'settings.orchestration.rules.taskTypes.report' => 'Report',
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
			'settings.orchestration.planner.checkpointLabel' => 'Autonomy',
			'settings.orchestration.planner.checkpointModes.off' => 'Autonomous',
			'settings.orchestration.planner.checkpointModes.perStep' => 'Per step',
			'settings.orchestration.planner.checkpointModes.everyN' => 'Every N',
			'settings.orchestration.planner.checkpointHints.off' => 'Supervisor decisions run without asking (auto mode).',
			'settings.orchestration.planner.checkpointHints.perStep' => 'Ask for approval before every proposed step batch.',
			'settings.orchestration.planner.checkpointHints.everyN' => 'Ask for approval after every N completed steps.',
			'settings.orchestration.planner.checkpointIntervalLabel' => 'Steps between checkpoints (1–50)',
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
			'settings.orchestration.execution.maxSupervisorIterations' => 'Max supervisor iterations',
			'settings.orchestration.execution.maxSupervisorIterationsDescription' => 'Cap on supervisor decision rounds in auto mode (1–100); reaching it ends the run with a partial report.',
			'settings.orchestration.execution.maxAttempts' => 'Max attempts per step',
			'settings.orchestration.execution.maxAttemptsDescription' => 'Total attempt budget for one step across lanes and retries (1–50).',
			'settings.orchestration.execution.stepTimeoutMs' => 'Step timeout (ms)',
			'settings.orchestration.execution.stepTimeoutMsDescription' => 'Per-attempt child-run timeout in milliseconds; 0 disables.',
			'settings.orchestration.execution.runTimeoutMs' => 'Run timeout (ms)',
			'settings.orchestration.execution.runTimeoutMsDescription' => 'Global plan-run timeout in milliseconds; 0 disables.',
			'settings.orchestration.execution.retryBackoffBaseMs' => 'Retry backoff base (ms)',
			'settings.orchestration.execution.retryBackoffBaseMsDescription' => 'Base of the exponential backoff between same-lane retries (full jitter).',
			'settings.orchestration.execution.retryBudgetTitle' => 'Retry budget per failure class',
			'settings.orchestration.execution.retryBudgetDescription' => 'Same-lane retries before failover/cooldown (0–5).',
			'settings.orchestration.execution.retryClasses.rateLimit' => 'Rate limit',
			'settings.orchestration.execution.retryClasses.quota' => 'Quota',
			'settings.orchestration.execution.retryClasses.auth' => 'Auth',
			'settings.orchestration.execution.retryClasses.timeout' => 'Timeout',
			'settings.orchestration.execution.retryClasses.transient' => 'Transient',
			'settings.orchestration.save.unsaved' => 'Unsaved changes',
			'settings.orchestration.save.save' => 'Save',
			'settings.orchestration.save.saving' => 'Saving…',
			'settings.orchestration.save.saved' => 'Saved',
			'settings.orchestration.save.discard' => 'Discard',
			'settings.orchestration.save.error' => 'Save failed',
			'settings.orchestration.save.emptyPool' => 'Add at least one candidate before saving.',
			'settings.notifications.title' => 'Notifications',
			'settings.notifications.description' => 'Control which notification events you receive.',
			'settings.notifications.webPush.title' => 'Notify this browser',
			'settings.notifications.webPush.enable' => 'Enable notifications',
			'settings.notifications.webPush.disable' => 'Disable notifications',
			'settings.notifications.webPush.enabled' => 'Notifications are enabled for this browser',
			'settings.notifications.webPush.loading' => 'Updating...',
			'settings.notifications.webPush.unsupported' => 'Push notifications are not supported in this browser.',
			'settings.notifications.webPush.denied' => 'Push notifications are blocked. Please allow them in your browser settings.',
			'settings.notifications.webPush.iosHint' => 'On iPhone/iPad, notifications only work after adding ddagent to the home screen (Share → Add to Home Screen) and enabling them from that installed app.',
			'settings.notifications.webPush.test' => 'Send test notification',
			'settings.notifications.webPush.testNoSubscription' => 'No device is subscribed. Tap "Enable" on the phone first.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Sent to ${count} device(s). If nothing appeared on the phone, add ddagent to the home screen (iOS requires this).',
			'settings.notifications.webPush.testNotDelivered' => 'No device was reachable. Make sure the app is running and notifications are enabled.',
			'settings.notifications.device.title' => 'Notify this device',
			'settings.notifications.device.enabled' => 'Notifications are enabled for this device',
			'settings.notifications.desktop.title' => 'Notify this desktop app',
			'settings.notifications.desktop.enable' => 'Enable notifications',
			'settings.notifications.desktop.disable' => 'Disable notifications',
			'settings.notifications.desktop.enabled' => 'Notifications are enabled for this desktop app',
			'settings.notifications.desktop.unsupported' => 'Desktop notifications are not supported on this system.',
			'settings.notifications.sound.title' => 'Sound',
			'settings.notifications.sound.description' => 'Play a short tone when a chat run finishes or needs tool approval.',
			_ => null,
		} ?? switch (path) {
			'settings.notifications.sound.enabled' => 'Enabled',
			'settings.notifications.sound.test' => 'Test sound',
			'settings.notifications.events.title' => 'Event Types',
			'settings.notifications.events.actionRequired' => 'Action required',
			'settings.notifications.events.stop' => 'Run stopped',
			'settings.notifications.events.error' => 'Run failed',
			'settings.notifications.messaging.title' => 'Messenger approvals',
			'settings.notifications.messaging.description' => 'Approve or deny agent permission requests from Telegram, and get run notifications on Discord.',
			'settings.notifications.messaging.enabled' => 'Enabled',
			'settings.notifications.messaging.save' => 'Save',
			'settings.notifications.messaging.test' => 'Test',
			'settings.notifications.messaging.pair' => 'Pair',
			'settings.notifications.messaging.telegramToken' => 'Bot token from @BotFather (123456:ABC…)',
			'settings.notifications.messaging.telegramHint' => 'Send any message to your bot, then pair the chat below.',
			'settings.notifications.messaging.discordWebhook' => 'https://discord.com/api/webhooks/…',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.unpair' => 'Unpair',
			'settings.appearanceSettings.darkMode.label' => 'Dark Mode',
			'settings.appearanceSettings.darkMode.description' => 'Toggle between light and dark themes',
			'settings.appearanceSettings.codeEditor.title' => 'Code Editor',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Editor Theme',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Default theme for the code editor',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Word Wrap',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Enable word wrapping by default in the editor',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Show Minimap',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Display a minimap for easier navigation in diff view',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Show Line Numbers',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Display line numbers in the editor',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Font Size',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Editor font size in pixels',
			'settings.appearanceSettings.terminal.title' => 'Terminal',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Focus follows pointer',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Focus the terminal for typing when you move the mouse over it',
			'settings.mcpForm.title.add' => 'Add MCP Server',
			'settings.mcpForm.title.edit' => 'Edit MCP Server',
			'settings.mcpForm.importMode.form' => 'Form Input',
			'settings.mcpForm.importMode.json' => 'JSON Import',
			'settings.mcpForm.scope.label' => 'Scope',
			'settings.mcpForm.scope.userGlobal' => 'User (Global)',
			'settings.mcpForm.scope.projectLocal' => 'Project (Local)',
			'settings.mcpForm.scope.userDescription' => 'User scope: Available across all projects on your machine',
			'settings.mcpForm.scope.projectDescription' => 'Local scope: Only available in the selected project',
			'settings.mcpForm.scope.cannotChange' => 'Scope cannot be changed when editing an existing server',
			'settings.mcpForm.fields.serverName' => 'Server Name',
			'settings.mcpForm.fields.transportType' => 'Transport Type',
			'settings.mcpForm.fields.command' => 'Command',
			'settings.mcpForm.fields.arguments' => 'Arguments (one per line)',
			'settings.mcpForm.fields.jsonConfig' => 'JSON Configuration',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Environment Variables (KEY=value, one per line)',
			'settings.mcpForm.fields.headers' => 'Headers (KEY=value, one per line)',
			'settings.mcpForm.fields.selectProject' => 'Select a project...',
			'settings.mcpForm.placeholders.serverName' => 'my-server',
			'settings.mcpForm.validation.missingType' => 'Missing required field: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdio type requires a command field',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type} type requires a url field',
			'settings.mcpForm.validation.invalidJson' => 'Invalid JSON format',
			'settings.mcpForm.validation.jsonHelp' => 'Paste your MCP server configuration in JSON format. Example formats:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Configuration Details (from ${configFile})',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Path: ${path}',
			'settings.mcpForm.actions.cancel' => 'Cancel',
			'settings.mcpForm.actions.saving' => 'Saving...',
			'settings.mcpForm.actions.addServer' => 'Add Server',
			'settings.mcpForm.actions.updateServer' => 'Update Server',
			'settings.saveStatus.success' => 'Settings saved successfully!',
			'settings.saveStatus.error' => 'Failed to save settings',
			'settings.saveStatus.saving' => 'Saving...',
			'settings.footerActions.save' => 'Save Settings',
			'settings.footerActions.cancel' => 'Cancel',
			'settings.git.title' => 'Git Configuration',
			'settings.git.description' => 'Configure your git identity for commits. These settings will be applied globally via git config --global',
			'settings.git.name.label' => 'Git Name',
			'settings.git.name.help' => 'Your name for git commits',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'Git Email',
			'settings.git.email.help' => 'Your email for git commits',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Save Configuration',
			'settings.git.actions.saving' => 'Saving...',
			'settings.git.status.success' => 'Saved successfully',
			'settings.git.status.error' => 'Failed to save',
			'settings.apiKeys.title' => 'API Keys',
			'settings.apiKeys.description' => 'Generate API keys to access the external API from other applications.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ Save Your API Key',
			'settings.apiKeys.newKey.alertMessage' => 'This is the only time you\'ll see this key. Store it securely.',
			'settings.apiKeys.newKey.iveSavedIt' => 'I\'ve saved it',
			'settings.apiKeys.form.placeholder' => 'API Key Name (e.g., Production Server)',
			'settings.apiKeys.form.createButton' => 'Create',
			'settings.apiKeys.form.cancelButton' => 'Cancel',
			'settings.apiKeys.newButton' => 'New API Key',
			'settings.apiKeys.empty' => 'No API keys created yet.',
			'settings.apiKeys.list.created' => 'Created:',
			'settings.apiKeys.list.lastUsed' => 'Last used:',
			'settings.apiKeys.confirmDelete' => 'Are you sure you want to delete this API key?',
			'settings.apiKeys.status.active' => 'Active',
			'settings.apiKeys.status.inactive' => 'Inactive',
			'settings.apiKeys.github.title' => 'GitHub Tokens',
			'settings.apiKeys.github.description' => 'Add GitHub Personal Access Tokens to clone private repositories via the external API.',
			'settings.apiKeys.github.descriptionAlt' => 'Add GitHub Personal Access Tokens to clone private repositories. You can also pass tokens directly in API requests without storing them.',
			'settings.apiKeys.github.addButton' => 'Add Token',
			'settings.apiKeys.github.form.namePlaceholder' => 'Token Name (e.g., Personal Repos)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHub Personal Access Token (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Description (optional)',
			'settings.apiKeys.github.form.addButton' => 'Add Token',
			'settings.apiKeys.github.form.cancelButton' => 'Cancel',
			'settings.apiKeys.github.form.howToCreate' => 'How to create a GitHub Personal Access Token →',
			'settings.apiKeys.github.form.showToken' => 'Show token',
			'settings.apiKeys.github.form.hideToken' => 'Hide token',
			'settings.apiKeys.github.empty' => 'No GitHub tokens added yet.',
			'settings.apiKeys.github.added' => 'Added:',
			'settings.apiKeys.github.confirmDelete' => 'Are you sure you want to delete this GitHub token?',
			'settings.apiKeys.apiDocsLink' => 'API Documentation',
			'settings.apiKeys.documentation.title' => 'External API Documentation',
			'settings.apiKeys.documentation.description' => 'Learn how to use the external API to trigger Claude/Cursor sessions from your applications.',
			'settings.apiKeys.documentation.viewLink' => 'View API Documentation →',
			'settings.apiKeys.loading' => 'Loading...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Update available: v${version}',
			'settings.tasks.checking' => 'Checking TaskMaster installation...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI Not Installed',
			'settings.tasks.notInstalled.description' => 'TaskMaster CLI is required to use task management features. Install it to get started:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'View on GitHub',
			'settings.tasks.notInstalled.afterInstallation' => 'After installation:',
			'settings.tasks.notInstalled.steps.restart' => 'Restart this application',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster features will automatically become available',
			'settings.tasks.notInstalled.steps.initCommand' => 'Use task-master init in your project directory',
			'settings.tasks.settings.enableLabel' => 'Enable TaskMaster Integration',
			'settings.tasks.settings.enableDescription' => 'Show TaskMaster tasks, banners, and sidebar indicators across the interface',
			'settings.agents.authStatus.checking' => 'Checking...',
			'settings.agents.authStatus.connected' => 'Connected',
			'settings.agents.authStatus.notConnected' => 'Not connected',
			'settings.agents.authStatus.disconnected' => 'Disconnected',
			'settings.agents.authStatus.checkingAuth' => 'Checking authentication status...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => 'Logged in as ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider} account',
			'settings.agents.authStatus.authenticatedUser' => 'authenticated user',
			'settings.agents.install.title' => ({required Object agent}) => '${agent} CLI is not installed',
			'settings.agents.install.description' => ({required Object agent}) => 'Install the ${agent} CLI to sign in and run sessions.',
			'settings.agents.install.button' => 'Install',
			'settings.agents.install.installing' => 'Installing…',
			'settings.agents.install.copyCommand' => 'Copy command',
			'settings.agents.install.docs' => 'Documentation',
			'settings.agents.install.success' => ({required Object agent}) => '${agent} CLI installed',
			'settings.agents.install.failed' => 'Installation failed — check the terminal output',
			'settings.agents.account.claude.description' => 'Anthropic Claude AI assistant',
			'settings.agents.account.cursor.description' => 'Cursor AI-powered code editor',
			'settings.agents.account.codex.description' => 'OpenAI Codex AI assistant',
			'settings.agents.account.opencode.description' => 'OpenCode CLI assistant',
			'settings.agents.account.commandcode.description' => 'Command Code CLI assistant',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI assistant',
			'settings.agents.account.devin.description' => 'Devin CLI assistant',
			'settings.agents.connectionStatus' => 'Connection Status',
			'settings.agents.login.title' => 'Login',
			'settings.agents.login.reAuthenticate' => 'Re-authenticate',
			'settings.agents.login.description' => ({required Object agent}) => 'Sign in to your ${agent} account to enable AI features',
			'settings.agents.login.reAuthDescription' => 'Sign in with a different account or refresh credentials',
			'settings.agents.login.button' => 'Login',
			'settings.agents.login.reLoginButton' => 'Re-login',
			'settings.agents.error' => ({required Object error}) => 'Error: ${error}',
			'settings.agents.accounts.title' => 'Named accounts',
			'settings.agents.accounts.description' => 'Additional credential sets. A session pinned to an account launches the CLI with its isolated config directory. Log in by running the provider CLI once with the shown env vars.',
			'settings.agents.accounts.loading' => 'Loading accounts…',
			'settings.agents.accounts.kDefault' => 'Default',
			'settings.agents.accounts.usage' => ({required Object tokens}) => '${tokens} tokens',
			'settings.agents.accounts.usageButton' => 'Usage',
			'settings.agents.accounts.showUsage' => 'Show token usage',
			'settings.agents.accounts.makeDefault' => 'Make default',
			'settings.agents.accounts.remove' => 'Remove account',
			'settings.agents.accounts.newLabel' => 'Account label (e.g. Work)',
			'settings.agents.accounts.add' => 'Add account',
			'settings.permissions.title' => 'Permission Settings',
			'settings.permissions.skipPermissions.label' => 'Skip permission prompts (use with caution)',
			'settings.permissions.skipPermissions.claudeDescription' => 'Equivalent to --dangerously-skip-permissions flag',
			'settings.permissions.skipPermissions.cursorDescription' => 'Equivalent to -f flag in Cursor CLI',
			'settings.permissions.allowedTools.title' => 'Allowed Tools',
			'settings.permissions.allowedTools.description' => 'Tools that are automatically allowed without prompting for permission',
			'settings.permissions.allowedTools.placeholder' => 'e.g., "Bash(git log:*)" or "Write"',
			'settings.permissions.allowedTools.quickAdd' => 'Quick add common tools:',
			'settings.permissions.allowedTools.empty' => 'No allowed tools configured',
			'settings.permissions.blockedTools.title' => 'Blocked Tools',
			'settings.permissions.blockedTools.description' => 'Tools that are automatically blocked without prompting for permission',
			'settings.permissions.blockedTools.placeholder' => 'e.g., "Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => 'No blocked tools configured',
			'settings.permissions.allowedCommands.title' => 'Allowed Shell Commands',
			'settings.permissions.allowedCommands.description' => 'Shell commands that are automatically allowed without prompting',
			'settings.permissions.allowedCommands.placeholder' => 'e.g., "Shell(ls)" or "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => 'Quick add common commands:',
			'settings.permissions.allowedCommands.empty' => 'No allowed commands configured',
			'settings.permissions.blockedCommands.title' => 'Blocked Shell Commands',
			'settings.permissions.blockedCommands.description' => 'Shell commands that are automatically blocked',
			'settings.permissions.blockedCommands.placeholder' => 'e.g., "Shell(rm -rf)" or "Shell(sudo)"',
			'settings.permissions.blockedCommands.empty' => 'No blocked commands configured',
			'settings.permissions.toolExamples.title' => 'Tool Pattern Examples:',
			'settings.permissions.toolExamples.bashGitLog' => '- Allow all git log commands',
			'settings.permissions.toolExamples.bashGitDiff' => '- Allow all git diff commands',
			'settings.permissions.toolExamples.write' => '- Allow all Write tool usage',
			'settings.permissions.toolExamples.bashRm' => '- Block all rm commands (dangerous)',
			'settings.permissions.shellExamples.title' => 'Shell Command Examples:',
			'settings.permissions.shellExamples.ls' => '- Allow ls command',
			'settings.permissions.shellExamples.gitStatus' => '- Allow git status',
			'settings.permissions.shellExamples.npmInstall' => '- Allow npm install',
			'settings.permissions.shellExamples.rmRf' => '- Block recursive delete',
			'settings.permissions.codex.permissionMode' => 'Permission Mode',
			'settings.permissions.codex.description' => 'Controls how Codex handles file modifications and command execution',
			'settings.permissions.codex.modes.kDefault.title' => 'Default',
			'settings.permissions.codex.modes.kDefault.description' => 'Only trusted commands (ls, cat, grep, git status, etc.) run automatically. Other commands are skipped. Can write to workspace.',
			'settings.permissions.codex.modes.acceptEdits.title' => 'Accept Edits',
			'settings.permissions.codex.modes.acceptEdits.description' => 'All commands run automatically within the workspace. Full auto mode with sandboxed execution.',
			'settings.permissions.codex.modes.bypassPermissions.title' => 'Bypass Permissions',
			'settings.permissions.codex.modes.bypassPermissions.description' => 'Full system access with no restrictions. All commands run automatically with full disk and network access. Use with caution.',
			'settings.permissions.codex.technicalDetails' => 'Technical details',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Trusted commands: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (without -exec), etc.',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never. All commands auto-execute within project directory.',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never. Full system access, use only in trusted environments.',
			'settings.permissions.codex.technicalInfo.overrideNote' => 'You can override this per-session using the mode button in the chat interface.',
			'settings.permissions.permissionMode.title' => 'Permission Mode',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Default permission mode for new ${provider} sessions. You can still override it for a single session with the mode button in the chat composer.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Default',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Actions that need permission are shown to you for approval in the chat.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Accept Edits',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'File edits are approved automatically; other actions still ask for your approval.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Bypass Permissions',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Every action is approved automatically — full access without prompts. Use with caution.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Planning mode: the agent explores and plans without executing commands.',
			'settings.permissions.actions.add' => 'Add',
			'settings.mcpServers.title' => 'MCP Servers',
			'settings.mcpServers.description.claude' => 'Model Context Protocol servers provide additional tools and data sources to Claude',
			'settings.mcpServers.description.cursor' => 'Model Context Protocol servers provide additional tools and data sources to Cursor',
			'settings.mcpServers.description.codex' => 'Model Context Protocol servers provide additional tools and data sources to Codex',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol servers provide additional tools and data sources to OpenCode',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol servers provide additional tools and data sources to Command Code',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol servers provide additional tools and data sources to Antigravity',
			'settings.mcpServers.description.devin' => 'Model Context Protocol servers provide additional tools and data sources to Devin',
			'settings.mcpServers.addButton' => 'Add MCP Server',
			'settings.mcpServers.empty' => 'No MCP servers configured',
			'settings.mcpServers.serverType' => 'Type',
			'settings.mcpServers.scope.local' => 'local',
			'settings.mcpServers.scope.user' => 'user',
			'settings.mcpServers.config.command' => 'Command',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Args',
			'settings.mcpServers.config.environment' => 'Environment',
			'settings.mcpServers.tools.title' => 'Tools',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} more',
			'settings.mcpServers.actions.edit' => 'Edit server',
			'settings.mcpServers.actions.delete' => 'Delete server',
			'settings.mcpServers.managed.badge' => 'Managed',
			'settings.mcpServers.managed.hint' => 'Managed by ddagent.',
			'settings.mcpServers.help.title' => 'About Codex MCP',
			'settings.mcpServers.help.description' => 'Codex supports stdio-based MCP servers. You can add servers that extend Codex\'s capabilities with additional tools and resources.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '"${serverName}" will be removed from the provider configuration.',
			'settings.mcpServers.deleteConfirm.title' => 'Delete MCP server?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => 'Alert thresholds, routing policy and the accounts polled for quota.',
			'settings.quota.settings.saved' => 'Saved',
			'settings.quota.settings.alertsSection' => 'Alerts',
			'settings.quota.settings.alertsSectionHint' => 'Warn before a limit is actually exhausted, not only at 100%.',
			'settings.quota.settings.alertsEnabled' => 'Predicted limit alerts',
			'settings.quota.settings.alertsEnabledHint' => 'Surface pace-based projections on the overview and account cards.',
			'settings.quota.settings.watchThreshold' => 'Watch threshold (%)',
			'settings.quota.settings.watchThresholdHint' => 'Accounts at or above this reading are counted as at risk.',
			'settings.quota.settings.dangerThreshold' => 'Danger threshold (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Readings at or above this value are shown in red.',
			'settings.quota.settings.routingSection' => 'Routing',
			'settings.quota.settings.routingSectionHint' => 'How the panel may move work to the account with the most headroom.',
			'settings.quota.settings.routing.manual' => 'Manual',
			'settings.quota.settings.routing.manualHint' => 'Only show a recommendation; never switch accounts automatically.',
			'settings.quota.settings.routing.ask' => 'Ask before switching',
			'settings.quota.settings.routing.askHint' => 'A switch is proposed and waits for your approval.',
			'settings.quota.settings.routing.autoLowRisk' => 'Auto for low-risk tasks',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Only tasks marked low risk may be moved automatically.',
			'settings.quota.settings.routingNote' => 'Switching an account changes cost and model quality, so it always requires a decision.',
			'settings.quota.settings.accountsSection' => 'Polled accounts',
			'settings.quota.settings.accountsSectionHint' => 'Credentials are read from each tool; the panel never sends them anywhere else.',
			'settings.quota.settings.sourcesSection' => 'Data sources',
			'settings.quota.settings.sourcesSectionHint' => 'Where usage and cost figures come from.',
			'settings.quota.settings.logSources' => 'Token and cost log store',
			'settings.quota.settings.logSourcesHint' => 'Read-only aggregate store shared with the tokboard collector.',
			'settings.quota.settings.readOnly' => 'Read-only',
			'settings.quota.settings.quotaConsent' => 'Quota polling',
			'settings.quota.settings.quotaConsentHint' => 'Reads provider quota endpoints with locally stored credentials.',
			'settings.quota.settings.localOnly' => 'Local only',
			'settings.quota.empty.description' => 'No accounts detected yet.',
			'settings.quota.quality.cached' => 'cached',
			'settings.quota.quality.error' => 'error',
			'settings.quota.quality.estimate' => 'estimate',
			'settings.quota.quality.live' => 'live',
			'settings.quota.quality.unknown' => 'unknown',
			'settings.quota.syncFailed' => 'Sync failed',
			'settings.quota.syncNow' => 'Sync now',
			'settings.browser.checking' => 'checking...',
			'settings.browser.description' => 'Allow agents to create guarded Playwright browser sessions that you can monitor from the Browser tab.',
			'settings.browser.enableDescription' => 'Registers Browser for supported agents. Agents can create browser sessions; you can watch, stop, and delete them.',
			'settings.browser.enableLabel' => 'Enable Browser',
			'settings.browser.errors.installRuntime' => 'Failed to install browser runtime',
			'settings.browser.errors.loadSettings' => 'Failed to load Browser settings',
			'settings.browser.errors.loadStatus' => 'Failed to load Browser status',
			'settings.browser.errors.saveSettings' => 'Failed to save Browser settings',
			'settings.browser.installHint' => 'Install the browser runtime before agents can create Browser sessions.',
			'settings.browser.installRuntime' => 'Install Runtime',
			'settings.browser.installed' => 'installed',
			'settings.browser.installing' => 'Installing...',
			'settings.browser.missing' => 'missing',
			'settings.browser.runtimeRequired' => 'Browser runtime required',
			'settings.browser.statusDisabled' => 'disabled',
			'settings.browser.statusLabel' => 'Status',
			'settings.browser.statusReady' => 'ready',
			'settings.browser.statusSetupRequired' => 'setup required',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Cancel',
			'settings.workspaces.create' => 'Add workspace',
			'settings.workspaces.deleteConfirm' => 'Remove this workspace from ddagent? Its files stay on disk.',
			'settings.workspaces.deleteFailed' => 'Failed to remove workspace.',
			'settings.workspaces.deleteTitle' => 'Remove workspace',
			'settings.workspaces.description' => 'Workspaces are directories ddagent can chat, run code, and browse inside.',
			'settings.workspaces.remove' => 'Remove workspace',
			'settings.workspaces.title' => 'Workspaces',
			'settings.workspaces.pathRequired' => 'Path is required',
			'settings.stt.title' => 'Voice input (speech-to-text)',
			'settings.stt.description' => 'Whisper-compatible /audio/transcriptions endpoint (OpenAI, whisper.cpp, faster-whisper, Speaches). Enables the mic button in the composer.',
			'settings.stt.configured' => 'configured',
			'settings.stt.endpoint' => 'Endpoint URL (e.g. https://api.openai.com/v1)',
			'settings.stt.apiKey' => 'API key',
			'settings.stt.model' => 'Model (default: whisper-1)',
			'settings.stt.save' => 'Save',
			'settings.schedules.title' => 'Schedules',
			'settings.schedules.description' => 'Recurring agent runs on a cron timetable. Runs fire unattended with permissions bypassed.',
			'settings.schedules.preventSleep' => 'Prevent sleep while agents run',
			'settings.schedules.preventSleepHint' => 'Desktop keeps the display awake; in the browser a screen wake lock is used.',
			'settings.schedules.kNew' => 'New schedule',
			'settings.schedules.loading' => 'Loading…',
			'settings.schedules.empty' => 'No schedules yet.',
			'settings.schedules.project' => 'Project',
			'settings.schedules.provider' => 'Provider',
			'settings.schedules.cron' => 'Cron (min hour day month weekday)',
			'settings.schedules.nextRun' => ({required Object time}) => 'Next run: ${time}',
			'settings.schedules.cronInvalid' => 'No upcoming run for this expression',
			'settings.schedules.prompt' => 'Prompt',
			'settings.schedules.useWorktree' => 'Run in a fresh worktree',
			'settings.schedules.catchUp' => 'Catch up missed runs',
			'settings.schedules.failures' => ({required Object count}) => '${count} failures',
			'settings.schedules.disabled' => 'disabled',
			'settings.schedules.history' => 'History',
			'settings.schedules.runNow' => 'Run now',
			'settings.schedules.delete' => 'Delete',
			'settings.schedules.noRuns' => 'No runs yet.',
			'settings.schedules.next' => 'next',
			'settings.schedules.create' => 'Create',
			'settings.schedules.toggleSchedule' => 'Enable schedule',
			'settings.mcpTokens.title' => 'ddagent MCP server tokens',
			'settings.mcpTokens.description' => 'External tools (Claude Desktop, OpenClaw) call ddagent tools over POST /mcp with one of these bearer tokens.',
			'settings.mcpTokens.dismiss' => 'Dismiss',
			'settings.mcpTokens.labelPlaceholder' => 'Token label (e.g. Claude Desktop)',
			'settings.mcpTokens.create' => 'Create',
			'settings.mcpTokens.empty' => 'No MCP tokens yet.',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => 'used ${time}',
			'settings.mcpTokens.neverUsed' => 'never used',
			'settings.about.supportTitle' => 'Support the Project',
			'settings.about.buyMeACoffee' => 'Buy Me a Coffee',
			'settings.about.tryHosted' => 'Try ddagent Hosted',
			'settings.about.learnMore' => 'Learn more',
			'settings.about.proFeatures' => 'ddagent Pro Features',
			'settings.about.pro.syncSettings' => 'Sync Settings',
			'settings.about.pro.teamManagement' => 'Team Management',
			'settings.about.versionInfo' => 'Version info',
			'settings.about.client' => 'App',
			'settings.about.server' => 'Server',
			'settings.about.platformMobile' => 'Mobile',
			'settings.about.platformDesktop' => 'Desktop',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'unknown',
			'settings.shortcuts.description' => 'Every keyboard shortcut in ddagent, split by platform.',
			'settings.shortcuts.action' => 'Action',
			'settings.shortcuts.winLinux' => 'Windows / Linux',
			'settings.shortcuts.mac' => 'macOS',
			'settings.shortcuts.navigation' => 'Navigation',
			'settings.shortcuts.navWorkspace' => 'Go to Workspace',
			'settings.shortcuts.navTasks' => 'Go to Tasks / Git',
			'settings.shortcuts.navGit' => 'Go to Git',
			'settings.shortcuts.navFocus' => 'Toggle focus mode (sidebar)',
			'settings.shortcuts.navSwitcher' => 'Session quick switcher',
			'settings.shortcuts.navPalette' => 'Command palette',
			'settings.shortcuts.navSettings' => 'Open settings',
			'settings.shortcuts.navClose' => 'Close dialog / restore split panes',
			'settings.shortcuts.composer' => 'Composer',
			'settings.shortcuts.compSend' => 'Send message',
			'settings.shortcuts.compNewline' => 'New line',
			'settings.shortcuts.compNav' => 'Navigate suggestions',
			'settings.shortcuts.compAccept' => 'Accept suggestion',
			'settings.shortcuts.compCloseSuggest' => 'Close suggestions',
			'settings.shortcuts.transcript' => 'Transcript',
			'settings.shortcuts.trCopy' => 'Copy selected text',
			'settings.shortcuts.trClose' => 'Close search / review panel',
			'settings.shortcuts.terminal' => 'Terminal',
			'settings.shortcuts.termCopy' => 'Copy selection',
			'settings.shortcuts.termInterrupt' => 'Interrupt process (no selection)',
			'settings.shortcuts.termPaste' => 'Paste',
			'settings.shortcuts.termSelectAll' => 'Select all',
			'settings.shortcuts.editor' => 'Editor',
			'settings.shortcuts.edSave' => 'Save file',
			'settings.shortcuts.edSaveAll' => 'Save all files',
			'settings.shortcuts.edClose' => 'Close tab',
			'settings.shortcuts.edNextTab' => 'Next tab',
			'settings.shortcuts.edPrevTab' => 'Previous tab',
			'settings.shortcuts.edIndent' => 'Indent / outdent',
			'settings.shortcuts.palette' => 'Command palette',
			'settings.shortcuts.palNav' => 'Navigate items',
			'settings.shortcuts.palRun' => 'Run / open',
			'settings.shortcuts.palBack' => 'Back (empty search)',
			'settings.shortcuts.palClose' => 'Close',
			'sidebar.projects.title' => 'Projects',
			'sidebar.projects.newProject' => 'New Project',
			'sidebar.projects.deleteProject' => 'Remove Project',
			'sidebar.projects.renameProject' => 'Rename Project',
			'sidebar.projects.noProjects' => 'No projects found',
			'sidebar.projects.loadingProjects' => 'Loading projects...',
			'sidebar.projects.searchPlaceholder' => 'Search projects...',
			'sidebar.projects.projectNamePlaceholder' => 'Project name',
			'sidebar.projects.starred' => 'Starred',
			'sidebar.projects.all' => 'All',
			'sidebar.projects.untitledSession' => 'Untitled Session',
			'sidebar.projects.newSession' => 'New Session',
			'sidebar.projects.codexSession' => 'Codex Session',
			'sidebar.projects.fetchingProjects' => 'Fetching your Claude projects and sessions',
			'sidebar.projects.projects' => 'projects',
			'sidebar.projects.noMatchingProjects' => 'No matching projects',
			'sidebar.projects.tryDifferentSearch' => 'Try adjusting your search term',
			'sidebar.projects.runClaudeCli' => 'Run Claude CLI in a project directory to get started',
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'AI coding assistant interface',
			'sidebar.panel.open' => 'Panel',
			'sidebar.panel.newChat' => 'New chat',
			'sidebar.panel.navigation' => 'Navigation',
			'sidebar.panel.sessions' => 'Sessions',
			'sidebar.sessions.title' => 'Sessions',
			'sidebar.sessions.newSession' => 'New Session',
			'sidebar.sessions.deleteSession' => 'Delete Session',
			'sidebar.sessions.renameSession' => 'Rename Session',
			'sidebar.sessions.noSessions' => 'No sessions yet',
			'sidebar.sessions.loadingSessions' => 'Loading sessions...',
			'sidebar.sessions.unnamed' => 'Unnamed',
			'sidebar.sessions.loading' => 'Loading...',
			'sidebar.sessions.showMore' => 'Show more sessions',
			'sidebar.sessions.selectMode' => 'Select',
			'sidebar.sessions.selectAll' => 'Select all',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Archive (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Delete (${count})',
			'sidebar.sessions.cancelSelection' => 'Cancel selection',
			'sidebar.sessions.toggleSelection' => 'Toggle session selection',
			'sidebar.sessions.selectionToolbar' => 'Session selection actions',
			'sidebar.sessions.options' => 'Session options',
			'sidebar.sessions.pinSession' => 'Pin session',
			'sidebar.sessions.unpinSession' => 'Unpin session',
			'sidebar.sessions.pinned' => 'Pinned session',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} selected', other: '${count} selected', ), 
			'sidebar.tooltips.viewEnvironments' => 'View Environments',
			'sidebar.tooltips.hideSidebar' => 'Hide sidebar',
			'sidebar.tooltips.createProject' => 'Create new project',
			'sidebar.tooltips.refresh' => 'Refresh projects and sessions (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Rename project (F2)',
			'sidebar.tooltips.deleteProject' => 'Remove project from sidebar (Delete)',
			'sidebar.tooltips.addToFavorites' => 'Add to favorites',
			'sidebar.tooltips.removeFromFavorites' => 'Remove from favorites',
			'sidebar.tooltips.editSessionName' => 'Manually edit session name',
			'sidebar.tooltips.deleteSession' => 'Delete this session permanently',
			'sidebar.tooltips.activeSessionIndicator' => 'Recently active session (last 10 minutes)',
			'sidebar.tooltips.save' => 'Save',
			'sidebar.tooltips.cancel' => 'Cancel',
			'sidebar.tooltips.clearSearch' => 'Clear search',
			'sidebar.tooltips.openCommandPalette' => 'Open command palette',
			'sidebar.tooltips.attentionRequiredIndicator' => 'Session needs attention',
			'sidebar.tooltips.openSessions' => 'Browse sessions',
			'sidebar.navigation.chat' => 'Chat',
			'sidebar.navigation.files' => 'Files',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminal',
			'sidebar.navigation.tasks' => 'Tasks',
			'sidebar.actions.refresh' => 'Refresh',
			'sidebar.actions.settings' => 'Settings',
			'sidebar.actions.collapseAll' => 'Collapse All',
			'sidebar.actions.expandAll' => 'Expand All',
			'sidebar.actions.cancel' => 'Cancel',
			'sidebar.actions.save' => 'Save',
			'sidebar.actions.delete' => 'Delete',
			'sidebar.actions.rename' => 'Rename',
			'sidebar.actions.joinCommunity' => 'Join Community',
			'sidebar.actions.reportIssue' => 'Report Issue',
			'sidebar.actions.starOnGithub' => 'Star on GitHub',
			'sidebar.actions.buyMeACoffee' => 'Buy Me a Coffee',
			'sidebar.workspace.title' => 'Change session workspace',
			'sidebar.workspace.description' => 'The agent runs its next turns in this directory. Existing session history is kept.',
			'sidebar.workspace.pathLabel' => 'Workspace path',
			'sidebar.workspace.pathRequired' => 'Workspace path is required.',
			'sidebar.workspace.submit' => 'Change workspace',
			'sidebar.workspace.saving' => 'Changing…',
			'sidebar.workspace.changeAction' => 'Change workspace',
			'sidebar.branding.openSource' => 'Open Source',
			'sidebar.status.active' => 'Active',
			'sidebar.status.inactive' => 'Inactive',
			'sidebar.status.thinking' => 'Thinking...',
			'sidebar.status.error' => 'Error',
			'sidebar.status.aborted' => 'Aborted',
			'sidebar.status.unknown' => 'Unknown',
			'sidebar.time.justNow' => 'Just now',
			'sidebar.time.oneMinuteAgo' => '1 min ago',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} mins ago',
			_ => null,
		} ?? switch (path) {
			'sidebar.time.oneHourAgo' => '1 hour ago',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} hours ago',
			'sidebar.time.oneDayAgo' => '1 day ago',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} days ago',
			'sidebar.messages.deleteConfirm' => 'Are you sure you want to delete this?',
			'sidebar.messages.renameSuccess' => 'Renamed successfully',
			'sidebar.messages.deleteSuccess' => 'Deleted successfully',
			'sidebar.messages.errorOccurred' => 'An error occurred',
			'sidebar.messages.deleteSessionConfirm' => 'Are you sure you want to delete this session? This action cannot be undone.',
			'sidebar.messages.deleteProjectConfirm' => 'Remove this project from the sidebar? Your project files, memories, and session data will not be deleted.',
			'sidebar.messages.enterProjectPath' => 'Please enter a project path',
			'sidebar.messages.deleteSessionFailed' => 'Failed to delete session. Please try again.',
			'sidebar.messages.deleteSessionError' => 'Error deleting session. Please try again.',
			'sidebar.messages.renameSessionFailed' => 'Failed to rename session. Please try again.',
			'sidebar.messages.renameSessionError' => 'Error renaming session. Please try again.',
			'sidebar.messages.changeWorkspaceFailed' => 'Failed to change workspace. Please try again.',
			'sidebar.messages.changeWorkspaceError' => 'Error changing workspace. Please try again.',
			'sidebar.messages.deleteProjectFailed' => 'Failed to remove project. Please try again.',
			'sidebar.messages.deleteProjectError' => 'Error removing project. Please try again.',
			'sidebar.messages.createProjectFailed' => 'Failed to create project. Please try again.',
			'sidebar.messages.createProjectError' => 'Error creating project. Please try again.',
			'sidebar.messages.updateProjectError' => 'Error updating project. Please try again.',
			'sidebar.messages.refreshError' => 'Failed to refresh. Please try again.',
			'sidebar.messages.restoreProjectFailed' => 'Failed to restore project. Please try again.',
			'sidebar.messages.restoreProjectError' => 'Error restoring project. Please try again.',
			'sidebar.messages.restoreSessionFailed' => 'Failed to restore session. Please try again.',
			'sidebar.messages.restoreSessionError' => 'Error restoring session. Please try again.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Failed to delete ${count} session. Please try again.', other: 'Failed to delete ${count} sessions. Please try again.', ), 
			'sidebar.version.updateAvailable' => 'Update available',
			'sidebar.version.restartRequired' => 'Update installed — restart the server to apply',
			'sidebar.version.updateNow' => 'Update now',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Update ddagent to v${version}? The latest code will be pulled, rebuilt, and the server will restart — active sessions are interrupted.',
			'sidebar.version.updating' => 'Updating… this can take a few minutes',
			'sidebar.version.restarting' => 'Update installed — restarting…',
			'sidebar.version.updateFailed' => 'Update failed',
			'sidebar.version.releaseNotes' => 'Release notes',
			'sidebar.search.modeProjects' => 'Projects',
			'sidebar.search.modeConversations' => 'Conversations',
			'sidebar.search.conversationsPlaceholder' => 'Search in conversations...',
			'sidebar.search.searching' => 'Searching...',
			'sidebar.search.sessionTitles' => 'Session',
			'sidebar.search.conversationContents' => 'Conversation contents',
			'sidebar.search.noResults' => 'No results found',
			'sidebar.search.tryDifferentQuery' => 'Try a different search query',
			'sidebar.search.modeRunning' => 'Running',
			'sidebar.search.archiveOnly' => 'Archive',
			'sidebar.search.runningTooltip' => 'Running sessions',
			'sidebar.search.archiveOnlyTooltip' => 'Archive only',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} active',
			'sidebar.search.viewMenu' => 'View',
			'sidebar.search.backToProjects' => 'Back to projects',
			'sidebar.search.archivedPlaceholder' => 'Search archived sessions...',
			'sidebar.search.runningPlaceholder' => 'Search running sessions...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} match', other: '${count} matches', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} project scanned', other: '${count} projects scanned', ), 
			'sidebar.recent.title' => 'Recent conversations',
			'sidebar.recent.emptyTitle' => 'No conversations yet',
			'sidebar.recent.emptyDescription' => 'Your most recently updated conversations will appear here.',
			'sidebar.recent.loadFailed' => 'Could not load recent conversations',
			'sidebar.recent.loadMore' => 'Load older conversations',
			'sidebar.recent.loadingMore' => 'Loading more...',
			'sidebar.deleteConfirmation.deleteProject' => 'Remove Project',
			'sidebar.deleteConfirmation.deleteSession' => 'Delete Session',
			'sidebar.deleteConfirmation.confirmDelete' => 'What would you like to do with',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Remove from sidebar only',
			'sidebar.deleteConfirmation.deleteAllData' => 'Delete all data permanently',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'The project will be removed from the sidebar. Your files, memories, and session data will be preserved.',
			'sidebar.deleteConfirmation.cannotUndo' => 'You can re-add the project later.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'Archive hides the selected sessions from the active list while preserving their history. Deleting permanently removes them and their transcripts.',
			'sidebar.deleteConfirmation.archiveSession' => 'Archive session',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'Archive keeps the session out of the active list while preserving its history.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'This session is already archived. You can keep it hidden or delete it permanently.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'This permanently removes the session and its transcript. This action cannot be undone.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Delete permanently',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'This project contains ${count} conversation.', other: 'This project contains ${count} conversations.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Manage selected session', other: 'Manage ${count} selected sessions', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Archive session', other: 'Archive ${count} sessions', ), 
			'sidebar.zones.activeNow' => 'Active now',
			'sidebar.zones.recent' => 'Recently worked on',
			'sidebar.zones.today' => 'Today',
			'sidebar.zones.yesterday' => 'Yesterday',
			'sidebar.zones.thisWeek' => 'This week',
			'sidebar.zones.showMore' => ({required Object count}) => 'Show ${count} more',
			'sidebar.zones.showLess' => 'Show less',
			'sidebar.tabs.board' => 'Agent Board',
			'sidebar.tabs.files' => 'Files',
			'sidebar.tabs.git' => 'Source Control',
			'sidebar.tabs.tasks' => 'Tasks',
			'sidebar.tabs.usage' => 'Quota & Usage',
			'tasks.notConfigured.title' => 'TaskMaster AI is not configured',
			'tasks.notConfigured.description' => 'TaskMaster helps break down complex projects into manageable tasks with AI-powered assistance',
			'tasks.notConfigured.whatIsTitle' => '🎯 What is TaskMaster?',
			'tasks.notConfigured.features.aiPowered' => 'AI-Powered Task Management: Break complex projects into manageable subtasks',
			'tasks.notConfigured.features.prdTemplates' => 'PRD Templates: Generate tasks from Product Requirements Documents',
			'tasks.notConfigured.features.dependencyTracking' => 'Dependency Tracking: Understand task relationships and execution order',
			'tasks.notConfigured.features.progressVisualization' => 'Progress Visualization: Kanban boards and detailed task analytics',
			'tasks.notConfigured.features.cliIntegration' => 'CLI Integration: Use taskmaster commands for advanced workflows',
			'tasks.notConfigured.initializeButton' => 'Initialize TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => 'Write PRD first',
			'tasks.gettingStarted.title' => 'Getting Started with TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster is initialized! Here\'s what to do next:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Create a Product Requirements Document (PRD)',
			'tasks.gettingStarted.steps.createPRD.description' => 'Discuss your project idea and create a PRD that describes what you want to build.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'Add PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'Existing PRDs:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'Generate Tasks from PRD',
			'tasks.gettingStarted.steps.generateTasks.description' => 'Once you have a PRD, ask your AI assistant to parse it and TaskMaster will automatically break it down into manageable tasks with implementation details.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Analyze & Expand Tasks',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'Ask your AI assistant to analyze task complexity and expand them into detailed subtasks for easier implementation.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'Start Building',
			'tasks.gettingStarted.steps.startBuilding.description' => 'Ask your AI assistant to begin working on tasks, update their status, and add new tasks as your project evolves.',
			'tasks.gettingStarted.tip' => '💡 Tip: Start with a PRD to get the most out of TaskMaster\'s AI-powered task generation',
			'tasks.setupModal.title' => 'TaskMaster Setup',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => 'Interactive CLI for ${projectName}',
			'tasks.setupModal.willStart' => 'TaskMaster initialization will start automatically',
			'tasks.setupModal.completed' => 'TaskMaster setup completed! You can now close this window.',
			'tasks.setupModal.closeButton' => 'Close',
			'tasks.setupModal.closeContinueButton' => 'Close & Continue',
			'tasks.setupModal.closeTitle' => 'Close',
			'tasks.setupModal.description' => 'Creates a .taskmaster folder in this project. No external tooling or API keys required — tasks are stored locally.',
			'tasks.setupModal.initializeButton' => 'Initialize',
			'tasks.setupModal.initializing' => 'Initializing...',
			'tasks.helpGuide.title' => 'Getting Started with TaskMaster',
			'tasks.helpGuide.subtitle' => 'Your guide to productive task management',
			'tasks.helpGuide.examples.parsePRD' => '💬 Example:\n"I\'ve just initialized a new project with Claude Task Master. I have a PRD at .taskmaster/docs/prd.txt. Can you help me parse it and set up the initial tasks?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Example:\n"Task 5 seems complex. Can you break it down into subtasks?"',
			'tasks.helpGuide.examples.addTask' => '💬 Example:\n"Please add a new task to implement user profile image uploads using Cloudinary, research the best approach."',
			'tasks.helpGuide.moreExamples' => 'View more examples and usage patterns →',
			'tasks.helpGuide.proTips.title' => '💡 Pro Tips',
			'tasks.helpGuide.proTips.search' => 'Use the search bar to quickly find specific tasks',
			'tasks.helpGuide.proTips.views' => 'Switch between Kanban, List, and Grid views using the view toggles',
			'tasks.helpGuide.proTips.filters' => 'Use filters to focus on specific task statuses or priorities',
			'tasks.helpGuide.proTips.details' => 'Click on any task to view detailed information and manage subtasks',
			'tasks.helpGuide.learnMore.title' => '📚 Learn More',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI is an advanced task management system built for developers. Get documentation, examples, and contribute to the project.',
			'tasks.helpGuide.learnMore.githubButton' => 'View on GitHub',
			'tasks.helpGuide.closeTitle' => 'Close',
			'tasks.search.placeholder' => 'Search tasks...',
			'tasks.filters.button' => 'Filters',
			'tasks.filters.status' => 'Status',
			'tasks.filters.priority' => 'Priority',
			'tasks.filters.sortBy' => 'Sort By',
			'tasks.filters.allStatuses' => 'All Statuses',
			'tasks.filters.allPriorities' => 'All Priorities',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => 'Showing ${filtered} of ${total} tasks',
			'tasks.filters.clearFilters' => 'Clear Filters',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Status',
			'tasks.sort.priority' => 'Priority',
			'tasks.sort.idAsc' => 'ID (Ascending)',
			'tasks.sort.idDesc' => 'ID (Descending)',
			'tasks.sort.titleAsc' => 'Title (A-Z)',
			'tasks.sort.titleDesc' => 'Title (Z-A)',
			'tasks.sort.statusAsc' => 'Status (Pending First)',
			'tasks.sort.statusDesc' => 'Status (Done First)',
			'tasks.sort.priorityAsc' => 'Priority (High First)',
			'tasks.sort.priorityDesc' => 'Priority (Low First)',
			'tasks.views.kanban' => 'Kanban view',
			'tasks.views.list' => 'List view',
			'tasks.views.grid' => 'Grid view',
			'tasks.kanban.pending' => '📋 To Do',
			'tasks.kanban.inProgress' => '🚀 In Progress',
			'tasks.kanban.review' => '👀 Review',
			'tasks.kanban.done' => '✅ Done',
			'tasks.kanban.blocked' => '🚫 Blocked',
			'tasks.kanban.deferred' => '⏳ Deferred',
			'tasks.kanban.cancelled' => '❌ Cancelled',
			'tasks.kanban.noTasksYet' => 'No tasks yet',
			'tasks.kanban.tasksWillAppear' => 'Tasks will appear here',
			'tasks.kanban.moveTasksHere' => 'Move tasks here when started',
			'tasks.kanban.completedTasksHere' => 'Completed tasks appear here',
			'tasks.kanban.statusTasksHere' => 'Tasks with this status will appear here',
			'tasks.buttons.help' => 'TaskMaster Getting Started Guide',
			'tasks.buttons.prds' => 'PRDs',
			'tasks.buttons.addPRD' => 'Add PRD',
			'tasks.buttons.addTask' => 'Add Task',
			'tasks.buttons.createNewPRD' => 'Create New PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} PRD(s) available',
			'tasks.prd.modified' => ({required Object date}) => 'Modified: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.newFile' => 'new file',
			'tasks.prd.template' => 'Template',
			'tasks.prd.parse' => 'Parse PRD',
			'tasks.prd.fileExistsTitle' => 'File already exists',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => 'A PRD named "${name}" already exists. Do you want to overwrite it?',
			'tasks.prd.fileNameHint' => 'file name (e.g. prd.txt)',
			'tasks.prd.saved' => 'PRD saved',
			'tasks.prd.tasksGenerated' => 'Tasks generated from PRD',
			'tasks.statuses.pending' => 'Pending',
			'tasks.statuses.inProgress' => 'In Progress',
			'tasks.statuses.done' => 'Done',
			'tasks.statuses.blocked' => 'Blocked',
			'tasks.statuses.deferred' => 'Deferred',
			'tasks.statuses.cancelled' => 'Cancelled',
			'tasks.statuses.review' => 'Review',
			'tasks.priorities.high' => 'High',
			'tasks.priorities.medium' => 'Medium',
			'tasks.priorities.low' => 'Low',
			'tasks.noMatchingTasks.title' => 'No tasks match your filters',
			'tasks.noMatchingTasks.description' => 'Try adjusting your search or filter criteria.',
			'tasks.board.title' => 'Agent Board',
			'tasks.board.subtitle' => 'Move a card to Ready and the agent picks it up. Click a card to open its session.',
			'tasks.board.newCard' => 'New card',
			'tasks.board.addCard' => 'Add card',
			'tasks.board.refresh' => 'Refresh',
			'tasks.board.empty.title' => 'No cards yet',
			'tasks.board.empty.description' => 'Add a card, describe the task, then drag it to Ready to let an agent start working on it.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Ready to start',
			'tasks.board.columns.working' => 'Working',
			'tasks.board.columns.needsDecision' => 'Needs your decision',
			'tasks.board.columns.done' => 'Done',
			'tasks.board.columns.archived' => 'Archived',
			'tasks.board.card.running' => 'Running',
			'tasks.board.card.abort' => 'Abort',
			'tasks.board.card.delete' => 'Delete',
			'tasks.board.card.openSession' => 'Open session',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.card.edit' => 'Edit',
			'tasks.board.card.moveTo' => 'Move to',
			'tasks.board.dialog.createTitle' => 'New card',
			'tasks.board.dialog.editTitle' => 'Edit card',
			'tasks.board.dialog.titleLabel' => 'Title',
			'tasks.board.dialog.titlePlaceholder' => 'What should the agent do?',
			'tasks.board.dialog.descriptionLabel' => 'Description',
			'tasks.board.dialog.descriptionPlaceholder' => 'Add context, acceptance criteria, links...',
			'tasks.board.dialog.cancel' => 'Cancel',
			'tasks.board.dialog.save' => 'Save',
			'tasks.board.noProject' => 'Add a project first, then create cards for it.',
			'tasks.board.projectLabel' => 'Project',
			'tasks.board.backToChat' => 'Back to chat',
			'tasks.board.agent.provider' => 'Agent',
			'tasks.board.agent.anyProvider' => 'Any agent',
			'tasks.board.agent.model' => 'Model',
			'tasks.board.agent.defaultModel' => 'Default model',
			'tasks.board.agent.effort' => 'Reasoning',
			'tasks.board.agent.defaultEffort' => 'Default',
			'tasks.board.agent.searchModel' => 'Search models…',
			'tasks.board.agent.noModels' => 'No matching models',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '"${cardTitle}" will be permanently deleted.',
			'tasks.board.deleteConfirm.title' => 'Delete card?',
			'tasks.board.project' => 'Project',
			'tasks.board.assignee.label' => 'Assignee',
			'tasks.board.assignee.all' => 'All assignees',
			'tasks.board.assignee.unassigned' => 'Unassigned',
			'tasks.board.presence.online' => ({required Object count}) => '${count} online',
			'tasks.board.activity.title' => 'Activity',
			'tasks.board.activity.empty' => 'No activity yet',
			'tasks.board.comments.label' => 'Comments',
			'tasks.board.comments.placeholder' => 'Write a comment…',
			'tasks.board.comments.send' => 'Send',
			'tasks.board.comments.unknownAuthor' => 'Someone',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Depends on: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Task ${id}',
			'tasks.card.highPriority' => 'High priority',
			'tasks.card.lowPriority' => 'Low priority',
			'tasks.card.mediumPriority' => 'Medium priority',
			'tasks.card.noPriority' => 'No priority set',
			'tasks.card.parentTask' => ({required Object id}) => 'Task ${id}',
			'tasks.card.progressLabel' => 'Progress:',
			'tasks.card.progressTooltip' => ({required Object completed, required Object total}) => '${completed} of ${total} subtasks completed',
			'tasks.card.runTask' => 'Run task',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Run task ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Status: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'Task ID: ${id}',
			'tasks.card.taskInProgress' => 'Task in progress',
			'tasks.createTask.cancel' => 'Cancel',
			'tasks.createTask.descriptionLabel' => 'Description',
			'tasks.createTask.descriptionPlaceholder' => 'Optional details',
			'tasks.createTask.error' => 'Failed to add task',
			'tasks.createTask.priorityLabel' => 'Priority',
			'tasks.createTask.submit' => 'Add Task',
			'tasks.createTask.submitting' => 'Adding...',
			'tasks.createTask.title' => 'Add Task',
			'tasks.createTask.titleLabel' => 'Title',
			'tasks.createTask.titlePlaceholder' => 'What needs to be done?',
			'tasks.list.completedReopen' => 'Completed (click to reopen)',
			'tasks.list.inProgressComplete' => 'In progress (click to complete)',
			'tasks.list.markCompleted' => 'Mark completed',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Toggle task ${id} status',
			'tasks.list.markDone' => 'Mark done',
			'tasks.list.reopen' => 'Reopen',
			'tasks.nextTask.allComplete' => 'All tasks complete',
			'tasks.nextTask.feature1' => '- AI-powered task management with dependencies and subtasks.',
			'tasks.nextTask.feature2' => '- PRD-driven task generation for faster project bootstrapping.',
			'tasks.nextTask.feature3' => '- Kanban and list views for day-to-day execution.',
			'tasks.nextTask.hideDetails' => 'Hide details',
			'tasks.nextTask.initialize' => 'Initialize',
			'tasks.nextTask.noPending' => 'No pending tasks',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI is not configured',
			'tasks.nextTask.review' => 'Review',
			'tasks.nextTask.startTask' => 'Start Task',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Task ${id}',
			'tasks.nextTask.viewAll' => 'View all tasks',
			'tasks.nextTask.viewDetails' => 'View task details',
			'tasks.nextTask.whatIs' => 'What is TaskMaster?',
			'tasks.taskDetail.cancelEdit' => 'Cancel editing',
			'tasks.taskDetail.close' => 'Close',
			'tasks.taskDetail.copyTaskId' => 'Copy task ID',
			'tasks.taskDetail.delete' => 'Delete task',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '"${title}" will be permanently deleted.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Delete task?',
			'tasks.taskDetail.deleteFailed' => 'Failed to delete task',
			'tasks.taskDetail.dependencies' => 'Dependencies',
			'tasks.taskDetail.dependenciesPlaceholder' => 'e.g. 1, 2, 3',
			'tasks.taskDetail.description' => 'Description',
			'tasks.taskDetail.edit' => 'Edit task',
			'tasks.taskDetail.implDetails' => 'Implementation Details',
			'tasks.taskDetail.noDependencies' => 'No dependencies',
			'tasks.taskDetail.noDescription' => 'No description provided',
			'tasks.taskDetail.priority' => 'Priority',
			'tasks.taskDetail.priorityNotSet' => 'Not set',
			'tasks.taskDetail.save' => 'Save',
			'tasks.taskDetail.status' => 'Status',
			'tasks.taskDetail.statusFailed' => 'Failed to update task status',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Task ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Task ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Test Strategy',
			'tasks.taskDetail.titleRequired' => 'Title is required',
			'tasks.taskDetail.updateFailed' => 'Failed to update task',
			'tasks.taskDetail.notFound' => 'Task not found',
			'tasks.taskDetail.subtasks' => 'Subtasks',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'Task #${id} will be removed. This cannot be undone.',
			'tasks.taskDetail.idCopied' => 'Task ID copied',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Task ${id} set to in-progress',
			'knowledge.title' => 'Knowledge',
			'knowledge.tabs.dashboard' => 'Dashboard',
			'knowledge.tabs.memories' => 'Memories',
			'knowledge.tabs.rules' => 'Rules',
			'knowledge.tabs.skills' => 'Skills',
			'knowledge.tabs.personal' => 'Personal',
			'knowledge.tabs.graph' => 'Graph',
			'knowledge.common.add' => 'Add',
			'knowledge.common.save' => 'Save',
			'knowledge.common.cancel' => 'Cancel',
			'knowledge.common.delete' => 'Delete',
			'knowledge.common.edit' => 'Edit',
			'knowledge.common.close' => 'Close',
			'knowledge.common.restore' => 'Restore',
			'knowledge.common.refresh' => 'Refresh',
			'knowledge.common.allProjects' => 'All projects',
			'knowledge.common.global' => 'Global',
			'knowledge.actions.scan' => 'Scan project files',
			'knowledge.actions.export' => 'Export JSON',
			'knowledge.actions.import' => 'Import JSON',
			'knowledge.actions.scanComplete' => 'Project scan complete',
			'knowledge.actions.importComplete' => 'Import complete',
			'knowledge.actions.importFailed' => 'Import failed',
			'knowledge.dialog.newEntity' => 'New entry',
			'knowledge.dialog.editEntity' => 'Edit entry',
			'knowledge.dialog.deleteTitle' => 'Delete',
			'knowledge.dialog.deleteMessage' => 'Delete this entry? This cannot be undone (history is kept).',
			'knowledge.dialog.pickIcon' => 'Pick icon',
			'knowledge.dialog.removeIcon' => 'Remove icon',
			'knowledge.dialog.iconTooLarge' => 'Icon is too large (max 40 KB).',
			'knowledge.dialog.importTitle' => 'Import knowledge',
			'knowledge.dialog.importHint' => 'Paste exported JSON here',
			'knowledge.dialog.exportTitle' => 'Export knowledge',
			'knowledge.dialog.import' => 'Import',
			'knowledge.fields.key' => 'Key',
			'knowledge.fields.title' => 'Title',
			'knowledge.fields.name' => 'Name',
			'knowledge.fields.description' => 'Description',
			'knowledge.fields.category' => 'Category',
			'knowledge.fields.content' => 'Content',
			'knowledge.fields.priority' => 'Priority',
			'knowledge.fields.tags' => 'Tags',
			'knowledge.fields.enabled' => 'Enabled',
			'knowledge.fields.projectScope' => 'Project scope',
			'knowledge.fields.tagsHint' => 'comma, separated',
			'knowledge.dashboard.memories' => 'Memories',
			'knowledge.dashboard.rules' => 'Rules',
			'knowledge.dashboard.skills' => 'Skills',
			'knowledge.dashboard.personal' => 'Personal',
			'knowledge.dashboard.connections' => 'Connections',
			'knowledge.dashboard.recent' => 'Recent memories',
			'knowledge.dashboard.noMemories' => 'No memories yet. Add one from the Memories tab.',
			'knowledge.empty.memories' => 'No memories yet.',
			'knowledge.empty.rules' => 'No rules yet.',
			'knowledge.empty.skills' => 'No skills yet.',
			'knowledge.empty.personal' => 'No personal information yet.',
			'knowledge.empty.graph' => 'No entities to graph yet.',
			'knowledge.history.title' => 'History',
			'knowledge.history.none' => 'No history yet.',
			'knowledge.history.untitled' => '(untitled)',
			'knowledge.priorities.critical' => 'Critical',
			'knowledge.priorities.high' => 'High',
			'knowledge.priorities.normal' => 'Normal',
			'knowledge.priorities.low' => 'Low',
			'knowledge.search.title' => 'Search knowledge',
			'knowledge.search.hint' => 'Search memories, rules, skills…',
			'knowledge.search.noResults' => 'No results.',
			'knowledge.links.title' => 'Link entities',
			'knowledge.links.source' => 'Source',
			'knowledge.links.target' => 'Target',
			'knowledge.links.relationship' => 'Relationship',
			'knowledge.links.add' => 'Create link',
			'knowledge.tags.all' => 'All tags',
			'knowledge.tags.manage' => 'Manage tags',
			'knowledge.tags.none' => 'No tags yet.',
			'knowledge.graph.truncated' => 'truncated',
			'knowledge.importAll.title' => 'Import everything into ddagent',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Projects scanned: ${count}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Agent skills found: ${found} (new: ${newSkills})',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Rules: ${total} · duplicate groups: ${duplicates}',
			'knowledge.importAll.mergeDuplicates' => 'Merge duplicate entries',
			'knowledge.importAll.mergeDuplicatesHint' => 'Collapses duplicate rows in ddagent (not files)',
			'knowledge.importAll.action' => 'Import everything',
			'knowledge.migrate.title' => 'Migrate existing rules',
			'knowledge.migrate.scanned' => ({required Object count}) => 'Scanned ${count} project(s).',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Rules: ${total} total, ${critical} critical.',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Duplicate groups across projects: ${count}',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Removed: ${removed}, promoted: ${promoted}',
			'knowledge.migrate.mergeDuplicates' => 'Merge duplicates',
			'knowledge.importSkills.title' => 'Import agent skills',
			'knowledge.importSkills.found' => ({required Object count}) => 'Found ${count} skill(s) across your agents.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'New: ${imported} · skipped: ${skipped}',
			'knowledge.critical.make' => 'Make critical',
			'knowledge.critical.makeAll' => 'Make all rules critical',
			'knowledge.critical.makeAllHint' => 'Adds them to the injected context budget',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Memory: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Rule: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Skill: ${name}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Personal: ${title}',
			'knowledge.errors.importFailed' => ({required Object error}) => 'Import failed: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Migration failed: ${error}',
			'browser.dialogTitle' => 'Agent Browser',
			'browser.viewError' => 'Browser view error',
			'browser.web' => 'Web',
			'collab.team' => 'Team',
			'collab.invite' => 'Invite',
			'collab.inviteTeammate' => 'Invite teammate',
			'collab.shareTokenHint' => 'Share this invite token — it is shown once and expires in 72h:',
			'collab.createInvite' => 'Create invite',
			'collab.copyToken' => 'Copy token',
			'collab.roles.member' => 'Member',
			'collab.roles.viewer' => 'Viewer',
			'fileTree.uploadTo' => 'Upload to',
			'fileTree.uploadHere' => 'Upload here',
			'fileTree.browseServerFilesystem' => 'Browse server filesystem',
			'fileTree.noFiles' => 'No files',
			'fileTree.copyContents' => 'Copy contents',
			'fileTree.chooseFolder' => 'Choose folder',
			'fileTree.search.hint' => 'Filter names / Enter to search contents',
			'fileTree.search.prompt' => 'Type a query and press Enter',
			'fileTree.search.noMatches' => 'No matches',
			'fileTree.search.resultsTruncated' => 'Results truncated',
			'fileTree.titles.rename' => ({required Object name}) => 'Rename ${name}',
			'fileTree.titles.delete' => ({required Object name}) => 'Delete ${name}',
			'fileTree.titles.download' => ({required Object name}) => 'Download ${name}',
			'fileTree.uploadedCount' => ({required Object count}) => 'Uploaded ${count} file(s)',
			'fileTree.newName' => 'New name',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Not a registered project: ${path}',
			'fileTree.showGitignoredFiles' => 'Show gitignored files',
			'fileTree.hideGitignoredFiles' => 'Hide gitignored files',
			'fileTree.downloadUnsupportedOnWeb' => 'Download unsupported on web',
			'fileTree.saveToPath' => 'Save to path',
			'fileTree.savedTo' => ({required Object path}) => 'Saved to ${path}',
			'git.checkpoints.title' => 'Checkpoints',
			'git.checkpoints.restoreTitle' => 'Restore checkpoint',
			'git.checkpoints.restoreMessage' => 'Reset the working tree to this checkpoint? Current changes will be replaced.',
			'git.checkpoints.restored' => 'Checkpoint restored',
			'git.checkpoints.labelHint' => 'Checkpoint label (optional)',
			'git.checkpoints.empty' => 'No checkpoints yet',
			'git.checkpoints.create' => 'New',
			'git.stagedChanges' => 'Staged Changes',
			'git.statusStaged' => 'Staged',
			'git.switchBranch' => 'Switch branch',
			'git.unifiedDiff' => 'Unified diff',
			'git.splitDiff' => 'Split diff',
			'git.noDiff' => 'No diff available',
			'git.largeDiff' => 'Large diff preview: rendering is limited to keep the tab responsive.',
			'git.loadDiffFailed' => ({required Object error}) => 'Failed to load diff: ${error}',
			'git.hunkStage' => '+ Hunk',
			'git.hunkUnstage' => '− Hunk',
			'git.stageHunk' => 'Stage hunk',
			'git.unstageHunk' => 'Unstage hunk',
			'git.deleteFile' => 'Delete file',
			'git.commitMessage' => 'Commit message',
			'git.aiButton' => '✦ AI',
			'git.commitCreated' => 'Commit created',
			'git.noBranch' => 'no branch',
			'git.selectProject' => 'Select a project',
			'kanban.card.untitled' => 'Untitled',
			'kanban.comments.empty' => 'No comments yet',
			'kanban.comments.add' => 'Add comment',
			'kanban.dialog.saving' => 'Saving…',
			'kanban.details.title' => 'Card Details',
			'kanban.details.status' => ({required Object status}) => 'Status: ${status}',
			'kanban.empty.noProject' => 'No project selected',
			'kanban.saveFailed' => 'Failed to save card',
			'kanban.time.now' => 'now',
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '1 minute ago', other: '${count} minutes ago', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '1 hour ago', other: '${count} hours ago', ), 
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '1 day ago', other: '${count} days ago', ), 
			'mcp.install.title' => 'Install ddagent MCP server',
			'mcp.install.description' => 'Lets the selected agents use the ddagent knowledge base and tools over MCP.',
			'mcp.install.cardDescription' => 'Give your agents the knowledge base and ddagent tools over MCP — pick agents or install for all.',
			'mcp.install.installSelected' => 'Install selected',
			'mcp.install.installForAll' => 'Install for all',
			'mcp.install.button' => 'Install',
			'mcp.install.failed' => ({required Object error}) => 'Install failed: ${error}',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Installed on ${count} agent.', other: 'Installed on ${count} agents.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => 'Installed on ${count}; failed: ${failed}',
			'mcp.install.errorFallback' => 'error',
			'mcp.servers.loading' => 'Loading MCP servers...',
			'mcp.servers.refreshingScopes' => 'Refreshing project scopes...',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Model Context Protocol servers provide additional tools and data sources to ${provider}',
			'mcp.servers.addGlobalTitle' => 'Add Global MCP Server',
			'mcp.servers.addGlobalDescription' => 'Adds this MCP server to every provider: Claude, Cursor, Codex, OpenCode, and Devin. Only stdio and HTTP transports are supported because the same config must work across all providers.',
			'mcp.servers.addGlobalMenuDescription' => 'Add Global MCP Server writes one common stdio or HTTP server to Claude, Cursor, Codex, OpenCode, and Devin.',
			_ => null,
		} ?? switch (path) {
			'mcp.servers.addProviderTitle' => ({required Object provider}) => 'Add ${provider} MCP Server',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => 'Add ${provider} MCP Server only changes ${provider}.',
			'mcp.servers.config.cwd' => 'Cwd',
			'mcp.servers.config.envVars' => 'Env Vars',
			'mcp.team.title' => 'Team MCP Configs',
			'mcp.team.description' => 'Share MCP server configurations across your team. Everyone stays in sync automatically.',
			'mcp.team.cta' => 'Available with ddagent Pro',
			'mcp.tokens.scopeWrite' => 'Write',
			'mcp.form.submitTo' => ({required Object provider}) => 'Add Server to ${provider}',
			'mcp.form.scope.userAllProviders' => 'User (All Providers)',
			'mcp.form.scope.claudeLocal' => 'Claude Local',
			'mcp.form.scope.projectAllProviders' => 'Project (All Providers)',
			'mcp.form.scope.description.userGlobal' => 'Writes to each provider user config and is available across projects on this machine',
			'mcp.form.scope.description.user' => 'Available across all projects on your machine',
			'mcp.form.scope.description.local' => 'Stored in Claude user settings for the selected project',
			'mcp.form.scope.description.projectGlobal' => 'Writes to the selected project workspace for every provider',
			'mcp.form.scope.description.project' => 'Stored in the selected project workspace',
			'mcp.form.fields.workingDirectory' => 'Working Directory',
			'mcp.form.fields.envVarNames' => 'Environment Variable Names',
			'mcp.form.fields.bearerTokenEnvVar' => 'Bearer Token Environment Variable',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'Add MCP Server supports only stdio and http across all providers, not ${type}.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} does not support ${type} MCP servers',
			'notifications.deviceLabel' => 'ddagent Flutter',
			'notifications.errors.registrationRejected' => 'Registration rejected by server',
			'notifications.errors.noResponse' => 'No response from the server',
			'onboarding.gitHint' => 'Used for commits created by ddagent sessions.',
			'onboarding.completeSetup' => 'Complete Setup',
			'onboarding.errors.nameAndEmailRequired' => 'Both git name and email are required.',
			'onboarding.errors.invalidEmail' => 'Please enter a valid email address.',
			'onboarding.agents.title' => 'Connect Your AI Agents',
			'onboarding.agents.description' => 'Login to one or more AI coding assistants. All are optional.',
			'onboarding.agents.laterHint' => 'You can configure these later in Settings.',
			'onboarding.mcp.title' => 'Connect agents to ddagent',
			'onboarding.mcp.description' => 'Install the ddagent MCP server so your agents can use the knowledge base and ddagent tools. Pick agents, or install for all.',
			'onboarding.mcp.installSelected' => 'Install selected',
			'onboarding.mcp.installForAll' => 'Install for all',
			'onboarding.mcp.laterHint' => 'Optional — you can also install this later in Settings → MCP.',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Installed on ${count} agent.', other: 'Installed on ${count} agents.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => 'Installed on ${installedCount}; failed: ${failed}',
			'preview.embeddedWebOnly' => 'Embedded preview is available on the web build',
			'preview.startDevServerHint' => 'Start a dev server (npm run dev, flutter run -d web-server…)\nand its port appears here.',
			'projects.cloneRepository' => 'Clone repository',
			'projects.repositoryCloned' => 'Repository cloned',
			'projects.clone' => 'Clone',
			'projects.cloneFinished' => 'Clone finished. Refreshing project list…',
			'projects.cloneFailed' => 'Clone failed',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.destinationPath' => 'Destination path',
			'projects.destinationPathRequired' => 'Destination path is required',
			'projects.repositoryUrlRequired' => 'Repository URL is required',
			'projects.githubTokenOptional' => 'GitHub token (optional)',
			'projects.archive' => 'Archive',
			'projects.restore' => 'Restore',
			'projects.deletePermanently' => 'Delete permanently',
			'projects.deleteProjectTitle' => 'Delete project?',
			'projects.deleteProjectMessage' => ({required Object name}) => 'Permanently removes "${name}" including all sessions and stored history (JSONL wipe). This cannot be undone.',
			'projects.archivedSection' => ({required Object count}) => 'Archived (${count})',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} session', other: '${count} sessions', ), 
			'projects.newer' => 'Newer',
			'projects.older' => 'Older',
			'projects.projectArchived' => 'Project archived',
			'projects.projectRestored' => 'Project restored',
			'projects.projectRenamed' => 'Project renamed',
			'projects.projectDeleted' => 'Project deleted',
			'projects.failedToLoadTokens' => 'Failed to load GitHub tokens',
			'projects.displayNameOptional' => 'Display name (optional)',
			'projects.usingStoredToken' => ({required Object name}) => 'Using stored token: ${name}',
			'projects.unknown' => 'Unknown',
			'quota.section.config' => 'Config',
			'quota.overview.tokensAndCost' => 'Tokens and cost',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.config.pollerTitle' => 'Poller & alerts',
			'quota.config.accountRouting' => 'Account routing',
			'quota.config.save' => 'Save config',
			'quota.chart.show' => 'Show',
			'quota.chart.hide' => 'Hide',
			'quota.chart.noData' => 'Not enough data for a trend.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} tokens · ${cost}',
			'scheduler.newLabel' => 'New',
			'scheduler.runs' => 'Runs',
			'scheduler.editTitle' => 'Edit schedule',
			'scheduler.deleteTitle' => 'Delete schedule?',
			'scheduler.deleteMessage' => ({required Object id}) => 'This removes the recurring job ${id}. Existing sessions are kept.',
			'scheduler.checking' => 'Checking…',
			'scheduler.nextIn' => ({required Object time}) => 'next in ${time}',
			'scheduler.worktree' => 'worktree',
			'scheduler.session' => ({required Object id}) => 'session ${id}',
			'scheduler.cronHint' => 'Cron (min hour day month weekday) — e.g. 0 9 * * *',
			'scheduler.promptHint' => 'Prompt for the agent',
			'serverConnect.subtitle' => 'Connect to your ddagent server',
			'serverConnect.enterUrl' => 'Enter a server URL',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Connection failed (${error})',
			'serverConnect.connect' => 'Connect',
			'serverConnect.connecting' => 'Connecting…',
			'serverConnect.changeServer' => 'Change server',
			'serverConnect.local.title' => 'This device',
			'serverConnect.local.subtitle' => 'Run the ddagent server on this machine',
			'serverConnect.local.install' => 'Install local server',
			'serverConnect.local.start' => 'Start local server',
			'serverConnect.local.stop' => 'Stop',
			'serverConnect.local.starting' => 'Starting local server…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Downloading server… ${percent}%',
			'serverConnect.local.installing' => 'Installing…',
			'serverConnect.local.running' => ({required Object url}) => 'Running at ${url}',
			'serverConnect.local.installed' => ({required Object version}) => 'Installed (v${version})',
			'serverConnect.local.connect' => 'Use this server',
			'serverConnect.local.error' => ({required Object error}) => 'Local server error: ${error}',
			'serverConnect.local.or' => 'or connect to a remote server',
			'sessions.noSessions' => 'No sessions',
			'sessions.noRecentSessions' => 'No recent sessions',
			'sessions.archivedSessions' => 'Archived sessions',
			'sessions.rename' => 'Rename',
			'sessions.archive' => 'Archive',
			'sessions.compareWith' => 'Compare with…',
			'sessions.projectPath' => 'Project path',
			'sessions.newSessionProvider' => 'New session — provider',
			'sessions.autoOrchestrator' => 'Auto (orchestrator)',
			'sessions.createFailed' => ({required Object error}) => 'Failed to create session: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => 'Removes "${name}" and its transcript. This cannot be undone.',
			'sessions.toasts.archived' => 'Session archived',
			'sessions.toasts.restored' => 'Session restored',
			'sessions.toasts.deleted' => 'Session deleted',
			'sessions.toasts.renamed' => 'Session renamed',
			'sessions.toasts.pinned' => 'Session pinned',
			'sessions.toasts.unpinned' => 'Session unpinned',
			'sessions.toasts.workspaceChanged' => 'Workspace changed',
			'sessions.age.lessThanMinute' => '<1m',
			'sessions.age.minutes' => ({required Object count}) => '${count}m',
			'sessions.age.hours' => ({required Object hours}) => '${hours}hr',
			'sessions.age.days' => ({required Object days}) => '${days}d',
			'sessions.activity.subagentRunning' => 'Subagent running',
			'sessions.activity.readingFile' => ({required Object file}) => 'Reading ${file}',
			'sessions.activity.runningTool' => ({required Object name}) => 'Running ${name}',
			'sessions.activity.editingFile' => ({required Object file}) => 'Editing ${file}',
			'sessions.activity.editingFileGeneric' => 'Editing a file',
			'sessions.activity.runningShellCommand' => 'Running a shell command',
			'sessions.activity.runningCommand' => ({required Object command}) => 'Running `${command}`',
			'sessions.activity.committingChanges' => 'Committing changes',
			'sessions.activity.pushingBranch' => 'Pushing branch',
			'sessions.activity.fetchingUrl' => ({required Object url}) => 'Fetching ${url}',
			'sessions.activity.searching' => ({required Object query}) => 'Searching “${query}”',
			'sharedContext.title' => 'Shared Notes',
			'skills.moveSkill' => ({required Object name}) => 'Move ${name}',
			'skills.deleteSkill' => ({required Object name}) => 'Delete ${name}',
			'skills.projectLabel' => 'Project',
			'skills.addDialog.title' => ({required Object provider}) => 'Add ${provider} Skill',
			'skills.addDialog.chooseFileTitle' => 'Choose SKILL.md',
			'skills.addDialog.chooseFolderTitle' => 'Choose a skill folder',
			'skills.addDialog.uploadHint' => 'Upload a SKILL.md file or a complete skill folder.',
			'skills.addDialog.pickTitle' => 'Pick a skill folder or SKILL.md',
			'skills.addDialog.pickHint' => 'Folders can include scripts, references, and assets.',
			'skills.addDialog.chooseFiles' => 'Choose Files',
			'skills.addDialog.chooseFolder' => 'Choose Folder',
			'skills.addDialog.readyToInstall' => 'Ready to install',
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Markdown file · ${size}',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} file · ${size}', other: '${count} files · ${size}', ), 
			'skills.addDialog.removeQueued' => ({required Object name}) => 'Remove ${name}',
			'skills.addDialog.whereWillThisInstall' => 'Where will this install?',
			'skills.addDialog.hideInstallLocation' => 'Hide install location',
			'skills.addDialog.folderUploadsNote' => 'Folder uploads keep the selected folder name; standalone files use the `name` in `SKILL.md`.',
			'skills.addDialog.installSkill' => 'Install Skill',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Install ${count} Skill', other: 'Install ${count} Skills', ), 
			'skills.moveDialog.toProjectHint' => 'Choose the project that should own this skill. It moves out of the provider\'s global skills directory.',
			'skills.moveDialog.toGlobalHint' => 'Move this skill into the global skills directory so every project can use it.',
			'skills.moveDialog.moveToProject' => 'Move to project',
			'skills.moveDialog.moveToGlobal' => 'Move to global',
			'skills.screen.manageDescription' => ({required Object provider}) => 'Manage ${provider} skills from local files, complete folders, and project-aware locations.',
			'skills.screen.searchHint' => 'Search skills...',
			'skills.screen.clearSearch' => 'Clear skill search',
			'skills.screen.addSkill' => 'Add Skill',
			'skills.screen.scanningProjectSkills' => 'Scanning project skills...',
			'skills.screen.savedSuccessfully' => 'Skills saved successfully.',
			'skills.screen.loadingSkills' => ({required Object provider}) => 'Loading ${provider} skills…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} SKILL', other: '${count} SKILLS', ), 
			'skills.screen.deleteTitle' => ({required Object name}) => 'Delete ${name}?',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'This removes the ${directory} directory from ${provider}\'s managed skills directory. This cannot be undone.',
			'skills.screen.noDescription' => 'No description provided in the skill front matter.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Plugin: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Project: ${name}',
			'skills.screen.sourceLabel' => 'SOURCE',
			'skills.empty.noProjects' => 'No projects available',
			'skills.empty.noProjectsDescription' => 'Add a project or workspace to browse its skills.',
			'skills.empty.noSkillsInProject' => 'No skills in this project',
			'skills.empty.noSkillsInProjectDescription' => 'Create a .claude/skills, .cursor/skills or .agents/skills folder in the selected project.',
			'skills.empty.noGlobalSkills' => 'No global skills discovered yet',
			'skills.empty.noGlobalSkillsDescription' => 'Add a global skill above to make it available across every project.',
			'skills.empty.noMatchingSkills' => 'No matching skills',
			'skills.empty.noMatchingSkillsDescription' => 'Try a different command, name, scope, project, or source path.',
			'skills.scopes.user' => 'User',
			'skills.scopes.plugin' => 'Plugin',
			'skills.scopes.repo' => 'Repo',
			'skills.scopes.project' => 'Project',
			'skills.scopes.admin' => 'Admin',
			'skills.scopes.system' => 'System',
			'skills.errors.dropMarkdownOrFolder' => 'Drop one or more markdown files or a folder containing SKILL.md.',
			'skills.errors.addMarkdownFirst' => 'Add one or more markdown files first.',
			'skills.errors.importFailed' => 'Failed to import skills',
			'skills.errors.folderReadFailed' => 'Failed to read skill folder',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'A skill folder can contain up to ${count} files.',
			'skills.errors.folderSizeLimit' => 'Selected skill folders must be smaller than 30 MB in total.',
			'skills.errors.missingSkillFile' => 'The selected folder does not contain a SKILL.md file.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => 'Could not read SKILL.md from ${name}.',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'terminal.tabs.plainShell' => 'Plain Shell',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Login: ${provider}',
			'terminal.actions.newTab' => 'New Terminal Tab',
			'terminal.actions.providerLogin' => 'Provider Login',
			'terminal.actions.restartSession' => 'Restart Session',
			'terminal.actions.clearOutput' => 'Clear Output',
			'terminal.actions.newShell' => 'New Shell',
			'terminal.actions.connect' => 'Connect',
			'terminal.authUrl.openInBrowser' => 'Open in browser',
			'terminal.fileLink.detected' => ({required Object path}) => 'File detected: ${path}',
			'terminal.shortcuts.interrupt' => 'Interrupt (SIGINT)',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.suspend' => 'Suspend (SIGTSTP)',
			'terminal.shortcuts.hide' => 'Hide shortcuts bar',
			'terminal.shortcuts.showTooltip' => 'Show Shortcuts',
			'terminal.shortcuts.hideTooltip' => 'Hide Shortcuts',
			'terminal.paste.title' => 'Paste into terminal',
			'terminal.paste.hint' => 'Ctrl+V / right-click → Paste',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Could not open link: ${url}',
			'voice.preview' => 'Preview',
			'voice.settingsSaved' => 'Voice input settings saved',
			'voice.saveFailed' => 'Failed to save STT configuration',
			'voice.apiKeySaved' => 'API Key (saved, enter to replace)',
			'workspace.exportChat' => 'Export chat',
			'workspace.searchTranscript' => 'Search transcript',
			'workspace.previousMatch' => 'Previous match',
			'workspace.nextMatch' => 'Next match',
			'workspace.closeSearch' => 'Close search',
			'workspace.newChatProvider' => 'New chat — provider',
			'workspace.closePane' => 'Close pane',
			'workspace.jumpToSession' => 'Jump to session…',
			'workspace.archivedWorkspaceName' => 'Archived',
			'workspace.sendTo' => ({required Object count}) => 'Send to ${count}',
			'workspace.deleteSessionNotice' => 'Removes the session and its transcript. Cannot be undone.',
			'workspace.accountWithLabel' => ({required Object label}) => 'Default · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'Finish the run before changing workspace',
			'workspace.restored' => 'Workspace restored',
			'workspace.maximizePane' => 'Maximize pane',
			'workspace.restorePanes' => 'Restore panes',
			'workspace.reviewChangedFiles' => 'Review changed files',
			'worktrees.scripts' => 'Scripts',
			'worktrees.emptyTitle' => 'No worktrees found',
			'worktrees.emptyDescription' => 'Create a worktree to isolate feature work or agent runs.',
			'worktrees.opened' => ({required Object branch}) => 'Opened worktree: ${branch}',
			'worktrees.created' => 'Worktree created',
			'worktrees.removed' => 'Worktree removed',
			'worktrees.merged' => ({required Object branch}) => 'Worktree merged into ${branch}',
			'worktrees.scriptsSaved' => 'Scripts configuration saved',
			'worktrees.setupLabel' => 'Setup: ',
			'worktrees.serverLabel' => 'Server: ',
			'worktrees.runRunning' => 'running',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'running :${port}',
			'worktrees.runButton' => 'Run',
			'worktrees.stopButton' => 'Stop',
			'worktrees.mainBadge' => 'main',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD detached at ${sha}',
			'worktrees.branchHint' => 'New branch name (e.g. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => 'Branching off ${branch}',
			'worktrees.mergeTitle' => ({required Object branch}) => 'Merge ${branch}',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Merge changes into ${branch}.',
			'worktrees.squashDescription' => 'Combine all commits into a single commit',
			'worktrees.cleanupDescription' => 'Remove worktree and delete branch once merged',
			'worktrees.removeTitle' => ({required Object branch}) => 'Remove worktree ${branch}?',
			'worktrees.removeDescription' => 'This deletes the worktree folder. Linked projects will be archived.',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Warning: This worktree has ${count} uncommitted changes that will be lost.',
			'worktrees.forceRemoveLabel' => 'Force remove (discard changes)',
			'worktrees.deleteBranchLabel' => 'Delete branch as well',
			'worktrees.setupHint' => 'Setup command (e.g. npm install)',
			'worktrees.runHint' => 'Run command (e.g. npm run dev)',
			'worktrees.portHint' => 'Run port (optional, e.g. 3000)',
			_ => null,
		};
	}
}
