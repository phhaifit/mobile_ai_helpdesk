import 'package:flutter/material.dart';

/// Global key for the root [Navigator]. Used by infrastructure that needs to
/// push routes from outside the widget tree — currently the OAuth WebView
/// browser client which is a non-widget singleton in the data layer.
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
}
