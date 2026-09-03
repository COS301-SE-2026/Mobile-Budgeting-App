import 'package:budgetit/models/import/parsed_transaction.dart';
import 'package:budgetit/services/import/schema_discovery_service.dart';

abstract interface class StatementParserServiceContract {
  Future<List<ParsedTransaction>> parse(
    String path, {
    SchemaConfirmationCallback? onNeedsSchemaConfirmation,
  });
}
