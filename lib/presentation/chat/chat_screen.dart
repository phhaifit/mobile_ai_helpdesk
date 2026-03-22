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
  final VoidCallback? onInfoTap;

  const ChatScreen({
    super.key,
    this.room,
    this.scrollToMessageId,
    this.onInfoTap,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatStore _chatStore;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  int _previousItemCount = 0;
  bool _showSearch = false;
  List<int> _searchResults = []; // Message IDs that match search query
  int _currentSearchIndex = -1; // Index in _searchResults array
  int? _highlightedMessageId; // ID of currently highlighted message

  @override
  void initState() {
    super.initState();
    _chatStore = getIt<ChatStore>();
    _chatStore.getMessages();

    _scrollController.addListener(_onScrollPositionChanged);
    _inputFocusNode.addListener(_onInputFocusChanged);
  }

  void _onScrollPositionChanged() {
    // Implementation for scroll position change
  }

  void _onInputFocusChanged() {
    if (_inputFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
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

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _currentSearchIndex = -1;
        _highlightedMessageId = null;
      });
      return;
    }

    final messages = _chatStore.messageList;
    final results = <int>[];

    for (final message in messages) {
      if (message.content.toLowerCase().contains(query.toLowerCase())) {
        results.add(message.id);
      }
    }

    // Reverse so newest messages come first
    results.sort((a, b) {
      final messageA = messages.firstWhere((m) => m.id == a);
      final messageB = messages.firstWhere((m) => m.id == b);
      return messageB.timestamp.compareTo(
        messageA.timestamp,
      ); // Descending order
    });

    setState(() {
      _searchResults = results;
      _currentSearchIndex = -1;
      _highlightedMessageId = null;
    });

    // Auto-navigate to first result if exists
    if (_searchResults.isNotEmpty) {
      _navigateToNextSearchResult();
    }
  }

  void _navigateToNextSearchResult() {
    if (_searchResults.isEmpty) return;

    setState(() {
      _currentSearchIndex = (_currentSearchIndex + 1) % _searchResults.length;
      _highlightedMessageId = _searchResults[_currentSearchIndex];
    });

    // Scroll to highlighted message
    _scrollToMessage(_highlightedMessageId!);
  }

  void _scrollToMessage(int messageId) {
    final messages = _chatStore.messageList;
    final messageIndex = messages.indexWhere((m) => m.id == messageId);

    if (messageIndex != -1) {
      // Calculate scroll position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // Simple scroll with estimated item height (~80px per message)
          final estimatedOffset = messageIndex * 100.0;
          _scrollController.animateTo(
            estimatedOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _closeSearch() {
    setState(() {
      _showSearch = false;
      _searchController.clear();
      _searchResults = [];
      _currentSearchIndex = -1;
      _highlightedMessageId = null; // This will remove highlight
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return const SizedBox.expand(
        child: Center(child: Text('Chọn một phòng chat để bắt đầu')),
      );
    }

    return Scaffold(
      appBar: ChatAppBar(
        name: widget.room!.name,
        avatarInitials: widget.room!.avatarInitials,
        isActive: widget.room!.isActive,
        room: widget.room,
        onInfoTap: widget.onInfoTap,
        onSearchTap: () {
          setState(() => _showSearch = !_showSearch);
          if (_showSearch) {
            // Focus search input
            FocusScope.of(context).requestFocus(FocusNode()..attach(context));
          } else {
            _closeSearch();
          }
        },
      ),
      body: Column(
        children: [
          // Search bar
          if (_showSearch)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm tin nhắn...',
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: AppColors.messengerBlue,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      onChanged: _performSearch,
                      onSubmitted: (_) => _navigateToNextSearchResult(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_searchResults.isNotEmpty)
                    Text(
                      '${_currentSearchIndex + 1}/${_searchResults.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.messengerBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: _closeSearch,
                  ),
                ],
              ),
            ),
          // Messages list
          Expanded(
            child: Observer(
              builder: (_) {
                if (_chatStore.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = _chatStore.messageList;

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          size: 64,
                          color: AppColors.messengerBlue.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa tìm thấy tin nhắn nào cho phiếu này',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hãy bắt đầu cuộc trò chuyện với khách hàng để hiểu hơn về yêu cầu của họ!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Calculate item count: messages + typing indicator
                final itemCount =
                    messages.length + (_chatStore.isTyping ? 1 : 0);

                // Scroll to bottom when messages load or new messages arrive
                // Only trigger scroll when item count changes
                if (itemCount > _previousItemCount) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  _previousItemCount = itemCount;
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Show typing indicator at last position
                    if (index == messages.length) {
                      return const TypingIndicator(senderName: 'AI Assistant');
                    }

                    final message = messages[index];

                    // Determine grouping
                    final isGroupStart =
                        index == 0 ||
                        messages[index - 1].senderName != message.senderName;
                    final isGroupEnd =
                        index == messages.length - 1 ||
                        messages[index + 1].senderName != message.senderName;

                    return MessageBubble(
                      message: message,
                      isGroupStart: isGroupStart,
                      isGroupEnd: isGroupEnd,
                      showAvatar: isGroupEnd,
                      isHighlighted: _highlightedMessageId == message.id,
                      onReactionAdded: (emoji) {
                        _chatStore.addReactionToMessage(message.id, emoji);
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Input bar
          ChatInputBar(
            controller: _textController,
            onSend: () {
              if (_textController.text.isNotEmpty) {
                _chatStore.sendMessage(_textController.text);
                _textController.clear();
                // Auto scroll to bottom after sending
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
              }
            },
            focusNode: _inputFocusNode,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _searchController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }
}
