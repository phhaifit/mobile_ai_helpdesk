# Plan: AI Agent Management + Chat Playground

**Branch:** `feature/12-ai-agent-system`  
**Scope:** Full UI + offline simulation — tất cả tầng đều được implement, data source là mock offline.

---

## Overview

Implement đầy đủ hai feature module:

1. **AI Agent Management** — CRUD screens, cấu hình agent, publish lên nhiều nền tảng
2. **AI Chat Playground** — Giao diện chat mock, streaming simulation, session management

Tất cả data là mock offline. Không gọi AI/LLM thật. Kiến trúc theo Clean Architecture + MobX đang có trong codebase.

---

## New Dependencies (pubspec.yaml)

| Package | Mục đích |
|---|---|
| `flutter_markdown: ^0.7.x` | Render markdown trong playground chat bubbles |
| `file_picker: ^8.x` | UI chọn file đính kèm (không upload thật) |

---

## Phase 1 — Domain Layer

### Entities

| File | Fields |
|---|---|
| `lib/domain/entity/ai_agent/ai_agent.dart` | id, name, description, avatarUrl, mode (enum: auto/semiAuto), platforms (List\<String\>), workflows (List\<String\>), teamId, createdAt — `@JsonSerializable` |
| `lib/domain/entity/playground/playground_session.dart` | id, agentId, contextType (enum: lazada/normal), messages (List\<PlaygroundMessage\>), createdAt — `@JsonSerializable` |
| `lib/domain/entity/playground/playground_message.dart` | id, content, role (enum: user/assistant), isStreaming, attachments (List\<String\>), timestamp — `@JsonSerializable` |

> Chạy `build_runner` sau khi tạo entities.

### Repository Interfaces

**`lib/domain/repository/ai_agent/ai_agent_repository.dart`**
```dart
abstract class AiAgentRepository {
  Future<Either<Failure, List<AiAgent>>> getAgents();
  Future<Either<Failure, AiAgent>> getAgent(String id);
  Future<Either<Failure, AiAgent>> createAgent(AiAgent agent);
  Future<Either<Failure, AiAgent>> updateAgent(AiAgent agent);
  Future<Either<Failure, void>> deleteAgent(String id);
}
```

**`lib/domain/repository/playground/playground_repository.dart`**
```dart
abstract class PlaygroundRepository {
  Future<Either<Failure, List<PlaygroundSession>>> getSessions();
  Future<Either<Failure, PlaygroundSession>> getSession(String id);
  Future<Either<Failure, PlaygroundSession>> createSession(PlaygroundContextType contextType);
  Future<Either<Failure, PlaygroundMessage>> sendMessage(String sessionId, String content, List<String> attachments);
}
```

### Use Cases

**AI Agent** (`lib/domain/usecase/ai_agent/`):
- `get_agents_usecase.dart`
- `get_agent_usecase.dart`
- `create_agent_usecase.dart`
- `update_agent_usecase.dart`
- `delete_agent_usecase.dart`

**Playground** (`lib/domain/usecase/playground/`):
- `get_sessions_usecase.dart`
- `create_session_usecase.dart`
- `send_playground_message_usecase.dart`

---

## Phase 2 — Data Layer

### Mock DataSources

**`lib/data/local/datasources/ai_agent/ai_agent_datasource.dart`**
- Trả về 3–5 mock agents với varied platforms, modes, workflows
- Hỗ trợ CRUD in-memory

**`lib/data/local/datasources/playground/playground_datasource.dart`**
- Mock sessions (2–3 sessions cũ)
- Mock AI response generator theo context:
  - **Lazada context**: Trả lời về đơn hàng, giao vận, hoàn trả
  - **Normal context**: Trả lời support chung

### Repository Implementations

- `lib/data/repository/ai_agent/mock_ai_agent_repository_impl.dart` — delegate sang `AiAgentDataSource`
- `lib/data/repository/playground/playground_repository_impl.dart` — delegate sang `PlaygroundDataSource`

### Endpoints (stub only)

Thêm vào `lib/data/network/constants/endpoints.dart`:
```dart
static String agents() => '/api/agents';
static String agent(String id) => '/api/agents/$id';
static String playgroundSessions() => '/api/playground/sessions';
```
*(Không dùng thật, chỉ định nghĩa để giữ đúng pattern)*

---

## Phase 3 — Presentation Layer: MobX Stores

### AiAgentStore

**`lib/presentation/ai_agent/store/ai_agent_store.dart`**

```
@observable  agentList: ObservableList<AiAgent>
@observable  selectedAgent: AiAgent?
@observable  errorMessage: String?
@observable  fetchFuture: ObservableFuture<void>
@computed    isLoading: bool

@action fetchAgents()
@action fetchAgent(String id)
@action createAgent(AiAgent agent)
@action updateAgent(AiAgent agent)
@action deleteAgent(String id)
```

### PlaygroundStore

**`lib/presentation/playground/store/playground_store.dart`**

```
@observable  sessions: ObservableList<PlaygroundSession>
@observable  currentSession: PlaygroundSession?
@observable  messages: ObservableList<PlaygroundMessage>
@observable  isStreaming: bool
@observable  isTyping: bool
@observable  contextType: PlaygroundContextType
@observable  errorMessage: String?
@observable  fetchFuture: ObservableFuture<void>
@computed    isLoading: bool

@action fetchSessions()
@action createSession()
@action sendMessage(String content, List<String> attachments)
@action editMessage(String messageId, String newContent)
@action newSession()
@action setContextType(PlaygroundContextType type)
```

**Streaming simulation:**
```dart
// Trong sendMessage():
// 1. Thêm message tạm với isStreaming = true
// 2. Timer.periodic(50ms) append từng ký tự của mock response
// 3. Sau khi xong, set isStreaming = false
```

> Chạy `build_runner` sau khi tạo stores.

---

## Phase 4 — UI Screens: AI Agent Management

### Screen 1: Agent List

**File:** `lib/presentation/ai_agent/agent_list_screen.dart`  
**Route:** `/ai-agents`

**Widget tree:**
```
Scaffold
├── AppBar (title: "AI Agents", actions: [team assistant icon])
├── Body
│   └── ListView.builder
│       └── AgentCard (per agent)
│           ├── CircleAvatar (avatarUrl / initials fallback)
│           ├── Column
│           │   ├── Text(name)
│           │   ├── Text(description, maxLines: 1)
│           │   └── Row
│           │       ├── ModeBadge (Auto / Semi-auto chip)
│           │       └── PlatformIcons (Slack, Telegram, Messenger icons)
│           └── PopupMenuButton (Edit, Delete)
└── FloatingActionButton (+ Create Agent)
```

### Screen 2: Agent Create / Edit

**File:** `lib/presentation/ai_agent/agent_create_edit_screen.dart`  
**Route:** `/ai-agents/create`, `/ai-agents/edit` (args: AiAgent?)

**Widget tree:**
```
Scaffold
├── AppBar (title: "Create Agent" / "Edit Agent")
└── SingleChildScrollView
    └── Form
        ├── AvatarPicker (CircleAvatar + edit icon, UI only)
        ├── TextFormField (Name*)
        ├── TextFormField (Description)
        ├── SwitchListTile (Mode: Auto / Semi-auto)
        ├── Section: "Platforms"
        │   ├── CheckboxListTile (Slack)
        │   ├── CheckboxListTile (Telegram)
        │   └── CheckboxListTile (Messenger)
        ├── Section: "Workflows"
        │   └── Wrap (chips: FAQ Answering, Lead Qualification,
        │             Order Tracking, Complaint Handling, ...)
        └── Row
            ├── OutlinedButton (Cancel)
            └── ElevatedButton (Save)
```

### Screen 3: Agent Detail

**File:** `lib/presentation/ai_agent/agent_detail_screen.dart`  
**Route:** `/ai-agents/:id`

**Widget tree:**
```
Scaffold
├── AppBar (actions: [Edit icon, Delete icon])
└── Column
    ├── AgentProfileHeader
    │   ├── CircleAvatar (large)
    │   ├── Text(name, headline)
    │   └── ModeBadge
    ├── InfoSection (Description)
    ├── PlatformSection (platform icons + labels)
    ├── WorkflowSection (chips)
    └── ElevatedButton ("Open Playground →")
```

### Screen 4: Team Assistant Config

**File:** `lib/presentation/ai_agent/team_assistant_screen.dart`  
**Route:** `/ai-agents/team-assistant`

**Widget tree:**
```
Scaffold
├── AppBar (title: "Team Assistant")
└── ListView
    ├── InfoCard (ghi chú về team assistant)
    └── [per agent]
        └── ListTile
            ├── CircleAvatar
            ├── Text(name)
            └── Radio / Switch (selected as team assistant)
```

---

## Phase 5 — UI Screens: Chat Playground

### Screen: Playground Main

**File:** `lib/presentation/playground/playground_screen.dart`  
**Route:** `/playground`

**Widget tree:**
```
Scaffold
├── AppBar
│   ├── AgentSelectorDropdown
│   ├── ContextSelector (Lazada / Normal)
│   └── IconButton (session history)
├── Body (Column)
│   ├── [if messages.isEmpty] SuggestionChips
│   ├── MessageList (ListView.builder, reverse: true)
│   │   └── PlaygroundMessageBubble (per message)
│   ├── [if isStreaming] StreamingIndicator
│   ├── [if semiAutoMode] DraftResponsePanel
│   └── PlaygroundInputBar
└── Drawer → SessionHistoryDrawer
```

### Widget: PlaygroundMessageBubble

**File:** `lib/presentation/playground/widgets/playground_message_bubble.dart`

```
Container (bubble shape, color by role)
├── [role == assistant] MarkdownBody (flutter_markdown)
├── [role == user]      SelectableText(content)
├── [isStreaming]       AnimatedCursor (blinking |)
├── [attachments.isNotEmpty] AttachmentChips
└── Text(timestamp, style: caption)
```
Long-press (user message only) → `showModalBottomSheet` → edit field.

### Widget: PlaygroundInputBar

**File:** `lib/presentation/playground/widgets/playground_input_bar.dart`

```
Container
└── Row
    ├── IconButton (attach — triggers file_picker, shows filename)
    ├── [attachedFile != null] FileChip (filename + remove X)
    ├── Expanded → TextField (hint: "Type a message...")
    └── IconButton (send — disabled if empty & no file)
```

### Widget: ContextSelector

**File:** `lib/presentation/playground/widgets/context_selector.dart`

```
SegmentedButton<PlaygroundContextType>
├── Segment(value: lazada, label: "Lazada Customer")
└── Segment(value: normal, label: "Normal Customer")
```

### Widget: SuggestionChips

**File:** `lib/presentation/playground/widgets/suggestion_chips.dart`

```
Column
├── Text("Try asking:")
└── Wrap
    ├── ActionChip("How can I track my order?")
    ├── ActionChip("What are your business hours?")
    ├── ActionChip("I want to return a product")
    ├── ActionChip("Connect me to a human agent")
    └── ActionChip("What payment methods do you accept?")
```

### Widget: StreamingIndicator

**File:** `lib/presentation/playground/widgets/streaming_indicator.dart`

```
Row (bubble shape, assistant side)
└── AnimatedBuilder (blinking dots animation)
    └── Row [●, ●, ●] (staggered opacity animation)
```

### Widget: SessionHistoryDrawer

**File:** `lib/presentation/playground/widgets/session_history_drawer.dart`

```
Drawer
└── Column
    ├── DrawerHeader (title: "Sessions")
    ├── ListTile (+ New Session)
    └── ListView.builder
        └── ListTile (per session)
            ├── Text(session date/time)
            ├── Text(first message preview)
            └── onTap → store.loadSession(id)
```

### Widget: DraftResponsePanel

**File:** `lib/presentation/playground/widgets/draft_response_panel.dart`

```
Container (elevated, bottom positioned)
├── Text("Draft suggestions:")
└── Column [per draft]
    └── ListTile
        ├── Text(draftText, maxLines: 2)
        └── Row
            ├── TextButton("Use this" → copy to input)
            └── TextButton("Dismiss")
```

---

## Phase 6 — DI, Routes, Navigation

### DI Updates

| File | Thêm |
|---|---|
| `lib/data/di/module/local_module.dart` | `AiAgentDataSource`, `PlaygroundDataSource` |
| `lib/data/di/module/repository_module.dart` | `MockAiAgentRepositoryImpl`, `PlaygroundRepositoryImpl` |
| `lib/domain/di/module/usecase_module.dart` | 8 use cases mới |
| `lib/presentation/di/module/store_module.dart` | `AiAgentStore` (factory), `PlaygroundStore` (factory) |

### Route Constants

Thêm vào `lib/utils/routes/routes.dart`:

```dart
static const String aiAgents             = '/ai-agents';
static const String aiAgentCreate        = '/ai-agents/create';
static const String aiAgentDetail        = '/ai-agents/detail';   // args: String id
static const String aiAgentEdit          = '/ai-agents/edit';     // args: AiAgent
static const String aiAgentTeamAssistant = '/ai-agents/team-assistant';
static const String playground           = '/playground';
```

### Sidebar Navigation

Thêm vào `lib/presentation/widgets/sidebar_menu_panel.dart`:
- **AI Agents** → route `/ai-agents`, icon `Icons.smart_toy`
- **Playground** → route `/playground`, icon `Icons.play_circle_outline`

---

## Phase 7 — Localization

Thêm vào tất cả `assets/lang/*.json` (en, da, es, vi):

```json
{
  "aiAgentsTitle": "AI Agents",
  "createAgent": "Create Agent",
  "editAgent": "Edit Agent",
  "deleteAgent": "Delete Agent",
  "deleteAgentConfirm": "Are you sure you want to delete this agent?",
  "agentName": "Agent Name",
  "agentDescription": "Description",
  "agentMode": "Response Mode",
  "agentModeAuto": "Auto",
  "agentModeSemiAuto": "Semi-Auto",
  "agentPlatforms": "Publish to Platforms",
  "agentWorkflows": "Workflows",
  "teamAssistantTitle": "Team Assistant",
  "openPlayground": "Open Playground",
  "playgroundTitle": "Chat Playground",
  "newSession": "New Session",
  "sessionHistory": "Session History",
  "contextSelector": "Context",
  "contextLazada": "Lazada Customer",
  "contextNormal": "Normal Customer",
  "draftResponses": "Draft Suggestions",
  "useDraft": "Use this",
  "dismissDraft": "Dismiss",
  "trySuggestion": "Try asking:",
  "typeMessage": "Type a message...",
  "editMessage": "Edit Message",
  "attachFile": "Attach File"
}
```

---

## Full File List

### Files to Create

#### Domain
```
lib/domain/entity/ai_agent/ai_agent.dart
lib/domain/entity/playground/playground_session.dart
lib/domain/entity/playground/playground_message.dart
lib/domain/repository/ai_agent/ai_agent_repository.dart
lib/domain/repository/playground/playground_repository.dart
lib/domain/usecase/ai_agent/get_agents_usecase.dart
lib/domain/usecase/ai_agent/get_agent_usecase.dart
lib/domain/usecase/ai_agent/create_agent_usecase.dart
lib/domain/usecase/ai_agent/update_agent_usecase.dart
lib/domain/usecase/ai_agent/delete_agent_usecase.dart
lib/domain/usecase/playground/get_sessions_usecase.dart
lib/domain/usecase/playground/create_session_usecase.dart
lib/domain/usecase/playground/send_playground_message_usecase.dart
```

#### Data
```
lib/data/local/datasources/ai_agent/ai_agent_datasource.dart
lib/data/local/datasources/playground/playground_datasource.dart
lib/data/repository/ai_agent/mock_ai_agent_repository_impl.dart
lib/data/repository/playground/playground_repository_impl.dart
```

#### Presentation — AI Agent
```
lib/presentation/ai_agent/store/ai_agent_store.dart
lib/presentation/ai_agent/agent_list_screen.dart
lib/presentation/ai_agent/agent_create_edit_screen.dart
lib/presentation/ai_agent/agent_detail_screen.dart
lib/presentation/ai_agent/team_assistant_screen.dart
```

#### Presentation — Playground
```
lib/presentation/playground/store/playground_store.dart
lib/presentation/playground/playground_screen.dart
lib/presentation/playground/widgets/playground_message_bubble.dart
lib/presentation/playground/widgets/playground_input_bar.dart
lib/presentation/playground/widgets/context_selector.dart
lib/presentation/playground/widgets/suggestion_chips.dart
lib/presentation/playground/widgets/streaming_indicator.dart
lib/presentation/playground/widgets/session_history_drawer.dart
lib/presentation/playground/widgets/draft_response_panel.dart
```

### Files to Modify

```
pubspec.yaml
lib/data/network/constants/endpoints.dart
lib/data/di/module/local_module.dart
lib/data/di/module/repository_module.dart
lib/domain/di/module/usecase_module.dart
lib/presentation/di/module/store_module.dart
lib/utils/routes/routes.dart
lib/presentation/widgets/sidebar_menu_panel.dart
assets/lang/en.json
assets/lang/da.json
assets/lang/es.json
assets/lang/vi.json
```

> **Generated by build_runner** (không tạo tay):
> `ai_agent.g.dart`, `playground_session.g.dart`, `playground_message.g.dart`,
> `ai_agent_store.g.dart`, `playground_store.g.dart`

---

## Execution Progress

| Batch | Tasks | Description | Status |
|---|---|---|---|
| **A** | 1, 2, 4, 14, 36 | pubspec packages, AiAgent entity, PlaygroundMessage entity, endpoint stubs, localization | ✅ Done |
| **B** | 3, 6, 10 | PlaygroundSession entity, AiAgentRepository interface, AiAgentDataSource | ✅ Done |
| **C** | 5, 7, 11, 8, 12 | build_runner (entities), PlaygroundRepository, PlaygroundDataSource, 5 agent use cases, MockAiAgentRepositoryImpl | ✅ Done |
| **D** | 9, 13 | 3 playground use cases, PlaygroundRepositoryImpl | ✅ Done |
| **E** | 15, 16 | AiAgentStore (MobX), PlaygroundStore + streaming simulation | ✅ Done |
| **F** | 17, 18–21, 25–27, 30–32 | build_runner (stores), 4 Agent screens, ContextSelector/SuggestionChips/StreamingIndicator widgets, DI local+repo+usecase | ✅ Done |
| **G** | 22–24, 28–29, 33 | PlaygroundScreen, MessageBubble/InputBar/Drawer/DraftPanel widgets, DI store_module | ✅ Done |
| **H** | 34 | Register 6 routes | ✅ Done |
| **I** | 35 | Sidebar navigation entries | ✅ Done |
| **J** | 37–40 | flutter analyze (fixed home.dart duplicate imports), build apk ✓ | ✅ Done |

---

## Acceptance Criteria Checklist

- [ ] Agent management CRUD screens implemented (list, create, edit, detail, delete)
- [ ] Team assistant config screen
- [ ] Multi-platform publishing selection UI (Slack, Telegram, Messenger)
- [ ] Workflow selection UI (≥3 workflow types)
- [ ] Playground chat interface with mock AI responses
- [ ] Streaming simulation works (Timer.periodic, character-by-character)
- [ ] File upload UI renders (file_picker, only shows filename)
- [ ] Markdown rendering in AI messages (flutter_markdown)
- [ ] Context simulation selector (Lazada / Normal) changes mock response
- [ ] Message editing UI (long-press → bottom sheet)
- [ ] Session management: new session, session history drawer
- [ ] Typing indicator animation
- [ ] Empty state with suggestion chips
- [ ] Draft response suggestion panel (semi-auto mode)
- [ ] Widget tree documented (inline comments) for each screen
- [ ] All strings use AppLocalization (no hardcoded strings)
- [ ] All layers wired up in DI
- [ ] Routes registered and navigable
- [ ] `flutter analyze` clean
- [ ] App builds with `flutter build apk --debug`

---

## Decisions & Scope Boundaries

- **Tất cả tầng implement đầy đủ** — không skip layer nào
- **Data source là mock offline hoàn toàn** — real API integration nằm ngoài scope
- Streaming = `Timer.periodic` trong store, không dùng WebSocket
- File upload = chỉ hiển thị tên file trong UI, không upload/xử lý
- Widget tree documentation = inline comment `// Widget tree:` trong từng screen file
- Không thêm tính năng Firebase mới
- Kiểm thử chỉ cần test với mock data offline
