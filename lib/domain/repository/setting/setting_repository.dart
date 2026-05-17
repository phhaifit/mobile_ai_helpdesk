import 'dart:async';

abstract class SettingRepository {
  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value);

  bool get isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value);

  String? get currentLanguage;

  // Realtime: cached Socket.IO id (SharedPreferences) ------------------------
  String? get socketId;
}
