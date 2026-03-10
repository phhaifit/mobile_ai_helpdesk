# Widget Tree Documentation

This document provides a comprehensive overview of the widget hierarchy for each screen in the Mobile AI Helpdesk application.

---

## 📱 Screen Overview

The application contains 3 main screens:

1. **ChatRoomListScreen** - Home screen showing list of chat conversations
2. **ChatScreen** - Main chat screen for messaging
3. **ChatInfoScreen** - Message search screen

---

## 1️⃣ ChatRoomListScreen

**File:** `lib/presentation/chat/chat_room_list_screen.dart`

**Purpose:** Displays list of available chat rooms and active conversations.

### Widget Tree Structure

```
Scaffold
├── backgroundColor: Colors.white
├── appBar: AppBar
│   ├── backgroundColor: Colors.white
│   ├── title: Row
│   │   ├── Text('Chats') - Main title
│   │   └── Container - Unread count badge (conditional)
│   │       └── Text(${_store.totalUnread})
│   ├── actions: Row
│   │   ├── IconButton(camera_alt_outlined)
│   │   └── IconButton(edit_square)
│   └── bottom: Divider
└── body: Column
    ├── _buildSearchBar()
    │   └── Padding
    │       └── Container
    │           └── TextField
    │               ├── prefixIcon: Icon(search_rounded)
    │               └── hintText: "Search"
    │
    ├── _buildActiveNowRow()
    │   └── Observer
    │       └── Column
    │           ├── Text("Active Now")
    │           └── SizedBox(height: 86)
    │               └── ListView.builder (horizontal)
    │                   └── _buildActiveRoomItem() x N
    │                       └── Stack
    │                           ├── Container (circular avatar)
    │                           │   └── Gradient background
    │                           └── Positioned (online indicator)
    │                               └── Container (green dot)
    │
    ├── Divider
    │
    └── Expanded
        └── _buildRoomList()
            └── Observer
                └── ListView.builder
                    ├── itemCount: filtered rooms
                    └── ChatRoomTile (custom widget) x N
                        ├── ReorderableDelayedDragStartListener
                        ├── Dismissible
                        └── Widget content
                            ├── CircleAvatar (room avatar)
                            ├── Column (room info)
                            │   ├── Text(room.name)
                            │   └── Text(room.lastMessage)
                            └── Column (right side)
                                ├── Text(timestamp)
                                └── Unread badge (conditional)
```

### Key Features

- **Search Bar:** Filter chat rooms in real-time
- **Active Now Section:** Horizontal list of active users with gradient avatars
- **Unread Badge:** Shows total unread messages count
- **Chat Room Tiles:** With avatar, name, last message, and unread indicator

---

## 2️⃣ ChatScreen

**File:** `lib/presentation/chat/chat_screen.dart`

**Purpose:** Main messaging screen where users can send/receive messages, see reactions, and search.

### Widget Tree Structure

```
Scaffold
├── resizeToAvoidBottomInset: true
├── backgroundColor: Colors.white
├── appBar: ChatAppBar (custom widget)
│   ├── leading: IconButton(arrow_back)
│   ├── title: Row
│   │   ├── CircleAvatar (contact avatar)
│   │   └── Column
│   │       ├── Text(name)
│   │       └── Text("Active now" / "Offline")
│   └── actions: Row
│       ├── IconButton(phone)
│       ├── IconButton(videocam_rounded)
│       └── IconButton(info_outline_rounded) → navigates to ChatInfoScreen
│
└── body: Stack
    ├── Column
    │   ├── Expanded
    │   │   └── Observer (MobX reactive builder)
    │   │       ├── CircularProgressIndicator (loading state)
    │   │       ├── _buildEmptyState() (empty messages state)
    │   │       │   └── Center
    │   │       │       └── Column
    │   │       │           ├── Container(circular icon background)
    │   │       │           ├── Text("No messages yet")
    │   │       │           ├── Text("Say hi...")
    │   │       │           └── ElevatedButton("Start Chat")
    │   │       │
    │   │       └── ListView.builder
    │   │           ├── controller: _scrollController
    │   │           ├── itemCount: messageList + (isTyping ? 1 : 0)
    │   │           └── itemBuilder: (context, index)
    │   │               ├── TypingIndicator (conditional) 🎯
    │   │               │   └── 3 animated dots
    │   │               │
    │   │               └── MessageBubble (custom widget) x N
    │   │                   ├── GestureDetector (long-press for reactions)
    │   │                   ├── Container (message bubble)
    │   │                   │   ├── backgroundColor (different for user/AI)
    │   │                   │   ├── borderRadius (grouped messages)
    │   │                   │   └── child: Column
    │   │                   │       ├── Text(message.content)
    │   │                   │       └── Row
    │   │                   │           ├── timestamp
    │   │                   │           └── readStatus icons (✓✓ etc)
    │   │                   │
    │   │                   ├── _buildReactions() (if reactions exist)
    │   │                   │   └── Row
    │   │                   │       └── Chip x N (emoji reactions)
    │   │                   │
    │   │                   ├── _buildReadStatusIcon()
    │   │                   │   └── Icon (sent/delivered/read status)
    │   │                   │
    │   │                   └── ReactionPicker (popup, long-press triggered)
    │   │                       └── Popup menu
    │   │                           └── 8 emoji options
    │   │
    │   └── ChatInputBar (custom widget)
    │       └── Container
    │           ├── Row
    │           │   ├── IconButton(emoji_emotions_outlined)
    │           │   ├── Expanded
    │           │   │   └── TextField
    │           │   │       ├── focusNode: _inputFocusNode
    │           │   │       └── maxLines: null (multiline)
    │           │   │
    │           │   └── Conditional action buttons
    │           │       ├── If text empty:
    │           │       │   ├── IconButton(mic_none_rounded)
    │           │       │   ├── IconButton(image_outlined)
    │           │       │   └── IconButton(thumb_up_rounded)
    │           │       │
    │           │       └── If text not empty:
    │           │           └── FloatingActionButton(send icon)
    │           │
    │           └── SafeArea (for bottom padding)
    │
    └── Positioned (unread notification badge) 🎯
        └── Conditional: if (_showUnreadNotification)
            └── Center
                └── GestureDetector (tap to scroll down)
                    └── Container (blue notification bubble)
                        └── Row
                            ├── Icon(arrow_downward_rounded)
                            └── Text("X tin nhắn mới")
```

### Key Features

- **Auto-scroll:** Scrolls to bottom when keyboard appears (via FocusNode)
- **Unread Notification:** Shows floating badge when new messages arrive while scrolled up
- **Message Grouping:** Consecutive messages from same sender grouped visually
- **Read Status:** Displays sent (✓) / delivered (✓✓) / read (✓✓ blue) icons
- **Reactions:** Long-press to add emoji reactions to messages
- **Typing Indicator:** Animated 3-dot indicator when AI is "typing"
- **Message Scroll:** Auto-scroll to specific message (from search results)

### State Tracking Variables

```dart
int _previousMessageCount          // Track new messages
int _unreadMessageCount            // Count of new messages
bool _isScrolledToBottom           // User position tracking
bool _showUnreadNotification       // Badge visibility
```

---

## 3️⃣ ChatInfoScreen

**File:** `lib/presentation/chat/chat_info_screen.dart`

**Purpose:** Search interface for finding specific messages in conversation.

### Widget Tree Structure

```
Scaffold
├── backgroundColor: Colors.white
├── appBar: AppBar
│   ├── backgroundColor: Colors.white
│   ├── leading: IconButton(arrow_back)
│   ├── title: Text("Search Messages")
│   └── elevation: 0
│
└── body: Column
    ├── Padding (search input)
    │   └── TextField
    │       ├── decoration: InputDecoration
    │       │   ├── hintText: "Search messages..."
    │       │   ├── prefixIcon: Icon(search)
    │       │   ├── suffixIcon: clear button (conditional)
    │       │   └── border: OutlineInputBorder(circle)
    │       │
    │       ├── onChanged: _chatStore.setSearchQuery()
    │       └── focusNode (managed by parent)
    │
    └── Expanded
        └── Observer (MobX reactive builder)
            └── _chatStore.filteredMessages (computed)
                ├── No results message (conditional)
                │   └── Center
                │       └── Text("No messages found")
                │
                └── ListView.builder
                    ├── itemCount: filteredMessages.length
                    └── ListTile x N
                        ├── leading: CircleAvatar
                        │   └── senderName first letter
                        │
                        ├── title: Text
                        │   └── message.content (ellipsized)
                        │
                        ├── subtitle: Text
                        │   └── formatted timestamp
                        │       └── style: grey, smaller font
                        │
                        ├── trailing: Icon(chevron_right)
                        │
                        └── onTap
                            └── _navigateToMessage(messageId)
                                ├── Pop this screen
                                └── PushReplacement to ChatScreen
                                    ├── with messageId
                                    └── ChatScreen auto-scrolls to message
```

### Search Flow

1. User taps **Info button (info_outline_rounded)** in ChatAppBar → navigates here
2. User types in search field → `_chatStore.setSearchQuery()` updates observable
3. `filteredMessages` computed property filters messageList in real-time
   - Filters by: `content.toLowerCase().contains(searchQuery.toLowerCase())`
4. User taps search result → calls `_navigateToMessage(messageId)`
5. Auto-scrolls to message in ChatScreen using `_scrollToMessage()`

---

## 🔄 Data Flow & State Management

### MobX Integration

**ChatStore (Store)**

```
@observable
├── ObservableList<Message> messageList
├── bool isLoading
├── bool isTyping
└── String searchQuery

@computed
└── List<Message> get filteredMessages
    └── Reactive filtering based on searchQuery

@action
├── getMessages()
├── sendMessage(text)
├── addReactionToMessage(id, emoji)
├── setSearchQuery(query)
└── Internal helpers:
    ├── _simulateAutoReply()
    ├── _simulateReadStatusProgression()
    └── _simulateTypingIndicator()
```

The `Observer` widget in each screen rebuilds automatically when observables change.

---

## 🎨 Custom Widgets Used

| Widget              | Location                        | Purpose                                            |
| ------------------- | ------------------------------- | -------------------------------------------------- |
| **ChatAppBar**      | `widgets/chat_app_bar.dart`     | Top bar with contact info & action buttons         |
| **ChatInputBar**    | `widgets/chat_input_bar.dart`   | Bottom input field with action buttons             |
| **MessageBubble**   | `widgets/message_bubble.dart`   | Individual message display with reactions & status |
| **TypingIndicator** | `widgets/typing_indicator.dart` | Animated 3-dot indicator                           |
| **ReactionPicker**  | `widgets/reaction_picker.dart`  | Emoji reaction menu (popup)                        |
| **ChatRoomTile**    | `widgets/chat_room_tile.dart`   | Chat room card in list view                        |

---

## 🎯 Key Navigation Flows

### 1. Home → Chat Conversation

```
ChatRoomListScreen
└── ChatRoomTile onTap
    └── Navigator.push()
        └── ChatScreen(room: room)
```

### 2. Chat → Message Search

```
ChatScreen (Info button in ChatAppBar)
└── Navigator.push()
    └── ChatInfoScreen(room: room)
```

### 3. Search Result → Chat with Auto-scroll

```
ChatInfoScreen (Search result ListTile)
└── onTap: _navigateToMessage(messageId)
    ├── Navigator.pop() (close search)
    └── Navigator.pushReplacement()
        └── ChatScreen(messageId: messageId)
            └── _scrollToMessage()
                └── animateTo(messageIndex * 80.0px)
```

---

## 📐 Key Measurements & Styling

| Element                  | Size/Value                       | Notes                    |
| ------------------------ | -------------------------------- | ------------------------ |
| AppBar Height            | kToolbarHeight + 1               | Standard material design |
| Message Group Spacing    | Dynamic (based on content)       | Responsive layout        |
| Avatar Size              | 20px (AppBar), 52px (Active Now) | Varies by context        |
| Input Bar Height         | 120px max                        | Expandable for multiline |
| Unread Badge Position    | bottom: 80                       | Above input bar          |
| Scroll Tolerance         | 100px                            | "At bottom" threshold    |
| Estimated Message Height | 80px                             | For scroll calculations  |

---

## 🔍 Responsive Behavior

- **Keyboard Display:** `resizeToAvoidBottomInset: true` automatically adjust layout
- **Soft Keyboard Dismissal:** Handled by `FocusNode` in ChatScreen
- **Auto-scroll on Input:** Triggered by `_onInputFocusChanged()` listener
- **Dynamic Message Heights:** ListView adjusts based on content
- **Unread Badge:** Floating position (Positioned widget) overlays messages

---

## 📝 Notes

- All screens use `Scaffold` as root widget
- MobX `Observer` used for reactive state management
- Custom widgets provide reusable, isolated UI components
- Navigator pattern supports deep linking and state preservation
- Focus nodes manage keyboard visibility and scroll sync behavior
