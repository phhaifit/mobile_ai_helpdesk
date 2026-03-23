import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_helpdesk/domain/entity/auth/user.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _sharedPreference;

  SharedPreferenceHelper(this._sharedPreference);

  // Auth:----------------------------------------------------------------------
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.authToken);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.authToken, authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(Preferences.authToken);
  }

  // Login:---------------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.isLoggedIn) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.isLoggedIn, value);
  }

  // Theme:---------------------------------------------------------------------
  bool get isDarkMode {
    return _sharedPreference.getBool(Preferences.isDarkMode) ?? false;
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.setBool(Preferences.isDarkMode, value);
  }

  // Language:------------------------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.currentLanguage);
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.currentLanguage, language);
  }

  // Analytics user properties (set after login):-------------------------------
  Future<void> saveAnalyticsUserProperties({
    String? tenantId,
    String? role,
    String? planType,
  }) async {
    if (tenantId != null) {
      await _sharedPreference.setString(Preferences.tenantId, tenantId);
    }
    if (role != null) {
      await _sharedPreference.setString(Preferences.userRole, role);
    }
    if (planType != null) {
      await _sharedPreference.setString(Preferences.planType, planType);
    }
  }

  String? get tenantId => _sharedPreference.getString(Preferences.tenantId);
  String? get userRole => _sharedPreference.getString(Preferences.userRole);
  String? get planType => _sharedPreference.getString(Preferences.planType);

  // User:----------------------------------------------------------------------
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _sharedPreference.setString(Preferences.userData, userJson);
  }

  Future<User?> getUser() async {
    final userJson = _sharedPreference.getString(Preferences.userData);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<bool> removeUser() async {
    return _sharedPreference.remove(Preferences.userData);
  }
}
