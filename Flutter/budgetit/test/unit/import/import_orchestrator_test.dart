import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/models/import/parsed_transaction.dart';
import 'package:budgetit/services/import/import_orchestrator.dart';
import '../database/helpers.dart';


ParsedTransaction _parsed({
  required String description,
  required String amount,
  bool isIncome = false,
  bool isDuplicate = false,
  bool categoryOverridden = false,
  String? categoryId,
  DateTime? date,
}) {
  final tx = ParsedTransaction(
    date: date ?? DateTime(2026, 5, 1),
    description: description,
    amount: Decimal.parse(amount),
    isIncome: isIncome,
    deduplicationHash: 'hash-${description.hashCode}',
    rawData: const {},
    categoryId: categoryId,
  );
  tx.isDuplicate = isDuplicate;
  tx.categoryOverridden = categoryOverridden;
  return tx;
}


void main() {

  configureSqliteForTests();

  late AppDatabase db;
  late TransactionDao taDao;
  late CategoryDao categoryDao;
  late ImportOrchestrator orchestrator;

  setUp(() {
    db = openTestDatabase();
    taDao = TransactionDao(db);
    categoryDao = CategoryDao(db);
    orchestrator = ImportOrchestrator(
      db: db,
      taDao: taDao,
      categoryDao: categoryDao,
    );
  });


  tearDown(()async {
    await db.close();

  }
  );

  group('Import orchestrator import commit', () {
        test('empty list returns a null result', () async {
      final result = await orchestrator.commitImport([]);

      expect(result.totalParsed, equals(0));
      expect(result.inserted, equals(0));
      expect(result.duplicatesSkipped, equals(0));
      expect(result.failed, equals(0));
      expect(result.errors, isEmpty);
    });

    test('inserts non-duplicate transactions and reports correct counts', () async {
      final transactions = [
        _parsed(description: 'Checkers groceries', amount: '250.00'),
        _parsed(description: 'Salary payment', amount: '12000.00', isIncome: true),
      ];
      final result = await orchestrator.commitImport(transactions);

      expect(result.totalParsed, equals(2));
      expect(result.inserted, equals(2));
      expect(result.duplicatesSkipped, equals(0));
      expect(result.failed, equals(0));
      final stored = await taDao.getAllTransactions();
      expect(stored, hasLength(2));
    });

    test('skips duplicates by default', () async {
      final transactions = [
        _parsed(description: 'New transaction', amount: '100.00'),
        _parsed(description: 'Duplicate transaction', amount: '50.00', isDuplicate: true),
      ];
      final result = await orchestrator.commitImport(transactions);

      expect(result.inserted, equals(1));
      expect(result.duplicatesSkipped, equals(1));
      expect(result.totalParsed, equals(2));
      final stored = await taDao.getAllTransactions();
      expect(stored, hasLength(1));
      expect(stored.first.shortDescription, equals('New transaction'));
    });



  });



}

