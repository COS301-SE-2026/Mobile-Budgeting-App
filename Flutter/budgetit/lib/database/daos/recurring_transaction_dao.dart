import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'recurring_transaction_dao.g.dart';

@DriftAccessor(
  tables: [RecurringTransactions, Transactions, TransactionCategoryMap],
)
class RecurringTransactionDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringTransactionDaoMixin {
  final Uuid _uuid = const Uuid();

  RecurringTransactionDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

  Future<RecurringTransaction> insertRecurringTransaction({
    required Decimal amount,
    required TransactionType type,
    required String shortDescription,
    String? longDescription,
    required DateTime nextTransactionDate,
    required PeriodType unit,
    required int intervalAmount,
    String currency = 'ZAR',
  }) {
    throw UnimplementedError();
  }

  Future<RecurringTransaction?> getRecurringTransactionById(
    String id, {
    bool includeDeleted = false,
  }) {
    throw UnimplementedError();
  }

  Future<List<RecurringTransaction>> getAllRecurringTransactions({
    bool includeDeleted = false,
  }) {
    throw UnimplementedError();
  }

  Future<List<RecurringTransaction>> getRecurringTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  }) {
    throw UnimplementedError();
  }

  Future<RecurringTransaction> updateRecurringTransaction(
    String id, {
    Decimal? amount,
    TransactionType? type,
    String? shortDescription,
    Value<String?> longDescription = const Value.absent(),
    DateTime? nextTransactionDate,
    PeriodType? unit,
    int? intervalAmount,
    String? currency,
  }) {
    throw UnimplementedError();
  }

  Future<void> softDeleteRecurringTransaction(String id) {
    throw UnimplementedError();
  }

  Future<void> hardDeleteRecurringTransaction(String id) {
    throw UnimplementedError();
  }

  Future<void> restoreRecurringTransaction(String id) {
    throw UnimplementedError();
  }

  Future<List<RecurringTransaction>> getDueRecurringTransactions(
    DateTime before, {
    bool includeDeleted = false,
  }) {
    throw UnimplementedError();
  }

  Future<RecurringTransaction> advanceNextDate(String id) {
    throw UnimplementedError();
  }

  Future<List<Transaction>> getTransactionsForRecurring(
    String recurringId, {
    bool includeDeleted = false,
  }) {
    throw UnimplementedError();
  }
}
