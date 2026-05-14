import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/di/service_locator.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';
import '/domain/usecase/media/upload_file_usecase.dart';
import '/presentation/jarvis/store/jarvis_store.dart';
import '/presentation/playground/store/playground_store.dart';
import '/presentation/playground/widgets/context_selector.dart';
import '/presentation/playground/widgets/draft_response_panel.dart';
import '/presentation/playground/widgets/playground_input_bar.dart';
import '/presentation/playground/widgets/playground_message_bubble.dart';
import '/presentation/playground/widgets/session_history_drawer.dart';
import '/presentation/playground/widgets/streaming_indicator.dart';
import '/presentation/playground/widgets/suggestion_chips.dart';
import '/utils/locale/app_localization.dart';

/// Main AI Chat Playground screen.
///
/// Widget Tree:
/// Scaffold
///   ├── AppBar (title, history drawer button)
///   ├── Drawer → SessionHistoryDrawer
///   └── Body → Column
///       ├── ContextSelector (lazada / normal)
///       ├── SuggestionChips (quick prompts in empty state)
///       ├── Expanded → ListView (messages + StreamingIndicator)
///       ├── DraftResponsePanel (optional, when drafts available)
///       └── PlaygroundInputBar (input + attach)
class PlaygroundScreen extends StatefulWidget {
  /// Optional agent pre-loaded for this playground session.
  final AiAgent? agent;

  const PlaygroundScreen({super.key, this.agent});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  static const String _defaultTenant = 'default_tenant';
  static const String _playgroundUserId = 'playground-user';

  late final PlaygroundStore _store;
  late final JarvisStore _jarvisStore;
  late final SharedPreferenceHelper _prefs;
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _inputCtrl = TextEditingController();

  PlaygroundContextType _contextType = PlaygroundContextType.normal;
  bool _showDrafts = false;
  List<String> _drafts = [];
  List<PlatformFile> _pendingAttachments = [];

  @override
  void initState() {
    super.initState();
    _store = getIt<PlaygroundStore>();
    _jarvisStore = getIt<JarvisStore>();
    _prefs = getIt<SharedPreferenceHelper>();
    _store.fetchSessions().then((_) {
      if (_store.sessions.isNotEmpty && _store.activeSession == null) {
        _store.openSession(_store.sessions.first);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _newSession() async {
    await _store.createSession(_contextType, widget.agent?.id);
    _scrollToBottom();
  }

  Future<void> _onSend(String text) async {
    final filesToUpload = _consumePendingAttachments();
    final uploadedUrls = await _uploadAttachments(filesToUpload);

    await _store.sendMessage(text, attachments: uploadedUrls);
    _scrollToBottom();

    await _fetchDraftFromSession();
    await _fetchDraftFromJarvis(text, uploadedUrls);
  }

  List<PlatformFile> _consumePendingAttachments() {
    final files = List<PlatformFile>.from(_pendingAttachments);
    if (files.isEmpty) {
      return files;
    }

    setState(() => _pendingAttachments = []);
    return files;
  }

  Future<List<String>> _uploadAttachments(List<PlatformFile> files) async {
    if (files.isEmpty) {
      return <String>[];
    }

    final uploadUseCase = getIt<UploadFileUseCase>();
    final tenantId = await _resolveTenantId();
    final urls = <String>[];

    for (final file in files) {
      try {
        final media = await uploadUseCase.call(
          params: UploadFileParams(tenantId: tenantId, file: file),
        );
        urls.add(media.url);
      } catch (_) {
        // Skip files that fail to upload — don't block the message.
      }
    }

    return urls;
  }

  Future<void> _fetchDraftFromSession() async {
    final session = _store.activeSession;
    if (session == null || session.messages.isEmpty) {
      return;
    }

    final params = _buildDraftParams(session);
    await _store.fetchDraftResponse(params);

    if (!mounted) {
      return;
    }

    final draft = _store.draftResponse.trim();
    _setDraftVisibility(draft.isEmpty ? <String>[] : <String>[draft]);
  }

  DraftResponseParams _buildDraftParams(PlaygroundSession session) {
    return DraftResponseParams(
      chatHistory: session.messages
          .map(
            (message) => <String, String>{
              'role': message.role.name,
              'content': message.content,
            },
          )
          .toList(),
      channel: _contextType == PlaygroundContextType.lazada ? 'lazada' : 'chat',
      type: 'draft_response',
      defaultConfigType: const <String>['playground'],
      tenantID: '',
      ticketID: session.id,
      chatRoomID: session.id,
      customerID: _playgroundUserId,
    );
  }

  Future<void> _fetchDraftFromJarvis(String text, List<String> imageUrls) async {
    final tenantId = await _resolveTenantId();

    final response = await _jarvisStore.sendMessage(
      tenantId: tenantId,
      userId: tenantId,
      userRole: 'agent',
      message: text,
      sessionId: _store.activeSession?.id,
      imageUrls: imageUrls,
    );

    if (!mounted) {
      return;
    }

    if (response != null && response.requiresConfirmation) {
      _setDraftVisibility([response.message]);
    }
  }

  Future<String> _resolveTenantId() async {
    return await _prefs.tenantId ?? _defaultTenant;
  }

  void _setDraftVisibility(List<String> drafts) {
    setState(() {
      _drafts = drafts;
      _showDrafts = drafts.isNotEmpty;
    });
  }

  void _dismissDrafts() {
    _setDraftVisibility(<String>[]);
  }

  void _applyDraft(String draft) {
    _inputCtrl.text = draft;
    _inputCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: draft.length),
    );
    _dismissDrafts();
  }

  List<String> _buildSuggestions(AppLocalizations l) {
    return [
      l.translate('playground_suggestion_return'),
      l.translate('playground_suggestion_order_status'),
      l.translate('playground_suggestion_refund_policy'),
      l.translate('playground_suggestion_contact_support'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final suggestions = _buildSuggestions(l);

    return Scaffold(
      appBar: _buildAppBar(context, l),
      drawer: SessionHistoryDrawer(
        store: _store,
        onNewSession: () {
          Navigator.pop(context);
          _newSession();
        },
      ),
      body: _buildBody(suggestions),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (ctx) => Navigator.canPop(ctx)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(ctx),
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
      ),
      title: Text(l.translate('playground_title')),
      actions: [
        Observer(
          builder: (_) => IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: l.translate('playground_new_session'),
            onPressed: _newSession,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(List<String> suggestions) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.horizontalPadding,
            vertical: 8,
          ),
          child: ContextSelector(
            selected: _contextType,
            onChanged: (type) => setState(() => _contextType = type),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Observer(
            builder: (_) => _buildMessagesArea(suggestions),
          ),
        ),
        if (_showDrafts)
          DraftResponsePanel(
            drafts: _drafts,
            onUse: _applyDraft,
            onDismiss: _dismissDrafts,
          ),
        Observer(
          builder: (_) => PlaygroundInputBar(
            enabled: _store.activeSession != null && !_store.isStreaming,
            controller: _inputCtrl,
            onSend: _onSend,
            onAttachmentsChanged: (list) =>
                setState(() => _pendingAttachments = list),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesArea(List<String> suggestions) {
    final messages = _store.messages;
    final isStreaming = _store.isStreaming;

    if (_store.activeSession == null) {
      return _EmptyState(
        suggestions: suggestions,
        onSuggestionTap: (suggestion) {
          _newSession().then((_) => _onSend(suggestion));
        },
        onNewSession: _newSession,
      );
    }

    if (messages.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 16),
          SuggestionChips(
            suggestions: suggestions,
            onSelected: _onSend,
          ),
        ],
      );
    }

    _scrollToBottom();
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length + (isStreaming ? 1 : 0),
      itemBuilder: (_, index) {
        if (isStreaming && index == messages.length) {
          return const StreamingIndicator();
        }

        final message = messages[index];
        if (message.isStreaming && message.content.isEmpty) {
          return const SizedBox.shrink();
        }

        return PlaygroundMessageBubble(
          message: message,
          onEdit: () => _showEditDialog(message.id, message.content),
        );
      },
    );
  }

  void _showEditDialog(String messageId, String currentContent) {
    final ctrl = TextEditingController(text: currentContent);
    showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('playground_edit_message'),
        ),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).translate('ai_agent_cancel'),
            ),
          ),
          FilledButton(
            onPressed: () {
              _store.editMessage(messageId, ctrl.text.trim());
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('ai_agent_save'),
            ),
          ),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }
}

class _EmptyState extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onNewSession;

  const _EmptyState({
    required this.suggestions,
    required this.onSuggestionTap,
    required this.onNewSession,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.horizontalPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l.translate('playground_title'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l.translate('playground_no_sessions'),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.translate('playground_new_session')),
              onPressed: onNewSession,
            ),
            const SizedBox(height: 24),
            SuggestionChips(
              suggestions: suggestions,
              onSelected: onSuggestionTap,
            ),
          ],
        ),
      ),
    );
  }
}
