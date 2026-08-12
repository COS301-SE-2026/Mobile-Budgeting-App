import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../models/import/candidate_row.dart';
import '../../models/import/statement_schema.dart';

abstract class SchemaClassifier {
  Future<StatementSchema> classify(List<CandidateRow> sampleRows);
}

abstract class SchemaCacheStore {
  Future<StatementSchema?> get(String fingerprint);
  Future<void> put(String fingerprint, StatementSchema schema);
}

class InMemorySchemaCacheStore implements SchemaCacheStore {
  final Map<String, StatementSchema> _store = {};

  @override
  Future<StatementSchema?> get(String fingerprint) async => _store[fingerprint];

  @override
  Future<void> put(String fingerprint, StatementSchema schema) async {
    _store[fingerprint] = schema;
  }
}

class SchemaDiscoveryService {
  final SchemaClassifier _classifier;
  final SchemaCacheStore _cache;

  SchemaDiscoveryService({
    required SchemaClassifier classifier,
    SchemaCacheStore? cache,
  })  : _classifier = classifier,
        _cache = cache ?? InMemorySchemaCacheStore();

  Future<StatementSchema> discover({
    required String sourceType,
    required List<CandidateRow> sampleRows,
  }) async {
    if (sampleRows.isEmpty) {
      return const StatementSchema(signConvention: SignConvention.keywordBased);
    }

    final fingerprint = _fingerprint(sourceType, sampleRows);
    final cached = await _cache.get(fingerprint);
    if (cached != null) return cached;
    final sample = sampleRows.length > 20 ? sampleRows.sublist(0, 20) : sampleRows;
    final schema = await _classifier.classify(sample);
    if (_isConsistent(schema, sampleRows)) {
      await _cache.put(fingerprint, schema);
    }

    return schema;
  }


}