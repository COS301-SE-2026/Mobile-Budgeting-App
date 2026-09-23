import 'dart:typed_data';

final class CategoryEmbedding {
  final String categoryId;
  final String categoryName;
  final Float32List vector;

  const CategoryEmbedding({
    required this.categoryId,
    required this.categoryName,
    required this.vector,
  });
}

final class CategoryScore {
  final String categoryId;
  final String categoryName;
  final double similarity;

  const CategoryScore({
    required this.categoryId,
    required this.categoryName,
    required this.similarity,
  });
}
