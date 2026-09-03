import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

abstract interface class RecurringTransactionDaoContract {
  Future<RecurringTransaction> insertRecurringTransaction({
    required Decimal amount,
    required TransactionType type,
    required String shortDescripton,
    required DateTime nextTransactionDate,
    required PeriodType unit,
    required int intervalAmount,
    required DateTime startDate,
    String? longDescription,
    String? categoryId,
    String? currency = 'ZAR',
  });

  Future<RecurringTransaction?> getRecurringTransactionById(
    String id, {
    bool includeDeleted = false,
  });

  Future<List<RecurringTransaction>> getAllRecurringTransactions({
    bool includeDeleted = false,
  });

  Future<List<RecurringTransaction>> getRecurringTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  });

  Future<RecurringTransaction> updateRecurringTransaction(
    String id, {
    Decimal? amount,
    TransactionType? type,
    String? shortDescripton,
    Value<String?> longDescription = const Value.absent(),
    DateTime? nextTransactionDate,
    PeriodType? unit,
    int? intervalAmount,
    DateTime? startDate,
  });

  Future<void> softDeleteRecurringTransaction(String id);

  Future<void> hardDeleteRecurringTransaction(String id);

  Future<void> restoreRecurringTransaction(String id);

  Future<List<RecurringTransaction>> getDueRecurringTransactions(
    DateTime before, {
    bool includeDeleted = false,
  });

  Future<RecurringTransaction> advanceNextDate(String id);

  Future<List<Transaction>> getTransactionsForRecurring(
    String recurringId, {
    bool includeDeleted = false,
  });
}
