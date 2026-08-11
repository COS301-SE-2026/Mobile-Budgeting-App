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


    test('inserts duplicates instead of skipping them', () async {
      final transactions = [ _parsed(description: 'Duplicate transaction', amount: '50.00', isDuplicate: true)];
      final result = await orchestrator.commitImport(transactions, forceAll: true);
      expect(result.inserted, equals(1));
      expect(result.duplicatesSkipped, equals(0));

      final stored = await taDao.getAllTransactions();
      expect(stored, hasLength(1));
    });

    test('assigns category with AssignmentSource.ai when not manually overridden', () async {
      final category = await categoryDao.insertCategory( name: 'Groceries', type: CategoryType.expense);
      final transactions = [
        _parsed(
          description: 'Checkers groceries',
          amount: '250.00',
          categoryId: category.id,
        ),
      ];

      await orchestrator.commitImport(transactions);
      final stored = await taDao.getAllTransactions();
      final mapping = await taDao.getCategoryForTransaction(stored.first.id);

      expect(mapping, isNotNull);
      expect(mapping!.categoryId, equals(category.id));
      expect(mapping.assignmentSource, equals(AssignmentSource.ai));
    });


    test('assigns category with AssignmentSource.manual when categoryOverridden is true', () async {
      final category = await categoryDao.insertCategory( name: 'Groceries', type: CategoryType.expense);
      final transactions = [
        _parsed(
          description: 'Checkers groceries',
          amount: '250.00',
          categoryId: category.id,
          categoryOverridden: true,
        ),
      ];
      await orchestrator.commitImport(transactions);
      final stored = await taDao.getAllTransactions();
      final mapping = await taDao.getCategoryForTransaction(stored.first.id);

      expect(mapping!.assignmentSource, equals(AssignmentSource.manual));
    });

    test('no category assignment is made when categoryId is null', () async {
      final transactions = [ _parsed(description: 'Uncategorised expense', amount: '75.00')];
      await orchestrator.commitImport(transactions);
      final stored = await taDao.getAllTransactions();
      final mapping = await taDao.getCategoryForTransaction(stored.first.id);

      expect(mapping, isNull);
    });

    test('a row that fails to insert is counted as failed with an error message, no failures', () async {
      final overlongDescription = 'x' * 700;
      final transactions = [
        _parsed(description: 'Valid transaction', amount: '10.00'),
        _parsed(description: overlongDescription, amount: '20.00'),
        _parsed(description: 'Another valid transaction', amount: '30.00'),
      ];
      final result = await orchestrator.commitImport(transactions);

      expect(result.totalParsed, equals(3));
      expect(result.inserted, equals(2));
      expect(result.failed, equals(1));
      expect(result.duplicatesSkipped, equals(0));
      expect(result.errors, hasLength(1));
      expect(result.errors.keys.first, equals(overlongDescription.substring(0, 100)));
      final stored = await taDao.getAllTransactions();
      expect(stored, hasLength(2));
    });

    test('mixed batch: duplicate skipped, one succeeds, one fails - totals reconcile', () async {
      final overlongDescription = 'y' * 700;
      final transactions = [
        _parsed(description: 'Duplicate row', amount: '10.00', isDuplicate: true),
        _parsed(description: 'Good row', amount: '20.00'),
        _parsed(description: overlongDescription, amount: '30.00'),
      ];
      final result = await orchestrator.commitImport(transactions);

      expect(result.totalParsed, equals(3));
      expect(result.duplicatesSkipped, equals(1));
      expect(result.inserted, equals(1));
      expect(result.failed, equals(1));
      expect(result.duplicatesSkipped + result.inserted + result.failed, equals(result.totalParsed));
    });

    test('inserted transactions carry TransactionSource.import and the correct type', () async {
      final transactions = [
        _parsed(description: 'Expense row', amount: '10.00', isIncome: false),
        _parsed(description: 'Income row', amount: '20.00', isIncome: true),
      ];
      await orchestrator.commitImport(transactions);
      final stored = await taDao.getAllTransactions();
      final expenseRow = stored.firstWhere((t) => t.shortDescription == 'Expense row');
      final incomeRow = stored.firstWhere((t) => t.shortDescription == 'Income row');

      expect(expenseRow.source, equals(TransactionSource.import));
      expect(expenseRow.type, equals(TransactionType.expense));
      expect(incomeRow.type, equals(TransactionType.income));
    });


  });



}

