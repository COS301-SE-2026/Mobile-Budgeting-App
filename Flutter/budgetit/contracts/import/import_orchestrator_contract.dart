import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/models/import/import_result.dart';
import 'package:budgetit/models/import/parsed_transaction.dart';

abstract interface class ImportOrchestratorContract {
  Future<List<ParsedTransaction>> preparePreview(String filePath);
  Future<List<Category>> getAvailableCategories();
  Future<ImportResult> commitImport(
    List<ParsedTransaction> transactions, {
    bool forceAll = false,
  });
}
