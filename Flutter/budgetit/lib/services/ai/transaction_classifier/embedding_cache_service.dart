import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../../database/daos/embedding_cache_dao.dart';
import '../../../database/schema.dart';
import 'text_embedder.dart';

final class EmbeddingCacheService {
  final TextEmbedder embedder;
  final EmbeddingCacheDao cacheDao;

  EmbeddingCacheService({required this.embedder, required this.cacheDao});

  Future<Float32List> getOrCreate({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String text,
  }) async {
    final cleanSourceId = sourceId.trim();

    if (cleanSourceId.isEmpty) {
      throw ArgumentError.value(
        sourceId,
        'sourceId',
        'The embedding source ID cannot be empty.',
      );
    }

    final inputHash = sha256.convert(utf8.encode(text)).toString();

    final cached = await cacheDao.getEmbedding(
      sourceType: sourceType,
      sourceId: cleanSourceId,
      modelVersion: embedder.modelVersion,
      inputHash: inputHash,
    );

    if (cached != null) {
      return cached;
    }

    final vector = await embedder.embed(text);

    await cacheDao.saveEmbedding(
      sourceType: sourceType,
      sourceId: cleanSourceId,
      modelVersion: embedder.modelVersion,
      inputHash: inputHash,
      vector: vector,
    );

    return vector;
  }
}
