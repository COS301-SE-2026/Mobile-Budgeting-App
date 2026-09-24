import 'package:budgetit/models/import/candidate_row.dart';
import 'package:budgetit/models/import/statement_schema.dart';
import 'package:budgetit/services/import/schema_discovery_service.dart';

/// Determines how a statement encodes the direction of a transaction.
///
/// Banks disagree on whether a credit is a 'Cr' suffix, a missing minus sign
/// or a separate column. This service infers the convention from sample rows,
/// asking the user only when inference fails, and caches the answer against a
/// fingerprint of the statement's shape so the same format is not queried
/// twice.
///
/// {@category Import}
abstract interface class SchemaDiscoveryServiceContract {
  /// Returns the schema for the statement represented by [sampleRows].
  ///
  /// Resolution order: the cache, then deterministic inference from the sign
  /// markers present, then [onNeedsConfirmation]. A schema that classifies
  /// the sample consistently is written back to the cache.
  ///
  /// Always returns a schema. It falls back to keyword-based classification
  /// rather than failing.
  ///
  ///  [sourceType] : 'csv' or 'pdf', part of the cache fingerprint
  ///  [sampleRows] : rows to infer from; at most the first 20 are examined
  ///  [onNeedsConfirmation] : asked to confirm when inference is
  ///  inconclusive; may throw an [ImportCancelledException] if the user
  ///  backs out
  Future<StatementSchema> discover({
    required String sourceType,
    required List<CandidateRow> sampleRows,
    SchemaConfirmationCallback? onNeedsConfirmation,
  });

  /// Returns the cached schema for these rows, or 'null' if none is cached.
  ///
  /// Never infers, never prompts and never writes to the cache. Use it to
  /// apply a previously learned schema's skip patterns before the full
  /// [discover] call.
  Future<StatementSchema?> peekCached({
    required String sourceType,
    required List<CandidateRow> sampleRows,
  });
}
