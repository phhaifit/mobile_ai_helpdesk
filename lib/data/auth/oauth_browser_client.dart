import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

/// Thrown when the user dismisses the in-app browser before the OAuth flow
/// completes. Distinct from network/state-mismatch errors so the repository
/// can map it to [OAuthCancelledFailure] and the UI can stay quiet.
class OAuthCancelledException implements Exception {
  const OAuthCancelledException();
}

/// Thin abstraction over the platform OAuth browser session so
/// [AuthRepositoryImpl] can be unit-tested without `flutter_web_auth_2`'s
/// platform channels in the loop.
abstract class OAuthBrowserClient {
  /// Open [url] in an OS-managed browser session (Chrome Custom Tab on
  /// Android, ASWebAuthenticationSession on iOS), wait for a navigation
  /// matching [callbackUrlScheme], and return that URL.
  ///
  /// Throws [OAuthCancelledException] when the user dismisses the session.
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  });
}

/// Production implementation backed by `flutter_web_auth_2`.
class FlutterWebAuthBrowserClient implements OAuthBrowserClient {
  const FlutterWebAuthBrowserClient();

  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  }) async {
    try {
      return await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );
    } on PlatformException catch (e) {
      // `CANCELED` is what flutter_web_auth_2 reports on both iOS (user
      // tapped the X) and Android (user backed out of the Custom Tab).
      if (e.code == 'CANCELED') {
        throw const OAuthCancelledException();
      }
      rethrow;
    }
  }
}
