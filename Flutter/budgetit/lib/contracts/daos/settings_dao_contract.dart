/// Data access for user preferences, stored as a key–value table.
/// Every value is persisted as a string. The typed accessors below wrap the
/// well-known keys, each returning a documented default when the key has
/// never been written, so callers never have to handle a missing setting.
///
/// {@category DAOs}
abstract interface class SettingsDaoContract {
  /// Returns the raw string stored under [key], or 'null' if unset.
  Future<String?> getSetting(String key);

  /// Writes [value] under [key], replacing any existing value.
  Future<void> setSetting(String key, String value);

  /// Removes [key]. Its typed accessor will then report its default again.
  Future<void> deleteSetting(String key);

  /// Returns every key currently stored.
  Future<List<String>> getSettingKeys();

  /// The user's preferred ISO currency code, defaulting to 'ZAR'.
  Future<String> getDefaultCurrency();

  /// Sets the preferred ISO currency code, e.g. 'ZAR' or 'USD'.
  Future<void> setDefaultCurrency(String currency);

  /// The user's theme preference, defaulting to 'system'.
  Future<String> getThemeMode();

  /// Sets the theme preference: 'system', 'light' or 'dark'.
  Future<void> setThemeMode(String mode);

  /// Whether the user has finished onboarding, defaulting to 'false'.
  Future<bool> getOnboardingComplete();

  /// Records whether onboarding has been completed.
  Future<void> setOnboardingComplete({required bool complete});

  /// The user's preferred date format pattern, defaulting to
  /// 'yyyy-MM-dd'.
  Future<String> getDateFormat();

  /// Sets the date format pattern used when displaying dates.
  Future<void> setDateFormat(String format);
}
