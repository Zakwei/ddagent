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
class TranslationsKo extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKo({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsKo _root = this; // ignore: unused_field

	@override 
	TranslationsKo $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKo(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$ko auth = Translations$auth$ko._(_root);
	@override late final Translations$chat$ko chat = Translations$chat$ko._(_root);
	@override late final Translations$codeEditor$ko codeEditor = Translations$codeEditor$ko._(_root);
	@override late final Translations$common$ko common = Translations$common$ko._(_root);
	@override late final Translations$settings$ko settings = Translations$settings$ko._(_root);
	@override late final Translations$sidebar$ko sidebar = Translations$sidebar$ko._(_root);
	@override late final Translations$tasks$ko tasks = Translations$tasks$ko._(_root);
	@override late final Translations$knowledge$ko knowledge = Translations$knowledge$ko._(_root);
}

// Path: auth
class Translations$auth$ko extends Translations$auth$en {
	Translations$auth$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => '세션이 만료되었습니다. 다시 로그인하세요.';
	@override late final Translations$auth$login$ko login = Translations$auth$login$ko._(_root);
	@override late final Translations$auth$register$ko register = Translations$auth$register$ko._(_root);
	@override late final Translations$auth$logout$ko logout = Translations$auth$logout$ko._(_root);
}

// Path: chat
class Translations$chat$ko extends Translations$chat$en {
	Translations$chat$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$ko codeBlock = Translations$chat$codeBlock$ko._(_root);
	@override late final Translations$chat$copyMessage$ko copyMessage = Translations$chat$copyMessage$ko._(_root);
	@override late final Translations$chat$messageTypes$ko messageTypes = Translations$chat$messageTypes$ko._(_root);
	@override late final Translations$chat$tools$ko tools = Translations$chat$tools$ko._(_root);
	@override late final Translations$chat$search$ko search = Translations$chat$search$ko._(_root);
	@override late final Translations$chat$fileOperations$ko fileOperations = Translations$chat$fileOperations$ko._(_root);
	@override late final Translations$chat$interactive$ko interactive = Translations$chat$interactive$ko._(_root);
	@override late final Translations$chat$thinking$ko thinking = Translations$chat$thinking$ko._(_root);
	@override late final Translations$chat$json$ko json = Translations$chat$json$ko._(_root);
	@override late final Translations$chat$permissions$ko permissions = Translations$chat$permissions$ko._(_root);
	@override late final Translations$chat$todo$ko todo = Translations$chat$todo$ko._(_root);
	@override late final Translations$chat$plan$ko plan = Translations$chat$plan$ko._(_root);
	@override late final Translations$chat$usageLimit$ko usageLimit = Translations$chat$usageLimit$ko._(_root);
	@override late final Translations$chat$codex$ko codex = Translations$chat$codex$ko._(_root);
	@override late final Translations$chat$input$ko input = Translations$chat$input$ko._(_root);
	@override late final Translations$chat$providerSelection$ko providerSelection = Translations$chat$providerSelection$ko._(_root);
	@override late final Translations$chat$session$ko session = Translations$chat$session$ko._(_root);
	@override late final Translations$chat$shell$ko shell = Translations$chat$shell$ko._(_root);
	@override late final Translations$chat$claudeStatus$ko claudeStatus = Translations$chat$claudeStatus$ko._(_root);
	@override late final Translations$chat$projectSelection$ko projectSelection = Translations$chat$projectSelection$ko._(_root);
	@override late final Translations$chat$tasks$ko tasks = Translations$chat$tasks$ko._(_root);
	@override late final Translations$chat$voice$ko voice = Translations$chat$voice$ko._(_root);
	@override late final Translations$chat$composer$ko composer = Translations$chat$composer$ko._(_root);
	@override late final Translations$chat$splitSession$ko splitSession = Translations$chat$splitSession$ko._(_root);
	@override late final Translations$chat$sessionPicker$ko sessionPicker = Translations$chat$sessionPicker$ko._(_root);
	@override late final Translations$chat$splitWorkspace$ko splitWorkspace = Translations$chat$splitWorkspace$ko._(_root);
	@override late final Translations$chat$splitOverview$ko splitOverview = Translations$chat$splitOverview$ko._(_root);
	@override late final Translations$chat$askUserQuestion$ko askUserQuestion = Translations$chat$askUserQuestion$ko._(_root);
	@override late final Translations$chat$attachments$ko attachments = Translations$chat$attachments$ko._(_root);
	@override late final Translations$chat$checkpoint$ko checkpoint = Translations$chat$checkpoint$ko._(_root);
	@override late final Translations$chat$common$ko common = Translations$chat$common$ko._(_root);
	@override late final Translations$chat$taskMaster$ko taskMaster = Translations$chat$taskMaster$ko._(_root);
	@override late final Translations$chat$tokenUsage$ko tokenUsage = Translations$chat$tokenUsage$ko._(_root);
	@override late final Translations$chat$tool$ko tool = Translations$chat$tool$ko._(_root);
	@override late final Translations$chat$quotaBadge$ko quotaBadge = Translations$chat$quotaBadge$ko._(_root);
	@override late final Translations$chat$paneHeader$ko paneHeader = Translations$chat$paneHeader$ko._(_root);
	@override late final Translations$chat$broadcast$ko broadcast = Translations$chat$broadcast$ko._(_root);
}

// Path: codeEditor
class Translations$codeEditor$ko extends Translations$codeEditor$en {
	Translations$codeEditor$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$ko toolbar = Translations$codeEditor$toolbar$ko._(_root);
	@override String loading({required Object fileName}) => '${fileName} 로딩 중...';
	@override late final Translations$codeEditor$header$ko header = Translations$codeEditor$header$ko._(_root);
	@override late final Translations$codeEditor$actions$ko actions = Translations$codeEditor$actions$ko._(_root);
	@override late final Translations$codeEditor$footer$ko footer = Translations$codeEditor$footer$ko._(_root);
	@override late final Translations$codeEditor$binaryFile$ko binaryFile = Translations$codeEditor$binaryFile$ko._(_root);
	@override late final Translations$codeEditor$filePreview$ko filePreview = Translations$codeEditor$filePreview$ko._(_root);
}

// Path: common
class Translations$common$ko extends Translations$common$en {
	Translations$common$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$ko buttons = Translations$common$buttons$ko._(_root);
	@override late final Translations$common$tabs$ko tabs = Translations$common$tabs$ko._(_root);
	@override late final Translations$common$status$ko status = Translations$common$status$ko._(_root);
	@override late final Translations$common$messages$ko messages = Translations$common$messages$ko._(_root);
	@override late final Translations$common$navigation$ko navigation = Translations$common$navigation$ko._(_root);
	@override late final Translations$common$common$ko common = Translations$common$common$ko._(_root);
	@override late final Translations$common$time$ko time = Translations$common$time$ko._(_root);
	@override late final Translations$common$fileOperations$ko fileOperations = Translations$common$fileOperations$ko._(_root);
	@override late final Translations$common$mainContent$ko mainContent = Translations$common$mainContent$ko._(_root);
	@override late final Translations$common$fileTree$ko fileTree = Translations$common$fileTree$ko._(_root);
	@override late final Translations$common$projectWizard$ko projectWizard = Translations$common$projectWizard$ko._(_root);
	@override late final Translations$common$notifications$ko notifications = Translations$common$notifications$ko._(_root);
	@override late final Translations$common$versionUpdate$ko versionUpdate = Translations$common$versionUpdate$ko._(_root);
	@override late final Translations$common$quota$ko quota = Translations$common$quota$ko._(_root);
	@override late final Translations$common$actions$ko actions = Translations$common$actions$ko._(_root);
	@override late final Translations$common$browserPane$ko browserPane = Translations$common$browserPane$ko._(_root);
	@override late final Translations$common$browserUse$ko browserUse = Translations$common$browserUse$ko._(_root);
	@override late final Translations$common$commandPalette$ko commandPalette = Translations$common$commandPalette$ko._(_root);
	@override late final Translations$common$gitPanel$ko gitPanel = Translations$common$gitPanel$ko._(_root);
	@override late final Translations$common$sessions$ko sessions = Translations$common$sessions$ko._(_root);
	@override late final Translations$common$projects$ko projects = Translations$common$projects$ko._(_root);
}

// Path: settings
class Translations$settings$ko extends Translations$settings$en {
	Translations$settings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '설정';
	@override late final Translations$settings$changelog$ko changelog = Translations$settings$changelog$ko._(_root);
	@override late final Translations$settings$server$ko server = Translations$settings$server$ko._(_root);
	@override late final Translations$settings$updates$ko updates = Translations$settings$updates$ko._(_root);
	@override late final Translations$settings$tabs$ko tabs = Translations$settings$tabs$ko._(_root);
	@override late final Translations$settings$account$ko account = Translations$settings$account$ko._(_root);
	@override late final Translations$settings$mcp$ko mcp = Translations$settings$mcp$ko._(_root);
	@override late final Translations$settings$appearance$ko appearance = Translations$settings$appearance$ko._(_root);
	@override late final Translations$settings$actions$ko actions = Translations$settings$actions$ko._(_root);
	@override late final Translations$settings$quickSettings$ko quickSettings = Translations$settings$quickSettings$ko._(_root);
	@override late final Translations$settings$terminalShortcuts$ko terminalShortcuts = Translations$settings$terminalShortcuts$ko._(_root);
	@override late final Translations$settings$mainTabs$ko mainTabs = Translations$settings$mainTabs$ko._(_root);
	@override late final Translations$settings$orchestration$ko orchestration = Translations$settings$orchestration$ko._(_root);
	@override late final Translations$settings$notifications$ko notifications = Translations$settings$notifications$ko._(_root);
	@override late final Translations$settings$appearanceSettings$ko appearanceSettings = Translations$settings$appearanceSettings$ko._(_root);
	@override late final Translations$settings$mcpForm$ko mcpForm = Translations$settings$mcpForm$ko._(_root);
	@override late final Translations$settings$saveStatus$ko saveStatus = Translations$settings$saveStatus$ko._(_root);
	@override late final Translations$settings$footerActions$ko footerActions = Translations$settings$footerActions$ko._(_root);
	@override late final Translations$settings$git$ko git = Translations$settings$git$ko._(_root);
	@override late final Translations$settings$apiKeys$ko apiKeys = Translations$settings$apiKeys$ko._(_root);
	@override late final Translations$settings$tasks$ko tasks = Translations$settings$tasks$ko._(_root);
	@override late final Translations$settings$agents$ko agents = Translations$settings$agents$ko._(_root);
	@override late final Translations$settings$permissions$ko permissions = Translations$settings$permissions$ko._(_root);
	@override late final Translations$settings$mcpServers$ko mcpServers = Translations$settings$mcpServers$ko._(_root);
	@override late final Translations$settings$quota$ko quota = Translations$settings$quota$ko._(_root);
	@override late final Translations$settings$browser$ko browser = Translations$settings$browser$ko._(_root);
	@override late final Translations$settings$workspaces$ko workspaces = Translations$settings$workspaces$ko._(_root);
	@override late final Translations$settings$about$ko about = Translations$settings$about$ko._(_root);
}

// Path: sidebar
class Translations$sidebar$ko extends Translations$sidebar$en {
	Translations$sidebar$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$ko projects = Translations$sidebar$projects$ko._(_root);
	@override late final Translations$sidebar$app$ko app = Translations$sidebar$app$ko._(_root);
	@override late final Translations$sidebar$sessions$ko sessions = Translations$sidebar$sessions$ko._(_root);
	@override late final Translations$sidebar$tooltips$ko tooltips = Translations$sidebar$tooltips$ko._(_root);
	@override late final Translations$sidebar$navigation$ko navigation = Translations$sidebar$navigation$ko._(_root);
	@override late final Translations$sidebar$actions$ko actions = Translations$sidebar$actions$ko._(_root);
	@override late final Translations$sidebar$branding$ko branding = Translations$sidebar$branding$ko._(_root);
	@override late final Translations$sidebar$status$ko status = Translations$sidebar$status$ko._(_root);
	@override late final Translations$sidebar$time$ko time = Translations$sidebar$time$ko._(_root);
	@override late final Translations$sidebar$messages$ko messages = Translations$sidebar$messages$ko._(_root);
	@override late final Translations$sidebar$version$ko version = Translations$sidebar$version$ko._(_root);
	@override late final Translations$sidebar$search$ko search = Translations$sidebar$search$ko._(_root);
	@override late final Translations$sidebar$deleteConfirmation$ko deleteConfirmation = Translations$sidebar$deleteConfirmation$ko._(_root);
	@override late final Translations$sidebar$zones$ko zones = Translations$sidebar$zones$ko._(_root);
	@override late final Translations$sidebar$panel$ko panel = Translations$sidebar$panel$ko._(_root);
	@override late final Translations$sidebar$workspace$ko workspace = Translations$sidebar$workspace$ko._(_root);
	@override late final Translations$sidebar$recent$ko recent = Translations$sidebar$recent$ko._(_root);
	@override late final Translations$sidebar$tabs$ko tabs = Translations$sidebar$tabs$ko._(_root);
}

// Path: tasks
class Translations$tasks$ko extends Translations$tasks$en {
	Translations$tasks$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$ko notConfigured = Translations$tasks$notConfigured$ko._(_root);
	@override late final Translations$tasks$gettingStarted$ko gettingStarted = Translations$tasks$gettingStarted$ko._(_root);
	@override late final Translations$tasks$setupModal$ko setupModal = Translations$tasks$setupModal$ko._(_root);
	@override late final Translations$tasks$helpGuide$ko helpGuide = Translations$tasks$helpGuide$ko._(_root);
	@override late final Translations$tasks$search$ko search = Translations$tasks$search$ko._(_root);
	@override late final Translations$tasks$filters$ko filters = Translations$tasks$filters$ko._(_root);
	@override late final Translations$tasks$sort$ko sort = Translations$tasks$sort$ko._(_root);
	@override late final Translations$tasks$views$ko views = Translations$tasks$views$ko._(_root);
	@override late final Translations$tasks$kanban$ko kanban = Translations$tasks$kanban$ko._(_root);
	@override late final Translations$tasks$buttons$ko buttons = Translations$tasks$buttons$ko._(_root);
	@override late final Translations$tasks$prd$ko prd = Translations$tasks$prd$ko._(_root);
	@override late final Translations$tasks$statuses$ko statuses = Translations$tasks$statuses$ko._(_root);
	@override late final Translations$tasks$priorities$ko priorities = Translations$tasks$priorities$ko._(_root);
	@override late final Translations$tasks$noMatchingTasks$ko noMatchingTasks = Translations$tasks$noMatchingTasks$ko._(_root);
	@override late final Translations$tasks$board$ko board = Translations$tasks$board$ko._(_root);
	@override late final Translations$tasks$card$ko card = Translations$tasks$card$ko._(_root);
	@override late final Translations$tasks$createTask$ko createTask = Translations$tasks$createTask$ko._(_root);
	@override late final Translations$tasks$list$ko list = Translations$tasks$list$ko._(_root);
	@override late final Translations$tasks$nextTask$ko nextTask = Translations$tasks$nextTask$ko._(_root);
	@override late final Translations$tasks$taskDetail$ko taskDetail = Translations$tasks$taskDetail$ko._(_root);
}

// Path: knowledge
class Translations$knowledge$ko extends Translations$knowledge$en {
	Translations$knowledge$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '지식';
	@override late final Translations$knowledge$tabs$ko tabs = Translations$knowledge$tabs$ko._(_root);
	@override late final Translations$knowledge$common$ko common = Translations$knowledge$common$ko._(_root);
	@override late final Translations$knowledge$actions$ko actions = Translations$knowledge$actions$ko._(_root);
	@override late final Translations$knowledge$dialog$ko dialog = Translations$knowledge$dialog$ko._(_root);
	@override late final Translations$knowledge$fields$ko fields = Translations$knowledge$fields$ko._(_root);
	@override late final Translations$knowledge$dashboard$ko dashboard = Translations$knowledge$dashboard$ko._(_root);
	@override late final Translations$knowledge$empty$ko empty = Translations$knowledge$empty$ko._(_root);
	@override late final Translations$knowledge$history$ko history = Translations$knowledge$history$ko._(_root);
	@override late final Translations$knowledge$priorities$ko priorities = Translations$knowledge$priorities$ko._(_root);
	@override late final Translations$knowledge$search$ko search = Translations$knowledge$search$ko._(_root);
	@override late final Translations$knowledge$links$ko links = Translations$knowledge$links$ko._(_root);
	@override late final Translations$knowledge$tags$ko tags = Translations$knowledge$tags$ko._(_root);
	@override late final Translations$knowledge$settings$ko settings = Translations$knowledge$settings$ko._(_root);
}

// Path: auth.login
class Translations$auth$login$ko extends Translations$auth$login$en {
	Translations$auth$login$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '다시 오신 것을 환영합니다';
	@override String get description => 'ddagent 계정에 로그인하세요';
	@override String get username => '사용자명';
	@override String get password => '비밀번호';
	@override String get submit => '로그인';
	@override String get loading => '로그인 중...';
	@override late final Translations$auth$login$errors$ko errors = Translations$auth$login$errors$ko._(_root);
	@override late final Translations$auth$login$placeholders$ko placeholders = Translations$auth$login$placeholders$ko._(_root);
}

// Path: auth.register
class Translations$auth$register$ko extends Translations$auth$register$en {
	Translations$auth$register$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '계정 생성';
	@override String get username => '사용자명';
	@override String get password => '비밀번호';
	@override String get confirmPassword => '비밀번호 확인';
	@override String get submit => '계정 생성';
	@override String get loading => '계정 생성 중...';
	@override late final Translations$auth$register$errors$ko errors = Translations$auth$register$errors$ko._(_root);
}

// Path: auth.logout
class Translations$auth$logout$ko extends Translations$auth$logout$en {
	Translations$auth$logout$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '로그아웃';
	@override String get confirm => '정말 로그아웃하시겠습니까?';
	@override String get button => '로그아웃';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$ko extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get copy => '복사';
	@override String get copied => '복사됨';
	@override String get copyCode => '코드 복사';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$ko extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get copy => '메시지 복사';
	@override String get copied => '메시지 복사됨';
	@override String get failed => '복사하지 못했습니다';
	@override String get selectFormat => '복사 형식 선택';
	@override String get copyAsMarkdown => '마크다운으로 복사';
	@override String get copyAsText => '텍스트로 복사';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$ko extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => '오류';
	@override String get tool => '도구';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
}

// Path: chat.tools
class Translations$chat$tools$ko extends Translations$chat$tools$en {
	Translations$chat$tools$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get settings => '도구 설정';
	@override String get error => '도구 오류';
	@override String get result => '도구 결과';
	@override String get viewParams => '입력 파라미터 보기';
	@override String get viewRawParams => 'Raw 파라미터 보기';
	@override String get viewDiff => '편집 Diff 보기:';
	@override String get creatingFile => '새 파일 생성:';
	@override String get updatingTodo => 'Todo 리스트 업데이트';
	@override String get read => '읽기';
	@override String get readFile => '파일 읽기';
	@override String get updateTodo => 'Todo 리스트 업데이트';
	@override String get readTodo => 'Todo 리스트 읽기';
	@override String get searchResults => '결과';
}

// Path: chat.search
class Translations$chat$search$ko extends Translations$chat$search$en {
	Translations$chat$search$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '${count}개의 ${type} 발견';
	@override String get file => '파일';
	@override String get files => '파일';
	@override String get pattern => '패턴:';
	@override String get kIn => '위치:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$ko extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get updated => '파일이 업데이트되었습니다';
	@override String get created => '파일이 생성되었습니다';
	@override String get written => '파일이 작성되었습니다';
	@override String get diff => 'Diff';
	@override String get newFile => '새 파일';
	@override String get viewContent => '파일 내용 보기';
	@override String viewFullOutput({required Object count}) => '전체 출력 보기 (${count}자)';
	@override String get contentDisplayed => '파일 내용이 위의 Diff 보기에 표시됩니다';
}

// Path: chat.interactive
class Translations$chat$interactive$ko extends Translations$chat$interactive$en {
	Translations$chat$interactive$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '대화형 프롬프트';
	@override String get waiting => 'CLI에서 응답을 기다리는 중';
	@override String get instruction => 'Claude가 실행 중인 터미널에서 옵션을 선택해주세요.';
	@override String selectedOption({required Object number}) => '✓ Claude가 옵션 ${number}을(를) 선택했습니다';
	@override String get instructionDetail => 'CLI에서 화살표 키 또는 숫자를 입력하여 이 옵션을 대화형으로 선택합니다.';
}

// Path: chat.thinking
class Translations$chat$thinking$ko extends Translations$chat$thinking$en {
	Translations$chat$thinking$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '생각 중...';
	@override String get emoji => '💭 생각 중...';
}

// Path: chat.json
class Translations$chat$json$ko extends Translations$chat$json$en {
	Translations$chat$json$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSON 응답';
}

// Path: chat.permissions
class Translations$chat$permissions$ko extends Translations$chat$permissions$en {
	Translations$chat$permissions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => '${tool}에 대한 권한 부여';
	@override String get added => '권한이 추가되었습니다';
	@override String addTo({required Object entry}) => '${entry}을(를) 허용된 도구에 추가합니다.';
	@override String get retry => '권한이 저장되었습니다. 도구를 사용하려면 요청을 재시도하세요.';
	@override String get error => '권한을 업데이트할 수 없습니다. 다시 시도해주세요.';
	@override String get openSettings => '설정 열기';
}

// Path: chat.todo
class Translations$chat$todo$ko extends Translations$chat$todo$en {
	Translations$chat$todo$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Todo 리스트가 업데이트되었습니다';
	@override String get current => '현재 Todo 리스트';
}

// Path: chat.plan
class Translations$chat$plan$ko extends Translations$chat$plan$en {
	Translations$chat$plan$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 구현 계획 보기';
	@override String get title => '구현 계획';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$ko extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Claude 사용량 한도에 도달했습니다. 한도는 **${time} ${timezone}** - ${date}에 초기화됩니다';
}

// Path: chat.codex
class Translations$chat$codex$ko extends Translations$chat$codex$en {
	Translations$chat$codex$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => '권한 모드';
	@override late final Translations$chat$codex$modes$ko modes = Translations$chat$codex$modes$ko._(_root);
	@override late final Translations$chat$codex$descriptions$ko descriptions = Translations$chat$codex$descriptions$ko._(_root);
	@override String get technicalDetails => '기술 상세';
}

// Path: chat.input
class Translations$chat$input$ko extends Translations$chat$input$en {
	Translations$chat$input$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => '/를 입력하여 명령어, @를 입력하여 파일, 또는 ${provider}에게 무엇이든 물어보세요...';
	@override String get placeholderDefault => '메시지를 입력하세요...';
	@override String get disabled => '입력 비활성화';
	@override String get attachFiles => '파일 첨부';
	@override String get attachImages => '이미지 첨부';
	@override String get send => '전송';
	@override String get stop => '중지';
	@override late final Translations$chat$input$hintText$ko hintText = Translations$chat$input$hintText$ko._(_root);
	@override String get clickToChangeMode => '클릭하여 권한 모드 변경';
	@override String get showAllCommands => '모든 명령어 보기';
	@override String get clearInput => '입력 지우기';
	@override String get scrollToBottom => '맨 아래로 스크롤';
	@override late final Translations$chat$input$queue$ko queue = Translations$chat$input$queue$ko._(_root);
	@override String get attachFilesDesc => '사진, 파일 또는 문서 업로드';
	@override String get takePhoto => '사진 촬영';
	@override String get takePhotoDesc => '카메라로 사진 촬영';
	@override String get moreTools => '더 많은 도구';
	@override String get commandsDesc => '단축키와 명령 탐색';
	@override String get clearInputDesc => '현재 텍스트 버리기';
	@override String get newMessage => '새 메시지';
	@override String get newMessages => '새 메시지들';
	@override String get autoContinueTasks => '자동 계속';
	@override String get autoContinueTasksTooltip => 'Devin이 다음 Task Master 작업으로 자동 진행하도록 활성화';
	@override late final Translations$chat$input$offlineQueue$ko offlineQueue = Translations$chat$input$offlineQueue$ko._(_root);
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$ko extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'AI 어시스턴트 선택';
	@override String get description => '새 대화를 시작할 프로바이더를 선택하세요';
	@override String get selectModel => '모델 선택';
	@override late final Translations$chat$providerSelection$providerInfo$ko providerInfo = Translations$chat$providerSelection$providerInfo$ko._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$ko readyPrompt = Translations$chat$providerSelection$readyPrompt$ko._(_root);
	@override String pressToSearch({required Object shortcut}) => '<kbd>${shortcut}</kbd>를 눌러 세션, 파일 및 커밋을 검색하세요';
	@override String get workspace => '작업 영역';
	@override String get noWorkspace => '없음';
	@override String get clickToChangeWorkspace => '클릭하여 작업 영역 변경';
	@override String get chooseWorkspace => '작업 영역 선택';
	@override String get searchWorkspaces => '작업 영역 검색...';
	@override String get noWorkspacesFound => '작업 영역을 찾을 수 없습니다.';
	@override String get all => '전체';
	@override String get free => '무료';
	@override String get noModelsFound => '모델을 찾을 수 없습니다.';
	@override String get paid => '유료';
	@override String get searchModels => '모델 검색...';
	@override String get addModel => '모델 추가';
	@override String get chooseModel => '모델 선택';
	@override String get chooseModelDescription => '기본 및 사용자 정의 모델을 하나의 목록에';
	@override String get clickToChange => '클릭하여 모델 변경';
	@override String get favorites => '즐겨찾기';
	@override String get loadingModels => '모델 로드 중…';
	@override String get manageModels => '모델 관리';
	@override String get refresh => '모델 새로고침';
}

// Path: chat.session
class Translations$chat$session$ko extends Translations$chat$session$en {
	Translations$chat$session$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$ko kContinue = Translations$chat$session$kContinue$ko._(_root);
	@override late final Translations$chat$session$loading$ko loading = Translations$chat$session$loading$ko._(_root);
	@override late final Translations$chat$session$messages$ko messages = Translations$chat$session$messages$ko._(_root);
}

// Path: chat.shell
class Translations$chat$shell$ko extends Translations$chat$shell$en {
	Translations$chat$shell$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$ko selectProject = Translations$chat$shell$selectProject$ko._(_root);
	@override late final Translations$chat$shell$status$ko status = Translations$chat$shell$status$ko._(_root);
	@override late final Translations$chat$shell$actions$ko actions = Translations$chat$shell$actions$ko._(_root);
	@override String get loading => '터미널 로딩 중...';
	@override String get connecting => 'Shell에 연결 중...';
	@override String get startSession => '새 Claude 세션 시작';
	@override String resumeSession({required Object displayName}) => '세션 재개: ${displayName}...';
	@override String runCommand({required Object projectName, required Object command}) => '${projectName}에서 ${command} 실행';
	@override String startCli({required Object projectName}) => '${projectName}에서 Claude CLI 시작';
	@override String get defaultCommand => '명령어';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$ko extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$ko actions = Translations$chat$claudeStatus$actions$ko._(_root);
	@override late final Translations$chat$claudeStatus$state$ko state = Translations$chat$claudeStatus$state$ko._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$ko elapsed = Translations$chat$claudeStatus$elapsed$ko._(_root);
	@override String get stop => '중지';
	@override late final Translations$chat$claudeStatus$controls$ko controls = Translations$chat$claudeStatus$controls$ko._(_root);
	@override late final Translations$chat$claudeStatus$providers$ko providers = Translations$chat$claudeStatus$providers$ko._(_root);
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$ko extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => '${provider}와 채팅을 시작하려면 프로젝트를 선택하세요';
}

// Path: chat.tasks
class Translations$chat$tasks$ko extends Translations$chat$tasks$en {
	Translations$chat$tasks$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => '다음 작업 시작';
}

// Path: chat.voice
class Translations$chat$voice$ko extends Translations$chat$voice$en {
	Translations$chat$voice$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get autoRead => '답변 소리 내어 읽기';
	@override String get autoReadOn => '답변 읽기: 켬';
	@override String get autoReadOff => '답변 읽기: 끔';
	@override String get autoReadVoice => '읽기 음성';
	@override String get autoReadVoiceAuto => '자동 음성';
	@override String get autoReadPreview => '답변이 이렇게 들립니다.';
	@override String get speakMessage => '소리 내어 읽기';
	@override String get stopSpeaking => '읽기 중지';
}

// Path: chat.composer
class Translations$chat$composer$ko extends Translations$chat$composer$en {
	Translations$chat$composer$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => '도구 및 작업';
	@override String get toolsAndActionsDesc => '채팅 입력창의 도구와 컨트롤';
	@override String get reasoning => '추론';
	@override String get model => '모델';
	@override String get effortDefault => '기본값';
	@override String get loadingModels => '모델 로드 중…';
	@override String get modelMenu => '모델 및 추론 수준 선택';
	@override String permissionHeading({required Object provider}) => '${provider} 작업을 어떻게 승인할까요?';
	@override String get favorites => '즐겨찾기';
}

// Path: chat.splitSession
class Translations$chat$splitSession$ko extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get toggle => '세션 분할';
	@override String get close => '분할 세션 닫기';
	@override String get selectSession => '비교할 세션 선택';
	@override String get noOtherSessions => '다른 세션이 없습니다';
	@override String get newSessionOption => '+ 분할 보기에서 새 세션';
	@override String currentProjectGroup({required Object name}) => '현재 프로젝트 (${name})';
	@override String get otherProjectsGroup => '다른 프로젝트';
	@override String get recentSessionsGroup => '최근 세션';
	@override String get startNewSession => '분할 보기에서 새 세션 시작';
	@override String get selectFromList => '기존 세션 목록에서 세션 선택';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$ko extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '세션 선택';
	@override String get searchPlaceholder => '세션 검색...';
	@override String get clearSearch => '검색 지우기';
	@override String get newChat => '+ 새 채팅';
	@override String get archivedToggle => '보관됨';
	@override String get changeSession => '세션 변경';
	@override String get archivedLoading => '보관된 세션 로드 중...';
	@override String get archivedError => '보관된 세션을 불러올 수 없습니다';
	@override String get archivedEmpty => '보관된 세션 없음';
	@override String get archivedProjectOnly => '작업 영역이 보관됨 — 세션을 보려면 복원하세요.';
	@override String get emptySearch => '검색과 일치하는 세션이 없습니다';
	@override String get restore => '복원';
	@override String get restoreSession => '세션 복원';
	@override String get restoreProject => '작업 영역 복원';
	@override String get restoreSessionFailed => '세션 복원에 실패했습니다. 다시 시도하세요.';
	@override String get restoreProjectFailed => '작업 영역 복원에 실패했습니다. 다시 시도하세요.';
	@override String get archiveFailed => '세션 보관에 실패했습니다. 다시 시도하세요.';
	@override String get deleteFailed => '세션 삭제에 실패했습니다. 다시 시도하세요.';
	@override String get running => '세션 실행 중';
	@override String get unread => '읽지 않음 — 새 출력과 함께 완료됨';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$ko extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get addChat => '채팅 창 추가';
	@override String get addBrowser => '브라우저 창 추가';
	@override String get addTerminal => '터미널 창 추가';
	@override String get overview => '모든 창 표시';
	@override String get exitFocusMode => '포커스 모드 종료 (Ctrl+Shift+F)';
	@override String get focusMode => '포커스 모드 (Ctrl+Shift+F)';
	@override String get browseSessions => '세션 목록 열기';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$ko extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '분할 창 개요';
	@override String count({required Object count}) => '${count}개 창';
	@override String get close => '개요 닫기';
	@override String get question => '질문 — 입력 필요';
	@override String get processing => '처리 중';
	@override String get idle => '유휴';
	@override String get active => '활성';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$ko extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider}이(가) 입력을 기다립니다';
}

// Path: chat.attachments
class Translations$chat$attachments$ko extends Translations$chat$attachments$en {
	Translations$chat$attachments$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => '다운로드 실패 — 클릭하여 다시 시도';
	@override String get fileAttachment => '파일 첨부';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$ko extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get creating => '스냅샷 생성 중…';
	@override String get revertChanges => '파일을 마지막 체크포인트로 되돌리기';
	@override String get undo => '체크포인트 실행 취소';
}

// Path: chat.common
class Translations$chat$common$ko extends Translations$chat$common$en {
	Translations$chat$common$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get close => '닫기';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$ko extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => '작업';
	@override String get saved => '저장됨';
	@override String get saving => '저장 중...';
	@override String get taskShort => '작업';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$ko extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get desc => '세션 토큰 사용량 보기';
	@override String get title => '토큰 사용량';
}

// Path: chat.tool
class Translations$chat$tool$ko extends Translations$chat$tool$en {
	Translations$chat$tool$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(아직 출력 없음 — 도구가 빈 결과를 반환했습니다)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$ko extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => '구독 한도';
	@override String get noData => '이 모델에 대한 구독 데이터가 없습니다';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$ko extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get processing => '처리 중…';
	@override String get switchSession => '세션 전환';
}

// Path: chat.broadcast
class Translations$chat$broadcast$ko extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => '오케스트레이터 선택';
	@override String get orchestratorsOnly => '오케스트레이터만';
	@override String get noOrchestrators => '사용 가능한 오케스트레이터 세션이 없습니다';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$ko extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get changes => '변경사항';
	@override String get previousChange => '이전 변경';
	@override String get nextChange => '다음 변경';
	@override String get hideDiff => 'Diff 하이라이트 숨기기';
	@override String get showDiff => 'Diff 하이라이트 표시';
	@override String get settings => '에디터 설정';
	@override String get collapse => '에디터 접기';
	@override String get expand => '에디터 전체 너비로 펼치기';
}

// Path: codeEditor.header
class Translations$codeEditor$header$ko extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => '변경사항 표시';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$ko extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get copyPath => '파일 경로 복사';
	@override String get pathCopied => '파일 경로를 복사했습니다';
	@override String get download => '파일 다운로드';
	@override String get save => '저장';
	@override String get saving => '저장 중...';
	@override String get saved => '저장됨!';
	@override String get exitFullscreen => '전체화면 종료';
	@override String get fullscreen => '전체화면';
	@override String get close => '닫기';
	@override String get previewMarkdown => '마크다운 미리보기';
	@override String get editMarkdown => '마크다운 편집';
	@override String get pinFile => '파일을 컨텍스트에 고정';
	@override String get unpinFile => '파일을 컨텍스트에서 해제';
	@override String get previewHtml => '새 탭에서 HTML 미리보기 열기';
	@override String get retry => '다시 시도';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$ko extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get lines => '줄:';
	@override String get characters => '문자:';
	@override String get shortcuts => 'Ctrl+S로 저장 • Esc로 닫기';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$ko extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '바이너리 파일';
	@override String message({required Object fileName}) => '파일 "${fileName}"은(는) 바이너리 파일이므로 텍스트 편집기에서 표시할 수 없습니다.';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$ko extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '미리보기 로딩 중...';
	@override String get error => '이 파일을 표시할 수 없습니다.';
	@override String get openInNewTab => '새 탭에서 열기';
}

// Path: common.buttons
class Translations$common$buttons$ko extends Translations$common$buttons$en {
	Translations$common$buttons$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get save => '저장';
	@override String get cancel => '취소';
	@override String get delete => '삭제';
	@override String get create => '생성';
	@override String get edit => '편집';
	@override String get close => '닫기';
	@override String get confirm => '확인';
	@override String get submit => '제출';
	@override String get retry => '재시도';
	@override String get refresh => '새로고침';
	@override String get search => '검색';
	@override String get clear => '지우기';
	@override String get copy => '복사';
	@override String get download => '다운로드';
	@override String get upload => '업로드';
	@override String get browse => '찾아보기';
}

// Path: common.tabs
class Translations$common$tabs$ko extends Translations$common$tabs$en {
	Translations$common$tabs$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get chat => '채팅';
	@override String get shell => 'Shell';
	@override String get files => '파일';
	@override String get git => '소스 관리';
	@override String get tasks => '작업';
	@override String get browser => '브라우저';
	@override String get computer => '컴퓨터';
	@override String get board => '보드';
	@override String get usage => 'AI Control';
}

// Path: common.status
class Translations$common$status$ko extends Translations$common$status$en {
	Translations$common$status$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '로딩 중...';
	@override String get success => '성공';
	@override String get error => '오류';
	@override String get failed => '실패';
	@override String get pending => '대기 중';
	@override String get completed => '완료';
	@override String get inProgress => '진행 중';
}

// Path: common.messages
class Translations$common$messages$ko extends Translations$common$messages$en {
	Translations$common$messages$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => '저장되었습니다';
	@override String get deletedSuccessfully => '삭제되었습니다';
	@override String get updatedSuccessfully => '업데이트되었습니다';
	@override String get operationFailed => '작업 실패';
	@override String get networkError => '네트워크 오류. 연결을 확인해주세요.';
	@override String get unauthorized => '인증되지 않았습니다. 로그인해주세요.';
	@override String get notFound => '찾을 수 없음';
	@override String get invalidInput => '잘못된 입력';
	@override String get requiredField => '필수 항목입니다';
	@override String get unknownError => '알 수 없는 오류가 발생했습니다';
	@override String get renameSessionFailed => '세션 이름 변경에 실패했습니다. 다시 시도하세요.';
}

// Path: common.navigation
class Translations$common$navigation$ko extends Translations$common$navigation$en {
	Translations$common$navigation$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get settings => '설정';
	@override String get home => '홈';
	@override String get back => '뒤로';
	@override String get next => '다음';
	@override String get previous => '이전';
	@override String get logout => '로그아웃';
}

// Path: common.common
class Translations$common$common$ko extends Translations$common$common$en {
	Translations$common$common$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get language => '언어';
	@override String get theme => '테마';
	@override String get darkMode => '다크 모드';
	@override String get lightMode => '라이트 모드';
	@override String get name => '이름';
	@override String get description => '설명';
	@override String get enabled => '활성화';
	@override String get disabled => '비활성화';
	@override String get optional => '선택사항';
	@override String get version => '버전';
	@override String get select => '선택';
	@override String get selectAll => '전체 선택';
	@override String get deselectAll => '전체 해제';
	@override String get done => '완료';
	@override String get failed => '실패';
}

// Path: common.time
class Translations$common$time$ko extends Translations$common$time$en {
	Translations$common$time$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get justNow => '방금 전';
	@override String minutesAgo({required Object count}) => '${count}분 전';
	@override String hoursAgo({required Object count}) => '${count}시간 전';
	@override String daysAgo({required Object count}) => '${count}일 전';
	@override String get yesterday => '어제';
}

// Path: common.fileOperations
class Translations$common$fileOperations$ko extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get newFile => '새 파일';
	@override String get newFolder => '새 폴더';
	@override String get rename => '이름 변경';
	@override String get move => '이동';
	@override String get copyPath => '경로 복사';
	@override String get openInEditor => '에디터에서 열기';
}

// Path: common.mainContent
class Translations$common$mainContent$ko extends Translations$common$mainContent$en {
	Translations$common$mainContent$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => 'ddagent 로딩 중';
	@override String get settingUpWorkspace => '워크스페이스 설정 중...';
	@override String get chooseProject => '프로젝트 선택';
	@override String get selectProjectDescription => '사이드바에서 프로젝트를 선택하여 Claude와 코딩을 시작하세요. 각 프로젝트에는 채팅 세션과 파일 히스토리가 포함됩니다.';
	@override String get tip => '팁';
	@override String get createProjectMobile => '위의 메뉴 버튼을 눌러 프로젝트에 접근하세요';
	@override String get createProjectDesktop => '사이드바의 폴더 아이콘을 클릭하여 새 프로젝트를 생성하세요';
	@override String get newSession => '새 세션';
	@override String get untitledSession => '제목 없는 세션';
	@override String get projectFiles => '프로젝트 파일';
	@override String get focusMode => '포커스 모드 (Ctrl+Shift+F)';
	@override String get exitFocusMode => '포커스 모드 종료 (Ctrl+Shift+F)';
	@override String get splitSession => '세션 분할';
	@override String get closeSplitSession => '분할 세션 닫기';
	@override String get chooseWorkspace => '작업 영역 선택';
	@override String get chooseWorkspaceDescription => '이 채팅의 작업 영역을 선택하거나 설정에서 새로 만드세요.';
	@override String get createWorkspace => '설정에서 작업 영역 만들기';
	@override String get recentProjects => '최근 프로젝트';
}

// Path: common.fileTree
class Translations$common$fileTree$ko extends Translations$common$fileTree$en {
	Translations$common$fileTree$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '파일 로딩 중...';
	@override String get files => '파일';
	@override String get simpleView => '간단히 보기';
	@override String get compactView => '컴팩트 보기';
	@override String get detailedView => '상세히 보기';
	@override String get searchPlaceholder => '파일 및 폴더 검색...';
	@override String get clearSearch => '검색 지우기';
	@override String get name => '이름';
	@override String get size => '크기';
	@override String get modified => '수정일';
	@override String get permissions => '권한';
	@override String get noFilesFound => '파일을 찾을 수 없음';
	@override String get checkProjectPath => '프로젝트 경로가 접근 가능한지 확인하세요';
	@override String get noMatchesFound => '일치하는 항목 없음';
	@override String get tryDifferentSearch => '다른 검색어를 시도하거나 검색을 지우세요';
	@override String get justNow => '방금 전';
	@override String minAgo({required Object count}) => '${count}분 전';
	@override String hoursAgo({required Object count}) => '${count}시간 전';
	@override String daysAgo({required Object count}) => '${count}일 전';
	@override String get newFile => '새 파일 (Cmd+N)';
	@override String get newFolder => '새 폴더 (Cmd+Shift+N)';
	@override String get refresh => '새로고침';
	@override String get collapseAll => '모두 접기';
	@override late final Translations$common$fileTree$context$ko context = Translations$common$fileTree$context$ko._(_root);
	@override String get searchContentPlaceholder => '파일 내 검색...';
	@override String get searchInFiles => '파일 내 검색';
	@override String get searchByName => '이름으로 검색';
	@override String get loadFailed => '파일을 불러올 수 없습니다';
	@override String get noSearchResults => '일치하는 항목 없음';
	@override String get searchError => '검색 실패';
	@override String get searching => '검색 중...';
	@override String resultsTruncated({required Object count}) => '처음 ${count}개 결과 표시';
	@override String get allWorkspaces => '모든 작업 영역';
	@override late final Translations$common$fileTree$delete$ko delete = Translations$common$fileTree$delete$ko._(_root);
	@override String get dropToUpload => '파일을 놓아 업로드';
	@override String dropToUploadTo({required Object folder}) => '파일을 놓아 "${folder}"에 업로드';
	@override String get noProject => '먼저 프로젝트를 추가하세요';
	@override String get noRecentFiles => '최근 7일간 변경된 파일이 없습니다';
	@override String get showAllFiles => '모든 파일 표시';
	@override String get showAllFilesHint => '최근 필터를 끄면 모든 파일을 볼 수 있습니다.';
	@override String get showRecentOnly => '최근 7일간 변경된 파일 표시';
	@override late final Translations$common$fileTree$toast$ko toast = Translations$common$fileTree$toast$ko._(_root);
	@override String get uploadComplete => '업로드 완료';
	@override String get uploadFailed => '업로드 실패';
	@override String uploadFiles({required Object size}) => '파일 업로드 (각 최대 ${size})';
	@override String uploadToFolder({required Object folder}) => '"${folder}"에 파일 업로드';
	@override String uploadedCount({required Object total, required Object label, required Object uploaded}) => '${total} ${label} 중 ${uploaded}개 업로드됨';
	@override String get uploadingFiles => '파일 업로드 중';
	@override late final Translations$common$fileTree$validation$ko validation = Translations$common$fileTree$validation$ko._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$ko extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '새 프로젝트 생성';
	@override late final Translations$common$projectWizard$steps$ko steps = Translations$common$projectWizard$steps$ko._(_root);
	@override late final Translations$common$projectWizard$step1$ko step1 = Translations$common$projectWizard$step1$ko._(_root);
	@override late final Translations$common$projectWizard$step2$ko step2 = Translations$common$projectWizard$step2$ko._(_root);
	@override late final Translations$common$projectWizard$step3$ko step3 = Translations$common$projectWizard$step3$ko._(_root);
	@override late final Translations$common$projectWizard$buttons$ko buttons = Translations$common$projectWizard$buttons$ko._(_root);
	@override late final Translations$common$projectWizard$errors$ko errors = Translations$common$projectWizard$errors$ko._(_root);
}

// Path: common.notifications
class Translations$common$notifications$ko extends Translations$common$notifications$en {
	Translations$common$notifications$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get genericTool => '도구';
	@override late final Translations$common$notifications$codes$ko codes = Translations$common$notifications$codes$ko._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$ko extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '업데이트 가능';
	@override String get newVersionReady => '새 버전이 준비되었습니다';
	@override String get currentVersion => '현재 버전';
	@override String get latestVersion => '최신 버전';
	@override String get whatsNew => '새로운 기능:';
	@override String get viewFullRelease => '전체 릴리스 보기';
	@override String get updateProgress => '업데이트 진행 상황:';
	@override String get manualUpgrade => '수동 업그레이드:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => '또는 "지금 업데이트"를 클릭하여 자동으로 업데이트합니다.';
	@override String get updateCompleted => '업데이트가 완료되었습니다!';
	@override String get restartServer => '변경사항을 적용하려면 서버를 재시작하세요.';
	@override String get updateFailed => '업데이트 실패';
	@override late final Translations$common$versionUpdate$buttons$ko buttons = Translations$common$versionUpdate$buttons$ko._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$ko ariaLabels = Translations$common$versionUpdate$ariaLabels$ko._(_root);
}

// Path: common.quota
class Translations$common$quota$ko extends Translations$common$quota$en {
	Translations$common$quota$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$ko section = Translations$common$quota$section$ko._(_root);
	@override late final Translations$common$quota$filter$ko filter = Translations$common$quota$filter$ko._(_root);
	@override late final Translations$common$quota$period$ko period = Translations$common$quota$period$ko._(_root);
	@override late final Translations$common$quota$group$ko group = Translations$common$quota$group$ko._(_root);
	@override late final Translations$common$quota$metric$ko metric = Translations$common$quota$metric$ko._(_root);
	@override late final Translations$common$quota$cost$ko cost = Translations$common$quota$cost$ko._(_root);
	@override late final Translations$common$quota$cost3$ko cost3 = Translations$common$quota$cost3$ko._(_root);
	@override late final Translations$common$quota$overview$ko overview = Translations$common$quota$overview$ko._(_root);
	@override late final Translations$common$quota$usage$ko usage = Translations$common$quota$usage$ko._(_root);
	@override late final Translations$common$quota$agents$ko agents = Translations$common$quota$agents$ko._(_root);
	@override late final Translations$common$quota$agentStatus$ko agentStatus = Translations$common$quota$agentStatus$ko._(_root);
	@override late final Translations$common$quota$alert$ko alert = Translations$common$quota$alert$ko._(_root);
	@override String get backToChat => '채팅으로 돌아가기';
	@override String get syncNow => '지금 동기화';
	@override String generatedAt({required Object value}) => '업데이트: ${value}';
	@override String get loading => '계정 한도 로드 중…';
	@override String remaining({required Object value}) => '${value}% 남음';
	@override String resetsIn({required Object value}) => '${value} 후 리셋';
	@override String projected({required Object value}) => '현재 속도로 이 한도는 ${value} 후 소진됩니다';
	@override String syncedAgo({required Object value}) => '${value} 전에 동기화됨';
	@override String get refreshAccount => '계정 새로고침';
	@override String get syncFailed => '동기화 실패';
	@override String get history => '기록';
	@override String historyPoints({required Object value}) => '${value}개 판독값 기록됨';
	@override String get historyEmpty => '아직 기록된 내역 없음';
	@override String get noAgents => '할당된 에이전트 없음';
	@override String get noSubscription => '구독 없음';
	@override String get noSubscriptionHint => '제공자가 이 계정에 대한 활성 플랜을 보고하지 않습니다.';
	@override late final Translations$common$quota$quality$ko quality = Translations$common$quota$quality$ko._(_root);
	@override late final Translations$common$quota$kpi$ko kpi = Translations$common$quota$kpi$ko._(_root);
	@override late final Translations$common$quota$empty$ko empty = Translations$common$quota$empty$ko._(_root);
	@override late final Translations$common$quota$settings$ko settings = Translations$common$quota$settings$ko._(_root);
	@override late final Translations$common$quota$range$ko range = Translations$common$quota$range$ko._(_root);
}

// Path: common.actions
class Translations$common$actions$ko extends Translations$common$actions$en {
	Translations$common$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get retry => '다시 시도';
	@override String get save => '저장';
}

// Path: common.browserPane
class Translations$common$browserPane$ko extends Translations$common$browserPane$en {
	Translations$common$browserPane$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get address => '주소';
	@override String get back => '뒤로';
	@override String get connecting => '브라우저에 연결 중…';
	@override String get connectionFailed => '브라우저 연결에 실패했습니다.';
	@override String couldNotLoad({required Object url}) => '${url}을(를) 로드할 수 없습니다';
	@override String get disconnected => '브라우저 뷰 연결 끊김';
	@override String get enterUrl => 'URL 입력';
	@override String get forward => '앞으로';
	@override String get invalidUrl => '유효한 http(s) URL을 입력하세요';
	@override String get noAuthToken => '인증 토큰이 없습니다.';
	@override String get openExternal => '시스템 브라우저에서 열기';
	@override String get reload => '새로고침';
	@override String get retry => '다시 시도';
	@override String get stop => '중지';
}

// Path: common.browserUse
class Translations$common$browserUse$ko extends Translations$common$browserUse$en {
	Translations$common$browserUse$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count}개 활성';
	@override String get cancel => '취소';
	@override String get close => '닫기';
	@override String get delete => '삭제';
	@override String deleteDesc({required Object name}) => '${name}이(가) 영구적으로 삭제됩니다.';
	@override String get deleteSession => '세션 삭제';
	@override String get deleteTitle => '브라우저 세션을 삭제하시겠습니까?';
	@override late final Translations$common$browserUse$empty$ko empty = Translations$common$browserUse$empty$ko._(_root);
	@override String get emptyStatus => '비어 있음';
	@override late final Translations$common$browserUse$errors$ko errors = Translations$common$browserUse$errors$ko._(_root);
	@override String get fullscreen => '전체 화면';
	@override String get installRuntime => '런타임 설치';
	@override String get installing => '설치 중...';
	@override String get lastAction => '마지막 작업';
	@override String get nextSnapshot => '에이전트 브라우저의 다음 스냅샷이 여기에 표시됩니다.';
	@override String get noPageLoaded => '로드된 페이지 없음';
	@override String get noSessions => '에이전트 브라우저 세션이 없습니다.';
	@override String get none => '없음';
	@override String get openSettings => 'Browser 설정 열기';
	@override String get profile => '프로필';
	@override String get promptLabel => '프롬프트';
	@override late final Translations$common$browserUse$prompts$ko prompts = Translations$common$browserUse$prompts$ko._(_root);
	@override String get refresh => '브라우저 세션 새로고침';
	@override late final Translations$common$browserUse$relative$ko relative = Translations$common$browserUse$relative$ko._(_root);
	@override late final Translations$common$browserUse$runtime$ko runtime = Translations$common$browserUse$runtime$ko._(_root);
	@override String get runtimeSetup => '런타임 설정 필요';
	@override String get selected => '선택됨';
	@override String get sessionFallback => '브라우저 세션';
	@override String get sessionScreenshot => '브라우저 세션 스크린샷';
	@override String get sessions => '세션';
	@override String get status => '상태';
	@override String get stop => '중지';
	@override String get stopSession => '세션 중지';
	@override String get subtitle => 'AI 에이전트가 연 브라우저 세션을 모니터링합니다.';
	@override String get temporary => '임시';
	@override String get thisSession => '이 세션';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '전체 ${count}개';
	@override String updated({required Object time}) => '업데이트: ${time}';
	@override String get waiting => '대기 중';
	@override String get waitingForScreenshot => '스크린샷 대기 중';
}

// Path: common.commandPalette
class Translations$common$commandPalette$ko extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get backToAll => '전체로 돌아가기';
	@override String get backspaceHint => 'Backspace로 돌아가기';
	@override late final Translations$common$commandPalette$browseAll$ko browseAll = Translations$common$commandPalette$browseAll$ko._(_root);
	@override late final Translations$common$commandPalette$compare$ko compare = Translations$common$commandPalette$compare$ko._(_root);
	@override late final Translations$common$commandPalette$groups$ko groups = Translations$common$commandPalette$groups$ko._(_root);
	@override late final Translations$common$commandPalette$hints$ko hints = Translations$common$commandPalette$hints$ko._(_root);
	@override late final Translations$common$commandPalette$items$ko items = Translations$common$commandPalette$items$ko._(_root);
	@override late final Translations$common$commandPalette$nav$ko nav = Translations$common$commandPalette$nav$ko._(_root);
	@override String get noResults => '결과가 없습니다.';
	@override late final Translations$common$commandPalette$pages$ko pages = Translations$common$commandPalette$pages$ko._(_root);
	@override String get placeholder => '입력하여 검색…';
	@override String searchPagePlaceholder({required Object page}) => '${page} 검색…';
	@override String get title => '명령 팔레트';
}

// Path: common.gitPanel
class Translations$common$gitPanel$ko extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} 앞섬';
	@override String get aheadLabel => '앞섬';
	@override String get aiSuggest => 'AI 제안';
	@override String get aiSuggestTitle => 'AI로 커밋 메시지 생성';
	@override String get all => '전체';
	@override String get allStaged => '모든 변경 사항이 스테이징됨';
	@override String behind({required Object count}) => '${count} 뒤처짐';
	@override String get behindLabel => '뒤처짐';
	@override late final Translations$common$gitPanel$branches$ko branches = Translations$common$gitPanel$branches$ko._(_root);
	@override String get cancel => '취소';
	@override String changesCount({required Object count}) => '변경 사항 (${count})';
	@override String get clearSearch => '검색 지우기';
	@override String get collapseDiff => 'diff 접기';
	@override String get commit => '커밋';
	@override String get commitChanges => '변경 사항 커밋';
	@override String commitFiles({required Object count}) => '${count}개 파일 커밋';
	@override String get committing => '커밋 중...';
	@override late final Translations$common$gitPanel$confirmActions$ko confirmActions = Translations$common$gitPanel$confirmActions$ko._(_root);
	@override String confirmCommit({required Object count, required Object message}) => '${count}개 파일을 메시지 "${message}"(으)로 커밋하시겠습니까?';
	@override String confirmDeleteFile({required Object file}) => '추적되지 않는 파일 "${file}"을(를) 삭제하시겠습니까? 되돌릴 수 없습니다.';
	@override String confirmDiscardFile({required Object file}) => '"${file}"의 모든 변경 사항을 폐기하시겠습니까? 되돌릴 수 없습니다.';
	@override String confirmPublish({required Object branch, required Object remote}) => '"${branch}" 브랜치를 ${remote}에 게시하시겠습니까?';
	@override String confirmPull({required Object remote, required Object count}) => '${remote}에서 ${count}개 커밋을 가져오시겠습니까?';
	@override String confirmPush({required Object remote, required Object count}) => '${remote}에 ${count}개 커밋을 푸시하시겠습니까?';
	@override String get confirmRevert => '최신 로컬 커밋을 되돌리시겠습니까? 커밋은 제거되지만 변경 사항은 스테이징 상태로 유지됩니다.';
	@override late final Translations$common$gitPanel$confirmTitles$ko confirmTitles = Translations$common$gitPanel$confirmTitles$ko._(_root);
	@override String get createBranch => '새 브랜치 생성';
	@override String get creating => '생성 중...';
	@override String get delete => '삭제';
	@override String get deleteUntracked => '추적되지 않는 파일 삭제';
	@override String get deselectAll => '모두 선택 해제';
	@override String get discard => '폐기';
	@override String get discardChanges => '변경 사항 폐기';
	@override String get dismiss => '닫기';
	@override String get dismissError => '오류 닫기';
	@override late final Translations$common$gitPanel$errors$ko errors = Translations$common$gitPanel$errors$ko._(_root);
	@override String get expandDiff => 'diff 펼치기';
	@override String get fetch => '페치';
	@override String fetchTitle({required Object remote}) => '${remote}에서 fetch';
	@override String get fetching => 'Fetch 중…';
	@override String filesSelected({required Object count}) => '${count}개 파일 선택됨';
	@override String get generating => '생성 중...';
	@override late final Translations$common$gitPanel$history$ko history = Translations$common$gitPanel$history$ko._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$ko mergeWorktree = Translations$common$gitPanel$mergeWorktree$ko._(_root);
	@override String get merging => '병합 중...';
	@override String get messagePlaceholder => '메시지 (Ctrl+Enter로 커밋)';
	@override late final Translations$common$gitPanel$newBranch$ko newBranch = Translations$common$gitPanel$newBranch$ko._(_root);
	@override late final Translations$common$gitPanel$newWorktree$ko newWorktree = Translations$common$gitPanel$newWorktree$ko._(_root);
	@override String get noChanges => '변경 사항이 감지되지 않았습니다';
	@override String get noChangesToCommit => '커밋할 변경 사항이 없습니다';
	@override late final Translations$common$gitPanel$noCommits$ko noCommits = Translations$common$gitPanel$noCommits$ko._(_root);
	@override String get noMatchingBranches => '일치하는 브랜치 없음';
	@override late final Translations$common$gitPanel$noRepo$ko noRepo = Translations$common$gitPanel$noRepo$ko._(_root);
	@override String get noStagedFiles => '스테이징된 파일 없음';
	@override String get none => '없음';
	@override String nothingToPush({required Object remote}) => '${remote}에 푸시할 내용이 없습니다';
	@override String get openFile => '클릭하여 파일 열기';
	@override String get publish => '게시';
	@override String publishTitle({required Object branch, required Object remote}) => '"${branch}"을(를) ${remote}에 게시';
	@override String get publishing => '게시 중…';
	@override String get pull => '풀';
	@override String pullCount({required Object count}) => '풀 ${count}';
	@override String pullTitle({required Object remote, required Object count}) => '${remote}에서 ${count}개 가져오기';
	@override String get pulling => 'Pull 중…';
	@override String get push => '푸시';
	@override String pushCount({required Object count}) => '푸시 ${count}';
	@override String pushTitle({required Object remote, required Object count}) => '${remote}에 ${count}개 푸시';
	@override String get pushing => 'Push 중…';
	@override String get recentCommits => '최근 커밋';
	@override String get refresh => 'git 상태 새로고침';
	@override String get remove => '제거';
	@override late final Translations$common$gitPanel$removeWorktree$ko removeWorktree = Translations$common$gitPanel$removeWorktree$ko._(_root);
	@override String get removing => '제거 중...';
	@override String get revertLatest => '최신 로컬 커밋 되돌리기';
	@override String get scroll => '스크롤';
	@override String get searchBranches => '브랜치 검색...';
	@override String get selectAll => '모두 선택';
	@override String get selectProject => '소스 컨트롤을 보려면 프로젝트를 선택하세요';
	@override String selectedOf({required Object total, required Object selected}) => '${total}개 파일 중 ${selected}개 선택됨';
	@override String selectedOfMobile({required Object total, required Object selected}) => '${total}개 중 ${selected}개 선택됨';
	@override String get sideBySide => '나란히';
	@override String get stageAll => '모두 스테이징';
	@override String get stageHunk => '이 헝크 스테이징';
	@override String staged({required Object count}) => '스테이징됨 (${count})';
	@override late final Translations$common$gitPanel$status$ko status = Translations$common$gitPanel$status$ko._(_root);
	@override String get statusGuide => '파일 상태 가이드';
	@override String get switchScroll => '가로 스크롤로 전환';
	@override String get switchSplit => '나란히 보기로 전환';
	@override String get switchUnified => '통합 보기로 전환';
	@override String get switchWrap => '텍스트 줄바꿈으로 전환';
	@override String get unified => '통합';
	@override String get unstageAll => '모두 스테이징 해제';
	@override String get unstageHunk => '이 헝크 스테이징 해제';
	@override String get upToDate => '최신 상태';
	@override String upToDateWith({required Object remote}) => '${remote}와 최신 상태';
	@override String get viewAll => '모두 보기';
	@override String get viewsAria => '소스 컨트롤 뷰';
	@override late final Translations$common$gitPanel$worktrees$ko worktrees = Translations$common$gitPanel$worktrees$ko._(_root);
	@override String get wrap => '줄바꿈';
	@override late final Translations$common$gitPanel$tabs$ko tabs = Translations$common$gitPanel$tabs$ko._(_root);
}

// Path: common.sessions
class Translations$common$sessions$ko extends Translations$common$sessions$en {
	Translations$common$sessions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get renameSession => '세션 이름 변경';
}

// Path: common.projects
class Translations$common$projects$ko extends Translations$common$projects$en {
	Translations$common$projects$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get newSession => '새 세션';
}

// Path: settings.changelog
class Translations$settings$changelog$ko extends Translations$settings$changelog$en {
	Translations$settings$changelog$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '변경 로그';
	@override String get loading => '로딩 중…';
	@override String get empty => '표시할 릴리스가 없습니다';
	@override String get current => '현재';
	@override String get kNew => '신규';
}

// Path: settings.server
class Translations$settings$server$ko extends Translations$settings$server$en {
	Translations$settings$server$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '서버';
	@override String get description => 'ddagent 프로세스를 재시작합니다 — 업데이트 적용이나 멈춤 상태 복구에 유용합니다.';
	@override String get restart => '재시작';
	@override String get restartConfirm => 'ddagent 서버를 재시작할까요? 활성 세션이 중단됩니다.';
	@override String get restarting => '재시작 중… 서버가 돌아오면 페이지가 새로고침됩니다.';
	@override String get restartFailed => '재시작 실패';
	@override String get unsupported => '서버가 서비스 매니저로 실행 중일 때만 재시작할 수 있습니다.';
}

// Path: settings.updates
class Translations$settings$updates$ko extends Translations$settings$updates$en {
	Translations$settings$updates$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '앱 업데이트';
	@override String get description => 'GitHub에서 더 최신 데스크톱 빌드를 확인합니다. 새 버전은 자동으로 다운로드되어 종료 시 설치됩니다.';
	@override String get check => '업데이트 확인';
	@override String get checking => '확인 중…';
	@override String upToDate({required Object version}) => '최신 버전입니다 (v${version}).';
	@override String available({required Object version}) => '업데이트 v${version} 발견 — 백그라운드에서 다운로드 중; ddagent 종료 시 설치됩니다.';
	@override String downloaded({required Object version}) => '업데이트 v${version} 다운로드 완료 — ddagent를 종료 후 다시 실행하면 설치됩니다.';
	@override String get unavailable => '업데이트 확인은 패키지된 데스크톱 빌드에서만 사용할 수 있습니다.';
	@override String error({required Object message}) => '업데이트 확인 실패: ${message}';
	@override String get errorGeneric => '업데이트 확인에 실패했습니다.';
}

// Path: settings.tabs
class Translations$settings$tabs$ko extends Translations$settings$tabs$en {
	Translations$settings$tabs$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get account => '계정';
	@override String get permissions => '권한';
	@override String get mcpServers => 'MCP 서버';
	@override String get skills => '스킬';
	@override String get appearance => '외관';
}

// Path: settings.account
class Translations$settings$account$ko extends Translations$settings$account$en {
	Translations$settings$account$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '계정';
	@override String get language => '언어';
	@override String get languageLabel => '표시 언어';
	@override String get languageDescription => '인터페이스에 사용할 언어를 선택하세요';
	@override String get username => '사용자명';
	@override String get email => '이메일';
	@override String get profile => '프로필';
	@override String get changePassword => '비밀번호 변경';
}

// Path: settings.mcp
class Translations$settings$mcp$ko extends Translations$settings$mcp$en {
	Translations$settings$mcp$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP 서버';
	@override String get addServer => '서버 추가';
	@override String get editServer => '서버 편집';
	@override String get deleteServer => '서버 삭제';
	@override String get serverName => '서버 이름';
	@override String get serverType => '서버 유형';
	@override String get config => '설정';
	@override String get testConnection => '연결 테스트';
	@override String get status => '상태';
	@override String get connected => '연결됨';
	@override String get disconnected => '연결 끊김';
	@override late final Translations$settings$mcp$scope$ko scope = Translations$settings$mcp$scope$ko._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$ko extends Translations$settings$appearance$en {
	Translations$settings$appearance$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '외관';
	@override String get theme => '테마';
	@override String get codeEditor => '코드 에디터';
	@override String get editorTheme => '에디터 테마';
	@override String get wordWrap => '자동 줄바꿈';
	@override String get showMinimap => '미니맵 표시';
	@override String get lineNumbers => '줄 번호';
	@override String get fontSize => '글꼴 크기';
}

// Path: settings.actions
class Translations$settings$actions$ko extends Translations$settings$actions$en {
	Translations$settings$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => '변경사항 저장';
	@override String get resetToDefaults => '기본값으로 초기화';
	@override String get cancelChanges => '변경 취소';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$ko extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '빠른 설정';
	@override late final Translations$settings$quickSettings$sections$ko sections = Translations$settings$quickSettings$sections$ko._(_root);
	@override String get darkMode => '다크 모드';
	@override String get showRawParameters => 'Raw 파라미터 표시';
	@override String get showThinking => '생각 과정 표시';
	@override String get sendByCtrlEnter => 'Ctrl+Enter로 전송';
	@override String get sendByCtrlEnterDescription => '활성화하면 Enter 대신 Ctrl+Enter로 메시지를 전송합니다. IME 사용자가 실수로 전송하는 것을 방지하는 데 유용합니다.';
	@override late final Translations$settings$quickSettings$dragHandle$ko dragHandle = Translations$settings$quickSettings$dragHandle$ko._(_root);
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$ko extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '터미널 단축키';
	@override String get sectionKeys => '키';
	@override String get sectionNavigation => '탐색';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => '위쪽 화살표';
	@override String get arrowDown => '아래쪽 화살표';
	@override String get scrollDown => '아래로 스크롤';
	@override late final Translations$settings$terminalShortcuts$handle$ko handle = Translations$settings$terminalShortcuts$handle$ko._(_root);
	@override String get killTitle => '실행 중인 프로세스 종료 (Ctrl+C)';
	@override String get paste => '붙여넣기';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$ko extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '설정';
	@override String get agents => '에이전트';
	@override String get orchestration => '오케스트레이션';
	@override String get appearance => '외관';
	@override String get git => 'Git';
	@override String get apiTokens => 'API & 토큰';
	@override String get models => '모델';
	@override String get tasks => '작업';
	@override String get browser => '브라우저';
	@override String get notifications => '알림';
	@override String get about => '정보';
	@override String get workspaces => '작업 영역';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$ko extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$ko enable = Translations$settings$orchestration$enable$ko._(_root);
	@override late final Translations$settings$orchestration$pool$ko pool = Translations$settings$orchestration$pool$ko._(_root);
	@override late final Translations$settings$orchestration$tiers$ko tiers = Translations$settings$orchestration$tiers$ko._(_root);
	@override late final Translations$settings$orchestration$rules$ko rules = Translations$settings$orchestration$rules$ko._(_root);
	@override late final Translations$settings$orchestration$planner$ko planner = Translations$settings$orchestration$planner$ko._(_root);
	@override late final Translations$settings$orchestration$execution$ko execution = Translations$settings$orchestration$execution$ko._(_root);
	@override late final Translations$settings$orchestration$save$ko save = Translations$settings$orchestration$save$ko._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$ko extends Translations$settings$notifications$en {
	Translations$settings$notifications$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '알림';
	@override String get description => '수신할 알림 이벤트를 설정합니다.';
	@override late final Translations$settings$notifications$webPush$ko webPush = Translations$settings$notifications$webPush$ko._(_root);
	@override late final Translations$settings$notifications$desktop$ko desktop = Translations$settings$notifications$desktop$ko._(_root);
	@override late final Translations$settings$notifications$sound$ko sound = Translations$settings$notifications$sound$ko._(_root);
	@override late final Translations$settings$notifications$events$ko events = Translations$settings$notifications$events$ko._(_root);
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$ko extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$ko darkMode = Translations$settings$appearanceSettings$darkMode$ko._(_root);
	@override late final Translations$settings$appearanceSettings$projectSorting$ko projectSorting = Translations$settings$appearanceSettings$projectSorting$ko._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$ko codeEditor = Translations$settings$appearanceSettings$codeEditor$ko._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$ko terminal = Translations$settings$appearanceSettings$terminal$ko._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$ko extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$ko title = Translations$settings$mcpForm$title$ko._(_root);
	@override late final Translations$settings$mcpForm$importMode$ko importMode = Translations$settings$mcpForm$importMode$ko._(_root);
	@override late final Translations$settings$mcpForm$scope$ko scope = Translations$settings$mcpForm$scope$ko._(_root);
	@override late final Translations$settings$mcpForm$fields$ko fields = Translations$settings$mcpForm$fields$ko._(_root);
	@override late final Translations$settings$mcpForm$placeholders$ko placeholders = Translations$settings$mcpForm$placeholders$ko._(_root);
	@override late final Translations$settings$mcpForm$validation$ko validation = Translations$settings$mcpForm$validation$ko._(_root);
	@override String configDetails({required Object configFile}) => '설정 상세 (${configFile}에서)';
	@override String projectPath({required Object path}) => '경로: ${path}';
	@override late final Translations$settings$mcpForm$actions$ko actions = Translations$settings$mcpForm$actions$ko._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$ko extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get success => '설정이 저장되었습니다!';
	@override String get error => '설정 저장 실패';
	@override String get saving => '저장 중...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$ko extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get save => '설정 저장';
	@override String get cancel => '취소';
}

// Path: settings.git
class Translations$settings$git$ko extends Translations$settings$git$en {
	Translations$settings$git$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Git 설정';
	@override String get description => '커밋을 위한 Git 정보를 설정합니다. 이 설정은 git config --global로 전역 적용됩니다';
	@override late final Translations$settings$git$name$ko name = Translations$settings$git$name$ko._(_root);
	@override late final Translations$settings$git$email$ko email = Translations$settings$git$email$ko._(_root);
	@override late final Translations$settings$git$actions$ko actions = Translations$settings$git$actions$ko._(_root);
	@override late final Translations$settings$git$status$ko status = Translations$settings$git$status$ko._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$ko extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'API 키';
	@override String get description => '다른 애플리케이션에서 외부 API에 접근하기 위한 API 키를 생성합니다.';
	@override late final Translations$settings$apiKeys$newKey$ko newKey = Translations$settings$apiKeys$newKey$ko._(_root);
	@override late final Translations$settings$apiKeys$form$ko form = Translations$settings$apiKeys$form$ko._(_root);
	@override String get newButton => '새 API 키';
	@override String get empty => '생성된 API 키가 없습니다.';
	@override late final Translations$settings$apiKeys$list$ko list = Translations$settings$apiKeys$list$ko._(_root);
	@override String get confirmDelete => '이 API 키를 삭제하시겠습니까?';
	@override late final Translations$settings$apiKeys$status$ko status = Translations$settings$apiKeys$status$ko._(_root);
	@override late final Translations$settings$apiKeys$github$ko github = Translations$settings$apiKeys$github$ko._(_root);
	@override String get apiDocsLink => 'API 문서';
	@override late final Translations$settings$apiKeys$documentation$ko documentation = Translations$settings$apiKeys$documentation$ko._(_root);
	@override String get loading => '로딩 중...';
	@override late final Translations$settings$apiKeys$version$ko version = Translations$settings$apiKeys$version$ko._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$ko extends Translations$settings$tasks$en {
	Translations$settings$tasks$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get checking => 'TaskMaster 설치 확인 중...';
	@override late final Translations$settings$tasks$notInstalled$ko notInstalled = Translations$settings$tasks$notInstalled$ko._(_root);
	@override late final Translations$settings$tasks$settings$ko settings = Translations$settings$tasks$settings$ko._(_root);
}

// Path: settings.agents
class Translations$settings$agents$ko extends Translations$settings$agents$en {
	Translations$settings$agents$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$ko authStatus = Translations$settings$agents$authStatus$ko._(_root);
	@override late final Translations$settings$agents$account$ko account = Translations$settings$agents$account$ko._(_root);
	@override String get connectionStatus => '연결 상태';
	@override late final Translations$settings$agents$login$ko login = Translations$settings$agents$login$ko._(_root);
	@override String error({required Object error}) => '오류: ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$ko extends Translations$settings$permissions$en {
	Translations$settings$permissions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '권한 설정';
	@override late final Translations$settings$permissions$skipPermissions$ko skipPermissions = Translations$settings$permissions$skipPermissions$ko._(_root);
	@override late final Translations$settings$permissions$allowedTools$ko allowedTools = Translations$settings$permissions$allowedTools$ko._(_root);
	@override late final Translations$settings$permissions$blockedTools$ko blockedTools = Translations$settings$permissions$blockedTools$ko._(_root);
	@override late final Translations$settings$permissions$allowedCommands$ko allowedCommands = Translations$settings$permissions$allowedCommands$ko._(_root);
	@override late final Translations$settings$permissions$blockedCommands$ko blockedCommands = Translations$settings$permissions$blockedCommands$ko._(_root);
	@override late final Translations$settings$permissions$toolExamples$ko toolExamples = Translations$settings$permissions$toolExamples$ko._(_root);
	@override late final Translations$settings$permissions$shellExamples$ko shellExamples = Translations$settings$permissions$shellExamples$ko._(_root);
	@override late final Translations$settings$permissions$codex$ko codex = Translations$settings$permissions$codex$ko._(_root);
	@override late final Translations$settings$permissions$actions$ko actions = Translations$settings$permissions$actions$ko._(_root);
	@override late final Translations$settings$permissions$permissionMode$ko permissionMode = Translations$settings$permissions$permissionMode$ko._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$ko extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP 서버';
	@override late final Translations$settings$mcpServers$description$ko description = Translations$settings$mcpServers$description$ko._(_root);
	@override String get addButton => 'MCP 서버 추가';
	@override String get empty => '설정된 MCP 서버 없음';
	@override String get serverType => '유형';
	@override late final Translations$settings$mcpServers$scope$ko scope = Translations$settings$mcpServers$scope$ko._(_root);
	@override late final Translations$settings$mcpServers$config$ko config = Translations$settings$mcpServers$config$ko._(_root);
	@override late final Translations$settings$mcpServers$tools$ko tools = Translations$settings$mcpServers$tools$ko._(_root);
	@override late final Translations$settings$mcpServers$actions$ko actions = Translations$settings$mcpServers$actions$ko._(_root);
	@override late final Translations$settings$mcpServers$managed$ko managed = Translations$settings$mcpServers$managed$ko._(_root);
	@override late final Translations$settings$mcpServers$help$ko help = Translations$settings$mcpServers$help$ko._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$ko deleteConfirm = Translations$settings$mcpServers$deleteConfirm$ko._(_root);
}

// Path: settings.quota
class Translations$settings$quota$ko extends Translations$settings$quota$en {
	Translations$settings$quota$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$ko settings = Translations$settings$quota$settings$ko._(_root);
	@override late final Translations$settings$quota$empty$ko empty = Translations$settings$quota$empty$ko._(_root);
	@override late final Translations$settings$quota$quality$ko quality = Translations$settings$quota$quality$ko._(_root);
	@override String get syncFailed => '동기화 실패';
	@override String get syncNow => '지금 동기화';
}

// Path: settings.browser
class Translations$settings$browser$ko extends Translations$settings$browser$en {
	Translations$settings$browser$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get checking => '확인 중...';
	@override String get description => '에이전트가 Browser 탭에서 모니터링할 수 있는 관리형 Playwright 브라우저 세션을 만들 수 있도록 허용합니다.';
	@override String get enableDescription => '지원되는 에이전트에 Browser를 등록합니다. 에이전트는 브라우저 세션을 만들 수 있으며, 사용자는 이를 보고, 중지하고, 삭제할 수 있습니다.';
	@override String get enableLabel => 'Browser 활성화';
	@override late final Translations$settings$browser$errors$ko errors = Translations$settings$browser$errors$ko._(_root);
	@override String get installHint => '에이전트가 Browser 세션을 만들기 전에 브라우저 런타임을 설치하세요.';
	@override String get installRuntime => '런타임 설치';
	@override String get installed => '설치됨';
	@override String get installing => '설치 중...';
	@override String get missing => '없음';
	@override String get runtimeRequired => '브라우저 런타임 필요';
	@override String get statusDisabled => '비활성화됨';
	@override String get statusLabel => '상태';
	@override String get statusReady => '준비됨';
	@override String get statusSetupRequired => '설정 필요';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$ko extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get create => '작업 영역 추가';
	@override String get deleteConfirm => '이 작업 영역을 ddagent에서 제거하시겠습니까? 파일은 디스크에 남습니다.';
	@override String get deleteFailed => '작업 영역 제거에 실패했습니다.';
	@override String get deleteTitle => '작업 영역 제거';
	@override String get description => '작업 영역은 ddagent가 채팅하고, 코드를 실행하고, 탐색할 수 있는 디렉터리입니다.';
	@override String get remove => '작업 영역 제거';
	@override String get title => '작업 영역';
}

// Path: settings.about
class Translations$settings$about$ko extends Translations$settings$about$en {
	Translations$settings$about$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => '프로젝트 후원하기';
	@override String get buyMeACoffee => '커피 한 잔 사주기';
}

// Path: sidebar.projects
class Translations$sidebar$projects$ko extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '프로젝트';
	@override String get newProject => '새 프로젝트';
	@override String get deleteProject => '프로젝트 제거';
	@override String get renameProject => '프로젝트 이름 변경';
	@override String get noProjects => '프로젝트가 없습니다';
	@override String get loadingProjects => '프로젝트 로딩 중...';
	@override String get searchPlaceholder => '프로젝트 검색...';
	@override String get projectNamePlaceholder => '프로젝트 이름';
	@override String get starred => '즐겨찾기';
	@override String get all => '전체';
	@override String get untitledSession => '제목 없는 세션';
	@override String get newSession => '새 세션';
	@override String get codexSession => 'Codex 세션';
	@override String get fetchingProjects => 'Claude 프로젝트와 세션을 가져오는 중';
	@override String get projects => '프로젝트';
	@override String get noMatchingProjects => '일치하는 프로젝트 없음';
	@override String get tryDifferentSearch => '검색어를 변경해보세요';
	@override String get runClaudeCli => '프로젝트 디렉토리에서 Claude CLI를 실행하여 시작하세요';
}

// Path: sidebar.app
class Translations$sidebar$app$ko extends Translations$sidebar$app$en {
	Translations$sidebar$app$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'ddagent';
	@override String get subtitle => 'AI 코딩 어시스턴트 UI';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$ko extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '세션';
	@override String get newSession => '새 세션';
	@override String get deleteSession => '세션 삭제';
	@override String get renameSession => '세션 이름 변경';
	@override String get noSessions => '세션이 없습니다';
	@override String get loadingSessions => '세션 로딩 중...';
	@override String get unnamed => '이름 없음';
	@override String get loading => '로딩 중...';
	@override String get showMore => '더 많은 세션 보기';
	@override String get selectMode => '선택';
	@override String get selectAll => '모두 선택';
	@override String archiveSelected({required Object count}) => '보관 (${count})';
	@override String deleteSelected({required Object count}) => '삭제 (${count})';
	@override String get cancelSelection => '선택 취소';
	@override String get toggleSelection => '세션 선택 전환';
	@override String get selectionToolbar => '세션 선택 작업';
	@override String get options => '세션 옵션';
	@override String get pinSession => '세션 고정';
	@override String get unpinSession => '세션 고정 해제';
	@override String get pinned => '고정된 세션';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '${count}개 선택됨',
		other: '${count}개 선택됨',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$ko extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => '환경 보기';
	@override String get hideSidebar => '사이드바 숨기기';
	@override String get createProject => '새 프로젝트 생성';
	@override String get refresh => '프로젝트 및 세션 새로고침 (Ctrl+R)';
	@override String get renameProject => '프로젝트 이름 변경 (F2)';
	@override String get deleteProject => '사이드바에서 프로젝트 제거 (Delete)';
	@override String get addToFavorites => '즐겨찾기에 추가';
	@override String get removeFromFavorites => '즐겨찾기에서 제거';
	@override String get editSessionName => '세션 이름 직접 편집';
	@override String get deleteSession => '이 세션 영구 삭제';
	@override String get activeSessionIndicator => '최근 활성 세션 (지난 10분)';
	@override String get save => '저장';
	@override String get cancel => '취소';
	@override String get clearSearch => '검색 지우기';
	@override String get openCommandPalette => '명령 팔레트 열기';
	@override String get attentionRequiredIndicator => '세션에 주의가 필요합니다';
	@override String get openSessions => '세션 찾아보기';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$ko extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get chat => '채팅';
	@override String get files => '파일';
	@override String get git => 'Git';
	@override String get terminal => '터미널';
	@override String get tasks => '작업';
}

// Path: sidebar.actions
class Translations$sidebar$actions$ko extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get refresh => '새로고침';
	@override String get settings => '설정';
	@override String get collapseAll => '모두 접기';
	@override String get expandAll => '모두 펼치기';
	@override String get cancel => '취소';
	@override String get save => '저장';
	@override String get delete => '삭제';
	@override String get rename => '이름 변경';
	@override String get joinCommunity => '커뮤니티 참여';
	@override String get reportIssue => '문제 신고';
	@override String get starOnGithub => 'GitHub에서 스타';
	@override String get buyMeACoffee => '커피 한 잔 사주기';
}

// Path: sidebar.branding
class Translations$sidebar$branding$ko extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get openSource => '오픈 소스';
}

// Path: sidebar.status
class Translations$sidebar$status$ko extends Translations$sidebar$status$en {
	Translations$sidebar$status$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get active => '활성';
	@override String get inactive => '비활성';
	@override String get thinking => '생각 중...';
	@override String get error => '오류';
	@override String get aborted => '중단됨';
	@override String get unknown => '알 수 없음';
}

// Path: sidebar.time
class Translations$sidebar$time$ko extends Translations$sidebar$time$en {
	Translations$sidebar$time$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get justNow => '방금 전';
	@override String get oneMinuteAgo => '1분 전';
	@override String minutesAgo({required Object count}) => '${count}분 전';
	@override String get oneHourAgo => '1시간 전';
	@override String hoursAgo({required Object count}) => '${count}시간 전';
	@override String get oneDayAgo => '1일 전';
	@override String daysAgo({required Object count}) => '${count}일 전';
}

// Path: sidebar.messages
class Translations$sidebar$messages$ko extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => '정말 삭제하시겠습니까?';
	@override String get renameSuccess => '이름이 변경되었습니다';
	@override String get deleteSuccess => '삭제되었습니다';
	@override String get errorOccurred => '오류가 발생했습니다';
	@override String get deleteSessionConfirm => '이 세션을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';
	@override String get deleteProjectConfirm => '사이드바에서 이 프로젝트를 제거하시겠습니까? 프로젝트 파일, 메모리 및 세션 데이터는 삭제되지 않습니다.';
	@override String get enterProjectPath => '프로젝트 경로를 입력해주세요';
	@override String get deleteSessionFailed => '세션 삭제 실패. 다시 시도해주세요.';
	@override String get deleteSessionError => '세션 삭제 오류. 다시 시도해주세요.';
	@override String get renameSessionFailed => '세션 이름 변경 실패. 다시 시도해주세요.';
	@override String get renameSessionError => '세션 이름 변경 오류. 다시 시도해주세요.';
	@override String get deleteProjectFailed => '프로젝트 제거 실패. 다시 시도해주세요.';
	@override String get deleteProjectError => '프로젝트 제거 오류. 다시 시도해주세요.';
	@override String get createProjectFailed => '프로젝트 생성 실패. 다시 시도해주세요.';
	@override String get createProjectError => '프로젝트 생성 오류. 다시 시도해주세요.';
	@override String get updateProjectError => '프로젝트 업데이트 오류. 다시 시도해주세요.';
	@override String get refreshError => '새로고침 실패. 다시 시도해주세요.';
	@override String get restoreProjectFailed => '프로젝트 복원 실패. 다시 시도해주세요.';
	@override String get restoreProjectError => '프로젝트 복원 오류. 다시 시도해주세요.';
	@override String get restoreSessionFailed => '세션 복원 실패. 다시 시도해주세요.';
	@override String get restoreSessionError => '세션 복원 오류. 다시 시도해주세요.';
	@override String get changeWorkspaceFailed => '작업 영역 변경에 실패했습니다. 다시 시도하세요.';
	@override String get changeWorkspaceError => '작업 영역 변경 중 오류가 발생했습니다. 다시 시도하세요.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '${count}개 세션을 삭제하지 못했습니다. 다시 시도하세요.',
		other: '${count}개 세션을 삭제하지 못했습니다. 다시 시도하세요.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$ko extends Translations$sidebar$version$en {
	Translations$sidebar$version$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => '업데이트 가능';
	@override String get restartRequired => '업데이트가 설치됨 — 적용하려면 서버를 재시작하세요';
	@override String get updateNow => '지금 업데이트';
	@override String updateConfirm({required Object version}) => 'ddagent를 v${version}(으)로 업데이트할까요? 최신 코드를 받아 빌드한 뒤 서버가 재시작됩니다 — 활성 세션은 중단됩니다.';
	@override String get updating => '업데이트 중… 몇 분 걸릴 수 있습니다';
	@override String get restarting => '업데이트 설치됨 — 재시작 중…';
	@override String get updateFailed => '업데이트 실패';
	@override String get releaseNotes => '릴리스 노트';
}

// Path: sidebar.search
class Translations$sidebar$search$ko extends Translations$sidebar$search$en {
	Translations$sidebar$search$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => '프로젝트';
	@override String get modeConversations => '대화';
	@override String get conversationsPlaceholder => '대화 내용 검색...';
	@override String get searching => '검색 중...';
	@override String get sessionTitles => '세션 제목';
	@override String get conversationContents => '대화 내용';
	@override String get noResults => '결과를 찾을 수 없습니다';
	@override String get tryDifferentQuery => '다른 검색어로 시도해보세요';
	@override String get modeRunning => '실행 중';
	@override String get archiveOnly => '보관함';
	@override String get runningTooltip => '실행 중인 세션';
	@override String get archiveOnlyTooltip => '보관함만';
	@override String runningCount({required Object count}) => '${count}개 활성';
	@override String get viewMenu => '보기';
	@override String get backToProjects => '프로젝트로 돌아가기';
	@override String get archivedPlaceholder => '보관된 세션 검색...';
	@override String get runningPlaceholder => '실행 중인 세션 검색...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '${count}개 일치',
		other: '${count}개 일치',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '프로젝트 ${count}개 검색됨',
		other: '프로젝트 ${count}개 검색됨',
	);
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$ko extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => '프로젝트 제거';
	@override String get deleteSession => '세션 삭제';
	@override String get confirmDelete => '이 프로젝트를 어떻게 하시겠습니까:';
	@override String get removeFromSidebar => '사이드바에서만 제거';
	@override String get deleteAllData => '모든 데이터 영구 삭제';
	@override String get allConversationsDeleted => '프로젝트가 사이드바에서 제거됩니다. 파일, 메모리 및 세션 데이터는 보존됩니다.';
	@override String get cannotUndo => '나중에 프로젝트를 다시 추가할 수 있습니다.';
	@override String get bulkDeleteSessionsDescription => '보관은 선택한 세션을 활성 목록에서 숨기면서 기록을 유지합니다.';
	@override String get archiveSession => '세션 보관';
	@override String get archiveSessionNotice => '보관은 기록을 유지하면서 세션을 활성 목록에서 제외합니다.';
	@override String get archivedSessionNotice => '이 세션은 이미 보관되어 있습니다. 숨긴 채로 두거나 영구 삭제할 수 있습니다.';
	@override String get deleteSessionNotice => '세션과 트랜스크립트를 영구적으로 제거합니다. 이 작업은 되돌릴 수 없습니다.';
	@override String get deleteSessionPermanently => '영구 삭제';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '이 프로젝트에는 ${count}개의 대화가 있습니다.',
		other: '이 프로젝트에는 ${count}개의 대화가 있습니다.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '선택한 세션 관리',
		other: '선택한 ${count}개 세션 관리',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count,
		one: '세션 보관',
		other: '${count}개 세션 보관',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$ko extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get activeNow => '지금 활성';
	@override String get recent => '최근 사용';
	@override String get today => '오늘';
	@override String get yesterday => '어제';
	@override String get thisWeek => '이번 주';
	@override String showMore({required Object count}) => '${count}개 더 보기';
	@override String get showLess => '간단히 보기';
}

// Path: sidebar.panel
class Translations$sidebar$panel$ko extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get open => '패널';
	@override String get newChat => '새 채팅';
	@override String get navigation => '탐색';
	@override String get sessions => '세션';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$ko extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '세션 작업 영역 변경';
	@override String get description => '에이전트가 이 디렉터리에서 다음 턴을 실행합니다. 기존 세션 기록은 유지됩니다.';
	@override String get pathLabel => '작업 영역 경로';
	@override String get pathRequired => '작업 영역 경로가 필요합니다.';
	@override String get submit => '작업 영역 변경';
	@override String get saving => '변경 중…';
	@override String get changeAction => '작업 영역 변경';
}

// Path: sidebar.recent
class Translations$sidebar$recent$ko extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '최근 대화';
	@override String get emptyTitle => '아직 대화 없음';
	@override String get emptyDescription => '가장 최근에 업데이트된 대화가 여기에 표시됩니다.';
	@override String get loadFailed => '최근 대화를 불러올 수 없습니다';
	@override String get loadMore => '이전 대화 불러오기';
	@override String get loadingMore => '더 불러오는 중...';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$ko extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get board => '에이전트 보드';
	@override String get files => '파일';
	@override String get git => '소스 컨트롤';
	@override String get tasks => '작업';
	@override String get usage => '쿼터 및 사용량';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$ko extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI가 설정되지 않았습니다';
	@override String get description => 'TaskMaster는 AI 기반 지원으로 복잡한 프로젝트를 관리하기 쉬운 작업 단위로 나눠줍니다';
	@override String get whatIsTitle => '🎯 TaskMaster란?';
	@override late final Translations$tasks$notConfigured$features$ko features = Translations$tasks$notConfigured$features$ko._(_root);
	@override String get initializeButton => 'TaskMaster AI 초기화';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$ko extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster 시작하기';
	@override String get subtitle => 'TaskMaster가 초기화되었습니다! 다음 단계를 안내합니다:';
	@override late final Translations$tasks$gettingStarted$steps$ko steps = Translations$tasks$gettingStarted$steps$ko._(_root);
	@override String get tip => '💡 팁: PRD로 시작하면 TaskMaster의 AI 기반 작업 생성 기능을 최대한 활용할 수 있습니다';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$ko extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster 설정';
	@override String subtitle({required Object projectName}) => '${projectName}용 대화형 CLI';
	@override String get willStart => 'TaskMaster 초기화가 자동으로 시작됩니다';
	@override String get completed => 'TaskMaster 설정이 완료되었습니다! 이제 이 창을 닫아도 됩니다.';
	@override String get closeButton => '닫기';
	@override String get closeContinueButton => '닫고 계속하기';
	@override String get closeTitle => '닫기';
	@override String get description => '이 프로젝트에 .taskmaster 폴더를 생성합니다. 외부 도구나 API 키가 필요 없으며 작업은 로컬에 저장됩니다.';
	@override String get initializeButton => '초기화';
	@override String get initializing => '초기화 중...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$ko extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster 시작하기';
	@override String get subtitle => '생산적인 작업 관리를 위한 가이드';
	@override late final Translations$tasks$helpGuide$examples$ko examples = Translations$tasks$helpGuide$examples$ko._(_root);
	@override String get moreExamples => '더 많은 예시와 사용 패턴 보기 →';
	@override late final Translations$tasks$helpGuide$proTips$ko proTips = Translations$tasks$helpGuide$proTips$ko._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$ko learnMore = Translations$tasks$helpGuide$learnMore$ko._(_root);
	@override String get closeTitle => '닫기';
}

// Path: tasks.search
class Translations$tasks$search$ko extends Translations$tasks$search$en {
	Translations$tasks$search$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get placeholder => '작업 검색...';
}

// Path: tasks.filters
class Translations$tasks$filters$ko extends Translations$tasks$filters$en {
	Translations$tasks$filters$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get button => '필터';
	@override String get status => '상태';
	@override String get priority => '우선순위';
	@override String get sortBy => '정렬 기준';
	@override String get allStatuses => '모든 상태';
	@override String get allPriorities => '모든 우선순위';
	@override String showing({required Object total, required Object filtered}) => '${total}개 중 ${filtered}개 표시';
	@override String get clearFilters => '필터 초기화';
}

// Path: tasks.sort
class Translations$tasks$sort$ko extends Translations$tasks$sort$en {
	Translations$tasks$sort$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => '상태';
	@override String get priority => '우선순위';
	@override String get idAsc => 'ID (오름차순)';
	@override String get idDesc => 'ID (내림차순)';
	@override String get titleAsc => '제목 (A-Z)';
	@override String get titleDesc => '제목 (Z-A)';
	@override String get statusAsc => '상태 (대기 우선)';
	@override String get statusDesc => '상태 (완료 우선)';
	@override String get priorityAsc => '우선순위 (높은 순)';
	@override String get priorityDesc => '우선순위 (낮은 순)';
}

// Path: tasks.views
class Translations$tasks$views$ko extends Translations$tasks$views$en {
	Translations$tasks$views$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get kanban => '칸반 보기';
	@override String get list => '목록 보기';
	@override String get grid => '그리드 보기';
}

// Path: tasks.kanban
class Translations$tasks$kanban$ko extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 대기 중';
	@override String get inProgress => '🚀 진행 중';
	@override String get review => '👀 검토';
	@override String get done => '✅ 완료';
	@override String get blocked => '🚫 차단됨';
	@override String get deferred => '⏳ 보류';
	@override String get cancelled => '❌ 취소됨';
	@override String get noTasksYet => '아직 작업이 없습니다';
	@override String get tasksWillAppear => '작업이 여기에 표시됩니다';
	@override String get moveTasksHere => '시작하면 작업을 여기로 옮기세요';
	@override String get completedTasksHere => '완료된 작업이 여기에 표시됩니다';
	@override String get statusTasksHere => '이 상태의 작업이 여기에 표시됩니다';
}

// Path: tasks.buttons
class Translations$tasks$buttons$ko extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get help => 'TaskMaster 시작 가이드';
	@override String get prds => 'PRD';
	@override String get addPRD => 'PRD 추가';
	@override String get addTask => '작업 추가';
	@override String get createNewPRD => '새 PRD 생성';
	@override String prdsAvailable({required Object count}) => 'PRD ${count}개 사용 가능';
}

// Path: tasks.prd
class Translations$tasks$prd$ko extends Translations$tasks$prd$en {
	Translations$tasks$prd$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => '수정됨: ${date}';
}

// Path: tasks.statuses
class Translations$tasks$statuses$ko extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get pending => '대기 중';
	@override String get inProgress => '진행 중';
	@override String get done => '완료';
	@override String get blocked => '차단됨';
	@override String get deferred => '보류';
	@override String get cancelled => '취소됨';
}

// Path: tasks.priorities
class Translations$tasks$priorities$ko extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get high => '높음';
	@override String get medium => '중간';
	@override String get low => '낮음';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$ko extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '필터와 일치하는 작업이 없습니다';
	@override String get description => '검색어나 필터 조건을 조정해보세요.';
}

// Path: tasks.board
class Translations$tasks$board$ko extends Translations$tasks$board$en {
	Translations$tasks$board$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '에이전트 보드';
	@override String get subtitle => '카드를 준비로 옮기면 에이전트가 처리합니다. 카드를 클릭하면 세션이 열립니다.';
	@override String get newCard => '새 카드';
	@override String get addCard => '카드 추가';
	@override String get refresh => '새로고침';
	@override late final Translations$tasks$board$empty$ko empty = Translations$tasks$board$empty$ko._(_root);
	@override late final Translations$tasks$board$columns$ko columns = Translations$tasks$board$columns$ko._(_root);
	@override late final Translations$tasks$board$card$ko card = Translations$tasks$board$card$ko._(_root);
	@override late final Translations$tasks$board$dialog$ko dialog = Translations$tasks$board$dialog$ko._(_root);
	@override String get noProject => '먼저 프로젝트를 추가한 다음 카드를 만드세요.';
	@override String get projectLabel => '프로젝트';
	@override String get backToChat => '채팅으로 돌아가기';
	@override late final Translations$tasks$board$agent$ko agent = Translations$tasks$board$agent$ko._(_root);
	@override late final Translations$tasks$board$deleteConfirm$ko deleteConfirm = Translations$tasks$board$deleteConfirm$ko._(_root);
	@override String get project => '프로젝트';
}

// Path: tasks.card
class Translations$tasks$card$ko extends Translations$tasks$card$en {
	Translations$tasks$card$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => '종속: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => '작업 ${id}';
	@override String get highPriority => '높은 우선순위';
	@override String get lowPriority => '낮은 우선순위';
	@override String get mediumPriority => '중간 우선순위';
	@override String get noPriority => '우선순위 미설정';
	@override String parentTask({required Object id}) => '작업 ${id}';
	@override String get progressLabel => '진행률:';
	@override String progressTooltip({required Object total, required Object completed}) => '${total}개 하위 작업 중 ${completed}개 완료';
	@override String get runTask => '작업 실행';
	@override String runTaskAria({required Object id}) => '작업 ${id} 실행';
	@override String statusTooltip({required Object status}) => '상태: ${status}';
	@override String taskIdTitle({required Object id}) => '작업 ID: ${id}';
	@override String get taskInProgress => '작업 진행 중';
}

// Path: tasks.createTask
class Translations$tasks$createTask$ko extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get descriptionLabel => '설명';
	@override String get descriptionPlaceholder => '선택적 세부 정보';
	@override String get error => '작업 추가 실패';
	@override String get priorityLabel => '우선순위';
	@override String get submit => '작업 추가';
	@override String get submitting => '추가 중...';
	@override String get title => '작업 추가';
	@override String get titleLabel => '제목';
	@override String get titlePlaceholder => '무엇을 해야 하나요?';
}

// Path: tasks.list
class Translations$tasks$list$ko extends Translations$tasks$list$en {
	Translations$tasks$list$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => '완료됨 (클릭하여 다시 열기)';
	@override String get inProgressComplete => '진행 중 (클릭하여 완료)';
	@override String get markCompleted => '완료로 표시';
	@override String toggleStatusAria({required Object id}) => '작업 ${id} 상태 전환';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$ko extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get allComplete => '모든 작업 완료';
	@override String get feature1 => '- 종속성 및 하위 작업을 지원하는 AI 작업 관리.';
	@override String get feature2 => '- PRD 기반 작업 생성으로 프로젝트 빠른 시작.';
	@override String get feature3 => '- 일상 작업을 위한 칸반 및 목록 보기.';
	@override String get hideDetails => '세부 정보 숨기기';
	@override String get initialize => '초기화';
	@override String get noPending => '대기 중인 작업 없음';
	@override String get notConfigured => 'TaskMaster AI가 구성되지 않았습니다';
	@override String get review => '검토';
	@override String get startTask => '작업 시작';
	@override String taskId({required Object id}) => '작업 ${id}';
	@override String get viewAll => '모든 작업 보기';
	@override String get viewDetails => '작업 세부 정보 보기';
	@override String get whatIs => 'TaskMaster란?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$ko extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => '편집 취소';
	@override String get close => '닫기';
	@override String get copyTaskId => '작업 ID 복사';
	@override String get delete => '작업 삭제';
	@override String deleteConfirmDescription({required Object title}) => '"${title}"이(가) 영구적으로 삭제됩니다.';
	@override String get deleteConfirmTitle => '작업을 삭제하시겠습니까?';
	@override String get deleteFailed => '작업을 삭제하지 못했습니다';
	@override String get dependencies => '종속성';
	@override String get dependenciesPlaceholder => '예: 1, 2, 3';
	@override String get description => '설명';
	@override String get edit => '작업 편집';
	@override String get implDetails => '구현 세부 정보';
	@override String get noDependencies => '종속성 없음';
	@override String get noDescription => '설명 없음';
	@override String get priority => '우선순위';
	@override String get priorityNotSet => '설정되지 않음';
	@override String get save => '저장';
	@override String get status => '상태';
	@override String get statusFailed => '작업 상태 업데이트 실패';
	@override String taskId({required Object id}) => '작업 ${id}';
	@override String taskTitle({required Object id, required Object title}) => '작업 ${id}: ${title}';
	@override String get testStrategy => '테스트 전략';
	@override String get titleRequired => '제목은 필수입니다';
	@override String get updateFailed => '작업 업데이트 실패';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$ko extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get dashboard => '대시보드';
	@override String get memories => '메모리';
	@override String get rules => '규칙';
	@override String get skills => '스킬';
	@override String get personal => '개인정보';
	@override String get graph => '그래프';
}

// Path: knowledge.common
class Translations$knowledge$common$ko extends Translations$knowledge$common$en {
	Translations$knowledge$common$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get add => '추가';
	@override String get save => '저장';
	@override String get cancel => '취소';
	@override String get delete => '삭제';
	@override String get edit => '편집';
	@override String get close => '닫기';
	@override String get restore => '복원';
	@override String get refresh => '새로고침';
	@override String get allProjects => '모든 프로젝트';
	@override String get global => '전역';
}

// Path: knowledge.actions
class Translations$knowledge$actions$ko extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get scan => '프로젝트 파일 스캔';
	@override String get export => 'JSON 내보내기';
	@override String get import => 'JSON 가져오기';
	@override String get scanComplete => '스캔 완료';
	@override String get importComplete => '가져오기 완료';
	@override String get importFailed => '가져오기 실패';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$ko extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get newEntity => '새 항목';
	@override String get editEntity => '항목 편집';
	@override String get deleteTitle => '삭제';
	@override String get deleteMessage => '이 항목을 삭제할까요? 되돌릴 수 없습니다(기록은 유지됨).';
	@override String get pickIcon => '아이콘 선택';
	@override String get removeIcon => '아이콘 제거';
	@override String get iconTooLarge => '아이콘이 너무 큽니다(최대 40KB).';
	@override String get importTitle => '지식 가져오기';
	@override String get importHint => '내보낸 JSON을 여기에 붙여넣기';
	@override String get exportTitle => '지식 내보내기';
	@override String get import => '가져오기';
}

// Path: knowledge.fields
class Translations$knowledge$fields$ko extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get key => '키';
	@override String get title => '제목';
	@override String get name => '이름';
	@override String get description => '설명';
	@override String get category => '카테고리';
	@override String get content => '내용';
	@override String get priority => '우선순위';
	@override String get tags => '태그';
	@override String get enabled => '활성화';
	@override String get projectScope => '프로젝트 범위';
	@override String get tagsHint => '쉼표로 구분';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$ko extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get memories => '메모리';
	@override String get rules => '규칙';
	@override String get skills => '스킬';
	@override String get personal => '개인정보';
	@override String get connections => '연결';
	@override String get recent => '최근 메모리';
	@override String get noMemories => '메모리가 없습니다. 메모리 탭에서 추가하세요.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$ko extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get memories => '메모리가 없습니다.';
	@override String get rules => '규칙이 없습니다.';
	@override String get skills => '스킬이 없습니다.';
	@override String get personal => '개인정보가 없습니다.';
	@override String get graph => '그래프로 표시할 항목이 없습니다.';
}

// Path: knowledge.history
class Translations$knowledge$history$ko extends Translations$knowledge$history$en {
	Translations$knowledge$history$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '기록';
	@override String get none => '기록이 없습니다.';
	@override String get untitled => '(제목 없음)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$ko extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get critical => '치명적';
	@override String get high => '높음';
	@override String get normal => '보통';
	@override String get low => '낮음';
}

// Path: knowledge.search
class Translations$knowledge$search$ko extends Translations$knowledge$search$en {
	Translations$knowledge$search$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '지식 검색';
	@override String get hint => '메모리, 규칙, 스킬 검색…';
	@override String get noResults => '결과가 없습니다.';
}

// Path: knowledge.links
class Translations$knowledge$links$ko extends Translations$knowledge$links$en {
	Translations$knowledge$links$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '엔티티 연결';
	@override String get source => '소스';
	@override String get target => '대상';
	@override String get relationship => '관계';
	@override String get add => '연결 만들기';
}

// Path: knowledge.tags
class Translations$knowledge$tags$ko extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get all => '모든 태그';
	@override String get manage => '태그 관리';
	@override String get none => '태그가 없습니다.';
}

// Path: knowledge.settings
class Translations$knowledge$settings$ko extends Translations$knowledge$settings$en {
	Translations$knowledge$settings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => '에이전트를 위한 로컬 메모리 계층: 메모리, 규칙, 스킬, 개인정보.';
}

// Path: auth.login.errors
class Translations$auth$login$errors$ko extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => '사용자명 또는 비밀번호가 잘못되었습니다';
	@override String get requiredFields => '모든 항목을 입력해주세요';
	@override String get networkError => '네트워크 오류. 다시 시도해주세요.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$ko extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get username => '사용자명을 입력하세요';
	@override String get password => '비밀번호를 입력하세요';
}

// Path: auth.register.errors
class Translations$auth$register$errors$ko extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => '비밀번호가 일치하지 않습니다';
	@override String get usernameTaken => '이미 사용 중인 사용자명입니다';
	@override String get weakPassword => '비밀번호가 너무 약합니다';
	@override String get usernameTooShort => '사용자 이름은 3자 이상이어야 합니다';
	@override String get passwordTooShort => '비밀번호는 6자 이상이어야 합니다';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$ko extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '기본 모드';
	@override String get auto => '자동 모드';
	@override String get acceptEdits => '편집 허용';
	@override String get bypassPermissions => '권한 우회';
	@override String get plan => 'Plan 모드';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$ko extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '신뢰할 수 있는 명령어(ls, cat, grep, git status 등)만 자동 실행됩니다. 다른 명령어는 건너뜁니다. 워크스페이스에 쓰기 가능.';
	@override String get auto => '모델 분류기가 도구 호출마다 승인 또는 거부를 결정합니다. 높은 자율성.';
	@override String get acceptEdits => '워크스페이스 내에서 모든 명령어가 자동 실행됩니다. 샌드박스 내 완전 자동 모드.';
	@override String get bypassPermissions => '제한 없는 전체 시스템 접근. 모든 명령어가 전체 디스크 및 네트워크 접근 권한으로 자동 실행됩니다. 주의해서 사용하세요.';
	@override String get plan => '계획 모드 - 명령어가 실행되지 않습니다';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$ko extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter로 전송 • / 명령어 • @ 파일';
	@override String get enter => 'Enter로 전송 • Shift+Enter 줄바꿈 • / 명령어 • @ 파일';
	@override String get queue => 'Enter로 다음 메시지 대기열에 추가';
	@override String get updateQueued => 'Enter로 대기 중인 메시지 업데이트';
}

// Path: chat.input.queue
class Translations$chat$input$queue$ko extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get sendNext => '다음 메시지 대기열에 추가';
	@override String get update => '대기 중인 메시지 업데이트';
	@override String get label => '대기 중';
	@override String get willSend => '완료되면 전송됩니다';
	@override String get edit => '대기 중인 메시지 편집';
	@override String get delete => '대기 중인 메시지 삭제';
	@override String get failed => '전송 실패';
	@override String get sendNow => '지금 보내기';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$ko extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get clear => '취소하고 오프라인 큐 비우기';
	@override String get clearBtn => '취소';
	@override String multiple({required Object count}) => '${count}개 메시지가 오프라인 큐에 있음 — 재연결 시 자동 전송됩니다';
	@override String get single => '1개 메시지가 오프라인 큐에 있음 — 재연결 시 자동 전송됩니다';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$ko extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'Anthropic 제공';
	@override String get openai => 'OpenAI 제공';
	@override String get cursorEditor => 'AI 코드 에디터';
	@override String get google => 'Google 제공';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$ko extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => '${model} 모델로 Claude를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.';
	@override String cursor({required Object model}) => '${model} 모델로 Cursor를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.';
	@override String codex({required Object model}) => '${model} 모델로 Codex를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.';
	@override String opencode({required Object model}) => '${model} 모델로 OpenCode를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.';
	@override String get kDefault => '시작하려면 위에서 제공자를 선택하세요';
	@override String devin({required Object model}) => 'Devin ${model} 준비 완료';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$ko extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '대화 계속하기';
	@override String get description => '코드에 대해 질문하거나, 변경을 요청하거나, 개발 작업에 도움을 받으세요';
	@override String get action => '계속 입력';
}

// Path: chat.session.loading
class Translations$chat$session$loading$ko extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => '이전 메시지 로딩 중...';
	@override String get sessionMessages => '세션 메시지 로딩 중...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$ko extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object total, required Object shown}) => '${total}개 중 ${shown}개 표시';
	@override String get scrollToLoad => '위로 스크롤하여 더 로드';
	@override String showingLast({required Object count, required Object total}) => '마지막 ${count}개 메시지 표시 (총 ${total}개)';
	@override String get loadEarlier => '이전 메시지 로드';
	@override String get loadAll => '모든 메시지 로드';
	@override String get loadingAll => '모든 메시지 로딩 중...';
	@override String get allLoaded => '모든 메시지 로드 완료';
	@override String get perfWarning => '모든 메시지가 로드됨 - 스크롤이 느려질 수 있습니다. "맨 아래로 스크롤"을 클릭하면 성능이 복구됩니다.';
	@override String get loadOlderFailed => '이전 메시지를 불러오지 못했습니다.';
	@override String get retry => '다시 시도';
	@override String get noSearchMatches => '검색과 일치하는 메시지가 없습니다.';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$ko extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '프로젝트 선택';
	@override String get description => '해당 디렉토리에서 대화형 Shell을 열 프로젝트를 선택하세요';
}

// Path: chat.shell.status
class Translations$chat$shell$status$ko extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get newSession => '새 세션';
	@override String get initializing => '초기화 중...';
	@override String get restarting => '재시작 중...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$ko extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get disconnect => '연결 끊기';
	@override String get disconnectTitle => 'Shell 연결 끊기';
	@override String get restart => '재시작';
	@override String get restartTitle => 'Shell 재시작 (먼저 연결 끊기)';
	@override String get connect => 'Shell에서 계속';
	@override String get connectTitle => 'Shell에 연결';
	@override String get kill => '종료 (SIGINT)';
	@override String get killTitle => '실행 중인 프로세스 종료 (Ctrl+C)';
	@override String get copyOutput => '출력 복사';
	@override String get copyOutputTitle => '터미널 출력 복사';
	@override String get copied => '복사됨!';
	@override String get zoomInTitle => '확대';
	@override String get zoomOutTitle => '축소';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$ko extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get thinking => '생각 중';
	@override String get processing => '처리 중';
	@override String get analyzing => '분석 중';
	@override String get working => '작업 중';
	@override String get computing => '계산 중';
	@override String get reasoning => '추론 중';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$ko extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get live => '실시간';
	@override String get paused => '일시 중지';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$ko extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}초';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '${time} 경과';
	@override String get startingNow => '지금 시작';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$ko extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => '생성 중지';
	@override String get pressEscToStop => 'Esc를 눌러 언제든 중지';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$ko extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get assistant => '어시스턴트';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$ko extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get rename => '이름 변경';
	@override String get delete => '삭제';
	@override String get copyPath => '경로 복사';
	@override String get download => '다운로드';
	@override String get newFile => '새 파일';
	@override String get newFolder => '새 폴더';
	@override String get upload => '파일 업로드';
	@override String get refresh => '새로 고침';
	@override String get menuLabel => '파일 컨텍스트 메뉴';
	@override String get loading => '로딩 중...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$ko extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get confirm => '삭제';
	@override String get fileWarning => '이 파일은 영구적으로 삭제됩니다.';
	@override String get folderWarning => '이 폴더와 모든 내용이 영구적으로 삭제됩니다.';
	@override String title({required Object type}) => '${type} 삭제';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$ko extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => '경로 복사 실패';
	@override String get fileCreated => '파일이 생성되었습니다';
	@override String get fileDeleted => '파일이 삭제되었습니다';
	@override String get folderCreated => '폴더가 생성되었습니다';
	@override String get folderDeleted => '폴더가 삭제되었습니다';
	@override String get folderDownloaded => '폴더가 ZIP으로 다운로드되었습니다';
	@override String get pathCopied => '경로가 클립보드에 복사되었습니다';
	@override String get renamed => '이름이 변경되었습니다';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$ko extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => '파일 이름은 점만으로 구성될 수 없습니다';
	@override String get emptyName => '파일 이름은 비워 둘 수 없습니다';
	@override String get invalidChars => '파일 이름에 잘못된 문자가 포함되어 있습니다';
	@override String get reserved => '파일 이름이 예약어입니다';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$ko extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get type => '유형';
	@override String get configure => '설정';
	@override String get confirm => '확인';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$ko extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get question => '이미 워크스페이스가 있으신가요, 아니면 새로 생성하시겠습니까?';
	@override late final Translations$common$projectWizard$step1$existing$ko existing = Translations$common$projectWizard$step1$existing$ko._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$ko kNew = Translations$common$projectWizard$step1$kNew$ko._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$ko extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get existingPath => '워크스페이스 경로';
	@override String get newPath => '워크스페이스 경로';
	@override String get existingPlaceholder => '/path/to/existing/workspace';
	@override String get newPlaceholder => '/path/to/new/workspace';
	@override String get existingHelp => '기존 워크스페이스 디렉토리의 전체 경로';
	@override String get newHelp => '워크스페이스 디렉토리의 전체 경로';
	@override String get githubUrl => 'GitHub URL (선택사항)';
	@override String get githubPlaceholder => 'https://github.com/username/repository';
	@override String get githubHelp => '선택사항: 저장소를 clone하려면 GitHub URL을 입력하세요';
	@override String get githubAuth => 'GitHub 인증 (선택사항)';
	@override String get githubAuthHelp => '비공개 저장소에만 필요합니다. 공개 저장소는 인증 없이 clone할 수 있습니다.';
	@override String get loadingTokens => '저장된 토큰 로딩 중...';
	@override String get storedToken => '저장된 토큰';
	@override String get newToken => '새 토큰';
	@override String get nonePublic => '없음 (공개)';
	@override String get selectToken => '토큰 선택';
	@override String get selectTokenPlaceholder => '-- 토큰 선택 --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => '이 토큰은 이 작업에만 사용됩니다';
	@override String get publicRepoInfo => '공개 저장소는 인증이 필요하지 않습니다. 공개 저장소를 clone하는 경우 토큰을 생략할 수 있습니다.';
	@override String get noTokensHelp => '저장된 토큰이 없습니다. 설정 → API Keys에서 토큰을 추가하면 재사용이 편리합니다.';
	@override String get optionalTokenPublic => 'GitHub 토큰 (공개 저장소는 선택사항)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (공개 저장소는 비워두세요)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$ko extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => '설정 검토';
	@override String get existingWorkspace => '기존 워크스페이스';
	@override String get newWorkspace => '새 워크스페이스';
	@override String get path => '경로:';
	@override String get cloneFrom => 'Clone 소스:';
	@override String get authentication => '인증:';
	@override String get usingStoredToken => '저장된 토큰 사용:';
	@override String get usingProvidedToken => '제공된 토큰 사용';
	@override String get noAuthentication => '인증 없음';
	@override String get sshKey => 'SSH 키';
	@override String get existingInfo => '워크스페이스가 프로젝트 목록에 추가되며 Claude/Cursor 세션에서 사용할 수 있습니다.';
	@override String get newWithClone => '이 폴더에 저장소가 clone됩니다.';
	@override String get newEmpty => '워크스페이스가 프로젝트 목록에 추가되며 Claude/Cursor 세션에서 사용할 수 있습니다.';
	@override String get cloningRepository => '저장소 clone 중...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$ko extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get back => '뒤로';
	@override String get next => '다음';
	@override String get createProject => '프로젝트 생성';
	@override String get creating => '생성 중...';
	@override String get cloning => 'Clone 중...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$ko extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get selectType => '기존 워크스페이스를 사용할지 새로 생성할지 선택해주세요';
	@override String get providePath => '워크스페이스 경로를 입력해주세요';
	@override String get failedToCreate => '워크스페이스 생성 실패';
	@override String get failedToCreateFolder => '폴더 생성 실패';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$ko extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$ko generic = Translations$common$notifications$codes$generic$ko._(_root);
	@override late final Translations$common$notifications$codes$permission$ko permission = Translations$common$notifications$codes$permission$ko._(_root);
	@override late final Translations$common$notifications$codes$run$ko run = Translations$common$notifications$codes$run$ko._(_root);
	@override late final Translations$common$notifications$codes$agent$ko agent = Translations$common$notifications$codes$agent$ko._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$ko extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get close => '닫기';
	@override String get later => '나중에';
	@override String get copyCommand => '명령어 복사';
	@override String get updateNow => '지금 업데이트';
	@override String get updating => '업데이트 중...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$ko extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get closeModal => '버전 업그레이드 모달 닫기';
	@override String get showSidebar => '사이드바 표시';
	@override String get settings => '설정';
	@override String get updateAvailable => '업데이트 가능';
	@override String get closeSidebar => '사이드바 닫기';
}

// Path: common.quota.section
class Translations$common$quota$section$ko extends Translations$common$quota$section$en {
	Translations$common$quota$section$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get overview => '개요';
	@override String get quotas => '쿼터';
	@override String get usage => '사용량';
	@override String get agents => '에이전트';
}

// Path: common.quota.filter
class Translations$common$quota$filter$ko extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get all => '전체';
}

// Path: common.quota.period
class Translations$common$quota$period$ko extends Translations$common$quota$period$en {
	Translations$common$quota$period$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7일';
	@override String get k30d => '30일';
	@override String get all => '전체';
}

// Path: common.quota.group
class Translations$common$quota$group$ko extends Translations$common$quota$group$en {
	Translations$common$quota$group$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get provider => '제공자';
	@override String get model => '모델';
	@override String get agent => '에이전트';
	@override String get tool => '도구';
}

// Path: common.quota.metric
class Translations$common$quota$metric$ko extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get tokens => '토큰';
	@override String get input => '입력';
	@override String get output => '출력';
	@override String get cache => '캐시 읽기';
	@override String get calls => 'API 호출';
	@override String get cost => '비용';
	@override String get sessions => '세션';
}

// Path: common.quota.cost
class Translations$common$quota$cost$ko extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get billed => '청구됨 (API + 초과분)';
	@override String get listPrice => '사용된 토큰의 정가';
	@override String get subscriptionValue => '구독으로 충당';
	@override String get cacheSavings => '캐시 절감';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$ko extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get billed => '청구됨 (API + 초과분)';
	@override String get listPrice => '사용된 토큰의 정가';
	@override String get subscriptionValue => '구독으로 충당';
}

// Path: common.quota.overview
class Translations$common$quota$overview$ko extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '토큰 및 비용 — 지난 7일';
	@override String get effectiveCost => '실질 비용 (7일)';
	@override String get alertsTitle => '알림';
	@override String get noAlerts => '지금 주의가 필요한 항목이 없습니다.';
	@override String get limitsTitle => '사용량 및 한도';
	@override String get activeTasks => '활성 작업';
	@override String get viewAccounts => '모든 계정';
	@override String get viewAgents => '모든 에이전트';
	@override String get noTasks => '지금 실행 중인 에이전트가 없습니다.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$ko extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '일일 추세';
	@override String breakdownTitle({required Object group}) => '${group}별 분석';
	@override String get colName => '이름';
	@override String get sourceUnavailable => '분석 저장소를 사용할 수 없습니다. 데이터를 표시하지 않습니다.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$ko extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value}개 실행 중';
	@override String get colAgent => '에이전트';
	@override String get colStatus => '상태';
	@override String get colTask => '작업';
	@override String get colModel => '계정 / 모델';
	@override String get colTime => '시간';
	@override String get empty => '이 필터와 일치하는 에이전트가 없습니다.';
	@override String get detailSession => '세션';
	@override String get detailStarted => '시작됨';
	@override String get detailRetries => '재시도';
	@override String get detailResult => '결과';
	@override String get notTracked => '추적 안 됨';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$ko extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get running => '실행 중';
	@override String get waiting => '대기 중';
	@override String get failed => '실패';
	@override String get finished => '완료됨';
	@override String get queued => '대기열';
}

// Path: common.quota.alert
class Translations$common$quota$alert$ko extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: 현재 속도로 ${value} 후 한도 소진';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% 사용 (임계값 ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$ko extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get live => '실시간';
	@override String get cached => '캐시됨';
	@override String get estimate => '추정';
	@override String get unknown => '알 수 없음';
	@override String get error => '오류';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$ko extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get atRisk => '위험한 한도';
	@override String atRiskHint({required Object value}) => '${value}% 초과 계정';
	@override String get windowsAtRisk => '소진 임박 윈도우';
	@override String get errored => '동기화 실패';
	@override String get activeAgents => '활성 에이전트';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} 대기 · ${queued} 대기열';
	@override String get nextReset => '다음 리셋';
	@override String get tokens => '토큰';
	@override String sessionsHint({required Object value}) => '${value} 세션';
	@override String get cost => '예상 비용';
	@override String costHint({required Object value}) => '${value} 플랜으로 충당';
}

// Path: common.quota.empty
class Translations$common$quota$empty$ko extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '연결된 계정 없음';
	@override String get description => 'Claude, Codex, Gemini 또는 CommandCode에 로그인하면 여기서 쿼터를 추적할 수 있습니다.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$ko extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '알림 및 라우팅';
	@override String get description => '대시보드가 경고하는 시점과 새 작업에 계정을 제안하는 방식을 제어합니다.';
	@override String get alertsEnabled => '예측 및 임계값 알림';
	@override String get alertsEnabledHint => '90%가 되어서가 아니라 현재 속도로 한도가 소진되기 전에 경고합니다.';
	@override String get watchThreshold => '관찰 임계값 (%)';
	@override String get dangerThreshold => '위험 임계값 (%)';
	@override String get routingMode => '라우팅';
	@override late final Translations$common$quota$settings$routing$ko routing = Translations$common$quota$settings$routing$ko._(_root);
	@override String get logSources => '로그 소스';
	@override String get logSourcesHint => '사용량 및 에이전트 화면이 읽는 읽기 전용 소스입니다.';
	@override String get quotaConsent => '쿼터 폴링 허용';
	@override String get quotaConsentHint => '저장된 자격 증명으로 제공자 엔드포인트를 폴링하여 실시간 한도를 읽습니다.';
	@override String get perAccount => '계정별 재정의';
	@override String get tab => 'Control Center 설정';
}

// Path: common.quota.range
class Translations$common$quota$range$ko extends Translations$common$quota$range$en {
	Translations$common$quota$range$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => '전체';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$ko extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => '설정에서 Browser를 활성화하면 에이전트가 모니터링되는 브라우저 세션을 열 수 있습니다.';
	@override String get descEnabled => 'AI 작업이 Browser를 사용하는 동안 에이전트 브라우저 세션이 여기에 표시됩니다.';
	@override String get titleDisabled => 'Browser가 비활성화됨';
	@override String get titleEnabled => '아직 브라우저 세션 없음';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$ko extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => '브라우저 작업 실패';
	@override String get loadFailed => 'Browser 로드 실패';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$ko extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Browser를 사용하여 결제 흐름을 검사하고 깨진 UI 상태를 보고하세요.';
	@override String get prompt2 => 'Browser로 <url>을 열고 페이지와 상호작용한 뒤 각 단계 후 변경 사항을 요약하세요.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$ko extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => '일 전';
	@override String get hoursAgo => '시간 전';
	@override String get justNow => '방금';
	@override String get minutesAgo => '분 전';
	@override String get never => '없음';
	@override String get secondsAgo => '초 전';
	@override String get unknown => '알 수 없음';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$ko extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get disabled => '비활성화됨';
	@override String get installing => '설치 중';
	@override String get ready => '준비됨';
	@override String get setupRequired => '설정 필요';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$ko extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => '모든 브랜치 보기 (${count})';
	@override String commits({required Object count}) => '모든 커밋 보기 (${count})';
	@override String files({required Object count}) => '모든 파일 보기 (${count})';
	@override String sessions({required Object count}) => '모든 세션 보기 (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$ko extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get costNote => '비용은 공개된 토큰당 요금을 기반으로 한 클라이언트 측 추정치이며, 알 수 없는 모델은 "—"로 표시됩니다.';
	@override String get estCost => '예상 비용';
	@override String get inputOutput => '입력 / 출력';
	@override String get model => '모델';
	@override String get na => '해당 없음';
	@override String get openSplit => '분할 뷰로 열기';
	@override String get provider => '제공자';
	@override String get selectSession => '세션 선택…';
	@override String get tokensUsed => '사용된 토큰';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$ko extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get actions => '작업';
	@override String get branches => '브랜치';
	@override String get commits => '커밋';
	@override String get files => '파일';
	@override String get git => 'Git';
	@override String get navigate => '탐색';
	@override String get sessions => '세션';
	@override String get settings => '설정';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$ko extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get close => '닫기';
	@override String get navigate => '탐색';
	@override String get select => '선택';
	@override String get togglePalette => '팔레트 전환';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$ko extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => '세션 비교';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => '설정 열기';
	@override String get selectProjectFirst => '먼저 프로젝트를 선택하세요';
	@override String settingsEntry({required Object label}) => '설정: ${label}';
	@override String get startNewChat => '새 채팅 시작';
	@override String switchTo({required Object name}) => '전환: ${name}';
	@override String get toggleTheme => '테마 전환';
	@override String get tokensAndCost => '토큰 및 비용';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$ko extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get board => '에이전트 보드로 이동';
	@override String get chat => '채팅으로 이동';
	@override String get files => '파일로 이동';
	@override String get git => 'Git으로 이동';
	@override String get sourceControl => '소스 컨트롤로 이동';
	@override String get tasks => '작업으로 이동';
	@override String get usage => '쿼터 및 사용량으로 이동';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$ko extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get actions => '작업';
	@override String get branches => '브랜치';
	@override String get commits => '커밋';
	@override String get compare => '비교';
	@override String get files => '파일';
	@override String get sessions => '세션';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$ko extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => '"${branch}" 브랜치를 삭제하시겠습니까? 일반 삭제는 브랜치가 완전히 병합된 경우에만 성공합니다. 되돌릴 수 없습니다.';
	@override String confirmSwitch({required Object branch}) => '"${branch}" 브랜치로 전환하시겠습니까? 커밋되지 않은 변경 사항이 없는지 확인하세요.';
	@override String countBoth({required Object local, required Object remote}) => '로컬 ${local}개, 원격 ${remote}개';
	@override String countLocal({required Object count}) => '로컬 ${count}개';
	@override String get current => '현재';
	@override String deleteTitle({required Object branch}) => '${branch} 삭제';
	@override String get emptyDesc => '브랜치를 생성하여 병렬 작업을 시작하세요.';
	@override String get forceDelete => '강제 삭제';
	@override String get forceDeleteDesc => '다른 곳에 병합되지 않은 커밋이 있어도 브랜치를 영구적으로 제거합니다.';
	@override String get forceDeleteLabel => '병합되지 않은 이 브랜치 강제 삭제';
	@override String get local => '로컬';
	@override String get kNew => '새 브랜치';
	@override String get noMatch => '검색과 일치하는 브랜치가 없습니다';
	@override String get none => '브랜치를 찾을 수 없습니다';
	@override String get remote => '원격';
	@override String get kSwitch => '전환';
	@override String switchTo({required Object branch}) => '${branch}(으)로 전환';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$ko extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get commit => '확인';
	@override String get delete => '삭제';
	@override String get deleteBranch => '삭제';
	@override String get discard => '폐기';
	@override String get publish => '게시';
	@override String get pull => '풀';
	@override String get push => '푸시';
	@override String get revertLocalCommit => '커밋 되돌리기';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$ko extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get commit => '작업 확인';
	@override String get delete => '파일 삭제';
	@override String get deleteBranch => '브랜치 삭제';
	@override String get discard => '변경 사항 폐기';
	@override String get publish => '브랜치 게시';
	@override String get pull => 'Pull 확인';
	@override String get push => 'Push 확인';
	@override String get revertLocalCommit => '로컬 커밋 되돌리기';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$ko extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => '브랜치 생성 실패';
	@override String get createWorktreeFailed => 'worktree 생성 실패';
	@override String get deleteBranchFailed => '브랜치 삭제 실패';
	@override String get fetchFailed => 'Fetch 실패';
	@override String get initFailed => '리포지토리 초기화 실패';
	@override String get initialCommitFailed => '첫 커밋 생성 실패';
	@override String get mergeFailed => '병합 실패';
	@override String get openWorktreeFailed => 'worktree 열기 실패';
	@override String get operationFailed => 'git 작업 실패';
	@override String get publishFailed => '게시 실패';
	@override String get pullFailed => 'Pull 실패';
	@override String get pushFailed => 'Push 실패';
	@override String get removeWorktreeFailed => 'worktree 제거 실패';
	@override String get stageFailed => '스테이징 실패';
	@override String get stageHunksFailed => '헝크 스테이징 실패';
	@override String get switchFailed => '브랜치 전환 실패';
	@override String get unstageFailed => '스테이징 해제 실패';
	@override String get unstageHunksFailed => '헝크 스테이징 해제 실패';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$ko extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get added => '추가됨';
	@override String get author => '작성자';
	@override String get changedFiles => '변경된 파일';
	@override String get date => '날짜';
	@override String get empty => '커밋을 찾을 수 없습니다';
	@override String get files => '파일';
	@override String get removed => '제거됨';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$ko extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => '병합 후 worktree를 제거하고 브랜치 삭제';
	@override String get cleanupLabel => '병합 후 정리';
	@override String commitCount({required Object count}) => '${count}개 커밋';
	@override String get merge => '병합';
	@override String mergeMessage({required Object branch}) => '\'${branch}\' 브랜치 병합';
	@override String get messageLabel => '커밋 메시지';
	@override String squashDesc({required Object commits, required Object branch}) => '${commits}개를 ${branch}의 단일 커밋으로 결합';
	@override String get squashLabel => '커밋 스쿼시';
	@override String get squashMerge => '스쿼시 및 병합';
	@override String squashMessage({required Object branch}) => '\'${branch}\' 브랜치 스쿼시 병합';
	@override String get title => 'Worktree 병합';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$ko extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => '현재 브랜치(${branch})에서 새 브랜치를 생성합니다';
	@override String get nameLabel => '브랜치 이름';
	@override String get submit => '브랜치 생성';
	@override String get title => '새 브랜치 생성';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$ko extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => '브랜치';
	@override String get createFrom => '생성 기준';
	@override String get description => '브랜치를 별도 폴더에 체크아웃하여 병렬로 작업하세요.';
	@override String get existingBranch => '기존 브랜치 — 있는 그대로 체크아웃됩니다.';
	@override String get submit => 'Worktree 생성';
	@override String get switchAfter => '생성 후 worktree로 전환';
	@override String get title => '새 Worktree';
	@override String get willCreateIn => '생성 위치';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$ko extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get create => '첫 커밋 생성';
	@override String get creating => '첫 커밋 생성 중...';
	@override String get description => '이 리포지토리에는 아직 커밋이 없습니다. 첫 커밋을 생성하여 변경 추적을 시작하세요.';
	@override String get title => '아직 커밋 없음';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$ko extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => '이 프로젝트는 아직 git 리포지토리가 아닙니다. 초기화하여 변경 추적 및 소스 컨트롤 기능을 사용하세요.';
	@override String get init => 'git init 실행';
	@override String get initializing => '리포지토리 초기화 중...';
	@override String get title => 'git 리포지토리 없음';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$ko extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => '브랜치도 삭제';
	@override String description({required Object branch}) => '${branch}의 worktree를 제거하시겠습니까? 폴더가 삭제되고 연결된 프로젝트가 보관됩니다 — 채팅 세션은 복구 가능합니다.';
	@override String dirtyWarning({required Object count}) => '이 worktree에는 손실될 커밋되지 않은 변경 사항이 ${count}개 있습니다.';
	@override String get discardChanges => '커밋되지 않은 변경 사항 폐기';
	@override String get title => 'Worktree 제거';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$ko extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get added => '추가됨';
	@override String get deleted => '삭제됨';
	@override String get modified => '수정됨';
	@override String get untracked => '추적 안 됨';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$ko extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count}개 변경 사항';
	@override String count({required Object count}) => '${count}개 worktree';
	@override String get createFirst => '첫 worktree를 생성하세요';
	@override String get detached => '분리됨';
	@override String detachedAt({required Object sha}) => '분리됨 @ ${sha}';
	@override String get detachedHead => '분리된 HEAD';
	@override String get emptyDesc => 'worktree는 브랜치를 자체 폴더에 체크아웃하여 별도의 채팅 세션을 나란히 실행하고 준비되면 결과를 병합할 수 있습니다.';
	@override String get emptyTitle => '브랜치에서 병렬로 작업';
	@override String get locked => '잠김';
	@override String get mainWorktree => '메인 worktree';
	@override String mergeTitle({required Object branch}) => '${branch}을(를) 기본 브랜치에 병합';
	@override String get kNew => '새 worktree';
	@override String get none => 'worktree 없음';
	@override String get nothingToMerge => '병합할 내용 없음 — 기본 브랜치보다 앞선 커밋 없음';
	@override String get open => '열기';
	@override String get refresh => 'worktree 새로고침';
	@override String removeTitle({required Object branch}) => '${branch}의 worktree 제거';
	@override String switchTo({required Object branch}) => '${branch}(으)로 전환';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$ko extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get changes => '변경 사항';
	@override String get history => '커밋';
	@override String get branches => '브랜치';
	@override String get worktrees => '워크트리';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$ko extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '범위';
	@override String get user => '사용자';
	@override String get project => '프로젝트';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$ko extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get appearance => '외관';
	@override String get toolDisplay => '도구 표시';
	@override String get inputSettings => '입력 설정';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$ko extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get dragging => '드래그 핸들';
	@override String get closePanel => '설정 패널 닫기';
	@override String get openPanel => '설정 패널 열기';
	@override String get draggingStatus => '드래그 중...';
	@override String get toggleAndMove => '클릭하여 토글, 드래그하여 이동';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$ko extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get closePanel => '단축키 패널 닫기';
	@override String get openPanel => '단축키 패널 열기';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$ko extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$ko extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
	@override late final Translations$settings$orchestration$pool$fields$ko fields = Translations$settings$orchestration$pool$fields$ko._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$ko extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$ko extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$ko taskTypes = Translations$settings$orchestration$rules$taskTypes$ko._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$ko extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$ko modes = Translations$settings$orchestration$planner$modes$ko._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$ko modeHints = Translations$settings$orchestration$planner$modeHints$ko._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$ko templates = Translations$settings$orchestration$planner$templates$ko._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$ko extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$ko onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$ko._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$ko extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

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
class Translations$settings$notifications$webPush$ko extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '웹 푸시 알림';
	@override String get enable => '푸시 알림 활성화';
	@override String get disable => '푸시 알림 비활성화';
	@override String get enabled => '푸시 알림이 활성화되었습니다';
	@override String get loading => '업데이트 중...';
	@override String get unsupported => '이 브라우저에서는 푸시 알림이 지원되지 않습니다.';
	@override String get denied => '푸시 알림이 차단되었습니다. 브라우저 설정에서 허용해 주세요.';
	@override String get iosHint => 'iPhone/iPad에서는 ddagent를 홈 화면에 추가하고(공유 → 홈 화면에 추가) 설치된 앱에서 알림을 활성화해야만 알림이 작동합니다.';
	@override String get test => '테스트 알림 보내기';
	@override String get testNoSubscription => '구독 중인 기기가 없습니다. 먼저 휴대폰에서 "활성화"를 누르세요.';
	@override String testSuccess({required Object count}) => '${count}개 기기에 전송했습니다. 휴대폰에 아무것도 표시되지 않으면 ddagent를 홈 화면에 추가하세요(iOS 요구 사항).';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$ko extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '데스크톱 앱 알림';
	@override String get enable => '알림 활성화';
	@override String get disable => '알림 비활성화';
	@override String get enabled => '이 데스크톱 앱에 대한 알림이 활성화되었습니다';
	@override String get unsupported => '이 시스템에서는 데스크톱 알림이 지원되지 않습니다.';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$ko extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '소리';
	@override String get description => '채팅 실행이 완료되면 짧은 알림음을 재생합니다.';
	@override String get enabled => '사용';
	@override String get test => '소리 테스트';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$ko extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '이벤트 유형';
	@override String get actionRequired => '작업 필요';
	@override String get stop => '실행 중지';
	@override String get error => '실행 실패';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$ko extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '다크 모드';
	@override String get description => '라이트/다크 테마 전환';
}

// Path: settings.appearanceSettings.projectSorting
class Translations$settings$appearanceSettings$projectSorting$ko extends Translations$settings$appearanceSettings$projectSorting$en {
	Translations$settings$appearanceSettings$projectSorting$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '프로젝트 정렬';
	@override String get description => '사이드바에서 프로젝트 정렬 방식';
	@override String get alphabetical => '알파벳순';
	@override String get recentActivity => '최근 활동순';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$ko extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '코드 에디터';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$ko theme = Translations$settings$appearanceSettings$codeEditor$theme$ko._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$ko wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$ko._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$ko showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$ko._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$ko lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$ko._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$ko fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$ko._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$ko extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '터미널';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ko focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ko._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$ko extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get add => 'MCP 서버 추가';
	@override String get edit => 'MCP 서버 편집';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$ko extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get form => '폼 입력';
	@override String get json => 'JSON 가져오기';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$ko extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '범위';
	@override String get userGlobal => '사용자 (전역)';
	@override String get projectLocal => '프로젝트 (로컬)';
	@override String get userDescription => '사용자 범위: 모든 프로젝트에서 사용 가능';
	@override String get projectDescription => '로컬 범위: 선택한 프로젝트에서만 사용 가능';
	@override String get cannotChange => '기존 서버를 편집할 때는 범위를 변경할 수 없습니다';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$ko extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get serverName => '서버 이름';
	@override String get transportType => '전송 유형';
	@override String get command => '명령어';
	@override String get arguments => '인수 (한 줄에 하나씩)';
	@override String get jsonConfig => 'JSON 설정';
	@override String get url => 'URL';
	@override String get envVars => '환경 변수 (KEY=value, 한 줄에 하나씩)';
	@override String get headers => '헤더 (KEY=value, 한 줄에 하나씩)';
	@override String get selectProject => '프로젝트 선택...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$ko extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'my-server';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$ko extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get missingType => '필수 항목 누락: type';
	@override String get stdioRequiresCommand => 'stdio 유형은 command 필드가 필요합니다';
	@override String httpRequiresUrl({required Object type}) => '${type} 유형은 url 필드가 필요합니다';
	@override String get invalidJson => '잘못된 JSON 형식';
	@override String get jsonHelp => 'MCP 서버 설정을 JSON 형식으로 붙여넣으세요. 예시:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$ko extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cancel => '취소';
	@override String get saving => '저장 중...';
	@override String get addServer => '서버 추가';
	@override String get updateServer => '서버 업데이트';
}

// Path: settings.git.name
class Translations$settings$git$name$ko extends Translations$settings$git$name$en {
	Translations$settings$git$name$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git 이름';
	@override String get help => 'Git 커밋에 사용될 이름';
}

// Path: settings.git.email
class Translations$settings$git$email$ko extends Translations$settings$git$email$en {
	Translations$settings$git$email$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git 이메일';
	@override String get help => 'Git 커밋에 사용될 이메일';
}

// Path: settings.git.actions
class Translations$settings$git$actions$ko extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get save => '설정 저장';
	@override String get saving => '저장 중...';
}

// Path: settings.git.status
class Translations$settings$git$status$ko extends Translations$settings$git$status$en {
	Translations$settings$git$status$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get success => '저장 완료';
	@override String get error => '저장 실패';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$ko extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ API 키를 저장하세요';
	@override String get alertMessage => '이 키는 지금만 볼 수 있습니다. 안전하게 보관하세요.';
	@override String get iveSavedIt => '저장했습니다';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$ko extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'API 키 이름 (예: Production Server)';
	@override String get createButton => '생성';
	@override String get cancelButton => '취소';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$ko extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get created => '생성일:';
	@override String get lastUsed => '마지막 사용:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$ko extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get active => '활성';
	@override String get inactive => '비활성';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$ko extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub 토큰';
	@override String get description => '외부 API를 통해 비공개 저장소를 clone하기 위한 GitHub Personal Access Token을 추가합니다.';
	@override String get descriptionAlt => '비공개 저장소를 clone하기 위한 GitHub Personal Access Token을 추가합니다. 저장하지 않고 API 요청에 직접 토큰을 전달할 수도 있습니다.';
	@override String get addButton => '토큰 추가';
	@override late final Translations$settings$apiKeys$github$form$ko form = Translations$settings$apiKeys$github$form$ko._(_root);
	@override String get empty => '추가된 GitHub 토큰이 없습니다.';
	@override String get added => '추가일:';
	@override String get confirmDelete => '이 GitHub 토큰을 삭제하시겠습니까?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$ko extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '외부 API 문서';
	@override String get description => '외부 API를 사용하여 애플리케이션에서 Claude/Cursor 세션을 트리거하는 방법을 알아보세요.';
	@override String get viewLink => 'API 문서 보기 →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$ko extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => '업데이트 가능: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$ko extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLI가 설치되지 않았습니다';
	@override String get description => '작업 관리 기능을 사용하려면 TaskMaster CLI가 필요합니다. 시작하려면 설치하세요:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'GitHub에서 보기';
	@override String get afterInstallation => '설치 후:';
	@override late final Translations$settings$tasks$notInstalled$steps$ko steps = Translations$settings$tasks$notInstalled$steps$ko._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$ko extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'TaskMaster 통합 활성화';
	@override String get enableDescription => '인터페이스 전체에 TaskMaster 작업, 배너 및 사이드바 표시';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$ko extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get checking => '확인 중...';
	@override String get connected => '연결됨';
	@override String get notConnected => '연결되지 않음';
	@override String get disconnected => '연결 끊김';
	@override String get checkingAuth => '인증 상태 확인 중...';
	@override String loggedInAs({required Object email}) => '${email}(으)로 로그인됨';
	@override String providerAccount({required Object provider}) => '${provider} 계정';
	@override String get authenticatedUser => '인증된 사용자';
}

// Path: settings.agents.account
class Translations$settings$agents$account$ko extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$ko claude = Translations$settings$agents$account$claude$ko._(_root);
	@override late final Translations$settings$agents$account$cursor$ko cursor = Translations$settings$agents$account$cursor$ko._(_root);
	@override late final Translations$settings$agents$account$codex$ko codex = Translations$settings$agents$account$codex$ko._(_root);
	@override late final Translations$settings$agents$account$opencode$ko opencode = Translations$settings$agents$account$opencode$ko._(_root);
	@override late final Translations$settings$agents$account$commandcode$ko commandcode = Translations$settings$agents$account$commandcode$ko._(_root);
	@override late final Translations$settings$agents$account$antigravity$ko antigravity = Translations$settings$agents$account$antigravity$ko._(_root);
	@override late final Translations$settings$agents$account$devin$ko devin = Translations$settings$agents$account$devin$ko._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$ko extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '로그인';
	@override String get reAuthenticate => '재인증';
	@override String description({required Object agent}) => 'AI 기능을 활성화하려면 ${agent} 계정에 로그인하세요';
	@override String get reAuthDescription => '다른 계정으로 로그인하거나 자격 증명을 새로고침하세요';
	@override String get button => '로그인';
	@override String get reLoginButton => '재로그인';
}

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$ko extends Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '권한 확인 건너뛰기 (주의해서 사용)';
	@override String get claudeDescription => '--dangerously-skip-permissions 플래그와 동일';
	@override String get cursorDescription => 'Cursor CLI의 -f 플래그와 동일';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$ko extends Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '허용된 도구';
	@override String get description => '권한 확인 없이 자동으로 허용되는 도구';
	@override String get placeholder => '예: "Bash(git log:*)" 또는 "Write"';
	@override String get quickAdd => '자주 쓰는 도구 빠른 추가:';
	@override String get empty => '설정된 허용 도구 없음';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$ko extends Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '차단된 도구';
	@override String get description => '권한 확인 없이 자동으로 차단되는 도구';
	@override String get placeholder => '예: "Bash(rm:*)"';
	@override String get empty => '설정된 차단 도구 없음';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$ko extends Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '허용된 Shell 명령어';
	@override String get description => '권한 확인 없이 자동으로 허용되는 Shell 명령어';
	@override String get placeholder => '예: "Shell(ls)" 또는 "Shell(git status)"';
	@override String get quickAdd => '자주 쓰는 명령어 빠른 추가:';
	@override String get empty => '설정된 허용 명령어 없음';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$ko extends Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '차단된 Shell 명령어';
	@override String get description => '자동으로 차단되는 Shell 명령어';
	@override String get placeholder => '예: "Shell(rm -rf)" 또는 "Shell(sudo)"';
	@override String get empty => '설정된 차단 명령어 없음';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$ko extends Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '도구 패턴 예시:';
	@override String get bashGitLog => '- 모든 git log 명령어 허용';
	@override String get bashGitDiff => '- 모든 git diff 명령어 허용';
	@override String get write => '- 모든 Write 도구 사용 허용';
	@override String get bashRm => '- 모든 rm 명령어 차단 (위험)';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$ko extends Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Shell 명령어 예시:';
	@override String get ls => '- ls 명령어 허용';
	@override String get gitStatus => '- git status 허용';
	@override String get npmInstall => '- npm install 허용';
	@override String get rmRf => '- 재귀 삭제 차단';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$ko extends Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => '권한 모드';
	@override String get description => 'Codex가 파일 수정 및 명령어 실행을 처리하는 방식을 제어합니다';
	@override late final Translations$settings$permissions$codex$modes$ko modes = Translations$settings$permissions$codex$modes$ko._(_root);
	@override String get technicalDetails => '기술 상세';
	@override late final Translations$settings$permissions$codex$technicalInfo$ko technicalInfo = Translations$settings$permissions$codex$technicalInfo$ko._(_root);
}

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$ko extends Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get add => '추가';
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$ko extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '권한 모드';
	@override String description({required Object provider}) => '새 ${provider} 세션의 기본 권한 모드. 개별 세션에서 재정의할 수 있습니다.';
	@override late final Translations$settings$permissions$permissionMode$modes$ko modes = Translations$settings$permissions$permissionMode$modes$ko._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$ko extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Model Context Protocol 서버는 Claude에 추가 도구와 데이터 소스를 제공합니다';
	@override String get cursor => 'Model Context Protocol 서버는 Cursor에 추가 도구와 데이터 소스를 제공합니다';
	@override String get codex => 'Model Context Protocol 서버는 Codex에 추가 도구와 데이터 소스를 제공합니다';
	@override String get opencode => 'Model Context Protocol 서버는 OpenCode에 추가 도구와 데이터 소스를 제공합니다';
	@override String get commandcode => 'Model Context Protocol 서버는 Command Code에 추가 도구와 데이터 소스를 제공합니다';
	@override String get antigravity => 'Model Context Protocol 서버는 Antigravity에 추가 도구와 데이터 소스를 제공합니다';
	@override String get devin => 'Model Context Protocol 서버는 Devin에 추가 도구와 데이터 소스를 제공합니다';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$ko extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get local => '로컬';
	@override String get user => '사용자';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$ko extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get command => '명령어';
	@override String get url => 'URL';
	@override String get args => '인수';
	@override String get environment => '환경';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$ko extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '도구';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count}개 더';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$ko extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get edit => '서버 편집';
	@override String get delete => '서버 삭제';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$ko extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get badge => '관리됨';
	@override String get hint => 'ddagent가 관리합니다.';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$ko extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'Codex MCP 정보';
	@override String get description => 'Codex는 stdio 기반 MCP 서버를 지원합니다. 추가 도구와 리소스로 Codex의 기능을 확장하는 서버를 추가할 수 있습니다.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$ko extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '"${serverName}"이(가) 제공자 구성에서 제거됩니다.';
	@override String get title => 'MCP 서버를 삭제하시겠습니까?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$ko extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => '알림 임계값, 라우팅 정책, 쿼터를 폴링하는 계정.';
	@override String get saved => '저장됨';
	@override String get alertsSection => '알림';
	@override String get alertsSectionHint => '한도가 실제로 소진되기 전에 경고합니다. 100%가 되어서가 아닙니다.';
	@override String get alertsEnabled => '예측 한도 알림';
	@override String get alertsEnabledHint => '개요와 계정 카드에 속도 기반 예측을 표시합니다.';
	@override String get watchThreshold => '관찰 임계값 (%)';
	@override String get watchThresholdHint => '이 판독값 이상인 계정은 위험으로 계산됩니다.';
	@override String get dangerThreshold => '위험 임계값 (%)';
	@override String get dangerThresholdHint => '이 값 이상의 판독값은 빨간색으로 표시됩니다.';
	@override String get routingSection => '라우팅';
	@override String get routingSectionHint => '패널이 여유가 가장 많은 계정으로 작업을 옮기는 방식.';
	@override late final Translations$settings$quota$settings$routing$ko routing = Translations$settings$quota$settings$routing$ko._(_root);
	@override String get routingNote => '계정 전환은 비용과 모델 품질을 변경하므로 항상 명시적 결정이 필요합니다.';
	@override String get accountsSection => '폴링된 계정';
	@override String get accountsSectionHint => '자격 증명은 각 도구에서 읽습니다. 패널이 다른 곳으로 보내지 않습니다.';
	@override String get sourcesSection => '데이터 소스';
	@override String get sourcesSectionHint => '사용량 및 비용 수치의 출처.';
	@override String get logSources => '토큰 및 비용 로그 저장소';
	@override String get logSourcesHint => 'tokboard 수집기와 공유되는 읽기 전용 집계 저장소.';
	@override String get readOnly => '읽기 전용';
	@override String get quotaConsent => '쿼터 폴링';
	@override String get quotaConsentHint => '로컬에 저장된 자격 증명으로 제공자 쿼터 엔드포인트를 읽습니다.';
	@override String get localOnly => '로컬 전용';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$ko extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => '아직 감지된 계정이 없습니다.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$ko extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get cached => '캐시됨';
	@override String get error => '오류';
	@override String get estimate => '추정';
	@override String get live => '실시간';
	@override String get unknown => '알 수 없음';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$ko extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => '브라우저 런타임 설치 실패';
	@override String get loadSettings => 'Browser 설정 로드 실패';
	@override String get loadStatus => 'Browser 상태 로드 실패';
	@override String get saveSettings => 'Browser 설정 저장 실패';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$ko extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'AI 기반 작업 관리: 복잡한 프로젝트를 관리하기 쉬운 하위 작업으로 분할';
	@override String get prdTemplates => 'PRD 템플릿: 제품 요구사항 문서(PRD)로부터 작업 생성';
	@override String get dependencyTracking => '의존성 추적: 작업 간 관계와 실행 순서 파악';
	@override String get progressVisualization => '진행 상황 시각화: 칸반 보드와 상세한 작업 분석';
	@override String get cliIntegration => 'CLI 연동: 고급 워크플로우를 위한 taskmaster 명령어 사용';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$ko extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$ko createPRD = Translations$tasks$gettingStarted$steps$createPRD$ko._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$ko generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$ko._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$ko analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$ko._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$ko startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$ko._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$ko extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 예시:\n"Claude Task Master로 새 프로젝트를 초기화했어요. .taskmaster/docs/prd.txt에 PRD가 있는데, 이를 분석해서 초기 작업을 설정하는 걸 도와줄 수 있나요?"';
	@override String get expandTask => '💬 예시:\n"작업 5가 복잡해 보이는데, 하위 작업으로 나눠줄 수 있나요?"';
	@override String get addTask => '💬 예시:\n"Cloudinary를 사용한 사용자 프로필 이미지 업로드 기능을 구현하는 새 작업을 추가해주세요. 가장 좋은 방법을 조사해주세요."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$ko extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 유용한 팁';
	@override String get search => '검색창을 사용해 특정 작업을 빠르게 찾으세요';
	@override String get views => '보기 전환 버튼으로 칸반, 목록, 그리드 보기를 전환하세요';
	@override String get filters => '필터를 사용해 특정 상태나 우선순위의 작업에 집중하세요';
	@override String get details => '작업을 클릭하면 상세 정보를 확인하고 하위 작업을 관리할 수 있습니다';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$ko extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 더 알아보기';
	@override String get description => 'TaskMaster AI는 개발자를 위한 고급 작업 관리 시스템입니다. 문서와 예시를 확인하고 프로젝트에 기여해보세요.';
	@override String get githubButton => 'GitHub에서 보기';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$ko extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '아직 카드 없음';
	@override String get description => '카드를 추가하고 작업을 설명한 후 준비로 드래그하면 에이전트가 작업을 시작합니다.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$ko extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get backlog => '백로그';
	@override String get ready => '시작 준비';
	@override String get working => '작업 중';
	@override String get needsDecision => '결정 필요';
	@override String get done => '완료';
	@override String get archived => '보관됨';
}

// Path: tasks.board.card
class Translations$tasks$board$card$ko extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get running => '실행 중';
	@override String get abort => '중단';
	@override String get delete => '삭제';
	@override String get openSession => '세션 열기';
	@override String get pullRequest => '풀 리퀘스트';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$ko extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get createTitle => '새 카드';
	@override String get editTitle => '카드 편집';
	@override String get titleLabel => '제목';
	@override String get titlePlaceholder => '에이전트가 무엇을 해야 하나요?';
	@override String get descriptionLabel => '설명';
	@override String get descriptionPlaceholder => '컨텍스트, 수용 기준, 링크 추가...';
	@override String get cancel => '취소';
	@override String get save => '저장';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$ko extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get provider => '에이전트';
	@override String get anyProvider => '모든 에이전트';
	@override String get model => '모델';
	@override String get defaultModel => '기본 모델';
	@override String get effort => '추론';
	@override String get defaultEffort => '기본값';
	@override String get searchModel => '모델 검색…';
	@override String get noModels => '일치하는 모델 없음';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$ko extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '"${cardTitle}"이(가) 영구적으로 삭제됩니다.';
	@override String get title => '카드를 삭제하시겠습니까?';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$ko extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '기존 워크스페이스';
	@override String get description => '서버에 이미 워크스페이스가 있고 프로젝트 목록에 추가만 하면 됩니다';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$ko extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '새 워크스페이스';
	@override String get description => '새 워크스페이스를 생성하고, 선택적으로 GitHub 저장소에서 clone합니다';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$ko extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$ko info = Translations$common$notifications$codes$generic$info$ko._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$ko extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$ko required = Translations$common$notifications$codes$permission$required$ko._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$ko extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$ko stopped = Translations$common$notifications$codes$run$stopped$ko._(_root);
	@override late final Translations$common$notifications$codes$run$failed$ko failed = Translations$common$notifications$codes$run$failed$ko._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$ko extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$ko notification = Translations$common$notifications$codes$agent$notification$ko._(_root);
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$ko extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get manual => '수동 — 권장만 표시';
	@override String get ask => '계정 전환 전 확인';
	@override String get autoLowRisk => '저위험 작업 자동 전환';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$ko extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

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
class Translations$settings$orchestration$rules$taskTypes$ko extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

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
class Translations$settings$orchestration$planner$modes$ko extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$ko extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$ko extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$ko extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$ko extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '에디터 테마';
	@override String get description => '코드 에디터의 기본 테마';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$ko extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '자동 줄바꿈';
	@override String get description => '에디터에서 기본적으로 자동 줄바꿈 활성화';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$ko extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '미니맵 표시';
	@override String get description => 'Diff 보기에서 쉬운 탐색을 위한 미니맵 표시';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$ko extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '줄 번호 표시';
	@override String get description => '에디터에 줄 번호 표시';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$ko extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '글꼴 크기';
	@override String get description => '에디터 글꼴 크기 (픽셀)';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ko extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '포커스가 포인터를 따름';
	@override String get description => '마우스를 올리면 입력을 위해 터미널에 포커스';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$ko extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => '토큰 이름 (예: Personal Repos)';
	@override String get tokenPlaceholder => 'GitHub 개인 액세스 토큰 (ghp_...)';
	@override String get descriptionPlaceholder => '설명 (선택사항)';
	@override String get addButton => '토큰 추가';
	@override String get cancelButton => '취소';
	@override String get howToCreate => 'GitHub Personal Access Token 생성 방법 →';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$ko extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get restart => '이 애플리케이션을 재시작하세요';
	@override String get autoAvailable => 'TaskMaster 기능이 자동으로 활성화됩니다';
	@override String get initCommand => '프로젝트 디렉토리에서 task-master init을 사용하세요';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$ko extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'Anthropic Claude AI 어시스턴트';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$ko extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'Cursor AI 기반 코드 에디터';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$ko extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenAI Codex AI 어시스턴트';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$ko extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenCode CLI 어시스턴트';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$ko extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'Command Code CLI 어시스턴트';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$ko extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'Antigravity CLI 어시스턴트';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$ko extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get description => 'Devin CLI 어시스턴트';
}

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$ko extends Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$codex$modes$kDefault$ko kDefault = Translations$settings$permissions$codex$modes$kDefault$ko._(_root);
	@override late final Translations$settings$permissions$codex$modes$acceptEdits$ko acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$ko._(_root);
	@override late final Translations$settings$permissions$codex$modes$bypassPermissions$ko bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$ko._(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$ko extends Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted. 신뢰할 수 있는 명령어: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find(-exec 제외) 등.';
	@override String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never. 프로젝트 디렉토리 내에서 모든 명령어 자동 실행.';
	@override String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never. 전체 시스템 접근, 신뢰할 수 있는 환경에서만 사용하세요.';
	@override String get overrideNote => '채팅 인터페이스의 모드 버튼을 사용하여 세션별로 재정의할 수 있습니다.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$ko extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$ko kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$ko._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$ko acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$ko._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$ko bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$ko._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$ko plan = Translations$settings$permissions$permissionMode$modes$plan$ko._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$ko extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get manual => '수동';
	@override String get manualHint => '권장만 표시하고 계정을 자동 전환하지 않습니다.';
	@override String get ask => '전환 전 확인';
	@override String get askHint => '전환이 제안되고 승인을 기다립니다.';
	@override String get autoLowRisk => '저위험 작업 자동';
	@override String get autoLowRiskHint => '저위험으로 표시된 작업만 자동으로 이동할 수 있습니다.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$ko extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '제품 요구사항 문서(PRD) 작성';
	@override String get description => '프로젝트 아이디어를 정리하고 무엇을 만들고 싶은지 설명하는 PRD를 작성하세요.';
	@override String get addButton => 'PRD 추가';
	@override String get existingPRDs => '기존 PRD:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$ko extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'PRD로부터 작업 생성';
	@override String get description => 'PRD가 준비되면 AI 어시스턴트에게 이를 분석해달라고 요청하세요. TaskMaster가 구현 세부사항과 함께 관리하기 쉬운 작업으로 자동 분할합니다.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$ko extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '작업 분석 및 확장';
	@override String get description => 'AI 어시스턴트에게 작업의 복잡도를 분석하고, 더 쉽게 구현할 수 있도록 상세한 하위 작업으로 확장해달라고 요청하세요.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$ko extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '개발 시작';
	@override String get description => 'AI 어시스턴트에게 작업을 시작하고, 상태를 업데이트하고, 프로젝트가 진행됨에 따라 새 작업을 추가해달라고 요청하세요.';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$ko extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '알림';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$ko extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '작업 필요';
	@override String body({required Object toolName}) => '${toolName} 에 대한 결정을 기다리고 있습니다.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$ko extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '실행이 중지되었습니다';
	@override String body({required Object reason}) => '사유: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$ko extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '실행 실패';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$ko extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '에이전트 알림';
}

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$ko extends Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '기본';
	@override String get description => '신뢰할 수 있는 명령어(ls, cat, grep, git status 등)만 자동 실행됩니다. 다른 명령어는 건너뜁니다. 워크스페이스에 쓰기 가능.';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$ko extends Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '편집 허용';
	@override String get description => '워크스페이스 내에서 모든 명령어가 자동 실행됩니다. 샌드박스 내 완전 자동 모드.';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$ko extends Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '권한 우회';
	@override String get description => '제한 없는 전체 시스템 접근. 모든 명령어가 전체 디스크 및 네트워크 접근 권한으로 자동 실행됩니다. 주의해서 사용하세요.';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$ko extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '기본';
	@override String get description => '권한이 필요한 작업은 채팅에서 승인을 위해 표시됩니다.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$ko extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '편집 허용';
	@override String get description => '파일 편집은 자동 승인됩니다. 다른 작업은 계속 승인을 요청합니다.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$ko extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '권한 우회';
	@override String get description => '모든 작업이 자동 승인됩니다 — 확인 없는 전체 접근. 주의해서 사용하세요.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$ko extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$ko._(TranslationsKo root) : this._root = root, super.internal(root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '계획';
	@override String get description => '계획 모드: 에이전트가 명령을 실행하지 않고 탐색하고 계획합니다.';
}

/// The flat map containing all translations for locale <ko>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsKo {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => '세션이 만료되었습니다. 다시 로그인하세요.',
			'auth.login.title' => '다시 오신 것을 환영합니다',
			'auth.login.description' => 'ddagent 계정에 로그인하세요',
			'auth.login.username' => '사용자명',
			'auth.login.password' => '비밀번호',
			'auth.login.submit' => '로그인',
			'auth.login.loading' => '로그인 중...',
			'auth.login.errors.invalidCredentials' => '사용자명 또는 비밀번호가 잘못되었습니다',
			'auth.login.errors.requiredFields' => '모든 항목을 입력해주세요',
			'auth.login.errors.networkError' => '네트워크 오류. 다시 시도해주세요.',
			'auth.login.placeholders.username' => '사용자명을 입력하세요',
			'auth.login.placeholders.password' => '비밀번호를 입력하세요',
			'auth.register.title' => '계정 생성',
			'auth.register.username' => '사용자명',
			'auth.register.password' => '비밀번호',
			'auth.register.confirmPassword' => '비밀번호 확인',
			'auth.register.submit' => '계정 생성',
			'auth.register.loading' => '계정 생성 중...',
			'auth.register.errors.passwordMismatch' => '비밀번호가 일치하지 않습니다',
			'auth.register.errors.usernameTaken' => '이미 사용 중인 사용자명입니다',
			'auth.register.errors.weakPassword' => '비밀번호가 너무 약합니다',
			'auth.register.errors.usernameTooShort' => '사용자 이름은 3자 이상이어야 합니다',
			'auth.register.errors.passwordTooShort' => '비밀번호는 6자 이상이어야 합니다',
			'auth.logout.title' => '로그아웃',
			'auth.logout.confirm' => '정말 로그아웃하시겠습니까?',
			'auth.logout.button' => '로그아웃',
			'chat.codeBlock.copy' => '복사',
			'chat.codeBlock.copied' => '복사됨',
			'chat.codeBlock.copyCode' => '코드 복사',
			'chat.copyMessage.copy' => '메시지 복사',
			'chat.copyMessage.copied' => '메시지 복사됨',
			'chat.copyMessage.failed' => '복사하지 못했습니다',
			'chat.copyMessage.selectFormat' => '복사 형식 선택',
			'chat.copyMessage.copyAsMarkdown' => '마크다운으로 복사',
			'chat.copyMessage.copyAsText' => '텍스트로 복사',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => '오류',
			'chat.messageTypes.tool' => '도구',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.tools.settings' => '도구 설정',
			'chat.tools.error' => '도구 오류',
			'chat.tools.result' => '도구 결과',
			'chat.tools.viewParams' => '입력 파라미터 보기',
			'chat.tools.viewRawParams' => 'Raw 파라미터 보기',
			'chat.tools.viewDiff' => '편집 Diff 보기:',
			'chat.tools.creatingFile' => '새 파일 생성:',
			'chat.tools.updatingTodo' => 'Todo 리스트 업데이트',
			'chat.tools.read' => '읽기',
			'chat.tools.readFile' => '파일 읽기',
			'chat.tools.updateTodo' => 'Todo 리스트 업데이트',
			'chat.tools.readTodo' => 'Todo 리스트 읽기',
			'chat.tools.searchResults' => '결과',
			'chat.search.found' => ({required Object count, required Object type}) => '${count}개의 ${type} 발견',
			'chat.search.file' => '파일',
			'chat.search.files' => '파일',
			'chat.search.pattern' => '패턴:',
			'chat.search.kIn' => '위치:',
			'chat.fileOperations.updated' => '파일이 업데이트되었습니다',
			'chat.fileOperations.created' => '파일이 생성되었습니다',
			'chat.fileOperations.written' => '파일이 작성되었습니다',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => '새 파일',
			'chat.fileOperations.viewContent' => '파일 내용 보기',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => '전체 출력 보기 (${count}자)',
			'chat.fileOperations.contentDisplayed' => '파일 내용이 위의 Diff 보기에 표시됩니다',
			'chat.interactive.title' => '대화형 프롬프트',
			'chat.interactive.waiting' => 'CLI에서 응답을 기다리는 중',
			'chat.interactive.instruction' => 'Claude가 실행 중인 터미널에서 옵션을 선택해주세요.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude가 옵션 ${number}을(를) 선택했습니다',
			'chat.interactive.instructionDetail' => 'CLI에서 화살표 키 또는 숫자를 입력하여 이 옵션을 대화형으로 선택합니다.',
			'chat.thinking.title' => '생각 중...',
			'chat.thinking.emoji' => '💭 생각 중...',
			'chat.json.response' => 'JSON 응답',
			'chat.permissions.grant' => ({required Object tool}) => '${tool}에 대한 권한 부여',
			'chat.permissions.added' => '권한이 추가되었습니다',
			'chat.permissions.addTo' => ({required Object entry}) => '${entry}을(를) 허용된 도구에 추가합니다.',
			'chat.permissions.retry' => '권한이 저장되었습니다. 도구를 사용하려면 요청을 재시도하세요.',
			'chat.permissions.error' => '권한을 업데이트할 수 없습니다. 다시 시도해주세요.',
			'chat.permissions.openSettings' => '설정 열기',
			'chat.todo.updated' => 'Todo 리스트가 업데이트되었습니다',
			'chat.todo.current' => '현재 Todo 리스트',
			'chat.plan.viewPlan' => '📋 구현 계획 보기',
			'chat.plan.title' => '구현 계획',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claude 사용량 한도에 도달했습니다. 한도는 **${time} ${timezone}** - ${date}에 초기화됩니다',
			'chat.codex.permissionMode' => '권한 모드',
			'chat.codex.modes.kDefault' => '기본 모드',
			'chat.codex.modes.auto' => '자동 모드',
			'chat.codex.modes.acceptEdits' => '편집 허용',
			'chat.codex.modes.bypassPermissions' => '권한 우회',
			'chat.codex.modes.plan' => 'Plan 모드',
			'chat.codex.descriptions.kDefault' => '신뢰할 수 있는 명령어(ls, cat, grep, git status 등)만 자동 실행됩니다. 다른 명령어는 건너뜁니다. 워크스페이스에 쓰기 가능.',
			'chat.codex.descriptions.auto' => '모델 분류기가 도구 호출마다 승인 또는 거부를 결정합니다. 높은 자율성.',
			'chat.codex.descriptions.acceptEdits' => '워크스페이스 내에서 모든 명령어가 자동 실행됩니다. 샌드박스 내 완전 자동 모드.',
			'chat.codex.descriptions.bypassPermissions' => '제한 없는 전체 시스템 접근. 모든 명령어가 전체 디스크 및 네트워크 접근 권한으로 자동 실행됩니다. 주의해서 사용하세요.',
			'chat.codex.descriptions.plan' => '계획 모드 - 명령어가 실행되지 않습니다',
			'chat.codex.technicalDetails' => '기술 상세',
			'chat.input.placeholder' => ({required Object provider}) => '/를 입력하여 명령어, @를 입력하여 파일, 또는 ${provider}에게 무엇이든 물어보세요...',
			'chat.input.placeholderDefault' => '메시지를 입력하세요...',
			'chat.input.disabled' => '입력 비활성화',
			'chat.input.attachFiles' => '파일 첨부',
			'chat.input.attachImages' => '이미지 첨부',
			'chat.input.send' => '전송',
			'chat.input.stop' => '중지',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter로 전송 • / 명령어 • @ 파일',
			'chat.input.hintText.enter' => 'Enter로 전송 • Shift+Enter 줄바꿈 • / 명령어 • @ 파일',
			'chat.input.hintText.queue' => 'Enter로 다음 메시지 대기열에 추가',
			'chat.input.hintText.updateQueued' => 'Enter로 대기 중인 메시지 업데이트',
			'chat.input.clickToChangeMode' => '클릭하여 권한 모드 변경',
			'chat.input.showAllCommands' => '모든 명령어 보기',
			'chat.input.clearInput' => '입력 지우기',
			'chat.input.scrollToBottom' => '맨 아래로 스크롤',
			'chat.input.queue.sendNext' => '다음 메시지 대기열에 추가',
			'chat.input.queue.update' => '대기 중인 메시지 업데이트',
			'chat.input.queue.label' => '대기 중',
			'chat.input.queue.willSend' => '완료되면 전송됩니다',
			'chat.input.queue.edit' => '대기 중인 메시지 편집',
			'chat.input.queue.delete' => '대기 중인 메시지 삭제',
			'chat.input.queue.failed' => '전송 실패',
			'chat.input.queue.sendNow' => '지금 보내기',
			'chat.input.attachFilesDesc' => '사진, 파일 또는 문서 업로드',
			'chat.input.takePhoto' => '사진 촬영',
			'chat.input.takePhotoDesc' => '카메라로 사진 촬영',
			'chat.input.moreTools' => '더 많은 도구',
			'chat.input.commandsDesc' => '단축키와 명령 탐색',
			'chat.input.clearInputDesc' => '현재 텍스트 버리기',
			'chat.input.newMessage' => '새 메시지',
			'chat.input.newMessages' => '새 메시지들',
			'chat.input.autoContinueTasks' => '자동 계속',
			'chat.input.autoContinueTasksTooltip' => 'Devin이 다음 Task Master 작업으로 자동 진행하도록 활성화',
			'chat.input.offlineQueue.clear' => '취소하고 오프라인 큐 비우기',
			'chat.input.offlineQueue.clearBtn' => '취소',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count}개 메시지가 오프라인 큐에 있음 — 재연결 시 자동 전송됩니다',
			'chat.input.offlineQueue.single' => '1개 메시지가 오프라인 큐에 있음 — 재연결 시 자동 전송됩니다',
			'chat.providerSelection.title' => 'AI 어시스턴트 선택',
			'chat.providerSelection.description' => '새 대화를 시작할 프로바이더를 선택하세요',
			'chat.providerSelection.selectModel' => '모델 선택',
			'chat.providerSelection.providerInfo.anthropic' => 'Anthropic 제공',
			'chat.providerSelection.providerInfo.openai' => 'OpenAI 제공',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI 코드 에디터',
			'chat.providerSelection.providerInfo.google' => 'Google 제공',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => '${model} 모델로 Claude를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => '${model} 모델로 Cursor를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => '${model} 모델로 Codex를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => '${model} 모델로 OpenCode를 사용할 준비가 되었습니다. 아래에 메시지를 입력하세요.',
			'chat.providerSelection.readyPrompt.kDefault' => '시작하려면 위에서 제공자를 선택하세요',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Devin ${model} 준비 완료',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => '<kbd>${shortcut}</kbd>를 눌러 세션, 파일 및 커밋을 검색하세요',
			'chat.providerSelection.workspace' => '작업 영역',
			'chat.providerSelection.noWorkspace' => '없음',
			'chat.providerSelection.clickToChangeWorkspace' => '클릭하여 작업 영역 변경',
			'chat.providerSelection.chooseWorkspace' => '작업 영역 선택',
			'chat.providerSelection.searchWorkspaces' => '작업 영역 검색...',
			'chat.providerSelection.noWorkspacesFound' => '작업 영역을 찾을 수 없습니다.',
			'chat.providerSelection.all' => '전체',
			'chat.providerSelection.free' => '무료',
			'chat.providerSelection.noModelsFound' => '모델을 찾을 수 없습니다.',
			'chat.providerSelection.paid' => '유료',
			'chat.providerSelection.searchModels' => '모델 검색...',
			'chat.providerSelection.addModel' => '모델 추가',
			'chat.providerSelection.chooseModel' => '모델 선택',
			'chat.providerSelection.chooseModelDescription' => '기본 및 사용자 정의 모델을 하나의 목록에',
			'chat.providerSelection.clickToChange' => '클릭하여 모델 변경',
			'chat.providerSelection.favorites' => '즐겨찾기',
			'chat.providerSelection.loadingModels' => '모델 로드 중…',
			'chat.providerSelection.manageModels' => '모델 관리',
			'chat.providerSelection.refresh' => '모델 새로고침',
			'chat.session.kContinue.title' => '대화 계속하기',
			'chat.session.kContinue.description' => '코드에 대해 질문하거나, 변경을 요청하거나, 개발 작업에 도움을 받으세요',
			'chat.session.kContinue.action' => '계속 입력',
			'chat.session.loading.olderMessages' => '이전 메시지 로딩 중...',
			'chat.session.loading.sessionMessages' => '세션 메시지 로딩 중...',
			'chat.session.messages.showingOf' => ({required Object total, required Object shown}) => '${total}개 중 ${shown}개 표시',
			'chat.session.messages.scrollToLoad' => '위로 스크롤하여 더 로드',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => '마지막 ${count}개 메시지 표시 (총 ${total}개)',
			'chat.session.messages.loadEarlier' => '이전 메시지 로드',
			'chat.session.messages.loadAll' => '모든 메시지 로드',
			'chat.session.messages.loadingAll' => '모든 메시지 로딩 중...',
			'chat.session.messages.allLoaded' => '모든 메시지 로드 완료',
			'chat.session.messages.perfWarning' => '모든 메시지가 로드됨 - 스크롤이 느려질 수 있습니다. "맨 아래로 스크롤"을 클릭하면 성능이 복구됩니다.',
			'chat.session.messages.loadOlderFailed' => '이전 메시지를 불러오지 못했습니다.',
			'chat.session.messages.retry' => '다시 시도',
			'chat.session.messages.noSearchMatches' => '검색과 일치하는 메시지가 없습니다.',
			'chat.shell.selectProject.title' => '프로젝트 선택',
			'chat.shell.selectProject.description' => '해당 디렉토리에서 대화형 Shell을 열 프로젝트를 선택하세요',
			'chat.shell.status.newSession' => '새 세션',
			'chat.shell.status.initializing' => '초기화 중...',
			'chat.shell.status.restarting' => '재시작 중...',
			'chat.shell.actions.disconnect' => '연결 끊기',
			'chat.shell.actions.disconnectTitle' => 'Shell 연결 끊기',
			'chat.shell.actions.restart' => '재시작',
			'chat.shell.actions.restartTitle' => 'Shell 재시작 (먼저 연결 끊기)',
			'chat.shell.actions.connect' => 'Shell에서 계속',
			'chat.shell.actions.connectTitle' => 'Shell에 연결',
			'chat.shell.actions.kill' => '종료 (SIGINT)',
			'chat.shell.actions.killTitle' => '실행 중인 프로세스 종료 (Ctrl+C)',
			'chat.shell.actions.copyOutput' => '출력 복사',
			'chat.shell.actions.copyOutputTitle' => '터미널 출력 복사',
			'chat.shell.actions.copied' => '복사됨!',
			'chat.shell.actions.zoomInTitle' => '확대',
			'chat.shell.actions.zoomOutTitle' => '축소',
			'chat.shell.loading' => '터미널 로딩 중...',
			'chat.shell.connecting' => 'Shell에 연결 중...',
			'chat.shell.startSession' => '새 Claude 세션 시작',
			'chat.shell.resumeSession' => ({required Object displayName}) => '세션 재개: ${displayName}...',
			'chat.shell.runCommand' => ({required Object projectName, required Object command}) => '${projectName}에서 ${command} 실행',
			'chat.shell.startCli' => ({required Object projectName}) => '${projectName}에서 Claude CLI 시작',
			'chat.shell.defaultCommand' => '명령어',
			'chat.claudeStatus.actions.thinking' => '생각 중',
			'chat.claudeStatus.actions.processing' => '처리 중',
			'chat.claudeStatus.actions.analyzing' => '분석 중',
			'chat.claudeStatus.actions.working' => '작업 중',
			'chat.claudeStatus.actions.computing' => '계산 중',
			'chat.claudeStatus.actions.reasoning' => '추론 중',
			'chat.claudeStatus.state.live' => '실시간',
			'chat.claudeStatus.state.paused' => '일시 중지',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}초',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} 경과',
			'chat.claudeStatus.elapsed.startingNow' => '지금 시작',
			'chat.claudeStatus.stop' => '중지',
			'chat.claudeStatus.controls.stopGeneration' => '생성 중지',
			'chat.claudeStatus.controls.pressEscToStop' => 'Esc를 눌러 언제든 중지',
			'chat.claudeStatus.providers.assistant' => '어시스턴트',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => '${provider}와 채팅을 시작하려면 프로젝트를 선택하세요',
			'chat.tasks.nextTaskPrompt' => '다음 작업 시작',
			'chat.voice.autoRead' => '답변 소리 내어 읽기',
			'chat.voice.autoReadOn' => '답변 읽기: 켬',
			'chat.voice.autoReadOff' => '답변 읽기: 끔',
			'chat.voice.autoReadVoice' => '읽기 음성',
			'chat.voice.autoReadVoiceAuto' => '자동 음성',
			'chat.voice.autoReadPreview' => '답변이 이렇게 들립니다.',
			'chat.voice.speakMessage' => '소리 내어 읽기',
			'chat.voice.stopSpeaking' => '읽기 중지',
			'chat.composer.toolsAndActions' => '도구 및 작업',
			'chat.composer.toolsAndActionsDesc' => '채팅 입력창의 도구와 컨트롤',
			'chat.composer.reasoning' => '추론',
			'chat.composer.model' => '모델',
			'chat.composer.effortDefault' => '기본값',
			'chat.composer.loadingModels' => '모델 로드 중…',
			'chat.composer.modelMenu' => '모델 및 추론 수준 선택',
			'chat.composer.permissionHeading' => ({required Object provider}) => '${provider} 작업을 어떻게 승인할까요?',
			'chat.composer.favorites' => '즐겨찾기',
			'chat.splitSession.toggle' => '세션 분할',
			'chat.splitSession.close' => '분할 세션 닫기',
			'chat.splitSession.selectSession' => '비교할 세션 선택',
			'chat.splitSession.noOtherSessions' => '다른 세션이 없습니다',
			'chat.splitSession.newSessionOption' => '+ 분할 보기에서 새 세션',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => '현재 프로젝트 (${name})',
			'chat.splitSession.otherProjectsGroup' => '다른 프로젝트',
			'chat.splitSession.recentSessionsGroup' => '최근 세션',
			'chat.splitSession.startNewSession' => '분할 보기에서 새 세션 시작',
			'chat.splitSession.selectFromList' => '기존 세션 목록에서 세션 선택',
			'chat.sessionPicker.title' => '세션 선택',
			'chat.sessionPicker.searchPlaceholder' => '세션 검색...',
			'chat.sessionPicker.clearSearch' => '검색 지우기',
			'chat.sessionPicker.newChat' => '+ 새 채팅',
			'chat.sessionPicker.archivedToggle' => '보관됨',
			'chat.sessionPicker.changeSession' => '세션 변경',
			'chat.sessionPicker.archivedLoading' => '보관된 세션 로드 중...',
			'chat.sessionPicker.archivedError' => '보관된 세션을 불러올 수 없습니다',
			'chat.sessionPicker.archivedEmpty' => '보관된 세션 없음',
			'chat.sessionPicker.archivedProjectOnly' => '작업 영역이 보관됨 — 세션을 보려면 복원하세요.',
			'chat.sessionPicker.emptySearch' => '검색과 일치하는 세션이 없습니다',
			'chat.sessionPicker.restore' => '복원',
			'chat.sessionPicker.restoreSession' => '세션 복원',
			'chat.sessionPicker.restoreProject' => '작업 영역 복원',
			'chat.sessionPicker.restoreSessionFailed' => '세션 복원에 실패했습니다. 다시 시도하세요.',
			'chat.sessionPicker.restoreProjectFailed' => '작업 영역 복원에 실패했습니다. 다시 시도하세요.',
			'chat.sessionPicker.archiveFailed' => '세션 보관에 실패했습니다. 다시 시도하세요.',
			'chat.sessionPicker.deleteFailed' => '세션 삭제에 실패했습니다. 다시 시도하세요.',
			'chat.sessionPicker.running' => '세션 실행 중',
			'chat.sessionPicker.unread' => '읽지 않음 — 새 출력과 함께 완료됨',
			'chat.splitWorkspace.addChat' => '채팅 창 추가',
			'chat.splitWorkspace.addBrowser' => '브라우저 창 추가',
			'chat.splitWorkspace.addTerminal' => '터미널 창 추가',
			'chat.splitWorkspace.overview' => '모든 창 표시',
			'chat.splitWorkspace.exitFocusMode' => '포커스 모드 종료 (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => '포커스 모드 (Ctrl+Shift+F)',
			'chat.splitWorkspace.browseSessions' => '세션 목록 열기',
			'chat.splitOverview.title' => '분할 창 개요',
			'chat.splitOverview.count' => ({required Object count}) => '${count}개 창',
			'chat.splitOverview.close' => '개요 닫기',
			'chat.splitOverview.question' => '질문 — 입력 필요',
			'chat.splitOverview.processing' => '처리 중',
			'chat.splitOverview.idle' => '유휴',
			'chat.splitOverview.active' => '활성',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider}이(가) 입력을 기다립니다',
			'chat.attachments.downloadFailedRetry' => '다운로드 실패 — 클릭하여 다시 시도',
			'chat.attachments.fileAttachment' => '파일 첨부',
			'chat.checkpoint.creating' => '스냅샷 생성 중…',
			'chat.checkpoint.revertChanges' => '파일을 마지막 체크포인트로 되돌리기',
			'chat.checkpoint.undo' => '체크포인트 실행 취소',
			'chat.common.close' => '닫기',
			'chat.taskMaster.saveToTask' => '작업',
			'chat.taskMaster.saved' => '저장됨',
			'chat.taskMaster.saving' => '저장 중...',
			'chat.taskMaster.taskShort' => '작업',
			'chat.tokenUsage.desc' => '세션 토큰 사용량 보기',
			'chat.tokenUsage.title' => '토큰 사용량',
			'chat.tool.emptyResult' => '(아직 출력 없음 — 도구가 빈 결과를 반환했습니다)',
			'chat.quotaBadge.ariaLabel' => '구독 한도',
			'chat.quotaBadge.noData' => '이 모델에 대한 구독 데이터가 없습니다',
			'chat.paneHeader.processing' => '처리 중…',
			'chat.paneHeader.switchSession' => '세션 전환',
			'chat.broadcast.selectOrchestrators' => '오케스트레이터 선택',
			'chat.broadcast.orchestratorsOnly' => '오케스트레이터만',
			'chat.broadcast.noOrchestrators' => '사용 가능한 오케스트레이터 세션이 없습니다',
			'codeEditor.toolbar.changes' => '변경사항',
			'codeEditor.toolbar.previousChange' => '이전 변경',
			'codeEditor.toolbar.nextChange' => '다음 변경',
			'codeEditor.toolbar.hideDiff' => 'Diff 하이라이트 숨기기',
			'codeEditor.toolbar.showDiff' => 'Diff 하이라이트 표시',
			'codeEditor.toolbar.settings' => '에디터 설정',
			'codeEditor.toolbar.collapse' => '에디터 접기',
			'codeEditor.toolbar.expand' => '에디터 전체 너비로 펼치기',
			'codeEditor.loading' => ({required Object fileName}) => '${fileName} 로딩 중...',
			'codeEditor.header.showingChanges' => '변경사항 표시',
			'codeEditor.actions.copyPath' => '파일 경로 복사',
			'codeEditor.actions.pathCopied' => '파일 경로를 복사했습니다',
			'codeEditor.actions.download' => '파일 다운로드',
			'codeEditor.actions.save' => '저장',
			'codeEditor.actions.saving' => '저장 중...',
			'codeEditor.actions.saved' => '저장됨!',
			'codeEditor.actions.exitFullscreen' => '전체화면 종료',
			'codeEditor.actions.fullscreen' => '전체화면',
			'codeEditor.actions.close' => '닫기',
			'codeEditor.actions.previewMarkdown' => '마크다운 미리보기',
			'codeEditor.actions.editMarkdown' => '마크다운 편집',
			'codeEditor.actions.pinFile' => '파일을 컨텍스트에 고정',
			'codeEditor.actions.unpinFile' => '파일을 컨텍스트에서 해제',
			'codeEditor.actions.previewHtml' => '새 탭에서 HTML 미리보기 열기',
			'codeEditor.actions.retry' => '다시 시도',
			'codeEditor.footer.lines' => '줄:',
			'codeEditor.footer.characters' => '문자:',
			'codeEditor.footer.shortcuts' => 'Ctrl+S로 저장 • Esc로 닫기',
			'codeEditor.binaryFile.title' => '바이너리 파일',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => '파일 "${fileName}"은(는) 바이너리 파일이므로 텍스트 편집기에서 표시할 수 없습니다.',
			'codeEditor.filePreview.loading' => '미리보기 로딩 중...',
			'codeEditor.filePreview.error' => '이 파일을 표시할 수 없습니다.',
			'codeEditor.filePreview.openInNewTab' => '새 탭에서 열기',
			'common.buttons.save' => '저장',
			'common.buttons.cancel' => '취소',
			'common.buttons.delete' => '삭제',
			'common.buttons.create' => '생성',
			'common.buttons.edit' => '편집',
			'common.buttons.close' => '닫기',
			'common.buttons.confirm' => '확인',
			'common.buttons.submit' => '제출',
			'common.buttons.retry' => '재시도',
			'common.buttons.refresh' => '새로고침',
			'common.buttons.search' => '검색',
			'common.buttons.clear' => '지우기',
			'common.buttons.copy' => '복사',
			'common.buttons.download' => '다운로드',
			'common.buttons.upload' => '업로드',
			'common.buttons.browse' => '찾아보기',
			'common.tabs.chat' => '채팅',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => '파일',
			'common.tabs.git' => '소스 관리',
			'common.tabs.tasks' => '작업',
			'common.tabs.browser' => '브라우저',
			'common.tabs.computer' => '컴퓨터',
			'common.tabs.board' => '보드',
			'common.tabs.usage' => 'AI Control',
			'common.status.loading' => '로딩 중...',
			'common.status.success' => '성공',
			'common.status.error' => '오류',
			'common.status.failed' => '실패',
			'common.status.pending' => '대기 중',
			'common.status.completed' => '완료',
			'common.status.inProgress' => '진행 중',
			'common.messages.savedSuccessfully' => '저장되었습니다',
			'common.messages.deletedSuccessfully' => '삭제되었습니다',
			'common.messages.updatedSuccessfully' => '업데이트되었습니다',
			'common.messages.operationFailed' => '작업 실패',
			'common.messages.networkError' => '네트워크 오류. 연결을 확인해주세요.',
			'common.messages.unauthorized' => '인증되지 않았습니다. 로그인해주세요.',
			'common.messages.notFound' => '찾을 수 없음',
			'common.messages.invalidInput' => '잘못된 입력',
			'common.messages.requiredField' => '필수 항목입니다',
			'common.messages.unknownError' => '알 수 없는 오류가 발생했습니다',
			'common.messages.renameSessionFailed' => '세션 이름 변경에 실패했습니다. 다시 시도하세요.',
			'common.navigation.settings' => '설정',
			'common.navigation.home' => '홈',
			'common.navigation.back' => '뒤로',
			'common.navigation.next' => '다음',
			'common.navigation.previous' => '이전',
			'common.navigation.logout' => '로그아웃',
			'common.common.language' => '언어',
			'common.common.theme' => '테마',
			'common.common.darkMode' => '다크 모드',
			'common.common.lightMode' => '라이트 모드',
			'common.common.name' => '이름',
			'common.common.description' => '설명',
			'common.common.enabled' => '활성화',
			'common.common.disabled' => '비활성화',
			'common.common.optional' => '선택사항',
			'common.common.version' => '버전',
			'common.common.select' => '선택',
			'common.common.selectAll' => '전체 선택',
			'common.common.deselectAll' => '전체 해제',
			'common.common.done' => '완료',
			'common.common.failed' => '실패',
			'common.time.justNow' => '방금 전',
			'common.time.minutesAgo' => ({required Object count}) => '${count}분 전',
			'common.time.hoursAgo' => ({required Object count}) => '${count}시간 전',
			'common.time.daysAgo' => ({required Object count}) => '${count}일 전',
			'common.time.yesterday' => '어제',
			'common.fileOperations.newFile' => '새 파일',
			'common.fileOperations.newFolder' => '새 폴더',
			'common.fileOperations.rename' => '이름 변경',
			'common.fileOperations.move' => '이동',
			'common.fileOperations.copyPath' => '경로 복사',
			'common.fileOperations.openInEditor' => '에디터에서 열기',
			'common.mainContent.loading' => 'ddagent 로딩 중',
			'common.mainContent.settingUpWorkspace' => '워크스페이스 설정 중...',
			'common.mainContent.chooseProject' => '프로젝트 선택',
			'common.mainContent.selectProjectDescription' => '사이드바에서 프로젝트를 선택하여 Claude와 코딩을 시작하세요. 각 프로젝트에는 채팅 세션과 파일 히스토리가 포함됩니다.',
			'common.mainContent.tip' => '팁',
			'common.mainContent.createProjectMobile' => '위의 메뉴 버튼을 눌러 프로젝트에 접근하세요',
			'common.mainContent.createProjectDesktop' => '사이드바의 폴더 아이콘을 클릭하여 새 프로젝트를 생성하세요',
			'common.mainContent.newSession' => '새 세션',
			'common.mainContent.untitledSession' => '제목 없는 세션',
			'common.mainContent.projectFiles' => '프로젝트 파일',
			'common.mainContent.focusMode' => '포커스 모드 (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => '포커스 모드 종료 (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => '세션 분할',
			'common.mainContent.closeSplitSession' => '분할 세션 닫기',
			'common.mainContent.chooseWorkspace' => '작업 영역 선택',
			'common.mainContent.chooseWorkspaceDescription' => '이 채팅의 작업 영역을 선택하거나 설정에서 새로 만드세요.',
			'common.mainContent.createWorkspace' => '설정에서 작업 영역 만들기',
			'common.mainContent.recentProjects' => '최근 프로젝트',
			'common.fileTree.loading' => '파일 로딩 중...',
			'common.fileTree.files' => '파일',
			'common.fileTree.simpleView' => '간단히 보기',
			'common.fileTree.compactView' => '컴팩트 보기',
			'common.fileTree.detailedView' => '상세히 보기',
			'common.fileTree.searchPlaceholder' => '파일 및 폴더 검색...',
			'common.fileTree.clearSearch' => '검색 지우기',
			'common.fileTree.name' => '이름',
			'common.fileTree.size' => '크기',
			'common.fileTree.modified' => '수정일',
			'common.fileTree.permissions' => '권한',
			'common.fileTree.noFilesFound' => '파일을 찾을 수 없음',
			'common.fileTree.checkProjectPath' => '프로젝트 경로가 접근 가능한지 확인하세요',
			'common.fileTree.noMatchesFound' => '일치하는 항목 없음',
			'common.fileTree.tryDifferentSearch' => '다른 검색어를 시도하거나 검색을 지우세요',
			'common.fileTree.justNow' => '방금 전',
			'common.fileTree.minAgo' => ({required Object count}) => '${count}분 전',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count}시간 전',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count}일 전',
			'common.fileTree.newFile' => '새 파일 (Cmd+N)',
			'common.fileTree.newFolder' => '새 폴더 (Cmd+Shift+N)',
			'common.fileTree.refresh' => '새로고침',
			'common.fileTree.collapseAll' => '모두 접기',
			'common.fileTree.context.rename' => '이름 변경',
			'common.fileTree.context.delete' => '삭제',
			'common.fileTree.context.copyPath' => '경로 복사',
			'common.fileTree.context.download' => '다운로드',
			'common.fileTree.context.newFile' => '새 파일',
			'common.fileTree.context.newFolder' => '새 폴더',
			'common.fileTree.context.upload' => '파일 업로드',
			'common.fileTree.context.refresh' => '새로 고침',
			'common.fileTree.context.menuLabel' => '파일 컨텍스트 메뉴',
			'common.fileTree.context.loading' => '로딩 중...',
			'common.fileTree.searchContentPlaceholder' => '파일 내 검색...',
			'common.fileTree.searchInFiles' => '파일 내 검색',
			'common.fileTree.searchByName' => '이름으로 검색',
			'common.fileTree.loadFailed' => '파일을 불러올 수 없습니다',
			'common.fileTree.noSearchResults' => '일치하는 항목 없음',
			'common.fileTree.searchError' => '검색 실패',
			'common.fileTree.searching' => '검색 중...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => '처음 ${count}개 결과 표시',
			'common.fileTree.allWorkspaces' => '모든 작업 영역',
			'common.fileTree.delete.confirm' => '삭제',
			'common.fileTree.delete.fileWarning' => '이 파일은 영구적으로 삭제됩니다.',
			'common.fileTree.delete.folderWarning' => '이 폴더와 모든 내용이 영구적으로 삭제됩니다.',
			'common.fileTree.delete.title' => ({required Object type}) => '${type} 삭제',
			'common.fileTree.dropToUpload' => '파일을 놓아 업로드',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => '파일을 놓아 "${folder}"에 업로드',
			'common.fileTree.noProject' => '먼저 프로젝트를 추가하세요',
			'common.fileTree.noRecentFiles' => '최근 7일간 변경된 파일이 없습니다',
			'common.fileTree.showAllFiles' => '모든 파일 표시',
			'common.fileTree.showAllFilesHint' => '최근 필터를 끄면 모든 파일을 볼 수 있습니다.',
			'common.fileTree.showRecentOnly' => '최근 7일간 변경된 파일 표시',
			'common.fileTree.toast.copyFailed' => '경로 복사 실패',
			'common.fileTree.toast.fileCreated' => '파일이 생성되었습니다',
			'common.fileTree.toast.fileDeleted' => '파일이 삭제되었습니다',
			'common.fileTree.toast.folderCreated' => '폴더가 생성되었습니다',
			'common.fileTree.toast.folderDeleted' => '폴더가 삭제되었습니다',
			'common.fileTree.toast.folderDownloaded' => '폴더가 ZIP으로 다운로드되었습니다',
			'common.fileTree.toast.pathCopied' => '경로가 클립보드에 복사되었습니다',
			'common.fileTree.toast.renamed' => '이름이 변경되었습니다',
			'common.fileTree.uploadComplete' => '업로드 완료',
			'common.fileTree.uploadFailed' => '업로드 실패',
			'common.fileTree.uploadFiles' => ({required Object size}) => '파일 업로드 (각 최대 ${size})',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => '"${folder}"에 파일 업로드',
			'common.fileTree.uploadedCount' => ({required Object total, required Object label, required Object uploaded}) => '${total} ${label} 중 ${uploaded}개 업로드됨',
			'common.fileTree.uploadingFiles' => '파일 업로드 중',
			'common.fileTree.validation.dotsOnly' => '파일 이름은 점만으로 구성될 수 없습니다',
			'common.fileTree.validation.emptyName' => '파일 이름은 비워 둘 수 없습니다',
			'common.fileTree.validation.invalidChars' => '파일 이름에 잘못된 문자가 포함되어 있습니다',
			'common.fileTree.validation.reserved' => '파일 이름이 예약어입니다',
			'common.projectWizard.title' => '새 프로젝트 생성',
			'common.projectWizard.steps.type' => '유형',
			_ => null,
		} ?? switch (path) {
			'common.projectWizard.steps.configure' => '설정',
			'common.projectWizard.steps.confirm' => '확인',
			'common.projectWizard.step1.question' => '이미 워크스페이스가 있으신가요, 아니면 새로 생성하시겠습니까?',
			'common.projectWizard.step1.existing.title' => '기존 워크스페이스',
			'common.projectWizard.step1.existing.description' => '서버에 이미 워크스페이스가 있고 프로젝트 목록에 추가만 하면 됩니다',
			'common.projectWizard.step1.kNew.title' => '새 워크스페이스',
			'common.projectWizard.step1.kNew.description' => '새 워크스페이스를 생성하고, 선택적으로 GitHub 저장소에서 clone합니다',
			'common.projectWizard.step2.existingPath' => '워크스페이스 경로',
			'common.projectWizard.step2.newPath' => '워크스페이스 경로',
			'common.projectWizard.step2.existingPlaceholder' => '/path/to/existing/workspace',
			'common.projectWizard.step2.newPlaceholder' => '/path/to/new/workspace',
			'common.projectWizard.step2.existingHelp' => '기존 워크스페이스 디렉토리의 전체 경로',
			'common.projectWizard.step2.newHelp' => '워크스페이스 디렉토리의 전체 경로',
			'common.projectWizard.step2.githubUrl' => 'GitHub URL (선택사항)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => '선택사항: 저장소를 clone하려면 GitHub URL을 입력하세요',
			'common.projectWizard.step2.githubAuth' => 'GitHub 인증 (선택사항)',
			'common.projectWizard.step2.githubAuthHelp' => '비공개 저장소에만 필요합니다. 공개 저장소는 인증 없이 clone할 수 있습니다.',
			'common.projectWizard.step2.loadingTokens' => '저장된 토큰 로딩 중...',
			'common.projectWizard.step2.storedToken' => '저장된 토큰',
			'common.projectWizard.step2.newToken' => '새 토큰',
			'common.projectWizard.step2.nonePublic' => '없음 (공개)',
			'common.projectWizard.step2.selectToken' => '토큰 선택',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- 토큰 선택 --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => '이 토큰은 이 작업에만 사용됩니다',
			'common.projectWizard.step2.publicRepoInfo' => '공개 저장소는 인증이 필요하지 않습니다. 공개 저장소를 clone하는 경우 토큰을 생략할 수 있습니다.',
			'common.projectWizard.step2.noTokensHelp' => '저장된 토큰이 없습니다. 설정 → API Keys에서 토큰을 추가하면 재사용이 편리합니다.',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHub 토큰 (공개 저장소는 선택사항)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (공개 저장소는 비워두세요)',
			'common.projectWizard.step3.reviewConfig' => '설정 검토',
			'common.projectWizard.step3.existingWorkspace' => '기존 워크스페이스',
			'common.projectWizard.step3.newWorkspace' => '새 워크스페이스',
			'common.projectWizard.step3.path' => '경로:',
			'common.projectWizard.step3.cloneFrom' => 'Clone 소스:',
			'common.projectWizard.step3.authentication' => '인증:',
			'common.projectWizard.step3.usingStoredToken' => '저장된 토큰 사용:',
			'common.projectWizard.step3.usingProvidedToken' => '제공된 토큰 사용',
			'common.projectWizard.step3.noAuthentication' => '인증 없음',
			'common.projectWizard.step3.sshKey' => 'SSH 키',
			'common.projectWizard.step3.existingInfo' => '워크스페이스가 프로젝트 목록에 추가되며 Claude/Cursor 세션에서 사용할 수 있습니다.',
			'common.projectWizard.step3.newWithClone' => '이 폴더에 저장소가 clone됩니다.',
			'common.projectWizard.step3.newEmpty' => '워크스페이스가 프로젝트 목록에 추가되며 Claude/Cursor 세션에서 사용할 수 있습니다.',
			'common.projectWizard.step3.cloningRepository' => '저장소 clone 중...',
			'common.projectWizard.buttons.cancel' => '취소',
			'common.projectWizard.buttons.back' => '뒤로',
			'common.projectWizard.buttons.next' => '다음',
			'common.projectWizard.buttons.createProject' => '프로젝트 생성',
			'common.projectWizard.buttons.creating' => '생성 중...',
			'common.projectWizard.buttons.cloning' => 'Clone 중...',
			'common.projectWizard.errors.selectType' => '기존 워크스페이스를 사용할지 새로 생성할지 선택해주세요',
			'common.projectWizard.errors.providePath' => '워크스페이스 경로를 입력해주세요',
			'common.projectWizard.errors.failedToCreate' => '워크스페이스 생성 실패',
			'common.projectWizard.errors.failedToCreateFolder' => '폴더 생성 실패',
			'common.notifications.genericTool' => '도구',
			'common.notifications.codes.generic.info.title' => '알림',
			'common.notifications.codes.permission.required.title' => '작업 필요',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} 에 대한 결정을 기다리고 있습니다.',
			'common.notifications.codes.run.stopped.title' => '실행이 중지되었습니다',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => '사유: ${reason}',
			'common.notifications.codes.run.failed.title' => '실행 실패',
			'common.notifications.codes.agent.notification.title' => '에이전트 알림',
			'common.versionUpdate.title' => '업데이트 가능',
			'common.versionUpdate.newVersionReady' => '새 버전이 준비되었습니다',
			'common.versionUpdate.currentVersion' => '현재 버전',
			'common.versionUpdate.latestVersion' => '최신 버전',
			'common.versionUpdate.whatsNew' => '새로운 기능:',
			'common.versionUpdate.viewFullRelease' => '전체 릴리스 보기',
			'common.versionUpdate.updateProgress' => '업데이트 진행 상황:',
			'common.versionUpdate.manualUpgrade' => '수동 업그레이드:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => '또는 "지금 업데이트"를 클릭하여 자동으로 업데이트합니다.',
			'common.versionUpdate.updateCompleted' => '업데이트가 완료되었습니다!',
			'common.versionUpdate.restartServer' => '변경사항을 적용하려면 서버를 재시작하세요.',
			'common.versionUpdate.updateFailed' => '업데이트 실패',
			'common.versionUpdate.buttons.close' => '닫기',
			'common.versionUpdate.buttons.later' => '나중에',
			'common.versionUpdate.buttons.copyCommand' => '명령어 복사',
			'common.versionUpdate.buttons.updateNow' => '지금 업데이트',
			'common.versionUpdate.buttons.updating' => '업데이트 중...',
			'common.versionUpdate.ariaLabels.closeModal' => '버전 업그레이드 모달 닫기',
			'common.versionUpdate.ariaLabels.showSidebar' => '사이드바 표시',
			'common.versionUpdate.ariaLabels.settings' => '설정',
			'common.versionUpdate.ariaLabels.updateAvailable' => '업데이트 가능',
			'common.versionUpdate.ariaLabels.closeSidebar' => '사이드바 닫기',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => '개요',
			'common.quota.section.quotas' => '쿼터',
			'common.quota.section.usage' => '사용량',
			'common.quota.section.agents' => '에이전트',
			'common.quota.filter.all' => '전체',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7일',
			'common.quota.period.k30d' => '30일',
			'common.quota.period.all' => '전체',
			'common.quota.group.provider' => '제공자',
			'common.quota.group.model' => '모델',
			'common.quota.group.agent' => '에이전트',
			'common.quota.group.tool' => '도구',
			'common.quota.metric.tokens' => '토큰',
			'common.quota.metric.input' => '입력',
			'common.quota.metric.output' => '출력',
			'common.quota.metric.cache' => '캐시 읽기',
			'common.quota.metric.calls' => 'API 호출',
			'common.quota.metric.cost' => '비용',
			'common.quota.metric.sessions' => '세션',
			'common.quota.cost.billed' => '청구됨 (API + 초과분)',
			'common.quota.cost.listPrice' => '사용된 토큰의 정가',
			'common.quota.cost.subscriptionValue' => '구독으로 충당',
			'common.quota.cost.cacheSavings' => '캐시 절감',
			'common.quota.cost3.billed' => '청구됨 (API + 초과분)',
			'common.quota.cost3.listPrice' => '사용된 토큰의 정가',
			'common.quota.cost3.subscriptionValue' => '구독으로 충당',
			'common.quota.overview.trendTitle' => '토큰 및 비용 — 지난 7일',
			'common.quota.overview.effectiveCost' => '실질 비용 (7일)',
			'common.quota.overview.alertsTitle' => '알림',
			'common.quota.overview.noAlerts' => '지금 주의가 필요한 항목이 없습니다.',
			'common.quota.overview.limitsTitle' => '사용량 및 한도',
			'common.quota.overview.activeTasks' => '활성 작업',
			'common.quota.overview.viewAccounts' => '모든 계정',
			'common.quota.overview.viewAgents' => '모든 에이전트',
			'common.quota.overview.noTasks' => '지금 실행 중인 에이전트가 없습니다.',
			'common.quota.usage.trendTitle' => '일일 추세',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => '${group}별 분석',
			'common.quota.usage.colName' => '이름',
			'common.quota.usage.sourceUnavailable' => '분석 저장소를 사용할 수 없습니다. 데이터를 표시하지 않습니다.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value}개 실행 중',
			'common.quota.agents.colAgent' => '에이전트',
			'common.quota.agents.colStatus' => '상태',
			'common.quota.agents.colTask' => '작업',
			'common.quota.agents.colModel' => '계정 / 모델',
			'common.quota.agents.colTime' => '시간',
			'common.quota.agents.empty' => '이 필터와 일치하는 에이전트가 없습니다.',
			'common.quota.agents.detailSession' => '세션',
			'common.quota.agents.detailStarted' => '시작됨',
			'common.quota.agents.detailRetries' => '재시도',
			'common.quota.agents.detailResult' => '결과',
			'common.quota.agents.notTracked' => '추적 안 됨',
			'common.quota.agentStatus.running' => '실행 중',
			'common.quota.agentStatus.waiting' => '대기 중',
			'common.quota.agentStatus.failed' => '실패',
			'common.quota.agentStatus.finished' => '완료됨',
			'common.quota.agentStatus.queued' => '대기열',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: 현재 속도로 ${value} 후 한도 소진',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% 사용 (임계값 ${watch}%)',
			'common.quota.backToChat' => '채팅으로 돌아가기',
			'common.quota.syncNow' => '지금 동기화',
			'common.quota.generatedAt' => ({required Object value}) => '업데이트: ${value}',
			'common.quota.loading' => '계정 한도 로드 중…',
			'common.quota.remaining' => ({required Object value}) => '${value}% 남음',
			'common.quota.resetsIn' => ({required Object value}) => '${value} 후 리셋',
			'common.quota.projected' => ({required Object value}) => '현재 속도로 이 한도는 ${value} 후 소진됩니다',
			'common.quota.syncedAgo' => ({required Object value}) => '${value} 전에 동기화됨',
			'common.quota.refreshAccount' => '계정 새로고침',
			'common.quota.syncFailed' => '동기화 실패',
			'common.quota.history' => '기록',
			'common.quota.historyPoints' => ({required Object value}) => '${value}개 판독값 기록됨',
			'common.quota.historyEmpty' => '아직 기록된 내역 없음',
			'common.quota.noAgents' => '할당된 에이전트 없음',
			'common.quota.noSubscription' => '구독 없음',
			'common.quota.noSubscriptionHint' => '제공자가 이 계정에 대한 활성 플랜을 보고하지 않습니다.',
			'common.quota.quality.live' => '실시간',
			'common.quota.quality.cached' => '캐시됨',
			'common.quota.quality.estimate' => '추정',
			'common.quota.quality.unknown' => '알 수 없음',
			'common.quota.quality.error' => '오류',
			'common.quota.kpi.atRisk' => '위험한 한도',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => '${value}% 초과 계정',
			'common.quota.kpi.windowsAtRisk' => '소진 임박 윈도우',
			'common.quota.kpi.errored' => '동기화 실패',
			'common.quota.kpi.activeAgents' => '활성 에이전트',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} 대기 · ${queued} 대기열',
			'common.quota.kpi.nextReset' => '다음 리셋',
			'common.quota.kpi.tokens' => '토큰',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} 세션',
			'common.quota.kpi.cost' => '예상 비용',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} 플랜으로 충당',
			'common.quota.empty.title' => '연결된 계정 없음',
			'common.quota.empty.description' => 'Claude, Codex, Gemini 또는 CommandCode에 로그인하면 여기서 쿼터를 추적할 수 있습니다.',
			'common.quota.settings.title' => '알림 및 라우팅',
			'common.quota.settings.description' => '대시보드가 경고하는 시점과 새 작업에 계정을 제안하는 방식을 제어합니다.',
			'common.quota.settings.alertsEnabled' => '예측 및 임계값 알림',
			'common.quota.settings.alertsEnabledHint' => '90%가 되어서가 아니라 현재 속도로 한도가 소진되기 전에 경고합니다.',
			'common.quota.settings.watchThreshold' => '관찰 임계값 (%)',
			'common.quota.settings.dangerThreshold' => '위험 임계값 (%)',
			'common.quota.settings.routingMode' => '라우팅',
			'common.quota.settings.routing.manual' => '수동 — 권장만 표시',
			'common.quota.settings.routing.ask' => '계정 전환 전 확인',
			'common.quota.settings.routing.autoLowRisk' => '저위험 작업 자동 전환',
			'common.quota.settings.logSources' => '로그 소스',
			'common.quota.settings.logSourcesHint' => '사용량 및 에이전트 화면이 읽는 읽기 전용 소스입니다.',
			'common.quota.settings.quotaConsent' => '쿼터 폴링 허용',
			'common.quota.settings.quotaConsentHint' => '저장된 자격 증명으로 제공자 엔드포인트를 폴링하여 실시간 한도를 읽습니다.',
			'common.quota.settings.perAccount' => '계정별 재정의',
			'common.quota.settings.tab' => 'Control Center 설정',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => '전체',
			'common.actions.cancel' => '취소',
			'common.actions.retry' => '다시 시도',
			'common.actions.save' => '저장',
			'common.browserPane.address' => '주소',
			'common.browserPane.back' => '뒤로',
			'common.browserPane.connecting' => '브라우저에 연결 중…',
			'common.browserPane.connectionFailed' => '브라우저 연결에 실패했습니다.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => '${url}을(를) 로드할 수 없습니다',
			'common.browserPane.disconnected' => '브라우저 뷰 연결 끊김',
			'common.browserPane.enterUrl' => 'URL 입력',
			'common.browserPane.forward' => '앞으로',
			'common.browserPane.invalidUrl' => '유효한 http(s) URL을 입력하세요',
			'common.browserPane.noAuthToken' => '인증 토큰이 없습니다.',
			'common.browserPane.openExternal' => '시스템 브라우저에서 열기',
			'common.browserPane.reload' => '새로고침',
			'common.browserPane.retry' => '다시 시도',
			'common.browserPane.stop' => '중지',
			'common.browserUse.activeCount' => ({required Object count}) => '${count}개 활성',
			'common.browserUse.cancel' => '취소',
			'common.browserUse.close' => '닫기',
			'common.browserUse.delete' => '삭제',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name}이(가) 영구적으로 삭제됩니다.',
			'common.browserUse.deleteSession' => '세션 삭제',
			'common.browserUse.deleteTitle' => '브라우저 세션을 삭제하시겠습니까?',
			'common.browserUse.empty.descDisabled' => '설정에서 Browser를 활성화하면 에이전트가 모니터링되는 브라우저 세션을 열 수 있습니다.',
			'common.browserUse.empty.descEnabled' => 'AI 작업이 Browser를 사용하는 동안 에이전트 브라우저 세션이 여기에 표시됩니다.',
			'common.browserUse.empty.titleDisabled' => 'Browser가 비활성화됨',
			'common.browserUse.empty.titleEnabled' => '아직 브라우저 세션 없음',
			'common.browserUse.emptyStatus' => '비어 있음',
			'common.browserUse.errors.actionFailed' => '브라우저 작업 실패',
			'common.browserUse.errors.loadFailed' => 'Browser 로드 실패',
			'common.browserUse.fullscreen' => '전체 화면',
			'common.browserUse.installRuntime' => '런타임 설치',
			'common.browserUse.installing' => '설치 중...',
			'common.browserUse.lastAction' => '마지막 작업',
			'common.browserUse.nextSnapshot' => '에이전트 브라우저의 다음 스냅샷이 여기에 표시됩니다.',
			'common.browserUse.noPageLoaded' => '로드된 페이지 없음',
			'common.browserUse.noSessions' => '에이전트 브라우저 세션이 없습니다.',
			'common.browserUse.none' => '없음',
			'common.browserUse.openSettings' => 'Browser 설정 열기',
			'common.browserUse.profile' => '프로필',
			'common.browserUse.promptLabel' => '프롬프트',
			'common.browserUse.prompts.prompt1' => 'Browser를 사용하여 결제 흐름을 검사하고 깨진 UI 상태를 보고하세요.',
			'common.browserUse.prompts.prompt2' => 'Browser로 <url>을 열고 페이지와 상호작용한 뒤 각 단계 후 변경 사항을 요약하세요.',
			'common.browserUse.refresh' => '브라우저 세션 새로고침',
			'common.browserUse.relative.daysAgo' => '일 전',
			'common.browserUse.relative.hoursAgo' => '시간 전',
			'common.browserUse.relative.justNow' => '방금',
			'common.browserUse.relative.minutesAgo' => '분 전',
			'common.browserUse.relative.never' => '없음',
			'common.browserUse.relative.secondsAgo' => '초 전',
			'common.browserUse.relative.unknown' => '알 수 없음',
			'common.browserUse.runtime.disabled' => '비활성화됨',
			'common.browserUse.runtime.installing' => '설치 중',
			'common.browserUse.runtime.ready' => '준비됨',
			'common.browserUse.runtime.setupRequired' => '설정 필요',
			'common.browserUse.runtimeSetup' => '런타임 설정 필요',
			'common.browserUse.selected' => '선택됨',
			'common.browserUse.sessionFallback' => '브라우저 세션',
			'common.browserUse.sessionScreenshot' => '브라우저 세션 스크린샷',
			'common.browserUse.sessions' => '세션',
			'common.browserUse.status' => '상태',
			'common.browserUse.stop' => '중지',
			'common.browserUse.stopSession' => '세션 중지',
			'common.browserUse.subtitle' => 'AI 에이전트가 연 브라우저 세션을 모니터링합니다.',
			'common.browserUse.temporary' => '임시',
			'common.browserUse.thisSession' => '이 세션',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '전체 ${count}개',
			'common.browserUse.updated' => ({required Object time}) => '업데이트: ${time}',
			'common.browserUse.waiting' => '대기 중',
			'common.browserUse.waitingForScreenshot' => '스크린샷 대기 중',
			'common.commandPalette.backToAll' => '전체로 돌아가기',
			'common.commandPalette.backspaceHint' => 'Backspace로 돌아가기',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => '모든 브랜치 보기 (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => '모든 커밋 보기 (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => '모든 파일 보기 (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => '모든 세션 보기 (${count})',
			'common.commandPalette.compare.costNote' => '비용은 공개된 토큰당 요금을 기반으로 한 클라이언트 측 추정치이며, 알 수 없는 모델은 "—"로 표시됩니다.',
			'common.commandPalette.compare.estCost' => '예상 비용',
			'common.commandPalette.compare.inputOutput' => '입력 / 출력',
			'common.commandPalette.compare.model' => '모델',
			'common.commandPalette.compare.na' => '해당 없음',
			'common.commandPalette.compare.openSplit' => '분할 뷰로 열기',
			'common.commandPalette.compare.provider' => '제공자',
			'common.commandPalette.compare.selectSession' => '세션 선택…',
			'common.commandPalette.compare.tokensUsed' => '사용된 토큰',
			'common.commandPalette.groups.actions' => '작업',
			'common.commandPalette.groups.branches' => '브랜치',
			'common.commandPalette.groups.commits' => '커밋',
			'common.commandPalette.groups.files' => '파일',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => '탐색',
			'common.commandPalette.groups.sessions' => '세션',
			'common.commandPalette.groups.settings' => '설정',
			'common.commandPalette.hints.close' => '닫기',
			'common.commandPalette.hints.navigate' => '탐색',
			'common.commandPalette.hints.select' => '선택',
			'common.commandPalette.hints.togglePalette' => '팔레트 전환',
			'common.commandPalette.items.compareSessions' => '세션 비교',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => '설정 열기',
			'common.commandPalette.items.selectProjectFirst' => '먼저 프로젝트를 선택하세요',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => '설정: ${label}',
			'common.commandPalette.items.startNewChat' => '새 채팅 시작',
			'common.commandPalette.items.switchTo' => ({required Object name}) => '전환: ${name}',
			'common.commandPalette.items.toggleTheme' => '테마 전환',
			'common.commandPalette.items.tokensAndCost' => '토큰 및 비용',
			'common.commandPalette.nav.board' => '에이전트 보드로 이동',
			'common.commandPalette.nav.chat' => '채팅으로 이동',
			'common.commandPalette.nav.files' => '파일로 이동',
			'common.commandPalette.nav.git' => 'Git으로 이동',
			'common.commandPalette.nav.sourceControl' => '소스 컨트롤로 이동',
			'common.commandPalette.nav.tasks' => '작업으로 이동',
			'common.commandPalette.nav.usage' => '쿼터 및 사용량으로 이동',
			'common.commandPalette.noResults' => '결과가 없습니다.',
			'common.commandPalette.pages.actions' => '작업',
			'common.commandPalette.pages.branches' => '브랜치',
			'common.commandPalette.pages.commits' => '커밋',
			'common.commandPalette.pages.compare' => '비교',
			'common.commandPalette.pages.files' => '파일',
			'common.commandPalette.pages.sessions' => '세션',
			'common.commandPalette.placeholder' => '입력하여 검색…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => '${page} 검색…',
			'common.commandPalette.title' => '명령 팔레트',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} 앞섬',
			'common.gitPanel.aheadLabel' => '앞섬',
			'common.gitPanel.aiSuggest' => 'AI 제안',
			'common.gitPanel.aiSuggestTitle' => 'AI로 커밋 메시지 생성',
			'common.gitPanel.all' => '전체',
			'common.gitPanel.allStaged' => '모든 변경 사항이 스테이징됨',
			'common.gitPanel.behind' => ({required Object count}) => '${count} 뒤처짐',
			'common.gitPanel.behindLabel' => '뒤처짐',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => '"${branch}" 브랜치를 삭제하시겠습니까? 일반 삭제는 브랜치가 완전히 병합된 경우에만 성공합니다. 되돌릴 수 없습니다.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => '"${branch}" 브랜치로 전환하시겠습니까? 커밋되지 않은 변경 사항이 없는지 확인하세요.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '로컬 ${local}개, 원격 ${remote}개',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '로컬 ${count}개',
			'common.gitPanel.branches.current' => '현재',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => '${branch} 삭제',
			'common.gitPanel.branches.emptyDesc' => '브랜치를 생성하여 병렬 작업을 시작하세요.',
			'common.gitPanel.branches.forceDelete' => '강제 삭제',
			'common.gitPanel.branches.forceDeleteDesc' => '다른 곳에 병합되지 않은 커밋이 있어도 브랜치를 영구적으로 제거합니다.',
			'common.gitPanel.branches.forceDeleteLabel' => '병합되지 않은 이 브랜치 강제 삭제',
			'common.gitPanel.branches.local' => '로컬',
			'common.gitPanel.branches.kNew' => '새 브랜치',
			'common.gitPanel.branches.noMatch' => '검색과 일치하는 브랜치가 없습니다',
			'common.gitPanel.branches.none' => '브랜치를 찾을 수 없습니다',
			'common.gitPanel.branches.remote' => '원격',
			'common.gitPanel.branches.kSwitch' => '전환',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => '${branch}(으)로 전환',
			'common.gitPanel.cancel' => '취소',
			'common.gitPanel.changesCount' => ({required Object count}) => '변경 사항 (${count})',
			'common.gitPanel.clearSearch' => '검색 지우기',
			'common.gitPanel.collapseDiff' => 'diff 접기',
			'common.gitPanel.commit' => '커밋',
			'common.gitPanel.commitChanges' => '변경 사항 커밋',
			'common.gitPanel.commitFiles' => ({required Object count}) => '${count}개 파일 커밋',
			'common.gitPanel.committing' => '커밋 중...',
			'common.gitPanel.confirmActions.commit' => '확인',
			'common.gitPanel.confirmActions.delete' => '삭제',
			'common.gitPanel.confirmActions.deleteBranch' => '삭제',
			'common.gitPanel.confirmActions.discard' => '폐기',
			'common.gitPanel.confirmActions.publish' => '게시',
			'common.gitPanel.confirmActions.pull' => '풀',
			'common.gitPanel.confirmActions.push' => '푸시',
			'common.gitPanel.confirmActions.revertLocalCommit' => '커밋 되돌리기',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => '${count}개 파일을 메시지 "${message}"(으)로 커밋하시겠습니까?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => '추적되지 않는 파일 "${file}"을(를) 삭제하시겠습니까? 되돌릴 수 없습니다.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => '"${file}"의 모든 변경 사항을 폐기하시겠습니까? 되돌릴 수 없습니다.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => '"${branch}" 브랜치를 ${remote}에 게시하시겠습니까?',
			'common.gitPanel.confirmPull' => ({required Object remote, required Object count}) => '${remote}에서 ${count}개 커밋을 가져오시겠습니까?',
			'common.gitPanel.confirmPush' => ({required Object remote, required Object count}) => '${remote}에 ${count}개 커밋을 푸시하시겠습니까?',
			'common.gitPanel.confirmRevert' => '최신 로컬 커밋을 되돌리시겠습니까? 커밋은 제거되지만 변경 사항은 스테이징 상태로 유지됩니다.',
			'common.gitPanel.confirmTitles.commit' => '작업 확인',
			'common.gitPanel.confirmTitles.delete' => '파일 삭제',
			'common.gitPanel.confirmTitles.deleteBranch' => '브랜치 삭제',
			'common.gitPanel.confirmTitles.discard' => '변경 사항 폐기',
			'common.gitPanel.confirmTitles.publish' => '브랜치 게시',
			'common.gitPanel.confirmTitles.pull' => 'Pull 확인',
			'common.gitPanel.confirmTitles.push' => 'Push 확인',
			'common.gitPanel.confirmTitles.revertLocalCommit' => '로컬 커밋 되돌리기',
			'common.gitPanel.createBranch' => '새 브랜치 생성',
			'common.gitPanel.creating' => '생성 중...',
			'common.gitPanel.delete' => '삭제',
			'common.gitPanel.deleteUntracked' => '추적되지 않는 파일 삭제',
			'common.gitPanel.deselectAll' => '모두 선택 해제',
			'common.gitPanel.discard' => '폐기',
			'common.gitPanel.discardChanges' => '변경 사항 폐기',
			'common.gitPanel.dismiss' => '닫기',
			'common.gitPanel.dismissError' => '오류 닫기',
			'common.gitPanel.errors.createBranchFailed' => '브랜치 생성 실패',
			'common.gitPanel.errors.createWorktreeFailed' => 'worktree 생성 실패',
			'common.gitPanel.errors.deleteBranchFailed' => '브랜치 삭제 실패',
			'common.gitPanel.errors.fetchFailed' => 'Fetch 실패',
			'common.gitPanel.errors.initFailed' => '리포지토리 초기화 실패',
			'common.gitPanel.errors.initialCommitFailed' => '첫 커밋 생성 실패',
			'common.gitPanel.errors.mergeFailed' => '병합 실패',
			'common.gitPanel.errors.openWorktreeFailed' => 'worktree 열기 실패',
			'common.gitPanel.errors.operationFailed' => 'git 작업 실패',
			'common.gitPanel.errors.publishFailed' => '게시 실패',
			'common.gitPanel.errors.pullFailed' => 'Pull 실패',
			'common.gitPanel.errors.pushFailed' => 'Push 실패',
			'common.gitPanel.errors.removeWorktreeFailed' => 'worktree 제거 실패',
			'common.gitPanel.errors.stageFailed' => '스테이징 실패',
			'common.gitPanel.errors.stageHunksFailed' => '헝크 스테이징 실패',
			'common.gitPanel.errors.switchFailed' => '브랜치 전환 실패',
			'common.gitPanel.errors.unstageFailed' => '스테이징 해제 실패',
			'common.gitPanel.errors.unstageHunksFailed' => '헝크 스테이징 해제 실패',
			'common.gitPanel.expandDiff' => 'diff 펼치기',
			'common.gitPanel.fetch' => '페치',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => '${remote}에서 fetch',
			'common.gitPanel.fetching' => 'Fetch 중…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count}개 파일 선택됨',
			'common.gitPanel.generating' => '생성 중...',
			'common.gitPanel.history.added' => '추가됨',
			'common.gitPanel.history.author' => '작성자',
			'common.gitPanel.history.changedFiles' => '변경된 파일',
			'common.gitPanel.history.date' => '날짜',
			'common.gitPanel.history.empty' => '커밋을 찾을 수 없습니다',
			'common.gitPanel.history.files' => '파일',
			'common.gitPanel.history.removed' => '제거됨',
			'common.gitPanel.mergeWorktree.cleanupDesc' => '병합 후 worktree를 제거하고 브랜치 삭제',
			'common.gitPanel.mergeWorktree.cleanupLabel' => '병합 후 정리',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count}개 커밋',
			'common.gitPanel.mergeWorktree.merge' => '병합',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => '\'${branch}\' 브랜치 병합',
			'common.gitPanel.mergeWorktree.messageLabel' => '커밋 메시지',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => '${commits}개를 ${branch}의 단일 커밋으로 결합',
			'common.gitPanel.mergeWorktree.squashLabel' => '커밋 스쿼시',
			'common.gitPanel.mergeWorktree.squashMerge' => '스쿼시 및 병합',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => '\'${branch}\' 브랜치 스쿼시 병합',
			'common.gitPanel.mergeWorktree.title' => 'Worktree 병합',
			'common.gitPanel.merging' => '병합 중...',
			'common.gitPanel.messagePlaceholder' => '메시지 (Ctrl+Enter로 커밋)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => '현재 브랜치(${branch})에서 새 브랜치를 생성합니다',
			'common.gitPanel.newBranch.nameLabel' => '브랜치 이름',
			'common.gitPanel.newBranch.submit' => '브랜치 생성',
			'common.gitPanel.newBranch.title' => '새 브랜치 생성',
			'common.gitPanel.newWorktree.branchLabel' => '브랜치',
			'common.gitPanel.newWorktree.createFrom' => '생성 기준',
			'common.gitPanel.newWorktree.description' => '브랜치를 별도 폴더에 체크아웃하여 병렬로 작업하세요.',
			'common.gitPanel.newWorktree.existingBranch' => '기존 브랜치 — 있는 그대로 체크아웃됩니다.',
			'common.gitPanel.newWorktree.submit' => 'Worktree 생성',
			'common.gitPanel.newWorktree.switchAfter' => '생성 후 worktree로 전환',
			'common.gitPanel.newWorktree.title' => '새 Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => '생성 위치',
			'common.gitPanel.noChanges' => '변경 사항이 감지되지 않았습니다',
			'common.gitPanel.noChangesToCommit' => '커밋할 변경 사항이 없습니다',
			'common.gitPanel.noCommits.create' => '첫 커밋 생성',
			'common.gitPanel.noCommits.creating' => '첫 커밋 생성 중...',
			'common.gitPanel.noCommits.description' => '이 리포지토리에는 아직 커밋이 없습니다. 첫 커밋을 생성하여 변경 추적을 시작하세요.',
			'common.gitPanel.noCommits.title' => '아직 커밋 없음',
			'common.gitPanel.noMatchingBranches' => '일치하는 브랜치 없음',
			'common.gitPanel.noRepo.description' => '이 프로젝트는 아직 git 리포지토리가 아닙니다. 초기화하여 변경 추적 및 소스 컨트롤 기능을 사용하세요.',
			'common.gitPanel.noRepo.init' => 'git init 실행',
			'common.gitPanel.noRepo.initializing' => '리포지토리 초기화 중...',
			'common.gitPanel.noRepo.title' => 'git 리포지토리 없음',
			'common.gitPanel.noStagedFiles' => '스테이징된 파일 없음',
			'common.gitPanel.none' => '없음',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => '${remote}에 푸시할 내용이 없습니다',
			'common.gitPanel.openFile' => '클릭하여 파일 열기',
			'common.gitPanel.publish' => '게시',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => '"${branch}"을(를) ${remote}에 게시',
			'common.gitPanel.publishing' => '게시 중…',
			'common.gitPanel.pull' => '풀',
			'common.gitPanel.pullCount' => ({required Object count}) => '풀 ${count}',
			'common.gitPanel.pullTitle' => ({required Object remote, required Object count}) => '${remote}에서 ${count}개 가져오기',
			'common.gitPanel.pulling' => 'Pull 중…',
			'common.gitPanel.push' => '푸시',
			'common.gitPanel.pushCount' => ({required Object count}) => '푸시 ${count}',
			'common.gitPanel.pushTitle' => ({required Object remote, required Object count}) => '${remote}에 ${count}개 푸시',
			'common.gitPanel.pushing' => 'Push 중…',
			'common.gitPanel.recentCommits' => '최근 커밋',
			'common.gitPanel.refresh' => 'git 상태 새로고침',
			'common.gitPanel.remove' => '제거',
			'common.gitPanel.removeWorktree.alsoDelete' => '브랜치도 삭제',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => '${branch}의 worktree를 제거하시겠습니까? 폴더가 삭제되고 연결된 프로젝트가 보관됩니다 — 채팅 세션은 복구 가능합니다.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => '이 worktree에는 손실될 커밋되지 않은 변경 사항이 ${count}개 있습니다.',
			'common.gitPanel.removeWorktree.discardChanges' => '커밋되지 않은 변경 사항 폐기',
			'common.gitPanel.removeWorktree.title' => 'Worktree 제거',
			'common.gitPanel.removing' => '제거 중...',
			'common.gitPanel.revertLatest' => '최신 로컬 커밋 되돌리기',
			'common.gitPanel.scroll' => '스크롤',
			'common.gitPanel.searchBranches' => '브랜치 검색...',
			'common.gitPanel.selectAll' => '모두 선택',
			'common.gitPanel.selectProject' => '소스 컨트롤을 보려면 프로젝트를 선택하세요',
			'common.gitPanel.selectedOf' => ({required Object total, required Object selected}) => '${total}개 파일 중 ${selected}개 선택됨',
			'common.gitPanel.selectedOfMobile' => ({required Object total, required Object selected}) => '${total}개 중 ${selected}개 선택됨',
			'common.gitPanel.sideBySide' => '나란히',
			'common.gitPanel.stageAll' => '모두 스테이징',
			'common.gitPanel.stageHunk' => '이 헝크 스테이징',
			'common.gitPanel.staged' => ({required Object count}) => '스테이징됨 (${count})',
			'common.gitPanel.status.added' => '추가됨',
			'common.gitPanel.status.deleted' => '삭제됨',
			'common.gitPanel.status.modified' => '수정됨',
			'common.gitPanel.status.untracked' => '추적 안 됨',
			'common.gitPanel.statusGuide' => '파일 상태 가이드',
			'common.gitPanel.switchScroll' => '가로 스크롤로 전환',
			'common.gitPanel.switchSplit' => '나란히 보기로 전환',
			'common.gitPanel.switchUnified' => '통합 보기로 전환',
			'common.gitPanel.switchWrap' => '텍스트 줄바꿈으로 전환',
			'common.gitPanel.unified' => '통합',
			'common.gitPanel.unstageAll' => '모두 스테이징 해제',
			'common.gitPanel.unstageHunk' => '이 헝크 스테이징 해제',
			'common.gitPanel.upToDate' => '최신 상태',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => '${remote}와 최신 상태',
			'common.gitPanel.viewAll' => '모두 보기',
			'common.gitPanel.viewsAria' => '소스 컨트롤 뷰',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count}개 변경 사항',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count}개 worktree',
			'common.gitPanel.worktrees.createFirst' => '첫 worktree를 생성하세요',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.worktrees.detached' => '분리됨',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => '분리됨 @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => '분리된 HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'worktree는 브랜치를 자체 폴더에 체크아웃하여 별도의 채팅 세션을 나란히 실행하고 준비되면 결과를 병합할 수 있습니다.',
			'common.gitPanel.worktrees.emptyTitle' => '브랜치에서 병렬로 작업',
			'common.gitPanel.worktrees.locked' => '잠김',
			'common.gitPanel.worktrees.mainWorktree' => '메인 worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => '${branch}을(를) 기본 브랜치에 병합',
			'common.gitPanel.worktrees.kNew' => '새 worktree',
			'common.gitPanel.worktrees.none' => 'worktree 없음',
			'common.gitPanel.worktrees.nothingToMerge' => '병합할 내용 없음 — 기본 브랜치보다 앞선 커밋 없음',
			'common.gitPanel.worktrees.open' => '열기',
			'common.gitPanel.worktrees.refresh' => 'worktree 새로고침',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => '${branch}의 worktree 제거',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => '${branch}(으)로 전환',
			'common.gitPanel.wrap' => '줄바꿈',
			'common.gitPanel.tabs.changes' => '변경 사항',
			'common.gitPanel.tabs.history' => '커밋',
			'common.gitPanel.tabs.branches' => '브랜치',
			'common.gitPanel.tabs.worktrees' => '워크트리',
			'common.sessions.renameSession' => '세션 이름 변경',
			'common.projects.newSession' => '새 세션',
			'settings.title' => '설정',
			'settings.changelog.title' => '변경 로그',
			'settings.changelog.loading' => '로딩 중…',
			'settings.changelog.empty' => '표시할 릴리스가 없습니다',
			'settings.changelog.current' => '현재',
			'settings.changelog.kNew' => '신규',
			'settings.server.title' => '서버',
			'settings.server.description' => 'ddagent 프로세스를 재시작합니다 — 업데이트 적용이나 멈춤 상태 복구에 유용합니다.',
			'settings.server.restart' => '재시작',
			'settings.server.restartConfirm' => 'ddagent 서버를 재시작할까요? 활성 세션이 중단됩니다.',
			'settings.server.restarting' => '재시작 중… 서버가 돌아오면 페이지가 새로고침됩니다.',
			'settings.server.restartFailed' => '재시작 실패',
			'settings.server.unsupported' => '서버가 서비스 매니저로 실행 중일 때만 재시작할 수 있습니다.',
			'settings.updates.title' => '앱 업데이트',
			'settings.updates.description' => 'GitHub에서 더 최신 데스크톱 빌드를 확인합니다. 새 버전은 자동으로 다운로드되어 종료 시 설치됩니다.',
			'settings.updates.check' => '업데이트 확인',
			'settings.updates.checking' => '확인 중…',
			'settings.updates.upToDate' => ({required Object version}) => '최신 버전입니다 (v${version}).',
			'settings.updates.available' => ({required Object version}) => '업데이트 v${version} 발견 — 백그라운드에서 다운로드 중; ddagent 종료 시 설치됩니다.',
			'settings.updates.downloaded' => ({required Object version}) => '업데이트 v${version} 다운로드 완료 — ddagent를 종료 후 다시 실행하면 설치됩니다.',
			'settings.updates.unavailable' => '업데이트 확인은 패키지된 데스크톱 빌드에서만 사용할 수 있습니다.',
			'settings.updates.error' => ({required Object message}) => '업데이트 확인 실패: ${message}',
			'settings.updates.errorGeneric' => '업데이트 확인에 실패했습니다.',
			'settings.tabs.account' => '계정',
			'settings.tabs.permissions' => '권한',
			'settings.tabs.mcpServers' => 'MCP 서버',
			'settings.tabs.skills' => '스킬',
			'settings.tabs.appearance' => '외관',
			'settings.account.title' => '계정',
			'settings.account.language' => '언어',
			'settings.account.languageLabel' => '표시 언어',
			'settings.account.languageDescription' => '인터페이스에 사용할 언어를 선택하세요',
			'settings.account.username' => '사용자명',
			'settings.account.email' => '이메일',
			'settings.account.profile' => '프로필',
			'settings.account.changePassword' => '비밀번호 변경',
			'settings.mcp.title' => 'MCP 서버',
			'settings.mcp.addServer' => '서버 추가',
			'settings.mcp.editServer' => '서버 편집',
			'settings.mcp.deleteServer' => '서버 삭제',
			'settings.mcp.serverName' => '서버 이름',
			'settings.mcp.serverType' => '서버 유형',
			'settings.mcp.config' => '설정',
			'settings.mcp.testConnection' => '연결 테스트',
			'settings.mcp.status' => '상태',
			'settings.mcp.connected' => '연결됨',
			'settings.mcp.disconnected' => '연결 끊김',
			'settings.mcp.scope.label' => '범위',
			'settings.mcp.scope.user' => '사용자',
			'settings.mcp.scope.project' => '프로젝트',
			'settings.appearance.title' => '외관',
			'settings.appearance.theme' => '테마',
			'settings.appearance.codeEditor' => '코드 에디터',
			'settings.appearance.editorTheme' => '에디터 테마',
			'settings.appearance.wordWrap' => '자동 줄바꿈',
			'settings.appearance.showMinimap' => '미니맵 표시',
			'settings.appearance.lineNumbers' => '줄 번호',
			'settings.appearance.fontSize' => '글꼴 크기',
			'settings.actions.saveChanges' => '변경사항 저장',
			'settings.actions.resetToDefaults' => '기본값으로 초기화',
			'settings.actions.cancelChanges' => '변경 취소',
			'settings.quickSettings.title' => '빠른 설정',
			'settings.quickSettings.sections.appearance' => '외관',
			'settings.quickSettings.sections.toolDisplay' => '도구 표시',
			'settings.quickSettings.sections.inputSettings' => '입력 설정',
			'settings.quickSettings.darkMode' => '다크 모드',
			'settings.quickSettings.showRawParameters' => 'Raw 파라미터 표시',
			'settings.quickSettings.showThinking' => '생각 과정 표시',
			'settings.quickSettings.sendByCtrlEnter' => 'Ctrl+Enter로 전송',
			'settings.quickSettings.sendByCtrlEnterDescription' => '활성화하면 Enter 대신 Ctrl+Enter로 메시지를 전송합니다. IME 사용자가 실수로 전송하는 것을 방지하는 데 유용합니다.',
			'settings.quickSettings.dragHandle.dragging' => '드래그 핸들',
			'settings.quickSettings.dragHandle.closePanel' => '설정 패널 닫기',
			'settings.quickSettings.dragHandle.openPanel' => '설정 패널 열기',
			'settings.quickSettings.dragHandle.draggingStatus' => '드래그 중...',
			'settings.quickSettings.dragHandle.toggleAndMove' => '클릭하여 토글, 드래그하여 이동',
			'settings.terminalShortcuts.title' => '터미널 단축키',
			'settings.terminalShortcuts.sectionKeys' => '키',
			'settings.terminalShortcuts.sectionNavigation' => '탐색',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => '위쪽 화살표',
			'settings.terminalShortcuts.arrowDown' => '아래쪽 화살표',
			'settings.terminalShortcuts.scrollDown' => '아래로 스크롤',
			'settings.terminalShortcuts.handle.closePanel' => '단축키 패널 닫기',
			'settings.terminalShortcuts.handle.openPanel' => '단축키 패널 열기',
			'settings.terminalShortcuts.killTitle' => '실행 중인 프로세스 종료 (Ctrl+C)',
			'settings.terminalShortcuts.paste' => '붙여넣기',
			'settings.mainTabs.label' => '설정',
			'settings.mainTabs.agents' => '에이전트',
			'settings.mainTabs.orchestration' => '오케스트레이션',
			'settings.mainTabs.appearance' => '외관',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API & 토큰',
			'settings.mainTabs.models' => '모델',
			'settings.mainTabs.tasks' => '작업',
			'settings.mainTabs.browser' => '브라우저',
			'settings.mainTabs.notifications' => '알림',
			'settings.mainTabs.about' => '정보',
			'settings.mainTabs.workspaces' => '작업 영역',
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
			'settings.notifications.title' => '알림',
			'settings.notifications.description' => '수신할 알림 이벤트를 설정합니다.',
			'settings.notifications.webPush.title' => '웹 푸시 알림',
			'settings.notifications.webPush.enable' => '푸시 알림 활성화',
			'settings.notifications.webPush.disable' => '푸시 알림 비활성화',
			'settings.notifications.webPush.enabled' => '푸시 알림이 활성화되었습니다',
			'settings.notifications.webPush.loading' => '업데이트 중...',
			'settings.notifications.webPush.unsupported' => '이 브라우저에서는 푸시 알림이 지원되지 않습니다.',
			'settings.notifications.webPush.denied' => '푸시 알림이 차단되었습니다. 브라우저 설정에서 허용해 주세요.',
			'settings.notifications.webPush.iosHint' => 'iPhone/iPad에서는 ddagent를 홈 화면에 추가하고(공유 → 홈 화면에 추가) 설치된 앱에서 알림을 활성화해야만 알림이 작동합니다.',
			'settings.notifications.webPush.test' => '테스트 알림 보내기',
			'settings.notifications.webPush.testNoSubscription' => '구독 중인 기기가 없습니다. 먼저 휴대폰에서 "활성화"를 누르세요.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => '${count}개 기기에 전송했습니다. 휴대폰에 아무것도 표시되지 않으면 ddagent를 홈 화면에 추가하세요(iOS 요구 사항).',
			'settings.notifications.desktop.title' => '데스크톱 앱 알림',
			'settings.notifications.desktop.enable' => '알림 활성화',
			'settings.notifications.desktop.disable' => '알림 비활성화',
			'settings.notifications.desktop.enabled' => '이 데스크톱 앱에 대한 알림이 활성화되었습니다',
			'settings.notifications.desktop.unsupported' => '이 시스템에서는 데스크톱 알림이 지원되지 않습니다.',
			'settings.notifications.sound.title' => '소리',
			'settings.notifications.sound.description' => '채팅 실행이 완료되면 짧은 알림음을 재생합니다.',
			'settings.notifications.sound.enabled' => '사용',
			'settings.notifications.sound.test' => '소리 테스트',
			'settings.notifications.events.title' => '이벤트 유형',
			'settings.notifications.events.actionRequired' => '작업 필요',
			'settings.notifications.events.stop' => '실행 중지',
			'settings.notifications.events.error' => '실행 실패',
			'settings.appearanceSettings.darkMode.label' => '다크 모드',
			'settings.appearanceSettings.darkMode.description' => '라이트/다크 테마 전환',
			'settings.appearanceSettings.projectSorting.label' => '프로젝트 정렬',
			'settings.appearanceSettings.projectSorting.description' => '사이드바에서 프로젝트 정렬 방식',
			'settings.appearanceSettings.projectSorting.alphabetical' => '알파벳순',
			'settings.appearanceSettings.projectSorting.recentActivity' => '최근 활동순',
			'settings.appearanceSettings.codeEditor.title' => '코드 에디터',
			'settings.appearanceSettings.codeEditor.theme.label' => '에디터 테마',
			'settings.appearanceSettings.codeEditor.theme.description' => '코드 에디터의 기본 테마',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => '자동 줄바꿈',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => '에디터에서 기본적으로 자동 줄바꿈 활성화',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => '미니맵 표시',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Diff 보기에서 쉬운 탐색을 위한 미니맵 표시',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => '줄 번호 표시',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => '에디터에 줄 번호 표시',
			'settings.appearanceSettings.codeEditor.fontSize.label' => '글꼴 크기',
			'settings.appearanceSettings.codeEditor.fontSize.description' => '에디터 글꼴 크기 (픽셀)',
			'settings.appearanceSettings.terminal.title' => '터미널',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => '포커스가 포인터를 따름',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => '마우스를 올리면 입력을 위해 터미널에 포커스',
			'settings.mcpForm.title.add' => 'MCP 서버 추가',
			'settings.mcpForm.title.edit' => 'MCP 서버 편집',
			'settings.mcpForm.importMode.form' => '폼 입력',
			'settings.mcpForm.importMode.json' => 'JSON 가져오기',
			'settings.mcpForm.scope.label' => '범위',
			'settings.mcpForm.scope.userGlobal' => '사용자 (전역)',
			'settings.mcpForm.scope.projectLocal' => '프로젝트 (로컬)',
			'settings.mcpForm.scope.userDescription' => '사용자 범위: 모든 프로젝트에서 사용 가능',
			'settings.mcpForm.scope.projectDescription' => '로컬 범위: 선택한 프로젝트에서만 사용 가능',
			'settings.mcpForm.scope.cannotChange' => '기존 서버를 편집할 때는 범위를 변경할 수 없습니다',
			'settings.mcpForm.fields.serverName' => '서버 이름',
			'settings.mcpForm.fields.transportType' => '전송 유형',
			'settings.mcpForm.fields.command' => '명령어',
			'settings.mcpForm.fields.arguments' => '인수 (한 줄에 하나씩)',
			'settings.mcpForm.fields.jsonConfig' => 'JSON 설정',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => '환경 변수 (KEY=value, 한 줄에 하나씩)',
			'settings.mcpForm.fields.headers' => '헤더 (KEY=value, 한 줄에 하나씩)',
			'settings.mcpForm.fields.selectProject' => '프로젝트 선택...',
			'settings.mcpForm.placeholders.serverName' => 'my-server',
			'settings.mcpForm.validation.missingType' => '필수 항목 누락: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdio 유형은 command 필드가 필요합니다',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type} 유형은 url 필드가 필요합니다',
			'settings.mcpForm.validation.invalidJson' => '잘못된 JSON 형식',
			'settings.mcpForm.validation.jsonHelp' => 'MCP 서버 설정을 JSON 형식으로 붙여넣으세요. 예시:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => '설정 상세 (${configFile}에서)',
			'settings.mcpForm.projectPath' => ({required Object path}) => '경로: ${path}',
			'settings.mcpForm.actions.cancel' => '취소',
			'settings.mcpForm.actions.saving' => '저장 중...',
			'settings.mcpForm.actions.addServer' => '서버 추가',
			'settings.mcpForm.actions.updateServer' => '서버 업데이트',
			'settings.saveStatus.success' => '설정이 저장되었습니다!',
			'settings.saveStatus.error' => '설정 저장 실패',
			'settings.saveStatus.saving' => '저장 중...',
			'settings.footerActions.save' => '설정 저장',
			'settings.footerActions.cancel' => '취소',
			'settings.git.title' => 'Git 설정',
			'settings.git.description' => '커밋을 위한 Git 정보를 설정합니다. 이 설정은 git config --global로 전역 적용됩니다',
			'settings.git.name.label' => 'Git 이름',
			'settings.git.name.help' => 'Git 커밋에 사용될 이름',
			'settings.git.email.label' => 'Git 이메일',
			'settings.git.email.help' => 'Git 커밋에 사용될 이메일',
			'settings.git.actions.save' => '설정 저장',
			'settings.git.actions.saving' => '저장 중...',
			'settings.git.status.success' => '저장 완료',
			'settings.git.status.error' => '저장 실패',
			'settings.apiKeys.title' => 'API 키',
			'settings.apiKeys.description' => '다른 애플리케이션에서 외부 API에 접근하기 위한 API 키를 생성합니다.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ API 키를 저장하세요',
			'settings.apiKeys.newKey.alertMessage' => '이 키는 지금만 볼 수 있습니다. 안전하게 보관하세요.',
			'settings.apiKeys.newKey.iveSavedIt' => '저장했습니다',
			'settings.apiKeys.form.placeholder' => 'API 키 이름 (예: Production Server)',
			'settings.apiKeys.form.createButton' => '생성',
			'settings.apiKeys.form.cancelButton' => '취소',
			'settings.apiKeys.newButton' => '새 API 키',
			'settings.apiKeys.empty' => '생성된 API 키가 없습니다.',
			'settings.apiKeys.list.created' => '생성일:',
			'settings.apiKeys.list.lastUsed' => '마지막 사용:',
			'settings.apiKeys.confirmDelete' => '이 API 키를 삭제하시겠습니까?',
			'settings.apiKeys.status.active' => '활성',
			'settings.apiKeys.status.inactive' => '비활성',
			'settings.apiKeys.github.title' => 'GitHub 토큰',
			'settings.apiKeys.github.description' => '외부 API를 통해 비공개 저장소를 clone하기 위한 GitHub Personal Access Token을 추가합니다.',
			'settings.apiKeys.github.descriptionAlt' => '비공개 저장소를 clone하기 위한 GitHub Personal Access Token을 추가합니다. 저장하지 않고 API 요청에 직접 토큰을 전달할 수도 있습니다.',
			'settings.apiKeys.github.addButton' => '토큰 추가',
			'settings.apiKeys.github.form.namePlaceholder' => '토큰 이름 (예: Personal Repos)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHub 개인 액세스 토큰 (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => '설명 (선택사항)',
			'settings.apiKeys.github.form.addButton' => '토큰 추가',
			'settings.apiKeys.github.form.cancelButton' => '취소',
			'settings.apiKeys.github.form.howToCreate' => 'GitHub Personal Access Token 생성 방법 →',
			'settings.apiKeys.github.empty' => '추가된 GitHub 토큰이 없습니다.',
			'settings.apiKeys.github.added' => '추가일:',
			'settings.apiKeys.github.confirmDelete' => '이 GitHub 토큰을 삭제하시겠습니까?',
			'settings.apiKeys.apiDocsLink' => 'API 문서',
			'settings.apiKeys.documentation.title' => '외부 API 문서',
			'settings.apiKeys.documentation.description' => '외부 API를 사용하여 애플리케이션에서 Claude/Cursor 세션을 트리거하는 방법을 알아보세요.',
			'settings.apiKeys.documentation.viewLink' => 'API 문서 보기 →',
			'settings.apiKeys.loading' => '로딩 중...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => '업데이트 가능: v${version}',
			'settings.tasks.checking' => 'TaskMaster 설치 확인 중...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI가 설치되지 않았습니다',
			'settings.tasks.notInstalled.description' => '작업 관리 기능을 사용하려면 TaskMaster CLI가 필요합니다. 시작하려면 설치하세요:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'GitHub에서 보기',
			'settings.tasks.notInstalled.afterInstallation' => '설치 후:',
			'settings.tasks.notInstalled.steps.restart' => '이 애플리케이션을 재시작하세요',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster 기능이 자동으로 활성화됩니다',
			'settings.tasks.notInstalled.steps.initCommand' => '프로젝트 디렉토리에서 task-master init을 사용하세요',
			'settings.tasks.settings.enableLabel' => 'TaskMaster 통합 활성화',
			'settings.tasks.settings.enableDescription' => '인터페이스 전체에 TaskMaster 작업, 배너 및 사이드바 표시',
			'settings.agents.authStatus.checking' => '확인 중...',
			'settings.agents.authStatus.connected' => '연결됨',
			'settings.agents.authStatus.notConnected' => '연결되지 않음',
			'settings.agents.authStatus.disconnected' => '연결 끊김',
			'settings.agents.authStatus.checkingAuth' => '인증 상태 확인 중...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => '${email}(으)로 로그인됨',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider} 계정',
			'settings.agents.authStatus.authenticatedUser' => '인증된 사용자',
			'settings.agents.account.claude.description' => 'Anthropic Claude AI 어시스턴트',
			'settings.agents.account.cursor.description' => 'Cursor AI 기반 코드 에디터',
			'settings.agents.account.codex.description' => 'OpenAI Codex AI 어시스턴트',
			'settings.agents.account.opencode.description' => 'OpenCode CLI 어시스턴트',
			'settings.agents.account.commandcode.description' => 'Command Code CLI 어시스턴트',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI 어시스턴트',
			'settings.agents.account.devin.description' => 'Devin CLI 어시스턴트',
			'settings.agents.connectionStatus' => '연결 상태',
			'settings.agents.login.title' => '로그인',
			'settings.agents.login.reAuthenticate' => '재인증',
			'settings.agents.login.description' => ({required Object agent}) => 'AI 기능을 활성화하려면 ${agent} 계정에 로그인하세요',
			'settings.agents.login.reAuthDescription' => '다른 계정으로 로그인하거나 자격 증명을 새로고침하세요',
			'settings.agents.login.button' => '로그인',
			'settings.agents.login.reLoginButton' => '재로그인',
			'settings.agents.error' => ({required Object error}) => '오류: ${error}',
			'settings.permissions.title' => '권한 설정',
			'settings.permissions.skipPermissions.label' => '권한 확인 건너뛰기 (주의해서 사용)',
			'settings.permissions.skipPermissions.claudeDescription' => '--dangerously-skip-permissions 플래그와 동일',
			'settings.permissions.skipPermissions.cursorDescription' => 'Cursor CLI의 -f 플래그와 동일',
			'settings.permissions.allowedTools.title' => '허용된 도구',
			'settings.permissions.allowedTools.description' => '권한 확인 없이 자동으로 허용되는 도구',
			'settings.permissions.allowedTools.placeholder' => '예: "Bash(git log:*)" 또는 "Write"',
			'settings.permissions.allowedTools.quickAdd' => '자주 쓰는 도구 빠른 추가:',
			'settings.permissions.allowedTools.empty' => '설정된 허용 도구 없음',
			'settings.permissions.blockedTools.title' => '차단된 도구',
			'settings.permissions.blockedTools.description' => '권한 확인 없이 자동으로 차단되는 도구',
			'settings.permissions.blockedTools.placeholder' => '예: "Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => '설정된 차단 도구 없음',
			'settings.permissions.allowedCommands.title' => '허용된 Shell 명령어',
			'settings.permissions.allowedCommands.description' => '권한 확인 없이 자동으로 허용되는 Shell 명령어',
			'settings.permissions.allowedCommands.placeholder' => '예: "Shell(ls)" 또는 "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => '자주 쓰는 명령어 빠른 추가:',
			'settings.permissions.allowedCommands.empty' => '설정된 허용 명령어 없음',
			'settings.permissions.blockedCommands.title' => '차단된 Shell 명령어',
			'settings.permissions.blockedCommands.description' => '자동으로 차단되는 Shell 명령어',
			'settings.permissions.blockedCommands.placeholder' => '예: "Shell(rm -rf)" 또는 "Shell(sudo)"',
			'settings.permissions.blockedCommands.empty' => '설정된 차단 명령어 없음',
			'settings.permissions.toolExamples.title' => '도구 패턴 예시:',
			'settings.permissions.toolExamples.bashGitLog' => '- 모든 git log 명령어 허용',
			'settings.permissions.toolExamples.bashGitDiff' => '- 모든 git diff 명령어 허용',
			'settings.permissions.toolExamples.write' => '- 모든 Write 도구 사용 허용',
			'settings.permissions.toolExamples.bashRm' => '- 모든 rm 명령어 차단 (위험)',
			'settings.permissions.shellExamples.title' => 'Shell 명령어 예시:',
			'settings.permissions.shellExamples.ls' => '- ls 명령어 허용',
			'settings.permissions.shellExamples.gitStatus' => '- git status 허용',
			'settings.permissions.shellExamples.npmInstall' => '- npm install 허용',
			'settings.permissions.shellExamples.rmRf' => '- 재귀 삭제 차단',
			'settings.permissions.codex.permissionMode' => '권한 모드',
			'settings.permissions.codex.description' => 'Codex가 파일 수정 및 명령어 실행을 처리하는 방식을 제어합니다',
			'settings.permissions.codex.modes.kDefault.title' => '기본',
			'settings.permissions.codex.modes.kDefault.description' => '신뢰할 수 있는 명령어(ls, cat, grep, git status 등)만 자동 실행됩니다. 다른 명령어는 건너뜁니다. 워크스페이스에 쓰기 가능.',
			'settings.permissions.codex.modes.acceptEdits.title' => '편집 허용',
			'settings.permissions.codex.modes.acceptEdits.description' => '워크스페이스 내에서 모든 명령어가 자동 실행됩니다. 샌드박스 내 완전 자동 모드.',
			'settings.permissions.codex.modes.bypassPermissions.title' => '권한 우회',
			'settings.permissions.codex.modes.bypassPermissions.description' => '제한 없는 전체 시스템 접근. 모든 명령어가 전체 디스크 및 네트워크 접근 권한으로 자동 실행됩니다. 주의해서 사용하세요.',
			'settings.permissions.codex.technicalDetails' => '기술 상세',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted. 신뢰할 수 있는 명령어: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find(-exec 제외) 등.',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never. 프로젝트 디렉토리 내에서 모든 명령어 자동 실행.',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never. 전체 시스템 접근, 신뢰할 수 있는 환경에서만 사용하세요.',
			'settings.permissions.codex.technicalInfo.overrideNote' => '채팅 인터페이스의 모드 버튼을 사용하여 세션별로 재정의할 수 있습니다.',
			'settings.permissions.actions.add' => '추가',
			'settings.permissions.permissionMode.title' => '권한 모드',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => '새 ${provider} 세션의 기본 권한 모드. 개별 세션에서 재정의할 수 있습니다.',
			'settings.permissions.permissionMode.modes.kDefault.title' => '기본',
			'settings.permissions.permissionMode.modes.kDefault.description' => '권한이 필요한 작업은 채팅에서 승인을 위해 표시됩니다.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => '편집 허용',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => '파일 편집은 자동 승인됩니다. 다른 작업은 계속 승인을 요청합니다.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => '권한 우회',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => '모든 작업이 자동 승인됩니다 — 확인 없는 전체 접근. 주의해서 사용하세요.',
			'settings.permissions.permissionMode.modes.plan.title' => '계획',
			'settings.permissions.permissionMode.modes.plan.description' => '계획 모드: 에이전트가 명령을 실행하지 않고 탐색하고 계획합니다.',
			'settings.mcpServers.title' => 'MCP 서버',
			'settings.mcpServers.description.claude' => 'Model Context Protocol 서버는 Claude에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.description.cursor' => 'Model Context Protocol 서버는 Cursor에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.description.codex' => 'Model Context Protocol 서버는 Codex에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol 서버는 OpenCode에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol 서버는 Command Code에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol 서버는 Antigravity에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.description.devin' => 'Model Context Protocol 서버는 Devin에 추가 도구와 데이터 소스를 제공합니다',
			'settings.mcpServers.addButton' => 'MCP 서버 추가',
			'settings.mcpServers.empty' => '설정된 MCP 서버 없음',
			'settings.mcpServers.serverType' => '유형',
			'settings.mcpServers.scope.local' => '로컬',
			'settings.mcpServers.scope.user' => '사용자',
			'settings.mcpServers.config.command' => '명령어',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => '인수',
			'settings.mcpServers.config.environment' => '환경',
			'settings.mcpServers.tools.title' => '도구',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count}개 더',
			'settings.mcpServers.actions.edit' => '서버 편집',
			'settings.mcpServers.actions.delete' => '서버 삭제',
			'settings.mcpServers.managed.badge' => '관리됨',
			'settings.mcpServers.managed.hint' => 'ddagent가 관리합니다.',
			'settings.mcpServers.help.title' => 'Codex MCP 정보',
			'settings.mcpServers.help.description' => 'Codex는 stdio 기반 MCP 서버를 지원합니다. 추가 도구와 리소스로 Codex의 기능을 확장하는 서버를 추가할 수 있습니다.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '"${serverName}"이(가) 제공자 구성에서 제거됩니다.',
			'settings.mcpServers.deleteConfirm.title' => 'MCP 서버를 삭제하시겠습니까?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => '알림 임계값, 라우팅 정책, 쿼터를 폴링하는 계정.',
			'settings.quota.settings.saved' => '저장됨',
			'settings.quota.settings.alertsSection' => '알림',
			'settings.quota.settings.alertsSectionHint' => '한도가 실제로 소진되기 전에 경고합니다. 100%가 되어서가 아닙니다.',
			'settings.quota.settings.alertsEnabled' => '예측 한도 알림',
			'settings.quota.settings.alertsEnabledHint' => '개요와 계정 카드에 속도 기반 예측을 표시합니다.',
			'settings.quota.settings.watchThreshold' => '관찰 임계값 (%)',
			'settings.quota.settings.watchThresholdHint' => '이 판독값 이상인 계정은 위험으로 계산됩니다.',
			'settings.quota.settings.dangerThreshold' => '위험 임계값 (%)',
			'settings.quota.settings.dangerThresholdHint' => '이 값 이상의 판독값은 빨간색으로 표시됩니다.',
			'settings.quota.settings.routingSection' => '라우팅',
			'settings.quota.settings.routingSectionHint' => '패널이 여유가 가장 많은 계정으로 작업을 옮기는 방식.',
			'settings.quota.settings.routing.manual' => '수동',
			'settings.quota.settings.routing.manualHint' => '권장만 표시하고 계정을 자동 전환하지 않습니다.',
			'settings.quota.settings.routing.ask' => '전환 전 확인',
			'settings.quota.settings.routing.askHint' => '전환이 제안되고 승인을 기다립니다.',
			'settings.quota.settings.routing.autoLowRisk' => '저위험 작업 자동',
			'settings.quota.settings.routing.autoLowRiskHint' => '저위험으로 표시된 작업만 자동으로 이동할 수 있습니다.',
			'settings.quota.settings.routingNote' => '계정 전환은 비용과 모델 품질을 변경하므로 항상 명시적 결정이 필요합니다.',
			'settings.quota.settings.accountsSection' => '폴링된 계정',
			'settings.quota.settings.accountsSectionHint' => '자격 증명은 각 도구에서 읽습니다. 패널이 다른 곳으로 보내지 않습니다.',
			'settings.quota.settings.sourcesSection' => '데이터 소스',
			'settings.quota.settings.sourcesSectionHint' => '사용량 및 비용 수치의 출처.',
			'settings.quota.settings.logSources' => '토큰 및 비용 로그 저장소',
			'settings.quota.settings.logSourcesHint' => 'tokboard 수집기와 공유되는 읽기 전용 집계 저장소.',
			'settings.quota.settings.readOnly' => '읽기 전용',
			'settings.quota.settings.quotaConsent' => '쿼터 폴링',
			'settings.quota.settings.quotaConsentHint' => '로컬에 저장된 자격 증명으로 제공자 쿼터 엔드포인트를 읽습니다.',
			'settings.quota.settings.localOnly' => '로컬 전용',
			'settings.quota.empty.description' => '아직 감지된 계정이 없습니다.',
			'settings.quota.quality.cached' => '캐시됨',
			'settings.quota.quality.error' => '오류',
			'settings.quota.quality.estimate' => '추정',
			'settings.quota.quality.live' => '실시간',
			'settings.quota.quality.unknown' => '알 수 없음',
			'settings.quota.syncFailed' => '동기화 실패',
			'settings.quota.syncNow' => '지금 동기화',
			'settings.browser.checking' => '확인 중...',
			'settings.browser.description' => '에이전트가 Browser 탭에서 모니터링할 수 있는 관리형 Playwright 브라우저 세션을 만들 수 있도록 허용합니다.',
			'settings.browser.enableDescription' => '지원되는 에이전트에 Browser를 등록합니다. 에이전트는 브라우저 세션을 만들 수 있으며, 사용자는 이를 보고, 중지하고, 삭제할 수 있습니다.',
			'settings.browser.enableLabel' => 'Browser 활성화',
			'settings.browser.errors.installRuntime' => '브라우저 런타임 설치 실패',
			'settings.browser.errors.loadSettings' => 'Browser 설정 로드 실패',
			'settings.browser.errors.loadStatus' => 'Browser 상태 로드 실패',
			'settings.browser.errors.saveSettings' => 'Browser 설정 저장 실패',
			'settings.browser.installHint' => '에이전트가 Browser 세션을 만들기 전에 브라우저 런타임을 설치하세요.',
			'settings.browser.installRuntime' => '런타임 설치',
			'settings.browser.installed' => '설치됨',
			'settings.browser.installing' => '설치 중...',
			'settings.browser.missing' => '없음',
			'settings.browser.runtimeRequired' => '브라우저 런타임 필요',
			'settings.browser.statusDisabled' => '비활성화됨',
			'settings.browser.statusLabel' => '상태',
			'settings.browser.statusReady' => '준비됨',
			'settings.browser.statusSetupRequired' => '설정 필요',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => '취소',
			_ => null,
		} ?? switch (path) {
			'settings.workspaces.create' => '작업 영역 추가',
			'settings.workspaces.deleteConfirm' => '이 작업 영역을 ddagent에서 제거하시겠습니까? 파일은 디스크에 남습니다.',
			'settings.workspaces.deleteFailed' => '작업 영역 제거에 실패했습니다.',
			'settings.workspaces.deleteTitle' => '작업 영역 제거',
			'settings.workspaces.description' => '작업 영역은 ddagent가 채팅하고, 코드를 실행하고, 탐색할 수 있는 디렉터리입니다.',
			'settings.workspaces.remove' => '작업 영역 제거',
			'settings.workspaces.title' => '작업 영역',
			'settings.about.supportTitle' => '프로젝트 후원하기',
			'settings.about.buyMeACoffee' => '커피 한 잔 사주기',
			'sidebar.projects.title' => '프로젝트',
			'sidebar.projects.newProject' => '새 프로젝트',
			'sidebar.projects.deleteProject' => '프로젝트 제거',
			'sidebar.projects.renameProject' => '프로젝트 이름 변경',
			'sidebar.projects.noProjects' => '프로젝트가 없습니다',
			'sidebar.projects.loadingProjects' => '프로젝트 로딩 중...',
			'sidebar.projects.searchPlaceholder' => '프로젝트 검색...',
			'sidebar.projects.projectNamePlaceholder' => '프로젝트 이름',
			'sidebar.projects.starred' => '즐겨찾기',
			'sidebar.projects.all' => '전체',
			'sidebar.projects.untitledSession' => '제목 없는 세션',
			'sidebar.projects.newSession' => '새 세션',
			'sidebar.projects.codexSession' => 'Codex 세션',
			'sidebar.projects.fetchingProjects' => 'Claude 프로젝트와 세션을 가져오는 중',
			'sidebar.projects.projects' => '프로젝트',
			'sidebar.projects.noMatchingProjects' => '일치하는 프로젝트 없음',
			'sidebar.projects.tryDifferentSearch' => '검색어를 변경해보세요',
			'sidebar.projects.runClaudeCli' => '프로젝트 디렉토리에서 Claude CLI를 실행하여 시작하세요',
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'AI 코딩 어시스턴트 UI',
			'sidebar.sessions.title' => '세션',
			'sidebar.sessions.newSession' => '새 세션',
			'sidebar.sessions.deleteSession' => '세션 삭제',
			'sidebar.sessions.renameSession' => '세션 이름 변경',
			'sidebar.sessions.noSessions' => '세션이 없습니다',
			'sidebar.sessions.loadingSessions' => '세션 로딩 중...',
			'sidebar.sessions.unnamed' => '이름 없음',
			'sidebar.sessions.loading' => '로딩 중...',
			'sidebar.sessions.showMore' => '더 많은 세션 보기',
			'sidebar.sessions.selectMode' => '선택',
			'sidebar.sessions.selectAll' => '모두 선택',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => '보관 (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => '삭제 (${count})',
			'sidebar.sessions.cancelSelection' => '선택 취소',
			'sidebar.sessions.toggleSelection' => '세션 선택 전환',
			'sidebar.sessions.selectionToolbar' => '세션 선택 작업',
			'sidebar.sessions.options' => '세션 옵션',
			'sidebar.sessions.pinSession' => '세션 고정',
			'sidebar.sessions.unpinSession' => '세션 고정 해제',
			'sidebar.sessions.pinned' => '고정된 세션',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '${count}개 선택됨', other: '${count}개 선택됨', ), 
			'sidebar.tooltips.viewEnvironments' => '환경 보기',
			'sidebar.tooltips.hideSidebar' => '사이드바 숨기기',
			'sidebar.tooltips.createProject' => '새 프로젝트 생성',
			'sidebar.tooltips.refresh' => '프로젝트 및 세션 새로고침 (Ctrl+R)',
			'sidebar.tooltips.renameProject' => '프로젝트 이름 변경 (F2)',
			'sidebar.tooltips.deleteProject' => '사이드바에서 프로젝트 제거 (Delete)',
			'sidebar.tooltips.addToFavorites' => '즐겨찾기에 추가',
			'sidebar.tooltips.removeFromFavorites' => '즐겨찾기에서 제거',
			'sidebar.tooltips.editSessionName' => '세션 이름 직접 편집',
			'sidebar.tooltips.deleteSession' => '이 세션 영구 삭제',
			'sidebar.tooltips.activeSessionIndicator' => '최근 활성 세션 (지난 10분)',
			'sidebar.tooltips.save' => '저장',
			'sidebar.tooltips.cancel' => '취소',
			'sidebar.tooltips.clearSearch' => '검색 지우기',
			'sidebar.tooltips.openCommandPalette' => '명령 팔레트 열기',
			'sidebar.tooltips.attentionRequiredIndicator' => '세션에 주의가 필요합니다',
			'sidebar.tooltips.openSessions' => '세션 찾아보기',
			'sidebar.navigation.chat' => '채팅',
			'sidebar.navigation.files' => '파일',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => '터미널',
			'sidebar.navigation.tasks' => '작업',
			'sidebar.actions.refresh' => '새로고침',
			'sidebar.actions.settings' => '설정',
			'sidebar.actions.collapseAll' => '모두 접기',
			'sidebar.actions.expandAll' => '모두 펼치기',
			'sidebar.actions.cancel' => '취소',
			'sidebar.actions.save' => '저장',
			'sidebar.actions.delete' => '삭제',
			'sidebar.actions.rename' => '이름 변경',
			'sidebar.actions.joinCommunity' => '커뮤니티 참여',
			'sidebar.actions.reportIssue' => '문제 신고',
			'sidebar.actions.starOnGithub' => 'GitHub에서 스타',
			'sidebar.actions.buyMeACoffee' => '커피 한 잔 사주기',
			'sidebar.branding.openSource' => '오픈 소스',
			'sidebar.status.active' => '활성',
			'sidebar.status.inactive' => '비활성',
			'sidebar.status.thinking' => '생각 중...',
			'sidebar.status.error' => '오류',
			'sidebar.status.aborted' => '중단됨',
			'sidebar.status.unknown' => '알 수 없음',
			'sidebar.time.justNow' => '방금 전',
			'sidebar.time.oneMinuteAgo' => '1분 전',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count}분 전',
			'sidebar.time.oneHourAgo' => '1시간 전',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count}시간 전',
			'sidebar.time.oneDayAgo' => '1일 전',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count}일 전',
			'sidebar.messages.deleteConfirm' => '정말 삭제하시겠습니까?',
			'sidebar.messages.renameSuccess' => '이름이 변경되었습니다',
			'sidebar.messages.deleteSuccess' => '삭제되었습니다',
			'sidebar.messages.errorOccurred' => '오류가 발생했습니다',
			'sidebar.messages.deleteSessionConfirm' => '이 세션을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.',
			'sidebar.messages.deleteProjectConfirm' => '사이드바에서 이 프로젝트를 제거하시겠습니까? 프로젝트 파일, 메모리 및 세션 데이터는 삭제되지 않습니다.',
			'sidebar.messages.enterProjectPath' => '프로젝트 경로를 입력해주세요',
			'sidebar.messages.deleteSessionFailed' => '세션 삭제 실패. 다시 시도해주세요.',
			'sidebar.messages.deleteSessionError' => '세션 삭제 오류. 다시 시도해주세요.',
			'sidebar.messages.renameSessionFailed' => '세션 이름 변경 실패. 다시 시도해주세요.',
			'sidebar.messages.renameSessionError' => '세션 이름 변경 오류. 다시 시도해주세요.',
			'sidebar.messages.deleteProjectFailed' => '프로젝트 제거 실패. 다시 시도해주세요.',
			'sidebar.messages.deleteProjectError' => '프로젝트 제거 오류. 다시 시도해주세요.',
			'sidebar.messages.createProjectFailed' => '프로젝트 생성 실패. 다시 시도해주세요.',
			'sidebar.messages.createProjectError' => '프로젝트 생성 오류. 다시 시도해주세요.',
			'sidebar.messages.updateProjectError' => '프로젝트 업데이트 오류. 다시 시도해주세요.',
			'sidebar.messages.refreshError' => '새로고침 실패. 다시 시도해주세요.',
			'sidebar.messages.restoreProjectFailed' => '프로젝트 복원 실패. 다시 시도해주세요.',
			'sidebar.messages.restoreProjectError' => '프로젝트 복원 오류. 다시 시도해주세요.',
			'sidebar.messages.restoreSessionFailed' => '세션 복원 실패. 다시 시도해주세요.',
			'sidebar.messages.restoreSessionError' => '세션 복원 오류. 다시 시도해주세요.',
			'sidebar.messages.changeWorkspaceFailed' => '작업 영역 변경에 실패했습니다. 다시 시도하세요.',
			'sidebar.messages.changeWorkspaceError' => '작업 영역 변경 중 오류가 발생했습니다. 다시 시도하세요.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '${count}개 세션을 삭제하지 못했습니다. 다시 시도하세요.', other: '${count}개 세션을 삭제하지 못했습니다. 다시 시도하세요.', ), 
			'sidebar.version.updateAvailable' => '업데이트 가능',
			'sidebar.version.restartRequired' => '업데이트가 설치됨 — 적용하려면 서버를 재시작하세요',
			'sidebar.version.updateNow' => '지금 업데이트',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'ddagent를 v${version}(으)로 업데이트할까요? 최신 코드를 받아 빌드한 뒤 서버가 재시작됩니다 — 활성 세션은 중단됩니다.',
			'sidebar.version.updating' => '업데이트 중… 몇 분 걸릴 수 있습니다',
			'sidebar.version.restarting' => '업데이트 설치됨 — 재시작 중…',
			'sidebar.version.updateFailed' => '업데이트 실패',
			'sidebar.version.releaseNotes' => '릴리스 노트',
			'sidebar.search.modeProjects' => '프로젝트',
			'sidebar.search.modeConversations' => '대화',
			'sidebar.search.conversationsPlaceholder' => '대화 내용 검색...',
			'sidebar.search.searching' => '검색 중...',
			'sidebar.search.sessionTitles' => '세션 제목',
			'sidebar.search.conversationContents' => '대화 내용',
			'sidebar.search.noResults' => '결과를 찾을 수 없습니다',
			'sidebar.search.tryDifferentQuery' => '다른 검색어로 시도해보세요',
			'sidebar.search.modeRunning' => '실행 중',
			'sidebar.search.archiveOnly' => '보관함',
			'sidebar.search.runningTooltip' => '실행 중인 세션',
			'sidebar.search.archiveOnlyTooltip' => '보관함만',
			'sidebar.search.runningCount' => ({required Object count}) => '${count}개 활성',
			'sidebar.search.viewMenu' => '보기',
			'sidebar.search.backToProjects' => '프로젝트로 돌아가기',
			'sidebar.search.archivedPlaceholder' => '보관된 세션 검색...',
			'sidebar.search.runningPlaceholder' => '실행 중인 세션 검색...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '${count}개 일치', other: '${count}개 일치', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '프로젝트 ${count}개 검색됨', other: '프로젝트 ${count}개 검색됨', ), 
			'sidebar.deleteConfirmation.deleteProject' => '프로젝트 제거',
			'sidebar.deleteConfirmation.deleteSession' => '세션 삭제',
			'sidebar.deleteConfirmation.confirmDelete' => '이 프로젝트를 어떻게 하시겠습니까:',
			'sidebar.deleteConfirmation.removeFromSidebar' => '사이드바에서만 제거',
			'sidebar.deleteConfirmation.deleteAllData' => '모든 데이터 영구 삭제',
			'sidebar.deleteConfirmation.allConversationsDeleted' => '프로젝트가 사이드바에서 제거됩니다. 파일, 메모리 및 세션 데이터는 보존됩니다.',
			'sidebar.deleteConfirmation.cannotUndo' => '나중에 프로젝트를 다시 추가할 수 있습니다.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => '보관은 선택한 세션을 활성 목록에서 숨기면서 기록을 유지합니다.',
			'sidebar.deleteConfirmation.archiveSession' => '세션 보관',
			'sidebar.deleteConfirmation.archiveSessionNotice' => '보관은 기록을 유지하면서 세션을 활성 목록에서 제외합니다.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => '이 세션은 이미 보관되어 있습니다. 숨긴 채로 두거나 영구 삭제할 수 있습니다.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => '세션과 트랜스크립트를 영구적으로 제거합니다. 이 작업은 되돌릴 수 없습니다.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => '영구 삭제',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '이 프로젝트에는 ${count}개의 대화가 있습니다.', other: '이 프로젝트에는 ${count}개의 대화가 있습니다.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '선택한 세션 관리', other: '선택한 ${count}개 세션 관리', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ko'))(count, one: '세션 보관', other: '${count}개 세션 보관', ), 
			'sidebar.zones.activeNow' => '지금 활성',
			'sidebar.zones.recent' => '최근 사용',
			'sidebar.zones.today' => '오늘',
			'sidebar.zones.yesterday' => '어제',
			'sidebar.zones.thisWeek' => '이번 주',
			'sidebar.zones.showMore' => ({required Object count}) => '${count}개 더 보기',
			'sidebar.zones.showLess' => '간단히 보기',
			'sidebar.panel.open' => '패널',
			'sidebar.panel.newChat' => '새 채팅',
			'sidebar.panel.navigation' => '탐색',
			'sidebar.panel.sessions' => '세션',
			'sidebar.workspace.title' => '세션 작업 영역 변경',
			'sidebar.workspace.description' => '에이전트가 이 디렉터리에서 다음 턴을 실행합니다. 기존 세션 기록은 유지됩니다.',
			'sidebar.workspace.pathLabel' => '작업 영역 경로',
			'sidebar.workspace.pathRequired' => '작업 영역 경로가 필요합니다.',
			'sidebar.workspace.submit' => '작업 영역 변경',
			'sidebar.workspace.saving' => '변경 중…',
			'sidebar.workspace.changeAction' => '작업 영역 변경',
			'sidebar.recent.title' => '최근 대화',
			'sidebar.recent.emptyTitle' => '아직 대화 없음',
			'sidebar.recent.emptyDescription' => '가장 최근에 업데이트된 대화가 여기에 표시됩니다.',
			'sidebar.recent.loadFailed' => '최근 대화를 불러올 수 없습니다',
			'sidebar.recent.loadMore' => '이전 대화 불러오기',
			'sidebar.recent.loadingMore' => '더 불러오는 중...',
			'sidebar.tabs.board' => '에이전트 보드',
			'sidebar.tabs.files' => '파일',
			'sidebar.tabs.git' => '소스 컨트롤',
			'sidebar.tabs.tasks' => '작업',
			'sidebar.tabs.usage' => '쿼터 및 사용량',
			'tasks.notConfigured.title' => 'TaskMaster AI가 설정되지 않았습니다',
			'tasks.notConfigured.description' => 'TaskMaster는 AI 기반 지원으로 복잡한 프로젝트를 관리하기 쉬운 작업 단위로 나눠줍니다',
			'tasks.notConfigured.whatIsTitle' => '🎯 TaskMaster란?',
			'tasks.notConfigured.features.aiPowered' => 'AI 기반 작업 관리: 복잡한 프로젝트를 관리하기 쉬운 하위 작업으로 분할',
			'tasks.notConfigured.features.prdTemplates' => 'PRD 템플릿: 제품 요구사항 문서(PRD)로부터 작업 생성',
			'tasks.notConfigured.features.dependencyTracking' => '의존성 추적: 작업 간 관계와 실행 순서 파악',
			'tasks.notConfigured.features.progressVisualization' => '진행 상황 시각화: 칸반 보드와 상세한 작업 분석',
			'tasks.notConfigured.features.cliIntegration' => 'CLI 연동: 고급 워크플로우를 위한 taskmaster 명령어 사용',
			'tasks.notConfigured.initializeButton' => 'TaskMaster AI 초기화',
			'tasks.gettingStarted.title' => 'TaskMaster 시작하기',
			'tasks.gettingStarted.subtitle' => 'TaskMaster가 초기화되었습니다! 다음 단계를 안내합니다:',
			'tasks.gettingStarted.steps.createPRD.title' => '제품 요구사항 문서(PRD) 작성',
			'tasks.gettingStarted.steps.createPRD.description' => '프로젝트 아이디어를 정리하고 무엇을 만들고 싶은지 설명하는 PRD를 작성하세요.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'PRD 추가',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => '기존 PRD:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'PRD로부터 작업 생성',
			'tasks.gettingStarted.steps.generateTasks.description' => 'PRD가 준비되면 AI 어시스턴트에게 이를 분석해달라고 요청하세요. TaskMaster가 구현 세부사항과 함께 관리하기 쉬운 작업으로 자동 분할합니다.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => '작업 분석 및 확장',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'AI 어시스턴트에게 작업의 복잡도를 분석하고, 더 쉽게 구현할 수 있도록 상세한 하위 작업으로 확장해달라고 요청하세요.',
			'tasks.gettingStarted.steps.startBuilding.title' => '개발 시작',
			'tasks.gettingStarted.steps.startBuilding.description' => 'AI 어시스턴트에게 작업을 시작하고, 상태를 업데이트하고, 프로젝트가 진행됨에 따라 새 작업을 추가해달라고 요청하세요.',
			'tasks.gettingStarted.tip' => '💡 팁: PRD로 시작하면 TaskMaster의 AI 기반 작업 생성 기능을 최대한 활용할 수 있습니다',
			'tasks.setupModal.title' => 'TaskMaster 설정',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => '${projectName}용 대화형 CLI',
			'tasks.setupModal.willStart' => 'TaskMaster 초기화가 자동으로 시작됩니다',
			'tasks.setupModal.completed' => 'TaskMaster 설정이 완료되었습니다! 이제 이 창을 닫아도 됩니다.',
			'tasks.setupModal.closeButton' => '닫기',
			'tasks.setupModal.closeContinueButton' => '닫고 계속하기',
			'tasks.setupModal.closeTitle' => '닫기',
			'tasks.setupModal.description' => '이 프로젝트에 .taskmaster 폴더를 생성합니다. 외부 도구나 API 키가 필요 없으며 작업은 로컬에 저장됩니다.',
			'tasks.setupModal.initializeButton' => '초기화',
			'tasks.setupModal.initializing' => '초기화 중...',
			'tasks.helpGuide.title' => 'TaskMaster 시작하기',
			'tasks.helpGuide.subtitle' => '생산적인 작업 관리를 위한 가이드',
			'tasks.helpGuide.examples.parsePRD' => '💬 예시:\n"Claude Task Master로 새 프로젝트를 초기화했어요. .taskmaster/docs/prd.txt에 PRD가 있는데, 이를 분석해서 초기 작업을 설정하는 걸 도와줄 수 있나요?"',
			'tasks.helpGuide.examples.expandTask' => '💬 예시:\n"작업 5가 복잡해 보이는데, 하위 작업으로 나눠줄 수 있나요?"',
			'tasks.helpGuide.examples.addTask' => '💬 예시:\n"Cloudinary를 사용한 사용자 프로필 이미지 업로드 기능을 구현하는 새 작업을 추가해주세요. 가장 좋은 방법을 조사해주세요."',
			'tasks.helpGuide.moreExamples' => '더 많은 예시와 사용 패턴 보기 →',
			'tasks.helpGuide.proTips.title' => '💡 유용한 팁',
			'tasks.helpGuide.proTips.search' => '검색창을 사용해 특정 작업을 빠르게 찾으세요',
			'tasks.helpGuide.proTips.views' => '보기 전환 버튼으로 칸반, 목록, 그리드 보기를 전환하세요',
			'tasks.helpGuide.proTips.filters' => '필터를 사용해 특정 상태나 우선순위의 작업에 집중하세요',
			'tasks.helpGuide.proTips.details' => '작업을 클릭하면 상세 정보를 확인하고 하위 작업을 관리할 수 있습니다',
			'tasks.helpGuide.learnMore.title' => '📚 더 알아보기',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI는 개발자를 위한 고급 작업 관리 시스템입니다. 문서와 예시를 확인하고 프로젝트에 기여해보세요.',
			'tasks.helpGuide.learnMore.githubButton' => 'GitHub에서 보기',
			'tasks.helpGuide.closeTitle' => '닫기',
			'tasks.search.placeholder' => '작업 검색...',
			'tasks.filters.button' => '필터',
			'tasks.filters.status' => '상태',
			'tasks.filters.priority' => '우선순위',
			'tasks.filters.sortBy' => '정렬 기준',
			'tasks.filters.allStatuses' => '모든 상태',
			'tasks.filters.allPriorities' => '모든 우선순위',
			'tasks.filters.showing' => ({required Object total, required Object filtered}) => '${total}개 중 ${filtered}개 표시',
			'tasks.filters.clearFilters' => '필터 초기화',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => '상태',
			'tasks.sort.priority' => '우선순위',
			'tasks.sort.idAsc' => 'ID (오름차순)',
			'tasks.sort.idDesc' => 'ID (내림차순)',
			'tasks.sort.titleAsc' => '제목 (A-Z)',
			'tasks.sort.titleDesc' => '제목 (Z-A)',
			'tasks.sort.statusAsc' => '상태 (대기 우선)',
			'tasks.sort.statusDesc' => '상태 (완료 우선)',
			'tasks.sort.priorityAsc' => '우선순위 (높은 순)',
			'tasks.sort.priorityDesc' => '우선순위 (낮은 순)',
			'tasks.views.kanban' => '칸반 보기',
			'tasks.views.list' => '목록 보기',
			'tasks.views.grid' => '그리드 보기',
			'tasks.kanban.pending' => '📋 대기 중',
			'tasks.kanban.inProgress' => '🚀 진행 중',
			'tasks.kanban.review' => '👀 검토',
			'tasks.kanban.done' => '✅ 완료',
			'tasks.kanban.blocked' => '🚫 차단됨',
			'tasks.kanban.deferred' => '⏳ 보류',
			'tasks.kanban.cancelled' => '❌ 취소됨',
			'tasks.kanban.noTasksYet' => '아직 작업이 없습니다',
			'tasks.kanban.tasksWillAppear' => '작업이 여기에 표시됩니다',
			'tasks.kanban.moveTasksHere' => '시작하면 작업을 여기로 옮기세요',
			'tasks.kanban.completedTasksHere' => '완료된 작업이 여기에 표시됩니다',
			'tasks.kanban.statusTasksHere' => '이 상태의 작업이 여기에 표시됩니다',
			'tasks.buttons.help' => 'TaskMaster 시작 가이드',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => 'PRD 추가',
			'tasks.buttons.addTask' => '작업 추가',
			'tasks.buttons.createNewPRD' => '새 PRD 생성',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => 'PRD ${count}개 사용 가능',
			'tasks.prd.modified' => ({required Object date}) => '수정됨: ${date}',
			'tasks.statuses.pending' => '대기 중',
			'tasks.statuses.inProgress' => '진행 중',
			'tasks.statuses.done' => '완료',
			'tasks.statuses.blocked' => '차단됨',
			'tasks.statuses.deferred' => '보류',
			'tasks.statuses.cancelled' => '취소됨',
			'tasks.priorities.high' => '높음',
			'tasks.priorities.medium' => '중간',
			'tasks.priorities.low' => '낮음',
			'tasks.noMatchingTasks.title' => '필터와 일치하는 작업이 없습니다',
			'tasks.noMatchingTasks.description' => '검색어나 필터 조건을 조정해보세요.',
			'tasks.board.title' => '에이전트 보드',
			'tasks.board.subtitle' => '카드를 준비로 옮기면 에이전트가 처리합니다. 카드를 클릭하면 세션이 열립니다.',
			'tasks.board.newCard' => '새 카드',
			'tasks.board.addCard' => '카드 추가',
			'tasks.board.refresh' => '새로고침',
			'tasks.board.empty.title' => '아직 카드 없음',
			'tasks.board.empty.description' => '카드를 추가하고 작업을 설명한 후 준비로 드래그하면 에이전트가 작업을 시작합니다.',
			'tasks.board.columns.backlog' => '백로그',
			'tasks.board.columns.ready' => '시작 준비',
			'tasks.board.columns.working' => '작업 중',
			'tasks.board.columns.needsDecision' => '결정 필요',
			'tasks.board.columns.done' => '완료',
			'tasks.board.columns.archived' => '보관됨',
			'tasks.board.card.running' => '실행 중',
			'tasks.board.card.abort' => '중단',
			'tasks.board.card.delete' => '삭제',
			'tasks.board.card.openSession' => '세션 열기',
			'tasks.board.card.pullRequest' => '풀 리퀘스트',
			'tasks.board.dialog.createTitle' => '새 카드',
			'tasks.board.dialog.editTitle' => '카드 편집',
			'tasks.board.dialog.titleLabel' => '제목',
			'tasks.board.dialog.titlePlaceholder' => '에이전트가 무엇을 해야 하나요?',
			'tasks.board.dialog.descriptionLabel' => '설명',
			'tasks.board.dialog.descriptionPlaceholder' => '컨텍스트, 수용 기준, 링크 추가...',
			'tasks.board.dialog.cancel' => '취소',
			'tasks.board.dialog.save' => '저장',
			'tasks.board.noProject' => '먼저 프로젝트를 추가한 다음 카드를 만드세요.',
			'tasks.board.projectLabel' => '프로젝트',
			'tasks.board.backToChat' => '채팅으로 돌아가기',
			'tasks.board.agent.provider' => '에이전트',
			'tasks.board.agent.anyProvider' => '모든 에이전트',
			'tasks.board.agent.model' => '모델',
			'tasks.board.agent.defaultModel' => '기본 모델',
			'tasks.board.agent.effort' => '추론',
			'tasks.board.agent.defaultEffort' => '기본값',
			'tasks.board.agent.searchModel' => '모델 검색…',
			'tasks.board.agent.noModels' => '일치하는 모델 없음',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '"${cardTitle}"이(가) 영구적으로 삭제됩니다.',
			'tasks.board.deleteConfirm.title' => '카드를 삭제하시겠습니까?',
			'tasks.board.project' => '프로젝트',
			'tasks.card.dependsOnList' => ({required Object tasks}) => '종속: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => '작업 ${id}',
			'tasks.card.highPriority' => '높은 우선순위',
			'tasks.card.lowPriority' => '낮은 우선순위',
			'tasks.card.mediumPriority' => '중간 우선순위',
			'tasks.card.noPriority' => '우선순위 미설정',
			'tasks.card.parentTask' => ({required Object id}) => '작업 ${id}',
			'tasks.card.progressLabel' => '진행률:',
			'tasks.card.progressTooltip' => ({required Object total, required Object completed}) => '${total}개 하위 작업 중 ${completed}개 완료',
			'tasks.card.runTask' => '작업 실행',
			'tasks.card.runTaskAria' => ({required Object id}) => '작업 ${id} 실행',
			'tasks.card.statusTooltip' => ({required Object status}) => '상태: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => '작업 ID: ${id}',
			'tasks.card.taskInProgress' => '작업 진행 중',
			'tasks.createTask.cancel' => '취소',
			'tasks.createTask.descriptionLabel' => '설명',
			'tasks.createTask.descriptionPlaceholder' => '선택적 세부 정보',
			'tasks.createTask.error' => '작업 추가 실패',
			'tasks.createTask.priorityLabel' => '우선순위',
			'tasks.createTask.submit' => '작업 추가',
			'tasks.createTask.submitting' => '추가 중...',
			'tasks.createTask.title' => '작업 추가',
			'tasks.createTask.titleLabel' => '제목',
			'tasks.createTask.titlePlaceholder' => '무엇을 해야 하나요?',
			'tasks.list.completedReopen' => '완료됨 (클릭하여 다시 열기)',
			'tasks.list.inProgressComplete' => '진행 중 (클릭하여 완료)',
			'tasks.list.markCompleted' => '완료로 표시',
			'tasks.list.toggleStatusAria' => ({required Object id}) => '작업 ${id} 상태 전환',
			'tasks.nextTask.allComplete' => '모든 작업 완료',
			'tasks.nextTask.feature1' => '- 종속성 및 하위 작업을 지원하는 AI 작업 관리.',
			'tasks.nextTask.feature2' => '- PRD 기반 작업 생성으로 프로젝트 빠른 시작.',
			'tasks.nextTask.feature3' => '- 일상 작업을 위한 칸반 및 목록 보기.',
			'tasks.nextTask.hideDetails' => '세부 정보 숨기기',
			'tasks.nextTask.initialize' => '초기화',
			'tasks.nextTask.noPending' => '대기 중인 작업 없음',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI가 구성되지 않았습니다',
			'tasks.nextTask.review' => '검토',
			'tasks.nextTask.startTask' => '작업 시작',
			'tasks.nextTask.taskId' => ({required Object id}) => '작업 ${id}',
			'tasks.nextTask.viewAll' => '모든 작업 보기',
			'tasks.nextTask.viewDetails' => '작업 세부 정보 보기',
			'tasks.nextTask.whatIs' => 'TaskMaster란?',
			'tasks.taskDetail.cancelEdit' => '편집 취소',
			'tasks.taskDetail.close' => '닫기',
			'tasks.taskDetail.copyTaskId' => '작업 ID 복사',
			'tasks.taskDetail.delete' => '작업 삭제',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '"${title}"이(가) 영구적으로 삭제됩니다.',
			'tasks.taskDetail.deleteConfirmTitle' => '작업을 삭제하시겠습니까?',
			'tasks.taskDetail.deleteFailed' => '작업을 삭제하지 못했습니다',
			'tasks.taskDetail.dependencies' => '종속성',
			'tasks.taskDetail.dependenciesPlaceholder' => '예: 1, 2, 3',
			'tasks.taskDetail.description' => '설명',
			'tasks.taskDetail.edit' => '작업 편집',
			'tasks.taskDetail.implDetails' => '구현 세부 정보',
			'tasks.taskDetail.noDependencies' => '종속성 없음',
			'tasks.taskDetail.noDescription' => '설명 없음',
			'tasks.taskDetail.priority' => '우선순위',
			'tasks.taskDetail.priorityNotSet' => '설정되지 않음',
			'tasks.taskDetail.save' => '저장',
			'tasks.taskDetail.status' => '상태',
			'tasks.taskDetail.statusFailed' => '작업 상태 업데이트 실패',
			'tasks.taskDetail.taskId' => ({required Object id}) => '작업 ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => '작업 ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => '테스트 전략',
			'tasks.taskDetail.titleRequired' => '제목은 필수입니다',
			'tasks.taskDetail.updateFailed' => '작업 업데이트 실패',
			'knowledge.title' => '지식',
			'knowledge.tabs.dashboard' => '대시보드',
			'knowledge.tabs.memories' => '메모리',
			'knowledge.tabs.rules' => '규칙',
			'knowledge.tabs.skills' => '스킬',
			'knowledge.tabs.personal' => '개인정보',
			'knowledge.tabs.graph' => '그래프',
			'knowledge.common.add' => '추가',
			'knowledge.common.save' => '저장',
			'knowledge.common.cancel' => '취소',
			'knowledge.common.delete' => '삭제',
			'knowledge.common.edit' => '편집',
			'knowledge.common.close' => '닫기',
			'knowledge.common.restore' => '복원',
			'knowledge.common.refresh' => '새로고침',
			'knowledge.common.allProjects' => '모든 프로젝트',
			'knowledge.common.global' => '전역',
			'knowledge.actions.scan' => '프로젝트 파일 스캔',
			'knowledge.actions.export' => 'JSON 내보내기',
			'knowledge.actions.import' => 'JSON 가져오기',
			'knowledge.actions.scanComplete' => '스캔 완료',
			'knowledge.actions.importComplete' => '가져오기 완료',
			'knowledge.actions.importFailed' => '가져오기 실패',
			'knowledge.dialog.newEntity' => '새 항목',
			'knowledge.dialog.editEntity' => '항목 편집',
			'knowledge.dialog.deleteTitle' => '삭제',
			'knowledge.dialog.deleteMessage' => '이 항목을 삭제할까요? 되돌릴 수 없습니다(기록은 유지됨).',
			'knowledge.dialog.pickIcon' => '아이콘 선택',
			'knowledge.dialog.removeIcon' => '아이콘 제거',
			'knowledge.dialog.iconTooLarge' => '아이콘이 너무 큽니다(최대 40KB).',
			'knowledge.dialog.importTitle' => '지식 가져오기',
			'knowledge.dialog.importHint' => '내보낸 JSON을 여기에 붙여넣기',
			'knowledge.dialog.exportTitle' => '지식 내보내기',
			'knowledge.dialog.import' => '가져오기',
			'knowledge.fields.key' => '키',
			'knowledge.fields.title' => '제목',
			'knowledge.fields.name' => '이름',
			'knowledge.fields.description' => '설명',
			'knowledge.fields.category' => '카테고리',
			'knowledge.fields.content' => '내용',
			'knowledge.fields.priority' => '우선순위',
			'knowledge.fields.tags' => '태그',
			'knowledge.fields.enabled' => '활성화',
			'knowledge.fields.projectScope' => '프로젝트 범위',
			'knowledge.fields.tagsHint' => '쉼표로 구분',
			'knowledge.dashboard.memories' => '메모리',
			'knowledge.dashboard.rules' => '규칙',
			'knowledge.dashboard.skills' => '스킬',
			'knowledge.dashboard.personal' => '개인정보',
			'knowledge.dashboard.connections' => '연결',
			'knowledge.dashboard.recent' => '최근 메모리',
			'knowledge.dashboard.noMemories' => '메모리가 없습니다. 메모리 탭에서 추가하세요.',
			'knowledge.empty.memories' => '메모리가 없습니다.',
			'knowledge.empty.rules' => '규칙이 없습니다.',
			'knowledge.empty.skills' => '스킬이 없습니다.',
			'knowledge.empty.personal' => '개인정보가 없습니다.',
			'knowledge.empty.graph' => '그래프로 표시할 항목이 없습니다.',
			'knowledge.history.title' => '기록',
			'knowledge.history.none' => '기록이 없습니다.',
			'knowledge.history.untitled' => '(제목 없음)',
			'knowledge.priorities.critical' => '치명적',
			'knowledge.priorities.high' => '높음',
			'knowledge.priorities.normal' => '보통',
			'knowledge.priorities.low' => '낮음',
			'knowledge.search.title' => '지식 검색',
			'knowledge.search.hint' => '메모리, 규칙, 스킬 검색…',
			'knowledge.search.noResults' => '결과가 없습니다.',
			'knowledge.links.title' => '엔티티 연결',
			'knowledge.links.source' => '소스',
			'knowledge.links.target' => '대상',
			'knowledge.links.relationship' => '관계',
			'knowledge.links.add' => '연결 만들기',
			'knowledge.tags.all' => '모든 태그',
			'knowledge.tags.manage' => '태그 관리',
			'knowledge.tags.none' => '태그가 없습니다.',
			'knowledge.settings.description' => '에이전트를 위한 로컬 메모리 계층: 메모리, 규칙, 스킬, 개인정보.',
			_ => null,
		};
	}
}
