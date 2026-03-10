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
import 'widgets/ai_analysis_panel.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom? room;
  final int? scrollToMessageId;

  const ChatScreen({super.key, this.room, this.scrollToMessageId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ChatStore _chatStore = getIt<ChatStore>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  int _previousMessageCount = 0;
  int _unreadMessageCount = 0;
  bool _isScrolledToBottom = true;
  bool _showUnreadNotification = false;

  // AI Analysis Panel variables
  bool _showAIPanel = false;
  late AnimationController _panelAnimationController;
  late Animation<Offset> _panelSlideAnimation;

  @override
  void initState() {
    super.initState();
    _chatStore.getMessages();
    _previousMessageCount = _chatStore.messageList.length;

    // Listen to scroll position changes
    _scrollController.addListener(_onScrollPositionChanged);

    // Listen to input focus changes - when keyboard appears, scroll to bottom
    _inputFocusNode.addListener(_onInputFocusChanged);

    // Initialize AI Panel animation controller
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _panelSlideAnimation =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Slide from right
          end: const Offset(0.0, 0.0), // Slide to center
        ).animate(
          CurvedAnimation(
            parent: _panelAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    // If scrollToMessageId is provided, scroll to that message after messages load
    if (widget.scrollToMessageId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToMessage(widget.scrollToMessageId!);
      });
    }
  }

  void _onInputFocusChanged() {
    // When input gains focus (keyboard starts appearing), scroll to bottom
    if (_inputFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _toggleAIPanel() {
    setState(() {
      _showAIPanel = !_showAIPanel;
      if (_showAIPanel) {
        _panelAnimationController.forward();
      } else {
        _panelAnimationController.reverse();
      }
    });
  }

  void _closeAIPanel() {
    setState(() {
      _showAIPanel = false;
      _panelAnimationController.reverse();
    });
  }

  void _onScrollPositionChanged() {
    // Check if user is scrolled to bottom (within 100 pixels)
    final isAtBottom =
        _scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 100);

    if (isAtBottom != _isScrolledToBottom) {
      setState(() {
        _isScrolledToBottom = isAtBottom;
        // If user scrolls to bottom, clear unread count
        if (isAtBottom && _showUnreadNotification) {
          _unreadMessageCount = 0;
          _showUnreadNotification = false;
        }
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
    _scrollController.removeListener(_onScrollPositionChanged);
    _scrollController.dispose();
    _inputFocusNode.removeListener(_onInputFocusChanged);
    _inputFocusNode.dispose();
    _panelAnimationController.dispose();
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

  void _handleNewMessages() {
    final currentMessageCount = _chatStore.messageList.length;
    if (currentMessageCount > _previousMessageCount) {
      final newMessagesCount = currentMessageCount - _previousMessageCount;
      _previousMessageCount = currentMessageCount;

      // If user is at bottom or input focused, auto-scroll
      if (_isScrolledToBottom) {
        _scrollToBottom();
        setState(() {
          _unreadMessageCount = 0;
          _showUnreadNotification = false;
        });
      } else {
        // Show unread notification
        setState(() {
          _unreadMessageCount += newMessagesCount;
          _showUnreadNotification = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: ChatAppBar(
        name: widget.room?.name ?? 'Jarvis AI',
        avatarInitials: widget.room?.avatarInitials ?? 'AI',
        isActive: widget.room?.isActive ?? true,
        room: widget.room,
        onAIAnalysisTap: _toggleAIPanel,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Observer(
                  builder: (_) {
                    // Handle new messages arrival
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _handleNewMessages();
                    });

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
                          return const TypingIndicator(
                            senderName: "AI Assistant",
                          );
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
              ChatInputBar(
                controller: _textController,
                onSend: _sendMessage,
                focusNode: _inputFocusNode,
              ),
            ],
          ),
          // Unread messages notification (Floating button)
          if (_showUnreadNotification)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _unreadMessageCount = 0;
                      _showUnreadNotification = false;
                    });
                    _scrollToBottom();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.messengerBlue,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _unreadMessageCount == 1
                              ? '1 tin nhắn mới'
                              : '$_unreadMessageCount tin nhắn mới',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // AI Analysis Panel (slides in from right)
          if (_showAIPanel)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AIAnalysisPanel(
                slideAnimation: _panelSlideAnimation,
                onClose: _closeAIPanel,
              ),
            ),
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
