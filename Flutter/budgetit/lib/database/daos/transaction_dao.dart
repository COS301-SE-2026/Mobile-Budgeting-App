// daos/transaction_dao.dart
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, TransactionCategoryMap])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final Uuid _uuid = const Uuid();

  TransactionDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

  Future<Transaction> insertTransaction({
    required Decimal amount,
    required TransactionType type,
    required String shortDescription,
    String? longDescription,
    required DateTime transactionDate,
    required TransactionSource source,
    String currency = 'ZAR',
  }) async {
    if (shortDescription.length > 100) {
      throw ArgumentError('shortDescription must be 100 characters or fewer');
    }
    if (longDescription != null && longDescription.length > 500) {
      throw ArgumentError('longDescription must be 500 characters or fewer');
    }
    final id = _uuid.v4();
    final now = _now();
    await into(transactions).insert(
      TransactionsCompanion.insert(
        id: id,
        amount: amount,
        type: type,
        shortDescription: shortDescription,
        longDescription: Value(longDescription),
        transactionDate: transactionDate,
        createdAt: now,
        updatedAt: now,
        source: source,
        currency: Value(currency),
      ),
    );
    return (select(transactions)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Transaction?> getTransactionById(
    String id, {
    bool includeDeleted = false,
  }) {
    final q = select(transactions)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  Future<List<Transaction>> getAllTransactions({bool includeDeleted = false}) {
    final q = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<List<Transaction>> getTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  }) {
    final q = select(transactions)
      ..where((t) => t.type.equalsValue(type))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end, {
    bool includeDeleted = false,
  }) {
    final q = select(transactions)
      ..where(
        (t) =>
            t.transactionDate.isBiggerOrEqualValue(start) &
            t.transactionDate.isSmallerOrEqualValue(end),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<Transaction> updateTransaction(
    String id, {
    Decimal? amount,
    TransactionType? type,
    String? shortDescription,
    String? longDescription,
    DateTime? transactionDate,
    TransactionSource? source,
    String? currency,
  }) async {
    final companion = TransactionsCompanion(
      amount: amount != null ? Value(amount) : const Value.absent(),
      type: type != null ? Value(type) : const Value.absent(),
      shortDescription: shortDescription != null
          ? Value(shortDescription)
          : const Value.absent(),
      longDescription: longDescription != null
          ? Value(longDescription)
          : const Value.absent(),
      transactionDate: transactionDate != null
          ? Value(transactionDate)
          : const Value.absent(),
      source: source != null ? Value(source) : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(
      transactions,
    )..where((t) => t.id.equals(id))).write(companion);
    return (select(transactions)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> softDeleteTransaction(String id) async {
    final now = _now();
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> hardDeleteTransaction(String id) async {
    await (delete(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(id))).go();
    await (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<void> restoreTransaction(String id) async {
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<TransactionCategoryMapData> assignCategory({
    required String transactionId,
    required String categoryId,
    required AssignmentSource assignmentSource,
  }) async {
    final companion = TransactionCategoryMapCompanion.insert(
      transactionId: transactionId,
      categoryId: categoryId,
      assignedAt: _now(),
      assignmentSource: assignmentSource,
    );
    await into(transactionCategoryMap).insertOnConflictUpdate(companion);
    return (select(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(transactionId))).getSingle();
  }

  Future<TransactionCategoryMapData?> getCategoryForTransaction(
    String transactionId,
  ) {
    return (select(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(transactionId))).getSingleOrNull();
  }

  Future<List<TransactionCategoryMapData>> getTransactionsForCategory(
    String categoryId,
  ) {
    return (select(
      transactionCategoryMap,
    )..where((t) => t.categoryId.equals(categoryId))).get();
  }

  Future<void> removeMapping(String transactionId) async {
    await (delete(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(transactionId))).go();
  }

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) {
    final query = select(transactions).join([
      leftOuterJoin(
        transactionCategoryMap,
        transactionCategoryMap.transactionId.equalsExp(transactions.id),
      ),
    ]);
    query.where(transactionCategoryMap.categoryId.equals(categoryId));
    return query.map((row) => row.readTable(transactions)).get();
  }
}
