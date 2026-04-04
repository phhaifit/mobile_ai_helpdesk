import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';

/// In-memory mock datasource for playground sessions and AI responses.
/// Simulates context-aware responses based on [PlaygroundContextType].
class PlaygroundDataSource {
  final List<PlaygroundSession> _sessions = [];

  // ---------------------------------------------------------------------------
  // Mock AI response banks
  // ---------------------------------------------------------------------------

  static const _lazadaResponses = [
    "Xin chào! Tôi có thể giúp bạn tra cứu đơn hàng. Vui lòng cung cấp mã đơn hàng của bạn nhé.",
    "Đơn hàng #ORD-2026-00{n} của bạn đang trong quá trình giao hàng. Dự kiến đến nơi vào ngày mai từ 8:00 - 18:00.",
    "Chính sách hoàn trả của Lazada cho phép đổi/trả trong vòng **15 ngày** kể từ ngày nhận hàng. Bạn muốn tôi hướng dẫn thủ tục không?",
    "Vấn đề của bạn đã được ghi nhận. Đội ngũ hỗ trợ Lazada sẽ liên hệ trong vòng **2 giờ làm việc**.",
    "Tôi có thể hỗ trợ bạn:\n- Tra cứu đơn hàng\n- Yêu cầu hoàn trả\n- Kiểm tra tình trạng giao hàng\n- Liên hệ người bán\n\nBạn cần hỗ trợ vấn đề nào?",
    "Rất tiếc về sự bất tiện này! Để xử lý khiếu nại, tôi cần bạn cung cấp **ảnh chụp sản phẩm** và **mô tả vấn đề**. Bạn có thể đính kèm ảnh vào đây không?",
    "Đơn hàng của bạn đã được **xác nhận hoàn tiền**. Số tiền sẽ được hoàn về tài khoản trong 3-5 ngày làm việc.",
  ];

  static const _normalResponses = [
    "Xin chào! Tôi là trợ lý AI, rất vui được hỗ trợ bạn hôm nay. Bạn cần giúp đỡ gì?",
    "Cảm ơn bạn đã liên hệ. Tôi hiểu vấn đề của bạn và sẽ cố gắng hỗ trợ tốt nhất.",
    "Dựa trên thông tin bạn cung cấp, đây là một số giải pháp:\n\n1. **Kiểm tra lại cài đặt** trong phần tùy chọn\n2. **Xóa cache** của trình duyệt/ứng dụng\n3. **Liên hệ bộ phận kỹ thuật** nếu vấn đề vẫn tiếp diễn",
    "Tôi đã chuyển yêu cầu của bạn đến đội hỗ trợ chuyên biệt. Họ sẽ phản hồi trong **vòng 24 giờ**.",
    "Câu hỏi rất hay! Giờ làm việc của chúng tôi là **Thứ 2 - Thứ 6, 8:00 - 18:00** và **Thứ 7, 8:00 - 12:00**.",
    "Bạn có thể thanh toán qua:\n- **Thẻ tín dụng/ghi nợ** (Visa, MasterCard)\n- **Chuyển khoản ngân hàng**\n- **Ví điện tử** (MoMo, ZaloPay, VNPay)\n- **Tiền mặt** khi giao hàng (COD)",
    "Tôi rất xin lỗi về trải nghiệm không tốt này. Chúng tôi sẽ ghi nhận phản hồi và cải thiện dịch vụ. Tôi có thể làm gì thêm để hỗ trợ bạn không?",
  ];

  int _responseIndex = 0;

  // ---------------------------------------------------------------------------
  // Pre-seeded mock sessions
  // ---------------------------------------------------------------------------

  PlaygroundDataSource() {
    final session1CreatedAt = DateTime.now().subtract(const Duration(days: 2));
    final session2CreatedAt = DateTime.now().subtract(const Duration(hours: 5));

    _sessions.addAll([
      PlaygroundSession(
        id: 'session-001',
        agentId: 'agent-001',
        contextType: PlaygroundContextType.lazada,
        messages: [
          PlaygroundMessage(
            id: 'msg-001-1',
            content: 'Tôi muốn theo dõi đơn hàng của mình',
            role: MessageRole.user,
            attachments: [],
            timestamp: session1CreatedAt.add(const Duration(minutes: 1)),
          ),
          PlaygroundMessage(
            id: 'msg-001-2',
            content:
                'Xin chào! Tôi có thể giúp bạn tra cứu đơn hàng. Vui lòng cung cấp mã đơn hàng của bạn nhé.',
            role: MessageRole.assistant,
            attachments: [],
            timestamp: session1CreatedAt.add(const Duration(minutes: 1, seconds: 5)),
          ),
          PlaygroundMessage(
            id: 'msg-001-3',
            content: 'Mã đơn hàng ORD-2026-004521',
            role: MessageRole.user,
            attachments: [],
            timestamp: session1CreatedAt.add(const Duration(minutes: 2)),
          ),
          PlaygroundMessage(
            id: 'msg-001-4',
            content:
                'Đơn hàng #ORD-2026-004521 của bạn đang trong quá trình giao hàng. Dự kiến đến nơi vào ngày mai từ 8:00 - 18:00.',
            role: MessageRole.assistant,
            attachments: [],
            timestamp: session1CreatedAt.add(const Duration(minutes: 2, seconds: 8)),
          ),
        ],
        createdAt: session1CreatedAt,
      ),
      PlaygroundSession(
        id: 'session-002',
        agentId: 'agent-003',
        contextType: PlaygroundContextType.normal,
        messages: [
          PlaygroundMessage(
            id: 'msg-002-1',
            content: 'Giờ làm việc của bạn là mấy giờ?',
            role: MessageRole.user,
            attachments: [],
            timestamp: session2CreatedAt.add(const Duration(minutes: 1)),
          ),
          PlaygroundMessage(
            id: 'msg-002-2',
            content:
                'Câu hỏi rất hay! Giờ làm việc của chúng tôi là **Thứ 2 - Thứ 6, 8:00 - 18:00** và **Thứ 7, 8:00 - 12:00**.',
            role: MessageRole.assistant,
            attachments: [],
            timestamp: session2CreatedAt.add(const Duration(minutes: 1, seconds: 4)),
          ),
        ],
        createdAt: session2CreatedAt,
      ),
    ]);
  }

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<List<PlaygroundSession>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_sessions.reversed.toList());
  }

  Future<PlaygroundSession?> getSessionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<PlaygroundSession> createSession(
    PlaygroundContextType contextType,
    String? agentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final session = PlaygroundSession(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      agentId: agentId,
      contextType: contextType,
      messages: [],
      createdAt: DateTime.now(),
    );
    _sessions.add(session);
    return session;
  }

  /// Appends a user message and returns a mock AI response immediately.
  /// The caller (store) is responsible for streaming simulation.
  Future<PlaygroundMessage> sendMessage(
    String sessionId,
    String content,
    List<String> attachments,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx == -1) throw Exception('Session not found: $sessionId');

    final session = _sessions[idx];
    final now = DateTime.now();

    // User message
    final userMsg = PlaygroundMessage(
      id: 'msg-${now.millisecondsSinceEpoch}-u',
      content: content,
      role: MessageRole.user,
      attachments: attachments,
      timestamp: now,
    );

    // Pick mock AI response based on context
    final responses = session.contextType == PlaygroundContextType.lazada
        ? _lazadaResponses
        : _normalResponses;
    final aiText = responses[_responseIndex % responses.length];
    _responseIndex++;

    final aiMsg = PlaygroundMessage(
      id: 'msg-${now.millisecondsSinceEpoch}-a',
      content: aiText,
      role: MessageRole.assistant,
      attachments: [],
      timestamp: now.add(const Duration(milliseconds: 50)),
    );

    final updatedMessages = [...session.messages, userMsg, aiMsg];
    _sessions[idx] = session.copyWith(messages: updatedMessages);

    return aiMsg;
  }

  Future<PlaygroundMessage> editMessage(
    String sessionId,
    String messageId,
    String newContent,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final sIdx = _sessions.indexWhere((s) => s.id == sessionId);
    if (sIdx == -1) throw Exception('Session not found: $sessionId');

    final session = _sessions[sIdx];
    final msgs = List<PlaygroundMessage>.from(session.messages);
    final mIdx = msgs.indexWhere((m) => m.id == messageId);
    if (mIdx == -1) throw Exception('Message not found: $messageId');

    final updated = msgs[mIdx].copyWith(content: newContent);
    msgs[mIdx] = updated;
    _sessions[sIdx] = session.copyWith(messages: msgs);
    return updated;
  }
}
