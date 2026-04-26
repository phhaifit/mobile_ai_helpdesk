import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _sharedPreference;

  SharedPreferenceHelper(this._sharedPreference);

  // Auth access token:---------------------------------------------------------
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.authToken);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.authToken, authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(Preferences.authToken);
  }

  // Auth refresh token:--------------------------------------------------------
  Future<String?> get authRefreshToken async {
    return _sharedPreference.getString(Preferences.authRefreshToken);
  }

  Future<bool> saveAuthRefreshToken(String token) async {
    return _sharedPreference.setString(Preferences.authRefreshToken, token);
  }

  Future<bool> removeAuthRefreshToken() async {
    return _sharedPreference.remove(Preferences.authRefreshToken);
  }

  // Login status:--------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.isLoggedIn) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.isLoggedIn, value);
  }

  // Tenant:--------------------------------------------------------------------
  // Account JSON cache (serialised `Account` payload):-------------------------
  Future<String?> get accountJson async {
    return _sharedPreference.getString(Preferences.accountJson);
  }

  Future<bool> saveAccountJson(String json) async {
    return _sharedPreference.setString(Preferences.accountJson, json);
  }

  Future<bool> removeAccountJson() async {
    return _sharedPreference.remove(Preferences.accountJson);
  }

  // Tenant ID (required header for Helpdesk APIs):-----------------------------
  Future<String?> get tenantId async {
    return _sharedPreference.getString(Preferences.tenantId);
  }

  Future<bool> saveTenantId(String id) async {
    return _sharedPreference.setString(Preferences.tenantId, id);
  }

  Future<bool> removeTenantId() async {
    return _sharedPreference.remove(Preferences.tenantId);
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

  // Analytics - First Launch & Installation Tracking:--------------------------
  bool? getIsAppFirstOpen() {
    return _sharedPreference.getBool(Preferences.isAppFirstOpen);
  }

  Future<bool> setIsAppFirstOpen(bool value) {
    return _sharedPreference.setBool(Preferences.isAppFirstOpen, value);
  }

  String? getInstallationId() {
    return _sharedPreference.getString(Preferences.installationId);
  }

  Future<bool> setInstallationId(String value) {
    return _sharedPreference.setString(Preferences.installationId, value);
  }

  String? getInstallSource() {
    return _sharedPreference.getString(Preferences.installSource);
  }

  Future<bool> setInstallSource(String value) {
    return _sharedPreference.setString(Preferences.installSource, value);
  }

  String? getFirstLaunchTime() {
    return _sharedPreference.getString(Preferences.firstLaunchTime);
  }

  Future<bool> setFirstLaunchTime(String value) {
    return _sharedPreference.setString(Preferences.firstLaunchTime, value);
  }
}
