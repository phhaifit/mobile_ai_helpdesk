import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/chat/chat_room.dart';
import 'store/chat_store.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom? room;
  final int? scrollToMessageId;

  const ChatScreen({super.key, this.room, this.scrollToMessageId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatStore _chatStore = getIt<ChatStore>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatStore.getMessages();

    // If scrollToMessageId is provided, scroll to that message after messages load
    if (widget.scrollToMessageId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToMessage(widget.scrollToMessageId!);
      });
    }
  }

  void _scrollToMessage(int messageId) {
    final messageIndex = _chatStore.messageList.indexWhere(
      (msg) => msg.id == messageId,
    );

    if (messageIndex != -1) {
      _scrollController.animateTo(
        (messageIndex * 80.0), // Approximate height of each message
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;
    _chatStore.sendMessage(text);
    _textController.clear();
    // Scroll to bottom after the new item is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(
        name: widget.room?.name ?? 'Jarvis AI',
        avatarInitials: widget.room?.avatarInitials ?? 'AI',
        isActive: widget.room?.isActive ?? true,
        room: widget.room,
      ),
      body: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (_) {
                if (_chatStore.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.messengerBlue,
                    ),
                  );
                }

                if (_chatStore.messageList.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount:
                      _chatStore.messageList.length +
                      (_chatStore.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator if this is the last item and isTyping
                    if (_chatStore.isTyping &&
                        index == _chatStore.messageList.length) {
                      // Auto-scroll to typing indicator
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToBottom(),
                      );
                      return const TypingIndicator(senderName: "AI Assistant");
                    }

                    final msg = _chatStore.messageList[index];
                    final total = _chatStore.messageList.length;
                    final prevMsg = index > 0
                        ? _chatStore.messageList[index - 1]
                        : null;
                    final nextMsg = index < total - 1
                        ? _chatStore.messageList[index + 1]
                        : null;

                    // Group consecutive messages from the same sender
                    final bool isGroupStart =
                        prevMsg == null || prevMsg.isMe != msg.isMe;
                    final bool isGroupEnd =
                        nextMsg == null || nextMsg.isMe != msg.isMe;
                    final bool showAvatar = !msg.isMe && isGroupEnd;

                    return MessageBubble(
                      message: msg,
                      isGroupStart: isGroupStart,
                      isGroupEnd: isGroupEnd,
                      showAvatar: showAvatar,
                      onReactionAdded: (emoji) {
                        _chatStore.addReactionToMessage(msg.id, emoji);
                      },
                    );
                  },
                );
              },
            ),
          ),
          ChatInputBar(controller: _textController, onSend: _sendMessage),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.messengerBlue.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: AppColors.messengerBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No messages yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Say hi to start the conversation!",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _chatStore.getMessages,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.messengerBlue,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              "Start Chat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
