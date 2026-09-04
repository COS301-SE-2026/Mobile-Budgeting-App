import 'package:flutter/cupertino.dart';

abstract interface class SettingsDaoContract {
  Future<String?> getSetting(String key);
  Future<void> setSetting(String key, String value);
  Future<void> deleteSetting(String key);
  Future<List<String>> getSettingKeys();
  Future<String> getDefaultCurrency();
  Future<void> setDefaultCurrency(String currency);
  Future<String> getThemeMode();
  Future<void> setThemeMode(String mode);
  Future<bool> getOnboardingComplete();
  Future<void> setOnboardingComplete({required bool complete});
  Future<String> getDateFormat();
  Future<void> setDateFormat(String format);
}
