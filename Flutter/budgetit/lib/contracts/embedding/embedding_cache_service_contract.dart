import 'dart:typed_data';

import 'package:budgetit/database/schema.dart';

/// Returns text embeddings, computing them only when not already cached.
/// Wraps the embedding model and the embedding cache so callers never decide
/// between them. The cache key includes a hash of the text and the model
/// version, so changed text or an upgraded model recomputes automatically.
///
/// {@category Embedding}
abstract interface class EmbeddingCacheServiceContract {
  /// Returns the embedding of [text], from cache when possible.
  /// On a miss the vector is computed and stored before being returned, so
  /// the next call for the same text and model is a cache hit.
  ///
  /// Throws an [ArgumentError] if [sourceId] is empty or only whitespace,
  /// since a blank id would collide across unrelated records. [sourceId] is
  /// trimmed before use.
  ///
  ///  [sourceType] : what kind of record [sourceId] refers to
  ///  [sourceId] : identifier of the record this text belongs to
  ///  [text] : the text to embed; its hash forms part of the cache key
  Future<Float32List> getOrCreate({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String text,
  });
}
