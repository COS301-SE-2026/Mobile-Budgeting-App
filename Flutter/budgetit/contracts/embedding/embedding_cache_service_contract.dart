// A named contract is intentional even when the service currently
// has one operation.
// ignore_for_file: one_member_abstracts

import 'dart:typed_data';

import 'package:budgetit/database/schema.dart';

abstract interface class EmbeddingCacheServiceContract {
  Future<Float32List> getOrCreate({
    required EmbeddingSourceType sourceType,
    required String sourceId,
    required String text,
  });
}
