class SocketDraftResponseProgressEvent {
  static const String name = 'SOCKET_DRAFT_RESPONSE_PROGRESS';

  final String taskId;
  final String? step;
  final String status;
  final Map<String, dynamic>? result;
  final int? timestamp;

  SocketDraftResponseProgressEvent({
    required this.taskId,
    required this.status,
    this.step,
    this.result,
    this.timestamp,
  });

  static SocketDraftResponseProgressEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final Map<String, dynamic> m = payload.cast<String, dynamic>();
    final String taskId = (m['taskId'] ?? '').toString();
    final String status = (m['status'] ?? '').toString();
    if (taskId.isEmpty || status.isEmpty) return null;

    final Object? stepRaw = m['step'];
    final String? step = stepRaw == null
        ? null
        : stepRaw.toString().trim().isEmpty
            ? null
            : stepRaw.toString();

    final int? timestamp = m['timestamp'] is num
        ? (m['timestamp'] as num).toInt()
        : null;

    return SocketDraftResponseProgressEvent(
      taskId: taskId,
      step: step,
      status: status,
      result: m['result'] is Map
          ? (m['result'] as Map).cast<String, dynamic>()
          : null,
      timestamp: timestamp,
    );
  }

  /// Primary suggestion text from `result.response[]` (lowest order).
  String? extractPrimarySuggestionText() {
    final Map<String, dynamic>? resultMap = result;
    if (resultMap == null) return null;

    final Object? responseRaw = resultMap['response'];
    if (responseRaw is! List || responseRaw.isEmpty) return null;

    final List<Map<String, dynamic>> items = responseRaw
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> e) => e.cast<String, dynamic>())
        .toList(growable: false);
    if (items.isEmpty) return null;

    items.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      final int orderA = a['order'] is num ? (a['order'] as num).toInt() : 0;
      final int orderB = b['order'] is num ? (b['order'] as num).toInt() : 0;
      return orderA.compareTo(orderB);
    });

    final String content = (items.first['content'] ?? '').toString().trim();
    return content.isEmpty ? null : content;
  }
}
