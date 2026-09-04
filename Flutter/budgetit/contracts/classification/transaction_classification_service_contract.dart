import 'package:budgetit/services/ai/transaction_classifier/transaction_classification_service.dart';

abstract interface class TransactionClassificationServiceContract {
  Future<void> initialize();

  Future<TransactionClassificationResult> classify({
    required String shortDescription,
    required List<ClassificationCategory> categories,
    String? transactionId,
    String? longDescription,
  });

  Future<void> dispose();
}
