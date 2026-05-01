import 'dart:convert';

import 'package:ai_helpdesk/data/auth/oauth_browser_client.dart';
import 'package:ai_helpdesk/data/auth/oauth_pkce.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBrowser implements OAuthBrowserClient {
  String? capturedUrl;
  String? capturedScheme;
  String Function(String url)? respondWith;
  Object? throwsInstead;

  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  }) async {
    capturedUrl = url;
    capturedScheme = callbackUrlScheme;
    if (throwsInstead != null) {
      throw throwsInstead!;
    }
    return respondWith!(url);
  }
}

void main() {
  group('OAuthPkceGenerator', () {
    test('challenge is SHA-256(verifier) Base64URL-no-pad', () {
      final pair = OAuthPkceGenerator().generatePair();

      final expectedChallenge = base64Url
          .encode(sha256.convert(utf8.encode(pair.verifier)).bytes)
          .replaceAll('=', '');
      expect(pair.challenge, expectedChallenge);
      expect(pair.verifier.contains('='), isFalse,
          reason: 'verifier must be Base64URL with padding stripped');
      expect(pair.challenge.contains('='), isFalse,
          reason: 'challenge must be Base64URL with padding stripped');
    });

    test('state is non-empty Base64URL-no-pad', () {
      final state = OAuthPkceGenerator().generateState();
      expect(state, isNotEmpty);
      expect(state.contains('='), isFalse);
      expect(state.contains('+'), isFalse);
      expect(state.contains('/'), isFalse);
    });

    test('successive pairs are different', () {
      final gen = OAuthPkceGenerator();
      final a = gen.generatePair();
      final b = gen.generatePair();
      expect(a.verifier, isNot(b.verifier));
      expect(a.challenge, isNot(b.challenge));
    });
  });

  group('FakeBrowser plumbing (sanity)', () {
    test('round-trips url and scheme', () async {
      final fake = _FakeBrowser()
        ..respondWith =
            (_) => 'https://helpdesk.jarvis.cx/oauth2callback?code=X&state=Y';
      final result = await fake.authenticate(
        url: 'https://example.com/?state=Y',
        callbackUrlScheme: 'https',
      );
      expect(result, 'https://helpdesk.jarvis.cx/oauth2callback?code=X&state=Y');
      expect(fake.capturedScheme, 'https');
    });

    test('OAuthCancelledException is distinguishable', () async {
      final fake = _FakeBrowser()..throwsInstead = const OAuthCancelledException();
      Object? caught;
      try {
        await fake.authenticate(url: 'https://x', callbackUrlScheme: 's');
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<OAuthCancelledException>());
    });
  });

  group('AuthFailure', () {
    test('OAuthCancelledFailure carries the right code', () {
      const f = OAuthCancelledFailure();
      expect(f.code, 'auth_error_oauth_cancelled');
    });

    test('OAuthFailedFailure carries the right code', () {
      const f = OAuthFailedFailure();
      expect(f.code, 'auth_error_oauth_failed');
    });
  });
}
