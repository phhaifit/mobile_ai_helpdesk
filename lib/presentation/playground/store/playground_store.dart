import 'dart:async';

import 'package:mobx/mobx.dart';

import '/core/stores/error/error_store.dart';
import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';
import '/domain/usecase/playground/create_session_usecase.dart';
import '/domain/usecase/playground/get_draft_response_usecase.dart';
import '/domain/usecase/playground/get_sessions_usecase.dart';
import '/domain/usecase/playground/send_playground_message_usecase.dart';
import '/domain/usecase/playground/stream_draft_response_usecase.dart';

part 'playground_store.g.dart';

class PlaygroundStore = _PlaygroundStore with _$PlaygroundStore;

abstract class _PlaygroundStore with Store {
  _PlaygroundStore(
    this._getSessionsUseCase,
    this._createSessionUseCase,
    this._sendMessageUseCase,
    this._getDraftResponseUseCase,
    this._streamDraftResponseUseCase,
    this.errorStore,
  );

  // use cases:-----------------------------------------------------------------
  final GetSessionsUseCase _getSessionsUseCase;
  final CreateSessionUseCase _createSessionUseCase;
  final SendPlaygroundMessageUseCase _sendMessageUseCase;
  final GetDraftResponseUseCase _getDraftResponseUseCase;
  final StreamDraftResponseUseCase _streamDraftResponseUseCase;

  // stores:--------------------------------------------------------------------
  final ErrorStore errorStore;

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<List<PlaygroundSession>?> emptySessionsResponse =
      ObservableFuture.value(null);

  // store variables:-----------------------------------------------------------
  @observable
  ObservableFuture<List<PlaygroundSession>?> fetchSessionsFuture =
      emptySessionsResponse;

  @observable
  ObservableList<PlaygroundSession> sessions = ObservableList.of([]);

  /// The session currently open in the chat view.
  /// Managed independently from [sessions] to support real-time message updates.
  @observable
  PlaygroundSession? activeSession;

  /// True while the AI response is being streamed character-by-character.
  @observable
  bool isStreaming = false;

  // draft response state:------------------------------------------------------
  @observable
  String draftResponse = '';

  @observable
  bool isDraftLoading = false;

  @observable
  bool isDraftStreaming = false;

  StreamSubscription<String>? _draftStreamSubscription;

  // computed:------------------------------------------------------------------
  @computed
  bool get isLoadingSessions =>
      fetchSessionsFuture.status == FutureStatus.pending;

  @computed
  List<PlaygroundMessage> get messages => activeSession?.messages ?? [];

  // actions:-------------------------------------------------------------------

  @action
  Future<void> fetchSessions() async {
    errorStore.errorMessage = '';
    final future = _getSessionsUseCase.call(params: null);
    fetchSessionsFuture = ObservableFuture(future);
    await future.then((result) {
      sessions = ObservableList.of(result);
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    });
  }

  @action
  void openSession(PlaygroundSession session) {
    activeSession = session;
  }

  @action
  void openSessionById(String sessionId) {
    final idx = sessions.indexWhere((s) => s.id == sessionId);
    if (idx >= 0) activeSession = sessions[idx];
  }

  @action
  Future<void> createSession(
    PlaygroundContextType contextType,
    String? agentId,
  ) async {
    errorStore.errorMessage = '';
    await _createSessionUseCase
        .call(
          params: CreateSessionParams(
            contextType: contextType,
            agentId: agentId,
          ),
        )
        .then((session) {
          sessions.insert(0, session);
          activeSession = session;
        })
        .catchError((e) {
          errorStore.errorMessage = e.toString();
        });
  }

  @action
  Future<void> sendMessage(
    String content, {
    List<String> attachments = const [],
  }) async {
    if (activeSession == null || isStreaming) return;
    errorStore.errorMessage = '';

    // 1. Optimistically add user message to activeSession.
    final userMsg = PlaygroundMessage(
      id: 'msg-user-${DateTime.now().millisecondsSinceEpoch}',
      role: MessageRole.user,
      content: content,
      attachments: attachments,
      timestamp: DateTime.now(),
    );
    activeSession = activeSession!.copyWith(
      messages: [...activeSession!.messages, userMsg],
    );

    // 2. Fetch AI response (datasource persists both messages internally).
    PlaygroundMessage? aiResponse;
    try {
      aiResponse = await _sendMessageUseCase.call(
        params: SendMessageParams(
          sessionId: activeSession!.id,
          content: content,
          attachments: attachments,
        ),
      );
    } catch (e) {
      errorStore.errorMessage = e.toString();
    }

    if (aiResponse == null) return;

    // 3. Add a streaming placeholder (empty content) to activeSession.
    final placeholder = aiResponse.copyWith(content: '', isStreaming: true);
    activeSession = activeSession!.copyWith(
      messages: [...activeSession!.messages, placeholder],
    );
    isStreaming = true;

    // 4. Reveal content char-by-char with ~30 ms interval.
    final fullText = aiResponse.content;
    int charIndex = 0;
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (charIndex >= fullText.length) {
        timer.cancel();
        runInAction(() {
          if (activeSession == null) return;
          final msgs = List<PlaygroundMessage>.from(activeSession!.messages);
          msgs[msgs.length - 1] = msgs.last.copyWith(
            content: fullText,
            isStreaming: false,
          );
          activeSession = activeSession!.copyWith(messages: msgs);
          isStreaming = false;
        });
        return;
      }
      charIndex++;
      final partial = fullText.substring(0, charIndex);
      runInAction(() {
        if (activeSession == null) return;
        final msgs = List<PlaygroundMessage>.from(activeSession!.messages);
        msgs[msgs.length - 1] = msgs.last.copyWith(
          content: partial,
          isStreaming: true,
        );
        activeSession = activeSession!.copyWith(messages: msgs);
      });
    });
  }

  /// Edits the content of a message already in [activeSession].
  @action
  void editMessage(String messageId, String newContent) {
    if (activeSession == null) return;
    final updatedMessages = activeSession!.messages.map((m) {
      return m.id == messageId ? m.copyWith(content: newContent) : m;
    }).toList();
    activeSession = activeSession!.copyWith(messages: updatedMessages);
  }

  @action
  void closeSession() {
    activeSession = null;
    isStreaming = false;
  }

  // draft response actions:----------------------------------------------------

  @action
  Future<void> fetchDraftResponse(DraftResponseParams params) async {
    isDraftLoading = true;
    draftResponse = '';
    errorStore.errorMessage = '';
    await _getDraftResponseUseCase.call(params: params).then((text) {
      draftResponse = text;
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    }).whenComplete(() {
      isDraftLoading = false;
    });
  }

  @action
  void startDraftStream(DraftResponseParams params) {
    _draftStreamSubscription?.cancel();
    draftResponse = '';
    isDraftStreaming = true;
    errorStore.errorMessage = '';

    final stream =
        _streamDraftResponseUseCase.call(params: params) as Stream<String>;
    _draftStreamSubscription = stream.listen(
      (chunk) => runInAction(() => draftResponse += chunk),
      onError: (dynamic e) => runInAction(() {
        errorStore.errorMessage = e.toString();
        isDraftStreaming = false;
      }),
      onDone: () => runInAction(() => isDraftStreaming = false),
    );
  }

  @action
  void cancelDraftStream() {
    _draftStreamSubscription?.cancel();
    _draftStreamSubscription = null;
    isDraftStreaming = false;
  }
}
