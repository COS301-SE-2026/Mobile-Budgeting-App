import 'dart:typed_data';

import 'package:budgetit/database/schema.dart';

abstract interface class EmbeddingCacheDaoContract {
  Future<Float32List?> getEmbedding({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String modelVersion,
    required String inputHash,
  });

  Future<void> saveEmbedding({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String modelVersion,
    required String inputHash,
    required Float32List vector,
  });

  Future<int> deleteForSource({
    required EmbeddingSourceType sourceType,
    required String sourceId,
  });

  Future<int> deleteForModel(String modelVersion);

  Future<int> deleteOtherModelVersions(String currentModelVersion);
}
