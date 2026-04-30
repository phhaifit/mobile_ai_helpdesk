class MessengerOauthConfig {
  MessengerOauthConfig._();

  static const String facebookAppId = '4008027856152613';
  static const String state = 'ticketplus_messenger_integration';
  static const String facebookOauthVersion = 'v19.0';
  static const String redirectPath = '/messenger-oauth';
  static const String prodRedirectUri =
      'https://helpdesk.jarvis.cx$redirectPath';

  static const List<String> scopes = <String>[
    'business_management',
    'pages_messaging',
    'pages_show_list',
    'pages_read_engagement',
    'pages_manage_metadata',
    'pages_read_user_content',
    'pages_manage_ads',
    'pages_manage_posts',
    'pages_manage_engagement',
    'page_events',
    'pages_messaging_subscriptions',
    'ads_management',
    'paid_marketing_messages',
  ];

  static String buildAuthorizeUrl({required String redirectUri}) {
    final Map<String, String> params = <String, String>{
      'client_id': facebookAppId,
      'redirect_uri': redirectUri,
      'state': state,
      'response_type': 'code',
      'scope': scopes.join(','),
    };
    final String query = params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
    return 'https://www.facebook.com/$facebookOauthVersion/dialog/oauth?$query';
  }
}
