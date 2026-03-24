import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '/core/stores/error/error_store.dart';
import '/domain/repository/setting/setting_repository.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  final SettingRepository _repository;
  final ErrorStore errorStore;

  @observable
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  _ThemeStore(this._repository, this.errorStore) {
    init();
  }

  @action
  Future<void> changeBrightnessToDark(bool value) async {
    _darkMode = value;
    await _repository.changeBrightnessToDark(value);
  }

  Future<void> init() async {
    _darkMode = _repository.isDarkMode;
  }

  bool isPlatformDark(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  void dispose() {}
}
