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
	@override late final Translations$chat$input$es input = Translations$chat$input$es._(_root);
	@override late final Translations$chat$composer$es composer = Translations$chat$composer$es._(_root);
	@override late final Translations$chat$providerSelection$es providerSelection = Translations$chat$providerSelection$es._(_root);
	@override late final Translations$chat$session$es session = Translations$chat$session$es._(_root);
	@override late final Translations$chat$shell$es shell = Translations$chat$shell$es._(_root);
	@override late final Translations$chat$claudeStatus$es claudeStatus = Translations$chat$claudeStatus$es._(_root);
	@override late final Translations$chat$projectSelection$es projectSelection = Translations$chat$projectSelection$es._(_root);
	@override late final Translations$chat$tasks$es tasks = Translations$chat$tasks$es._(_root);
	@override late final Translations$chat$voice$es voice = Translations$chat$voice$es._(_root);
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
	@override late final Translations$chat$paneHeader$es paneHeader = Translations$chat$paneHeader$es._(_root);
	@override late final Translations$chat$broadcast$es broadcast = Translations$chat$broadcast$es._(_root);
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
}

// Path: common
class Translations$common$es extends Translations$common$en {
	Translations$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$es buttons = Translations$common$buttons$es._(_root);
	@override late final Translations$common$tabs$es tabs = Translations$common$tabs$es._(_root);
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
	@override late final Translations$common$quota$es quota = Translations$common$quota$es._(_root);
	@override late final Translations$common$actions$es actions = Translations$common$actions$es._(_root);
	@override late final Translations$common$browserPane$es browserPane = Translations$common$browserPane$es._(_root);
	@override late final Translations$common$browserUse$es browserUse = Translations$common$browserUse$es._(_root);
	@override late final Translations$common$commandPalette$es commandPalette = Translations$common$commandPalette$es._(_root);
	@override late final Translations$common$gitPanel$es gitPanel = Translations$common$gitPanel$es._(_root);
	@override late final Translations$common$sessions$es sessions = Translations$common$sessions$es._(_root);
	@override late final Translations$common$projects$es projects = Translations$common$projects$es._(_root);
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
	@override late final Translations$settings$about$es about = Translations$settings$about$es._(_root);
}

// Path: sidebar
class Translations$sidebar$es extends Translations$sidebar$en {
	Translations$sidebar$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$es projects = Translations$sidebar$projects$es._(_root);
	@override late final Translations$sidebar$app$es app = Translations$sidebar$app$es._(_root);
	@override late final Translations$sidebar$sessions$es sessions = Translations$sidebar$sessions$es._(_root);
	@override late final Translations$sidebar$tooltips$es tooltips = Translations$sidebar$tooltips$es._(_root);
	@override late final Translations$sidebar$navigation$es navigation = Translations$sidebar$navigation$es._(_root);
	@override late final Translations$sidebar$actions$es actions = Translations$sidebar$actions$es._(_root);
	@override late final Translations$sidebar$branding$es branding = Translations$sidebar$branding$es._(_root);
	@override late final Translations$sidebar$status$es status = Translations$sidebar$status$es._(_root);
	@override late final Translations$sidebar$time$es time = Translations$sidebar$time$es._(_root);
	@override late final Translations$sidebar$messages$es messages = Translations$sidebar$messages$es._(_root);
	@override late final Translations$sidebar$version$es version = Translations$sidebar$version$es._(_root);
	@override late final Translations$sidebar$search$es search = Translations$sidebar$search$es._(_root);
	@override late final Translations$sidebar$deleteConfirmation$es deleteConfirmation = Translations$sidebar$deleteConfirmation$es._(_root);
	@override late final Translations$sidebar$zones$es zones = Translations$sidebar$zones$es._(_root);
	@override late final Translations$sidebar$panel$es panel = Translations$sidebar$panel$es._(_root);
	@override late final Translations$sidebar$workspace$es workspace = Translations$sidebar$workspace$es._(_root);
	@override late final Translations$sidebar$recent$es recent = Translations$sidebar$recent$es._(_root);
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
}

// Path: auth.login
class Translations$auth$login$es extends Translations$auth$login$en {
	Translations$auth$login$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bienvenido de nuevo';
	@override String get description => 'Inicia sesión en tu cuenta autoalojada de ddagent';
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

// Path: chat.input
class Translations$chat$input$es extends Translations$chat$input$en {
	Translations$chat$input$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Escribe / para comandos, @ para archivos, o pregúntale lo que quieras a ${provider}...';
	@override String get placeholderDefault => 'Escribe tu mensaje...';
	@override String get disabled => 'Entrada deshabilitada';
	@override String get attachFiles => 'Adjuntar archivos';
	@override String get attachImages => 'Adjuntar imágenes';
	@override String get send => 'Enviar';
	@override String get stop => 'Detener';
	@override late final Translations$chat$input$hintText$es hintText = Translations$chat$input$hintText$es._(_root);
	@override String get clickToChangeMode => 'Haz clic para cambiar el modo de permisos (o pulsa Tab en el campo de texto)';
	@override String get showAllCommands => 'Mostrar todos los comandos';
	@override String get clearInput => 'Limpiar entrada';
	@override String get scrollToBottom => 'Ir al final';
	@override late final Translations$chat$input$queue$es queue = Translations$chat$input$queue$es._(_root);
	@override String get attachFilesDesc => 'Subir fotos, archivos o documentos';
	@override String get takePhoto => 'Tomar foto';
	@override String get takePhotoDesc => 'Usar la cámara para capturar una foto';
	@override String get moreTools => 'Más herramientas';
	@override String get commandsDesc => 'Explorar atajos y comandos';
	@override String get clearInputDesc => 'Descartar el texto actual';
	@override String get newMessage => 'Nuevo mensaje';
	@override String get newMessages => 'Nuevos mensajes';
	@override String get autoContinueTasks => 'Continuación automática';
	@override String get autoContinueTasksTooltip => 'Activa para que Devin continúe automáticamente con la siguiente tarea de Task Master';
	@override late final Translations$chat$input$offlineQueue$es offlineQueue = Translations$chat$input$offlineQueue$es._(_root);
}

// Path: chat.composer
class Translations$chat$composer$es extends Translations$chat$composer$en {
	Translations$chat$composer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get reasoning => 'Razonamiento';
	@override String get model => 'Modelo';
	@override String get effortDefault => 'Predeterminado';
	@override String get loadingModels => 'Cargando modelos…';
	@override String get modelMenu => 'Seleccionar modelo y esfuerzo de razonamiento';
	@override String permissionHeading({required Object provider}) => '¿Cómo deben aprobarse las acciones de ${provider}?';
	@override String get toolsAndActions => 'Herramientas y acciones';
	@override String get toolsAndActionsDesc => 'Herramientas y controles del editor de chat';
	@override String get favorites => 'Favoritos';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$es extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Elige tu asistente de IA';
	@override String get description => 'Selecciona un proveedor para iniciar una conversación nueva';
	@override String get selectModel => 'Seleccionar modelo';
	@override late final Translations$chat$providerSelection$providerInfo$es providerInfo = Translations$chat$providerSelection$providerInfo$es._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$es readyPrompt = Translations$chat$providerSelection$readyPrompt$es._(_root);
	@override String pressToSearch({required Object shortcut}) => 'Pulsa <kbd>${shortcut}</kbd> para buscar sesiones, archivos y commits';
	@override String get workspace => 'Espacio de trabajo';
	@override String get noWorkspace => 'Ninguno';
	@override String get clickToChangeWorkspace => 'Haz clic para cambiar de espacio de trabajo';
	@override String get chooseWorkspace => 'Elegir un espacio de trabajo';
	@override String get searchWorkspaces => 'Buscar espacios de trabajo...';
	@override String get noWorkspacesFound => 'No se encontraron espacios de trabajo.';
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
	@override late final Translations$chat$claudeStatus$controls$es controls = Translations$chat$claudeStatus$controls$es._(_root);
	@override late final Translations$chat$claudeStatus$providers$es providers = Translations$chat$claudeStatus$providers$es._(_root);
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
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$es extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Añadir panel de chat';
	@override String get addBrowser => 'Añadir panel de navegador';
	@override String get addTerminal => 'Añadir panel de terminal';
	@override String get overview => 'Mostrar todos los paneles';
	@override String get exitFocusMode => 'Salir del modo enfoque (Ctrl+Mayús+F)';
	@override String get focusMode => 'Modo enfoque (Ctrl+Mayús+F)';
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
}

// Path: chat.attachments
class Translations$chat$attachments$es extends Translations$chat$attachments$en {
	Translations$chat$attachments$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'Descarga fallida — clic para reintentar';
	@override String get fileAttachment => 'Archivo adjunto';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$es extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Creando instantánea…';
	@override String get revertChanges => 'Revertir archivos al último checkpoint';
	@override String get undo => 'Deshacer checkpoint';
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
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$es extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Ver el consumo de tokens de la sesión';
	@override String get title => 'Uso de tokens';
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
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$es extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Procesando…';
	@override String get switchSession => 'Cambiar sesión';
}

// Path: chat.broadcast
class Translations$chat$broadcast$es extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => 'Seleccionar orquestadores';
	@override String get orchestratorsOnly => 'Solo orquestadores';
	@override String get noOrchestrators => 'No hay sesiones de orquestador disponibles';
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
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$es extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Líneas:';
	@override String get characters => 'Caracteres:';
	@override String get shortcuts => 'Ctrl+S para guardar • Esc para cerrar';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$es extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Archivo binario';
	@override String message({required Object fileName}) => 'El archivo "${fileName}" no se puede mostrar en el editor de texto porque es un archivo binario.';
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
	@override String get browser => 'Navegador';
	@override String get computer => 'Equipo';
	@override String get board => 'Tablero';
	@override String get usage => 'AI Control';
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
	@override String get loading => 'Cargando ddagent';
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
	@override String get clearSearch => 'Limpiar búsqueda';
	@override String get name => 'Nombre';
	@override String get size => 'Tamaño';
	@override String get modified => 'Modificado';
	@override String get permissions => 'Permisos';
	@override String get noFilesFound => 'No se encontraron archivos';
	@override String get checkProjectPath => 'Comprueba si la ruta del proyecto es accesible';
	@override String get noMatchesFound => 'No se encontraron coincidencias';
	@override String get tryDifferentSearch => 'Prueba con otro término o limpia la búsqueda';
	@override String get justNow => 'justo ahora';
	@override String minAgo({required Object count}) => 'hace ${count} min';
	@override String hoursAgo({required Object count}) => 'hace ${count} horas';
	@override String daysAgo({required Object count}) => 'hace ${count} días';
	@override String get newFile => 'Archivo nuevo (Cmd+N)';
	@override String get newFolder => 'Carpeta nueva (Cmd+Shift+N)';
	@override String get refresh => 'Actualizar';
	@override String get collapseAll => 'Contraer todo';
	@override late final Translations$common$fileTree$context$es context = Translations$common$fileTree$context$es._(_root);
	@override String get searchContentPlaceholder => 'Buscar en archivos...';
	@override String get searchInFiles => 'Buscar en archivos';
	@override String get searchByName => 'Buscar por nombre';
	@override String get loadFailed => 'No se pudieron cargar los archivos';
	@override String get noSearchResults => 'No se encontraron coincidencias';
	@override String get searchError => 'Error en la búsqueda';
	@override String get searching => 'Buscando...';
	@override String resultsTruncated({required Object count}) => 'Mostrando los primeros ${count} resultados';
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

// Path: common.quota
class Translations$common$quota$es extends Translations$common$quota$en {
	Translations$common$quota$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
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
	@override String get description => 'Reinicia el proceso de ddagent — útil tras una actualización o si algo se bloquea.';
	@override String get restart => 'Reiniciar';
	@override String get restartConfirm => '¿Reiniciar el servidor ddagent? Las sesiones activas se interrumpirán.';
	@override String get restarting => 'Reiniciando… la página se recargará cuando el servidor vuelva.';
	@override String get restartFailed => 'El reinicio falló';
	@override String get unsupported => 'El reinicio solo está disponible cuando el servidor se ejecuta bajo el gestor de servicios.';
}

// Path: settings.updates
class Translations$settings$updates$es extends Translations$settings$updates$en {
	Translations$settings$updates$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Actualizaciones de la app';
	@override String get description => 'Busca en GitHub una versión de escritorio más reciente. Las nuevas versiones se descargan automáticamente y se instalan al salir.';
	@override String get check => 'Buscar actualizaciones';
	@override String get checking => 'Buscando…';
	@override String upToDate({required Object version}) => 'Tienes la última versión (v${version}).';
	@override String available({required Object version}) => 'Actualización v${version} encontrada — descargando en segundo plano; se instalará al cerrar ddagent.';
	@override String downloaded({required Object version}) => 'Actualización v${version} descargada — cierra y reinicia ddagent para instalarla.';
	@override String get unavailable => 'La búsqueda de actualizaciones solo está disponible en builds de escritorio empaquetados.';
	@override String error({required Object message}) => 'Error al buscar actualizaciones: ${message}';
	@override String get errorGeneric => 'Error al buscar actualizaciones.';
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
	@override late final Translations$settings$terminalShortcuts$handle$es handle = Translations$settings$terminalShortcuts$handle$es._(_root);
	@override String get killTitle => 'Terminar proceso en ejecución (Ctrl+C)';
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
	@override String get appearance => 'Apariencia';
	@override String get git => 'Git';
	@override String get apiTokens => 'API y tokens';
	@override String get models => 'Modelos';
	@override String get tasks => 'Tareas';
	@override String get browser => 'Navegador';
	@override String get notifications => 'Notificaciones';
	@override String get about => 'Acerca de';
	@override String get workspaces => 'Espacios de trabajo';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$es extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
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
	@override late final Translations$settings$notifications$desktop$es desktop = Translations$settings$notifications$desktop$es._(_root);
	@override late final Translations$settings$notifications$sound$es sound = Translations$settings$notifications$sound$es._(_root);
	@override late final Translations$settings$notifications$events$es events = Translations$settings$notifications$events$es._(_root);
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$es extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$es darkMode = Translations$settings$appearanceSettings$darkMode$es._(_root);
	@override late final Translations$settings$appearanceSettings$projectSorting$es projectSorting = Translations$settings$appearanceSettings$projectSorting$es._(_root);
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
	@override late final Translations$settings$agents$account$es account = Translations$settings$agents$account$es._(_root);
	@override String get connectionStatus => 'Estado de la conexión';
	@override late final Translations$settings$agents$login$es login = Translations$settings$agents$login$es._(_root);
	@override String error({required Object error}) => 'Error: ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$es extends Translations$settings$permissions$en {
	Translations$settings$permissions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes de permisos';
	@override late final Translations$settings$permissions$skipPermissions$es skipPermissions = Translations$settings$permissions$skipPermissions$es._(_root);
	@override late final Translations$settings$permissions$allowedTools$es allowedTools = Translations$settings$permissions$allowedTools$es._(_root);
	@override late final Translations$settings$permissions$blockedTools$es blockedTools = Translations$settings$permissions$blockedTools$es._(_root);
	@override late final Translations$settings$permissions$allowedCommands$es allowedCommands = Translations$settings$permissions$allowedCommands$es._(_root);
	@override late final Translations$settings$permissions$blockedCommands$es blockedCommands = Translations$settings$permissions$blockedCommands$es._(_root);
	@override late final Translations$settings$permissions$toolExamples$es toolExamples = Translations$settings$permissions$toolExamples$es._(_root);
	@override late final Translations$settings$permissions$shellExamples$es shellExamples = Translations$settings$permissions$shellExamples$es._(_root);
	@override late final Translations$settings$permissions$codex$es codex = Translations$settings$permissions$codex$es._(_root);
	@override late final Translations$settings$permissions$actions$es actions = Translations$settings$permissions$actions$es._(_root);
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
	@override String get deleteConfirm => '¿Quitar este espacio de trabajo de ddagent? Sus archivos permanecen en el disco.';
	@override String get deleteFailed => 'No se pudo quitar el espacio de trabajo.';
	@override String get deleteTitle => 'Quitar espacio de trabajo';
	@override String get description => 'Los espacios de trabajo son directorios donde ddagent puede chatear, ejecutar código y navegar.';
	@override String get remove => 'Quitar espacio de trabajo';
	@override String get title => 'Espacios de trabajo';
}

// Path: settings.about
class Translations$settings$about$es extends Translations$settings$about$en {
	Translations$settings$about$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Apoya el proyecto';
	@override String get buyMeACoffee => 'Invítame a un café';
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
	@override String get title => 'ddagent';
	@override String get subtitle => 'Interfaz de asistente de programación con IA';
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
	@override String get changeWorkspaceFailed => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.';
	@override String get changeWorkspaceError => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.';
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
	@override String updateConfirm({required Object version}) => '¿Actualizar ddagent a v${version}? Se descargará y compilará el código más reciente y el servidor se reiniciará — las sesiones activas se interrumpirán.';
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
	@override String get ctrlEnter => 'Ctrl+Enter para enviar • Shift+Enter para nueva línea • Tab para cambiar de modo • / para comandos';
	@override String get enter => 'Enter para enviar • Shift+Enter para nueva línea • Tab para cambiar de modo • / para comandos';
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
	@override String get loadAll => 'Cargar todos los mensajes';
	@override String get loadingAll => 'Cargando todos los mensajes...';
	@override String get allLoaded => 'Todos los mensajes cargados';
	@override String get perfWarning => 'Todos los mensajes cargados — el desplazamiento puede ser más lento. Haz clic en "Ir al final" para recuperar el rendimiento.';
	@override String get loadOlderFailed => 'No se pudieron cargar mensajes anteriores.';
	@override String get retry => 'Reintentar';
	@override String get noSearchMatches => 'Ningún mensaje coincide con la búsqueda.';
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
	@override String get connect => 'Continuar en la shell';
	@override String get connectTitle => 'Conectar a la shell';
	@override String get kill => 'Terminar (SIGINT)';
	@override String get killTitle => 'Terminar proceso en ejecución (Ctrl+C)';
	@override String get copyOutput => 'Copiar salida';
	@override String get copyOutputTitle => 'Copiar salida del terminal';
	@override String get copied => '¡Copiado!';
	@override String get zoomInTitle => 'Acercar';
	@override String get zoomOutTitle => 'Alejar';
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

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$es extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ámbito';
	@override String get user => 'Usuario';
	@override String get project => 'Proyecto';
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

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$es extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$es extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
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
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$es taskTypes = Translations$settings$orchestration$rules$taskTypes$es._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$es extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$es modes = Translations$settings$orchestration$planner$modes$es._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$es modeHints = Translations$settings$orchestration$planner$modeHints$es._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$es templates = Translations$settings$orchestration$planner$templates$es._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$es extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$es onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$es._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$es extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

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
	@override String get iosHint => 'En iPhone/iPad, las notificaciones solo funcionan tras añadir ddagent a la pantalla de inicio (Compartir → Añadir a pantalla de inicio) y activarlas desde la app instalada.';
	@override String get test => 'Enviar notificación de prueba';
	@override String get testNoSubscription => 'Ningún dispositivo está suscrito. Toca «Activar» en el teléfono primero.';
	@override String testSuccess({required Object count}) => 'Enviado a ${count} dispositivo(s). Si no aparece nada en el teléfono, añade ddagent a la pantalla de inicio (iOS lo requiere).';
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

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$es extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Modo oscuro';
	@override String get description => 'Alterna entre el tema claro y el oscuro';
}

// Path: settings.appearanceSettings.projectSorting
class Translations$settings$appearanceSettings$projectSorting$es extends Translations$settings$appearanceSettings$projectSorting$en {
	Translations$settings$appearanceSettings$projectSorting$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Orden de proyectos';
	@override String get description => 'Cómo se ordenan los proyectos en la barra lateral';
	@override String get alphabetical => 'Alfabético';
	@override String get recentActivity => 'Actividad reciente';
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
}

// Path: settings.git.email
class Translations$settings$git$email$es extends Translations$settings$git$email$en {
	Translations$settings$git$email$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Correo para Git';
	@override String get help => 'Tu correo para los commits de git';
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
	@override String get authenticatedUser => 'usuario autenticado';
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

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$es extends Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get label => 'Omitir avisos de permisos (usar con precaución)';
	@override String get claudeDescription => 'Equivalente al flag --dangerously-skip-permissions';
	@override String get cursorDescription => 'Equivalente al flag -f en la CLI de Cursor';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$es extends Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Herramientas permitidas';
	@override String get description => 'Herramientas que se permiten automáticamente sin pedir permiso';
	@override String get placeholder => 'p. ej., "Bash(git log:*)" o "Write"';
	@override String get quickAdd => 'Añadir rápido herramientas comunes:';
	@override String get empty => 'No hay herramientas permitidas configuradas';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$es extends Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Herramientas bloqueadas';
	@override String get description => 'Herramientas que se bloquean automáticamente sin pedir permiso';
	@override String get placeholder => 'p. ej., "Bash(rm:*)"';
	@override String get empty => 'No hay herramientas bloqueadas configuradas';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$es extends Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Comandos de shell permitidos';
	@override String get description => 'Comandos de shell que se permiten automáticamente sin preguntar';
	@override String get placeholder => 'p. ej., "Shell(ls)" o "Shell(git status)"';
	@override String get quickAdd => 'Añadir rápido comandos comunes:';
	@override String get empty => 'No hay comandos permitidos configurados';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$es extends Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Comandos de shell bloqueados';
	@override String get description => 'Comandos de shell que se bloquean automáticamente';
	@override String get placeholder => 'p. ej., "Shell(rm -rf)" o "Shell(sudo)"';
	@override String get empty => 'No hay comandos bloqueados configurados';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$es extends Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ejemplos de patrones de herramientas:';
	@override String get bashGitLog => '- Permitir todos los comandos git log';
	@override String get bashGitDiff => '- Permitir todos los comandos git diff';
	@override String get write => '- Permitir todo uso de la herramienta Write';
	@override String get bashRm => '- Bloquear todos los comandos rm (peligroso)';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$es extends Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ejemplos de comandos de shell:';
	@override String get ls => '- Permitir el comando ls';
	@override String get gitStatus => '- Permitir git status';
	@override String get npmInstall => '- Permitir npm install';
	@override String get rmRf => '- Bloquear el borrado recursivo';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$es extends Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'Modo de permisos';
	@override String get description => 'Controla cómo Codex gestiona las modificaciones de archivos y la ejecución de comandos';
	@override late final Translations$settings$permissions$codex$modes$es modes = Translations$settings$permissions$codex$modes$es._(_root);
	@override String get technicalDetails => 'Detalles técnicos';
	@override late final Translations$settings$permissions$codex$technicalInfo$es technicalInfo = Translations$settings$permissions$codex$technicalInfo$es._(_root);
}

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$es extends Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get add => 'Añadir';
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
	@override String get hint => 'Gestionado por ddagent.';
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
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
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

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$es extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manual — solo recomendación';
	@override String get ask => 'Preguntar antes de cambiar de cuenta';
	@override String get autoLowRisk => 'Cambio automático para tareas de bajo riesgo';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$es extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

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
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$es extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

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
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$es extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$es extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
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

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$es extends Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$codex$modes$kDefault$es kDefault = Translations$settings$permissions$codex$modes$kDefault$es._(_root);
	@override late final Translations$settings$permissions$codex$modes$acceptEdits$es acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$es._(_root);
	@override late final Translations$settings$permissions$codex$modes$bypassPermissions$es bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$es._(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$es extends Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Comandos de confianza: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (sin -exec), etc.';
	@override String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never. Todos los comandos se autoejecutan dentro del directorio del proyecto.';
	@override String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never. Acceso completo al sistema; úsalo solo en entornos de confianza.';
	@override String get overrideNote => 'Puedes cambiar esto por sesión con el botón de modo en la interfaz del chat.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$es extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$es kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$es._(_root);
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

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$es extends Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Por defecto';
	@override String get description => 'Solo los comandos de confianza (ls, cat, grep, git status, etc.) se ejecutan automáticamente. Los demás comandos se omiten. Puede escribir en el espacio de trabajo.';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$es extends Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aceptar ediciones';
	@override String get description => 'Todos los comandos se ejecutan automáticamente dentro del espacio de trabajo. Modo automático completo con ejecución en sandbox.';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$es extends Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Omitir permisos';
	@override String get description => 'Acceso completo al sistema sin restricciones. Todos los comandos se ejecutan automáticamente con acceso total a disco y red. Úsalo con precaución.';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$es extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Por defecto';
	@override String get description => 'Las acciones que necesitan permiso se te muestran para aprobación en el chat.';
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
			'auth.login.description' => 'Inicia sesión en tu cuenta autoalojada de ddagent',
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
			'chat.json.response' => 'Respuesta JSON',
			'chat.permissions.grant' => ({required Object tool}) => 'Conceder permiso para ${tool}',
			'chat.permissions.added' => 'Permiso añadido',
			'chat.permissions.addTo' => ({required Object entry}) => 'Añade ${entry} a las herramientas permitidas.',
			'chat.permissions.retry' => 'Permiso guardado. Reintenta la solicitud para usar la herramienta.',
			'chat.permissions.error' => 'No se pudieron actualizar los permisos. Inténtalo de nuevo.',
			'chat.permissions.openSettings' => 'Abrir ajustes',
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
			'chat.input.placeholder' => ({required Object provider}) => 'Escribe / para comandos, @ para archivos, o pregúntale lo que quieras a ${provider}...',
			'chat.input.placeholderDefault' => 'Escribe tu mensaje...',
			'chat.input.disabled' => 'Entrada deshabilitada',
			'chat.input.attachFiles' => 'Adjuntar archivos',
			'chat.input.attachImages' => 'Adjuntar imágenes',
			'chat.input.send' => 'Enviar',
			'chat.input.stop' => 'Detener',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter para enviar • Shift+Enter para nueva línea • Tab para cambiar de modo • / para comandos',
			'chat.input.hintText.enter' => 'Enter para enviar • Shift+Enter para nueva línea • Tab para cambiar de modo • / para comandos',
			'chat.input.hintText.queue' => 'Enter para poner en cola tu siguiente mensaje',
			'chat.input.hintText.updateQueued' => 'Enter para actualizar el mensaje en cola',
			'chat.input.clickToChangeMode' => 'Haz clic para cambiar el modo de permisos (o pulsa Tab en el campo de texto)',
			'chat.input.showAllCommands' => 'Mostrar todos los comandos',
			'chat.input.clearInput' => 'Limpiar entrada',
			'chat.input.scrollToBottom' => 'Ir al final',
			'chat.input.queue.sendNext' => 'Poner en cola el siguiente mensaje',
			'chat.input.queue.update' => 'Actualizar mensaje en cola',
			'chat.input.queue.label' => 'En cola',
			'chat.input.queue.willSend' => 'Se enviará cuando esto termine',
			'chat.input.queue.edit' => 'Editar mensaje en cola',
			'chat.input.queue.delete' => 'Eliminar mensaje en cola',
			'chat.input.queue.failed' => 'Falló el envío',
			'chat.input.queue.sendNow' => 'Enviar ahora',
			'chat.input.attachFilesDesc' => 'Subir fotos, archivos o documentos',
			'chat.input.takePhoto' => 'Tomar foto',
			'chat.input.takePhotoDesc' => 'Usar la cámara para capturar una foto',
			'chat.input.moreTools' => 'Más herramientas',
			'chat.input.commandsDesc' => 'Explorar atajos y comandos',
			'chat.input.clearInputDesc' => 'Descartar el texto actual',
			'chat.input.newMessage' => 'Nuevo mensaje',
			'chat.input.newMessages' => 'Nuevos mensajes',
			'chat.input.autoContinueTasks' => 'Continuación automática',
			'chat.input.autoContinueTasksTooltip' => 'Activa para que Devin continúe automáticamente con la siguiente tarea de Task Master',
			'chat.input.offlineQueue.clear' => 'Cancelar y vaciar la cola sin conexión',
			'chat.input.offlineQueue.clearBtn' => 'Cancelar',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} mensajes en cola sin conexión — se enviarán automáticamente al reconectar',
			'chat.input.offlineQueue.single' => '1 mensaje en cola sin conexión — se enviará automáticamente al reconectar',
			'chat.composer.reasoning' => 'Razonamiento',
			'chat.composer.model' => 'Modelo',
			'chat.composer.effortDefault' => 'Predeterminado',
			'chat.composer.loadingModels' => 'Cargando modelos…',
			'chat.composer.modelMenu' => 'Seleccionar modelo y esfuerzo de razonamiento',
			'chat.composer.permissionHeading' => ({required Object provider}) => '¿Cómo deben aprobarse las acciones de ${provider}?',
			'chat.composer.toolsAndActions' => 'Herramientas y acciones',
			'chat.composer.toolsAndActionsDesc' => 'Herramientas y controles del editor de chat',
			'chat.composer.favorites' => 'Favoritos',
			'chat.providerSelection.title' => 'Elige tu asistente de IA',
			'chat.providerSelection.description' => 'Selecciona un proveedor para iniciar una conversación nueva',
			'chat.providerSelection.selectModel' => 'Seleccionar modelo',
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
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Pulsa <kbd>${shortcut}</kbd> para buscar sesiones, archivos y commits',
			'chat.providerSelection.workspace' => 'Espacio de trabajo',
			'chat.providerSelection.noWorkspace' => 'Ninguno',
			'chat.providerSelection.clickToChangeWorkspace' => 'Haz clic para cambiar de espacio de trabajo',
			'chat.providerSelection.chooseWorkspace' => 'Elegir un espacio de trabajo',
			'chat.providerSelection.searchWorkspaces' => 'Buscar espacios de trabajo...',
			'chat.providerSelection.noWorkspacesFound' => 'No se encontraron espacios de trabajo.',
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
			'chat.session.messages.loadAll' => 'Cargar todos los mensajes',
			'chat.session.messages.loadingAll' => 'Cargando todos los mensajes...',
			'chat.session.messages.allLoaded' => 'Todos los mensajes cargados',
			'chat.session.messages.perfWarning' => 'Todos los mensajes cargados — el desplazamiento puede ser más lento. Haz clic en "Ir al final" para recuperar el rendimiento.',
			'chat.session.messages.loadOlderFailed' => 'No se pudieron cargar mensajes anteriores.',
			'chat.session.messages.retry' => 'Reintentar',
			'chat.session.messages.noSearchMatches' => 'Ningún mensaje coincide con la búsqueda.',
			'chat.shell.selectProject.title' => 'Selecciona un proyecto',
			'chat.shell.selectProject.description' => 'Elige un proyecto para abrir una shell interactiva en ese directorio',
			'chat.shell.status.newSession' => 'Sesión nueva',
			'chat.shell.status.initializing' => 'Inicializando...',
			'chat.shell.status.restarting' => 'Reiniciando...',
			'chat.shell.actions.disconnect' => 'Desconectar',
			'chat.shell.actions.disconnectTitle' => 'Desconectar de la shell',
			'chat.shell.actions.restart' => 'Reiniciar',
			'chat.shell.actions.restartTitle' => 'Reiniciar shell',
			'chat.shell.actions.connect' => 'Continuar en la shell',
			'chat.shell.actions.connectTitle' => 'Conectar a la shell',
			'chat.shell.actions.kill' => 'Terminar (SIGINT)',
			'chat.shell.actions.killTitle' => 'Terminar proceso en ejecución (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Copiar salida',
			'chat.shell.actions.copyOutputTitle' => 'Copiar salida del terminal',
			'chat.shell.actions.copied' => '¡Copiado!',
			'chat.shell.actions.zoomInTitle' => 'Acercar',
			'chat.shell.actions.zoomOutTitle' => 'Alejar',
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
			'chat.claudeStatus.controls.stopGeneration' => 'Detener generación',
			'chat.claudeStatus.controls.pressEscToStop' => 'Pulsa Esc en cualquier momento para detener',
			'chat.claudeStatus.providers.assistant' => 'Asistente',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'Selecciona un proyecto para empezar a chatear con ${provider}',
			'chat.tasks.nextTaskPrompt' => 'Empezar la siguiente tarea',
			'chat.voice.autoRead' => 'Leer respuestas en voz alta',
			'chat.voice.autoReadOn' => 'Lectura de respuestas: activada',
			'chat.voice.autoReadOff' => 'Lectura de respuestas: desactivada',
			'chat.voice.autoReadVoice' => 'Voz de lectura',
			'chat.voice.autoReadVoiceAuto' => 'Voz automática',
			'chat.voice.autoReadPreview' => 'Así sonarán las respuestas.',
			'chat.voice.speakMessage' => 'Leer en voz alta',
			'chat.voice.stopSpeaking' => 'Detener lectura',
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
			'chat.splitWorkspace.addChat' => 'Añadir panel de chat',
			'chat.splitWorkspace.addBrowser' => 'Añadir panel de navegador',
			'chat.splitWorkspace.addTerminal' => 'Añadir panel de terminal',
			'chat.splitWorkspace.overview' => 'Mostrar todos los paneles',
			'chat.splitWorkspace.exitFocusMode' => 'Salir del modo enfoque (Ctrl+Mayús+F)',
			'chat.splitWorkspace.focusMode' => 'Modo enfoque (Ctrl+Mayús+F)',
			'chat.splitWorkspace.browseSessions' => 'Abrir lista de sesiones',
			'chat.splitOverview.title' => 'Vista general de paneles divididos',
			'chat.splitOverview.count' => ({required Object count}) => '${count} paneles',
			'chat.splitOverview.close' => 'Cerrar vista general',
			'chat.splitOverview.question' => 'PREGUNTA — se requiere entrada',
			'chat.splitOverview.processing' => 'PROCESANDO',
			'chat.splitOverview.idle' => 'Inactivo',
			'chat.splitOverview.active' => 'Activa',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} necesita tu respuesta',
			'chat.attachments.downloadFailedRetry' => 'Descarga fallida — clic para reintentar',
			'chat.attachments.fileAttachment' => 'Archivo adjunto',
			'chat.checkpoint.creating' => 'Creando instantánea…',
			'chat.checkpoint.revertChanges' => 'Revertir archivos al último checkpoint',
			'chat.checkpoint.undo' => 'Deshacer checkpoint',
			'chat.common.close' => 'Cerrar',
			'chat.taskMaster.saveToTask' => 'Tarea',
			'chat.taskMaster.saved' => 'Guardado',
			'chat.taskMaster.saving' => 'Guardando...',
			'chat.taskMaster.taskShort' => 'TAREA',
			'chat.tokenUsage.desc' => 'Ver el consumo de tokens de la sesión',
			'chat.tokenUsage.title' => 'Uso de tokens',
			'chat.tool.emptyResult' => '(sin salida aún — la herramienta devolvió un resultado vacío)',
			'chat.quotaBadge.ariaLabel' => 'Límites de suscripción',
			'chat.quotaBadge.noData' => 'No hay datos de suscripción para este modelo',
			'chat.paneHeader.processing' => 'Procesando…',
			'chat.paneHeader.switchSession' => 'Cambiar sesión',
			'chat.broadcast.selectOrchestrators' => 'Seleccionar orquestadores',
			'chat.broadcast.orchestratorsOnly' => 'Solo orquestadores',
			'chat.broadcast.noOrchestrators' => 'No hay sesiones de orquestador disponibles',
			'codeEditor.toolbar.changes' => 'cambios',
			'codeEditor.toolbar.previousChange' => 'Cambio anterior',
			'codeEditor.toolbar.nextChange' => 'Cambio siguiente',
			'codeEditor.toolbar.hideDiff' => 'Ocultar resaltado de diferencias',
			'codeEditor.toolbar.showDiff' => 'Mostrar resaltado de diferencias',
			'codeEditor.toolbar.settings' => 'Ajustes del editor',
			'codeEditor.toolbar.collapse' => 'Contraer editor',
			'codeEditor.toolbar.expand' => 'Expandir editor a ancho completo',
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
			'codeEditor.footer.lines' => 'Líneas:',
			'codeEditor.footer.characters' => 'Caracteres:',
			'codeEditor.footer.shortcuts' => 'Ctrl+S para guardar • Esc para cerrar',
			'codeEditor.binaryFile.title' => 'Archivo binario',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'El archivo "${fileName}" no se puede mostrar en el editor de texto porque es un archivo binario.',
			'codeEditor.filePreview.loading' => 'Cargando vista previa...',
			'codeEditor.filePreview.error' => 'No se puede mostrar este archivo.',
			'codeEditor.filePreview.openInNewTab' => 'Abrir en una pestaña nueva',
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
			'common.tabs.chat' => 'Chat',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => 'Archivos',
			'common.tabs.git' => 'Control de versiones',
			'common.tabs.tasks' => 'Tareas',
			'common.tabs.browser' => 'Navegador',
			'common.tabs.computer' => 'Equipo',
			'common.tabs.board' => 'Tablero',
			'common.tabs.usage' => 'AI Control',
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
			'common.mainContent.loading' => 'Cargando ddagent',
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
			'common.fileTree.clearSearch' => 'Limpiar búsqueda',
			'common.fileTree.name' => 'Nombre',
			'common.fileTree.size' => 'Tamaño',
			'common.fileTree.modified' => 'Modificado',
			'common.fileTree.permissions' => 'Permisos',
			'common.fileTree.noFilesFound' => 'No se encontraron archivos',
			'common.fileTree.checkProjectPath' => 'Comprueba si la ruta del proyecto es accesible',
			'common.fileTree.noMatchesFound' => 'No se encontraron coincidencias',
			'common.fileTree.tryDifferentSearch' => 'Prueba con otro término o limpia la búsqueda',
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
			'common.fileTree.searchContentPlaceholder' => 'Buscar en archivos...',
			'common.fileTree.searchInFiles' => 'Buscar en archivos',
			'common.fileTree.searchByName' => 'Buscar por nombre',
			'common.fileTree.loadFailed' => 'No se pudieron cargar los archivos',
			'common.fileTree.noSearchResults' => 'No se encontraron coincidencias',
			'common.fileTree.searchError' => 'Error en la búsqueda',
			'common.fileTree.searching' => 'Buscando...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'Mostrando los primeros ${count} resultados',
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
			_ => null,
		} ?? switch (path) {
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
			'common.quota.controlCenter' => 'AI Control Center',
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
			_ => null,
		} ?? switch (path) {
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
			'common.sessions.renameSession' => 'Renombrar sesión',
			'common.projects.newSession' => 'Nueva sesión',
			'settings.title' => 'Ajustes',
			'settings.changelog.title' => 'Registro de cambios',
			'settings.changelog.loading' => 'Cargando…',
			'settings.changelog.empty' => 'No hay versiones para mostrar',
			'settings.changelog.current' => 'actual',
			'settings.changelog.kNew' => 'nueva',
			'settings.server.title' => 'Servidor',
			'settings.server.description' => 'Reinicia el proceso de ddagent — útil tras una actualización o si algo se bloquea.',
			'settings.server.restart' => 'Reiniciar',
			'settings.server.restartConfirm' => '¿Reiniciar el servidor ddagent? Las sesiones activas se interrumpirán.',
			'settings.server.restarting' => 'Reiniciando… la página se recargará cuando el servidor vuelva.',
			'settings.server.restartFailed' => 'El reinicio falló',
			'settings.server.unsupported' => 'El reinicio solo está disponible cuando el servidor se ejecuta bajo el gestor de servicios.',
			'settings.updates.title' => 'Actualizaciones de la app',
			'settings.updates.description' => 'Busca en GitHub una versión de escritorio más reciente. Las nuevas versiones se descargan automáticamente y se instalan al salir.',
			'settings.updates.check' => 'Buscar actualizaciones',
			'settings.updates.checking' => 'Buscando…',
			'settings.updates.upToDate' => ({required Object version}) => 'Tienes la última versión (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'Actualización v${version} encontrada — descargando en segundo plano; se instalará al cerrar ddagent.',
			'settings.updates.downloaded' => ({required Object version}) => 'Actualización v${version} descargada — cierra y reinicia ddagent para instalarla.',
			'settings.updates.unavailable' => 'La búsqueda de actualizaciones solo está disponible en builds de escritorio empaquetados.',
			'settings.updates.error' => ({required Object message}) => 'Error al buscar actualizaciones: ${message}',
			'settings.updates.errorGeneric' => 'Error al buscar actualizaciones.',
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
			'settings.appearance.editorTheme' => 'Tema del editor',
			'settings.appearance.wordWrap' => 'Ajuste de línea',
			'settings.appearance.showMinimap' => 'Mostrar minimapa',
			'settings.appearance.lineNumbers' => 'Números de línea',
			'settings.appearance.fontSize' => 'Tamaño de fuente',
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
			'settings.terminalShortcuts.title' => 'Atajos de terminal',
			'settings.terminalShortcuts.sectionKeys' => 'Teclas',
			'settings.terminalShortcuts.sectionNavigation' => 'Navegación',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Flecha arriba',
			'settings.terminalShortcuts.arrowDown' => 'Flecha abajo',
			'settings.terminalShortcuts.scrollDown' => 'Desplazar hacia abajo',
			'settings.terminalShortcuts.handle.closePanel' => 'Cerrar panel de atajos',
			'settings.terminalShortcuts.handle.openPanel' => 'Abrir panel de atajos',
			'settings.terminalShortcuts.killTitle' => 'Terminar proceso en ejecución (Ctrl+C)',
			'settings.terminalShortcuts.paste' => 'Pegar',
			'settings.mainTabs.label' => 'Ajustes',
			'settings.mainTabs.agents' => 'Agentes',
			'settings.mainTabs.orchestration' => 'Orquestación',
			'settings.mainTabs.appearance' => 'Apariencia',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API y tokens',
			'settings.mainTabs.models' => 'Modelos',
			'settings.mainTabs.tasks' => 'Tareas',
			'settings.mainTabs.browser' => 'Navegador',
			'settings.mainTabs.notifications' => 'Notificaciones',
			'settings.mainTabs.about' => 'Acerca de',
			'settings.mainTabs.workspaces' => 'Espacios de trabajo',
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
			'settings.notifications.title' => 'Notificaciones',
			'settings.notifications.description' => 'Controla qué eventos de notificación recibes.',
			'settings.notifications.webPush.title' => 'Notificar en este navegador',
			'settings.notifications.webPush.enable' => 'Activar notificaciones',
			'settings.notifications.webPush.disable' => 'Desactivar notificaciones',
			'settings.notifications.webPush.enabled' => 'Las notificaciones están activadas en este navegador',
			'settings.notifications.webPush.loading' => 'Actualizando...',
			'settings.notifications.webPush.unsupported' => 'Las notificaciones push no son compatibles con este navegador.',
			'settings.notifications.webPush.denied' => 'Las notificaciones push están bloqueadas. Permítelas en los ajustes de tu navegador.',
			'settings.notifications.webPush.iosHint' => 'En iPhone/iPad, las notificaciones solo funcionan tras añadir ddagent a la pantalla de inicio (Compartir → Añadir a pantalla de inicio) y activarlas desde la app instalada.',
			'settings.notifications.webPush.test' => 'Enviar notificación de prueba',
			'settings.notifications.webPush.testNoSubscription' => 'Ningún dispositivo está suscrito. Toca «Activar» en el teléfono primero.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => 'Enviado a ${count} dispositivo(s). Si no aparece nada en el teléfono, añade ddagent a la pantalla de inicio (iOS lo requiere).',
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
			'settings.appearanceSettings.darkMode.label' => 'Modo oscuro',
			'settings.appearanceSettings.darkMode.description' => 'Alterna entre el tema claro y el oscuro',
			'settings.appearanceSettings.projectSorting.label' => 'Orden de proyectos',
			'settings.appearanceSettings.projectSorting.description' => 'Cómo se ordenan los proyectos en la barra lateral',
			'settings.appearanceSettings.projectSorting.alphabetical' => 'Alfabético',
			'settings.appearanceSettings.projectSorting.recentActivity' => 'Actividad reciente',
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
			'settings.git.email.label' => 'Correo para Git',
			'settings.git.email.help' => 'Tu correo para los commits de git',
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
			'settings.agents.authStatus.authenticatedUser' => 'usuario autenticado',
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
			'settings.agents.error' => ({required Object error}) => 'Error: ${error}',
			'settings.permissions.title' => 'Ajustes de permisos',
			'settings.permissions.skipPermissions.label' => 'Omitir avisos de permisos (usar con precaución)',
			'settings.permissions.skipPermissions.claudeDescription' => 'Equivalente al flag --dangerously-skip-permissions',
			'settings.permissions.skipPermissions.cursorDescription' => 'Equivalente al flag -f en la CLI de Cursor',
			'settings.permissions.allowedTools.title' => 'Herramientas permitidas',
			'settings.permissions.allowedTools.description' => 'Herramientas que se permiten automáticamente sin pedir permiso',
			'settings.permissions.allowedTools.placeholder' => 'p. ej., "Bash(git log:*)" o "Write"',
			'settings.permissions.allowedTools.quickAdd' => 'Añadir rápido herramientas comunes:',
			'settings.permissions.allowedTools.empty' => 'No hay herramientas permitidas configuradas',
			'settings.permissions.blockedTools.title' => 'Herramientas bloqueadas',
			'settings.permissions.blockedTools.description' => 'Herramientas que se bloquean automáticamente sin pedir permiso',
			'settings.permissions.blockedTools.placeholder' => 'p. ej., "Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => 'No hay herramientas bloqueadas configuradas',
			'settings.permissions.allowedCommands.title' => 'Comandos de shell permitidos',
			'settings.permissions.allowedCommands.description' => 'Comandos de shell que se permiten automáticamente sin preguntar',
			'settings.permissions.allowedCommands.placeholder' => 'p. ej., "Shell(ls)" o "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => 'Añadir rápido comandos comunes:',
			'settings.permissions.allowedCommands.empty' => 'No hay comandos permitidos configurados',
			'settings.permissions.blockedCommands.title' => 'Comandos de shell bloqueados',
			'settings.permissions.blockedCommands.description' => 'Comandos de shell que se bloquean automáticamente',
			'settings.permissions.blockedCommands.placeholder' => 'p. ej., "Shell(rm -rf)" o "Shell(sudo)"',
			'settings.permissions.blockedCommands.empty' => 'No hay comandos bloqueados configurados',
			'settings.permissions.toolExamples.title' => 'Ejemplos de patrones de herramientas:',
			'settings.permissions.toolExamples.bashGitLog' => '- Permitir todos los comandos git log',
			'settings.permissions.toolExamples.bashGitDiff' => '- Permitir todos los comandos git diff',
			'settings.permissions.toolExamples.write' => '- Permitir todo uso de la herramienta Write',
			'settings.permissions.toolExamples.bashRm' => '- Bloquear todos los comandos rm (peligroso)',
			'settings.permissions.shellExamples.title' => 'Ejemplos de comandos de shell:',
			'settings.permissions.shellExamples.ls' => '- Permitir el comando ls',
			'settings.permissions.shellExamples.gitStatus' => '- Permitir git status',
			'settings.permissions.shellExamples.npmInstall' => '- Permitir npm install',
			'settings.permissions.shellExamples.rmRf' => '- Bloquear el borrado recursivo',
			'settings.permissions.codex.permissionMode' => 'Modo de permisos',
			'settings.permissions.codex.description' => 'Controla cómo Codex gestiona las modificaciones de archivos y la ejecución de comandos',
			'settings.permissions.codex.modes.kDefault.title' => 'Por defecto',
			'settings.permissions.codex.modes.kDefault.description' => 'Solo los comandos de confianza (ls, cat, grep, git status, etc.) se ejecutan automáticamente. Los demás comandos se omiten. Puede escribir en el espacio de trabajo.',
			'settings.permissions.codex.modes.acceptEdits.title' => 'Aceptar ediciones',
			'settings.permissions.codex.modes.acceptEdits.description' => 'Todos los comandos se ejecutan automáticamente dentro del espacio de trabajo. Modo automático completo con ejecución en sandbox.',
			'settings.permissions.codex.modes.bypassPermissions.title' => 'Omitir permisos',
			'settings.permissions.codex.modes.bypassPermissions.description' => 'Acceso completo al sistema sin restricciones. Todos los comandos se ejecutan automáticamente con acceso total a disco y red. Úsalo con precaución.',
			'settings.permissions.codex.technicalDetails' => 'Detalles técnicos',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Comandos de confianza: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (sin -exec), etc.',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never. Todos los comandos se autoejecutan dentro del directorio del proyecto.',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never. Acceso completo al sistema; úsalo solo en entornos de confianza.',
			'settings.permissions.codex.technicalInfo.overrideNote' => 'Puedes cambiar esto por sesión con el botón de modo en la interfaz del chat.',
			'settings.permissions.actions.add' => 'Añadir',
			'settings.permissions.permissionMode.title' => 'Modo de permisos',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Modo de permiso predeterminado para nuevas sesiones de ${provider}. Aún puedes anularlo para una sesión individual.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Por defecto',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'Las acciones que necesitan permiso se te muestran para aprobación en el chat.',
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
			'settings.mcpServers.managed.hint' => 'Gestionado por ddagent.',
			'settings.mcpServers.help.title' => 'Acerca de MCP en Codex',
			'settings.mcpServers.help.description' => 'Codex admite servidores MCP basados en stdio. Puedes añadir servidores que amplíen las capacidades de Codex con herramientas y recursos adicionales.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '«${serverName}» se eliminará de la configuración del proveedor.',
			'settings.mcpServers.deleteConfirm.title' => '¿Eliminar el servidor MCP?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
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
			_ => null,
		} ?? switch (path) {
			'settings.workspaces.deleteConfirm' => '¿Quitar este espacio de trabajo de ddagent? Sus archivos permanecen en el disco.',
			'settings.workspaces.deleteFailed' => 'No se pudo quitar el espacio de trabajo.',
			'settings.workspaces.deleteTitle' => 'Quitar espacio de trabajo',
			'settings.workspaces.description' => 'Los espacios de trabajo son directorios donde ddagent puede chatear, ejecutar código y navegar.',
			'settings.workspaces.remove' => 'Quitar espacio de trabajo',
			'settings.workspaces.title' => 'Espacios de trabajo',
			'settings.about.supportTitle' => 'Apoya el proyecto',
			'settings.about.buyMeACoffee' => 'Invítame a un café',
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
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'Interfaz de asistente de programación con IA',
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
			'sidebar.messages.changeWorkspaceFailed' => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.',
			'sidebar.messages.changeWorkspaceError' => 'Error al cambiar de espacio de trabajo. Inténtalo de nuevo.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(count, one: 'Error al eliminar ${count} sesión. Inténtalo de nuevo.', other: 'Error al eliminar ${count} sesiones. Inténtalo de nuevo.', ), 
			'sidebar.version.updateAvailable' => 'Actualización disponible',
			'sidebar.version.restartRequired' => 'Actualización instalada — reinicia el servidor para aplicarla',
			'sidebar.version.updateNow' => 'Actualizar ahora',
			'sidebar.version.updateConfirm' => ({required Object version}) => '¿Actualizar ddagent a v${version}? Se descargará y compilará el código más reciente y el servidor se reiniciará — las sesiones activas se interrumpirán.',
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
			'sidebar.panel.open' => 'Panel',
			'sidebar.panel.newChat' => 'Nuevo chat',
			'sidebar.panel.navigation' => 'Navegación',
			'sidebar.panel.sessions' => 'Sesiones',
			'sidebar.workspace.title' => 'Cambiar el espacio de trabajo de la sesión',
			'sidebar.workspace.description' => 'El agente ejecuta sus próximos turnos en este directorio. El historial de sesión existente se conserva.',
			'sidebar.workspace.pathLabel' => 'Ruta del espacio de trabajo',
			'sidebar.workspace.pathRequired' => 'La ruta del espacio de trabajo es obligatoria.',
			'sidebar.workspace.submit' => 'Cambiar espacio de trabajo',
			'sidebar.workspace.saving' => 'Cambiando…',
			'sidebar.workspace.changeAction' => 'Cambiar espacio de trabajo',
			'sidebar.recent.title' => 'Conversaciones recientes',
			'sidebar.recent.emptyTitle' => 'Aún no hay conversaciones',
			'sidebar.recent.emptyDescription' => 'Tus conversaciones actualizadas más recientemente aparecerán aquí.',
			'sidebar.recent.loadFailed' => 'No se pudieron cargar las conversaciones recientes',
			'sidebar.recent.loadMore' => 'Cargar conversaciones anteriores',
			'sidebar.recent.loadingMore' => 'Cargando más...',
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
			'tasks.statuses.pending' => 'Pendiente',
			'tasks.statuses.inProgress' => 'En curso',
			'tasks.statuses.done' => 'Hecha',
			'tasks.statuses.blocked' => 'Bloqueada',
			'tasks.statuses.deferred' => 'Aplazada',
			'tasks.statuses.cancelled' => 'Cancelada',
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
			_ => null,
		};
	}
}
