import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
 //Used Deepseek to help troubleshoot one line giving me an error
    notifyListeners();
  }
}
