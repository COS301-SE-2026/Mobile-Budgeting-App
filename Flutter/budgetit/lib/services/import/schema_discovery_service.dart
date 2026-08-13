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
  String _fingerprint(String sourceType, List<CandidateRow> rows) {
    final markers = rows.map((r) => r.signMarker ?? '∅').toSet().toList()
      ..sort();
    final key = '$sourceType|${markers.join(",")}|rows:${rows.length.clamp(0, 50)}';
    return sha256.convert(utf8.encode(key)).toString().substring(0, 16);
  }


  bool _isConsistent(StatementSchema schema, List<CandidateRow> rows) {
    if (rows.length < 3) return true;

    final resolved = rows.map((r) => resolveIsIncome(r, schema)).toList();
    final allSame = resolved.every((v) => v == resolved.first);
    return !allSame;
  }
}

bool resolveIsIncome(CandidateRow row, StatementSchema schema) {
  final marker = row.signMarker?.toUpperCase();

  switch (schema.signConvention) {
    case SignConvention.crSuffixMeansIncome:
      return marker == 'CR';
    case SignConvention.minusPrefixMeansExpense:
      return marker != '-';
    case SignConvention.separateDebitCredit:
      return marker == 'CREDIT' || marker == 'CR' || marker == 'IN';
    case SignConvention.signedAmount:
      return marker != '-';
    case SignConvention.keywordBased:
      const incomeKeywords = [
        'eft', 'salary', 'payroll', 'wages', 'transfer in',
        'payback', 'interest earned', 'refund', 'credit',
        'deposit', 'reversal', 'payshap credit',
      ];
      final descLower = row.description.toLowerCase();
      return incomeKeywords.any((k) => descLower.contains(k));
  }
}