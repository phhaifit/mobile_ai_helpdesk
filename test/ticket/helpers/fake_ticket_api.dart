import 'package:ai_helpdesk/core/data/network/dio/configs/dio_configs.dart';
import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';

/// Test double for [TicketApi].
/// Overrides all network methods — Dio is never called.
/// Set [xxxResponse] to control return values; inspect [lastXxx] for captured args.
class FakeTicketApi extends TicketApi {
  // --- configurable return values ---
  List<dynamic> customerTicketsResponse = [];
  List<dynamic> commentsResponse = [];
  Map<String, dynamic> addCommentResponse = {};

  // --- captured arguments ---
  String? lastGetCustomerTicketsId;
  String? lastGetCommentsTicketId;
  String? lastAddCommentTicketId;
  String? lastAddCommentContent;
  String? lastDeleteCommentId;

  FakeTicketApi()
      : super(DioClient(
          dioConfigs: const DioConfigs(baseUrl: 'http://fake.test'),
        ));

  @override
  Future<List<dynamic>> getCustomerTickets(String customerId) async {
    lastGetCustomerTicketsId = customerId;
    return customerTicketsResponse;
  }

  @override
  Future<List<dynamic>> getComments(String ticketId) async {
    lastGetCommentsTicketId = ticketId;
    return commentsResponse;
  }

  @override
  Future<Map<String, dynamic>> addComment(
    String ticketId,
    String content,
  ) async {
    lastAddCommentTicketId = ticketId;
    lastAddCommentContent = content;
    return addCommentResponse;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    lastDeleteCommentId = commentId;
  }
}
