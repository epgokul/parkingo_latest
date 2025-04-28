import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = Parkingotheme.lightTheme;
  bool _isDarkTheme = false;

  ThemeData get themeData => _themeData;
  bool get isDarkTheme => _isDarkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  set isDarkTheme(bool isDarkTheme) {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == Parkingotheme.lightTheme) {
      themeData = Parkingotheme.darkTheme;
      isDarkTheme = true;
    } else {
      themeData = Parkingotheme.lightTheme;
      isDarkTheme = false;
    }
  }
}
