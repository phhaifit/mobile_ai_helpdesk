import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/data/auth/oauth_browser_client.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

/// Performs the Google Drive OAuth 2.0 implicit flow inside an in-app WebView,
/// reusing the [WebViewBrowserClient] already used for Stack Auth.
///
/// Implicit flow keeps the mobile app out of any client-secret handling — the
/// access token is delivered straight to the redirect URL fragment.  We
/// forward the resulting credentials object to the backend, which uses it to
/// pull files from Drive on the user's behalf.
class GoogleDriveOAuthService {
  /// drive.readonly is the minimum scope to ingest files; openid+email gives
  /// us a stable user identifier we ship along with the credentials so BE can
  /// associate the source with a specific Google identity.
  static const _scopes = [
    'https://www.googleapis.com/auth/drive.readonly',
    'openid',
    'email',
    'profile',
  ];

  /// Opens the Google consent screen, captures the redirect, and returns the
  /// parsed credentials object suitable for the BE `/google-drive` endpoint.
  ///
  /// Returns `null` if the user cancels, throws on configuration / parsing
  /// errors so callers can surface a meaningful message.
  Future<GoogleDriveCredentials?> signIn() async {
    final env = EnvConfig.instance;
    if (!env.isGoogleOauthConfigured) {
      throw const GoogleDriveOAuthException(
        'Google OAuth chưa được cấu hình. '
        'Thêm --dart-define=GOOGLE_OAUTH_CLIENT_ID=<id> khi build.',
      );
    }

    final clientId = env.googleOauthClientId;
    final redirectUri = env.googleOauthRedirectUri;
    final state = DateTime.now().microsecondsSinceEpoch.toString();

    final authorizeUri = Uri.https(
      'accounts.google.com',
      '/o/oauth2/v2/auth',
      {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'response_type': 'token',
        'scope': _scopes.join(' '),
        'include_granted_scopes': 'true',
        'state': state,
        'prompt': 'consent',
      },
    );

    final client = WebViewBrowserClient(callbackUrlPrefix: redirectUri);

    String resultUrl;
    try {
      resultUrl = await client.authenticate(
        url: authorizeUri.toString(),
        callbackUrlScheme: 'https',
        forceAccountChooser: true,
      );
    } on OAuthCancelledException {
      return null;
    }

    return _parseImplicitCallback(resultUrl, expectedState: state);
  }

  GoogleDriveCredentials _parseImplicitCallback(
    String url, {
    required String expectedState,
  }) {
    final uri = Uri.parse(url);
    // Implicit flow returns parameters in the URL fragment (#access_token=…).
    final fragment = uri.fragment.isNotEmpty ? uri.fragment : '';
    final fragMap = _parseQuery(fragment);
    final queryMap = uri.queryParameters;

    final error = fragMap['error'] ?? queryMap['error'];
    if (error != null) {
      throw GoogleDriveOAuthException('Google từ chối yêu cầu: $error');
    }

    final accessToken = fragMap['access_token'] ?? queryMap['access_token'];
    if (accessToken == null || accessToken.isEmpty) {
      throw const GoogleDriveOAuthException(
        'Không nhận được access token từ Google.',
      );
    }

    final state = fragMap['state'] ?? queryMap['state'];
    if (state != expectedState) {
      throw const GoogleDriveOAuthException(
        'State không khớp — phiên đăng nhập có thể bị giả mạo.',
      );
    }

    final tokenType = fragMap['token_type'] ?? queryMap['token_type'];
    final expiresInRaw = fragMap['expires_in'] ?? queryMap['expires_in'];
    final scope = fragMap['scope'] ?? queryMap['scope'];

    return GoogleDriveCredentials({
      'accessToken': accessToken,
      if (tokenType != null) 'tokenType': tokenType,
      if (expiresInRaw != null) 'expiresIn': int.tryParse(expiresInRaw),
      if (scope != null) 'scope': scope,
      'obtainedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Map<String, String> _parseQuery(String input) {
    if (input.isEmpty) return const {};
    final out = <String, String>{};
    for (final pair in input.split('&')) {
      final eq = pair.indexOf('=');
      if (eq <= 0) continue;
      final k = Uri.decodeComponent(pair.substring(0, eq));
      final v = Uri.decodeComponent(pair.substring(eq + 1));
      out[k] = v;
    }
    return out;
  }
}

class GoogleDriveOAuthException implements Exception {
  final String message;
  const GoogleDriveOAuthException(this.message);

  @override
  String toString() => message;
}
