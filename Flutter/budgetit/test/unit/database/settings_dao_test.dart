import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/settings_dao.dart';
import 'helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late SettingsDao dao;

  setUp(() {
    db = openTestDatabase();
    dao = db.settingsDao;
  });

  tearDown(() => db.close());

  group('SettingsDao.getSetting', () {
    test('returns the value for an existing key', () async {
      await dao.setSetting('my_key', 'my_value');

      expect(await dao.getSetting('my_key'), equals('my_value'));
    });

    test('returns null for a missing key', () async {
      expect(await dao.getSetting('not_set'), isNull);
    });
  });

  group('SettingsDao.setSetting', () {
    test('inserts a new setting', () async {
      await dao.setSetting('theme', 'dark');

      expect(await dao.getSetting('theme'), equals('dark'));
    });

    test('updates an existing setting (upsert)', () async {
      await dao.setSetting('theme', 'light');
      await dao.setSetting('theme', 'dark');

      expect(await dao.getSetting('theme'), equals('dark'));
    });

    test('only one row exists after multiple sets on the same key', () async {
      await dao.setSetting('key', 'first');
      await dao.setSetting('key', 'second');
      await dao.setSetting('key', 'third');

      final keys = await dao.getSettingKeys();

      expect(keys.where((k) => k == 'key'), hasLength(1));
    });
  });

  group('SettingsDao.deleteSetting', () {
    test('removes an existing setting', () async {
      await dao.setSetting('remove_me', 'value');

      await dao.deleteSetting('remove_me');

      expect(await dao.getSetting('remove_me'), isNull);
    });

    test('is a no-op for a key that does not exist', () async {
      await expectLater(dao.deleteSetting('ghost'), completes);
    });
  });

  group('SettingsDao.getSettingKeys', () {
    test('returns all stored keys', () async {
      await dao.setSetting('alpha', '1');
      await dao.setSetting('beta', '2');

      final keys = await dao.getSettingKeys();

      expect(keys, containsAll(['alpha', 'beta']));
      expect(keys, hasLength(2));
    });

    test('returns an empty list when no settings exist', () async {
      expect(await dao.getSettingKeys(), isEmpty);
    });
  });

  group('SettingsDao.getDefaultCurrency', () {
    test('returns ZAR when not set', () async {
      expect(await dao.getDefaultCurrency(), equals('ZAR'));
    });
  });

  group('SettingsDao.getThemeMode', () {
    test('returns system when not set', () async {
      expect(await dao.getThemeMode(), equals('system'));
    });
  });

  group('SettingsDao.getOnboardingComplete', () {
    test('returns false when not set', () async {
      expect(await dao.getOnboardingComplete(), isFalse);
    });

    test('returns true when set to true', () async {
      await dao.setOnboardingComplete(complete: true);

      expect(await dao.getOnboardingComplete(), isTrue);
    });

    test('returns false when set to false', () async {
      await dao.setOnboardingComplete(complete: false);

      expect(await dao.getOnboardingComplete(), isFalse);
    });
  });

  group('SettingsDao.setOnboardingComplete', () {
    test('persists false after being set to true', () async {
      await dao.setOnboardingComplete(complete: true);
      await dao.setOnboardingComplete(complete: false);

      expect(await dao.getOnboardingComplete(), isFalse);
    });
  });

  group('SettingsDao.getDateFormat', () {
    test('returns yyyy-MM-dd when not set', () async {
      expect(await dao.getDateFormat(), equals('yyyy-MM-dd'));
    });
  });
}
