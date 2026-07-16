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
  }) async {
    if (shortDescription.length > 100) {
      throw ArgumentError('shortDescription must be 100 characters or less');
    }
    if (longDescription != null && longDescription.length > 500) {
      throw ArgumentError('longDescription must be 500 characters or less');
    }
    if (amount <= Decimal.zero) {
      throw ArgumentError('amount must be bigger than zero');
    }
    if (intervalAmount <= 0) {
      throw ArgumentError('intervalAmount must be bigger than zero');
    }
    final id = _uuid.v4();
    final now = _now();
    await into(recurringTransactions).insert(
      RecurringTransactionsCompanion.insert(
        id: id,
        amount: amount,
        type: type,
        shortDescription: shortDescription,
        longDescription: Value(longDescription),
        nextTransactionDate: nextTransactionDate,
        createdAt: now,
        updatedAt: now,
        unit: unit,
        intervalAmount: intervalAmount,
        currency: Value(currency),
      ),
    );
    return (select(
      recurringTransactions,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<RecurringTransaction?> getRecurringTransactionById(
    String id, {
    bool includeDeleted = false,
  }) {
    final q = select(recurringTransactions)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  Future<List<RecurringTransaction>> getAllRecurringTransactions({
    bool includeDeleted = false,
  }) {
    final q = select(recurringTransactions)
      ..orderBy([(t) => OrderingTerm.asc(t.nextTransactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<List<RecurringTransaction>> getRecurringTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  }) {
    final q = select(recurringTransactions)
      ..where((t) => t.type.equalsValue(type))
      ..orderBy([(t) => OrderingTerm.asc(t.nextTransactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
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
  }) async {
    if (shortDescription != null && shortDescription.length > 100) {
      throw ArgumentError('shortDescription must be 100 characters or less');
    }
    final ldValue = longDescription.present ? longDescription.value : null;
    if (ldValue != null && ldValue.length > 500) {
      throw ArgumentError('longDescription must be 500 characters or less');
    }
    final exists = await (select(
      recurringTransactions,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    if (exists == null) {
      throw Exception('Recurring transaction not found or is soft-deleted');
    }
    final companion = RecurringTransactionsCompanion(
      amount: amount != null ? Value(amount) : const Value.absent(),
      type: type != null ? Value(type) : const Value.absent(),
      shortDescription: shortDescription != null
          ? Value(shortDescription)
          : const Value.absent(),
      longDescription: longDescription,
      nextTransactionDate: nextTransactionDate != null
          ? Value(nextTransactionDate)
          : const Value.absent(),
      unit: unit != null ? Value(unit) : const Value.absent(),
      intervalAmount: intervalAmount != null
          ? Value(intervalAmount)
          : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(
      recurringTransactions,
    )..where((t) => t.id.equals(id))).write(companion);
    return (select(
      recurringTransactions,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> softDeleteRecurringTransaction(String id) async {
    final now = _now();
    await (update(recurringTransactions)..where((t) => t.id.equals(id))).write(
      RecurringTransactionsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> hardDeleteRecurringTransaction(String id) async {
    await (update(transactions)..where((t) => t.recurringId.equals(id))).write(
      const TransactionsCompanion(recurringId: Value(null)),
    );
    await (delete(recurringTransactions)..where((t) => t.id.equals(id))).go();
  }

  Future<void> restoreRecurringTransaction(String id) async {
    final now = _now();
    await (update(recurringTransactions)..where((t) => t.id.equals(id))).write(
      RecurringTransactionsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<List<RecurringTransaction>> getDueRecurringTransactions(
    DateTime before, {
    bool includeDeleted = false,
  }) {
    final q = select(recurringTransactions)
      ..where((t) => t.nextTransactionDate.isSmallerOrEqualValue(before))
      ..orderBy([(t) => OrderingTerm.asc(t.nextTransactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
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
