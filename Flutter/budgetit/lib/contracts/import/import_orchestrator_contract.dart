import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/models/import/import_result.dart';
import 'package:budgetit/models/import/parsed_transaction.dart';
import 'package:budgetit/services/import/schema_discovery_service.dart';

/// Drives a statement import from file to saved transactions.
///
/// Sequences parsing, keyword classification, optional AI classification and
/// duplicate detection into a preview the user can review, then commits the
/// rows they accept. Nothing is written to the database until
/// [commitImport] is called.
///
/// {@category Import}
abstract interface class ImportOrchestratorContract {
  /// Parses, classifies and duplicate-checks the statement at [filePath],
  /// returning the transactions for review.
  ///
  /// The returned objects carry a suggested category and a duplicate flag,
  /// and are the same instances passed back to [commitImport], so any edits
  /// the user makes to them are preserved.
  ///
  /// Returns an empty list when the file holds no transactions. Propagates
  /// the parser's errors, including [ImportCancelledException] if the user
  /// dismisses the schema prompt.
  ///
  ///  [onNeedsSchemaConfirmation] : forwarded to the parser when the sign
  ///  convention needs confirming
  Future<List<ParsedTransaction>> preparePreview(
    String filePath, {
    SchemaConfirmationCallback? onNeedsSchemaConfirmation,
  });

  /// Returns the categories available for assignment in the preview UI.
  Future<List<Category>> getAvailableCategories();

  /// Writes [transactions] to the database and reports what happened.
  ///
  /// Rows flagged as duplicates are skipped and counted unless [forceAll] is
  /// 'true'. Each row is inserted independently, so one failure does not
  /// abort the rest: failures are counted and recorded against the
  /// transaction's description in the returned [ImportResult].
  ///
  /// Any category on a transaction is assigned in the same step, marked as
  /// manual when the user overrode it and as AI otherwise.
  Future<ImportResult> commitImport(
    List<ParsedTransaction> transactions, {
    bool forceAll = false,
  });
}
