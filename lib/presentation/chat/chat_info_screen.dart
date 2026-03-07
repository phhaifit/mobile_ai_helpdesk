import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/chat/chat_room.dart';
import 'store/chat_store.dart';
import 'chat_screen.dart';

class ChatInfoScreen extends StatefulWidget {
  final ChatRoom room;

  const ChatInfoScreen({super.key, required this.room});

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  final ChatStore _chatStore = getIt<ChatStore>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _chatStore.setSearchQuery(''); // Clear search when leaving
    super.dispose();
  }

  void _navigateToMessage(int messageId) {
    // Close search screen and navigate to chat with message ID
    Navigator.of(context).pop();

    // Pass message ID to ChatScreen so it can scroll to it
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            ChatScreen(room: widget.room, scrollToMessageId: messageId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.messengerBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Search Messages',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _chatStore.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.messengerBlue,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _chatStore.setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.messengerBlue),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              autofocus: true,
            ),
          ),
          // Results List
          Expanded(
            child: Observer(
              builder: (_) {
                final results = _chatStore.filteredMessages;

                if (_searchController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start typing to search',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final msg = results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 6,
                      ),
                      elevation: 0,
                      color: Colors.grey.shade50,
                      child: ListTile(
                        onTap: () => _navigateToMessage(msg.id.toInt()),
                        leading: CircleAvatar(
                          backgroundColor: msg.isMe
                              ? AppColors.messengerBlue
                              : Colors.grey.shade400,
                          child: Text(
                            msg.isMe ? 'U' : 'A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          msg.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          _formatTime(msg.timestamp),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(time.year, time.month, time.day);

    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final timeStr = '$h:$m';

    if (msgDay == today) return timeStr;

    final dayDiff = now.difference(msgDay).inDays;
    if (dayDiff == 1) return 'Yesterday $timeStr';

    return '${time.day}/${time.month}/${time.year} $timeStr';
  }
}
