import 'package:flutter/material.dart';
import 'app_colour.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    MyColours.isDark = _isDark;
    notifyListeners();
  }
}
