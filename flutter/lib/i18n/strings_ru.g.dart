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
	@override late final Translations$chat$input$ru input = Translations$chat$input$ru._(_root);
	@override late final Translations$chat$providerSelection$ru providerSelection = Translations$chat$providerSelection$ru._(_root);
	@override late final Translations$chat$session$ru session = Translations$chat$session$ru._(_root);
	@override late final Translations$chat$shell$ru shell = Translations$chat$shell$ru._(_root);
	@override late final Translations$chat$claudeStatus$ru claudeStatus = Translations$chat$claudeStatus$ru._(_root);
	@override late final Translations$chat$projectSelection$ru projectSelection = Translations$chat$projectSelection$ru._(_root);
	@override late final Translations$chat$tasks$ru tasks = Translations$chat$tasks$ru._(_root);
	@override late final Translations$chat$voice$ru voice = Translations$chat$voice$ru._(_root);
	@override late final Translations$chat$composer$ru composer = Translations$chat$composer$ru._(_root);
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
	@override late final Translations$chat$paneHeader$ru paneHeader = Translations$chat$paneHeader$ru._(_root);
	@override late final Translations$chat$broadcast$ru broadcast = Translations$chat$broadcast$ru._(_root);
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
}

// Path: common
class Translations$common$ru extends Translations$common$en {
	Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$ru buttons = Translations$common$buttons$ru._(_root);
	@override late final Translations$common$tabs$ru tabs = Translations$common$tabs$ru._(_root);
	@override late final Translations$common$status$ru status = Translations$common$status$ru._(_root);
	@override late final Translations$common$messages$ru messages = Translations$common$messages$ru._(_root);
	@override late final Translations$common$navigation$ru navigation = Translations$common$navigation$ru._(_root);
	@override late final Translations$common$common$ru common = Translations$common$common$ru._(_root);
	@override late final Translations$common$time$ru time = Translations$common$time$ru._(_root);
	@override late final Translations$common$fileOperations$ru fileOperations = Translations$common$fileOperations$ru._(_root);
	@override late final Translations$common$mainContent$ru mainContent = Translations$common$mainContent$ru._(_root);
	@override late final Translations$common$fileTree$ru fileTree = Translations$common$fileTree$ru._(_root);
	@override late final Translations$common$projectWizard$ru projectWizard = Translations$common$projectWizard$ru._(_root);
	@override late final Translations$common$versionUpdate$ru versionUpdate = Translations$common$versionUpdate$ru._(_root);
	@override late final Translations$common$quota$ru quota = Translations$common$quota$ru._(_root);
	@override late final Translations$common$notifications$ru notifications = Translations$common$notifications$ru._(_root);
	@override late final Translations$common$actions$ru actions = Translations$common$actions$ru._(_root);
	@override late final Translations$common$browserPane$ru browserPane = Translations$common$browserPane$ru._(_root);
	@override late final Translations$common$browserUse$ru browserUse = Translations$common$browserUse$ru._(_root);
	@override late final Translations$common$commandPalette$ru commandPalette = Translations$common$commandPalette$ru._(_root);
	@override late final Translations$common$gitPanel$ru gitPanel = Translations$common$gitPanel$ru._(_root);
	@override late final Translations$common$sessions$ru sessions = Translations$common$sessions$ru._(_root);
	@override late final Translations$common$projects$ru projects = Translations$common$projects$ru._(_root);
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
	@override late final Translations$settings$about$ru about = Translations$settings$about$ru._(_root);
}

// Path: sidebar
class Translations$sidebar$ru extends Translations$sidebar$en {
	Translations$sidebar$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$ru projects = Translations$sidebar$projects$ru._(_root);
	@override late final Translations$sidebar$app$ru app = Translations$sidebar$app$ru._(_root);
	@override late final Translations$sidebar$sessions$ru sessions = Translations$sidebar$sessions$ru._(_root);
	@override late final Translations$sidebar$tooltips$ru tooltips = Translations$sidebar$tooltips$ru._(_root);
	@override late final Translations$sidebar$navigation$ru navigation = Translations$sidebar$navigation$ru._(_root);
	@override late final Translations$sidebar$actions$ru actions = Translations$sidebar$actions$ru._(_root);
	@override late final Translations$sidebar$branding$ru branding = Translations$sidebar$branding$ru._(_root);
	@override late final Translations$sidebar$status$ru status = Translations$sidebar$status$ru._(_root);
	@override late final Translations$sidebar$time$ru time = Translations$sidebar$time$ru._(_root);
	@override late final Translations$sidebar$messages$ru messages = Translations$sidebar$messages$ru._(_root);
	@override late final Translations$sidebar$version$ru version = Translations$sidebar$version$ru._(_root);
	@override late final Translations$sidebar$search$ru search = Translations$sidebar$search$ru._(_root);
	@override late final Translations$sidebar$deleteConfirmation$ru deleteConfirmation = Translations$sidebar$deleteConfirmation$ru._(_root);
	@override late final Translations$sidebar$zones$ru zones = Translations$sidebar$zones$ru._(_root);
	@override late final Translations$sidebar$panel$ru panel = Translations$sidebar$panel$ru._(_root);
	@override late final Translations$sidebar$workspace$ru workspace = Translations$sidebar$workspace$ru._(_root);
	@override late final Translations$sidebar$recent$ru recent = Translations$sidebar$recent$ru._(_root);
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
	@override late final Translations$knowledge$settings$ru settings = Translations$knowledge$settings$ru._(_root);
}

// Path: auth.login
class Translations$auth$login$ru extends Translations$auth$login$en {
	Translations$auth$login$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Добро пожаловать';
	@override String get description => 'Войдите в свой аккаунт ddagent';
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

// Path: chat.input
class Translations$chat$input$ru extends Translations$chat$input$en {
	Translations$chat$input$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Введите / для команд, @ для файлов, или спросите ${provider} что угодно...';
	@override String get placeholderDefault => 'Введите ваше сообщение...';
	@override String get disabled => 'Ввод отключен';
	@override String get attachFiles => 'Прикрепить файлы';
	@override String get attachImages => 'Прикрепить изображения';
	@override String get send => 'Отправить';
	@override String get stop => 'Остановить';
	@override late final Translations$chat$input$hintText$ru hintText = Translations$chat$input$hintText$ru._(_root);
	@override String get clickToChangeMode => 'Нажмите для смены режима разрешений';
	@override String get showAllCommands => 'Показать все команды';
	@override String get clearInput => 'Очистить ввод';
	@override String get scrollToBottom => 'Прокрутить вниз';
	@override String get attachFilesDesc => 'Загрузить фото, файлы или документы';
	@override String get takePhoto => 'Сделать фото';
	@override String get takePhotoDesc => 'Использовать камеру для фото';
	@override String get moreTools => 'Больше инструментов';
	@override String get commandsDesc => 'Обзор сочетаний клавиш и команд';
	@override String get clearInputDesc => 'Отменить текущий текст';
	@override String get newMessage => 'Новое сообщение';
	@override String get newMessages => 'Новые сообщения';
	@override late final Translations$chat$input$queue$ru queue = Translations$chat$input$queue$ru._(_root);
	@override String get autoContinueTasks => 'Автопродолжение';
	@override String get autoContinueTasksTooltip => 'Включите, чтобы Devin автоматически переходил к следующей задаче Task Master';
	@override late final Translations$chat$input$offlineQueue$ru offlineQueue = Translations$chat$input$offlineQueue$ru._(_root);
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$ru extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Выберите вашего AI-ассистента';
	@override String get description => 'Выберите провайдера для начала нового разговора';
	@override String get selectModel => 'Выбрать модель';
	@override late final Translations$chat$providerSelection$providerInfo$ru providerInfo = Translations$chat$providerSelection$providerInfo$ru._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$ru readyPrompt = Translations$chat$providerSelection$readyPrompt$ru._(_root);
	@override String pressToSearch({required Object shortcut}) => 'Нажмите <kbd>${shortcut}</kbd>, чтобы искать сессии, файлы и коммиты';
	@override String get workspace => 'Рабочая область';
	@override String get noWorkspace => 'Нет';
	@override String get clickToChangeWorkspace => 'Нажмите, чтобы сменить рабочую область';
	@override String get chooseWorkspace => 'Выберите рабочую область';
	@override String get searchWorkspaces => 'Поиск рабочих областей...';
	@override String get noWorkspacesFound => 'Рабочие области не найдены.';
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
	@override late final Translations$chat$claudeStatus$controls$ru controls = Translations$chat$claudeStatus$controls$ru._(_root);
	@override late final Translations$chat$claudeStatus$providers$ru providers = Translations$chat$claudeStatus$providers$ru._(_root);
	@override String get stop => 'Остановить';
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
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$ru extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Добавить панель чата';
	@override String get addBrowser => 'Добавить панель браузера';
	@override String get addTerminal => 'Добавить панель терминала';
	@override String get overview => 'Показать все панели';
	@override String get exitFocusMode => 'Выйти из режима фокуса (Ctrl+Shift+F)';
	@override String get focusMode => 'Режим фокуса (Ctrl+Shift+F)';
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
}

// Path: chat.attachments
class Translations$chat$attachments$ru extends Translations$chat$attachments$en {
	Translations$chat$attachments$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Загрузка не удалась — нажмите, чтобы повторить';
	@override String get fileAttachment => 'Вложение';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$ru extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Создание снимка…';
	@override String get revertChanges => 'Вернуть файлы к последнему чекпоинту';
	@override String get undo => 'Отменить чекпоинт';
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
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$ru extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Просмотр потребления токенов в сессии';
	@override String get title => 'Использование токенов';
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
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$ru extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Обработка…';
	@override String get switchSession => 'Сменить сессию';
}

// Path: chat.broadcast
class Translations$chat$broadcast$ru extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => 'Выбрать оркестраторы';
	@override String get orchestratorsOnly => 'Только оркестраторы';
	@override String get noOrchestrators => 'Нет доступных сессий оркестратора';
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
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$ru extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Строк:';
	@override String get characters => 'Символов:';
	@override String get shortcuts => 'Нажмите Ctrl+S для сохранения • Esc для закрытия';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$ru extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Бинарный файл';
	@override String message({required Object fileName}) => 'Файл "${fileName}" не может быть отображен в текстовом редакторе, так как это бинарный файл.';
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
	@override String get browser => 'Браузер';
	@override String get computer => 'Компьютер';
	@override String get board => 'Доска';
	@override String get usage => 'AI Control';
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
	@override String get loading => 'Загрузка ddagent';
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
	@override String get clearSearch => 'Очистить поиск';
	@override String get name => 'Имя';
	@override String get size => 'Размер';
	@override String get modified => 'Изменено';
	@override String get permissions => 'Права доступа';
	@override String get noFilesFound => 'Файлы не найдены';
	@override String get checkProjectPath => 'Проверьте доступность пути к проекту';
	@override String get noMatchesFound => 'Совпадений не найдено';
	@override String get tryDifferentSearch => 'Попробуйте другой поисковый запрос или очистите поиск';
	@override String get justNow => 'только что';
	@override String minAgo({required Object count}) => '${count} мин. назад';
	@override String hoursAgo({required Object count}) => '${count} ч. назад';
	@override String daysAgo({required Object count}) => '${count} дн. назад';
	@override String get newFile => 'Новый файл (Cmd+N)';
	@override String get newFolder => 'Новая папка (Cmd+Shift+N)';
	@override String get refresh => 'Обновить';
	@override String get collapseAll => 'Свернуть все';
	@override late final Translations$common$fileTree$context$ru context = Translations$common$fileTree$context$ru._(_root);
	@override String get searchContentPlaceholder => 'Поиск в файлах...';
	@override String get searchInFiles => 'Поиск в файлах';
	@override String get searchByName => 'Поиск по имени';
	@override String get loadFailed => 'Не удалось загрузить файлы';
	@override String get noSearchResults => 'Совпадений не найдено';
	@override String get searchError => 'Ошибка поиска';
	@override String get searching => 'Поиск...';
	@override String resultsTruncated({required Object count}) => 'Показаны первые ${count} результатов';
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

// Path: common.quota
class Translations$common$quota$ru extends Translations$common$quota$en {
	Translations$common$quota$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
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

// Path: common.notifications
class Translations$common$notifications$ru extends Translations$common$notifications$en {
	Translations$common$notifications$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'инструмент';
	@override late final Translations$common$notifications$codes$ru codes = Translations$common$notifications$codes$ru._(_root);
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
	@override String get description => 'Перезапускает процесс ddagent — полезно после обновления или при зависании.';
	@override String get restart => 'Перезапустить';
	@override String get restartConfirm => 'Перезапустить сервер ddagent? Активные сессии будут прерваны.';
	@override String get restarting => 'Перезапуск… страница перезагрузится, когда сервер вернётся.';
	@override String get restartFailed => 'Перезапуск не удался';
	@override String get unsupported => 'Перезапуск доступен только когда сервер работает под менеджером служб.';
}

// Path: settings.updates
class Translations$settings$updates$ru extends Translations$settings$updates$en {
	Translations$settings$updates$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Обновления приложения';
	@override String get description => 'Проверить GitHub на наличие новой десктопной сборки. Новые версии скачиваются автоматически и устанавливаются при выходе.';
	@override String get check => 'Проверить обновления';
	@override String get checking => 'Проверка…';
	@override String upToDate({required Object version}) => 'У вас последняя версия (v${version}).';
	@override String available({required Object version}) => 'Найдено обновление v${version} — скачивается в фоне; установится при выходе из ddagent.';
	@override String downloaded({required Object version}) => 'Обновление v${version} загружено — закройте и перезапустите ddagent для установки.';
	@override String get unavailable => 'Проверка обновлений доступна только в упакованных десктопных сборках.';
	@override String error({required Object message}) => 'Не удалось проверить обновления: ${message}';
	@override String get errorGeneric => 'Не удалось проверить обновления.';
}

// Path: settings.tabs
class Translations$settings$tabs$ru extends Translations$settings$tabs$en {
	Translations$settings$tabs$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get account => 'Аккаунт';
	@override String get permissions => 'Разрешения';
	@override String get mcpServers => 'MCP серверы';
	@override String get appearance => 'Внешний вид';
	@override String get skills => 'Навыки';
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
	@override late final Translations$settings$terminalShortcuts$handle$ru handle = Translations$settings$terminalShortcuts$handle$ru._(_root);
	@override String get killTitle => 'Завершить выполняющийся процесс (Ctrl+C)';
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
	@override String get appearance => 'Внешний вид';
	@override String get git => 'Git';
	@override String get apiTokens => 'API и токены';
	@override String get models => 'Модели';
	@override String get tasks => 'Задачи';
	@override String get notifications => 'Уведомления';
	@override String get about => 'О программе';
	@override String get workspaces => 'Рабочие области';
	@override String get browser => 'Browser';
	@override String get tools => 'Инструменты';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$ru extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
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
	@override late final Translations$settings$notifications$sound$ru sound = Translations$settings$notifications$sound$ru._(_root);
	@override late final Translations$settings$notifications$events$ru events = Translations$settings$notifications$events$ru._(_root);
	@override late final Translations$settings$notifications$desktop$ru desktop = Translations$settings$notifications$desktop$ru._(_root);
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
	@override late final Translations$settings$agents$account$ru account = Translations$settings$agents$account$ru._(_root);
	@override String get connectionStatus => 'Статус подключения';
	@override late final Translations$settings$agents$login$ru login = Translations$settings$agents$login$ru._(_root);
	@override String error({required Object error}) => 'Ошибка: ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$ru extends Translations$settings$permissions$en {
	Translations$settings$permissions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки разрешений';
	@override late final Translations$settings$permissions$skipPermissions$ru skipPermissions = Translations$settings$permissions$skipPermissions$ru._(_root);
	@override late final Translations$settings$permissions$allowedTools$ru allowedTools = Translations$settings$permissions$allowedTools$ru._(_root);
	@override late final Translations$settings$permissions$blockedTools$ru blockedTools = Translations$settings$permissions$blockedTools$ru._(_root);
	@override late final Translations$settings$permissions$allowedCommands$ru allowedCommands = Translations$settings$permissions$allowedCommands$ru._(_root);
	@override late final Translations$settings$permissions$blockedCommands$ru blockedCommands = Translations$settings$permissions$blockedCommands$ru._(_root);
	@override late final Translations$settings$permissions$toolExamples$ru toolExamples = Translations$settings$permissions$toolExamples$ru._(_root);
	@override late final Translations$settings$permissions$shellExamples$ru shellExamples = Translations$settings$permissions$shellExamples$ru._(_root);
	@override late final Translations$settings$permissions$codex$ru codex = Translations$settings$permissions$codex$ru._(_root);
	@override late final Translations$settings$permissions$actions$ru actions = Translations$settings$permissions$actions$ru._(_root);
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
	@override late final Translations$settings$mcpServers$help$ru help = Translations$settings$mcpServers$help$ru._(_root);
	@override late final Translations$settings$mcpServers$managed$ru managed = Translations$settings$mcpServers$managed$ru._(_root);
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
	@override String get deleteConfirm => 'Удалить эту рабочую область из ddagent? Её файлы останутся на диске.';
	@override String get deleteFailed => 'Не удалось удалить рабочую область.';
	@override String get deleteTitle => 'Удалить рабочую область';
	@override String get description => 'Рабочие области — каталоги, в которых ddagent может вести чаты, запускать код и просматривать файлы.';
	@override String get remove => 'Удалить рабочую область';
	@override String get title => 'Рабочие области';
}

// Path: settings.about
class Translations$settings$about$ru extends Translations$settings$about$en {
	Translations$settings$about$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Поддержать проект';
	@override String get buyMeACoffee => 'Угостите меня кофе';
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
	@override String get title => 'ddagent';
	@override String get subtitle => 'Интерфейс AI помощника для программирования';
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
	@override String get changeWorkspaceFailed => 'Не удалось сменить рабочую область. Попробуйте снова.';
	@override String get changeWorkspaceError => 'Ошибка при смене рабочей области. Попробуйте снова.';
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
	@override String updateConfirm({required Object version}) => 'Обновить ddagent до v${version}? Будет получен и собран последний код, сервер перезапустится — активные сессии будут прерваны.';
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

// Path: knowledge.settings
class Translations$knowledge$settings$ru extends Translations$knowledge$settings$en {
	Translations$knowledge$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get description => 'Локальный слой памяти для агентов: память, правила, навыки и личные данные.';
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
	@override String get kDefault => 'Выберите провайдера выше для начала';
	@override String opencode({required Object model}) => 'OpenCode с ${model} готов к работе. Начните вводить сообщение ниже.';
	@override String devin({required Object model}) => 'Готово с Devin ${model}';
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
	@override String get loadAll => 'Загрузить все сообщения';
	@override String get loadingAll => 'Загрузка всех сообщений...';
	@override String get allLoaded => 'Все сообщения загружены';
	@override String get perfWarning => 'Все сообщения загружены — прокрутка может быть медленнее. Нажмите "Прокрутить вниз" для восстановления производительности.';
	@override String get loadOlderFailed => 'Не удалось загрузить старые сообщения.';
	@override String get retry => 'Повторить';
	@override String get noSearchMatches => 'Нет сообщений, соответствующих запросу.';
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
	@override String get connect => 'Продолжить в оболочке';
	@override String get connectTitle => 'Подключиться к оболочке';
	@override String get kill => 'Завершить (SIGINT)';
	@override String get killTitle => 'Завершить выполняющийся процесс (Ctrl+C)';
	@override String get copyOutput => 'Копировать вывод';
	@override String get copyOutputTitle => 'Копировать вывод терминала';
	@override String get copied => 'Скопировано!';
	@override String get zoomInTitle => 'Увеличить';
	@override String get zoomOutTitle => 'Уменьшить';
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

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$ru extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Область';
	@override String get user => 'Пользователь';
	@override String get project => 'Проект';
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

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$ru extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$ru extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
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
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$ru taskTypes = Translations$settings$orchestration$rules$taskTypes$ru._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$ru extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$ru modes = Translations$settings$orchestration$planner$modes$ru._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$ru modeHints = Translations$settings$orchestration$planner$modeHints$ru._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$ru templates = Translations$settings$orchestration$planner$templates$ru._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$ru extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$ru onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$ru._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$ru extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

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
	@override String get iosHint => 'На iPhone/iPad уведомления работают только после добавления ddagent на домашний экран (Поделиться → На экран «Домой») и их включения в установленном приложении.';
	@override String get test => 'Отправить тестовое уведомление';
	@override String get testNoSubscription => 'Нет подписанных устройств. Сначала нажмите «Включить» на телефоне.';
	@override String testSuccess({required Object count}) => 'Отправлено на ${count} устройств. Если на телефоне ничего не появилось, добавьте ddagent на домашний экран (это требование iOS).';
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
}

// Path: settings.git.email
class Translations$settings$git$email$ru extends Translations$settings$git$email$en {
	Translations$settings$git$email$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Email Git';
	@override String get help => 'Ваш email для git коммитов';
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

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$ru extends Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get label => 'Пропускать запросы разрешений (используйте с осторожностью)';
	@override String get claudeDescription => 'Эквивалентно флагу --dangerously-skip-permissions';
	@override String get cursorDescription => 'Эквивалентно флагу -f в Cursor CLI';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$ru extends Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Разрешенные инструменты';
	@override String get description => 'Инструменты, которые автоматически разрешены без запроса разрешения';
	@override String get placeholder => 'например, "Bash(git log:*)" или "Write"';
	@override String get quickAdd => 'Быстро добавить общие инструменты:';
	@override String get empty => 'Разрешенные инструменты не настроены';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$ru extends Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Заблокированные инструменты';
	@override String get description => 'Инструменты, которые автоматически блокируются без запроса разрешения';
	@override String get placeholder => 'например, "Bash(rm:*)"';
	@override String get empty => 'Заблокированные инструменты не настроены';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$ru extends Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Разрешенные команды оболочки';
	@override String get description => 'Команды оболочки, которые автоматически разрешены без запроса';
	@override String get placeholder => 'например, "Shell(ls)" или "Shell(git status)"';
	@override String get quickAdd => 'Быстро добавить общие команды:';
	@override String get empty => 'Разрешенные команды не настроены';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$ru extends Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Заблокированные команды оболочки';
	@override String get description => 'Команды оболочки, которые автоматически блокируются';
	@override String get placeholder => 'например, "Shell(rm -rf)" или "Shell(sudo)"';
	@override String get empty => 'Заблокированные команды не настроены';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$ru extends Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Примеры шаблонов инструментов:';
	@override String get bashGitLog => '- Разрешить все команды git log';
	@override String get bashGitDiff => '- Разрешить все команды git diff';
	@override String get write => '- Разрешить все использование инструмента Write';
	@override String get bashRm => '- Заблокировать все команды rm (опасно)';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$ru extends Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Примеры команд оболочки:';
	@override String get ls => '- Разрешить команду ls';
	@override String get gitStatus => '- Разрешить git status';
	@override String get npmInstall => '- Разрешить npm install';
	@override String get rmRf => '- Заблокировать рекурсивное удаление';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$ru extends Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Режим разрешений';
	@override String get description => 'Управляет тем, как Codex обрабатывает изменения файлов и выполнение команд';
	@override late final Translations$settings$permissions$codex$modes$ru modes = Translations$settings$permissions$codex$modes$ru._(_root);
	@override String get technicalDetails => 'Технические детали';
	@override late final Translations$settings$permissions$codex$technicalInfo$ru technicalInfo = Translations$settings$permissions$codex$technicalInfo$ru._(_root);
}

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$ru extends Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get add => 'Добавить';
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

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$ru extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'О Codex MCP';
	@override String get description => 'Codex поддерживает MCP серверы на основе stdio. Вы можете добавлять серверы, которые расширяют возможности Codex дополнительными инструментами и ресурсами.';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$ru extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Управляемый';
	@override String get hint => 'Управляется ddagent.';
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
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
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

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$ru extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Вручную — только рекомендация';
	@override String get ask => 'Спрашивать перед сменой аккаунта';
	@override String get autoLowRisk => 'Автопереключение для задач с низким риском';
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

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$ru extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

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
	@override String get redundantAccounts => 'Резервные аккаунты';
	@override String get redundantAccountsNone => 'Нет других аккаунтов для этого провайдера';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$ru extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

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
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$ru extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$ru extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
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

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$ru extends Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$codex$modes$kDefault$ru kDefault = Translations$settings$permissions$codex$modes$kDefault$ru._(_root);
	@override late final Translations$settings$permissions$codex$modes$acceptEdits$ru acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$ru._(_root);
	@override late final Translations$settings$permissions$codex$modes$bypassPermissions$ru bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$ru._(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$ru extends Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Доверенные команды: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (без -exec) и т.д.';
	@override String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never. Все команды автоматически выполняются в каталоге проекта.';
	@override String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never. Полный системный доступ, используйте только в доверенных средах.';
	@override String get overrideNote => 'Вы можете переопределить это для каждого сеанса, используя кнопку режима в интерфейсе чата.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$ru extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$ru kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$ru._(_root);
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

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$ru extends Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'По умолчанию';
	@override String get description => 'Только доверенные команды (ls, cat, grep, git status и т.д.) выполняются автоматически. Другие команды пропускаются. Может записывать в рабочее пространство.';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$ru extends Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Принимать правки';
	@override String get description => 'Все команды выполняются автоматически в рабочем пространстве. Полный автоматический режим с изолированным выполнением.';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$ru extends Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Обход разрешений';
	@override String get description => 'Полный системный доступ без ограничений. Все команды выполняются автоматически с полным доступом к диску и сети. Используйте с осторожностью.';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$ru extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'По умолчанию';
	@override String get description => 'Действия, требующие разрешения, показываются вам для одобрения в чате.';
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
			'auth.login.description' => 'Войдите в свой аккаунт ddagent',
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
			'chat.json.response' => 'JSON ответ',
			'chat.permissions.grant' => ({required Object tool}) => 'Предоставить разрешение для ${tool}',
			'chat.permissions.added' => 'Разрешение добавлено',
			'chat.permissions.addTo' => ({required Object entry}) => 'Добавляет ${entry} в разрешенные инструменты.',
			'chat.permissions.retry' => 'Разрешение сохранено. Повторите запрос для использования инструмента.',
			'chat.permissions.error' => 'Не удалось обновить разрешения. Попробуйте снова.',
			'chat.permissions.openSettings' => 'Открыть настройки',
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
			'chat.input.placeholder' => ({required Object provider}) => 'Введите / для команд, @ для файлов, или спросите ${provider} что угодно...',
			'chat.input.placeholderDefault' => 'Введите ваше сообщение...',
			'chat.input.disabled' => 'Ввод отключен',
			'chat.input.attachFiles' => 'Прикрепить файлы',
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
			'chat.input.attachFilesDesc' => 'Загрузить фото, файлы или документы',
			'chat.input.takePhoto' => 'Сделать фото',
			'chat.input.takePhotoDesc' => 'Использовать камеру для фото',
			'chat.input.moreTools' => 'Больше инструментов',
			'chat.input.commandsDesc' => 'Обзор сочетаний клавиш и команд',
			'chat.input.clearInputDesc' => 'Отменить текущий текст',
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
			'chat.input.autoContinueTasks' => 'Автопродолжение',
			'chat.input.autoContinueTasksTooltip' => 'Включите, чтобы Devin автоматически переходил к следующей задаче Task Master',
			'chat.input.offlineQueue.clear' => 'Отменить и очистить офлайн-очередь',
			'chat.input.offlineQueue.clearBtn' => 'Отмена',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} сообщений в офлайн-очереди — отправятся автоматически при переподключении',
			'chat.input.offlineQueue.single' => '1 сообщение в офлайн-очереди — отправится автоматически при переподключении',
			'chat.providerSelection.title' => 'Выберите вашего AI-ассистента',
			'chat.providerSelection.description' => 'Выберите провайдера для начала нового разговора',
			'chat.providerSelection.selectModel' => 'Выбрать модель',
			'chat.providerSelection.providerInfo.anthropic' => 'от Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'от OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI редактор кода',
			'chat.providerSelection.providerInfo.google' => 'от Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Готов использовать Claude с ${model}. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Готов использовать Cursor с ${model}. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Готов использовать Codex с ${model}. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Выберите провайдера выше для начала',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'OpenCode с ${model} готов к работе. Начните вводить сообщение ниже.',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Готово с Devin ${model}',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Нажмите <kbd>${shortcut}</kbd>, чтобы искать сессии, файлы и коммиты',
			'chat.providerSelection.workspace' => 'Рабочая область',
			'chat.providerSelection.noWorkspace' => 'Нет',
			'chat.providerSelection.clickToChangeWorkspace' => 'Нажмите, чтобы сменить рабочую область',
			'chat.providerSelection.chooseWorkspace' => 'Выберите рабочую область',
			'chat.providerSelection.searchWorkspaces' => 'Поиск рабочих областей...',
			'chat.providerSelection.noWorkspacesFound' => 'Рабочие области не найдены.',
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
			'chat.session.messages.loadAll' => 'Загрузить все сообщения',
			'chat.session.messages.loadingAll' => 'Загрузка всех сообщений...',
			'chat.session.messages.allLoaded' => 'Все сообщения загружены',
			'chat.session.messages.perfWarning' => 'Все сообщения загружены — прокрутка может быть медленнее. Нажмите "Прокрутить вниз" для восстановления производительности.',
			'chat.session.messages.loadOlderFailed' => 'Не удалось загрузить старые сообщения.',
			'chat.session.messages.retry' => 'Повторить',
			'chat.session.messages.noSearchMatches' => 'Нет сообщений, соответствующих запросу.',
			'chat.shell.selectProject.title' => 'Выберите проект',
			'chat.shell.selectProject.description' => 'Выберите проект для открытия интерактивной оболочки в этом каталоге',
			'chat.shell.status.newSession' => 'Новый сеанс',
			'chat.shell.status.initializing' => 'Инициализация...',
			'chat.shell.status.restarting' => 'Перезапуск...',
			'chat.shell.actions.disconnect' => 'Отключиться',
			'chat.shell.actions.disconnectTitle' => 'Отключиться от оболочки',
			'chat.shell.actions.restart' => 'Перезапустить',
			'chat.shell.actions.restartTitle' => 'Перезапустить оболочку (сначала отключитесь)',
			'chat.shell.actions.connect' => 'Продолжить в оболочке',
			'chat.shell.actions.connectTitle' => 'Подключиться к оболочке',
			'chat.shell.actions.kill' => 'Завершить (SIGINT)',
			'chat.shell.actions.killTitle' => 'Завершить выполняющийся процесс (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Копировать вывод',
			'chat.shell.actions.copyOutputTitle' => 'Копировать вывод терминала',
			'chat.shell.actions.copied' => 'Скопировано!',
			'chat.shell.actions.zoomInTitle' => 'Увеличить',
			'chat.shell.actions.zoomOutTitle' => 'Уменьшить',
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
			'chat.claudeStatus.controls.stopGeneration' => 'Остановить генерацию',
			'chat.claudeStatus.controls.pressEscToStop' => 'Нажмите Esc в любое время для остановки',
			'chat.claudeStatus.providers.assistant' => 'Ассистент',
			'chat.claudeStatus.stop' => 'Остановить',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Выберите проект для начала чата с ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Начать следующую задачу',
			'chat.voice.autoRead' => 'Читать ответы вслух',
			'chat.voice.autoReadOn' => 'Чтение ответов вслух: вкл',
			'chat.voice.autoReadOff' => 'Чтение ответов вслух: выкл',
			'chat.voice.autoReadVoice' => 'Голос озвучки',
			'chat.voice.autoReadVoiceAuto' => 'Автоматический голос',
			'chat.voice.autoReadPreview' => 'Так будут звучать ответы.',
			'chat.voice.speakMessage' => 'Прочитать вслух',
			'chat.voice.stopSpeaking' => 'Остановить чтение',
			'chat.composer.toolsAndActions' => 'Инструменты и действия',
			'chat.composer.toolsAndActionsDesc' => 'Инструменты и элементы управления полем ввода',
			'chat.composer.reasoning' => 'Рассуждает',
			'chat.composer.model' => 'Модель',
			'chat.composer.effortDefault' => 'По умолчанию',
			'chat.composer.loadingModels' => 'Загрузка моделей…',
			'chat.composer.modelMenu' => 'Выбрать модель и уровень рассуждений',
			'chat.composer.permissionHeading' => ({required Object provider}) => 'Как должны одобряться действия ${provider}?',
			'chat.composer.favorites' => 'Избранное',
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
			'chat.splitWorkspace.addChat' => 'Добавить панель чата',
			'chat.splitWorkspace.addBrowser' => 'Добавить панель браузера',
			'chat.splitWorkspace.addTerminal' => 'Добавить панель терминала',
			'chat.splitWorkspace.overview' => 'Показать все панели',
			'chat.splitWorkspace.exitFocusMode' => 'Выйти из режима фокуса (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => 'Режим фокуса (Ctrl+Shift+F)',
			'chat.splitWorkspace.browseSessions' => 'Открыть список сессий',
			'chat.splitOverview.title' => 'Обзор разделённых панелей',
			'chat.splitOverview.count' => ({required Object count}) => '${count} панелей',
			'chat.splitOverview.close' => 'Закрыть обзор',
			'chat.splitOverview.question' => 'ВОПРОС — требуется ввод',
			'chat.splitOverview.processing' => 'ОБРАБОТКА',
			'chat.splitOverview.idle' => 'Бездействует',
			'chat.splitOverview.active' => 'Активна',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} ждёт вашего ответа',
			'chat.attachments.downloadFailedRetry' => 'Загрузка не удалась — нажмите, чтобы повторить',
			'chat.attachments.fileAttachment' => 'Вложение',
			'chat.checkpoint.creating' => 'Создание снимка…',
			'chat.checkpoint.revertChanges' => 'Вернуть файлы к последнему чекпоинту',
			'chat.checkpoint.undo' => 'Отменить чекпоинт',
			'chat.common.close' => 'Закрыть',
			'chat.taskMaster.saveToTask' => 'Задача',
			'chat.taskMaster.saved' => 'Сохранено',
			'chat.taskMaster.saving' => 'Сохранение...',
			'chat.taskMaster.taskShort' => 'ЗАДАЧА',
			'chat.tokenUsage.desc' => 'Просмотр потребления токенов в сессии',
			'chat.tokenUsage.title' => 'Использование токенов',
			'chat.tool.emptyResult' => '(пока нет вывода — инструмент вернул пустой результат)',
			'chat.quotaBadge.ariaLabel' => 'Лимиты подписки',
			'chat.quotaBadge.noData' => 'Нет данных о подписке для этой модели',
			'chat.paneHeader.processing' => 'Обработка…',
			'chat.paneHeader.switchSession' => 'Сменить сессию',
			'chat.broadcast.selectOrchestrators' => 'Выбрать оркестраторы',
			'chat.broadcast.orchestratorsOnly' => 'Только оркестраторы',
			'chat.broadcast.noOrchestrators' => 'Нет доступных сессий оркестратора',
			'codeEditor.toolbar.changes' => 'изменения',
			'codeEditor.toolbar.previousChange' => 'Предыдущее изменение',
			'codeEditor.toolbar.nextChange' => 'Следующее изменение',
			'codeEditor.toolbar.hideDiff' => 'Скрыть подсветку различий',
			'codeEditor.toolbar.showDiff' => 'Показать подсветку различий',
			'codeEditor.toolbar.settings' => 'Настройки редактора',
			'codeEditor.toolbar.collapse' => 'Свернуть редактор',
			'codeEditor.toolbar.expand' => 'Развернуть редактор на всю ширину',
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
			'codeEditor.footer.lines' => 'Строк:',
			'codeEditor.footer.characters' => 'Символов:',
			'codeEditor.footer.shortcuts' => 'Нажмите Ctrl+S для сохранения • Esc для закрытия',
			'codeEditor.binaryFile.title' => 'Бинарный файл',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'Файл "${fileName}" не может быть отображен в текстовом редакторе, так как это бинарный файл.',
			'codeEditor.filePreview.loading' => 'Загрузка предпросмотра...',
			'codeEditor.filePreview.error' => 'Не удалось отобразить этот файл.',
			'codeEditor.filePreview.openInNewTab' => 'Открыть в новой вкладке',
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
			'common.tabs.chat' => 'Чат',
			'common.tabs.shell' => 'Терминал',
			'common.tabs.files' => 'Файлы',
			'common.tabs.git' => 'Система контроля версий',
			'common.tabs.tasks' => 'Задачи',
			'common.tabs.browser' => 'Браузер',
			'common.tabs.computer' => 'Компьютер',
			'common.tabs.board' => 'Доска',
			'common.tabs.usage' => 'AI Control',
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
			'common.mainContent.loading' => 'Загрузка ddagent',
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
			'common.fileTree.clearSearch' => 'Очистить поиск',
			'common.fileTree.name' => 'Имя',
			'common.fileTree.size' => 'Размер',
			'common.fileTree.modified' => 'Изменено',
			'common.fileTree.permissions' => 'Права доступа',
			'common.fileTree.noFilesFound' => 'Файлы не найдены',
			'common.fileTree.checkProjectPath' => 'Проверьте доступность пути к проекту',
			'common.fileTree.noMatchesFound' => 'Совпадений не найдено',
			'common.fileTree.tryDifferentSearch' => 'Попробуйте другой поисковый запрос или очистите поиск',
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
			'common.fileTree.searchContentPlaceholder' => 'Поиск в файлах...',
			'common.fileTree.searchInFiles' => 'Поиск в файлах',
			'common.fileTree.searchByName' => 'Поиск по имени',
			'common.fileTree.loadFailed' => 'Не удалось загрузить файлы',
			'common.fileTree.noSearchResults' => 'Совпадений не найдено',
			'common.fileTree.searchError' => 'Ошибка поиска',
			'common.fileTree.searching' => 'Поиск...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Показаны первые ${count} результатов',
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
			_ => null,
		} ?? switch (path) {
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
			'common.quota.controlCenter' => 'AI Control Center',
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
			'common.notifications.genericTool' => 'инструмент',
			'common.notifications.codes.generic.info.title' => 'Уведомление',
			'common.notifications.codes.permission.required.title' => 'Требуется действие',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} ожидает вашего решения.',
			'common.notifications.codes.run.stopped.title' => 'Запуск остановлен',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Причина: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Запуск завершился сбоем',
			'common.notifications.codes.agent.notification.title' => 'Уведомление агента',
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
			_ => null,
		} ?? switch (path) {
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
			'common.sessions.renameSession' => 'Переименовать сессию',
			'common.projects.newSession' => 'Новая сессия',
			'settings.title' => 'Настройки',
			'settings.changelog.title' => 'Журнал изменений',
			'settings.changelog.loading' => 'Загрузка…',
			'settings.changelog.empty' => 'Нет релизов для отображения',
			'settings.changelog.current' => 'текущая',
			'settings.changelog.kNew' => 'новая',
			'settings.server.title' => 'Сервер',
			'settings.server.description' => 'Перезапускает процесс ddagent — полезно после обновления или при зависании.',
			'settings.server.restart' => 'Перезапустить',
			'settings.server.restartConfirm' => 'Перезапустить сервер ddagent? Активные сессии будут прерваны.',
			'settings.server.restarting' => 'Перезапуск… страница перезагрузится, когда сервер вернётся.',
			'settings.server.restartFailed' => 'Перезапуск не удался',
			'settings.server.unsupported' => 'Перезапуск доступен только когда сервер работает под менеджером служб.',
			'settings.updates.title' => 'Обновления приложения',
			'settings.updates.description' => 'Проверить GitHub на наличие новой десктопной сборки. Новые версии скачиваются автоматически и устанавливаются при выходе.',
			'settings.updates.check' => 'Проверить обновления',
			'settings.updates.checking' => 'Проверка…',
			'settings.updates.upToDate' => ({required Object version}) => 'У вас последняя версия (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Найдено обновление v${version} — скачивается в фоне; установится при выходе из ddagent.',
			'settings.updates.downloaded' => ({required Object version}) => 'Обновление v${version} загружено — закройте и перезапустите ddagent для установки.',
			'settings.updates.unavailable' => 'Проверка обновлений доступна только в упакованных десктопных сборках.',
			'settings.updates.error' => ({required Object message}) => 'Не удалось проверить обновления: ${message}',
			'settings.updates.errorGeneric' => 'Не удалось проверить обновления.',
			'settings.tabs.account' => 'Аккаунт',
			'settings.tabs.permissions' => 'Разрешения',
			'settings.tabs.mcpServers' => 'MCP серверы',
			'settings.tabs.appearance' => 'Внешний вид',
			'settings.tabs.skills' => 'Навыки',
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
			'settings.terminalShortcuts.title' => 'Горячие клавиши терминала',
			'settings.terminalShortcuts.sectionKeys' => 'Клавиши',
			'settings.terminalShortcuts.sectionNavigation' => 'Навигация',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Стрелка вверх',
			'settings.terminalShortcuts.arrowDown' => 'Стрелка вниз',
			'settings.terminalShortcuts.scrollDown' => 'Прокрутка вниз',
			'settings.terminalShortcuts.handle.closePanel' => 'Закрыть панель горячих клавиш',
			'settings.terminalShortcuts.handle.openPanel' => 'Открыть панель горячих клавиш',
			'settings.terminalShortcuts.killTitle' => 'Завершить выполняющийся процесс (Ctrl+C)',
			'settings.terminalShortcuts.paste' => 'Вставить',
			'settings.mainTabs.label' => 'Настройки',
			'settings.mainTabs.agents' => 'Агенты',
			'settings.mainTabs.orchestration' => 'Оркестрация',
			'settings.mainTabs.appearance' => 'Внешний вид',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API и токены',
			'settings.mainTabs.models' => 'Модели',
			'settings.mainTabs.tasks' => 'Задачи',
			'settings.mainTabs.notifications' => 'Уведомления',
			'settings.mainTabs.about' => 'О программе',
			'settings.mainTabs.workspaces' => 'Рабочие области',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Инструменты',
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
			'settings.orchestration.pool.fields.redundantAccounts' => 'Резервные аккаунты',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Нет других аккаунтов для этого провайдера',
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
			'settings.notifications.title' => 'Уведомления',
			'settings.notifications.description' => 'Управляйте тем, какие события уведомлений вы получаете.',
			'settings.notifications.webPush.title' => 'Web Push уведомления',
			'settings.notifications.webPush.enable' => 'Включить Push уведомления',
			'settings.notifications.webPush.disable' => 'Отключить Push уведомления',
			'settings.notifications.webPush.enabled' => 'Push уведомления включены',
			'settings.notifications.webPush.loading' => 'Обновление...',
			'settings.notifications.webPush.unsupported' => 'Push уведомления не поддерживаются в этом браузере.',
			'settings.notifications.webPush.denied' => 'Push уведомления заблокированы. Разрешите их в настройках браузера.',
			'settings.notifications.webPush.iosHint' => 'На iPhone/iPad уведомления работают только после добавления ddagent на домашний экран (Поделиться → На экран «Домой») и их включения в установленном приложении.',
			'settings.notifications.webPush.test' => 'Отправить тестовое уведомление',
			'settings.notifications.webPush.testNoSubscription' => 'Нет подписанных устройств. Сначала нажмите «Включить» на телефоне.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Отправлено на ${count} устройств. Если на телефоне ничего не появилось, добавьте ddagent на домашний экран (это требование iOS).',
			'settings.notifications.sound.title' => 'Звук',
			'settings.notifications.sound.description' => 'Воспроизводить короткий сигнал при завершении запуска чата.',
			'settings.notifications.sound.enabled' => 'Включено',
			'settings.notifications.sound.test' => 'Проверить звук',
			'settings.notifications.events.title' => 'Типы событий',
			'settings.notifications.events.actionRequired' => 'Требуется действие',
			'settings.notifications.events.stop' => 'Запуск остановлен',
			'settings.notifications.events.error' => 'Запуск завершился с ошибкой',
			'settings.notifications.desktop.title' => 'Уведомлять это десктопное приложение',
			'settings.notifications.desktop.enable' => 'Включить Push уведомления',
			'settings.notifications.desktop.disable' => 'Отключить Push уведомления',
			'settings.notifications.desktop.enabled' => 'Уведомления включены для этого десктопного приложения',
			'settings.notifications.desktop.unsupported' => 'Десктопные уведомления не поддерживаются в этой системе.',
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
			'settings.git.email.label' => 'Email Git',
			'settings.git.email.help' => 'Ваш email для git коммитов',
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
			'settings.agents.error' => ({required Object error}) => 'Ошибка: ${error}',
			'settings.permissions.title' => 'Настройки разрешений',
			'settings.permissions.skipPermissions.label' => 'Пропускать запросы разрешений (используйте с осторожностью)',
			'settings.permissions.skipPermissions.claudeDescription' => 'Эквивалентно флагу --dangerously-skip-permissions',
			'settings.permissions.skipPermissions.cursorDescription' => 'Эквивалентно флагу -f в Cursor CLI',
			'settings.permissions.allowedTools.title' => 'Разрешенные инструменты',
			'settings.permissions.allowedTools.description' => 'Инструменты, которые автоматически разрешены без запроса разрешения',
			'settings.permissions.allowedTools.placeholder' => 'например, "Bash(git log:*)" или "Write"',
			'settings.permissions.allowedTools.quickAdd' => 'Быстро добавить общие инструменты:',
			'settings.permissions.allowedTools.empty' => 'Разрешенные инструменты не настроены',
			'settings.permissions.blockedTools.title' => 'Заблокированные инструменты',
			'settings.permissions.blockedTools.description' => 'Инструменты, которые автоматически блокируются без запроса разрешения',
			'settings.permissions.blockedTools.placeholder' => 'например, "Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => 'Заблокированные инструменты не настроены',
			'settings.permissions.allowedCommands.title' => 'Разрешенные команды оболочки',
			'settings.permissions.allowedCommands.description' => 'Команды оболочки, которые автоматически разрешены без запроса',
			'settings.permissions.allowedCommands.placeholder' => 'например, "Shell(ls)" или "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => 'Быстро добавить общие команды:',
			'settings.permissions.allowedCommands.empty' => 'Разрешенные команды не настроены',
			'settings.permissions.blockedCommands.title' => 'Заблокированные команды оболочки',
			'settings.permissions.blockedCommands.description' => 'Команды оболочки, которые автоматически блокируются',
			'settings.permissions.blockedCommands.placeholder' => 'например, "Shell(rm -rf)" или "Shell(sudo)"',
			'settings.permissions.blockedCommands.empty' => 'Заблокированные команды не настроены',
			'settings.permissions.toolExamples.title' => 'Примеры шаблонов инструментов:',
			'settings.permissions.toolExamples.bashGitLog' => '- Разрешить все команды git log',
			'settings.permissions.toolExamples.bashGitDiff' => '- Разрешить все команды git diff',
			'settings.permissions.toolExamples.write' => '- Разрешить все использование инструмента Write',
			'settings.permissions.toolExamples.bashRm' => '- Заблокировать все команды rm (опасно)',
			'settings.permissions.shellExamples.title' => 'Примеры команд оболочки:',
			'settings.permissions.shellExamples.ls' => '- Разрешить команду ls',
			'settings.permissions.shellExamples.gitStatus' => '- Разрешить git status',
			'settings.permissions.shellExamples.npmInstall' => '- Разрешить npm install',
			'settings.permissions.shellExamples.rmRf' => '- Заблокировать рекурсивное удаление',
			'settings.permissions.codex.permissionMode' => 'Режим разрешений',
			'settings.permissions.codex.description' => 'Управляет тем, как Codex обрабатывает изменения файлов и выполнение команд',
			'settings.permissions.codex.modes.kDefault.title' => 'По умолчанию',
			'settings.permissions.codex.modes.kDefault.description' => 'Только доверенные команды (ls, cat, grep, git status и т.д.) выполняются автоматически. Другие команды пропускаются. Может записывать в рабочее пространство.',
			'settings.permissions.codex.modes.acceptEdits.title' => 'Принимать правки',
			'settings.permissions.codex.modes.acceptEdits.description' => 'Все команды выполняются автоматически в рабочем пространстве. Полный автоматический режим с изолированным выполнением.',
			'settings.permissions.codex.modes.bypassPermissions.title' => 'Обход разрешений',
			'settings.permissions.codex.modes.bypassPermissions.description' => 'Полный системный доступ без ограничений. Все команды выполняются автоматически с полным доступом к диску и сети. Используйте с осторожностью.',
			'settings.permissions.codex.technicalDetails' => 'Технические детали',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Доверенные команды: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (без -exec) и т.д.',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never. Все команды автоматически выполняются в каталоге проекта.',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never. Полный системный доступ, используйте только в доверенных средах.',
			'settings.permissions.codex.technicalInfo.overrideNote' => 'Вы можете переопределить это для каждого сеанса, используя кнопку режима в интерфейсе чата.',
			'settings.permissions.actions.add' => 'Добавить',
			'settings.permissions.permissionMode.title' => 'Режим разрешений',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Режим разрешений по умолчанию для новых сессий ${provider}. Его всё ещё можно переопределить для отдельной сессии.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'По умолчанию',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Действия, требующие разрешения, показываются вам для одобрения в чате.',
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
			'settings.mcpServers.help.title' => 'О Codex MCP',
			'settings.mcpServers.help.description' => 'Codex поддерживает MCP серверы на основе stdio. Вы можете добавлять серверы, которые расширяют возможности Codex дополнительными инструментами и ресурсами.',
			'settings.mcpServers.managed.badge' => 'Управляемый',
			'settings.mcpServers.managed.hint' => 'Управляется ddagent.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '«${serverName}» будет удалён из конфигурации провайдера.',
			'settings.mcpServers.deleteConfirm.title' => 'Удалить сервер MCP?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
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
			_ => null,
		} ?? switch (path) {
			'settings.browser.runtimeRequired' => 'Требуется среда выполнения браузера',
			'settings.browser.statusDisabled' => 'отключён',
			'settings.browser.statusLabel' => 'Статус',
			'settings.browser.statusReady' => 'готов',
			'settings.browser.statusSetupRequired' => 'требуется настройка',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'Отмена',
			'settings.workspaces.create' => 'Добавить рабочую область',
			'settings.workspaces.deleteConfirm' => 'Удалить эту рабочую область из ddagent? Её файлы останутся на диске.',
			'settings.workspaces.deleteFailed' => 'Не удалось удалить рабочую область.',
			'settings.workspaces.deleteTitle' => 'Удалить рабочую область',
			'settings.workspaces.description' => 'Рабочие области — каталоги, в которых ddagent может вести чаты, запускать код и просматривать файлы.',
			'settings.workspaces.remove' => 'Удалить рабочую область',
			'settings.workspaces.title' => 'Рабочие области',
			'settings.about.supportTitle' => 'Поддержать проект',
			'settings.about.buyMeACoffee' => 'Угостите меня кофе',
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
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'Интерфейс AI помощника для программирования',
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
			'sidebar.messages.changeWorkspaceFailed' => 'Не удалось сменить рабочую область. Попробуйте снова.',
			'sidebar.messages.changeWorkspaceError' => 'Ошибка при смене рабочей области. Попробуйте снова.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(count, one: 'Не удалось удалить ${count} сессию. Попробуйте снова.', other: 'Не удалось удалить ${count} сессий. Попробуйте снова.', ), 
			'sidebar.version.updateAvailable' => 'Доступно обновление',
			'sidebar.version.restartRequired' => 'Обновление установлено — перезапустите сервер для применения',
			'sidebar.version.updateNow' => 'Обновить',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'Обновить ddagent до v${version}? Будет получен и собран последний код, сервер перезапустится — активные сессии будут прерваны.',
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
			'sidebar.panel.open' => 'Панель',
			'sidebar.panel.newChat' => 'Новый чат',
			'sidebar.panel.navigation' => 'Навигация',
			'sidebar.panel.sessions' => 'Сессии',
			'sidebar.workspace.title' => 'Сменить рабочую область сессии',
			'sidebar.workspace.description' => 'Агент выполняет следующие шаги в этом каталоге. Существующая история сессии сохраняется.',
			'sidebar.workspace.pathLabel' => 'Путь рабочей области',
			'sidebar.workspace.pathRequired' => 'Требуется путь рабочей области.',
			'sidebar.workspace.submit' => 'Сменить рабочую область',
			'sidebar.workspace.saving' => 'Смена…',
			'sidebar.workspace.changeAction' => 'Сменить рабочую область',
			'sidebar.recent.title' => 'Недавние разговоры',
			'sidebar.recent.emptyTitle' => 'Пока нет разговоров',
			'sidebar.recent.emptyDescription' => 'Здесь появятся ваши недавно обновлённые разговоры.',
			'sidebar.recent.loadFailed' => 'Не удалось загрузить недавние разговоры',
			'sidebar.recent.loadMore' => 'Загрузить более старые разговоры',
			'sidebar.recent.loadingMore' => 'Загрузка...',
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
			'tasks.statuses.pending' => 'Ожидание',
			'tasks.statuses.inProgress' => 'В процессе',
			'tasks.statuses.done' => 'Выполнено',
			'tasks.statuses.blocked' => 'Заблокировано',
			'tasks.statuses.deferred' => 'Отложено',
			'tasks.statuses.cancelled' => 'Отменено',
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
			'knowledge.settings.description' => 'Локальный слой памяти для агентов: память, правила, навыки и личные данные.',
			_ => null,
		};
	}
}
