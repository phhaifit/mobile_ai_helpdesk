import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/chat/chat_room.dart';
import '../../domain/entity/chat/message.dart';
import '../../domain/entity/prompt/prompt.dart';
import '../../domain/usecase/chat/realtime/emit_stop_typing_indicator_usecase.dart';
import '../../domain/usecase/chat/realtime/emit_typing_indicator_usecase.dart';
import '../auth/store/auth_store.dart';
import '../prompt/store/prompt_store.dart';
import 'slash_prompt_picker_overlay.dart';
import 'store/chat_room_store.dart';
import 'store/chat_store.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/reply_preview_bar.dart';
import 'widgets/suggested_replies_panel.dart';
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
  late final ChatRoomStore _chatRoomStore;
  late final PromptStore _promptStore;
  late final AuthStore _authStore;
  late final EmitTypingIndicatorUseCase _emitTyping;
  late final EmitStopTypingIndicatorUseCase _emitStopTyping;

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  Timer? _typingIdleTimer;
  bool _isAgentTypingEmitted = false;

  bool _slashMode = false;
  bool _showSearch = false;
  List<String> _searchResults = [];
  int _currentSearchIndex = -1;
  String? _highlightedMessageId;
  Message? _replyingTo;

  @override
  void initState() {
    super.initState();
    _chatStore = getIt<ChatStore>();
    _chatRoomStore = getIt<ChatRoomStore>();
    _promptStore = getIt<PromptStore>();
    _authStore = getIt<AuthStore>();
    _emitTyping = getIt<EmitTypingIndicatorUseCase>();
    _emitStopTyping = getIt<EmitStopTypingIndicatorUseCase>();

    final ChatRoom? room = widget.room;
    if (room?.id != null) {
      _chatRoomStore.setActiveRoomId(room!.id);
      unawaited(
        _chatStore.observeRoom(
          room.id,
          unreadCount: room.unreadCount,
          ticketId: room.ticketId,
          channelId: room.channel.id,
        ),
      );
    }

    _textController.addListener(_onComposerChanged);
    if (_promptStore.templates.isEmpty) {
      _promptStore.loadTemplates();
    }

    _inputFocusNode.addListener(_onInputFocusChanged);
    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  String? get _customerSupportId => _authStore.account?.customerSupportId;

  void _emitAgentTypingIfNeeded() {
    final String? roomId = widget.room?.id;
    if (roomId == null) return;
    if (_isAgentTypingEmitted) return;

    _emitTyping.call(
      params: EmitTypingParams(
        chatRoomId: roomId,
        customerSupportId: _customerSupportId,
        fullname: _authStore.account?.fullname,
        profilePicture: _authStore.account?.profilePicture,
      ),
    );
    _isAgentTypingEmitted = true;
  }

  void _emitAgentStopTyping() {
    final String? roomId = widget.room?.id;
    if (roomId == null) return;
    if (!_isAgentTypingEmitted) return;

    _emitStopTyping.call(
      params: EmitStopTypingParams(
        chatRoomId: roomId,
        customerSupportId: _customerSupportId,
      ),
    );
    _isAgentTypingEmitted = false;
  }

  void _onItemPositionsChanged() {
    final Iterable<ItemPosition> positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // maxVisible is the item highest up on the screen (oldest)
    final int maxVisible = positions
        .map((ItemPosition p) => p.index)
        .reduce((int a, int b) => a > b ? a : b);

    if (maxVisible >= _chatStore.currentMessages.length - 2 &&
        _chatStore.hasMoreOlderMessages &&
        !_chatStore.isLoadingOlderMessages) {
      _chatStore.loadOlderMessages();
    }
  }

  void _onComposerChanged() {
    final String t = _textController.text;
    final bool next = t.startsWith('/');
    if (next != _slashMode) {
      setState(() => _slashMode = next);
    } else if (_slashMode) {
      setState(() {});
    }

    if (t.trim().isEmpty) {
      _typingIdleTimer?.cancel();
      _emitAgentStopTyping();
      return;
    }

    _typingIdleTimer?.cancel();
    _typingIdleTimer = Timer(const Duration(milliseconds: 300), () {
      _emitAgentTypingIfNeeded();
      _typingIdleTimer = Timer(const Duration(seconds: 2), _emitAgentStopTyping);
    });
  }

  String get _slashQuery =>
      _slashMode && _textController.text.startsWith('/')
          ? _textController.text.substring(1)
          : '';

  void _applyPrompt(ResponseTemplate p) {
    _textController.text = p.template;
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    setState(() => _slashMode = false);
  }

  void _onInputFocusChanged() {
    if (_inputFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatStore.currentMessages.isEmpty) return;
      // Index 0 is the newest message at the bottom
      _itemScrollController.jumpTo(index: 0);
    });
  }

  void _scrollToMessage(String messageId) {
    final List<Message> reversedMessages = _chatStore.currentMessages.reversed.toList();
    final int messageIndex = reversedMessages.indexWhere((Message m) => m.id == messageId);

    if (messageIndex != -1) {
      final int typingCount = _chatStore.isSupportTyping ? 1 : 0;
      final int scrollIndex = typingCount + messageIndex; // typing indicator is at 0
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _itemScrollController.scrollTo(
          index: scrollIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _currentSearchIndex = -1;
        _highlightedMessageId = null;
      });
    }

    final List<Message> results = await _chatStore.searchMessages(query);

    setState(() {
      _searchResults = results.map((Message e) => e.id).toList();
      _currentSearchIndex = -1;
      _highlightedMessageId = null;
    });

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

    _scrollToMessage(_highlightedMessageId!);
  }

  void _closeSearch() {
    setState(() {
      _showSearch = false;
      _searchController.clear();
      _searchResults = [];
      _currentSearchIndex = -1;
      _highlightedMessageId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return const SizedBox.expand(
        child: Center(child: Text('Chọn một phòng chat để bắt đầu')),
      );
    }

    final ChatRoom room = widget.room!;

    return Scaffold(
      appBar: ChatAppBar(
        room: room,
        onInfoTap: widget.onInfoTap,
        onAIAnalysisTap: () {
          unawaited(_chatStore.regenerateSuggestedReply());
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
            builder: (_) {
              if (!_chatStore.showSuggestedReplyPanel) {
                return const SizedBox.shrink();
              }
              return SuggestedRepliesPanel(
                isExpanded: _chatStore.isSuggestedReplyPanelExpanded,
                isLoading: _chatStore.isSuggestedReplyLoading,
                suggestion: _chatStore.suggestedReply,
                errorMessage: _chatStore.draftError,
                onRegenerate: () {
                  unawaited(_chatStore.regenerateSuggestedReply());
                },
                onToggleExpanded: _chatStore.toggleSuggestedReplyPanel,
                onDismissSuggestion: _chatStore.dismissSuggestedReply,
                onApplySuggestion: (String draft) {
                  _textController.text = draft;
                  _textController.selection = TextSelection.collapsed(
                    offset: _textController.text.length,
                  );
                },
              );
            },
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

                final List<Message> messages = _chatStore.currentMessages;

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
                final int typingCount = _chatStore.isSupportTyping ? 1 : 0;
                final int itemCount = typingCount + messages.length + olderLoaderCount;

                return ScrollablePositionedList.builder(
                  reverse: true,
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    // A. Typing Indicator at the Bottom (Index 0)
                    if (typingCount > 0 && index == 0) {
                      return TypingIndicator();
                    }

                    // B. Messages
                    final int messageIndex = index - typingCount;
                    if (messageIndex >= 0 && messageIndex < messages.length) {
                      final Message message = messages[messageIndex];
                      
                      // Because list is reversed, visually "above" is messageIndex + 1
                      final bool isGroupStart = messageIndex == messages.length - 1 ||
                          !_sameSender(messages[messageIndex + 1], message);
                          
                      // Visually "below" is messageIndex - 1
                      final bool isGroupEnd = messageIndex == 0 ||
                          !_sameSender(message, messages[messageIndex - 1]);

                      return MessageBubble(
                        message: message,
                        isGroupStart: isGroupStart,
                        isGroupEnd: isGroupEnd,
                        showAvatar: isGroupEnd,
                        isHighlighted: _highlightedMessageId == message.id,
                        onReply: () {
                          setState(() => _replyingTo = message);
                          _inputFocusNode.requestFocus();
                        },
                        onZaloReactionSelected: (String reactIcon) {
                          unawaited(
                            _chatStore.reactToMessage(
                              message: message,
                              reactIcon: reactIcon,
                              chatRoomId: room.id,
                              channelId: room.channel.id,
                            ),
                          );
                        },
                      );
                    }

                    // C. Loader at the Top (Highest Index)
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
                  },
                );
              },
            ),
          ),
          if (_slashMode)
            Observer(
              builder: (_) {
                final List<Prompt> filtered =
                    _promptStore.slashFiltered(_slashQuery);
                return SlashPromptPickerOverlay(
                  prompts: filtered,
                  onSelected: _applyPrompt,
                );
              },
            ),
          if (_replyingTo != null)
            ReplyPreviewBar(
              message: _replyingTo!,
              onCancel: () => setState(() => _replyingTo = null),
            ),
          Observer(
            builder: (_) => ChatInputBar(
              controller: _textController,
              sendEnabled: !_chatStore.isSendingMessage,
              onSend: () async {
                if (_chatStore.isSendingMessage) return;

                final String text = _textController.text.trim();
                if (text.isEmpty) {
                  return;
                }
                _emitAgentStopTyping();
                final String? replyId = _replyingTo?.id;
                setState(() {
                  _slashMode = false;
                  _replyingTo = null;
                });
                _textController.clear();
                await _chatStore.sendMessage(
                  room.id,
                  room.channel.id,
                  room.contactId,
                  room.ticketId,
                  text,
                  null,
                  replyMessageId: replyId,
                );
                _scrollToBottom();
              },
              focusNode: _inputFocusNode,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _typingIdleTimer?.cancel();
    _emitAgentStopTyping();
    _chatRoomStore.setActiveRoomId(null);
    _itemPositionsListener.itemPositions.removeListener(_onItemPositionsChanged);
    _textController.removeListener(_onComposerChanged);
    _textController.dispose();
    _searchController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }
}
