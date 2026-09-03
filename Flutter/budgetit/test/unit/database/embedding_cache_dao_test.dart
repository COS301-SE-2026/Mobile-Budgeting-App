import 'dart:typed_data';

import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/embedding_cache_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late EmbeddingCacheDao dao;

  setUp(() {
    db = openTestDatabase();
    dao = db.embeddingCacheDao;
  });

  tearDown(() => db.close());

  group('EmbeddingCacheDao.getEmbedding', () {
    test('returns null when no cached embedding exists', () async {
      final result = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
      );

      expect(result, isNull);
    });

    test('returns a saved Float32 embedding', () async {
      final vector = Float32List.fromList([0.25, -0.5, 0.75]);

      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
        vector: vector,
      );

      final result = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
      );

      expect(result, isNotNull);
      expect(result, hasLength(3));
      expect(result![0], closeTo(0.25, 0.000001));
      expect(result[1], closeTo(-0.5, 0.000001));
      expect(result[2], closeTo(0.75, 0.000001));
    });

    test('does not return a vector from another model version', () async {
      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([1, 0]),
      );

      final result = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'fine-tuned-v1',
        inputHash: 'hash-1',
      );

      expect(result, isNull);
    });

    test('does not return a vector for different input text', () async {
      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.category,
        sourceId: 'category-1',
        modelVersion: 'base-v1',
        inputHash: 'old-name-hash',
        vector: Float32List.fromList([0, 1]),
      );

      final result = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.category,
        sourceId: 'category-1',
        modelVersion: 'base-v1',
        inputHash: 'new-name-hash',
      );

      expect(result, isNull);
    });
  });

  group('EmbeddingCacheDao.saveEmbedding', () {
    test('replaces an existing matching cache entry', () async {
      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([1, 0]),
      );

      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([0, 1]),
      );

      final result = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
      );

      expect(result, isNotNull);
      expect(result![0], closeTo(0, 0.000001));
      expect(result[1], closeTo(1, 0.000001));
    });

    test('rejects an empty embedding', () {
      expect(
        () => dao.saveEmbedding(
          sourceType: EmbeddingSourceType.transaction,
          sourceId: 'transaction-1',
          modelVersion: 'base-v1',
          inputHash: 'hash-1',
          vector: Float32List(0),
        ),
        throwsArgumentError,
      );
    });
  });

  group('EmbeddingCacheDao deletion', () {
    test('deletes all embeddings belonging to a source', () async {
      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.category,
        sourceId: 'category-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([1, 0]),
      );

      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.category,
        sourceId: 'category-1',
        modelVersion: 'fine-tuned-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([0, 1]),
      );

      final deleted = await dao.deleteForSource(
        sourceType: EmbeddingSourceType.category,
        sourceId: 'category-1',
      );

      expect(deleted, 2);

      final result = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.category,
        sourceId: 'category-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
      );

      expect(result, isNull);
    });

    test('deletes old models but retains the current model', () async {
      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([1, 0]),
      );

      await dao.saveEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'fine-tuned-v1',
        inputHash: 'hash-1',
        vector: Float32List.fromList([0, 1]),
      );

      await dao.deleteOtherModelVersions('fine-tuned-v1');

      final oldVector = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'base-v1',
        inputHash: 'hash-1',
      );

      final currentVector = await dao.getEmbedding(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        modelVersion: 'fine-tuned-v1',
        inputHash: 'hash-1',
      );

      expect(oldVector, isNull);
      expect(currentVector, isNotNull);
    });
  });
}
