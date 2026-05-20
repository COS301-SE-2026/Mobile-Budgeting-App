// daos/settings_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../schema.dart';

part 'settings_dao.g.dart';

/// Data access object for application settings stored in [AppSettings].
///
/// [SettingsDao] manages key-value settings for the app, including currency,
/// theme, onboarding status, and date format. All values are stored as
/// strings in the database.
///
/// Usage:
/// ```dart
/// final dao = SettingsDao(database);
/// final currency = await dao.getDefaultCurrency();
/// await dao.setDateFormat('dd/MM/yyyy');
/// ```
@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  /// Creates a new instance of [SettingsDao] backed by the given [AppDatabase].
  SettingsDao(super.db);

  /// Returns the current UTC time.
  DateTime _now() => DateTime.now().toUtc();

  /// Retrieves the value of a setting by its [key].
  ///
  /// Returns `null` if the setting does not exist.
  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  /// Inserts or updates a setting key with the given [value].
  ///
  /// If a row with the same [key] already exists, it is updated
  /// in place. Otherwise, a new row is inserted.
  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value, updatedAt: _now()),
    );
  }

  /// Deletes a setting by its [key].
  Future<void> deleteSetting(String key) async {
    await (delete(appSettings)..where((t) => t.key.equals(key))).go();
  }

  /// Returns all setting keys stored in the database.
  Future<List<String>> getSettingKeys() async {
    final rows = await select(appSettings).get();
    return rows.map((r) => r.key).toList();
  }

  /// Returns the user's default currency.
  ///
  /// Defaults to 'ZAR' if not set.
  Future<String> getDefaultCurrency() async =>
      await getSetting('default_currency') ?? 'ZAR';

  /// Sets the user's default currency.
  Future<void> setDefaultCurrency(String currency) =>
      setSetting('default_currency', currency);

  /// Returns the user's preferred theme mode.
  ///
  /// Defaults to 'system' if not set.
  Future<String> getThemeMode() async =>
      await getSetting('theme_mode') ?? 'system';

  /// Sets the user's preferred theme mode.
  Future<void> setThemeMode(String mode) => setSetting('theme_mode', mode);

  /// Checks whether onboarding has been completed.
  ///
  /// Returns `false` if the setting is unset.
  Future<bool> getOnboardingComplete() async =>
      await getSetting('onboarding_complete') == 'true';

  /// Records whether onboarding has been completed.
  Future<void> setOnboardingComplete({required bool complete}) =>
      setSetting('onboarding_complete', complete.toString());

  /// Returns the user's preferred date format.
  ///
  /// Defaults to 'yyyy-MM-dd' if not set.
  Future<String> getDateFormat() async =>
      await getSetting('date_format') ?? 'yyyy-MM-dd';

  /// Sets the user's preferred date format.
  Future<void> setDateFormat(String format) =>
      setSetting('date_format', format);
}
