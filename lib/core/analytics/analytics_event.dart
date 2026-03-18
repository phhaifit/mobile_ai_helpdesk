/// Central definition of analytics event names and parameter keys.
/// Used by [AnalyticsService] and documented in ANALYTICS.md.
class AnalyticsEvent {
  AnalyticsEvent._();

  // --- Screen view (handled via logScreenView) ---
  // Screen names are in [AnalyticsScreen].

  // --- Custom events ---
  static const String login = 'login';
  static const String ticketCreated = 'ticket_created';
  static const String agentUsed = 'agent_used';
  static const String logout = 'logout';

  // --- Parameter keys (for custom events) ---
  static const String paramMethod = 'method'; // e.g. 'email', 'google'
  static const String paramTicketId = 'ticket_id';
  static const String paramChannel = 'channel';
  static const String paramAgentType = 'agent_type'; // e.g. 'chatbot', 'human'
  static const String paramSuccess = 'success';
}
