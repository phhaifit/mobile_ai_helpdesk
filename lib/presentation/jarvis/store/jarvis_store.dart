import 'package:mobx/mobx.dart';

import '/core/stores/error/error_store.dart';
import '/domain/entity/jarvis/jarvis_message.dart';
import '/domain/usecase/jarvis/confirm_hitl_usecase.dart';
import '/domain/usecase/jarvis/send_jarvis_message_usecase.dart';

part 'jarvis_store.g.dart';

class JarvisStore = _JarvisStore with _$JarvisStore;

abstract class _JarvisStore with Store {
  _JarvisStore(
    this._sendMessageUseCase,
    this._confirmHitlUseCase,
    this.errorStore,
  );

  final SendJarvisMessageUseCase _sendMessageUseCase;
  final ConfirmHitlUseCase _confirmHitlUseCase;
  final ErrorStore errorStore;

  @observable
  bool isLoading = false;

  @observable
  JarvisResponse? lastResponse;

  @observable
  bool requiresConfirmation = false;

  @observable
  String? pendingSessionId;

  @action
  Future<JarvisResponse?> sendMessage({
    required String tenantId,
    required String userId,
    required String userRole,
    required String message,
    List<String> history = const [],
    String? sessionId,
    List<String> imageUrls = const [],
  }) async {
    isLoading = true;
    errorStore.errorMessage = '';
    try {
      final dto = JarvisMessageDto(
        userId: userId,
        userRole: userRole,
        message: message,
        history: history,
        sessionId: sessionId,
        messageImages: imageUrls,
      );
      final response = await _sendMessageUseCase.call(
        params: SendJarvisMessageParams(tenantId: tenantId, dto: dto),
      );
      lastResponse = response;
      requiresConfirmation = response.requiresConfirmation;
      if (response.requiresConfirmation) {
        pendingSessionId = response.sessionId;
      }
      return response;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<JarvisResponse?> confirmHitl({
    required String tenantId,
    required String userId,
    required HitlAction action,
    String? language,
  }) async {
    if (pendingSessionId == null) return null;
    isLoading = true;
    errorStore.errorMessage = '';
    try {
      final dto = JarvisConfirmDto(
        userId: userId,
        sessionId: pendingSessionId!,
        action: action,
        language: language,
      );
      final response = await _confirmHitlUseCase.call(
        params: ConfirmHitlParams(tenantId: tenantId, dto: dto),
      );
      lastResponse = response;
      requiresConfirmation = false;
      pendingSessionId = null;
      return response;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearError() {
    errorStore.errorMessage = '';
  }
}
