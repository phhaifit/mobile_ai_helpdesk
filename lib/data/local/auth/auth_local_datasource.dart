import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';

/// Local data source for auth-related local storage operations
class AuthLocalDatasource {
  final SharedPreferenceHelper _prefs;

  AuthLocalDatasource(this._prefs);

  // Access Token operations ---------------------------------------------------

  Future<void> saveAuthToken(String token) async {
    await _prefs.saveAuthToken(token);
  }

  Future<String?> getAuthToken() async {
    return await _prefs.authToken;
  }

  Future<void> clearAuthToken() async {
    await _prefs.removeAuthToken();
  }

  // Refresh Token operations --------------------------------------------------

  Future<void> saveRefreshToken(String token) async {
    await _prefs.saveRefreshToken(token);
  }

  Future<String?> getRefreshToken() async {
    return await _prefs.refreshToken;
  }

  Future<void> clearRefreshToken() async {
    await _prefs.removeRefreshToken();
  }

  // User operations -----------------------------------------------------------

  Future<void> saveUser(User user) async {
    await _prefs.saveUser(user);
  }

  Future<User?> getUser() async {
    return await _prefs.getUser();
  }

  Future<void> clearUser() async {
    await _prefs.removeUser();
  }

  // Login status --------------------------------------------------------------

  Future<void> setLoggedIn(bool value) async {
    await _prefs.saveIsLoggedIn(value);
  }

  Future<bool> isLoggedIn() async {
    return await _prefs.isLoggedIn;
  }

  // Clear all auth data (logout) ----------------------------------------------

  Future<void> clearAllAuthData() async {
    await _prefs.removeAuthToken();
    await _prefs.removeRefreshToken();
    await _prefs.removeUser();
    await _prefs.saveIsLoggedIn(false);
  }
}
