import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/models/import/import_result.dart';

void main() {
  group('ImportResult', () {
    test('isFullSucess is true when there are no failures or duplicates', () {
      const result = ImportResult(
        totalParsed: 5,
        inserted: 5,
        duplicatesSkipped: 0,
        failed: 0,
      );

      expect(result.isFullSucess, isTrue);
    });

    test('isFullSucess is false when failures exist', () {
      const result = ImportResult(
        totalParsed: 5,
        inserted: 4,
        duplicatesSkipped: 0,
        failed: 1,
      );

      expect(result.isFullSucess, isFalse);
    });

    test('isFullSucess is false when duplicates were skipped', () {
      const result = ImportResult(
        totalParsed: 5,
        inserted: 4,
        duplicatesSkipped: 1,
        failed: 0,
      );

      expect(result.isFullSucess, isFalse);
    });

    test('hasInserts is true when inserted count is greater than zero', () {
      const result = ImportResult(
        totalParsed: 3,
        inserted: 1,
        duplicatesSkipped: 1,
        failed: 1,
      );

      expect(result.hasInserts, isTrue);
    });

    test('hasInserts is false when no records were inserted', () {
      const result = ImportResult(
        totalParsed: 3,
        inserted: 0,
        duplicatesSkipped: 2,
        failed: 1,
      );

      expect(result.hasInserts, isFalse);
    });

    test(
      'toString includes parsed, inserted, duplicates and failed counts',
      () {
        const result = ImportResult(
          totalParsed: 10,
          inserted: 7,
          duplicatesSkipped: 2,
          failed: 1,
        );

        expect(
          result.toString(),
          'ImportResult(parsed: 10, inserted: 7,duplicates: 2, failed: 1)',
        );
      },
    );

    test('stores import errors', () {
      const result = ImportResult(
        totalParsed: 2,
        inserted: 1,
        duplicatesSkipped: 0,
        failed: 1,
        errors: {'row 2': 'Invalid amount'},
      );

      expect(result.errors['row 2'], 'Invalid amount');
    });
  });
}
