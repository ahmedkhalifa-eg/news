import 'package:flutter/material.dart';

/// Global, lightweight app state (theme + language).
class AppState {
  AppState._();

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);
  static final ValueNotifier<Locale> locale =
      ValueNotifier<Locale>(const Locale('en'));
}
