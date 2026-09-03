import 'package:budgetit/models/import/candidate_row.dart';
import 'package:budgetit/models/import/statement_schema.dart';
import 'package:budgetit/services/import/schema_discovery_service.dart';

abstract interface class SchemaDiscoveryServiceContract {
  Future<StatementSchema?> discover({
    required String sourceType,
    required List<CandidateRow> sampleRows,
    SchemaConfirmationCallback? onNeedsConfirmation,
  });

  Future<StatementSchema?> peekCached({
    required String sourceType,
    required List<CandidateRow> sampleRows,
  });
}
