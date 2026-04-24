class SocketDraftResponseProgressEvent {
  static const String name = 'SOCKET_DRAFT_RESPONSE_PROGRESS';

  final String taskId;
  final String step;
  final String status;
  final Map<String, dynamic>? result;

  SocketDraftResponseProgressEvent({
    required this.taskId,
    required this.step,
    required this.status,
    required this.result,
  });

  static SocketDraftResponseProgressEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final taskId = (m['taskId'] ?? '').toString();
    final step = (m['step'] ?? '').toString();
    final status = (m['status'] ?? '').toString();
    if (taskId.isEmpty || step.isEmpty || status.isEmpty) return null;
    return SocketDraftResponseProgressEvent(
      taskId: taskId,
      step: step,
      status: status,
      result: m['result'] is Map ? (m['result'] as Map).cast<String, dynamic>() : null,
    );
  }
}

