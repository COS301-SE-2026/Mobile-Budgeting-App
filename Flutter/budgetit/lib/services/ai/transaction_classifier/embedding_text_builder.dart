String buildTransactionEmbeddingText({
  required String shortDescription,
  String? longDescription,
}) {
  final shortText = shortDescription.trim();
  final longText = (longDescription ?? '').trim();

  if (shortText.isEmpty && longText.isEmpty) {
    throw ArgumentError('A transaction must have a short or long description.');
  }

  if (shortText.isEmpty) {
    return longText;
  }

  if (longText.isEmpty) {
    return shortText;
  }

  return '$shortText\n$longText';
}

String buildCategoryEmbeddingText(String categoryName) {
  final text = categoryName.trim();

  if (text.isEmpty) {
    throw ArgumentError('The category name cannot be empty.');
  }

  return text;
}
