# Realtime Messaging - Widget Tree Documentation

Tài liệu này mô tả Widget Tree cho tất cả các screens trong module chat realtime.

---

## 📋 Mục lục

1. [SupportInboxScreen](#supportinboxscreen)
2. [ChatScreen](#chatscreen)
3. [ContactInfoPanel](#contactinfopanel)
4. [Message-related Widgets](#message-related-widgets)
5. [Helper Widgets](#helper-widgets)

---

## SupportInboxScreen

**File:** `lib/presentation/chat/support_inbox_screen.dart`

**Mục đích:** Màn hình chính hiển thị danh sách các cuộc hội thoại (chat rooms) với responsive layout cho mobile/tablet/desktop.

### Widget Tree:

```
Scaffold (Mobile/Tablet/Desktop)
├── appBar: AppBar
│   ├── title: Text("Hộp thư hỗ trợ")
│   └── badge: Container (Unread count)
│
└── body:
    ├── Mobile (screenWidth < 600):
    │   └── Column
    │       ├── _buildSearchBar()
    │       └── Expanded → _buildRoomList()
    │
    ├── Tablet (600 ≤ screenWidth < 900):
    │   └── Row
    │       ├── Container (35% width)
    │       │   ├── _buildSearchBar()
    │       │   └── Expanded → _buildRoomList()
    │       │
    │       ├── Container (Divider)
    │       │
    │       └── Expanded (65% width)
    │           └── ChatScreen / Empty state
    │
    └── Desktop (screenWidth ≥ 900):
        └── Row
            ├── Container (25% width)
            │   ├── _buildSearchBar()
            │   └── Expanded → _buildRoomList()
            │
            ├── Container (Divider)
            │
            ├── Expanded (flex: _showContactInfo ? 2 : 3)
            │   └── ChatScreen / Empty state
            │
            ├── Container (Divider) [conditional]
            │
            └── ContactInfoPanel (25% width) [conditional]
```

### Key Components:

#### \_buildSearchBar():

```
Padding
└── TextField
    ├── prefixIcon: Icon(search)
    ├── suffixIcon: Icon(clear) [conditional]
    └── decoration: OutlineInputBorder (borderRadius: 24)
```

#### \_buildRoomList():

```
Observer
└── ListView.builder
    └── Container
        ├── color: Selected highlight [conditional]
        └── ChatRoomTile
            ├── room: ChatRoom
            ├── onTap: _openRoom()
            ├── Avatar + Unread badge
            ├── Tên room
            ├── Trạng thái online dot
            └── Preview tin nhắn cuối
```

### State Management:

- `ChatRoomStore` - Quản lý danh sách chat rooms
- `_selectedRoom` - Current selected room
- `_showContactInfo` - Toggle ContactInfoPanel (desktop only)
- `_searchQuery` - Search filter

---

## ChatScreen

**File:** `lib/presentation/chat/chat_screen.dart`

**Mục đích:** Hiển thị cuộc hội thoại chi tiết với tin nhắn, input, search, và typing indicator.

### Widget Tree:

```
Scaffold
├── appBar: ChatAppBar
│   ├── leading: IconButton (Back)
│   ├── title: Row
│   │   ├── Avatar with status dot
│   │   └── Column
│   │       ├── Tên contact
│   │       └── Status (Active now / Offline)
│   │
│   └── actions:
│       ├── IconButton (Search) → onSearchTap
│       ├── IconButton (Voice call)
│       ├── IconButton (Video call)
│       └── IconButton (Info) → onInfoTap
│
└── body: Column
    ├── [CONDITIONAL] Search Bar (nếu _showSearch == true)
    │   └── Container (padding + decoration)
    │       └── Row
    │           ├── Expanded → TextField
    │           │   ├── prefixIcon: search
    │           │   ├── suffixIcon: clear [conditional]
    │           │   └── onChanged: _performSearch()
    │           │
    │           ├── Text (_currentSearchIndex / _searchResults.length) [conditional]
    │           └── IconButton (Close) → _closeSearch()
    │
    ├── Expanded (Messages List)
    │   └── Observer
    │       └── ListView.builder
    │           ├── itemCount: messages.length + (isTyping ? 1 : 0)
    │           │
    │           └── itemBuilder:
    │               ├── [Last item if typing] TypingIndicator
    │               │   ├── Avatar placeholder
    │               │   ├── Tên sender
    │               │   └── 3 animated dots
    │               │
    │               └── [Messages] MessageBubble
    │                   ├── Avatar (show nếu isGroupEnd)
    │                   ├── Sender name (show nếu isGroupStart)
    │                   ├── Bubble container
    │                   │   ├── Message content text
    │                   │   ├── Timestamp + read status
    │                   │   └── [CONDITIONAL] Highlight + border (nếu isHighlighted)
    │                   │
    │                   └── Reactions (animated row)
    │                       └── GestureDetector
    │                           └── Emoji + count
    │
    └── ChatInputBar
        ├── TextField (input message)
        │   ├── prefixIcon: Attachment
        │   └── suffixIcon: Send button
        │
        └── onSend: _chatStore.sendMessage()
```

### Key State Variables:

```dart
late final ChatStore _chatStore;
final ScrollController _scrollController;
final TextEditingController _textController;
final TextEditingController _searchController;
final FocusNode _inputFocusNode;

// Search-related
bool _showSearch = false;
List<int> _searchResults = [];
int _currentSearchIndex = -1;
int? _highlightedMessageId;
```

### Key Methods:

- `_performSearch(String query)` - Tìm messages matching query
- `_navigateToNextSearchResult()` - Jump tới kết quả tiếp theo
- `_scrollToMessage(int messageId)` - Scroll tới message
- `_scrollToBottom()` - Auto-scroll khi có tin nhắn mới
- `_closeSearch()` - Đóng search + xóa highlight

---

## ContactInfoPanel

**File:** `lib/presentation/chat/contact_info_panel.dart`

**Mục đích:** Hiển thị thông tin chi tiết của contact (name, avatar, status, actions, sections mở rộng).

### Widget Tree:

```
Container
├── width: isDesktop ? 320 : double.infinity
└── SingleChildScrollView
    └── Column
        ├── [Header Section]
        │   └── Container (padding + border bottom)
        │       └── Column
        │           ├── Avatar (80x80)
        │           │   └── CircleAvatar (Gradient background)
        │           │
        │           ├── SizedBox (height: 12)
        │           ├── Text (Tên contact) - Bold, 18px
        │           ├── SizedBox (height: 4)
        │           │
        │           └── Row (Status indicator)
        │               ├── Container (Status dot - green/grey)
        │               └── Text (Status text)
        │
        ├── [Action Buttons Section]
        │   └── Padding
        │       └── Column
        │           ├── SizedBox (Xem hồ sơ KH)
        │           └── SizedBox (Lịch sử tương tác)
        │
        ├── [Divider]
        │
        └── [Expandable Sections]
            ├── ExpansionTile (Chi tiết phiếu)
            │   └── Column (Details list)
            │       ├── ListTile
            │       ├── ListTile
            │       └── ...
            │
            ├── ExpansionTile (Nhân viên)
            │   └── Column
            │       └── ListTile
            │
            ├── ExpansionTile (Phân tích cuộc hội thoại)
            │   └── Column (AI Analysis content)
            │       ├── Text (Sentiment analysis)
            │       ├── Divider
            │       ├── Text (Key topics)
            │       └── ...
            │
            ├── ExpansionTile (Ghi chú)
            │   └── TextField
            │
            ├── ExpansionTile (Lịch sử)
            │   └── ListView (Activity history)
            │
            └── ExpansionTile (Danh sách phiếu)
                └── ListView (Related tickets)
```

### Responsive Behavior:

- **Desktop (width ≥ 900):** Fixed width 320px (side panel)
- **Mobile/Tablet (width < 900):** Full width `double.infinity`

---

## Message-related Widgets

### MessageBubble

**File:** `lib/presentation/chat/widgets/message_bubble.dart`

```
Padding
└── Row
    ├── [Avatar slot] SizedBox(width: 0) or _buildAvatarSlot()
    │
    └── Flexible → Column
        ├── [Sender name] Text (show if isGroupStart)
        │
        ├── Row (Avatar + Bubble)
        │   ├── [Avatar] CircleAvatar (show if isGroupEnd)
        │   │
        │   └── Flexible → GestureDetector (long-press for reactions)
        │       └── Container (Bubble)
        │           ├── decoration: BoxDecoration
        │           │   ├── color: Blue (isMe) / Grey (others)
        │           │   ├── [CONDITIONAL] Yellow background + Orange border (if isHighlighted)
        │           │   └── borderRadius: _buildBorderRadius()
        │           │
        │           └── Text (Message content)
        │               ├── softWrap: true
        │               └── maxLines: null
        │
        ├── [Reactions] Wrap (show if reactions.isNotEmpty)
        │   └── Container + Row (emoji + count)
        │
        └── [Timestamp] Row (show if isGroupEnd)
            ├── Text (Time)
            └── [Icon] Read status indicator (single/double checkmark)
```

### MessageBubble Parameters:

```dart
- message: Message (required)
- isGroupStart: bool (first message in consecutive group)
- isGroupEnd: bool (last message in consecutive group)
- showAvatar: bool (show avatar)
- onReactionAdded: Function(String emoji)? (reaction callback)
- isHighlighted: bool (search highlight)
```

### TypingIndicator

**File:** `lib/presentation/chat/widgets/typing_indicator.dart`

```
Padding
└── Column
    ├── Text (Sender name) [padding left: 46]
    │
    └── Row
        ├── SizedBox (Avatar space: 30px)
        ├── SizedBox (6px spacing)
        │
        └── Container (Bubble)
            ├── padding: symmetric(horizontal: 14, vertical: 10)
            ├── decoration: BoxDecoration (grey background, borderRadius: 20)
            │
            └── Row (3 animated dots)
                └── AnimatedBuilder
                    └── Container (8x8 circle)
                        └── transform: Matrix4.translationValues(0, offset, 0)
                            └── Animated vertical bounce
```

### ReactionPicker

**File:** `lib/presentation/chat/widgets/reaction_picker.dart`

```
Container (maxWidth: 70% of screen width)
├── constraints: BoxConstraints(maxWidth: ...)
├── padding: symmetric(horizontal: 12, vertical: 8)
├── decoration: BoxDecoration
│   ├── color: white
│   ├── borderRadius: 24
│   └── boxShadow: [...]
│
└── Wrap (emoji grid)
    ├── spacing: 6
    ├── runSpacing: 0
    │
    └── [For each emoji]:
        └── GestureDetector (onTap: onReactionSelected)
            └── SizedBox (36x36)
                └── Center
                    └── Text (emoji, fontSize: 24)
                        └── onTap → _chatStore.addReactionToMessage()
```

---

## Helper Widgets

### ChatAppBar

**File:** `lib/presentation/chat/widgets/chat_app_bar.dart`

```
AppBar (Material Design)
├── backgroundColor: white
├── elevation: 0
├── titleSpacing: 0
│
├── leading: IconButton (Back arrow)
│
├── title: Row
│   ├── _buildAvatarWithStatus()
│   └── Column
│       ├── Text (Contact name)
│       └── Text (Status: Active now / Offline)
│
└── actions: [
    IconButton (Search),
    IconButton (Voice call),
    IconButton (Video call),
    IconButton (Info)
]
```

### ChatInputBar

**File:** `lib/presentation/chat/widgets/chat_input_bar.dart`

```
Container
├── padding: 12.0
│
└── Row
    ├── [Attachment icon]
    │
    ├── Expanded → TextField
    │   ├── controller: _textController
    │   ├── hint: "Nhập tin nhắn..."
    │   ├── maxLines: null (được phép wrap)
    │   └── border: OutlineInputBorder (borderRadius: 20)
    │
    └── IconButton (Send)
        └── onPressed: onSend()
```

### ChatRoomTile

**File:** `lib/presentation/chat/widgets/chat_room_tile.dart`

```
ListTile
├── leading: Stack
│   ├── CircleAvatar (Avatar)
│   └── [Unread badge] Container (red circle with count)
│
├── title: Text (Room name)
├── subtitle: Text (Last message preview)
│
└── trailing: Stack
    ├── Text (Time)
    └── [Unread count badge] Container [conditional]
```

---

## Screen Layout Breakpoints

### Mobile (< 600px)

```
┌─────────────────┐
│   AppBar        │
├─────────────────┤
│  ChatRoomList   │
│                 │
│   (searchable)  │
├─────────────────┤
│   (When room    │
│    selected on  │
│    tablet/desk) │
└─────────────────┘
```

### Tablet (600px - 899px)

```
┌──────────────────────────────────┐
│             AppBar               │
├────────────────┬────────────────┤
│                │                │
│  ChatRoomList  │  ChatScreen    │
│  (35% width)   │  (65% width)   │
│                │                │
│                │  +SearchBar    │
│                │  +Messages     │
│                │  +InputBar     │
│                │                │
└────────────────┴────────────────┘
```

### Desktop (≥ 900px)

```
┌─────────────────────────────────────────────┐
│                  AppBar                     │
├───────────┬──────────────────┬─────────────┤
│           │                  │             │
│  ChatRoom │   ChatScreen     │  ContactInfo│
│  List(25%)│   (50%-75%)      │   Panel(25%)│
│           │                  │             │
│  +Search  │   +SearchBar     │  +Sections  │
│  +Rooms   │   +Messages      │  (mở rộng)  │
│           │   +InputBar      │             │
│           │                  │             │
└───────────┴──────────────────┴─────────────┘
```

---

## State Management Flow

```
ChatStore (MobX)
├── @observable
│   ├── ObservableList<Message> messageList
│   ├── bool isLoading
│   ├── bool isTyping
│   └── String searchQuery
│
├── @action
│   ├── getMessages()
│   ├── sendMessage(String text)
│   │   ├── Add message to list
│   │   ├── _simulateReadStatusProgression()
│   │   └── _simulateAutoReply()
│   │
│   └── addReactionToMessage(int id, String emoji)
│
└── @computed
    └── List<Message> filteredMessages (search result)

ChatRoomStore (MobX)
├── @observable
│   ├── ObservableList<ChatRoom> chatRooms
│   ├── int totalUnread
│   └── bool isLoading
│
└── @action
    ├── fetchChatRooms()
    └── markAsRead(int roomId)
```

---

## Widget Communication

### Data Flow:

```
SupportInboxScreen
├── [Select Room]
└── ChatScreen (room: selected room)
    ├── ChatStore.getMessages()
    │   └── Display in ListView
    │
    └── [Send Message]
        └── ChatStore.sendMessage()
            ├── Add to messageList
            ├── [Auto-reply]
            │   ├── Show TypingIndicator
            │   └── Add response message
            │
            └── Observer rebuild ListView
                └── Display new message + reactions
```

### Search Flow:

```
SearchBar (TextField)
├── onChanged: _performSearch(query)
│   └── Find matching messages
│       └── Update _searchResults[]
│
└── onSubmitted: _navigateToNextSearchResult()
    ├── Update _currentSearchIndex
    ├── Update _highlightedMessageId
    └── Scroll to message
        └── MessageBubble renders with highlight
```

### Reaction Flow:

```
MessageBubble
├── [Long-press]
└── _showReactionPicker(context)
    └── ReactionPicker (Wrap of emojis)
        └── [Select emoji]
            └── onReactionSelected(emoji)
                └── ChatStore.addReactionToMessage()
                    └── Update message.reactions
                        └── Observer rebuild MessageBubble
```

---

## Dependency Injection (GetIt)

```
service_locator.dart
├── ChatStore → Singleton
├── ChatRepository → Singleton
├── ChatDataSource → Singleton
├── ChatRoomStore → Singleton
└── ChatRoomRepository → Singleton
```

---

## Summary Statistics

| Component          | Type      | Purpose                                |
| ------------------ | --------- | -------------------------------------- |
| SupportInboxScreen | Stateful  | Chat rooms list + responsive layout    |
| ChatScreen         | Stateful  | Message display + search functionality |
| ContactInfoPanel   | Stateless | Contact info + analysis                |
| MessageBubble      | Stateless | Single message display + reactions     |
| TypingIndicator    | Stateful  | Animated typing indicator              |
| ChatAppBar         | Stateless | App bar with controls                  |
| ChatInputBar       | Stateless | Message input field                    |
| ReactionPicker     | Stateless | Emoji selection popup                  |
| ChatRoomTile       | Stateless | Room list item                         |

**Total Screens:** 3 (SupportInboxScreen, ChatScreen, ContactInfoPanel)
**Total Widgets:** 8+ (including composites)
**Responsive Breakpoints:** 3 (Mobile, Tablet, Desktop)
**State Management:** MobX with Observer pattern
