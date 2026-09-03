import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

abstract interface class TransactionDaoContract {
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

  Future<Transaction?> getTransactionById(
    String id, {
    bool includeDeleted = false,
  });

  Future<List<Transaction>> getAllTransactions({
    bool includeDeleted = false,
  });

  Future<List<Transaction>> getTransactionsByType(
    TransactionType type, {
    bool includeDeleted = false,
  });

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end, {
    bool includeDeleted = false,
  });

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

  Future<void> softDeleteTransaction(String id);

  Future<void> hardDeleteTransaction(String id);

  Future<void> restoreTransaction(String id);

  Future<TransactionCategoryMapData> assignCategory({
    required String transactionId,
    required String categoryId,
    required AssignmentSource assignmentSource,
  });

  Future<TransactionCategoryMapData> getCategoryForTransaction(
    String transactionId,
  );

  Future<List<TransactionCategoryMapData>> getTransactionsForCategory(
    String categoryId,
  );

  Future<void> removeMapping(String transactionId);

  Future<List<Transaction>> getTransactionsByCategory(
    String categoryId,
  );
}
