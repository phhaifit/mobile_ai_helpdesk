import '/constants/env.dart';

class Endpoints {
  Endpoints._();

  // base url — sourced from EnvConfig
  static String get baseUrl => EnvConfig.instance.baseUrl;

  // receiveTimeout — sourced from EnvConfig
  static int get receiveTimeout => EnvConfig.instance.receiveTimeout;

  // connectTimeout — sourced from EnvConfig
  static int get connectionTimeout => EnvConfig.instance.connectionTimeout;

  // AI Agent endpoints (stubs — mock data served locally)
  static String agents() => '/api/agents';
  static String agent(String id) => '/api/agents/$id';

  // Playground endpoints (stubs — mock data served locally)
  static String playgroundSessions() => '/api/playground/sessions';
  static String playgroundSession(String id) =>
      '/api/playground/sessions/$id';
  static String playgroundMessages(String sessionId) =>
      '/api/playground/sessions/$sessionId/messages';

  // Chat endpoints
  static String chatRoom() => '/api/chat-room';
  static String chatRoomCounter() => '$chatRoom/counter';
  static String chatRoomDetail() => '$chatRoom/detail';
  static String chatRoomSeen() => '$chatRoom/seen';
  static String chatRoomAnalyzeTicket() => '$chatRoom/ticket-analysis';

  // Message endpoints
  static String message() => '$chatRoom/message';
  static String newerMessage() => '$message/newer-message';
  static String csToCustomer() => '$message/cs-to-customer';
  static String countSearchResult(String chatRoomId) => '$message/$chatRoomId/count-search';
  static String searchGroupedByChatRoomMessage() => '$message/search-group';
  static String flatSearchMessageList() => '$message/search-list';
  static String reactToMessage() => '$message/react';
  static String unreactToMessage() => '$message/unreact';

  // AI Draft Response endpoints
  static String draftResponse() => '$chatRoom/draft-response';
  static String streamDraftResponse() => '$draftResponse/stream';
}
