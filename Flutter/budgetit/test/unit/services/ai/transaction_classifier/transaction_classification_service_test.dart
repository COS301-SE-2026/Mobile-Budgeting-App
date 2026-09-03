import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'text_embedder.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'transaction_classification_service.dart';

final class TestTextEmbedder implements TextEmbedder {
  @override
  String get modelVersion => 'test-model-v1';

  @override
  int get embeddingSize => 2;

  @override
  Future<void> initialize() async {}

  @override
  Future<Float32List> embed(String text) async {
    if (text.contains('UBER')) {
      return Float32List.fromList([1, 0]);
    }

    if (text == 'Transport') {
      return Float32List.fromList([0.9, 0.1]);
    }

    if (text == 'Groceries') {
      return Float32List.fromList([0, 1]);
    }

    return Float32List.fromList([0.5, 0.5]);
  }

  @override
  Future<List<Float32List>> embedBatch(List<String> texts) async {
    return Future.wait(texts.map(embed));
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  late TransactionClassificationService service;

  setUp(() {
    service = TransactionClassificationService(embedder: TestTextEmbedder());
  });

  test('ranks the most similar category first', () async {
    final result = await service.classify(
      shortDescription: 'UBER TRIP',
      categories: const [
        ClassificationCategory(id: 'groceries', name: 'Groceries'),
        ClassificationCategory(id: 'transport', name: 'Transport'),
      ],
    );

    expect(result.modelVersion, 'test-model-v1');
    expect(result.rankedCategories, hasLength(2));
    expect(result.bestMatch?.categoryId, 'transport');
  });

  test('returns an empty ranking when there are no categories', () async {
    final result = await service.classify(
      shortDescription: 'UBER TRIP',
      categories: const [],
    );

    expect(result.rankedCategories, isEmpty);
    expect(result.bestMatch, isNull);
  });

  test('throws when the transaction descriptions are empty', () {
    expect(
      () => service.classify(
        shortDescription: ' ',
        longDescription: ' ',
        categories: const [
          ClassificationCategory(id: 'transport', name: 'Transport'),
        ],
      ),
      throwsArgumentError,
    );
  });
}
