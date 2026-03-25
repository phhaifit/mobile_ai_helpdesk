import '/core/stores/error/error_store.dart';
import '/domain/entity/language/language.dart';
import '/domain/repository/setting/setting_repository.dart';
import 'package:mobx/mobx.dart';

part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  final SettingRepository _repository;
  final ErrorStore errorStore;

  List<Language> supportedLanguages = [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'VN', locale: 'vi', language: 'Tiếng Việt'),
  ];

  _LanguageStore(this._repository, this.errorStore) {
    init();
  }

  @observable
  String _locale = 'en';

  @computed
  String get locale => _locale;

  @action
  void changeLanguage(String value) {
    _locale = value;
    _repository.changeLanguage(value);
  }

  @action
  String getCode() {
    var code = 'US';

    if (_locale == 'en') {
      code = 'US';
    } else if (_locale == 'vi') {
      code = 'VN';
    }

    return code;
  }

  @action
  String? getLanguage() {
    return supportedLanguages[supportedLanguages.indexWhere(
          (language) => language.locale == _locale,
        )]
        .language;
  }

  Future<void> init() async {
    if (_repository.currentLanguage != null) {
      _locale = _repository.currentLanguage!;
    }
  }

  void dispose() {}
}
