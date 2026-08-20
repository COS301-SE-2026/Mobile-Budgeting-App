import 'category_score.dart';
import 'embedding_text_builder.dart';
import 'text_embedder.dart';
import 'vector_similarity.dart';

final class ClassificationCategory {
  final String id;
  final String name;

  const ClassificationCategory({required this.id, required this.name});
}

final class TransactionClassificationResult {
  final String modelVersion;
  final List<CategoryScore> rankedCategories;

  const TransactionClassificationResult({
    required this.modelVersion,
    required this.rankedCategories,
  });

  CategoryScore? get bestMatch {
    if (rankedCategories.isEmpty) {
      return null;
    }

    return rankedCategories.first;
  }
}

final class TransactionClassificationService {
  final TextEmbedder embedder;

  TransactionClassificationService({required this.embedder});

  Future<void> initialize() {
    return embedder.initialize();
  }

  Future<TransactionClassificationResult> classify({
    required String shortDescription,
    String? longDescription,
    required List<ClassificationCategory> categories,
  }) async {
    final transactionText = buildTransactionEmbeddingText(
      shortDescription: shortDescription,
      longDescription: longDescription,
    );

    if (categories.isEmpty) {
      return TransactionClassificationResult(
        modelVersion: embedder.modelVersion,
        rankedCategories: const [],
      );
    }

    final transactionVector = await embedder.embed(transactionText);

    final categoryTexts = [
      for (final category in categories)
        buildCategoryEmbeddingText(category.name),
    ];

    final categoryVectors = await embedder.embedBatch(categoryTexts);

    if (categoryVectors.length != categories.length) {
      throw StateError(
        'The model returned ${categoryVectors.length} category embeddings '
        'for ${categories.length} categories.',
      );
    }

    final categoryEmbeddings = [
      for (var index = 0; index < categories.length; index++)
        CategoryEmbedding(
          categoryId: categories[index].id,
          categoryName: categories[index].name,
          vector: categoryVectors[index],
        ),
    ];

    final rankedCategories = rankCategories(
      transactionVector: transactionVector,
      categories: categoryEmbeddings,
    );

    return TransactionClassificationResult(
      modelVersion: embedder.modelVersion,
      rankedCategories: rankedCategories,
    );
  }

  Future<void> dispose() {
    return embedder.dispose();
  }
}
