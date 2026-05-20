// daos/transaction_dao.dart
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'transaction_dao.g.dart';

/// Data access object for managing transactions and their category mappings.
///
/// [TransactionDao] provides full CRUD for transactions stored in [Transactions],
/// along with category association through the [TransactionCategoryMap] table.
/// Soft deletes are supported, and category mappings are cleaned up on
/// hard delete.
///
/// Transactions are ordered by [Transaction.transactionDate] descending
/// by default in queries.
///
/// Usage:
/// ```dart
/// final dao = TransactionDao(database);
/// final tx = await dao.insertTransaction(
///   amount: Decimal.parse('50.00'),
///   type: TransactionType.expense,
///   shortDescription: 'Groceries',
///   transactionDate: DateTime.now(),
///   source: TransactionSource.manual,
/// );
/// ```
@DriftAccessor(tables: [Transactions, TransactionCategoryMap])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  /// Singleton UUID generator used to create unique identifiers for transactions.
  final Uuid _uuid = const Uuid();

  /// Creates a new instance of [TransactionDao] backed by the given [AppDatabase].
  TransactionDao(super.db);

  /// Returns the current UTC time.
  DateTime _now() => DateTime.now().toUtc();

  /// Inserts a new transaction.
  ///
  /// Throws [ArgumentError] if [shortDescription] exceeds 100 characters
  /// or [longDescription] exceeds 500 characters.
  ///
  /// - [amount] - the transaction amount
  /// - [type] - the transaction type ([income] or [expense])
  /// - [shortDescription] - a brief description (max 100 chars)
  /// - [longDescription] - an optional extended description (max 500 chars)
  /// - [transactionDate] - when the transaction occurred
  /// - [source] - the source of the transaction
  /// - [currency] - the currency code (defaults to 'ZAR')
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

  /// Retrieves a single transaction by its [id].
  ///
  /// Returns `null` if no transaction exists with the given ID or if the
  /// transaction has been soft-deleted and [includeDeleted] is `false`.
  ///
  /// - [id] - the unique identifier of the transaction
  /// - [includeDeleted] - if `true`, includes soft-deleted transactions
  ///   (defaults to `false`)
  Future<Transaction?> getTransactionById(
    String id, {
    bool includeDeleted = false,
  }) {
    final q = select(transactions)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  /// Retrieves all transactions, ordered by [Transaction.transactionDate] descending.
  ///
  /// By default, soft-deleted transactions are excluded. Use [includeDeleted]
  /// to include soft-deleted transactions.
  ///
  /// - [includeDeleted] - if `true`, includes soft-deleted transactions
  ///   (defaults to `false`)
  Future<List<Transaction>> getAllTransactions({bool includeDeleted = false}) {
    final q = select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  /// Retrieves all transactions of the given [type].
  ///
  /// Ordered by [Transaction.transactionDate] descending. Soft-deleted
  /// transactions are excluded unless [includeDeleted] is `true`.
  ///
  /// - [type] - the transaction type to filter by
  /// - [includeDeleted] - if `true`, includes soft-deleted transactions
  ///   (defaults to `false`)
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

  /// Retrieves transactions within the given [start] and [end] date range.
  ///
  /// Ordered by [Transaction.transactionDate] descending. Soft-deleted
  /// transactions are excluded unless [includeDeleted] is `true`.
  ///
  /// - [start] - start of the date range (inclusive)
  /// - [end] - end of the date range (inclusive)
  /// - [includeDeleted] - if `true`, includes soft-deleted transactions
  ///   (defaults to `false`)
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

  /// Updates a transaction's fields.
  ///
  /// Only provided non-`null` parameters are updated. The
  /// [Transaction.updatedAt] timestamp is always refreshed.
  ///
  /// Returns the updated [Transaction].
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

  /// Soft-deletes a transaction by marking [id] with a [deletedAt] timestamp.
  ///
  /// The transaction is not actually removed from the database. It will be
  /// excluded from query results unless [getTransactionById] or
  /// [getAllTransactions] are called with [includeDeleted] = `true`.
  Future<void> softDeleteTransaction(String id) async {
    final now = _now();
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  /// Hard-deletes a transaction and its category mapping.
  ///
  /// Removes all [TransactionCategoryMap] entries for the transaction
  /// and the transaction row itself.
  Future<void> hardDeleteTransaction(String id) async {
    await (delete(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(id))).go();
    await (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Restores a soft-deleted transaction by clearing its [deletedAt] timestamp.
  ///
  /// The transaction becomes visible in queries again after restoration.
  Future<void> restoreTransaction(String id) async {
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  /// Assigns a [categoryId] to a [transactionId] with the given [assignmentSource].
  ///
  /// If a mapping for the transaction already exists, it is updated
  /// in place. Returns the stored mapping.
  ///
  /// - [transactionId] - the transaction to assign a category to
  /// - [categoryId] - the category to assign
  /// - [assignmentSource] - how the assignment was made (manual, AI, import)
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

  /// Retrieves the category assigned to a transaction.
  ///
  /// Returns `null` if no category has been assigned to the transaction.
  Future<TransactionCategoryMapData?> getCategoryForTransaction(
    String transactionId,
  ) {
    return (select(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(transactionId))).getSingleOrNull();
  }

  /// Retrieves all transactions that have been assigned the given [categoryId].
  ///
  /// This queries the [TransactionCategoryMap] table directly.
  Future<List<TransactionCategoryMapData>> getTransactionsForCategory(
    String categoryId,
  ) {
    return (select(
      transactionCategoryMap,
    )..where((t) => t.categoryId.equals(categoryId))).get();
  }

  /// Removes the category mapping for a transaction.
  Future<void> removeMapping(String transactionId) async {
    await (delete(
      transactionCategoryMap,
    )..where((t) => t.transactionId.equals(transactionId))).go();
  }

  /// Retrieves transactions that are mapped to the given [categoryId] via the [TransactionCategoryMap].
  ///
  /// Performs a left outer join between [transactions] and [transactionCategoryMap]
  /// to return full [Transaction] records.
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
