import 'dart:typed_data';

import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'embedding_cache_service.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'text_embedder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../database/helpers.dart';

final class CountingTextEmbedder implements TextEmbedder {
  @override
  final String modelVersion;

  int embedCallCount = 0;

  CountingTextEmbedder({required this.modelVersion});

  @override
  int get embeddingSize => 2;

  @override
  Future<void> initialize() async {}

  @override
  Future<Float32List> embed(String text) async {
    embedCallCount++;

    return Float32List.fromList([
      text.length.toDouble(),
      modelVersion.length.toDouble(),
    ]);
  }

  @override
  Future<List<Float32List>> embedBatch(List<String> texts) {
    return Future.wait(texts.map(embed));
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late CountingTextEmbedder embedder;
  late EmbeddingCacheService service;

  setUp(() {
    db = openTestDatabase();
    embedder = CountingTextEmbedder(modelVersion: 'test-model-v1');
    service = EmbeddingCacheService(
      embedder: embedder,
      cacheDao: db.embeddingCacheDao,
    );
  });

  tearDown(() => db.close());

  test('generates and saves an embedding on a cache miss', () async {
    final result = await service.getOrCreate(
      sourceType: EmbeddingSourceType.transaction,
      sourceId: 'transaction-1',
      text: 'UBER TRIP',
    );

    expect(embedder.embedCallCount, 1);
    expect(result, hasLength(2));
  });

  test('reuses a cached embedding without invoking the model again', () async {
    final first = await service.getOrCreate(
      sourceType: EmbeddingSourceType.category,
      sourceId: 'category-transport',
      text: 'Transport',
    );

    final second = await service.getOrCreate(
      sourceType: EmbeddingSourceType.category,
      sourceId: 'category-transport',
      text: 'Transport',
    );

    expect(embedder.embedCallCount, 1);
    expect(second, orderedEquals(first));
  });

  test('generates a new embedding when the input text changes', () async {
    await service.getOrCreate(
      sourceType: EmbeddingSourceType.category,
      sourceId: 'category-1',
      text: 'Transport',
    );

    await service.getOrCreate(
      sourceType: EmbeddingSourceType.category,
      sourceId: 'category-1',
      text: 'Public transport and taxi',
    );

    expect(embedder.embedCallCount, 2);
  });

  test(
    'does not reuse an embedding created by another model version',
    () async {
      await service.getOrCreate(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        text: 'UBER TRIP',
      );

      final newerEmbedder = CountingTextEmbedder(
        modelVersion: 'fine-tuned-model-v1',
      );

      final newerService = EmbeddingCacheService(
        embedder: newerEmbedder,
        cacheDao: db.embeddingCacheDao,
      );

      await newerService.getOrCreate(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: 'transaction-1',
        text: 'UBER TRIP',
      );

      expect(embedder.embedCallCount, 1);
      expect(newerEmbedder.embedCallCount, 1);
    },
  );

  test('rejects an empty source ID', () {
    expect(
      () => service.getOrCreate(
        sourceType: EmbeddingSourceType.transaction,
        sourceId: ' ',
        text: 'UBER TRIP',
      ),
      throwsArgumentError,
    );
  });
}
