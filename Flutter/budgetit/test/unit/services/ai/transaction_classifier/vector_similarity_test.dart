import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'category_score.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'vector_similarity.dart';

void main() {
  group('l2Normalize', () {
    test('returns a vector with a length close to one', () {
      final result = l2Normalize(Float32List.fromList([3, 4]));

      final lengthSquared = result.fold<double>(
        0,
        (total, value) => total + value * value,
      );

      expect(lengthSquared, closeTo(1, 0.0001));
    });

    test('throws for a zero vector', () {
      expect(() => l2Normalize(Float32List.fromList([0, 0])), throwsStateError);
    });
  });

  group('dotProduct', () {
    test('calculates the dot product', () {
      final result = dotProduct(
        Float32List.fromList([1, 2, 3]),
        Float32List.fromList([4, 5, 6]),
      );

      expect(result, 32);
    });

    test('throws when the dimensions differ', () {
      expect(
        () => dotProduct(
          Float32List.fromList([1, 2]),
          Float32List.fromList([1, 2, 3]),
        ),
        throwsArgumentError,
      );
    });
  });

  group('rankCategories', () {
    test('places the most similar category first', () {
      final transaction = Float32List.fromList([1, 0]);

      final categories = [
        CategoryEmbedding(
          categoryId: 'food',
          categoryName: 'Food',
          vector: Float32List.fromList([0, 1]),
        ),
        CategoryEmbedding(
          categoryId: 'transport',
          categoryName: 'Transport',
          vector: Float32List.fromList([0.9, 0.1]),
        ),
      ];

      final result = rankCategories(
        transactionVector: transaction,
        categories: categories,
      );

      expect(result.first.categoryId, 'transport');
      expect(result.first.similarity, greaterThan(result.last.similarity));
    });
  });
}
