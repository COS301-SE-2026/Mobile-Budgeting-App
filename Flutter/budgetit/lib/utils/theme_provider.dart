import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({bool isDark = true}) : _isDark = isDark;

  bool _isDark;

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    //Used Deepseek to help troubleshoot one line giving me an error
    notifyListeners();
  }
}
