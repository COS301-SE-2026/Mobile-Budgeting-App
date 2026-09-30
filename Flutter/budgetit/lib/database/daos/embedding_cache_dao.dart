import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../schema.dart';

part 'embedding_cache_dao.g.dart';

@DriftAccessor(tables: [EmbeddingCacheEntries])
class EmbeddingCacheDao extends DatabaseAccessor<AppDatabase>
    with _$EmbeddingCacheDaoMixin {
  final Uuid _uuid = const Uuid();

  EmbeddingCacheDao(super.db);

  Future<Float32List?> getEmbedding({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String modelVersion,
    required String inputHash,
  }) async {
    final query = select(embeddingCacheEntries)
      ..where(
        (entry) =>
            entry.sourceType.equalsValue(sourceType) &
            entry.sourceId.equals(sourceId) &
            entry.modelVersion.equals(modelVersion) &
            entry.inputHash.equals(inputHash),
      );

    final entry = await query.getSingleOrNull();

    if (entry == null) {
      return null;
    }

    return _bytesToFloat32List(entry.embedding);
  }

  Future<void> saveEmbedding({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String modelVersion,
    required String inputHash,
    required Float32List vector,
  }) async {
    if (vector.isEmpty) {
      throw ArgumentError('The embedding cannot be empty.');
    }

    await transaction(() async {
      await (delete(embeddingCacheEntries)..where(
            (entry) =>
                entry.sourceType.equalsValue(sourceType) &
                entry.sourceId.equals(sourceId) &
                entry.modelVersion.equals(modelVersion) &
                entry.inputHash.equals(inputHash),
          ))
          .go();

      await into(embeddingCacheEntries).insert(
        EmbeddingCacheEntriesCompanion.insert(
          id: _uuid.v4(),
          sourceType: sourceType,
          sourceId: sourceId,
          modelVersion: modelVersion,
          inputHash: inputHash,
          embedding: _float32ListToBytes(vector),
          createdAt: DateTime.now().toUtc(),
        ),
      );
    });
  }

  Future<int> deleteForSource({
    required EmbeddingSourceType sourceType,
    required String sourceId,
  }) {
    return (delete(embeddingCacheEntries)..where(
          (entry) =>
              entry.sourceType.equalsValue(sourceType) &
              entry.sourceId.equals(sourceId),
        ))
        .go();
  }

  Future<int> deleteForModel(String modelVersion) {
    return (delete(
      embeddingCacheEntries,
    )..where((entry) => entry.modelVersion.equals(modelVersion))).go();
  }

  Future<int> deleteOtherModelVersions(String currentModelVersion) {
    return (delete(embeddingCacheEntries)..where(
          (entry) => entry.modelVersion.equals(currentModelVersion).not(),
        ))
        .go();
  }

  Uint8List _float32ListToBytes(Float32List vector) {
    final data = ByteData(vector.length * Float32List.bytesPerElement);

    for (var index = 0; index < vector.length; index++) {
      data.setFloat32(
        index * Float32List.bytesPerElement,
        vector[index],
        Endian.little,
      );
    }

    return data.buffer.asUint8List();
  }

  Float32List _bytesToFloat32List(Uint8List bytes) {
    if (bytes.lengthInBytes % Float32List.bytesPerElement != 0) {
      throw StateError('The cached embedding contains invalid binary data.');
    }

    final data = ByteData.sublistView(bytes);
    final numberOfValues = bytes.lengthInBytes ~/ Float32List.bytesPerElement;

    return Float32List.fromList([
      for (var index = 0; index < numberOfValues; index++)
        data.getFloat32(index * Float32List.bytesPerElement, Endian.little),
    ]);
  }
}
