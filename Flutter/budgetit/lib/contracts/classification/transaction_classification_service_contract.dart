import 'package:budgetit/services/ai/transaction_classifier/transaction_classification_service.dart';

/// Suggests a category for a transaction using on-device text embeddings.
/// Runs the BGE sentence-embedding model through ONNX Runtime, embedding both
/// the transaction description and the candidate category names, then ranks
/// categories by similarity. This is the second pass of import
/// classification, used for transactions that keyword matching could not
/// place.
///
/// Lifecycle: call [initialize] once before the first [classify], and
/// [dispose] when finished, so the native interpreter and its memory are
/// released.
///
/// {@category Classification}
abstract interface class TransactionClassificationServiceContract {
  /// Loads the model and prepares the embedding runtime.
  /// Must complete before [classify] can return real suggestions. Safe to
  /// await more than once; implementations should make repeat calls a no-op.
  Future<void> initialize();

  /// Ranks [categories] by how closely they match the transaction text.
  /// The returned [TransactionClassificationResult] carries the ordered
  /// matches and the model version that produced them; read
  /// 'bestMatch' for the top suggestion, which is 'null' when nothing
  /// scored highly enough.
  ///
  /// If the service is disabled or not initialised, returns an empty result
  /// rather than throwing, so callers can treat AI classification as
  /// best-effort.
  ///
  ///  [shortDescription] : the primary text to classify
  ///  [categories] : the candidate categories to rank
  ///  [transactionId] : optional identifier used to cache the embedding
  ///  [longDescription] : optional extra text appended to the input
  Future<TransactionClassificationResult> classify({
    required String shortDescription,
    required List<ClassificationCategory> categories,
    String? transactionId,
    String? longDescription,
  });

  /// Releases the model and native resources.
  /// After this, [classify] will not produce suggestions until [initialize]
  /// is awaited again.
  Future<void> dispose();
}
