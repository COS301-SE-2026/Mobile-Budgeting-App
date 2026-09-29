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

typedef SchemaConfirmationCallback = Future<StatementSchema> Function(
  StatementSchema proposed, //classifiers response
  List<CandidateRow> sampleRows, //rows to show user -> for confirmation
);

StatementSchema? classifyDeterministic(List<CandidateRow> sampleRows) {
  final markers = sampleRows.map((r) => r.signMarker?.toUpperCase()).whereType<String>().toSet();
  final hasCredit = markers.contains('CREDIT');
  final hasDebit = markers.contains("DEBIT");

  if(hasCredit && hasDebit) {
    return const StatementSchema(signConvention: SignConvention.separateDebitCredit);
  }
  if (hasDebit && !hasCredit) {
    return const StatementSchema(signConvention: SignConvention.explicitDebitMeansExpense);
  }
  final hasCr = markers.contains('CR');
  final hasMinus = markers.contains('-');
  if (hasCr && !hasMinus) {
    return const StatementSchema(signConvention: SignConvention.crSuffixMeansIncome);
  }
  if (hasMinus && !hasCr) {
    return const StatementSchema(signConvention: SignConvention.minusPrefixMeansExpense);
  }
  return null;
}

class ImportCancelledException implements Exception {
  const ImportCancelledException();
}


class SchemaDiscoveryService {
  final SchemaClassifier _classifier;
  final SchemaCacheStore _cache;

  SchemaDiscoveryService({
    required SchemaClassifier classifier,
    SchemaCacheStore? cache,
  })  : _classifier = classifier,
        _cache = cache ?? InMemorySchemaCacheStore();

  static const int _schemaVersion = 3;

  Future<StatementSchema> discover({
    required String sourceType,
    required List<CandidateRow> sampleRows,
    SchemaConfirmationCallback? onNeedsConfirmation,
  }) async {
    if (sampleRows.isEmpty) {
      return const StatementSchema(signConvention: SignConvention.keywordBased);
    }

    final fingerprint = _fingerprint(sourceType, sampleRows);
    final cached = await _cache.get(fingerprint);
    if (cached != null) return cached;
    final sample = sampleRows.length > 20 ? sampleRows.sublist(0, 20) : sampleRows;


    final deterministic = classifyDeterministic(sample);
    final needsConfirmation = deterministic == null;
    var schema = deterministic ?? await _classifier.classify(sample);

    if( needsConfirmation && onNeedsConfirmation != null) {
      final previewRows = sample.length > 3 ? sample.sublist(0,3) : sample;
      schema = await onNeedsConfirmation(schema, previewRows);
    }


    //final schema = await _classifier.classify(sample);
    if (_isConsistent(schema, sampleRows)) {
      await _cache.put(fingerprint, schema);
    }

    return schema;
  }
  //static const int _schemaVersion = 2;

  Future<StatementSchema?> peekCached({
    required String sourceType,
    required List<CandidateRow> sampleRows,
  }) async {
    if (sampleRows.isEmpty) return null;
    final fingerprint = _fingerprint(sourceType, sampleRows);
    return _cache.get(fingerprint);
  }

  String _fingerprint(String sourceType, List<CandidateRow> rows) {
    final markers = rows.map((r) => r.signMarker ?? '∅').toSet().toList()
      ..sort();
    //final key = '$sourceType|${markers.join(",")}|rows:${rows.length.clamp(0, 50)}';
    final key = 'v$_schemaVersion|$sourceType|${markers.join(",")}'; //removed |rows:${rows.length.clamp(0,50)} ambiguous
    return sha256.convert(utf8.encode(key)).toString().substring(0, 16);
  }


  bool _isConsistent(StatementSchema schema, List<CandidateRow> rows) {

    final resolvedByMarker = <String, bool>{};
    for(final row in rows){
      final markerKey = row.signMarker?.toUpperCase() ?? '0';
      resolvedByMarker.putIfAbsent(markerKey, () => resolveIsIncome(row,schema));
    }
    if(resolvedByMarker.length < 2) return true;
    return resolvedByMarker.values.toSet().length > 1;
    /*if (rows.length < 3) return true;

    final resolved = rows.map((r) => resolveIsIncome(r, schema)).toList();
    final allSame = resolved.every((v) => v == resolved.first);
    return !allSame;*/
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
    case SignConvention.explicitDebitMeansExpense:
      return marker != 'DEBIT';
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