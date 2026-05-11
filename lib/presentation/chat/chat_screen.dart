import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/chat/chat_room.dart';
import '../../domain/entity/chat/message.dart';
import '../../domain/entity/prompt/prompt.dart';
import '../playground/widgets/draft_response_panel.dart';
import '../prompt/store/prompt_store.dart';
import 'slash_prompt_picker_overlay.dart';
import 'store/chat_store.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';

bool _sameSender(Message a, Message b) {
  final String idA = a.sender.id;
  final String idB = b.sender.id;
  if (idA.isNotEmpty && idB.isNotEmpty) {
    return idA == idB;
  }
  return a.sender.name == b.sender.name;
}

class ChatScreen extends StatefulWidget {
  final ChatRoom? room;
  final VoidCallback? onInfoTap;

  const ChatScreen({
    super.key,
    this.room,
    this.onInfoTap,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatStore _chatStore;
  late final PromptStore _promptStore;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ItemScrollController _itemScrollController =  ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int _previousItemCount = 0;
  bool _slashMode = false;
  bool _showSearch = false;
  List<String> _searchResults = []; // Message IDs that match search query
  int _currentSearchIndex = -1; // Index in _searchResults array
  String? _highlightedMessageId; // ID of currently highlighted message

  @override
  void initState() {
    super.initState();
    _chatStore = getIt<ChatStore>();
    _promptStore = getIt<PromptStore>();

    _chatStore.currentChatRoomId = widget.room?.id;

    _textController.addListener(_onComposerChanged);
    if (_promptStore.prompts.isEmpty) {
      _promptStore.loadPrompts(useNetworkDelay: false);
    }

    _inputFocusNode.addListener(_onInputFocusChanged);
    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  void _onItemPositionsChanged() {
    final Iterable<ItemPosition> positions =
        _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Smallest index currently visible — when the user scrolls toward the
    // top of the list, this approaches 0. Trigger an older-page fetch a
    // few items before the very top so the new batch lands seamlessly.
    final int topVisible = positions
        .map((ItemPosition p) => p.index)
        .reduce((int a, int b) => a < b ? a : b);

    if (topVisible <= 2 &&
        _chatStore.hasMoreOlderMessages &&
        !_chatStore.isLoadingOlderMessages) {
      _chatStore.loadOlderMessages();
    }
  }

  void _onComposerChanged() {
    final t = _textController.text;
    final next = t.startsWith('/');
    if (next != _slashMode) {
      setState(() => _slashMode = next);
    } else if (_slashMode) {
      setState(() {});
    }
  }

  String get _slashQuery =>
      _slashMode && _textController.text.startsWith('/')
          ? _textController.text.substring(1)
          : '';

  void _applyPrompt(Prompt p) {
    _textController.text = p.body;
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    setState(() => _slashMode = false);
    _promptStore.incrementUsage(p.id);
  }

  void _onInputFocusChanged() {
    // Scroll to bottom when input is focused
    if (_inputFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _itemScrollController.scrollTo(
        index: _chatStore.currentMessages.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _currentSearchIndex = -1;
        _highlightedMessageId = null;
      });
    }

    final results = await _chatStore.searchMessages(query);

    setState(() {
      _searchResults = results.map((e) => e.id).toList();
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

  void _scrollToMessage(String messageId) {
    final messages = _chatStore.currentMessages;
    final messageIndex = messages.indexWhere((m) => m.id == messageId);

    if (messageIndex != -1) {
      final int olderLoaderCount = _chatStore.isLoadingOlderMessages ? 1 : 0;
      final int scrollIndex = olderLoaderCount + messageIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _itemScrollController.scrollTo(
          index: scrollIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
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
        room: widget.room!,
        onInfoTap: widget.onInfoTap,
        onAIAnalysisTap: () {
          final roomId = widget.room?.id;
          if (roomId != null) {
            _chatStore.generateDraftResponses(chatRoomId: roomId);
          }
        },
        onSearchTap: () {
          setState(() => _showSearch = !_showSearch);
          if (_showSearch) {
            FocusScope.of(context).requestFocus(FocusNode()..attach(context));
          } else {
            _closeSearch();
          }
        },
      ),
      body: Column(
        children: [
          Observer(
            builder: (_) => DraftResponsePanel(
              drafts: _chatStore.draftResponses.toList(),
              onUse: (draft) {
                _textController.text = draft;
                _textController.selection = TextSelection.collapsed(
                  offset: _textController.text.length,
                );
              },
              onDismiss: () {
                _chatStore.draftResponses.clear();
              },
            ),
          ),
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
          Expanded(
            child: Observer(
              builder: (_) {
                if (_chatStore.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = _chatStore.currentMessages;

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
                        const Text(
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

                final bool showOlderLoader = _chatStore.isLoadingOlderMessages;
                final int olderLoaderCount = showOlderLoader ? 1 : 0;
                final int typingCount = _chatStore.isTyping ? 1 : 0;
                final int itemCount = olderLoaderCount + messages.length + typingCount;

                if (itemCount > _previousItemCount) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  _previousItemCount = itemCount;
                }

                return ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (showOlderLoader && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    final int messageIndex = index - olderLoaderCount;

                    if (messageIndex == messages.length) {
                      return const TypingIndicator(senderName: 'AI Assistant');
                    }

                    final message = messages[messageIndex];
                    final isGroupStart =
                        messageIndex == 0 ||
                        !_sameSender(messages[messageIndex - 1], message);
                    final isGroupEnd =
                        messageIndex == messages.length - 1 ||
                        !_sameSender(message, messages[messageIndex + 1]);

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
          if (_slashMode)
            Observer(
              builder: (_) {
                final filtered = _promptStore.slashFiltered(_slashQuery);
                return SlashPromptPickerOverlay(
                  prompts: filtered,
                  onSelected: _applyPrompt,
                );
              },
            ),
          ChatInputBar(
            controller: _textController,
            onSend: () async {
              final text = _textController.text.trim();
              if (text.isEmpty) {
                return;
              }
              setState(() => _slashMode = false);
              await _chatStore.sendMessage(widget.room!.id, widget.room!.channel.id, widget.room!.contactId, widget.room!.ticketId, text, null);
              _textController.clear();
              _scrollToBottom();
            },
            focusNode: _inputFocusNode,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onItemPositionsChanged);
    _textController.removeListener(_onComposerChanged);
    _textController.dispose();
    _searchController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }
}
