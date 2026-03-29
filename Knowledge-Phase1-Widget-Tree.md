# Knowledge Phase 1 - Widget Tree Documentation

This document describes the widget tree for all Knowledge Phase 1 screens and shared widgets, based on the current code in the repository.

## Scope

Screens:
1. KnowledgeSourceListScreen
2. AddSourceTypeScreen
3. WebSourceFormScreen
4. FileSourceFormScreen
5. GoogleDriveFormScreen
6. DatabaseFormScreen
7. CrawlIntervalConfigScreen

Shared widgets:
1. SourceTypeFilterBar
2. SourceListCard
3. SourceStatusBadge
4. CrawlIntervalGrid

## 1) KnowledgeSourceListScreen

File: lib/presentation/knowledge/knowledge_source_list_screen.dart

Purpose:
- Main screen for listing, filtering, and managing knowledge sources.
- Entry point to add source and configure crawl interval.

### Root widget tree

```text
KnowledgeSourceListScreen (StatefulWidget)
└── build()
    ├── body (SafeArea)
    │   └── Column
    │       ├── Header (Padding -> Row)
    │       │   ├── IconButton(menu) [conditional: onMenuTap != null]
    │       │   ├── Expanded(Text: "Nạp kiến thức")
    │       │   └── FilledButton.icon("Thêm nguồn") -> _openAddSource()
    │       ├── Observer
    │       │   └── SourceTypeFilterBar
    │       │       ├── selected: _store.selectedCategory
    │       │       └── onSelected: _store.filterByCategory
    │       └── Expanded
    │           └── Observer
    │               ├── loading + empty sources -> Center(CircularProgressIndicator)
    │               ├── error + empty sources -> _buildError()
    │               ├── no filteredSources -> _buildEmpty()
    │               └── RefreshIndicator(onRefresh: _store.loadSources)
    │                   └── ListView.builder
    │                       └── SourceListCard (per source)
    │                           ├── onConfigureInterval -> _configureInterval(source)
    │                           ├── onReindex -> _reindex(source)
    │                           └── onDelete -> _confirmDelete(source)
    └── if embedded == false
        └── Scaffold
            ├── appBar: AppBar("Nạp kiến thức")
            └── body: body
```

### State and dependencies

- Internal state:
  - Uses one store instance from DI: getIt<KnowledgeStore>().
- Inputs:
  - embedded: bool
  - onMenuTap: VoidCallback?
- Store observables consumed:
  - isLoading
  - sources
  - filteredSources
  - selectedCategory
  - errorMessage

### User actions

- Tap Add Source button:
  - showModalBottomSheet -> AddSourceTypeScreen(store: _store)
- Pull to refresh:
  - _store.loadSources()
- Tap Reindex:
  - _store.reindexSource(source.id)
  - show snackbar for reindex start
- Tap Configure Interval:
  - push CrawlIntervalConfigScreen(current: source.crawlInterval)
  - if new selection differs: _store.updateSourceCrawlInterval(source.id, selected)
  - show success/failure snackbar
- Tap Delete:
  - show confirmation dialog
  - if confirmed: _store.deleteSource(source.id)

### Mock state transitions

- initState -> _store.loadSources() -> Mock repository getSources()
- configure interval -> _store.updateSourceCrawlInterval() -> Mock repository updates in-memory source
- reindex -> _store.reindexSource() -> Mock repository updates status/lastSyncAt
- delete -> _store.deleteSource() -> Mock repository removes source

## 2) AddSourceTypeScreen

File: lib/presentation/knowledge/add_source/add_source_type_screen.dart

Purpose:
- Bottom sheet for selecting source type before opening the corresponding form screen.

### Root widget tree

```text
AddSourceTypeScreen (StatefulWidget)
└── Container (bottom-sheet style)
    └── Column(mainAxisSize: min)
        ├── Drag handle
        ├── Header (Row)
        │   ├── Text("Chọn nguồn tri thức")
        │   └── Icon(close) -> Navigator.pop
        ├── Divider
        ├── Flexible
        │   └── ListView.builder (source type options)
        │       └── GestureDetector(onTap: set _selectedIndex)
        │           └── AnimatedContainer (selected styling)
        │               └── Row
        │                   ├── icon container
        │                   └── Expanded(title + subtitle)
        ├── Divider
        └── Footer buttons (Row)
            ├── OutlinedButton("Đóng") -> Navigator.pop
            └── ElevatedButton("Tiếp theo") -> _goNext()
```

### State and dependencies

- Inputs:
  - store: KnowledgeStore
- Internal state:
  - _selectedIndex: int
  - _sourceTypes: static tuple list (icon, title, subtitle, color)

### User actions and navigation

- Select any source type card -> updates _selectedIndex
- Tap Next:
  - closes bottom sheet first (Navigator.pop)
  - opens one of these screens with the same store:
    - FileSourceFormScreen
    - WebSourceFormScreen
    - GoogleDriveFormScreen
    - DatabaseFormScreen

### Mock state transitions

- No direct data mutation here.
- This screen only routes to form screens where addSource/testConnection flows happen.

## 3) WebSourceFormScreen

File: lib/presentation/knowledge/add_source/web_source_form_screen.dart

Purpose:
- Add a web source (single page or full site) with crawl interval configuration.

### Root widget tree

```text
WebSourceFormScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── leading back button
    │   ├── title "Web"
    │   └── close button
    └── body: Form(_formKey)
        └── Column
            ├── Divider
            ├── Expanded
            │   └── SingleChildScrollView
            │       └── Column
            │           ├── URL label + TextFormField (validator)
            │           ├── Type label + _buildTypeToggle()
            │           │   ├── "Một trang" card
            │           │   └── "Toàn bộ" card
            │           ├── _buildInfoBox()
            │           └── CrawlIntervalGrid
            └── _buildBottomBar()
                ├── OutlinedButton("Đóng")
                └── ElevatedButton("Xác nhận" or loading)
```

### State and dependencies

- Inputs:
  - store: KnowledgeStore
- Internal state:
  - _urlController
  - _fullSite: bool
  - _crawlInterval: CrawlInterval
  - _isSaving: bool

### User actions

- Input URL (must start with http)
- Toggle type:
  - single page -> KnowledgeSourceType.webSingle
  - full site -> KnowledgeSourceType.webFull
- Select crawl interval via CrawlIntervalGrid
- Submit:
  - builds KnowledgeSource with status indexing
  - widget.store.addSource(source)
  - closes screen on success

### Mock state transitions

- addSource() -> store adds to observable list -> mock repository adds in-memory source with generated id and indexing status.

## 4) FileSourceFormScreen

File: lib/presentation/knowledge/add_source/file_source_form_screen.dart

Purpose:
- Add local file source using mock file picker behavior.

### Root widget tree

```text
FileSourceFormScreen (StatefulWidget)
└── Scaffold
    ├── AppBar (back, title, close)
    └── body: Column
        ├── Divider
        ├── Expanded
        │   └── SingleChildScrollView
        │       └── Column
        │           ├── Label "Tệp tin"
        │           ├── _buildFilePicker()
        │           ├── _buildSelectedFile() [conditional: _mockFileName != null]
        │           └── Supported format hint text
        └── _buildBottomBar()
            ├── OutlinedButton("Đóng")
            └── ElevatedButton("Xác nhận") [disabled if no file]
```

### State and dependencies

- Inputs:
  - store: KnowledgeStore
- Internal state:
  - _mockFileName: String?
  - _isSaving: bool

### User actions

- Tap picker area -> _mockPickFile() sets a mock filename
- Remove selected file via close icon
- Submit when file exists:
  - builds KnowledgeSource (type localFile, manual interval)
  - widget.store.addSource(source)
  - closes screen

### Mock state transitions

- addSource() writes new source into mock repository list.

## 5) GoogleDriveFormScreen

File: lib/presentation/knowledge/add_source/google_drive_form_screen.dart

Purpose:
- Add Google Drive source with required name + required folder/file selection.

### Root widget tree

```text
GoogleDriveFormScreen (StatefulWidget)
└── Scaffold
    ├── AppBar (back, title, close)
    └── body: Column
        ├── Divider
        ├── Expanded
        │   └── SingleChildScrollView
        │       └── Column
        │           ├── Name label + TextField
        │           ├── Name error text [conditional]
        │           ├── Drive item label + _buildFilePicker()
        │           │   ├── selected state card [if _selectedItem != null]
        │           │   └── picker container with Image.network fallback icon
        │           ├── File error text [conditional]
        │           ├── Note text
        │           └── CrawlIntervalGrid
        └── _buildBottomBar()
            ├── OutlinedButton("Đóng")
            └── ElevatedButton("Xác nhận" or loading)
```

### State and dependencies

- Inputs:
  - store: KnowledgeStore
- Internal state:
  - _nameController
  - _selectedItem: String?
  - _crawlInterval: CrawlInterval
  - _isSaving: bool
  - _nameError: bool
  - _fileError: bool

### User actions

- Enter source name (required)
- Tap picker -> _mockPickItem() sets "Helpdesk Docs"
- Remove selected item with close icon
- Choose crawl interval
- Submit:
  - validates required name + selected item
  - builds KnowledgeSource (type googleDrive)
  - widget.store.addSource(source)
  - closes screen

### Mock state transitions

- addSource() updates in-memory source list in mock repository.

## 6) DatabaseFormScreen

File: lib/presentation/knowledge/add_source/database_form_screen.dart

Purpose:
- 2-step form for database source creation.
- Includes mock DB connection test flow wired through KnowledgeStore.

### Root widget tree

```text
DatabaseFormScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── leading back button
    │   │   ├── if step 2: go back to step 1 + resetConnectionTest()
    │   │   └── if step 1: Navigator.pop
    │   ├── title "Truy vấn CSDL"
    │   └── close button
    └── body: Column
        ├── Divider
        ├── Expanded
        │   ├── _buildStep1() when _step == 1
        │   │   └── SingleChildScrollView
        │   │       └── Column
        │   │           ├── Name TextField (+ error)
        │   │           └── CrawlIntervalGrid
        │   └── _buildStep2(l10n) when _step == 2
        │       └── SingleChildScrollView
        │           └── Column
        │               ├── Dropdown (manual/daily/weekly/monthly display)
        │               ├── Host + Port fields
        │               ├── Database + DB type dropdown
        │               ├── Username + Password fields
        │               ├── SQL TextField
        │               ├── Observer
        │               │   └── OutlinedButton.icon(Test connection)
        │               └── _buildConnectionStatusBanner(l10n)
        │                   └── Observer
        │                       ├── isTesting -> blue testing banner
        │                       ├── success -> green banner
        │                       ├── failure -> red banner
        │                       └── null -> SizedBox.shrink
        └── _buildBottomBar()
            ├── OutlinedButton("Đóng")
            └── ElevatedButton("Tiếp theo")
                ├── step 1 -> _goToStep2()
                └── step 2 -> _submit()
```

### State and dependencies

- Inputs:
  - store: KnowledgeStore
- Internal state:
  - Step management: _step (1/2)
  - Step 1 fields: _nameController, _crawlInterval, _nameError
  - Step 2 fields: host/port/database/username/password/sql controllers
  - _dbType, _obscurePassword
  - _isSaving
- Store observables consumed via Observer:
  - isTesting
  - connectionTestSuccess

### User actions

- Step 1:
  - enter source name
  - select crawl interval
  - next validates non-empty name
- Step 2:
  - fill DB connection fields and SQL
  - toggle password visibility
  - change DB type
  - test connection button:
    - disabled while store.isTesting
    - calls store.testConnection(_buildConnectionConfig())
  - any connection config change triggers _onConnectionConfigChanged():
    - if previous test result exists, resetConnectionTest()
  - submit creates KnowledgeSource and calls store.addSource(source)

### Mock state transitions

- testConnection(config):
  - store sets isTesting=true and connectionTestSuccess=null
  - mock repository returns success when host is non-empty
  - UI banner updates through Observer
- addSource() appends new DB source to in-memory list.

## 7) CrawlIntervalConfigScreen

File: lib/presentation/knowledge/config/crawl_interval_config_screen.dart

Purpose:
- Screen for selecting and returning crawl interval for an existing source.

### Root widget tree

```text
CrawlIntervalConfigScreen (StatefulWidget)
└── Scaffold
    ├── AppBar
    │   ├── title "Cấu hình tần suất đồng bộ"
    │   └── TextButton("Lưu") -> Navigator.pop(context, _selected)
    └── body: Column
        ├── Info banner container
        ├── Expanded
        │   └── ListView.separated (options)
        │       └── GestureDetector
        │           └── AnimatedContainer
        │               └── Row
        │                   ├── icon container
        │                   ├── Expanded(title + desc)
        │                   └── Radio<CrawlInterval>
        └── Bottom confirm button
            └── ElevatedButton("Xác nhận") -> Navigator.pop(context, _selected)
```

### State and dependencies

- Inputs:
  - current: CrawlInterval
- Internal state:
  - _selected (initialized from current in initState)

### User actions and transitions

- Tap option card or radio -> update _selected
- Tap Save or Confirm -> returns selected interval to caller via Navigator.pop result
- Caller (KnowledgeSourceListScreen) applies update through store/usecase/repository.

## Shared Widgets

## A) SourceTypeFilterBar

File: lib/presentation/knowledge/widgets/source_type_filter_bar.dart

Purpose:
- Horizontal category chips for source filtering.

### Widget tree

```text
SourceTypeFilterBar (StatelessWidget)
└── SizedBox(height: 36)
    └── ListView.separated(horizontal)
        └── GestureDetector(onTap: onSelected(category))
            └── AnimatedContainer(selected/unselected styles)
                └── Row(icon + label)
```

### Props and behavior

- Props:
  - selected: String?
  - onSelected: ValueChanged<String?>
- Filter values:
  - null (all), file, web, drive, db
- Stateless component; selection visuals are derived from selected prop.

## B) SourceListCard

File: lib/presentation/knowledge/widgets/source_list_card.dart

Purpose:
- Render one source item with metadata, status badge, and management actions.

### Widget tree

```text
SourceListCard (StatelessWidget)
└── Card
    └── Padding
        └── Column
            ├── Row
            │   ├── _TypeIcon(type)
            │   ├── Expanded(Text(source.name))
            │   └── SourceStatusBadge(status: source.status)
            ├── Row (metadata)
            │   ├── last sync icon + formatted datetime
            │   └── interval icon + _intervalLabel(source.crawlInterval)
            ├── Divider
            └── Row(actions)
                ├── TextButton.icon("Cấu hình tần suất") -> onConfigureInterval
                ├── TextButton.icon("Reindex") -> onReindex
                └── TextButton.icon("Xóa") -> onDelete
```

### Props and behavior

- Props:
  - source: KnowledgeSource
  - onConfigureInterval: VoidCallback
  - onReindex: VoidCallback
  - onDelete: VoidCallback
- Internal helpers:
  - _formatDateTime(DateTime)
  - _intervalLabel(CrawlInterval)
- Child private widget _TypeIcon maps source type to icon and color.

## C) SourceStatusBadge

File: lib/presentation/knowledge/widgets/source_status_badge.dart

Purpose:
- Compact status indicator for source state.

### Widget tree

```text
SourceStatusBadge (StatelessWidget)
└── Container (pill)
    └── Row
        ├── if indexing: CircularProgressIndicator
        ├── else: Icon(_icon)
        └── Text(_label)
```

### Props and behavior

- Prop:
  - status: KnowledgeSourceStatus
- Mapping:
  - active -> green + check icon + "Hoạt động"
  - indexing -> purple + spinner + "Đang đồng bộ"
  - error -> red + error icon + "Lỗi"

## D) CrawlIntervalGrid

File: lib/presentation/knowledge/widgets/crawl_interval_grid.dart

Purpose:
- Reusable interval picker used in multiple add-source forms.

### Widget tree

```text
CrawlIntervalGrid (StatelessWidget)
└── GridView.count(crossAxisCount: 2, non-scrollable)
    └── for each option
        └── GestureDetector(onTap: onSelected(interval))
            └── AnimatedContainer(selected/unselected)
                └── Column
                    ├── title
                    └── subtitle
```

### Props and behavior

- Props:
  - selected: CrawlInterval
  - onSelected: ValueChanged<CrawlInterval>
- Options rendered by this widget:
  - manual, daily, weekly, monthly

## End-to-End Mock Data Flow (Phase 1)

```text
UI Screen / Widget action
-> KnowledgeStore action
-> UseCase
-> KnowledgeRepository (MockKnowledgeRepositoryImpl)
-> in-memory list mutation / boolean result
-> MobX observable update
-> Observer rebuild in UI
```

Key flows:
1. Add source:
   - form submit -> addSource() -> new source appended.
2. Delete source:
   - confirm delete -> deleteSource() -> source removed.
3. Reindex source:
   - reindex action -> reindexSource() -> status/index timestamp updated.
4. Update crawl interval for existing source:
   - configure interval -> updateSourceCrawlInterval() -> source item interval updated.
5. Test DB connection:
   - test connection -> testConnection() -> isTesting and connectionTestSuccess drive status banners.

## Notes

- All flows above are currently offline/mock behavior.
- Database test result rule in mock repository:
  - success when connectionConfig.host is non-empty.
- Crawl interval update in source list is immediate in UI after store update.
