import 'dart:convert';

import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';

/// Local persistence for the Stack Auth session and cached helpdesk account.
class AuthLocalDatasource {
  final SharedPreferenceHelper _prefs;

  AuthLocalDatasource(this._prefs);

  // ---- Session -------------------------------------------------------------

  Future<void> saveSession(AuthSession session) async {
    await _prefs.saveAuthToken(session.accessToken);
    await _prefs.saveAuthRefreshToken(session.refreshToken);
    await _prefs.saveIsLoggedIn(true);
  }

  /// Partial session write — refresh interceptor calls this with a freshly
  /// rotated access token; refresh token and user id are left untouched.
  Future<void> updateAccessToken(String accessToken) async {
    await _prefs.saveAuthToken(accessToken);
  }

  Future<AuthSession?> loadSession() async {
    final access = await _prefs.authToken;
    final refresh = await _prefs.authRefreshToken;
    if (access == null || access.isEmpty || refresh == null || refresh.isEmpty) {
      return null;
    }
    final accountId = (await loadAccount())?.accountId ?? '';
    return AuthSession(
      accessToken: access,
      refreshToken: refresh,
      userId: accountId,
      isNewUser: false,
    );
  }

  Future<String?> getAccessToken() => _prefs.authToken;
  Future<String?> getRefreshToken() => _prefs.authRefreshToken;

  // ---- Account cache -------------------------------------------------------

  Future<void> saveAccount(Account account) async {
    final json = jsonEncode(account.toJson());
    await _prefs.saveAccountJson(json);
    final tenantId = account.tenantId;
    if (tenantId != null && tenantId.isNotEmpty) {
      await _prefs.saveTenantId(tenantId);
    } else {
      await _prefs.removeTenantId();
    }
  }

  Future<Account?> loadAccount() async {
    final json = await _prefs.accountJson;
    if (json == null || json.isEmpty) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Account.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getTenantId() => _prefs.tenantId;

  // ---- Clear ---------------------------------------------------------------

  Future<void> clearAll() async {
    await _prefs.removeAuthToken();
    await _prefs.removeAuthRefreshToken();
    await _prefs.removeAccountJson();
    await _prefs.removeTenantId();
    await _prefs.saveIsLoggedIn(false);
  }
}
