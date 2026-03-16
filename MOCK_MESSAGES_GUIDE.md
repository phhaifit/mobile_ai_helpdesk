# Mock Messages - Hiển Thị Tin Nhắn Mẫu

> Hướng dẫn làm thế nào mock messages được tạo, lưu trữ, và hiển thị trong giao diện chat.

---

## Tổng Quan Qui Trình

```
ChatDataSource (Mock Data)
    ↓
ChatRepository (Interface)
    ↓
ChatStore (MobX State Management)
    ↓
ChatScreen (UI Display)
    ↓
MessageBubble (Widget)
```

---

## 1. Tạo Mock Data - ChatDataSource

_File: `lib/data/local/datasources/chat/chat_datasource.dart`_

```dart
class ChatDataSource {
  Future<List<Message>> getMockMessages() async {
    final baseTime = DateTime.now().subtract(const Duration(minutes: 45));

    return [
      Message(
        id: 1,
        content: "Xin chào, tôi có câu hỏi về đơn hàng của mình",
        timestamp: baseTime,
        isMe: false,
        senderName: "Nguyễn Huy Tân",
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),
      // ... 10 tin nhắn khác
    ];
  }
}
```

### Giải thích Message properties:

| Property     | Kiểu             | Ý nghĩa                                                 |
| ------------ | ---------------- | ------------------------------------------------------- |
| `id`         | `int`            | ID duy nhất của tin nhắn                                |
| `content`    | `String`         | Nội dung tin nhắn                                       |
| `timestamp`  | `DateTime`       | Thời gian gửi                                           |
| `isMe`       | `bool`           | `true` = mình gửi, `false` = khách hàng gửi             |
| `senderName` | `String`         | Tên người gửi ("You", "Nguyễn Huy Tân", "AI Assistant") |
| `isPending`  | `bool`           | Có đang chờ gửi không                                   |
| `readStatus` | `enum`           | `sent` / `delivered` / `read`                           |
| `reactions`  | `List<Reaction>` | Danh sách emoji reactions                               |

### Dữ liệu Mock hiện tại:

**11 tin nhắn** mô phỏng hội thoại thực tế giữa khách hàng (Nguyễn Huy Tân) và support agent (AI Assistant):

1. **Khách hàng** hỏi về đơn hàng
2. **AI** chào đón và yêu cầu mã đơn hàng (reaction: 👍)
3. **Khách hàng** cung cấp mã (reaction: 👍 từ AI)
4. **AI** kính nhã và kiểm tra
5. **AI** tiếp tục với thông tin đơn hàng
6. **Khách hàng** hỏi cách theo dõi
7. **AI** cung cấp link tracking
8. **AI** cung cấp thêm thông tin (reaction: ❤️)
9. **Khách hàng** hỏi "Còn câu hỏi gì khác"
10. **AI** đề nghị giúp thêm
11. **Khách hàng** cảm ơn (readStatus: sent)

---

## 2. Lưu Trữ Data - Repository Pattern

_File: `lib/data/repository/chat/chat_repository_impl.dart`_

```dart
class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<List<Message>> getMessages() {
    return _chatDataSource.getMockMessages();  // Ủy thác cho DataSource
  }
}
```

**Tương lai:** Có thể thay `_chatDataSource.getMockMessages()` bằng:

```dart
return http.get('/api/messages').then(...)  // API thực
```

---

## 3. Quản Lý State - ChatStore (MobX)

_File: `lib/presentation/chat/store/chat_store.dart`_

```dart
abstract class _ChatStore with Store {
  final ChatRepository _chatRepository;

  @observable
  ObservableList<Message> messageList = ObservableList<Message>();

  @observable
  bool isLoading = false;

  @action
  Future<void> getMessages() async {
    isLoading = true;
    final messages = await _chatRepository.getMessages();
    messageList.addAll(messages);  // ← Observable cập nhật, UI rebuild
    isLoading = false;
  }

  @action
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Tạo tin nhắn mới của mình
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      content: text,
      timestamp: DateTime.now(),
      isMe: true,
      senderName: "You",
      isPending: false,
      readStatus: MessageReadStatus.sent,
    );

    messageList.add(newMessage);  // ← Thêm vào danh sách

    // Giả lập tiến trình: sent → delivered (500ms) → read (2s)
    _simulateReadStatusProgression(newMessage.id);

    // Giả lập AI phản hồi sau 2.5s
    _simulateAutoReply();
  }

  @action
  void addReactionToMessage(int messageId, String emoji) {
    final index = messageList.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = messageList[index];
      final reactionIndex = message.reactions.indexWhere((r) => r.emoji == emoji);

      if (reactionIndex != -1) {
        // Emoji đã tồn tại → thêm user vào danh sách
        final updated = message.reactions[reactionIndex].copyWith(
          userNames: [...message.reactions[reactionIndex].userNames, 'You'],
        );
        message.reactions[reactionIndex] = updated;
      } else {
        // Emoji mới → tạo reaction mới
        message.reactions.add(Reaction(emoji: emoji, userNames: ['You']));
      }

      messageList[index] = message;  // ← Cập nhật observable
    }
  }
}
```

**Các tính năng:**

- ✅ `getMessages()` - Tải tin nhắn từ repository
- ✅ `sendMessage(text)` - Gửi tin nhắn mới
- ✅ Giả lập trạng thái đọc (sent → delivered → read)
- ✅ Giả lập phản hồi tự động từ AI
- ✅ `addReactionToMessage()` - Thêm emoji reaction

---

## 4. Hiển Thị UI - ChatScreen

_File: `lib/presentation/chat/chat_screen.dart`_

### Inject ChatStore:

```dart
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late final ChatStore _chatStore;

  @override
  void initState() {
    super.initState();
    _chatStore = getIt<ChatStore>();  // ← Lấy từ GetIt
    _chatStore.getMessages();           // ← Tải tin nhắn
  }
}
```

### Render Messages với Observer:

```dart
Expanded(
  child: Observer(
    builder: (_) {
      if (_chatStore.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final messages = _chatStore.messageList;

      if (messages.isEmpty) {
        return Center(child: Text('Chưa có tin nhắn'));
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];

          // Xác định tin nhắn này là bắt đầu/kết thúc của chuỗi từ cùng người gửi
          final isGroupStart = index == 0 ||
              messages[index - 1].senderName != message.senderName;
          final isGroupEnd = index == messages.length - 1 ||
              messages[index + 1].senderName != message.senderName;

          return MessageBubble(
            message: message,
            isGroupStart: isGroupStart,           // Avatar chỉ ở tin cuối
            isGroupEnd: isGroupEnd,
            showAvatar: isGroupEnd,               // Tên chỉ ở tin đầu
            onReactionAdded: (emoji) {
              _chatStore.addReactionToMessage(message.id, emoji);
            },
          );
        },
      );
    },
  ),
)
```

**Observer Pattern:**

- `Observer` widget tự động rebuild khi `_chatStore.messageList` thay đổi
- Hiệu quả cao - chỉ rebuild phần cần thiết

### Gửi Tin Nhắn:

```dart
ChatInputBar(
  controller: _textController,
  onSend: () {
    if (_textController.text.isNotEmpty) {
      _chatStore.sendMessage(_textController.text);  // ← Gửi
      _textController.clear();                        // ← Clear ô input
      _scrollToBottom();                              // ← Cuộn xuống
    }
  },
  focusNode: _inputFocusNode,
)
```

---

## 5. Render Message - MessageBubble Widget

_File: `lib/presentation/chat/widgets/message_bubble.dart`_

```dart
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isGroupStart;    // Tin nhắn đầu tiên của chuỗi?
  final bool isGroupEnd;      // Tin nhắn cuối cùng của chuỗi?
  final bool showAvatar;      // Hiển thị avatar?
  final Function(String emoji)? onReactionAdded;  // Callback reaction

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(
        top: isGroupStart ? 6 : 2,      // Khoảng cách thêm nếu là đầu chuỗi
        bottom: isGroupEnd ? 8 : 0,     // Khoảng cách dưới cho reactions
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (chỉ hiển thị cho tin cuối của chuỗi từ người khác)
          if (!isMe)
            showAvatar
              ? _buildAvatar()
              : const SizedBox(width: 30),

          // Tên người gửi (chỉ ở tin đầu)
          if (!isMe && isGroupStart)
            Text(
              message.senderName,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),

          // Bubble chính
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.messengerBlue : AppColors.bubbleGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                // Read status checkmark
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    if (isMe) const SizedBox(width: 4),
                    if (isMe) _buildReadStatusIcon(message.readStatus),
                  ],
                ),
              ],
            ),
          ),

          // Reactions (dưới bubble)
          if (message.reactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildReactionsList(message.reactions),
            ),
        ],
      ),
    );
  }

  Widget _buildReactionsList(List<Reaction> reactions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((reaction) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => onReactionAdded?.call(reaction.emoji),
              child: Text(reaction.emoji, style: const TextStyle(fontSize: 14)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

---

## Luồng Dữ Liệu Chi Tiết

### Khi ChatScreen khởi động:

```
ChatScreen.initState()
  → _chatStore = getIt<ChatStore>()
  → _chatStore.getMessages()
    → ChatRepository.getMessages()
      → ChatDataSource.getMockMessages()
        → return [Message1, Message2, ..., Message11]
      ← Trả lại messageList
    ← messageList cập nhật (observable)
  → setState() [tự động từ Observer]
  → build() gọi ListView.builder
    → Render 11 MessageBubble
      → isGroupStart/isGroupEnd tính toán
      → Avatar/Tên hiển thị chỉ khi cần
      → Reactions hiển thị nếu có
```

### Khi người dùng gửi tin nhắn:

```
ChatInputBar.onSend("Xin chào")
  → _chatStore.sendMessage("Xin chào")
    → Tạo Message mới (isMe: true)
    → messageList.add(newMessage)
      → messageList observable cập nhật
      → Observer tự rebuild ListView
        → MessageBubble mới hiển thị ngay
    → _simulateReadStatusProgression()
      → Sau 500ms: readStatus = delivered
        → messageList[index] cập nhật
        → Observer rebuild
      → Sau 2s: readStatus = read
        → Tương tự
    → _simulateAutoReply()
      → Sau 2.5s: tạo Message AI phản hồi
      → messageList.add(autoReplyMessage)
      → Observer rebuild
      → isTyping = true/false (typing indicator)
```

### Khi người dùng thêm reaction:

```
MessageBubble.onLongPress
  → ReactionPicker hiển thị
    → Người dùng chọn '❤️'
  → onReactionAdded('❤️') callback
    → _chatStore.addReactionToMessage(messageId, '❤️')
      → Tìm message trong messageList
      → Thêm reaction vào message.reactions
      → messageList[index] = updatedMessage
        → Observable cập nhật
        → Observer rebuild MessageBubble
          → '❤️' hiện dưới bubble
```

---

## Tối Ưu Hiệu Năng

### 1. **Observer Pattern**

```dart
Observer(
  builder: (_) => ListView.builder(...),  // ← Rebuild khi messageList thay đổi
)
```

- Chỉ rebuild ListView khi dữ liệu thay đổi
- Không rebuild toàn bộ ChatScreen

### 2. **ListView.builder**

```dart
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) => MessageBubble(...),
)
```

- Chỉ render những item đang hiển thị
- Giải phóng memory khi scroll

### 3. **Grouping Logic**

```dart
final isGroupStart = messages[index - 1].senderName != message.senderName;
final isGroupEnd = messages[index + 1].senderName != message.senderName;
final showAvatar = isGroupEnd;  // Avatar chỉ ở cuối chuỗi
```

- Avatar chỉ hiển thị ở tin cuối → tiết kiệm không gian
- Tên chỉ ở tin đầu → không lặp lại

---

## Mở Rộng Tương Lai

### 1. **Tích Hợp API Thực**

```dart
// chat_datasource.dart
Future<List<Message>> getMessages() {
  return http.get('/api/messages')
    .then((response) => (jsonDecode(response.body) as List)
      .map((json) => Message.fromJson(json))
      .toList());
}
```

### 2. **Lưu Tin Nhắn**

```dart
// ChatScreen.dispose()
@override
void dispose() {
  // Lưu tin nhắn lại trước khi đóng
  _chatStore.saveMessages();
  super.dispose();
}
```

### 3. **Tìm Kiếm Tin Nhắn**

```dart
@computed
List<Message> get filteredMessages {
  if (searchQuery.isEmpty) return messageList.toList();
  return messageList
    .where((msg) => msg.content.contains(searchQuery))
    .toList();
}
```

---

## Tóm Tắt

| Bước | Tệp                         | Mô Tả                            |
| ---- | --------------------------- | -------------------------------- |
| 1    | `chat_datasource.dart`      | Tạo 11 tin nhắn mock             |
| 2    | `chat_repository_impl.dart` | Ủy thác lấy dữ liệu              |
| 3    | `chat_store.dart`           | Quản lý state với MobX           |
| 4    | `chat_screen.dart`          | Inject Store & gọi getMessages() |
| 5    | `message_bubble.dart`       | Render từng tin nhắn             |

**Luồng:** DataSource → Repository → Store → Screen → Widget

**Tối ưu:** Observer Pattern + ListView.builder + Grouping Logic
