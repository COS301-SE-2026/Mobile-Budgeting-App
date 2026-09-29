@Tags(['nfr'])
library;
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/services/financial_health_score_service.dart';
import '../unit/database/helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    configureSqliteForTests();
    db = openTestDatabase();
  });

  tearDown(() async => db.close());

  Future<Transaction> add({
    required String amount,
    required TransactionType type,
    DateTime? date,
    String description = 'Test',
  }) {
    return db.transactionDao.insertTransaction(
      amount: Decimal.parse(amount),
      type: type,
      shortDescription: description,
      transactionDate: date ?? DateTime.now(),
      source: TransactionSource.manual,
    );
  }

  test('decimal amounts survive a write and read without precision loss',
      () async {
    const values = [
      '0.01',
      '0.10',
      '99.99',
      '1234.56',
      '999999.99',
      '0.05',
      '10.005',
    ];

    for (final v in values) {
      await add(amount: v, type: TransactionType.expense, description: v);
    }
    final stored = await db.transactionDao.getAllTransactions();
    final readBack = {for (final t in stored) t.shortDescription: t.amount};
    for (final v in values) {
      print('decimal $v -> ${readBack[v]}');
      expect(readBack[v], Decimal.parse(v), reason: 'precision lost on $v');
    }
  });

  test('summing decimals gives an exact total with no floating point drift',
      () async {
    for (var i = 0; i < 100; i++) {
      await add(amount: '0.10', type: TransactionType.expense);
    }
    final stored = await db.transactionDao.getTransactionsByType(
      TransactionType.expense,
    );
    final total = stored.fold<Decimal>(
      Decimal.zero,
      (sum, t) => sum + t.amount,
    );
    print('100 x 0.10 = $total');
    expect(total, Decimal.parse('10.00'));
  });

  test('type filters partition the data with no overlap or loss', () async {
    await add(amount: '100.00', type: TransactionType.income);
    await add(amount: '200.00', type: TransactionType.income);
    await add(amount: '50.00', type: TransactionType.expense);
    await add(amount: '25.00', type: TransactionType.expense);
    await add(amount: '75.00', type: TransactionType.expense);
    final all = await db.transactionDao.getAllTransactions();
    final income = await db.transactionDao.getTransactionsByType(TransactionType.income);
    final expense = await db.transactionDao.getTransactionsByType(TransactionType.expense);

    print('partition: all=${all.length} income=${income.length} '
        'expense=${expense.length}');
    expect(income.length + expense.length, all.length);
    expect(income.map((t) => t.id).toSet().intersection(
          expense.map((t) => t.id).toSet(),
        ), isEmpty);
  });

  test('date-range queries include both boundary days', () async {
    await add(
      amount: '10.00',
      type: TransactionType.expense,
      date: DateTime(2026, 5, 1),
      description: 'first day',
    );
    await add(
      amount: '20.00',
      type: TransactionType.expense,
      date: DateTime(2026, 5, 15),
      description: 'middle',
    );
    await add(
      amount: '30.00',
      type: TransactionType.expense,
      date: DateTime(2026, 5, 31),
      description: 'last day',
    );
    await add(
      amount: '40.00',
      type: TransactionType.expense,
      date: DateTime(2026, 6, 1),
      description: 'outside',
    );
    final inRange = await db.transactionDao.getTransactionsByDateRange(
      DateTime(2026, 5, 1),
      DateTime(2026, 5, 31),
    );
    final descriptions = inRange.map((t) => t.shortDescription).toList();
    print('date boundaries: $descriptions');
    expect(inRange.length, 3);
    expect(descriptions, contains('first day'));
    expect(descriptions, contains('last day'));
    expect(descriptions, isNot(contains('outside')));
  });

  test('soft-deleted transactions are excluded from totals but recoverable',
      () async {
    final keep = await add(amount: '100.00', type: TransactionType.expense);
    final remove = await add(amount: '250.00', type: TransactionType.expense);
    final before = await db.transactionDao.getAllTransactions();
    await db.transactionDao.softDeleteTransaction(remove.id);
    final after = await db.transactionDao.getAllTransactions();
    final withDeleted = await db.transactionDao.getAllTransactions(includeDeleted: true);
    await db.transactionDao.restoreTransaction(remove.id);
    final restored = await db.transactionDao.getAllTransactions();

    print('soft delete: before=${before.length} after=${after.length} '
        'withDeleted=${withDeleted.length} restored=${restored.length}');
    expect(after.length, before.length - 1);
    expect(after.map((t) => t.id), isNot(contains(remove.id)));
    expect(withDeleted.length, before.length);
    expect(restored.length, before.length);
    expect(restored.map((t) => t.id), contains(keep.id));
  });

  test('financial health score stays within 0-100 for extreme inputs',
      () async {
    final service = FinancialHealthScoreService(db);
    final now = DateTime.now();
    final empty = await service.calculateMonthlyScore();
    print('score with no data: ${empty.score} (${empty.status})');
    expect(empty.score, inInclusiveRange(0, 100));
    await add(amount: '1000000.00', type: TransactionType.income, date: now);
    final incomeOnly = await service.calculateMonthlyScore();
    print('score income only: ${incomeOnly.score} (${incomeOnly.status})');
    expect(incomeOnly.score, inInclusiveRange(0, 100));
    await add(amount: '5000000.00', type: TransactionType.expense, date: now);
    final overspent = await service.calculateMonthlyScore();
    print('score heavily overspent: ${overspent.score} '
        '(${overspent.status}) net=${overspent.netBalance}');
    expect(overspent.score, inInclusiveRange(0, 100));
  });

  test('financial health score totals match the underlying transactions',
      () async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    await add(amount: '15000.00', type: TransactionType.income, date: monthStart);
    await add(amount: '2500.00', type: TransactionType.income, date: monthStart);
    await add(amount: '450.00', type: TransactionType.expense, date: monthStart);
    await add(amount: '1200.50', type: TransactionType.expense, date: monthStart);
    final score = await FinancialHealthScoreService(db).calculateMonthlyScore();

    print('score totals: income=${score.totalIncome} '
        'expenses=${score.totalExpenses} net=${score.netBalance}');
    expect(score.totalIncome, 17500.0);
    expect(score.totalExpenses, 1650.5);
    expect(score.netBalance, closeTo(15849.5, 0.001));
  });

  test('soft-deleted transactions do not contribute to the health score',
      () async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    await add(amount: '10000.00', type: TransactionType.income, date: monthStart);
    final removed = await add(
      amount: '9000.00',
      type: TransactionType.expense,
      date: monthStart,
    );
    final before = await FinancialHealthScoreService(db).calculateMonthlyScore();
    await db.transactionDao.softDeleteTransaction(removed.id);
    final after = await FinancialHealthScoreService(db).calculateMonthlyScore();

    print('health score expenses before=${before.totalExpenses} '
        'after soft delete=${after.totalExpenses}');
    expect(before.totalExpenses, 9000.0);
    expect(after.totalExpenses, 0.0);
  });
}