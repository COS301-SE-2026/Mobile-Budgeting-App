import '../../models/import/candidate_row.dart';
import '../../models/import/statement_schema.dart';
import 'schema_discovery_service.dart';

class StubSchemaClassifier implements SchemaClassifier {
  @override
  Future<StatementSchema> classify(List<CandidateRow> sampleRows) async {
    final deterministic = classifyDeterministic(sampleRows);
    if(deterministic != null) return deterministic;
  /*  final markers = sampleRows.map((r) => r.signMarker?.toUpperCase()).where((m) => m != null).toSet();

    if (markers.contains('CREDIT') || markers.contains('DEBIT')) {
      return const StatementSchema(
        signConvention: SignConvention.separateDebitCredit,
      );
    }
    if (markers.contains('DEBIT') && !markers.contains('CREDIT')) {
      return const StatementSchema(
        signConvention: SignConvention.explicitDebitMeansExpense,
      );
    }

    if (markers.contains('CR') && !markers.contains('-')) {
      return const StatementSchema(
        signConvention: SignConvention.crSuffixMeansIncome,
      );
    }

    if (markers.contains('-') && !markers.contains('CR')) {
      return const StatementSchema(
        signConvention: SignConvention.minusPrefixMeansExpense,
      );
    }*/ //yah neh

    return const StatementSchema(signConvention: SignConvention.keywordBased);
  }
}