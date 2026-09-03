import 'dart:typed_data';

abstract interface class TextEmbedder {
  String get modelVersion;

  int get embeddingSize;

  Future<void> initialize();

  Future<Float32List> embed(String text);

  Future<List<Float32List>> embedBatch(List<String> texts);

  Future<void> dispose();
}
