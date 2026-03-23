import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';

/// Local data source for auth-related local storage operations
class AuthLocalDatasource {
  final SharedPreferenceHelper _prefs;

  AuthLocalDatasource(this._prefs);

  // Auth Token operations

  /// Save auth token
  Future<void> saveAuthToken(String token) async {
    await _prefs.saveAuthToken(token);
  }

  /// Get saved auth token
  Future<String?> getAuthToken() async {
    return await _prefs.authToken;
  }

  /// Remove auth token
  Future<void> clearAuthToken() async {
    await _prefs.removeAuthToken();
  }

  // User operations

  /// Save user data locally
  Future<void> saveUser(User user) async {
    await _prefs.saveUser(user);
  }

  /// Get saved user data
  Future<User?> getUser() async {
    return await _prefs.getUser();
  }

  /// Remove user data
  Future<void> clearUser() async {
    await _prefs.removeUser();
  }

  // Login status

  /// Mark user as logged in
  Future<void> setLoggedIn(bool value) async {
    await _prefs.saveIsLoggedIn(value);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _prefs.isLoggedIn;
  }

  // Clear all auth data (logout)

  /// Clear all user authentication data
  Future<void> clearAllAuthData() async {
    await _prefs.removeAuthToken();
    await _prefs.removeUser();
    await _prefs.saveIsLoggedIn(false);
  }
}
