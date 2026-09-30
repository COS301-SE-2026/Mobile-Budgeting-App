import 'package:budgetit/models/import/parsed_transaction.dart';
import 'package:budgetit/services/import/schema_discovery_service.dart';

/// Reads a bank statement file into structured transactions.
///
/// Accepts CSV and PDF. PDFs are parsed by position rather than flattened
/// text: word coordinates are recovered from the page, a labelled header row
/// is located, and each value is read from the column it occupies. Statements
/// with separate debit and credit columns take their sign from the column;
/// statements with one amount column take it from the token itself, whether
/// that is a trailing minus, a leading minus or a 'Cr'/'Dr' suffix. A PDF
/// whose layout is not recognised falls back to text-based parsing.
///
/// {@category Import}
abstract interface class StatementParserServiceContract {
  /// Parses the statement at [path] and returns the transactions found.
  ///
  /// The format is chosen from the file extension, case-insensitively.
  ///
  /// Throws an [UnsupportedError] if the extension is neither '.csv' nor
  /// '.pdf', a [FormatException] if the file cannot be read as a statement,
  /// and an [ImportCancelledException] if the user dismisses the schema
  /// confirmation prompt.
  ///
  ///  [onNeedsSchemaConfirmation] : invoked when the sign convention cannot
  ///  be determined from the file alone and the user must confirm it. When
  ///  omitted, a best guess is used without prompting.
  Future<List<ParsedTransaction>> parse(
    String path, {
    SchemaConfirmationCallback? onNeedsSchemaConfirmation,
  });
}
