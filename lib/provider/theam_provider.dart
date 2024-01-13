import 'package:admin/constants/enums.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeModeEnum _currentThemeMode = ThemeModeEnum.light;

  ThemeModeEnum get currentThemeMode => _currentThemeMode;

  void toggleTheme() {
    print('Toggling theme');
    _currentThemeMode = _currentThemeMode == ThemeModeEnum.light
        ? ThemeModeEnum.dark
        : ThemeModeEnum.light;

    print('Current theme: $_currentThemeMode');

    notifyListeners();
  }
}
