import 'dart:convert';
import 'dart:io' show Platform;

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

/// Outcome of a successful Google Drive sign-in.
///
/// Carries the two tokens the backend `/google-drive` import endpoint needs
/// (`accessToken` + `refreshToken`) plus a few display-only fields so the UI
/// can show *which* account was connected and when the access token expires.
class GoogleDriveAuthResult {
  final String accessToken;
  final String refreshToken;
  final String? idToken;
  final DateTime? accessTokenExpiresAt;
  final List<String> grantedScopes;

  /// Email of the signed-in Google account, decoded from the OIDC id_token.
  /// `null` if the id_token was absent or not a parseable JWT.
  final String? accountEmail;

  const GoogleDriveAuthResult({
    required this.accessToken,
    required this.refreshToken,
    this.idToken,
    this.accessTokenExpiresAt,
    this.grantedScopes = const [],
    this.accountEmail,
  });

  /// The exact `credentials` object the BE `POST /google-drive` endpoint
  /// expects — per the API contract it carries only `accessToken` +
  /// `refreshToken` (it treats the object as opaque otherwise).
  GoogleDriveCredentials toCredentials() => GoogleDriveCredentials({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      });
}

/// Runs Google's **OAuth 2.0 Authorization Code flow with PKCE** in the system
/// browser (Chrome Custom Tabs on Android, `ASWebAuthenticationSession` on
/// iOS) via `flutter_appauth`.
///
/// Why PKCE and not the old implicit/WebView flow:
///  * Implicit flow only ever returns an `access_token` (no `refresh_token`),
///    so periodic re-sync on the BE would die after ~1h.
///  * PKCE proves "the client exchanging the code is the one that started the
///    flow" via a `code_verifier`/`code_challenge` pair — **no `client_secret`
///    is needed or used on-device**. flutter_appauth + the AppAuth SDKs handle
///    the PKCE bookkeeping; we just request `access_type=offline` (ask for a
///    refresh token) and `prompt=consent` (force the consent screen so Google
///    *re-issues* the refresh token on every sign-in, not only the first one).
///  * Google blocks OAuth inside embedded WebViews; the system browser is the
///    only sanctioned path for mobile.
class GoogleDriveOAuthService {
  // The Android + iOS OAuth client IDs (and the matching native redirect-scheme
  // config in android/app/build.gradle and ios/Runner/Info.plist) live in
  // [EnvConfig] — see the comment block there. [_redirectUrl] below derives the
  // redirect scheme from whichever client ID is active.

  /// Google's OpenID Connect discovery document. flutter_appauth reads the
  /// authorization + token endpoints from here, so we never hardcode them.
  static const String _discoveryUrl =
      'https://accounts.google.com/.well-known/openid-configuration';

  /// `drive.readonly` is the scope the BE needs to ingest the user's files;
  /// `openid`+`email` give us a stable identifier (the account email) we show
  /// in the UI. NOTE: `drive.readonly` is a Google "sensitive" scope — the
  /// OAuth consent screen will need verification before going to production
  /// with external users (it works for test users immediately).
  static const List<String> _scopes = <String>[
    'https://www.googleapis.com/auth/drive.readonly',
    'openid',
    'email',
  ];

  final FlutterAppAuth _appAuth;

  GoogleDriveOAuthService({FlutterAppAuth? appAuth})
      : _appAuth = appAuth ?? const FlutterAppAuth();

  String get _clientId => Platform.isIOS
      ? EnvConfig.instance.googleDriveIosClientId
      : EnvConfig.instance.googleDriveAndroidClientId;

  /// Custom-scheme redirect Google sends the authorization code back to,
  /// derived from the reversed client ID (the scheme Google's mobile OAuth
  /// clients are wired to). Must match the native config — see the big comment
  /// on the client-ID constants above.
  String get _redirectUrl {
    // `123-abc.apps.googleusercontent.com` → `com.googleusercontent.apps.123-abc`
    final reversed =
        'com.googleusercontent.apps.${_clientId.split('.').first}';
    return '$reversed:/oauth2redirect';
  }

  /// Opens the Google consent screen, exchanges the returned code for tokens,
  /// and returns them. Returns `null` when the user dismisses the browser;
  /// throws [GoogleDriveOAuthException] (with a user-facing message) on any
  /// real failure.
  Future<GoogleDriveAuthResult?> signIn() async {
    final AuthorizationTokenResponse response;
    try {
      response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes,
          // access_type=offline → request a refresh_token.
          // prompt=consent      → always show consent so Google re-issues the
          //                       refresh_token (it only sends one on the very
          //                       first consent otherwise).
          additionalParameters: const {
            'access_type': 'offline',
            'prompt': 'consent',
          },
          // PKCE (code_challenge_method=S256) is enabled by default — no need
          // to generate the verifier/challenge ourselves.
        ),
      );
    } on FlutterAppAuthUserCancelledException {
      return null;
    } on FlutterAppAuthPlatformException catch (e) {
      if (_isCancellation(e)) return null;
      throw GoogleDriveOAuthException(_describe(e));
    } on Exception catch (e) {
      throw GoogleDriveOAuthException('Đăng nhập Google thất bại: $e');
    }

    final accessToken = response.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw const GoogleDriveOAuthException(
        'Google không trả về access token. Vui lòng thử lại.',
      );
    }

    final refreshToken = response.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      // Happens when the user previously granted access and Google decides not
      // to mint a new refresh token. `prompt=consent` should prevent this, but
      // guard anyway so we never silently send half-credentials to the BE.
      throw const GoogleDriveOAuthException(
        'Google không trả về refresh token. Hãy bấm "Đăng nhập lại" và đồng ý '
        'lại trên màn hình cấp quyền của Google.',
      );
    }

    return GoogleDriveAuthResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: response.idToken,
      accessTokenExpiresAt: response.accessTokenExpirationDateTime,
      grantedScopes: response.scopes ?? const [],
      accountEmail: _emailFromIdToken(response.idToken),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers
  // ───────────────────────────────────────────────────────────────────────────

  bool _isCancellation(FlutterAppAuthPlatformException e) {
    final haystack = [
      e.code,
      e.message,
      e.platformErrorDetails.type,
      e.platformErrorDetails.code,
      e.platformErrorDetails.error,
      e.platformErrorDetails.errorDescription,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains('cancel') || // "user cancelled flow", "user_cancelled"
        haystack.contains('error -3'); // OIDErrorCodeUserCanceledAuthorizationFlow (iOS)
  }

  String _describe(FlutterAppAuthPlatformException e) {
    final d = e.platformErrorDetails;
    String? pick(String? s) {
      final t = s?.trim();
      return (t != null && t.isNotEmpty) ? t : null;
    }

    final detail = pick(d.errorDescription) ??
        pick(d.error) ??
        pick(e.message) ??
        e.code;
    return 'Đăng nhập Google thất bại: $detail';
  }

  /// Decodes the `email` claim out of an OIDC id_token (an unsigned JWT for our
  /// purposes — we only need it for display, the BE doesn't trust it).
  static String? _emailFromIdToken(String? idToken) {
    if (idToken == null) return null;
    final parts = idToken.split('.');
    if (parts.length < 2) return null;
    try {
      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      payload = payload.padRight((payload.length + 3) & ~3, '=');
      final json = jsonDecode(utf8.decode(base64.decode(payload)));
      if (json is Map && json['email'] is String) return json['email'] as String;
    } catch (_) {
      // not a parseable JWT — not fatal, the email is cosmetic.
    }
    return null;
  }
}

/// Surfaced to the UI when the Google Drive sign-in fails (configuration,
/// network, server rejection, …). [message] is already user-facing Vietnamese.
class GoogleDriveOAuthException implements Exception {
  final String message;
  const GoogleDriveOAuthException(this.message);

  @override
  String toString() => message;
}
