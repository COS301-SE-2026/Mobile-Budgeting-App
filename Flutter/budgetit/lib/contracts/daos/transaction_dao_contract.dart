import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:decimal/decimal.dart';

/// Data access for transactions and their category mappings.
/// Provides full CRUD over the 'Transactions' table plus association to
/// categories through 'TransactionCategoryMap'. Deletion is soft by default:
/// a deleted row keeps its data and is simply hidden from queries, so it can
/// be restored. Query methods return transactions ordered by transaction date
/// descending.
///
/// {@category DAOs}
abstract interface class TransactionDaoContract {
  /// Inserts a transaction and returns the persisted record.
  ///
  /// A UUID is generated for the new row and its created/updated timestamps
  /// are set in UTC.
  ///
  /// Throws an [ArgumentError] if [shortDescription] exceeds 100 characters
  /// or [longDescription] exceeds 500.
  ///
  ///  [amount] : the transaction amount, always stored unsigned; direction
  ///   comes from [type]
  ///  [type] : income or expense
  ///  [shortDescription] : brief description, max 100 characters
  ///  [transactionDate] : when the transaction occurred
  ///  [source] : how the transaction entered the app (manual, import,
  ///   recurring)
  ///  [longDescription] : optional extended description, max 500 characters
  ///  [currency] : ISO currency code, defaults to 'ZAR'
  ///  [recurringId] : set when this row was generated from a recurring
  ///   template
  Future<Transaction> insertTransaction({
    required Decimal amount,
    required TransactionType type,
    required String shortDescription,
    required DateTime transactionDate,
    required TransactionSource source,
    String? longDescription,
    String currency = 'ZAR',
    String? recurringId,
  });

  /// Retrieves a single transaction by [id].
  /// Returns 'null' if no such transaction exists, or if it is soft-deleted
  /// and [includeDeleted] is 'false'.
  Future<Transaction?> getTransactionById(
    String id, {
    bool includeDeleted = false,
  });

  /// Retrieves all transactions, most recent transaction date first.
  /// Soft-deleted rows are excluded unless [includeDeleted] is 'true'.
  Future<List<Transaction>> getAllTransactions({
    bool includeDeleted = false,
  });

  /// Retrieves all transactions of the given [type], most recent first.
  /// Soft-deleted rows are excluded unless [includeDeleted] is 'true'.
  Future<List<Transaction>> getTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  });

  /// Retrieves transactions dated between [start] and [end] inclusive, most
  /// recent first.
  /// Both bounds are compared against [Transaction.transactionDate], so pass
  /// an [end] at the last instant of the day to include that whole day.
  /// Soft-deleted rows are excluded unless [includeDeleted] is 'true'.
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end, {
    bool includeDeleted = false,
  });

  /// Updates the supplied fields of transaction [id] and returns the updated
  /// record.
  /// Only non-'null' parameters are written; the updated-at timestamp is
  /// always refreshed.
  Future<Transaction> updateTransaction(
    String id, {
    Decimal? amount,
    TransactionType? type,
    String? shortDescription,
    DateTime? transactionDate,
    TransactionSource? source,
    String? longDescription,
    String? currency,
    String? recurringId,
  });

  /// Soft-deletes transaction [id] by stamping its deleted-at timestamp.
  /// The row is retained and hidden from queries unless they pass
  /// 'includeDeleted: true'. Reverse with [restoreTransaction].
  Future<void> softDeleteTransaction(String id);

  /// Permanently removes transaction [id] and its category mapping.
  /// Both deletions happen in one database transaction. This cannot be
  /// undone; prefer [softDeleteTransaction] for user-facing deletes.
  Future<void> hardDeleteTransaction(String id);

  /// Restores a soft-deleted transaction by clearing its deleted-at
  /// timestamp.
  Future<void> restoreTransaction(String id);

  /// Assigns [categoryId] to [transactionId] and returns the mapping.
  /// A transaction has at most one category: assigning again replaces the
  /// existing mapping rather than adding a second.
  ///
  /// - [assignmentSource] — records whether the category was chosen by the
  ///   user, by keyword rules or by the AI classifier
  Future<TransactionCategoryMapData> assignCategory({
    required String transactionId,
    required String categoryId,
    required AssignmentSource assignmentSource,
  });

  /// Returns the category mapping for [transactionId], or 'null' when the
  /// transaction has no category assigned.
  Future<TransactionCategoryMapData?> getCategoryForTransaction(
    String transactionId,
  );

  /// Returns the mapping rows for every transaction assigned to
  /// [categoryId].
  ///
  /// Returns mappings, not transactions; use [getTransactionsByCategory] for
  /// the transactions themselves.
  Future<List<TransactionCategoryMapData>> getTransactionsForCategory(
    String categoryId,
  );

  /// Removes the category mapping for [transactionId], leaving the
  /// transaction uncategorised.
  /// Does nothing if no mapping exists.
  Future<void> removeMapping(String transactionId);

  /// Returns the transactions assigned to [categoryId].
  Future<List<Transaction>> getTransactionsByCategory(
    String categoryId,
  );
}
