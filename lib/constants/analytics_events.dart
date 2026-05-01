/// Standard analytics event names for user acquisition tracking.
///
/// These constants define all trackable events in the application.
/// They follow Firebase Analytics naming conventions:
/// - Snake_case naming
/// - Maximum 40 characters
/// - No special characters except underscore
///
/// Usage:
/// ```dart
/// await analyticsService.trackEvent(
///   AnalyticsEvents.userLogin,
///   {'method': 'email', 'success': 'true'},
/// );
/// ```
class AnalyticsEvents {
  AnalyticsEvents._();

  // ============================================================================
  // First Launch & Installation Events
  // ============================================================================

  /// Fired when app is opened for the first time (Firebase auto-event).
  /// Firebase automatically fires this event, but we can add custom params.
  static const String firstOpen = 'first_open';

  /// Custom event fired when we detect first app open and track installation.
  /// Parameters: install_source, session_id, app_version
  static const String installEvent = 'install';

  /// Fired every time the app is opened (session start).
  /// Used to track daily active users and sessions.
  static const String appOpen = 'app_open';

  // ============================================================================
  // Navigation & Screen Events
  // ============================================================================

  /// Fired when user navigates to a new screen.
  /// Firebase auto-tracks this via screenView, but we can add custom params.
  /// Parameters: screen_name, screen_class, utm_source, utm_campaign, etc.
  static const String screenView = 'screen_view';

  // ============================================================================
  // Authentication Events
  // ============================================================================

  /// Fired when user successfully logs in or fails to log in.
  /// Parameters: method (email/phone/biometric), success (true/false), error_code
  static const String userLogin = 'user_login';

  /// Fired when user logs out.
  /// Parameters: none (optional: reason)
  static const String userLogout = 'user_logout';

  /// Fired when user creates a new account.
  /// Parameters: method (email/phone/social), success (true/false)
  static const String userSignup = 'user_signup';

  /// Fired when user attempts password reset.
  /// Parameters: method, success (true/false)
  static const String passwordReset = 'password_reset';

  /// Fired when user views but skips authentication.
  /// Parameters: screen_name
  static const String skipAuth = 'skip_auth';

  // ============================================================================
  // Ticket/Support Events
  // ============================================================================

  /// Fired when user creates a new support ticket.
  /// Parameters: category, priority, channel (email/chat/phone)
  static const String ticketCreated = 'ticket_created';

  /// Fired when user views a ticket detail.
  /// Parameters: ticket_id, status, priority
  static const String ticketViewed = 'ticket_viewed';

  /// Fired when user updates a ticket.
  /// Parameters: ticket_id, field_updated, new_value
  static const String ticketUpdated = 'ticket_updated';

  /// Fired when user closes/resolves a ticket.
  /// Parameters: ticket_id, reason, resolution_time_minutes
  static const String ticketClosed = 'ticket_closed';

  /// Fired when user searches for tickets.
  /// Parameters: query, result_count, filters_applied
  static const String ticketSearched = 'ticket_searched';

  // ============================================================================
  // Messaging/Chat Events
  // ============================================================================

  /// Fired when user sends a message.
  /// Parameters: channel (chat/email), conversation_id
  static const String messageSent = 'message_sent';

  /// Fired when user views a conversation.
  /// Parameters: conversation_id, participant_count
  static const String conversationViewed = 'conversation_viewed';

  /// Fired when user starts a new conversation.
  /// Parameters: type (support/inquiry/feedback)
  static const String conversationStarted = 'conversation_started';

  /// Fired when user receives a new message.
  /// Parameters: from_user_type (agent/customer), conversation_id
  static const String messageReceived = 'message_received';

  // ============================================================================
  // User Profile Events
  // ============================================================================

  /// Fired when user views their profile.
  /// Parameters: tab_viewed (info/settings/history)
  static const String profileViewed = 'profile_viewed';

  /// Fired when user edits their profile.
  /// Parameters: field_updated (name/email/phone/avatar)
  static const String profileUpdated = 'profile_updated';

  /// Fired when user changes settings.
  /// Parameters: setting_name, old_value, new_value
  static const String settingsChanged = 'settings_changed';

  /// Fired when user changes language preference.
  /// Parameters: from_language, to_language
  static const String languageChanged = 'language_changed';

  // ============================================================================
  // Search & Discovery Events
  // ============================================================================

  /// Fired when user performs a search.
  /// Parameters: search_term, result_count, category
  static const String search = 'search';

  /// Fired when user applies filters.
  /// Parameters: filter_name, filter_value, result_count
  static const String filterApplied = 'filter_applied';

  /// Fired when user clicks on a search result.
  /// Parameters: search_term, result_position
  static const String searchResultClicked = 'search_result_clicked';

  // ============================================================================
  // Performance & Technical Events
  // ============================================================================

  /// Fired when an error occurs in the app.
  /// Parameters: error_type, error_message, screen_name
  /// NOTE: Do NOT include sensitive error details that could contain PII
  static const String errorOccurred = 'error_occurred';

  /// Fired when app crashes or recovers from a crash.
  /// Parameters: crash_reason, timestamp
  static const String appCrash = 'app_crash';

  /// Fired when an API call fails.
  /// Parameters: endpoint, error_code, retry_count
  static const String apiError = 'api_error';

  /// Fired when a long operation completes.
  /// Parameters: operation_name, duration_seconds, success (true/false)
  static const String operationCompleted = 'operation_completed';

  // ============================================================================
  // Feature Adoption Events
  // ============================================================================

  /// Fired when user first discovers or uses a feature.
  /// Parameters: feature_name, entry_point
  static const String featureDiscovered = 'feature_discovered';

  /// Fired when user interacts with onboarding.
  /// Parameters: step_number, action (completed/skipped)
  static const String onboardingEvent = 'onboarding_event';

  /// Fired for A/B testing variations.
  /// Parameters: experiment_name, variant_name
  static const String experimentViewed = 'experiment_viewed';

  // ============================================================================
  // Engagement Events
  // ============================================================================

  /// Fired when user rates the app or provides feedback.
  /// Parameters: rating (1-5), feedback_text (sanitized, no PII)
  static const String feedbackProvided = 'feedback_provided';

  /// Fired when user shares the app or content.
  /// Parameters: share_method (social/email/link)
  static const String contentShared = 'content_shared';

  /// Fired when user bookmarks or favorites content.
  /// Parameters: content_type, content_id
  static const String contentFavorited = 'content_favorited';

  // ============================================================================
  // Help & Support Events
  // ============================================================================

  /// Fired when user accesses help or FAQ.
  /// Parameters: section, search_term
  static const String helpAccessed = 'help_accessed';

  /// Fired when user contacts support.
  /// Parameters: contact_method (chat/email/phone), topic
  static const String supportContacted = 'support_contacted';

  /// Fired when user opens knowledge base article.
  /// Parameters: article_id, category, search_origin (true/false)
  static const String articleViewed = 'article_viewed';

  // ============================================================================
  // Marketing / Broadcasting Events
  // ============================================================================

  /// Fired when a broadcast template is created.
  /// Parameters: channel, category
  static const String marketingTemplateCreated = 'marketing_template_created';

  /// Fired when a broadcast template is updated.
  /// Parameters: template_id, channel, category
  static const String marketingTemplateUpdated = 'marketing_template_updated';

  /// Fired when a broadcast template is deleted.
  /// Parameters: template_id
  static const String marketingTemplateDeleted = 'marketing_template_deleted';

  /// Fired when a broadcast campaign is created.
  /// Parameters: channel, template_id
  static const String marketingCampaignCreated = 'marketing_campaign_created';

  /// Fired when a broadcast campaign is started (executed).
  /// Parameters: campaign_id, channel, recipient_count
  static const String marketingCampaignStarted = 'marketing_campaign_started';

  /// Fired when a broadcast campaign is paused.
  /// Parameters: campaign_id
  static const String marketingCampaignPaused = 'marketing_campaign_paused';

  /// Fired when a broadcast campaign is resumed.
  /// Parameters: campaign_id
  static const String marketingCampaignResumed = 'marketing_campaign_resumed';

  /// Fired when a broadcast campaign reaches completed status via realtime.
  /// Parameters: campaign_id, sent_count, delivered_count, failed_count
  static const String marketingCampaignCompleted =
      'marketing_campaign_completed';

  /// Fired when a broadcast campaign reaches failed status via realtime.
  /// Parameters: campaign_id
  static const String marketingCampaignFailed = 'marketing_campaign_failed';

  /// Fired when a Facebook admin account is connected or reauthed.
  /// Parameters: account_id
  static const String marketingFacebookConnected =
      'marketing_facebook_connected';

  /// Fired when a Facebook admin account is disconnected.
  /// Parameters: account_id
  static const String marketingFacebookDisconnected =
      'marketing_facebook_disconnected';

  /// Fired when audience filtering completes.
  /// Parameters: recipient_count, filter_type
  static const String marketingAudienceFiltered = 'marketing_audience_filtered';
}
