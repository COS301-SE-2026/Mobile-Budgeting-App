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
        'Groceries': 'cat-groceries',
        'Dining Out': 'cat-dining',
      });
      final tx = _pt('REAL PLACE', isIncome: false);

      service.classifyAll([tx]);

      expect(tx.categoryId, equals('cat-groceries'));
      expect(tx.categoryName, equals('Groceries'));
    });

    test('picks the first matching keyword rule', () {
      final service = ClassificationService({
        'Clothing': 'PAVAN-Clothing',
        'Dining Out': 'cat-dining',
      });
      final tx = _pt('PAVS PLACE');
      service.classifyAll([tx]);

      expect(tx.categoryName, equals('Clothing'));
      expect(tx.categoryId, equals('PAVAN-Clothing'));
    });

    test('keyword matches but category id map lacks the category', () {
      final service = ClassificationService({'Dining Out': 'pav-dining'});
      final tx = _pt('PAVS PLACE', isIncome: false, categoryId: 'stale-id', categoryName: 'Stale Category');
      service.classifyAll([tx]);
      expect(tx.categoryId, isNull);
      expect(tx.categoryName, isNull);
    });

    test('no keyword match, income transaction, other income known', () {
      final service = ClassificationService({'Other Income': 'cat-other-income'});
      final tx = _pt('PAVS PLACE', isIncome: true);
      service.classifyAll([tx]);
      expect(tx.categoryId, equals('cat-other-income'));
      expect(tx.categoryName, equals('Other Income'));

    });

    test('no keyword match, expense transaction, other income not known', () {
      final service = ClassificationService({'Groceries':'cat-groceries'});
      final tx = _pt('PAVS OTHER PLACE', isIncome: false);
      service.classifyAll([tx]);
      expect(tx.categoryId, isNull);
      expect(tx.categoryName, isNull);
    });

    test('no keyword match, expense transaction, reset to null', () {
      final service = ClassificationService({'Groceries':'cat-groceries'});
      final tx = _pt('PAVS OTHER PLACE', isIncome: false, categoryId: 'old-id', categoryName: 'Old Category');
      service.classifyAll([tx]);
      expect(tx.categoryId, isNull);
      expect(tx.categoryName, isNull);

    });
  });
}