import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Cryptographically random PKCE pair generated per OAuth attempt.
class PkcePair {
  final String verifier;
  final String challenge;

  const PkcePair({required this.verifier, required this.challenge});
}

/// PKCE + state generator. Pulled out as a stand-alone class so the repo can
/// stay deterministic in tests (override the random source via constructor).
class OAuthPkceGenerator {
  final Random _random;

  OAuthPkceGenerator({Random? random}) : _random = random ?? Random.secure();

  /// 64-byte verifier → SHA-256 → Base64URL-no-padding challenge.
  /// 64 bytes after Base64URL encoding fits comfortably inside the 43–128
  /// range mandated by RFC 7636.
  PkcePair generatePair() {
    final verifierBytes = _randomBytes(64);
    final verifier = _base64UrlNoPad(verifierBytes);
    final challengeBytes = sha256.convert(utf8.encode(verifier)).bytes;
    final challenge = _base64UrlNoPad(challengeBytes);
    return PkcePair(verifier: verifier, challenge: challenge);
  }

  /// Random Base64URL string used as the OAuth `state` (CSRF protection).
  String generateState({int byteLength = 24}) {
    return _base64UrlNoPad(_randomBytes(byteLength));
  }

  List<int> _randomBytes(int length) =>
      List<int>.generate(length, (_) => _random.nextInt(256));

  static String _base64UrlNoPad(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');
}
