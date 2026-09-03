import 'dart:typed_data';
import 'dart:math' as math;
import 'text_embedder.dart';

final class FakeTextEmbedder implements TextEmbedder {
  @override
  final String modelVersion;

  @override
  final int embeddingSize;

  FakeTextEmbedder({
    this.modelVersion = 'fake-model-v1',
    this.embeddingSize = 384,
  });

  @override
  Future<void> initialize() async {}

  @override
  Future<Float32List> embed(String text) async {
    if (text.trim().isEmpty) {
      throw ArgumentError.value(text, 'text', 'Text cannot be empty.');
    }

    final vector = Float32List(embeddingSize);

    for (var index = 0; index < text.length; index++) {
      final vectorIndex = index % embeddingSize;
      vector[vectorIndex] += text.codeUnitAt(index).toDouble();
    }

    return _normalize(vector);
  }

  @override
  Future<List<Float32List>> embedBatch(List<String> texts) async {
    final embeddings = <Float32List>[];

    for (final text in texts) {
      embeddings.add(await embed(text));
    }

    return embeddings;
  }

  Float32List _normalize(Float32List vector) {
    var squaredLength = 0.0;

    for (final value in vector) {
      squaredLength += value * value;
    }

    final length = math.sqrt(squaredLength);

    if (length == 0 || !length.isFinite) {
      throw StateError('Cannot normalize an invalid vector.');
    }

    return Float32List.fromList([for (final value in vector) value / length]);
  }

  @override
  Future<void> dispose() async {}
}
