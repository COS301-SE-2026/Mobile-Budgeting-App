import 'dart:typed_data';

import 'package:budgetit/database/schema.dart';

/// Stores computed text embeddings so they need not be recomputed.
/// A cached vector is identified by four parts: what it describes
/// ([EmbeddingSourceType] and a source id), which model produced it
/// ('modelVersion') and a hash of the exact text embedded ('inputHash'). All
/// four must match for a lookup to hit, so editing the text or upgrading the
/// model naturally misses rather than returning a stale vector.
///
/// {@category Embedding}
abstract interface class EmbeddingCacheDaoContract {
  /// Returns the cached vector for this exact combination, or 'null' on a
  /// miss.
  ///
  /// A miss means the caller should compute the embedding and store it with
  /// [saveEmbedding].
  Future<Float32List?> getEmbedding({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String modelVersion,
    required String inputHash,
  });

  /// Stores [vector] against this combination, replacing any existing entry.
  Future<void> saveEmbedding({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String modelVersion,
    required String inputHash,
    required Float32List vector,
  });

  /// Deletes every cached vector for one source, across all model versions.
  /// Call when the underlying record is deleted. Returns the number of rows
  /// removed.
  Future<int> deleteForSource({
    required EmbeddingSourceType sourceType,
    required String sourceId,
  });

  /// Deletes every cached vector produced by [modelVersion].
  /// Returns the number of rows removed.
  Future<int> deleteForModel(String modelVersion);

  /// Deletes every cached vector **except** those produced by
  /// [currentModelVersion].
  ///
  /// Use after a model upgrade to reclaim space held by vectors that can no
  /// longer be compared against new ones. Returns the number of rows removed.
  Future<int> deleteOtherModelVersions(String currentModelVersion);
}
