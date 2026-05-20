// daos/settings_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../schema.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value, updatedAt: _now()),
    );
  }

  Future<void> deleteSetting(String key) async {
    await (delete(appSettings)..where((t) => t.key.equals(key))).go();
  }

  Future<List<String>> getSettingKeys() async {
    final rows = await select(appSettings).get();
    return rows.map((r) => r.key).toList();
  }

  Future<String> getDefaultCurrency() async =>
      await getSetting('default_currency') ?? 'ZAR';
  Future<void> setDefaultCurrency(String currency) =>
      setSetting('default_currency', currency);

  Future<String> getThemeMode() async =>
      await getSetting('theme_mode') ?? 'system';
  Future<void> setThemeMode(String mode) => setSetting('theme_mode', mode);

  Future<bool> getOnboardingComplete() async =>
      await getSetting('onboarding_complete') == 'true';

  Future<void> setOnboardingComplete({required bool complete}) =>
      setSetting('onboarding_complete', complete.toString());

  Future<String> getDateFormat() async =>
      await getSetting('date_format') ?? 'yyyy-MM-dd';
  Future<void> setDateFormat(String format) =>
      setSetting('date_format', format);
}
