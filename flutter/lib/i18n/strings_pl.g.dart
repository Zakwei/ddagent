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
	@override late final Translations$knowledge$settings$pl settings = Translations$knowledge$settings$pl._(_root);
}

// Path: auth.login
class Translations$auth$login$pl extends Translations$auth$login$en {
	Translations$auth$login$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Witaj ponownie';
	@override String get description => 'Zaloguj się do swojego samodzielnie hostowanego konta ddagent';
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
	@override late final Translations$chat$claudeStatus$controls$pl controls = Translations$chat$claudeStatus$controls$pl._(_root);
	@override late final Translations$chat$claudeStatus$providers$pl providers = Translations$chat$claudeStatus$providers$pl._(_root);
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
}

// Path: chat.attachments
class Translations$chat$attachments$pl extends Translations$chat$attachments$en {
	Translations$chat$attachments$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Pobieranie nie powiodło się — kliknij, aby ponowić';
	@override String get fileAttachment => 'Załącznik pliku';
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
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$pl extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Zobacz zużycie tokenów w sesji';
	@override String get title => 'Zużycie tokenów';
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
	@override String get previewHtml => 'Otwórz podgląd HTML w nowej karcie';
	@override String get retry => 'Ponów';
	@override String get unpinFile => 'Odepnij plik od kontekstu';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$pl extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Linie:';
	@override String get characters => 'Znaki:';
	@override String get shortcuts => 'Naciśnij Ctrl+S, aby zapisać • Esc, aby zamknąć';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$pl extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plik binarny';
	@override String message({required Object fileName}) => 'Plik "${fileName}" nie może zostać wyświetlony w edytorze tekstu, ponieważ jest to plik binarny.';
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
	@override String get browser => 'Przeglądarka';
	@override String get computer => 'Komputer';
	@override String get board => 'Tablica';
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
	@override String get loading => 'Ładowanie ddagent';
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
	@override String get description => 'Uruchamia ponownie proces ddagent — przydatne po aktualizacji lub gdy coś się zawiesi.';
	@override String get restart => 'Uruchom ponownie';
	@override String get restartConfirm => 'Zrestartować serwer ddagent? Aktywne sesje zostaną przerwane.';
	@override String get restarting => 'Restartowanie… strona przeładuje się, gdy serwer wróci.';
	@override String get restartFailed => 'Restart nie powiódł się';
	@override String get unsupported => 'Restart jest dostępny tylko, gdy serwer działa pod menedżerem usług.';
}

// Path: settings.updates
class Translations$settings$updates$pl extends Translations$settings$updates$en {
	Translations$settings$updates$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aktualizacje aplikacji';
	@override String get description => 'Sprawdź GitHub w poszukiwaniu nowszej wersji desktopowej. Nowe wersje pobierają się automatycznie i instalują przy zamknięciu.';
	@override String get check => 'Sprawdź aktualizacje';
	@override String get checking => 'Sprawdzanie…';
	@override String upToDate({required Object version}) => 'Masz najnowszą wersję (v${version}).';
	@override String available({required Object version}) => 'Znaleziono aktualizację v${version} — pobieranie w tle; zainstaluje się przy zamknięciu ddagent.';
	@override String downloaded({required Object version}) => 'Aktualizacja v${version} pobrana — zamknij i uruchom ddagent ponownie, aby ją zainstalować.';
	@override String get unavailable => 'Sprawdzanie aktualizacji dostępne tylko w spakietowanej aplikacji desktopowej.';
	@override String error({required Object message}) => 'Sprawdzanie aktualizacji nie powiodło się: ${message}';
	@override String get errorGeneric => 'Sprawdzanie aktualizacji nie powiodło się.';
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
	@override String get appearance => 'Wygląd';
	@override String get git => 'Git';
	@override String get apiTokens => 'API i tokeny';
	@override String get models => 'Modele';
	@override String get tasks => 'Zadania';
	@override String get browser => 'Przeglądarka';
	@override String get notifications => 'Powiadomienia';
	@override String get about => 'O aplikacji';
	@override String get quota => 'Control Center';
	@override String get workspaces => 'Obszary robocze';
	@override String get shortcuts => 'Skróty klawiszowe';
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
	@override late final Translations$settings$notifications$desktop$pl desktop = Translations$settings$notifications$desktop$pl._(_root);
	@override late final Translations$settings$notifications$sound$pl sound = Translations$settings$notifications$sound$pl._(_root);
	@override late final Translations$settings$notifications$events$pl events = Translations$settings$notifications$events$pl._(_root);
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
	@override late final Translations$settings$agents$account$pl account = Translations$settings$agents$account$pl._(_root);
	@override String get connectionStatus => 'Stan połączenia';
	@override late final Translations$settings$agents$login$pl login = Translations$settings$agents$login$pl._(_root);
	@override String error({required Object error}) => 'Błąd: ${error}';
	@override late final Translations$settings$agents$accounts$pl accounts = Translations$settings$agents$accounts$pl._(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$pl extends Translations$settings$permissions$en {
	Translations$settings$permissions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ustawienia uprawnień';
	@override late final Translations$settings$permissions$skipPermissions$pl skipPermissions = Translations$settings$permissions$skipPermissions$pl._(_root);
	@override late final Translations$settings$permissions$allowedTools$pl allowedTools = Translations$settings$permissions$allowedTools$pl._(_root);
	@override late final Translations$settings$permissions$blockedTools$pl blockedTools = Translations$settings$permissions$blockedTools$pl._(_root);
	@override late final Translations$settings$permissions$allowedCommands$pl allowedCommands = Translations$settings$permissions$allowedCommands$pl._(_root);
	@override late final Translations$settings$permissions$blockedCommands$pl blockedCommands = Translations$settings$permissions$blockedCommands$pl._(_root);
	@override late final Translations$settings$permissions$toolExamples$pl toolExamples = Translations$settings$permissions$toolExamples$pl._(_root);
	@override late final Translations$settings$permissions$shellExamples$pl shellExamples = Translations$settings$permissions$shellExamples$pl._(_root);
	@override late final Translations$settings$permissions$codex$pl codex = Translations$settings$permissions$codex$pl._(_root);
	@override late final Translations$settings$permissions$permissionMode$pl permissionMode = Translations$settings$permissions$permissionMode$pl._(_root);
	@override late final Translations$settings$permissions$actions$pl actions = Translations$settings$permissions$actions$pl._(_root);
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
	@override String get deleteConfirm => 'Usunąć ten obszar roboczy z ddagent? Jego pliki pozostaną na dysku.';
	@override String get deleteFailed => 'Nie udało się usunąć obszaru roboczego.';
	@override String get deleteTitle => 'Usuń obszar roboczy';
	@override String get description => 'Obszary robocze to katalogi, w których ddagent może czatować, uruchamiać kod i przeglądać.';
	@override String get remove => 'Usuń obszar roboczy';
	@override String get title => 'Obszary robocze';
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
	@override String get title => 'Tokeny serwera MCP ddagenta';
	@override String get description => 'Zewnętrzne narzędzia (Claude Desktop, OpenClaw) wywołują narzędzia ddagenta przez POST /mcp z tymi tokenami bearer.';
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
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$pl extends Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Wszystkie skróty klawiszowe w ddagent, wg platformy.';
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
	@override String get title => 'ddagent';
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
	@override String updateConfirm({required Object version}) => 'Zaktualizować ddagent do v${version}? Najnowszy kod zostanie pobrany i zbudowany, a serwer uruchomi się ponownie — aktywne sesje zostaną przerwane.';
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

// Path: knowledge.settings
class Translations$knowledge$settings$pl extends Translations$knowledge$settings$en {
	Translations$knowledge$settings$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get description => 'Lokalna warstwa pamięci dla agentów: pamięci, reguły, skille i dane osobowe.';
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
	@override String get loadAll => 'Wczytaj wszystkie wiadomości';
	@override String get loadingAll => 'Wczytywanie wszystkich wiadomości...';
	@override String get allLoaded => 'Wczytano wszystkie wiadomości';
	@override String get perfWarning => 'Wczytano wszystkie wiadomości — przewijanie może być wolniejsze. Kliknij „Przewiń na dół”, aby przywrócić wydajność.';
	@override String get loadOlderFailed => 'Nie udało się załadować starszych wiadomości.';
	@override String get noSearchMatches => 'Żadne wiadomości nie pasują do wyszukiwania.';
	@override String get retry => 'Ponów';
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
	@override String get iosHint => 'Na iPhone/iPadzie powiadomienia działają dopiero po dodaniu ddagent do ekranu głównego (Udostępnij → Dodaj do ekranu głównego) i włączeniu ich w zainstalowanej aplikacji.';
	@override String get test => 'Wyślij powiadomienie testowe';
	@override String get testNoSubscription => 'Żadne urządzenie nie jest zasubskrybowane. Najpierw dotknij „Włącz” na telefonie.';
	@override String testSuccess({required Object count}) => 'Wysłano do ${count} urządzeń. Jeśli nic się nie pojawiło na telefonie, dodaj ddagent do ekranu głównego (iOS tego wymaga).';
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
}

// Path: settings.git.email
class Translations$settings$git$email$pl extends Translations$settings$git$email$en {
	Translations$settings$git$email$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'E-mail Git';
	@override String get help => 'Twój e-mail do commitów Git';
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

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$pl extends Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nazwane konta';
	@override String get description => 'Dodatkowe zestawy poświadczeń. Sesja przypięta do konta uruchamia CLI z izolowanym katalogiem konfiguracji. Zaloguj się, uruchamiając raz CLI providera z pokazanymi zmiennymi.';
	@override String get loading => 'Ładowanie kont…';
	@override String get kDefault => 'Domyślne';
	@override String usage({required Object tokens}) => '${tokens} tokenów';
	@override String get usageButton => 'Użycie';
	@override String get showUsage => 'Pokaż użycie tokenów';
	@override String get makeDefault => 'Ustaw jako domyślne';
	@override String get remove => 'Usuń konto';
	@override String get newLabel => 'Nazwa konta (np. Praca)';
	@override String get add => 'Dodaj konto';
}

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$pl extends Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get label => 'Pomiń monity o uprawnienia (używaj ostrożnie)';
	@override String get claudeDescription => 'Odpowiednik flagi --dangerously-skip-permissions';
	@override String get cursorDescription => 'Odpowiednik flagi -f w Cursor CLI';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$pl extends Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dozwolone narzędzia';
	@override String get description => 'Narzędzia automatycznie dozwolone bez pytania o uprawnienia';
	@override String get placeholder => 'np. "Bash(git log:*)" lub "Write"';
	@override String get quickAdd => 'Szybko dodaj popularne narzędzia:';
	@override String get empty => 'Brak skonfigurowanych dozwolonych narzędzi';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$pl extends Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zablokowane narzędzia';
	@override String get description => 'Narzędzia automatycznie blokowane bez pytania o uprawnienia';
	@override String get placeholder => 'np. "Bash(rm:*)"';
	@override String get empty => 'Brak skonfigurowanych zablokowanych narzędzi';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$pl extends Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dozwolone polecenia powłoki';
	@override String get description => 'Polecenia powłoki automatycznie dozwolone bez pytania';
	@override String get placeholder => 'np. "Shell(ls)" lub "Shell(git status)"';
	@override String get quickAdd => 'Szybko dodaj popularne polecenia:';
	@override String get empty => 'Brak skonfigurowanych dozwolonych poleceń';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$pl extends Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zablokowane polecenia powłoki';
	@override String get description => 'Polecenia powłoki automatycznie blokowane';
	@override String get placeholder => 'np. "Shell(rm -rf)" lub "Shell(sudo)"';
	@override String get empty => 'Brak skonfigurowanych zablokowanych poleceń';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$pl extends Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Przykłady wzorców narzędzi:';
	@override String get bashGitLog => '- Zezwól na wszystkie polecenia git log';
	@override String get bashGitDiff => '- Zezwól na wszystkie polecenia git diff';
	@override String get write => '- Zezwól na każde użycie narzędzia Write';
	@override String get bashRm => '- Blokuj wszystkie polecenia rm (niebezpieczne)';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$pl extends Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Przykłady poleceń powłoki:';
	@override String get ls => '- Zezwól na polecenie ls';
	@override String get gitStatus => '- Zezwól na git status';
	@override String get npmInstall => '- Zezwól na npm install';
	@override String get rmRf => '- Blokuj rekurencyjne usuwanie';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$pl extends Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Tryb uprawnień';
	@override String get description => 'Kontroluje, jak Codex obsługuje modyfikacje plików i wykonywanie poleceń';
	@override late final Translations$settings$permissions$codex$modes$pl modes = Translations$settings$permissions$codex$modes$pl._(_root);
	@override String get technicalDetails => 'Szczegóły techniczne';
	@override late final Translations$settings$permissions$codex$technicalInfo$pl technicalInfo = Translations$settings$permissions$codex$technicalInfo$pl._(_root);
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

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$pl extends Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get add => 'Dodaj';
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
	@override String get hint => 'Zarządzane przez ddagent.';
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
	@override String online({required Object count}) => '${count} online';
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

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$pl extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Pytaj';
	@override String get skip => 'Pomiń krok';
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

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$pl extends Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$codex$modes$kDefault$pl kDefault = Translations$settings$permissions$codex$modes$kDefault$pl._(_root);
	@override late final Translations$settings$permissions$codex$modes$acceptEdits$pl acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$pl._(_root);
	@override late final Translations$settings$permissions$codex$modes$bypassPermissions$pl bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$pl._(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$pl extends Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Zaufane polecenia: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (bez -exec) itd.';
	@override String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never. Wszystkie polecenia są wykonywane automatycznie w katalogu projektu.';
	@override String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never. Pełny dostęp do systemu, używaj tylko w zaufanych środowiskach.';
	@override String get overrideNote => 'Możesz to zmienić dla pojedynczej sesji przyciskiem trybu w interfejsie czatu.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$pl extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$pl kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$pl._(_root);
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

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$pl extends Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Domyślny';
	@override String get description => 'Tylko zaufane polecenia (ls, cat, grep, git status itd.) są uruchamiane automatycznie. Inne polecenia są pomijane. Możliwy zapis w obszarze roboczym.';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$pl extends Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Akceptuj zmiany';
	@override String get description => 'Wszystkie polecenia są uruchamiane automatycznie w obszarze roboczym. Pełny tryb automatyczny z wykonywaniem w piaskownicy.';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$pl extends Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Omijaj uprawnienia';
	@override String get description => 'Pełny dostęp do systemu bez ograniczeń. Wszystkie polecenia są uruchamiane automatycznie z pełnym dostępem do dysku i sieci. Używaj ostrożnie.';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$pl extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$pl._(TranslationsPl root) : this._root = root, super.internal(root);

	final TranslationsPl _root; // ignore: unused_field

	// Translations
	@override String get title => 'Domyślny';
	@override String get description => 'Akcje wymagające uprawnień są wyświetlane do zatwierdzenia w czacie.';
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
			'auth.login.description' => 'Zaloguj się do swojego samodzielnie hostowanego konta ddagent',
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
			'chat.json.response' => 'Odpowiedź JSON',
			'chat.permissions.grant' => ({required Object tool}) => 'Nadaj uprawnienia dla ${tool}',
			'chat.permissions.added' => 'Dodano uprawnienie',
			'chat.permissions.addTo' => ({required Object entry}) => 'Dodaje ${entry} do dozwolonych narzędzi.',
			'chat.permissions.retry' => 'Uprawnienie zapisane. Ponów żądanie, aby użyć narzędzia.',
			'chat.permissions.error' => 'Nie można zaktualizować uprawnień. Spróbuj ponownie.',
			'chat.permissions.openSettings' => 'Otwórz ustawienia',
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
			'chat.session.messages.loadAll' => 'Wczytaj wszystkie wiadomości',
			'chat.session.messages.loadingAll' => 'Wczytywanie wszystkich wiadomości...',
			'chat.session.messages.allLoaded' => 'Wczytano wszystkie wiadomości',
			'chat.session.messages.perfWarning' => 'Wczytano wszystkie wiadomości — przewijanie może być wolniejsze. Kliknij „Przewiń na dół”, aby przywrócić wydajność.',
			'chat.session.messages.loadOlderFailed' => 'Nie udało się załadować starszych wiadomości.',
			'chat.session.messages.noSearchMatches' => 'Żadne wiadomości nie pasują do wyszukiwania.',
			'chat.session.messages.retry' => 'Ponów',
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
			'chat.claudeStatus.controls.stopGeneration' => 'Zatrzymaj generowanie',
			'chat.claudeStatus.controls.pressEscToStop' => 'W dowolnym momencie naciśnij Esc, aby zatrzymać',
			'chat.claudeStatus.providers.assistant' => 'Asystent',
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
			'chat.attachments.downloadFailedRetry' => 'Pobieranie nie powiodło się — kliknij, aby ponowić',
			'chat.attachments.fileAttachment' => 'Załącznik pliku',
			'chat.checkpoint.creating' => 'Tworzenie migawki…',
			'chat.checkpoint.revertChanges' => 'Przywróć pliki do ostatniego punktu kontrolnego',
			'chat.checkpoint.undo' => 'Cofnij punkt kontrolny',
			'chat.checkpoint.undoAiRun' => 'Cofnij przebieg AI',
			'chat.checkpoint.undoing' => 'Cofiwanie…',
			'chat.checkpoint.undone' => 'Cofnięto',
			'chat.common.close' => 'Zamknij',
			'chat.taskMaster.saveToTask' => 'Zadanie',
			'chat.taskMaster.saved' => 'Zapisano',
			'chat.taskMaster.saving' => 'Zapisywanie...',
			'chat.taskMaster.taskShort' => 'TASK',
			'chat.tokenUsage.desc' => 'Zobacz zużycie tokenów w sesji',
			'chat.tokenUsage.title' => 'Zużycie tokenów',
			'chat.tool.emptyResult' => '(brak wyjścia — narzędzie zwróciło pusty wynik)',
			'chat.quotaBadge.ariaLabel' => 'Limity subskrypcji',
			'chat.quotaBadge.noData' => 'Brak danych o subskrypcji dla tego modelu',
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
			'codeEditor.toolbar.changes' => 'zmiany',
			'codeEditor.toolbar.previousChange' => 'Poprzednia zmiana',
			'codeEditor.toolbar.nextChange' => 'Następna zmiana',
			'codeEditor.toolbar.hideDiff' => 'Ukryj podświetlanie diff',
			'codeEditor.toolbar.showDiff' => 'Pokaż podświetlanie diff',
			'codeEditor.toolbar.settings' => 'Ustawienia edytora',
			'codeEditor.toolbar.collapse' => 'Zwiń edytor',
			'codeEditor.toolbar.expand' => 'Rozszerz edytor na pełną szerokość',
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
			'codeEditor.actions.previewHtml' => 'Otwórz podgląd HTML w nowej karcie',
			'codeEditor.actions.retry' => 'Ponów',
			'codeEditor.actions.unpinFile' => 'Odepnij plik od kontekstu',
			'codeEditor.footer.lines' => 'Linie:',
			'codeEditor.footer.characters' => 'Znaki:',
			'codeEditor.footer.shortcuts' => 'Naciśnij Ctrl+S, aby zapisać • Esc, aby zamknąć',
			'codeEditor.binaryFile.title' => 'Plik binarny',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Plik "${fileName}" nie może zostać wyświetlony w edytorze tekstu, ponieważ jest to plik binarny.',
			'codeEditor.filePreview.loading' => 'Wczytywanie podglądu...',
			'codeEditor.filePreview.error' => 'Nie można wyświetlić tego pliku.',
			'codeEditor.filePreview.openInNewTab' => 'Otwórz w nowej karcie',
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
			'common.tabs.chat' => 'Czat',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => 'Pliki',
			'common.tabs.git' => 'Kontrola źródła',
			'common.tabs.tasks' => 'Zadania',
			'common.tabs.browser' => 'Przeglądarka',
			'common.tabs.computer' => 'Komputer',
			'common.tabs.board' => 'Tablica',
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
			_ => null,
		} ?? switch (path) {
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
			'common.mainContent.loading' => 'Ładowanie ddagent',
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
			_ => null,
		} ?? switch (path) {
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
			'settings.title' => 'Ustawienia',
			'settings.changelog.title' => 'Dziennik zmian',
			'settings.changelog.loading' => 'Ładowanie…',
			'settings.changelog.empty' => 'Brak wydań do wyświetlenia',
			'settings.changelog.current' => 'aktualna',
			'settings.changelog.kNew' => 'nowa',
			'settings.server.title' => 'Serwer',
			'settings.server.description' => 'Uruchamia ponownie proces ddagent — przydatne po aktualizacji lub gdy coś się zawiesi.',
			'settings.server.restart' => 'Uruchom ponownie',
			'settings.server.restartConfirm' => 'Zrestartować serwer ddagent? Aktywne sesje zostaną przerwane.',
			'settings.server.restarting' => 'Restartowanie… strona przeładuje się, gdy serwer wróci.',
			'settings.server.restartFailed' => 'Restart nie powiódł się',
			'settings.server.unsupported' => 'Restart jest dostępny tylko, gdy serwer działa pod menedżerem usług.',
			'settings.updates.title' => 'Aktualizacje aplikacji',
			'settings.updates.description' => 'Sprawdź GitHub w poszukiwaniu nowszej wersji desktopowej. Nowe wersje pobierają się automatycznie i instalują przy zamknięciu.',
			'settings.updates.check' => 'Sprawdź aktualizacje',
			'settings.updates.checking' => 'Sprawdzanie…',
			'settings.updates.upToDate' => ({required Object version}) => 'Masz najnowszą wersję (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Znaleziono aktualizację v${version} — pobieranie w tle; zainstaluje się przy zamknięciu ddagent.',
			'settings.updates.downloaded' => ({required Object version}) => 'Aktualizacja v${version} pobrana — zamknij i uruchom ddagent ponownie, aby ją zainstalować.',
			'settings.updates.unavailable' => 'Sprawdzanie aktualizacji dostępne tylko w spakietowanej aplikacji desktopowej.',
			'settings.updates.error' => ({required Object message}) => 'Sprawdzanie aktualizacji nie powiodło się: ${message}',
			'settings.updates.errorGeneric' => 'Sprawdzanie aktualizacji nie powiodło się.',
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
			'settings.appearance.editorTheme' => 'Motyw edytora',
			'settings.appearance.wordWrap' => 'Zawijanie wierszy',
			'settings.appearance.showMinimap' => 'Pokaż minimapę',
			'settings.appearance.lineNumbers' => 'Numery wierszy',
			'settings.appearance.fontSize' => 'Rozmiar czcionki',
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
			'settings.mainTabs.appearance' => 'Wygląd',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API i tokeny',
			'settings.mainTabs.models' => 'Modele',
			'settings.mainTabs.tasks' => 'Zadania',
			'settings.mainTabs.browser' => 'Przeglądarka',
			'settings.mainTabs.notifications' => 'Powiadomienia',
			'settings.mainTabs.about' => 'O aplikacji',
			'settings.mainTabs.quota' => 'Control Center',
			'settings.mainTabs.workspaces' => 'Obszary robocze',
			'settings.mainTabs.shortcuts' => 'Skróty klawiszowe',
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
			'settings.notifications.webPush.iosHint' => 'Na iPhone/iPadzie powiadomienia działają dopiero po dodaniu ddagent do ekranu głównego (Udostępnij → Dodaj do ekranu głównego) i włączeniu ich w zainstalowanej aplikacji.',
			'settings.notifications.webPush.test' => 'Wyślij powiadomienie testowe',
			'settings.notifications.webPush.testNoSubscription' => 'Żadne urządzenie nie jest zasubskrybowane. Najpierw dotknij „Włącz” na telefonie.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Wysłano do ${count} urządzeń. Jeśli nic się nie pojawiło na telefonie, dodaj ddagent do ekranu głównego (iOS tego wymaga).',
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
			'settings.git.email.label' => 'E-mail Git',
			'settings.git.email.help' => 'Twój e-mail do commitów Git',
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
			'settings.agents.error' => ({required Object error}) => 'Błąd: ${error}',
			'settings.agents.accounts.title' => 'Nazwane konta',
			'settings.agents.accounts.description' => 'Dodatkowe zestawy poświadczeń. Sesja przypięta do konta uruchamia CLI z izolowanym katalogiem konfiguracji. Zaloguj się, uruchamiając raz CLI providera z pokazanymi zmiennymi.',
			'settings.agents.accounts.loading' => 'Ładowanie kont…',
			'settings.agents.accounts.kDefault' => 'Domyślne',
			'settings.agents.accounts.usage' => ({required Object tokens}) => '${tokens} tokenów',
			'settings.agents.accounts.usageButton' => 'Użycie',
			'settings.agents.accounts.showUsage' => 'Pokaż użycie tokenów',
			'settings.agents.accounts.makeDefault' => 'Ustaw jako domyślne',
			'settings.agents.accounts.remove' => 'Usuń konto',
			'settings.agents.accounts.newLabel' => 'Nazwa konta (np. Praca)',
			'settings.agents.accounts.add' => 'Dodaj konto',
			'settings.permissions.title' => 'Ustawienia uprawnień',
			'settings.permissions.skipPermissions.label' => 'Pomiń monity o uprawnienia (używaj ostrożnie)',
			'settings.permissions.skipPermissions.claudeDescription' => 'Odpowiednik flagi --dangerously-skip-permissions',
			'settings.permissions.skipPermissions.cursorDescription' => 'Odpowiednik flagi -f w Cursor CLI',
			'settings.permissions.allowedTools.title' => 'Dozwolone narzędzia',
			'settings.permissions.allowedTools.description' => 'Narzędzia automatycznie dozwolone bez pytania o uprawnienia',
			'settings.permissions.allowedTools.placeholder' => 'np. "Bash(git log:*)" lub "Write"',
			'settings.permissions.allowedTools.quickAdd' => 'Szybko dodaj popularne narzędzia:',
			'settings.permissions.allowedTools.empty' => 'Brak skonfigurowanych dozwolonych narzędzi',
			'settings.permissions.blockedTools.title' => 'Zablokowane narzędzia',
			'settings.permissions.blockedTools.description' => 'Narzędzia automatycznie blokowane bez pytania o uprawnienia',
			'settings.permissions.blockedTools.placeholder' => 'np. "Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => 'Brak skonfigurowanych zablokowanych narzędzi',
			'settings.permissions.allowedCommands.title' => 'Dozwolone polecenia powłoki',
			'settings.permissions.allowedCommands.description' => 'Polecenia powłoki automatycznie dozwolone bez pytania',
			'settings.permissions.allowedCommands.placeholder' => 'np. "Shell(ls)" lub "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => 'Szybko dodaj popularne polecenia:',
			'settings.permissions.allowedCommands.empty' => 'Brak skonfigurowanych dozwolonych poleceń',
			'settings.permissions.blockedCommands.title' => 'Zablokowane polecenia powłoki',
			'settings.permissions.blockedCommands.description' => 'Polecenia powłoki automatycznie blokowane',
			'settings.permissions.blockedCommands.placeholder' => 'np. "Shell(rm -rf)" lub "Shell(sudo)"',
			_ => null,
		} ?? switch (path) {
			'settings.permissions.blockedCommands.empty' => 'Brak skonfigurowanych zablokowanych poleceń',
			'settings.permissions.toolExamples.title' => 'Przykłady wzorców narzędzi:',
			'settings.permissions.toolExamples.bashGitLog' => '- Zezwól na wszystkie polecenia git log',
			'settings.permissions.toolExamples.bashGitDiff' => '- Zezwól na wszystkie polecenia git diff',
			'settings.permissions.toolExamples.write' => '- Zezwól na każde użycie narzędzia Write',
			'settings.permissions.toolExamples.bashRm' => '- Blokuj wszystkie polecenia rm (niebezpieczne)',
			'settings.permissions.shellExamples.title' => 'Przykłady poleceń powłoki:',
			'settings.permissions.shellExamples.ls' => '- Zezwól na polecenie ls',
			'settings.permissions.shellExamples.gitStatus' => '- Zezwól na git status',
			'settings.permissions.shellExamples.npmInstall' => '- Zezwól na npm install',
			'settings.permissions.shellExamples.rmRf' => '- Blokuj rekurencyjne usuwanie',
			'settings.permissions.codex.permissionMode' => 'Tryb uprawnień',
			'settings.permissions.codex.description' => 'Kontroluje, jak Codex obsługuje modyfikacje plików i wykonywanie poleceń',
			'settings.permissions.codex.modes.kDefault.title' => 'Domyślny',
			'settings.permissions.codex.modes.kDefault.description' => 'Tylko zaufane polecenia (ls, cat, grep, git status itd.) są uruchamiane automatycznie. Inne polecenia są pomijane. Możliwy zapis w obszarze roboczym.',
			'settings.permissions.codex.modes.acceptEdits.title' => 'Akceptuj zmiany',
			'settings.permissions.codex.modes.acceptEdits.description' => 'Wszystkie polecenia są uruchamiane automatycznie w obszarze roboczym. Pełny tryb automatyczny z wykonywaniem w piaskownicy.',
			'settings.permissions.codex.modes.bypassPermissions.title' => 'Omijaj uprawnienia',
			'settings.permissions.codex.modes.bypassPermissions.description' => 'Pełny dostęp do systemu bez ograniczeń. Wszystkie polecenia są uruchamiane automatycznie z pełnym dostępem do dysku i sieci. Używaj ostrożnie.',
			'settings.permissions.codex.technicalDetails' => 'Szczegóły techniczne',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Zaufane polecenia: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (bez -exec) itd.',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never. Wszystkie polecenia są wykonywane automatycznie w katalogu projektu.',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never. Pełny dostęp do systemu, używaj tylko w zaufanych środowiskach.',
			'settings.permissions.codex.technicalInfo.overrideNote' => 'Możesz to zmienić dla pojedynczej sesji przyciskiem trybu w interfejsie czatu.',
			'settings.permissions.permissionMode.title' => 'Tryb uprawnień',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Domyślny tryb uprawnień dla nowych sesji ${provider}. Możesz go nadal zmienić dla pojedynczej sesji przyciskiem trybu w oknie czatu.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Domyślny',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Akcje wymagające uprawnień są wyświetlane do zatwierdzenia w czacie.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Akceptuj zmiany',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Zmiany plików są zatwierdzane automatycznie; pozostałe akcje nadal wymagają Twojej zgody.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'Omijaj uprawnienia',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Wszystkie akcje są zatwierdzane automatycznie — pełny dostęp bez pytań. Używaj ostrożnie.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Tryb planowania: agent analizuje i planuje bez wykonywania poleceń.',
			'settings.permissions.actions.add' => 'Dodaj',
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
			'settings.mcpServers.managed.hint' => 'Zarządzane przez ddagent.',
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
			'settings.workspaces.deleteConfirm' => 'Usunąć ten obszar roboczy z ddagent? Jego pliki pozostaną na dysku.',
			'settings.workspaces.deleteFailed' => 'Nie udało się usunąć obszaru roboczego.',
			'settings.workspaces.deleteTitle' => 'Usuń obszar roboczy',
			'settings.workspaces.description' => 'Obszary robocze to katalogi, w których ddagent może czatować, uruchamiać kod i przeglądać.',
			'settings.workspaces.remove' => 'Usuń obszar roboczy',
			'settings.workspaces.title' => 'Obszary robocze',
			'settings.stt.title' => 'Wprowadzanie głosowe (speech-to-text)',
			'settings.stt.description' => 'Endpoint zgodny z Whisper /audio/transcriptions (OpenAI, whisper.cpp, faster-whisper, Speaches). Włącza przycisk mikrofonu w polu wiadomości.',
			'settings.stt.configured' => 'skonfigurowano',
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
			'settings.mcpTokens.title' => 'Tokeny serwera MCP ddagenta',
			'settings.mcpTokens.description' => 'Zewnętrzne narzędzia (Claude Desktop, OpenClaw) wywołują narzędzia ddagenta przez POST /mcp z tymi tokenami bearer.',
			'settings.mcpTokens.dismiss' => 'Zamknij',
			'settings.mcpTokens.labelPlaceholder' => 'Etykieta tokenu (np. Claude Desktop)',
			'settings.mcpTokens.create' => 'Utwórz',
			'settings.mcpTokens.empty' => 'Brak tokenów MCP.',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => 'użyty ${time}',
			'settings.mcpTokens.neverUsed' => 'nigdy nie użyty',
			'settings.about.supportTitle' => 'Wesprzyj projekt',
			'settings.about.buyMeACoffee' => 'Postaw mi kawę',
			'settings.shortcuts.description' => 'Wszystkie skróty klawiszowe w ddagent, wg platformy.',
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
			'sidebar.app.title' => 'ddagent',
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
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Zaktualizować ddagent do v${version}? Najnowszy kod zostanie pobrany i zbudowany, a serwer uruchomi się ponownie — aktywne sesje zostaną przerwane.',
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
			'tasks.statuses.pending' => 'Oczekujące',
			'tasks.statuses.inProgress' => 'W toku',
			'tasks.statuses.done' => 'Ukończone',
			'tasks.statuses.blocked' => 'Zablokowane',
			'tasks.statuses.deferred' => 'Odroczone',
			'tasks.statuses.cancelled' => 'Anulowane',
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
			_ => null,
		} ?? switch (path) {
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
			'tasks.board.presence.online' => ({required Object count}) => '${count} online',
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
			'knowledge.settings.description' => 'Lokalna warstwa pamięci dla agentów: pamięci, reguły, skille i dane osobowe.',
			_ => null,
		};
	}
}
