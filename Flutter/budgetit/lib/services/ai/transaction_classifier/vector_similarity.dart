import 'dart:math' as math;
import 'dart:typed_data';

import 'category_score.dart';

Float32List l2Normalize(Float32List vector) {
  var squaredLength = 0.0;

  for (final value in vector) {
    squaredLength += value * value;
  }

  final length = math.sqrt(squaredLength);

  if (length == 0 || !length.isFinite) {
    throw StateError('Cannot normalize an invalid embedding.');
  }

  return Float32List.fromList([for (final value in vector) value / length]);
}

double dotProduct(Float32List left, Float32List right) {
  if (left.length != right.length) {
    throw ArgumentError(
      'Embedding dimensions do not match: '
      '${left.length} and ${right.length}.',
    );
  }

  var total = 0.0;

  for (var index = 0; index < left.length; index++) {
    total += left[index] * right[index];
  }

  return total;
}

List<CategoryScore> rankCategories({
  required Float32List transactionVector,
  required List<CategoryEmbedding> categories,
}) {
  final scores = [
    for (final category in categories)
      CategoryScore(
        categoryId: category.categoryId,
        categoryName: category.categoryName,
        similarity: dotProduct(transactionVector, category.vector),
      ),
  ];

  scores.sort((left, right) => right.similarity.compareTo(left.similarity));

  return scores;
}
