import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/import/classification_service.dart';
import 'package:budgetit/models/import/parsed_transaction.dart';

ParsedTransaction _pt(
  String description, {
  bool isIncome = false,
  bool categoryOverridden = false,
  String? categoryId,
  String? categoryName,
}) {
  final pt = ParsedTransaction(
    date: DateTime(2026, 5, 1),
    description: description,
    amount: Decimal.parse('100.00'),
    isIncome: isIncome,
    deduplicationHash: 'hash-${description.hashCode}',
    rawData: const {},
    categoryId: categoryId,
    categoryName: categoryName,
  );
  pt.categoryOverridden = categoryOverridden;
  return pt;
}

void main() {
  group('ClassificationService', () {
    test('assigns category when keyword matches and id is known', () {
      final service = ClassificationService({
        'Groceries': 'pav-groceries',
        'Dining Out': 'pav-dining',
      });
      final tx = _pt('CHECKERS', isIncome: false);

      service.classifyAll([tx]);

      expect(tx.categoryId, equals('pav-groceries'));
      expect(tx.categoryName, equals('Groceries'));
    });

    test('picks the first matching keyword rule', () {
      final service = ClassificationService({
        'Groceries': 'pav-groceries',
        'Clothing': 'pav-clothing',
      });

      final tx = _pt('WOOLWORTHS FOOD PURCHASE');

      service.classifyAll([tx]);

      expect(tx.categoryName, equals('Groceries'));
      expect(tx.categoryId, equals('pav-groceries'));
    });

    test('keyword matches but category id map lacks the category', () {
      final service = ClassificationService({'Dining Out': 'pav-dining'});
      final tx = _pt(
        'CHECKERS',
        isIncome: false,
        categoryId: 'stale-id',
        categoryName: 'Stale Category',
      );
      service.classifyAll([tx]);
      expect(tx.categoryId, isNull);
      expect(tx.categoryName, isNull);
    });

    test('no keyword match, income transaction, other income known', () {
      final service = ClassificationService({
        'Other Income': 'pav-other-income',
      });
      final tx = _pt('PAVS PLACE', isIncome: true);
      service.classifyAll([tx]);
      expect(tx.categoryId, equals('pav-other-income'));
      expect(tx.categoryName, equals('Other Income'));
    });

    test('no keyword match, expense transaction, other income not known', () {
      final service = ClassificationService({'Groceries': 'pav-groceries'});
      final tx = _pt('PAVS OTHER PLACE', isIncome: false);
      service.classifyAll([tx]);
      expect(tx.categoryId, isNull);
      expect(tx.categoryName, isNull);
    });

    test('no keyword match, expense transaction, reset to null', () {
      final service = ClassificationService({'Groceries': 'pav-groceries'});
      final tx = _pt(
        'PAVS OTHER PLACE',
        isIncome: false,
        categoryId: 'old-id',
        categoryName: 'Old Category',
      );
      service.classifyAll([tx]);
      expect(tx.categoryId, isNull);
      expect(tx.categoryName, isNull);
    });
    test('categoryOverriden transactions are skipped entirely', () {
      final service = ClassificationService({'Groceries': 'pav-groceries'});
      final tx = _pt(
        'PAVS OTHER PLACE',
        categoryId: 'manual-id',
        categoryName: 'Manually Chosen',
        categoryOverridden: true,
      );
      service.classifyAll([tx]);
      expect(tx.categoryId, equals('manual-id'));
      expect(tx.categoryName, equals('Manually Chosen'));
    });

    test('classifyAll processes a mixed batch correctly', () {
      final service = ClassificationService({
        'Groceries': 'pav-groceries',
        'Salary': 'pav-salary',
      });

      final overridden = _pt(
        'ANYTHING',
        categoryOverridden: true,
        categoryId: 'manual',
        categoryName: 'Manual',
      );
      final groceries = _pt('CHECKERS');
      final salary = _pt('PAYROLL', isIncome: true);
      final unmatched = _pt('TRANSFER', isIncome: false);
      service.classifyAll([unmatched, groceries, salary, overridden]);

      expect(overridden.categoryName, equals('Manual'));
      expect(groceries.categoryName, equals('Groceries'));
      expect(salary.categoryName, equals('Salary'));
      expect(unmatched.categoryName, isNull);
    });

    group('classificationRate', () {
      test('returns 0 for empty list', () {
        final service = ClassificationService(const {});
        expect(service.classificationRate([]), equals(0.0));
      });

      test('returns 1.0 when all transactions are classified', () {
        final service = ClassificationService({'Groceries': 'pav-groceries'});
        final txs = [_pt('CHECKERS'), _pt('SPAR')];
        service.classifyAll(txs);

        expect(service.classificationRate(txs), equals(1.0));
      });

      test('returns correct fraction for a partially classified batch', () {
        final service = ClassificationService({'Groceries': 'pav-groceries'});
        final classified = _pt('CHECKERS');
        final unclassified = _pt('UNKNOWN VENDOR', isIncome: false);
        final txs = [classified, unclassified];
        service.classifyAll(txs);

        expect(service.classificationRate(txs), equals(0.5));
      });

      test('does not mutate transactions itself, only reads categoryId', () {
        final service = ClassificationService(const {});
        final tx = _pt('X', categoryId: 'preset-id', categoryName: 'Preset');

        final rate = service.classificationRate([tx]);

        expect(rate, equals(1.0));
        expect(tx.categoryId, equals('preset-id'));
      });
    });
  });
}
