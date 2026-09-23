import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/ai/transaction_classifier/'
    'embedding_text_builder.dart';

void main() {
  group('buildTransactionEmbeddingText', () {
    test('returns the trimmed short description', () {
      final result = buildTransactionEmbeddingText(
        shortDescription: '  UBER TRIP  ',
      );

      expect(result, 'UBER TRIP');
    });

    test('combines the short and long descriptions', () {
      final result = buildTransactionEmbeddingText(
        shortDescription: 'UBER TRIP',
        longDescription: 'HELP.UBER.COM',
      );

      expect(result, 'UBER TRIP\nHELP.UBER.COM');
    });

    test('returns the long description when short description is empty', () {
      final result = buildTransactionEmbeddingText(
        shortDescription: '',
        longDescription: 'MONTHLY ACCOUNT FEE',
      );

      expect(result, 'MONTHLY ACCOUNT FEE');
    });

    test('throws when both descriptions are empty', () {
      expect(
        () => buildTransactionEmbeddingText(
          shortDescription: '',
          longDescription: ' ',
        ),
        throwsArgumentError,
      );
    });
  });

  group('buildCategoryEmbeddingText', () {
    test('returns the trimmed category name', () {
      expect(buildCategoryEmbeddingText('  Transport  '), 'Transport');
    });

    test('throws when the category name is empty', () {
      expect(() => buildCategoryEmbeddingText(' '), throwsArgumentError);
    });
  });
}
