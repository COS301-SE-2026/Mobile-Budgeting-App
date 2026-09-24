import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

/// Data access for recurring transaction templates.
/// A recurring transaction is a rule; amount, description, category and a
/// repeat interval from which real transactions are generated as each due
/// date passes. The next due date is held on the template itself and moved
/// forward by [advanceNextDate] once an occurrence has been created.
/// Deletion is soft by default; transactions already generated from a
/// template are not affected.
///
/// {@category DAOs}
abstract interface class RecurringTransactionDaoContract {
  /// Inserts a recurring transaction template and returns it.
  /// Throws an [ArgumentError] if [shortDescription] exceeds 100 characters.
  ///
  ///  [unit] and [intervalAmount] : together define the repeat, e.g.
  ///   'PeriodType.monthly' with '1' for monthly
  ///  [nextTransactionDate] : when the next occurrence is due
  ///  [startDate] : when the rule takes effect
  ///  [categoryId] : optional; applied to each generated transaction
  Future<RecurringTransaction> insertRecurringTransaction({
    required Decimal amount,
    required TransactionType type,
    required String shortDescription,
    required DateTime nextTransactionDate,
    required PeriodType unit,
    required int intervalAmount,
    required DateTime startDate,
    String? longDescription,
    String? categoryId,
    String? currency = 'ZAR',
  });

  /// Retrieves a recurring transaction by [id].
  /// Returns 'null' if none exists, or if it is soft-deleted and
  /// [includeDeleted] is 'false'.
  Future<RecurringTransaction?> getRecurringTransactionById(
    String id, {
    bool includeDeleted = false,
  });

  /// Retrieves all recurring transactions.
  /// Soft-deleted rows are excluded unless [includeDeleted] is 'true'.
  Future<List<RecurringTransaction>> getAllRecurringTransactions({
    bool includeDeleted = false,
  });

  /// Retrieves all recurring transactions of the given [type].
  /// Soft-deleted rows are excluded unless [includeDeleted] is 'true'.
  Future<List<RecurringTransaction>> getRecurringTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  });

  /// Updates the supplied fields of template [id] and returns the updated
  /// record.
  /// Non-'null' parameters are written and the updated-at timestamp is
  /// refreshed. [longDescription] is a nullable column, so it takes a
  /// [Value]: omit it to leave it alone, or pass 'Value(null)' to clear it.
  Future<RecurringTransaction> updateRecurringTransaction(
    String id, {
    Decimal? amount,
    TransactionType? type,
    String? shortDescription,
    Value<String?> longDescription = const Value.absent(),
    DateTime? nextTransactionDate,
    PeriodType? unit,
    int? intervalAmount,
    DateTime? startDate,
  });

  /// Soft-deletes template [id], stopping future occurrences.
  /// Transactions already generated are kept. Reverse with
  /// [restoreRecurringTransaction].
  Future<void> softDeleteRecurringTransaction(String id);

  /// Permanently removes template [id]. This cannot be undone.
  Future<void> hardDeleteRecurringTransaction(String id);

  /// Restores a soft-deleted template by clearing its deleted-at timestamp.
  Future<void> restoreRecurringTransaction(String id);

  /// Returns templates whose next due date is at or before [before].
  /// This is the catch-up query: pass the end of the local day to collect
  /// everything owed up to and including today.
  /// Soft-deleted rows are excluded unless [includeDeleted] is 'true'.
  Future<List<RecurringTransaction>> getDueRecurringTransactions(
    DateTime before, {
    bool includeDeleted = false,
  });

  /// Moves template [id] forward by one interval and returns the updated
  /// record.
  /// Call after an occurrence has been created, so the same date is not
  /// generated twice. A template that is several intervals overdue needs one
  /// call per occurrence.
  Future<RecurringTransaction> advanceNextDate(String id);

  /// Returns the transactions that were generated from [recurringId].
  /// Soft-deleted transactions are excluded unless [includeDeleted] is
  /// 'true'.
  Future<List<Transaction>> getTransactionsForRecurring(
    String recurringId, {
    bool includeDeleted = false,
  });
}
