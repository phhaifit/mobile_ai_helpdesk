flutter_boilerplate_project/
├── android/
│   ├── .gitignore
│   ├── build.gradle
│   ├── gradle.properties
│   ├── settings.gradle
│   ├── .gradle/
│   ├── app/
│   │   └── src/main/java/com/iotecksolutions/todoapp/
│   │       └── MainActivity.java
│   └── gradle/
│       └── wrapper/
│           └── gradle-wrapper.properties
├── ios/
│   ├── .gitignore
│   ├── Podfile
│   ├── Runner-Bridging-Header.h
│   ├── Flutter/
│   ├── Runner/
│   ├── Runner.xcodeproj/
│   ├── Runner.xcworkspace/
│   ├── RunnerTests/
│   │   └── RunnerTests.swift
│   └── Podfile
├── linux/
│   ├── .gitignore
│   ├── CMakeLists.txt
│   ├── main.cc
│   ├── my_application.h
│   ├── my_application.cc
│   ├── flutter/
│   │   ├── CMakeLists.txt
│   │   ├── generated_plugin_registrant.h
│   │   └── generated_plugins.cmake
│   └── (other files...)
├── macos/
│   ├── Podfile
│   ├── Flutter/
│   ├── Runner/
│   ├── Runner.xcodeproj/
│   ├── Runner.xcworkspace/
│   ├── RunnerTests/
│   │   └── RunnerTests.swift
│   └── Flutter/
│       └── GeneratedPluginRegistrant.swift
├── web/
│   └── index.html
├── windows/
│   ├── CMakeLists.txt
│   ├── runner/
│   │   ├── CMakeLists.txt
│   │   ├── main.cpp
│   │   ├── utils.h
│   │   ├── utils.cpp
│   │   ├── resource.h
│   │   └── (other files...)
│   └── flutter/
│       ├── CMakeLists.txt
│       ├── generated_plugin_registrant.h
│       ├── generated_plugin_registrant.cc
│       └── generated_plugins.cmake
├── lib/
│   ├── main.dart
│   ├── constants/
│   │   ├── app_theme.dart
│   │   ├── assets.dart
│   │   ├── colors.dart
│   │   ├── dimens.dart
│   │   ├── font_family.dart
│   │   └── strings.dart
│   ├── core/
│   │   ├── data/
│   │   │   ├── local/
│   │   │   │   ├── encryption/
│   │   │   │   │   └── xxtea.dart
│   │   │   │   └── sembast/
│   │   │   │       └── sembast_client.dart
│   │   │   └── network/
│   │   │       └── dio/
│   │   │           └── configs/
│   │   │               └── dio_configs.dart
│   │   ├── domain/
│   │   │   └── usecase/
│   │   │       └── use_case.dart
│   │   ├── stores/
│   │   │   ├── error/
│   │   │   │   ├── error_store.dart
│   │   │   │   └── error_store.g.dart
│   │   │   └── form/
│   │   │       └── form_store.dart
│   │   └── widgets/
│   │       ├── empty_app_bar_widget.dart
│   │       ├── progress_indicator_widget.dart
│   │       └── rounded_button_widget.dart
│   ├── data/
│   │   ├── di/
│   │   │   ├── data_layer_injection.dart
│   │   │   └── module/
│   │   │       ├── local_module.dart
│   │   │       ├── network_module.dart
│   │   │       └── repository_module.dart
│   │   ├── local/
│   │   │   ├── constants/
│   │   │   │   └── db_constants.dart
│   │   │   └── datasources/
│   │   │       └── post/
│   │   │           └── post_datasource.dart
│   │   ├── network/
│   │   │   ├── apis/
│   │   │   │   └── posts/
│   │   │   │       └── post_api.dart
│   │   │   ├── constants/
│   │   │   │   └── endpoints.dart
│   │   │   └── dio_client.dart
│   │   ├── repository/
│   │   │   ├── post/
│   │   │   │   └── post_repository_impl.dart
│   │   │   └── setting/
│   │   │       └── setting_repository_impl.dart
│   │   └── sharedpref/
│   │       ├── constants/
│   │       │   └── preferences.dart
│   │       └── shared_preference_helper.dart
│   ├── di/
│   │   └── service_locator.dart
│   ├── domain/
│   │   ├── di/
│   │   │   ├── domain_layer_injection.dart
│   │   │   └── module/
│   │   │       └── usecase_module.dart
│   │   ├── entity/
│   │   │   ├── language/
│   │   │   │   └── Language.dart
│   │   │   ├── post/
│   │   │   │   ├── post.dart
│   │   │   │   └── post_list.dart
│   │   │   └── user/
│   │   │       └── user.dart
│   │   ├── repository/
│   │   │   ├── post/
│   │   │   │   └── post_repository.dart
│   │   │   ├── setting/
│   │   │   │   └── setting_repository.dart
│   │   │   └── user/
│   │   │       └── user_repository.dart
│   │   └── usecase/
│   │       ├── post/
│   │       │   ├── delete_post_usecase.dart
│   │       │   ├── find_post_by_id_usecase.dart
│   │       │   ├── get_post_usecase.dart
│   │       │   ├── insert_post_usecase.dart
│   │       │   └── udpate_post_usecase.dart
│   │       └── user/
│   │           ├── is_logged_in_usecase.dart
│   │           ├── login_usecase.dart
│   │           └── save_login_in_status_usecase.dart
│   ├── presentation/
│   │   ├── di/
│   │   │   ├── presentation_layer_injection.dart
│   │   │   └── module/
│   │   │       └── store_module.dart
│   │   ├── home/
│   │   │   ├── home.dart
│   │   │   └── store/
│   │   │       ├── language/
│   │   │       │   ├── language_store.dart
│   │   │       │   └── language_store.g.dart
│   │   │       └── theme/
│   │   │           ├── theme_store.dart
│   │   │           └── theme_store.g.dart
│   │   ├── login/
│   │   │   ├── login.dart
│   │   │   └── store/
│   │   │       └── login_store.dart
│   │   ├── my_app.dart
│   │   └── post/
│   │       ├── post_list.dart
│   │       └── store/
│   │           ├── post_store.dart
│   │           └── post_store.g.dart
│   └── utils/
│       ├── dio/
│       │   └── dio_error_util.dart
│       ├── locale/
│       │   └── app_localization.dart
│       └── routes/
│           └── routes.dart
├── test/
│   └── widget_test.dart
├── assets/
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   └── lang/
├── art/
├── .gitignore
├── .gitmodules
├── .metadata
├── analysis_options.yaml
├── CHANGELOG.md
├── LICENSE
├── pubspec.yaml
└── README.md
