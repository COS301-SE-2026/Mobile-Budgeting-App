import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/import/duplicate_detector.dart';
import 'package:budgetit/models/import/parsed_transaction.dart';

ParsedTransaction _parsed({
  required DateTime date,
  required String amount,
  required String hash,
  String description = 'Test transaction',
}) {
  return ParsedTransaction(
    date: date,
    description: description,
    amount: Decimal.parse(amount),
    isIncome: false,
    deduplicationHash: hash,
    rawData: const {},
  );
}

ExistingTransaction _existing({
  required DateTime date,
  required String amount,
  required String hash,
}) {
  return ExistingTransaction(
    date: date,
    amount: Decimal.parse(amount),
    deduplicationHash: hash,
  );
}


void main() {

  group('DuplicateDetector', () {

    test('flags a transaction as duplicate when the deduplication hash matches exactly', () {
      final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '100.00', hash: 'hashA')];
      final detector = DuplicateDetector(existing);
      final incoming = _parsed(
        date: DateTime(2026, 5, 1),
        amount: '100.00',
        hash: 'hashA',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isTrue);
    });

    test('flags duplicate through hash match even if amount/date differ', () {
      final existing = [ _existing(date: DateTime(2026, 1, 1), amount: '999.00', hash: 'hashB')];
      final detector = DuplicateDetector(existing);
      final incoming = _parsed(
        date: DateTime(2026, 6, 15),
        amount: '1.00',
        hash: 'hashB',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isTrue);
    });

    test('flags duplicate when amount matches and dates are within 3 days', () {
      final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash')];
      final detector = DuplicateDetector(existing);
      final incoming = _parsed(
        date: DateTime(2026, 5, 3),
        amount: '250.00',
        hash: 'thatHash',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isTrue);
    });

    test('4 days apart with matching amount is not a duplicate', () {
      final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash')];
      final detector = DuplicateDetector(existing);
      final incoming = _parsed(
        date: DateTime(2026, 5, 5),
        amount: '250.00',
        hash: 'thatHash',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isFalse);
    });

    test('date proximity check also matches when incoming date is before existing date', () {
      final existing = [ _existing(date: DateTime(2026, 5, 10), amount: '250.00', hash: 'thisHash')];
      final detector = DuplicateDetector(existing);
      final incoming = _parsed(
        date: DateTime(2026, 5, 8), 
        amount: '250.00',
        hash: 'thatHash',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isTrue);
    });

    test('not a duplicate when just amount differs', () {
      final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash')];
      final detector = DuplicateDetector(existing);
      final incoming = _parsed(
        date: DateTime(2026, 5, 1),
        amount: '251.00',
        hash: 'thatHash',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isFalse);
    });

    test('nothing flagged when no existing transactions', () {
      final detector = DuplicateDetector(const []);
      final incoming = _parsed(
        date: DateTime(2026, 5, 1),
        amount: '250.00',
        hash: 'aHash',
      );
      detector.flagDuplicates([incoming]);

      expect(incoming.isDuplicate, isFalse);
    });

    test('flagDuplicates mutates each transaction in the input list in place', () {
      final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'existing-hash')];
      final detector = DuplicateDetector(existing);
      final dup = _parsed(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash');
      final notDup = _parsed(date: DateTime(2026, 5, 1), amount: '9999.00', hash: 'thatHash');
      detector.flagDuplicates([dup, notDup]);

      expect(dup.isDuplicate, isTrue);
      expect(notDup.isDuplicate, isFalse);
    });

    group('filterDuplicates', () {
      test('remove only the transactions flagged as duplicate', () {
        final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'existing-hash')];
        final detector = DuplicateDetector(existing);
        final dup = _parsed(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash');
        final notDup = _parsed(date: DateTime(2026, 5, 1), amount: '9999.00', hash: 'thatHash');
        final parsed = [dup, notDup];
        detector.flagDuplicates(parsed);
        final result = detector.filterDuplicates(parsed);

        expect(result, equals([notDup]));
        expect(result, isNot(contains(dup)));
      });

      test('returns empty list if all transactions are duplicates', () {
        final existing = [ _existing(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash')];
        final detector = DuplicateDetector(existing);
        final dup = _parsed(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'thisHash');
        detector.flagDuplicates([dup]);
        final result = detector.filterDuplicates([dup]);

        expect(result, isEmpty);
      });

      test('returns everything unfiltered if flagDuplicates is never called', () {
        final detector = DuplicateDetector(const []);
        final tx = _parsed(date: DateTime(2026, 5, 1), amount: '250.00', hash: 'hashA');
        final result = detector.filterDuplicates([tx]);

        expect(result, equals([tx]));
      });
    });

  });
}