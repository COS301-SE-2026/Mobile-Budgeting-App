import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:jiffy/jiffy.dart';
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

  Future<RecurringTransaction> _getByIdOrThrow(String id) {
    final query = select(recurringTransactions)..where((t) => t.id.equals(id));
    return query.getSingle();
  }

  void _applyDeletedFilter(
    GeneratedColumn<DateTime> deletedAtColumn,
    SimpleSelectStatement query,
    bool includeDeleted,
  ) {
    if (!includeDeleted) {
      query.where((_) => deletedAtColumn.isNull());
    }
  }

  static const _maxShortDescriptionLength = 100;
  static const _maxLongDescriptionLength = 500;

  Future<RecurringTransaction> insertRecurringTransaction({
    required Decimal amount,
    required TransactionType type,
    required String shortDescription,
    String? longDescription,
    required DateTime nextTransactionDate,
    required PeriodType unit,
    required int intervalAmount,
    required DateTime startDate,
    String? categoryId,
    String currency = 'ZAR',
  }) async {
    if (shortDescription.length > _maxShortDescriptionLength) {
      throw ArgumentError('shortDescription must be 100 characters or less');
    }

    if (longDescription != null &&
        longDescription.length > _maxLongDescriptionLength) {
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
        startDate: startDate,
        categoryId: Value(categoryId),
        currency: Value(currency),
      ),
    );

    return _getByIdOrThrow(id);
  }

  Future<RecurringTransaction?> getRecurringTransactionById(
    String id, {
    bool includeDeleted = false,
  }) {
    final query = select(recurringTransactions)..where((t) => t.id.equals(id));
    _applyDeletedFilter(recurringTransactions.deletedAt, query, includeDeleted);
    return query.getSingleOrNull();
  }

  Future<List<RecurringTransaction>> getAllRecurringTransactions({
    bool includeDeleted = false,
  }) {
    final query = select(recurringTransactions)
      ..orderBy([(t) => OrderingTerm.asc(t.nextTransactionDate)]);

    _applyDeletedFilter(recurringTransactions.deletedAt, query, includeDeleted);

    return query.get();
  }

  Future<List<RecurringTransaction>> getRecurringTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  }) {
    final query = select(recurringTransactions)
      ..where((t) => t.type.equalsValue(type))
      ..orderBy([(t) => OrderingTerm.asc(t.nextTransactionDate)]);

    _applyDeletedFilter(recurringTransactions.deletedAt, query, includeDeleted);
    return query.get();
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
    DateTime? startDate,
  }) async {
    if (shortDescription != null &&
        shortDescription.length > _maxShortDescriptionLength) {
      throw ArgumentError('shortDescription must be 100 characters or less');
    }

    final ldValue = longDescription.present ? longDescription.value : null;

    if (ldValue != null && ldValue.length > _maxLongDescriptionLength) {
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

    return _getByIdOrThrow(id);
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
    final query = select(recurringTransactions)
      ..where((t) => t.nextTransactionDate.isSmallerOrEqualValue(before))
      ..orderBy([(t) => OrderingTerm.asc(t.nextTransactionDate)]);

    _applyDeletedFilter(recurringTransactions.deletedAt, query, includeDeleted);
    return query.get();
  }

  DateTime _addInterval(
    DateTime date,
    PeriodType unit,
    int intervalAmount,
    DateTime startDate,
  ) {
    final currentDate = Jiffy.parseFromDateTime(date);

    switch (unit) {
      case PeriodType.daily:
        return currentDate.add(days: intervalAmount).dateTime;

      case PeriodType.weekly:
        return currentDate.add(days: intervalAmount * 7).dateTime;

      case PeriodType.monthly:
        final next = currentDate.add(months: intervalAmount).dateTime;
        final daysInCurrentMonth = DateTime(date.year, date.month + 1, 0).day;
        final wasClamped =
            date.day != startDate.day && date.day == daysInCurrentMonth;
        final targetDay = _clampDayForMonth(
          next.year,
          next.month,
          wasClamped ? startDate.day : next.day,
        );
        return DateTime(next.year, next.month, targetDay);

      case PeriodType.yearly:
        return currentDate.add(years: intervalAmount).dateTime;
    }
  }

  /// Returns [day] if the target month has at least that many days,
  /// else the last valid day of the month.
  int _clampDayForMonth(int year, int month, int day) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return day > daysInMonth ? daysInMonth : day;
  }

  Future<RecurringTransaction> advanceNextDate(String id) async {
    final record = await (select(
      recurringTransactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (record == null) {
      throw Exception('Recurring transaction not found');
    }

    final newDate = _addInterval(
      record.nextTransactionDate,
      record.unit,
      record.intervalAmount,
      record.startDate,
    );

    await (update(recurringTransactions)..where((t) => t.id.equals(id))).write(
      RecurringTransactionsCompanion(
        nextTransactionDate: Value(newDate),
        updatedAt: Value(_now()),
      ),
    );

    return _getByIdOrThrow(id);
  }

  Future<List<Transaction>> getTransactionsForRecurring(
    String recurringId, {
    bool includeDeleted = false,
  }) {
    final query = select(transactions)
      ..where((t) => t.recurringId.equals(recurringId));

    _applyDeletedFilter(transactions.deletedAt, query, includeDeleted);

    return query.get();
  }
}
